# Affine.Earth Courts — live on Glama

**The sky writes geometry. Quantum complexity does too. So does code.**  
One endpoint carries three courts: the **Math Court** (49 domains behind `math_court`), the **Quantum court** (QMA + QC-001…021 verifiers and two projection tools) and the **Coding Court** (`code_ir_equiv`, `execute_artifact_crucible` — the verdict IS the artifact, including a prebuilt wasm module returned byte-exact). **49 tools**, measured 2026-09-02 per cell on all nine A records.  
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
| The court is public | Live `tools/list` on 2026-08-27T19:48:20Z advertised **23** tools (HTTP 200, edge `nbg-01`). Raw JSON: `clients/math-court-mcp/evidence/tools-list-20260827T194820Z.raw`. `math_court` and `lattice_op` are present. An earlier walk printed **21** — that count is stale. **Superseded: live `tools/list` is 48 as of 2026-08-29**, measured per-cell against all nine A records; the 23 above stands as the dated record of what was served that day, with its raw JSON. |
| The court is the whole court | One walk covered geometry, chance, algebra, physics, QCD, health, finance, compilers, fluids, eclipse, EHT, seismic, disease, chemistry, materials, PDB, Rife, dynamo, and the four QMA domains. **29 LIVE · 0 LEARN.** |
| Miner verbs stay off the public surface | `mine`, `isolate`, `sha256d`, `submitblock` were **absent**. The win is the verified bond, not a wallet. |
| Floats cannot enter | The wire is decimal strings. A JSON `Float64` is refused. Continuous-quantum agents that speak IEEE never reach a seal. |
| QMA fixtures return exact geometry | 2-local energy **−1/1**. Spin-glass energy **−1**. N-representability **WIN**. 3×3 permanent **6**. |
| The bond is the win | `verify_jordan_bond` returned `AFFINE_JZ_SHEAR_ZERO` on the uniform lock. |

The Mac app (`AffineNPHard court example`) is the same walk with a desktop surface. It measured **30 LIVE · 1 LEARN**. The LEARN row is Go First Dice, which wants sixty-face arrays — not a court failure, a different payload shape.

These are **wired fixtures**. `expose` strobes the instance, emits the close, seals. Named tools replay that seal. An unknown ground state is not searched. That is the honest claim, and it is already stronger than a VQE notebook: the answer is a string you can print, not a distribution you can average.

## Four QMA studies, one public harness

| Study | Legacy pitch | Affine lock | Call this tool |
|---|---|---|---|
| [22 — 2-local Hamiltonian](Study-22-QMA-2-Local-Hamiltonian.md) | VQE / continuous \(e^{-iHt}\) | energy **−1/1** | `expose` `kind=qma_2local` |
| [23 — Spin-glass / TIM](Study-23-QMA-Spin-Glass.md) | D-Wave analog / QMC sign problem | energy **−1** | `expose` `kind=qma_spinglass` |
| [24 — N-representability](Study-24-QMA-N-Representability.md) | Float SDP / wave amplitudes | **WIN** | `expose` `kind=qma_nrep` |
| [25 — Matrix permanent](Study-25-Exact-Permanent.md) | Float boson-sampling “supremacy” | permanent **6** | `expose` `kind=qma_permanent` |

Same fixtures call `expose`. Named tools and `math_court` domains `qma_2local`, `qma_spinglass`, `qma_nrep`, `qma_permanent` replay the seal.

Full algorithm map: [Quantum algorithms inventory](Quantum-Algorithms-Inventory.md). vQbit law: [UUM-8D + vQbit](UUM-8D-vQbit-Integer-Relationships.md).

## The 49 live tools (measured 2026-09-02) — and the 23 of 2026-08-27

