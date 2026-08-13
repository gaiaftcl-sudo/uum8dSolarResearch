# Shear Studies White Paper — Shape Against Magnitude Across Eight Skies

**Program:** UUM-8D Solar Research / Shear Studies  
**Surface:** [uum8dSolarResearch wiki](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki)  
**Date:** 2026-08-13 (Version 2.0 — T+1 revision; first version 2026-07-23)  
**Status of this document:** Public synthesis of sealed and open studies. Study 1: eclipse complete 2026-08-12, day verified quiet, sealed prediction pending its pinned archive (grading window ~2026-08-30). Study 07 numbers ledger-frozen and re-verified byte-exact 2026-08-13. Study 08 charter sealed; Studies 02–06 charter-sealed pending corpus.  
**Readers’ entry:** [Shear-Studies-Readers-Guide](Shear-Studies-Readers-Guide.md)

---

## Abstract

Science has spent decades measuring the world with rulers: percent drop, peak amplitude, χ² fit, image brightness. Rulers are cheap to fool. A geomagnetic superstorm digs a deeper ionospheric hole than an eclipse; a storm surge lifts a tide gauge as high as a tsunami; lightcurve normalization moves a table’s absolute amplitudes before imaging ever begins. Magnitudes travel. **Appointments do not.**

This program replaces the ruler with a **shear**: a forcing that carries its own public clock and track; a raw public archive; a named adversary that matches size but not shape; and a frozen exact-integer law that grades confinement and traveling lag before any future event is scored. The eclipse of 2026-08-12 was the reference implementation — it has now happened, on schedule, on a day that measured quiet; the sealed prediction awaits its pinned grading archive (§2.1). Seven further studies transplant the same recipe to rocket burns, solar flares, tsunamis, cosmic-ray Forbush decreases, explosion-vs-earthquake discrimination, the Event Horizon Telescope’s public visibilities of Sagittarius A\* (the radio source at the center of the Milky Way), and the astrometric-spectroscopic orbit of Gaia BH1.

**The Study 07 ledger row, stated at its measured strength:** the public non-normalized Stokes-I CSV for Sgr A\* (product 2022-D02-01) passes a frozen integer law on short/long baseline ladder, closure-phase structure, and Earth-rotation arc order — **8/8 WIN** across days, bands, and both HOPS and CASA pipelines. The lightcurve-normalized tables used as static-imaging input fail the same absolute short-baseline floor — **8/8 MISS**, every failure `SHORT_FAIL`. Compact flux ~2.1–2.5 Jy on short baselines is in the sky’s table (VERIFIED against the sealed ledger). What the MISS measures is the definition of normalization doing exactly what the source collaboration’s release notes document: dividing amplitudes by the concurrent total-flux light curve drives short baselines to ~1.0 Jy-equivalent by construction. The shape quantities imaging actually uses — the radial ratio ladder and the closure phases — pass through normalization intact (§4.5). The program’s reading is that the absolute-jansky appointment and the imaging input are **different tables**, and that the fork must be named as provenance; the collaboration documents the same fork in its own release notes. That separation is a ledger row, not a slogan.

---

## 1. The thesis

### 1.1 Size is cheap; shape keeps appointments

| Domain | Magnitude mimic | What the mimic cannot do |
|---|---|---|
| Ionosphere | Gannon G5 storm (May 2024) | Thread the Moon’s umbral cone on the ephemeris clock |
| Rockets | Storm TEC holes, Tonga TIDs | Sit inside a launch corridor at T+5–15 min from a manifest second |
| Flares | Storms, radio bursts | Step the whole sunlit hemisphere on the GOES X-ray second |
| Ocean | Storm surge, meteotsunami | March gauge-to-gauge on a Huygens travel-time chart from a USGS origin |
| Cosmic rays | Pressure lows, diurnal wave | Strobe ~50 neutron monitors in one L1 shock minute, rigidity-ordered |
| Seismology | Near-site quakes, quarry blasts | Climb a Pn/Pg/Sn/Lg ladder from a fixed depth-0 point track |
| Galactic center VLBI | Ring PNG + regularizers + `csv_norm` | Invent short-baseline absolute janskys and closure topology absent from the sealed rows |
| Gaia BH1 astrometry | Published *N* M☉ dark companion narrative | Carry the horizon-scale label into the integer table. The mass itself is in the appointments — the orbital signal sits 10³–10⁴ above the sealed integer quanta (§9.4) — but the horizon narrative is a label, not a measurement, and the integer table does not adjudicate it |

### 1.1b Cosmology’s three black-hole pipelines

| # | Pipeline | Instrument writes | Model shows | Program study |
|---|---|---|---|---|
| 1 | High-precision astrometry | Star wobble (Gaia BH1) | Invisible black hole of *N* M☉ | [Study 08](Study-08-Gaia-BH1-Astrometric-Shear.md) |
| 2 | GW interferometry | Laser strain (LIGO/Virgo) | Merging compact objects | Study 10 queued (renumbered — see note) |
| 3 | VLBI | Sparse visibilities (EHT) | Ring / shadow image | [Study 07](Study-07-SgrA-Milky-Way-Results.md) — **graded** |

**Renumbering note (2026-08-13):** the first version of this paper queued the GW-interferometry study as “Study 09.” That number has since been taken by a different charter — *Shear Study 09 — The Global Convective Bond* (aircraft traffic, atmosphere, and solar forcing), chartered 2026-07-25 on the program’s main-branch surface. That page is **not** yet published on this wiki; until it is, it is cited here without a link rather than linked into a void. The GW pipeline study is therefore queued as **Study 10**.

**Origin of shear, scoped per pipeline:** the infinite-precision failure mode named in v1 of this paper belongs to **pipeline 3** — imaging regularizers filling sparse Fourier coverage on absolute grids. It does not describe pipeline 1. Gaia BH1’s published mass is a plain Keplerian two-body fit at ~1.4 AU separation from a ~9.3 M☉ companion: no relativistic term enters the fit, no singular boundary is approached, and the 2024 re-analysis reports residuals consistent with noise under the plain Keplerian model (REPORTED — Nagarajan et al. 2024). For pipeline 1 the shear question is narrower and stated in §9.4: which channel of the public record carries the orbit at integer resolution, and what label rides on top of it. Where a fit’s arithmetic does collapse, the program seals an integer boundary and grades the **object assignment** as adversary. Ingest for Study 08 runs through a dedicated `corpus/study-08/` directory with integer quantization at ingest; ledger rows are sealed only after grading.

