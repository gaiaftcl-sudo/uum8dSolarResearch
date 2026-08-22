# Study 11 — Ehrhart Volume Shear: lattice points vs float volume

**Status: LAW FROZEN — 2026-08-22**  
**Program:** [Shear Studies Index](Shear-Studies-Index) · [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm)

---

## For every reader

1. **Volume is a lattice appointment, not an integral.** Count integer points in dilated polytope \(tP\); the leading coefficient of the Ehrhart polynomial \(h_P(t)=|tP\cap\mathbb{Z}^d|\) is the exact rational volume — no floats.
2. **Continuous geometry shears the count.** A float triangulation predicts \(\mathrm{round}(\mathrm{vol}(P)\cdot t^d)\); that prediction **misses** on every corpus polytope at the sealed dilation.
3. **UUM-8D native fit.** Integer polytope boundaries, Jordan-bonded state transitions — this is the arithmetic the substrate was built to seal.

Results: [Study 11 Results](Study-11-Ehrhart-Volume-Results) · Corpus: [Study 11 Corpus](Study-11-Ehrhart-Volume-Corpus)

**5 / 5 WIN. Float adversary 5 / 5 MISS.**

---

## The forcing and the track

| Piece | Instantiation |
|---|---|
| **Forcing** | Integer dilation \(t\in\mathbb{Z}_{\ge 0}\) applied to a lattice polytope \(P\subset\mathbb{Z}^d\) |
| **Clock** | The dilation index \(t\) — the appointment is \(h_P(t)\), not a Riemann sum |
| **Track** | Integer lattice \(\mathbb{Z}^d\); points must land inside exact facet halfspaces |
| **Raw archive** | Vertex lists in [Corpus](Study-11-Ehrhart-Volume-Corpus) — public, deterministic, no floats |
| **Adversary** | Float simplex-triangulation volume \(\times\, t^d\), rounded to integer |
| **Future events** | Any new lattice polytope registered before its counts are examined |

---

## Why Ehrhart is native to UUM-8D

Ehrhart theory asks: *how many integer lattice points live inside a scaled convex polytope?* That question is already the substrate's geometry:

- Polytope facets are **affine halfspace inequalities** with integer coefficients.
- Dilations are **exact integer maps** on vertex coordinates.
- Volume emerges as the **leading coefficient** of \(h_P(t)\) via the \(d\)-fold forward difference \(\Delta^d h(0)/d!\) — a pure integer operation on the count table.
- No measure theory, no floating quadrature, no IEEE-754 shear.

The continuous-math habit integrates \(P\subset\mathbb{R}^d\) with floats and calls the debris "volume." When the same polytope is graded on the integer lattice, float volume **misses** the sealed count at \(t=12\) on every corpus member — the shear is measurable.

---

## Frozen law (sealed 2026-08-22T16:00:00Z)

| Symbol | Meaning | Sealed rule |
|---|---|---|
| `count(P,t)` | Lattice points in \(tP\) | Integer bbox enumeration + exact facet halfspaces |
| `vol(P)` | Euclidean volume | \(\Delta^d h(0)/d!\) as exact rational `num/den` |
| `T_max` | Maximum dilation graded | **12** |
| **WIN** | Count table matches reference Ehrhart polynomial for \(t=0\ldots T_{\max}\) **and** `vol_fd == vol_exp` | — |
| **Adversary MISS** | `round(float_vol(P) * T_max^d) != count(P, T_max)` | Required on every corpus row |

No float crosses the seal path. Volume comparisons use `Fraction` rationals only.

---

## What this proves

| Claim | Verdict |
|---|---|
| Integer lattice counting recovers exact Ehrhart polynomials | **5/5 WIN** |
| Leading coefficient equals exact rational volume | **5/5 WIN** |
| Float triangulation volume predicts lattice counts | **5/5 MISS** (adversary) |

---

## Read next

- [Study 11 Results](Study-11-Ehrhart-Volume-Results)
- [Peer-review bundle](Peer-Review-Conjecture-Bundle)
- [Study 12 Results](Study-12-Quantum-Parallel-Repetition-Results)
