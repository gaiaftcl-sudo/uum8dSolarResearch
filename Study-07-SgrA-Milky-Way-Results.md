# Study 07 — Results: frozen law on the Milky Way CSV

The law below was derived from the [Corpus](Study-07-SgrA-Milky-Way-Corpus.md) pins, then frozen. Every primary `csv/` file was graded once. Lightcurve-normalized `csv_norm/` files — the processing fork named in the 2022-D02-01 README as the static-imaging input — were graded as the **processing adversary**.

## Frozen law (sealed 2026-07-23T20:00:59Z)

Exact-integer thresholds. Amplitudes in µJy; ratios and concentrations in parts per thousand (ppt).

| Symbol | Meaning | Sealed integer |
|---|---|---|
| `T_short_min_uJy` | Short-baseline (`q` < 1000 Mλ) median amplitude ≥ | **1,500,000** µJy (1.5 Jy) |
| `T_long_max_uJy` | Long-baseline (`q` ≥ 4000 Mλ) median amplitude ≤ | **400,000** µJy (0.4 Jy) |
| `T_ratio_min_ppt` | short_median × 1000 / long_median ≥ | **5,000** (×5) |
| `T_closure_conc_min_ppt` | Max 45° closure-phase sector / all hi-SNR closures ≥ | **200** ppt |
| `T_closure_minus_null_min_ppt` | real concentration − phase-scramble null ≥ | **20** ppt |
| `T_arc_order_min_ppt` | Median baseline arc-sign agreement ≥ | **400** ppt |
| `hiSNR_min_amp_uJy` | Closure triangle min-edge amp for hi-SNR set | **100,000** µJy |
| Scramble seed | Deterministic phase shuffle for null | **7** |

Quantization (sealed): amplitude = integer µJy via decimal-string ×10⁶; phase = integer millidegree via decimal-string ×10³; `q` = integer kλ; time bin = 0.01 h.

**WIN** iff all six threshold inequalities hold. No float crosses a seal.

## Primary grades — non-normalized `csv/` (the sky's table)

**8 / 8 WIN**

| Day | Band | Pipeline | Rows | Short µJy | Long µJy | Ratio ppt | Clos. conc | Null conc | Arc ppt | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 096 | hi | casa | 13,357 | 2,502,812 | 134,379 | 18,625 | 452 | 303 | 998 | **WIN** |
| 096 | hi | hops | 13,790 | 2,516,890 | 135,455 | 18,581 | 463 | 303 | 998 | **WIN** |
| 096 | lo | casa | 12,673 | 2,442,837 | 119,388 | 20,461 | 445 | 308 | 998 | **WIN** |
| 096 | lo | hops | 12,996 | 2,444,417 | 118,326 | 20,658 | 473 | 291 | 998 | **WIN** |
| 097 | hi | casa | 13,480 | 2,183,111 | 108,769 | 20,071 | 509 | 348 | 997 | **WIN** |
| 097 | hi | hops | 15,424 | 2,185,992 | 103,266 | 21,168 | 492 | 356 | 998 | **WIN** |
| 097 | lo | casa | 15,509 | 2,100,435 | 112,209 | 18,718 | 499 | 344 | 998 | **WIN** |
| 097 | lo | hops | 17,529 | 2,106,014 | 108,260 | 19,453 | 501 | 379 | 998 | **WIN** |

### What this says about the Milky Way center

1. **Compact flux is in the raw table.** Every stratum's short-baseline median sits between 2.100 and 2.517 Jy — above the 1.5 Jy floor.
2. **Long baselines are suppressed.** Medians 0.103–0.135 Jy on `q` ≥ 4000 Mλ — a radial ladder of order ×18–×21, not a flat point-source profile.
3. **Closure phases are structured.** Sector concentration 445–509 ppt beats the phase-scramble null by ≥ 122 ppt on every file.
4. **Earth-rotation arc order holds.** Median arc-sign agreement ≈ 998 ppt — the `(u,v)` samples march on tracks.
5. **Both reduction pipelines agree.** HOPS and CASA strata WIN independently — no silent average.

There is still **no ring pixel** in these rows. The WIN is a network shape: short-vs-long ladder + closure structure + arc order.

## Processing adversary — `csv_norm/` (static-imaging input)

Paper III static imaging used lightcurve-normalized visibilities. Graded under the **same absolute-amplitude law**:

| File | Short µJy | Long µJy | Ratio ppt | Verdict | Reasons |
|---|---|---|---|---|---|
| `ER6_SGRA_2017_096_hi_casa_netcal-LMTcal-norm_StokesI.csv` | 998205 | 52735 | 18928 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_096_hi_hops_netcal-LMTcal-norm_StokesI.csv` | 997648 | 53106 | 18785 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_096_lo_casa_netcal-LMTcal-norm_StokesI.csv` | 999073 | 48675 | 20525 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_096_lo_hops_netcal-LMTcal-norm_StokesI.csv` | 998357 | 48229 | 20700 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_097_hi_casa_netcal-LMTcal-norm_StokesI.csv` | 998674 | 48554 | 20568 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_097_hi_hops_netcal-LMTcal-norm_StokesI.csv` | 997263 | 45922 | 21716 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_097_lo_casa_netcal-LMTcal-norm_StokesI.csv` | 999163 | 51761 | 19303 | **MISS** | SHORT_FAIL |
| `ER6_SGRA_2017_097_lo_hops_netcal-LMTcal-norm_StokesI.csv` | 997976 | 49844 | 20021 | **MISS** | SHORT_FAIL |

**8 / 8 MISS** — every normalized file fails `T_short_min_uJy`. Normalization removes the absolute jansky scale the public short-baseline measurement carries. That is the shear: the imaging fork no longer passes the raw absolute ladder, while closures on the primary `csv/` already carry structured phase without any ring PNG.

> [!WARNING]
> A recorded MISS is a finding. The normalized product is not "wrong"; it is a different table. Claiming the ring image *is* the raw measurement without naming the normalization step fails this ledger.

## Success criteria status

| Criterion | Status |
|---|---|
| S1 — Threshold frozen from 2017 Sgr A* CSV corpus | **PASS** — sealed 2026-07-23T20:00:59Z |
| S2 — Adversary graded raw | **PASS** — `csv_norm/` 8/8 MISS published |
| S3 — Pipeline strata agree or disagreement published | **PASS** — HOPS and CASA both 4/4 WIN |
| S4 — Prospective releases | **OPEN** — waiting on next portal Sgr A* product (see [Registry](Study-07-SgrA-Milky-Way-Registry.md)) |

Back to [Study 07 charter](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) · [Corpus](Study-07-SgrA-Milky-Way-Corpus.md) · [Registry](Study-07-SgrA-Milky-Way-Registry.md)
