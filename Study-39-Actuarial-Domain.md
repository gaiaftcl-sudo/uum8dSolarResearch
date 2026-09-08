# Study 39 — The actuarial domain, exact against float

*Study 38 measured property-and-casualty reserving. This covers the rest of the domain — life,
pensions, multi-state health, and aggregation at the discrete cuts a capital regime is written on —
on two public archives whose every published value is fixed-decimal, and therefore an exact rational
before any arithmetic runs. **Across 10,878 measured quantities the exact and floating-point answers
agree to at least fourteen significant digits, in every arm.** The reporting units the rules are
written on sit eleven digits coarser than that.*

> [!NOTE]
> **CORRECTED 2026-09-08, the same day it was sealed — the first version of this page reported a
> tightest margin of eight significant digits and read something into it. That was our instrument,
> not the arithmetic.** The first comparator rounded both values at each digit and asked whether the
> rounded results matched. An exact value whose decimal expansion terminates in a 5 sits exactly on a
> rounding tie, so the exact arm rounds half-away up while the float sits infinitesimally below and
> rounds down — and the comparator called that a disagreement. It reported a parting at the 8th digit
> for two values agreeing to the 16th. The tie is a property of the decimal expansion, not of the
> arithmetic. The comparator now measures the exact relative difference — a `Double` is a binary
> rational exactly, from its own bit pattern, so `|exact − float| / |exact|` is a ratio of two
> integers and nothing is rounded at all. **The corrected reading is 14 significant digits, uniform
> across all three arms**, and the paragraph that read meaning into the shortest product is retired
> below. A 21st control arm now pins that specific tie case at 15 digits or more, so the defect
> cannot return unnoticed.

**Status: RESULTS SEALED 2026-09-08** · marker `STUDY39_ACTUARIAL_DOMAIN_EXACT_VS_FLOAT`
— two public archives, digest-pinned, no authentication; 21 published life tables (16,128 values,
zero cells the archive does not serve) and 295 monthly statutory rate triples; 21 control arms passing
in both directions; every figure printed by `reproduce/actuarial-domain-exact-vs-float.swift`.
**The subject under grading is the arithmetic and the instrument.** No person, insurer, pension scheme
or country is assessed, and nothing here is advice.

## The exact form of the domain

Actuarial inputs are published as decimal strings with a fixed number of places. A fixed-decimal
string is an exact rational: `0.00023` is `23/100000` and `4.42` percent is `442/10000`. Nothing about
these values is approximate until someone chooses to approximate them.

> **Every published input in this domain is an exact rational, and every quantity built from them by
> the standard formulae — annuity, assurance, net premium, deferred pension value, n-step transition —
> is a ratio of two integers.**

The programs below never parse a published decimal into a binary float in the exact arm. Values are
read as digit strings and carried as integers over a stated power of ten, and the present values are
built over a **common denominator** so that no rational addition is ever needed and nothing is reduced
or rounded until the reporting unit.

## The archives

Both measured SERVED 2026-09-08, HTTP 200, no key.
[Provenance and the two reading traps](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/corpus/actuarial/README.md).

- **Eurostat `demo_mlifetable`** — 21 life tables (DE, FR, IT, ES, PL, NL, SE × 2019, 2021, 2022),
  eight published indicators over the single-year age ladder. **16,128 values, three distinct
  published precisions, and zero cells the archive does not serve.**
- **IRS minimum-present-value segment rates, IRC §417(e)(3)(D)** — **295 monthly triples**, each rate
  to two decimal places. The most recent published month serves `442, 547, 631` basis points, exactly.

**Two things in the life-table archive are not what they look like, and both were measured rather
than assumed.** The age dimension carries 97 categories of which the single-year ladder is 96:
`Y_GE85` is an aggregate published beside the ladder, and reading it as an age makes it look like a
missing cell that deletes every younger age depending on it. And the terminal open interval carries
`q = 1.0` exactly, so any chain running through it terminates with probability exactly zero — true,
and a measurement of nothing. The ladder is therefore built by name and the chains end at the last
closed age.

## 1. The published tables against their own integer identities

