# The exact off-target atlas of the nucleic-acid medicines

*Every nucleic-acid substance the US public substance registry publishes a usable sequence
for — not a list of drugs anyone remembered — screened against every window of the whole
human transcriptome, exactly. One integer per window per strand. No sampling, no cutoff
inside the computation, no parameter to choose.*

## The question, and why it does not expire

A trial reads out and a drug is approved, or it is not. This is a different question, and it
stays true either way:

> **Besides its target, where else in the human transcriptome can this molecule bind well
> enough to matter?**

Watson–Crick complementarity is a **discrete** rule, so it is counted rather than estimated.
Bases are integers; an antisense strand binds antiparallel, so position *i* of the drug pairs
with position *L*−1−*i* of the window, and a position pairs exactly when the two codes sum to
3. Every window of every transcript is enumerated.

```
strands screened    : 472
substances          : 350
transcripts scanned : 670670
windows enumerated  : per strand LENGTH — a 20-mer has 1467336203 scoreable windows
```

That last line was corrected on 2026-09-06. It previously read `1467336293`, presented as a
property of the run. It was neither: the count is a function of strand LENGTH, and only strand
index 0 incremented the counter, so the figure named one arbitrary strand — and it was inflated by
windows containing an `N` that the mismatch early-exit reached before the invalid-base check. **No
off-target list, no histogram bucket and no seal moved**, because a window at or above the report
floor never takes that exit and the sealed transcript covers the histograms and the hit lists, not
the below-floor bucket. The repair decides window cleanliness once per transcript, independent of
any strand scanning order. It was found by a second, independently written screen disagreeing by 99
windows while agreeing exactly on all nine scored buckets.

## Why the scope is the registry and not a list

The first version of this screen covered 33 medicines from a list written from memory. That
is a real defect in a safety artifact and it is not one any harness can catch: **a drug
nobody recalls is simply absent from the map, silently.** The arithmetic would have been
correct and the coverage would have been wrong.

So the registry is enumerated instead. NCATS GSRS holds **742** substances of class
`nucleicAcid`; **740** carry at least one sequence; and the ones whose every subunit falls in
the 8–60 nt range this screen can handle give **472 strands across 350 substances**.
The enumeration provably contains every one of the original 33.

The rest are refused with the reason recorded: **388** are outside the oligonucleotide length
range — vectors, plasmids, genes and mRNA vaccines, which are mechanistically different and
not what a 20-mer complementarity screen is about — **2** carry no sequence, and **2** carry a
residue this program will not interpret.

**A note on the word approved.** The registry's status field means a curator validated the
*record*. It does not mean the substance is a marketed medicine. This page reports the field
verbatim and makes no marketing claim; which of these are approved drugs is a question for a
label, not for this registry field.

## The target is measured, not declared

A screen that needs you to tell it the target cannot enumerate a registry, because most
substances carry no target annotation. So the target is **read out of the transcriptome**: a
strand's measured target is the set of genes carrying its *perfect* complement, and
off-targets are the qualifying windows outside that set.

**A strand with no perfect complement anywhere gets no off-target list.** Its published
sequence and the transcriptome disagree, and that is reported rather than worked around.

| | strands |
|---|---|
| perfect complement found — screened | **187** |
| no perfect complement anywhere — not screened | 285 |

The honest reasons for the second row are ordinary: the registry publishes the **sense**
strand of a double-stranded drug and its partner is the one that finds the target; the target
is viral or otherwise absent from GENCODE; the molecule is an **aptamer**, which binds a
protein and not a transcript, so complementarity has nothing to say about it; or the sequence
carries chemistry a string of bases cannot represent.

That the aptamers fail is the point rather than a defect. An instrument that returned an
off-target list for an aptamer would be wrong, and they are in the table so it can be seen
not to.

The guide strand of a double-stranded siRNA is identified the same way — by measurement. For
olpasiran the screen says strand 2, and nobody told it.

## What the screen found

Of the 187 strands with a measured target, **18** have no window anywhere
else in the transcriptome reaching the reporting threshold, and **169** do.

