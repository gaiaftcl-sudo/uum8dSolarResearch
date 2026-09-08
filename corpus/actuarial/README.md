# The actuarial corpus — published life tables and statutory discount rates

Two public archives, both anonymous, both fixed-decimal.

## 1. Eurostat life tables — `demo_mlifetable`

    https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_mlifetable?format=JSON&geo=<GEO>&sex=T&time=<YEAR>

Measured SERVED 2026-09-08, HTTP 200, no key. Twenty-one tables: DE, FR, IT, ES, PL, NL, SE
for 2019, 2021 and 2022, sex total. Eight published indicators — `PROBDEATH`, `PROBSURV`,
`SURVIVORS`, `NUMBERDYING`, `PYLIVED`, `TOTPYLIVED`, `LIFEXP`, `DEATHRATE` — over the
single-year age ladder.

**Every value is published to a fixed number of decimal places**: three distinct precisions
across 16,128 values, and nothing served at more. A fixed-decimal string is an exact
rational, so the whole table is exact before any arithmetic runs.

**The age dimension carries 97 categories and the single-year ladder is 96 of them.**
`Y_GE85` is an aggregate published beside the ladder and populated for other datasets, not
an age. Read as an age it looks like a missing cell, and dropping every younger age that
depends on it removes almost the whole table. The program builds the ladder by NAME —
`Y_LT1`, `Y1`…`Y94`, and the single largest `Y_GE` as the terminal open interval — so an
aggregate is excluded rather than counted absent.

**The terminal open interval carries `q = 1.0` exactly.** Any chain running through it
terminates with probability exactly zero, which is true and measures nothing about
arithmetic, so chains end at the last closed age.

## 2. IRS minimum-present-value segment rates — IRC §417(e)(3)(D)

    https://www.irs.gov/retirement-plans/minimum-present-value-segment-rates

Measured SERVED 2026-09-08, HTTP 200, no key. Pinned as served. 295 monthly triples, each
rate published to two decimal places — so `4.42` percent is exactly `442/10000`, a rational
and not a binary approximation to one.

## Digests

`SHA256SUMS`, verified by `reproduce/validate.sh` before any figure is read. Both archives
are revised over time; the digests are what make a figure on the study page replayable.

No person, insurer, pension scheme or country is assessed anywhere in this work, and nothing
here is advice.
