# Study 38 — The loss-reserve triangle, exact against float

*A loss reserve is an exact rational of integers a regulator already holds. We computed it exactly on
779 public company triangles whose realised runoff the corpus also contains, and against the same law
in floating point. **Exact and float agree at the reporting unit on 481 of 482 triangles.** The number
that moves — by sixteen billion — is produced by a premise nothing checks, and both arithmetics
produce it identically.*

**Status: RESULTS SEALED 2026-09-08** · marker `STUDY38_RESERVE_TRIANGLE_EXACT_VS_FLOAT`
— corpus public and digest-pinned (six NAIC Schedule P line files, 5,393,021 bytes, 77,900 rows, no
authentication); two laws registered separately, the first never edited; 14 control arms passing in
both directions; every figure printed by `reproduce/reserve-triangle-exact-vs-float.swift`.
**The subject under grading is the instrument.** No insurer is assessed, no reserve opinion is
offered, and nothing here is advice.

## The exact form of a reserve

Reserving inputs are already exact. Losses are filed as whole thousands of dollars. Accident years and
development lags are integers. A volume-weighted development factor is a ratio of two integer column
sums, and a product of ratios of integers is a ratio of integers.

> **A volume-weighted chain-ladder reserve is an exact rational of the filed data. No approximation is
> mathematically required anywhere in it.**

That is the first fact on this page and it holds independently of anything measured below. It makes
the reserve a **replayable object**: two people holding the same filing reach the same rational, and
the rational is the answer rather than an approximation to one.

## The corpus

The [CAS loss-reserving database](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/corpus/schedule-p/README.md),
pulled from NAIC Schedule P and republished by the Casualty Actuarial Society. Public, anonymous, no
key. Measured SERVED 2026-09-08.

Six lines — private passenger auto, commercial auto, workers' compensation, other liability, medical
malpractice, product liability — as **accident years 1988–1997 by development lags 1–10**. Every loss
column is an integer number of thousands of dollars.

**77,900 rows. 779 complete 10×10 grids. Zero grids dropped as incomplete.**

The square is complete, and that is why this corpus was chosen: it holds **the runoff as well as the
triangle**. A law applied at the year-end 1997 valuation is graded against what happened, not against
another model.

## The law, frozen before scoring

A cell `(ay, lag)` is **observed** iff `ay + lag − 1 ≤ 1997`.

```
f_k   = ( Σ  C[ay][k+1] ) / ( Σ  C[ay][k] )      over accident years with both cells observed
U_ay  = C[ay][latest] × Π f_k                    k from latest to 9
R_ay  = U_ay − C[ay][latest]
```

The exact arm carries no `Float`, no `Double` and no float literal; it runs on base-1e9 big integers
with schoolbook division. The float arm is computed **two mathematically identical ways** — factors
accumulated ascending with accident years summed ascending, and both descending — so that agreement
between orderings is measured rather than assumed.

**Two laws are registered, and the first is never edited.**

- **L1** — refuses a grid only where a denominator is zero, because a factor with no denominator does
  not exist.
- **L1′** — registered separately, adding **one** gate: the grid must satisfy the premise the model is
  an instrument for — cumulative paid non-negative and non-decreasing, every divided column sum
  positive. That is the model's own definition of its inputs. The gate reads **only the observed
  triangle**, because a gate reading the runoff would read what a 1997 valuation cannot see.

## 1. Exact and float, measured

| law | grids scored | rounded verdicts differing | worst gap | float ordering A vs B differing |
|---|---|---|---|---|
| **L1** | 482 | **1** | **1 thousand dollars** | **0** |
| **L1′** | 187 | **0** | 0 | **0** |

**481 of 482 triangles carry the identical verdict in both arithmetics.** The one that differs
differs by a single unit. The two float orderings agree on every grid under both laws.

The measurement that produces this is small: nine multiplications on values around 10⁷, in a format
carrying about 15 significant digits. **The reading is bounded to that shape** — it is a fact about
short-tail casualty chain ladder at this magnitude and depth, and it transfers to another arithmetic
depth only by being measured there.

## 2. The number that moves, and what produces it

L1 scored 482 grids for a projected total of **8,592,265** against a realised **22,458,691**. One
triangle accounts for the distance:

> `othliab_pos` · GRCODE 33499 · **Dorinco Rein Co** · L1 projected reserve **-16,662,494**

```
    AY         1         2         3         4         5         6         7
  1994        41      2056      4952      6857         .         .         .
  1995     -5186     -6318     -2823         .         .         .         .
  1996      1138       396         .         .         .         .         .
  1997    -10225         .         .         .         .         .         .

  f1=14043/46   — a development factor above 305
```

Cumulative paid loss is negative at three accident years, so the lag-1 column sum is **46**: the
negatives all but cancel the positives. A factor above 305 applied to a latest cumulative of
**−10,225** projects minus sixteen and a half billion dollars.

**The exact arm and the float arm agree on that figure to the unit.** Both arithmetics computed it
faithfully, because neither was asked whether the model applied.

> **The terminal the instrument needed was REFUSED, and precision is not that terminal.**

In this programme's [ontology](Ontology.md) `REFUSED` is a distinct answer from a verdict and is never
a MISS or a substituted zero. Exactness is a property of the arithmetic; a premise is a property of the
inputs. A court that answers only the first computes a confident number wherever the second was never
asked.

## 3. The filed data and the premise, counted

Over all 779 grids:

| invariant | violating cells |
|---|---|
| cumulative paid **falls** as development advances | **2,390** |
| paid exceeds incurred | **823** |
| cumulative paid is negative | **313** |
| earned premium varies within an accident year | **0** |

