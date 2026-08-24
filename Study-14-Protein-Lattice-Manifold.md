# Study 14 — Protein lattice manifold

**Status: LOOK LIVE · CHARTER WITH ARCHIVE · CLAIM DARK — 2026-08-24**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 15 — Skala DFT shear](Study-15-Skala-DFT-Shear.md) · [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm.md)

| Surface | URL / key | Cited vs sealed |
|---|---|---|
| Look | https://affine.earth/language-game/#researcher · [catalog GET](https://affine.earth/language-game/discoveries/catalog.json) | GET only. credentials omit. |
| Review ledger | [Known molecular discoveries](Known-Molecular-Discoveries.md) · IDE `#discovery-review` | **LOOK LIVE** — measured PDB holdings **258616** VERIFIED 2026-08-24. Claim stays **DARK**. |
| Court | none — no occupancy / residue / pocket key on the running membrane | **DARK** |
| `health` court | `mass_milli` / `vol_milli` | PK **dose**. Not a binding pocket. Not ozone. |
| Study 11 `geometry` | `polytope_id` + `dilation` | Ehrhart volume. **Not** a protein fold. |
| Humanity | Small- and large-molecule discovery without a moving DFT baseline | **Using something that is not accurate (because it shears) may not be useless — it may be dangerous.** |

The win is the **verified bond**, not custody of a fold and not a true/false “discovery” bit. Pocket Claim stays **DARK** until an integer occupancy key exists and a prove seals it. Honest edge word on unbound mass / fold: ***not known***.

---

## For every reader — one paragraph

A protein is a chain written in a **cited** finite alphabet. Affine.Earth’s intended game is lattice occupancy — each voxel is 0 or 1 — and a peptide appointment as an exact rational Jordan link. That game is **not** implemented as a court today. Cryo-EM / X-ray density quantized to occupancy is the *intended* ingest. Complementary occupancy (ligand 1s ⊂ pocket 0s) is the *shape of the game*, not an O(1) engine. AlphaFold is the adversary (predicted float coordinates), not our method. This page does **not** say folding is solved, and it does **not** land a docking stub.

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.** A kcal/mol miss or a moving XC baseline treated as the molecule is a spatial collision: wrong pocket, wrong bond, wrong dose.

---

## The shear recipe (this study)

| Piece | Instantiation |
|---|---|
| **Forcing / track** | Residue sequence in the cited amino-acid alphabet; intended lattice occupancy 0/1 on an integer grid |
| **Clock** | Residue index along the chain (appointment), not a float torsion sweep |
| **Raw archive** | **Intended:** public Cryo-EM / X-ray density maps quantized once to occupancy. **DARK** until a key exists. Do not hallucinate a PDB ingest. |
| **Adversary** | AlphaFold / float MD / DFT+DL (Skala and kin) — continuously improving functionals and predicted coordinates treated as the molecule |
| **Law (to freeze at corpus)** | Complementary occupancy is the shape: ligand occupied cells sit inside pocket empty cells. No runtime force field. No `evaluateDocking` court. |

**Verdict language (when a key exists — not today):**

- **WIN (lattice):** occupancy appointment holds as exact integers; residue 0 or `REFUSED_FLOAT`
- **MISS (adversary):** a sheared kcal/mol or a predicted fold treated as the sealed molecule
- **VOID:** incomplete map inventory, or a float on the wire

Ingest: dedicated corpus only, quantize once — **never** float-thrash into core OS or NATS. Ledger burn of the amino-acid alphabet is a **NEXT increment**, not claimed done.

---

## Cited alphabet — not a ledger burn

The twenty genetically encoded amino acids are a **cited** macro-alphabet, not a court key and not a sealed burn.

| Citation | What it names | Fetched |
|---|---|---|
| IUPAC–IUB JCBN, *Nomenclature and Symbolism for Amino Acids and Peptides*, Recommendations 1983, *Eur. J. Biochem.* **138**, 9–37 (1984); also *Pure Appl. Chem.* **56**, 595–624 (1984) | One- and three-letter codes for the coded amino acids and peptides | **cited** (standard nomenclature; not a membrane ingest) |

A future ledger row that burns those codes is a next increment. This charter does not claim that burn.

---

## Peptide appointment vs float torsion

A 1 000-residue chain graded by float backbone torsion accumulates IEEE-754 shear: the same sequence replayed on two libm versions is not the same bit pattern. Affine’s *intended* appointment is an exact rational Jordan link along the chain — residue *i* bonded to residue *i*+1 as a sealed pair, not a force-field energy.

That appointment is **not** a runtime force field and **not** a court today. Study 13’s algebra court grades named words (`Z2_a2b`), not peptides. Do not POST a residue string into `algebra`.

---

## Cryo-EM / X-ray — intended ingest, DARK

Empirical density (Cryo-EM potential, X-ray electron density) is the archive this charter wants: quantize once onto the lattice as occupancy 0/1. That is the opposite of AlphaFold. AlphaFold emits predicted coordinates; we reject it as **our** method. It remains the named adversary — a continuously improving float fold treated as the molecule.

