---
title: Eclipse 2026 — success criteria (and why reading the shear changes the game)
audience: engineers_and_auditors
game: WIKI-ECLIPSE-2026-010
---

# Success criteria — what "the study succeeded" means, decidably

Every criterion below is pinned to a sealed, fingerprint-checked Form and decided by the T+1 resolution on measured public data. Nothing here is judged by narrative; each tier passes or fails in the same rendered tables the world can read now.

## Tier 0 — Pre-registration integrity *(testable every day; already green)*

All Forms re-verify from disk, and both prediction Forms re-derive **byte-for-byte** from the NASA Besselian elements. Any drift before August 12 — constants, roster, coordinates, elements — falsifies the pre-registration itself. This is the criterion that gives the others their meaning.

<!-- GAIA:BEGIN forms-registry -->
| Form | Kind | Class | Closure | Terminal | Fingerprint | Stamped |
|---|---|---|---|---|---|---|
| 2024 benchmark | projection | shadow-projection | 7/7 | CALORIE | `89afd825011f060e` | 2026-07-16T16:01:47Z |
| 2026 prediction | prediction-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `c3e6841a206b8058` | 2026-07-16T16:02:00Z |
| 2026 prediction extensions | prediction-extensions-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `b106d2926b1bf2cf` | 2026-07-16T18:54:39Z |
| historical universality | historical-universality | shadow-projection | 15/16 | CURE | `6fe49bee70289fee` | 2026-07-16T18:14:09Z |

*Loaded and fingerprint-checked from `~/.gaiaftcl/franklin/invariants/` at render time.*
<!-- GAIA:END forms-registry -->

## Tier 1 — The base prediction (Form `c3e6841a206b8058`)

| ID | Criterion | Decided by |
|---|---|---|
| **S1** | All five totality stations — Reykjavik, Látrabjarg, A Coruña, León, Zaragoza — **PROJECT** under the frozen law: depletion ≥ 300‰ of obscuration inside their ≥80% gate windows | T+1 crucible on measured vTEC |
| **S2** | Both declared controls — Norwich CT (13.2%), Millstone Hill (15.9%) — **seal dead cat** (their gate can never open, by geometry alone) | same crucible |

CALORIE iff **5/5 projections and 0 false positives**.

## Tier 2 — The shear-born extensions (Form `b106d2926b1bf2cf`)

The criteria no depletion-magnitude model even states:

| ID | Criterion | Decided by |
|---|---|---|
| **S3** — traveling signature | Depletion minima in the pinned order **Látrabjarg → +192 s → Reykjavik → +2372 s → A Coruña → +53 s → León → +32 s → Zaragoza**, each deepest bin riding its own max-obscuration second within [−300, +1200] s | `eclipse-shear` on measured 2026 vTEC |
| **S4** — confinement (storm-proof) | Excess in-window depletion (gate-window median − ±2 h flank median) **≥ 50,189 ppm** at every totality station, **< 50,189 ppm** at both controls | same analysis |
| **S5** — quantified nulls | No gate-scale signature at the controls, with pre-stated sub-threshold expectations: Norwich 40,790–73,923 ppm · Millstone 49,036–88,868 ppm (below quiet variance at 300-s bins) | same analysis |

## Tier 3 — Cross-regime universality *(reported, not sealed)*

The 2026 couplings land inside the measured historical band **309–560‰** — extending the one-frozen-law result from three eclipses and a full solar cycle (2017 SC24-declining · 2023 annular · 2024 SC25-max) to a fourth eclipse and the hardest geometry transfer: high latitude, +25.8° Sun, near sunset over Europe.

## The storm contingency (pre-registered)

If SWPC est-Kp ≥ 5 during 15:30–20:00 UT on eclipse day: **S1–S4 remain decidable** — that is exactly what the shear bought — while S5 weakens with a storm annotation. A G-storm cannot un-total an eclipse, and it cannot fake confinement.

## Failure semantics (LAW 3)

Any miss seals **CURE**, raw, in these same tables — never renamed. A high-latitude coupling break or a lag-window violation would itself be a finding of the study, published identically to a pass.

---

# Why reading the shear changes the game

## 1. From magnitude to signature

Every conventional eclipse-ionosphere result is a scalar claim — *"TEC dropped 20–60%"* — and the Gannon corpus **proves scalars are forgeable**: May 11, 2024 reproduced eclipse-grade depletions at all seven benchmark stations with zero shadow anywhere, and the frozen magnitude law false-positived 7/7 ([Model shear](Eclipse-2026-Model-Shear.md)). Reading the shear replaced *how much* with *what shape*: confined to the gate minutes, riding each station's own maximum with the measured bottomside lag. A storm can fake the amount. Only the Moon writes the shape.

## 2. Storm-immune eclipse science

The worst operational risk of any solar-max eclipse campaign is a coincident geomagnetic storm — historically, that day's data is discarded as contaminated. The confinement discriminant stays decidable **through** a G5: a storm floods the ±2 h flanks (measured at 665,000–724,000 ppm on May 11) and pins its minima to window edges; a shadow cannot do either. At SC25 maximum, the elevated storm probability flips from study-killer to strongest possible test — **S4 passing through a storm would be the headline result**.

## 3. The failures became the instrument

Standard practice filters model failures out as bad data. This study ingested them **on purpose**, measured exactly how they fail — flank flooding, edge-pinned minima, no lag relation to the geometry — and that failure structure *became* the second-generation discriminant, then a sealed falsifiable prediction 27 days ahead. Data sheared of the models revealed what the models could not have imagined; the recorded CURE taught the next CALORIE.

## 4. A general template

Wherever a computable forcing meets a noisy medium, the same read applies: pair the forcing's own timetable with the response, demand confinement + traveling coherence against that timetable, and use the adversarial corpus (the "storms" of that domain) as the shear. Launch- and eruption-driven TIDs, flare-vs-storm thermospheric response, any detector whose adversary mimics magnitude but not structure. And if S3+S4 hold on August 12, the ionosphere will have been shown to carry a readable, per-second copy of the umbra's ground track that survives storm contamination — the Moon as a calibrated signal generator, photochemistry separated from electrodynamics at 300-second resolution, from public raw data on one machine.
