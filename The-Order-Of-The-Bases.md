# The order of the bases

*Every nucleic-acid medicine the US public substance registry publishes a usable sequence for,
ranked against sixteen rearrangements of its own bases. Not "where can this molecule pair" — that
question is already answered and answered alone it decides nothing. This is the comparison: **is
this molecule more specific than an ordinary sequence of the same bases, or is its off-target
burden simply what its composition forces?** One integer per window per probe, 5,355,878,467,758
of them, no sampling and no cutoff inside the arithmetic.*

**A near-complementary window is a place a molecule COULD pair. It is not a cut, not an occupancy,
not a clinical event, and not evidence that any medicine harms anyone. A high rank is not a safety
finding and a low rank is not a clearance.** That sentence is repeated wherever a rank appears on
this page, not once at the top, because a rank lifted out of a page and pasted into a slide loses
every qualifier that was not next to it.

## Where this sits in the family

Three artefacts, one question, taken in order:

| | what it answered | |
|---|---|---|
| [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas) | **WHERE** every one of the 472 registry strands can pair, across the whole transcriptome | the map |
| [The first treatment for Alexander disease — and the safety question that should be exact](The-Safety-Question-Made-Exact) | **WHETHER THAT BURDEN IS UNUSUAL** for one drug, zilganersen, by screening sixteen permutations of its own bases beside it | the control, n = 1 drug |
| **this page** | **that same control, run across the registry** — and the ranking it produces | the comparison |

A list of off-target sites is not a decision. **Any** 20-mer has hundreds of near-complementary
windows in a corpus of 1.47 billion, for the same reason any twenty-letter string turns up in a
large enough library: the corpus is enormous. The number 324 means nothing until you know what an
ordinary sequence of the same bases scores. That is what a control arm is for, and until now the
programme had built one for exactly one molecule.

## The question a bench actually has

> Does **this order** of these bases pair in fewer places than the **same bases in another order**?

It is comparative, it is discrete, and it is therefore exactly answerable. Watson–Crick
complementarity is a counting rule, not an estimate: bases are integers (A=0 C=1 G=2 T/U=3), an
antisense strand binds antiparallel, so position *i* of the strand pairs with position *L*−1−*i* of
the window, and a position pairs exactly when the two codes sum to 3. One integer per window per
probe. No sampling, no seed heuristic, no e-value, no cutoff inside the arithmetic. The reporting
threshold is applied **after** the arithmetic, and the complete mismatch histogram is published, so
any reader can re-make that choice without re-running anything.

And it is answerable **before a molecule is ever synthesised**, which is the half of this that
reaches a patient who has not yet been dosed.

![186 screened probe families, each against sixteen permutations of its own bases: two strictly below all sixteen, eight tying the lowest, 122 inside their own control range, one tying the highest, 44 above every permutation, and nine tying all sixteen at zero where no rank can be read — with 18 ubiquitous, 266 refused and 19 not-known outside the bar entirely](images/oligo-order-vs-composition.svg)

## The control, and the evidence that it discriminates — before any ranking

### 1. Sixteen permutations of each molecule's own bases

For every screened strand the same pass also screens **sixteen permutations of that strand's own
bases** — the identical multiset of A, C, G and T, permuted by a fixed-constant Fisher–Yates with
no clock and no system randomness. A permutation is the same molecule's composition with none of
its design. It is the same permutation function, the same constants and the same seeds as the
single-drug zilganersen screen, so that screen's integers must reappear here, and they are checked
as an instrument arm:

```
[PASS] ranking-separates-and-every-rank-1-is-strictly-below-all-16
       ... ZILGANERSEN off=324 ctrl median=787 range 141-1355 rank 3 of 17
       — matched against the single-drug screen's published integers
```

Two programs, written separately, returning the same integers on the same public bytes.

### 2. Seventeen sequences designed for nothing at all

The most consequential comparison on this page is between a designed medicine and an undesigned
sequence, so it may not rest on one sequence. The instrument constructs **seventeen** undesigned
20-mers by one fixed rule — the reverse complement of the first scoreable 20-mer of every
39,451st transcript of this corpus — and screens each one exactly as it screens a medicine, with its own sixteen
permutations. **They are not medicines** and are labelled as such on every line they appear on.
Their result is printed **before** the registry ranking, because a rank means nothing until the
instrument has been shown to discriminate on sequences nobody designed:

```
sequence                      off     cmin     cmed     cmax    rank  vs-controls     kRes
UNDESIGNED-20MER-01           374       50      444     2138       7  inside             2
UNDESIGNED-20MER-02          1176      100      405      928      17  ABOVE-all-16       2
UNDESIGNED-20MER-03          1138      146      551     3610      13  inside             2
UNDESIGNED-20MER-04          5413     2509     4688     6872      15  inside             1
UNDESIGNED-20MER-05          1808      137      618     2243      16  inside             2
UNDESIGNED-20MER-06           348      101      365      775       8  inside             2
UNDESIGNED-20MER-07          1720       99      344     1256      17  ABOVE-all-16       2
UNDESIGNED-20MER-08         11773      608     2091     8151      17  ABOVE-all-16       1
UNDESIGNED-20MER-09           659      149      642     3265      10  inside             2
UNDESIGNED-20MER-10           238      203      635     1543       2  inside             2
UNDESIGNED-20MER-11           764       48      428     1170      15  inside             2
UNDESIGNED-20MER-12           961       13      308     1549      15  inside             3
UNDESIGNED-20MER-13          2765     1207     2611     5313      11  inside             2
UNDESIGNED-20MER-14          1550      365     1508     3413      10  inside             2
UNDESIGNED-20MER-15          2136       19      505     1899      17  ABOVE-all-16       1
UNDESIGNED-20MER-16           213      135      508     1337       4  inside             2
UNDESIGNED-20MER-17          1117      525     1765     2771       7  inside             2
```

**0 of 17** pair in fewer places than every one of their own sixteen permutations. The median
rankLo of the cohort is **13 of 17**, and **4 of 17** pair in more places than every permutation of
their own bases.

**What that licenses, read off those numbers rather than asserted.** An ordinary stretch of human
transcript, read back as an antisense strand, does not sit at the bottom of its own composition
class — none of these seventeen does. So a registry strand at rank 17 is *not* simply exhibiting
"what happens when a sequence's bases were copied out of a transcriptome full of paralogues and
repeats while a permutation of them was not": the cohort came from exactly there, and four of it
sits at rank 17 too. And a registry strand strictly below all sixteen has done something that
**17 of these 17** undesigned sequences did not do.

**What it does not license.** Seventeen is not a population, they are 20-mers only, and nothing
about a cohort rank says anything about any molecule's safety.

### 3. The instrument answers to seventeen arms, in both directions

Nine before the corpus is read, eight that depend on it, and the count is the length of the list
that ran rather than a typed number. No arm asserts a literal `true`; each exercises the thing that
must hold **and** a deliberately broken case that must be caught. **Seven of the seventeen are new
in this version, and every one of them exists because of a specific defect found in the previous
one** — the tie rule, the disposition set, the resolving threshold, the ubiquitous boundary, the
chance expectation, the both-conventions check, and the requirement that the undesigned control be
more than one sequence:

```
INSTRUMENT CONTROL ARMS (pre-corpus) — 9 arms, count derived from the arms that ran
  [PASS] composition-held-fixed
  [PASS] permutations-deterministic-and-not-identity
  [PASS] packed-scorer-equals-obvious-scorer
  [PASS] scope-classifier-separates-absence-refusal-and-not-known
  [PASS] rank-is-an-interval-and-ties-are-caught
  [PASS] dispositions-are-exhaustive-and-exclusive
  [PASS] resolving-threshold-is-the-first-k-with-spread
  [PASS] ubiquitous-boundary-is-read-off-the-distribution
  [PASS] chance-expectation-is-computed-and-is-large-at-the-boundary

INSTRUMENT CONTROL ARMS (corpus-dependent) — 8 arms, count derived from the arms that ran
  [PASS] sweep-A-scored-every-window-it-claimed
  [PASS] sweep-B-scored-every-window-it-claimed
  [PASS] two-sweeps-agree-bin-for-bin
  [PASS] ranking-separates-and-every-rank-1-is-strictly-below-all-16
  [PASS] tie-convention-declared-and-both-counts-printed
  [PASS] undesigned-cohort-is-more-than-one-sequence
  [PASS] cohort-and-medicine-separate-identical-sequences-do-not
  [PASS] on-target-and-off-target-stay-apart
```

