# Corpus — the published sequences of the oligonucleotide medicines

Every sequence in `drugs.tsv` was fetched from **NCATS GSRS**, the US National Center for
Advancing Translational Sciences' public substance registry, at
`https://gsrs.ncats.nih.gov/api/v1/substances(<UNII>)?view=full`, and read from the single JSON
path `/nucleicAcid/subunits[*]/sequence`. No sequence was taken from memory or from a paper.

The extraction path was validated on a known case before it was trusted anywhere else:
UNII `LSO9H7UZ90` (PELACARSEN) returns `TGCTCCGTTGGTGCTTGTTC`, which is the sequence already
published in Study 26 and independently screened there.

## Frozen rules, declared before any screen was run

**Residues.** A sequence may contain residues outside `{A,C,G,T,U}` — GSRS uses them for
chemical modifications that are not bases. Leading and trailing such residues are trimmed and
the trim is recorded. A sequence with any such residue **internally** is REFUSED, not guessed
at, and the drug is recorded as `REFUSED_UNINTERPRETABLE_RESIDUE`. `U` is written as `T`; the
pairing rule treats them identically and the substitution is lossless for this purpose.

**Strands.** A double-stranded siRNA is registered with two subunits. Rather than assume which
one is the guide, **both are screened separately** and the guide is identified by measurement:
it is the strand whose perfect complement occurs in the drug's target gene. `OLPASIRAN.2` is
the guide; `OLPASIRAN.1` is the passenger, and the screen says so rather than being told.

**Targets.** The `target_gene` column is REPORTED from the public label or mechanism. It is used
**only as the known-case check** and never as an input to the screen. The measurement is which
gene actually carries the perfect complement; agreement with the declared target is the PASS.

**Modality is a refusal, not a score.** Aptamers (`pegaptanib`, `avacincaptad pegol`) bind
proteins, not transcripts, and a Watson-Crick complementarity screen has nothing to say about
them. They are included precisely so that the instrument is seen to fail on them. An instrument
that returned an off-target list for an aptamer would be wrong.

## What is not here

`IMETELSTAT` carries no sequence in GSRS and is recorded `NO_SEQUENCE` — absent, not zero.
One `PLOZASIRAN` strand carries an uninterpretable internal residue and is refused; its other
strand is screened.

The transcriptome screened against is GENCODE v50,
`gencode.v50.transcripts.fa.gz`, sha256
`5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56`, 670,670 transcripts.
It is 183 MB and is therefore pinned by URL and digest rather than committed.
