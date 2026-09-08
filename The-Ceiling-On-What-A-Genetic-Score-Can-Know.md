# The ceiling on what a genetic score can know

*A bound, not a comparison. The subject under grading is the **instrument** — every present and
future genotype-only score for a trait. Never any person, never any group, and never anyone's
fitness for anything.*

**Status: VERIFIED — 2026-09-08.** 56 phenotypes, every ceiling computed as an exact integer
bracket over 10¹², **25 self-test arms in both directions, 0 failed**, 12 published figures
recomputed and **0 disagreeing**. No individual genotype exists in this corpus, none was used, and
nothing here assesses anybody.

---

## The thing we can compute exactly

Ask the question sharply enough and it stops being an opinion.

> Given a trait whose common-SNP heritability is *h²*, how often can the **best possible**
> genotype-only score put two people in their true order?

That has an exact answer. For a trait *Y* and an additive genotype score *S*, bivariate normal at
correlation ρ, the probability that *S* ranks two independently drawn people correctly is

> **C(ρ) = ½ + arcsin(ρ) / π**

Set ρ = √h²_SNP and C becomes a **ceiling**: no score can correlate with a trait more strongly than
the additive genetic value it is estimating. It is an upper bound on every score that exists and
every score anyone will ever build, in that stratum, from genotype alone.

**And it is computable with no floating point anywhere.** The transcendental is never evaluated.
The test *C − ½ ≤ t* is reduced to *ρ ≤ sin(πt)*, and then to an integer cross-multiplication:

```
sin_hi(πt)² × den(ρ²)   vs   num(ρ²) × 10¹²⁰
```

π and sin are bracketed by alternating series with per-term intervals and direction-correct
truncation — a partial sum ending on a **subtraction** is a lower bound, one ending on an
**addition** an upper bound. No square root is taken. No arcsin is taken. A ceiling that moves with
the rounding is not a ceiling.

## What the ceiling is, measured

56 load-relevant phenotypes carrying both an LDSC heritability and a standard error, from the Neale
lab UK Biobank round-2 release. Every number below is computed by the program, not asserted.

| | C |
|---|---|
| a coin | **0.500000000000** |
| lower median ceiling — *Sleep duration* | **0.573212381656** |
| maximum ceiling — *Worrier / anxious feelings* | **0.602142835007** |
| maximum anywhere, at the top of a 2-SE interval | **0.610622725745** |
| minimum ceiling — *Severity of manic/irritable episodes* | **0.527947611149** |

**Phenotypes reaching C = 0.62 even at the top of their interval: 0. Reaching 0.65: 0.**

Read that plainly. Across the best-measured behavioural and health phenotypes in the largest public
cohort there is, a *perfect* genotype-only score orders two strangers correctly about **57 times in
100** at the median, and **60 in 100** at the very best. Not the scores we have — the ones nobody
can build.

## The three that matter most to a working person

The exposures an employer might be tempted to sort people on:

| phenotype | ceiling C | 2-SE interval |
|---|---|---|
| **Job involves shift work** (826) | **0.544353505508** | 0.538042338431 .. 0.549890300690 |
| **Length of working week for main job** (767) | **0.541714427173** | 0.535623790633 .. 0.547038320768 |
| **Time employed in main current job** (757) | **0.530300726943** | 0.521659037231 .. 0.536993080201 |

**A perfect genotype-only score for shift-work status ranks two people correctly about 54.4 times in
100, against 50 for a coin.** That is the ceiling on the instrument.

And there is a second reason the number cannot mean what a sorting scheme would need it to mean:

> **h² on an occupational phenotype is the heritability of WHO ENDS UP IN THAT JOB** — selection
> into the exposure. It is not tolerance of the exposure, and no column anywhere in this corpus
> separates the two.

*Unemployed* measures who is unemployed. *Nurses* measures who is a nurse. Every work-family trait
in this corpus that clears the study's minimum gene count is, without exception, employment **state**
or job **category** — never anyone's capacity to withstand a shift.

