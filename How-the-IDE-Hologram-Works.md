# How the IDE hologram works

**Status: measured — existing lattice / Franklin canvas. No protein-dock hologram.**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 11 Ehrhart](Study-11-Ehrhart-Volume-Shear.md)

Researchers see a **receipt + the frame that already paints**. Affine does not invent a pdb occupancy hologram. `ProteinManifold.evaluateDocking` is not stubbed.

---

## Hashes that exist (do not invent routes)

| Hash / URL | What GET/POST does | What pixels come from |
|---|---|---|
| [`ide.html#ehrhart-volume`](https://affine.earth/language-game/ide.html#ehrhart-volume) | Template POSTs Study 11 geometry ingest (`polytope_id` + integer `dilation`) | Court receipt in the workspace. No dedicated png on this hash. |
| [`ide.html#gym`](https://affine.earth/language-game/ide.html#gym) | Gym view. Franklin hologram card | `hologram-manifold.js` + `franklin-law-plot.js` paint the gym canvas from sealed A/V attribute URLs |
| [`/language-game/`](https://affine.earth/language-game/) | Main UI stage | Same hologram scripts. `#capture` records the canvas via `captureStream` |
| `GET /language-invariant/game/proteins/frame?w=512&h=512&t=800` | Integer `w`/`h`/`t` query | LatticeRender protein-fold raster (NP-hard catalog `protein-fold`). **Not** a pdb dock. |
| `GET /language-invariant/game/materials/frame?w=512&h=512&t=600` | same pattern | Crystal lattice raster. Not a manufacture cookbook. |
| `GET /language-invariant/game/geometry/context` | Study 11 roles | JSON, not pixels |
| `#complex-pair` · `#rife-frequency` · `#pdb-holdings` | POST industry keys | After WIN the HUD `<img>` loads the **existing** proteins frame above. Caption says so. |

`backdrop-filter` on the IDE chrome is CSS blur. It is not a hologram `filter:` law and was not changed.

---

## After a WIN (pdb / complex / rife)

The court HUD:

1. POSTs `/language-invariant/game/{domain}/ingest` with `source`+`role`
2. Writes the JSON receipt
3. If HTTP 2xx, sets `img.src` to `/language-invariant/game/proteins/frame?w=512&h=512&t=800`

That frame is the **already-live** lattice raster. It is not a hologram of 2HYY. It is not occupancy. A researcher sees the claim receipt and the live lattice in the same workspace.

Wiki door: [Study 11](Study-11-Ehrhart-Volume-Shear.md) · IDE [`#ehrhart-volume`](https://affine.earth/language-game/ide.html#ehrhart-volume).

---

## What this page does not do

- Does not invent a `#protein-dock` hash
- Does not stub `ProteinManifold.evaluateDocking`
- Does not claim the proteins frame is the presented PDB
- Does not add an MCP tool
