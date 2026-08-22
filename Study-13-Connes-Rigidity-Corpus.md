# Study 13 — Corpus: group words on the Eisenstein lattice

**Status: CORPUS SEALED — 2026-08-22**  
Charter: [Study 13](Study-13-Connes-Rigidity-Shear) · Results: [Results](Study-13-Connes-Rigidity-Results)

---

## Generator pin

| Letter | Inverse | Axial step \((q,r)\) |
|---|---|---|
| `a` | `A` | (1, 0) |
| `b` | `B` | (0, 1) |
| `A` | `a` | (−1, 0) |
| `B` | `b` | (0, −1) |

Free reduction cancels adjacent inverse pairs. Presentations then apply:

| Presentation | Relator |
|---|---|
| `cyclicZ2` | \(a^2=1\) — fold `a`/`A` to a parity; keep `b` |
| `freeAbelianZ2` | \(ab=ba\) — net counts of \(a\) and \(b\) |
| `symmetricS3` | free reduction only; bound \(\lvert q\rvert+\lvert r\rvert\le 4\) |

---

## Sealed words

| ID | Letters | Presentation |
|---|---|---|
| `Z2_a2b` | `aab` | cyclic \(\mathbb{Z}/2\) |
| `Z2_aba` | `aba` | cyclic \(\mathbb{Z}/2\) |
| `Z2_abAB` | `abAB` | free abelian \(\mathbb{Z}^2\) |
| `Z2_ba` | `ba` | free abelian \(\mathbb{Z}^2\) |
| `S3_abab` | `abab` | \(S_3\) fragment |

---

## Machine ledger

| Artifact | Path |
|---|---|
| Grade script | `corpus/study-13/study13_grade.py` |
| Sealed ledger JSON | `corpus/study-13/study13_ledger.json` |

```bash
python3 corpus/study-13/study13_grade.py
```

Expected summary: `primary_win: 5`, `primary_total: 5`, `adversary_miss: 5`.

---

## Gaps (VOID)

| Slot | Reason |
|---|---|
| Property-(T) infinite presentations | Prospective registry OPEN — this seal is the finite linking pin |
| Full von Neumann \(L(G)\) reconstruction | **REFUSED** — continuous operator algebra is the adversary, not the corpus |
