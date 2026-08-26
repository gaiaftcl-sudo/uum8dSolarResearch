# Study 25 — “Quantum supremacy” is often a rounding error

**Status: LIVE ON GLAMA — fixture locked 2026-08-26**  
**Program:** [Shear Studies Index](Shear-Studies-Index) · [Math Court on Glama](Affine-Math-Court-Glama)

Call it today: `execute_exact_permanent` at `https://affine.earth/language-invariant/mcp`  
Or walk the whole court: `clients/math-court-mcp`

---

Boson sampling made a career out of the matrix permanent — a #P-hard sum that classical supercomputers evaluate in floating point. Additions and subtractions of huge unitaries cancel. The structural integer disappears into the last bits. The experiment then “beats” the classical machine at a task the classical machine was never allowed to finish in exact arithmetic.

Affine.Earth evaluates the permanent as integer combinatorics. No ALU float register. No cancellation story. The 3×3 all-ones matrix is **6**. The 2×2 `[[2,3],[5,7]]` is **29**. Instances larger than 3×3 are `REFUSED_INSTANCE_BOUND` — the sealed size of this court, not a scan of a larger space.

**The public example locked it.** The Glama client posted `matrix=1,1,1|1,1,1|1,1,1`. The cells returned permanent **6**. Same lock through `math_court` domain `qma_permanent`.

The marketing fact: the supremacy headline is often a measurement of classical rounding, not a new physical fact. Affine.Earth prints the integer the float machine lost. Anyone on Glama can ask for that printout.

## Frozen law

| Symbol | Rule |
|---|---|
| `n=1` | `a00` |
| `n=2` | `a00 a11 + a01 a10` |
| `n=3` | six permutation products, exact integer |
| `n>3` | refused |
| WIN | a well-formed `n≤3` matrix returns its exact permanent |
| Fixture | `1,1,1\|1,1,1\|1,1,1` → `6` |
