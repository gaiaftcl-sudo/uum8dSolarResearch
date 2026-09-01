# The full-grade replacement

**Page class: INDEX / ARGUMENT.** Every figure below is printed by `reproduce/replacement-grade-ledger.swift` from a sha256-pinned snapshot of the live court's own catalog, or carries its grade inline per [the ontology](Ontology).

---

## The over-scaling law

The [exactness seam](The-Exactness-Seam) established the narrow, vendor-documented fact: floating-point verdicts re-derive **inside one platform-and-version pair** and do not travel across pairs. At small scale that is a nuisance — a few dozen experts absorb the discrepancies by hand.

**Over-scaling breaks it, and the failure is arithmetic, not opinion.** Scaling multiplies exactly the two things the seam cannot survive:

- **Consumers per verdict.** A simulated number used to be read by an engineer. It is now consumed by fleets of agents, pipelines, and downstream models — each inheriting a number it has no way to re-derive. The reconciliation *debt* grows with the consumer count. The reconciliation *capacity* — human experts re-deriving by hand — does not grow at all.
- **Platform pairs.** More hardware generations, more compilers, more cloud regions, more model versions: every pair added is a new boundary the verdict cannot cross bit-identically.

Our own record shows what this looks like at *small* scale, in a field of a few dozen practitioners: a **5× units artifact stood unremarked in the literature for two years** ([found by counting](Home)); one model returns **opposite signs under two standard conventions** from identical inputs; five peer-reviewed groups **disagree on the sign** of the same physical response. That is the reconciliation debt of a tiny field. Multiply the consumers by a million agents and the debt scales with them.

> **An industry whose verdicts cannot be re-derived by its consumers accumulates unreconcilable disagreement at the rate of its own growth.** What does not survive over-scaling is not any particular company — it is the *trust-me verdict* as a product. Either the law layer of a verdict industry migrates to exact, re-derivable form, or its outputs stop functioning as evidence at exactly the scale its business plan requires.

That migration is not a proposal. It is running, and the court's own catalog is the ledger of it.

---

## The four probabilistic overshoots, and the seam that already runs

Four industries are scaling fastest into the failure mode, and for each one the replacement is not a whitepaper — it is a **named tool answering on the live court** at `affine.earth`.

| vertical | the probabilistic overshoot | the exact seam, live today | what a local population gets |
|---|---|---|---|
| **Quantum** | advantage claims settled in float amplitudes no reviewer can re-derive; a verdict industry built on `Pr = \|α\|²` in ℝ | the `chance` domain (**PROVEN** — exact rationals vs float amplitude tensors, 4/4 vs 4/4) and the `verify_*` court set: Grover, Shor witness, QFT, QPE, HHL, teleport, QMA 2-local / spin-glass / N-representability / permanent — **a presented quantum computation is verified in exact arithmetic** | a regulator or a journal can check a quantum claim without owning a quantum computer or trusting the claimant |
| **AI** | verdicts consumed by millions of agents that cannot re-derive them; training and inference economics that demand orbital-scale energy | the `cs` domain (dead equation: *IEEE-754 sums; float loss + backprop*), `code_ir_equiv` for exact program equivalence — and [Study 30](Study-30-Sovereign-Edge-Pod)'s ground node at **3.240 J per hour**, measured | verification stays on the ground, repairable by a person with a screwdriver, owned by the country it sits in — and auditable by anyone |
| **Space** | the literal over-scaling: a fleet whose replacement cycle moves three planetary accounts at once, graded by five models that disagree on sign | [Study 29](Study-29-Continuous-Model-Shear), [Study 30](Study-30-Sovereign-Edge-Pod), and [Study 31](Study-31-Biosphere-Cascade) — the joint ledger **sealed live on all nine cells**, `STUDY31_BIOSPHERE_JOINT_LEDGER_PROVEN` | the sky over their heads gets an instrument: a verdict about the atmosphere any citizen can replay, against a measured healthy baseline |
| **FSD / autonomy** | safety cases built on perception confidence scores and simulated miles — probabilistic evidence for a binary question: do two trajectories collide | `twin_robotics_evaluate_exact_ik` — **exact inverse kinematics** for a digital twin — and `atc_assert_4d_deconfliction`: exact 4D separation over declared trajectories in integer-scaled coordinates, returning **a separation certificate or the violating pair**, never a confidence score | a separation *certificate* is evidence in a way a confidence score never is: the difference between "the model was 99.7% sure" and a number the investigating authority can re-derive |

Every tool named in that column is on the live court's `tools/list` right now — the same wire this wiki's harness checks on every run.

**The benefit thread, stated plainly:** in each vertical the replacement moves the *authority over the verdict* from the vendor to the public. That is what "lasting benefit for the local population" means in practice — not a cheaper service, but a verdict their own regulator, their own engineer, their own researcher can re-derive without permission. The [flourishing identity](Ontology) is the per-domain measure of exactly that transfer.

---

## The catalog — 49 rows, each naming the instrument it retires

The court's own declaration, rendered from the pinned snapshot (`corpus/study-31/court-catalog-20260901.json`). Each domain names its `dead_equation` — the continuous instrument retired — and its `new_law`. A sample of the retirements, verbatim:

| domain | the continuous instrument retired |
|---|---|
| geometry | `vol = integral_P 1 dx` |
| chance | `Pr = \|alpha\|^2 in R` |
| finance | `Black-Scholes PDE; GBM + VaR Monte Carlo` |
| fluids | `Navier-Stokes + RANS closures; Re = UL/nu` |
| health | `C = C0 e^{-k t}; p-value; Cox e^{beta X}` |
| cs | `IEEE-754 sums; float loss + backprop` |
| dynamo | `continuous MHD / gyrochronology` |
| biosphere | `each axis modelled alone in floating point, reported as a global mean` |

The full 49 print from one command:

```bash
xcrun swiftc -O -swift-version 5 reproduce/replacement-grade-ledger.swift -o /tmp/rgl && /tmp/rgl
```

## The scoreboard — counted, not claimed

| | |
|---|---|
| domains declared on the live court | **49** |
| carrying a live `PROVEN` marker | **13** |
| resolving the flourishing identity to `1/1` | **9** |
| still short of `1/1` | **40** |

**The replacement is not finished, and this page does not pretend it is.** Forty domains have not yet resolved their identity, and the table names them rather than rounding them up. What this page claims is narrower and checkable: the migration is *running* — per-domain, dated, with the proof status of every row readable off the live court instead of off anyone's prose — and the four industries scaling fastest into the shear already have their first exact seams answering in public.

That is what survives over-scaling: not the loudest instrument, but the one whose answers strangers can re-derive.

---

**Related:** [The exactness seam](The-Exactness-Seam) — the vendor-documented foundation · [Zero float · zero shear](Zero-Float-Zero-Shear-Paradigm) — the method · [The narrow-study defence, answered](Impact-Study-SpaceX-Biosphere-Forcing) · [Study 31 — sealed live](Study-31-Biosphere-Cascade) · [The ontology](Ontology)
