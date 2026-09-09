# Study 45 — Which of nine billion answers a laboratory can act on

*A catalogue now exists that answers, in advance, what every possible single-letter change in
the human genome does. Nine billion answers, free to academic researchers. This study is a
safety review of that catalogue, and it asks one question on a laboratory's behalf: **for which
of those answers can a bench tell two variants apart, and for which can it not?** It grades no
model and makes no biological claim. It reads counts, never verdicts, and publishes not one
prediction value.*

**Status: FINDINGS SEALED — 2026-09-09.** Three instruments. Twenty self-test arms across the
two that carry them, every one fired in both directions; the third holds no arms and is graded
by its refusals, which are listed below.
Arm A needs no account and no key. Arm B reads the live artifact and therefore uses an
AlphaGenome API key under Google DeepMind's terms — the only arm on this board that a stranger
cannot re-derive with one command, and it is marked as such everywhere it appears.

---

## Why this matters to somebody who does not work in genomics

A laboratory that wants to understand a disease has more possible experiments than it can ever
run. Every bench-week spent on a change that turns out to do nothing is a bench-week not spent
on the one that matters, and for a family waiting on an answer that arithmetic is not abstract.

So a catalogue that scores all nine billion possible single-letter changes ahead of time is a
genuinely good thing to build. It is meant to let a researcher skip the changes that look inert
and go straight to the ones that look interesting. That is a real gift to the field.

The gift only works if the catalogue can **tell its own answers apart**. If two changes come
back carrying the same number, a researcher reads that as "these two are alike." Sometimes that
is exactly what the model meant. Sometimes it means the format the numbers travel in had no
room left to say anything finer, and two genuinely different answers were rounded onto the same
value. **From the outside those two situations look identical**, and this study is about
measuring where the second one is happening, so that nobody spends a year of bench-work on a
distinction the catalogue was never able to make.

We are not looking for something wrong with the science. We are looking for the places where a
careful person should ask for more before betting a laboratory on the answer.

---

## What we checked, and on what

The catalogue is **AlphaGenome Atlas**, released by Google DeepMind on 8 September 2026: a
precomputed prediction for every single-nucleotide change in the human genome, about nine
billion of them, roughly a petabyte, free for non-commercial research.

[Study 44](Study-44-The-Atlas-Container) established the arithmetic this study builds on. The
Atlas's own service definition, published under Apache-2.0, says the values *"are stored as
single precision floats."* A single-precision float has **4,294,967,296** bit patterns, of which
**16,777,214** carry no number, leaving **4,278,190,082** distinct values on the most generous
reading. Nine billion things and four and a quarter billion available answers, so **4,721,809,918
variants — 52 of every 100 — must carry the same score as another variant.** That is
unconditional and it names no particular pair.

This study asks the next question, which is the one a laboratory actually faces: **where does
that bite, and on which outputs?** It answers in two arms that between them cover the whole
catalogue.

---

## Arm A — the part that is already known, exactly and for free

About one variant in a hundred falls inside a protein-coding region. For those, the consequence
to the protein is not a prediction at all. It is a lookup in the genetic code, a table that has
been settled science for sixty years, and it gives an answer that is **exact, free, and the same
on every computer ever built**.

Enumerated completely — 64 codons, 3 positions, 3 alternate letters, so 576 substitutions in
all — the code divides as:

```
  total substitutions                          576
  SYNONYMOUS   (protein unchanged, exactly)    138   239 per 1000
  MISSENSE     (amino acid changes)            392   680 per 1000
  NONSENSE     (stop gained, truncating)       23   39 per 1000
  STOP_LOST    (stop -> amino acid)            23   39 per 1000

  substitutions whose PROTEIN consequence is a CERTAINTY from this table alone:
    synonymous + nonsense + stop-lost          184 of 576   319 per 1000
```

**Say precisely what this does and does not mean, because the tempting overstatement is wrong.**
It does **not** say that a synonymous change is biologically silent. Changes that leave the
protein untouched can still affect splicing, message stability and how much protein gets made —
and those are exactly the regulatory effects the Atlas is built to predict, so the model is
answering a real question there. What the table settles is the **protein-coding consequence**,
and it settles it with certainty. Where a researcher wants that particular answer, a continuous
score adds cost and not information, because the answer was already free and already exact.

