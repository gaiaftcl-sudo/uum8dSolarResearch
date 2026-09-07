# Zilganersen — where else in the transcriptome can it bind?

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  UNII
IDENTITY       AXQ9493NT2
TITLE          Zilganersen off-target map, exact, whole human transcriptome
MEASURED       On the real approved sequence against GENCODE v50: 2 perfect 20/20 windows, both in GFAP; 0 at 19/20 and 0 at 18/20; 11 sites named at 17/20; 324 off-target windows at 16/20 or better outside GFAP against a composition-matched control median of 787. 670,670 transcripts, one integer per window, no cutoff inside the arithmetic.
PROGRAM        zilganersen-offtarget-whole-transcriptome
FIGURE         perfect 20/20       : 0, none in GFAP
FIGURE         19/20 and 18/20     : 0 and 0
FIGURE         off-target burden at 16/20 or better, outside GFAP : 324
FIGURE         composition-matched control median at the same threshold : 787
SEAL           edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa
GRADE          MEASURED
SOURCE         NCATS GSRS, UNII AXQ9493NT2 — the sequence is public and nothing here is behind a login
WHERE_THE_LAW_LIVES  reproduce/zilganersen-offtarget-whole-transcriptome.swift
REFUSED        not a safety verdict on the medicine, and not a finding about any patient
REFUSED        not a claim that any listed site is bound, cleaved or clinically relevant in a person. Complementarity is where binding is possible, never where it happens
REFUSED        not a comment on the trial, the endpoint or the approval
FALSIFIER      the same sequence against the same GENCODE v50 digest returning a different count at any of the four thresholds, or a perfect window outside GFAP
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 zilganersen-offtarget-whole-transcriptome.swift -o /tmp/run && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
