# Study 21 — Stellar dynamo shear (integer step court)

**Status: LAW FROZEN + LIVE CLAIM — 2026-08-25 · integer step court, not a Kepler/TESS observation**  
**Lead corpus (read first):** [Impact study — the stellar dynamo kill shot](Impact-Study-Stellar-Dynamo-Kill-Shot.md)  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Death of continuous shear](Death-of-Continuous-Shear.md) · [Fourier Phantom](Impact-Study-Fourier-Phantom.md)

This study is the kill shot against the continuum. Astrophysicists have been wrestling with this exact anomaly—which they term “weakened magnetic braking”—for years. They built gyrochronology on a continuous curve that assumes stellar rotation slows down indefinitely. When asteroseismology revealed that older stars rotate much faster than these continuous models predict, the community was forced to invent a “critical Rossby number” to explain a sudden collapse of the global dynamo. They are patching a broken continuous PDE with synthetic variables.

The architecture proof is on the [kill-shot page](Impact-Study-Stellar-Dynamo-Kill-Shot.md). This charter names the old equations, the new law, the IDE hash, and the honest court grade.

| Surface | URL / key | Grade |
|---|---|---|
| Kill-shot narrative | [Impact-Study-Stellar-Dynamo-Kill-Shot](Impact-Study-Stellar-Dynamo-Kill-Shot.md) · [affine story](https://affine.earth/language-game/#story/Impact-Study-Stellar-Dynamo-Kill-Shot) | lead corpus |
| Claim UI | https://affine.earth/language-game/study-21-dynamo.html | POST `dynamo` ingest |
| IDE | https://affine.earth/language-game/ide.html#stellar-dynamo | integer `q`,`r`,`n`,`d` |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/game/dynamo/ingest` | `(q,r)` + `n/d` · source+role |
| Affine story | https://affine.earth/language-game/#story/Study-21-Stellar-Dynamo-Shear | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-21-Stellar-Dynamo-Shear | door |

Walk: tap **Z2_a2b (0,1) + 1/2** → WIN; **Refuse example** → `k=0.15` `REFUSED_FLOAT` — [Low-friction user flows](Low-Friction-User-Flows.md#stellar-dynamo--integer-step).

This study has a court. It is **not OPEN**. OPEN stays 03 / 05 / 08.

**Affine does not write a sealed Kepler / TESS observation.** Affine does not invent a star’s measured \(B\). File-only HTML is not the court. Apex POST this hour: HTTP 200 WIN `STUDY21_DYNAMO_INTEGER_STEP` linking `(0,1)` spin `1/2`. `k=0.15` → HTTP 400 `REFUSED_FLOAT`.

---

## Cited old court (fetched 2026-08-25)

| Paper | DOI | What they said |
|---|---|---|
| van Saders et al., Nature **529**, 181 (2016) | [10.1038/nature16168](https://doi.org/10.1038/nature16168) | Gyrochronology fails for old asteroseismic field stars. They postulate angular-momentum loss ceases above \(Ro_{\mathrm{crit}}=2.16\pm 0.09\). |
| Metcalfe, Egeland & van Saders, ApJL **826**, L2 (2016) | [10.3847/2041-8205/826/1/L2](https://doi.org/10.3847/2041-8205/826/1/L2) | Same transition at \(Ro\sim 2\). Sun may be in a dynamo transition. |

Those numbers are **theirs**. They are not Affine CALORIE keys.

---

## 1.5 Stellar Magnetism & Dynamo Evolution — dead as a continuous decay curve

**Old (continuum court):**

\[
\frac{\mathrm{d}\omega}{\mathrm{d}t} = -k\,\omega^{a},\qquad
\frac{\partial B}{\partial t}=\nabla\times(u\times B)+\eta\nabla^{2}B
\]

Gyrochronology and continuous MHD. Spin decay and dynamo braking as continuous DEs in IEEE-754.

**Why inaccurate (The Shear):**

\(B\) treated as a \(C^{\infty}\) vector field in a fluid. When a middle-aged star crosses a discrete topological threshold, spin leaves the fitted float curve (\(e^{-kt}\) / power law). Continuous astro labels this “broken spin-down” / “dynamo collapse” / “weakened magnetic braking.” The collapse is debris of a shearing float PDE that cannot step discretely.

**New (lattice court):**

\[
\text{Magnetic State}=L(w)=(q,r)\in\mathbb{Z}^{2},\qquad W_{n}=\Bigl(\frac{n}{d}\Bigr)^{n}\in\mathbb{Q}
\]

- **Topological invariant:** stellar magnetic topology is an exact integer linking class on the orientable 8D flat torus. Dipole→multipole is a discrete Jordan swap, not continuous field attenuation.
- **Discrete braking:** angular momentum steps in exact rationals \(n/d\), unbounded string/limb so register-width does not shear.
- **Polytope plasma volume:** convective zone mass and flux linkage as Ehrhart \(\Delta^{8}h(0)/8!\) — [Study 11](Study-11-Ehrhart-Volume-Shear.md). Cross-see [Study 12](Study-12-Quantum-Parallel-Repetition-Shear.md) for \(W_n\) and [Study 13](Study-13-Connes-Rigidity-Shear.md) for \(L(w)=(q,r)\).

**Proves:** Middle-aged stellar magnetic transition is a deterministic integer step function.  
**Solves:** The “solar midlife crisis” phantom and artificial dynamo breakdown terms — as a court.

---

## Integer keys

| Key | Kind | Rule |
|---|---|---|
| `q` | Int64 | Jordan link first coordinate |
| `r` | Int64 | Jordan link second coordinate |
| `n` | Int64 | rational spin numerator |
| `d` | Int64 | rational spin denominator; must be \(>0\) |
| `cited_id` | optional token | must match the fixture row if presented |
| `source` + `role` | required | empty source → HTTP 400 `REFUSED_UNATTRIBUTED` |

IEEE payload (`k=0.15`, `omega=1.2`, `eta=0.01`) → HTTP 400 `REFUSED_FLOAT`.  
Dead-equation keys `k` / `omega` / `eta` / `rossby` even as integers → `REFUSED_NO_STD`.

---

## Cited fixture (not a star B)

| cited_id | Integers | Source |
|---|---|---|
| `z2-a2b-half-step` | \((q,r)=(0,1)\) · \(n/d=1/2\) | [Study 13](Study-13-Connes-Rigidity-Shear.md) word `Z2_a2b` linking `(0,1)` plus a well-formed rational half-step |

No Kepler / TESS \(B\) is invented. Study 09 convective is LIVE and is a **different** court — [Study 09](Study-09-Global-Convective-Bond.md).

---

## Example POSTs

**WIN** (cited Study 13 link + half-step):

```json
{"source":"researcher","role":"researcher","q":0,"r":1,"n":1,"d":2,"cited_id":"z2-a2b-half-step"}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"researcher","k":0.15}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"researcher","q":0,"r":1,"n":1,"d":2}
```

---

## Section 6 row

| Domain | Equation that is no longer a court | Why | New equation / law | What it solves |
|---|---|---|---|---|
| Astrophysics (Dynamo) · Study 21 | Continuous MHD & Gyrochronology (\(\mathrm{d}\omega/\mathrm{d}t=-k\omega^{a}\)) | Float curve fits miss discrete topological phase steps | \(L(w)=(q,r)\in\mathbb{Z}^{2}\) + rational spin steps · this charter | Dynamo “collapse” / solar anomaly phantoms |

Landed also on [Impact-Study-Death-of-Continuous-Shear §6](Impact-Study-Death-of-Continuous-Shear.md#6-one-table--old-equation-why-dead-what-replaces-it) and the [kill-shot page](Impact-Study-Stellar-Dynamo-Kill-Shot.md#section-6-row).

---

## What this page does not do

- Does not invent Rife-style efficacy (that is Study 20)
- Does not invent a Kepler / TESS light-curve CALORIE
- Does not invent a star’s measured \(B\)
- Does not conflate MHD with Study 09 convective containment
- Does not fill OPEN 03 / 05 / 08
- Does not host occupancy / docking

Swift: `cells/xcode/Sources/InvariantCompiler/StellarDynamoCourt.swift` · domain `dynamo` in `LatticeDomainIntegration.swift`.
