# Study 02 — Rocket-Launch Ionospheric Holes: the sky keeps a launch log

A rocket's second stage burns through the one layer of the sky that carries long-range radio. On the night of 2023-07-19 (04:09 UTC July 20), a Falcon 9 out of Vandenberg lit its second stage at 286 km altitude — right at the F-region peak — and its water and carbon-dioxide exhaust quenched the local ionization by up to 70%. People from Southern California to Arizona photographed the wound: a red 630.0 nm glow, visible for ~20 minutes, oxygen ions recombining where the plasma used to be (Jeff Baumgardner, Boston Univ., via spaceweatherarchive.com 2023-07-23 — VERIFIED by fetch).

That is the shape this study grades. A hole ~900 km across, punched along a published track, opening 5–15 minutes after a liftoff second the operator announces in advance, and healing by plasma diffusion in 1–3 hours (Falcon-9-class F-region holes; the Saturn-V-class founding event ran ~4 h). Around it, on the biggest events, a ring: circular shock-acoustic waves expanding at 629–726 m/s (FORMOSAT-5, 2017 — the largest on record).

The sky writes geometry, and geometry cannot lie. The eclipse study (Study 1 — see [Eclipse 2026 — Overview](Eclipse-2026-Overview.md)) proved the method on a Moon-driven clock: a frozen exact-integer law, an adversary that mimics magnitude but not shape, predictions sealed 27 days ahead. This study runs the same shear recipe on a forcing with a *weekly* clock instead of a yearly one — the fastest forcing cadence in the program.

---

## The forcing and its clock

The forcing is a cone of exhaust dragged along a line in the sky. Three geometric pieces, each computable before the event:

**The clock.** Pre-registration reads the TheSpaceDevs Launch Library 2 `net` field — VERIFIED by live fetch of `https://lldev.thespacedevs.com/2.3.0/launches/upcoming/` on 2026-07-16, which returned an upcoming launch with `net 2026-07-16T20:22:00Z`, `net_precision "Minute"`, pad coordinates 34.632/−120.611, and target orbit, no auth. Post-hoc ground truth is Jonathan McDowell's GCAT/LVDB launch log (planet4589.org/space/gcat/web/launch/index.html — REPORTED via search), the only online source giving liftoff UTC to the second for most launches. Cross-checks: the operator's webcast T-0 and the Spaceflight Now launch log.

Minute-level precision at freeze time is not a weakness: the response rises at T+5 to T+15 min, so the frozen clock is 10–100× tighter than the phenomenon it predicts. GCAT then sharpens it to the second after the fact.

**The track.** The hole's source is the second-stage burn arc, ~200–700 km altitude. Reconstruction: start at the LL2 pad coordinates, take launch azimuth from the target-orbit inclination by spherical trig, refine by back-propagating the first post-launch Space-Track element set to insertion; flightclub.io publishes simulated full-telemetry trajectories per mission for cross-check (site VERIFIED by fetch; per-mission trajectory coverage REPORTED, not individually confirmed).

**The corridor.** A ±3° band around the reconstructed ground track over the T+0 to T+15 min arc. The grading grid is 1°×1°, so km-scale trajectory error is irrelevant — the corridor eats it.

> [!NOTE]
> Nothing in the clock or the track comes from the response data. The forcing is fully specified by public manifests and orbital mechanics before the first response bin exists. That independence is what the shear cuts along.

---

## The response archive

All response data is public, raw, and named here exactly. Grading surface first, disputes and inputs after.