And two deliberately broken builds, to show the arms are instruments and not decoration. Both were
run on a 12,000-transcript subset of the same corpus rather than the whole of it — the point is
which arm fires and what its detail column says, and a subset makes that a twenty-second experiment
instead of an hour-long one:

```
TAMPER 1 — rank each strand against ONE control (its median) instead of all sixteen
  [FAIL] ranking-separates-and-every-rank-1-is-strictly-below-all-16
         ... 0 of 18 families consulted all 16 controls and 18 did not ...

TAMPER 2 — silently skip one transcript in a thousand in sweep B
  [FAIL] sweep-B-scored-every-window-it-claimed
         ... 0 of them sum their on-target and off-target bins to their length's
         window census and 306 do not
  [FAIL] two-sweeps-agree-bin-for-bin      273 of 1152 histogram bins disagree
  [FAIL] on-target-and-off-target-stay-apart
         ... 17 of 18 carry their perfect complement on-target, 1 do not
```

Note what the FAIL lines say. Every arm's detail is written as a **measurement**, including the
disagreeing count, so a reader scanning the detail column of a failing arm cannot read a pass off
it. In the previous version those two arms printed sentences like *"every probe's bins sum to its
length's window census exactly"* whether or not they did.

## What was screened, and what was not

An off-target statement is meaningful only for a strand whose target the instrument could
**measure** — read out of the transcriptome as the set of genes carrying the strand's perfect
complement, never taken from a label. Four dispositions, and no two of them are the same answer:

```
SCOPE — FOUR dispositions, and no two of them are the same answer
  registry strands in the table              : 472
  undesigned constructed 20-mers, NOT medicines: 17
  SCREENED   (target measured in few genes)  : 169
  UBIQUITOUS (perfect complement in hundreds of genes): 18   — NOT a measured target
  REFUSED    (no perfect complement anywhere): 266   — NOT zero off-targets
  NOT_KNOWN  (too short for a target to mean): 19
```

**169 registry strands + 17 undesigned = 186 screened families = 3,162 probes in the second
sweep.** Every excluded strand is named in the run output with its reason. **An excluded strand is
never a clean strand:** absence, refusal, ubiquity and not-known are four different answers, and
none of them is "zero off-targets".

### UBIQUITOUS — the disposition this page had to add

The previous version had three dispositions and no room for a sequence that pairs perfectly
*everywhere*. ABETIMUS was admitted as SCREENED with **47,404 perfect 20/20 complements across
1,344 genes**; those 1,344 genes were then subtracted as "on-target", and the remainder was
published as an off-target burden at rank 17. That figure was never earned. A sequence pairing
perfectly across a thousand genes has not had a target *measured*; it is a common motif.

The boundary is **read off the measurement, not chosen.** The per-strand target-gene counts are
sorted and made distinct, and the boundary is placed at the largest integer *ratio* between
consecutive counts. It fires only when that ratio exceeds the largest ratio a contiguous run of
counts can produce, which the program computes from a constructed contiguous run rather than
typing:

```
THE UBIQUITOUS BOUNDARY — read off the measured distribution, not chosen
  distinct target-gene counts among the strands that carried a perfect complement:
    1 2 3 141 984 1137 1344
  largest consecutive ratio in that sorted list : 47000 per thousand, at the step up to 141
  second-largest ratio                          : 6978 per thousand
  contiguous-run control ratio (computed)       : 2000 per thousand
  the rule fires because 47000 exceeds 2000; the boundary is 141 genes and above.
```

The population is cleanly bimodal. Of the 204 strands that carried a perfect complement at all,
**186 have 1, 2 or 3 measured target genes and nothing whatever lies between 3 and 141.** The
eighteen above the boundary are the sixteen ABETIMUS registrations
(1,137 and 1,344 genes), DIDC-OLIGONUCLEOTIDE (984), and VO-659-free-acid (141). They are named,
they carry their gene count, and their off-target burden is **not** published, because the
subtraction that would produce it is meaningless.

Removing them changed a headline figure that had nothing to do with ranks: the perfect complements
the screened strands carry inside their own measured targets fell from a six-figure number to
**4,192 windows** across 186 families, against **94** carried anywhere by their 2,976 permutations.

### How much a "measured target" rests on

The NOT_KNOWN boundary is exact — a perfect complement is informative only where 4^L exceeds the
number of scoreable windows of that length, which on this corpus falls at L = 16. But that only
puts the expected number of chance perfect complements below **one**. It does not make one
*unlikely*, and the previous version of this page let it read as though it did. The expectation is
now computed and printed per length:

```
  L=16  windows=  1470018861  expected=  342265 ppm   about 34 in every hundred arbitrary 16-mers
  L=17  windows=  1469348182  expected=   85527 ppm   about 8 in every hundred arbitrary 17-mers
  L=18  windows=  1468677513  expected=   21372 ppm   about 2 in every hundred arbitrary 18-mers
  L=19  windows=  1468006855  expected=    5340 ppm   about one in 187 arbitrary 19-mers
  L=20  windows=  1467336203  expected=    1334 ppm   about one in 749 arbitrary 20-mers
  L=23  windows=  1465324287  expected=      20 ppm   about one in 50000 arbitrary 23-mers
  L=25  windows=  1463983026  expected=       1 ppm   about one in 1000000 arbitrary 25-mers
```

**About a third of arbitrary 16-mers carry a perfect complement somewhere in this transcriptome.**
So a 16-mer whose "measured target" is a single perfect window is admitted here on much weaker
evidence than the same words carry at 20 or 25 bases, and eight rows are flagged `weak` for exactly
that. The convention is stated — an expectation above one in a hundred — and its sensitivity is
printed beside it so a reader can re-make the choice:

```
  Rows flagged at an expectation above one in ten      (100000 ppm): 4
  Rows flagged at an expectation above one in a hundred ( 10000 ppm): 8   <- the stated convention
  Rows flagged at an expectation above one in a thousand (  1000 ppm): 13

    DYN-101                         L=16  perfect=  1  expectation=342265 ppm  rank 2
    DYN-101-FREE-ACID               L=16  perfect=  1  expectation=342265 ppm  rank 2
    Dimovarsen                      L=16  perfect=  1  expectation=342265 ppm  rank 15
    Dimovarsen-sodium               L=16  perfect=  1  expectation=342265 ppm  rank 15
    Mulnitorsen                     L=18  perfect=  1  expectation=21372 ppm  rank 14
    Mulnitorsen-sodium              L=18  perfect=  1  expectation=21372 ppm  rank 14
    Zorevunersen                    L=18  perfect=  1  expectation=21372 ppm  rank 12
    Zorevunersen-Sodium             L=18  perfect=  1  expectation=21372 ppm  rank 12
```

Two of them sit at **rank 2** — the second-best result in the study — and a reader is entitled to
know that their target rests on one 16-base window that a third of arbitrary 16-mers would also
have. A flagged row is not a wrong row. It is a row whose evidence is named.

## On-target and off-target, kept strictly apart

At the perfect-match threshold a real medicine will **always** exceed its permutations, because it
has a target and they do not. That is the design succeeding and it is not a burden; reporting it as
one is what makes a working medicine look dangerous. The separation here is structural, not a
convention — a window inside a strand's measured target genes cannot reach the off-target histogram
at all, for the strand or for any of its permutations — and an arm proves it holds:

