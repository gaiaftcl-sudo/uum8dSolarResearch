# How the IDE hologram works

**Status: measured 2026-08-25 — existing lattice frame. No protein-dock hologram.**  
**Walks:** [Low-friction user flows](Low-Friction-User-Flows.md) · [Study 11 Ehrhart](Study-11-Ehrhart-Volume-Shear.md)

Researchers and claimants see a **receipt + the frame that already paints**. Affine does not invent a pdb occupancy hologram. `ProteinManifold.evaluateDocking` is not stubbed.

Meaning = **integer seal + lattice raster**. Not a training deck. Not a molecule dock. Not a stellar surface.

---

## Validated capture this hour

`GET https://affine.earth/language-invariant/game/proteins/frame?w=512&h=512&t=800`

| Field | Measured 2026-08-25T21:14:06Z · nbg-01 |
|---|---|
| HTTP | **200** |
| `content-type` | `application/octet-stream` |
| Byte length | **1048576** (512 × 512 × 4 RGBA) |
| sha256 | `a3f6f2bb6f73078c10b411fbcf1e4bfcc694d591e27c8c06a0f7342fe414235e` |
| `x-affine-game` | `proteins` |
| `x-gop-width` / `x-gop-height` | 512 / 512 |
| `x-affine-game-step` | 800 |
| `x-gop-order` | RGBA |

Same sha after pdb 4HHB WIN and after complex 2HYY+5291 WIN. `t=800` did not change. Earlier hour `c4dae839391998605fa264d7622aa688f3f4e463432febe88e44e7872756ddd4` was the previous raster at this same URL.

This is the **same URL** the court HUD `<img id="courtPlayHologramImg">` loads after a Look catalog GET and after every WIN. Home Look `#researcher` loads the same URL into `<img id="researcherHologramImg">`. It is not a hologram of 4HHB or 2HYY. It is the live LatticeRender protein-fold raster.

A second existing raster (not what the HUD loads after WIN):

`GET /language-invariant/game/materials/frame?w=512&h=512&t=600` — HTTP 200, octet-stream, 1048576 bytes. Chemistry / materials WIN still load **proteins/frame**. The HUD caption says so.

Evidence: `evidence/discovery-app-hologram-flow-20260825/`

`backdrop-filter` on the IDE chrome is CSS blur. It is not a hologram `filter:` law and was not changed.

---

## When the frame appears

| Surface | When `img.src` is set | Requires Claim POST? |
|---|---|---|
| `#researcher` (home Look) | After GET catalog.json HTTP 200 `index_n=258616` | **no** |
| `#protein-material-look` | After GET catalog.json HTTP 200 `index_n=258616` | **no** |
| `#manufacture-look` | After GET manufacture-contracts.json HTTP 200 (n=6) | **no** |
| `#disease-icd` · `#pdb-holdings` · `#chemistry-inchi` · `#material-std` · `#complex-pair` · `#rife-frequency` · `#stellar-dynamo` | After ingest HTTP 2xx (WIN / CALORIE) — door-open sample POST or **POST selected** | **yes** for Claim doors |
| Refuse (`REFUSED_NO_STD` / `REFUSED_FLOAT` / `REFUSED_UNATTRIBUTED`) | frame stays hidden | — |

Process:

1. Court HUD or Look GETs/POSTs.
2. `court-play.js` `showExistingHologram` (and `ide-controller.js` `paintWin` after the filled-sample POST) writes the JSON receipt on the same page.
3. If HTTP 2xx (or Look catalog/contracts 200), sets `img.src` to `/language-invariant/game/proteins/frame?w=512&h=512&t=800` and unhides `#courtPlayHologram`.

---

## Hashes that exist (do not invent routes)

| Hash / URL | What GET/POST does | What pixels come from |
|---|---|---|
| [`ide.html#chooser`](https://affine.earth/language-game/ide.html#chooser) | First screen. **Open this door** | none until a court mounts |
| [`#researcher`](https://affine.earth/language-game/#researcher) | GET catalog + games. credentials omit | proteins/frame after catalog 200 |
| [`#protein-material-look`](https://affine.earth/language-game/ide.html#protein-material-look) | GET catalog 258616 + aggregates 125302 | same proteins/frame |
| [`#manufacture-look`](https://affine.earth/language-game/ide.html#manufacture-look) | GET contracts n=6. Zero steps | same proteins/frame after GET |
| [`#ehrhart-volume`](https://affine.earth/language-game/ide.html#ehrhart-volume) | Template POSTs Study 11 geometry | Court receipt. No dedicated png on this hash. |
| [`#gym`](https://affine.earth/language-game/ide.html#gym) | Gym view. Franklin hologram card | `hologram-manifold.js` + `franklin-law-plot.js` |
| [`/language-game/`](https://affine.earth/language-game/) | Main UI stage | Same hologram scripts. `#capture` records the canvas |
| `#disease-icd` · `#pdb-holdings` · `#chemistry-inchi` · `#material-std` · `#complex-pair` · `#rife-frequency` · `#stellar-dynamo` | POST industry key + source+role | After WIN: proteins/frame |

---

## After a WIN

The court HUD:

1. POSTs `/language-invariant/game/{domain}/ingest` with `source`+`role` (door-open fills and POSTs the sample; or tap a sample chip / **POST selected**)
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