Live HTTP: `POST https://affine.earth/language-invariant/mcp` `tools/list` → HTTP 200, **49** names, identical on every one of the nine cells with SNI pinned.  
In-repo mirror: `cells/xcode/Resources/language-game/mcp-tools.json` (regenerated from the live list 2026-09-02) · `CapabilityRegistry.servableEntries` · `.well-known/glama.json` (all 49).  
If those disagree with the live HTTP, the live HTTP wins. Re-measure: `bash clients/math-court-mcp/prove-live-court.sh`.

The 26 that joined since the table below was captured: the 21 QC verifiers (`verify_shor_witness` … `verify_presented_pair`), generic `expose`, the two projection tools `project_shor_twin` and `project_affine_key`, and the Coding Court pair `code_ir_equiv` and `execute_artifact_crucible`. Full table with every tool: [MCP user guide](Affine-Earth-MCP-User-Guide.md).

The 23 below are the dated record of 2026-08-27, kept with its raw JSON:

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

**ON GLAMA (live 49).** If a name is in the live `tools/list`, it is on affine.earth MCP and any Glama agent can call it. Studies **22–25** call `expose` (`kind` `qma_*`); named tools replay the sealed emit. Studies **11–13** use `math_court` domains `geometry`, `chance`, `algebra`. Fixtures and the caller: `clients/math-court-mcp/fixtures/live-court-studies.json` · `bash clients/math-court-mcp/prove-live-court.sh`.

**LIVE — 21 QC verifiers + generic `expose` + two projection tools + the Coding Court (measured on the apex 2026-09-02).** Law: `ExposeLaw.swift` + `AffineExposeLaw.swift` + `QCCourtLaw.swift`.

**MANIFOLD REPAIR, 2026-08-30 — the ingest was carrying half a tensor.** The A-vector fed to the
Jordan bond had four measured limbs and four literal constants, so C⁴ collapsed to three
coordinates (`c3 ≡ c1 + bw − 1` for every key) and the exposure could not distinguish a point
from its own negation. The 21,953-row corpus was also structurally unparseable — 25 header
fields against 46 per row. All measured, all repaired, corpus regenerated cold from the raw
curve points. Full record with the before/after numbers:
[QMT Court — Manifold Repair v3.0](QMT-Court-Repair-2026-08-30.md).

**POST ONE HALF, RECEIVE THE OTHER — the two projection tools.** Every other tool on this surface
GRADES a witness you supply in full. These two return the half you withheld.

`project_shor_twin` — post `halfPow` and receive `factor`/`cofactor` by `gcd(a−1,N)` and
`gcd(a+1,N)`; post the factors and receive `a` by CRT. A bijection, polynomial in both directions.
It does not search for a period. Measured 250/250 in both directions with the round trip closing on
the court's own answer.

`project_affine_key` — post `A` (the private face) and receive `Q = A·G`. Scalar multiplication:
total, search-free, closes for every A in [1, n−1]. **Measured 250/250 on scalars up to 256 bits,
each posted ALONE with Q withheld, each projecting exactly its own Q.**

The two directions of the affine key are NOT symmetric and the court says so rather than hiding it
behind one verdict word. Post `q_hex` alone and the other face is the discrete log: secp256k1 has
PRIME group order, so the required bond dimension is n itself (~1.16e77) against a ceiling of 4096.
Measured 2026-09-02, that answers verdict **CHI_EXHAUSTED**: `energy_num` = n (the bond dimension this instance requires, ~1.16e77) over `energy_den` = 4096 (the ceiling), and the detail names the PROBE as the limit — an n² enumeration that closes to n=17 — rather than the group. It is a cost report, not a claim of impossibility and not a graded pair (the wire `status` reads MISS today; the `verdict` field is the one to read).
`x(Q)` is returned as ground because it is real and derivable, and it is PUBLIC; it is never
promoted into the private face. A court that backfilled it would announce a bonded pair for every
pubkey Bitcoin has ever exposed. Membrane: `CapabilityRegistry` + `CertifiedUserMCPMembrane`. `tools/list` on the live apex is **49**, measured 2026-09-02 against every one of the nine A records, not through the round-robin alone. The count grew past 45 with the two PROJECTION tools and reached 49 with the Coding Court, which are the only ones on this surface that hand back a value you did not post: `project_shor_twin` and `project_affine_key`. `expose` `kind` selects the law (`affine_key` is Q-only Affine period strobe, no k). The act is strobe → emit → seal. Named `verify_*` tools replay a sealed emit. Call table: [Conjecture Alignment](Conjecture-Alignment-UUM8D.md). They do not search an unknown period, marked item, variational landscape, or k from a bare Q. `vmNotConnected` catalog bodies are not this surface.