### How much of the catalogue that covers

The codon table is exact, but it only speaks where protein-coding sequence is. Measured over
GENCODE v50, one canonical transcript per gene so a position shared between isoforms is counted
once, against the whole-genome variant count:

```
  canonical protein_coding transcripts        20,107
  CDS segments                                 197,573
  distinct coding positions (canonical union)  33,722,363
  coding single-nucleotide variants (x3)       101,167,089
  whole-genome variants (Study 44)             9,299,252,154
  coding SNVs per 100,000 of the genome        1087
```

**About 1.09% — roughly one variant in ninety.** So the free, exact answer covers about one
percent of the catalogue, and the remaining ninety-nine percent is where a predicted number is
genuinely the only answer available. That is not a criticism of the Atlas; it is the reason the
Atlas is worth building. It is also why the rest of this study is about those ninety-nine
percent, and about whether the numbers there can be told apart.

---
### And what that one percent already tells you, for nothing

Inside the coding fraction the genetic code is not a hint, it is the answer. Applying the table
to every canonical coding position in the assembly:

```
CONSEQUENCE CLASS — every coding substitution over the canonical CDS set
  substitutions classified                     103,076,262
  SYNONYMOUS  (protein unchanged, exactly)     23,660,731   229 per 1000
  MISSENSE    (amino acid changes)             75,158,434   729 per 1000
  NONSENSE    (stop gained, truncating)        4,246,822   41 per 1000
  STOP_LOST   (stop -> amino acid)             10,275   0 per 1000
  positions skipped (N in codon)               0
  PROTEIN consequence certain from the table   27,917,828   270 per 1000
```

**Nearly twenty-eight million variants whose effect on the protein is already a certainty** —
synonymous, nonsense, or stop-lost — with no model, no key, no network and no download beyond a
public assembly. Not one of them needs a predicted number to answer that particular question. And
`positions skipped` is zero: every canonical coding codon in the assembly is unambiguous, so
nothing was set aside to reach that figure.

Two honest notes on the arithmetic. The 103,076,262 here is slightly larger than the 101,167,089
above, by 1,909,173, because the two count different things: the footprint merges genome positions
into a union, while this walks each canonical transcript in turn, so a position two overlapping
genes share is counted once there and twice here. And missense is exactly identified too — the
amino acid substitution is certain — but *which* substitution matters is a further question, and
that is precisely where a model has something to say.


## Arm B — where the catalogue carries the claim, measured on the live artifact

The other ninety-nine variants in a hundred are outside protein-coding sequence, and there no
lookup table helps. That is the Atlas's home ground, the regulatory question it was built for,
and there the answer is whatever number comes back. So we pulled real answers and counted.

**What was pulled.** Every variant in a 200-base window inside *HBB* on chromosome 11 — the
haemoglobin beta gene, chosen because it is one of the best-understood stretches of the human
genome — giving all **600** variants the window admits, and separately every variant in a
200-base window inside *CFTR* on chromosome 7, the cystic-fibrosis gene, as a second locus to
check that nothing here is one window's peculiarity. Both windows sit within their gene as
GENCODE v50 places it, checked against the same annotation Arm A uses: `chr11:5,227,000-5,227,200`
inside HBB at `chr11:5,225,464-5,229,395`, and `chr7:117,559,000-117,559,200` inside CFTR at
`chr7:117,287,120-117,715,971`.

Each variant comes back with **22 scorers**, and each scorer returns not one number but a
vector: from a single value for the headline score up to 35,245 values for the expression
tracks. 89,097 numbers per variant.

**What was counted, and why it had to be counted this way.** Two variants "share a score" when
they carry the same value **for the same quantity** — position by position through those
vectors. That is the thing Study 44's arithmetic bounds. Counting instead whether two variants
match across an entire 167-value vector at once would measure something far rarer, report
almost nothing, and be read as evidence against the very arithmetic it was meant to test. Both
figures are reported below, and the stronger one is labelled as the stronger one.

