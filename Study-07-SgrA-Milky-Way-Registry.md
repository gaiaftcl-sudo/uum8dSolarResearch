# Study 07 — Registry: standing law and future Sgr A* products

## Standing law (frozen)

Sealed **2026-07-23T20:00:59Z** against product **2022-D02-01** primary `csv/` corpus. Thresholds verbatim in [Results](Study-07-SgrA-Milky-Way-Results.md). After this timestamp the integers do not move; only new products move through them.

```
LAW. For sealed product code P with frozen file inventory F on the non-normalized Stokes-I surface:
  compute integer short/long medians, ratio_ppt, closure-sector concentration,
  scramble-null concentration (seed=7), and arc-order ppt
  by the sealed ingest rules.
  Verdict = WIN iff all of:
    short_median_uJy >= 1500000
    long_median_uJy  <= 400000
    ratio_ppt        >= 5000
    closure_conc_ppt >= 200
    (closure_conc_ppt - null_conc_ppt) >= 20
    arc_order_ppt    >= 400
  else MISS.
  VOID-by-inventory if F incomplete; VOID-by-pipeline if a required stratum absent;
  VOID-by-norm-mix if normalized and non-normalized rows are concatenated.
  Adversary PNGs are never inputs to the LAW.
```

## Historical resolution (2017 campaign)

| Product | Surface | Verdict |
|---|---|---|
| 2022-D02-01 | `csv/` × 8 strata | **8/8 WIN** (see Results) |
| 2022-D02-01 | `csv_norm/` × 8 strata | **8/8 MISS** (SHORT_FAIL — processing adversary) |

## Pre-registered future products

Each row freezes **before** that product's imaging press surface is scored. Portal: https://eventhorizontelescope.org/for-astronomers/data

| Product code | Target | Status | Notes |
|---|---|---|---|
| 2025-D01-01 | 2018 EHT L1 complete | PRE-REGISTERED — awaiting Stokes-I CSV extract under sealed ingest | Grade primary calibrated Stokes-I if/when published in CSV form; else VOID-by-inventory until CSV surface exists |
| 2025-D02-01 | 2021 EHT L1 complete | PRE-REGISTERED — same rule | Same |
| 2026-D01-01 | 2018/2021 calibrated polarimetric | PRE-REGISTERED — Stokes-I projection stratum only | Polarization beyond Stokes I is out of seal scope for Study 07 |
| Next named Sgr A* `csv/` release on portal | Sgr A* | OPEN slot | Freeze product code + DOI here before scoring |

## How a new product is graded

1. Record product code, DOI, and SHA-256 of every Stokes-I CSV in the inventory page append.
2. Run the sealed ingest (µJy / millidegree / kλ / 0.01 h).
3. Emit one ledger row per stratum: WIN / MISS / VOID.
4. Publish the row raw on the Results page. Do not retune thresholds.

Back to [Study 07 charter](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) · [Corpus](Study-07-SgrA-Milky-Way-Corpus.md) · [Results](Study-07-SgrA-Milky-Way-Results.md)
