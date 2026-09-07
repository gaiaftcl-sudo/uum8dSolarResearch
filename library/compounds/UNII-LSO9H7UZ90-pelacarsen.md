# Pelacarsen — the same question, asked of a different strand

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  UNII
IDENTITY       LSO9H7UZ90
TITLE          Pelacarsen off-target map, exact, whole human transcriptome
MEASURED       3 perfect 20/20 windows, all in LPA, over 670,670 transcripts and 1,467,336,203 windows against GENCODE v50. At 17/20 or better outside LPA: LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1.
PROGRAM        pelacarsen-offtarget-whole-transcriptome
FIGURE         perfect 20/20 windows : 3, all in LPA
FIGURE         17/20 or better, not LPA : LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1
FIGURE         513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757
SEAL           513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757
GRADE          MEASURED
SOURCE         NCATS GSRS, UNII LSO9H7UZ90
WHERE_THE_LAW_LIVES  reproduce/pelacarsen-offtarget-whole-transcriptome.swift
REFUSED        not a safety verdict on the medicine and not a finding about any patient
REFUSED        not a claim that LPAL2 or any named transcript is bound in a person
FALSIFIER      an independent screen of the same strand against the same transcriptome digest reaching a different perfect-window count or a different named set at 17/20
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 pelacarsen-offtarget-whole-transcriptome.swift -o /tmp/run && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