| Archive | URL | Format | Cadence | Auth | Sourcing |
|---|---|---|---|---|---|
| Madrigal world-gridded vertical TEC (CEDAR), instrument 8000, kindat 3500 | https://cedar.openmadrigal.org | ASCII via web services (columns `YEAR MONTH DAY HOUR MIN SEC GDLAT GLON TEC DTEC`) or HDF5 (`gpsYYMMDDg.00x`); 1°×1° global grid | 5-min bins; files post ~1–3 days after real time | None — identification triple (name/email/affiliation) only; "prior permission to access the data is not required" | VERIFIED twice: site fetched 2026-07-16, and the program's existing Madrigal ingestion client (the same path that graded Study 1's response side) already reads exactly this instrument/kindat, live-verified 2026-07-16 |
| Madrigal line-of-sight TEC, kindat 3505 | https://cedar.openmadrigal.org | HDF5 (`losYYMMDD`, tens of GB/day), per receiver–satellite pair with pierce points | 30-s native GNSS cadence, daily files | None (same triple) | REPORTED (kindat number from program seed + Madrigal convention; site verified, this kindat not individually fetched) |
| Launch Library 2 API (TheSpaceDevs) | https://ll.thespacedevs.com/2.3.0/launches/upcoming/ | JSON REST: `net`, `net_precision`, `status`, `pad.latitude/longitude`, `mission.orbit`, `launch_service_provider` | Continuously updated; poll daily, freeze at T−1h (prod rate-limited; `lldev` mirror for development) | None for read | VERIFIED by live fetch of the lldev development mirror 2026-07-16; prod endpoint REPORTED (same API, rate-limited) |
| GCAT / JSR Launch Vehicle Database | https://planet4589.org/space/gcat/web/launch/index.html | Tab-separated text catalogs + web tables; liftoff UTC to the second where available | Updated ~monthly | None | REPORTED (via search; URL from search result, not individually fetched) |
| Space-Track.org TLE archive | https://www.space-track.org | REST API, JSON/TLE; first post-launch element sets | Hours after orbit insertion | Free registered account | REPORTED (standard, not re-fetched here) |
| GFZ Potsdam Kp index, definitive series | https://kp.gfz-potsdam.de | ASCII/JSON 3-hour Kp values | 3-h values; definitive series posted after month close (nowcast sooner) | None | REPORTED (standard reference archive; not individually fetched) |
| DRAO Penticton F10.7 solar flux (via NOAA SWPC) | https://www.swpc.noaa.gov | Daily observed F10.7 flux values | Daily | None | REPORTED (standard reference archive; not individually fetched) |

Kindat 3500 is the primary grading surface. Kindat 3505 is used only for high-resolution corridor cross-sections on WIN/MISS disputes. Space-Track is secondary — corridor from pad + azimuth alone is sufficient at 1° grid scale. Kp gating reads the GFZ Potsdam definitive series: "Kp at t0" means the definitive 3-hour Kp value covering t0; if the definitive value is not yet posted at grading time, grading waits for it — nowcast Kp never seals a verdict. F10.7 stratification reads the DRAO daily value for the launch date.

---

## The adversary

The adversary mimics magnitude. It cannot mimic shape. That gap is the shear — the same cut the eclipse study made against the Gannon superstorm ([Eclipse 2026 — Model shear](Eclipse-2026-Model-Shear.md)).

**Why it mimics.** Geomagnetic-storm negative phases deplete midlatitude TEC by tens of TECu for hours — the Gannon G5 superstorm (2024-05-10, SSC 17:05 UT, Dst −412 nT, Kp 9) drove −20 to −25 TECu over Europe and daytime depletions exceeding −35 TECu persisting 18 h at 30–50°N. That is deeper and 6–10× longer-lived than any launch hole. Storm LSTIDs and impulsive-event TIDs travel at 300–1000 m/s — the same band as launch shock-acoustic waves (FORMOSAT-5: 629–726 m/s). A TEC dip of 2–70% with wave activity is, pointwise, indistinguishable from a launch signature. Magnitude alone decides nothing here.

**Why shape defeats it.** Three independent locks the adversary cannot fake simultaneously:

