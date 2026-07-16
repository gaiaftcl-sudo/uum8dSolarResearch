# Study 4 — Tsunami vs Storm Surge: the ocean floor writes the chart, and the chart cannot lie

A magnitude-9 earthquake under the Pacific is a hammer strike on the planet's largest drum. The sea answers with a ring — a physical, expanding ring of water that marches outward over the ocean floor at √(g·H), the shallow-water speed set by nothing but gravity and depth. Where the ocean is 4,000 m deep the ring runs like a jetliner; over a shallow shelf it slows to highway speed. That means the ring's arrival time at every tide gauge on Earth is *computable in advance* from public bathymetry — a track chart anchored to one seismic instant known to the millisecond.

A hurricane can raise the sea higher than most tsunamis ever will. Hurricane Sandy put **2.87 m** of surge on The Battery gauge in New York — larger than the Tohoku tsunami registered at any US gauge. Same instrument, same units, bigger number. But the storm has no clock and no chart: its water piles up over hours, confined to the storm's footprint, following the storm at storm speed. Magnitude without geometry.

This study extends the shear method validated in the eclipse study (Study 1) — see [Eclipse 2026 — Overview](Eclipse-2026-Overview.md) and [Eclipse 2026 — Model shear](Eclipse-2026-Model-Shear.md) — to the ocean: a second-precision forcing clock, a computable track, a public raw archive that anyone can pull with a GET request, and an adversary that matches the magnitude while owning none of the shape. The question is decidable in exact integers: does the basin-wide set of first arrivals collapse onto the travel-time chart anchored to one earthquake, or doesn't it?

---

## The forcing and its clock

**The clock.** Earthquake origin times from the USGS ANSS ComCat (earthquake.usgs.gov FDSN event service, `format=geojson`). REPORTED — the endpoint was unreachable from the build sandbox, but ComCat event IDs encode the origin time directly: Tohoku's event ID is `official20110311054624120_30`, i.e. **2011-03-11 05:46:24.120 UTC**, confirmed via the USGS event page surfaced in search. ComCat publishes origin times to the second or better; the study clock needs only integer seconds — orders of magnitude tighter than the minutes-scale arrival tolerance. Backup clock: the NCEI/WDS Global Historical Tsunami Database (ngdc.noaa.gov/hazel).

**The track.** The Tsunami Travel Time (TTT) software by Paul Wessel / Geoware — distributed free to warning and mitigation agencies via NCEI and ITIC (VERIFIED at the NCEI travel-time-maps page; SDK 4.0.1, Aug 2023 README at ftp.soest.hawaii.edu/ptwc/TTT/). TTT propagates a Huygens-principle first-arrival front over gridded bathymetry (NCEI 2-arc-minute global relief / ETOPO2) at √(g·H). The Pacific Tsunami Warning Center uses TTT operationally. Anyone reproducing this study without the SDK can run a Huygens fast-marching solver over the free ETOPO 2022 grid — same physics, same chart.

**The chart's own error bar is published:** computed times are usually within 1 hour of observed, occasionally worse trans-Pacific (VERIFIED, NCEI travel-time-maps page). The per-gauge arrival tolerance is derived per-distance from the corpus, sanity-bounded by that published error, never assumed fixed (see the shear metric below).

The three-dimensional picture: one point in space-time (hypocenter, origin second), one cone of causally reachable water expanding over the real seafloor topography, and a fence of gauges standing in the cone's path. Every gauge has a pre-computable appointment with the ring. The adversary keeps no appointments.

---

## The response archive

All four archives are public, keyless, machine-readable, and — for the primary two — verified live during charter drafting.

