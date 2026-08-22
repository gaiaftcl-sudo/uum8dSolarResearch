# Study 11 — Corpus: lattice polytope vertex pins

**Status: CORPUS SEALED — 2026-08-22**  
Charter: [Study 11](Study-11-Ehrhart-Volume-Shear) · Results: [Results](Study-11-Ehrhart-Volume-Results)

---

## Corpus inventory

All vertices are integer tuples in \(\mathbb{Z}^d\). No float coordinates. Reproducible from this page alone.

| ID | dim | Vertices | Sealed volume |
|---|---:|---|---|
| `unit_square` | 2 | `(0,0),(1,0),(1,1),(0,1)` | 1 |
| `unit_triangle` | 2 | `(0,0),(1,0),(0,1)` | 1/2 |
| `simplex3` | 3 | `(0,0,0),(1,0,0),(0,1,0),(0,0,1)` | 1/6 |
| `hle_poly_d2` | 2 | `(0,0),(1,0),(0,1),(-1,1)` | 1 |
| `hle_poly_d3` | 3 | `(0,0,0),(1,0,0),(0,1,0),(0,0,1),(-1,0,1),(0,-1,1)` | 2/3 |

The `hle_poly_*` rows are the Humanity's Last Exam polytope family (integer lattice formulation).

---

## Machine ledger

| Artifact | Path |
|---|---|
| Grade script | `corpus/study-11/study11_grade.py` |
| Sealed ledger JSON | `corpus/study-11/study11_ledger.json` |
| Boundary schema | `corpus/peer-review-conjecture/schemas/ehrhart_polytope_boundary.json` |

```bash
python3 corpus/study-11/study11_grade.py
```

Expected summary: `primary_win: 5`, `primary_total: 5`, `adversary_miss: 5`.

---

## Gaps (VOID)

| Slot | Reason |
|---|---|
| Dimension \(d \ge 4\) HLE polytope | Not yet pinned — prospective registry OPEN |
| Barvinok-style high-dimensional corpus | Charter extension; enumeration suffices for this seal |
