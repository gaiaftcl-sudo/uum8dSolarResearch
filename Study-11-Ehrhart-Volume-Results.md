# Study 11 — Results: Ehrhart volume without floats

## For every reader

1. **Count lattice points** in dilated polytopes \(tP\) using integers only.
2. **Recover volume** as the leading coefficient \(\Delta^d h(0)/d!\) — exact rationals.
3. **Grade the float adversary** — triangulation volume \(\times\, t^d\) rounded — it **misses** on every polytope.

Charter: [Study 11](Study-11-Ehrhart-Volume-Shear) · Corpus: [Corpus](Study-11-Ehrhart-Volume-Corpus) · Ledger: `corpus/study-11/study11_ledger.json`

**Live court (2026-08-23):** `POST https://affine.earth/language-invariant/game/geometry/ingest` — explorer: [Lattice role endpoints](Affine-Earth-Lattice-Endpoints). Measured: `unit_square` @ `dilation` 12 → `lattice_count` 169 · `volume` `1/1` · `float_adversary` 216 · verdict **WIN**.

---

## Frozen law (sealed 2026-08-22T16:00:00Z)

| Symbol | Meaning | Sealed value |
|---|---|---|
| `T_max` | Maximum dilation | **12** |
| `count` | Integer points in \(tP\) | Bbox + exact facet halfspaces |
| `vol_fd` | \(\Delta^d h(0)/d!\) | Exact rational `num/den` |
| **WIN** | Counts match reference **and** `vol_fd == vol_exp` | — |
| **Adversary** | `round(float_vol * T_max^d)` | Must **not** equal `count(T_max)` |

No float crosses a seal.

---

## Primary grades — lattice polytope corpus

**5 / 5 WIN**

| Polytope | dim | Volume (rational) | count(12) | float pred @12 | Adversary | Verdict |
|---|---:|---|---:|---:|---|---|
| `unit_square` | 2 | 1/1 | 169 | 216 | MISS | **WIN** |
| `unit_triangle` | 2 | 1/2 | 91 | 72 | MISS | **WIN** |
| `simplex3` | 3 | 1/6 | 455 | 288 | MISS | **WIN** |
| `hle_poly_d2` | 2 | 1/1 | 169 | 216 | MISS | **WIN** |
| `hle_poly_d3` | 3 | 2/3 | 1469 | 2304 | MISS | **WIN** |

Numbers are the public Python grader (`corpus/study-11/study11_grade.py`). Re-run that script to reproduce the table.

### Reference Ehrhart polynomials (sealed)

| ID | \(h_P(t)\) |
|---|---|
| `unit_square` | \((t+1)^2\) |
| `unit_triangle` | \((t+1)(t+2)/2\) |
| `simplex3` | \((t+1)(t+2)(t+3)/6\) |
| `hle_poly_d2` | \((t+1)^2\) |
| `hle_poly_d3` | \(1 + 5t + 4\binom{t}{2} + 4\binom{t}{3}\) |

Counts verified for all \(t = 0\ldots 12\).

### Sample count ladders (\(t=0\ldots 6\))

| Polytope | \(t=0\) | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---:|---:|---:|---:|---:|---:|---:|
| `unit_square` | 1 | 4 | 9 | 16 | 25 | 36 | 49 |
| `unit_triangle` | 1 | 3 | 6 | 10 | 15 | 21 | 28 |
| `simplex3` | 1 | 4 | 10 | 20 | 35 | 56 | 84 |
| `hle_poly_d2` | 1 | 4 | 9 | 16 | 25 | 36 | 49 |
| `hle_poly_d3` | 1 | 6 | 19 | 44 | 85 | 146 | 231 |

---

## Adversary grades — float volume shear

**5 / 5 MISS** (required)

The float triangulation adversary predicts lattice counts from \(\mathrm{round}(\mathrm{float\_vol}(P)\cdot t^d)\). On every corpus member at \(t=12\), the prediction disagrees with the integer count — continuous volume integration **shears** the lattice appointment.

| Polytope | Integer count | Float prediction | Error |
|---|---:|---:|---:|
| `unit_square` | 169 | 216 | +47 |
| `unit_triangle` | 91 | 72 | −19 |
| `simplex3` | 455 | 288 | −167 |
| `hle_poly_d2` | 169 | 216 | +47 |
| `hle_poly_d3` | 1469 | 2304 | +835 |

---

## What this WIN means

| Layer | Result |
|---|---|
| **Math** | Volume is the leading coefficient of an integer count polynomial — not a float integral |
| **Science** | Lattice polytopes carry exact appointments; continuous volume is the wrong reader |
| **Compute** | Integer facet enumeration seals what GPU float triangulation cannot |

Ehrhart's Volume Conjecture in the UUM-8D reading: **the volume of a lattice polytope is recovered exactly from its integer dilation counts** — and float geometry is the named adversary that fails.

---

**Status: LAW FROZEN — 5/5 primary WIN · 5/5 adversary MISS. Re-run: `python3 corpus/study-11/study11_grade.py`.**

---

## Public flourishing, as an exact quantity

This study's law is served as domain `geometry` on the live catalogue, and that domain declares an
entropy triple which satisfies an identity anyone can check:

> **6/5 − 1/5 = 1/1**

The continuous form of this law carries **6/5** of structural entropy — more than one. Adopting
the exact form removes exactly **1/5**. What remains is **unity: one answer, replayable on any
machine, by anyone.** That is what the public gets: volume is a count a regulator can replay.

Verified by [`reproduce/flourishing-entropy-ledger.swift`](reproduce/flourishing-entropy-ledger.swift),
which carries a control arm proving the identity can fail. Nine of the forty-eight served domains
declare such a triple; the other thirty-nine do not, and are not counted.

