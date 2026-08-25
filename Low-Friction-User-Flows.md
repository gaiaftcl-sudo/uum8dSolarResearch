# Low-friction user flows

**Status: measured 2026-08-25 — one story, every step a curl or a live button.**  
**Start:** https://affine.earth/language-game/ → https://affine.earth/language-game/ide.html#chooser  
**Hologram:** [How the IDE hologram works](How-the-IDE-Hologram-Works.md)  
**Doors:** [Discoveries by user](Discoveries-By-User.md)

A stranger walks **one path**: Home → chooser (who I am) → **Open this door** → catalog or court with the sample already filled → that tap POSTs (or Look GETs) → **WIN + hologram + receipt on one screen** → this wiki, one paragraph, is what the seal meant.

FoT is the base. Chooser is the first screen. One tap per user type (**Open this door**) lands on a court that already has sample buttons. Look never asks for identity. Claim POSTs `source`+`role` in the body — there is no login form. After WIN the receipt and the existing lattice frame sit on the same HUD.

Evidence: `evidence/discovery-app-hologram-flow-20260825/CAPTURES.md`

Hologram URL (same after Look and after every WIN):

`GET https://affine.earth/language-invariant/game/proteins/frame?w=512&h=512&t=800`

Measured this hour: HTTP **200**, `application/octet-stream`, **1048576** bytes, sha256 `a3f6f2bb6f73078c10b411fbcf1e4bfcc694d591e27c8c06a0f7342fe414235e`. Same sha after pdb 4HHB WIN and after complex 2HYY+5291 WIN. `t=800` did not change. Earlier hour `c4dae839…5ddd4` was the previous raster at the same URL.

---

## Researcher — LOOK

**URL:** https://affine.earth/language-game/ide.html#chooser → **Open this door** on Researcher · or https://affine.earth/language-game/#researcher · or https://affine.earth/language-game/ide.html#protein-material-look

| Step | Button / action | Capture |
|---|---|---|
| 1 | Open `#chooser` | GET `ide.html` HTTP **200** |
| 2 | Tap **Open this door** on Researcher | hash `#protein-material-look` or home `#researcher` |
| 3 | Page GETs holdings catalog | GET `discoveries/catalog.json` HTTP **200** · `index_n=258616` · `ids` 258616 |
| 4 | Page GETs aggregates | GET `protein-material-aggregates.json` HTTP **200** · `index_n=125302` (78680 + 46622) |
| 5 | Lattice frame appears | GET proteins/frame HTTP **200** · sha256 `a3f6f2bb…14235e` |

Identity: **omit**. No POST. Sample buttons on the IDE Look are **Play #pdb-holdings**, **Play #disease-icd**, **Play #chemistry-inchi**, **Play #material-std**, **Play #stellar-dynamo**, **kill shot** — they change hash or open the kill-shot story. They do not POST a generated label.

Hologram: **yes** (after catalog GET). No Claim required.

**What this meant:** the researcher is looking at the hosted holdings index and the live lattice raster. The frame is not a pdb dock. Catalog N is 258616, not a minted fact sheet.

---

## Disease / protein — CLAIM

**URLs:** https://affine.earth/language-game/ide.html#disease-icd · https://affine.earth/language-game/ide.html#pdb-holdings

### Disease

| Step | Button / action | Capture |
|---|---|---|
| 1 | Chooser → **Open this door** on Disease / protein · or hash `#disease-icd` | court HUD mounts; input already `C67` |
| 2 | Door-open POSTs the filled sample, or tap **C67 · DOID:11054** / **POST selected** | POST `/language-invariant/game/disease/ingest` `{source:researcher, role:clinician, icd:C67, doid:DOID:11054}` |
| 3 | Receipt | HTTP **200** · `lattice_court.verdict=WIN` · `status=CALORIE_GAME_INGEST` · `proven_marker=STUDY16_DISEASE_ICD_PROVEN` |
| 4 | Hologram | proteins/frame HTTP **200** · sha256 `a3f6f2bb…14235e` · HUD `<img id="courtPlayHologramImg">` unhides |

C50 this hour: tap **C50 · DOID:1612** → HTTP **200** WIN `STUDY16_DISEASE_ICD_PROVEN`.

Refuse (process match):

| Button / body | Capture |
|---|---|
| **Refuse example** → `icd=Bladder_Cancer_111` | HTTP **400** · `REFUSED_NO_STD` |
| POST with `source=""` | HTTP **400** · `REFUSED_UNATTRIBUTED` · reason `POST must name source — absence is recorded, not defaulted` |

Hologram on refuse: **not shown**.

**What this meant:** C67 / C50 are playable ICD keys. A generated nickname is not a key. Affine does not write a treatment protocol.

### Protein

| Step | Button / action | Capture |
|---|---|---|
| 1 | Hash `#pdb-holdings` | GET catalog HTTP **200** `index_n=258616` · input already `4HHB` |
| 2 | Door-open POSTs **4HHB**, or tap **4HHB** / **2HYY** / **POST selected** | POST `/language-invariant/game/pdb/ingest` `{source:researcher, role:crystallographer, pdb_id}` |
| 3 | 4HHB | HTTP **200** WIN `STUDY14_PDB_HOLDINGS_PROVEN` |
| 3b | 2HYY | HTTP **200** WIN `STUDY14_PDB_HOLDINGS_PROVEN` |
| 4 | Hologram | proteins/frame · same sha · HUD figure unhides |

