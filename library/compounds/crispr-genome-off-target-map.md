# Where else could this guide cut? The whole genome, counted

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
DIGEST_OF      the sealed transcript of the genome-wide guide screen over 15 registry guides
TITLE          Genome-wide off-target map for every guide RNA the public registry publishes
MEASURED       15 guides, found by the canonical SpCas9 scaffold rather than by name, against 3,099,750,718 bases: 304,796,751 NGG PAM sites examined on both strands, 1,718 windows containing an N set aside rather than scored. All 15 guides found a zero-mismatch site and 13 had exactly one in the whole genome; every guide had 0 sites at one mismatch and 13 of 15 had 0 at two.
PROGRAM        crispr-genome-offtarget-exact
FIGURE         487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
FIGURE         304796751 NGG PAM sites
FIGURE         All 15 guides found a zero-mismatch site; 13 had exactly one in the whole genome.
FIGURE         L28RZ5CC6K
SEAL           487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
GRADE          MEASURED
SOURCE         NCATS GSRS, all 742 nucleicAcid substances scanned for the scaffold; 15 carry it
WHERE_THE_LAW_LIVES  reproduce/crispr-genome-offtarget-exact.swift
REFUSED        not a per-guide safety verdict. This entry publishes the map at the granularity the program prints, and no claim about one named guide beyond what appears there
REFUSED        an N window is neither a match nor a mismatch. The 1,718 are set aside and counted, never folded into either bucket
REFUSED        not a claim that any site is cut in a person. A PAM plus complementarity is where a cut is possible, never where it happens
FALSIFIER      a 16th guide in the registry carrying the canonical scaffold, or a different site count for the same assembly digest
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 crispr-genome-offtarget-exact.swift -o /tmp/run && curl -sL <GRCh38 primary assembly fasta> | gunzip -c | /tmp/run ../corpus/crispr-atlas/guides_all.tsv
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