## How much headroom the field has left

Complete enumeration of the staged PGS Catalog performance rows — **1,105 rows over 210 distinct
scores**, nothing sampled. Of the **125** metrics on pinned traits evaluated in Europeans, **85 are
comparable and scored**; **40 are not, and are counted rather than dropped** — AUROC 8, percentage
scale 10, bare unqualified R² 21, other 1. A quantity that is not the same quantity does not get
averaged in.

CAPTURED is the share of the achievable excess over a coin that the best published score already
holds, as exact integer per-mille, floored.

| trait | ceiling C | best published C | captured | score |
|---|---|---|---|---|
| chronotype (1180) | 0.598988711992 | 0.571783146564 | **725/1000** | PGS003563 partial-R² = 0.05 |
| neuroticism (20127) | 0.599737251748 | 0.571783146564 | **719/1000** | PGS003565 partial-R² = 0.05 |
| sleep duration (1160) | 0.573212381656 | 0.550601310553 | **691/1000** | PGS002196 partial-r = 0.1583 |
| overall health rating (2178) | 0.589832252329 | 0.558775112702 | **654/1000** | PGS002218 partial-r = 0.1836 |
| insomnia (1200) | 0.571762982457 | 0.545063908314 | **627/1000** | PGS002149 partial-r = 0.1411 |
| nap during day (1190) | 0.580744435846 | 0.542074155164 | 521/1000 | PGS001000 PGS R² = 0.01737 |
| snoring (1210) | 0.587466536469 | 0.541915115528 | 479/1000 | PGS002225 partial-r = 0.1313 |
| getting up in morning (1170) | 0.575594213665 | 0.533598381081 | 444/1000 | PGS001001 PGS R² = 0.0111 |
| risk taking (2040) | 0.590346895043 | 0.525150471237 | 278/1000 | PGS001049 PGS R² = 0.00623 |
| daytime dozing (1220) | 0.561183362582 | **ABSENT** | — | none of a comparable family |
| **job involves shift work** (826) | 0.544353505508 | **ABSENT** | — | none of a comparable family |
| **length of working week** (767) | 0.541714427173 | **ABSENT** | — | none of a comparable family |
| **time employed in job** (757) | 0.530300726943 | **ABSENT** | — | none of a comparable family |

**The published field already holds 627 to 725 parts per thousand of the achievable excess** on the
traits it has built scores for. There is very little headroom left to buy — and for the work
exposures there is none at all, because there is nothing to buy it with.

**One claim sits above its own ceiling, and it is reported rather than used.** PGS004430, neuroticism,
*PGS R² (no covariates) = 0.1554439* → **C = 0.629000353248**, against a neuroticism ceiling of
0.599737251748 and 0.606403923961 at the top of its 2-SE interval. A score cannot beat the additive
genetic value it estimates, so the row is evidence about the metric or the evaluation sample, not
about the score. Three readings are printed and none is chosen: the metric is not the quantity its
name states; the evaluation sample overlaps the data the score was trained on; or the LDSC h² for
that trait understates the common-SNP heritability. **The selection rule excludes it automatically —
it is not a judgement made afterwards**, and that is why the rule is stated before the table rather
than after it.

**ABSENCE, stated as absence and not as zero.** No polygenic score of any kind, of any metric family,
exists in these rows for shift work, night shift work, length of working week or hours worked. The
same check over the whole PGS Catalog — 6,982 scores — returns zero by two independent routes, in
the score table under the frozen trait regex and in the performance table. *(That wider check is
MEASURED against the full Catalog; the count above is what this program reads from the staged
slice.)*

## What the bound assumes, named rather than buried

Three things, and each of them is a real condition rather than a formality.

**Bivariate normality of the score and the trait.** The arcsin identity is exact for a bivariate
normal pair. For a binary phenotype it is read on the liability scale, which is why the corpus
column is `h2_liability` and not the observed-scale figure. A trait whose joint distribution is far
from normal gets a different constant — not a different conclusion about magnitude, but the digits
would move.