A life table asserts arithmetic about itself. Each identity is checked **exactly**, in the published
units, with no tolerance; a near-miss is counted separately from a pass, because they are different
answers.

| identity | holds exactly | does not | of which off by exactly one published unit |
|---|---|---|---|
| `q(x) + p(x) = 1` | **2,016** | **0** | — |
| `l(x+1) = l(x) − d(x)` | 1,510 | 485 | **485** |
| `T(x) = T(x+1) + L(x)` | 1,469 | 526 | **526** |

> **In 3,990 identity tests there is no residual larger than one unit in the last published place.**

The complementary probabilities close exactly, everywhere. The two accumulation identities close to
the limit of the precision the publisher chose to print, and no further — which is what a rounded
table is, stated as a measurement rather than assumed.

*(For contrast, and it is a contrast rather than a comparison: the Schedule P filings in
[Study 38](Study-38-Loss-Reserve-Triangle.md) carry 2,390 cells where a cumulative total falls, by
arbitrary amounts. Two archives, two different shapes, both measured the same way.)*

## 2. Life assurance — the net premium

Whole-life assurance over a whole-life annuity-due, per 100,000 sum assured, at each of the three
published segment rates. The denominators cancel exactly, so the exact premium is a ratio of two
integers and nothing is rounded until the reporting unit.

| | |
|---|---|
| premiums computed | **6,048** (21 tables × 3 rates × 96 ages) |
| deepest term reached | **95 discount multiplications** |
| verdicts differing at the reporting unit | **0** |
| fewest agreeing significant digits | **14** |

The distribution of leading significant digits on which the two arithmetics agree: 14 in **1,158**
cases, 15 in **3,845**, 16 in **922**, 17 in 111, 18 in 11, and 19 in one.

**This is the depth question Study 38 could not reach.** That study measured nine multiplications and
said so; this one measures ninety-five, and the reading holds.

## 3. Pensions — the deferred annuity

The lump sum per 1,000 of annual pension deferred to age 65 and paid for life — the shape the
minimum-present-value rule is written on — at the same three published rates.

| | |
|---|---|
| entry ages scored | **2,835** |
| deepest term reached | **75 discount multiplications** |
| verdicts differing at the reporting unit | **0** |
| fewest agreeing significant digits | **14** — 1,028 cases at 14, 1,729 at 15, 71 at 16 |

## 4. Multi-state — the n-step survival chain

A life table is a two-state Markov chain and its n-step transition is an exact product of published
rationals, ending at the last closed age.

| | |
|---|---|
| chains scored | **1,995** |
| longest chain | **95 steps** |
| verdicts differing at parts per billion | **0** |
| fewest agreeing significant digits | **14** — `IT 2022, from age 9, 86 steps` |

Sixteen chains agree to 14 digits, 1,495 to 15, 442 to 16, and the rest higher. The fewest-agreeing
case is a **long** product — 86 steps — which is the direction accumulated rounding actually runs.

*The first version of this page reported this arm's tightest margin as 8 digits in a two-step chain
and built a paragraph on the reversal. That number was an artifact of the comparator, as the note at
the top of this page records; the corrected measurement removes both the number and the reading.*

**A three-state morbidity chain is not measured here and is not claimed.** The transition rates it
needs are not served by an open archive: the SOA MORT tables sit behind a postback application that
returns HTML to a direct request, and the Human Mortality Database returns a login page. Both measured
2026-09-08. That is **ABSENT** — a fact about the archives, not a result about morbidity.

## 5. Aggregation — does the order of the sum change the total

A capital figure is a sum over many positions, and floating-point addition is not associative. The
same law, the same data, three orderings, on the 779 filed integers of Study 38's corpus.

| | |
|---|---|
| values summed | **779 filed integers** |
| the exact total, one value | **22,973,085** |
| distinct float totals across three orderings | **1** |
| spread between orderings | **0** |
| largest single value | 11,561,327 |
| the exactly-representable ceiling of a `Double` | **9,007,199,254,740,992** |

Every value and every running total sit far below that ceiling, so each addition is exact and the
ordering cannot matter. **That is a statement about magnitude, not about floating point being
associative** — and the control arm below runs the same code past the ceiling and watches the two
orderings part.

