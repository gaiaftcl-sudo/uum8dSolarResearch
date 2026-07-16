---
title: Eclipse 2026 — the science research (circumstances, ionospheric response, storms, solar cycle)
audience: engineers_and_auditors
game: WIKI-ECLIPSE-2026-002
---

# The science — August 12, 2026, and everything history says about it

This page is the research foundation of Game 3: what the 2026 eclipse is, what measured ionospheric physics says a total eclipse does, what the reference storms look like, and what the solar cycle does to the noise floor. Data tables inside `GAIA` markers are generated from the substrate's own ledger.

---

## 1. The August 12, 2026 total solar eclipse

**Global circumstances** (NASA/GSFC Espenak lineage; the substrate's embedded Besselian elements carry fingerprint `f9f9f8eebf7ed0cc`):

- **Instant of greatest eclipse:** 2026 Aug 12, **17:45:53.8 UT** (17:47:06 TD; ΔT = 71.4 s) at **65°13.5′N 025°13.7′W** — the North Atlantic ~45 km off western Iceland.
- **Greatest duration:** 2 min 18.2 s near 65°50′N; Sun altitude at greatest eclipse only **+25.8°**, azimuth 248.4°; path width 294 km.
- **Magnitude 1.0386 · gamma 0.8977 · Saros 126 (member 48 of 72, descending node).**
- **Global contacts:** partial begins 15:34:11 UT → total begins 16:58:05 UT → greatest 17:45:54 UT → total ends 18:34:05 UT → partial ends 19:57:56 UT.
- **The path:** begins at sunrise over the Taymyr Peninsula, sweeps (east-to-west in its first half — unusual) across the Arctic Ocean near the North Pole (~17:06 UT), clips eastern Greenland (Scoresby Sund ~17:15 UT), crosses **western Iceland** (Westfjords, Snæfellsnes, Reykjanes), the North Atlantic, and **northern Spain** (A Coruña, León, Bilbao, Zaragoza, Valencia, Palma) near sunset. Madrid and Barcelona sit just outside totality.
- **Historical rarity:** the first total eclipse visible from Iceland since **June 30, 1954** and from Reykjavík since **June 17, 1433**; the first total eclipse over mainland Spain since **August 30, 1905**.

**The substrate's own station circumstances for 2026** (computed by `eclipse-geometry`, stored in the ledger):

<!-- GAIA:BEGIN geometry-2026-08-12 -->
<!-- GAIA:END geometry-2026-08-12 -->

**Norwich, Connecticut** — the home station — sees a shallow **~13.2% partial** with the Sun ~60° high at maximum 17:55:20 UT (1:55 PM EDT). That is a fundamentally different physical regime from totality: far too weak for a detectable local TEC signature, so Norwich (and Millstone Hill, 15.9%) are the **declared below-threshold control channel** of the 2026 prediction — a falsifiable claim in its own right. The science payload comes from the totality path: Iceland and Spain.

**Path geometry caveat:** 2026 is a high-latitude, low-Sun (+25.8°), near-sunset-over-Europe event; the 2017/2024 references are mid-latitude, high-Sun US events. Quantitative transfer of depletion magnitudes is approximate — which is exactly why the pre-registered law audits a *relation* (depletion commensurate with obscuration), not an absolute number.

## 2. What a total eclipse measurably does to the ionosphere

The Moon's shadow switches off the ionosphere's photoionization source along a supersonic (~700 m/s at F-region heights) moving track. Measured consequences from the two best-instrumented modern eclipses:

**Total Electron Content (TEC) depletion**
- **2017-08-21:** TEC decreased **30–40%** within the 75% obscuration area with equatorward expansion (Cherniak & Zakharenkova, GRL 2018); peak depletions **~50–60%** vs background (Coster et al. 2017); tomography showed ~40% electron-density depletion vs the prior day, recovering ~30 min after totality (EPS 2022); COSMIC radio-occultation profiles ~40% maximum depletion.
- **2024-04-08:** reductions **20–65%** depending on obscuration and distance from totality. Millstone Hill ISR (Aa et al., JGR Space Physics 2024): above 250 km, **Ne dropped ~60% and persisted up to 6 hours**; below 250 km, <30% lasting 2–3 h. SAMI3-TIDAS assimilation: Ne reduction 20–50%, max in the F-region 200–250 km, lag growing with altitude (5–10 min bottomside → 1–2.5 h topside). Absolute depletions ~8–12 TECU after non-uniform background correction (GPS Solutions 2025). 2024 also produced the **first reported post-eclipse TEC enhancement** propagating equatorward, followed by a secondary depletion belt.

**Waves**
- Eclipse-induced **ionospheric bow waves** (Zhang et al. 2017); gravity waves with 25–90 min periods, peaking 25–30 min, in 30-s GPS-TEC (Nayak & Yiğit 2018); modeled supersonic-shadow bow-wave front + mesoscale acoustic-gravity waves (Lin et al., GRL 2018); eclipse-driven medium-scale TIDs documented for 2024 (Liang et al., Space Weather 2026).
- **Neutral-atmosphere/infrasound detection is historically marginal** — the 2015 UK study (Marlton et al.) could not confidently attribute surface pressure/temperature wave perturbations to the eclipse; treat any such channel as exploratory.

**Timing structure** — peak TEC/foF2 reduction lands within ~30 min of local maximum obscuration; the topside lags by 1–2.5 h; foF2 overshoots on recovery. The substrate's projected leaves (below) land **within minutes of local maximum** — consistent with the published bottomside lag.

**Raw vs smoothed products:** high-cadence line-of-sight/1 Hz GNSS data preserves the bow waves and short-period gravity waves that gridded, binned vertical-TEC maps average away, and the choice of background-correction method alone moves reported depletion magnitudes by **20–40%**. Engineering consequence baked into Game 3: ingest raw-est available products, quantize once, pin the baseline *rule* (lower median over named quiet days) in the sealed Form so the correction method can never drift post-hoc.

## 3. What the substrate measured (the historical corpus)

The corpus below is the substrate's own end-to-end measurement — public raw archives → quantized integer ledger → the ONE frozen pair law. Every row is generated from the live crucible:

<!-- GAIA:BEGIN empirical-coupling -->
| Eclipse | Station | Projected (UT) | Obscuration (ppm) | Depletion (ppm) | Coupling (‰ of obs) | Day max Kp |
|---|---|---|---|---|---|---|
| 2017-08-21 | carbondale | 18:05:47 UT | 800292 | 391086 | 488 | 3.0 |
| 2017-08-21 | casper-wy | 17:29:17 UT | 802380 | 268279 | 334 | 3.0 |
| 2017-08-21 | columbia-sc | 18:27:38 UT | 800290 | 448461 | 560 | 3.0 |
| 2017-08-21 | nashville | 18:12:52 UT | 802211 | 392061 | 488 | 3.0 |
| 2017-08-21 | salem-or | 17:05:17 UT | 802393 | 263023 | 327 | 3.0 |
| 2023-10-14 | albuquerque | 16:26:33 UT | 801694 | 265351 | 330 | 3.0 |
| 2023-10-14 | corpus-christi | 16:46:38 UT | 800667 | 315295 | 393 | 3.0 |
| 2023-10-14 | san-antonio | 16:42:59 UT | 801810 | 319424 | 398 | 3.0 |
| 2024-04-08 | carbondale | 18:46:29 UT | 800534 | 274457 | 342 | 3.3 |
| 2024-04-08 | cleveland | 19:01:31 UT | 802627 | 353317 | 440 | 3.3 |
| 2024-04-08 | dallas | 18:45:00 UT | 997624 | 308350 | 309 | 3.3 |
| 2024-04-08 | indianapolis | 18:53:22 UT | 800050 | 286986 | 358 | 3.3 |
| 2024-04-08 | mazatlan | 18:05:00 UT | 970682 | 323319 | 333 | 3.3 |
| 2024-04-08 | millstone | 19:17:05 UT | 801464 | 419091 | 522 | 3.3 |
| 2024-04-08 | norwich | 19:17:06 UT | 801484 | 426439 | 532 | 3.3 |

*Coupling = depletion·1000 ÷ obscuration at the projected second (exact integer). The 2026 expectation inherits this measured range: at totality (obs = 10⁶ ppm) expect depletion between the table's min and max coupling ‰ of baseline; the frozen law audits at ≥ 3·obs/10.*
<!-- GAIA:END empirical-coupling -->

See [Historical corpus](Eclipse-2026-Historical-Corpus.md) for the full per-eclipse picture and [Benchmark results](Eclipse-2026-Benchmark-Results.md) for the sealed 2024 verdict.

## 4. The reference storms (the data that shears naive models)

A geomagnetic storm moves TEC as violently as an eclipse — without a shadow. Any model that detects eclipses by "TEC dropped" false-positives on storm days. The two canonical references:

- **May 10–11, 2024 "Gannon" superstorm:** minimum **Dst −412 nT** — the most intense G5 storm since March 1989; Kp reached 9 twice and stayed ≥8 for 24 hours; daily Ap 273; magnetosphere compressed to ~5 R_E; aurora to Texas, Florida, Spain, Italy. Driven by successive CMEs from AR13664 (incl. an X5.8 flare). Magnitude a 1-in-12.5-year event, duration 1-in-41-year (Elvidge & Themens 2025).
- **October–November 2003 "Halloween" storms:** Dst −383 nT (Oct 30) and −422 nT (Nov 20); dayside TEC **increases of ~40% (Oct 29) and ~250% (Oct 30)** within hours via prompt-penetration electric fields — the "daytime super-fountain" (~900% electron-content increase above CHAMP altitude); the Oct 28 X17 flare alone stepped TEC ~30% (~25 TECU) in ~15 min.

Both storms' TEC days are ingested into the ledger; the Gannon days form the **shear-negative fossils** — see [Model shear](Eclipse-2026-Model-Shear.md). The 2026 operational rule is pre-registered: **max Kp > 4 disqualifies a day from any baseline**, and eclipse-day est-Kp ≥ 5 flags the storm pivot (the path-station resolution still runs; the interpretation gains a storm annotation and the storm archives become the science channel).

## 5. Solar-cycle context — why history spans three regimes

- **2017-08-21** sat in the **declining phase of Solar Cycle 24**: low background TEC (roughly half the 2024 levels), quiet variability — the low-noise regime.
- **2023-10-14** (annular) sat on **rising SC25**.
- **2024-04-08** sat near **SC25 maximum**.
- **2026-08-12** sits **near/just past SC25 maximum**: per NOAA SWPC (Jan 30, 2026), SC25 likely reached the highest sunspot number in over 20 years — WDC-SILSO's initial daily estimate for Aug 8 was **299** (SWPC non-official estimate 337, a value unseen since March 2001). SC25 ran ~31% above SC24 at the equivalent point.

Consequences: 2026 background TEC and day-to-day variability will resemble 2024, not 2017 — the noise floor is high, storm probability is elevated, and the cross-cycle corpus (same law, three regimes) is precisely what bounds how much of the eclipse signature survives regime change.

## 6. Live context

<!-- GAIA:BEGIN live-status -->
- Latest SWPC estimated Kp in ledger: 0.33 at 2026-07-16 19:12:00 UT
- Latest GFZ definitive/nowcast Kp day in ledger: 2024-05-11
- Latest magnetometer capture: BOU H at 2026-07-16 19:11:00 UT

*Ledger-borne (renders identically until the next ingest).*
<!-- GAIA:END live-status -->

## Source register

NASA/GSFC Five-Millennium-Canon Besselian elements (2017/2023/2024/2026, embedded verbatim, fingerprinted) · nationaleclipse.com + eclipse2024.org city circumstances (fixture anchors: Dallas, Norwich CT, Carbondale 2017, Albuquerque 2023) · Cherniak & Zakharenkova GRL 2018 · Coster et al. 2017 · Zhang et al. 2017 · Nayak & Yiğit 2018 · Lin et al. GRL 2018 · Aa et al. JGR Space Physics 2024 · GPS Solutions 2025 (background correction) · Liang et al. Space Weather 2026 · Marlton et al. (2015 UK) · Elvidge & Themens 2025 (Gannon statistics) · NASA NTRS 20070019835 (Halloween TEC) · NOAA SWPC news 2026-01-30 (SC25 record SSN) · MIT Haystack Madrigal / GFZ Potsdam / USGS / NOAA SWPC archives (live-verified — see [Data archives](Eclipse-2026-Data-Archives.md)).
