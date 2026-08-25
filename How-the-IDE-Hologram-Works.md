# How the IDE hologram works

**Status: measured 2026-08-25 — existing lattice frame. No protein-dock hologram.**  
**Walks:** [Low-friction user flows](Low-Friction-User-Flows.md) · [Study 11 Ehrhart](Study-11-Ehrhart-Volume-Shear.md)

Researchers and claimants see a **receipt + the frame that already paints**. Affine does not invent a pdb occupancy hologram. `ProteinManifold.evaluateDocking` is not stubbed.

---

## Validated capture this hour

`GET https://affine.earth/language-invariant/game/proteins/frame?w=512&h=512&t=800`

| Field | Measured 2026-08-25T12:45:44Z · nbg-01 |
|---|---|
| HTTP | **200** |
| `content-type` | `application/octet-stream` |
| Byte length | **1048576** (512 × 512 × 4 RGBA) |
| sha256 | `c4dae839391998605fa264d7622aa688f3f4e463432febe88e44e7872756ddd4` |
| `x-affine-game` | `proteins` |
| `x-gop-width` / `x-gop-height` | 512 / 512 |
| `x-affine-game-step` | 800 |
| `x-gop-order` | RGBA |

This is the **same URL** the court HUD `<img id="courtPlayHologramImg">` loads after a Look catalog GET and after every WIN. It is not a hologram of 4HHB or 2HYY. It is the live LatticeRender protein-fold raster.

A second existing raster (not what the HUD loads after WIN):

`GET /language-invariant/game/materials/frame?w=512&h=512&t=600` — HTTP 200, octet-stream, 1048576 bytes, sha256 `cd806d8a4d5848e10b02c09bc8b81f6ef63ce851d553fb8101ce275d09f3e8e0`. Chemistry / materials WIN still load **proteins/frame**. The HUD caption says so.

Evidence: `evidence/keep-going-dynamo-flows-20260825/` · earlier walk `evidence/low-friction-flows-20260825/CAPTURES.md`

`backdrop-filter` on the IDE chrome is CSS blur. It is not a hologram `filter:` law and was not changed.

---

## When the frame appears

| Surface | When `img.src` is set | Requires Claim POST? |
|---|---|---|
| `#researcher` (home Look) | After GET catalog.json HTTP 200 `index_n=258616` | **no** |
| `#protein-material-look` | After GET catalog.json HTTP 200 `index_n=258616` | **no** |
| `#disease-icd` · `#pdb-holdings` · `#chemistry-inchi` · `#material-std` · `#complex-pair` · `#rife-frequency` · `#stellar-dynamo` | After ingest HTTP 2xx (WIN / CALORIE) | **yes** — sample button or **POST selected** |
| `#manufacture-look` | never — Look contracts only | no POST, no frame |
| Refuse (`REFUSED_NO_STD` / `REFUSED_FLOAT` / `REFUSED_UNATTRIBUTED`) | frame stays hidden | — |

---

## Hashes that exist (do not invent routes)

| Hash / URL | What GET/POST does | What pixels come from |
|---|---|---|
| [`ide.html#chooser`](https://affine.earth/language-game/ide.html#chooser) | First screen. **Open this door** | none until a court mounts |
| [`#researcher`](https://affine.earth/language-game/#researcher) | GET catalog + games. credentials omit | proteins/frame after catalog 200 |
| [`#protein-material-look`](https://affine.earth/language-game/ide.html#protein-material-look) | GET catalog 258616 + aggregates 125302 | same proteins/frame |
| [`#ehrhart-volume`](https://affine.earth/language-game/ide.html#ehrhart-volume) | Template POSTs Study 11 geometry | Court receipt. No dedicated png on this hash. |
| [`#gym`](https://affine.earth/language-game/ide.html#gym) | Gym view. Franklin hologram card | `hologram-manifold.js` + `franklin-law-plot.js` |
| [`/language-game/`](https://affine.earth/language-game/) | Main UI stage | Same hologram scripts. `#capture` records the canvas |
| `#disease-icd` · `#pdb-holdings` · `#chemistry-inchi` · `#material-std` · `#complex-pair` · `#rife-frequency` · `#stellar-dynamo` | POST industry key + source+role | After WIN: proteins/frame |

---

## After a WIN

The court HUD:

1. POSTs `/language-invariant/game/{domain}/ingest` with `source`+`role` (sample button fills and POSTs; or tap **POST selected**)
2. Writes the JSON receipt on the same page
3. If HTTP 2xx, sets `img.src` to `/language-invariant/game/proteins/frame?w=512&h=512&t=800`

Meaning = seal + frame. No training paragraph required. Dynamo WIN uses this same proteins/frame — integer step seal + frame, not a stellar-surface hologram.

---

## What this page does not do

- Does not invent a `#protein-dock` hash
- Does not stub `ProteinManifold.evaluateDocking`
- Does not claim the proteins frame is the presented PDB
- Does not add an MCP tool
- Does not change hologram `filter:` / `backdrop-filter`
