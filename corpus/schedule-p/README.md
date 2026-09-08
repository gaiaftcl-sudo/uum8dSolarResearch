# CAS loss-reserving database, pulled from NAIC Schedule P

Six lines of business, filed with the National Association of Insurance Commissioners and
republished by the Casualty Actuarial Society as a research resource. Public, anonymous,
no key, no registration.

    https://www.casact.org/publications-research/research/research-resources/loss-reserving-data-pulled-naic-schedule-p
    https://www.casact.org/sites/default/files/2021-04/<line>_pos.csv

Measured SERVED 2026-09-08: all six returned HTTP 200 with no authentication.

| file | bytes | rows | companies |
|---|---|---|---|
| `ppauto_pos.csv` | 1,046,587 | 14,600 | 146 |
| `comauto_pos.csv` | 1,096,456 | 15,800 | 158 |
| `wkcomp_pos.csv` | 926,241 | 13,200 | 132 |
| `othliab_pos.csv` | 1,626,377 | 23,900 | 239 |
| `medmal_pos.csv` | 243,780 | 3,400 | 34 |
| `prodliab_pos.csv` | 453,580 | 7,000 | 70 |

Digests in `SHA256SUMS`, verified by `reproduce/validate.sh` before any figure is read.

**Why this corpus and not another.** Every loss column is served as an **integer number of
thousands of dollars**, so nothing here is parsed from a decimal and no rounding choice
enters before the arithmetic does. And the square is complete: accident years 1988–1997 by
development lags 1–10, which means the corpus contains **the runoff as well as the
triangle**. A method applied at the year-end 1997 valuation can therefore be graded against
what actually happened, which is rare.

Columns read by `reproduce/reserve-triangle-exact-vs-float.swift`: `GRCODE`,
`AccidentYear`, `DevelopmentLag`, `IncurLoss_B`, `CumPaidLoss_B`, `EarnedPremNet_B`.

**Line endings are CRLF.** In Swift `\r\n` is a single Character, so
`split(separator: "\n")` matches nothing and returns the whole file as one line. The
program splits on a predicate over all three endings instead.

No company on these pages is assessed and no reserve opinion is offered. The subject under
grading is the arithmetic and the instrument.