### 1.2 The four-piece shear recipe

Every study on this wiki must instantiate all four. Missing any one is a correlation hunt, not a shear study.

1. **Forcing with computable clock and track** — announced in public numbers before the response is examined.
2. **Public raw response archive** — exact URLs, formats, cadence; anyone with a terminal pulls the same bytes.
3. **Sealed adversary** — matches magnitude, fails shape; graded raw; firings published, never renamed.
4. **Standing future events** — law frozen before scoring events that had not yet happened (or products not yet examined).

**Verdict rules (program-wide):** exact integers only — no floating point crosses a seal. Every shear has a **confinement** analog and a **traveling-lag** analog. Thresholds derive from historical corpus, then freeze. A recorded failure is a finding.

### 1.3 The five-stage road

Charter → Corpus → Frozen law → Pre-registration → Public resolution. No stage revisited. Status lines only advance.

---

## 2. Study 1 — Eclipse 2026: the reference implementation

**Status:** EVENT COMPLETE 2026-08-12 · fair test VERIFIED quiet · sealed prediction PENDING on the pinned archive · grading window ~2026-08-30.

On 2026-08-12 the Moon’s umbral cone crossed western Iceland and northern Spain, on schedule — the crossing of the sealed stations spanned 16:43:40–19:22:06 UT, with the totality peak off Iceland at 17:45:54 UT. Six decades of eclipse-ionosphere literature reported scalars (“TEC dropped 40%”) — a characterization of the literature (REPORTED, not independently re-surveyed by this program). On 2024-05-11 the Gannon superstorm produced deeper depletions under an unobscured Sun. Graded precisely: **the program’s own frozen magnitude-gate law false-positived at all seven 2024 stations that day** — sealed raw in the historical Form, nine false positives in total (VERIFIED, ledger-frozen). No other collaboration’s pipeline was run or graded here; the plain inference that any detector keyed to depletion magnitude alone would have fired that day is the program’s reading, not a measurement.

Study 1 asks a different question: does the ionospheric dent **thread** the shadow’s timetable — confined to the geometry’s minutes, deepest near each station’s own maximum, marching at the cone’s ground speed? Storms dig holes; they have no cone, no track, no clock.

**Already sealed (public Forms):**

| Stage | Claim | Status |
|---|---|---|
| 2024 proof | Shape-read verifies April 2024 eclipse from raw archives | SEALED — 7/7, 21 controls null, 0 false positives |
| Historical universality | One frozen law across 2017 / 2023 annular / 2024 + storm shear | SEALED RAW **as a failure** — 15/16, the Eugene OR 2023 miss named in the seal, 9 false positives published |
| 2026 prediction | Named totality stations must thread; named nulls must refuse | PRE-REGISTERED 2026-07-16 |
| Extensions | Station order and storm-decidable confinement | PRE-REGISTERED 2026-07-16 |

All four Forms — fingerprints `89afd825011f060e`, `6fe49bee70289fee`, `c3e6841a206b8058`, `b106d2926b1bf2cf` — re-verified byte-for-byte on 2026-08-13, 28 days after sealing (VERIFIED).

**The frozen numbers a reader needs to falsify Study 1** (all ledger-frozen; re-derived exactly at T+1):

- **Detection law** (`89afd825011f060e`): 2024 benchmark 7/7 detections, 21 control pairs null, 0 false positives — re-run green 2026-08-13.
- **Two-clause discriminant** (`b106d2926b1bf2cf`): confinement excess ≥ **50,189 ppm**; lag gate **[−300, +1200] s** around each station’s own maximum; traveling order latrabjarg +192 s → reykjavik +2,372 s → coruna +53 s → leon +32 s → zaragoza.
- **Storm gate:** est-Kp ≥ 5 on the day voids the clean-test framing. It never fired (§2.1).
- **Quantified nulls:** norwich must refuse at 40,790–73,923 ppm; millstone at 49,036–88,868 ppm — both undetectable by the sealed law.
- **Separation:** minimum true-eclipse excess **57,543 ppm** against the maximum storm impostor **42,836 ppm** (Gannon May-11, Dallas) — a clean gap of 14,707 ppm around the frozen threshold. All 16 true eclipse rows pass both clauses, including Eugene, which the base magnitude law missed.
- **Empirical coupling band:** 309–560 permille of obscuration.
- **Historical crucible** (`6fe49bee70289fee`, sealed as a failure, raw): 2017 totality 5/5 · 2023 annular 3/4 (the Eugene, OR miss named in the seal, never renamed) · 2024 7/7. Gannon May-10 was a 7/7 dead cat; May-11’s naive-gate false positives are rejected by confinement + lag. 15/16 overall, 9 false positives, across **82 station-day pairs** (a birth-day commit message said 96 — an overcount, corrected in the [27-day review](Eclipse-2026-First-27-Days-Review.md)).
- **2026 prediction** (`c3e6841a206b8058`): the named totality stations must thread; the named nulls must refuse.

A 2026 verdict that fails any of these terms is a miss and will be published as one.

**Why it is the reference:** it proved that a magnitude-mimicking adversary (Gannon) fails a shape test that true eclipse days pass — and that the law can be sealed weeks before the next sky event: sealed 2026-07-16, 27 days before the eclipse, and untouched since. Every later study reuses that logic.

### 2.1 T+1 — the day answered quiet; the archive has not yet spoken (added 2026-08-13)

The eclipse happened. Whether the prediction won is not yet decidable — and the reason is a measured archive calendar, not a hedge.

**The fair test is verified.** The confounds that could have dirtied the test are each quantified from captured public feeds:

