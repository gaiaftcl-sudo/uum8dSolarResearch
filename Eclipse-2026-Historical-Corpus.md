---
title: Eclipse 2026 — the historical corpus (three eclipses, three solar regimes, one law)
audience: engineers_and_auditors
game: WIKI-ECLIPSE-2026-003
---

# The historical corpus — one frozen law across three solar regimes

The full picture the founder asked for: every relevant historical eclipse ingested raw, quantized once, and presented to the **same frozen pair law** that is pre-registered for 2026. Nothing here is tuned per eclipse — the constants (`gate=800000ppm`, `coupling=3/10`, lower-median quiet baselines, Kp ≤ 4) were set once on the 2024 benchmark and never moved. What history shows at those constants is recorded raw, CALORIE or CURE (LAW 3).

## Why these three eclipses

| Eclipse | Type | Solar regime | What it stresses |
|---|---|---|---|
| **2017-08-21** | Total (US coast-to-coast) | SC24 **declining** — background TEC ~half of 2024 | Does the coupling law survive a low-background regime? |
| **2023-10-14** | **Annular** (ring of fire, US SW) | SC25 rising | The antumbra branch: obscuration plateaus at ~89.6% (ratio²), never reaching totality — a shallower forcing with high obscuration |
| **2024-04-08** | Total (US S→NE) | SC25 **near maximum** — the 2026-like regime | The sealed benchmark |

**Carbondale, Illinois is the anchor station**: the only place both the 2017 and 2024 totality paths crossed. Same ground, same 1°×1° TEC grid cells, seven years and one solar cycle apart — the cleanest cross-regime pair the archive offers.

## Per-eclipse geometry (substrate-computed, ledger-stored)

### 2017-08-21 (total, SC24 declining)

<!-- GAIA:BEGIN geometry-2017-08-21 -->
| Station | C1 (UT) | Maximum (UT) | C4 (UT) | Max obscuration |
|---|---|---|---|---|
| albuquerque | 16:21:20 | 17:45:14 | 19:13:57 | 733132 ppm (73.3%) |
| carbondale | 16:52:27 | 18:21:25 | 19:47:29 | 1000000 ppm (100.0%) |
| casper-wy | 16:22:17 | 17:43:51 | 19:09:26 | 1000000 ppm (100.0%) |
| cleveland | 17:06:33 | 18:31:01 | 19:51:08 | 799463 ppm (79.9%) |
| columbia-sc | 17:13:08 | 18:43:06 | 20:06:21 | 1000000 ppm (100.0%) |
| corpus-christi | 16:45:22 | 18:14:04 | 19:42:12 | 568225 ppm (56.8%) |
| coruna | 18:43:28 | 19:18:50 | 19:22:03 | 128081 ppm (12.8%) |
| dallas | 16:40:26 | 18:10:00 | 19:39:24 | 754963 ppm (75.5%) |
| eugene-or | 16:04:36 | 17:17:41 | 18:37:40 | 992914 ppm (99.3%) |
| indianapolis | 16:57:53 | 18:25:02 | 19:48:38 | 914737 ppm (91.5%) |
| latrabjarg | 18:18:15 | 18:40:54 | 19:03:12 | 22958 ppm (2.3%) |
| leon | 18:44:15 | 19:09:28 | 19:09:29 | 113166 ppm (11.3%) |
| mazatlan | 16:36:46 | 17:53:27 | 19:13:58 | 306647 ppm (30.7%) |
| millstone | 17:27:27 | 18:45:48 | 19:58:36 | 630201 ppm (63.0%) |
| nashville | 16:58:32 | 18:28:24 | 19:54:04 | 1000000 ppm (100.0%) |
| norwich | 17:26:51 | 18:46:39 | 20:00:36 | 666822 ppm (66.7%) |
| reykjavik | 18:21:37 | 18:43:50 | 19:05:41 | 22161 ppm (2.2%) |
| salem-or | 16:05:27 | 17:18:18 | 18:37:51 | 1000000 ppm (100.0%) |
| san-antonio | 16:40:47 | 18:09:20 | 19:38:12 | 611369 ppm (61.1%) |
| zaragoza | 18:44:42 | 18:49:18 | 18:49:19 | 14389 ppm (1.4%) |