| Archive | URL | Format | Cadence / limits | Auth |
|---|---|---|---|---|
| **NOAA CO-OPS Data API** (tide gauges) | `https://api.tidesandcurrents.noaa.gov/api/prod/datagetter` | JSON / CSV / XML. VERIFIED live: `product=one_minute_water_level&station=1617760&datum=MSL&units=metric&time_zone=gmt&format=json` returned real 1-min Hilo data for 2011-03-11 (Tohoku day). Products: `one_minute_water_level`, `water_level` (6-min, verified), `predictions` (for de-tiding) | 1-min and 6-min; 1-min history reaches back at least to 2011 at Pacific stations. Per-call limits VERIFIED by the API's own error message: **4 days max** for 1-min, **31 days** for 6-min | None — public GET |
| **UNESCO/IOC Sea Level Station Monitoring Facility** (VLIZ) | `https://www.ioc-sealevelmonitoring.org/service.php` | JSON/XML/text REST. VERIFIED live: `query=data&code=hilo&timestart=2022-01-15T04:00:00&timestop=2022-01-15T06:00:00&format=json` returned 1-min water-level (`wls`) records for the Hunga Tonga day; station `nuku` (Nuku'alofa) also returned data. Sensor codes: `wls`/`rad`/`prs`/`bat` | ~1-minute real-time global feed, hundreds of GLOSS stations; **max 30 days per call** (REPORTED, GLOSS real-time-data-delivery page). Raw — no quality control | None — public GET |
| **NDBC DART** bottom-pressure records | `https://www.ndbc.noaa.gov/view_text_file.php?filename=21418t2011.txt.gz&dir=data/historical/dart/` | Fixed-width text (`YY MM DD hh mm ss T HEIGHT`, meters of water column; T flag — 1: 15-min standard, 2: 1-min, 3: 15-s event mode). VERIFIED live: `21418t2011.txt.gz` returned 2011 records for DART 21418, the first buoy to see Tohoku | 15-min standard, auto-switching to 1-min / 15-s event mode on tsunami trigger; full-resolution 15-s records recovered ~every 2 years, archived at NCEI (netCDF + gzipped CSV via THREDDS — REPORTED) | None — public |
| **NCEI/ITIC Tsunami Travel Time maps + TTT software** (the track chart) | `https://www.ncei.noaa.gov/products/natural-hazards/tsunamis-earthquakes-volcanoes/tsunamis/travel-time-maps` | Precomputed travel-time maps + interactive coastal-locations tool; TTT SDK for arbitrary epicenters. VERIFIED page fetch | Static computation from bathymetry — computable within minutes of any new epicenter | Maps free; SDK distributed free to government warning/mitigation organizations via NCEI+ITIC |

> [!NOTE]
> The CO-OPS `predictions` product is what makes replay deterministic: de-tided residuals (observed minus predicted tide) computed the same way on every machine, every time. IOC is the only archive covering near-source Pacific-island gauges — Tonga, Chile, Japan Sea — outside US territory. DART gives open-ocean confirmation free of harbor resonance.

<details>
<summary>Correction logged during archive verification</summary>

The IOC facility's domain is `ioc-sealevelmonitoring.org`, **not** `ioc-sealevel.org` — the latter does not resolve. Recorded here so no replayer chases a dead domain.

</details>

---

## The adversary

The adversary is every sea-level excursion in the very same raw gauge records — excursions that own the magnitude but not the shape: **storm surge** from tropical and extratropical cyclones, **meteotsunamis** driven by atmospheric-pressure jumps under derechos and squall lines, and — as a hybrid probe — the 2022 Hunga Tonga **Lamb-wave** sea response. This is the oceanic equivalent of Study 1's superstorm: magnitude without the forcing clock.

**Why it mimics.** Same instrument, same units, overlapping or *exceeding* amplitude. Sandy's 2.87 m at The Battery beat any Tohoku reading at a US gauge. The 13 June 2013 meteotsunami rang more than 16 NOAA gauges with >0.5 m peak-to-trough oscillations *in the tsunami frequency band, under clear skies* — the National Tsunami Warning Center initially investigated it as a possible seismic event. Any detector keyed to magnitude alone is already defeated.

**Why shape defeats it.** The tsunami must keep three appointments the adversary cannot fake:

1. **One instant.** Every gauge's first arrival is pinned to a single seismic origin second. Surge has no origin instant — it builds over hours.
2. **One chart.** Arrivals must land at origin_time + TTT(epicenter → gauge) within a distance-scaled tolerance, and in the chart's isochron *order* — the ring marches gauge to gauge across the basin. Surge arrival tracks the cyclone at cyclone speed inside the storm footprint; the 2013 meteotsunami keyed to the squall line and even arrived by *reflection off the continental shelf break* hours after the forcing.
3. **One speed.** √(g·H) over real bathymetry. Tonga's Lamb-wave component arrived **more than 2 hours earlier** than any bathymetric travel time, marching at ~315 m/s atmospheric speed — coherent, basin-wide, and on the *wrong chart*. It is the perfect probe against a shape metric that naively rewards any coherent march: the metric must reject it too.

In de-tided residual space, only a true tsunami produces a basin-wide set of first-arrival lags that collapse onto the TTT chart anchored to one seismic instant. That collapse — or its recorded absence — is the shear.

### Pre-named adversary windows

| Window (UTC) | Event | Why it earns its place |
|---|---|---|
| 2012-10-29 (surge peak ~23:30 at The Battery, coincident with high tide) | Hurricane Sandy storm surge, US East Coast | 2.87 m (9.40 ft) surge at The Battery; 3.86 m (12.65 ft) at Kings Point; storm tide 4.29 m above normal low tide (NHC TCR AL182012, Blake et al. 2013 — VERIFIED via search + nhc.noaa.gov/data/tcr/AL182012_Sandy.pdf). Larger than any US tsunami gauge reading in the corpus. Hours-timescale, storm-footprint-confined, zero seismic clock |
| 2013-06-13 (derecho exited NJ coast ~15:00; waves 3–5 h later) | US East Coast meteotsunami (derecho-generated) | >0.5 m peak-to-trough tsunami-band oscillations at >16 NOAA gauges, Massachusetts to Puerto Rico and Bermuda, clear skies (NOAA NOS CO-OPS 079; NCTR event page — REPORTED from search). Arrivals keyed to squall line + shelf-break reflection — incoherent against any seismic origin |
| 2022-01-15 (eruption 04:14:45; Lamb-wave sea response ahead of the marine tsunami everywhere) | Hunga Tonga Lamb-wave component — adversary embedded inside a real tsunami | Sea-level arrivals >2 h ahead of bathymetric travel time, Pacific-wide, at ~315 m/s (Kubota, Saito & Nishida 2022, *Science*, PubMed 35549307; USGS PCMSC page — REPORTED). Coherent but at atmospheric speed — the wrong-chart probe |

---

## The blind spots this study targets

These are not this study's speculations. Each is a published, documented failure of magnitude-first tsunami practice.

**The $40-million empty wave.** Between 1948 and 1996, 15 of 20 Pacific-wide tsunami warnings were false alarms — 75% (Milburn et al. 1996, PMEL, nctr.pmel.noaa.gov/milburn1996.html). The May 1986 Aleutian (M8.0) warning evacuated Honolulu for a wave that flooded nothing, at a cost of ~$40M (ITIC "Hawaii Tsunami Warnings 1986, 1994"). The documented failure mode is triggering on magnitude without a gauge-track confirmation — exactly the confirmation this study's frozen gate formalizes.

**The day every chart was wrong.** All tsunami-warning-center procedures and products were built for earthquake tsunamis (~90% of the historical record). On 15 January 2022 the Hunga Tonga eruption left every Pacific warning center improvising: arrivals beat the travel-time charts by more than 2 hours (the Lamb wave), the volcano offered no magnitude to key products on, and the severed submarine cable left centers "data blind" at the source (UNESCO/IOC "PTWC Procedures and PTWS Products for HTHH"; USGS PCMSC in-depth article; Kubota et al. 2022, *Science*). Permanent HTHH procedures were only adopted in September 2023.

**Twenty-five impostors a year.** Roughly 25 meteotsunamis per year strike the US East Coast (Dusek et al. 2019, *BAMS* meteotsunami climatology, doi:10.1175/BAMS-D-18-0206.1). The June 2013 event was initially worked as seismic. Small genuine tsunamis at that amplitude are indistinguishable from these events by magnitude alone — only the clock-and-chart shape separates them.

**The chart's own error bar.** TTT computed times are "usually within 1 hour" of observed and can exceed an hour trans-Pacific (NCEI travel-time-maps page). A naive tight arrival gate would falsely reject *genuine* tsunamis. The tolerance must scale with travel distance, be derived from the corpus, and be frozen before use.

**The gauges die exactly when needed.** The 2024 Noto earthquake destroyed or disabled the Wajima and Noto gauges minutes into the record — the nearest witnesses were the first casualties (post-event survey, doi:10.1080/21664250.2024.2368955). The traveling signature must be resolvable from surviving mid- and far-field gauges alone.

---

## The shear metric

Two analogs, both counted in exact integers, both frozen before the next qualifying event.

### Confinement analog

For each event window, count gauges with a significant de-tided residual excursion, binned by great-circle distance from the candidate source. A tsunami excites a basin-wide, azimuthally broad set — Tohoku and Kamchatka rang gauges from Japan to Chile. Storm surge stays inside the storm footprint (Sandy: mid-Atlantic bight only); a meteotsunami stays on one shelf sector. **Metric:** an integer inequality with frozen constants — the count of responding gauges beyond 3,000 km must satisfy count_beyond_3000km ≥ K × count_within_1000km (K a frozen integer in the Form) **and** meet a frozen minimum far-field count across ≥ 3 azimuthal quadrants. When zero gauges respond within 1,000 km (Noto destroyed its near-field gauges; open-ocean epicenters may have none), the near-field term is 0 and the far-field minimum alone decides. Integer counts, integer constants, no division, no floats.

### Traveling-lag analog

Per gauge *g*:

```
lag_g = observed_first_arrival(g) − (origin_time + TTT(epicenter → g))
```

where observed first arrival is the first de-tided residual excursion above that gauge's frozen threshold. A genuine tsunami collapses all lag_g near zero, with spread bounded by the published TTT error (≤ 1 h basin-crossing, minutes regionally), and the arrival *order* matches the chart's isochrons — the ring marches gauge to gauge. The three adversaries fail in three distinct, checkable ways:

- **Surge:** lag_g is undefined and incoherent — there is no origin instant to subtract.
- **Meteotsunami:** lags key to the squall line plus shelf reflections, not to any seismic clock.
- **Lamb wave:** arrivals are systematically EARLY by hours, with lag_g ≈ distance × (1/(315 m/s) − 1/√(g·H)) < 0 — so the metric discriminates coherent-but-wrong-speed marches, not just incoherence.

### Quantization

Integer seconds for all clocks (origin, predicted arrival, observed arrival). Residual water levels in integer millimeters (CO-OPS and IOC both report to the millimeter). Lags binned in integer minutes. TTT isochrons in integer minutes. Every sealed row is exact-integer — no floating point in any sealed proof.

### Threshold derivation plan — derive, never assume

1. **Excursion threshold:** from each gauge's own pre-event 48 h de-tided residual (CO-OPS `predictions` product / IOC baseline), set threshold = k × robust spread, in integer millimeters — calibrated so the four seismic corpus events (Tohoku, Illapel, Noto, Kamchatka) detect at all published responding gauges while the Sandy, June-2013, and Tonga Lamb-wave windows produce *no* basin-wide coherent set.
2. **Lag tolerance:** freeze the minimal integer pair (a, b) such that every corpus |lag_g| ≤ a + b·d — a in integer minutes, b in integer minutes per 1,000 km, d quantized to integer thousands of km (rounded up) — sanity-bounded by NCEI's published ≤ 1 h trans-Pacific TTT error. Deterministic: same corpus, same (a, b), on every machine.
3. **Coherence gate:** minimum N gauges across ≥ 3 azimuthal quadrants whose arrival order matches TTT isochron order — an integer rank correlation.

All three constants freeze in the standing Form BEFORE the next qualifying event. Nothing tunes after the fact.

---

## Historical corpus

Five events. Five clocks. The four seismic events calibrate the thresholds; Hunga Tonga enters as the pre-registered wrong-speed adversary — then the thresholds seal.

| Date (UTC) | Event | Origin clock (UTC) | Response magnitude | Sources |
|---|---|---|---|---|
| 2011-03-11 | Tohoku, Japan — Mw 9.1 megathrust | 05:46:24 (USGS `official20110311054624120_30` — origin time encoded in the event ID, confirmed on the USGS event page via search) | First wave at DART 21418 ~25 min after origin, ~1.8 m open-ocean amplitude (exceptional; typical DART tsunami signals are cm-scale). CO-OPS 1-min Hawaii records for this day VERIFIED retrievable | USGS event page; NCEI ngdc.noaa.gov/hazard/11mar2011.html; Heidarzadeh & Satake 2013, *PAGEOPH* doi:10.1007/s00024-012-0558-5; NCTR nctr.pmel.noaa.gov/honshu20110311/ |
| 2015-09-16 | Illapel, Chile — Mw 8.3 | 22:54:33 (ITIC event data page) | 4.7–4.75 m maximum amplitude at the Coquimbo tide gauge ~100 km north of the epicenter; 6.4 m max runup | ITIC event page (legacy.itic.ioc-unesco.org); Heidarzadeh et al. 2016 *GRL* doi:10.1002/2015GL067297 |
| 2022-01-15 | Hunga Tonga–Hunga Ha'apai eruption + tsunami (volcanic, dual-mechanism) | 04:14:45 eruption onset (NCEI news page; waveform inversions place the marine-tsunami origin ~04:16 — Kubota et al. 2022) | Basin-wide tsunami on IOC and CO-OPS gauges (Nuku'alofa IOC data VERIFIED retrievable); first arrivals >2 h ahead of TTT via the ~315 m/s Lamb wave; Tonga went data-blind when the cable broke | NCEI news page; Kubota, Saito & Nishida 2022 *Science* doi:10.1126/science.abo4364; UNESCO/IOC PTWC-procedures article |
| 2024-01-01 | Noto Peninsula, Japan — Mw 7.5 (Japan Sea) | 07:10:09 / 16:10:09 JST (USGS `us6000m0xl`) | >1.2 m at Wajima before the gauge failed; nearest gauges destroyed/disabled by the earthquake; 11.3 m runup at Monzenmachi Kuroshima (post-event survey) | USGS event page; *Coastal Engineering Journal* doi:10.1080/21664250.2024.2368955; *Scientific Data* doi:10.1038/s41597-024-03619-z |
| 2025-07-29 | Kamchatka Peninsula, Russia — Mw 8.8 (largest since Tohoku) | 23:24:52 (USGS `us6000qw60`; EMSC special report id=386) | Kahului 1.74 m; Crescent City 1.13 m; Baltra, Galápagos 1.04 m; Coliumo, Chile 1.12 m; DART 0.9 m off Kamchatka — "second largest DART amplitude ever recorded"; 19 m runup at Baikovo, Shumshu Is. PTWC inverted five NW-Pacific DARTs for its basin forecast (VERIFIED — NWS/ITIC event page fetched) | NWS/ITIC weather.gov/itic-car/29july2025_kamtchatka_tsunami; USGS `us6000qw60`; EMSC m.emsc-csem.org/Special_reports/?id=386 |

