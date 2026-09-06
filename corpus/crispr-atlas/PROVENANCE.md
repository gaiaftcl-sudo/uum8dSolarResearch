# Corpus — the published guide sequences of the CRISPR medicines

Both guide spacers were fetched from **NCATS GSRS**, the US National Center for Advancing
Translational Sciences' public substance registry, at
`https://gsrs.ncats.nih.gov/api/v1/substances(<UNII>)?view=full`, and read from
`/nucleicAcid/subunits[*]/sequence`. Neither was taken from memory or from a paper.

## How the 20-base spacer was separated from the scaffold

A guide RNA registered in GSRS is the **full molecule**: a 20-base spacer followed by the
constant sgRNA scaffold. The spacer was not assumed to be "the first twenty bases" — the
canonical scaffold `GUUUUAGAGCUAGAAAUAGCAAGU` was located in the sequence and the spacer taken
as everything before it. In both records the scaffold begins at position 20, which is what makes
the 20-base reading correct rather than merely conventional.

Two further records were **refused rather than parsed on a guess**, and are recorded here because
a corpus that hides what it could not read is not a corpus:

- `NTLA-2001` (nexiguran ziclumeran), UNII `JJ5AS2HL3G` — the registry entry is the full 4,423-base
  molecule, which carries the Cas9 messenger RNA and not an isolatable 20-base spacer at the
  position this rule looks for. **NO_CANONICAL_SCAFFOLD.**
- `RENIZGAMGLOGENE`, UNII `RT5PXR4D9S` — 66 bases with no canonical scaffold at any position.
  **NO_CANONICAL_SCAFFOLD.**

`VERVE-102`, `PM359`, `EXA-CEL` and `BEAM-101` return no record under those names in GSRS and are
recorded **NOT_FOUND** — absent, not zero.

## The target column is a check, never an input

`target` and `chrom` are REPORTED from the public label and mechanism. They are used **only** for
the known-case check. The measurement is where the zero-mismatch site actually falls; agreement
with the declared chromosome is the PASS, and a guide that fails it has no off-target list printed.

## The assembly

GENCODE GRCh38 primary assembly, `GRCh38.primary_assembly.genome.fa.gz`, sha256
`b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca`, 845,635,028 bytes compressed,
3,099,750,718 bases across 194 sequences. It is pinned by URL and digest rather than committed.