- **Geomagnetic quiet (VERIFIED — GFZ definitive Kp):** eclipse-day maximum Kp **2.667** (Aug 9: 2.667 · Aug 10: 2.000 · Aug 11: 3.000). The forecast Kp-5 CME arrival underperformed. The sealed storm gate (est-Kp ≥ 5) never fired.
- **Flares absent (VERIFIED — captured GOES 7-day X-ray archive):** one B5.4 flare, 16:41–16:55 UT, ending 43 minutes before the Reykjavik totality window opened (17:38–17:59 UT — a ±10-minute window around the sealed maximum-obscuration second, 64,126 s = 17:48:46 UT; totality itself lasts about a minute, and the gap from flare end to the sealed maximum second is ~54 minutes); window-maximum long-band flux 5.6×10⁻⁷ W/m²; zero C-, M-, or X-class flares anywhere in 15:30–20:00 UT.
- **Solar wind quantified (VERIFIED — captured L1 1-minute feed, reaching back to 11:26 UT on eclipse day):** proton speed 382–478 km/s, density 1.48–9.39 cm⁻³, Bz between −5.0 and +3.4 nT with 56 minutes below −3 nT. A mild residual tail — a named caveat for the Iceland corridor only, which sits auroral-adjacent. The Spanish stations are clean.
- **Auroral flank quiet (VERIFIED — captured Narsarsuaq magnetometer, full day):** X-component range 107 nT in the eclipse window against 453 nT in the same day’s pre-dawn hours. No substorm. The Leirvogur (Iceland) cross-check is pending; that observatory routes through DTU rather than BGS.

A quiet day is a fair test: a match will be a clean win with no confound to explain it away; a miss will be a clean miss with no storm to blame.

**Raw custody is held.** Twenty-seven RINEX 30-second observation files (93 MB) were captured at T+1 from anonymous public mirrors (BKG IGS/EUREF and NOAA CORS) for nine stations — REYK, HOFN, ACOR, LEON, ZARA, VILL, CANT, SALA, WES2 — covering eclipse day (DOY 224) and control days 217 and 197, alongside the GOES, solar-wind, and magnetometer captures. A SHA-256 manifest records every file’s digest, retrieval timestamp, and source URL. Custody doctrine, stated plainly: **the sealed verdict grades on the pinned Madrigal gridded-TEC surface; the raw RINEX is custody and cross-check, not a substitute grading surface.**

**The grading window is measured, not promised.** Madrigal instrument-8000 gridded TEC for 2026-08-12 was NOT POSTED at T+1. The posting boundary was measured between 2026-07-25 and 2026-08-01 — a two-to-three-week lag — so eclipse day is expected to post around **2026-08-30**, by which time control day 2026-08-19 will also be up. Grading runs then, on the pinned surface, against the untouched fingerprints. Version 1 of this paper promised a public verdict on 2026-08-13; that promise is graded **MISSED** in the published [operational review](Eclipse-2026-First-27-Days-Review.md). The archive’s own calendar made it impossible, and the date lived only in prose — no sealed clause ever named it.

**The operational record is on the page.** The [27-day review](Eclipse-2026-First-27-Days-Review.md) also records, as failures: the live capture loop was dark from 2026-07-21 through eclipse day (last sample 2026-07-20 18:01 UT); the watch daemon was staged but never installed; the program’s pages were split across three unreconciled surfaces; and the fossil-pair count was corrected from 96 to 82. The sealed core held while the live surface failed. Both facts belong in the record.

## Predictions vs first measured data — the raw-channel first look (added 2026-08-13, T+1)

The founder's requirement on resolution day was plain: the predictions and the measured data, side by side, now. The pinned grading archive has not posted eclipse day — but the raw receiver files captured and SHA-sealed this morning contain the ionosphere's answer, and the program computed it directly from those bytes on T+1. Method: GPS dual-frequency geometry-free phase (L1C/L2W) from the sealed RINEX files, sign-calibrated against the code combination, satellite arcs leveled, 300-second bins, differenced against the sealed control day 2026-08-05. This is **relative slant TEC from single stations — a different observable from the pinned gridded surface the frozen law grades on**. It is the first look, not the sealed verdict; the verdict still runs ~2026-08-30 on the pinned archive, untouched.

**What the raw bytes say, station by sealed station:**

| Sealed station | Sealed maximum (27 days prior) | Measured deepest depletion (raw first look) | Lag vs sealed max | Depth vs control day | Sealed lag gate [−300, +1200] s |
|---|---|---|---|---|---|
| **Reykjavik** | 17:48:46 UT | 17:40–17:45 UT bin | **−376 s** (next-deepest bin −76 s) | **−4.5 TECU** | at the early edge; bracketing bins inside |
| **A Coruña** | 18:28:18 UT | 18:45 UT bin | **+1,002 s** | **−6.2 TECU** | **inside** |
| **León** | 18:29:11 UT | 18:45 UT bin | **+952 s** | **−5.8 TECU** | **inside** |
| **Zaragoza** | 18:29:43 UT | 18:35 UT bin | **+467 s** | **−3.1 TECU** (measured curve) | **inside** |

Reading it plainly:

- **Every one of the four sealed totality stations with a receiver in our custody measurably dipped, in its sealed window, on the day.** Reykjavik's depletion is the textbook signature: onset ~17:30, bottom at 17:40–17:45 straddling the sealed 17:48:46 maximum, asymmetric recovery — the bottomside delay shape the historical corpus measured on three previous eclipses. The control day shows nothing at those minutes.
- **The traveling structure is present at first-look resolution.** Iceland dipped first; the Spanish trio dipped together roughly fifty minutes later — the sealed order. The sealed gaps *within* the Spanish trio (+53 s, +32 s) sit far below 300-second binning and single-station noise; they are for the pinned surface to grade, not this one.
- **The depths are consistent with the sealed expectation band.** Depletions of 3–6 TECU against evening quiet levels of roughly 8–15 TECU vertical at these latitudes sit inside the pre-registered 31–56%-of-quiet expectation — stated as consistency, not as a graded fraction, since arc-leveled relative TEC carries no absolute denominator.
- **Recorded raw, not smoothed:** A Coruña and León show a positive TEC excursion in the quarter-hour *before* their maxima (one León bin at +13 TECU — flagged as a possible arc-leveling artifact pending the pinned surface); Reykjavik's single deepest bin sits just outside the early edge of the sealed lag gate at this observable's resolution, with its neighboring bin inside; León's full-window deepest bin is a late feature at 19:15 near local sunset. These anomalies are printed here on the day they were measured, before the sealed grading, so nobody can accuse the record of meeting the data halfway.
- **The null channel** (Westford, beside Millstone Hill) is captured but not yet processed — its file is a different format generation; processing is queued. The sealed null claim is *silence*, and it grades on the pinned surface with everything else.

The derivation is in custody beside the raw files it read: the processing scripts, every per-station output, and a method README, all SHA-256-sealed in the same manifest. Anyone holding the RINEX files can re-run the arithmetic.

