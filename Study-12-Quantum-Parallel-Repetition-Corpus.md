# Study 12 — Corpus: CHSH integer payoff table

**Status: CORPUS SEALED — 2026-08-22**  
Charter: [Study 12](Study-12-Quantum-Parallel-Repetition-Shear) · Results: [Results](Study-12-Quantum-Parallel-Repetition-Results)

---

## Game pin

CHSH is the bipartite game with inputs \(x,y\in\{0,1\}\) and outputs \(a,b\in\{0,1\}\).

**Win rule (exact integer):** \(a \oplus b = x \land y\).

There are 4 deterministic functions for Alice and 4 for Bob (16 strategy pairs). The maximum classical win fraction over the 4 input pairs is **3/4**.

| Object | Integer statement |
|---|---|
| Inputs | \(\{0,1\}\times\{0,1\}\) |
| Outputs | \(\{0,1\}\times\{0,1\}\) |
| Classical ceiling | \(3/4\) |
| Parallel copies graded | \(n \in \{1,2,4,8\}\) |
| Discrete transition | win_num \(\times 3\), win_den \(\times 4\) per round |

No complex amplitude appears in this corpus.

---

## Machine ledger

| Artifact | Path |
|---|---|
| Grade script | `corpus/study-12/study12_grade.py` |
| Sealed ledger JSON | `corpus/study-12/study12_ledger.json` |
| Transition schema | `corpus/peer-review-conjecture/schemas/vqbit_bipartite_transition.json` |

```bash
python3 corpus/study-12/study12_grade.py
```

Expected summary: `primary_win: 4`, `primary_total: 4`, `adversary_miss: 4`.

---

## Gaps (VOID)

| Slot | Reason |
|---|---|
| Magic Square / other published games | Prospective registry OPEN — CHSH is the sealed pin |
| Quantum (non-classical) strategy table | Not this seal; this seal grades the **classical** bound as a discrete product |
