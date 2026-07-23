# Study 07 — Corpus: Sgr A* 2017 public visibilities

Product **2022-D02-01** (First Sagittarius A* EHT Results: Calibrated Data). Ingested 2026-07-23 from the public GitHub mirror. Every byte below is public; digests are SHA-256 of the files as pulled.

## Pull record

| Item | Value |
|---|---|
| Source URL | `https://github.com/eventhorizontelescope/2022-D02-01/raw/main/EHTC_FirstSgrAResults_May2022_csv.tgz` |
| Tarball | `EHTC_FirstSgrAResults_May2022_csv.tgz` |
| Bytes | 7,083,259 |
| SHA-256 | `709f322cd825669e1b30dacb3c9093f016ae3c931a19366b7b29f536ed0baebb` |
| Primary grading surface | `csv/` (non-normalized Stokes I) |
| Named processing variant | `csv_norm/` (lightcurve-normalized — Paper III static imaging input) |
| Reproduce | `curl -L -o EHTC_FirstSgrAResults_May2022_csv.tgz 'https://github.com/eventhorizontelescope/2022-D02-01/raw/main/EHTC_FirstSgrAResults_May2022_csv.tgz' && shasum -a 256 EHTC_FirstSgrAResults_May2022_csv.tgz` |

## File inventory (16 CSV)

| Path | Product | Bytes | SHA-256 (prefix) |
|---|---|---|---|
| `csv/ER6_SGRA_2017_096_hi_casa_netcal-LMTcal_StokesI.csv` | csv | 1,082,760 | `7ef5bd7f6fdc261b…` |
| `csv/ER6_SGRA_2017_096_hi_hops_netcal-LMTcal_StokesI.csv` | csv | 1,117,260 | `8bc1bd0b2834b8a6…` |
| `csv/ER6_SGRA_2017_096_lo_casa_netcal-LMTcal_StokesI.csv` | csv | 1,027,197 | `225b698525ffdd02…` |
| `csv/ER6_SGRA_2017_096_lo_hops_netcal-LMTcal_StokesI.csv` | csv | 1,053,304 | `89429b2a65ba9e9a…` |
| `csv/ER6_SGRA_2017_097_hi_casa_netcal-LMTcal_StokesI.csv` | csv | 1,092,954 | `76aab2d2500d03c4…` |
| `csv/ER6_SGRA_2017_097_hi_hops_netcal-LMTcal_StokesI.csv` | csv | 1,247,937 | `62f2671aacd867f6…` |
| `csv/ER6_SGRA_2017_097_lo_casa_netcal-LMTcal_StokesI.csv` | csv | 1,257,848 | `a5a40d58da509699…` |
| `csv/ER6_SGRA_2017_097_lo_hops_netcal-LMTcal_StokesI.csv` | csv | 1,419,016 | `8f02526ecc8fb85f…` |
| `csv_norm/ER6_SGRA_2017_096_hi_casa_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,082,760 | `a1a9a93f4d09fd79…` |
| `csv_norm/ER6_SGRA_2017_096_hi_hops_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,117,260 | `e3d2e204ec27c706…` |
| `csv_norm/ER6_SGRA_2017_096_lo_casa_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,027,197 | `1fcdd490abe7b804…` |
| `csv_norm/ER6_SGRA_2017_096_lo_hops_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,053,304 | `5d509e3efe361fd1…` |
| `csv_norm/ER6_SGRA_2017_097_hi_casa_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,092,954 | `6f79cd657851da9c…` |
| `csv_norm/ER6_SGRA_2017_097_hi_hops_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,247,937 | `44bf5fb7c1421425…` |
| `csv_norm/ER6_SGRA_2017_097_lo_casa_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,257,848 | `f7f3b3d292432db7…` |
| `csv_norm/ER6_SGRA_2017_097_lo_hops_netcal-LMTcal-norm_StokesI.csv` | csv_norm | 1,419,016 | `4f85581f730cbc06…` |

Full digests and per-file integer metrics live in `corpus/study-07/study07_ledger.json` in the research repository.

## What the corpus contains (machine summary)

Eight primary `csv/` strata (2 days × 2 bands × 2 pipelines). Observed envelope used to freeze the law:

| Pin | Integer |
|---|---|
| Short-baseline median amp min…max | 2,100,435 … 2,516,890 µJy |
| Long-baseline (`q` ≥ 4000 Mλ) median min…max | 103,266 … 135,455 µJy |
| Short/long ratio (parts per thousand) min…max | 18,581 … 21,168 |
| Closure-sector concentration min…max | 445 … 509 ppt |
| Scramble-null concentration max | 379 ppt |
| Min (real − null) concentration | 122 ppt |

Back to [Study 07 charter](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) · [Results](Study-07-SgrA-Milky-Way-Results.md) · [Registry](Study-07-SgrA-Milky-Way-Registry.md)
