# Study 17 — Chemistry (InChIKey / CID)

**Status: LAW FROZEN + LIVE CLAIM — 2026-08-24 · CID 2244 CALORIE**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 16](Study-16-Disease-Type.md) · [Study 18](Study-18-Material-STD.md) · [Known molecular discoveries](Known-Molecular-Discoveries.md)

| Surface | URL / key | Grade |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-17-chemistry.html | POST `chemistry` ingest |
| IDE | https://affine.earth/language-game/ide.html#chemistry-inchi | hash loads the fixture and POSTs |
| Look | https://affine.earth/language-game/#researcher · catalog already names CID 2244 | GET only |
| Court | `POST /language-invariant/game/chemistry/ingest` | `inchikey` + `cid` · optional `hbd`/`hba`/`lipinski_violations` |
| Affine story | https://affine.earth/language-game/#story/Study-17-Chemistry-InChIKey | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-17-Chemistry-InChIKey | door |

The win is the **verified bond** to a public compound identity. SMILES is a cookbook, not this court. Float MW / logP are not a verdict.

Chemist door: [Discoveries by user](Discoveries-By-User.md) · IDE [`#chemistry-inchi`](https://affine.earth/language-game/ide.html#chemistry-inchi).

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.**

---

## Goal

Name a molecule the way PubChem already names it: **InChIKey** (27-char standard) and **PubChem CID** as an integer. Optional sanctioned integers: `hbd`, `hba`, `lipinski_violations`. SOP-as-contract is this token. The recipe stays on disk.

---

## Integer / token keys

| Key | Kind | Rule |
|---|---|---|
| `inchikey` | exact token | `^[A-Z]{14}-[A-Z]{10}-[A-Z]$` |
| `cid` | Int64 | positive integer in the authored fixture |
| `hbd` `hba` `lipinski_violations` | Int64 | optional; `>= 0` |
| `source` + `role` | required | empty source → `REFUSED_UNATTRIBUTED` |

`logp`, `molecular_weight`, `combined_score` → HTTP 400 `REFUSED_FLOAT`. `smiles` → `REFUSED_COOKBOOK`.

---

## Authored fixture (3 rows, PubChem PUG 2026-08-24)

| cid | inchikey | formula | fetch |
|---:|---|---|---|
| 2244 | BSYNRYMUTXBXSQ-UHFFFAOYSA-N | C9H8O4 | PUG cid/2244 |
| 962 | XLYOFNOQVPJJNP-UHFFFAOYSA-N | H2O | PUG cid/962 |
| 702 | LFQSCWFLJHTTHZ-UHFFFAOYSA-N | C2H6O | PUG cid/702 |

Affine already LOOKS CID 2244 on the molecular ledger. This court CLAIMS it.

---

## Example POSTs

**WIN**

```json
{"source":"researcher","role":"chemist","cid":2244,"inchikey":"BSYNRYMUTXBXSQ-UHFFFAOYSA-N","hbd":1,"hba":4,"lipinski_violations":0}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"chemist","cid":2244,"logp":2.9}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"chemist","cid":2244}
```

**REFUSED_NO_STD**

```json
{"source":"researcher","role":"chemist","cid":99999999}
```

---

## What this page does not do

- Does not host SMILES, sequences, or SOP steps
- Does not seal float MW / logP / confidence
- Does not dump generated-candidate chemistry CSVs
- Does not invent a docking court

Swift: `IndustryStandardCourts.swift` · domain `chemistry`.