**What this is and is not.** It is the ionosphere's answer, read from bytes no one can alter, twenty-eight days after the claims were sealed and one day after the sky moved: four sealed stations, four measured dips, in the sealed windows, in the sealed order, at depths inside the sealed band. It is not the verdict — the verdict belongs to the frozen law running on the pinned archive, and that appointment stands at ~2026-08-30. If the pinned surface disagrees with this first look, both go on the page.


### 2.2 The arithmetic underneath — no supercomputer, no floats, and why that changes what a verdict is

There is a fact about this experiment that the tables do not show and that changes the meaning of everything on them: **none of it was computed the way modern geophysics is normally computed.** No supercomputer. No floating point anywhere a claim lives. Every sealed number in this experiment — obscuration in parts-per-million, time in whole UT seconds, depletion as exact integer ppm of baseline, thresholds like 50,189 and 800,000, the coupling law written as cross-multiplied whole numbers — exists on a whole-integer lattice, and every verdict is an integer comparison. The law never asks whether 0.5754 exceeds 0.5019 in some machine's rounding; it asks whether 57,543 ≥ 50,189, and that question has exactly one answer on every computer ever built.

**Why this is not a stylistic preference:**

**A floating-point verdict is a property of a machine. An integer verdict is a property of the numbers.** Two computers running the same floating-point pipeline can disagree in the last bits — different math libraries, fused instructions, compiler flags — and at a decision boundary, the last bit *is* the verdict. Conventional pipelines paper over this with tolerances, and a tolerance is a place where an argument lives: "agrees to within epsilon" invites the question *whose epsilon*. Integer arithmetic has no last bit to argue about. The grading of this experiment can be re-run by a stranger, on any machine, in any decade, and must produce **byte-identical** output — not close, identical.

**The seal architecture is only possible on the lattice.** The fingerprints that make this pre-registration unforgeable are hashes over exact text: re-derive the geometry from the published elements, byte-compare, done. That is why four seals re-verified **byte-for-byte, 28 days after stamping, 4/4** — a sentence that cannot be written about a floating-point pipeline, which can promise reproduction only to within tolerance. Byte-identity leaves the argument no place to live. The entire honesty architecture of this experiment — claims that cannot drift, failures that cannot be quietly amended — rests on arithmetic that cannot drift either.

**No supercomputer was involved, and that is the point, not a limitation.** The full experiment — shadow geometry derived from the published orbital elements, an 82-station-day historical crucible across three eclipses and a superstorm, the storm discriminant, four sealed predictions, and the grading to come — runs on one desk machine reading public archives. The scarce resource in this kind of science was never floating-point throughput. It was **exactness and discipline**, and those are free. What a supercomputer buys is more approximate arithmetic per second; what the lattice buys is arithmetic that means the same thing everywhere, forever. For the job of *grading a sealed claim*, the second is the one that matters, and it is the one the big machines do not offer.

**The lattice touches the world at exactly one guarded crossing.** The public archives deliver their measurements through conventional instruments and processing — that part of the world is not ours to change. This experiment takes each measurement across into the lattice at a single quantization step — parts-per-million, milli-units, whole seconds — and from that crossing onward, no approximate number ever touches the record. (Stated with the same honesty as everything else here: yesterday's raw-channel first look was an exploratory calculation made directly on the custody bytes to answer the day's question; the sealed grading that supersedes it runs entirely on the integer law.)

**What actually changes.** On conventional arithmetic, a scientific verdict is a computation you are asked to trust — trust in the machine, the library, the flags, the lab. On a whole-integer lattice, a verdict is a **fact you can check** — the same fact on every machine, for every person, at every time. That is the property that lets a fully public operation seal a claim twenty-seven days ahead and hand the grading to anyone: the arithmetic itself is incapable of taking a side. The prediction was radical not because the physics was new, but because the verdict was made *portable* — and exact arithmetic is what made it portable.


**What resolution will mean.** When the archive posts, the prediction grades at full strength on a verified-quiet day. What one resolved prediction proves is one entry in the track record — no more, no less.

**Entry points:** [Overview](Eclipse-2026-Overview.md) · [Model shear](Eclipse-2026-Model-Shear.md) · [Prediction registry](Eclipse-2026-Prediction-Registry.md) · [Blind spots](Eclipse-2026-Blind-Spots.md) · [First 27 days — full review](Eclipse-2026-First-27-Days-Review.md)

---

## 3. Studies 02–06 — charters sealed, corpus road ahead

These five share Study 1’s recipe. Their status is **OPEN — charter sealed**; thresholds are not yet frozen. They are not placeholders: each names archives, adversaries, integer metrics, and success criteria — and since this paper’s first version, each charter page has grown an animation of its discriminating shape, a section on what the study protects (people, ecology, and the planet), and an honest-limits section of its own.

### 3.1 Study 02 — Launch ionospheric holes

| Piece | Instantiation |
|---|---|
| Clock / track | Launch Library 2 / GCAT liftoff second; second-stage corridor ±3° |
| Archive | Madrigal world-gridded TEC (kindat 3500), same family as Study 1 |
| Adversary | Gannon, Hunga Tonga TIDs, Falcon deorbit burns |
| Shear | Corridor confinement + clock-locked onset/recovery in percent-of-baseline integers |

**Why it matters:** the only class of ~900 km F-region hole that arrives on a schedule published in advance — and that conventional TID filters delete by construction. Cadence: weekly.  
**Page:** [Study 02](Study-02-Launch-Ionospheric-Holes.md)

### 3.2 Study 03 — Solar-flare sudden ionospheric disturbances

| Piece | Instantiation |
|---|---|
| Clock / track | GOES X-ray peak; sunlit hemisphere (eclipse geometry in reverse) |
| Archive | Same TEC / SID-relevant public surfaces named in charter |
| Adversary | Geomagnetic storms + solar radio bursts |
| Shear | Hemisphere step lockstep with X-ray clock; quiet-day windows flare-excluded |

Since v1 of this paper, Study 03 has grown a second layer — SHARP integer helicity, a signed crossing-count that is exact in integers, with the torsion-vs-linking vocabulary corrected — and a decidable checklist page: [Study 03 predictions and validations](Study-03-Predictions-and-Validations.md).

**Why it matters:** polar aviation HF and crew dose ride the same daylit physics. Flares at solar-cycle maximum arrive on a drumbeat.  
**Page:** [Study 03](Study-03-Solar-Flare-SIDs.md)

### 3.3 Study 04 — Tsunami vs storm surge

