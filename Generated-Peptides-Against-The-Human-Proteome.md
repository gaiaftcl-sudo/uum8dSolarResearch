# Are the generated cures new? 78,680 sequences, counted against the human proteome

*A generative pipeline produced 78,680 protein sequences and labelled them validated cures. One
question about them is exactly decidable and needs no model, no score and no judgement: do any of
them already exist in us? Every one of the 5,165,782 generated residues was matched against every
one of the 11,418,237 residues of the reviewed human proteome. Complete enumeration, integers only,
no sampling and no cutoff inside the arithmetic. The answer is an integer, and it is zero.*

## The question, and why it outlives the pipeline's own verdict

A corpus like this arrives carrying its own grade. Every row has a `confidence`, a `coherence`, an
`overall_score`, and a column called `validation_passed`. None of those can be checked by a reader,
because none of them is a measurement of anything outside the program that produced them.

Underneath them sits a question that does not depend on trusting the generator at all:

> **Does any of these sequences already exist in the human proteome, and how much of any single one
> of them does?**

That question is **discrete**. A sequence either occurs in the reference or it does not; a shared
substring is either 9 residues long or 10. There is no threshold to choose, no scoring matrix to
defend, and no place for a float to enter. It also governs how every other claim about the corpus
may be read. If these sequences were already in us, *novel therapeutic* would be the wrong phrase
for them, and any observed activity would have an ordinary explanation. If they are not, then
whatever else is unknown about them, their primary structure is new chemical matter.

## What this instrument sees, and what it is blind to — before any number

This is stated here, at the front, because it is the qualifier that governs the headline word and a
reader should meet it before the figures rather than after them.

**This screen measures exact substring identity and nothing else.** No gapped alignment, no
substitution scoring, no BLAST, no Smith-Waterman, no structural comparison. A generated sequence
80% identical to a human protein across its whole length — a substitution every fifth residue — caps
its exact runs at 4 and lands *below the observed floor of 5*, in the same place as a sequence that
shares nothing with us at all.

So **"novel" on this page means exactly one thing: shares no long exact substring with the reviewed
human proteome.** It does **not** mean *no homology*. It does not mean *no cross-reactivity*. It
does not mean *immunologically safe*. The instrument that answers the substitution question is a
gapped, scored alignment — **a different measurement, not a refinement of this one**, and it is the
next instrument to build.

The null model below carries the same blindness, deliberately: it is built on the same exact-match
statistic as the observation, so neither one can speak past it.

## What the file actually is, measured from its own columns

The brief that opened this study described 78,680 sequences "across twelve diseases." **That is the
wrong file, and the correction is loud because it changes what the numbers are about.**

Counted from `proteins_validated.csv` itself — by a program that now reads those columns rather than
describing them — all 78,680 rows carry one category, `Health - Cancer`, and one mechanism, `PPI
Inhibition (electrostatic disruption)`, over **sixteen cancer labels**:

| label | rows | label | rows |
|---|---:|---|---:|
| Colorectal Cancer | 4,932 | Breast Cancer | 4,917 |
| Kidney Cancer | 4,929 | Prostate Cancer | 4,917 |
| Esophageal Cancer | 4,926 | Stomach Cancer | 4,914 |
| Ovarian Cancer | 4,924 | Bladder Cancer | 4,913 |
| Lymphoma | 4,923 | Thyroid Cancer | 4,913 |
| Pancreatic Cancer | 4,922 | Lung Cancer | 4,909 |
| Liver Cancer | 4,919 | Melanoma | 4,909 |
| Leukemia | 4,918 | Brain Cancer (Glioblastoma) | 4,895 |

The twelve diseases belong to a different, smaller file — `proteins_by_disease.csv`. It is screened
separately below, by the same matcher against the same reference, and the two are never pooled: the
number of sequences they share is **0**, measured rather than assumed.

The 78,680 sequences are all distinct. They run 42 to 90 residues, median 66, every residue one of
the twenty standard amino acids — no selenocysteine, no ambiguity codes.

**The file's own safety flag is not unanimous.** `passes_safety` is 0 on **37,289** rows and 1 on
**41,391**; a sibling file, `proteins_validated_safe.csv`, is exactly those 41,391. This screen ran
over the **full** export, flagged rows included, because novelty is a property of a string and does
not depend on what the generator thought of it. **Thirteen of the twenty-five longest matches
reported below come from rows the generator's own safety flag rejected.**

## The composition is not natural, and it says so before any matching begins

