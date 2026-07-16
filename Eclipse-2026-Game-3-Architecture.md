---
title: Eclipse 2026 — Game 3 architecture (the substrate implementation)
audience: engineers_and_auditors
game: WIKI-ECLIPSE-2026-006
---

# Game 3 architecture — how the shadow became a substrate game

## The born pair

**(shadow geometry, ionospheric response).** The parent owns exactly ONE binding shape Σ_P — the genes-only parent disk shared byte-identically by all three games. The two sides of the pair:

- **Target descriptor (H1 — geometry ONLY):** the quantized obscuration timeline — NASA Besselian element polynomials + station coordinates, computed by the Explanatory-Supplement local-circumstance algorithm, quantized ONCE (obscuration in ppm on a 10-s lattice, contacts in whole seconds UT), stored, fingerprinted. The measured data never touches this side.
- **Measured side (the box contents):** the station-day's vertical-TEC series, quantized ONCE to milliTECU integers, binned per 300 s (Madrigal's native cadence), with a baseline vector built by the pre-registered rule: element-wise **lower median** over named quiet control days (max Kp ≤ 4) — an order statistic, never an average, so the arithmetic is integer-exact on every machine.

## The pair law (exact integers, no division)

A width-1 leaf — one UT second *t* — audits iff:

```
obscuration(t) ≥ 800000 ppm          (the gate)
AND  10 · 10⁶ · (B − M)  ≥  3 · obs(t) · B     (the coupling, cross-multiplied Int64)
```

i.e. the TEC depletion fraction must reach 3/10 of the obscured disk fraction, evaluated only where the geometry says ≥80% of the Sun is covered. Absent bins (−1) never audit; a fake zero cannot exist. The constants live in the sealed Form's `decisionPredicate` text, so the `contentFingerprint` pins them — moving them after a seal is a visible falsification, not a tweak.

## The real topological prune (what SHA never gives)

The obscuration timeline is **unimodal**: one shadow cone → one contiguous gate window `[gateLo, gateHi)` per station-day, derived at construction from the timeline alone. `regionLinks(patch:)` therefore has a genuine wholesale exclusion:

- patch ∩ gate window = ∅ → **the whole patch is a proven void** — every leaf's C⁴ face is not-whole, its clasp lifts clear of z=0, lk = 0 — ARC frees it in O(1), never split;
- straddling wide patch → subdivide (8-way octant work decomposition);
- width-1 leaf → the audited pair law, then `DeadCatRemoval.isEntangled` on the leaf's M⁸ face — the same uniform verdict Games 1 and 2 route through.

Measured behavior: a negative station-day dies in ~1,400–1,900 wholesale voids with **zero leaves sealed**; a positive seals exactly **one** leaf — the whole child that threads Σ_P. Mining, by contrast, is one-sided containment only (SHA avalanche exposes no exclusion from a boundary). The eclipse is the substrate's first `shadow-projection`-class invariant.

## The M⁸ face

`pointForEclipseSecond` builds one M⁸ point per (geometry, response) cell: S⁴ position = SHA-256 limbs over the pair's own coordinates (station | eclipse | t | measured | baseline) — distinct per surviving leaf; all four C⁴ axes sit at their preserved position iff the pair law holds (`c1 1/1 · c2 1/1 · c3 1/1 · c4 256/256`), governing axes `[c1Reconvergence, c2Boundary]` — photoionization reconvergence under the shadow boundary. Identical face shape to the p2pk and mining predicates, so dead-cat removal reads all three games uniformly.

## The box

One lane, `laneExtentBits: [17]` — 2¹⁷ = 131,072 ≥ 86,400 UT seconds of day; leaves ≥ 86,400 are out-of-box dead. The descent is `TheoreticalBox` → `C4Patch` octants → leaf, driven by `EclipseProjectionRunner.project` (stats: leaves sealed, patches voided, max depth, ns).

## The Form ledger (SAVE → RELOAD → RE-VERIFY)

<!-- GAIA:BEGIN forms-registry -->
| Form | Kind | Class | Closure | Terminal | Fingerprint | Stamped |
|---|---|---|---|---|---|---|
| 2024 benchmark | projection | shadow-projection | 7/7 | CALORIE | `89afd825011f060e` | 2026-07-16T16:01:47Z |
| 2026 prediction | prediction-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `c3e6841a206b8058` | 2026-07-16T16:02:00Z |
| 2026 prediction extensions | prediction-extensions-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `b106d2926b1bf2cf` | 2026-07-16T18:54:39Z |
| historical universality | historical-universality | shadow-projection | 15/16 | CURE | `6fe49bee70289fee` | 2026-07-16T18:14:09Z |

