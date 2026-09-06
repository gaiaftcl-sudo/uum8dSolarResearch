# Where else could this guide cut? The whole genome, counted

*The two CRISPR medicines whose guide sequence is published in the US public substance registry,
screened against every NGG site on both strands of the human genome — exactly. 304,796,751
candidate sites, one integer each. No sampling, no seed heuristic, no alignment score, and no
parameter to choose.*

## The question, and why it outlives the trial

Casgevy — exagamglogene autotemcel — is an **approved** CRISPR therapy for sickle cell disease and
β-thalassemia. NTLA-2002 is a late-stage in-vivo CRISPR therapy for hereditary angioedema. Both
have been through the trials that decide whether they work.

Neither of those trials answers the question a patient would actually ask about a molecule that
edits their genome, and that question does not expire when the trial reads out:

> **Besides its intended cut site, where else in my genome could this guide direct a cut?**

That is a **discrete** question, so it is counted rather than estimated.

## The rule

SpCas9 cuts where two conditions hold together: a **PAM** — three bases immediately 3′ of the
protospacer matching NGG — and sufficient complementarity between the 20-base guide spacer and the
protospacer. Bases are integers; a position matches when the two codes are equal.

The PAM is what makes this tractable and it is worth seeing why. A 20-mer against the whole genome
would have three billion positions to consider on each strand. Requiring NGG discards fifteen
sixteenths of that space **before any comparison happens**, leaving 304,796,751 real candidate
sites. Every one of them is examined, on both strands:

```
forward at i : protospacer = g[i ..< i+20],  PAM = g[i+20 ..< i+23] with g[i+21]=G, g[i+22]=G
reverse at i : PAM read on the other strand — g[i]=C, g[i+1]=C
               protospacer = reverseComplement(g[i+3 ..< i+23])
```

N bases occur in long runs in the assembly. A window containing any N is **not scored** and is
counted separately: absence is not a match, and it is not a mismatch either. 1,651 windows were
set aside this way.

## The screen checks itself before it reports anything

There is one thing this screen can be held to in advance: **a guide's zero-mismatch site must exist,
and must fall on the chromosome its published target lies on.** That is tested first, per guide, and
**no off-target list is printed for a guide that fails it.**

The check earned its place. Run against chromosome 2 alone, Casgevy passed and NTLA-2002 correctly
emitted nothing — its target is on chromosome 4, so a chr2-only scan *should* find no perfect site.
The whole-genome run was only started after that behaviour was confirmed.

**And the two runs agree where they overlap, which is a control rather than a coincidence.** The
chr2-only scan and the whole-genome scan are separate executions over different inputs, so what
they say about chromosome 2 has to match:

| | chr2-only run | whole-genome run |
|---|---|---|
| NGG PAM sites | 24,131,051 | 304,796,751 (chr2 is 7.9% of them) |
| Casgevy, 0 mismatches | 1 | 1 — the same on-target, which is on chr2 |
| Casgevy, 1 and 2 mismatches | 0 and 0 | 0 and 0 |
| Casgevy, 3 mismatches | 0 | 6, and **none of the six is on chr2** |
| Casgevy, 4 mismatches | 13 | 137, of which chr2 supplies 13 — 9.5%, against its 7.9% share of sites |

A screen that had mis-indexed a chromosome, double-counted a strand or mis-parsed the assembly
would not produce two runs that agree on all of that.

```
guide                     UNII        target      chrom   perfect  known-case check
EXAGAMGLOGENE-AUTOTEMCEL  L28RZ5CC6K  BCL11A-enh  chr2          1  PASS — zero-mismatch site on chr2
NTLA-2002                 D8UQ4B2T7M  KLKB1       chr4          1  PASS — zero-mismatch site on chr4
```

Each guide has **exactly one** perfect site in the entire human genome, and it is the intended one.

These are the two sequences that were screened, so that nothing here rests on taking our word for
what was tested:

| medicine | UNII | 20-base spacer, as screened |
|---|---|---|
| Casgevy (exagamglogene autotemcel) | `L28RZ5CC6K` | `CTAACAGTTGCTTTTATCAC` |
| NTLA-2002 | `D8UQ4B2T7M` | `GGATTGCGTATGGGACACAA` |

Each is the 20 bases preceding the canonical sgRNA scaffold in that UNII's GSRS record, with `U`
written as `T`. Fetch the same record and you get the same bases.

## What the screen found

