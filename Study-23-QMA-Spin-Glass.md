# Study 23 — A spin glass does not need a freezer

**Status: LIVE ON GLAMA — fixture locked 2026-08-26**  
**Program:** [Shear Studies Index](Shear-Studies-Index) · [Math Court on Glama](Affine-Math-Court-Glama)

Call it today: `route_spin_glass_manifold` at `https://affine.earth/language-invariant/mcp`  
Or walk the whole court: `clients/math-court-mcp`

---

D-Wave exists to sell this problem. Three-dimensional spin glasses and the transverse Ising model are NP-hard / QMA-hard. Hardware annealers “solve” them with analog microwave pulses and a temperature schedule. Quantum Monte Carlo hits the sign problem. Thermal noise is not a footnote — it is the method. There is never a sealed global minimum, only a sample that looked deep enough this run.

Affine.Earth deletes time and temperature from the law. A spin is not a magnetic magnitude. It is a discrete ±1 direction on the flat torus. Frustrations are lattice seams. Energy is an exact integer.

**The public example locked it.** The Glama client posted the antiferromagnetic triangle `edges=0,1,1;1,2,1;2,0,1` with `spins=1,-1,1`. The cells returned energy **−1**. All-up `1,1,1` is energy **+3** — the excited class, a MISS. Same lock through `math_court` domain `qma_spinglass`.

The marketing fact: you do not rent an annealer to grade a presented spin string. You post decimal strings to affine.earth and the court prints the integer. The analog pulse has nothing to say to that printout.

## Frozen law

| Symbol | Rule |
|---|---|
| `E = Σ J_ij s_i s_j` | `s ∈ {+1,−1}` |
| WIN | fixture energy `−1` |
| MISS | any other presented energy |
| REFUSED | IEEE token on the wire |

All-up `1,1,1` is energy `+3` — MISS, the excited class.