```
ON-TARGET, KEPT STRICTLY APART AND NEVER COMPARED AGAINST THE CONTROLS
  screened strands                                              : 186
  perfect complements they carry inside their own measured target: 4192 windows
  perfect complements carried anywhere by their 2976 permutations: 94 windows

  [PASS] on-target-and-off-target-stay-apart
         0 of 186 screened strands leaked a perfect complement into their own off-target
         count; 186 of 186 carry their perfect complement on-target, 0 do not
```

## The ranking

Every screened strand against sixteen permutations of its own bases, fewest off-target windows
first, at four mismatches or fewer, **outside its own measured target genes**.

Read the columns as they are defined, because two of them are the repair this version exists for:

- **rank** is an **INTERVAL**. `rankLo = 1 + #{controls strictly below}`; `rankHi` adds the controls
  that scored **exactly the same**. A row prints `3` when nothing ties it and `1-17` when the strand
  and all sixteen permutations scored identically. **Rank 1 therefore means `1-1`, which is strict
  separation from all sixteen** — and nothing else does.
- **vs-controls** is the disposition, one of six, exhaustive and mutually exclusive.
- **cmed** is the **upper** median of the sixteen sorted controls — element 8 of `ctrl[0…15]`, the
  ninth smallest. Stated here rather than left to be inferred from the source.
- **perMille** is the burden as parts per thousand of that median, floored; `n/a` where the median
  is zero, because a ratio to zero is not a number.
- **kRes** is the smallest number of mismatches at which this family's own sixteen controls do not
  all agree with each other — the threshold the family can actually be *read* at.
- **evid** flags a measured target resting on a single perfect complement at a length where one is
  not rare.
- A row marked `*` is an undesigned constructed sequence and **is not a medicine**.

**A near-complementary window is a place a molecule COULD pair. It is not a cut, not an occupancy,
not a clinical event, and not evidence that any medicine harms anyone. A high rank is not a safety
finding and a low rank is not a clearance.**