*Besselian elements fingerprint `3a033a5260c80232` · quantized 10-s lattice · generated from `helio_eclipse_circumstances`.*
<!-- GAIA:END geometry-2017-08-21 -->

### 2023-10-14 (annular, SC25 rising)

<!-- GAIA:BEGIN geometry-2023-10-14 -->
| Station | C1 (UT) | Maximum (UT) | C4 (UT) | Max obscuration |
|---|---|---|---|---|
| albuquerque | 15:13:13 | 16:36:55 | 18:09:24 | 895921 ppm (89.6%) |
| carbondale | 15:33:37 | 16:59:21 | 18:30:01 | 538319 ppm (53.8%) |
| casper-wy | 15:13:41 | 16:33:29 | 18:00:25 | 724787 ppm (72.5%) |
| cleveland | 15:49:26 | 17:07:55 | 18:28:47 | 335536 ppm (33.6%) |
| columbia-sc | 15:50:28 | 17:18:09 | 18:48:20 | 446338 ppm (44.6%) |
| corpus-christi | 15:26:28 | 16:58:16 | 18:38:12 | 900988 ppm (90.1%) |
| coruna | — | — | — | 0 ppm (0.0%) |
| dallas | 15:23:34 | 16:52:49 | 18:29:37 | 807739 ppm (80.8%) |
| eugene-or | 15:05:27 | 16:18:53 | 17:39:46 | 887761 ppm (88.8%) |
| indianapolis | 15:39:31 | 17:02:15 | 18:28:47 | 441216 ppm (44.1%) |
| latrabjarg | — | — | — | 0 ppm (0.0%) |
| leon | — | — | — | 0 ppm (0.0%) |
| mazatlan | 15:24:55 | 16:50:34 | 18:25:32 | 618807 ppm (61.9%) |
| millstone | 16:16:52 | 17:24:47 | 18:32:31 | 175994 ppm (17.6%) |
| nashville | 15:38:02 | 17:05:02 | 18:36:25 | 521357 ppm (52.1%) |
| norwich | 16:14:48 | 17:25:05 | 18:35:15 | 194671 ppm (19.5%) |
| reykjavik | — | — | — | 0 ppm (0.0%) |
| salem-or | 15:05:49 | 16:19:05 | 17:39:36 | 881906 ppm (88.2%) |
| san-antonio | 15:23:49 | 16:54:16 | 18:33:00 | 900168 ppm (90.0%) |
| zaragoza | — | — | — | 0 ppm (0.0%) |

*Besselian elements fingerprint `dba5478372654d81` · quantized 10-s lattice · generated from `helio_eclipse_circumstances`.*
<!-- GAIA:END geometry-2023-10-14 -->

### 2024-04-08 (total, SC25 max — the benchmark)

<!-- GAIA:BEGIN geometry-2024-04-08 -->
| Station | C1 (UT) | Maximum (UT) | C4 (UT) | Max obscuration |
|---|---|---|---|---|
| albuquerque | 17:16:31 | 18:30:50 | 19:47:31 | 729370 ppm (72.9%) |
| carbondale | 17:42:59 | 19:01:19 | 20:18:09 | 1000000 ppm (100.0%) |
| casper-wy | 17:33:54 | 18:42:42 | 19:52:49 | 548370 ppm (54.8%) |
| cleveland | 17:59:21 | 19:15:38 | 20:28:58 | 1000000 ppm (100.0%) |
| columbia-sc | 17:52:31 | 19:10:22 | 20:25:06 | 761662 ppm (76.2%) |
| corpus-christi | 17:13:09 | 18:33:20 | 19:55:05 | 935812 ppm (93.6%) |
| coruna | 19:01:55 | 19:04:02 | 19:04:03 | 9477 ppm (0.9%) |
| dallas | 17:23:17 | 18:42:36 | 20:02:39 | 1000000 ppm (100.0%) |
| eugene-or | 17:29:57 | 18:23:01 | 19:18:09 | 235608 ppm (23.6%) |
| indianapolis | 17:50:32 | 19:07:57 | 20:23:11 | 1000000 ppm (100.0%) |
| latrabjarg | 18:48:27 | 19:38:20 | 20:26:37 | 431613 ppm (43.2%) |
| leon | — | — | — | 0 ppm (0.0%) |
| mazatlan | 16:51:27 | 18:09:37 | 19:32:10 | 1000000 ppm (100.0%) |
| millstone | 18:15:35 | 19:29:19 | 20:38:48 | 940365 ppm (94.0%) |
| nashville | 17:44:35 | 19:03:24 | 20:20:14 | 947625 ppm (94.8%) |
| norwich | 18:14:06 | 19:28:18 | 20:38:12 | 905593 ppm (90.6%) |
| reykjavik | 18:49:23 | 19:39:49 | 20:28:31 | 466604 ppm (46.7%) |
| salem-or | 17:32:13 | 18:24:29 | 19:18:41 | 224552 ppm (22.5%) |
| san-antonio | 17:14:29 | 18:34:18 | 19:55:44 | 999585 ppm (100.0%) |
| zaragoza | — | — | — | 0 ppm (0.0%) |