> [!WARNING]
> Hunga Tonga sits in this corpus as the pre-registered adversary only. It fails the standing-law trigger (no M ≥ 7.5 earthquake), so it is excluded from the detection calibration set; its Lamb-wave window must seal a non-detection under the same frozen gate the four seismic events pass.

---

## Pre-registration

### Standing law

The law resolves on the **next M ≥ 7.5 subsea earthquake** — USGS ComCat criteria: magnitude ≥ 7.5, hypocentral depth < 100 km, epicenter oceanic or ≤ 50 km offshore — the offshore rule decided on the same ETOPO 2022 grid already frozen for TTT: epicenter cell water depth > 0, or great-circle distance to the nearest land cell ≤ 50 km (rule and grid version frozen in the Form).

**Prediction template:** within lag tolerance(d) of origin_time + TTT(epicenter → gauge), ≥ N pre-named gauges (a CO-OPS 1-min + IOC 1-min roster, frozen in the Form) show first de-tided residual excursions above their frozen per-gauge integer-mm thresholds, in TTT isochron order across ≥ 3 azimuthal quadrants — **and** no window lacking a qualifying earthquake produces that coherent set (storm and meteotsunami windows must fail the gate). Every binding constant above is currently blank: the standing law is inert until a dated, sealed Form row exists — ledger ID, ISO timestamp, all constants filled — and S3 may only be claimed against that sealed row.

