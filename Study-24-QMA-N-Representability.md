# Study 24 — A molecule is consistent, or it is not

**Status: LIVE ON GLAMA — fixture locked 2026-08-26**  
**Program:** [Shear Studies Index](Shear-Studies-Index) · [Math Court on Glama](Affine-Math-Court-Glama)

Call it today: `verify_n_representability` at `https://affine.earth/language-invariant/mcp`  
Or walk the whole court: `clients/math-court-mcp`

---

N-representability is the quiet QMA-complete problem behind quantum chemistry. Given local 2-particle density matrices, do they belong to a real N-particle state? Classical groups spend days in floating-point semidefinite programs. Quantum groups try to measure continuous amplitudes. Trailing-bit drift invents geometries that never lived — false-positive molecules with a pretty picture.

Affine.Earth maps the 2-RDM as a rational matrix. Trace, symmetry, and positivity are cross-multiplies. Either the local patches intersect on the 8-manifold or the intersection is void. There is no “almost positive.”

**The public example locked it.** The Glama client posted `rho2=1/2,0/1|0/1,1/2` with `n=2`. The cells returned **WIN**. The adversary `3/2,0/1|0/1,-1/2` is **MISS** — a negative eigenvalue, a molecule the float SDP can still smile at. Same lock through `math_court` domain `qma_nrep`.

The marketing fact: consistency of a local quantum state is a boolean string match on affine.earth, not a multi-day solver farm. If your chemistry stack needs a float to decide whether a density is legal, the court has already refused your language.

## Frozen law

| Symbol | Rule |
|---|---|
| Trace | `a11+a22 = N(N−1)/2` exact |
| Symmetric | `a12 = a21` by cross-multiply |
| Positive | `a11 ≥ 0` and `det ≥ 0` |
| WIN | all three hold |
| MISS | any one fails |
| REFUSED | IEEE token on the wire |
