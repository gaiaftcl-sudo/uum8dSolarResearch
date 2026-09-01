# Reproduce every number

Ten self-contained programs. **No imports** except `Foundation` in the two that read a
file, no dependencies, no network, no framework. Each prints the table it backs, and each
that can carry a control arm carries one.

    xcrun swiftc -O -swift-version 5 <program>.swift -o /tmp/run && /tmp/run

Two of them read the pinned corpora and must be run from the corpus directory:

    cd ../corpus/flood-lead-time && xcrun swiftc -O -swift-version 5 \
        ../../reproduce/guadalupe-wave-ledger.swift -o /tmp/run && /tmp/run


## Validate everything at once

    bash validate.sh

Checks, in order: every corpus verifies against its pinned sha256; every program compiles
and runs; **every published figure appears in the output of the program that produces it**;
the published pages carry no reference into the private substrate repository; and the live
catalogue serves with the counts the pages claim.

It refuses to report a clean boundary if it finds no pages to scan, and it carries a
positive control so a scanner that has silently stopped working cannot pass. The first
version of that check reported PASS having counted nothing — `grep -c` prints `0` *and*
exits non-zero on no match, so a `|| echo 0` fallback produced `0\n0` and broke the
arithmetic. A gate handed nothing must not exit 0.

| program | reproduces | control arm |
|---|---|---|
| `unimodular-control-arms.swift` | det = 1 by fraction-free Bareiss; 4,000 → 4,000 distinct integral images | **yes, and it is the point** — it shows image count does *not* discriminate (det 2 and det 0 also give 4,000) and that reachability does |
| `lora-time-on-air.swift` | LoRa airtimes in exact integer microseconds; the floored duty counts; every ratio | the 16 B row, which was already correct and is why the two wrong rows read as corroborated |
| `pod-energy-budget.swift` | the pod energy budget at both operating points, with every datasheet input printed | prints both the binding rate and the regulatory ceiling by construction |
| `panel-energy-margin.swift` | supply against demand for the panel specification, in all conditions | the deep-winter row |
| `gate-checks-panel-and-flux.swift` | the cold-day panel overshoot; the modular-wrap flux defect and its fix | the naive-vs-ring-delta pair |
| `cost-matrix.swift` | every row of the cost table, four markets, three aggregation ratios | the per-site and 1:100 rows are each other's arm |
| `reentry-alumina-ledger.swift` | the exact-rational reentry ledger; both readings of the same published inputs | CHECK 3 and CHECK 6 are the two readings, and both are printed |
| `z8-vs-e8-lattice.swift` | kissing numbers 16 and 240 by direct enumeration; the density ratio as an exact integer | the det = 0 and det = 2 matrices |
| `guadalupe-wave-ledger.swift` | the river wave: peaks, propagation lags, the frozen-threshold lead time | reads the pinned corpus, digest in `corpus/flood-lead-time/SHA256SUMS` |
| `rate-of-rise-common-window.swift` | rise rates on a **common** window, and the sampling histogram that shows why the native-window pair is not a comparison | prints both windows and says outright which is invalid |

**Every program is integer or exact-rational.** None declares a float type. The one place
floating point appears anywhere in this work is a Landauer bound that needs `ln 2`, which
is irrational; it decides nothing and only its exponent carries the argument.

**What these do not contain.** No substrate source, no internal identifiers, no
implementation constants. They are the arithmetic, written so a stranger can run it
against the same public bytes and get the same digits.
