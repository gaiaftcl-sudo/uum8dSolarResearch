# Study 38 — The loss-reserve triangle, exact against float

*Insurance reserving is arithmetic on integers a regulator already holds. We recomputed it exactly,
against the same law in floating point, on 779 company triangles whose realised runoff the corpus
also contains. The result is not the one this programme has usually found, and it is published as
measured: **at this scale the arithmetic is not the weak link.** One triangle in 482 moved by one
thousand dollars. What did move the answer — by sixteen billion — was a premise nobody checked.*

**Status: RESULTS SEALED 2026-09-08** · marker `STUDY38_RESERVE_TRIANGLE_EXACT_VS_FLOAT`
— corpus public and digest-pinned (six NAIC Schedule P line files, 5,393,021 bytes, 77,900 rows, no authentication); two laws registered separately, the first
never edited; 14 control arms passing in both directions; every figure printed by
`reproduce/reserve-triangle-exact-vs-float.swift`. **The subject under grading is the instrument.**
No insurer is assessed, no reserve opinion is offered, and nothing here is advice.

## Why we asked

The programme's other courts start from a continuous model and ask what an exact one does
differently. Actuarial reserving invites the same question and answers it in a way worth writing
down, because **its inputs are already exact.** Losses are filed as whole thousands of dollars.
Accident years and development lags are integers. A volume-weighted development factor is a ratio of
two integer column sums, so a chain-ladder reserve is an **exact rational of the filed data** — no
approximation is mathematically required anywhere in it.

That makes the question sharp and, importantly, **losable**:

> Where a legally-filed number is an exact rational of public integers, does computing it in floating
> point ever change it — and if it does not, what does?

We did not know the answer when the law was frozen. Both answers were publishable. The one we got is
the one that cuts against our own prior, so it is stated first and loudest.

## The corpus

The [CAS loss-reserving database](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/corpus/schedule-p/README.md), pulled from NAIC Schedule P and
republished by the Casualty Actuarial Society. Public, anonymous, no key. Measured SERVED 2026-09-08.

Six lines — private passenger auto, commercial auto, workers' compensation, other liability, medical
malpractice, product liability — as **accident years 1988–1997 by development lags 1–10**. Every loss
column is an integer number of thousands of dollars.

**77,900 rows. 779 complete 10×10 grids. Zero grids dropped as incomplete.**

The square is complete, which is the whole reason this corpus was chosen: it holds **the runoff as
well as the triangle**. A law applied at the year-end 1997 valuation can be graded against what
actually happened.

## The law, frozen before scoring

Volume-weighted paid chain ladder. A cell `(ay, lag)` is **observed** iff `ay + lag − 1 ≤ 1997`.

```
f_k   = ( Σ  C[ay][k+1] ) / ( Σ  C[ay][k] )      over accident years with both cells observed
U_ay  = C[ay][latest] × Π f_k                    k from latest to 9
R_ay  = U_ay − C[ay][latest]
```

Every quantity above is an exact rational. The exact arm carries no `Float`, no `Double` and no float
literal; it runs on base-1e9 big integers with schoolbook division. The float arm exists to be graded
and is computed **two mathematically identical ways** — factors accumulated ascending with accident
years summed ascending, and both descending. A difference between those two is not an accuracy claim;
it is a statement about **agreement**.

**Two laws are registered, and the first is never edited.**

- **L1** — the law as first frozen. A grid is refused only where a denominator is zero, because a
  factor with no denominator does not exist. Nothing else is checked.
- **L1′** — registered separately, after L1 had already been run, adding **one** gate and only one:
  the grid must satisfy the premise the model is an instrument for — cumulative paid non-negative and
  non-decreasing, every divided column sum positive. That is the model's own definition of its
  inputs, not a threshold chosen to improve an answer. The gate reads **only the observed triangle**,
  because a gate that read the runoff would be reading data a 1997 valuation cannot see.

## What we found

### 1. The arithmetic is not the weak link here

| law | grids scored | exact vs float differing | worst gap | float ordering A vs B differing |
|---|---|---|---|---|
| **L1** | 482 | **1** | **1 thousand dollars** | **0** |
| **L1′** | 187 | **0** | 0 | **0** |

One triangle in 482 moved by one unit — one thousand dollars on a reserve of millions. Under L1′,
nothing moved at all. And the two float orderings **never disagreed**, on any grid, under either law.

This is worth stating plainly because it is the opposite of what this programme usually measures.
[Study 34](Study-34-Observer-Invariant-Verdict.md) found a floating-point safety verdict that
contradicts itself and [Study 35](Study-35-The-Safety-Brain-That-Forgets.md) found one that degrades
over time. **Neither reproduces here.** Chain ladder is nine multiplications on values around 10⁷ in a
format carrying about 15 significant digits, and it has room to spare. *We looked for a float defect
in a legally-binding number and did not find one.*

### 2. What did move the answer, by sixteen billion

L1 scored 482 grids and returned a projected reserve total of **8,592,265** against a realised
**22,458,691**. That is not chain ladder being wrong by 62%. It is **one triangle**:

> `othliab_pos` · GRCODE 33499 · **Dorinco Rein Co** · L1 projected reserve **-16,662,494**

```
    AY         1         2         3         4         5         6         7
  1994        41      2056      4952      6857         .         .         .
  1995     -5186     -6318     -2823         .         .         .         .
  1996      1138       396         .         .         .         .         .
  1997    -10225         .         .         .         .         .         .

  f1=14043/46   — a development factor above 305
```

