# Quantum algorithms inventory — what lives where

**Status: MEASURED 2026-08-27 from live HTTP + this git.**  
**Not a capability brochure.** A row is live on Glama only if the live `tools/list` names it. Mentions in `QuantumShearMap` are literature, not court tools.

If it is on affine.earth MCP, it is available. Live `tools/list` is the live list. QC-001…019 plus QC-021 are **wired**. Generic ingest `expose` is **wired** (`ExposeLaw`): `kind` selects the law. The act is strobe → emit → seal. Live list 2026-08-27 is still **23**. After QC-001…019 deploy it is **43**. After `verify_presented_pair`, **44**. After `expose`, **45**. `vmNotConnected` catalog bodies are not the court.

Canonical sources:

| Surface | Path |
|---|---|
| Public MCP (`tools/list`) | Live: `POST https://affine.earth/language-invariant/mcp` · evidence `clients/math-court-mcp/evidence/tools-list-20260827T194820Z.raw` · **count 23** (pre-roll) · HTTP 200 edge `nbg-01` · in-repo live mirror `cells/xcode/Resources/language-game/mcp-tools.json` · wired QC law `LatticeRender/Sources/LatticeRender/QCCourtLaw.swift` |
| Registry | `docs/mcp/server.json` · `earth.affine/math-court` |
| Served names | `CapabilityRegistry.servableEntries` in `cells/xcode/Sources/InvariantCompiler/CapabilityRegistry.swift` |
| Typed QC-001…019 shells | `cells/xcode/Sources/VQbitMath/Algorithms/AlgorithmCatalog.swift` |
| Literature shear map | `cells/xcode/Sources/InvariantCompiler/QuantumShearMap.swift` |
| QMA court law | `LatticeRender/Sources/LatticeRender/QMACourtLaw.swift` |
| Lean gates | [Research Lean gates](Research-Lean-Gates.md) · `proof/lean/FirstRoars/` |
| Public court | [Math Court on Glama](Affine-Math-Court-Glama.md) |

`AlgorithmCatalog.swift` bodies still throw `VQbitError.vmNotConnected`. That is **typed surface**, not the court. The court is `ExposeLaw` — strobe → emit → seal. Named `QCCourtLaw` / `QMACourtLaw` tools replay a sealed emit.

---

## ON GLAMA — live 49 (measured 2026-09-02, per cell on all nine); every QC verifier below is LIVE

Four QMA studies plus `math_court` domains. The primary act is `expose` (strobe → emit → seal). Named verifiers replay a sealed emit. An unknown ground state is **not searched**.

Researcher proof (hits the live HTTPS MCP, writes evidence, exits 2 on drift):

```bash
bash clients/math-court-mcp/prove-live-court.sh
```

Fixtures: `clients/math-court-mcp/fixtures/live-court-studies.json`.

| QC / literature name | Wiki study | Live Glama tool (2026-09-02) | Also live | `math_court` domain | Law |
|---|---|---|---|---|---|
| 2-local Hamiltonian (VQE's *problem*, not VQE's search) | [Study 22](Study-22-QMA-2-Local-Hamiltonian.md) | `execute_2local_hamiltonian` | same + `verify_vqe_energy` | `qma_2local` · `qc_vqe` | `QMACourtLaw.twoLocal` · `QCCourtLaw.vqeEnergy` |
| Spin-glass / frustrated Ising | [Study 23](Study-23-QMA-Spin-Glass.md) | `route_spin_glass_manifold` | same + `verify_qaoa_energy` | `qma_spinglass` · `qc_qaoa` | `QMACourtLaw.spinGlass` · `QCCourtLaw.qaoaEnergy` |
| N-representability (2-RDM) | [Study 24](Study-24-QMA-N-Representability.md) | `verify_n_representability` | same | `qma_nrep` | `QMACourtLaw.nRepresentability` |
| Exact integer permanent \(n\le 3\) | [Study 25](Study-25-Exact-Permanent.md) | `execute_exact_permanent` | same | `qma_permanent` | `QMACourtLaw.exactPermanent` |
| Shor witness / period | [alignment](Conjecture-Alignment-UUM8D.md) | `verify_shor_witness` · `verify_period` | `project_shor_twin` (post one half, receive the other) | `qc_shor` · `qc_period` | `QCCourtLaw.shorWitness` / `period` |
| Grover / QFT / QPE / HHL / DJ / BV / Simon / amp / walk / count / teleport / topo | same | 16 named `verify_*` tools | — | `qc_grover` … `qc_topo` | `QCCourtLaw` |
| Presented (k, Q) | same | `verify_presented_pair` | `project_affine_key` (A → Q; Q alone answers CHI_EXHAUSTED) | `qc_pair` | textbook k=1 → G only — not the Patoshi path |
| Affine key (Q-only) | same | `expose` | — | `affine_key` | `ExposeLaw` → `AffineExposeLaw` — object is `04…`; strobe → emit → seal; no k |