```
substance                    UNII         len   perf gene  evid  target             off    cmin    cmed    cmax   rank perMille  vs-controls   kRes
Zerlasiran-Sodium.2          C9WT9B9PXP    19     11    2     -  LPA,LPAL2          965     991    1554    4089      1      620  BELOW-all-16     1
Zerlasiran.2                 FBX7PTD863    19     11    2     -  LPA,LPAL2          965     991    1554    4089      1      620  BELOW-all-16     1
Pivicasiran.1                8T3L374QA3    23     22    1     -  PNPLA3               0       0      12     104    1-3        0  ties-lowest      3
LIXADESIRAN-SODIUM.2         62204K0Y95    25      5    1     -  PTGS2                0       0       0       1   1-15      n/a  ties-lowest      4
LIXADESIRAN.2                P3CNL1GL6K    25      5    1     -  PTGS2                0       0       0       1   1-15      n/a  ties-lowest      4
ALTERNATIVE-DEFINITION-for-[ -             26      6    1     -  DMD                  0       0       0       1   1-16      n/a  ties-lowest      4
Cysteinyl-zotadirsen         FY4SL5AU9C    26      6    1     -  DMD                  0       0       0       1   1-16      n/a  ties-lowest      4
Pixofisiran-sodium.1         8QFS4BAH6H    25      1    1     -  CCDC97               0       0       0       1   1-16      n/a  ties-lowest      4
Pixofisiran.1                O5QC3YP0M7    25      1    1     -  CCDC97               0       0       0       1   1-16      n/a  ties-lowest      4
Zotadirsen                   K4T33W5J4B    26      6    1     -  DMD                  0       0       0       1   1-16      n/a  ties-lowest      4
DEMATIRSEN                   51FM0REX6F    25     19    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      5
ELUFORSEN                    V30WFP6S2Y    33     26    1     -  CFTR                 0       0       0       0   1-17      n/a  ties-all-16      7
ELUFORSEN-SODIUM             RIY0DS613M    33     26    1     -  CFTR                 0       0       0       0   1-17      n/a  ties-all-16      7
ETEPLIRSEN                   AIW6036FAS    30     20    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      7
GOLODIRSEN                   033072U4MZ    25     19    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      5
LUFEPIRSEN                   OKA0O253JZ    30      9    2     -  GJA1,GJA1P1          0       0       0       0   1-17      n/a  ties-all-16      6
RADAVIRSEN                   9P30PF804H    30     20    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      7
Rostudirsen                  3AR55D4G2D    30     20    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      7
VESLETEPLIRSEN               F6U7EZ3N1Q    30     20    1     -  DMD                  0       0       0       0   1-17      n/a  ties-all-16      7
* UNDESIGNED-20MER-10        -             20      2    1     -  TSSC4              238     203     635    1543      2      374  inside           2
DYN-101                      NZL8REY4K6    16      1    1  weak  DNM2             54302   47330   80103  142374      2      677  inside           0
DYN-101-FREE-ACID            6470267545    16      1    1  weak  DNM2             54302   47330   80103  142374      2      677  inside           0
ZILGANERSEN                  AXQ9493NT2    20      2    1     -  GFAP               324     141     787    1355      3      411  inside           2
ZILGANERSEN-SODIUM           37YVE86ZYS    20      2    1     -  GFAP               324     141     787    1355      3      411  inside           2
* UNDESIGNED-20MER-16        -             20     13    1     -  DSN1               213     135     508    1337      4      419  inside           2
FAZIRSIRAN-SODIUM.2          3LN5C15FP2    21     60    1     -  SERPINA1            57      15     114     432      5      500  inside           3
FAZIRSIRAN.2                 V20IVC0OGQ    21     60    1     -  SERPINA1            57      15     114     432      5      500  inside           3
FRENLOSIRSEN                 J2Y9QT3BWL    16      5    1     -  IRF4             38113   25098   49006   74818      5      777  inside           1
FRENLOSIRSEN-SODIUM          J2MMX1VR5I    16      5    1     -  IRF4             38113   25098   49006   74818      5      777  inside           1
GTI-2501                     G9AU73Z0Y0    20     10    1     -  RRM1               146      26     332     705      6      439  inside           3
* UNDESIGNED-20MER-17        -             20      7    1     -  ZC3H12B           1117     525    1765    2771      7      632  inside           2
Tonlamarsen                  W6YJ85G6YG    16     18    1     -  AGT              36181   16842   50816  101227      7      712  inside           1
Tonlamarsen-Sodium           28GMY2R77H    16     18    1     -  AGT              36181   16842   50816  101227      7      712  inside           1
* UNDESIGNED-20MER-01        -             20      2    1     -  DDX11L16           374      50     444    2138      7      842  inside           2
EVAZARSEN-SODIUM             W3077QR2KG    20     18    1     -  AGT                273      47     297     970      7      919  inside           2
Evazarsen                    P048YHG804    20     18    1     -  AGT                273      47     297     970      7      919  inside           2
Onvuzosiran-sodium.2         T4XC2DH9BM    23     20    2     -  ENSG00000290         2       0       3      34      8      666  inside           3
Onvuzosiran.2                MC7ZD4X9KB    23     20    2     -  ENSG00000290         2       0       3      34      8      666  inside           3
TRABEDERSEN                  98OYR854NY    18      4    1     -  TGFB2             4231    1425    4901   17988      8      863  inside           1
TRABEDERSEN-SODIUM           Q037WFO97F    18      4    1     -  TGFB2             4231    1425    4901   17988      8      863  inside           1
INCLISIRAN-SODIUM.2          UPC6BTX7PY    23     15    1     -  PCSK9               51       6      56     137      8      910  inside           3
INCLISIRAN.2                 UOW2C71PG5    23     15    1     -  PCSK9               51       6      56     137      8      910  inside           3
* UNDESIGNED-20MER-06        -             20      1    1     -  MALINC1            348     101     365     775      8      953  inside           2
LSP-GR3                      DAGM66PSEW    20      3    1     -  GRIA1              282      51     333    1199    8-9      846  inside           3
OLPASIRAN.2                  8M4GC1EOB4    21      4    1     -  LPA                 71       8      76     276      9      934  inside           2
OBLIMERSEN                   85J5ZP6YSL    18      8    1     -  BCL2              5616    2883    5897   19064      9      952  inside           1
OBLIMERSEN-SODIUM            SH55B0RQ9K    18      8    1     -  BCL2              5616    2883    5897   19064      9      952  inside           1
Nucresiran.1                 MCT9H26JQY    23     16    1     -  TTR                 13       0      13      92   9-11     1000  inside           3
AR-177                       E3YZ3E0CZ6    17      3    1     -  TRPA1            66369   47372   66321  144387     10     1000  inside           0
AR-177-FREE-ACID             RR07N525H5    17      3    1     -  TRPA1            66369   47372   66321  144387     10     1000  inside           0
PELACARSEN                   LSO9H7UZ90    20      3    1     -  LPA                664     249     662    2348     10     1003  inside           2
PELACARSEN-SODIUM            D1J27662O8    20      3    1     -  LPA                664     249     662    2348     10     1003  inside           2
* UNDESIGNED-20MER-09        -             20     55    1     -  LINC01505          659     149     642    3265     10     1026  inside           2
* UNDESIGNED-20MER-14        -             20      3    2     -  ABHD17AP6,CC      1550     365    1508    3413     10     1027  inside           2
LADEMIRSEN                   KKQ6AQN9LH    19     36    2     -  MIR21,VMP1        1707     519    1587    4290     10     1075  inside           2
LADEMIRSEN-SODIUM            UWG3VFQ5CQ    19     36    2     -  MIR21,VMP1        1707     519    1587    4290     10     1075  inside           2
BALIFORSEN                   DR9CF3915M    16     68    1     -  DMPK             36829   13294   33250   99777     10     1107  inside           0
BALIFORSEN-SODIUM            JAC5IJI520    16     68    1     -  DMPK             36829   13294   33250   99777     10     1107  inside           0
* UNDESIGNED-20MER-13        -             20      3    1     -  AEN               2765    1207    2611    5313     11     1058  inside           2
Ultevursen                   94AC8YWE3I    21      4    1     -  USH2A              197      51     186     310     11     1059  inside           2
VUPANORSEN                   A7YG62NHZ6    20     22    1     -  ANGPTL3            328      68     287     900     11     1142  inside           2
VUPANORSEN-SODIUM            X70RY8Q6LI    20     22    1     -  ANGPTL3            328      68     287     900     11     1142  inside           2
ISIS-333611                  5QY760I44W    20     22    1     -  SOD1               818     158     694    1455     11     1178  inside           2
GATAPARSEN                   895O8QKF18    18     11    1     -  BIRC5             9938    4449    7867   60741     11     1263  inside           1
GATAPARSEN-SODIUM            3KY0EUQ36S    18     11    1     -  BIRC5             9938    4449    7867   60741     11     1263  inside           1
Fesomersen                   0CF4C9C787    20     39    1     -  F11                401      60     276     732     11     1452  inside           2
Fesomersen-Sodium            D8IRN5V2N6    20     39    1     -  F11                401      60     276     732     11     1452  inside           2
ISIS-5132                    48IAF3FDP3    20     84    1     -  RAF1               524     160     328    2455     11     1597  inside           2
Zorevunersen                 U4YV46D2DT    18      1    1  weak  SCN1A             5364    2450    5057    7510     12     1060  inside           2
Zorevunersen-Sodium          XBZ2D4R7RF    18      1    1  weak  SCN1A             5364    2450    5057    7510     12     1060  inside           2
CEPADACURSEN                 UGH88FK62E    16     15    1     -  PCSK9            82329   26476   70922  110729     12     1160  inside           1
CEPADACURSEN-SODIUM          H31ZZO36P5    16     15    1     -  PCSK9            82329   26476   70922  110729     12     1160  inside           1
GTI-2040                     5WY0FWR2CF    20     19    2     -  RRM2,RRM2P2        335      39     265     592     12     1264  inside           2
Vortosiran.2                 K4A9V4HK29    19      1    1     -  F11-AS1           1540     650    1190    3354     12     1294  inside           2
APATORSEN                    IFJ6X26JW6    20     21    3     -  ENSG00000295       738     232     557    2087     12     1324  inside           2
APATORSEN-SODIUM             3N4G7RE66Y    20     21    3     -  ENSG00000295       738     232     557    2087     12     1324  inside           2
DANVATIRSEN                  31N550RD05    16    108    1     -  STAT3            58725   11005   42059  101621     13     1396  inside           1
DANVATIRSEN-SODIUM           S6A2UYH57V    16    108    1     -  STAT3            58725   11005   42059  101621     13     1396  inside           1
ISIS-2503                    I444I66XWH    20     34    1     -  HRAS               758     157     541    1128     13     1401  inside           2
Sefaxersen                   T87K47QVF3    20     90    1     -  CFB               1272     407     864    3744     13     1472  inside           2
Sefaxersen-Sodium            37KI8XF3IH    20     90    1     -  CFB               1272     407     864    3744     13     1472  inside           2
TOMINERSEN                   7QI41X9QWC    20     10    1     -  HTT                685      86     386    1740     13     1774  inside           2
TOMINERSEN-SODIUM            5EO3CIJ3H7    20     10    1     -  HTT                685      86     386    1740     13     1774  inside           2
* UNDESIGNED-20MER-03        -             20     17    1     -  DOK1              1138     146     551    3610     13     2065  inside           2
Surbisiran-sodium.1          5P48P9MZ7W    23     69    1     -  CTNNB1              21       0       9      90     13     2333  inside           3
Surbisiran.1                 52DE7VG9RG    23     69    1     -  CTNNB1              21       0       9      90     13     2333  inside           3
TEPRASIRAN-SODIUM.2          ME0IRL7KDY    19     36    1     -  TP53              2460     512    1998    4194     14     1231  inside           2
TEPRASIRAN.1                 O03W5S19PJ    19     36    1     -  TP53              2460     512    1998    4194     14     1231  inside           2
ALTERNATIVE-DEFINITION-for-[ -             20      2    1     -  ITGA4             2066     421    1306    2785     14     1581  inside           1
Mulnitorsen                  0DYR6BJ4AG    18      1    1  weak  ENSG00000243     10450    2316    6121   13609     14     1707  inside           1
Mulnitorsen-sodium           T7OK5U7J41    18      1    1  weak  ENSG00000243     10450    2316    6121   13609     14     1707  inside           1
Renadirsen                   4RW6WRD7SW    18     20    1     -  DMD              10320    1576    5737   20987     14     1798  inside           1
Renadirsen-sodium            H5MKY4U4D5    18     20    1     -  DMD              10320    1576    5737   20987     14     1798  inside           1
Cibrigirsen                  3GMW696ZDY    18      3    1     -  IGF1R             8531    1788    4389   14522     14     1943  inside           1
* UNDESIGNED-20MER-04        -             20      4    1     -  NKTR              5413    2509    4688    6872     15     1154  inside           1
Basivarsen-lysine            2LVD3H594X    16     59    1     -  DMPK             84248   25723   50670  104462     15     1662  inside           0
* UNDESIGNED-20MER-11        -             20      8    1     -  PIK3C2G            764      48     428    1170     15     1785  inside           2
Apazunersen                  ABG25J5B9G    18     31    1     -  SNHG14            8556     960    4773    9177     15     1792  inside           1
Apazunersen-Sodium           B5PZX5263H    18     31    1     -  SNHG14            8556     960    4773    9177     15     1792  inside           1
MIPOMERSEN                   9GJ8S4GU0M    20      7    1     -  APOB              1128     153     623    5514     15     1810  inside           2
MIPOMERSEN-SODIUM            18EAY4870E    20      7    1     -  APOB              1128     153     623    5514     15     1810  inside           2
Dimovarsen                   R992QCR8LX    16      1    1  weak  MIR132           65463   14632   33417   72499     15     1958  inside           1
Dimovarsen-sodium            ZLL6RQ8PJ8    16      1    1  weak  MIR132           65463   14632   33417   72499     15     1958  inside           1
COBITOLIMOD                  328101264R    19     26    1     -  RELA              2670     166     979    8258     15     2727  inside           2
COBITOLIMOD-SODIUM           WWI522K8NY    19     26    1     -  RELA              2670     166     979    8258     15     2727  inside           2
* UNDESIGNED-20MER-12        -             20    157    3     -  DUXAP10,DUXA       961      13     308    1549     15     3120  inside           3
LUMASIRAN-SODIUM.2           67P6XH37HD    23     12    1     -  HAO1                79       0      21     217     15     3761  inside           3
LUMASIRAN.2                  RZT8C352O1    23     12    1     -  HAO1                79       0      21     217     15     3761  inside           3
ALN-3133.2                   5SZR36WXJ8    23     24    1     -  VEGFA               31       0       5      51     15     6200  inside           3
ATU-027.2                    IFJ2SAK127    23     14    1     -  PKN3                24       0       0      41  15-16      n/a  inside           3
TEMAVIRSEN                   KK8BAN51PF    19      5    2     -  MIR122,MIR12      2894     482    1809    4008     16     1599  inside           1
TEMAVIRSEN-SODIUM            KBG15GFL2Z    19      5    2     -  MIR122,MIR12      2894     482    1809    4008     16     1599  inside           1
ISIS-104838                  8BLG99WDHS    20      9    1     -  TNF                809      59     442    1168     16     1830  inside           2
EPLONTERSEN                  0GRZ0F5XJ6    20     16    1     -  TTR                799     120     393     958     16     2033  inside           2
EPLONTERSEN-SODIUM           WSP2DHR2BD    20     16    1     -  TTR                799     120     393     958     16     2033  inside           2
INOTERSEN                    0IEO0F56LV    20     16    1     -  TTR                799     120     393     958     16     2033  inside           2
INOTERSEN-SODIUM             950736UC77    20     16    1     -  TTR                799     120     393     958     16     2033  inside           2
CENERSEN                     K6KJ8AZ05F    20     34    1     -  TP53              7324    1689    3334    8217     16     2196  inside           1
CENERSEN-SODIUM              CI002S7WH8    20     34    1     -  TP53              7324    1689    3334    8217     16     2196  inside           1
ATESIDORSEN                  015582E098    20     42    1     -  GHR               1454     191     653    1460     16     2226  inside           1
ATESIDORSEN-SODIUM           F3H59ON671    20     42    1     -  GHR               1454     191     653    1460     16     2226  inside           1
Nivudirsen                   34LVJ6J2YV    18     20    1     -  DMD               5816     942    2510    6209     16     2317  inside           2
Elsunersen                   Y7F46E73CU    20     16    1     -  SCN2A             1607     163     650    1857     16     2472  inside           2
Elsunersen-sodium            646C2NRN3Y    20     16    1     -  SCN2A             1607     163     650    1857     16     2472  inside           2
Salanersen                   PTC9GTD4E7    18      9    2     -  SMN1,SMN2        10094    1307    3998   12209     16     2524  inside           1
Salanersen-sodium            ZMD5T5JL27    18      9    2     -  SMN1,SMN2        10094    1307    3998   12209     16     2524  inside           1
VEGLIN-3                     HUT057OOE6    21     24    1     -  VEGFA              267      23     105     336     16     2542  inside           3
TOFERSEN                     2NU6F9601K    20     24    1     -  SOD1              1291      94     488    1427     16     2645  inside           1
TOFERSEN-SODIUM              5YL205692C    20     24    1     -  SOD1              1291      94     488    1427     16     2645  inside           1
Ulefnersen                   TND56EA1LE    20      1    1     -  FUS               1049     220     393    1513     16     2669  inside           2
Ulefnersen-Sodium            EOL499F0PD    20      1    1     -  FUS               1049     220     393    1513     16     2669  inside           2
* UNDESIGNED-20MER-05        -             20     62    1     -  OCIAD1            1808     137     618    2243     16     2925  inside           2
PF-655-free-acid.1           CA2Z9MMW44    19      1    1     -  DDIT4-AS1         2894     239     907    3395     16     3190  inside           2
DONIDALORSEN                 ZD4D8M32TL    20     21    2     -  ENSG00000290       876     132     272     936     16     3220  inside           2
DONIDALORSEN-SODIUM          Y30VEG5PH1    20     21    2     -  ENSG00000290       876     132     272     936     16     3220  inside           2
RIMIGORSEN                   U93T57CW3M    20      6    1     -  DMD               1236      12     320    1432     16     3862  inside           1
BEVASIRANIB-SODIUM.2         II3PQ3910V    21     24    1     -  VEGFA              677      36     103     756     16     6572  inside           2
BEVASIRANIB.2                DGN36694W4    21     24    1     -  VEGFA              677      36     103     756     16     6572  inside           2
BAMOSIRAN.2                  C8Q2RMU41O    21      1    1     -  ADRB2              360       2      41     454     16     8780  inside           2
FITUSIRAN-SODIUM.2           A2PQ8BS44A    23     19    1     -  SERPINC1            96       0       9     120     16    10666  inside           2
FITUSIRAN.1                  SV9W47ZLE1    23     19    1     -  SERPINC1            96       0       9     120     16    10666  inside           2
VARODARSEN                   IU91PBD829    25     20    1     -  DMD                  2       0       0       2  16-17      n/a  ties-highest     4
MONGERSEN                    O1VIU3R1NE    21      6    1     -  SMAD7              837     260     556     814     17     1505  ABOVE-all-16     2
MONGERSEN-SODIUM             Z894KE4P3E    21      6    1     -  SMAD7              837     260     556     814     17     1505  ABOVE-all-16     2
PREXIGEBERSEN                8W1O4Y961B    18     29    1     -  GRB2              7195    1711    4639    7032     17     1550  ABOVE-all-16     1
PREXIGEBERSEN-SODIUM         1P6F634GJN    18     29    1     -  GRB2              7195    1711    4639    7032     17     1550  ABOVE-all-16     1
LEXANERSEN                   AMW2VPZ3XD    20      6    1     -  HTT               1374      73     513     936     17     2678  ABOVE-all-16     1
LEXANERSEN-SODIUM            RV6BTB6SX2    20      6    1     -  HTT               1374      73     513     936     17     2678  ABOVE-all-16     1
Marpinersen                  JZ0VQQ1YLD    20     80    1     -  ATXN2             2376     268     874    2273     17     2718  ABOVE-all-16     2
SEPOFARSEN                   7CAZ46X8EL    17     11    3     -  CTNNA1,ENSG0     33862    3095   12191   27273     17     2777  ABOVE-all-16     1
SEPOFARSEN-SODIUM            EW9I3PJC3R    17     11    3     -  CTNNA1,ENSG0     33862    3095   12191   27273     17     2777  ABOVE-all-16     1
* UNDESIGNED-20MER-02        -             20      4    1     -  S100A13           1176     100     405     928     17     2903  ABOVE-all-16     2
ALICAFORSEN                  J8435V445B    20      8    1     -  ICAM1              995      61     332     834     17     2996  ABOVE-all-16     2
ALICAFORSEN-SODIUM           4TWN6SZB8W    20      8    1     -  ICAM1              995      61     332     834     17     2996  ABOVE-all-16     2
ISIS-463588                  YJ4APB5MQC    20     69    1     -  FGFR4             2236     209     733    2106     17     3050  ABOVE-all-16     2
Divesiran.1                  6WZ4756CFE    19     40    1     -  TMPRSS6           6039    1041    1919    4869     17     3146  ABOVE-all-16     2
OLEZARSEN                    S3RS2SA30L    20     38    1     -  APOC3             2768     379     769    1865     17     3599  ABOVE-all-16     2
OLEZARSEN-SODIUM             NSY2BY6PSB    20     38    1     -  APOC3             2768     379     769    1865     17     3599  ABOVE-all-16     2
VOLANESORSEN                 2O4BE0K238    20     38    1     -  APOC3             2768     379     769    1865     17     3599  ABOVE-all-16     2
VOLANESORSEN-SODIUM          6JON30SLDT    20     38    1     -  APOC3             2768     379     769    1865     17     3599  ABOVE-all-16     2
COSDOSIRAN.2                 88SN5KG5CH    19     10    1     -  CASP2             4112     424    1134    3070     17     3626  ABOVE-all-16     2
NULABEGLOGENE-AUTOGEDTEMCEL- AAC95PP873    20     18    1     -  HBB               1501      36     410    1123     17     3660  ABOVE-all-16     1
VILTOLARSEN                  SXA7YP6EKX    21     19    1     -  DMD                298      18      80     188     17     3725  ABOVE-all-16     2
DRISAPERSEN                  73D586DAMF    20     20    1     -  DMD               1895      73     474    1258     17     3997  ABOVE-all-16     2
DRISAPERSEN-SODIUM           SDA7197G7Q    20     20    1     -  DMD               1895      73     474    1258     17     3997  ABOVE-all-16     2
SUVODIRSEN                   IBX8A21EH6    20     20    1     -  DMD               1895      73     474    1258     17     3997  ABOVE-all-16     2
SUVODIRSEN-SODIUM            P9Z955DK1E    20     20    1     -  DMD               1895      73     474    1258     17     3997  ABOVE-all-16     2
SAPABLURSEN                  DXS4HJC32N    20     42    1     -  TMPRSS6           1372      57     327     716     17     4195  ABOVE-all-16     2
SAPABLURSEN-SODIUM           6BGP5P5P2C    20     42    1     -  TMPRSS6           1372      57     327     716     17     4195  ABOVE-all-16     2
* UNDESIGNED-20MER-15        -             20     12    1     -  CREB3L3           2136      19     505    1899     17     4229  ABOVE-all-16     1
TOP-1731                     78OY93506O    21     23    1     -  PDE7A              320       3      68     287     17     4705  ABOVE-all-16     2
TOP-1731-SODIUM              MPO30R855B    21     23    1     -  PDE7A              320       3      68     287     17     4705  ABOVE-all-16     2
Tivanisiran-Sodium.2         PX4Q8LA7G6    19     14    2     -  ENSG00000262      6437     678    1322    2890     17     4869  ABOVE-all-16     1
Tivanisiran.2                2H47U2SBVO    19     14    2     -  ENSG00000262      6437     678    1322    2890     17     4869  ABOVE-all-16     1
* UNDESIGNED-20MER-07        -             20      6    1     -  RSPH3             1720      99     344    1256     17     5000  ABOVE-all-16     2
PF-655-free-acid.2           CA2Z9MMW44    19      8    1     -  DDIT4             4767     167     883    1923     17     5398  ABOVE-all-16     2
* UNDESIGNED-20MER-08        -             20      8    3     -  ENSG00000283     11773     608    2091    8151     17     5630  ABOVE-all-16     1
MG-98-SODIUM                 WY6BRA7LVZ    20     40    1     -  DNMT1             1741      72     254    1290     17     6854  ABOVE-all-16     1
ARCHEXIN                     4TEW51C830    20    121    1     -  AKT1              2955     123     360    1978     17     8208  ABOVE-all-16     2
CUSTIRSEN                    L26E95NLRK    21     92    1     -  CLU               1675      11      84     196     17    19940  ABOVE-all-16     3
CUSTIRSEN-SODIUM             ILE26V76EB    21     92    1     -  CLU               1675      11      84     196     17    19940  ABOVE-all-16     3
REVUSIRAN.2                  ZE6EHM8Z3A    23     16    1     -  TTR                173       0       6      42     17    28833  ABOVE-all-16     3
VUTRISIRAN-SODIUM.2          28O0WP6Z1P    23     16    1     -  TTR                173       0       6      42     17    28833  ABOVE-all-16     3
VUTRISIRAN.2                 GB4I2JI8UI    23     16    1     -  TTR                173       0       6      42     17    28833  ABOVE-all-16     3
Pixofisiran-sodium.2         8QFS4BAH6H    25     16    1     -  TGFB1               25       0       0       0     17      n/a  ABOVE-all-16     5
Pixofisiran.2                O5QC3YP0M7    25     16    1     -  TGFB1               25       0       0       0     17      n/a  ABOVE-all-16     5
```