Base-rate note: 2011–2025 produced qualifying events roughly yearly (Tohoku 2011, Illapel 2015, Noto 2024, Kamchatka 2025…), so the law resolves on a ~1-year horizon.

### Cadence

- **Continuous:** poll USGS ComCat each heartbeat for qualifying events. On trigger: pull CO-OPS `one_minute_water_level` (4-day-max calls) + IOC `service.php` (30-day-max calls) + NDBC DART event-mode files for the pre-named roster; compute integer lags against the frozen TTT chart; seal the verdict within 72 h of origin.
- **Quarterly adversary audit:** run the *identical* pipeline over every adversary window of the quarter, enumerated mechanically from the named archives — every NHC advisory reporting US surge ≥ 1 m, and every Dusek-catalog East Coast meteotsunami event ≥ 0.3 m peak-to-trough — and seal the required non-detections.

### The standing-law Form — frozen before the event, sealed to the ledger

1. **Gauge roster** with station IDs (CO-OPS numeric + IOC codes) and per-gauge integer-mm thresholds.
2. **TTT computation recipe:** bathymetry grid version, Huygens solver, and the rule that epicenter → per-gauge integer-minute predictions are emitted within 1 h of any qualifying origin and sealed *before* the first predicted arrival at far-field gauges.
3. **Lag tolerance function** constants: a in integer minutes; b in integer minutes per 1,000 km, with d quantized to integer thousands of km (rounded up); both frozen by the minimal-(a, b) corpus rule above.
4. **Coherence gate:** N and the quadrant rule.
5. **Validity quorum + falsifiers** — the verdict binds iff ≥ M roster gauges returned ≥ X% of their 1-min samples in the arrival window across ≥ 3 azimuthal quadrants (M and X frozen in the Form); below that quorum the event seals VOID. Above the quorum, the law FAILS if the coherent set is absent for a qualifying event; or PRESENT in any pre-registered adversary window; or if arrivals march coherently at atmospheric speed (the Lamb-wave discriminant) without the seismic clock.

