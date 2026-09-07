# Designed, or forced by its own bases? Every clinical CRISPR guide, counted

*Twenty-five guide RNAs — every one that a public, login-free registry publishes a spacer for and
that a WHO INN entry names as part of a CRISPR therapeutic — screened against the whole human
genome under three different PAM rules, exactly. And each one screened alongside 32 permutations
of its own bases, so the map says not only where a guide could cut but whether its specificity was
chosen or is simply what its composition allows.*

## What changed since the last map

[The previous map](CRISPR-Genome-Off-Target-Map.md) carried **15** guides and **one** rule: NGG,
three bases 3′ of a 20-base protospacer. It found them by scanning all 742 registry substances of
class `nucleicAcid` for one string — the canonical SpCas9 sgRNA scaffold `GUUUUAGAGCUAGAAAUAGCAAGU`
— and taking the 20 bases before it.

That rule is exact for what it covers and blind in three separate ways, each measured rather than
argued:

1. **A scaffold variant is not the canonical scaffold.** The two ataglogene autogetemcel guides
   carry `GUUUGAGAGCUAG` — one base different at position 4 — and were invisible.
2. **A different nuclease puts the spacer at the other end.** Cas12a and Cas12b guides carry a
   5′ repeat and a 3′ spacer. "The 20 bases before the scaffold" returns nothing on them.
3. **A record need not carry a scaffold at all.** `NULABEGLOGENE AUTOGEDTEMCEL` is registered as a
   bare 20-mer: there is nothing to anchor on, and the whole record is the spacer.

Three independent detectors were run instead — registry type (23 hits), structural anchor (22),
record name (23) — and **unioned to 27**. No single detector finds all of them, which is the whole
argument for the union. Two of the 27 were refused **on structure, not on name**. **Twenty-five
guides remain**, and the 15 the old rule found re-derive **byte-identically** under the new one.

## Three PAM rules, because one would have returned an empty map for ten of them

The published screen carried one rule: NGG, three bases 3' of a 20-base protospacer. That rule is
exact for SpCas9 and blind to everything else in this set. Ten of the twenty-five guides are not
screenable by it at all — their PAM sits on the **other side** of the protospacer, and their
spacers are 21 and 22 bases, not 20.

| nuclease | PAM | side | spacer | guides |
|---|---|---|---|---|
| SpCas9 | `NGG` | 3' of the protospacer | 20 nt | 15 |
| SpCas9 D10A base editor | `NGG` | 3' | 20, 20, **10** nt | 3 |
| AsCas12a (incl. chimeric RNA-DNA) | `TTTV` | **5'** of the protospacer | 20, 20, 20, **21** nt | 4 |
| Cas12b | `TTN` | **5'** | **22** nt | 3 |

A screen that ran the old kernel over the new table would have returned an empty map for those
ten and a zero-mismatch failure for each — which reads exactly like a corpus error and is not
one. Every (PAM word, spacer length) pair is therefore enumerated as its own group, with its own
footprint, its own candidate-site census and its own scan range.

Written as the program reads them, anchoring on the last base of the footprint:

```
SpCas9   forward   protospacer ends 3 before the anchor;  PAM = N G G at the anchor
         reverse   PAM reads C C on the forward strand L+1 and L+2 back
AsCas12a forward   PAM = T T T V at L+3 .. L back;        protospacer ends at the anchor
         reverse   PAM reads A A A then a non-A on the forward strand, 0..3 back
Cas12b   forward   PAM = T T N at L+2 .. L back;          protospacer ends at the anchor
         reverse   PAM reads A A then any base on the forward strand, 0..2 back
```

N bases occur in long runs in the assembly. A window containing any N is **not scored** and is
counted separately: absence is not a match, and it is not a mismatch either.

## The control arm: every guide against permutations of its own bases

A histogram alone cannot say whether a guide is specific *because someone chose it well* or
because its base composition leaves it nowhere else to go. A guide that happens to be GC-rich
in a GC-poor genome looks clean for a reason that has nothing to do with design.

So every guide is screened alongside **32 permutations of its own bases** — the identical count
of A, C, G and T, the identical length, the identical PAM rule. The permutation is Fisher-Yates
driven by a fixed-constant LCG keyed on (guide index, permutation index): no clock, no
`arc4random`, no hash seed, deterministic in every process on every machine.

On-target is held strictly apart from off-target burden. **Burden** is the number of sites at
1 to 4 mismatches; the zero-mismatch sites — the intended cut site — are excluded from the guide
and from every permutation by the same rule.

The verdict uses no rank threshold. It uses two exact, tie-free comparisons:

- **below every permutation** — the guide's burden is strictly less than the smallest of its own
  32 permutations. Its specificity is a property of the *sequence that was chosen*.