### The finding, by scorer

Over 600 variants at *HBB*. The rate is how many of every 1,000 values handed back are values
some other variant also received.

| scorer | values per variant | shared, per 1,000 | variants sharing an entire vector |
|---|---:|---:|---:|
| AVI_SCORE | 1 | **0** | 0 |
| PROCAP | 12 | **0** | 0 |
| CAGE | 546 | 1 | 0 |
| DNASE | 305 | 1 | 0 |
| ATAC | 167 | 2 | 0 |
| SPLICE_JUNCTIONS | 10,276 | 63 | 0 |
| CONTACT_MAPS | 28 | 106 | 0 |
| POLYADENYLATION | 371 | 176 | 0 |
| AVI_SCORE_FEATURE_IMPORTANCE | 18 | 364 | 0 |
| RNA_SEQ | 35,245 | 370 | 0 |
| DNASE_ACTIVE | 305 | 431 | 4 |
| AVI_SCORE_MODEL_FEATURES | 18 | 452 | 0 |
| CHIP_HISTONE | 1,116 | 468 | 0 |
| CAGE_ACTIVE | 546 | 529 | 2 |
| RNA_SEQ_ACTIVE | 35,245 | 534 | 0 |
| PROCAP_ACTIVE | 12 | 542 | 74 |
| ATAC_ACTIVE | 167 | 572 | 32 |
| CHIP_HISTONE_ACTIVE | 1,116 | 788 | 0 |
| CHIP_TF | 1,617 | 794 | 0 |
| SPLICE_SITES | 2 | 834 | 145 |
| CHIP_TF_ACTIVE | 1,617 | **930** | 0 |
| SPLICE_SITE_USAGE | 367 | **950** | 0 |

**Read the top row first, because it is the good news and it is real.** `AVI_SCORE` — the single
headline number, the one a researcher is most likely to sort on — gave
**600 different values to 600 variants**. It separated every one. Nothing in this study says that number is unreliable,
and a laboratory ranking variants on it is not being misled by the container at this scale.

**Then read the bottom.** `SPLICE_SITE_USAGE` shares **950 of every 1,000** values it hands back.
`CHIP_TF_ACTIVE` shares 930. These are the detailed, per-track quantities a researcher turns to
in order to say **why** a variant matters — which regulator, which tissue, which mechanism. On
those, at this window, most of the numbers coming back are numbers another variant also
received, and the artifact does not say whether that is agreement or exhaustion.

And some of it is stark in the plainest terms:
**145 of the 600 variants carry an identical pair of splice-site values** at HBB, 74 carry an
identical 12-value PROCAP_ACTIVE vector, and 32 carry an identical 167-value ATAC_ACTIVE vector. For those variants, on those scorers, the catalogue is
not distinguishing them at all.

### The pattern that holds without exception

Seven scorers ship in pairs — a base measurement and an `_ACTIVE` companion. **In all seven
pairs, the `_ACTIVE` version shares far more of its values than the base version does.**

| pair | base | _ACTIVE |
|---|---:|---:|
| PROCAP | 0 | 542 |
| CAGE | 1 | 529 |
| DNASE | 1 | 431 |
| ATAC | 2 | 572 |
| RNA_SEQ | 370 | 534 |
| CHIP_HISTONE | 468 | 788 |
| CHIP_TF | 794 | 930 |

Seven of seven, no exception, some of them moving from essentially nothing to more than half.

**We state the honest alternative reading, and we cannot settle it from outside.** An `_ACTIVE`
quantity may be deliberately coarse — a gate that reports whether a track is on, which would
genuinely have few distinct levels and would collide by design, not by exhaustion. That would be
a sound engineering choice and no criticism at all. **The point is that a reader cannot tell.**
The wire returns the same 32-bit value in both cases, and a researcher comparing two variants on
an `_ACTIVE` track has no way to know whether the model judged them alike or the quantity was
never fine enough to separate them. That is a question only the people who built it can answer,
and it is the first thing we would ask them.

