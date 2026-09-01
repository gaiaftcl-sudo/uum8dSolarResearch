# Study 09 — The Global Convective Bond

**Status: CHARTER SEALED — resolution prospective + retrospective. LIVE CLAIM.**

| Surface | URL / key | Cited vs sealed |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-09-convective.html | sealed POST |
| IDE | https://affine.earth/language-game/ide.html#convective-containment | file template; no auto-POST |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/weather/convective-containment` · MCP `weather.convective_containment` | sealed `PROVEN_CONTAINED` `breach_count=0` cell `SQUARE` |
| Humanity | Traffic-as-probe over radar voids; polar GEO void is named, not painted clear | charter thresholds (`T_cap_max_Jkg=25`) stay **cited** on this page unless the containment receipt names them |

Where the sky is about to break open, and how far ahead that is knowable. Study 09 binds three observing networks into a fourth globe layer on Affine.Earth OS: **aircraft traffic**, **atmosphere**, and **solar heating**. The shear is shape — cap break on a boundary — not raw CAPE magnitude.

Program links: [Shear Studies Index](Shear-Studies-Index.md) · [Shear Studies White Paper](Shear-Studies-White-Paper.md) · [Readers Guide](Shear-Studies-Readers-Guide.md) · OpenUSD ATC live: `/language-game/openusd/`

---

## The forcing and its clock

**The clock.** Solar ephemeris is the exact heating clock already carried by the substrate. Heating cue seals as integer milli-units (`solar_heating_cue_milli`); subsolar longitude as milli-degrees. No floating-point seals.

**The track.** Initiation is a **cap break on a boundary** (shape). Energy magnitude alone is forbidden as a seal discriminant. Frozen thresholds below are the law; they do not move after this charter seal.

**The observing network.** Roughly two-thirds of Earth has no weather radar. Over those voids, **traffic is the observing network** — ADS-B / AMDAR probes stitch the atmosphere where GEO / radar do not. Polar latitudes (|φ| ≥ 65°) are **REFUSED** under GEO imagery — REFUSED is not clear sky.

---

## Frozen integer thresholds

| Symbol | Value | Meaning |
|---|---:|---|
| `T_cap_max_Jkg` | 25 | Cap strength max (J/kg) |
| `T_energy_min_Jkg` | 500 | Minimum convective energy (J/kg) |
| `T_convergence_min` | 500 | Convergence in 10⁻⁷ s⁻¹ units |
| `T_confine_max_km` | 50 | Confinement max (km) |
| `T_window_max_min` | 90 | Nowcast window max (minutes) |
| `T_cooling_max_mK` | −4000 | Cooling max (milli-Kelvin) |
| `T_top_max_mK` | 233150 | Cloud-top max (milli-Kelvin) |
| `T_null_match_ppt` | 100 | Null-match parts-per-thousand |

Companion nulls seal separately. LAW 3: a miss is **CURE** — never renamed to CALORIE.

Swift SoT: `Study09FrozenThresholds` in the shipped substrate.

---

## Lead-dependent render object table

Never draw objects past the predictability horizon. The confidence horizon renders as a **visible surface**.

| Lead band | Objects allowed |
|---|---|
| 0–90 min | Convective **cells** |
| 90 min – 6 h | Meso objects (no cells) |
| 6–48 h | Synoptic packages |
| 48 h – 8 d | Multi-day envelopes |
| **>8 d** | **Synoptic only** |

Zoom → lead mapping (observer distance proxy): `AIRPORT_WALK` → 0–90m cells · `METRO` → meso · `REGIONAL` → 6–48h · `HEMISPHERE` → >8d synoptic only.

---

## Dead-cat removal first

Hierarchical prune. **Never materialize an empty global grid.** Only sparse viewport cells that carry traffic probes, observation voids, solar cues, or the confidence-horizon surface survive into the pack.

---

## Three terminals on the globe

| Terminal | Render cue | Meaning |
|---|---|---|
| **CALORIE** | `BOND_LOCKED` | Constraint satisfied / probe bond |
| **CURE** | `FRACTURE_ACTIVE` | Fracture under heal — never masked |
| **REFUSED** | `OBSERVATION_VOID` | No observation — **not** clear sky |

---

## Data spine

geo imagery · lightning · ECMWF / GFS / ICON · AMDAR · ADS-B · solar.

Polar >65° → GEO **REFUSED**. Full ML initiation forecast is charter-bound; live cells today emit solar cue, traffic-as-probe markers, observation-void REFUSED, and confidence-horizon surface.

---

## Success criteria (S1–S5)

Sealed separately with companion nulls. Prospective events pre-register before response examination; retrospective corpus grades against frozen thresholds without reopening them.

---

## Substrate wiring (live path)

| Surface | Path / subject |
|---|---|
| HTTP pack | `GET /language-invariant/airspace/convective-bond` |
| Embedded in zoom | `uum8d-zoom` → `convective_bond` |
| NATS family | `affine.earth.uum8d.convective.>` |
| Pack subject | `affine.earth.uum8d.convective.bond.pack` |
| OpenUSD layer | fourth globe layer; lead/zoom visibility; void ≠ calm |

Proven marker: `STUDY09_GLOBAL_CONVECTIVE_BOND_PROVEN`.

---

## What is live vs charter-only today

| Capability | State |
|---|---|
| Frozen thresholds + terminals + lead bands | **Live** (Swift constants) |
| Solar heating cue (integer) | **Live** |
| Traffic-as-probe markers | **Live** |
| REFUSED observation void / polar GEO refuse | **Live** |
| Confidence horizon surface | **Live** |
| Full cap-break ML initiation forecast | **Charter-only** (stubbed; layer still paints REFUSED vs calm correctly) |
| Full ECMWF/GFS/ICON / lightning ingest | **Charter spine** — follow-on briefs |

---

> [!WARNING]
> A recorded miss is a CURE. It is never renamed, filtered, or painted as clear sky.