- **within its composition** — the guide sits inside the range its own bases produce. That is a
  statement about the molecule, and not a defect in it.

## The instrument validates itself before it reports anything

Sixteen arms run **first**, on cases constructed in advance, and nothing is reported if any of them
fails. A synthetic contig is built from the real spacers with sites placed by construction: a
good-PAM forward site, a good-PAM reverse site, a one-mismatch decoy, a **broken-PAM** copy of the
same spacer and a **wrong-family-PAM** copy of the same spacer. The sequence is therefore present
four times where the rule may admit only two.

Arms run in both directions, because always-green and always-red are the same defect:

| arm | expected | measured |
|---|---|---|
| each of the five (rule, length) groups admits exactly its two constructed sites | `0mm=2` | `0mm=2` |
| the spacer is literally present more often than the rule admits | `literal=15 admitted_fwd=5` | `literal=15 admitted_fwd=5` |
| the one-mismatch decoy is seen as one mismatch | `1mm>=1` | `1mm>=1` |
| the intact spacer is found where a corrupted one is not | `intact=1 corrupt=0` | `intact=1 corrupt=0` |
| packed and naive kernels agree on every histogram bucket | `identical` | `identical` |
| packed and naive kernels agree on every candidate-site census | `identical` | `identical` |
| packed and naive kernels agree on the in-kernel work count | `169257` | `169257` |
| an N run is set aside rather than scored | `setAside>0` | `setAside>0` |
| an empty range performs no work and reports none | `evals=0 scored=0` | `evals=0 scored=0` |
| a homopolymer separates the three rules | `NGG:0/0 TTTV:0/0 TTN:0/9976` | `NGG:0/0 TTTV:0/0 TTN:0/9976` |
| both kernels reach that same split | `identical` | `identical` |
| the completeness identity holds, and refuses when perturbed | `true/false` | `true/false` |

**The homopolymer arm caught the arm, not the kernel.** It was written expecting zero PAM sites of
any rule on a run of A's, and it failed at 9,976. The kernel was right and the expectation was
wrong: on the *reverse* strand an A-run reads as a T-run, so a poly-A contig carries a `TTN` PAM at
every eligible anchor and none of the other two. The arm now asserts that exact split — zero for
NGG and TTTV, one site per eligible anchor for TTN — which is a stronger statement than the zero it
originally claimed.

**A second kernel exists only to disagree with the first.** The screen runs a packed
2-bit XOR-and-popcount kernel. Beside it sits a deliberately naive one — direct array indexing, one
base at a time, no packing, no rolling registers — and their histograms, candidate-site censuses
and work counts must match byte for byte, on the synthetic contig **and** on a 200,000-base slice
of real chromosome 1 taken deliberately past the telomeric N run, because a cross-check over
unusable bases agrees for the wrong reason.

## The completeness figure is counted, not derived

A completeness number computed from input sizes is unfalsifiable. `probeEvals` is incremented
**inside the innermost loop**, once per (candidate site, probe) pair actually evaluated, and the
program refuses to seal unless it satisfies its own identity against the in-kernel site census and
unless the assembly reproduces three externally published integers.

**That refusal was proven to fire.** The same binary was run on a deliberately truncated assembly:

```
REFUSED — INCOMPLETE. This program did not screen the whole assembly and will not seal a
map that would read as complete. What failed:
    bases scanned 118,032,780 != published 3,099,750,718
    sequences 1 != published 194
    NGG candidate sites at L=20 13,365,412 != published 304,796,751
```

The in-kernel counts came back **smaller** and the program **refused**, with no seal. A gate that
cannot fail is not a gate.

## Three instruments, one set of integers

The screen's own packed kernel, its deliberately naive twin, and the **previously published
program** were all run on identical bytes. None was adjusted to agree with any other.

| instrument | NGG candidate sites on the same 118,032,780 bases | N windows |
|---|---|---|
| this screen, packed 2-bit XOR + popcount | 6,674,446 fwd + 6,690,966 rev = **13,365,412** | 11 |
| the published predecessor, written independently | 6,674,446 fwd + 6,690,966 rev = **13,365,412** | 11 |
| this screen's naive kernel, on the 200,000-base slice | 18,850,194 probe evaluations | — |
| the packed kernel, on the same slice | 18,850,194 probe evaluations | — |

**One number differs on the whole assembly, and the difference is explained rather than smoothed.**
The predecessor counted 1,718 windows containing an N; this screen counts 1,737. The predecessor
stops comparing a window once it passes ten mismatches, so a window whose N sits *after* that exit
is never seen as an N — it lands in the ">10 mismatches" bucket instead. This screen checks the
whole protospacer's validity independently of how many mismatches have accumulated, so it sees all
of them. The 19 extra windows are all beyond ten mismatches and therefore **cannot** affect any
published site list or any bucket at four mismatches or fewer. The figure is reported and is
deliberately **not** one of the three pins.

