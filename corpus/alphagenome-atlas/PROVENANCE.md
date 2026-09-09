# AlphaGenome Atlas — the two public artifacts this study measures

Study 44 measures a **container**, not a model. It needs exactly two things, both public,
neither requiring an account, an API key or accepting any terms.

## 1. `atlas_service.proto`

The service definition for `AtlasService`, fetched 2026-09-09 from

    https://raw.githubusercontent.com/google-deepmind/alphagenome/main/src/alphagenome/protos/atlas_service.proto

Licensed **Apache-2.0** by Google DeepMind, as stated in that repository. It is quoted here
under that licence and is shipped verbatim so the sentence this study turns on can be read in
its own file rather than taken from us.

The sentence, at line 76-77, a comment on field 4 of `message DenseVariantScore`:

```
  // N-d array of scores, in row-major order. Values are stored as single
  // precision floats.
  bytes scores = 4;
```

## 2. The announced row count

"9 billion single-nucleotide variants", from Google DeepMind's own announcement of
AlphaGenome Atlas, 2026-09-08. Carried as **REPORTED** — it is their published figure and we
did not count it.

**It is also re-derivable from a corpus already in this repository, which is why the study does
not rest on their press release.** `corpus/crispr-clinical/RUN-full-assembly-n32.txt` records
GRCh38 primary assembly as **3,099,750,718 bases over 194 sequences**, measured by our own
program over the bytes. Every base admits exactly three alternate letters, so the number of
possible single-nucleotide variants is

    3,099,750,718 x 3 = 9,299,252,154

which exceeds their announced 9 billion. The study reports both and uses the SMALLER of the two
wherever a larger count would make its own finding stronger.

## What is NOT here, and why

No Atlas prediction values. Not one. Their terms restrict outputs to non-commercial use and
forbid using them to train models; this study needs no output value to reach its result, and
takes none. The finding is a property of the container the values are shipped in, and the
container is described in a file they published under Apache-2.0.
