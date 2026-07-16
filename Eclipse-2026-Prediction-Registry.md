# The prediction registry — sealed before the sky moves

On **2026-07-16**, twenty-seven days before the eclipse, the substrate sealed a falsifiable prediction of the August 12 ionospheric response to V234 (`ECLIPSE_2026_PREDICTION_PREREGISTERED`) and to a fingerprint-pinned Form. Nothing about it can change without the fingerprint saying so.

## The sealed claim, verbatim

<!-- GAIA:BEGIN prediction-registry -->
**Sealed pre-registration** (fingerprint `c3e6841a206b8058`, terminal CALORIE, stamped 2026-07-16T16:02:00Z):

```
PREREGISTERED 2026-08-12 shadow-projection (elements fp f9f9f8eebf7ed0cc): reykjavik lat=64146600 lon=-21942600 C1=60432 max=64126 C4=67658 obsmax=1000000 → PROJECT
latrabjarg lat=65502400 lon=-24525400 C1=60220 max=63934 C4=67495 obsmax=1000000 → PROJECT
coruna lat=43362300 lon=-8411500 C1=63056 max=66498 C4=69719 obsmax=1000000 → PROJECT
leon lat=42598700 lon=-5567100 C1=63164 max=66551 C4=69726 obsmax=1000000 → PROJECT
zaragoza lat=41648800 lon=-889100 C1=63281 max=66583 C4=68550 obsmax=1000000 → PROJECT
norwich lat=41524265 lon=-72075910 C1=61476 max=64520 C4=67443 obsmax=132007 → DEADCAT
millstone lat=42623300 lon=-71488200 C1=61246 max=64439 C4=67502 obsmax=158693 → DEADCAT
constants gate=800000ppm coupling=3/10 baseline=lower-median quiet=Kp<=4 bins=300s
resolution=post-eclipse crucible on measured vtec (2026-08-12)
```

*Rendered verbatim from the sealed Form. `invariant-verify --path …/eclipse-prediction-2026-08-12.invariant.json` re-derives this text byte-for-byte from the Besselian elements.*
<!-- GAIA:END prediction-registry -->

In plain terms:

| Station | Role | The claim |
|---|---|---|
| Reykjavik, Látrabjarg (Iceland) · A Coruña, León, Zaragoza (Spain) | totality path (obs = 10⁶ ppm) | each station-day box **MUST PROJECT** a whole child: TEC depletion ≥ 3/10 of obscuration inside its ≥80% gate window |
| Norwich CT (132,007 ppm) · Millstone Hill (158,693 ppm) | declared below-threshold controls | each **MUST SEAL DEAD CAT** — their obscuration can never open the 800,000 ppm gate, by geometry alone |

The law is **inherited, frozen, from the sealed 2024 benchmark** — gate 800,000 ppm, coupling 3/10, lower-median baselines over Kp ≤ 4 control days, 300 s bins. The historical corpus's empirical coupling range ([Historical corpus](Eclipse-2026-Historical-Corpus.md)) is the expectation band; the 300‰ audit line is the pass/fail.

## What falsifies it

1. **Tampering:** any change to the constants, the station roster, the coordinates, or the element set no longer re-derives the pinned text — `invariant-verify --path …/eclipse-prediction-2026-08-12.invariant.json` re-computes the geometry from the Besselian elements and byte-compares. Drift = broken pre-registration, visibly.
2. **Physics:** after the eclipse, a totality-path station with clean data that seals dead cat, or a declared control that projects, seals the resolution **CURE** — recorded raw, never renamed (LAW 3).
3. **Storms:** est Kp ≥ 5 on eclipse day does NOT void the prediction (the geometry side is untouched by a storm) — the resolution still runs; the interpretation carries a storm annotation and the control-channel claims weaken accordingly (pre-registered in [Model shear](Eclipse-2026-Model-Shear.md)).

## The prediction EXTENSIONS — what depletion-magnitude models never publish

Born from the finished shear ([Model shear](Eclipse-2026-Model-Shear.md)): second-generation claims sealed on top of the base prediction —