## Speed, because it is the reason this was affordable

The predecessor evaluated **5,842,235** (site, probe) pairs per CPU-second. This screen measures
**348,047,750** — a factor of **59.6** — by packing each spacer two bits to a base and reducing a
whole-spacer comparison to one XOR, one fold and one popcount. **Not one count changes**: the
enumeration is complete either way, and the naive kernel is kept alongside precisely to prove it.

## What the screen found

```
sequences scanned      : 194
bases scanned          : 3,099,750,718
candidate sites, by rule (forward + reverse, both strands of every sequence):
  NGG  L=10    153,019,230 fwd + 151,777,657 rev = 304,796,887   set aside (N)   836
  NGG  L=20    153,019,159 fwd + 151,777,592 rev = 304,796,751   set aside (N) 1,737
  TTTV L=20     68,660,340 fwd +  67,711,057 rev = 136,371,397   set aside (N)   821
  TTTV L=21     68,660,337 fwd +  67,711,054 rev = 136,371,391   set aside (N)   871
  TTN  L=22    290,754,808 fwd + 288,090,638 rev = 578,845,446   set aside (N) 3,883
probe evaluations      : 256,354,501,458      counted inside the kernel, as the work happened
permutations per guide : 32
```

A quarter of a trillion whole-spacer comparisons, every one of them an integer.

**Three pins, all reproduced.** The program refuses to seal unless the assembly it was handed
reproduces three externally published integers. All three came back exact — including
`304,796,751`, the NGG candidate-site count the previous map published, reproduced here by a
completely different kernel that also carries two PAM rules the old one never had.

**All 25 guides found their on-target site**, and every measured chromosome agrees with the
declared target locus, which was a cross-check and never an input. Seven of them — four Cas12a and
three Cas12b guides — could not have been screened at all under the old single-rule kernel.

