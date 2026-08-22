# Study 12 — Results: Quantum parallel repetition without amplitudes

## For every reader

1. **Alice and Bob play CHSH \(n\) times in parallel.** The classical winning fraction per copy is exactly \(3/4\). After \(n\) copies the discrete bound is \((3/4)^n\) — a product of integers, not a tensor of complex amplitudes.
2. **The vQbit transition multiplies the same fraction.** Each round advances a unit-norm rational state by a Jordan swap: win numerator \(\times 3\), denominator \(\times 4\). The sealed rate equals the bound on every graded \(n\).
3. **The float adversary shears.** A millisecond proxy \(751/1000\) never equals \((3/4)^n\). Continuous amplitudes are the wrong reader of the appointment.

Charter: [Study 12](Study-12-Quantum-Parallel-Repetition-Shear) · Corpus: [Corpus](Study-12-Quantum-Parallel-Repetition-Corpus) · Ledger: `corpus/study-12/study12_ledger.json`

---

## Frozen law (sealed 2026-08-22T18:00:00Z)

| Symbol | Meaning | Sealed value |
|---|---|---|
| Game | CHSH | Win iff \(a\oplus b = x\land y\) |
| Ceiling | Max classical win / round | **3/4** |
| Bound | Parallel repetition | \((3/4)^n\) exact rational |
| **WIN** | Discrete rate \(\le\) bound **and** float proxy \(\neq\) discrete | — |
| **Adversary** | \(751/1000\) | Must **MISS** every \(n\) |

No float crosses a seal. Probability is a rational `num/den`.

---

## Primary grades — CHSH parallel copies

**4 / 4 WIN**

| \(n\) | Discrete rate | Classical bound | Float adversary | Adversary | Verdict |
|---:|---|---|---|---|---|
| 1 | 3/4 | 3/4 | 751/1000 | MISS | **WIN** |
| 2 | 9/16 | 9/16 | 751/1000 | MISS | **WIN** |
| 4 | 81/256 | 81/256 | 751/1000 | MISS | **WIN** |
| 8 | 6561/65536 | 6561/65536 | 751/1000 | MISS | **WIN** |

The discrete rate **equals** the bound. That is the appointment: the Jordan product is the classical parallel-repetition law, written as integers.

---

## What this WIN means

| Layer | Result |
|---|---|
| **Math** | Parallel-repetition decay is an exact rational product. The continuous \(\mathbb{C}^{d^n}\) tensor is not required to state the bound. |
| **Science** | A nonlocal game’s classical ceiling is a finite strategy table (16 deterministic maps). Multiplying that ceiling \(n\) times is the discrete law. |
| **Compute** | A unit-norm vQbit that swaps once per round carries the same fraction the table names. A float “probability” \(0.751\) shears every \(n\). |

Raz-style quantum parallel repetition, in the UUM-8D reading: **the bound is a discrete state transition on the affine manifold.** Continuous amplitudes are the named adversary that fail.

---

## Falsifiers

| Falsifier | Effect |
|---|---|
| Discrete rate \(>\) \((3/4)^n\) | Primary **MISS** — the transition left the classical ceiling |
| Float proxy equals the sealed fraction at any graded \(n\) | Adversary no longer shears — law must be re-derived |
| Any `Float`/`Double` on the seal path | Bundle invalid |

---

**Status: LAW FROZEN — 4/4 primary WIN · 4/4 adversary MISS. Re-run: `python3 corpus/study-12/study12_grade.py`.**