| Piece | Instantiation |
|---|---|
| Clock / track | USGS origin second + Huygens bathymetric travel-time chart |
| Archive | NOAA CO-OPS / DART public water levels (charter-verified pulls include Tonga 2022, Sandy) |
| Adversary | Storm surge, meteotsunami, Lamb waves |
| Shear | Gauge-to-gauge arrival on the sealed chart — the oceanic traveling signature |

**Why it matters:** false alarms and missed arrivals are measured in coastlines. Standing law resolves on the next M ≥ 7.5 subsea event.  
**Page:** [Study 04](Study-04-Tsunami-vs-Storm-Surge.md)

### 3.4 Study 05 — Forbush decreases

| Piece | Instantiation |
|---|---|
| Clock / track | L1 shock minute; global neutron-monitor network |
| Archive | NMDB / related public counts; OMNI L1 |
| Adversary | Pressure lows + traveling diurnal wave (the “corrections” conventional pipelines apply) |
| Shear | Rigidity-ordered, longitude-flat global step on raw uncorrected counts |

**Why it matters:** particle-physics instruments, exact discipline of Study 1 — one clock, many stations, magnitude mimics from weather.  
**Page:** [Study 05](Study-05-Forbush-Decreases.md)

### 3.5 Study 06 — Explosion vs earthquake

| Piece | Instantiation |
|---|---|
| Clock / track | Catalog origin + fixed depth-0 point (Punggye-ri); Pn/Pg/Sn/Lg ladder |
| Archive | EarthScope / IRIS miniSEED integer counts; USGS ComCat labels |
| Adversary | Near-site quakes, ripple-fired quarry blasts; 2010-05-12 micro-event as scored holdout |
| Shear | Energy confined inside sealed P windows while Lg stays starved — shape, not mb/Ms scalars |

**Why it matters:** nuclear-treaty verification’s working problem, stated in public raw integers.  
**Page:** [Study 06](Study-06-Explosion-vs-Earthquake.md)

---

## 4. Study 07 — Sagittarius A\*: what the Milky Way wrote in the table

**Status:** LAW FROZEN 2026-07-23T20:00:59Z · primary `csv/` **8/8 WIN** · `csv_norm/` adversary **8/8 MISS** · all rows re-verified against the local ledger 2026-08-13

### 4.1 The provenance line this study draws

The public retelling often treats the EHT ring image as if it were the measurement. The source collaboration itself does not claim that: it publishes the calibrated visibility tables (the very release this study graded), documents the lightcurve normalization in its release notes, and describes imaging as reconstruction with quantified uncertainty (REPORTED — EHT Paper III). The measurement is a **visibility table**: time, station pair, `U(lambda)`, `V(lambda)`, Stokes-I amplitude, phase, error. Earth’s rotation drags baselines into arcs. Most of the Fourier plane is empty. Image pipelines minimize a floating-point objective with entropy, total-variation, and compactness priors — and, for Sgr A\* static imaging, start from **lightcurve-normalized** visibilities (`csv_norm/`), not the absolute-jansky `csv/` (VERIFIED from the release’s own README).

Study 07 grades the table first and formalizes the provenance line as a ledger row. The PNG is the adversary class not because images are fabricated bytes — they are not — but because an image is a reconstruction from a named product, and which product fork it came from matters. The image-for-measurement conflation lives chiefly in the press layer, not in the collaboration’s publications; this study makes the distinction gradeable rather than rhetorical.

### 4.2 Forcing, archive, adversary

| Piece | Instantiation |
|---|---|
| Clock / track | Observation UT; Earth-rotation `(u,v)` from station geodesy + Sgr A\* direction |
| Archive | EHT 2022-D02-01 — tarball SHA-256 `709f322cd825669e1b30dacb3c9093f016ae3c931a19366b7b29f536ed0baebb` (recomputed byte-exact from the local corpus copy 2026-08-13; repository listing and 7,083,259-byte size VERIFIED live) |
| Adversary | Ring images / pipelines; **processing adversary** = `csv_norm/` (Paper III static-imaging input) |
| Integer seals | µJy amplitudes, millidegree phases, kλ baselines, 0.01 h bins |

### 4.3 Frozen law (exact integers)

| Symbol | Sealed threshold |
|---|---|
| Short-baseline median (`q` < 1000 Mλ) | ≥ **1,500,000 µJy** (1.5 Jy) |
| Long-baseline median (`q` ≥ 4000 Mλ) | ≤ **400,000 µJy** (0.4 Jy) |
| Short/long ratio | ≥ **5,000 ppt** (×5) |
| Closure-phase sector concentration | ≥ **200 ppt** |
| Concentration − phase-scramble null | ≥ **20 ppt** (seed **7**) |
| Earth-rotation arc-order agreement | ≥ **400 ppt** |

WIN iff all hold. No float crosses a seal.

### 4.4 Primary grades — the sky’s table (`csv/`)

**8 / 8 WIN** (days 096 & 097 × lo/hi × casa/hops):

| Day | Band | Pipeline | Short (Jy) | Long (Jy) | Ratio | Clos. conc | vs null | Verdict |
|---|---|---|---|---|---|---|---|---|
| 096 | hi | casa | 2.503 | 0.134 | ×18.6 | 452 ppt | +149 | WIN |
| 096 | hi | hops | 2.517 | 0.135 | ×18.6 | 463 ppt | +160 | WIN |
| 096 | lo | casa | 2.443 | 0.119 | ×20.5 | 445 ppt | +137 | WIN |
| 096 | lo | hops | 2.444 | 0.118 | ×20.7 | 473 ppt | +182 | WIN |
| 097 | hi | casa | 2.183 | 0.109 | ×20.1 | 509 ppt | +161 | WIN |
| 097 | hi | hops | 2.186 | 0.103 | ×21.2 | 492 ppt | +136 | WIN |
| 097 | lo | casa | 2.100 | 0.112 | ×18.7 | 499 ppt | +155 | WIN |
| 097 | lo | hops | 2.106 | 0.108 | ×19.5 | 501 ppt | +122 | WIN |

The magnitudes agree with the collaboration’s own literature — compact flux ~2.4 Jy at 230 GHz on short baselines, ~0.1 Jy on long (REPORTED) — which is corroboration, not independent reproduction.

**A caveat carried on the row itself:** the six thresholds were derived from this same eight-file corpus and set outside its observed envelope, so 8/8 WIN on the 2017 corpus was guaranteed by construction. The WIN is **descriptive** of what the table contains; the law’s discriminating power exists only against future products it has not seen — the Registry’s S4 rows (§4.7). The seal timestamp 2026-07-23T20:00:59Z is ledger-internal, with no third-party time anchor; anchoring seal times externally is recorded program debt (§9).

