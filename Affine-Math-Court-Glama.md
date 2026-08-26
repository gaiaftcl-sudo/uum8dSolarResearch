# Affine.Earth Math Court — live on Glama

**The sky writes geometry. Quantum complexity does too.**  
Open MCP: `https://affine.earth/language-invariant/mcp` · Registry: `earth.affine/math-court`  
Public example: `clients/math-court-mcp` · Mac harness: `apps/AffineNPHard`

---

IonQ, D-Wave, and every VQE notebook sell the same story: *evolve a continuous wavefunction, sample a probability, call the average the answer.* Affine.Earth discarded the wavefunction. The Math Court maps those problems as rigid intersections on an 8-dimensional flat torus and returns **decimal strings** — exact rationals, exact integers — that any agent can replay.

You do not need a lab seat. You need a JSON-RPC post.

## What the example app proved

The public client in `clients/math-court-mcp` computes **no verdict**. It is a visitor: it lists the tools, walks every court domain, names the four QMA solvers, and asks the cells to lock a Jordan bond. Measured on the live 9-cell apex:

| Proof | What locked |
|---|---|
| The court is public | `tools/list` advertised **21** tools. `math_court` and `lattice_op` were present. |
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

## Run it yourself

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
