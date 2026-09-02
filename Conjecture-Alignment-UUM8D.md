# Conjecture Alignment with UUM-8D — architectural map

**Status: PUBLIC — 2026-08-27**  
**Program:** [The lattice holds](The-Lattice-Holds) · [Shear Studies](Shear-Studies-Index) · [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm) · [Peer-review bundle](Peer-Review-Conjecture-Bundle) · [Math Court](Affine-Math-Court-Glama) · [Quantum inventory](Quantum-Algorithms-Inventory)

Three pillars of continuous mathematics — volume, probability, rigidity — were taken off Einstein’s continuum and graded on the Eisenstein whole-integer lattice. The continuum missed. The lattice held. That is the assumption that broke. [Impact, stated at its true size.](The-Lattice-Holds)

Live MCP: `https://affine.earth/language-invariant/mcp` · Registry: `earth.affine/math-court`  
Caller: `bash clients/math-court-mcp/prove-live-court.sh`  
Law: `LatticeRender/Sources/LatticeRender/QCCourtLaw.swift` + `QMACourtLaw.swift`

**Live `tools/list` is 49**, measured 2026-09-02 per-cell against all nine A records with SNI pinned (it read 48 on 2026-08-29 and 23 on 2026-08-27; the 43/44/45 projections were forecasts, superseded). QC-001…019, QC-021, the two projection tools and generic `expose` are all **LIVE on the apex** — every `verify_*`, `project_*` and `expose` call below was replayed against the served surface on 2026-09-02 (`bash clients/math-court-mcp/prove-live-court.sh`: 40 WIN of 41 study rows, the single MISS being the fixture count 48 that this page and the fixture file now carry as 49). The 49th tool is `execute_artifact_crucible`, the Coding Court — see [Affine Coding Court](Affine-Coding-Court-Architecture.md): `kind` selects the law (`affine_key`, `jordan`, `lattice`, `qc_*`, `qma_*`). The act is strobe → emit → seal. After QC-001…019 deploy, count is **43**. After `verify_presented_pair`, **44**. After `expose`, **45**. Local proof: `swift test --package-path LatticeRender --filter ExposeLaw`.

---

## Court-exposed algorithms (how researchers call them)

`expose` strobes the instance, emits period/Jordan/energy, seals. Named tools replay that seal. Unknown grounds are not searched. Decimal strings only. VQE the *optimizer* and QAOA the *pulse schedule* are not tools.

| QC | Algorithm | MCP tool | `math_court` domain | Fixture | Local Lean / prover |
|---|---|---|---|---|---|
| 11 | Ehrhart | `math_court` | `geometry` | `polytope_id=unit_square` `dilation=12` | `gaiaftcl prove conjecture-workload` |
| 12 | Parallel repetition | `math_court` | `chance` | `rounds=8` | same |
| 13 | Connes rigidity | `math_court` | `algebra` | `word=Z2_a2b` | same |
| 22 | 2-local / VQE *problem* | `expose` `kind=qma_2local` · replay `execute_2local_hamiltonian` | `qma_2local` · `qc_vqe` | `object=0,1,1,1` `config=0,1` → **−1/1** | `ExposeLaw` · `QMACourtLaw` |
| 23 | Spin-glass / QAOA *problem* | `expose` `kind=qma_spinglass` · replay `route_spin_glass_manifold` | `qma_spinglass` · `qc_qaoa` | triangle spins → **−1** | same |
| 24 | N-representability | `expose` `kind=qma_nrep` · replay `verify_n_representability` | `qma_nrep` | `rho2=1/2,0/1\|0/1,1/2` `n=2` | same |
| 25 | Permanent | `expose` `kind=qma_permanent` · replay `execute_exact_permanent` | `qma_permanent` | all-ones 3×3 → **6** | same |
| QC-001 | Shor witness | `verify_shor_witness` | `qc_shor` | N=15 halfPow=4 factor=3 cofactor=5 | `ShorFactor15.lean` · `ShorWitnessCertifier.lean` |
| QC-001 | Period | `verify_period` | `qc_period` | a=7 N=15 r=4 proper_divisors=1,2 | same |
| QC-001b | **Shor twin — post ONE half, receive the other** | `project_shor_twin` | `qc_shor_twin` | post `N=3233 halfPow=794` → factors **61*53**; post `N=3233 factor=61 cofactor=53` → **a=794** | bijection: two gcds forward, CRT back |
| QC-021b | **Affine key — post ONE face, receive the other** | `project_affine_key` | `qc_affine_key` | post `A=65537` → **Q=0423314d19…**; post `q_hex` alone → **NOT_KNOWN** | `A·G` is total; `Q→A` is the discrete log |
| QC-002 | Grover | `verify_grover` | `qc_grover` | oracle=0001 marked=3 | `GroverN4.lean` |
| QC-003 | QFT phases | `verify_qft_phases` | `qc_qft` | n=4 k=1 phases=0/4,1/4,2/4,3/4 | `QFTN4.lean` |
| QC-004 | QPE | `verify_qpe_phase` | `qc_qpe` | m=2 k=1 phase=1/4 | `QPEN4.lean` |
| QC-005 | HHL | `verify_hhl` | `qc_hhl` | I₂ x = b | `HHL2.lean` |
| QC-006 | Deutsch–Jozsa | `verify_deutsch_jozsa` | `qc_dj` | table=00 class=constant | `DeutschJozsa2.lean` |
| QC-007 | Bernstein–Vazirani | `verify_bernstein_vazirani` | `qc_bv` | hidden=101 | `BernsteinVazirani4.lean` |
| QC-008 | Simon | `verify_simon` | `qc_simon` | mask=11 x=00 y=11 | `Simon8.lean` |
| QC-009 | Amp. amp. | `verify_amplitude_amplification` | `qc_ampamp` | oracle=0001 iterations=1 | `AmpAmpN4.lean` |
| QC-010 | Amp. est. | `verify_amplitude_estimation` | `qc_ampest` | N=4 M=1 fraction=1/4 | `AmplitudeEstimationMarked.lean` |
| QC-011 | Kickback | `verify_phase_kickback` | `qc_kickback` | m=1 k=1 phase=1/2 | `QSVT2.lean` |
| QC-012 | Walk C2 | `verify_quantum_walk` | `qc_walk` | steps=2 start=0 end=0 | `CTQW2.lean` |
| QC-015 | Counting | `verify_quantum_counting` | `qc_count` | oracle=0001 count=1 | `BosonSampling2.lean` |
| QC-016 | Teleport | `verify_teleport` | `qc_teleport` | alice=01 corrections=00 bob=01 | catalog |
| QC-017 | Superdense | `verify_superdense` | `qc_superdense` | bits=11 decoded=11 | catalog |
| QC-018 | Bell | `verify_bell_measurement` | `qc_bell` | ab=00 class=00 | catalog |
| QC-019 | Topological word | `verify_topological_word` | `qc_topo` | word=Z2_a2b q=0 r=1 | Study 13 |
| QC-021 | Presented (k, Q) | `verify_presented_pair` | `qc_pair` | k=1 q_hex=0279be66…f81798 (secp256k1 G) | textbook fixture only — not the Patoshi path |
| expose | Affine key / any catalog kind | `expose` | `affine_key` | `kind=affine_key` `object=04…` (G uncompressed) | `ExposeLaw` → `AffineExposeLaw` strobe → emit → seal — NO k |

