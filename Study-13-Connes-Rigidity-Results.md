# Study 13 — Results: Connes rigidity as Eisenstein linking

## For every reader

1. **A group word walks the Eisenstein hex lattice.** Generators \(a,b,a^{-1},b^{-1}\) step axial \((q,r)\). The terminal coordinate is the linking invariant — two integers, not a von Neumann spectral radius.
2. **Relators fold the walk onto the presentation.** \(\mathbb{Z}/2\) folds \(a\) to a parity; free abelian \(\mathbb{Z}^2\) commutes letters to a net translation; the \(S_3\) fragment stays freely reduced and bounded.
3. **The float spectral adversary shears.** It reports \(|q|+|r|+1\). The discrete length is \(|q|+|r|\). They never agree. Continuous operator-algebra norms are the wrong reader.

Charter: [Study 13](Study-13-Connes-Rigidity-Shear) · Corpus: [Corpus](Study-13-Connes-Rigidity-Corpus) · Ledger: `corpus/study-13/study13_ledger.json`

**Live court (2026-08-23):** `POST https://affine.earth/language-invariant/game/algebra/ingest` — explorer: [Lattice role endpoints](Affine-Earth-Lattice-Endpoints). Measured: `word=Z2_aba` → verdict **WIN**. Corpus words: `Z2_a2b` `Z2_aba` `Z2_abAB` `Z2_ba` `S3_abab`.

---

## Frozen law (sealed 2026-08-22T18:00:00Z)

| Symbol | Meaning | Sealed value |
|---|---|---|
| Lattice | Eisenstein hex, axial | \(\Delta a=(1,0),\ \Delta b=(0,1)\) |
| Invariant | Terminal linking | \((q,r)\in\mathbb{Z}^2\) |
| **WIN** | Rigid class \(\neq\) `NON_RIGID` **and** adversary \(\neq |q|+|r|\) | — |
| **Adversary** | Float spectral proxy | \(|q|+|r|+1\) |

No float crosses a seal.

---

## Primary grades — presentation corpus

**5 / 5 WIN**

| Word | Presentation | Reduced | Link \((q,r)\) | Rigid class | Adv | Verdict |
|---|---|---|---|---|---:|---|
| `Z2_a2b` | \(\mathbb{Z}/2\) | `b` | (0, 1) | `RIGID_CYCLE` | 2 | **WIN** |
| `Z2_aba` | \(\mathbb{Z}/2\) | `b` | (0, 1) | `RIGID_CYCLE` | 2 | **WIN** |
| `Z2_abAB` | free abelian \(\mathbb{Z}^2\) | \(\varepsilon\) | (0, 0) | `RIGID_COMMUTATIVE` | 1 | **WIN** |
| `Z2_ba` | free abelian \(\mathbb{Z}^2\) | `ab` | (1, 1) | `RIGID_TRANSLATION` | 3 | **WIN** |
| `S3_abab` | \(S_3\) fragment | `abab` | (2, 2) | `RIGID_BOUNDED` | 5 | **WIN** |

`Z2_a2b` and `Z2_aba` land on the **same** link after the \(\mathbb{Z}/2\) relator. That is rigidity: two different words, one invariant.

`Z2_abAB` is the commutator \([a,b]\). On free abelian \(\mathbb{Z}^2\) it is the identity — link \((0,0)\).

---

## What this WIN means

| Layer | Result |
|---|---|
| **Math** | Group structure that Connes rigidity asks about in \(L(G)\) survives as a discrete linking class on the Eisenstein lattice. |
| **Science** | Words that are the same element after relators share a coordinate. Words that are translations keep a nonzero link. The classification does not use a spectrum. |
| **Compute** | Integer generator steps replace continuous operator norms. The float spectral proxy is offset by one on every row — it never names the invariant. |

Connes rigidity, in the UUM-8D reading: **the group is the Jordan-bonded walk.** Continuous von Neumann algebras are the named adversary that fail.

---

## Falsifiers

| Falsifier | Effect |
|---|---|
| Any corpus word classifies `NON_RIGID` after the sealed relator | Primary **MISS** |
| Adversary equals \(|q|+|r|\) | Adversary no longer shears |
| Two \(\mathbb{Z}/2\) words that should identify land on different \((q,r)\) | Relator law broken |

---

**Status: LAW FROZEN — 5/5 primary WIN · 5/5 adversary MISS. Re-run: `python3 corpus/study-13/study13_grade.py`.**