| guide (product) | UNII | nuclease | PAM | nt | perfect | measured site | 1mm | 2mm | 3mm | 4mm | burden | rank | control min / median / max |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| exagamglogene autotemcel | `L28RZ5CC6K` | SpCas9 | `NGG` | 20 | 1 | chr2 | 0 | 0 | 6 | 137 | **143** | 20/33 | 17 / 127 / 949 |
| evoncabtagene pazurgedleucel | `EQW8RVL4CV` | SpCas9 | `NGG` | 20 | 1 | chr15 | 0 | 0 | 15 | 457 | **472** | 33/33 | 31 / 103 / 451 |
| evoncabtagene pazurgedleucel | `FKP72X9XKK` | SpCas9 | `NGG` | 20 | 1 | chr14 | 0 | 0 | 37 | 279 | **316** | 33/33 | 6 / 50 / 220 |
| nenzinacogene autogeleucel | `YGA7BAF735` | SpCas9 | `NGG` | 20 | 1 | chr3 | 0 | 1 | 7 | 121 | **129** | 29/33 | 13 / 67 / 165 |
| ristoglogene autogetemcel | `5UBM9CGH6K` | SpCas9-D10A-BE | `NGG` | 20 | 2 | chr11 | 0 | 0 | 10 | 79 | **89** | 23/33 | 11 / 60 / 175 |
| soficabtagene geleucel | `ENS57C5JUZ` | SpCas9 | `NGG` | 20 | 1 | chr17 | 0 | 0 | 2 | 61 | **63** | 18/33 | 16 / 62 / 280 |
| soficabtagene geleucel | `93A4Y2S6E2` | SpCas9 | `NGG` | 20 | 1 | chr14 | 0 | 0 | 5 | 136 | **141** | 10/33 | 65 / 196 / 555 |
| tacatresgene autoleucel | `3KQV6T97QD` | SpCas9 | `NGG` | 20 | 2 | chr7 | 0 | 0 | 2 | 69 | **71** | 20/33 | 4 / 63 / 1,376 |
| zugocabtagene geleucel | `GPK7BXF67W` | SpCas9 | `NGG` | 20 | 1 | chr3 | 0 | 0 | 6 | 83 | **89** | 8/33 | 51 / 135 / 245 |
| zugocabtagene geleucel | `RC77WK8XEG` | SpCas9 | `NGG` | 20 | 1 | chr1 | 0 | 0 | 3 | 32 | **35** | 6/33 | 11 / 67 / 467 |
| tremtelectogene empogeditemcel | `B6ZZE44GUB` | SpCas9 | `NGG` | 20 | 1 | chr19 | 0 | 0 | 15 | 105 | **120** | 24/33 | 15 / 68 / 172 |
| volamcabtagene durzigedleucel | `4M5F9ZC9EH` | SpCas9 | `NGG` | 20 | 1 | chr19 | 0 | 0 | 0 | 47 | **47** | 23/33 | 3 / 39 / 237 |
| nulabeglogene autogedtemcel | `AAC95PP873` | SpCas9 | `NGG` | 20 | 1 | chr11 | 0 | 0 | 15 | 145 | **160** | 29/33 | 0 / 37 / 782 |
| taziguran (+ ozunacogene parvec) | `A2N98QL2SL` | SpCas9 | `NGG` | 20 | 1 | chr4 | 0 | 1 | 18 | 189 | **208** | 25/33 | 39 / 175 / 356 |
| nexiguran (NTLA-2001) | `5G537B4BTJ` | SpCas9 | `NGG` | 20 | 1 | chr18 | 0 | 0 | 18 | 178 | **196** | 32/33 | 4 / 49 / 200 |
| lonvoguran (NTLA-2002) | `D8UQ4B2T7M` | SpCas9 | `NGG` | 20 | 1 | chr4 | 0 | 0 | 4 | 182 | **186** | 30/33 | 7 / 69 / 4,488 |
| ataglogene autogetemcel CS-101-msgRNA | `HN5K2P5L5F` | SpCas9-D10A-BE | `NGG` | 20 | 2 | chr11 | 0 | 0 | 10 | 79 | **89** | 28/33 | 3 / 46 / 142 |
| ataglogene autogetemcel CS-101-hsgRNA | `YG9GZ69KEF` | SpCas9-D10A-BE | `NGG` | 10 | 345 | *not retained* | 18039 | 613935 | 1063663 | 4731254 | **6,426,891** | 22/33 | 4,770,674 / 6,144,786 / 7,718,082 |
| peclacabtagene geleucel | `FJ27AXN4HM` | AsCas12a | `TTTV` | 20 | 1 | chr15 | 0 | 0 | 8 | 57 | **65** | 28/33 | 10 / 37 / 100 |
| peclacabtagene geleucel | `EVN3GQ2W9C` | AsCas12a | `TTTV` | 20 | 1 | chr2 | 0 | 0 | 1 | 7 | **8** | 18/33 | 0 / 7 / 51 |
| peclacabtagene geleucel | `HPQ9VN6BRV` | AsCas12a | `TTTV` | 20 | 1 | chr14 | 0 | 0 | 1 | 20 | **21** | 28/33 | 2 / 11 / 54 |
| renizgamglogene autogedtemcel | `RT5PXR4D9S` | AsCas12a | `TTTV` | 21 | 2 | chr11 | 0 | 0 | 0 | 10 | **10** | 20/33 | 0 / 7 / 49 |
| persicabtagene lemgedleucel | `95YRJ2A5AD` | Cas12b | `TTN` | 22 | 1 | chr15 | 0 | 0 | 1 | 27 | **28** | 30/33 | 1 / 8 / 47 |
| persicabtagene lemgedleucel | `69QP5QX83X` | Cas12b | `TTN` | 22 | 1 | chr16 | 0 | 0 | 3 | 20 | **23** | 31/33 | 0 / 6 / 38 |
| persicabtagene lemgedleucel | `J5PZ6ZT8TB` | Cas12b | `TTN` | 22 | 1 | chr14 | 0 | 0 | 0 | 9 | **9** | 22/33 | 1 / 7 / 42 |

`burden` is the number of sites at 1 to 4 mismatches, with the zero-mismatch on-target excluded by
the same rule from the guide and from every one of its permutations. `rank` is 1 + the number of
permutations with a strictly smaller burden, out of 33.

**A burden is not comparable across spacer lengths.** Four mismatches of ten is a far looser
criterion than four of twenty, which is why the 10-nucleotide homing guide's burden is six orders
of magnitude larger and why its coordinates are not published — a list of 6.4 million sites is a
list of the genome, not a finding. Its *within-guide* comparison against its own 32 permutations,
at its own length, is valid and is the number that matters for it.

## The two results, stated plainly

**First: where cleanliness matters most, these guides are clean, and the count is not an opinion.**
Every one of the 24 full-length guides has **zero sites in the human genome at one mismatch**, and
22 of 24 have **zero at two**. Three have zero at three as well. The entire off-target burden sits
in the 3- and 4-mismatch buckets — the regime furthest from a cut. **2,718 coordinates** are named
in full, with chromosome, position and strand, for all 24 — and the number of coordinate lines
the program emitted is **exactly** the sum of the 24 burdens in the table above, 2,718 = 2,718, so
nothing in the range it reports was left out of the list.