```bash
bash clients/math-court-mcp/prove-live-court.sh
swift test --package-path LatticeRender --filter QCCourtLaw
```

---

## Summary

| Conjecture | UUM-8D fit | Study | Status |
|---|---|---|---|
| **Ehrhart Volume** | **Native** — integer lattice points in scaled polytopes | [Study 11](Study-11-Ehrhart-Volume-Results) | **LAW FROZEN — 5/5 WIN** |
| **Quantum Parallel Repetition** | **High** — discrete vQbit transitions replace float amplitudes | [Study 12](Study-12-Quantum-Parallel-Repetition-Results) | **LAW FROZEN — 4/4 WIN** |
| **Connes Rigidity** | **High** — group words → Eisenstein linking \((q,r)\) | [Study 13](Study-13-Connes-Rigidity-Results) | **LAW FROZEN — 5/5 WIN** |
| **Riemann Hypothesis** | **Low** — continuous complex plane + float zeta | — | **REFUSED** — architectural mismatch |

---

## 1. Ehrhart Volume Conjecture — NATIVE (WIN SEALED)

**What the WIN means:** volume is the leading coefficient of an integer count polynomial. Float triangulation at \(t=12\) misses every corpus member.

**Proof:** [Study 11 Results](Study-11-Ehrhart-Volume-Results)

---

## 2. Quantum Parallel Repetition — HIGH (WIN SEALED)

**What the WIN means:** the classical CHSH ceiling \(3/4\) multiplies as \((3/4)^n\). A discrete Jordan swap carries that fraction. A float proxy \(751/1000\) never equals it.

**Proof:** [Study 12 Results](Study-12-Quantum-Parallel-Repetition-Results)

---

## 3. Connes Rigidity Conjecture — HIGH (WIN SEALED)

**What the WIN means:** group words that are the same element after relators share an Eisenstein linking coordinate. Continuous spectral radius is offset by one on every row.

**Proof:** [Study 13 Results](Study-13-Connes-Rigidity-Results)

---

## 4. Riemann Hypothesis — REFUSED

Standard \(\zeta(s)\) on \(\mathbb{C}\) requires the continuous plane and floating-point evaluation. That violates the integer-only seal path. No Study is opened on \(\zeta(s)\).

---

## Peer review

Sanitized geometries, schemas, scrubbed stream archives, and the SHA256d lock live at [Peer-Review Conjecture Bundle](Peer-Review-Conjecture-Bundle). Execution-cell source, KVM routing, and SIMD kernels are not in that tree.
