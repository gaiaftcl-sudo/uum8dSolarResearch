# GCAT corpus, pinned

`satcat.tsv` — the GCAT General Catalog of Artificial Space Objects. Pulled 2026-08-31:

    https://planet4589.org/space/gcat/tsv/cat/satcat.tsv

    19,293,257 bytes
    banner line 2:  # Updated 2026 Aug 30 2126:09
    sha256          090ce077eb05ef45fca04069b5d960e469c0242077c4ce9d1d1ee773e65f13df

**Why the bytes are here and not just the URL.** GCAT is rewritten at the same URL as the
catalogue updates, so a citation by URL alone does not identify the bytes a census was
measured from. The file is redistributable under its published terms, so it is pinned here
and every figure is re-derivable from these exact bytes.

**Licence and release, attributed to the right thing.** The licence and release number are
stated on the GCAT website, not inside this file. Measured: `satcat.tsv` contains exactly
two non-data lines — the 42-column header and the banner — and no release or licence string
anywhere. Cite the site for the terms and this digest for the bytes.

## Census, calendar 2025, re-derived from these bytes

Rows with `DDate` in 2025 and `Status` in {R, AR, D}:

| slice | rows | dry mass (grams, exact) |
|---|---|---|
| R + AR | 1,904 | 456,038,509 |
| D (active deorbit) | 3 | 5,175,000 |
| **union** | **1,907** | **461,213,509** |
| payload subset (`Type` begins `P`) | 1,124 | 272,922,509 |

## Why the lattice unit is the gram

`DryMass` conforms to `^-?[0-9]+$` or `^-?[0-9]+\.[0-9]{1,3}$` on **1,907 of 1,907 rows,
zero non-conforming**, so parsing is a string split and a multiply and the mass ledger is
exact Int64 grams with no float. `Inc` is present to two decimals on **1,907 of 1,907**
with the `IF` quality flag empty on all, so the turning latitude is an exact centi-degree
integer on every row.

    shasum -a 256 -c SHA256SUMS