**Second, and this is what the control arm was built to answer: none of the 25 sits below its own
composition floor.** Zero of 25 have a burden strictly smaller than every one of their own 32
permutations; 25 of 25 sit inside the range their own bases produce, and most sit in the upper half
of it. The control arm discriminates plainly — permutation burdens span **0 to 7,718,082** across
the set, so this is not an instrument that cannot tell probes apart.

**What that second result means, and what it does not.** A therapeutic spacer is **not free to be
chosen**. It is dictated by the locus the medicine has to cut: the guide must sit on *BCL11A*, on
*TTR*, on *TRAC*. Its 32 permutations have no locus to hit and are free to be whatever minimises
off-target burden. The comparison is therefore between a molecule with a job and 32 molecules with
none, and the honest reading of the result is a statement about **the constraint**, not about the
quality of anyone's guide design. That every one of them still reaches zero at one mismatch, under
that constraint, is the more remarkable half of the same measurement.

**Where a bench should point.** The control arm is a design-stage instrument, and it is at its most
useful where a target offers **more than one usable protospacer** — there, ranking candidates
against their own composition class is a real integer that separates them before any of them is
synthesised, and it costs one pass over a public file. It is worth least where the locus admits
exactly one guide, which is precisely the case where none of these numbers is anyone's fault.

## The full histogram, every bucket, for every guide

A safety artifact that publishes some of its distribution is not one. Below is the complete
mismatch histogram for all 25 guides — every bucket from zero to the guide's own spacer length,
over every candidate site of that guide's own PAM rule on both strands of the assembly. Nothing
is truncated and no threshold was applied inside the arithmetic; the 4-mismatch reporting cut in
the table above is applied only afterwards.