No occupancy key exists on `LatticeDomainIntegration` this hour. Geometry is Ehrhart (`polytope_id` + `dilation`). Health is dose (`mass_milli` / `vol_milli`). Frame “occupancy” in the games server is pixel coverage of a raster, not a residue voxel. **DARK.**

---

## Ligand / pocket — shape of the game, not an engine

Complementary occupancy is the grammar:

- pocket empty cells (0) are the volume a ligand may occupy
- ligand occupied cells (1) must sit inside those 0s
- clash = ligand 1 on a protein 1

That is the **shape**. It is not an implemented O(1) SQLite lookup, not a millisecond dock, and not `ProteinManifold.evaluateDocking`. Honest word until a key exists and a prove seals it: ***not known***. Pocket Claim stays DARK.

---

## Small molecule vs large molecule (same grammar, two scales)

One page, two scales. A third study number is not required.

| Scale | What the appointment would name | What stays cited / DARK |
|---|---|---|
| **Small molecule** | Ligand occupancy vs a declared pocket mask; dose still `health` `mass_milli`/`vol_milli` | No pocket key. Health is not the pocket. |
| **Large molecule / biologic** | Chain appointment (Jordan link) + fold occupancy vs a Cryo-EM mask | No residue key. AlphaFold is the adversary, not the method. |

Humanity: discovery without a moving DFT baseline. The same four Falcon acts apply — Look, Claim, Build, Share — once a key exists. Today Look is the public catalog; Share is this wiki + the GET record; Claim stays DARK; Build is the IDE template that opens a fetched record.

---

## Review ledger — how a researcher walks thousands of named public discoveries

This is Look → Claim → Build → Share applied to a **public discovery ledger**. It does not invent rows. It does not write a cookbook.

| Act | What happens | Status this hour |
|---|---|---|
| **LOOK** | `GET /language-game/discoveries/catalog.json` — index of public PDB ids + source URL template. No visitor data. `credentials: omit`. | **LIVE** — hosted `index_n=258616` from RCSB holdings HTTP 200, fetched 2026-08-24T17:13:23Z. Example fact sheets (4HHB, aspirin CID 2244 / CHEMBL25, DailyMed insulin human) are fields that came from those fetches. |
| **CLAIM** | Integer appointment about a *named* discovery (id, occupancy class, dose if health court). `source`+`role`. | **DARK** — no occupancy / residue / pocket key. Health `mass_milli`/`vol_milli` is PK dose, not this molecule. |
| **BUILD** | IDE template `#discovery-review` GETs the catalog and opens one record (id, name, source URL, manufacture class when the source stated it, known-facts from the fetch). | **LIVE** template. No hallucinated IC50. |
| **SHARE** | Receipt names `source`. GET view of the record (this wiki + the catalog JSON). | **LIVE** GET |

**Instructions** means public, labeled, cited: INN, indication (on the source document), PDB / PubChem / ChEMBL / DailyMed id, manufacture *class* (recombinant / chemical / extracted) from FDA / EMA / label / PDB, and links to that document. It does **not** mean a step-by-step synthesis. C-007: no pathogen enhancement, no military, no unpublished manufacture.

Walk: [Known molecular discoveries](Known-Molecular-Discoveries.md) · [catalog JSON](https://affine.earth/language-game/discoveries/catalog.json) · [IDE `#discovery-review`](https://affine.earth/language-game/ide.html#discovery-review) · Look panel [\#researcher](https://affine.earth/language-game/#researcher) (GET links only).

### Skala contrast (one paragraph)

Sheared tools — Skala, float MD, AlphaFold — are **not accurate due to shear**. Using them as the molecule **may be dangerous**: a kcal/mol miss or a predicted fold treated as the sealed structure is a spatial collision (wrong pocket, wrong bond, wrong dose). They are not called useless. Study 15 cites their GMTKN55 **2.72 / 2.8 kcal/mol** from their pages. Affine refuses the float or seals the integer. Pocket Claim stays DARK. Honest edge word on an unbound fold: ***not known***.

---

## What this page does not do

- Does not write `ProteinManifold.evaluateDocking` or a true/false discovery court
- Does not write Affine Assembler / string ALU / `binfmt` (Debian is HAL; law is the Swift membrane)
- Does not claim docking is a millisecond O(1) solved problem
- Does not claim Affine solved folding
- Does not call Skala, DFT+DL, float MD, or AlphaFold **useless** — they shear; using the shear as the molecule **may be dangerous**
- Does not POST Study 11 geometry as a protein fold
- Does not treat the health court as a binding pocket
- Does not invent discovery rows or IC50
- Does not write a synthesis cookbook — instructions are source links + cited manufacture class

Cross-link: [Study 15](Study-15-Skala-DFT-Shear.md) · [Known molecular discoveries](Known-Molecular-Discoveries.md) measures Skala 1.1 from their pages and contrasts methods. Edge word on unbound mass / fold remains ***not known***.

---

**Status: LOOK LIVE · CHARTER WITH ARCHIVE · CLAIM DARK.** Occupancy integers are absent so Claim stays DARK. OPEN is false — the PDB id list is ingested.
