# Manufacture contracts — SOP-as-contract, not a cookbook

**Status: LOOK LIVE — 2026-08-25 · CLASS + URL + sha256**  
**Program:** [Discoveries by user](Discoveries-By-User.md) · [Known discoveries](Known-Discoveries-Index.md)

| Surface | URL | Grade |
|---|---|---|
| GET | https://affine.earth/language-game/discoveries/manufacture-contracts.json | **LIVE** · credentials omit |
| IDE | https://affine.earth/language-game/ide.html#manufacture-look | Look card |
| Affine story | https://affine.earth/language-game/#story/Manufacture-Contracts | this page |

**Instructions** means: goal, material, industry key, N, manufacture CLASS, source URL, sha256 of the contract JSON (keys sorted, `sha256` field omitted). **Zero steps. Zero precursors. Zero yields.**

C-007: hosted files carry no recipe-key tokens and no military-body tokens.

CLASS is one of: `recombinant` · `chemical` · `extracted` · `optical-test` · `unknown` · `CLASS_ABSENT`. CLASS comes from a cited FDA/EMA/label/PDB row when we have one. Otherwise `CLASS_ABSENT`.

---

## Playable-family contracts (N=6)

| Family | Industry key | CLASS | N | Source |
|---|---|---|---:|---|
| disease | `icd=C67` `doid=DOID:11054` | CLASS_ABSENT | 12 | OLS4 DOID:11054 |
| pdb | `pdb_id=4HHB` | CLASS_ABSENT | 258616 | RCSB 4HHB |
| chemistry | `cid=2244` | chemical | 6 | PubChem PUG 2244 |
| material | `cod=9008564` | extracted | 7 | COD 9008564 Diamond |
| complex | `pdb_id=2HYY` `cid=5291` | CLASS_ABSENT | 4 | RCSB 2HYY |
| rife | `hz=440` `cited_id=iso16-a440` | optical-test | 3 | Wikipedia A440 |

sha256 values live on the GET JSON. This page does not repeat a recipe.

---

## Steward-disk `02_MANUFACTURING_READY/` (titles only)

Counted **2026-08-25**. Path is a folder label, not a brand. **51 files** = 50 `*_MANUFACTURING_GUIDE.md` + `MASTER_INDEX.md`.

Bodies were **not copied**. C-007-titled files were **not ingested**.

Titles counted, not copied. Two military-protection-titled files are **not listed here** and **not ingested**. Class not assigned — no FDA/EMA/label fetch this hour.

---

## What this page does not do

- Does not host synthesis steps, precursors, or yields
- Does not copy steward-disk guide bodies
- Does not write a treatment SOP
- Does not brand a folder label
