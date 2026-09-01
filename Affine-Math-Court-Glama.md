# Affine.Earth Math Court — live on Glama

**The sky writes geometry. Quantum complexity does too.**  
Open MCP: `https://affine.earth/language-invariant/mcp` · Registry: `earth.affine/math-court`  
Public example: `clients/math-court-mcp` · Live proof: `bash clients/math-court-mcp/prove-live-court.sh`  
Evidence: `clients/math-court-mcp/evidence/tools-list-20260827T194820Z.raw` · edge `nbg-01` · HTTP 200

---

IonQ, D-Wave, and every VQE notebook sell the same story: *evolve a continuous wavefunction, sample a probability, call the average the answer.* Affine.Earth discarded the wavefunction. The Math Court maps those problems as rigid intersections on an 8-dimensional flat torus and returns **decimal strings** — exact rationals, exact integers — that any agent can replay.

You do not need a lab seat. You need a JSON-RPC post.

## What the example app proved

The public client in `clients/math-court-mcp` computes **no verdict**. It is a visitor: it lists the tools, walks every court domain, names the four QMA solvers, and asks the cells to lock a Jordan bond. Measured on the live 9-cell apex:

| Proof | What locked |
|---|---|
| The court is public | Live `tools/list` on 2026-08-27T21:51:49Z advertised **43** tools (HTTP 200) — the 20 QC verifiers rolled to the cells the same day. Receipt: `clients/math-court-mcp/evidence/VERDICT-20260827T215149Z.json` (34 WIN · 0 MISS of 34, every QC fixture sealing its PROVEN marker). The earlier 23-count and 21-count walks are history. |
| The court is the whole court | One walk covered geometry, chance, algebra, physics, QCD, health, finance, compilers, fluids, eclipse, EHT, seismic, disease, chemistry, materials, PDB, Rife, dynamo, and the four QMA domains. **29 LIVE · 0 LEARN.** |
| Miner verbs stay off the public surface | `mine`, `isolate`, `sha256d`, `submitblock` were **absent**. The win is the verified bond, not a wallet. |
| Floats cannot enter | The wire is decimal strings. A JSON `Float64` is refused. Continuous-quantum agents that speak IEEE never reach a seal. |
| QMA fixtures return exact geometry | 2-local energy **−1/1**. Spin-glass energy **−1**. N-representability **WIN**. 3×3 permanent **6**. |
| The bond is the win | `verify_jordan_bond` returned `AFFINE_JZ_SHEAR_ZERO` on the uniform lock. |

The Mac app (`AffineNPHard court example`) is the same walk with a desktop surface. It measured **30 LIVE · 1 LEARN**. The LEARN row is Go First Dice, which wants sixty-face arrays — not a court failure, a different payload shape.

These are **wired fixtures**. A presented configuration is verified. An unknown ground state is not searched. That is the honest claim, and it is already stronger than a VQE notebook: the answer is a string you can print, not a distribution you can average.

## Four QMA studies, one public harness

| Study | Legacy pitch | Affine lock | Call this tool |
|---|---|---|---|
| [22 — 2-local Hamiltonian](Study-22-QMA-2-Local-Hamiltonian.md) | VQE / continuous \(e^{-iHt}\) | energy **−1/1** | `execute_2local_hamiltonian` |
| [23 — Spin-glass / TIM](Study-23-QMA-Spin-Glass.md) | D-Wave analog / QMC sign problem | energy **−1** | `route_spin_glass_manifold` |
| [24 — N-representability](Study-24-QMA-N-Representability.md) | Float SDP / wave amplitudes | **WIN** | `verify_n_representability` |
| [25 — Matrix permanent](Study-25-Exact-Permanent.md) | Float boson-sampling “supremacy” | permanent **6** | `execute_exact_permanent` |

Same fixtures accept `math_court` with domains `qma_2local`, `qma_spinglass`, `qma_nrep`, `qma_permanent`.

Full algorithm map: [Quantum algorithms inventory](Quantum-Algorithms-Inventory.md). vQbit law: [UUM-8D + vQbit](UUM-8D-vQbit-Integer-Relationships.md).

## The 43 live tools (measured 2026-08-27, post-roll)

Live HTTP: `POST https://affine.earth/language-invariant/mcp` `tools/list` → HTTP 200, **43 names** after the 2026-08-27 cell roll (the 23 below plus the 20 QC verifiers listed in the next section).  
In-repo mirror: the shipped resource tree · `CapabilityRegistry.servableEntries`.  
If those two disagree, the live HTTP wins. Re-measure: `bash clients/math-court-mcp/prove-live-court.sh`.

