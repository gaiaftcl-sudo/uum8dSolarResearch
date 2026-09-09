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

## What is stored here, and the digests of what is not

**Two of the four lines in `SHA256SUMS` named files this repository deliberately does not
keep** — `corpus/nfip/.gitignore` excludes `nfip-claims.csv` — so `shasum -a 256 -c
SHA256SUMS` could never pass on a fresh clone: it tried to open files that are not there,
and `reproduce/validate.sh` reported the nfip corpus as a DIGEST MISMATCH. Corrected
2026-09-09. `SHA256SUMS` now pins only the artifacts the repository actually stores, and the
two digests it used to carry are recorded below, where the checker does not try to open them
and a reader can still verify decompressed or re-pulled bytes against them.

| artifact | bytes | settlements | sha256 |
|---|---|---|---|
| `nfip-claims.csv.gz` — **stored, pinned in `SHA256SUMS`** | 6,128,213 | 200,000 | `ad68c579d14eea69277560463c12dfd718f95f9a0f1bd0afdb117a633564c999` |
| `nfip-claims.csv` — the above, decompressed; **not stored** | 26,785,593 | 200,000 | `1bbb75cb5deb2e4bcfc2bd1e53c25a03b36d56c6756a38e42a5f6957359c1460` |
| the FULL pull of 2026-09-08 — **not stored** | — | 2,721,780 | `79ef60dd8deb12a88232189fa5ac988cda4ac42d7fb2250d777a5ba4e492b843` |

Verify the decompressed slice without keeping it:

    gzip -dc nfip-claims.csv.gz | shasum -a 256
    # 1bbb75cb5deb2e4bcfc2bd1e53c25a03b36d56c6756a38e42a5f6957359c1460

**And the stored artifact is the 200,000-settlement slice, not the 2.7 million-settlement
corpus this page is named for.** Measured 2026-09-09: `nfip-claims.csv.gz` decompresses to
26,785,593 bytes, 200,001 lines — 200,000 settlements and a header — and its digest is the
one the retired line labelled *"uncompressed, 200,000 settlements"*. The full corpus is not
committed — extrapolating the slice, 2,721,780 ÷ 200,000 × 26,785,593 B, puts it near 365 MB,
which is why it is not — and `pull-nfip-claims.sh` regenerates it from the archive, while
the published figures are the full-corpus run, whose transcript is `full-corpus-transcript.txt`
and whose order-independent corpus seal is
`648f32eb494b7d0990446d4f7aa05971cbe395d34de0fac39937577616edee3d`.

So read the third row as the provenance of the published numbers and the first as the
provenance of the sample a stranger gets without a 360 MB download. A re-pull that returns
`79ef60dd…` is the same archive state the study was measured on; a different digest means
FEMA revised the archive, which is what the vintage stamp below is for.

## The vintage stamp, and why it is pinned

Every record carries `asOfDate`. The full-corpus digest recorded above, together with the
order-independent corpus seal the program computes, locks the archive's state on the pull
date. (`SHA256SUMS` pins the stored 200,000-settlement sample; the seal that the published
figures rest on is the full-corpus one, for the reason given in the section above.) When FEMA
revises the archive — and it will — the same program over the new pull returns a different
seal, and the per-settlement seal ledger says exactly which settlements moved. That diff is
the measurement, and it cannot be made without a baseline taken first.

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