**Additivity.** C bounds an *additive* genotype-only score, which is what every score in the PGS
Catalog is. A predictor using dominance, epistasis, or anything measured about a person other than
their genotype is outside the bound and this page says nothing about it.

**The heritability estimate itself.** h²_SNP is an LDSC estimate with a standard error, in one
ancestry stratum, in one cohort. That is exactly why every ceiling here is published as a **2-SE
interval** and never as a bare point — and why the highest ceiling anywhere, taken at the top of its
interval, is reported alongside the point value. If an estimate is too low, the ceiling rises; the
program recomputes it from whatever h² you give it.

None of the three is hidden inside the arithmetic. All three are visible in the corpus and in
the program that consumes it.

## What we call, and what we refuse to call

**We call this bound sound, and we call it the strongest kind of result this
research program produces.**
Every other number in a genetics study depends on a matched background surviving a confound someone
tried to build. This one depends on no background at all — it is arithmetic over a published
heritability, and it holds whatever anyone's data turn out to say.

**We refuse to call any of it a statement about a person.** C is a population rate over two
randomly drawn members of a stratum. It says nothing about any individual, in either direction, and
no individual genotype exists in this corpus.

**We refuse to convert any of it into a fitness determination, a hiring signal, or a scheduling
rule.** Using genetic information for employment or assignment decisions is prohibited under the US
Genetic Information Nondiscrimination Act and comparable law elsewhere. That is a fact about what
may be built, and the ceiling above is a fact about what *could* be built even if it were lawful.
Both point the same way.

**We refuse to read a heritability of an occupation as a capacity.** It is selection into the job.
The corpus cannot separate the two and neither can we.

**Where a bench should point.** The heritable signal that a worker actually needs measured — how
long they have been awake before the shift starts — is not in this corpus and is not in any
operational record. It is the axis with the best-characterised curve and the worst coverage. See
[Where humans actually yield](Where-Humans-Actually-Yield.md).

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
xcrun swiftc -O -swift-version 5 reproduce/genotype-score-ceiling-exact.swift -o /tmp/gc
/tmp/gc
```

Twenty-five self-test arms run before any corpus byte is read, in both directions — π is required
to bracket the canonical constant **and** to exclude two constants wrong by 1e-40; sin(π/6) must
contain ½ and must exclude 0.51; C must hit its exact rational images at ρ² = 0, ¼, ½, ¾, 1 and must
miss 0.7 at ρ² = ¼. One arm corrupts π to 3 and is **required to fail**; the arm after it restores
the engine and requires the hit to return, so the mutant is shown to be the cause. If any arm fails,
no ceiling table and no seal are emitted.

The program takes **no argument and no stdin**, and prints its published reference figures as its
very first action — before any file is opened — so every refusal path prints them and no early exit
can go uninstrumented. The corpus root is discovered by walking outward from the binary and the
working directory; nothing absolute is baked in, and the seal is identical from any directory.

The staged label file carries the field descriptions and **not** the answer: the C columns were
removed before staging, and the program refuses outright if one reappears.

```
  arms run = 25   failed = 0
  pins disagreeing = 0
MARKER  GENOTYPE_SCORE_CEILING__EXACT_ARCSIN_BRACKET_OVER_1E12
sha256  438bfa14cf0c4ab6e013af73173d78d16d8ecae2c78a438ff034482579733359
```

Corpus and provenance: `corpus/genotype-ceiling/`, digest-pinned, aggregate statistics only.

---

## Rights — source-available, not open-source

The bound, the law that computes it and every figure are published so anyone may check them.
Re-deriving these numbers from the public releases requires no permission and no agreement with us.
Affine.Earth asserts no claim over the UK Biobank, the Neale lab release or the PGS Catalog, which
belong to their authors and to the public.
