# ☀️🌑 Eclipse 2026 — the GaiaFTCL eclipse experiment, documentation only

**This repository is the wiki of one experiment. No code lives here — only the documented surface of it.** Every data table on these pages sits between `GAIA` markers and is **generated from the experiment's own ledger** (`substrate.sqlite`, the fossil corpus, the sealed Forms) by the substrate's renderer — the numbers are the experiment speaking, not prose typed around it.

## The experiment in one paragraph

On **August 12, 2026** a total solar eclipse crosses Iceland and northern Spain (greatest eclipse 17:45:54 UT). The GaiaFTCL substrate treats the eclipse as its third entangled-pair game: **(shadow geometry, ionospheric response)** — the Moon's obscuration timeline, computable to the second from Besselian elements alone, verified against measured ionospheric TEC depletion from public raw archives, by ONE frozen exact-integer law. The 2024 benchmark is sealed (7/7 stations projected, 0 false positives). The 2026 prediction was **sealed 27 days before the eclipse**, fingerprint-pinned and byte-reproducible. The historical corpus (2017 total · 2023 annular · 2024 total · the Gannon G5 superstorm) shows exactly where the law holds, where it strains, and what shears it — recorded raw, CALORIE or CURE, never renamed.

## Read in this order

| Page | What it holds |
|---|---|
| [Overview](Eclipse-2026-Overview.md) | The three staged wins, the doctrine, the sealed Forms |
| [Science research](Eclipse-2026-Science-Research.md) | The 2026 eclipse, measured 2017/2024 ionospheric physics, storms, solar cycle |
| [Historical corpus](Eclipse-2026-Historical-Corpus.md) | Three eclipses, three solar regimes, one frozen law — and the coupling band that bounds 2026 |
| [Model shear](Eclipse-2026-Model-Shear.md) | The storm data that breaks naive detectors — measured, not argued |
| [**Blind spots — five stories**](Eclipse-2026-Blind-Spots.md) | What magnitude models gloss over forever, read from ledger rows |
| [Data archives](Eclipse-2026-Data-Archives.md) | Every public source, verified access mechanics, provenance SHAs |
| [Game 3 architecture](Eclipse-2026-Game-3-Architecture.md) | The substrate implementation of the pair law |
| [Benchmark results](Eclipse-2026-Benchmark-Results.md) | The sealed 2024 verdict + cold-machine reproduction runbook |
| [Prediction registry](Eclipse-2026-Prediction-Registry.md) | The falsifiable 2026 claim, verbatim, with its falsification conditions |
| [**Success criteria**](Eclipse-2026-Success-Criteria.md) | S1–S5 decidable pass/fail, the storm contingency, and why reading the shear changes the game |
| [Operations runbook](Eclipse-2026-Operations-Runbook.md) | Eclipse day in UT, the live loop, the T+1 resolution |

## How this stays true

The generating code lives in the GaiaFTCL substrate repository (not here). After every ingest or crucible run there, `eclipse-wiki-render --wiki-dir <this repo>` regenerates the marked blocks in these pages from the ledger; `--check` exits nonzero if this wiki has drifted from the data. A page's prose frames; the substrate fills in its own numbers.

**Resolves:** 2026-08-13, when the post-eclipse crucible judges the sealed prediction against measured totality-path TEC — and the verdict lands in these tables either way.