| # | Tool | Role |
|---|---|---|
| 1 | `atc.assert_4d_deconfliction` | Exact 4D separation |
| 2 | `corpus_bonds` | Sealed corpus bonds |
| 3 | `corpus_capability_map` | Corpus census |
| 4 | `corpus_coverage` | Fleet KV coverage |
| 5 | `critique_frame` | Deterministic frame critic |
| 6 | `execute_2local_hamiltonian` | QMA 2-local verifier |
| 7 | `execute_exact_permanent` | #P permanent \(n\le 3\) |
| 8 | `execute_transition` | Membrane / Rational S4/C4 lanes |
| 9 | `feeds_catalog` | Feed catalog |
| 10 | `game_frame_meta` | Language-game frame |
| 11 | `ide_rebuild_mesh` | Founder-cell rebuild |
| 12 | `lattice_op` | UUM-8D lattice algebra |
| 13 | `math_court` | Domain ingest + catalog |
| 14 | `membrane_health` | Membrane identity |
| 15 | `noaa_goes_r_weather` | Live NOAA / GOES-R |
| 16 | `route_spin_glass_manifold` | QMA spin-glass verifier |
| 17 | `twin.robotics.evaluate_exact_ik` | Exact integer IK |
| 18 | `umc_direct` | UMC GAV direct |
| 19 | `umc_resume` | UMC resume |
| 20 | `umc_status` | UMC status |
| 21 | `verify_jordan_bond` | \(J_Z\) shear-zero |
| 22 | `verify_n_representability` | QMA 2-RDM verifier |
| 23 | `weather.convective_containment` | Exact convective containment |

Five catalogued **ABSENT** rows (`mcpTool: false`, empty primitive) are **not** served: `twin.quantum.stabilizer_tableau`, `twin.chem.qubo_ising_docking`, `twin.fluid.lbm_step`, `twin.chem.steric_knot_check`, `twin.materials.symmetry_burgers`.

## Two surfaces — do not collapse them

**ON GLAMA (live 43).** If a name is in the live `tools/list`, it is on affine.earth MCP and any Glama agent can call it. Studies **22–25** are on that court (`execute_2local_hamiltonian`, `route_spin_glass_manifold`, `verify_n_representability`, `execute_exact_permanent`, plus `math_court` domains `qma_*`). Studies **11–13** use `math_court` domains `geometry`, `chance`, `algebra`. Fixtures and the caller: `clients/math-court-mcp/fixtures/live-court-studies.json` · `bash clients/math-court-mcp/prove-live-court.sh`.

**LIVE ON GLAMA — 20 QC verifiers, rolled 2026-08-27.** Law: `QCCourtLaw.swift` (9/9 law tests, floats refused at the wire). Membrane: `CapabilityRegistry` + `CertifiedUserMCPMembrane` + `AffineMathCourt.qc`. Live `tools/list` is **43**, and every one of the 20 answered its fixture WIN with its `AFFINE_QC_*` PROVEN marker on the public apex (receipt above). Names: `verify_shor_witness`, `verify_period`, `verify_grover`, `verify_qft_phases`, `verify_qpe_phase`, `verify_hhl`, `verify_deutsch_jozsa`, `verify_bernstein_vazirani`, `verify_simon`, `verify_amplitude_amplification`, `verify_amplitude_estimation`, `verify_phase_kickback`, `verify_quantum_walk`, `verify_vqe_energy`, `verify_qaoa_energy`, `verify_quantum_counting`, `verify_teleport`, `verify_superdense`, `verify_bell_measurement`, `verify_topological_word`. Call table: [Conjecture Alignment](Conjecture-Alignment-UUM8D.md). These grade a **presented** witness. They do not search an unknown period, marked item, or variational landscape. `vmNotConnected` catalog bodies are not this surface.

**STILL NOT TOOLS.** `run_quantum_algorithm`, miner verbs, ECDLP-from-Q, VQE optimizer, QAOA pulses. Lean / substrate stay the research engines. Typed `AlgorithmCatalog` shells still throw `vmNotConnected` — do not expose those.

| Research object | Where it actually runs |
|---|---|
| Shor / period / Grover / QFT / QPE court | Named MCP tools above (after deploy) · local `swift test --package-path LatticeRender --filter QCCourtLaw` |
| Shor witness Lean | `cd proof/lean && lake build FirstRoars.ShorWitnessCertifier` · [Lion-Shor-Witness-Certifier](Lion-Shor-Witness-Certifier.md) |
| Shor ECDLP substrate | the shipped substrate · Lean `ShorECDLP.lean` |
| Studies 12–13 local prover | `gaiaftcl prove conjecture-workload` |
| Miner verbs | `mine`, `isolate`, `sha256d`, `submitblock`, `nphard` — unproven, off `tools/list` |

Full map: [Quantum algorithms inventory](Quantum-Algorithms-Inventory.md).

## Run it yourself

```bash
bash clients/math-court-mcp/prove-live-court.sh
```

That script POSTs the live apex, writes `clients/math-court-mcp/evidence/`, prints WIN/MISS, and exits 2 if the required names drift or a study fixture misses. Count 23 (pre-roll) or 43 (post-roll) both pass; the live apex serves 43 as of 2026-08-27T21:51:49Z, and the `DEPLOY_REQUIRED` state is history — a re-run today prints 34 WIN · 0 MISS.

```bash
swift run --scratch-path /tmp/affine-math-court-mcp --package-path clients/math-court-mcp/swift-example affine-math-court
```

```bash
swift run --scratch-path /tmp/AffineNPHard-harness --package-path apps/AffineNPHard AffineNPHard court example
```

Payloads are decimal strings. If you send `0.5`, the court refuses you. If you send `1/2`, it grades you.

## Why this is the marketing fact

Legacy quantum computing needs a cryostat, a microwave schedule, and a press release about “advantage.” Affine.Earth put the same problem class on a public MCP that any Glama agent can call from a laptop. The cells do not anneal. They do not descend a gradient. They project the presented string onto the torus and either lock or refuse.

That is the demonstration: **the hard problems they advertise are already a court, and the court is already open.**