### Where the shared values sit, which is the part a bench should hear

Of the values that are shared, we counted how many fall in the near-zero band — the small
numbers a laboratory reads as "nothing happening here" and uses to set a variant aside. The band
edge is a power of two — `2^-4 = 0.0625`, tested as a biased exponent of 122 or less — so the
test is exact integer arithmetic on the bit pattern and involves no rounding.

For the base scorers, the shared values are **overwhelmingly in that band**: 999 per 1,000 of
RNA_SEQ's, 999 of POLYADENYLATION's, 991 of CHIP_HISTONE's, 991 of SPLICE_SITE_USAGE's, 983 of
ATAC's, 956 of CHIP_TF's, and all 1,000 of CONTACT_MAPS'.

**So the catalogue is at its least able to separate variants precisely where a laboratory clears
them.** That is the sentence this study exists to put in front of a bench. It is not a claim
that any particular variant was wrongly cleared — this study reads no verdicts and names no
variant. It is a claim about **where to ask for more resolution before deciding nothing is
there**, and the answer is: in the quiet band, on the detailed tracks.

For the `_ACTIVE` scorers the picture is different, and it is not uniform. At *HBB*, six of the
seven put **none at all** of their shared values in that band — zero per 1,000 — which is what a
coarse gate sitting at a few fixed levels away from zero would look like, and is another reason
the coarse-by-design reading deserves a straight answer. **The seventh does not follow them:**
`RNA_SEQ_ACTIVE` puts 924 per 1,000 of its shared values in the band at *HBB* and 884 at *CFTR*,
behaving like a base scorer rather than like its six siblings. At *CFTR* `CAGE_ACTIVE` is a
partial exception too, at 115. We report the exceptions rather than the tidy version: whatever
the `_ACTIVE` family is doing, it is not one single thing.

### It is already here, far below the ceiling

Study 44's arithmetic forces collisions at nine billion variants. This measurement is at
**600** — a batch 7,130,316 times smaller than that ceiling — and the sharing is already substantial.
Measured at nested prefixes of the same batch:

```
  CHIP_TF_ACTIVE       n=75: 799/1000   n=150: 883/1000   n=300: 881/1000   n=600: 930/1000
  ATAC_ACTIVE          n=75: 525/1000   n=150: 570/1000   n=300: 529/1000   n=600: 572/1000
  CHIP_HISTONE         n=75: 305/1000   n=150: 459/1000   n=300: 479/1000   n=600: 468/1000
  CONTACT_MAPS         n=75:  28/1000   n=150:  53/1000   n=300:  90/1000   n=600: 106/1000
  AVI_SCORE            n=75:   0/1000   n=150:   0/1000   n=300:   0/1000   n=600:   0/1000
```

That collisions rise with the number of variants asked of one finite set of values is not a
discovery; it is the pigeonhole, and it was never in doubt. What the arithmetic alone cannot
tell you is **how early it arrives**, and the answer is that for several scorers it is already
most of the answers at six hundred variants. The count of shared values can only rise as more
variants are added; the rate is a ratio and can move either way, which is why two rows above
dip slightly before rising again.

### The second locus, which is the control that matters

Everything above is one 200-base window. A single window can be peculiar, so the whole
measurement was repeated at *CFTR* on chromosome 7 — a different chromosome, a different gene, a
different regulatory neighbourhood, the same 600 variants and the same 22 scorers.

**It replicates, and in places more strongly.**

| | *HBB*, chr11 | *CFTR*, chr7 |
|---|---:|---:|
| AVI_SCORE, shared per 1,000 | 0 | 0 |
| ATAC | 2 | 2 |
| CHIP_TF | 794 | 919 |
| CHIP_TF_ACTIVE | 930 | 968 |
| SPLICE_SITES | 834 | 985 |
| SPLICE_SITE_USAGE | **950** | **998** |
| `_ACTIVE` higher than its base | 7 of 7 | 7 of 7 |