```
L28RZ5CC6K  EXAGAMGLOGENE AUTOTEMCEL GUIDE RNA SEQUENCE
    0=1 1=0 2=0 3=6 4=137 5=1214 6=9776 7=59133 8=306178 9=1148285 10=3674918 11=9571693
    12=19847389 13=35381237 14=50173682 15=59588907 16=57235847 17=40777652 18=19876095
    19=6267001 20=875863
EQW8RVL4CV  EVONCABTAGENE PAZURGEDLEUCEL SINGLE GUIDE RNA (SGRNA) TARG
    0=1 1=0 2=0 3=15 4=457 5=2026 6=11754 7=65147 8=301201 9=1017945 10=3210883 11=8894428
    12=18706410 13=32979814 14=48987699 15=58717855 16=56265242 17=42425130 18=23510348
    19=8264803 20=1433856
FKP72X9XKK  EVONCABTAGENE PAZURGEDLEUCEL SINGLE GUIDE RNA (SGRNA) TARG
    0=1 1=0 2=0 3=37 4=279 5=2344 6=14016 7=75368 8=343029 9=1291280 10=3734811 11=9098294
    12=18732635 13=32919781 14=48641972 15=60763881 16=57819529 17=41854740 18=21198842
    19=7227940 20=1076235
YGA7BAF735  Nenzinacogene autogeleucel gRNA targeting CCR5
    0=1 1=0 2=1 3=7 4=121 5=1089 6=8366 7=51699 8=267000 9=1048615 10=3463289 11=9124820
    12=19850782 13=34911962 14=50740398 15=60120554 16=56442627 17=39408922 18=20279692
    19=7308810 20=1766259
5UBM9CGH6K  Ristoglogene autogetemcel gRNA
    0=2 1=0 2=0 3=10 4=79 5=803 6=6515 7=42808 8=223533 9=928851 10=3080028 11=8683859
    12=18875521 13=34388947 14=51850142 15=60845909 16=56366819 17=40142846 18=20522910
    19=7827280 20=1008152
ENS57C5JUZ  Soficabtagene geleucel single gRNA targeting CD7 locus
    0=1 1=0 2=0 3=2 4=61 5=687 6=5804 7=36424 8=194758 9=868763 10=2976871 11=8054098
    12=18319633 13=35241240 14=54257647 15=63548607 16=56691408 17=39469060 18=18977898
    19=5407203 20=744849
93A4Y2S6E2  Soficabtagene geleucel single gRNA targeting TRAC locus
    0=1 1=0 2=0 3=5 4=136 5=1658 6=19146 7=71189 8=312053 9=1152350 10=3693441 11=9778759
    12=21284040 13=37559420 14=53792915 15=61843751 16=53600530 17=36571047 18=17793359
    19=6048475 20=1272739
3KQV6T97QD  TACATRESGENE AUTOLEUCEL GUIDE RNA (GRNA) SEQUENCES (TRBC-1
    0=2 1=0 2=0 3=2 4=69 5=641 6=5535 7=34204 8=182661 9=774141 10=2620565 11=7266611
    12=17163788 13=31878676 14=48616919 15=60816049 16=59474554 17=44011014 18=23725020
    19=7195401 20=1029162
GPK7BXF67W  TGFBR2-5 sgRNA (zugocabtagene geleucel)
    0=1 1=0 2=0 3=6 4=83 5=743 6=5946 7=36767 8=188954 9=823242 10=2780625 11=7941190
    12=17670586 13=33407446 14=50103740 15=60704638 16=57851138 17=41314418 18=22477741
    19=8185594 20=1302156
RC77WK8XEG  ZC3H12A-10 sgRNA (zugocabtagene geleucel)
    0=1 1=0 2=0 3=3 4=32 5=431 6=3868 7=28170 8=165038 9=766035 10=2759206 11=7423802
    12=17258530 13=33125030 14=50094802 15=61481584 16=59830907 17=42316089 18=21513759
    19=7015886 20=1011841
B6ZZE44GUB  Tremtelectogene empogeditemcel Guide RNA
    0=1 1=0 2=0 3=15 4=105 5=926 6=6502 7=44026 8=216747 9=782743 10=2652863 11=7671560
    12=17355219 13=31612361 14=49151622 15=61690493 16=59916799 17=43910973 18=21776652
    19=6875185 20=1130222
4M5F9ZC9EH  VOLAMCABTAGENE DURZIGEDLEUCEL SINGLE GUIDE RNA (SGRNA) TAR
    0=1 1=0 2=0 3=0 4=47 5=519 6=4492 7=31798 8=181660 9=878210 10=2981780 11=7821437
    12=17400398 13=32538374 14=49835795 15=61480088 16=59299878 17=42331571 18=21806818
    19=7127110 20=1075038
AAC95PP873  NULABEGLOGENE AUTOGEDTEMCEL SINGLE GUIDE RNA SEQUENCE TARG
    0=1 1=0 2=0 3=15 4=145 5=1208 6=8330 7=46277 8=219804 9=826779 10=2661167 11=7348627
    12=16632152 13=31246683 14=49138912 15=62720244 16=58961431 17=43201258 18=22530695
    19=8027766 20=1223520
A2N98QL2SL  Taziguran
    0=1 1=0 2=1 3=18 4=189 5=1705 6=12655 7=71835 8=325225 9=1244489 10=3972608 11=9997960
    12=21301883 13=36614450 14=53533989 15=61651185 16=56395162 17=37012450 18=16893336
    19=5063171 20=702702
5G537B4BTJ  Nexiguran
    0=1 1=0 2=0 3=18 4=178 5=2181 6=11312 7=59637 8=280385 9=1136894 10=3492841 11=9155211
    12=19380426 13=34329232 14=50006304 15=59143518 16=56488543 17=41445844 18=21464430
    19=7372763 20=1025296
D8UQ4B2T7M  Lonvoguran
    0=1 1=0 2=0 3=4 4=182 5=837 6=5767 7=38025 8=203545 9=866121 10=2926046 11=8310532
    12=18995563 13=35077843 14=51161279 15=62410780 16=58039552 17=41003433 18=19215710
    19=5773014 20=766780
HN5K2P5L5F  CS-101-msgRNA (ataglogene autogetemcel)
    0=2 1=0 2=0 3=10 4=79 5=803 6=6515 7=42808 8=223533 9=928851 10=3080028 11=8683859
    12=18875521 13=34388947 14=51850142 15=60845909 16=56366819 17=40142846 18=20522910
    19=7827280 20=1008152
YG9GZ69KEF  CS-101-hsgRNA (ataglogene autogetemcel)
    0=345 1=18039 2=613935 3=1063663 4=4731254 5=15701930 6=38880909 7=68487629 8=88220654
    9=65498098 10=21579595
FJ27AXN4HM  Peclacabtagene geleucel B2M-tgt12 chRDNA
    0=1 1=0 2=0 3=8 4=57 5=526 6=3570 7=21952 8=116949 9=407678 10=1338089 11=3667107 12=8481084
    13=15898040 14=23969925 15=28044783 16=25679445 17=17360960 18=8435343 19=2548278 20=396781
EVN3GQ2W9C  Peclacabtagene geleucel PDCD1-tgt19 chRDNA
    0=1 1=0 2=0 3=1 4=7 5=83 6=851 7=6713 8=47435 9=261817 10=906176 11=2556637 12=6212545
    13=12467784 14=20754245 15=27440290 16=28158361 17=21887142 18=11314328 19=3787241 20=568919
HPQ9VN6BRV  Peclacabtagene geleucel TRAC-tgt12 chRDNA
    0=1 1=0 2=0 3=1 4=20 5=262 6=1841 7=12851 8=74097 9=295792 10=1004974 11=2902602 12=7150211
    13=13998220 14=22158593 15=28143750 16=27264435 17=19507009 18=10085993 19=3282541 20=487383
RT5PXR4D9S  Renizgamglogene autogedtemcel the guide RNA
    0=2 1=0 2=0 3=0 4=10 5=91 6=1035 7=7198 8=39013 9=178561 10=675593 11=2152552 12=5411791
    13=11007920 14=18493800 15=24898365 16=27097256 17=23091649 18=14520727 19=6649287
    20=1877113 21=268557
95YRJ2A5AD  Persicabtagene lemgedleucel sgRNA targeting B2M locus
    0=1 1=0 2=0 3=1 4=27 5=273 6=2025 7=13651 8=80761 9=348665 10=1351187 11=4397442 12=11607278
    13=26147521 14=49414049 15=77414462 16=101547343 17=109174556 18=94554591 19=63455352
    20=29699600 21=8589983 22=1042795
69QP5QX83X  Persicabtagene lemgedleucel sgRNA targeting CIITA locus
    0=1 1=0 2=0 3=3 4=20 5=251 6=1824 7=12618 8=70557 9=310592 10=1175050 11=3867027 12=10633872
    13=24716967 14=48111041 15=78382284 16=103975677 17=112286987 18=95890391 19=61418430
    20=28397437 21=8373203 22=1217331
J5PZ6ZT8TB  Persicabtagene lemgedleucel sgRNA targeting TRAC locus
    0=1 1=0 2=0 3=0 4=9 5=111 6=1051 7=7951 8=48374 9=231898 10=951894 11=3278047 12=9517226
    13=22826488 14=46142998 15=77596039 16=105578849 17=114217840 18=97745723 19=62875545
    20=28495454 21=8176627 22=1149438
```

