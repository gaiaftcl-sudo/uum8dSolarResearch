# Study 42 — The Exact Contract

*2,721,780 real flood-insurance settlements, graded against the algebra written into the contracts
they settle. Money is carried as native `Int128` cents and no float touches the data at any point.
**The contract's own arithmetic reproduces 114,944 settlements exactly, and 214,926 pay more than the
damage the same record reports.** Water depth is a real step in payout and is nowhere near rigid
enough to trigger one. And two runs of this law over the same bytes sealed to different digests until
a tie-break was made total — which is the strongest argument on this page for sealing anything.*

**Status: RESULTS SEALED 2026-09-08** · marker `STUDY42_THE_EXACT_CONTRACT`
— corpus public, anonymous and digest-pinned (`79ef60dd…843`, 2,721,780 settlements, single archive
vintage `asOfDate 2026-06-01`); 26 control arms passing in both directions; determinism proven across
process boundaries; every figure printed by `reproduce/exact-contract-nfip.swift`.
**The subject under grading is the arithmetic and the structural integrity of the instrument.**
No claimant, no community, no insurer and no individual payout decision is assessed anywhere in this
work, and nothing here is advice.

## The architecture, which is half the result

| layer | rule |
|---|---|
| **ingestion** | every money field is multiplied by 100 at the parser and carried as a native `Int128` of exact cents. `7243.04` is read as `724304`. **No `Float`, no `Double`, no float literal touches the data.** More than two decimal places is a distinct answer, never a silent truncation; an empty field is `ELEMENT_MISSING`, never a zero. |
| **mesh** | an `Int128` crossing a node boundary is serialised strictly as a decimal `String` and parsed back. No binary packing, so no endianness to agree on and no width to negotiate. |
| **seal** | SHA-256 written here in integer arithmetic, no dependency, checked against the published digests of `""` and `"abc"`. |

Measured on ingest: **15,173,855** money fields read as exact `Int128` cents, **3,878,605** recorded
`ELEMENT_MISSING`, and **zero** malformed, **zero** carrying more than two decimal places.

**The mesh boundary is proven on every run, not asserted.** The corpus is sharded nine ways —
302,420 settlements each, exactly — every `Int128` goes out as a `String` and comes back, the shards
are recombined, and the recombined ledger must seal identically to the whole-corpus ledger:

```
Int128 String round-trip failures      = 0
MESH SEAL   = 8a0bc3227eeedc062896c237099239e461fefb2affc33ca4147ef795ebcd0291
LEDGER SEAL = 8a0bc3227eeedc062896c237099239e461fefb2affc33ca4147ef795ebcd0291
mesh ledger equals whole-corpus ledger = true
```

## The determinism defect the seal caught

**Two full runs of this law, over the same corpus, on the same machine, returned 50 and then 51
recovered ladder entries and sealed to different SHA-256 digests.**

The cause was ours. `Dictionary.max(by:)` resolves a tie by iteration order, and Swift seeds
Dictionary hashing per process, so when two residual values tied for the modal count the winner
changed between runs — and when the arbitrary winner failed the whole-dollar filter, the entry
disappeared. Nothing in the output looked wrong either time; both counts were plausible.

> **A study that had not sealed its ledger would have published one of the two and never known there
> was another.**

Fixed by ranking on a **total** order — count descending, residual ascending — and pinned by two arms,
one of which has to cross a process boundary, because a repeat inside one run shares the hash seed and
cannot see the defect. Verified: two independent runs now return 51 entries and identical corpus,
ledger and mesh seals.

This is Constraint 5 failing inside our own instrument rather than in a float, and it is recorded here
at the same weight as any result about the archive.

## The deductible ladder is recovered, not looked up

No code-to-amount table is supplied. For each `(deductible code, decade of loss)` the program takes
the most common value of `damage − paid` among settlements not capped at the limit. The recovered
values reproduce the published NFIP schedule — `F` is $1,250 in the 2010s, `1` is $1,000 in the 2000s
and $750 in the 1990s, `2` is $2,000, `5` is $5,000, blank is $200 in the 1970s — so the instrument
re-derives a known contractual constant before grading anything with it. **51** `(code, decade)`
entries recovered; a pair from which no whole-dollar amount can be recovered is REFUSED, never assumed.