A recorded failure is a finding. It is sealed raw, under its own name, exactly as the Gannon shear was in Study 1.

---

## Success criteria

S1 and S2 are calibration sanity checks — guaranteed by construction on the same windows the thresholds were tuned on. Only S3 and S4 test the law.

- **S1 — Corpus lock (calibration sanity check).** With thresholds, tolerance(d), and the coherence gate frozen from the four seismic corpus events (Tohoku, Illapel, Noto, Kamchatka), all four pass the full gate — basin-wide coherent set, integer lags within tolerance(d), isochron rank order across ≥ 3 azimuthal quadrants — computed from the public archives named above, replayable by anyone with a GET request. This verifies the frozen pipeline replays its own calibration; it is not evidence for the law. Decidable: pass/fail per event.
- **S2 — Adversary lock (calibration sanity check).** The identical frozen pipeline over the three pre-named adversary windows (Sandy 2012, meteotsunami 2013-06-13, Tonga Lamb-wave component 2022) produces NO qualifying coherent set in any of them — including rejection of the Lamb wave's coherent-but-wrong-speed march. Like S1, this restates the calibration constraint; it is not evidence for the law. Decidable: zero false gates out of three, sealed raw.
- **S3 — Standing law resolves live.** On the next ComCat M ≥ 7.5 subsea event, the prediction sealed before arrival in the dated Form row (per-gauge integer-minute arrivals + coherence gate) is verdicted from raw archive pulls within 72 h of origin, and the verdict — PASS or FAIL — is sealed exactly as computed. Decidable: one event, one integer verdict row.
- **S4 — Quarterly adversary audits stay clean.** Every quarterly audit window seals its required non-detection; any detection in an adversary window is sealed raw as a falsifier of the law, never reprocessed, never renamed. Decidable: audit rows exist each quarter, each 0 or 1.