At *CFTR* the headline `AVI_SCORE` again gives 600 distinct values to 600 variants. The
`_ACTIVE` pattern again holds in every one of the seven pairs. `SPLICE_SITE_USAGE` again sits at
the bottom, sharing 998 of every 1,000 values it returns. And **574 of the 600 variants carry an
identical pair of splice-site values** — where at *HBB* it was 145.
### One scorer is present and empty, which is a different answer again

At *CFTR*, **21 of the 22 scorers return values and one does not.** `POLYADENYLATION` comes back
for all 600 variants with its key in place and **zero values inside it**. At *HBB* the same
scorer returns 371 values for every variant.

This is worth a paragraph of its own because it is a third state, and the most quietly dangerous
of the three. A number that separates is one answer. A number shared with another variant is a
second. **A scorer that is present and empty is neither** — and a program iterating the response
sees the field, finds nothing in it, and may record that as *no effect predicted* when what
actually happened is *nothing was predicted*. Absence and a negative result are different
findings, and only one of them is evidence.

We do not know why it is empty here, and we do not guess: polyadenylation may simply have no
annotated signal in this window, which would be a perfectly good reason. **The point for a
laboratory is to check the length of the array before reading meaning into its silence.**


The near-zero concentration is, if anything, sharper: at *CFTR* every non-`_ACTIVE` scorer sends
**979 or more of every 1,000** of its shared values into the quiet band, with the single exception
of the AVI model-feature vector at 801.

Two loci, two chromosomes, one instrument, and the same shape both times.

---

## What we call, and what we refuse to call

**What we call.** For the headline `AVI_SCORE`, the container is not the limiting factor at this
scale, and we say so plainly — it separated every variant at both loci. For the detailed
per-track scorers, and above all for the splice-site and transcription-factor tracks, **a
laboratory should not treat two equal numbers as evidence that two variants are alike** without
asking for more resolution. On those tracks most of the numbers returned are numbers another
variant also received, and the artifact cannot say which of the two reasons produced that.

**What we refuse to call.** We do **not** call any prediction wrong. We have no ground truth and
we built no instrument that could have one; this study reads counts of values and never a
verdict. We do **not** name a single variant, pair of variants, gene or patient. We make **no
clinical statement of any kind**, and the Atlas's own terms say its predictions are for research
and *"must not be used for clinical decision-making."* We take them at their word and add that
nothing here should be read as being about anybody's care. We do **not** call a synonymous change
biologically silent. And we do not claim the `_ACTIVE` sharing is a defect — it may be a coarse
quantity by design, which is a question for the people who built it and the first one we would
put to them.

**Where a bench should point next.** Ask the Atlas's authors two things. First, are the `_ACTIVE`
tracks intentionally coarse, and if so what is their intended number of levels — an answer that
would convert an ambiguity into a documented property and cost nothing. Second, for the tracks
where a research decision actually gets made, could the catalogue publish at double precision, or
publish the quantised levels explicitly? [Study 44](Study-44-The-Atlas-Container) measured that
the same nine billion answers in double precision force **zero** forced collisions, with room to
spare of about five hundred million to one. **The room is there.** This is a fixable thing, and
saying so is the most useful sentence in this study.

---

## What would have made this study wrong

The first version of the collision counter compared **whole vectors** — all 167 values of a
scorer at once. Run that way it reports almost nothing: at *HBB*, zero for `ATAC`, two variants
for `CAGE_ACTIVE`. A study built on that counter would have announced that the sharing Study 44
proved could not be found in the real artifact, and it would have been wrong, because matching on
167 quantities at once is a far rarer event than matching on one.

The repair was to count position by position, which is the quantity the arithmetic actually
bounds. The suite now carries an arm that holds a batch where the per-position count finds the
shared value and the whole-vector count finds nothing, so the two can never again be confused.
Both figures stay on the page.

Three other things were repaired before the artifact was ever pulled. The near-zero band was a
comparison on parsed floating-point numbers inside a study about floating point, and is now an
exact integer test on the exponent bits with a band edge that is a power of two. One self-test
arm compared an empty string to itself and could not fail; it is gone, replaced by arms that
check each property on a case that must hold and a case that must not. And a pull that stopped
early would have parsed cleanly and produced a rate over an unknown denominator, so the ingress
now writes its closing line only after the final page arrives and the counter refuses a file
that lacks it.