**Refuse example** `ZZZZ` → HTTP **400** `REFUSED_NO_STD`. Occupancy stays DARK. Health is PK dose.

Charter: [Study 16](Study-16-Disease-Type.md) · [Study 14](Study-14-Protein-Lattice-Manifold.md)

**What this meant:** the bond is holdings membership of a presented 4-char id. The hologram is the lattice raster, not 4HHB docked.

---

## Chemist — CLAIM

**URL:** https://affine.earth/language-game/ide.html#chemistry-inchi

| Step | Button / action | Capture |
|---|---|---|
| 1 | Chooser → **Open this door** on Chemist | input already `2244` |
| 2 | Door-open POSTs the filled sample, or tap **CID 2244** / **POST selected** | POST `/language-invariant/game/chemistry/ingest` `{source:researcher, role:chemist, cid:2244, inchikey:BSYNRYMUTXBXSQ-UHFFFAOYSA-N, hbd:1, hba:4, lipinski_violations:0}` |
| 3 | Receipt | HTTP **200** WIN `STUDY17_CHEMISTRY_INCHI_PROVEN` |
| 4 | Hologram | **yes** — chemistry uses lattice frame proteins/frame (caption on the HUD). Not a molecule dock. sha256 `a3f6f2bb…14235e` |

Charter: [Study 17](Study-17-Chemistry-InChIKey.md)

**What this meant:** CID 2244 is a public compound identity. The win is the verified InChIKey/CID bond, not a pose.

---

## Materials — CLAIM

**URL:** https://affine.earth/language-game/ide.html#material-std

| Step | Button / action | Capture |
|---|---|---|
| 1 | Chooser → **Open this door** on Materials | input already `9008564` |
| 2 | Door-open POSTs the filled sample, or tap **Diamond — COD 9008564** / **Graphite — COD 9008569** | POST `/language-invariant/game/material/ingest` |
| 3 | 9008564 | HTTP **200** WIN `STUDY18_MATERIAL_STD_PROVEN` |
| 3b | 9008569 | HTTP **200** WIN `STUDY18_MATERIAL_STD_PROVEN` |
| 4 | Hologram | **yes** — HUD loads proteins/frame (same URL as every WIN). Crystal raster `materials/frame` exists; HUD does not swap to it. |

No synthesis steps. Charter: [Study 18](Study-18-Material-STD.md)

**What this meant:** diamond / graphite play as cited COD ids. Affine does not host a membrane recipe.

---

## Builder / pair — CLAIM

**URL:** https://affine.earth/language-game/ide.html#complex-pair

| Step | Button / action | Capture |
|---|---|---|
| 1 | Hash `#complex-pair` | inputs already `2HYY` + `5291` |
| 2 | Door-open POSTs the filled sample, or tap **2HYY + 5291 imatinib** / **POST selected** | POST `/language-invariant/game/complex/ingest` `{source:researcher, role:researcher, pdb_id:2HYY, cid:5291}` |
| 3 | Receipt | HTTP **200** WIN `COMPLEX_PAIR_KEYS_PROVEN` · cited Abl kinase + imatinib |
| 4 | Hologram | proteins/frame · same sha after this WIN as after pdb 4HHB |

Two industry keys. Not a dock. 1N8Z has no invented ligand CID.

**What this meant:** two keys that already pass their own courts are appointed. Complementary occupancy stays DARK.

---

## Rife — test claim

**URL:** https://affine.earth/language-game/ide.html#rife-frequency

| Step | Button / action | Capture |
|---|---|---|
| 1 | Hash `#rife-frequency` | input already `440` |
| 2 | Tap **440 Hz ISO 16 A440** or **POST selected** | POST `{source:researcher, role:researcher, hz:440, cited_id:iso16-a440}` |
| 3 | Receipt | HTTP **200** WIN `STUDY20_RIFE_INTEGER_FREQUENCY_CLAIM` · `efficacy=TEST_CLAIM_NOT_EFFICACY` |
| 4 | Hologram | proteins/frame · same sha |
| 5 | **Refuse example** | POST `{hz:432.0}` → HTTP **400** `REFUSED_FLOAT` · hologram not shown |

Test claim, not efficacy. Affine does not write that a frequency kills cancer. Charter: [Study 20](Study-20-Rife-Frequency.md)

---

## Stellar dynamo — integer step

**URL:** https://affine.earth/language-game/ide.html#chooser → **Open this door** on Astrophysicist · or https://affine.earth/language-game/ide.html#stellar-dynamo  
**LOOK door:** `#researcher` **kill shot** · SHARE: Discoveries-By-User **kill shot**

