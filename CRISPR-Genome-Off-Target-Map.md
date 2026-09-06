# Where else could this guide cut? The whole genome, counted

*Every guide RNA the US public substance registry publishes — found by its scaffold, not by
a name anyone remembered — screened against every NGG site on both strands of the human
genome, exactly. 304,796,751 candidate sites, one integer each. No sampling, no seed heuristic,
no alignment score, and no parameter to choose.*

## The question, and why it outlives the trial

Casgevy — exagamglogene autotemcel — is an **approved** CRISPR therapy for sickle cell disease
and β-thalassemia. Others here are late-stage in-vivo therapies and CAR-T manufacturing guides.
The trials decide whether they work. None of them answers the question a patient would ask
about a molecule that edits their genome, and that question does not expire:

> **Besides its intended cut site, where else in my genome could this guide direct a cut?**

That is a **discrete** question, so it is counted rather than estimated.

## The rule

SpCas9 cuts where two conditions hold together: a **PAM** — three bases immediately 3′ of the
protospacer matching NGG — and sufficient complementarity between the 20-base spacer and the
protospacer. Bases are integers; a position matches when the two codes are equal.

The PAM is what makes this tractable. A 20-mer against three billion bases would have three
billion positions to consider on each strand; requiring NGG discards fifteen sixteenths of
that space **before any comparison happens**, leaving 304,796,751 real candidate sites. Every one
is examined, on both strands:

```
forward at i : protospacer = g[i ..< i+20],  PAM = g[i+20 ..< i+23], g[i+21]=G, g[i+22]=G
reverse at i : PAM read on the other strand — g[i]=C, g[i+1]=C
               protospacer = reverseComplement(g[i+3 ..< i+23])
```

N bases occur in long runs in the assembly. A window containing any N is **not scored** and is
counted separately — absence is not a match, and it is not a mismatch either. 1,718 windows
were set aside this way.

## Why the scope is the registry and not a list

The first version of this screen carried **two** guides, found by searching the registry for
drug names recalled from memory. That is a completeness defect no harness can catch: a guide
nobody recalls is silently absent from a safety map, the arithmetic correct and the coverage
wrong.

So all **742** substances of class `nucleicAcid` were scanned for the canonical SpCas9 sgRNA
scaffold `GUUUUAGAGCUAGAAAUAGCAAGU`. **Fifteen** carry it, and in every one the scaffold begins
at position 20 — which is what makes the 20-base spacer a *measurement* rather than a
convention.

Finding guides by **structure** rather than by **name** vindicated an earlier refusal instead
of overturning it. `NTLA-2001`'s own record is the full 4,423-base molecule carrying the Cas9
messenger RNA, with no isolatable spacer, and it was refused. Its guide exists under a
*separate* record — `Nexiguran`, UNII `5G537B4BTJ` — and the structural scan found it.
Refusing to guess at the mRNA record lost nothing.

## The cut site is measured, not declared

Most guide records carry no target annotation, so a screen that demands a declared target
chromosome cannot enumerate a registry — it would have reported nothing for fourteen of the
fifteen. A guide's measured cut site is therefore **where its zero-mismatch match actually
falls in the assembly**. Off-targets are the sites outside it. A guide with no zero-mismatch
site anywhere gets **no** off-target list, because its published spacer and the assembly
disagree.

The rule was validated on chromosome 2 before the whole-genome run: only Casgevy, whose
BCL11A target is on chr2, found a site there, and all fourteen others correctly found none.

## What the screen found

```
guides screened   : 15
sequences scanned : 194
bases scanned     : 3099750718
NGG PAM sites     : 304796751
windows with N    : 1718
```