## What the ranking found

### Designed specificity, named, at full magnitude

```
DISPOSITION at 4 mismatches — the six are exhaustive and mutually exclusive
  BELOW-all-16   :     2 families
  ties-lowest    :     8 families
  inside         :   122 families
  ties-highest   :     1 family
  ABOVE-all-16   :    44 families
  ties-all-16    :     9 families
```

**Two families pair in fewer places than every one of the sixteen rearrangements of their own
bases** — and they are two registrations of one sequence, the guide strand of zerlasiran, an siRNA
against *LPA*:

```
  Zerlasiran-Sodium.2             C9WT9B9PXP   L=19  off=    965  controls 991-4089  rank 1
  Zerlasiran.2                    FBX7PTD863   L=19  off=    965  controls 991-4089  rank 1
```

Say it at full magnitude, because this is the success. **965 near-complementary windows outside
*LPA* and *LPAL2*, against a control minimum of 991 and a control maximum of 4,089.** Not one of
the sixteen rearrangements of those same nineteen bases pairs in as few places. Its specificity is
a property of the **order** its bases were chosen in — not of which bases they are — and that was
measurable in integers before the molecule was ever synthesised. Zerlasiran's *passenger* strand,
registered beside it as `Zerlasiran.1`, carries no perfect complement anywhere and is REFUSED: the
guide strand is the designed half, and the instrument reads that off the transcriptome rather than
off the label.