Amino-acid composition is an exact integer count, so it can be stated without a model. Over all
5,165,782 generated residues, against **this same reviewed human proteome** — not against the
all-organism Swiss-Prot table that is usually quoted in its place:

| residue | corpus ppm | human ppm | corpus ÷ human (×1000) |
|---|---:|---:|---:|
| K | 104,598 | 57,308 | 1,825 |
| R | 94,075 | 56,326 | 1,670 |
| L | 71,918 | 99,584 | 722 |
| A | 62,730 | 70,097 | 894 |
| P | 62,425 | 63,176 | 988 |
| I | 53,962 | 43,385 | 1,243 |
| V | 53,821 | 59,565 | 903 |
| G | 53,393 | 65,649 | 813 |
| E | 51,858 | 71,067 | 729 |
| D | 51,234 | 47,343 | 1,082 |
| F | 45,051 | 36,471 | 1,235 |
| Y | 45,039 | 26,599 | 1,693 |
| T | 44,775 | 53,789 | 832 |
| S | 44,500 | 83,501 | 532 |
| H | 26,856 | 26,226 | 1,024 |
| Q | 26,836 | 47,663 | 563 |
| W | 26,779 | 12,127 | 2,208 |
| C | 26,769 | 22,970 | 1,165 |
| M | 26,739 | 21,304 | 1,255 |
| N | 26,631 | 35,837 | 743 |

**Lysine and arginine together are 1,026,307 of 5,165,782 corpus residues — 198,674 ppm — against
1,297,506 of 11,418,237 human residues, 113,634 ppm.** 19.87% against 11.36%: positive charge close
to doubled.

**The population that comparison is made against matters, and it is the one that was screened.** The
composition table most often quoted for "natural protein" (L 9.9, A 8.3, G 7.1, V 6.9, S 6.6 …) is
the **all-organism** Swiss-Prot composition. Measured on the human reference file itself: L 9.96,
S 8.35, E 7.11, A 7.01, G 6.57 — A differs by 1.3 points and S by 1.75. The load-bearing figure is
unaffected and it is computed here from the reference this study actually screened, not carried in
from a table.

That enrichment is not a defect and not a surprise: the file's own `mechanism` column, identical on
all 78,680 rows, reads *PPI Inhibition (electrostatic disruption)*. A generator asked for
electrostatic disruption produced sequences dense in the two residues that carry positive charge at
physiological pH. **It is also the single most likely source of nonspecific membrane activity**, and
that is the second experiment named at the end of this page.

Two further things fall out of the same table, and neither needed a float.

**The corpus is flatter than a proteome.** Most abundant residue over least: **3,927 thousandths in
the corpus, 8,211 in the human proteome.** An enrichment drawn from a natural background carries the
background's spread with it; this one does not.

**Six residues share one weight.** H, Q, W, C, M and N hold exact counts of 137,571 to 138,733 — a
spread of 1,162 across six residues, one part in 118. Those same six span 12,127 to 47,663 ppm in
the human proteome: most over least, **3,930 thousandths there against 1,008 here**. Six residues
agreeing to within a part in a hundred are six draws from a single shared weight. A designed
alphabet looks like this. A proteome does not.

So before a single comparison is made, the composition already says these sequences were composed
rather than sampled. That makes the novelty question sharper, not weaker: the question is no longer
*did the generator copy*, but *did a designed alphabet nonetheless land on something that already
exists*.

## How it was measured

Every common substring of length 5 or more is found by indexing **every** position of **every** valid
5-mer in the reference — **11,336,358** of them, confirmed by an independent `awk` sum — and
extending each seed hit maximally in both directions. The bound is the ordinary one and it is proved
in the program's header: a common substring of length L ≥ 5 contains a 5-mer, that 5-mer is in the
index, so the extension from it recovers the whole match. Every seed hit is extended; none is
skipped, so there is no pruning argument to get wrong.

There is **no reporting floor inside the computation.** Matches shorter than 5 are not lumped into a
"<5" bucket — first-occurrence tables hold every 1-, 2-, 3- and 4-mer over the twenty letters,
168,420 cells, so a sequence with no 5-mer hit is still answered exactly. The reporting threshold
appears only in the bench table at the end, applied to a distribution already published in full.

A protein boundary is a hard stop: proteins are separated by a sentinel no query residue can equal,
so no reported match is an artefact of two proteins sitting next to each other. The reference
alphabet is **21** letters, not 20 — selenocysteine (U) occurs 36 times — and U is excluded from the
index and terminates every extension. It can neither manufacture a match nor hide one, because no
generated sequence contains a U.

