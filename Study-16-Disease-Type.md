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

Cancer-related play is this court plus PDB holdings — [Discoveries by user — Cancer-related](Discoveries-By-User.md#cancer-related-discoveries). **C67** + `DOID:11054` already WIN. OLS4 this hour also cites **C50** / **C18** / **C61** / **C64** / **C53** / **C34.1** / **C25.0** / **C43.9** / **C22.0**. Generated nicknames do not. This page is not a treatment protocol.

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

## Authored fixture (12 rows)

Fetched OLS4 HTTP 200 **2026-08-25T11:19:20Z**. ICD-11 WHO `id.who.int` HTTP **401** this hour. Founder allows ICD-10 when that is the public row. Do not invent ICD-11 codes. Lung / pancreas / melanoma / liver use the OLS4 xref as written (C34.1 not C34).

| icd10 | doid | cited label | fetch |
|---|---|---|---|
| E11 | DOID:9352 | type 2 diabetes mellitus | OLS4 DOID_9352 · xref ICD10CM:E11 |
| C67 | DOID:11054 | urinary bladder cancer | OLS4 DOID_11054 · xref ICD10CM:C67 |
| I10 | DOID:10825 | essential hypertension | OLS4 DOID_10825 · xref ICD10CM:I10 |
| C50 | DOID:1612 | breast cancer | OLS4 DOID_1612 · xref ICD10CM:C50 |
| C18 | DOID:219 | colon cancer | OLS4 DOID_219 · xref ICD10CM:C18 |
| C61 | DOID:10283 | prostate cancer | OLS4 DOID_10283 · xref ICD10CM:C61 |
| C64 | DOID:263 | kidney cancer | OLS4 DOID_263 · xref ICD10CM:C64 |
| C53 | DOID:4362 | cervical cancer | OLS4 DOID_4362 · xref ICD10CM:C53 |
| C34.1 | DOID:1324 | lung cancer | OLS4 DOID_1324 · xref ICD10CM:C34.1 |
| C25.0 | DOID:1793 | pancreatic cancer | OLS4 DOID_1793 · xref ICD10CM:C25.0 |
| C43.9 | DOID:8923 | skin melanoma | OLS4 DOID_8923 · xref ICD10CM:C43.9 |
| C22.0 | DOID:3571 | liver cancer | OLS4 DOID_3571 · xref ICD10CM:C22.0 |

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

Swift: the shipped substrate · domain `disease` in `LatticeDomainIntegration.swift`.