Zilganersen — the drug the sibling page screened alone — sits at **rank 3 of 17, `inside` its
control range**: 324 windows against a control median of 787, range 141 to 1,355. That is the same
verdict the single-drug screen published, reproduced here by a different program on the same public
bytes, and it is *not* the headline claim. It is a low-quartile result inside its own composition
class, which is what the sibling page said it was.

### Inside their control range — 122 families, and this is not a safety finding

**122 of the 186 screened families are `inside`** — their off-target burden is indistinguishable
from what their base composition forces, sitting somewhere between the least and most burdened
rearrangement of their own bases. **Forty-four pair in more places than every rearrangement of
their own bases.** Nine tie all sixteen.

Every one of those is a measurement of one discrete property of a sequence.
**It is not a safety finding.** It is not a statement about any medicine's effect on any person,
and nothing on this page should change anyone's treatment. RNase H1 recruitment, RISC loading,
whether the site is accessible in a folded transcript, whether the gene is even expressed in the
tissue the drug reaches — every one of those sits between this integer and a patient, and none of
them is in this program.

## The tie rule, and what one comparison operator did to this study

This is the correction that matters most, and it is stated in full because the previous version of
this page got it wrong in the one direction a safety instrument must not err in — toward crediting
medicines with designed specificity nobody measured.

The previous build ranked a strand as `1 + #{controls strictly below it}`. Under that rule a family
in which the strand and **all sixteen** of its permutations score exactly the same is awarded rank
1, and rank 1 was then printed as *"pairs in fewer places than every one of the 16 rearrangements
of its own bases"*. It does not. It paired in the **same** number of places.

```
THE TIE RULE, AND WHAT IT DOES TO THE HEADLINE
  families whose rankLo is 1 (ties favour the strand)      : 19
  families STRICTLY below all 16 controls (rank exactly 1-1): 2
  the difference is 17 families that TIED at least one permutation, and
  9 of them tied ALL 16 — every arm of the comparison scoring the same number,
  which is not fewer places, it is the same number of places.
```

**Nineteen against two, from one comparison operator, with every other arm in the instrument
green.** Nine of the seventeen tied families tie at exactly zero: DEMATIRSEN, ELUFORSEN (×2),
ETEPLIRSEN, GOLODIRSEN, LUFEPIRSEN, RADAVIRSEN, Rostudirsen, VESLETEPLIRSEN — all 25 to 33 bases
long, all printing `off=0 cmin=0 cmed=0 cmax=0`.

