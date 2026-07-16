# Satellite & aviation advisory — August 12, 2026

## Why operators should care about the second sky that day

The ionosphere is the error term in every GNSS position fix and the mirror for every HF radio call. On August 12, 2026, over the busiest oceanic corridor on Earth — the **North Atlantic tracks pass directly beneath the eclipse path** — and over Icelandic and Iberian terminal airspace, the second sky will do something it never otherwise does: **change on a schedule known to the second, years in advance.**

- **GNSS users** (aircraft RNP approaches, LEO satellite navigation, precision timing): total electron content along the path will collapse by an expected **31–56% of its quiet value** inside each station's core window below, then recover — with the strongest *horizontal gradients* (the thing that actually stresses single-frequency and differential corrections) in the edge windows on either side.
- **HF communications** (oceanic and polar air traffic control): the shadow lowers the reflecting layers' ionization along the track — a brief, moving, predictable dent in HF propagation over Iceland and the North Atlantic during the core windows.
- **Satellite operators**: the eclipse briefly *cools* the local thermosphere (a transient density dip along the track — the opposite of a storm's drag spike). If a geomagnetic storm lands the same day, the shear discriminant below tells you which regime your anomalies belong to — retrospectively separable in the same public data.

None of this is speculative: the timetable is the sealed geometry this experiment pre-registered 27 days ahead, and the magnitude band is what the same law measured on the 2017, 2023, and 2024 eclipses.

## The timetable (rendered from the sealed geometry)

<!-- GAIA:BEGIN ops-advisory -->
| Station | Disturbance begins (C1) | Edge-in gradients | CORE depletion window | Expected core depletion | Edge-out gradients | Disturbance ends (C4) |
|---|---|---|---|---|---|---|
| cleveland | 17:07:12 UT | — | — (never reaches 80% obscuration) | 0.9%–1.6% (sub-gate, expected undetectable) | — | 18:12:16 UT |
| latrabjarg | 16:43:40 UT | 16:43:40→17:34:40 | 17:34:40–17:56:30 UT | 30.9%–56.0% of quiet TEC | 17:56:30→18:44:55 | 18:44:55 UT |
| reykjavik | 16:47:12 UT | 16:47:12→17:38:02 | 17:38:02–17:59:32 UT | 30.9%–56.0% of quiet TEC | 17:59:32→18:47:38 | 18:47:38 UT |
| millstone | 17:00:46 UT | — | — (never reaches 80% obscuration) | 4.9%–8.9% (sub-gate, expected undetectable) | — | 18:45:02 UT |
| norwich | 17:04:36 UT | — | — (never reaches 80% obscuration) | 4.1%–7.4% (sub-gate, expected undetectable) | — | 18:44:03 UT |
| coruna | 17:30:56 UT | 17:30:56→18:18:26 | 18:18:26–18:38:06 UT | 30.9%–56.0% of quiet TEC | 18:38:06→19:21:59 | 19:21:59 UT |
| leon | 17:32:44 UT | 17:32:44→18:19:34 | 18:19:34–18:38:54 UT | 30.9%–56.0% of quiet TEC | 18:38:54→19:22:06 | 19:22:06 UT |
| zaragoza | 17:34:41 UT | 17:34:41→18:20:21 | 18:20:21–18:39:11 UT | 30.9%–56.0% of quiet TEC | 18:39:11→19:02:30 | 19:02:30 UT |

*Windows derive from the SEALED Besselian geometry (fingerprint-pinned); the expected band is the measured 2017/2023/2024 coupling range (309–560‰ of obscuration). 300-s bin resolution. Generated from `helio_eclipse_circumstances`.*
<!-- GAIA:END ops-advisory -->

**The day at a glance** (all times UT; core = deep-depletion window, sealed geometry):

```mermaid
gantt
    title August 12, 2026 — the second sky's schedule (UT)
    dateFormat HH:mm:ss
    axisFormat %H:%M
    section Látrabjarg
    partial phase          :lat1, 16:43:40, 17:34:40
    CORE depletion         :crit, latc, 17:34:40, 17:56:30
    recovery               :lat2, 17:56:30, 18:44:55
    section Reykjavik
    partial phase          :rey1, 16:47:12, 17:38:02
    CORE depletion         :crit, reyc, 17:38:02, 17:59:32
    recovery               :rey2, 17:59:32, 18:47:38
    section A Coruña
    partial phase          :cor1, 17:30:56, 18:18:26
    CORE depletion         :crit, corc, 18:18:26, 18:38:06
    recovery               :cor2, 18:38:06, 19:21:59
    section León
    partial phase          :leo1, 17:32:44, 18:19:34
    CORE depletion         :crit, leoc, 18:19:34, 18:38:54
    recovery               :leo2, 18:38:54, 19:22:06
    section Zaragoza
    partial phase          :zar1, 17:34:41, 18:20:21
    CORE depletion         :crit, zarc, 18:20:21, 18:39:11
    recovery               :zar2, 18:39:11, 19:02:30
    section Greatest eclipse
    17:45:54 UT            :milestone, ge, 17:45:54, 0s
```

Reading it as an operator:

- **Edge-in / edge-out windows** are where TEC changes fastest in space and time — expect the largest differential-GNSS residuals and the fastest correction updates there, not at maximum.
- **Core windows** are the deep-depletion plateau — absolute TEC (and hence single-frequency range error) is at its minimum; the *change* is slower.
- The two New-England rows carry a **quantified null**: at 13–16% obscuration the effect is bounded below quiet-day variance — a pre-registered "you will NOT see this in your data" claim, which is itself checkable.
- The umbra's ground-track order — Látrabjarg → +192 s → Reykjavik → +2372 s → A Coruña → +53 s → León → +32 s → Zaragoza — is sealed; the depletion minima ride each station's own maximum within the measured lag window.

## The storm question — the part that matters most

> [!WARNING]
> Solar Cycle 25 is at maximum. If SWPC est-Kp reaches **≥ 5** during 15:30–20:00 UT on eclipse day, the pre-registered storm flag raises — the timetable above still holds (a storm cannot move the Moon), and the confinement verdict below remains decidable **through** the storm.

Conventional practice would call a stormy eclipse day's ionospheric data *contaminated* and unusable. This experiment pre-registered the opposite:

- **A storm cannot fake, and cannot hide, the eclipse signature.** The [finished shear](Eclipse-2026-Model-Shear.md) measured both regimes in the same instrument grid: a shadow's depletion is *confined* to its own minutes and *rides its own maximum*; a storm floods the flanking hours as deeply as the window (measured at 665,000–724,000 ppm on May 11, 2024) and pins to window edges. The confinement verdict — excess in-window depletion against a frozen 50,189 ppm threshold — stays **decidable through a G5**.
- **What that gives operators**: if August 12 turns stormy, the same public data separates "the scheduled, geometric dent" from "the storm on top of it." GNSS anomaly forensics that day do not have to throw the eclipse hours away — the two signatures are readable apart. On any *other* storm day, the same shape-read is the reason a deep TEC drop should **not** be attributed to a transient local cause: if the flanks are flooded and nothing rides a track, it is the storm, whole-sky ([Blind spots](Eclipse-2026-Blind-Spots.md), Stories 2–3).
- **Live gate**: the experiment's watch loop reads NOAA SWPC's 1-minute estimated Kp continuously; est-Kp ≥ 5 during 15:30–20:00 UT raises the pre-registered storm flag.

<!-- GAIA:BEGIN live-status -->
- Latest SWPC estimated Kp in ledger: 0.67 at 2026-07-16 20:06:00 UT
- Latest GFZ definitive/nowcast Kp day in ledger: 2024-05-11
- Latest magnetometer capture: BOU H at 2026-07-16 20:04:00 UT

*Ledger-borne (renders identically until the next ingest).*
<!-- GAIA:END live-status -->

## Honest limits — what this advisory is and is not

- It is a **timing-and-shape** product at 300-second, 1° resolution: *when* and *where* the second sky departs from quiet, by *how much* in band, and *what shape* distinguishes shadow from storm.
- It is **not** a scintillation forecast (small-scale phase jitter), **not** a radiation/SEU product, and **not** a thermospheric-density model — those need instruments this experiment does not ingest (yet; the Stage-4 archives — dual-frequency 1 Hz GNSS, Swarm in-situ — are documented in [Data archives](Eclipse-2026-Data-Archives.md)).
- Every number above traces to a sealed Form or a ledger row; the falsification conditions live in the [prediction registry](Eclipse-2026-Prediction-Registry.md). If the sky disagrees on August 12, these tables will say so, publicly, on August 13.

## The larger point for the space-weather community

Storm-time satellite and aviation safety today runs on **indices and baselines** — global scalars (Kp, Dst) and departures from a "normal" that drifts. The [blind-spot record](Eclipse-2026-Blind-Spots.md) shows what that costs: phantom events, erased events, mis-calibrated thresholds across solar cycles. The eclipse is the rare controlled experiment — a forcing with a God-given timetable — that lets the *shape-read* be validated end-to-end in public. Validated once, the same discipline applies to the uncontrolled events operators actually fear: read the structure, not the scalar.