Where a sequence's longest match occurs in more than one place, the reported position is the
**smallest reference position among all longest matches** — one position per sequence, not an
enumeration of places. `ANFVAPEVLK` is the worked example: it occurs in three human proteins
(P51812 at 582, Q15349 at 575, Q15418 at 578) and the table below names P51812, the smallest.

**The instrument validates itself before it is allowed to speak.** Twelve arms run first, and if any
fails, no verdict and no seal are emitted:

```
[PASS] A1  a whole real protein (O60479, 287 residues) matches itself in full, correct accession
[PASS] A2  a 66-mer window of a real protein returns 66
[PASS] A3  a deterministic scramble of that SAME protein collapses — 7, not 287
[PASS] A4  60 lysines returns 10, equal to an independent run-length scan, and is < 60
[PASS] A5  an empty query is REFUSED (-1), never answered as 0
[PASS] A6  control — a 1-residue query returns 1, so A5 is not always-refuse
[PASS] A7  an exact 30-mer returns 30; the same 30-mer with one residue changed returns 15
[PASS] A8  a 40-mer spanning the join between two adjacent proteins returns 20, never 40
[PASS] A9  CWCWC, which has no reference 5-mer, returns exactly 4
[PASS] A10 MWMWM, which has no 5-mer and no 4-mer, returns exactly 3
[PASS] A11 a 2-residue query present in the reference returns 2
[PASS] A12 sub-K tie rule — smallest reference position 1220 wins, not first query offset 224049
```

Arms run in **both** directions, because an instrument that only ever finds things is
indistinguishable from one that always says yes. A3 is the one that matters most: the scramble is
the same residues in a different order, so anything reporting it as a match would be counting
composition, not sequence. A12 **requires the two candidate tie rules to disagree** on its query — a
tie rule tested where both rules agree proves nothing.

Given nothing, the program refuses. A missing, empty or truncated reference; a missing, empty or
truncated corpus; a corpus with a non-standard residue: each exits 2, prints the published reference
figures, names a specific reason, and emits no seal. All three inputs are **hashed, not asserted** —
a single substituted residue leaves the protein and residue counts identical, so a count pin cannot
see it and a digest can.

## Answer 1 — does any generated sequence appear in us, in full?

```
sequences whose longest match equals their own full length: 0
that is 0 ppm of the corpus
```

**Not one of the 78,680 sequences occurs anywhere in the 11,418,237-residue reviewed human
proteome.** Every sequence was tested against every position: this is an exhaustive negative, not a
sampled one.

A null return is an integer, not an event. Zero here is the useful answer — it is what makes *novel*
a measurement rather than a hope — and it is settled twice over, once by the engine and once by
implication: there are **zero** 13-mers shared between the corpus and the proteome, against a corpus
minimum length of 42.

## Answers 2 and 3 — how much of any single one of them exists?

The full distribution, published so the reporting threshold is a choice a reader makes after the
arithmetic rather than one made inside it:

| longest shared substring | sequences | ppm of corpus | cumulative at or above |
|---:|---:|---:|---:|
| 5 | 33 | 419 | 78,680 |
| 6 | 33,519 | 426,016 | 78,647 |
| 7 | 41,021 | 521,365 | 45,128 |
| 8 | 3,861 | 49,072 | 4,107 |
| 9 | 233 | 2,961 | 246 |
| 10 | 12 | 152 | 13 |
| 11 | 0 | 0 | 1 |
| 12 | 1 | 12 | 1 |

Observed minimum 5, observed maximum **12**. The mean, stated as the exact integer ratio it is:
**521,543 / 78,680 = 6,628 thousandths of a residue.**

**The whole corpus touches the human proteome at a maximum of 12 residues, against a median sequence
length of 66.** The typical generated sequence shares a seven-residue window with some human protein
somewhere. Nothing in the corpus is a fragment of us.

## Is even that residual overlap more than chance?

A shared 7-mer sounds like something until you ask how often it should happen. The null model draws
residues independently at the **measured** composition of each side — so it is handed the corpus's
own K+R enrichment for free, and the enrichment cannot be smuggled back in as signal. The
aligned-pair match probability is the exact integer ratio **3,266,100,739,639 / 58,984,123,166,334 =
55,372 ppm**; a uniform twenty-letter alphabet would be 50,000, and the excess is precisely the
composition bias of the two populations. Its powers are taken in Int128 fixed point. No float enters
here either.