1. **Clock.** The hole opens 5–15 min after a to-the-second public epoch chosen by a launch manifest — statistically independent of solar-wind arrival. Epoch-superposing hundreds of launches averages storm noise to zero.
2. **Corridor.** The hole (~900 km) sits ON the published second-stage ground track. Storm depletion is continental and organized by magnetic latitude; natural TIDs move THROUGH the corridor rather than being confined to it. In-corridor vs control-corridor shear ratio ~1 for storms, large for launches.
3. **Recovery.** Falcon-9-class launch holes refill in 1–3 h by plasma diffusion (Saturn-V-class events ran ~4 h); storm negative phases persist 6–24+ h. Kp/Dst gating (windows with Kp ≥ 4 pre-declared VOID) removes the residual tail (disabled for adversary grading per S2, so the adversary is graded on shape, not gated away).

Three named adversary events stand ready for raw grading, exactly as Study 1 graded the Gannon shear:

<details>
<summary><strong>Adversary event roster (grade raw — any detector firing here is a recorded falsifier)</strong></summary>

| Window (UTC) | Event | Why it is the adversary |
|---|---|---|
| 2024-05-10 17:05 (SSC) – 2024-05-12 00:00 | Gannon G5 superstorm (Dst −412 nT, Kp 9) | Strongest storm in two decades; continental-scale depletion mimic (−20 to −25 TECu Europe; >−35 TECu daytime, 18 h at 30–50°N). No corridor confinement, hours-long recovery, clock-locked to the SSC and to no launch epoch. The detector must NOT fire. Citations: ScienceDirect S136468262500272X; arXiv:2511.16384. REPORTED via search. |
| 2022-01-15 04:14 (eruption) – 2022-01-19 08:14 (the ~100 h global propagation interval) | Hunga Tonga–Hunga Haʻapai global TIDs | Largest natural TID event on record: wavelike TEC structures at ~300–350 m/s with 500–1,000 km horizontal wavelengths circling the globe three times over ~100 h (Zhang et al. 2022), plus a ~1000 m/s near-field/LSTID component (Themens et al. 2022, GRL), spectrally overlapping launch SAWs. Tests the traveling-lag discriminant: Tonga waves hold no fixed lag to any launch epoch and cross corridors isotropically. Zhang et al. 2022, Front. Astron. Space Sci., doi:10.3389/fspas.2022.871275; Themens et al. 2022, GRL. REPORTED via search. |
| 2024-04-01 – 2024-05-31 (multiple; burn epoch list — pad, t0, reentry arc — to be extracted from Inchin et al. 2025 into the charter before sealing) | Falcon 9 second-stage deorbit burns over CONUS | The hardest mimic: chemically identical exhaust-driven depletions (Inchin et al. 2025, GRL, doi:10.1029/2024GL112364) occurring ~hours after launch epoch on descending arcs. Defeated only by the clock lock (wrong lag from t0) and corridor lock (reentry arc ≠ ascent track). Catalogued as a known-confounder class, not noise. REPORTED via search. |

</details>

> [!WARNING]
> A recorded failure is a finding. If the sealed detector fires inside an adversary window, that firing is published raw in the ledger. It is never renamed, filtered, or re-baselined away.

---

## The blind spots this study targets

Four gaps in the published record, each verifiable by reading the literature this charter cites:

**Nobody has ever pre-registered a launch hole.** From Mendillo's 1975 Skylab paper through Yasyukevich 2024 and Rajesh 2025, every published result is a post-hoc single-event or few-event case study. Falcon 9 flew 130+ missions per year in 2024–2026; the several-hundred-launch population 2017–2026 has never been epoch-superposed against gridded TEC as a statistical ensemble with frozen-in-advance predictions. This study is that survey.

**The community's own tooling deletes the signal.** Conventional TID climatologies built on band-pass-filtered dTEC are blind to the DC hole by construction; the 2025 MRMIT study of Jiuquan launches (MDPI Remote Sensing 17:3327) detrends TEC to extract TID amplitude and period separately from the depletion (REPORTED via search; full text not fetched). This study grades exactly the thing the filters remove.