**A single amount per code is measurably wrong**, which is why the ladder is era-scoped: code `F`
recovers **$1,250** from the 2017 settlements and **$500** across the undivided corpus.

**And the ladder's weakness is itself the finding.** The modal support is small — typically well under
one settlement in twenty. `damage − paid` is **not** concentrated at the deductible, so the deductible
is not what determines most settlements.

## Analysis 1 — the contractual invariant

`paid == min(damage − deductible, coverage)`, in exact `Int128` cents. The bins are disjoint and
tested in this order; all 2,721,780 settlements landed in exactly one.

| bin | settlements | per million | residual total |
|---|---|---|---|
| `ONE_DOLLAR_ROUNDING_SHEAR` | **823,111** | 302,416 | 36,972,497 cents |
| `RESIDUAL_OTHER` | **770,382** | 283,043 | 280,284,081,879 cents |
| `ABSENT` | **690,929** | 253,851 | — |
| **`NEGATIVE_RESIDUAL`** | **214,926** | 78,965 | **195,548,144,806 cents** |
| `EXACT_MATCH` | **114,944** | 42,231 | — |
| `LIMIT_CAP` | **93,172** | 34,232 | — |
| `LADDER_REFUSED` | **14,316** | 5,259 | — |

**`RESIDUAL_OTHER` is not an error count and must not be read as one.** It is where the rest of the
policy lives: depreciation to actual cash value, coverage sublimits, and the split between building
and contents cover. Those are real contract mechanics that the public record does not carry enough
fields to reconstruct. The honest statement is the narrow one — **the stated algebra determines
114,944 of 2,721,780 settlements exactly**, and the remainder is determined by terms the archive does
not publish.

**`NEGATIVE_RESIDUAL` is the one class that is a statement about the record itself**: 214,926
settlements where the payment exceeds the damage figure the same row reports. That is a
field-consistency fact about two columns of a public archive, not a claim about any payment being
wrong — a damage figure recorded short, or recorded on a different basis from the payment, produces it
exactly as readily.

**`LIMIT_CAP` read zero until the bin order was corrected.** When the entitlement exceeds the limit the
expected payment *is* the limit, so testing `EXACT_MATCH` first absorbed every capped settlement into
it. The bin could never fire. It now fires 93,172 times.

## Analysis 2 — the Parametric Trigger Matrix

Not a fitted relation and not a curve: a discrete map from an integer depth to an integer payout,
asking whether a public integer measurement is rigid enough to execute a contract without human
adjustment. Every order statistic is exact integer cents; every ratio is an exact integer count over
an exact integer count.

> **The step exists. The rigidity does not.** They are two answers and they are reported apart.

**The step**, conditioned on single-family occupancy in a mapped high-risk zone:

| depth (ft) | 0 | 1 | 2 | 3 | 4 | 5 | 10 |
|---|---|---|---|---|---|---|---|
| median paid (cents) | 620,802 | 777,002 | 1,258,800 | 1,549,515 | 1,932,937 | 2,660,000 | 6,042,274 |

The median rises roughly tenfold from depth 0 to depth 10. Over the **11** depths carrying 10,000 or
more settlements there are **3 inversions**; over the full 31-depth range there are **12**, and the
longest strictly increasing run is **6 consecutive depths**. The step is real where the depths carry
volume and noisy where they do not, and both halves are stated.

**The rigidity:** **no depth** has a majority of settlements within a quarter of its own median. The
best case anywhere is **192,107 per million** — 19.2%, at depth 10, already conditioned on occupancy
and zone. Unconditioned it sits near 105,000–140,000 per million across every depth.

> **Fewer than one settlement in five sits within a quarter of its own depth's median payout.**
> Integer water depth will not execute a contract without human adjustment.

That is the actionable result for the domain, and it points where the useful work is: a parametric
instrument written on this measurement would misprice four settlements in five, so the search is for a
public integer with more structural rigidity, not for a better fit to this one.

## Analysis 3 — the appointment

The gauge side is the four-gauge USGS corpus already pinned in this repository for the Guadalupe crest
of 2025-07-04, whose 10.000 ft crossings are Hunt 03:00 and Kerrville 06:00.

| | |
|---|---|
| 2025 settlements in the gauged counties | **125** |
| dated the crest day 2025-07-04 | **117** |
| | **936,000 per million, on one day out of the year** |