And one error was made in drafting this page and caught before it was published. The figure sheet
the programs print carries a rate for every scorer at both loci; while writing it, a value was
entered for `POLYADENYLATION` at *CFTR* that **no measurement had produced**. Checking every
figure in the sheet mechanically against the two measurement transcripts — rather than reading
them over — found it, and the truth turned out to be more interesting than the invented number:
that scorer returns no values at all at *CFTR*, which is the finding written up above. A table
assembled by hand from correct measurements is exactly where a fabricated cell hides, because
everything around it is right.

---

## The instruments, and that they refuse

Twenty self-test arms, each checked in both directions, because a gate that only ever passes has
measured nothing. They sit in two of the three programs; the genome program carries none, and is
graded instead by the refusals in the table below — that is a real gap in its instrumentation and
it is named here rather than papered over.

```
  codon-consequence-exact.swift          7 run, 7 passed
  atlas-collision-measure-exact.swift   13 run, 13 passed
```

The collision counter's arms include the decisive pair — that the per-position counter finds a
shared value on a batch where the whole-vector counter finds none — along with both edges of the
near-zero band, a batch with a known number of shared values, and a batch with none where it must
return zero rather than a floor.

Measured refusals, both directions:

| given | verdict |
|---|---|
| no pulled artifact | `RUN_TERMINAL REFUSED ATLAS_PULL_ABSENT` |
| an artifact whose stream stopped early | `RUN_TERMINAL REFUSED ATLAS_PULL_INCOMPLETE` |
| an artifact with no parseable variant | `RUN_TERMINAL REFUSED NO_VARIANTS_PARSED` |
| any arm failing | `RUN_TERMINAL REFUSED SELFTEST_FAILED` |
| the annotation absent | `RUN_TERMINAL REFUSED GTF_ABSENT` |
| a complete artifact | `RUN_TERMINAL COMPLETE` |

Every one of those refusals prints the study's published figures first, labelled as quoted rather
than measured, so a run that measures nothing still says what the published numbers are and
cannot be mistaken for one that produced them.

---

---

## The whole study was run again, from nothing

Every figure above was produced twice, and the second time from scratch. The corpora were
deleted and re-fetched from GENCODE; both loci were pulled again from the live Atlas endpoint;
all three programs were recompiled from the sources in this repository; and every run was
compared against what this page already said.

```
  GENCODE v50 annotation      re-fetched, sha256 83fba3e9… matches the recorded provenance
  GRCh38 primary assembly     re-fetched, sha256 b760d18d… matches the recorded provenance
  HBB pull                    re-pulled, 600 variants, identical to the byte count of the first
  CFTR pull                   re-pulled, 600 variants, identical to the byte count of the first

  codon-consequence-exact          seal 1c474b15…   reproduced
  coding-consequence-genome-exact  seal 25b068b6…   reproduced
  atlas-collision HBB              seal 1600aa88…   reproduced
  atlas-collision CFTR             seal 45054503…   reproduced
```

**The Arm B result is the one worth pausing on.** Its seal is a digest of counts taken over
bytes fetched from a live service, and a second fetch hours later produced the identical digest
at both loci. That is not a file being re-hashed: it is the same measurement, made twice, over
data delivered twice across the network. A reader with their own key gets the same numbers, and
that is the whole reason to publish a seal rather than a claim.


## Reproduce