**Operational products smear the hole below representation.** IGS global ionosphere maps run at 1–2 h cadence with few-degree spherical-harmonic smoothing; a 900-km, 2–3 h hole vanishes inside that kernel. No GNSS-augmentation threat model flags scheduled launches — despite depletions up to 70% directly over CONUS, on a clock published in advance.

**Existing lag statistics are contaminated in exactly the graded dimension.** Deorbit-burn depletions were only first characterized in 2025 (Inchin et al., GRL, doi:10.1029/2024GL112364). Every earlier hole catalog conflates ascent-burn and reentry-burn signatures — so lag-from-liftoff statistics in the literature are polluted in the one coordinate (clock lag) this study's metric isolates.

---

## The shear metric

The metric is the eclipse study's discriminant pair, transplanted: confinement replaces umbral confinement, the launch clock replaces the umbra's velocity lock.

**Confinement analog — corridor-confinement shear.** Quantized TEC anomaly (against a quiet-day baseline: median of the same UT bin, same cell, on the nearest qualifying days taken in day ±1, ±2, ±3, ±4, ±5 order, where a day qualifies only if it has no launch in the corridor and Kp < 4; if none of the ten candidate days qualifies, the prediction is VOID-by-baseline) *inside* the ±3° corridor around the reconstructed second-stage track, graded against a *control corridor* at the same geomagnetic latitude band displaced 15–30° in longitude at the same UT — displaced toward the denser receiver mesh (eastward over CONUS for Vandenberg, where a westward displacement lands over the receiver-free Pacific; if both displacement directions are oceanic/data-absent, the verdict is VOID-by-control). A launch hole: in-corridor depletion 10–70% with control ~0. A storm negative phase: both corridors depleted equally.

**Traveling-lag analog — clock-locked lag structure.** Two traveling signatures, both keyed to t0: (a) the hole onset propagates along track at vehicle speed (~7 km/s); at that speed the vehicle traverses the entire graded arc inside a single 5-min kindat 3500 bin, so this signature is resolvable only on kindat 3505 30-s data and is descriptive — it is not part of the sealed WIN rule; (b) the SAW ring expands at 600–1000 m/s acoustic speed from the burn arc (FORMOSAT-5: 629–726 m/s). Natural mimics fail the lag test: MSTIDs cross at 100–300 m/s with no fixed lag to t0; Tonga-class Lamb waves at ~330 m/s are locked to the eruption clock, not the launch clock; deorbit burns show the right chemistry at the wrong lag (hours).

**Quantization — exact integers only, per program law.**

- TEC and dTEC stored as integer deci-TECu: deci-TECu = round-half-away-from-zero(TEC × 10), applied once at ingestion and sealed with the Form (Madrigal ASCII columns are floating-point)
- time as integer 5-min bin index from the liftoff epoch (matches kindat 3500 cadence exactly)
- space as integer 1°×1° cell with binary in-corridor flag {0,1}
- depletion depth as integer percent-of-baseline
- shear graded on the integer pair (in-corridor deci-TECu anomaly, control-corridor deci-TECu anomaly), WIN condition: in-corridor anomaly ≤ −X AND control anomaly ≥ −Y for sealed integers X, Y — no division, so a ~0 or data-absent control can never produce an undefined ratio
- onset/recovery graded on bin indices: expected onset bins +1..+3; recovery = in-corridor anomaly ≥ −R percent-of-baseline (sealed integer R) for 2 consecutive bins at or before bin +36 (T+180 min)

No floats anywhere in a sealed verdict. Same inputs, same integers, on any machine.

**Threshold derivation plan — frozen from history, then sealed.**