The institutional record lands on the physical record's day. **The claims archive dates a loss to the
day, so this is a match of days and not of hours** — the hour-level appointment the gauge could support
is not measurable from this field, and is not claimed.

## Analysis 4 — the baseline lock

The archive carries its own vintage stamp: `asOfDate 2026-06-01` on all 2,721,780 settlements, a single
vintage. Today's state is sealed so that the next revision is a measurement rather than an argument.

```
CORPUS SEAL (order-independent) = 648f32eb494b7d0990446d4f7aa05971cbe395d34de0fac39937577616edee3d
LEDGER SEAL (Analysis 1 bins)   = 8a0bc3227eeedc062896c237099239e461fefb2affc33ca4147ef795ebcd0291
```

A per-settlement seal ledger is written alongside — one SHA-256 over each settlement's canonical field
tuple — so a future pull does not merely disagree in total: it names exactly which settlements moved.
**The diff cannot be taken without a baseline, and the baseline has to be taken before the revision.**

## Controls

Twenty-six arms, run every time, **in both directions** — the harness fails if any fails.

- **The SHA-256 written here** against the published digests of `""` and `"abc"`, plus a block-boundary
  case at 56 and 64 bytes.
- **The cents reader keeps every digit and refuses what is not money.** `7243.04`→724304;
  `0.5`→50 and not 5; a negative reads negative; empty is `ABSENT`; a non-decimal is `MALFORMED`;
  three decimal places is its own answer.
- **The mesh at both 128-bit extremes**, where a 64-bit packing would shear, and a corrupt wire value
  REFUSED rather than coerced.
- **Always-green:** damage $206,991.00 less a $1,250 deductible pays $205,741.00, exactly.
- **Always-red, four ways:** one dollar short is `ONE_DOLLAR_ROUNDING_SHEAR` and not `EXACT_MATCH`;
  a payment above the damage is `NEGATIVE_RESIDUAL`; an entitlement above the limit is `LIMIT_CAP`;
  a larger residual is `RESIDUAL_OTHER`.
- **Refusal and absence are distinct answers**, and neither is a verdict.
- **The bins are disjoint** — every settlement in the corpus landed in exactly one, checked against the
  corpus count.
- **Determinism, across a process boundary** — a second independent recovery returns the identical
  ladder, and the ledger seal reproduces. This is the arm that was failing.

```
control arms run    = 26
control arms failed = 0
SELFTEST PASS
```

## What this page measures, and what it does not

- **Measured:** the stated contract algebra reproduces 114,944 of 2,721,780 settlements exactly;
  214,926 settlements report a payment exceeding their own damage figure; integer water depth is a real
  monotone step in payout over the depths that carry volume and is nowhere rigid enough to trigger a
  payout; 117 of 125 settlements in a gauged reach fall on the day the gauge crested; and the whole
  ledger is reproducible across processes and across a nine-shard `String` boundary.
- **Not measured, and therefore not claimed:** whether any individual settlement was correct. The
  archive does not publish the depreciation basis, the sublimits or the adjuster's schedule, and
  without them no single settlement can be re-derived. `RESIDUAL_OTHER` is where those terms live.
- **Not measured:** the hour-level appointment. The date field is a day.
- **One archive, one vintage, one peril, one country.** Flood is not wind, and the NFIP is not a
  private carrier.
- **The negative-residual class is a two-column consistency fact**, not evidence of overpayment. A
  short damage figure produces it as readily as a large payment.

## Reproduce

No account, no key, no network at run time. The committed slice is the first 200,000 settlements in the
archive's own `$orderby=id`, reproducible from the pull script with `$top=200000`.

```
cd corpus/nfip && shasum -a 256 -c SHA256SUMS && gunzip -k nfip-claims.csv.gz
xcrun swiftc -O -swift-version 5 ../../reproduce/exact-contract-nfip.swift -o /tmp/run && /tmp/run .
```

`corpus/nfip/pull-nfip-claims.sh` rebuilds the full 2,721,780-settlement corpus from the public API,
and `corpus/nfip/full-corpus-transcript.txt` is the sealed transcript of the full run every figure on
this page is quoted from.

---

*Test claim, not efficacy. Nothing on this page is a statement about any insurer's solvency, any
community's flood risk, any claimant, or any individual payout decision. It is a statement about
arithmetic performed on a public archive, and about the structural integrity of an instrument.*