Same fixtures accept empty-body `math_court` (catalog) then domain ingest. Miner verbs (`mine`, `isolate`, `sha256d`, `submitblock`, `nphard`) are **unproven** and stay off `tools/list`.

---

## COURT VERIFIERS — LIVE on the apex since the 2026-08-29 roll; Lean stays the textbook

Call names and fixtures: [Conjecture Alignment](Conjecture-Alignment-UUM8D.md). Local prove: `swift test --package-path LatticeRender --filter ExposeLaw`.

| Name | QC id | Court tool | Lean / substrate (unchanged) |
|---|---|---|---|
| Shor factoring witness | QC-001 | `verify_shor_witness` | `ShorFactor15.lean` · `ShorWitnessCertifier.lean` · [Lion-Shor](Lion-Shor-Witness-Certifier.md) |
| Period (presented r) | QC-001 | `verify_period` | same — does not search r |
| Shor ECDLP | QC-001-ECDLP | **not a court tool** | `ShorECDLPSubstrate/` · Lean `ShorECDLP.lean` — Depth-0 wall stays *not known* |
| Grover | QC-002 | `verify_grover` | `GroverN4.lean` |
| QFT | QC-003 | `verify_qft_phases` | `QFTN4.lean` |
| QPE | QC-004 | `verify_qpe_phase` | `QPEN4.lean` |
| HHL | QC-005 | `verify_hhl` | `HHL2.lean` |
| Deutsch–Jozsa | QC-006 | `verify_deutsch_jozsa` | `DeutschJozsa2.lean` |
| Bernstein–Vazirani | QC-007 | `verify_bernstein_vazirani` | `BernsteinVazirani4.lean` |
| Simon | QC-008 | `verify_simon` | `Simon8.lean` |
| Amplitude amplification | QC-009 | `verify_amplitude_amplification` | `AmpAmpN4.lean` |
| Amplitude estimation | QC-010 | `verify_amplitude_estimation` | `AmplitudeEstimationMarked.lean` |
| Phase kickback / QSVT | QC-011 | `verify_phase_kickback` | `QSVT2.lean` |
| Quantum walk | QC-012 | `verify_quantum_walk` | `CTQW2.lean` |
| VQE energy (not search) | QC-013 | `verify_vqe_energy` | `VQE2.lean` — same ZZ as Study 22 |
| QAOA energy (not pulses) | QC-014 | `verify_qaoa_energy` | `QAOA1.lean` — same Ising as Study 23 |
| Quantum counting | QC-015 | `verify_quantum_counting` | `BosonSampling2.lean` (catalog map) |
| Teleport | QC-016 | `verify_teleport` | catalog |
| Superdense | QC-017 | `verify_superdense` | catalog |
| Bell measurement | QC-018 | `verify_bell_measurement` | catalog |
| Topological word | QC-019 | `verify_topological_word` | Study 13 Eisenstein |
| BTC preimage / PoW | QC-020 | **not a court tool** | `gaiaftcl prove qc020-verifier` |
| Presented (k, Q) | QC-021 | `verify_presented_pair` | sealed k=1 → secp256k1 G; does not derive k |
| Affine key | expose | `expose` | `kind=affine_key` `object=04…` — Q-only strobe → emit → seal; no k |
| Stabilizer tableau | — | **ABSENT debt** | `twin.quantum.stabilizer_tableau` never served |