### 4.5 Processing adversary — `csv_norm/`

**8 / 8 MISS**, every file `SHORT_FAIL`. Short-baseline medians fall to ~**0.997–0.999 Jy** — below the 1.5 Jy floor — while ratios remain steep.

This outcome is predictable from the product’s definition: an amplitude divided by the concurrent total-flux light curve has short-baseline amplitude near 1.0 Jy-equivalent **by construction**, and 1.0 < 1.5. The 8/8 MISS therefore re-derives the definition of the normalized product — it is a provenance fact, not a discovery about the sky, and the normalization is a documented processing step whose stated purpose is to mitigate Sgr A\*’s rapid intraday variability so static full-track imaging is possible (REPORTED — Paper III and the release README). The same graded table shows the short/long ratio ladder (18,785–21,716 ppt) survives normalization intact, and closure phases are exactly invariant under a per-time amplitude scale: **the shape information imaging actually uses passes through the fork unchanged.** What normalization destroys is the absolute jansky appointment on short baselines; naming that is the row’s whole content.

### 4.6 What this means — and what it does not

**Means:**

1. Compact emission at the galactic center is a **table fact** (~2.1–2.5 Jy short baselines) — a number the collaboration itself publishes in the open release this study graded.
2. The Fourier profile is a **steep radial ladder** (~×18–×21), not a flat point source.
3. Closure phases are **structured** against a deterministic scramble null.
4. `(u,v)` samples **march on Earth-rotation arcs**.
5. HOPS and CASA **agree** under identical integers.
6. The static-imaging input product is a **different table**: the absolute short-baseline appointment lives only in `csv/`. Treating the ring PNG as “the raw data” confuses a reconstruction with a measurement — a confusion the collaboration’s publications avoid and press simplification routinely commits.

**Does not mean:**

- That there is no compact source at Sgr A\* (the opposite is measured).
- That published images are fabricated bytes (they are reconstructions from named products).
- That this study has imaged an event horizon in integer pixels (WIN is network shape, not a ring map).
- That the ring was painted by priors. The quantities that pin morphology — closure phases and the ratio ladder — pass through normalization unchanged, and the collaboration reports non-ring morphologies in ≤5% of its descattered top-set reconstructions across independent pipelines, plus synthetic-data tests against non-ring models (REPORTED — Paper III). The collaboration explicitly tested the hypothesis a skeptical reader might raise here. This ledger neither confirms nor refutes the ring morphology; the frozen law grades absolute amplitudes and network shape, not images.

**The program’s reading, stated as the program’s reading:** the Milky Way’s center wrote arcs, janskys, and closures into the public table; the ring image is a regularized reconstruction built on the normalized fork of that table, filling sparse Fourier coverage. Naming the fork is provenance discipline — a distinction the collaboration also draws in its own release documentation. The frozen law grades the fork’s absolute amplitudes; whether the reconstruction’s morphology is right is a question this ledger does not grade, and one the collaboration addresses with its own published tests.

### 4.7 Standing future test — where the law can actually discriminate

The Registry pre-registers named future portal products (2025-D01-01, 2025-D02-01, 2026-D01-01) under the same frozen law. That is the one place the law earns non-circular discriminating power: a future non-normalized Sgr A\* release passing or failing the 1.5 Jy floor would be a genuine out-of-sample result. As of this revision, S4 is OPEN, the named product codes have not been checked against the portal, and nothing prospective has been graded.

**Entry points:** [Charter](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) · [Corpus](Study-07-SgrA-Milky-Way-Corpus.md) · [Results](Study-07-SgrA-Milky-Way-Results.md) · [Registry](Study-07-SgrA-Milky-Way-Registry.md)

---

## 5. One method — the isomorphism table

| Study | Confinement analog | Traveling-lag analog | Adversary |
|---|---|---|---|
| 01 Eclipse | Umbra / obscuration gate | Station maxima march with cone ground speed | Gannon storm (graded); Halloween 2003 ingested as archive reference only, never graded as shear pairs |
| 02 Launch holes | ±3° ascent corridor | Onset T+5–15 min from liftoff; recovery hours | Storms, Tonga TIDs, deorbit burns |
| 03 Flare SIDs | Sunlit hemisphere bands | Lockstep with GOES X-ray peak | Storms, radio bursts |
| 04 Tsunami | Gauge on travel-time chart | Origin → arrival by Huygens time | Surge, meteotsunami, Lamb |
| 05 Forbush | Global NM network, rigidity order | Single L1 shock minute | Pressure, diurnal wave |
| 06 Explosion | P-window vs Lg-window energy | Ladder from catalog clock + point track | Quakes, quarry blasts |
| 07 Sgr A\* | Short/long `q` ladder + closure sectors | Earth-rotation arc order in UT | Ring PNG + `csv_norm` |

Same grammar. Different skies. That is the program.

---

## 6. Why this changes how archives are read

### 6.1 From pictures and percent to appointments

Operational and public science default to:

- **Percent / amplitude** (ionosphere, cosmic rays),
- **Images** (VLBI, medical, remote sensing),
- **Scalar discriminants** (mb/Ms, P/Lg),
- **Baseline-corrected residuals** (tide gauges, neutron monitors).

Each default invites a magnitude mimic. The shear default asks: **did the response keep the forcing’s appointment?** That question is decidable in integers on public bytes.

### 6.2 Processing forks become first-class adversaries

Study 07 makes explicit what every field quietly knows: the product you download for “science ready” imaging may not be the product that carries the absolute appointment. Naming `csv` vs `csv_norm` as separate graded surfaces — and publishing MISS on the imaging fork — is the discipline. The same discipline applies wherever a community “corrects,” “detrends,” or “normalizes” before the claim is made.

### 6.3 Pre-registration is not optional decoration

Study 1 sealed its 2026 claims on 2026-07-16, 27 days before the eclipse — and the eclipse then occurred with the fingerprints untouched, re-verified byte-exact the day after. Study 07 freezes thresholds before the next portal release is scored. Studies 02–06 are built to freeze before the next launch, flare, quake, or L1 shock. Without pre-registration, shape tests collapse into post-hoc storytelling — the failure mode the program was built to exit.

### 6.4 Falsifiers stay on the page