| L | expected coincidences (×10⁻⁶) | observed sequences at or above L |
|---:|---:|---:|
| 5 | 28,627,446,967,166 | 78,680 |
| 6 | 1,556,650,460,359 | 78,647 |
| 7 | 84,621,389,007 | 45,128 |
| 8 | 4,598,813,488 | 4,107 |
| 9 | 249,852,560 | 246 |
| 10 | 13,570,309 | 13 |
| 11 | 736,815 | 1 |
| 12 | 39,993 | 1 |
| 13 | 2,169 | 0 |
| 14 | 117 | 0 |
| 15 | 6 | 0 |

Read the two columns carefully: expected counts aligned *(query position, reference position)* pairs;
observed counts *sequences*. At L ≥ 9 coincidences are rare enough that a sequence almost never has
two, so the columns are comparable there and not below it.

At L = 9 the null expects 249,852,560 millionths and 246 sequences are observed. At L = 10 it expects
13,570,309 millionths and 13 are observed. The single sequence reaching 12 stands against an
expectation of 39,993 millionths — one event in the tail of the length bins the model enumerates.

**What that column pair shows is the useful half of the result, and it is easy to under-read.** It is
not merely that the corpus is absent from the proteome. It is that **the residual overlap which does
exist is what the corpus's own composition predicts by chance** — the corpus is no closer to the
human proteome than composition alone forces it to be. The remaining overlap needs no explanation
beyond the alphabet the generator chose. It is a coincidence to be checked, not a homology to be
claimed — **at exact-substring resolution, and that qualifier is not optional.**

## The second population, screened separately and never pooled

`proteins_by_disease.csv` is the file the "twelve diseases" belong to. It is reported here rather
than left for a reader to go and find, and its figures come from the same matcher and the same
reference:

```
sha256      24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204
sequences   1400   residues 78,694   lengths 20 to 100   labels 12
shared with the studied corpus                    : 0
occurring in full in the reviewed human proteome  : 0
```

| longest shared substring | sequences |
|---:|---:|
| 5 | 18 |
| 6 | 780 |
| 7 | 551 |
| 8 | 47 |
| 9 | 4 |

Observed maximum **9**, on sequences running to 100 residues. Labels: alzheimer ×200, cancer ×200,
and amr, autoimmune, cardiovascular, copd, depression, diabetes, hiv, multiple_sclerosis, parkinson,
rheumatoid_arthritis ×100 each. The same exact-substring resolution applies, and the same qualifier
with it: this section measures identity, not homology.

## Where a bench should point

The reporting threshold is applied **here**, after the arithmetic, to a distribution already
published in full. These are the 25 longest shared substrings in the studied corpus. Each row
carries the shared fragment and its 1-based residue position inside the named accession, so it is
checkable against the reference file with `grep` alone:

| protein_id | len | longest | accession | residue | shared fragment | gene | generator's safety flag |
|---|---:|---:|---|---:|---|---|---|
| Lymphoma_504 | 76 | **12** | Q14258 | 441 | `LETFLAKSRPEL` | TRIM25 | pass |
| Bladder_Cancer_2773 | 64 | 10 | Q14320 | 105 | `REKERKKEAK` | FAM50A | pass |
| Brain_Cancer_(Glioblastoma)_107 | 72 | 10 | P51812 | 582 | `ANFVAPEVLK` | RPS6KA3 | pass |
| Brain_Cancer_(Glioblastoma)_20 | 43 | 10 | P62249 | 115 | `YDRTLLVADP` | RPS16 | **fail** |
| Brain_Cancer_(Glioblastoma)_2951 | 90 | 10 | Q96JP2 | 2410 | `GLRLLKVTQG` | MYO15B | **fail** |
| Colorectal_Cancer_1425 | 84 | 10 | P51679 | 158 | `SLATWSVAVF` | CCR4 | pass |
| Lymphoma_4450 | 87 | 10 | P98095 | 375 | `GSPRDPVKPS` | FBLN2 | **fail** |
| Ovarian_Cancer_794 | 79 | 10 | Q9P1Y6 | 818 | `SIKKTKQLRS` | PHRF1 | pass |
| Pancreatic_Cancer_3096 | 82 | 10 | P23246 | 314 | `KRLFAKYGEP` | SFPQ | pass |
| Prostate_Cancer_2055 | 80 | 10 | P00395 | 28 | `VLGTALSLLI` | MT-CO1 | **fail** |
| Stomach_Cancer_2069 | 85 | 10 | Q9C010 | 51 | `ALSVKEDAKE` | PKIB | pass |
| Thyroid_Cancer_30 | 67 | 10 | Q6NSI8 | 512 | `DEKGIECDVL` | SANBR | **fail** |
| Thyroid_Cancer_3414 | 49 | 10 | Q13685 | 225 | `PDGKRAVVGY` | AAMP | **fail** |
| Bladder_Cancer_1203 | 53 | 9 | P27708 | 1773 | `PFEGQKVKG` | CAD | **fail** |
| Bladder_Cancer_1847 | 71 | 9 | O75116 | 77 | `KIVKKIRGL` | ROCK2 | **fail** |
| Bladder_Cancer_2531 | 48 | 9 | Q6ZUT1 | 209 | `SRKKSLKKP` | NKAPD1 | pass |
| Bladder_Cancer_2933 | 74 | 9 | Q9UNH6 | 312 | `LPEEIGKLE` | SNX7 | pass |
| Bladder_Cancer_3467 | 66 | 9 | Q9ULI2 | 24 | `KEILRALKA` | RIMKLB | **fail** |
| Bladder_Cancer_3479 | 81 | 9 | Q96QS3 | 177 | `ENGAPFVPP` | ARX | **fail** |
| Bladder_Cancer_3873 | 72 | 9 | Q96EB6 | 553 | `VTLLDQAAK` | SIRT1 | **fail** |
| Bladder_Cancer_4229 | 46 | 9 | Q8WXR4 | 872 | `LQQLFSIPL` | MYO3B | pass |
| Bladder_Cancer_4283 | 79 | 9 | Q7RTT6 | 50 | `HMKRKYEAM` | SSX6P | pass |
| Bladder_Cancer_4285 | 61 | 9 | Q9Y4B5 | 963 | `AARELHRRA` | MTCL1 | **fail** |
| Bladder_Cancer_4690 | 62 | 9 | Q9HAT1 | 441 | `AKAAAKAPR` | LMAN1L | pass |
| Bladder_Cancer_4809 | 87 | 9 | Q9UPW5 | 1077 | `VEKSKESTA` | AGTPBP1 | **fail** |