1. **The traveling signature**: the five totality stations' depletion minima occur in a pinned ORDER with pinned gaps, each deepest bin riding its own station's max-obscuration second within the sealed lag window [−300, +1200] s (the bottomside delay measured −54…+1073 s across 2017/2023/2024) — the umbra's ground track written into the ionosphere.
2. **The confinement claim (storm-proof)**: each totality station's excess in-window depletion clears a frozen threshold derived from the measured historical separation — decidable even if a G-storm hits on eclipse day, because a storm floods the flanks and a shadow cannot.
3. **The quantified nulls**: Norwich CT and Millstone Hill sub-gate depletion bounded numerically by the measured coupling band × their obscuration — a pre-registered undetectability claim.

<!-- GAIA:BEGIN prediction-extensions -->
**Sealed prediction extensions** (fingerprint `b106d2926b1bf2cf`, terminal CALORIE, stamped 2026-07-16T18:54:39Z):

```
PREREGISTERED-EXTENSIONS 2026-08-12 (elements fp f9f9f8eebf7ed0cc): TRAVELING depletion-minimum order latrabjarg@63934 +192s→reykjavik@64126 +2372s→coruna@66498 +53s→leon@66551 +32s→zaragoza@66583 each deepest bin riding its own max-obscuration second within [-300,+1200]s (the bottomside delay measured −54…+1073s across 2017/2023/2024, bin-quantized)
CONFINEMENT excess=window−flank(±7200s) median depletion ≥ threshold=50189ppm at every totality station AND < threshold at norwich+millstone (storm-proof: a storm floods the flanks and pins to window edges, a shadow cannot)
NULLS norwich obsmax=132007 expected-depletion=40790–73923ppm → UNDETECTABLE at 300s bins
millstone obsmax=158693 expected-depletion=49036–88868ppm → UNDETECTABLE at 300s bins
derived-from measured historical coupling 309–560permille
resolution=post-eclipse eclipse-shear analysis on measured 2026-08-12 vtec
```

*Rendered verbatim from the sealed Form; `invariant-verify --path …/eclipse-prediction-extensions-2026-08-12.invariant.json` re-derives it byte-for-byte from the Besselian elements.*
<!-- GAIA:END prediction-extensions -->

## The resolution procedure (T+1, ~2026-08-13)

```bash
# 1. geometry for the 2026 stations is already ledger-stored; ingest the day + controls:
for d in 2026-08-12 2026-08-05 2026-08-19 2026-07-16; do
  gaiaftcl helio-ingest kp --day $d
  gaiaftcl helio-ingest madrigal-tec --day $d \
    --stations reykjavik,latrabjarg,coruna,leon,zaragoza,norwich,millstone
done
# (Madrigal final gridded TEC lands T+1; preliminary may land hours after.)

# 2. fossils for 2026 (quiet rule live), then the crucible against the sealed claim:
gaiaftcl eclipse-geometry --eclipse 2026-08-12 --build-fossils \
  --controls 2026-08-05,2026-08-19,2026-07-16
gaiaftcl eclipse-invariant --historical --seal --save   # the multi-eclipse run now includes 2026

# 3. wiki becomes the readout:
gaiaftcl eclipse-wiki-render
```

The verdict lands in the crucible tables on this wiki the moment the renderer runs — the same tables, the same law, the same fingerprints the world could copy down today.

## Current Form registry

<!-- GAIA:BEGIN forms-registry -->
| Form | Kind | Class | Closure | Terminal | Fingerprint | Stamped |
|---|---|---|---|---|---|---|
| 2024 benchmark | projection | shadow-projection | 7/7 | CALORIE | `89afd825011f060e` | 2026-07-16T16:01:47Z |
| 2026 prediction | prediction-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `c3e6841a206b8058` | 2026-07-16T16:02:00Z |
| 2026 prediction extensions | prediction-extensions-2026-08-12 | shadow-projection | PREREGISTERED | CALORIE | `b106d2926b1bf2cf` | 2026-07-16T18:54:39Z |
| historical universality | historical-universality | shadow-projection | 15/16 | CURE | `6fe49bee70289fee` | 2026-07-16T18:14:09Z |

*Loaded and fingerprint-checked from `~/.gaiaftcl/franklin/invariants/` at render time.*
<!-- GAIA:END forms-registry -->
