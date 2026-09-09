#!/usr/bin/env python3
"""STUDY 45, ARM B — ingress for the published AlphaGenome Atlas dense scores.

PURE FETCH. This file computes no verdict, no count and no rate. It calls the Atlas gRPC
endpoint for every variant in an interval and writes the EXACT wire bytes of each score
array to disk as hex. Every figure Study 45 publishes is produced by
atlas-collision-measure-exact.swift over those bytes, in integer arithmetic.

WHY THERE IS PYTHON HERE AND NOWHERE ELSE. The Atlas client library and its generated
protobuf stubs are published in Python by Google DeepMind. Speaking to their endpoint with
their own stubs is the shortest honest path to their bytes, and it keeps the fetch and the
measurement in different files so the fetch cannot influence a count. No cell runs this; it
is a study ingress on a workstation, and the law that grades its output is Swift.

TRUNCATION IS NOT A MEASUREMENT. The closing meta line is written only after the final page
arrives. A pull that dies mid-stream leaves a file with no meta line, and the Swift measurer
REFUSES such a file rather than reporting a collision rate over an unknown denominator.

THE KEY IS READ FROM A FILE, NEVER PRINTED, NEVER COMMITTED. The output is scanned for it
before the run is allowed to succeed, and the file is destroyed if it ever appears there.

  usage:  python3 atlas-dense-ingress.py <chrom> <start> <end> <out.jsonl>
"""
import os, sys, json, pathlib, struct
import grpc

KEY_PATH = pathlib.Path(os.path.expanduser("~/.config/affine-secrets/alphagenome"))
if not KEY_PATH.exists():
    sys.exit("no key file at ~/.config/affine-secrets/alphagenome")
KEY = KEY_PATH.read_text().strip()
if not KEY:
    sys.exit("key file is empty")

from alphagenome.protos import atlas_service_pb2 as ap
from alphagenome.protos import atlas_service_pb2_grpc as ag
from alphagenome.data import genome
from alphagenome.models import dna_model

chrom   = sys.argv[1] if len(sys.argv) > 1 else "chr11"
start   = int(sys.argv[2]) if len(sys.argv) > 2 else 5227000
end     = int(sys.argv[3]) if len(sys.argv) > 3 else 5227200
outpath = sys.argv[4] if len(sys.argv) > 4 else "atlas-dense.jsonl"

bases = max(0, end - start)
expected = bases * 3          # every base admits exactly three other letters

ADDRESS = "dns:///gdmscience.googleapis.com:443"
META    = [("x-goog-api-key", KEY)]
options = [("grpc.max_send_message_length", -1), ("grpc.max_receive_message_length", -1)]
channel = grpc.secure_channel(ADDRESS, grpc.ssl_channel_credentials(), options=options)
grpc.channel_ready_future(channel).result(30)
stub = ag.AtlasServiceStub(channel)

iv = genome.Interval(chromosome=chrom, start=start, end=end)
organism = dna_model.Organism.HOMO_SAPIENS.value

n_variants = 0
n_scorerows = 0
scorer_names = None
page_token = ""
complete = False

with open(outpath, "w") as fh:
    while True:
        req = ap.ListDenseVariantScoresRequest(
            interval=iv.to_proto(), organism=organism, page_size=1024, page_token=page_token
        )
        resp = stub.ListDenseVariantScores(req, metadata=META, timeout=300)
        for dvs in resp.variant_scores:
            v = dvs.variant
            row = {"chrom": v.chromosome, "pos": v.position,
                   "ref": v.reference_bases, "alt": v.alternate_bases, "scorers": []}
            for ds in dvs.scores:
                raw = ds.scores                      # bytes: single-precision floats
                row["scorers"].append({
                    "scorer": ds.variant_scorer.name,
                    "is_signed": ds.variant_scorer.is_signed,
                    "shape": list(ds.shape),
                    "n_bytes": len(raw),
                    "n_float32": len(raw) // 4,
                    "bytes_hex": raw.hex(),          # EXACT wire bytes; Swift does the counting
                })
                n_scorerows += 1
            fh.write(json.dumps(row) + "\n")
            n_variants += 1
            if scorer_names is None and row["scorers"]:
                scorer_names = [s["scorer"] for s in row["scorers"]]
        page_token = getattr(resp, "next_page_token", "")
        if not page_token:
            complete = True
            break
    # THE CLOSING LINE, WRITTEN LAST AND ONLY ON A COMPLETE STREAM.
    if complete:
        fh.write(json.dumps({"meta": {
            "chrom": chrom, "start": start, "end": end, "bases": bases,
            "variants_expected": expected, "variants_written": n_variants,
            "score_rows": n_scorerows, "scorers": scorer_names, "complete": True,
        }}) + "\n")

# KEY SAFETY: the run does not succeed until the output is proven free of the key.
data = pathlib.Path(outpath).read_text()
if KEY in data:
    os.remove(outpath)
    sys.exit("ABORT: key appeared in the output; file destroyed")

print(f"atlas dense ingress  {chrom}:{start}-{end}")
print(f"  variants the interval admits   {expected}")
print(f"  variants written               {n_variants}")
print(f"  score rows written             {n_scorerows}")
print(f"  scorers                        {scorer_names}")
print(f"  stream completed               {complete}")
print(f"  -> {outpath}")
if not complete:
    print("  NO META LINE WRITTEN — the stream did not finish; the measurer will refuse this file.")