`LETFLAKSRPEL` occurs **exactly once** in the whole reviewed human proteome — in TRIM25, an E3
ubiquitin/ISG15 ligase, 630 residues, at residue 441 — and it is really present in `Lymphoma_504`.
All 25 rows were verified against the reference by an independent extraction, and the check
discriminates: shifting every reported index by one breaks 25 of 25.

**Read the table as what it is: the top of a distribution, not the whole of it.** 4,107 sequences
share 8 or more residues with a human protein, 246 share 9 or more, 13 share 10 or more, and 1
reaches 12. These 25 are the longest, and each names one reference position — the smallest among that
sequence's longest matches — not every place the fragment occurs.

## What the floats in the source file cannot tell you

The corpus carries four numeric judgement columns. **The sealed program parses none of them** — it
reads the sequence, the id, the domain, the category and the mechanism, and never touches fields 6,
8 or 11. So no verdict on this page can rest on one by construction. Counting them separately, from
the file, shows why that is a strengthening rather than a sacrifice:

- **`validation_passed` has exactly one value across all 78,680 rows: 1.** A column that never says
  anything else separates nothing. An instrument that is always green and one that is always red are
  the same defect, and this one is always green.
- **`confidence` spans 0.40669063031673436 to 0.5121958454449972** — every value in the file below
  0.52, with 77,830 distinct values across 78,680 rows. A near-continuous label occupying a tenth of
  the unit interval, with no declared threshold and no observed outcome behind it.
- **`overall_score` takes 19 distinct values, and 76,544 of the 78,680 rows carry one written with a
  binary floating-point tail** — `0.9400000000000001`, `0.8899999999999999`, `0.8374999999999999`.
  **The value `0.94` does not appear in the file at all**; the 40,236 rows that mean 0.94 are every
  one of them written `0.9400000000000001`. That is not a rounding curiosity. It is the reason a
  verdict may not rest on a float: a comparison against `0.94` matches **none** of those 40,236 rows,
  and two programs reaching that comparison by different arithmetic can disagree about the same row.
  A ledger built on such a value diverges between machines that were meant to agree.

The novelty verdict needed none of them. Sequence identity is a comparison of integers, its result is
an integer, and every table above is a histogram of integers. *(One column the program also never
reads does check out: the CSV's own declared `length` agrees with the measured sequence length on all
78,680 rows, 0 disagreements.)*

## Confirmed by mechanisms that share no code with the instrument

The distribution is not one program's opinion of itself. Every bin was reproduced separately:

- a **sorted k-mer set intersection in coreutils only** — `awk` enumeration, `sort -u`, `join`, no
  Swift, no index, no extension, and no line of code shared with the engine — re-derived for this
  page at every k from 5 to 13:

  ```
  k= 5  78680      k= 8  4107       k=11  1
  k= 6  78647      k= 9   246       k=12  1
  k= 7  45128      k=10    13       k=13  0
  ```

  That is the engine's cumulative column exactly. Differencing it gives every published bin —
  5:33 6:33,519 7:41,021 8:3,861 9:233 10:12 11:0 12:1 — summing to 78,680 sequences, and weighting
  it by length gives **521,543**, the published mean numerator. `k=13 → 0`, against a corpus minimum
  length of 42, re-settles Answer 1 by implication without consulting the engine at all;
- and, in the earlier verification passes rather than in this run, a **suffix automaton** of each
  query streamed against the reference — a different algorithm class, no k-mers at all — agreeing on
  length *and* smallest reference position for 5,990 sequences including the entire ≥8 tail with zero
  disagreements, and a **`memmem` ascending-length scan** with no index and no seed, agreeing on 285
  sequences including the entire ≥9 tail.

**The null model was re-derived for this page in exact rational arithmetic**, outside Swift and
outside the program's Int128 fixed point, from window counts taken independently with `awk`. Nine of
its eleven rows reproduce digit for digit. The other two — L=5 and L=13 — come out exactly **one
unit higher** in the last digit, which is the signature of the program's fixed-point powers
truncating rather than rounding at each multiplication. The published null column is therefore
low by at most one unit in its last digit, never high, and one unit in 2.8 × 10¹³ moves nothing.

The index size was confirmed by an independent `awk` sum: 11,336,358 valid 5-mer positions, matching
the engine exactly. The composition counts on both populations, the K+R totals, the dynamic range,
the six-residue floor, `LETFLAKSRPEL`'s uniqueness in the whole proteome, TRIM25's length and all 25
accession, gene and residue rows were each re-derived outside the program for this page.

## What was repaired in our own instrument

Successive independent verification passes ran against this screen; the last round ran three in
parallel and all three returned *repairable*, not *sound*. **The answer never moved** — mechanisms
sharing no code with the engine had already reproduced every bin — but twelve things did, and they
are published here rather than absorbed quietly.

**The reference was asserted, not hashed.** The program printed a pinned digest it had never
computed. Substituting a single residue left the protein count at 20,431 and the residue count at
11,418,237, so both count pins stayed green and the program sealed a verdict on a file it had never
read. All three inputs are now hashed and refuse at the gate, naming the measured digest.

**Eleven accessions were mislabelled.** Eleven reviewed human descriptions spell an arrow inside the
text — *DNA dC->dU-editing enzyme APOBEC-3A*, *Delta 5-->4-isomerase type 1* — and the parser treated
every `>` byte as a record start. P14060, P26439, P31941, P41238, Q6NTF7, Q8IUX4, Q96AK3, Q9HC16,
Q9NRW3, Q9UH17 and Q9Y235 were reported under names like `4-isomerase`. All 20,431 parsed accessions
now equal an independent extraction, zero diff. *And the honest scope of that repair was measured
rather than argued: the pre-fix and post-fix sealed transcripts are byte-identical, because the
printed position had already been changed to a residue index inside the accession, which shifts
together with the spurious sentinel. "The parser was wrong" and "a published number was wrong" are
two claims and only the first survives.*

**The bench table could not be read by hand.** A fixed 32-character column with an id of exactly 32
characters emitted no separator and fused two fields; 3,914 corpus ids are 32 characters or longer.
Widths are now derived from the widest string printed — in the table and in the label census, where
the same defect had been re-introduced latently.

**The transcript recited its own tables from memory.** The paragraph a reader quotes carried
`249852560`, `13570309`, `39993` and the count of 12-residue matches as **typed literals**, six lines
under the table that computes them. They agreed by hand-copying; a corpus edit would have left the
paragraph reciting stale numbers inside a valid seal. Every numeral in it is now interpolated from
the arrays the table prints. The same defect was found and fixed in the category and mechanism
columns, which a parser that stopped at the sixth comma had been *describing* without reading, and in
the second corpus, which the transcript had characterised in full without ever opening the file.