1. Pull kindat 3500 for N ≥ 100 Falcon 9 launches 2018–2025 (GCAT times × LL2/GCAT pad+azimuth corridors), Kp < 4 windows only.
2. Build the in-corridor depletion-depth distribution at bins +1..+18 (T+5–90 min — the same sealed window the LAW grades) and the matched null distribution from shifted-epoch controls (same pad, same UT hour, day ±1 with no launch) and shifted-corridor controls.
3. Set the WIN threshold table — one integer per (local-time class, F10.7 band) stratum, F10.7 from the DRAO/SWPC archive named above — at the depth where in-corridor exceedance separates from null at a fixed integer false-positive budget (e.g. ≤ 5/100 controls).
4. Validate bracketing as decidable integer inequalities in the sealed unit (percent-of-baseline), each event graded in its own (local-time, F10.7) stratum: pin each event's depth as a sealed integer percent from its cited source (Falcon Heavy 17; FORMOSAT-5 and Starship depths pinned at seal time, Starship's published absolute 10–15 TECu converted to percent against its paper's stated background before sealing), then require FH_depth − d ≤ T_stratum ≤ FH_depth + d for a sealed integer margin d, and T_stratum < FORMOSAT5_depth and T_stratum < Starship_depth. Skylab (1973) predates GNSS TEC and is outside kindat 3500 coverage — it is explicitly exempt from the bracketing check.
5. Seal the threshold table into the standing Form **before** the first pre-registered launch. After sealing, the threshold never moves.

---

## Historical corpus

Five published events anchor the corpus — a half-century arc from the founding observation to the newest depletion class.

| Date (UTC) | Event | Clock | Response | Citation |
|---|---|---|---|---|
| 1973-05-14 | Skylab 1 / Saturn V — founding event of the field | Liftoff 17:30 UTC; rapid electron-content decrease within ~1000 km of the burning S-II stage over the following tens of minutes | Hole spanning ~2000 km (1000 km radius), lasting ~4 h; enhanced recombination from H₂ and H₂O exhaust | Mendillo, Hawkins & Klobuchar (1975), *Science* 187(4174):343, doi:10.1126/science.187.4174.343 — REPORTED via search (science.org + PubMed 17814266) |
| 2017-08-24 | FORMOSAT-5, Falcon 9 (Vandenberg SLC-4E) — largest circular SAW on record + giant hole | Liftoff 18:51 UTC (VERIFIED via Wikipedia); circular shock-acoustic waves from T+5 min, ~20 min duration; hole develops after | SAWs 629–726 m/s, wavelengths 390–450 km, period 10.28 ± 1 min, ~1500 km extent (114–128°W, 26–39°N); hole ~900 km diameter, 10–70% depletion vs reference days; recovery 2.5–3 h | Chou et al. (2018), *Space Weather*, doi:10.1002/2017SW001738 — numbers REPORTED via search (Wiley full text 403 on direct fetch) |
| 2018-02-06 | Falcon Heavy demo (KSC LC-39A) — trajectory-carved hole below F-peak | Liftoff 20:45 UTC (VERIFIED via Wikipedia); hole carved along trajectory ~T+10 min | ~2 TECU depletion, ~17% of ~12 TECU background, persisting >1 h without recovery; small because flight altitude stayed below 200 km | Chou et al. (2018), *GRL*, doi:10.1029/2018GL078088 — REPORTED via search |
| 2023-07-20 | Falcon 9 Starlink Group 6-15 (Vandenberg) — photographed red-glow hole over the US Southwest | Liftoff 04:09 UTC (21:09 PDT July 19); red 630.0 nm glow visible ~20 min from S. California to Arizona | Second-stage burn at 286 km, near the F-region peak; local ionization quenched up to 70%; red airglow from O⁺ recombination triggered by H₂O/CO₂ exhaust | spaceweatherarchive.com 2023-07-23 quoting Jeff Baumgardner (Boston Univ.) — VERIFIED by fetch; launch time REPORTED via space.com/Spaceflight Now search results |
| 2023-11-18 | Starship IFT-2 (Boca Chica) — first non-chemical (explosion-driven) depletion | Liftoff 13:02:50 UTC (VERIFIED via Wikipedia); booster breakup ~T+3.5 min at ~90 km; ship explosion ~T+8 min at ~150 km | −10 to −15 TECU after a +1–4 TECU pulse; depletion persisted 30–40 min in some series; 2000-km V-shaped disturbances propagating northward | Yasyukevich et al. (2024), *GRL*, doi:10.1029/2024GL109284 — REPORTED via search; times VERIFIED via Wikipedia |

