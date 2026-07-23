# Shear Studies White Paper — Shape Against Magnitude Across Seven Skies

**Program:** UUM-8D Solar Research / Shear Studies  
**Surface:** [uum8dSolarResearch wiki](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki)  
**Date:** 2026-07-23  
**Status of this document:** Public synthesis of sealed and open studies. Numbers cited for Study 1 and Study 07 are ledger-frozen; Studies 02–06 are charter-sealed pending corpus ingest.

---

## Abstract

Science has spent decades measuring the world with rulers: percent drop, peak amplitude, χ² fit, image brightness. Rulers are cheap to fool. A geomagnetic superstorm digs a deeper ionospheric hole than an eclipse; a storm surge lifts a tide gauge as high as a tsunami; lightcurve normalization and image regularizers turn sparse radio tracks into a filled ring. Magnitudes travel. **Appointments do not.**

This program replaces the ruler with a **shear**: a forcing that carries its own public clock and track; a raw public archive; a named adversary that matches size but not shape; and a frozen exact-integer law that grades confinement and traveling lag before any future event is scored. The eclipse of 2026-08-12 is the reference implementation. Six further studies transplant the same recipe to rocket burns, solar flares, tsunamis, cosmic-ray Forbush decreases, explosion-vs-earthquake discrimination, and — now frozen — the Event Horizon Telescope’s public visibilities of Sagittarius A\*, the radio source at the center of the Milky Way.

**The finding that changes the reading of the galactic center:** the public non-normalized Stokes-I CSV for Sgr A\* (product 2022-D02-01) passes a frozen integer law on short/long baseline ladder, closure-phase structure, and Earth-rotation arc order — **8/8 WIN** across days, bands, and both HOPS and CASA pipelines. The lightcurve-normalized tables used as static-imaging input fail the same absolute short-baseline floor — **8/8 MISS**. Compact flux ~2.1–2.5 Jy on short baselines is in the sky’s table. The filled ring is what happens after the table is altered and the Fourier gaps are painted. That separation is not a slogan. It is a ledger row.

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

**Status:** RESOLVING 2026-08-13 · locked until the sky answers.

On 2026-08-12 at 17:45:54 UT the Moon’s umbral cone crosses western Iceland and northern Spain. Sixty years of eclipse-ionosphere work reported scalars (“TEC dropped 40%”). On 2024-05-11 the Gannon superstorm produced deeper depletions under an unobscured Sun — every ruler pipeline that day recorded an eclipse that never happened.

Study 1 asks a different question: does the ionospheric dent **thread** the shadow’s timetable — confined to the geometry’s minutes, deepest near each station’s own maximum, marching at the cone’s ground speed? Storms dig holes; they have no cone, no track, no clock.

**Already sealed (public Forms):**

| Stage | Claim | Status |
|---|---|---|
| 2024 proof | Shape-read verifies April 2024 eclipse from raw archives | SEALED |
| Historical universality | One frozen law across 2017 / 2023 annular / 2024 + storm shear | SEALED RAW (includes own falsifiers) |
| 2026 prediction | Named totality stations must thread; named nulls must refuse | PRE-REGISTERED |
| Extensions | Station order and storm-decidable confinement | PRE-REGISTERED |

**Why it is the reference:** it proved that a magnitude-mimicking adversary (Gannon) fails a shape test that true eclipse days pass — and that the law can be sealed weeks before the next sky event. Every later study reuses that logic.

**Entry points:** [Overview](Eclipse-2026-Overview.md) · [Model shear](Eclipse-2026-Model-Shear.md) · [Prediction registry](Eclipse-2026-Prediction-Registry.md) · [Blind spots](Eclipse-2026-Blind-Spots.md)

---

## 3. Studies 02–06 — charters sealed, corpus road ahead

These five share Study 1’s recipe. Their status is **OPEN — charter sealed**; thresholds are not yet frozen. They are not placeholders: each names archives, adversaries, integer metrics, and success criteria.

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

**Status:** LAW FROZEN 2026-07-23T20:00:59Z · primary `csv/` **8/8 WIN** · `csv_norm/` adversary **8/8 MISS**

### 4.1 The category error this study ends

The public conversation treats the EHT ring image as if it were the measurement. The measurement is a **visibility table**: time, station pair, `U(lambda)`, `V(lambda)`, Stokes-I amplitude, phase, error. Earth’s rotation drags baselines into arcs. Most of the Fourier plane is empty. Image pipelines minimize a floating-point objective with entropy, total-variation, and compactness priors — and, for Sgr A\* static imaging, start from **lightcurve-normalized** visibilities (`csv_norm/`), not the absolute-jansky `csv/`.

Study 07 grades the table first. The PNG is the adversary class.

### 4.2 Forcing, archive, adversary

| Piece | Instantiation |
|---|---|
| Clock / track | Observation UT; Earth-rotation `(u,v)` from station geodesy + Sgr A\* direction |
| Archive | EHT 2022-D02-01 — tarball SHA-256 `709f322cd825669e1b30dacb3c9093f016ae3c931a19366b7b29f536ed0baebb` |
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

### 4.5 Processing adversary — `csv_norm/`

**8 / 8 MISS**, every file `SHORT_FAIL`. Short-baseline medians fall to ~**0.997–0.999 Jy** — below the 1.5 Jy floor — while ratios remain steep. Normalization preserves a relative ladder and destroys the absolute jansky appointment the raw short baselines keep.

