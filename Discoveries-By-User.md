# Discoveries by user type

**Status: LOOK LIVE + LIVE CLAIM on industry keys — 2026-08-25**  
**Program:** [Known discoveries](Known-Discoveries-Index.md) · [Language-games study board](Language-Games-Study-Board.md) · [Home](Home.md)

FoT is the base. Public flourishing. A steward-disk folder label is not a brand.

Thousands = measured catalog **N**, not invented fact sheets. Two hosted catalogs, **never added**:

| Catalog | N | Playable? | GET |
|---|---:|---|---|
| RCSB PDB holdings | **258616** | **yes** — 4-char `pdb_id` on `#pdb-holdings` | https://affine.earth/language-game/discoveries/catalog.json |
| Protein / material aggregates | **125302** = 78680 + 46622 | **no** — hashes only | https://affine.earth/language-game/discoveries/protein-material-aggregates.json |

Chooser GET: https://affine.earth/language-game/discoveries/user-types.json

Health court is PK **dose** (`mass_milli` / `vol_milli`), not a pocket and not a treatment protocol. Occupancy / docking stay **DARK**.

---

## Pick your door

| User | Act | Goal | Catalog N | Industry key | IDE | WIN | Refuse |
|---|---|---|---|---|---|---|---|
| **Researcher** | LOOK | GET catalogs, no identity | 258616 and 125302 stated separately | none on Look | [`#protein-material-look`](https://affine.earth/language-game/ide.html#protein-material-look) · [\#researcher](https://affine.earth/language-game/#researcher) | GET HTTP 200 | this door never POSTs |
| **Chemist** | CLAIM | InChIKey + CID | 3 fixture rows | `inchikey` + `cid` | [`#chemistry-inchi`](https://affine.earth/language-game/ide.html#chemistry-inchi) | CID **2244** CALORIE | `cid` 99999999 → `REFUSED_NO_STD` |
| **Materials** | CLAIM | COD / mp / space-group | 7 fixture rows | `cod` / `mp_id` / `space_group`+`pearson` | [`#material-std`](https://affine.earth/language-game/ide.html#material-std) | COD **9008564** / **9008569** CALORIE | `mp-99999999` → `REFUSED_NO_STD` |
| **Disease / protein** | CLAIM | ICD/DOID + PDB id | fixture 12 + holdings 258616 | `icd`+`doid` · `pdb_id` | [`#disease-icd`](https://affine.earth/language-game/ide.html#disease-icd) · [`#pdb-holdings`](https://affine.earth/language-game/ide.html#pdb-holdings) | **C67** / **C50** / **4HHB** / **2HYY** CALORIE | `Bladder_Cancer_111` / `ZZZZ` → `REFUSED_NO_STD` |
| **Builder** | BUILD | IDE hash → court HUD | families.json | the hash names the court | [`#chooser`](https://affine.earth/language-game/ide.html#chooser) | POST selected id → WIN | do not invent a `game_id` |
| **Public / press** | SHARE | wiki stories that cross-see affine.earth | same two N | cited public ids | [`#discoveries-index`](https://affine.earth/language-game/ide.html#discoveries-index) | story names the hash | no cure protocol · no minted STD |

Look omits credentials. Claim needs `source`+`role`.

---

## Cancer-related discoveries

Affine does **not** write “Affine cured cancer.” Affine does **not** host a treatment SOP.

**Playable** — OLS4 + RCSB fetched **2026-08-25T11:19:20Z**. ICD-11 WHO API HTTP 401 this hour; ICD-10 is the public row.

| Court | Key | Cited this hour | IDE |
|---|---|---|---|
| Disease | ICD / DOID | **C67** + `DOID:11054` bladder · **C50** + `DOID:1612` breast · **C18** + `DOID:219` colon · **C61** + `DOID:10283` prostate · **C64** + `DOID:263` kidney · **C53** + `DOID:4362` cervical · **C34.1** + `DOID:1324` lung · **C25.0** + `DOID:1793` pancreas · **C43.9** + `DOID:8923` skin melanoma · **C22.0** + `DOID:3571` liver | https://affine.earth/language-game/ide.html#disease-icd |
| Protein | 4-char PDB accession | holdings N=258616 · **4HHB** stays · cancer-related in holdings: **2HYY** Abl+imatinib · **1N8Z** HER2+trastuzumab Fab · **1YCR** MDM2–p53 · **5P21** H-Ras · **2ITO** EGFR+gefitinib · **4HJO** EGFR+erlotinib · **1T46** KIT+STI-571 | https://affine.earth/language-game/ide.html#pdb-holdings |

Fetch URLs: OLS4 `https://www.ebi.ac.uk/ols4/api/ontologies/doid/terms?iri=http://purl.obolibrary.org/obo/DOID_<n>` HTTP 200. RCSB `https://data.rcsb.org/rest/v1/core/entry/<id>` HTTP 200. Holdings membership is Set.contains.

Acceptance = CALORIE / WIN on a **presented** industry id. Miss = CURE `REFUSED_NO_STD`.

**Look-only (steward disk, 2026-08-25 read of titles/columns — tree not copied)**

| File | Cancer-word titled rows | STD present | Playable? |
|---|---:|---:|---|
| `proteins_validated.csv` | **63930** (of 78680) | 0 | **no** — generated domain / id words, no ICD / PDB |
| `proteins_by_disease.csv` | **200** (of 1400; 1 generated label) | 0 | **no** — generated disease string, not ICD |

Those generated names are not hosted as playable keys. They are Look-aggregate only.

Charter: [Study 16](Study-16-Disease-Type.md) · [Study 14](Study-14-Protein-Lattice-Manifold.md)

---

## Water / desalination materials

Affine does **not** host membrane synthesis steps. Affine does **not** mint `mp-` ids.

**Playable** — materials court when the row carries a fixture STD. Steward-disk validated CSVs this hour: **0** desalinate / RO / membrane titles. **4** water-related COD ids cited from COD `result.php` + CIF + HTML HTTP 200 at **2026-08-25T11:19:20Z**. Materials Project HTML/API returned 530/401 — **no new mp- rows**.

| STD | Cited | Fetch | IDE |
|---|---|---|---|
| COD **9008564** · sg 227 · `cF8` | Diamond | https://www.crystallography.net/cod/9008564.html | https://affine.earth/language-game/ide.html#material-std |
| mp-**149** · sg 227 · `cF8` | silicon · already in fixture | https://next.materialsproject.org/materials/mp-149 | same |
| COD **1573832** · sg 194 | hexagonal 4H Si-IV | https://www.crystallography.net/cod/1573832.html | same |
| COD **9008569** · sg 186 | Graphite (GO-membrane parent lattice) | https://www.crystallography.net/cod/9008569.html · CIF `_chemical_name_mineral Graphite` | same |
| COD **1000041** · sg 225 | Sodium chloride (the solute desalination removes) | https://www.crystallography.net/cod/1000041.html · COD search `text=sodium+chloride` | same |
| COD **1011255** · sg 43 | Natrolite (fibrous zeolite) | https://www.crystallography.net/cod/1011255.html · COD search `text=zeolite` | same |
| COD **1011097** · sg 152 | Quartz low (SiO₂) | https://www.crystallography.net/cod/1011097.html · CIF `_chemical_name_mineral Quartz low` | same |

Chemistry fixture CID **962** is H₂O (PubChem). That is a water molecule on the chemistry court, not a desalination material.

Charter: [Study 18](Study-18-Material-STD.md)

---

## Four acts

| Act | Who | What |
|---|---|---|
| LOOK | Researcher | GET catalogs. credentials omit. |
| CLAIM | Chemist · Materials · Disease / protein | POST industry key + source+role |
| BUILD | Builder | `ide.html` hash · court HUD search / sample / POST |
| SHARE | Public / press | this wiki · GitHub tab · affine `#story/` · [Fourier Phantom](Impact-Study-Fourier-Phantom.md) · [Death of continuous shear](Death-of-Continuous-Shear.md) |

**OPEN stays 03 / 05 / 08.**

## What this page does not do

- Does not invent 100k fact sheets
- Does not write a cancer-cure or treatment protocol
- Does not host occupancy / docking
- Does not brand a steward-disk folder label
- Does not collapse 258616 and 125302