The repair is not a softer sentence, it is a different number and a different column: the rank is
now an interval, `1-17` says on its face that the family cannot be ranked at this threshold, and
the headline is read off the **disposition** rather than off a rank integer. Both counts are
printed on every run, by an arm whose whole job is that they can never disagree silently again.

## Reading a family at a threshold where the comparison exists

A comparison in which every arm scores zero has no resolving power, and a 30-mer at four mismatches
is exactly that. So every family also carries **kRes** — the smallest number of mismatches at which
its own sixteen controls do not all agree with each other. The complete histogram is published
either way, so this is a reading of arithmetic already done, not a second screen.

```
READ AT EACH FAMILY'S OWN RESOLVING THRESHOLD — the smallest k where its controls disagree
  families with a resolving threshold          : 186 of 186
  families with NONE anywhere in 0...L         : 0
  distribution of that threshold:
    k= 0 :     7 families
    k= 1 :    50 families
    k= 2 :    87 families
    k= 3 :    23 families
    k= 4 :     8 families
    k= 5 :     4 families
    k= 6 :     1 family
    k= 7 :     6 families
  STRICTLY below all 16 controls at their own resolving k : 0
  ABOVE all 16 controls at their own resolving k          : 23
```

And this is where the nine zero-tied families become readable rather than empty. ETEPLIRSEN's
complete off-target histogram, outside *DMD*:

```
substance                       L           m0     m1     m2     m3     m4     m5     m6     m7     m8        worse
ETEPLIRSEN                     30            0      0      0      0      0      0      0     51     73   1460284003
```

**Across 1,460,629,903 scoreable 30-mer windows there is not one place outside *DMD* that pairs
with eteplirsen at six mismatches or better.** The nearest thing in the entire human transcriptome
is seven mismatches out of thirty. In absolute terms that is a striking number, and it is a
property four mismatches cannot see at all — for the strand *or* for its controls — which is
exactly why the old rank 1 was empty.

**And the comparison, once it can be made, does not go the way the old rank 1 implied.** At
eteplirsen's own resolving threshold of seven mismatches the strand carries **51** windows and its
sixteen permutations carry between **0 and 20**: it is `ABOVE-all-16`, not below. Its absolute
burden is remarkably small and its burden *relative to its own composition class* is the largest in
that class. Both are measurements of one discrete property; neither is a safety finding, and
neither says anything about a boy who takes this medicine. What they do say together is that a
family scoring zero against zero has not been measured yet, and that reading it at rank 1 was the
error.

Across the whole registry the same reading is stark: **0 of 186 families are strictly below all
sixteen of their controls at their own resolving threshold, and 23 are above all sixteen.**

## What the refusals mean

**266 registry strands carry no perfect complement anywhere in GENCODE v50 and are REFUSED.** That
is not a clean result and must never be read as one. The honest reasons: the registry publishes the
**sense** strand of a double-stranded medicine and its partner carries the target (zerlasiran,
inclisiran and fazirsiran each appear this way, `.1` refused and `.2` screened); the target is viral
or otherwise absent from GENCODE; the molecule is an aptamer, which binds a protein and not a
transcript, so complementarity has nothing to say about it; or the sequence carries chemistry a base
string cannot represent.

**19 are NOT_KNOWN** — short enough that a perfect complement is expected by chance, so finding one
is no evidence of a designed target.

**18 are UBIQUITOUS**, above.

Absence, refusal, ubiquity and not-known are four different answers. None of them is zero.

## The design instrument — the half that reaches a patient not yet dosed

This is the transferable result, and it does not depend on any molecule on the list above.

**Any candidate oligonucleotide can be ranked against its own composition class before it is
synthesised.** Write the sequence; the program permutes its own bases sixteen ways, screens all
seventeen probes against every window of a public transcriptome, and returns an integer rank, a
disposition, a resolving threshold and a complete mismatch histogram. It costs **one pass over a
public file**. There is no cutoff to choose, no parameter to tune, no e-value, no random seed and
no floating-point number anywhere on the decision path — so it returns the same integers on every
machine, in every laboratory, forever, and a regulator can re-derive it years later without
trusting whoever produced it.

That is a screen a chemist can run on a hundred candidate walks across a target transcript, in an
afternoon, before choosing which one to make. The registry ranking above is what that instrument
says about the molecules that already exist; the instrument itself is what it can say about the
ones that do not exist yet.

Both halves of the arithmetic are already there in the run: **717,027,798,090 probe-windows in the
first sweep and 4,638,850,669,668 in the second**, every one of them counted as it happened by
summing the histogram bins each window incremented, and checked against an independently
accumulated per-length window census. A short count is a refusal, not a footnote.

## The call

**What we call.** Of 472 registry strands, **169 had a target the instrument could measure** and
were screened against sixteen permutations of their own bases. **Two of them — one sequence, the
guide strand of zerlasiran, under two registrations — pair in strictly fewer places than every one
of those sixteen rearrangements.** That is designed specificity, it is a property of the order the
bases were chosen in, and it is measurable in integers before synthesis. **122 families are
indistinguishable from their own composition**, 44 pair in more places than every rearrangement of
their own bases, 9 tie all sixteen, and 17 undesigned control sequences drawn by a fixed rule from
the same corpus put those numbers in a scale: **none of the seventeen is below its own controls
either.**

**What we refuse to call.** We do not call any molecule on this page safe, and we do not call any
of them unsafe. A near-complementary window is a place a molecule COULD pair — not a cut, not an
occupancy, not a clinical event. **A high rank is not a safety finding and a low rank is not a
clearance.** We refuse to publish an off-target burden for a sequence whose perfect complement is
in 141 genes or more, because the subtraction that produces such a figure is meaningless. We refuse
to call a family "more specific than its permutations" when it tied them, which is what the
previous version of this page did nineteen times where the honest count is two. And we refuse to
call an excluded strand clean: 266 refusals, 19 not-knowns and 18 ubiquitous rows are three
different silences, none of which is a zero.

**Where the chemistry half sits, and it is not here.** Phosphorothioate backbone binding to plasma
and cell-surface proteins, complement activation, thrombocytopenia, the aseptic meningitis that
sits on real intrathecal labels — none of that is a sequence match, no base search predicts any of
it, and this program does not try. These are medicines real people take, some of them children,
intrathecally, for decades. This page measures one discrete property of a sequence and nothing
else.

**Where a bench should point.** Three places, in order. First, the nine families that tie all
sixteen controls at four mismatches — every one of them 25 to 33 bases long. Four mismatches cannot
read them at all, and at their own resolving thresholds the picture is not the flattering one: for
ETEPLIRSEN, nothing at all within six mismatches of it across 1.46 billion windows, and yet at
seven mismatches 51 windows against permutations carrying 0 to 20. A long strand buys an enormous
absolute margin; whether it buys anything *relative to its own bases* is a separate question, and
on this evidence it does not. That is where a design programme working on 25-mers and 30-mers
should look first. Second, the eight rows flagged `weak`,
whose measured target rests on a single perfect complement at a length where a third (L = 16) or a
fiftieth (L = 18) of arbitrary sequences would carry one; the target assignment there wants an
orthogonal check, not a longer screen. Third, the 44 families above every one of their own
permutations: the question a laboratory can ask that this program cannot is whether any of those
near-complementary windows is in a transcript that is actually expressed, actually accessible, and
actually cleaved — which is a bench question, and the coordinates are published for exactly that
reason.

## Two programs, written separately, returning the same integers

The ranking above comes from a screen that packs a window into a 64-bit register and counts
mismatches with one exclusive-or and a population count. A second program in this directory,
`reproduce/verify-one-family.swift`, does the same arithmetic the obvious way — one position at a
time, one integer comparison per position, no packed register, no popcount, no interleaved
histogram — and screens one family and its sixteen permutations across the whole transcriptome. Its
only job is to disagree with the main instrument if the main instrument is wrong. The permutation
rule is re-implemented in it from the declared constants rather than shared, because two
implementations of one declared law is the only way a re-implementation checks anything.