### 4.6 What this means — and what it does not

**Means:**

1. Compact emission at the galactic center is a **table fact** (~2.1–2.5 Jy short baselines).
2. The Fourier profile is a **steep radial ladder** (~×18–×21), not a flat point source.
3. Closure phases are **structured** against a deterministic scramble null.
4. `(u,v)` samples **march on Earth-rotation arcs**.
5. HOPS and CASA **agree** under identical integers.
6. The static-imaging input product is a **different table**; treating the ring PNG as “the raw data” fails this ledger.

**Does not mean:**

- That there is no compact source at Sgr A\* (the opposite is measured).
- That published images are fabricated bytes (they are reconstructions from named products).
- That this study has imaged an event horizon in integer pixels (WIN is network shape, not a ring map).

**The sentence that changes the public reading:**  
*The Milky Way’s center wrote arcs, janskys, and closures; the ring is what you see after the table is normalized and the gaps are filled.*

**Entry points:** [Charter](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) · [Corpus](Study-07-SgrA-Milky-Way-Corpus.md) · [Results](Study-07-SgrA-Milky-Way-Results.md) · [Registry](Study-07-SgrA-Milky-Way-Registry.md)

---

## 5. One method — the isomorphism table

| Study | Confinement analog | Traveling-lag analog | Adversary |
|---|---|---|---|
| 01 Eclipse | Umbra / obscuration gate | Station maxima march with cone ground speed | Gannon / Halloween storms |
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

Study 1 sealed 2026 claims before August. Study 07 freezes thresholds before the next portal release is scored. Studies 02–06 are built to freeze before the next launch, flare, quake, or L1 shock. Without pre-registration, shape tests collapse into post-hoc storytelling — the failure mode the program was built to exit.

### 6.4 Falsifiers stay on the page

Study 1’s historical Form already carries recorded falsifiers. Study 07’s `csv_norm` MISS rows stay published. The program’s epistemology is: **a recorded failure is how the experiment learns to see.** Renaming MISS as success is forbidden.

---

## 7. Program status board (as of 2026-07-23)

| # | Study | Stage | Headline result |
|---|---|---|---|
| 1 | Eclipse 2026 | Law frozen · prediction live | Resolves 2026-08-13 |
| 2 | Launch holes | Charter sealed | Corpus next |
| 3 | Flare SIDs | Charter sealed | Corpus next |
| 4 | Tsunami vs surge | Charter sealed | Corpus next |
| 5 | Forbush | Charter sealed | Corpus next |
| 6 | Explosion vs quake | Charter sealed | Corpus next |
| 7 | Sgr A\* Milky Way | **Law frozen · graded** | **csv 8/8 WIN; csv_norm 8/8 MISS** |

Build order for corpus ingest (pipeline reuse): **02 → 03 → 05 → 04 → 06**, with Study 07 already through frozen law on the VLBI archive.

---

## 8. What each sealed win protects

| Study | Downstream |
|---|---|
| 01 / 02 / 03 | GNSS, HF aviation, scheduled ionospheric integrity — shape warnings with clocks |
| 04 | Tsunami warning vs surge false alarm — travel-time appointments at gauges |
| 05 | Honest cosmic-ray steps vs weather-shaped phantoms |
| 06 | Treaty-relevant explosion/quake shape in public integer counts |
| 07 | Public honesty about what the galactic-center table contains before any ring is shown |

---

## 9. Reproducibility

| Object | Location |
|---|---|
| Program index | [Shear-Studies-Index](Shear-Studies-Index.md) |
| Study 07 ledger JSON | `corpus/study-07/study07_ledger.json` in [uum8dSolarResearch](https://github.com/gaiaftcl-sudo/uum8dSolarResearch) |
| Study 07 tarball digest | SHA-256 `709f322cd825669e1b30dacb3c9093f016ae3c931a19366b7b29f536ed0baebb` |
| EHT source | https://github.com/eventhorizontelescope/2022-D02-01 |
| Eclipse Forms / live tables | Regenerated into wiki GAIA blocks from the experiment ledger |

Anyone with the charter pages and a terminal can pull the named archives. Study 07’s integers are reproducible from the public CSV by the sealed quantization rules on the Results page.

---

## 10. Conclusion

The shear program is one claim, restated seven times:

> **An adversary can copy the size of a response. It cannot keep the forcing’s appointment. Grade the appointment in exact integers on public raw bytes. Freeze the law before the next event. Publish WIN and MISS alike.**

Study 1 proved it on the Moon’s shadow against a superstorm. Study 07 proved it on the Milky Way’s center against the imaging stack: the table carries compact flux, a steep radial ladder, structured closures, and arc order; the normalized imaging input fails the absolute short-baseline seal; the ring remains a reconstruction, not a row.

Studies 02–06 stand ready on the same grammar — ionosphere, ocean, cosmic rays, and ground — so the method does not stop at one sky.

The sky writes geometry. Geometry cannot lie. The ledger is how we read it.

---

## Document control

| Field | Value |
|---|---|
| Title | Shear Studies White Paper — Shape Against Magnitude Across Seven Skies |
| Version | 1.0 |
| Sealed Study 07 law timestamp | 2026-07-23T20:00:59Z |
| Eclipse resolution date | 2026-08-13 |
| Contact surface | This wiki — append-only study pages; white paper revised only by additive version section |

**Version 1.0** — initial public synthesis coinciding with Study 07 law freeze and full program index of Studies 01–07.