The corpus proper is the several-hundred-launch Falcon 9 population 2018–2025 (threshold derivation, step 1 above); these five are the published fixed points the frozen threshold must bracket.

---

## Pre-registration

**Target.** Every upcoming Falcon 9, Falcon Heavy, and Starship launch appearing in Launch Library 2 with `net_precision` at Minute or better. Priority tiers:

1. **Vandenberg** — corridor over the dense CONUS GNSS receiver mesh where kindat 3500 quality is best; both flagship published events (FORMOSAT-5, Starlink 6-15) are Vandenberg.
2. **Starship from Boca Chica** — largest response class (10–15 TECu), lower cadence.
3. **Cape launches** — graded only on the first ~1000 km of track before the corridor goes oceanic and data-sparse.

**Cadence.** Several launches per week — Falcon 9 alone flew 130+ missions/yr in 2024–2026, and the live LL2 feed (VERIFIED 2026-07-16) showed a Falcon 9 at Vandenberg within hours of the fetch. This is the fastest forcing clock of the five shear studies: WIN/MISS grading lands within ~2 days of each launch (Madrigal posting lag), tens of graded predictions per month. Poll LL2 daily; freeze each prediction at T−1h with the then-current `net`; reconcile post-hoc against GCAT's to-the-second liftoff, which then defines bin 0; scrubbed launches are VOID, never MISS.

**Standing law, not per-event forms.** One standing SEALED Form — the launch-hole invariant:

> **LAW.** For every pre-registered epoch t0 (bin 0 = the GCAT liftoff second when available, else the frozen net; a frozen-net-to-actual delta greater than 10 minutes makes the prediction VOID-by-slip) with corridor C and Kp < 4: the quantized in-corridor depletion exceeds the corpus-derived threshold in bins +1..+18 (T+5–90 min), AND recovers — in-corridor anomaly ≥ −R percent-of-baseline (sealed integer R) for 2 consecutive bins at or before bin +36 (T+180 min) — AND both shifted-epoch and shifted-corridor controls stay below threshold. Storm-gated windows (Kp ≥ 4 at t0, per the GFZ definitive 3-hour value covering t0) are pre-declared VOID, not MISS.

Each launch grades the same sealed law again. This is the eclipse-study pattern — pre-registered prediction Form plus watch daemon — reused with a weekly rather than yearly clock. The program's existing Madrigal ingestion path grades the response side unchanged.

---

## Success criteria

All four are decidable — integer verdicts against sealed rules, no judgment calls after sealing.