```
guides screened   : 2
sequences scanned : 194
bases scanned     : 3099750718
NGG PAM sites     : 153019159 forward + 151777592 reverse = 304796751
windows with N    : 1651
```

| mismatches | Casgevy (BCL11A enhancer) | NTLA-2002 (KLKB1) |
|---|---|---|
| **0** | **1** | **1** |
| **1** | **0** | **0** |
| **2** | **0** | **0** |
| 3 | 6 | 4 |
| 4 | 137 | 182 |
| 5 | 1,214 | 837 |
| 6 | 9,776 | 5,767 |
| 7 | 59,133 | 38,025 |
| 8 | 306,178 | 203,545 |
| 9 | 1,148,285 | 866,121 |
| 10 | 3,674,918 | 2,926,046 |
| more than 10 | 299,595,485 | 300,754,572 |

**One perfect site, then nothing at all until three mismatches.** That gap — zero sites at one
mismatch, zero at two, across three billion bases and both strands — is the property you want in an
editor that will be given to a person, and it is now a counted fact rather than a modelled score.

The nearest sites are named in full, with coordinates and strand, so anyone can go and look at
them. Casgevy's six three-mismatch sites:

```
3 mismatches  chr11:63955658+
3 mismatches  chr13:30199215-
3 mismatches  chr5:51113378+
3 mismatches  chr8:87700771+
3 mismatches  chr8:140143020-
3 mismatches  chrX:101733822-
```

NTLA-2002's four:

```
3 mismatches  chr21:33077250+
3 mismatches  chr5:37125244+
3 mismatches  chr6:72148751+
3 mismatches  chrX:77020085-
```

Casgevy carries 143 sites at four mismatches or fewer besides its on-target; NTLA-2002 carries 186.
The program prints every one.

## Where the sequences come from

Both spacers were fetched from **NCATS GSRS** and read from `/nucleicAcid/subunits[*]/sequence`.
Neither was taken from memory.

A guide registered in GSRS is the **whole molecule** — a 20-base spacer followed by the constant
sgRNA scaffold. The spacer was not assumed to be "the first twenty bases": the canonical scaffold
`GUUUUAGAGCUAGAAAUAGCAAGU` was located in each sequence and the spacer taken as everything before
it. In both records the scaffold begins at position 20, which is what makes the 20-base reading
correct rather than merely conventional.

**Two records were refused rather than parsed on a guess.** `NTLA-2001` (nexiguran ziclumeran) is
registered as the full 4,423-base molecule carrying the Cas9 messenger RNA, with no isolatable
spacer where this rule looks; `RENIZGAMGLOGENE` is 66 bases with no canonical scaffold anywhere.
Both are recorded `NO_CANONICAL_SCAFFOLD` and screened against nothing. `VERVE-102`, `PM359`,
`EXA-CEL` and `BEAM-101` return no record under those names and are recorded `NOT_FOUND` — absent,
not zero.

The assembly is GENCODE GRCh38 primary, pinned by digest so a reader can confirm they hold the same
bytes: `b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca`.

## The seal

```
MARKER  CRISPR_GENOME_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
sha256  e62190c957c75639c1c9a8cdb82055a4aed59fbd038d0bed72fd1c620aa71451
```

A different digest on your machine would mean the arithmetic diverged, which exact integers make
impossible.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/crispr-genome-offtarget-exact.swift -o /tmp/crispr
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/GRCh38.primary_assembly.genome.fa.gz \
  | gunzip -c | /tmp/crispr corpus/crispr-atlas/guides.tsv
```

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

## What this is not

This is a **map, not a verdict on any medicine.** A site at three mismatches is a place the
chemistry *could* direct a cut; whether it does, in a cell, at a dose, with that chromatin state,
is a different question that needs a laboratory and is not answered here. Nothing on this page is
medical advice, and nothing here says either of these therapies is unsafe — Casgevy is an approved
treatment that people are alive because of today, and this screen finds it to be a strikingly clean
guide.

What the page provides is the exact, complete, re-derivable enumeration that any such conversation
should start from, available to anyone, without permission and without trusting us.

## Related

- [The exact off-target atlas of the oligonucleotide medicines](Oligonucleotide-Off-Target-Atlas.md) — the same discipline over the transcriptome, for antisense and siRNA drugs.
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper.md) — why an exact safety screen belongs in public hands.
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md) — where the pelacarsen whole-transcriptome screen was first run.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can
inspect it and re-derive every figure. That visibility grants no rights. The repository carries no
LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a
separate written licensing agreement with the authors.
