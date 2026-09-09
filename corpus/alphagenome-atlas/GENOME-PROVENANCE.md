# Study 45 Arm A — the genome inputs, regenerated not stored

The coding-consequence arm reads two large public files. They are **NOT stored in this
repository** — a genome assembly and its annotation are hundreds of megabytes each and are
public, frozen, versioned artifacts anyone can re-fetch. This file records exactly which ones,
with digests, so the run is reproducible without us hosting a copy.

## The two inputs

**GENCODE v50 comprehensive annotation (CDS + the `Ensembl_canonical` tag):**

    https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.annotation.gtf.gz
    sha256  83fba3e9b03f0b8c958f3595c6c350adc55f468abf8b0e47b6d5284cfe13a453
    124,527,720 bytes gzipped

**GRCh38 primary assembly (the reference bases):**

    https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/GRCh38.primary_assembly.genome.fa.gz
    sha256  b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca
    845,635,028 bytes gzipped, 3,151,417,447 decompressed — measured 2026-09-09

This is the same assembly our CRISPR studies screen against (3,099,750,718 bases over 194
sequences), which is why Study 44's genome figure and this arm's footprint are the same genome.

## Reproduce Arm A

```bash
# footprint (coding fraction) needs only the annotation:
gzip -dc gencode.v50.annotation.gtf.gz > /tmp/g.gtf
swiftc -O reproduce/coding-consequence-genome-exact.swift -o /tmp/genA
/tmp/genA /tmp/g.gtf

# consequence classes need the assembly too:
gzip -dc GRCh38.primary_assembly.genome.fa.gz > /tmp/g.fa
/tmp/genA /tmp/g.gtf /tmp/g.fa
rm -f /tmp/g.gtf /tmp/g.fa       # delete after ingestion — the genome is not stored
```

The code-intrinsic baseline — the genetic code enumerated, needing no download at all — is
`reproduce/codon-consequence-exact.swift`: 138 synonymous, 392 missense, 23 nonsense, 23
stop-lost of 576.

---

# Study 45 Arm B — the pulled Atlas scores, measured and not stored

Arm B measures the **real published dense scores**. Unlike every other arm on this page it
therefore needs an AlphaGenome API key and accepts Google DeepMind's terms of service. That
difference is stated on the study page rather than left for a reader to discover.

## What is fetched

`reproduce/atlas-dense-ingress.py` calls `ListDenseVariantScores` on
`dns:///gdmscience.googleapis.com:443` for every variant in a stated interval and writes the
**exact wire bytes** of each score array as hex, one JSON line per variant, closing with a meta
line recording the interval, how many variants it admits, and how many were written.

The endpoint returns **22 scorers** per variant, with vector widths from 1 to 35,245 values —
`ATAC`, `CAGE`, `CHIP_HISTONE`, `CHIP_TF`, `CONTACT_MAPS`, `DNASE`, `POLYADENYLATION`, `PROCAP`,
`RNA_SEQ`, `SPLICE_JUNCTIONS`, `SPLICE_SITES`, `SPLICE_SITE_USAGE`, their `_ACTIVE` companions,
and `AVI_SCORE` with its model-features and feature-importance vectors.

## What is NOT stored, and why

**The pulled artifact never enters this repository.** It is roughly 672 KB per variant, it
contains AlphaGenome prediction values including `AVI_SCORE`, and their terms restrict what may
be done with model outputs. Study 45 publishes **counts of values, never a value**: how many
distinct numbers the container spends, how many variants are handed a number another variant
already has, and where those sit. Every published figure is an integer produced by
`reproduce/atlas-collision-measure-exact.swift` over the bytes, in integer arithmetic.

The API key lives outside the repository, is read from a file, is never printed, and the ingress
destroys its own output if the key is ever found inside it.

## Reproduce Arm B (needs your own key)

```bash
python3 reproduce/atlas-dense-ingress.py chr11 5227000 5227200 atlas-dense.jsonl
swiftc -O reproduce/atlas-collision-measure-exact.swift -o /tmp/s45b
/tmp/s45b atlas-dense.jsonl
rm -f atlas-dense.jsonl        # the scores are not ours to keep
```

A pull that stops early writes no meta line, and the measurer refuses such a file rather than
reporting a rate over an unknown denominator. Given no artifact at all it prints its reference
figures and measures nothing.