- **S1 — Threshold frozen from history.** An integer WIN threshold table, keyed by (local-time class, F10.7 band), is derived from ≥ 100 historical Falcon 9 launches (Kp < 4) against shifted-epoch and shifted-corridor nulls at a fixed integer false-positive budget (≤ 5/100 controls), satisfies the per-stratum integer bracketing inequalities of derivation step 4 (Falcon Heavy within sealed margin d of its stratum's threshold; FORMOSAT-5 and Starship strictly clearing theirs; Skylab exempt as archive-unreachable), and is sealed into the standing Form dated **before** the first frozen prediction. Decidable by the seal record's timestamp and the bracketing inequalities.
- **S2 — Adversary graded raw.** The sealed detector — run with the Kp ≥ 4 VOID gate disabled for adversary grading, an override that is itself sealed with the Form (otherwise the storm gate, not shape discrimination, would trivially guarantee zero WINs on Gannon) — produces zero WINs over the enumerated adversary windows: Gannon 2024-05-10 17:05 to 2024-05-12 00:00 UTC; Tonga 2022-01-15 04:14 to 2022-01-19 08:14 UTC (the ~100 h propagation interval); and the CONUS deorbit-burn class, which grades only after the specific burn epoch list (pad, t0, reentry arc) has been extracted from Inchin et al. 2025 into the charter and sealed — until that list is sealed, that window is not gradeable. Any firing is published raw in the ledger as a falsifier. Decidable by the ledger rows.
- **S3 — Prospective predictions sealed and graded.** Every pre-registered launch frozen at T−1h receives exactly one verdict — WIN, MISS, or VOID (scrub, slip, Kp ≥ 4, baseline-absent, control-absent, or data-absent per the sealed VOID rules) — from the sealed law at T+7 days, with the integer anomaly pair (in-corridor and control deci-TECu), depletion depth (integer percent), and onset/recovery bin indices recorded for each. Decidable by the presence and completeness of the ledger row.
- **S4 — Shape separates on the prospective ledger.** After the first N non-VOID graded launches (integer N sealed with the Form, e.g. N = 100): WINs ≥ W (integer W sealed with the Form) while shifted-epoch and shifted-corridor control firings ≤ floor(0.05 × N), and the sealed onset/recovery structure (onset in bins +1..+3, recovery per the sealed R-rule by bin +36) holds on WINs. Otherwise S4 is FAIL and the MISS ledger stands exactly as recorded. Decidable by the same integer counts the threshold was defined on.

## Honest limits

What this study is NOT:

- **Not a TID climatology and not a wave study.** It grades one shape — the clock-locked, corridor-confined, fast-recovering depletion — and deliberately ignores the band-passed wave field the existing literature focuses on.
- **Not a forecast of ionospheric weather.** The study predicts the response to a manifest, not the state of the ionosphere. Kp ≥ 4 windows are VOID by rule, so nothing here speaks to storm-time behavior.
- **Not uniform coverage.** Kindat 3500 exists only where ground receivers exist. Eastward Cape corridors go oceanic within ~1000 km; roughly half the launch population grades on a corridor stub. The Vandenberg tier and kindat 3505 cross-sections mitigate, not cure, this.
- **Not sensitive at the floor.** 1°×1°/5-min gridding plus ~1 TECu DTEC noise puts Falcon-Heavy-class holes (~2 TECu) near the detection floor; low-altitude-insertion profiles (burn < 200 km, below the F region) may be structurally MISS-prone. The threshold-derivation step must decide whether to gate on insertion-profile class or accept a lower per-launch win rate — and that decision seals with the Form.
- **Not immune to trajectory error.** Dogleg and dual-burn missions break azimuth-from-inclination; GTO coast-phase second burns can land the hole 1000+ km downrange of the modeled arc. The ±3° corridor absorbs most, not all, of this.
- **Not immune to clock churn or crowding.** Nets slip by hours routinely (handled by the T−1h freeze + GCAT reconciliation, with slips beyond the sealed 10-minute tolerance VOID-by-slip), but back-to-back same-pad launches and deorbit burns can put a second same-chemistry hole in a graded corridor within the grading window. The multi-event exclusion rule seals here, verbatim: if any other launch or catalogued deorbit burn deposits exhaust inside the graded corridor between bin −36 and bin +36 of t0, the prediction is VOID-by-crowding, never MISS.
- **Not built on an immutable archive.** Madrigal files post 1–3 days late and get reprocessed (`.001` → `.002`); grading runs once against the newest file version present at T+7 days, absence at T+7 days is VOID-by-data, the pinned version is recorded in the ledger row, and later reprocessed versions never regrade a sealed verdict.
- **Not a single-threshold world.** A 70% depletion of a 5-TECu nighttime background is 3.5 TECu; 17% of a 12-TECu daytime background is 2 TECu. Percent and absolute thresholds diverge, so the sealed threshold is an integer table stratified by local-time class and F10.7 band (archive named in the response table, each bracketing event assigned to its stratum by liftoff local time) — a single unstratified number would be systematically wrong for one class.

---

**Status: OPEN — charter published, corpus not yet ingested. Nothing here is sealed until the corpus runs.**