## Honest limits

- **This is not a warning system.** Verdicts seal within 72 h of origin — long after any evacuation decision. This study tests whether the shape discriminant is *sound*, not whether it is fast.
- **This is not a coverage claim for non-seismic tsunamis.** The standing law keys to ComCat M ≥ 7.5 — a Tonga-class volcanic or landslide tsunami is a real tsunami this law never triggers on. Volcanic events are logged as out-of-scope observations, with the Lamb-wave discriminant recorded as the documented extension path.
- **This is not immune to gauge death.** Noto 2024 destroyed its nearest gauges mid-record. The law is scoped to resolve from mid- and far-field gauges, and the roster carries redundancy per azimuth — but a sufficiently gauge-poor azimuth can leave a quadrant dark; the Form's validity quorum decides when that seals VOID instead of binding a verdict.
- **This is not float-free physics, only float-free proof.** The TTT solver computes in floating point; everything *sealed* — clocks, lags, thresholds, ranks — is quantized to exact integers first.
- **Marginal events have a frozen partition, not discretion.** Small real tsunamis (< ~0.3 m) sit at meteotsunami amplitude. The Form freezes the partition before any event: absence of TTT isochron order-coherence at ≥ N gauges seals FAIL regardless of amplitude; a "below-threshold, order-coherent" seal is permitted only when the Form's pre-registered amplitude predictor (from magnitude + depth) predicts sub-threshold response at the roster. That predictor-sanctioned bin is the only one that does not count against the law; every other absence of the coherent set above quorum seals FAIL.
- **Archive mechanics constrain the pipeline, not the other way round.** CO-OPS 1-min pulls are hard-capped at 4 days per call; IOC at 30 days, raw and un-quality-controlled (spikes, gaps, datum jumps); DART's 15-s full-resolution records arrive only after ~2-year instrument recovery, so DART is confirmation, not the primary gate. The ComCat endpoint was unreachable from the drafting sandbox — the watch daemon requires a network path to ComCat or the EMSC fdsnws mirror, cross-checked to the second.

**Status: OPEN — charter published, corpus not yet ingested. Nothing here is sealed until the corpus runs.**