*Besselian elements fingerprint `17af652a628dc38e` · quantized 10-s lattice · generated from `helio_eclipse_circumstances`.*
<!-- GAIA:END geometry-2024-04-08 -->

Calculator trust: the geometry core reproduces independently published city circumstances to seconds — Dallas 2024 (±3 s), Norwich 2024 deep partial (±3 s, obscuration 905,593 ppm vs published ~90.6%), Carbondale 2017 (±29 s vs minute-precision sources), Albuquerque 2023 annular (±4 s, obscuration 895,921 ppm vs the published **89.6%** — the antumbra ratio² branch exact to 0.7 mm of ring).

## The full crucible — every pair, one law

<!-- GAIA:BEGIN crucible-historical -->
| Eclipse | Kind | Pair | Verdict | Projected (UT) | Depletion | Obscuration |
|---|---|---|---|---|---|---|
| 2017-08-21 | positive | 2017-08-21-carbondale-eclipse | PROJECTED ✓ | 18:05:47 UT | 391086 ppm (39.1%) | 800292 ppm |
| 2017-08-21 | positive | 2017-08-21-casper-wy-eclipse | PROJECTED ✓ | 17:29:17 UT | 268279 ppm (26.8%) | 802380 ppm |
| 2017-08-21 | positive | 2017-08-21-columbia-sc-eclipse | PROJECTED ✓ | 18:27:38 UT | 448461 ppm (44.8%) | 800290 ppm |
| 2017-08-21 | positive | 2017-08-21-nashville-eclipse | PROJECTED ✓ | 18:12:52 UT | 392061 ppm (39.2%) | 802211 ppm |
| 2017-08-21 | positive | 2017-08-21-salem-or-eclipse | PROJECTED ✓ | 17:05:17 UT | 263023 ppm (26.3%) | 802393 ppm |
| 2017-08-21 | control-negative | neg-2017-08-21-carbondale-ctrl2017-07-25 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-carbondale-ctrl2017-08-14 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-carbondale-ctrl2017-08-28 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-casper-wy-ctrl2017-07-25 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-casper-wy-ctrl2017-08-14 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-casper-wy-ctrl2017-08-28 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-columbia-sc-ctrl2017-07-25 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-columbia-sc-ctrl2017-08-14 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-columbia-sc-ctrl2017-08-28 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-nashville-ctrl2017-07-25 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-nashville-ctrl2017-08-14 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-nashville-ctrl2017-08-28 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-salem-or-ctrl2017-07-25 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-salem-or-ctrl2017-08-14 | dead cat ✓ | — | — | — |
| 2017-08-21 | control-negative | neg-2017-08-21-salem-or-ctrl2017-08-28 | dead cat ✓ | — | — | — |
| 2023-10-14 | positive | 2023-10-14-albuquerque-eclipse | PROJECTED ✓ | 16:26:33 UT | 265351 ppm (26.5%) | 801694 ppm |
| 2023-10-14 | positive | 2023-10-14-corpus-christi-eclipse | PROJECTED ✓ | 16:46:38 UT | 315295 ppm (31.5%) | 800667 ppm |
| 2023-10-14 | positive | 2023-10-14-eugene-or-eclipse | no projection ‼︎ | — | — | — |
| 2023-10-14 | positive | 2023-10-14-san-antonio-eclipse | PROJECTED ✓ | 16:42:59 UT | 319424 ppm (31.9%) | 801810 ppm |
| 2023-10-14 | control-negative | neg-2023-10-14-albuquerque-ctrl2023-09-17 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-albuquerque-ctrl2023-09-30 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-albuquerque-ctrl2023-10-02 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-albuquerque-ctrl2023-10-07 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-corpus-christi-ctrl2023-09-17 | FALSE POSITIVE ‼︎ | 16:46:38 UT | 275023 ppm (27.5%) | 800667 ppm |
| 2023-10-14 | control-negative | neg-2023-10-14-corpus-christi-ctrl2023-09-30 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-corpus-christi-ctrl2023-10-02 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-corpus-christi-ctrl2023-10-07 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-eugene-or-ctrl2023-09-17 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-eugene-or-ctrl2023-09-30 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-eugene-or-ctrl2023-10-02 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-eugene-or-ctrl2023-10-07 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-san-antonio-ctrl2023-09-17 | FALSE POSITIVE ‼︎ | 16:42:59 UT | 280483 ppm (28.0%) | 801810 ppm |
| 2023-10-14 | control-negative | neg-2023-10-14-san-antonio-ctrl2023-09-30 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-san-antonio-ctrl2023-10-02 | dead cat ✓ | — | — | — |
| 2023-10-14 | control-negative | neg-2023-10-14-san-antonio-ctrl2023-10-07 | dead cat ✓ | — | — | — |
| 2024-04-08 | positive | 2024-04-08-carbondale-eclipse | PROJECTED ✓ | 18:46:29 UT | 274457 ppm (27.4%) | 800534 ppm |
| 2024-04-08 | positive | 2024-04-08-cleveland-eclipse | PROJECTED ✓ | 19:01:31 UT | 353317 ppm (35.3%) | 802627 ppm |
| 2024-04-08 | positive | 2024-04-08-dallas-eclipse | PROJECTED ✓ | 18:45:00 UT | 308350 ppm (30.8%) | 997624 ppm |
| 2024-04-08 | positive | 2024-04-08-indianapolis-eclipse | PROJECTED ✓ | 18:53:22 UT | 286986 ppm (28.7%) | 800050 ppm |
| 2024-04-08 | positive | 2024-04-08-mazatlan-eclipse | PROJECTED ✓ | 18:05:00 UT | 323319 ppm (32.3%) | 970682 ppm |
| 2024-04-08 | positive | 2024-04-08-millstone-eclipse | PROJECTED ✓ | 19:17:05 UT | 419091 ppm (41.9%) | 801464 ppm |
| 2024-04-08 | positive | 2024-04-08-norwich-eclipse | PROJECTED ✓ | 19:17:06 UT | 426439 ppm (42.6%) | 801484 ppm |
| 2024-04-08 | control-negative | neg-2024-04-08-carbondale-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-carbondale-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-carbondale-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-cleveland-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-cleveland-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-cleveland-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-dallas-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-dallas-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-dallas-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-indianapolis-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-indianapolis-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-indianapolis-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-mazatlan-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-mazatlan-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-mazatlan-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-millstone-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-millstone-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-millstone-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-norwich-ctrl2024-03-12 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-norwich-ctrl2024-04-01 | dead cat ✓ | — | — | — |
| 2024-04-08 | control-negative | neg-2024-04-08-norwich-ctrl2024-04-15 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-carbondale-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-carbondale-storm2024-05-11 | FALSE POSITIVE ‼︎ | 18:46:29 UT | 740074 ppm (74.0%) | 800534 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-cleveland-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-cleveland-storm2024-05-11 | FALSE POSITIVE ‼︎ | 19:01:31 UT | 720053 ppm (72.0%) | 802627 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-dallas-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-dallas-storm2024-05-11 | FALSE POSITIVE ‼︎ | 18:27:27 UT | 706563 ppm (70.7%) | 801513 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-indianapolis-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-indianapolis-storm2024-05-11 | FALSE POSITIVE ‼︎ | 18:53:22 UT | 736981 ppm (73.7%) | 800050 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-mazatlan-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-mazatlan-storm2024-05-11 | FALSE POSITIVE ‼︎ | 17:54:27 UT | 598914 ppm (59.9%) | 802552 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-millstone-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-millstone-storm2024-05-11 | FALSE POSITIVE ‼︎ | 19:17:05 UT | 671980 ppm (67.2%) | 801464 ppm |
| 2024-04-08 | shear-negative | shear-2024-04-08-norwich-storm2024-05-10 | dead cat ✓ | — | — | — |
| 2024-04-08 | shear-negative | shear-2024-04-08-norwich-storm2024-05-11 | FALSE POSITIVE ‼︎ | 19:17:06 UT | 694994 ppm (69.5%) | 801484 ppm |