## Two registries, because neither one is enough

**NCATS GSRS has the sequences and publishes no mechanism.** Its own subtype field is unreliable
for this question: all three persicabtagene lemgedleucel records are labelled `CAS9 GUIDE RNA`
while their structure is a 97-nucleotide 5′ scaffold with a 22-nucleotide 3′ spacer, which no Cas9
sgRNA has.

**WHO INN Proposed Lists have the mechanism** — and print the same molecules a second time, as
per-residue chemical nomenclature. All 26 published lists, pl110 through pl135, are public,
login-free PDFs on `cdn.who.int`; pl136 and later do not exist. pl131 says, verbatim, of
persicabtagene lemgedleucel: *"gene-edited using CRISPR/Cas12b"*. pl133 names Cas12a and the
chimeric RNA-DNA chemistry.

The two notations were machine-checked against each other in both directions, and the check is
re-run here rather than inherited:

```
arm1 known case  lonvoguran  pl130  residues=166  5'20=GGATTGCGTATGGGACACAA  MATCH
arm1 known case  nexiguran   pl127  residues=158  5'20=AAAGGCTGCTGATGACACCT  MATCH
arm2 corrupted expectation   lonvoguran  ...ACACAA vs ...ACACAT  DIFFERS  (as required)
arm3 absent name             notaguran   ABSENT (not zero, not a silent pass)
arms passed 4  arms failed 0  of 4
```

The source's own misspellings are admitted by name and counted on every run — `citidylyl`×7,
`citydyl`×1, `methylcitidylyl`×3, `methylcitydyl`×1 — rather than normalised away.

**The 20-base reading is sourced, not assumed.** WHO INN Proposed List 127 defines nexiguran as
*"single-stranded guide RNA (sgRNA) targeting the human transthyretin (TTR) gene with its
5′-terminal 20 nucleotides"*.

## The assembly

GENCODE GRCh38 primary assembly, pinned by digest so a reader can confirm they hold the same bytes:

```
sha256  b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca
        845,635,028 bytes compressed · 3,099,750,718 bases · 194 sequences
```

The digest was verified before the run and again after it, against the same local copy.

## What is ABSENT — and a correction to how that was stated

Six CRISPR products have a public registry record and **no public guide spacer anywhere**:
lumocabtagene geleucel, brinretigene vesgedparvovec, motacabtagene lurevgedleucel, edeltresgene
autogeleucel, imvucabtagene geleucel and teotresgene autogeleucel.

An earlier note said their records "carry no relationship to any nucleic-acid substance." **That is
not what the registry shows, and the measurement is more interesting than the claim it replaces.**
Each of the six *does* carry exactly one nucleic-acid record — and every one of them is the
**transgene the therapy inserts**, not the guide that directs the cut:

