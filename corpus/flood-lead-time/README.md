# Guadalupe River, 4 July 2025 — lead time, measured on an integer lattice

**This is evidence, not a study.** It carries no sealed adversary and grades no float
instrument against an exact key, so it does not instantiate the shear recipe and is not
numbered. It is the worked example for the lives lane of the business justification and
for the applications section of the sovereign-pod charter.

Corpus pinned by sha256 in `corpus/SHA256SUMS`. Source: USGS NWIS instantaneous values,
parameter 00065 (gauge height, feet), public and anonymous, no key:

    https://waterservices.usgs.gov/nwis/iv/?sites=<id>&startDT=2025-07-03T00:00-05:00&endDT=2025-07-05T12:00-05:00&parameterCd=00065&format=json

Four gauges, upstream to downstream: 08165500 Hunt · 08166200 Kerrville ·
08167000 Comfort · 08167500 near Spring Branch. Pulled 2026-08-31.

Stage is carried as **exact integer milli-feet**. The served values have two decimals, so
the conversion is a string split and a multiply — no float parse anywhere in the ledger.

## Measured

| gauge | peak | at (CDT) | lag from Hunt | last reading |
|---|---|---|---|---|
| Hunt | 37.520 ft | 05:10 | — | **05:10** |
| Kerrville | 37.510 ft | 06:45 | +95 min | 07-05 12:00 |
| Comfort | 35.640 ft | 11:00 | +350 min | 07-05 12:00 |
| Spring Branch | 30.030 ft | 07-05 04:45 | +1415 min | 07-05 12:00 |

**The lead time that existed in public data.** Against a threshold frozen at 10.000 ft,
stated before the test:

    Hunt      crosses 10.000 ft at 03:00
    Kerrville crosses 10.000 ft at 06:00
    lead time available at Kerrville: 180 minutes
    Kerrville's own stage when Hunt crossed: 1.470 ft

**Rate of rise, and the window must be stated because the two gauges do not share one.**
Hunt rose 19.350 ft in 95 minutes (03:00 to 04:35). Hunt reports every 5 minutes (343 of
344 intervals); Kerrville every 15 (235 of 236). A maximum taken over a shorter window can
only be larger, so Hunt's 5-minute maximum against Kerrville's 15-minute maximum is not a
comparison. On a **common** window:

| window | Hunt | Kerrville | ratio |
|---|---|---|---|
| 15 min | 316 milli-ft/min | 885 milli-ft/min | **2.80×** |
| 30 min | 248 milli-ft/min | 679 milli-ft/min | **2.73×** |

**The wave steepened by roughly 2.8×**, and the mismatched-window figure understated it —
Hunt's shorter window inflated Hunt's own maximum. Reproduced by
`rate-of-rise-common-window.swift`.

**The Hunt record ends at its own maximum.** A 35-minute gap from 04:35 (29.450 ft) to a
single final reading of 37.520 ft at 05:10, and then nothing. The instrument was in the
flood it was measuring.

## What this does and does not establish

It establishes that the wave is real, that its propagation time between gauges is a
measured integer quantity, and that three hours separated the upstream threshold crossing
from the downstream one — in data that was public the whole time.

**It does not establish that any outcome would have been different.** That is not
derivable from a stage record and this program does not assert it. The measurable gap is
between the data existing and the people downstream being reached, and closing that gap is
a claim about alerting, not about sensing.

Nothing here is a claim about the National Weather Service, whose products and timings are
not in this corpus, or about any decision taken on the day.

## Reproduce

    xcrun swiftc -O -swift-version 5 guadalupe-wave-ledger.swift -o /tmp/flood
    cd corpus && /tmp/flood
