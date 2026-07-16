# The sealed benchmark — April 8, 2024, verdict CALORIE

Stage 1 of the arc: the substrate ingested the 2024 total-eclipse archive raw and its invariant verified the measured ionospheric response against computed shadow geometry — **at the default pre-registered constants, with zero calibration**. Sealed to V234 as `ECLIPSE_C4_PROJECTION_INVARIANT | CALORIE` on 2026-07-16.

## The verdict (generated live from the corpus)

<details><summary><b>The sealed 2024 verdict — all 28 pairs</b> <i>(click to expand — generated live from the ledger)</i></summary>

<!-- GAIA:BEGIN crucible-benchmark -->
| Pair | Kind | Verdict | Projected (UT) | Depletion | Obscuration |
|---|---|---|---|---|---|
| 2024-04-08-carbondale-eclipse | positive | PROJECTED ✓ | 18:46:29 UT | 274457 ppm (27.4%) | 800534 ppm |
| 2024-04-08-cleveland-eclipse | positive | PROJECTED ✓ | 19:01:31 UT | 353317 ppm (35.3%) | 802627 ppm |
| 2024-04-08-dallas-eclipse | positive | PROJECTED ✓ | 18:45:00 UT | 308350 ppm (30.8%) | 997624 ppm |
| 2024-04-08-indianapolis-eclipse | positive | PROJECTED ✓ | 18:53:22 UT | 286986 ppm (28.7%) | 800050 ppm |
| 2024-04-08-mazatlan-eclipse | positive | PROJECTED ✓ | 18:05:00 UT | 323319 ppm (32.3%) | 970682 ppm |
| 2024-04-08-millstone-eclipse | positive | PROJECTED ✓ | 19:17:05 UT | 419091 ppm (41.9%) | 801464 ppm |
| 2024-04-08-norwich-eclipse | positive | PROJECTED ✓ | 19:17:06 UT | 426439 ppm (42.6%) | 801484 ppm |
| neg-2024-04-08-carbondale-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-carbondale-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-carbondale-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-cleveland-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-cleveland-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-cleveland-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-dallas-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-dallas-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-dallas-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-indianapolis-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-indianapolis-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-indianapolis-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-mazatlan-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-mazatlan-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-mazatlan-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-millstone-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-millstone-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-millstone-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-norwich-ctrl2024-03-12 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-norwich-ctrl2024-04-01 | control-negative | dead cat ✓ | — | — | — |
| neg-2024-04-08-norwich-ctrl2024-04-15 | control-negative | dead cat ✓ | — | — | — |

*The sealed 2024 benchmark scope (eclipse day + quiet controls). Generated live from the corpus through the runner.*
<!-- GAIA:END crucible-benchmark -->

</details>

What the table shows, in words:

- **Seven positives, seven projections.** Every 2024 station-day — five totality-path stations (Mazatlán, Dallas, Carbondale, Indianapolis, Cleveland) plus the two New-England deep partials (Millstone Hill 94.0%, Norwich CT 90.6%) — projected its whole child inside the ≥80% obscuration gate.
- **The projected instants track the Moon's shadow west→east** across the continent, each within minutes of local maximum — consistent with the published bottomside response lag.
- **Depletions of 27–43% of quiet baseline** — inside the published 20–60% band for this eclipse — with the deep-partial New-England stations at the top of the range, matching the regionally-strong 2024 northeast response in the literature.
- **All 21 control negatives sealed dead cat**: the same geometry against the same stations' quiet control days (2024-04-01, 2024-04-15, 2024-03-12; every one max Kp ≤ 3.7), leave-one-out lower-median baselines so no control day is ever judged against itself. Each negative died in ~1,400–1,900 wholesale patch voids with zero leaves sealed — the unimodal prune doing O(1) work.
- **Zero false positives. Zero calibration.** Gate 800,000 ppm and coupling 3/10 were the defaults written before the first crucible run; the physics closed on first presentation.

## Trust chain

1. **Geometry earns trust first:** the Besselian calculator reproduces independently published circumstances — Dallas totality contacts ±3 s, Norwich deep partial ±3 s with obscuration 905,593 ppm vs the published ~90.6% — before anything persists (the fixture gate refuses otherwise).
2. **Raw data with provenance:** one Madrigal world-file scan per day, SHA-256 over the raw bytes, sliced per station locally; all quiet days verified Kp ≤ 4 against GFZ live.
3. **Exact integers from ingest to seal:** milliTECU / ppm / whole seconds; cross-multiplied Int64 law; no floats anywhere on the sealed path.
4. **Determinism:** running the setter twice yields the identical `contentFingerprint`; a fresh process re-verifies the Form from disk with no network and no DB.

## The seals

<!-- GAIA:BEGIN forms-registry -->
| Form | Kind | Class | Closure | Terminal | Fingerprint | Stamped |
|---|---|---|---|---|---|---|
| 2024 benchmark | projection | shadow-projection | 7/7 | CALORIE | `89afd825011f060e` | 2026-07-16T16:01:47Z |
| 2026 prediction | prediction-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `c3e6841a206b8058` | 2026-07-16T16:02:00Z |
| 2026 prediction extensions | prediction-extensions-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `b106d2926b1bf2cf` | 2026-07-16T18:54:39Z |
| historical universality | historical-universality | shadow-projection | 15/16 | CURE | `6fe49bee70289fee` | 2026-07-16T18:14:09Z |

*Loaded and fingerprint-checked from `~/.gaiaftcl/franklin/invariants/` at render time.*
<!-- GAIA:END forms-registry -->

## Reproduction runbook (from a cold machine)

```bash
# 0. build (mutex queue), then geometry with the fixture gate:
~/bin/gaiaftcl-mac-build.sh -c release --product GaiaFTCLCLI
gaiaftcl eclipse-geometry --eclipse 2024-04-08 --all-stations       # fixtures must print GREEN

# 1. raw ingest — eclipse day + three controls (one world-scan each), plus Kp:
for d in 2024-04-08 2024-04-01 2024-04-15 2024-03-12; do
  gaiaftcl helio-ingest kp --day $d
  gaiaftcl helio-ingest madrigal-tec --day $d \
    --stations mazatlan,dallas,carbondale,indianapolis,cleveland,millstone,norwich
done

# 2. corpus (quiet rule checked live) + the crucible + seal + Form:
gaiaftcl eclipse-geometry --eclipse 2024-04-08 --build-fossils
gaiaftcl eclipse-invariant --seal --save                            # exit 0 ⟺ CALORIE

# 3. the SAVE→RELOAD→RE-VERIFY loop from disk only:
gaiaftcl invariant-verify --game eclipse                            # exit 0

# 4. the ledger row:
sqlite3 "$HOME/Library/Application Support/GaiaFTCL/substrate.sqlite" \
  "SELECT game,terminal,stamped_at_iso FROM ruliology_memory_state_changes
   WHERE game LIKE 'ECLIPSE%' ORDER BY stamped_at_iso DESC LIMIT 5"
```

The benchmark scope is pinned: as the fossil corpus grows multi-eclipse (2017, 2023, shear), `invariant-verify --game eclipse` keeps re-proving over exactly the sealed 2024 scope, so the fingerprint above never drifts from corpus growth — the historical runs seal their own separate Form ([Historical corpus](Eclipse-2026-Historical-Corpus.md)).