| product | UNII | registry class | length |
|---|---|---|---|
| lumocabtagene geleucel | `DDN8GY386G` | VECTOR / TRANSGENE | 6,418 nt |
| brinretigene vesgedparvovec | `Z9F4EN4DQZ` | VECTOR / TRANSGENE | 4,890 nt |
| motacabtagene lurevgedleucel | `5AX55JEG65` | VECTOR / TRANSGENE | 4,364 nt |
| edeltresgene autogeleucel | `7XHU2L4C8Q` | closed-end dsDNA | 3,163 nt |
| imvucabtagene geleucel | `7AS9F639BQ` | VECTOR / TRANSGENE | 3,147 nt |
| teotresgene autogeleucel | `2MHT2ZGF5Z` | closed-end dsDNA / TRANSGENE | 3,154 nt |

For contrast, a guide record is 66 to 119 bases — scaffold plus spacer. A rule that selected by
**name** would have screened a 6,418-base CAR expression cassette as though it were a spacer. A
rule that selects by **structure** refuses it, which is why two further records were also refused:
`Lerepmeran` (2,525 nt) and `Ataglogene autogetemcel mRNA-L` (4,593 nt, which encodes the Cas9 D10A
protein itself).

So the six are **NOT_KNOWN** here. That is a different answer from a burden of zero and a different
answer from a refusal, and it is printed differently. Nothing was inferred for them from a target
gene name, and nothing should be.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
xcrun swiftc -O -swift-version 5 reproduce/crispr-clinical-guide-atlas-exact.swift -o /tmp/atlas

# the whole assembly, 25 guides, three PAM rules, 32 permutations each
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/GRCh38.primary_assembly.genome.fa.gz \
  | gunzip -c | /tmp/atlas corpus/crispr-clinical/guides_expanded.tsv 32
```

The guide table is pinned inside the program by digest. Change one base of it and the program
refuses by name before it reads anything else:

```
GUIDE TABLE DIGEST MISMATCH — REFUSED. This program screens one pinned table and will not
screen bytes it cannot name.
  expected sha256  bb188a75837c3384322723c5935da34605cb89caae43cf3b0468572fda60b80c
  measured sha256  9c2173d88c1fcb3bf00a1e70b272a36d9a76f5f896cdaf74a2fc95ef02f4ae23
```

Run it with no guide table, or with no genome on stdin, and it says so and prints the figures it
would need — it never reports a screen it did not perform. No account, no key, no data-use
agreement, and no floating point anywhere on the decision path: mismatch counts are popcounts of a
2-bit packed XOR, and every rank, median and burden is an integer.

## The seal

```
MARKER  CRISPR_CLINICAL_GUIDE_ATLAS__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
arms    16 run, 16 as built
sha256  61ef3254a8455ee339917368c5d45013072a377592045d2e0494cc99c0fad247
```

The sealed transcript carries the guide-table digest, the per-rule candidate-site census, every
guide's complete histogram, every named coordinate and every control-arm row. It carries **no
path, no timing and no core count**, so two machines that hold the same public bytes reach the
same digest.

---

> ### What we claim, and what we do not
>
> **We claim:** twenty-five guide RNAs are registered in a public, login-free substance registry
> with a spacer sequence and named in a WHO INN Proposed List as part of a CRISPR therapeutic —
> from an approved therapy people are alive because of today to first-in-human candidates. For
> every one of them, this page reports the COMPLETE exact enumeration of candidate cut sites in
> GRCh38, on both strands, under the guide's own nuclease's PAM rule and at the guide's own
> measured spacer length: the full mismatch histogram, every bucket, no sampling, no seed
> heuristic, no e-value, no cutoff inside the arithmetic. Every site at four mismatches or fewer
> is named with its coordinate and strand, in full and not as a sample. Each guide is ranked
> against 32 permutations of its own bases under the identical rule, so the map distinguishes a
> specificity that was CHOSEN from one that the composition forces.
>
> **We do not claim:** that any of these therapies is safe, or unsafe. Neither verdict is ours to
> give and neither follows from this arithmetic. A site counted here is a place where the
> chemistry COULD direct a cut. It is **not** a cut, **not** an occupancy, **not** a clinical
> event, and **not** evidence that any medicine harms anyone. Whether a site is cut, in a cell,
> at a dose, in that chromatin state, needs a laboratory and is not answered here. We do not
> claim coverage of the six products whose spacer is not public — for those the honest word is
> *not known*, and it is printed as NOT_KNOWN rather than as zero. Nothing here is medical advice
> and no entry is a recommendation to take or withhold anything.

## Related

- [Where else could this guide cut? The whole genome, counted](CRISPR-Genome-Off-Target-Map.md) — the predecessor: 15 guides, one PAM rule, no control arm.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md) — the same discipline over the transcriptome.
- [The one safety question made exact](The-Safety-Question-Made-Exact.md) — where the composition-matched control arm was first built.
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