**STILL NOT TOOLS.** `run_quantum_algorithm`, miner verbs, ECDLP-from-Q, VQE optimizer, QAOA pulses. Lean / substrate stay the research engines. Typed `AlgorithmCatalog` shells still throw `vmNotConnected` — do not expose those.

| Research object | Where it actually runs |
|---|---|
| Shor / period / Grover / QFT / QPE court | Named MCP tools above (LIVE) · local `swift test --package-path LatticeRender --filter QCCourtLaw` |
| Shor witness Lean | `cd proof/lean && lake build FirstRoars.ShorWitnessCertifier` · [Lion-Shor-Witness-Certifier](Lion-Shor-Witness-Certifier.md) |
| Shor ECDLP substrate | `cells/xcode/Sources/ShorECDLPSubstrate/` · Lean `ShorECDLP.lean` |
| Studies 12–13 local prover | `gaiaftcl prove conjecture-workload` |
| Miner verbs | `mine`, `isolate`, `sha256d`, `submitblock`, `nphard` — unproven, off `tools/list` |

Full map: [Quantum algorithms inventory](Quantum-Algorithms-Inventory.md).

## Run it yourself

```bash
bash clients/math-court-mcp/prove-live-court.sh
```

That script POSTs the live apex, writes `clients/math-court-mcp/evidence/`, prints WIN/MISS, and exits 2 if the required names drift or a study fixture misses. The count is pinned EXACTLY at **49**; 2026-09-02 run: 40 WIN of 41 study rows, the single MISS being the fixture that still said 48. Every `verify_*`, `project_*` and `expose` row locked live.

```bash
swift run --scratch-path /tmp/affine-math-court-mcp --package-path clients/math-court-mcp/swift-example affine-math-court
```

```bash
swift run --scratch-path /tmp/AffineNPHard-harness --package-path apps/AffineNPHard AffineNPHard court example
```

Payloads are decimal strings. If you send `0.5`, the court refuses you. If you send `1/2`, it grades you.

## The Coding Court is on the same door

`code_ir_equiv` rules whether two implementations carry the same exact constant multiset in their LLVM IR — reordered constants are equivalent, one moved constant is `CODE_IR_DIVERGED` with the value named, no constants at all is `NOT_KNOWN`. `execute_artifact_crucible` ingests the twelve-field ARTIFACT INGESTION BRIEF plus the artifact an agent generated, rules on an eight-rung ladder, and seals the artifact only on the top rung. Measured live 2026-09-02: a real 4,946-byte wasm module posted as base64 came back rung 7 **WIN** as an MCP `resource` with `artifact_kind wasm.module`, `mimeType application/wasm` and a sha256 that re-digests to the posted bytes; a `Double` in a Swift payload was `ARTIFACT_LAW_BROKEN` under Constraint 3; assembler source capped at `ARTIFACT_ASSEMBLED_NOT_DELIVERED` because no cell carries a toolchain, by design. Guide: [Affine Coding Court](Affine-Coding-Court-Architecture.md).

## Why this is the marketing fact

Legacy quantum computing needs a cryostat, a microwave schedule, and a press release about “advantage.” Affine.Earth put the same problem class on a public MCP that any Glama agent can call from a laptop. The cells do not anneal. They do not descend a gradient. They project the presented string onto the torus and either lock or refuse.

That is the demonstration: **the hard problems they advertise are already a court, and the court is already open.**