On the headline family it agrees to the integer:

```
probe                 : ATAACTCTGTCCATTACCG  (L=19)   [zerlasiran guide strand]
scoreable windows     : 1468006855
perfect complements   : 11        measured target genes : LPA,LPAL2

STRAND ATAACTCTGTCCATTACCG   m0=0 m1=0 m2=0 m3=53 m4=912  ->  <=4 : 965
  control burdens, sorted   : 991 1002 1007 1026 1051 1053 1150 1250
                              1554 1621 1667 1838 1950 2383 2950 4089
  controls strictly BELOW the strand  : 0
  controls EXACTLY EQUAL to the strand: 0
  rank interval                       : 1 of 17
  disposition                         : BELOW-all-16
```

And on the family that broke the previous headline it settles the question directly:

```
probe                 : CTCCAACATCAAGGAAGATGGCATTTCTAG  (L=30)   [eteplirsen]
  strand burden                       : 0
  control burdens, sorted             : 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  controls strictly BELOW the strand  : 0
  controls EXACTLY EQUAL to the strand: 16
  rank interval                       : 1-17 of 17
  rank under 'ties favour the strand' : 1
  rank under 'ties count against it'  : 17
  disposition                         : ties-all-16
  resolving threshold kRes            : 7
  at kRes=7: strand 51, controls 0-20, rank 17, disposition ABOVE-all-16
```

Neither program was adjusted to agree with the other. The naive verifier was itself run twice,
from two builds that differ in how they reserve their input buffer, and its output on both families
is byte-identical between them; and it reproduces its own numbers at one thread and at sixteen,
because threads are a scheduling choice and every accumulator in it is a per-thread sum.

Its own marker, so a reader can pin its output the same way the main instrument's is pinned, and
so the harness refuses if either program's figures drift from what this page says:

```
MARKER  INDEPENDENT_VERIFIER_ONE_FAMILY
```

## One more property of the seal, found by accident

Between the first complete run and the published one, four display strings in the program were
repaired — a plain-language gloss that read *"about 562558 in every hundred arbitrary 9-mers"*,
a sensitivity list printed out of order, a plural, and a sentence that asserted a tendency instead
of printing the number it had measured. Nothing on the decision path changed.

**The two runs produced byte-identical seals.** The seal is computed over the measurement — every
strand, its burdens at every threshold, its rank interval, its disposition, its complete
histogram — and over nothing else: no path, no timing, no thread count, and none of the prose the
program prints around it. A cosmetic repair that moved four lines of English moved no digit of the
result, and the digest says so.

**And it held a second time, for a reason worth stating.** After the run was sealed, both programs
were given a block that prints the published figures on every exit path — including the refusal
path taken when no transcriptome arrives on standard input — so that the wiki's own harness can
check every number on this page from a clean clone without a 1.5 GB download. That edit changed
both source digests below and **no digit of the measurement**: the seal is still
`2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1`. The digests are published as
provenance, not as seal inputs, which is why one can move while the other cannot. A refusal that
prints nothing cannot be checked by anybody, and a figure nobody can check is a figure on trust.

## Reproduce

Nothing here is behind a login. Two files, two public inputs, no account and no data-use agreement.

```bash
# 1. the instrument, from a clean clone of this wiki
xcrun swiftc -O -swift-version 5 reproduce/registry-specificity-ranking.swift -o /tmp/rsr

# 2. the reference transcriptome, hashed before it is used
curl -sLO https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz
shasum -a 256 gencode.v50.transcripts.fa.gz
#   5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56

# 3. the strand table is found by walking outward from the working directory and from the
#    binary, so this works from anywhere inside the checkout; it may also be given as argv[1].
#    Its digest is pinned in the program and a mismatch is a refusal.
gunzip -c gencode.v50.transcripts.fa.gz | /tmp/rsr

# 4. the independent verifier — a deliberately naive scorer, one position at a time, no packed
#    register and no popcount, screening one family and its sixteen permutations
xcrun swiftc -O -swift-version 5 reproduce/verify-one-family.swift -o /tmp/vof
gunzip -c gencode.v50.transcripts.fa.gz | /tmp/vof ATAACTCTGTCCATTACCG              # zerlasiran guide
gunzip -c gencode.v50.transcripts.fa.gz | /tmp/vof CTCCAACATCAAGGAAGATGGCATTTCTAG   # eteplirsen
```

Given no corpus, or no strand table, the ranking program runs its nine pre-corpus arms,
**refuses**, prints the full reference-figure block, and **exits 2**. The verifier does the same.
Both print their published figures on **every** exit path, refusals included, so a reader who runs
either with nothing still sees the integers this page cites and can tell them apart from a run of
their own — and a harness grading by exit code cannot read a refusal as a success. Nine of those
figures are pinned in `reproduce/validate.sh`, which fails if a number on this page stops being
printed by the program that produces it.

## Seal

```
MARKER  REGISTRY_SPECIFICITY_RANKING__ORDER_NOT_COMPOSITION_SETS_THE_BURDEN

INPUTS — hashed by the program and verified, never asserted; a mismatch is a refusal
  strand table    all_nucleicacid.tsv             5135ebb89ca659c6cce26d749dfc1547c08c4e6fc959074b6b3ab67fc9862afb
  reference       gencode.v50.transcripts.fa.gz   5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56
  corpus as read  670670 transcripts, 79139 genes, 1480179158 bases
                  A=388150763 C=353906094 G=364371647 T=373650638 other=100016
  corpus fingerprint                              e8a4711ff3d52ffae59c8c36a3dd6477307e9c4e6562ead6039302a0056c9e98

INSTRUMENTS
  reproduce/registry-specificity-ranking.swift    06a1812b86c14822a75a6da618f33582f098ba61f72aca136886aad14d5a8b8b
  reproduce/verify-one-family.swift               8fccfadb8ad102e9b3cc1900b71ca311b2182b899e2ce9a8528a56c83a98f69b
  0 float type declarations, 0 float intrinsics, 0 absolute paths in either source

THE WORK, COUNTED AS IT HAPPENED
  probes            489 in sweep A, 3162 in sweep B
  probe-windows     717027798090 + 4638850669668 = 5355878467758
                    every one counted by summing the histogram bins each window incremented,
                    and checked against an independently accumulated per-length window census
  arms              9 pre-corpus + 8 corpus-dependent = 17, all PASS, count derived from the
                    list that ran

THE RESULT
  screened families 186   (169 registry strands + 17 undesigned constructed 20-mers)
  excluded          18 UBIQUITOUS, 266 REFUSED, 19 NOT_KNOWN — three silences, none of them zero
  at 4 mismatches   BELOW-all-16 2 | ties-lowest 8 | inside 122 | ties-highest 1 |
                    ABOVE-all-16 44 | ties-all-16 9
  at each family's own resolving threshold   0 BELOW-all-16, 23 ABOVE-all-16
  seal sha256                                     2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
```

**The seal is path-independent, and it was proven from two directories.** The screen was run
twice on the same public bytes: once from the checkout's `reproduce/` directory at 16 threads, once
from an unrelated directory whose copy of the strand table sits at a different path, at 12 threads.
The two 1,066-line transcripts differ on **exactly one line** — the one that prints the thread
count — and carry the **identical** seal. Nothing that reaches the digest is a path, a timing, a
thread count or a hostname; the accumulators are per-thread sums, so the merge is
order-independent and the answer does not depend on how many of them there were.

## Related

- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas) — WHERE every registry strand can pair.
- [The first treatment for Alexander disease — and the safety question that should be exact](The-Safety-Question-Made-Exact) — this control arm, built for one drug.
- [The exact CRISPR off-target map](CRISPR-Genome-Off-Target-Map) — the same discipline over the genome.
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