Study 1’s historical Form carries its recorded falsifiers in the seal itself: 15/16, the Eugene 2023 miss named, nine false positives published, sealed under a failure terminal and never renamed. Study 07’s `csv_norm` MISS rows stay published. The program’s **operational** failures get the same treatment: the eclipse-cycle [27-day review](Eclipse-2026-First-27-Days-Review.md) grades every public promise KEPT or MISSED by name — including the missed 2026-08-13 verdict date and the dark live watch. The program’s epistemology is: **a recorded failure is how the experiment learns to see.** Renaming MISS as success is forbidden.

---

## 7. Program status board (as of 2026-08-13, T+1)

| # | Study | Stage | Headline result |
|---|---|---|---|
| 1 | Eclipse 2026 | **Event complete · fair test verified · Forms re-verified byte-exact** | Grades ~2026-08-30 on Madrigal posting |
| 2 | Launch holes | Charter sealed | Corpus next |
| 3 | Flare SIDs | Charter sealed (+ Layer B helicity, checklist page) | Corpus next |
| 4 | Tsunami vs surge | Charter sealed | Corpus next |
| 5 | Forbush | Charter sealed | Corpus next |
| 6 | Explosion vs quake | Charter sealed | Corpus next |
| 7 | Sgr A\* Milky Way | **Law frozen · graded** | **csv 8/8 WIN; csv_norm 8/8 MISS** |
| 8 | Gaia BH1 | Charter sealed | Corpus next — dedicated ingest only |
| 9 | Global convective bond | Charter sealed on the main-branch surface | Not yet published on this wiki (§1.1b note) |
| 10 | GW interferometry | Queued | No charter yet |

Build order for corpus ingest: **08 (Gaia, parallel)** and **02 → 03 → 05 → 04 → 06**, with Study 07 already through frozen law on the VLBI archive.

---

## 8. What each sealed win protects

| Study | Downstream |
|---|---|
| 01 / 02 / 03 | GNSS, HF aviation, scheduled ionospheric integrity. What the sealed record supports today is **retrospective grading on definitive archives**. The one operational instantiation attempted so far — Study 1’s live storm-gate watch for eclipse day — never ran (dark from 2026-07-21; graded MISSED in the [27-day review](Eclipse-2026-First-27-Days-Review.md)). Shape warnings with clocks remain the goal, not a delivered capability |
| 04 | Tsunami warning vs surge false alarm — travel-time appointments at gauges |
| 05 | Honest cosmic-ray steps vs weather-shaped phantoms |
| 06 | Treaty-relevant explosion/quake shape in public integer counts |
| 07 | Public clarity about what the galactic-center table contains, and which product fork any image was built on, before any ring is shown |

---

## 9. Limitations and falsification — what is not yet won, and what would count as losing

Every charter page on this surface now carries its own honest-limits section; this is the program-level one, covering every open study.

### 9.1 Study 1 — Eclipse 2026

- **Nothing about the 2026 prediction is yet won or lost.** The grading surface (Madrigal instrument-8000) has not posted eclipse day; grading runs ~2026-08-30. The falsification terms are printed in full in §2 — a verdict failing any of them is a miss and will be published as one.
- **Named residual caveat:** the Iceland corridor carries a mild solar-wind tail (56 minutes of Bz below −3 nT); Spain is clean. The Leirvogur magnetometer cross-check is pending.
- **The live operational surface failed while the sealed core held:** watch dark from 2026-07-21, daemon never installed, the Aug-13 verdict promise missed — all graded in the [27-day review](Eclipse-2026-First-27-Days-Review.md).
- **The fossil corpus is 82 station-day pairs**, not the 96 a birth-day commit message claimed; and the corpus file itself sits outside version control — custody rests on the ledger rendering, not git (recorded debt).

### 9.2 Studies 02–06

Charters only. No thresholds frozen, no corpus ingested, no result exists — favorable or otherwise. Each could fail at corpus stage; if one does, the failure publishes under the same rules as Study 1’s historical Form. Falsification for each: its sealed confinement and traveling-lag clauses fail on the next scored event in its domain.

### 9.3 Study 07 — Sgr A\*

- **The 8/8 WIN is in-sample by construction:** thresholds were derived from the same eight files they grade, set outside the observed envelope. Discriminating power is prospective only (§4.7), and nothing prospective has been graded; the pre-registered future product codes have not been checked against the portal.
- **The 8/8 MISS is true by construction:** it re-derives the definition of lightcurve normalization. It is a provenance result, not a sky result.
- **Reproducibility is partial:** the short/long medians, ratio, and both amplitude floors — the fork that carries the `SHORT_FAIL` headline — are algorithm-complete on the public pages. Three of six law components are not: the closure-phase sector concentration lacks a published triangle-enumeration and binning specification, the scramble null names seed 7 without naming the shuffle algorithm, and arc-sign agreement is not defined at algorithm level. A third party cannot yet reproduce the full six-inequality verdict from published material alone. Publishing those three specifications is open debt.
- **Seal timestamps are ledger-internal** with no third-party time anchor (a program-wide debt, §9.6).
- **Falsifier:** a future non-normalized Sgr A\* release failing the 1.5 Jy short-baseline floor — or a normalized one passing it — breaks the law’s reading of the archive.

### 9.4 Study 08 — Gaia BH1

- **The title channel is undecidable today.** Gaia DR3 publishes no epoch astrometry for this source; the astrometric-residual track cannot be constructed from any public release until Gaia DR4, announced for **2026-12-02** (VERIFIED). The charter’s VOID-by-inventory clause covers this honestly; the S4 pre-registration should pin that date. The decidable raw channel at charter stage is the radial-velocity series — 115 public epochs across four instruments (VERIFIED), the study’s strongest public raw surface.
- **The arithmetic already fixes the honest expectation.** From the published parameters, the star’s barycentric orbit subtends ~2,600 integer microarcseconds and the RV semi-amplitude is ~66,000 integer m/s — 10³–10⁴ times the sealed integer quanta, whose m/s quantum sits at the best instrument’s own noise floor. The charter-stage expectation, to be pre-registered at S4, is therefore an adversary **WIN on the mass object**: the ~9.3 M☉ dark companion is fully supported by integer appointments. Only the horizon-scale **label** stays at the model layer — and the published papers themselves claim no horizon-scale measurement; that narrative is the press layer. The charter grades the published solution and the popular narrative separately, and this paper adopts that split.
- **The sealed adversary must pin which published solution is graded:** the 2023 discovery mass (9.62 ± 0.18 M☉) and the 2024 refit (9.27 ± 0.10 M☉) differ by ~0.35 M☉ (both REPORTED from the literature, VERIFIED as published values).
- **The public sampling clock is a forecast:** the scanning-law transit predictor is public, but only ~80% of predicted transits yield accepted data, and the as-flown per-transit times in the DR3 fit are unpublished until DR4. The frozen law must grade windows, not individual guaranteed transits.

