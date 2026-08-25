# Build a study on Affine.Earth — Falcon walkthrough

**Status: teaching surface — claim page and IDE template are live.** **DATA this morning:** Falcon 9 Starlink Group 10-49 lifted **2026-08-25T09:33:38Z** from SLC-40. One tap: [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html) · [ide.html#falcon-damage](https://affine.earth/language-game/ide.html#falcon-damage) · charter [Study 02](Study-02-Launch-Ionospheric-Holes.md) · [regulatory alarm](Study-02-Regulatory-Alarm.md) (package ready, no receipt id). Float heatmap is the old court. 900 km is **cited / not measured**. IGR waits **~2026-08-26T17:00Z**.

**This page teaches. The prove plan tests.** The test contract is [Researcher IDE + court loop — test plan](Researcher-IDE-Test-Plan.md). Claim UI: [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html). IDE template: [ide.html#falcon-damage](https://affine.earth/language-game/ide.html#falcon-damage). This page does not fork a second UI. Every other shear study is graded on the [language-games study board](Language-Games-Study-Board.md) — live vs DARK, measured receipt, developer value.

Registry: `earth.affine/math-court` `2026.8.24`. Public clients: [uum8dSolarResearch](https://github.com/gaiaftcl-sudo/uum8dSolarResearch).

---

## Two Falcon things. Do not mix them.

| Surface | What it is | What it is not |
|---|---|---|
| **Study 02 charter** | The sealed shear: Falcon 9 F-region hole, Vandenberg 2023-07-19 founding event, corridor + clock + 1–3 h recovery. Adversaries: Gannon, Hunga Tonga, Falcon deorbit burns. | Not an ozone court. Not a crop court. Not a phytoplankton court. |
| **Damage app (graphic example)** | Three panels that *read sealed integers* the live courts already accept — then *cite* ozone / UV-B, jet-stream / crops, and phytoplankton as literature the per-launch TEC ledger must inform. | Not a second law. Not a health-court ozone grade. Not invented floats. |

The charter is [Study 02 — Launch ionospheric holes](Study-02-Launch-Ionospheric-Holes.md). Open it first. The graphic app is [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html) — three cited panels that POST the integers below. Researchers generate the same files in the IDE template `falcon-damage`.

The `health` court PK is `mass_milli` / `vol_milli`. That is dose concentration. It is not ozone DU, not UV-B, not crops, not phytoplankton. A panel that paints those words must say **cited** next to the integer it actually sealed.

---

## The one-screen journey — four acts

Look is anonymous. Claim, build, and share name a `source`. Generation is a claim. The shared view is a public GET.

| Act | Name | You | URL |
|---|---|---|---|
| 1 | **LOOK** | Read the OS and the live catalog. No identity. | [https://affine.earth/language-game/#researcher](https://affine.earth/language-game/#researcher) |
| 2 | **CLAIM** | POST integers with `source` + `role`. | [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html) · `POST /language-invariant/game/{domain}/ingest` |
| 3 | **BUILD** | Compile and seal in the IDE that already exists. | [ide.html#falcon-damage](https://affine.earth/language-game/ide.html#falcon-damage) · [`#gym`](https://affine.earth/language-game/ide.html#gym) |
| 4 | **SHARE** | Grant `audience=public`. Hand someone a GET. | `GET /language-invariant/work/fetch?work_id=` |

Courts that Falcon actually binds — use these names, no others:

`physics` · `weather.convective_containment` · `noaa_goes_r_weather` · `execute_transition` · `corpus_bonds` · `verify_jordan_bond`

Look paints the 15 live MCP tools from `GET /language-game/mcp-tools.json`. Code-gen is **not** one of them.

---

## Act 1 — LOOK

Open [https://affine.earth/language-game/#researcher](https://affine.earth/language-game/#researcher) or click **Researchers**.

The tab GETs two catalogs (`/language-invariant/games` and `/language-game/mcp-tools.json`) with credentials omitted and no referrer. No location. No wallet. No name. No `source`. No MCP POST. The page says so: *“This tab shares no user data.”* The meta line reads **this tab sent no identity**. Proven: `RESEARCHER_LOOK_ZERO_VISITOR_DATA`.

What you see:

- What Affine.Earth is, and the UUM-8D entities that actually move in the twin.
- Nine lattice courts, live. Roles and ΔD_H from the cell, not a brochure.
- The 15 tools, live. Names below. Nothing else.
- Walks that are already GET views: OpenUSD, projection-room, twin, lattice, GOP meta.

Court POSTs are a different, explicit act. They do not live on this tab.

Fifteen tools, and only these:

`atc.assert_4d_deconfliction` · `corpus_bonds` · `critique_frame` · `execute_transition` · `feeds_catalog` · `game_frame_meta` · `ide_rebuild_mesh` · `membrane_health` · `noaa_goes_r_weather` · `twin.robotics.evaluate_exact_ik` · `umc_direct` · `umc_resume` · `umc_status` · `verify_jordan_bond` · `weather.convective_containment`

---

## Act 2 — CLAIM

You present integers. The cell writes a receipt that echoes `source`. A float is refused in public.

```
POST https://affine.earth/language-invariant/game/{domain}/ingest
{"source":"<your handle>","role":"<role>", …integers…}
```

| Missing / bad | What the cell returns |
|---|---|
| empty `source` | HTTP 400 `REFUSED_UNATTRIBUTED` — absence is recorded, not defaulted |
| `1.5` anywhere | HTTP 400 `REFUSED_FLOAT` |
| no ingest key for that role | HTTP 400 `REFUSED_EMPTY_PAYLOAD` |

`wallet_hash` is optional. Absence of `source` is not.

Explorer (every role, measured refusals): [Affine-Earth Lattice Endpoints](Affine-Earth-Lattice-Endpoints.md) and the public [uum8dSolarResearch wiki](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Affine-Earth-Lattice-Endpoints). Bind MCP at `https://affine.earth/language-invariant/mcp` — registry `earth.affine/math-court`.

### Bind the courts that exist

| Bind | Appointment | Falcon use |
|---|---|---|
| `physics` · role `experimentalist` / `detector` | `clock` `track` `table_counts` | Launch net, corridor cells, TEC table. Court returns CONTRACT — the table is the court. |
| `weather.convective_containment` | integer track vs declared cells (micro-deg, feet) | REST `/language-invariant/weather/convective-containment`. |
| `noaa_goes_r_weather` | `lane=weather` or `lane=space` | Live SIGMET / GOES-R / K / OVATION. A feed, not a damage verdict. Empty = empty. Fail = CURE. |
| `execute_transition` | `entity_id` + `intent` + `client_signature` | Signed membrane turn. Identity bind / ingest. |
| `corpus_bonds` | sealed corpus rows | Gym already calls this. |
| `verify_jordan_bond` | `source_creator_hash` / `target_creator_hash` | Bond table. The win is the bond. |

Do **not** POST ozone, UV-B, jet-slow, crop, or phytoplankton keys. Those keys are not on the courts. Study 02 names GNSS-guided planting and Maloney black-carbon / DU scenarios as the debate the **per-launch TEC ledger** must inform. The ledger is physics `table_counts`. The citations stay citations.

The claim page POSTs these same integers: [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html). Do not invent a second court.

---

## Act 3 — BUILD

Open the IDE that already exists:

- [https://affine.earth/language-game/ide.html](https://affine.earth/language-game/ide.html)
- Gym deep-link: [https://affine.earth/language-game/ide.html#gym](https://affine.earth/language-game/ide.html#gym)

Open [ide.html#falcon-damage](https://affine.earth/language-game/ide.html#falcon-damage). The template writes the Swift appointment structs and the same court POST bodies the claim page uses. Same IDE. Same compile. Same seal. No second surface.

| Button | id | What it does | Identity |
|---|---|---|---|
| Compile WASM | `#btn-compile` | `POST /ide-compile-wasm` `{code}`. Real artifact or honest fail. | None. Compile is session-local. |
| Rebuild Mesh (C-1) | `#btn-rebuild` | `POST /ide-rebuild-mesh`. **403 on every apex cell.** Founder C-1 only. | Researchers observe. They do not rebuild the mesh. |
| Seal to mesh | `#btn-seal-work` / `#btn-seal-confirm` | Writes a work row. Needs a compile artifact **and** `IdentitySpine.resolve()`. | `user_vqbit_hash` required. Missing identity → local refuse, nothing sent. |
| Download .wasm / project | `#btn-download-wasm` / `#btn-download-project` | Browser-local bytes. | None. |
| Franklin | `#btn-send-ai` | `POST /language-invariant/franklin-speak`. Not code-gen. | Query only. |
| Stage hologram capture | `#btn-gym-stage-capture` | Opens `/language-game/#capture`. Existing hash. | GET. |
| Wallet badge | `#btn-wallet` | `WALLET NOT CONNECTED` until a real bind. | No fabricated balance. |

`ide_rebuild_mesh` on the 9-cell apex returns `BLOCKED`. That is the contract.

Marketplace “Swift 6.4 code generation” is labeled **PREVIEW — SIMULATED**. It is not a listing and not a live tool.

### The example damage app — three panels

The claim page draws this. This page names what the researcher must see, so the charter and the graphic cannot be mistaken for each other.

Each panel **reads** a sealed integer from a court that exists, then **cites** the atmospheric-shear story the founder wants the public to understand. The citation is not the seal.

| Panel | Graphic | Integer it reads | Words it may cite, never as a court key |
|---|---|---|---|
| 1 · human | UV-B floor over the launch corridor | `health` `mass_milli` / `vol_milli` (PK dose) **and** physics `table_counts` (charter quench) | Ozone / UV-B literature. Houston 30°N as a cited latitude, not a sealed DU. |
| 2 · food | Jet + planting belt | `fluids` `phi_in` / `phi_out` (exact flux) **and** physics corridor integers | Black-carbon heat, jet-slow 35/1000, GNSS-guided acres — Study 02 downstream of TEC holes, not a crop court. |
| 3 · ocean | Surface under the published track | physics `clock=1` `track=1` `table_counts` | Phytoplankton UV-B stress — cited. No biomass key on any court. |

A bar that moves on a float the researcher typed is a lie. A bar that moves on a receipt integer is the app.

### Hologram — existing routes only

Project through surfaces that already exist. Do not add a route. Do not touch hologram CSS / `filter:`.

| Route | What it is |
|---|---|
| [https://affine.earth/language-game/](https://affine.earth/language-game/) | Landing. Wait for the `AFFINE · I64` chip. |
| [`ide.html#gym`](https://affine.earth/language-game/ide.html#gym) | Gym IDE + hologram rail. |
| `/language-game/#capture` | Stage capture from `#btn-gym-stage-capture`. |
| [`/language-game/openusd/`](https://affine.earth/language-game/openusd/) | 3D twin. |
| [`/language-game/projection-room.html`](https://affine.earth/language-game/projection-room.html) | Substrate & proofs. |

---

## Act 4 — SHARE

A report is a public GET whose receipt names `source`. It is not a Gamma deck.

1. Seal the compile (`#btn-seal-work`) with `user_vqbit_hash` present.
2. Grant `audience=public` on that `work_id`.
3. Hand over `https://affine.earth/language-invariant/work/fetch?work_id=w…`
4. The other person GETs with credentials omitted. They see bytes + `creator_vqbit_hash` + `content_fnv`. They do not see a private key, a cookie, or a look-tab identity.
5. Paste the court receipt JSON beside it. The receipt already echoes `source`.

Ungranted work returns the same body as “no such work.” There is no preview token.

Two researchers are two paths:

```
language-game/studies/study-02/<creator16>/
work_id = "w" + creator16 + "_" + study_slug + "_" + contentFNV
```

Same creator + same bytes is a dedup. A second `source` / second `user_vqbit_hash` is a second path. No `anon` default.

---

## What “easy” means here

One Swift law, compiled to the cell and to wasm32. One MCP catalog. Nine courts. Fifteen tools.

You do **not** stand up a second court in Python or Node. You do **not** re-implement the shear. You look at the catalog, you post integers that already have names, you compile in the IDE the OS already serves, you grant a public GET.

That is the example. Falcon is first. Study 09 convective, Study 03 flare SIDs, and the rest reuse this same four-act loop. No new login. Molecule studies ([14](Study-14-Protein-Lattice-Manifold.md) · [15](Study-15-Skala-DFT-Shear.md)) use those same four acts; the health court is PK dose (`mass_milli`/`vol_milli`), not a binding pocket.

---

## What stays dark

| Dark | Until | Honest state today |
|---|---|---|
| Public code-gen MCP tool / `tools/list` entry / `#researcher` card | `evidence/researcher-ide-falcon-loop-*/VERDICT.json` green **and** `codegen: PROVEN` | TEST-ONLY. First green may keep `codegen: DARK`. |
| Marketplace “code generation” | never treat as live | Banner: PREVIEW — SIMULATED. |
| `GET /codegen` as a file writer | sibling / TEST-ONLY generate | Edge LLVM→ARM64 shell, not a Falcon UI. |
| Gamma / Glama “tested” | prove loop green | Do not update Gamma in this pass. |
| `ide_rebuild_mesh` on the 9 apex cells | founder decision | Apex = `BLOCKED` / 403. C-1 only. |
| Invented hologram API | never | Existing routes only. |
| `health` court as ozone / UV-B / phytoplankton | a court that actually has those keys | PK is `mass_milli` / `vol_milli`. |
| `health` court as a binding pocket / O(1) dock | an occupancy key that does not exist | Study 14 / 15 stay DARK. Pocket Claim is not a dose POST. |

---

## Association — no new login

| Path | Who you are | If that is missing |
|---|---|---|
| LOOK | Nobody. Keep it. | N/A |
| CLAIM | `source` + `role`. `wallet_hash` optional. | `REFUSED_UNATTRIBUTED` |
| BUILD compile | Session-local VFS. | Allowed. |
| BUILD seal / grant | `user_vqbit_hash` (wallet ⊕ location SCF, hash only). | Local refuse / `REFUSED_IDENTITY_MISSING`. Nothing on the wire. |
| SHARE GET | Public audience. Credentials omitted. | Receipt still names `source`. Shared view does not send credentials. |

Look never writes `localStorage`. Seal lives in `affine.identity.v1` as a hash, not an address. The generation act is a POST. The shared view is a GET. Two verbs, one receipt.

---

## Wiki information architecture

### Pages that stay

| Page | Job | Inbound |
|---|---|---|
| [Study 02 — Launch ionospheric holes](Study-02-Launch-Ionospheric-Holes.md) | Sealed Falcon 9 F-region-hole charter. Science. | Index, this walkthrough, lattice, prove plan. |
| [Researcher IDE + court loop — test plan](Researcher-IDE-Test-Plan.md) | How we prove look / claim / build / share. Test contract. | Study 02 (`ee75e210`), this walkthrough. |
| [Affine-Earth Lattice Endpoints](Affine-Earth-Lattice-Endpoints.md) | Live court POST map, refusals, MCP bind. | Look tab overflow, this walkthrough, public clients wiki. |
| [Shear Studies Index](Shear-Studies-Index.md) | Program board. Study 02 status: LIVE CLAIM. | Home, readers’ guide. |

### Pages this example needs

| Page | Job | State |
|---|---|---|
| **This page** — Build a study on Affine.Earth — Falcon walkthrough | Teaching surface. Four acts. Charter vs damage app. Dark box. | **LIVE as teaching.** Prove `VERDICT.json` is still the test contract. |
| **Claim / damage app** | Three cited panels + court POSTs + report download. | [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html) |
| **IDE template** | Researcher file surface. | [ide.html#falcon-damage](https://affine.earth/language-game/ide.html#falcon-damage) |

### Inbound links this pass

- This page → Study 02, prove plan, lattice endpoints, index, live URLs above.
- Story catalog (`press/catalog.json`) lists this page next to Study 02 so the served wiki can open it.
- Study 02 HEAD already names the claim UI and IDE workspace.

### What is live vs still dark

| Live now | Still dark |
|---|---|
| Claim page, IDE `falcon-damage` template, look path, 15 MCP tools | Public codegen MCP tool, Gamma, Glama “tested”, apex `ide_rebuild_mesh` |
| Three-panel GET that names `source` after a seal | Health-as-ozone (never) |

---

## Copy outline (this page, in scan order)

1. **Title + status** — teaching surface; Falcon is the example; prove plan is the test contract; siblings named.
2. **Two Falcon things** — charter vs damage app. Health PK named. Citations stay citations.
3. **Four acts table** — Look / Claim / Build / Share with the real URLs.
4. **LOOK** — `#researcher`, zero visitor data, 15 tools listed.
5. **CLAIM** — `source` + `role`, refusals, six live binds, no invented keys.
6. **BUILD** — IDE buttons, identity rule, three panels, existing hologram routes.
7. **SHARE** — public GET, receipt names `source`, two-researcher paths.
8. **Easy** — same Swift, same MCP, no second court.
9. **Dark box** — codegen, Gamma, apex rebuild, hologram API, health-as-ozone.
10. **Association** — no new login.
11. **IA** — what stays, what is new, what flips.

---

## What “done” looks like on this wiki

A new researcher opens this page, walks Look → Claim → Build → Share without reading the prove plan, and can say:

- I read the Study 02 charter and I know what the hole is.
- I looked at nine courts and fifteen tools without giving a name.
- I posted integers the courts already accept, under my `source`.
- I compiled and sealed in the existing IDE. Rebuild on the apex refused, as it should.
- I know the three-panel app reads those integers and cites ozone / jet / phytoplankton — it does not pretend the health court graded them.
- I shared a GET. The receipt names me. The view sent no credentials.

The prove plan then measures that walk. This page taught it.

**Status: teaching page live. Claim UI and IDE template are on the membrane. Prove sealed `evidence/researcher-ide-falcon-loop-20260824T121306Z/VERDICT.json` (`RESEARCHER_IDE_FALCON_LOOP`). Codegen stays dark. Nothing here claims a court key the membrane does not have.**