**And the arm guarding the largest possible error was always-green.** A8 exists to prove that no
match is manufactured by two proteins sitting adjacent in the buffer. Its own comment named the
experiment — delete the inter-protein sentinel — and that experiment had never been run. Run: **all
twelve arms passed, and the program sealed a moved distribution** (5:33→32, 6:33,519→33,334,
7:41,021→41,180, 8:3,861→3,887, 9:233→234, mean 521,543→521,758). A sealed wrong answer under a clean
self-test is the worst state this file has an instrument for. The cause was two characters in A8's
*own setup*, a `- 1` that stepped over the sentinel and, with no sentinel present, truncated the
probe by one residue so it could not match 40 however thoroughly the boundary was destroyed — **the
arm was defended by the bug it was built to detect.** Both deleted; the harness now runs the
sentinel-deleted direction as an arm and requires A8 to fail **while the other eleven stay green**,
because "some arm failed" is also satisfied by a source that no longer compiles.

Also repaired: stdout is unbuffered, because a trap under `prog < /dev/null > file` discarded every
line already printed and a harness saw an empty file instead of a reason; fixed-size arrays are sized
from measurement so a different corpus refuses rather than traps; the sub-K path implements the tie
rule the transcript states rather than a different one, and A12 now executes it on a query where the
two candidate rules provably disagree; and the header's own zero-float claim was corrected after the
grep it quoted refuted it.

### What is still open, stated here rather than found later

- **The seal is path-bound.** The transcript names its three input files by absolute path, so a
  reader running from their own clone gets a different seal over identical arithmetic. Measured: the
  same bytes under a different root seal `5743f09d0aa7984bb647663d4e891d78967f512ff2436465f3397dd869cdb9fc`,
  and the *only* two lines that differ are the two path lines. The root-invariant digest published
  below is the figure a reader elsewhere can actually match.
- **One division in the composition section is unguarded** where the three below it are guarded. A
  population missing any one of the twenty residues would trap — exit 133, no reason, no seal —
  instead of refusing with the absent residue named. Latent, not live: all twenty residues are
  present in both populations here, verified independently.
- **Three sentences inside the sealed transcript are still stronger than the arithmetic under them,**
  and this page does not repeat any of them. One calls the 12-residue maxima "the only places where a
  generated sequence touches a real human protein at motif length" — the program's own table says
  4,107 sequences reach 8 or more. One states the file "carries no decimal number anywhere" while the
  same transcript prints `11.3634%`. One reads "Shows promise as novel chemical matter; warrants
  laboratory follow-up" — the only sentence in the transcript with no arithmetic behind it. Promise is
  not a quantity this program measures, and it is not claimed on this page.
- **The null model's denominator counts 36 residues its numerator cannot match.** The aligned-pair
  probability sums over the twenty standard residues but divides by all 11,418,237 reference
  residues, the 36 selenocysteines included. Measured: it makes the probability smaller by 3.15 parts
  per million, which moves no published digit, and it moves the null in the **conservative**
  direction — a slightly smaller null expects slightly fewer coincidences, which is the harder test
  for the claim this page draws from it, not the easier one.
- **Two properties still have no arm.** The tie rule fires on the seeded path — 207,602 swaps in one
  production run, instrumented in the verification pass that found this — while A12 exercises it only
  on the sub-K path; and nothing compares the parsed accessions to an
  independent extraction, so a regression of the arrow fix would be invisible to every instrument
  that ships. Both are latent today, both measured, both named here — which is how the A8 defect
  arrived, and the reason for writing them down before they become live.

## The seal

```
study            protein-novelty-exact
ROOT-INVARIANT   8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
```

**The root-invariant is the published figure, and the full-transcript seal deliberately is not.**
Two lines of the transcript name where the input files sit on the machine that ran it. That is a
fact about a filesystem, not about the answer, so a whole-transcript digest moves with the checkout
and would indict a correct reproduction from any other directory — the worst failure a seal has.
The program prints both: the full seal for the run in front of you, and the ROOT-INVARIANT over the
same transcript less those two lines. Measured from two different directories on the same bytes:
the full seals differ and the root-invariant is byte-identical. **Pin the root-invariant.**

The transcript covers every figure on this page and nothing else. Wall-clock timings are
deliberately excluded: a seal that changes when nothing about the answer
changed is a turn counter, not a seal. Both digests are reproducible with coreutils alone and both
agree with the program's own self-contained SHA-256:

```bash
sed -n '/^BEGIN TRANSCRIPT$/,/^END TRANSCRIPT$/p' out | shasum -a 256
sed -n '/^BEGIN TRANSCRIPT$/,/^END TRANSCRIPT$/p' out \
  | grep -vE "^  (studied|second) file " | shasum -a 256   # the ROOT-INVARIANT
```

The three inputs are pinned by digest, so a reader can confirm they hold the same bytes:

```
uniprot_human_reviewed.fasta  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e
proteins_validated.csv        bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
proteins_by_disease.csv       24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204
```

