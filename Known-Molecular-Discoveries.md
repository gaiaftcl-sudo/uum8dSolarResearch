# Known molecular discoveries — public review ledger

**Status: LOOK LIVE — 2026-08-24 · Claim DARK — no occupancy key**  
**Program:** [Study 14 — Protein lattice](Study-14-Protein-Lattice-Manifold.md) · [Study 15 — Skala DFT shear](Study-15-Skala-DFT-Shear.md) · [Language-games study board](Language-Games-Study-Board.md)

| Surface | URL | Grade |
|---|---|---|
| Catalog GET | https://affine.earth/language-game/discoveries/catalog.json | **LIVE** · `credentials: omit` · no visitor data |
| IDE | https://affine.earth/language-game/ide.html#discovery-review | Template opens a fetched record |
| Look walks | https://affine.earth/language-game/#researcher | GET links only. No auto-POST. |
| Claim | none | **DARK** — no occupancy / residue / pocket key |

The win is the **verified bond**, not custody of a fold and not a true/false “discovery” bit.

---

## For every reader — one paragraph

A researcher walks **named** public discoveries the same way Falcon walks a court: Look, then (when a key exists) Claim, then Build, then Share. Today Look is live. The cell serves an **index** of public PDB entry ids with a source-URL template, plus a handful of fact sheets whose fields came from a fetch (PDB 4HHB, PubChem aspirin CID 2244, ChEMBL CHEMBL25, DailyMed aspirin and insulin-human SPLs). The researcher GETs a fact sheet from RCSB / PubChem / ChEMBL / DailyMed. Claim stays DARK until an integer occupancy key exists.

**Instructions** means cited public facts and links — INN, indication on the label, PDB / PubChem / ChEMBL / DailyMed id, manufacture *class* (recombinant / chemical / extracted) from FDA / EMA / label / PDB. It does **not** mean a synthesis cookbook. C-007: no pathogen enhancement, no military, no unpublished manufacture steps.

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.** Skala / float MD / AlphaFold are the adversary on Study 14 / 15, not our method.

---

## Measured catalogs — 2026-08-24 (VERIFIED vs REPORTED)

| Catalog | Number | Grade | Source · fetched |
|---|---|---|---|
| RCSB PDB current holdings | **258616** entry ids | **VERIFIED** | `GET https://data.rcsb.org/rest/v1/holdings/current/entry_ids` HTTP 200 · 2026-08-24T17:13:23Z · example id `1IWB` |
| RCSB search `total_count` (experimental) | **258222** | **VERIFIED** | `POST https://search.rcsb.org/rcsbsearch/v2/query` HTTP 200 · example id `100D` |
| Hosted index `index_n` | **258616** | **VERIFIED** (copy of the holdings fetch) | `/language-game/discoveries/catalog.json` |
| ChEMBL distinct compounds | **2921148** | **VERIFIED** | [status.json](https://www.ebi.ac.uk/chembl/api/data/status.json) + `molecule.json` `page_meta.total_count` · ChEMBL_37 · 2026-05-01 · status UP |
| ChEMBL compound records | **3824604** | **VERIFIED** | same status.json |
| DailyMed SPL count `drug_name=aspirin` | **1077** | **VERIFIED** | `spls.json?drug_name=aspirin` HTTP 200 |
| DailyMed SPL count `drug_name=insulin human` | **22** | **VERIFIED** | `spls.json?drug_name=insulin%20human` HTTP 200 |
| PubChem compound universe | millions of CIDs | **REPORTED** (PUG listkey count HTTP 500 this hour) | Example **VERIFIED**: CID **2244** Aspirin `C9H8O4` |

Do not collapse 258616 and 258222 into one invented number. Holdings is the index we host. Search `total_count` is a second instrument on a filtered query.

---

## One example record (fetched, not invented)

**4HHB** — [RCSB](https://www.rcsb.org/structure/4HHB) · [REST](https://data.rcsb.org/rest/v1/core/entry/4HHB) HTTP 200

| Field | Value | Came from |
|---|---|---|
| id | `4HHB` | holdings + core entry |
| name | THE CRYSTAL STRUCTURE OF HUMAN DEOXYHAEMOGLOBIN AT 1.74 ANGSTROMS RESOLUTION | `struct.title` |
| method | X-RAY DIFFRACTION | `exptl[0].method` |
| polymer_entity_count | 2 | `rcsb_entry_info` |
| deposit_date | 1984-03-07 | `rcsb_accession_info` |
| manufacture_class | none on this row | PDB is a structure archive, not a marketed-product label |

**Aspirin** — PubChem CID 2244 · ChEMBL CHEMBL25 · DailyMed setid `ee8d0961-7572-471f-8c96-b4c0bd354de2`

| Field | Value | Came from |
|---|---|---|
| INN | aspirin | PubChem Title / ChEMBL `pref_name` |
| formula | C9H8O4 | PubChem |
| IUPACName | 2-acetyloxybenzoic acid | PubChem |
| molecule_type | Small molecule | ChEMBL_37 |
| first_approval | 1950 | ChEMBL |
| ATC | B01AC06 · N02BA01 · N02BA51 · A01AD05 | ChEMBL |
| manufacture_class | chemical | ChEMBL small molecule + DailyMed tablet SPL. **Not** a synthesis recipe. |

**Insulin human** — DailyMed setid `e245e0c5-b2d6-418b-baa4-1c3324292885` (HUMULIN 70/30, Eli Lilly)

| Field | Value | Came from |
|---|---|---|
| INN | insulin human | DailyMed title |
| manufacture_class | recombinant | Named product HUMULIN on the FDA/DailyMed listing. GET the SPL for the label text. **Not** a cookbook. |

No IC50 is written on any row. If a number was not in the fetch, it is absent.

---

## How the four acts land here

| Act | Researcher does | This surface |
|---|---|---|
| 1 LOOK | GET the catalog. No identity. | [catalog.json](https://affine.earth/language-game/discoveries/catalog.json) · [\#researcher](https://affine.earth/language-game/#researcher) |
| 2 CLAIM | POST integers + `source`+`role` about a *named* id | **DARK** — no occupancy key. Do not POST Study 11 geometry as a fold. Do not treat health dose as a pocket. |
| 3 BUILD | Open the record in the IDE that exists | [ide.html#discovery-review](https://affine.earth/language-game/ide.html#discovery-review) |
| 4 SHARE | GET view that names `source` | this page · catalog `examples[]` |

`feeds_catalog` / `corpus_bonds` / `umc_*` already name transports. No new MCP tool.

---

## What this page does not do

- Does not invent thousands of fake discovery rows
- Does not write a synthesis cookbook
- Does not land `ProteinManifold.evaluateDocking` or an O(1) dock
- Does not claim folding, docking, or thermochemistry is solved
- Does not call Skala / float MD / AlphaFold **useless**
- Does not POST occupancy, residue, or pocket integers

**Status: LOOK LIVE — hosted index N=258616. Claim DARK.** Family ledger: [Known discoveries](Known-Discoveries-Index.md).