| substance | UNII | length | measured target | off-target windows ≥16 |
|---|---|---|---|---|
| `ELUFORSEN` | V30WFP6S2Y | 33 | CFTR | 8892509 |
| `ELUFORSEN-SODIUM` | RIY0DS613M | 33 | CFTR | 8892509 |
| `ETEPLIRSEN` | AIW6036FAS | 30 | DMD | 1650921 |
| `Rostudirsen` | 3AR55D4G2D | 30 | DMD | 1650921 |
| `RADAVIRSEN` | 9P30PF804H | 30 | DMD | 1650921 |
| `VESLETEPLIRSEN` | F6U7EZ3N1Q | 30 | DMD | 1650921 |
| `LUFEPIRSEN` | OKA0O253JZ | 30 | GJA1,GJA1P1 | 1489738 |
| `DIDC-OLIGONUCLEOTIDE` | UKO9UZ8TJO | 26 | ABCB7,ABCC6,ABLIM1 +981 | 756695 |
| `VO-659-free-acid` | 59SHF443XA | 21 | AFF3,AGO1,ANK2 +138 | 180729 |
| `Cysteinyl-zotadirsen` | FY4SL5AU9C | 26 | DMD | 127545 |
| `Zotadirsen` | K4T33W5J4B | 26 | DMD | 127545 |
| `VARODARSEN` | IU91PBD829 | 25 | DMD | 106192 |
| `Pixofisiran.2` | O5QC3YP0M7 | 25 | TGFB1 | 103706 |
| `Pixofisiran-sodium.2` | 8QFS4BAH6H | 25 | TGFB1 | 103706 |
| `DEMATIRSEN` | 51FM0REX6F | 25 | DMD | 103411 |
| `GOLODIRSEN` | 033072U4MZ | 25 | DMD | 103411 |
| `ABETIMUS.2` | P3UVQ22SHK | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS-SODIUM.2` | F5Y7739G6U | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS.3` | P3UVQ22SHK | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS.4` | P3UVQ22SHK | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS-SODIUM.4` | F5Y7739G6U | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS.5` | P3UVQ22SHK | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS-SODIUM.5` | F5Y7739G6U | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `ABETIMUS-SODIUM.6` | F5Y7739G6U | 20 | AAK1,ABCB7,ABCC13 +1341 | 100934 |
| `LIXADESIRAN.2` | P3CNL1GL6K | 25 | PTGS2 | 99502 |
| `LIXADESIRAN-SODIUM.2` | 62204K0Y95 | 25 | PTGS2 | 99502 |
| `Pixofisiran-sodium.1` | 8QFS4BAH6H | 25 | CCDC97 | 92319 |
| `Pixofisiran.1` | O5QC3YP0M7 | 25 | CCDC97 | 92319 |
| `ABETIMUS.7` | P3UVQ22SHK | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS-SODIUM.7` | F5Y7739G6U | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS.8` | P3UVQ22SHK | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS-SODIUM.8` | F5Y7739G6U | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS.1` | P3UVQ22SHK | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS-SODIUM.1` | F5Y7739G6U | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS-SODIUM.3` | F5Y7739G6U | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `ABETIMUS.6` | P3UVQ22SHK | 20 | ABCC4,ABCG8,ABHD3 +1134 | 59798 |
| `INCLISIRAN-SODIUM.2` | UPC6BTX7PY | 23 | PCSK9 | 44786 |
| `INCLISIRAN.2` | UOW2C71PG5 | 23 | PCSK9 | 44786 |
| `ATU-027.2` | IFJ2SAK127 | 23 | PKN3 | 33762 |
| `LUMASIRAN-SODIUM.2` | 67P6XH37HD | 23 | HAO1 | 26282 |

*129 further strands carry off-target windows; the program prints them all.*

## The seal

The screen was sharded by **strand**, never by transcript: every shard reads the entire
transcriptome and every strand is scored against every window, so splitting the strand list
changes no number. The published seal is the sha256 of the eight shard seals in order, each
of which already covers its own strands over the whole corpus.

```
MARKER  OLIGO_OFFTARGET_ATLAS_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
sha256  321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08
```

shard seals, in order:

```
  0  825185d81c520a6adccf2ef3f6643e5537237e8c172ae6137a9260b0eba8c0fe
  1  5789afba0b6ae89e65edfa2283e7bc312c5025b7069339f11ba5931caab5b871
  2  3f7903728632cab384f10d2c6ac936e04f6bb0c1144c869b1481b10749c6d516
  3  477d9d01349bcdcfbeed1df4c73dd4c4f0eb6611804bf4dd02809b5aa103e508
  4  401a1452c65c01bed97bd4cf646d2533765e40e22af34507874f1c82bea87d54
  5  1d56bfe60288cdd980e622d286d604bf102326fcbeda042d6cfae2138682cc7e
  6  dd9899e2908b7a1977ee83335f346e864b4ac0139c12972138245cad0ff5c968
  7  206d29aa4a64037ad6a8bdfb7bf7ff4ebad309254d50f892656d0d288dda4809
```

The transcriptome is GENCODE v50, pinned by digest so a reader can confirm they hold the same
bytes: `5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56`. Pelacarsen's
sequence `TGCTCCGTTGGTGCTTGTTC` is in the table and reaches LPA, which is the same result the
independent single-drug screen in [Study 26](Study-26-Master-Regulator-Bonds.md) reached.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/oligo-offtarget-atlas-exact.swift -o /tmp/atlas
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz \
  | gunzip -c | /tmp/atlas corpus/oligo-atlas/all_nucleicacid.tsv
```

No account, no key, no data-use agreement, and no floating point in the exact path.

## What this is not

This is a **map, not a verdict on any medicine.** A window that pairs 17 of 20 is a place the
chemistry could bind; whether it does, in a cell, at a dose, is a different question that needs
a laboratory and is not answered here. Nothing on this page is medical advice, and nothing
here says any substance is unsafe — several are approved medicines people depend on today.
What the page provides is the exact, complete, re-derivable enumeration any such conversation
should start from, available to anyone without permission and without trusting us.

## Related

- [Where else could this guide cut? The whole genome, counted](CRISPR-Genome-Off-Target-Map.md) — the same discipline over the genome, for the approved CRISPR medicines.
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