| Step | Button / action | Capture |
|---|---|---|
| 1 | Chooser → **Open this door** on Astrophysicist · or hash `#stellar-dynamo` | input already `0,1` + `1/2` · HUD title Stellar dynamo |
| 2 | Tap **Z2_a2b (0,1) + 1/2** or **POST selected** | POST `{source:researcher, role:researcher, q:0, r:1, n:1, d:2, cited_id:z2-a2b-half-step}` |
| 3 | Receipt | HTTP **200** WIN `STUDY21_DYNAMO_INTEGER_STEP` linking `(0,1)` spin `1/2` |
| 4 | Hologram | proteins/frame after WIN · sha256 `a3f6f2bb…14235e` |
| 5 | **Refuse example** | POST `{k:0.15}` → HTTP **400** `REFUSED_FLOAT` · hologram not shown |

Court, not a Kepler/TESS B. Study 09 convective is a different court. Charter: [Study 21](Study-21-Stellar-Dynamo-Shear.md) · [kill shot](Impact-Study-Stellar-Dynamo-Kill-Shot.md)

---

## Manufacture — LOOK

**URL:** https://affine.earth/language-game/ide.html#manufacture-look

| Step | Button / action | Capture |
|---|---|---|
| 1 | Hash `#manufacture-look` | GET `manufacture-contracts.json` HTTP **200** · 6 family contracts |
| 2 | Tap a family chip (`disease · CLASS_ABSENT`, `pdb · CLASS_ABSENT`, `chemistry · chemical`, `material · extracted`, `complex · CLASS_ABSENT`, `rife · optical-test`) | receipt shows CLASS + sha256 · **zero steps** |
| 3 | Lattice frame appears | GET proteins/frame HTTP **200** · same sha · HUD unhides after contracts GET |
| 4 | **POST selected** | HUD text: `Look never POSTs a cookbook. GET the contract JSON.` |

Hologram: **yes** (Look, after contracts GET — not a WIN ingest).

Charter: [Manufacture contracts](Manufacture-Contracts.md)

**What this meant:** CLASS + sha256 is the Look. Zero steps. The frame is the same lattice raster every other door uses.

---

## Press — SHARE

| Step | Action | Capture |
|---|---|---|
| 1 | GitHub wiki Home | GET https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki HTTP **200** |
| 2 | [Discoveries by user](Discoveries-By-User.md) | GET `…/wiki/Discoveries-By-User` HTTP **200** |
| 3 | One IDE hash from that table | e.g. `#stellar-dynamo` or Astrophysicist **Open this door** |
| 4 | Kill shot SHARE | [Impact-Study-Stellar-Dynamo-Kill-Shot](Impact-Study-Stellar-Dynamo-Kill-Shot.md) · `#story/Impact-Study-Stellar-Dynamo-Kill-Shot` |

Affine story copies: https://affine.earth/language-game/#story/Low-Friction-User-Flows · `#story/How-the-IDE-Hologram-Works` · `#story/Home` · `#story/Discoveries-By-User` · `#story/Known-Molecular-Discoveries` · `#story/Study-14-Protein-Lattice-Manifold`

---

## Flow table (this hour)

| User | URL | Capture verdict | Hologram |
|---|---|---|---|
| Researcher LOOK | `#researcher` / `#protein-material-look` | GET catalog 258616 HTTP 200 | sha256 `a3f6f2bb…14235e` |
| Disease | `#disease-icd` C67 / C50 | WIN `STUDY16_DISEASE_ICD_PROVEN` | same sha |
| Protein | `#pdb-holdings` 4HHB / 2HYY | WIN `STUDY14_PDB_HOLDINGS_PROVEN` | same sha |
| Chemist | `#chemistry-inchi` 2244 | WIN `STUDY17_CHEMISTRY_INCHI_PROVEN` | same sha · caption: chemistry uses lattice frame |
| Materials | `#material-std` 9008564 / 9008569 | WIN `STUDY18_MATERIAL_STD_PROVEN` | same sha |
| Builder / pair | `#complex-pair` 2HYY+5291 | WIN `COMPLEX_PAIR_KEYS_PROVEN` | same sha |
| Rife | `#rife-frequency` 440 | WIN `STUDY20_RIFE_INTEGER_FREQUENCY_CLAIM` | same sha |
| Rife refuse | 432.0 | `REFUSED_FLOAT` | not shown |
| Dynamo | chooser Astrophysicist → `#stellar-dynamo` (0,1)+1/2 | WIN `STUDY21_DYNAMO_INTEGER_STEP` | same sha |
| Dynamo refuse | k=0.15 | `REFUSED_FLOAT` | not shown |
| Disease refuse | `Bladder_Cancer_111` | `REFUSED_NO_STD` | not shown |
| Protein refuse | `ZZZZ` | `REFUSED_NO_STD` | not shown |
| Empty source | `source=""` | `REFUSED_UNATTRIBUTED` | not shown |
| Manufacture | `#manufacture-look` | GET contracts HTTP 200 · n=6 · no steps | same sha (Look) |
| Press | GitHub Home → Discoveries-By-User **kill shot** + `#stellar-dynamo` | HTTP 200 | — |

---

## What this page does not do

- Does not invent a walk the IDE does not do
- Does not write “Affine cured cancer”
- Does not host occupancy / docking / SOP recipe bodies
- Does not collapse 258616 and 125302
