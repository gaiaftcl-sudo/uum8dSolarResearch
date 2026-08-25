# Study 16 — Disease type (ICD / DOID)

**Status: LAW FROZEN + LIVE CLAIM — 2026-08-24 · E11 / DOID:9352 CALORIE · generated nicknames REFUSED_NO_STD**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 14 — Protein lattice](Study-14-Protein-Lattice-Manifold.md) · [Study 17](Study-17-Chemistry-InChIKey.md) · [Study 18](Study-18-Material-STD.md)

| Surface | URL / key | Grade |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-16-disease.html | POST `disease` ingest |
| IDE | https://affine.earth/language-game/ide.html#disease-icd | hash loads the fixture and POSTs |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/game/disease/ingest` | `icd` + `doid` · source+role |
| Affine story | https://affine.earth/language-game/#story/Study-16-Disease-Type | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-16-Disease-Type | door |

The win is the **verified bond** to a public industry code. Occupancy stays Study 14 grammar, not a dock. Health is PK dose (`mass_milli`/`vol_milli`), not a pocket. Complementary occupancy is not this court.

Cancer-related play is this court plus PDB holdings — [Discoveries by user — Cancer-related](Discoveries-By-User.md#cancer-related-discoveries). **C67** + `DOID:11054` already WIN. Generated nicknames do not. This page is not a treatment protocol.

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.**

---

## Goal

Name a disease the way the public already names it: **ICD-10** (or ICD-11 when a public row has it) and **DOID** when a public DOID exists. Generated labels (`Bladder_Cancer_111`) do not WIN.

SOP-as-contract is this token. The recipe stays on disk.

---

## Integer / token keys

| Key | Kind | Rule |
|---|---|---|
| `icd` | exact token | ICD-10 `^[A-Z][0-9]{2}(\.[0-9A-Z]{1,4})?$` or ICD-11 `^[0-9][A-Z0-9]{3}(\.[0-9A-Z]{1,4})?$` |
| `doid` | exact token | `^DOID:[0-9]+$` |
| `source` + `role` | required | empty source → HTTP 400 `REFUSED_UNATTRIBUTED` |

No float field is a key. `confidence` / `overall_score` → HTTP 400 `REFUSED_FLOAT`.

---

## Authored fixture (3 rows, fetched 2026-08-24)

| icd10 | doid | cited label | fetch |
|---|---|---|---|
| E11 | DOID:9352 | type 2 diabetes mellitus | OLS4 DOID_9352 · xref ICD10CM:E11 |
| C67 | DOID:11054 | urinary bladder cancer | OLS4 DOID_11054 · xref ICD10CM:C67 |
| I10 | DOID:10825 | essential hypertension | OLS4 DOID_10825 · xref ICD10CM:I10 |

ICD-11 WHO API returned 401 this hour. Founder allows ICD-10 when that is the public row. Do not invent ICD-11 codes to fill the gap.

---

## Example POSTs

**WIN** (tiny fixture, not 125k):

```json
{"source":"researcher","role":"clinician","icd":"E11","doid":"DOID:9352"}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"clinician","icd":"E11","confidence":0.5}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"clinician","icd":"E11","doid":"DOID:9352"}
```

**REFUSED_NO_STD**

```json
{"source":"researcher","role":"clinician","icd":"Bladder_Cancer_111"}
```

---

## What this page does not do

- Does not ingest generated disease nicknames or sequences
- Does not write `ProteinManifold.evaluateDocking`
- Does not treat health as a pocket
- Does not fill OPEN 03 / 05 / 08
- Does not host SOP step bodies

Swift: `cells/xcode/Sources/InvariantCompiler/IndustryStandardCourts.swift` · domain `disease` in `LatticeDomainIntegration.swift`.