`QuantumShearMap` also lists Hamiltonian simulation, QSP/QSVT, adiabatic/annealing, boson sampling, AJL/Jones. Those are **literature dispositions**. They are not MCP tools.

---

## Stripped / leftover surfaces (do not resurrect as “live MCP”)

| What | Commit | What remains |
|---|---|---|
| Dead Shor quantum-circuit cluster (reversible oracle, symbolic Shor, projection) | `6f39e8b8950256e090d68a31657e086989663874` (2026-07-09) | `ShorECDLPSubstrateCurve` kept |
| `ShorECDLPTemplate` + reversible-oracle template + `StaticTensorBuilder` | `9192c03626f91b12bff8166644f102431c8b6ef3` (2026-07-09) | `ShorBoundaryMaskFactory` mooring kept |
| Boot bind `ShorECDLPCPUContractor` | `add9d197a70bb2b52ba6d98cf6f11e559e1b9341` (2026-07-08) | Live path: `Secp256k1ECDLPVerificationDispatcher` |
| `GaiaCellMCPServer` (`run_quantum_algorithm`, `distribute-shor`) | `d1a00b7b` / `068a548a` | Scripts still *mention* those names (`install-mcp-server.sh`, `franklin-mesh-orchestrator-loop.sh`). They are **not** on `https://affine.earth/language-invariant/mcp`. |
| Old Franklin teaching catalog | `wiki/Quantum-Algorithm-Catalog.md` deleted `ff85c3b0` (2026-07-15) | Archive copy: `evidence/wiki-archive-20260612T140113Z/wiki/Quantum-Algorithm-Catalog.md` — operator narration, not a live tool list. This page replaces it. |

Python leftover: `cells/python/gaiaftcl/src/gaiaftcl/shor.py` still shells `gaiaftcl prove shor`. The Swift `prove` dispatcher no longer registers that subcommand.

---

## Studies 11–13 (conjecture shear, not Glama QMA)

| Study | Engine | Local prove | Public court face |
|---|---|---|---|
| 11 Ehrhart | `EhrhartVolumePipeline` | `gaiaftcl prove conjecture-workload` | `math_court` domain `geometry` |
| 12 Parallel repetition | `QuantumParallelRepetitionEngine` | same | `math_court` domain `chance` |
| 13 Connes rigidity | `ConnesRigidityEngine` | same | `math_court` domain `algebra` |

Results: [11](Study-11-Ehrhart-Volume-Results.md) · [12](Study-12-Quantum-Parallel-Repetition-Results.md) · [13](Study-13-Connes-Rigidity-Results.md) · [bundle](Peer-Review-Conjecture-Bundle.md).

---

## Two wiki trees

| Tree | Role |
|---|---|
| `wiki/` | Steward / git wiki |
| `cells/xcode/Resources/language-game/press/wiki/` | Copy served with the language-game press surface |

This inventory belongs in both. If they drift, the live `tools/list` HTTP response wins. `prove-live-court.sh` fails loud when the count or names move.

---

## Honest bound

Affine.Earth is **not a quantum-circuit simulator** ([Mother Protocol](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/docs/MOTHER_PROTOCOL_UUM_8D.md)). vQbit strings are exact `num/den` relationships — [UUM-8D + vQbit](UUM-8D-vQbit-Integer-Relationships.md). The court exposes a Q-only / instance object: strobe → emit → seal. It does not search unknown Shor periods, Grover marked items, or VQE landscapes. `AlgorithmCatalog` `vmNotConnected` is not this court. ECDLP-from-Q stays *not known*.