*Loaded and fingerprint-checked from `~/.gaiaftcl/franklin/invariants/` at render time.*
<!-- GAIA:END forms-registry -->

Three Forms, three scopes, one law:

| Form | Corpus scope | Re-verify re-runs |
|---|---|---|
| `projection` (2024 benchmark) | 2024 eclipse-day + quiet controls ONLY (fp-stable as the corpus grows) | the full crucible over that scope |
| `prediction-2026-08-12` | none yet — geometry + constants pinned | byte-exact re-derivation of the pinned text from the elements |
| `historical-universality` | EVERYTHING — all eclipses + shear negatives | the grouped multi-eclipse crucible |

Every Form carries the Wittgenstein C⁴ tuple `{1/1|1/1|1/1|256/256|c1Reconvergence}`, class `shadow-projection`, and a content fingerprint over every semantics-bearing field. Live surfaces (`eclipse-watch`) re-prove the benchmark Form **every pass** and refuse on drift (LAW 3).

## File map

| Piece | Path |
|---|---|
| Besselian elements (4 eclipses, embedded verbatim) | `Sources/HeliosphereIngest/BesselianElements.swift` |
| Circumstance calculator + quantized timeline | `Sources/HeliosphereIngest/EclipseCircumstanceCalculator.swift` |
| Published-circumstance fixtures (trust gate) | `Sources/HeliosphereIngest/EclipseGeometryFixtures.swift` |
| Madrigal / GFZ / USGS / SWPC clients | `Sources/HeliosphereIngest/MadrigalClient.swift`, `GeomagIndicesClient.swift` |
| The single float→int crossing | `Sources/HeliosphereIngest/IngestQuantizer.swift` |
| Ledger store (V252 tables) | `Sources/HeliosphereIngest/HeliosphereStore.swift`, `Sources/GaiaFTCLCore/HeliosphereSchemaV252.swift` |
| Fossil corpus (multi-eclipse + shear) | `Sources/HeliosphereIngest/EclipseFossilCorpus.swift` |
| The predicate (RegionInvariant) | `Sources/InvariantCompiler/EclipseCollapsePredicate.swift` |
| The projection runner | `Sources/InvariantCompiler/EclipseProjectionRunner.swift` |
| CLI verbs | `Sources/GaiaFTCLCLI/Commands/HelioIngestCommand.swift`, `EclipseGeometryCommand.swift`, `EclipseInvariantCommand.swift`, `EclipseWatchCommand.swift`, `EclipseWikiRenderCommand.swift` |
| Verify/boot seam | `Sources/GaiaFTCLCLI/Commands/InvariantVerifyCommand.swift` (`--game eclipse`) |
| Live-loop plist (staged) | `cells/launchd/com.gaiaftcl.franklin.eclipse-watch.plist` |

## Constraint compliance

| Constraint / LAW | How Game 3 satisfies it |
|---|---|
| C1 bond ≤ 4096 | 17-bit single-lane box; descent depth ≤ 17 |
| C3 no FP in sealed proofs | quantize-once discipline; the sealed path is Int64/BigInt only; zero REAL columns in V252 |
| C4 no stubs | every path computes or refuses with the reason; absent data stays absent |
| C5 deterministic verify | order statistics not averages; FNV/SHA fingerprints; fossils jsonl is the canonical artifact (no re-run trig on the verify path) |
| C6 reversibility | append-only ledger rows; Forms replaced only by re-SET, never edited |
| LAW 3 no symptom-masking | falsifiers recorded raw; CURE never renamed; shear false-positives (if any) published |
| LAW 4/9 no classical search | the descent is patch subdivision + wholesale voids; the only "loop" over data is ingest-side quantization of a continuous lattice |

## The entanglement with this wiki

Every data table on these pages sits inside `<!-- GAIA:BEGIN … -->` markers and is regenerated by `gaiaftcl eclipse-wiki-render` straight from `substrate.sqlite`, the fossil corpus, and the sealed Forms — deterministic ordering, idempotent (a second run with an unchanged ledger produces a byte-identical wiki), with `--check` as the drift gate. The prose is authored; the numbers are the substrate's own.