**Arm A needs nothing at all.** No account, no key, no network, no corpus:

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/codon-consequence-exact.swift -o /tmp/s45a && /tmp/s45a
```

**The genome-weighted half of Arm A** needs two public files, both fetched from GENCODE and both
deleted after use — a genome assembly is public, frozen and versioned, and there is no reason for
us to host a copy. `corpus/alphagenome-atlas/GENOME-PROVENANCE.md` carries the URLs and digests;
the annotation used here verified against its recorded digest before the run.

**Arm B needs your own AlphaGenome key**, and this is the one place on this board where a reader
cannot simply re-derive our number:

```bash
python3 reproduce/atlas-dense-ingress.py chr11 5227000 5227200 atlas-dense.jsonl
swiftc -O reproduce/atlas-collision-measure-exact.swift -o /tmp/s45b
/tmp/s45b atlas-dense.jsonl
rm -f atlas-dense.jsonl
```

The ingress computes nothing. It calls the endpoint with Google DeepMind's own published stubs
and writes their exact wire bytes; every figure in this study is an integer produced by the Swift
program over those bytes. The pulled artifact is roughly 672 KB per variant, it contains
AlphaGenome prediction values, and **it is never committed here** — this study publishes counts
of values and not one value.

## Seal

```
codon-consequence-exact          7 arms, 7 passed
  sha256  1c474b157bb5b3c206a3b40f05a47bc3753f38fc5406ad09566af1a7dedb75b9

coding-consequence-genome-exact  GENCODE v50 canonical CDS + GRCh38 primary assembly
  MARKER  CODON_TABLE_SPEAKS_TO_ONLY_THE_CODING_FRACTION
  sha256  25b068b63a9b656aea78fdc2f2f290091ad451b5d1276b1c8bae4bf69259f111

atlas-collision-measure-exact   13 arms, 13 passed
  MARKER  ATLAS_COLLISIONS_MEASURED_ON_THE_PUBLISHED_ARTIFACT
  HBB   chr11:5,227,000-5,227,200   600 variants   22 scorers
  sha256  1600aa88aaa9cc3f4633b38d148984195b80d191303a6a1ec1be24e9d2fdcba0
  CFTR  chr7:117,559,000-117,559,200   600 variants   22 scorers
  sha256  45054503330b28b151432e6b27170112aaded210311998e9aef263885ea1fb9a
```

Each sealed transcript carries the interval, the coverage, and every count — and no path, no
timing and no score value.

## Evidence, graded

| what | grade | where it comes from |
|---|---|---|
| The genetic code enumerated: 138 / 392 / 23 / 23 of 576, and 184 whose protein consequence is certain | **Measured**, and re-derivable by anyone in one command | `codon-consequence-exact.swift`, no inputs of any kind |
| The container's arithmetic: 4,278,190,082 distinct values, 4,721,809,918 of 9,000,000,000 forced to share | **Published, cited** | [Study 44](Study-44-The-Atlas-Container), proved there from Google DeepMind's own Apache-2.0 service definition |
| Every per-scorer sharing rate, whole-vector count, near-zero attribution and growth figure, at both loci | **Measured** | `atlas-collision-measure-exact.swift` over the live pulled artifact, 2026-09-09 — **re-derivable only with an AlphaGenome key**, unlike every other figure here |
| `_ACTIVE` scorers sharing more than their base scorer, 7 of 7 at both loci | **Measured** | the same two runs; the pairing is the Atlas's own naming, not ours |
| Whether the `_ACTIVE` tracks are coarse by design | **NOT KNOWN** | it cannot be settled from outside the model; it is the question we would ask its authors |
| Whether any specific variant is wrongly cleared by any laboratory | **NOT MEASURED, and not claimed** | this study reads no prediction and names no variant |
| That the Atlas's predictions are for research and not clinical use | **Published, cited** | their own terms of service, quoted |

## Related

- [Study 44 — nine billion answers, four billion ways to say them](Study-44-The-Atlas-Container) — the container arithmetic this study measures against
- [The order of the bases](The-Order-Of-The-Bases) — the same discipline pointed at medicines, where an exact enumeration replaces a scored guess
- [Designed, or forced by its own bases?](CRISPR-Clinical-Guide-Atlas) — where the GRCh38 base count used here is measured

## Rights — source-available, not open-source

Everything on this page is ours and is published source-available, so that anyone can re-derive
every figure. `atlas_service.proto` is Google DeepMind's, licensed Apache-2.0, and is
redistributed in this repository under that licence with its origin and digest recorded. **No
AlphaGenome prediction value is reproduced anywhere in this study or this repository.** The
pulled artifact was measured and deleted; what survives it is a set of integer counts.
