# The NFIP claims corpus — 2.7 million flood-insurance settlements

The loss side of the insurance domain, public and anonymous, no key.

    https://www.fema.gov/api/open/v2/FimaNfipClaims

Measured SERVED 2026-09-08. The archive reported **2,721,780** records at the pull.
`pull-nfip-claims.sh` rebuilds the corpus byte-for-byte: it reads the record count from the
archive, pages with an explicit `$orderby=id` so the ordering is the archive's rather than
the server's mood, and concatenates the pages in order.

**What is selected, and why only this.** Twenty-one fields: the date and place of loss, the
damage and paid amounts for building and contents, the ICC payment, the deductible codes,
the coverage limits, water depth, cause, flood zone, occupancy class, and the archive's own
`asOfDate` vintage stamp. Nothing that identifies a person is pulled, and nothing that
identifies one is needed: the study grades settlement arithmetic, not claimants. The record
carries no name and no street address; latitude and longitude are published rounded to a
tenth of a degree and geography is used at county and census-tract resolution only.

## Why the money is read as digits

Every money field is served as a decimal string — `7243.04`, `3000.00`, `7744`. The reader
multiplies by 100 at the parser and carries the value as a native `Int128` of exact cents.
**No `Float`, no `Double` and no float literal touches the data at any point.** A field with
more than two decimal places is not silently truncated; it is a distinct answer and it is
counted as one. An empty field is `ELEMENT_MISSING`, never a zero.

## The vintage stamp, and why it is pinned

Every record carries `asOfDate`. The corpus digest in `SHA256SUMS`, together with the
order-independent corpus seal the program computes, locks the archive's state on the pull
date. When FEMA revises the archive — and it will — the same program over the new pull
returns a different seal, and the per-settlement seal ledger says exactly which settlements
moved. That diff is the measurement, and it cannot be made without a baseline taken first.

## The deductible ladder is recovered, not looked up

No code-to-amount table is supplied to the program. For each `(deductible code, decade of
loss)` it takes the most common value of `damage − paid` among settlements not capped at the
coverage limit. The recovered values reproduce the published NFIP schedule — code `1` is
$1,000, `2` is $2,000, `5` is $5,000, `A` is $10,000 — so the instrument re-derives a known
contractual constant before it grades anything with it. A pair from which no whole-dollar
amount can be recovered is REFUSED, never assumed.

## Scope

The subject under grading is the arithmetic and the structural integrity of the instrument.
No claimant, no community, no insurer and no individual payout decision is assessed anywhere
in this work, and nothing here is advice.
