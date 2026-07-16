---
title: Eclipse 2026 — operations runbook (eclipse day, live loop, resolution, handoffs)
audience: engineers_and_auditors
game: WIKI-ECLIPSE-2026-009
---

# Operations runbook — August 12, 2026

## The day, in UT

| UT | Event |
|---|---|
| 15:34:11 | First partial contact anywhere (global P1) |
| 16:43:40 | C1 Látrabjarg — the partial phase opens over Iceland |
| 16:58:05 | Totality begins on the path (global) |
| ~17:06 | The umbra crosses near the North Pole (east→west leg) |
| 17:45:34 | **Maximum, Látrabjarg** (totality) |
| **17:45:54** | **Greatest eclipse** — 65°13.5′N 25°13.7′W, 2m18.2s, Sun +25.8° |
| 17:48:46 | **Maximum, Reykjavik** (totality) |
| 17:53:59 / 17:55:20 | Maximum at Millstone (15.9%) / Norwich CT (13.2%) — the control channel |
| 18:28:18 / 18:29:11 / 18:29:43 | **Maximum, A Coruña / León / Zaragoza** (totality, Sun low) |
| 18:34:05 | Totality ends on the path (global) |
| 19:02:30 | C4 Zaragoza — near local sunset |
| 19:57:56 | Last partial contact anywhere (global P4) |

(Station rows are the substrate's own sealed geometry — see the [prediction registry](Eclipse-2026-Prediction-Registry.md).)

## The live loop — `eclipse-watch`

Every pass (default 60 s): **(1)** re-prove the sealed eclipse Form from disk and refuse the pass on drift (LAW 3 live-path governance); **(2)** capture NOAA SWPC 1-minute estimated Kp into the ledger and evaluate the **storm gate** (est Kp ≥ 5 → loud pivot flag; capture continues); **(3)** capture the USGS observatory H series for the current UT day; **(4)** inside 15:34–19:58 UT on the day, log the eclipse-window capture state; otherwise print the countdown.

```bash
gaiaftcl eclipse-watch --once            # single governed pass (smoke test)
gaiaftcl eclipse-watch --poll-seconds 60 # the 24×7 loop
```

Current ledger-borne state:

<!-- GAIA:BEGIN live-status -->
- Latest SWPC estimated Kp in ledger: 0.33 at 2026-07-16 15:59:00 UT
- Latest GFZ definitive/nowcast Kp day in ledger: 2024-05-11
- Latest magnetometer capture: BOU H at 2026-07-16 15:58:00 UT

*Ledger-borne (renders identically until the next ingest).*
<!-- GAIA:END live-status -->

**What the live loop is and is not:** it is the eclipse-day capture and the storm gate. It is **not** the verdict — Madrigal's definitive gridded TEC lands T+1, and the resolution crucible is the judgment. Real-time TEC (NTRIP/GNSS streams) is Stage-4 territory with its own registrations.

## T+1 — the resolution

The exact command chain lives in the [prediction registry](Eclipse-2026-Prediction-Registry.md). Sequence: ingest eclipse day + the three pre-registered control days (2026-08-05, 2026-08-19, 2026-07-16 — each must pass Kp ≤ 4 live or is excluded and reported) → build the 2026 fossils → `eclipse-invariant --historical --seal --save` → `eclipse-wiki-render`. The wiki's crucible tables become the public readout of whether the sealed claim held.

## Standing maintenance (now → eclipse week)

- `eclipse-wiki-render --check` after any ingest: exit 1 = the wiki drifted from the ledger → run the renderer.
- `invariant-verify --game eclipse` and `--path …/eclipse-prediction-2026-08-12.invariant.json` at will — both must exit 0; any drift is a stop-everything signal.
- Optional context captures any day: `helio-ingest kp --day <D>`, `helio-ingest usgs-geomag --day <D>`.

## Handoffs (outside the eclipse lane — stated, not performed)

1. **Daemonizing the live loop:** the plist is staged at `cells/launchd/com.gaiaftcl.franklin.eclipse-watch.plist`; bootstrapping it requires deploying the shared CLI binary to the fleet path — Games-1/2-stream territory. Until then the loop runs manually from the repo build binary.
2. **Publishing this wiki:** `scripts/publish_wiki.sh` pushes to the public GitHub wiki remote — founder's action.
3. **Stage-4 registrations** (Earthdata/CDDIS 1 Hz RINEX, ESA EO/Swarm, SuperMAG, GAGE NTRIP) — founder account signups; none block current operations.