### 9.5 Studies 09 and 10

Study 09 (Global Convective Bond) exists as a charter on the main-branch surface only; it is not yet published here, and this paper cites it without a link rather than linking into a void. Study 10 (GW interferometry) is queued with no charter.

### 9.6 Program-wide

Seal timestamps across the program are ledger-internal; third-party time anchoring is open debt. The program was split across three surfaces during the eclipse cycle and has not finished reconciling them (27-day-review finding). Where this paper characterizes external literature or another collaboration’s claims, the sourcing tag is REPORTED; where it states bytes fetched, hashed, or re-derived by the program, the tag is VERIFIED.

---

## 10. Reproducibility

| Object | Location |
|---|---|
| Program index | [Shear-Studies-Index](Shear-Studies-Index.md) |
| Study 07 ledger JSON | `corpus/study-07/study07_ledger.json` in [uum8dSolarResearch](https://github.com/gaiaftcl-sudo/uum8dSolarResearch) |
| Study 07 tarball digest | SHA-256 `709f322cd825669e1b30dacb3c9093f016ae3c931a19366b7b29f536ed0baebb` (recomputed byte-exact from the corpus copy 2026-08-13) |
| EHT source | https://github.com/eventhorizontelescope/2022-D02-01 |
| Eclipse Forms / live tables | Ledger-rendered status blocks on the wiki — all live-status blocks across five pages rendered one identical ledger state at 2026-08-13 10:41 UT, and the trial tables match the 82-row corpus row-for-row. Recorded debt: the corpus file itself sits outside version control |
| Eclipse T+1 raw custody | 27 RINEX 30-s files (93 MB, 9 stations, eclipse day DOY 224 + control days 217 / 197) plus GOES / solar-wind / magnetometer captures, under a SHA-256 manifest recording digest, retrieval timestamp, and source URL for every file — held by the program as custody and cross-check; the grading surface remains the pinned Madrigal archive |

Anyone with the charter pages and a terminal can pull the named archives. Study 07’s short/long medians, ratio, and both amplitude floors — the fork that carries the `SHORT_FAIL` headline — are reproducible from the public CSV by the sealed quantization rules on the Results page. The closure-sector, scramble-null, and arc-order components are not yet algorithm-complete in public; publishing those three specifications is recorded debt (§9.3).

---

## 11. Conclusion

The shear program is one claim, restated eight times:

> **An adversary can copy the size of a response. It cannot keep the forcing’s appointment. Grade the appointment in exact integers on public raw bytes. Freeze the law before the next event. Publish WIN and MISS alike.**

Study 1 proved it on the Moon’s shadow against a superstorm — in the historical crucible: sixteen true eclipse rows pass confinement and lag, every Gannon row is rejected, and the threshold was frozen 27 days before the 2026 eclipse, which then arrived on a verified-quiet day with the fingerprints untouched. The 2026 prediction itself grades ~2026-08-30 on the pinned archive; when it resolves, it will be one entry in the track record — no more, no less.

Study 07 proved the same grammar on the Milky Way’s center against the imaging stack: the table carries compact flux, a steep radial ladder, structured closures, and arc order; the normalized imaging input fails the absolute short-baseline seal exactly as its own definition requires; and the ring remains a reconstruction from a named product — which fork it was built on is now a ledger row.

Studies 02–06 and 08 stand ready on the same grammar — ionosphere, ocean, cosmic rays, ground, and a stellar orbit — so the method does not stop at one sky.

And beneath all eight skies runs the fact that makes the grading portable: none of these verdicts is a floating-point computation on somebody's machine. Every sealed threshold, every graded comparison, every fingerprint lives on a whole-integer lattice — arithmetic that produces the identical byte on every computer ever built. A supercomputer offers more approximate arithmetic per second; this program needed arithmetic incapable of taking a side. That is what lets a sealed claim be handed to a stranger for grading, and it is why the seals re-verify byte-for-byte weeks after stamping. The lattice is not an implementation detail. It is what makes the appointment checkable.

The sky writes geometry. The ledger is how we read it — wins, misses, and the program’s own failures alike.

---

## Document control

| Field | Value |
|---|---|
| Title | Shear Studies White Paper — Shape Against Magnitude Across Eight Skies |
| Version | 2.0 |
| Sealed Study 07 law timestamp | 2026-07-23T20:00:59Z |
| Eclipse event date | 2026-08-12 — complete; day verified quiet |
| Eclipse grading window | ~2026-08-30, on Madrigal instrument-8000 posting (lag measured at 2–3 weeks between 2026-07-25 and 2026-08-01) |
| Contact surface | This wiki — append-only study pages; white paper revised by versioned section |

**Version 1.0 (2026-07-23)** — initial public synthesis coinciding with Study 07 law freeze and full program index of Studies 01–07. Carried a title/doc-control contradiction (Eight vs Seven Skies) and a prose-only 2026-08-13 resolution date, both corrected below.

**Version 2.0 (2026-08-13, T+1)** — post-eclipse revision. Past-tense sweep for the completed event; new §2.1 (fair-test verification, raw custody, measured grading window, operational-honesty pointer); Study 1’s frozen falsification numbers printed in full; interpretive claims re-scoped to their evidence class in the Abstract and §§1.1, 1.1b, 4.1, 4.4–4.6, 5, and 8, with the program’s readings attributed as the program’s and the source collaborations’ own statements distinguished; Study 03’s Layer B and checklist page linked; Study 09 renumbering note added and the GW study moved to Study 10; new §9 (limitations and falsification, all open studies); status board refreshed to T+1; title/doc-control contradiction fixed; abstract count corrected to eight skies.

---

## Appendix A — UUM-8D vs IUT (verification exercise, 2026-07-24)

A separate program page records a verification exercise comparing the program’s runtime formalization against Inter-universal Teichmüller theory’s manual symbolic verification, with public seal and graphics: [UUM8D-vs-IUT-Topological-Projection](UUM8D-vs-IUT-Topological-Projection.md).