Cumulative paid loss is **negative** at three accident years. The lag-1 column sum is **46** — forty-six
thousand dollars, because the negatives all but cancel the positives. The development factor is
therefore above **305**, and applying it to a latest cumulative of **−10,225** projects minus sixteen and a
half billion dollars.

**The exact arm and the float arm agree on that number to the unit.** Exactness bought nothing. Both
arithmetics faithfully computed a catastrophic figure because neither was asked whether the model
applied. What was missing was not precision. It was a **REFUSAL** — which in this programme's
[ontology](Ontology.md) is a different terminal from a verdict, and is never a MISS.

### 3. The filed data does not obey the premise its own instrument assumes

Counted over all 779 grids:

| invariant | violating cells |
|---|---|
| cumulative paid **falls** as development advances | **2,390** |
| paid exceeds incurred | **823** |
| cumulative paid is negative | **313** |
| earned premium varies within an accident year | **0** |

**583 of 779 grids carry at least one violation.** Restricted to the observed triangle — all a 1997
valuation can see — it is **870** falling cells, **130** negative cells, and **370 of 779 grids**.

None of these are errors by the filers. Negative cumulative paid is what salvage, subrogation and
reinsurance recoveries look like on a net basis, and it is a real feature of the business. The finding
is not that the data is wrong. It is that **the instrument's premise and the data's actual shape are
different things, and nothing in the pipeline compares them.**

Under L1′ that comparison is made: **592 of 779 grids are refused**, and the 187 that remain project
**21,770,741** against a realised **19,041,666** — over by 14%, which is an ordinary actuarial result.

### 4. The instrument works at the scale a regulator reads it

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
individual negatives cancel in the pooling. Every projection lands within about 15% of the realised
runoff, and exact and float agree on all six.

So the defect is **scale-dependent**: it is invisible at the aggregate a supervisor reads and lives in
the individual filings underneath it. That is a statement about where to look, and it is the most
transferable thing on this page.

## Controls

Fourteen arms, run every time, **in both directions** — the harness fails if any of them fails.

- **Exact machinery on answers known in advance.** `10^18 / 7 = 142857142857142857 remainder 1`;
  a 999999999-limb carry; half-away-from-zero rounding on `±3/2`.
- **Always-green.** A fully-developed triangle owes exactly zero, in the exact arm and in both float
  orderings, and the premise gate admits it.
- **Always-red.** A triangle whose every cumulative value exceeds **2⁵³ = 9,007,199,254,740,992** —
  the largest integer a `Double` represents exactly — must part the arms. It does. *Without this arm
  a comparator that had silently stopped comparing would have reported the same clean result as the
  one above,* which is the defect this programme names most often.
- **Refusal is not a verdict.** An all-zero triangle returns `zeroDenominator`, never a reserve of 0.
- **The gate fires and does not over-fire.** It fires on a negative cell, fires on a falling cell, and
  does **not** fire on the always-green control.
- **The law reads the valuation date it declares.** Writing into an unobserved cell does not move any
  factor.
- **The two laws are distinguishable on this corpus.** If L1 and L1′ returned the same census, one of
  them would not exist.

```
control arms run    = 14
control arms failed = 0
SELFTEST PASS
```

## The court

The live [finance court](Affine-Earth-Lattice-Endpoints.md) already declares this domain's law —
`tick in Z; PnL = lots * ticks; discount n/d per period`, marker `FINANCE_TICK_IS_THE_COURT` — and
until today carried **no numbered study**. Two claims were posted to it and returned WIN:

- `finance/auditor`, the L1′ projected reserve as an exact integer tick count: **21,770,741**.
- `cs/compiler`, the two leading industry age-to-age factors added exactly:
  `74989020/41509839 + 78100830/65088178 = 8122851560871930/2701799789583342`.
  **Verified independently** rather than trusted — the same numerator and denominator, digit for
  digit, from arbitrary-precision arithmetic outside the court.

**One measured gap in the court itself, reported because it is a fact about the instrument.** The
catalog advertises the `finance/risk` role as ingesting `loss_ticks` and `threshold_ticks` — the
shape a reserve-against-an-action-level verdict needs. The grader refuses without `lots` and `ticks`
(`REFUSED_NO_INSTANCE — this study grades on lots, ticks`) and, once given them, ignores the threshold
pair entirely and returns a PnL. The advertised shape and the graded shape are different. That is not
a defect this study created and it is not fixed here; it is named.

## What would falsify this

1. **A domain where the same law does move.** Reserving at long tail lengths, or discounting at fine
   rate granularity over fifty-year pension horizons, involves far more multiplications than nine. If
   exact and float part there, section 1's finding is bounded to short-tail casualty and must say so.
2. **The premise gate being wrong rather than strict.** 592 refusals of 779 is a lot. If a working
   actuary can show that negative cumulative development is routinely handled by a documented
   adjustment that restores the premise, then L1′ refuses grids that a practitioner would rightly
   score, and the count is an artefact of our reading rather than of the data.
3. **A second corpus.** This is one database, one decade, one country's filings. A second archive
   with a different reporting basis could invert section 3 entirely.

## Facts on the record that cut against us

- **Floating point was adequate for the task we set it.** Section 1 is a null result for the
  programme's central thesis in this domain, and it is the headline rather than a footnote.
- **The 305 development factor is not hidden.** Any actuary reading that triangle would see it
  immediately; nothing here uncovers a concealed defect. What the study measures is that **an
  automated pipeline that computes rather than reads will not see it**, and that both an exact and a
  floating-point pipeline compute it alike.
- **Chain ladder itself performed reasonably** at every aggregate whose premise held — within about
  15% of realised runoff on a ten-year projection. This page is not an indictment of the method.

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