The reference is **20,431 records, every one `>sp|` Swiss-Prot reviewed, every one `OS=Homo sapiens`,
zero isoform accessions**. UniProt releases change; a reader whose download differs gets a refusal
naming their own digest, which is the instrument working, not failing.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
curl -sL 'https://rest.uniprot.org/uniprotkb/stream?query=reviewed:true+AND+organism_id:9606&format=fasta' \
  > raw/uniprot_human_reviewed.fasta
# the input paths are a compile-time constant; point ROOT at your clone
sed -i '' "s|static let ROOT = .*|static let ROOT = \"$PWD\"|" reproduce/protein-novelty-exact.swift
xcrun swiftc -O -swift-version 5 reproduce/protein-novelty-exact.swift -o /tmp/pn
/tmp/pn < /dev/null
bash reproduce/validate.sh
```

The program takes **no arguments** and reads **no stdin**. It prints the published reference figures
before it opens a single file, so every refusal path prints them too and no early exit is
uninstrumented. `validate.sh` re-runs it with no argv and stdin from `/dev/null`, holds **77 pins**
covering every figure on this page, recomputes the seal with coreutils, and carries **16 control
arms** proving its own detectors fire in both directions — including the five refusal paths, each
required to exit 2 with a named reason and **no** seal, and the sentinel-deleted build, required to
fail A8 alone.

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

## The verdict

Stated plainly, because a novelty screen that ends in hedging has not answered its question.

**What this screen DOES call.** These 78,680 sequences are **novel as primary structure**, and that is
a real, useful and hard-to-obtain property. Not one of them occurs in the reviewed human proteome — an
exhaustive negative over 5,165,782 generated residues against 11,418,237 human ones, every sequence
against every position, no sampling and no cutoff. **The whole corpus touches the proteome at a
maximum of 12 residues against a median length of 66**, and the residual overlap that does exist is
what chance predicts once the corpus's own composition is handed to the null for free. The corpus is
not a copy of the proteome, and it is no closer to it than composition alone forces.

**Nothing collides, and that is the result rather than the absence of one.** Zero exact full matches
is what licenses the word *novel*. Had any sequence matched in full, it would have been reported here
by accession with equal weight; the instrument was built to find such a case and its self-test proves
it can, on a real human protein, in full, with the right accession.

**What this screen does NOT call, and nobody should read into it.** Novel is not safe and novel is not
a cure. This program measured primary-sequence identity against **one** reference — canonical reviewed
human, no isoforms, no TrEMBL, no non-human proteome, no PDB and no patent space — and nothing else.
It did not measure structure, folding, binding, immunogenicity, toxicity, protease stability,
off-target activity, or efficacy against any of the sixteen cancers these sequences are labelled for.
**It also did not measure homology under substitution.** It sees exact substrings only. So the honest
sentence is that the corpus carries no detectable residual similarity to the human proteome **at
exact-substring resolution** — the null model is built on the same exact-match statistic as the
observation, and neither can speak past it. Affine.Earth does not call these sequences unrelated to
human proteins; it calls them **absent from the proteome as exact strings**. Those are two different
claims and only the second one was measured. **Affine.Earth does not call these safe, and does not
call them cures.**

**Where a bench should point.** Three instruments, in order.

1. **The maxima.** The 25 rows above name a fragment, an accession, a gene and a residue index. The
   12-mer in TRIM25 is the cheapest first experiment: synthesise it, assay against the named human
   partner, and see whether the shared window does anything. It is a coincidence to be checked, not a
   homology to be claimed.
2. **The charge.** K+R at 19.87% against 11.36% in the reference proteome is consistent with the
   file's own stated mechanism of PPI inhibition by electrostatic disruption, and is also the single
   most likely source of nonspecific membrane activity. A haemolysis and membrane-permeabilisation
   panel is the assay that separates a designed inhibitor from a detergent.
3. **The next instrument, which does not exist yet.** A gapped, scored alignment — profile HMM or
   Smith-Waterman with a substitution matrix — against the same corpus and the same reference. It
   answers the question this screen is blind to, and it is a different measurement, not a refinement
   of this one. Until it is built, no one, ourselves included, can say anything about homology under
   substitution in this corpus.

Nothing here is medical advice, and nothing here should change anyone's treatment. What the page
provides is the exact, complete, re-derivable enumeration any such conversation should start from,
available to anyone without permission and without trusting us.

## Related

- [Where else could this guide cut? The whole genome, counted](CRISPR-Genome-Off-Target-Map.md) — the same discipline over the genome.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md) — and over the transcriptome.
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
