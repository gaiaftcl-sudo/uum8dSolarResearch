# ERIC Ultimate package — ingest review

**Status: CHARTER WITH ARCHIVE · LOOK path (local hashes) · CLAIM DARK — 2026-08-24**  
**Not Study 16.** This is a ledger page under Study 14 / the family index. No new court. No occupancy key.  
**Program:** [Study 14 — Protein lattice](Study-14-Protein-Lattice-Manifold.md) · [Known molecular discoveries](Known-Molecular-Discoveries.md) · [Known discoveries — family ledger](Known-Discoveries-Index.md) · [Language-games study board](Language-Games-Study-Board.md)

| Surface | URL / key | Grade |
|---|---|---|
| Affine Look (public PDB) | [catalog.json](https://affine.earth/language-game/discoveries/catalog.json) | **LIVE** · hosted PDB holdings **N=258616**. ERIC adds **0** named public PDB / PubChem / ChEMBL / DailyMed ids. |
| Family GET | [families.json](https://affine.earth/language-game/discoveries/families.json) | **LIVE** · 17 families. ERIC is **not** a hosted family row this hour. |
| IDE | [ide.html#discovery-review](https://affine.earth/language-game/ide.html#discovery-review) · [#researcher](https://affine.earth/language-game/#researcher) | GET only. credentials omit. |
| Claim | `POST /language-invariant/game/{domain}/ingest` | **DARK** for ERIC. No occupancy / residue / pocket / kcal `game_id`. Health is PK dose (`mass_milli`/`vol_milli`), not a pocket. |
| Local archive | `/Users/richardgillespie/Documents/ERIC_ULTIMATE_ALL_INCLUSIVE_PACKAGE` | **CHARTER WITH ARCHIVE** — measured on disk. Do not copy binaries into Affine. |

The win is the **verified bond**. Edge word on unbound generated mass: ***not known***. This page does not say folding, docking, or thermochemistry is solved.

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.** Skala / float MD / AlphaFold / generated float scores treated as the molecule are a spatial collision: wrong pocket, wrong bond, wrong dose.

**Instructions** on Affine = cited INN / label / PDB–PubChem–ChEMBL–DailyMed id / manufacture *class* + source URL. Not a recipe. C-007: no military, no planetary harm, no synthesis cookbook. This page quotes **paths**, not procedures.

**OPEN stays only 03 SID / 05 NMDB / 08 µas.** ERIC contains none of those archives.

---

## What ERIC actually is (measured 2026-08-24)

ERIC is a **31 MB narrative + generated-candidate package**, not a PDB / SDF / CIF / FASTA / MOL2 / PDF corpus. Walked: 11 top-level folders, **195 files** (101 `json`, 84 `md`, 5 `py`, 5 `csv`). Zero structure files of those scientific types.

The start-here prose (`00_START_HERE_ERIC/PACKAGE_SUMMARY_FOR_DAD.md`) *claims* 1,426,480 materials, 1,540 SOPs, 248 domain guides, and 2,000+ manufacturing documents. **On disk this hour:**

| Top-level | Files | What it is |
|---|---:|---|
| `00_START_HERE_ERIC/` | 2 | Campaign + package summary markdown |
| `01_ULTIMATE_BREAKTHROUGHS/` | 7 | Status / battery narrative (float conductivity claims) |
| `02_MANUFACTURING_READY/` | 51 | 50 domain manufacturing guides + `MASTER_INDEX.md` |
| `03_SYNTHESIS_PROCEDURES/` | 100 | SOP JSON — **C-007 BLOCK** |
| `04_DISCOVERY_RESULTS/` | 13 | 6 narrative md + `VALIDATED_CURES/` CSVs |
| `05_TECHNICAL_CODE/` | 5 | Python generation engines — **MOCK / SIM refuse** |
| `06_TIER1_FOUNDATIONS/` | 4 | Protein-campaign narrative (reports 90,918) |
| `07_ADVANCED_APPLICATIONS/` | 7 | Includes transmutation + synthesis masters — **C-007 BLOCK** on those arms |
| `08_PARTNERSHIPS/` | 4 | CU Boulder / UConn narrative |
| `09_PATENTS_IP/` | 2 | Patent-claim markdown |
| `10_COMPLETE_JOURNEY/` | **0** | Empty directory |

**Local archive that can be hashed (not public Look ids):**

| File | Rows (header excluded) | sha256 |
|---|---:|---|
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/proteins_validated.csv` | **78680** | `bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7` |
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/proteins_validated_safe.csv` | **41391** | `a2ca4777949d77d68acafb60e8c281d06a894e83c72f6e836cad45ac75e71def` |
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/proteins_by_disease.csv` | **1400** | `24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204` |
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/materials_bivqbit_validated.csv` | **37910** | `eba20edffd6aecd8fd00d547deb217828be2ae82ff5e2bb1b16f990cbea17a66` |
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/materials_chemistry_validated.csv` | **8712** | `38fcd2c6048b361a0131843da549cfbbca84eefe921d1f575d28a010f09d6de4` |
| `04_DISCOVERY_RESULTS/VALIDATED_CURES/_export_stats.json` | counts only | `f92fc6adf8b16444b5964f75573ca64913c80ab231786d014d94a08171edd72e` |
| `00_START_HERE_ERIC/PACKAGE_SUMMARY_FOR_DAD.md` | prose | `70ccf2e3b92f2b5b642289c00bf6bcd697db948aebb9bd660247901e04fc85c4` |

Protein `protein_id` samples are generated labels (`Bladder_Cancer_111`, …) — **0** of 78,680 match a 4-character PDB id. Sequence length 42–90, 20-letter amino-acid alphabet, 16 cancer-named domains. Materials ids are `MOLECULE_*` or UUIDs with SMILES + float MW / logP / scores (`method=BiVQbit-EGNN` on all 37,910).

A grep of every `md` / `json` / `csv` / `py` for the words `PDB`, `PubChem`, `CHEMBL`, `DailyMed` returned **no matches**. SID / NMDB / µas / Gaia BH1 tokens are absent.

---

## Grade every arm

| Arm | Grade | Why |
|---|---|---|
| Hosted Affine PDB catalog | **PUBLIC NAMED** (already LOOK) | N=258616 on apex. ERIC does not add ids. |
| ERIC protein / material CSVs | **LOCAL ARCHIVE** + **FLOAT / SHEAR** + **MOCK / SIM** | Files exist and hash. Scores (`confidence`, `coherence`, `overall_score`, `logp`, `molecular_weight`, `combined_score`, …) are floats — Affine `REFUSED_FLOAT`. Rows are engine output, not a fetched public id. Founder rule: zero simulation as a court fact. |
| Integer-looking CSV columns (`length`, `num_atoms`, `hbd`, `hba`, `lipinski_violations`, `passes_safety`, `validation_passed`) | **not CLAIM-READY** | Exact integers on disk, but **no** existing `game_id` accepts them. Not Ehrhart `polytope_id`+`dilation`. Not Falcon clock/track. Not health `mass_milli`/`vol_milli`. Not occupancy. |
| `03_SYNTHESIS_PROCEDURES/*.json` (100) | **C-007 BLOCK** | Keys include `synthesis_procedure.steps`, `precursors`, `yield_expected`. Stop. Do not copy onto this wiki. |
| `02_MANUFACTURING_READY/bio_warfare_protection_MANUFACTURING_GUIDE.md` | **C-007 BLOCK** | Military / pathogen-adjacent. Path quoted. Stop. |
| `02_MANUFACTURING_READY/chem_warfare_protection_MANUFACTURING_GUIDE.md` | **C-007 BLOCK** | Military-adjacent. Stop. |
| `02_MANUFACTURING_READY/explosive_detection_MANUFACTURING_GUIDE.md` | **C-007 BLOCK** | Dual-use. Stop. |
| `02_MANUFACTURING_READY/gene_therapy_vector_MANUFACTURING_GUIDE.md` | **C-007 BLOCK** | Enhancement-adjacent. Stop. |
| Other `02_*_MANUFACTURING_GUIDE.md` (remaining 46 + index) | **C-007 BLOCK** as cookbooks | Manufacturing / scale-up prose. Do not ingest. Cite path only if a public manufacture *class* is later fetched from FDA / EMA / label. |
| `07_ADVANCED_APPLICATIONS/GOLD_TRANSMUTATION_PROTOCOL.md` | **C-007 BLOCK** | Nuclear transmutation protocol. Stop. |
| `07_ADVANCED_APPLICATIONS/B4C_DIAMOND_SYNTHESIS.md` · `B2CN_SUPERCONDUCTOR_SYNTHESIS.md` · `TIER1_MATERIALS_SYNTHESIS_MASTER.md` | **C-007 BLOCK** | Synthesis masters. Stop. |
| `05_TECHNICAL_CODE/*.py` | **MOCK / SIM** | Generation engines (`float` types, candidate loops). Refuse as court facts. |
| `01` / `06` / `08` / `09` narrative | **CITED / SHEAR** | Prose + float claims (e.g. mS/cm). Not a court. |
| SID / NMDB / µas | **absent** | OPEN list unchanged. |

---

## Map onto Affine 01–15 + QCD (no Study 16)

| ERIC family | Affine home | Court today |
|---|---|---|
| Generated protein sequences | Study 14 grammar (cited amino-acid alphabet) — **not** the hosted PDB catalog | CLAIM **DARK** (no occupancy key). Look the **public** PDB index, not these labels. |
| Generated SMILES + float scores | Study 15 shear-danger (same sentence as Skala) | CLAIM **DARK**. Float → HTTP 400 `REFUSED_FLOAT`. |
| PK dose | Study 02 `health` | ERIC has **no** `mass_milli` / `vol_milli`. |
| Lattice volume | Study 11 `geometry` | ERIC has **no** `polytope_id` + `dilation`. |
| Falcon / convective / QPR / Connes / QCD | 02 / 09 / 12 / 13 / QCD | No matching integers. |
| SID / NMDB / µas | 03 / 05 / 08 | ERIC does not supply them. **OPEN unchanged.** |

A new Study 16 is **not** opened. ERIC is a local archive sitting beside Study 14. Occupancy, docking, pocket, codegen, `ProteinManifold.evaluateDocking`, Affine Assembler / binfmt stay **DARK**.

---

## PDB ∩ hosted catalog

**Measured intersection: not computed against the 258616-row file because ERIC has no PDB id set.**

- ERIC `protein_id` values that match `[1-9][A-Za-z0-9]{3}`: **0 / 78680**
- Files containing the words PDB / PubChem / CHEMBL / DailyMed: **0**
- Loading `catalog.json` to intersect an empty id set would invent a count. The honest number is: **ERIC public named ids = 0; already-in-Look = not applicable; new public ids = 0.**

Affine can LOOK today: the hosted PDB catalog and the 17-family ledger. ERIC would be **new ingest only if** a future steward hosts a *separate* local-archive family (hashes + integer `length` only). That row is **not** on `families.json` this hour.

---

## What it will take (sequenced)

### 1. LOOK

1. Keep GET [catalog.json](https://affine.earth/language-game/discoveries/catalog.json) as the public PDB door (`index_n=258616`). Do not merge `Bladder_Cancer_*` or `MOLECULE_*` into that file.
2. Optional next increment (not done this turn): one `families.json` row, e.g. `eric-local-archive`, with measured N (**78680** proteins / **46622** materials), grade `CHARTER WITH ARCHIVE`, court `DARK`, wiki → this page, IDE stays `#discovery-review` (GET). No invented fact sheets.
3. If a sequence catalog is ever hosted: one row per `protein_id` with `length` (Int64) + source = CSV sha256 + role. Drop every float column. Empty source → `REFUSED_UNATTRIBUTED`.
4. Do not copy the 31 MB tree into AppleGaiaFTCL. Point at the absolute path and the hashes above.

### 2. VALIDATE (Claim)

| Existing court | Can it grade an ERIC row today? |
|---|---|
| `health` (Study 02) | **No** — needs `mass_milli`/`vol_milli`. ERIC has neither. Not a pocket. Not ozone. |
| `geometry` (Study 11 Ehrhart) | **No** — no polytope. |
| `physics` (Falcon 02) | **No** — no launch clock/track table. |
| `chance` / `algebra` / `qcd` / `weather` (12 / 13 / QCD / 09) | **No.** |
| Occupancy / residue / pocket | **DARK** — no key on the membrane. `evaluateDocking` stays DARK. |
| Any float score | HTTP 400 `REFUSED_FLOAT`. |

CLAIM-READY today: **almost none.** Integer flags exist on disk and still have no `game_id`.

### 3. DOCUMENT (this page)

- GitHub wiki: [ERIC-Ultimate-Ingest-Review](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/ERIC-Ultimate-Ingest-Review)
- Affine story: [affine.earth #story/ERIC-Ultimate-Ingest-Review](https://affine.earth/language-game/#story/ERIC-Ultimate-Ingest-Review)
- Board: [Language-Games-Study-Board](Language-Games-Study-Board.md)
- Index: [Known-Discoveries-Index](Known-Discoveries-Index.md)
- IDE walk: [#discovery-review](https://affine.earth/language-game/ide.html#discovery-review) · Look panel [#researcher](https://affine.earth/language-game/#researcher) (GET only)

---

## What stays DARK

- Occupancy / complementary pocket / residue voxel
- Docking scores, kcal/mol, RMSD, float MD, Skala-as-molecule
- SID / NMDB / µas (ERIC does not contain them)
- Synthesis SOP JSON and manufacturing cookbooks
- Warfare / transmutation / gene-therapy-vector arms
- Codegen, `ProteinManifold.evaluateDocking`, Affine Assembler / binfmt

---

## Cross-see (GitHub → Affine Look)

LOOK = GET. No identity.

- https://affine.earth/language-game/discoveries/catalog.json
- https://affine.earth/language-game/discoveries/families.json
- https://affine.earth/language-game/#researcher
- https://affine.earth/language-game/ide.html#discovery-review
- https://affine.earth/language-game/ide.html#discoveries-index
- https://affine.earth/language-game/#story/Known-Discoveries-Index
- https://affine.earth/language-game/#story/Language-Games-Study-Board
- https://affine.earth/language-game/#story/Study-14-Protein-Lattice-Manifold
- https://affine.earth/language-game/#story/Study-15-Skala-DFT-Shear
- https://affine.earth/language-game/#story/ERIC-Ultimate-Ingest-Review

---

## What this page does not do

- Does not invent Study 16 or a Claim court
- Does not put synthesis recipes, precursors, or yields on the wiki
- Does not scoop ERIC binaries into Affine
- Does not call Skala / float MD / AlphaFold useless
- Does not say folding is solved
- Does not change OPEN (03 / 05 / 08)