| guide | UNII | perfect sites | measured cut site | 1mm | 2mm | 3mm | 4mm | sites ≤4mm |
|---|---|---|---|---|---|---|---|---|
| `EVONCABTAGENE-PAZURGEDLEUCEL-SINGLE-G` | EQW8RVL4CV | 1 | chr15 (1 site) | 0 | 0 | 15 | 457 | 472 |
| `EVONCABTAGENE-PAZURGEDLEUCEL-SINGLE-G` | FKP72X9XKK | 1 | chr14 (1 site) | 0 | 0 | 37 | 279 | 316 |
| `EXAGAMGLOGENE-AUTOTEMCEL-GUIDE-RNA-SE` | L28RZ5CC6K | 1 | chr2 (1 site) | 0 | 0 | 6 | 137 | 143 |
| `Lonvoguran` | D8UQ4B2T7M | 1 | chr4 (1 site) | 0 | 0 | 4 | 182 | 186 |
| `Nenzinacogene-autogeleucel-gRNA-targe` | YGA7BAF735 | 1 | chr3 (1 site) | 0 | 1 | 7 | 121 | 129 |
| `Nexiguran` | 5G537B4BTJ | 1 | chr18 (1 site) | 0 | 0 | 18 | 178 | 196 |
| `Ristoglogene-autogetemcel-gRNA` | 5UBM9CGH6K | 2 | chr11 (2 sites) | 0 | 0 | 10 | 79 | 89 |
| `Soficabtagene-geleucel-single-gRNA-ta` | ENS57C5JUZ | 1 | chr17 (1 site) | 0 | 0 | 2 | 61 | 63 |
| `Soficabtagene-geleucel-single-gRNA-ta` | 93A4Y2S6E2 | 1 | chr14 (1 site) | 0 | 0 | 5 | 136 | 141 |
| `TACATRESGENE-AUTOLEUCEL-GUIDE-RNA-(GR` | 3KQV6T97QD | 2 | chr7 (2 sites) | 0 | 0 | 2 | 69 | 71 |
| `TGFBR2-5-sgRNA-(zugocabtagene-geleuce` | GPK7BXF67W | 1 | chr3 (1 site) | 0 | 0 | 6 | 83 | 89 |
| `Taziguran` | A2N98QL2SL | 1 | chr4 (1 site) | 0 | 1 | 18 | 189 | 208 |
| `Tremtelectogene-empogeditemcel-Guide-` | B6ZZE44GUB | 1 | chr19 (1 site) | 0 | 0 | 15 | 105 | 120 |
| `VOLAMCABTAGENE-DURZIGEDLEUCEL-SINGLE-` | 4M5F9ZC9EH | 1 | chr19 (1 site) | 0 | 0 | 0 | 47 | 47 |
| `ZC3H12A-10-sgRNA-(zugocabtagene-geleu` | RC77WK8XEG | 1 | chr1 (1 site) | 0 | 0 | 3 | 32 | 35 |

## The seal

```
MARKER  CRISPR_GENOME_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
sha256  487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
```

The assembly is GENCODE GRCh38 primary, pinned by digest so a reader can confirm they hold
the same bytes: `b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca`.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/crispr-genome-offtarget-exact.swift -o /tmp/crispr
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/GRCh38.primary_assembly.genome.fa.gz \
  | gunzip -c | /tmp/crispr corpus/crispr-atlas/guides_all.tsv
```

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

## The verdict

Stated plainly, because a safety map that ends in hedging is not a safety map.

**What this screen DOES call.** Every one of the fifteen guides has exactly one perfect match in
the genome and **zero sites at a single mismatch**; thirteen of fifteen have zero at two. On the
question this instrument can answer — *how many places in the genome match this guide, exactly* —
these are clean guides, and the count is not an opinion. Casgevy, an approved therapy people are
alive because of today, is among the cleanest.

**What this screen does NOT call, and nobody should read into it.** Affine.Earth does **not** call
any of these therapies safe. A site at three or four mismatches is a place the chemistry *could*
direct a cut; whether it does, in a cell, at a dose, in that chromatin state, is a laboratory
question this program has not asked and cannot answer. Off-target *potential* is one input to
safety among many, and this page measures only that one.

**Where a bench should look.** The sites listed at ≤4 mismatches, with their coordinates and
strands, are where a laboratory would start if it wanted to check a guide experimentally — and
they are published in full for exactly that reason. **Nothing here is medical advice and nothing
here should change anyone's treatment.**

What the page provides is the exact, complete, re-derivable enumeration any such conversation
should start from, available to anyone without permission and without trusting us.

## Related

- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md) — the same discipline over the transcriptome.
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper.md)
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