**583 of 779 grids carry at least one violation.** Restricted to the observed triangle — all a 1997
valuation can see — it is **870** falling cells, **130** negative cells, and **370 of 779 grids**.

These are not filing errors. Negative cumulative paid is what salvage, subrogation and reinsurance
recoveries look like on a net basis, and it is an ordinary feature of the business. The fact is that
**the instrument's premise and the data's actual shape are different objects, and nothing in the
pipeline compares them.**

L1′ makes that comparison: **592 of 779 grids refused**, and the 187 that remain project
**21,770,741** against a realised **19,041,666**.

## 4. The same law at the scale a supervisor reads

Every company in a line summed cell by cell:

| line | premise | projected | realised | exact == float |
|---|---|---|---|---|
| private passenger auto | held | 17,138,459 | 15,618,034 | yes |
| commercial auto | held | 1,743,193 | 1,580,311 | yes |
| workers' compensation | held | 2,777,813 | 2,416,210 | yes |
| other liability | held | 1,640,597 | 1,667,562 | yes |
| medical malpractice | held | 1,330,331 | 1,158,410 | yes |
| product liability | **VIOLATED** | 531,649 | 532,558 | yes |

**Five of six aggregate premises hold**, against 370 of 779 at the company level, because the
individual negatives cancel in the pooling. Every aggregate projection lands within about 15% of the
realised runoff, and exact and float agree on all six.

> **The premise gap is scale-dependent: absent from five of six pooled aggregates, present in 370 of
> 779 individual filings.**

That is the most transferable fact on this page. "The instrument holds" and "the instrument holds
where anyone looks at it" are two different statements, and only the second was ever checked.

## Controls

Fourteen arms, run every time, **in both directions** — the harness fails if any fails.

- **Exact machinery on answers known in advance.** `10^18 / 7 = 142857142857142857 remainder 1`; a
  999999999-limb carry; half-away-from-zero rounding on `±3/2`.
- **Always-green.** A fully-developed triangle owes exactly zero in the exact arm and in both float
  orderings, and the premise gate admits it.
- **Always-red.** A triangle whose every cumulative value exceeds **2⁵³ = 9,007,199,254,740,992** —
  the largest integer a `Double` represents exactly — parts the arms. Without this arm, a comparator
  that had silently stopped comparing would print the same clean table as section 1.
- **Refusal is not a verdict.** An all-zero triangle returns `zeroDenominator`, never a reserve of 0.
- **The gate fires and does not over-fire.** It fires on a negative cell, fires on a falling cell, and
  does **not** fire on the always-green control.
- **The law reads the valuation date it declares.** Writing into an unobserved cell moves no factor.
- **L1 and L1′ are distinguishable on this corpus.** Identical censuses would mean one law does not
  exist.

```
control arms run    = 14
control arms failed = 0
SELFTEST PASS
```

## The court

The live [finance court](Affine-Earth-Lattice-Endpoints.md) declares this domain's law —
`tick in Z; PnL = lots * ticks; discount n/d per period`, marker `FINANCE_TICK_IS_THE_COURT` — and
carried no numbered study until this one. Two claims were posted and returned WIN:

- `finance/auditor`, the L1′ projected reserve as an exact integer tick count: **21,770,741**.
- `cs/compiler`, the two leading industry age-to-age factors added exactly:
  `74989020/41509839 + 78100830/65088178 = 8122851560871930/2701799789583342`.
  **Verified independently** rather than trusted — the same numerator and denominator, digit for
  digit, from arbitrary-precision arithmetic outside the court.

One measured fact about the court's own surface: the catalog advertises the `finance/risk` role as
ingesting `loss_ticks` and `threshold_ticks` — the shape a reserve-against-an-action-level verdict
needs. The grader refuses without `lots` and `ticks`
(`REFUSED_NO_INSTANCE — this study grades on lots, ticks`) and, once given them, returns a PnL without
reading the threshold pair. The advertised shape and the graded shape are different.

## What this page measures, and what it does not

- **Measured:** a chain-ladder reserve is an exact rational; the two arithmetics agree at the unit on
  481 of 482 triangles and across both orderings; one triangle projects −16,662,494 and both
  arithmetics produce it identically; 370 of 779 observed triangles violate the model's premise; five
  of six pooled aggregates do not.
- **Not measured, and therefore not claimed:** the arithmetic reading at greater depth. Long-tail
  reserving and fifty-year discounting involve far more multiplications than nine, and this corpus
  says nothing about them.
- **Not measured:** whether a documented practitioner adjustment restores the premise on grids L1′
  refuses. If one does, the refusal count is a fact about our reading of the filings rather than about
  the filings.
- **One corpus, one decade, one country's filings.** A second archive on a different reporting basis
  is a separate measurement.
- **The 305 factor is visible.** Any actuary reading that triangle sees it at once. What is measured
  here is that a pipeline that computes rather than reads does not, and that exact and floating-point
  pipelines compute it alike.

## Reproduce

No account, no key, no network at run time. The corpus is pinned in this repository.

```
cd corpus/schedule-p && shasum -a 256 -c SHA256SUMS
xcrun swiftc -O -swift-version 5 ../../reproduce/reserve-triangle-exact-vs-float.swift -o /tmp/run && /tmp/run
```

`bash reproduce/validate.sh` runs it inside the full harness, which verifies the digests, runs the
program, and checks that every figure quoted on this page appears in its output.

---

*Test claim, not efficacy — and in this domain that phrase has a specific meaning. Nothing on this
page is a statement about any insurer's solvency, adequacy of reserves, or compliance with any
requirement. It is a statement about arithmetic performed on public filings, and about a premise that
an instrument assumes and does not check.*