*ONE frozen law — gate 800000 ppm, coupling 3/10 — applied to every pair. Generated live from `eclipse-fossils.jsonl` through `EclipseProjectionRunner`.*
<!-- GAIA:END crucible-historical -->

## The empirical coupling — what history lets us predict

For every projected positive, the measured coupling (depletion as parts-per-thousand of obscuration at the projected second) with the day's geomagnetic context:

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

**Reading the table toward 2026:** the pre-registered law requires depletion ≥ 300‰ of obscuration (coupling 3/10). Every historical coupling value above 300 is margin; the min–max range across regimes IS the falsifiable expectation band for the 2026 totality-path stations (obs = 10⁶ ppm at Reykjavik/Látrabjarg/A Coruña/León/Zaragoza). If 2026 lands inside the historical range, the shadow law generalizes across four eclipses and a full solar cycle; if it lands below the 300‰ audit line, the prediction seals CURE — recorded raw.

## The ingest ledger behind all of it

<!-- GAIA:BEGIN ingest-ledger -->
| UT day | Stations sliced | vTEC bins | Scan SHA-256 (12) | Max Kp | Class |
|---|---|---|---|---|---|
| 2003-10-29 | 7 | 1860 | `145dc2eaf8ca` | 9.0 | DISTURBED |
| 2003-10-30 | 7 | 1816 | `abaf5f22591e` | 9.0 | DISTURBED |
| 2017-07-25 | 5 | 1440 | `1a8590fab838` | 3.0 | quiet |
| 2017-08-14 | 5 | 1440 | `1cc6b02e6c84` | 2.0 | quiet |
| 2017-08-21 | 5 | 1440 | `1d94e38b4b4d` | 3.0 | quiet |
| 2017-08-28 | 5 | 1440 | `7c195648907e` | 0.7 | quiet |
| 2023-09-17 | 4 | 1152 | `37f0b808236e` | 3.3 | quiet |
| 2023-09-30 | 4 | 1152 | `86df55f9289f` | 2.3 | quiet |
| 2023-10-02 | 4 | 1152 | `aa254ad157b2` | 3.0 | quiet |
| 2023-10-07 | 4 | 1152 | `11079644ae38` | 1.7 | quiet |
| 2023-10-14 | 4 | 1152 | `a5cc83d231c8` | 3.0 | quiet |
| 2023-10-21 | 4 | 1152 | `9cd98d7d699c` | 5.0 | DISTURBED |
| 2024-03-12 | 7 | 2016 | `881948be8b56` | 2.3 | quiet |
| 2024-04-01 | 7 | 2016 | `3c4eb2649f94` | 3.7 | quiet |
| 2024-04-08 | 7 | 2014 | `7f36c28f7ab6` | 3.3 | quiet |
| 2024-04-15 | 7 | 2016 | `d09d2dcafe16` | 2.7 | quiet |
| 2024-05-10 | 7 | 2013 | `eb16ca1b2801` | 8.7 | DISTURBED |
| 2024-05-11 | 7 | 2012 | `dc0c9c4b4a4c` | 9.0 | DISTURBED |

*One Madrigal world-file scan per day, sliced per station locally; SHA-256 over the raw fetched bytes. Generated from `helio_ingest_provenance` + ledger Kp.*
<!-- GAIA:END ingest-ledger -->

## Honest boundaries

- Madrigal's world TEC network density grows over time: 2017 coverage is thinner than 2024 (and 2003, used only as a storm reference, thinner still). Grid values are medians over receivers; station-window slicing is identical across years, so the *comparison* is apples-to-apples even where absolute coverage differs.
- The annular 2023 event's obscuration ceiling (~89.6%) sits just above the 80% audit gate — its gate window is minutes long, a deliberately harsh test of the timing side of the law.
- Baselines are strictly same-eclipse quiet control days (±7 days + 27-day rotation prior, each Kp-gated). No cross-year baselines, no seasonal mixing.