## 6. What this means at a discrete cut

Capital and solvency regimes are written on **integer cuts** — the US risk-based-capital action levels
are published as 200, 150, 100 and 70 percent, and a verdict is which side of a cut a figure falls.
The measurement above answers that question in the form it is actually asked:

> **A verdict rendered at a cut expressed to fewer than fourteen significant digits cannot flip
> between the exact and the floating-point form of these quantities, anywhere in the 10,878 measured
> here.** The cuts are written to three.

That is the transferable statement, and it is a bound rather than a reassurance: it holds for the
quantities and depths measured on this page and transfers to another depth only by being measured
there.

## Controls

Twenty-one arms, run every time, **in both directions** — the harness fails if any fails.

- **Exact machinery on answers known in advance.** `10^18 / 7 = 142857142857142857 remainder 1`;
  `10^19` has twenty characters; half-away rounding on `3/2` and `1/2`.
- **The fixed-decimal reader keeps digits and refuses what is not a decimal.** `0.00023` → 23 at
  scale 5; `4.42` → 442 at scale 2; a bare integer at scale 0; `abc`, `1.2.3` and the empty string
  refused; `scaled()` pads and never truncates.
- **The age ladder excludes an aggregate rather than counting it absent** — contiguous from 0, one
  terminal open interval, 96 steps from the 97 categories served.
- **Always-green.** A table nobody dies in has an assurance numerator of exactly zero and an annuity
  numerator that is not zero.
- **Always-red, four ways.** Agreement is finite and not identical on inputs past 2⁵³; exact `1/3`
  against `Double(1/3)` agrees to 15–17 digits and no more; exact `1/3` against `0.34` agrees to at
  most **one** significant digit; and 201 values summed both ways differ once past 2⁵³.
- **Always-green on the same instrument.** Exact `1/4` against `0.25` is the identical rational — so
  the detector is not simply reporting a difference every time.
- **The tie that broke the first comparator is pinned.** The exact value `6360389250/10^10` against
  its floating-point product must agree to **15 digits or more**. Under the first instrument this
  case read 8.
- **Zero is a distinct answer.** A value of exactly zero returns the not-measurable sentinel, never
  the "they agree everywhere" code. Without this arm the survival chains reported perfect agreement
  for the reason that both sides had rounded to nothing.
- **The identity arms are testing something** — they ran on every published age, and they do not all
  return the same census.

```
control arms run    = 21
control arms failed = 0
SELFTEST PASS
```

## What this page measures, and what it does not

- **Measured:** every published input in this domain is an exact rational; the published tables satisfy
  their own identities with no residual above one unit in the last printed place; across 10,878
  quantities at depths to 95 multiplications, exact and float agree to at least 14 significant digits
  in every arm; and a sum of filed integers below 2⁵³ is order-independent because each addition is
  exact.
- **Not measured, and therefore not claimed:** a three-state morbidity chain, for want of an open
  archive. Recorded ABSENT with both archives named and their responses dated.
- **Not measured:** stochastic capital modelling. A Monte Carlo capital figure's reproducibility is a
  property of a particular firm's model, and constructing one here would be measuring our own
  construction rather than the field's.
- **Two archives, seven countries, three years, one statutory rate series.** A different reporting
  basis is a different measurement.
- **The margin is uniform at 14 digits across all three arms**, and the fewest-agreeing case in each
  is a deep product rather than a shallow one. The first version of this page said otherwise on both
  counts; the correction is recorded at the top rather than swapped in silently.

## Reproduce

No account, no key, no network at run time. Both corpora are pinned in this repository.

```
cd corpus/actuarial && shasum -a 256 -c SHA256SUMS
xcrun swiftc -O -swift-version 5 ../../reproduce/actuarial-domain-exact-vs-float.swift -o /tmp/run && /tmp/run
```

`bash reproduce/validate.sh` runs it inside the full harness, which verifies the digests, runs the
program, and checks that every figure quoted on this page appears in its output.

---

*Test claim, not efficacy. Nothing on this page is a statement about any insurer's solvency, any
pension scheme's funding, any country's mortality experience, or compliance with any requirement. It
is a statement about arithmetic performed on published tables.*
