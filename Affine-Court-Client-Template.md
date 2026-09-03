# The Court Client — a generic wasm IDE client for every Affine.Earth court

**One page. Every served tool. Your files as language games. A prompt that becomes a brief, a brief
that becomes a sealed wasm module, a module that runs where you are standing.**

Live: `https://affine.earth/language-game/court-client.html` · source: `court-client.html` +
`court-client.js` in the language-game bundle · brief template: `court-client.brief.txt`
(mirrored at `clients/math-court-mcp/briefs/generic-wasm-ide-client.brief.txt`).

Every number on this page was measured on 2026-09-02 against the live nine-cell apex from the page
itself, driven in a browser. Where something is committed and not yet serving, it says so.

---

## What it is, in one paragraph

A **delivery surface**. It draws what the law produced and posts what you did. It computes no
verdict, holds no law and converts no number — every value travels as the decimal string you typed
or your file carried, so a float is refused by the **cell**, never rounded by the page. It is the
browser-JavaScript row of the language table in `CLAUDE.md`, and nothing more: the law is Swift on
the cell, the shell it can load is Rust `#![no_std]` wasm32, and this page is the glass between them.

## The four things it does

### 1. Every court tool, from the tool's own schema

`tools/list` → 49 tools → one button each, grouped into courts by name (Coding Court, Quantum & QMA,
Math Court, Corpus census, Exact geometry, Render & language games, Membrane & controller). Clicking
a tool renders a form **generated from that tool's `inputSchema`** — enums become selects, objects
and arrays become JSON boxes, everything else is a text field that posts a string. Nothing is
hand-listed, so a fiftieth tool appears the moment the cell serves it, and a tool the cell stops
serving disappears the same way.

Measured: `initialize` → `tools/list` → **49 tools, HTTP 200**; `math_court {}` → **49 domains**;
`execute_exact_permanent` on the all-ones 3×3 → `WIN`, `energy_num 6`.

### 2. Local files → long-running UUM-8D language games

Open files with the File System Access picker (or the plain file input, or drop them anywhere on the
page). Rows are read as **strings**:

| file | becomes |
|---|---|
| `.csv` / `.tsv` | header → fields; each row → one `math_court` ingest |
| `.json` (array or `{rows|data|items}`) / `.jsonl` | each object → one ingest; keys are the fields |
| any other text | each line → `{line_no, statement}` |
| `.ll` | Code Court: `code_ir_equiv` against the previous `.ll` you loaded |
| `.rs` / `.swift` / `.s` | the crucible artifact (source) |
| `.wasm` | the crucible artifact (a prebuilt module, posted as base64) |

You choose the **domain** and **role** from the live `math_court` catalog; the role's `may_ingest`
fields appear and you map each to a column or a constant. Then the game runs: one `tools/call
math_court` per row, `source` attributed per row (`court-client:<host>:<file>#<row>`), tally of
WIN / MISS / REFUSED, cursor and tally **persisted in the browser** so reopening the same file,
domain and role resumes at the cursor. Pause and continue are buttons. That is the "long-running"
half: the page is the metronome, the cell is the court, and nothing is lost between sessions.

Measured, three-row CSV into `geometry` / `cad_engineer` (`polytope_id`, `dilation`):

| row | posted | cell said |
|---|---|---|
| 1 | `unit_square`, `12` | `CALORIE` |
| 2 | `unit_square`, `1.5` | `REFUSED_FLOAT` — the page posted the string `1.5` untouched; the cell refused it |
| 3 | `unit_cube`, `3` | `REFUSED_POLYTOPE` — not a polytope the court knows |

Two refusals out of three is the instrument working. A client that rounded `1.5` to `2` or dropped
the row would have turned a refusal into silence.

New facts and invariants enter the same way: a row is a fact, the domain's `new_law` (shown beside
the picker) is the invariant it is graded against, and `expose`, `verify_jordan_bond` and
`lattice_op` are one click away in the runner for anything that is a lattice rather than a table.

### 3. Prompt → brief → crucible → module

Type the coding requirement. The page fills the twelve-field **ARTIFACT INGESTION BRIEF** from the
template — the generic wasm IDE client brief, with your prompt appended to `Purpose` — and shows it.
The artifact is **the caller's half**: paste source, drop a `.wasm`, or copy the composed
`tools/call` and hand it to the MCP host that generates (Claude, Cursor, a CI agent — any of them
posts the identical call, which is the point of a headless court). Then `execute_artifact_crucible`
rules, and whatever it seals lands under **Returned modules**.

A returned `wasm.module` is:

1. **digest-checked** — the blob is decoded and re-hashed; a mismatch with the declared `sha256` stops here, by name;
2. **magic-checked** — the bytes must begin `00 61 73 6d 01`; an `artifact_kind` is an assertion and the magic is a fact;
3. **instantiated** — the module's declared imports are read; `box_camera.project_x` and `project_y` are wired to `BoxCamera` in the served law module `AffineWasmClient.wasm` through the same adapter the landing page uses (`box_camera_project(x,y,z)` then lanes 4 and 5 of the law's Int32 out buffer; a return other than 1 crosses the boundary as `i32::MIN`), so the cell raster and this canvas cannot project differently. When the law module is not reachable the import is a **refusing** stub — every call answers `i32::MIN` and the shell parks the vertex — and the log says so; a stub never invents a coordinate;
4. **driven** — if it exports the IDE shell contract (`get_code_buffer_ptr`, `set_code_length`, `validate_edge_code`, `ingest_intent_vector`, `get_frame_buffer_ptr`, `memory`), the page writes your prompt into the 64 KB code buffer, asks the module to validate it as UTF-8, posts one intent vector under a monotonic sequence id, and paints the 600×600 frame onto the canvas. Any other module has its zero-argument exports listed and called.

Measured on the live apex, posting the served 4,946-byte `affine_wasm_ide.wasm` as base64 with the
template brief:

| step | result |
|---|---|
| `execute_artifact_crucible` | rung **7** `CALORIE_AFFINE_ARTIFACT_DELIVERED`, `law_checked false` (a posted module — the court says it did not scan source) |
| returned resource | `affine://artifact/affine_wasm_ide.wasm`, `application/wasm`, `artifact_kind wasm.module`, 4,946 bytes |
| digest | recomputed in the page equals the declared `sha256`; bytes identical to what was posted |
| instantiate | imports `box_camera.project_x`, `box_camera.project_y`; exports the full IDE shell contract |
| drive | `validate_edge_code → 1`, `ingest_intent_vector` accepted, frame painted on the canvas — 800 lit pixels with `box_camera` resolved to the served law module (725 with the refusing stub, cross-origin from a dev box) |

**The brief declares `Target Architecture: Rust no_std wasm32`**, because that is what the client
shell is. That value is **committed and not yet serving**: the fleet binary at the time of writing
knows three architectures and answers `REFUSED_UNKNOWN_ARCHITECTURE` for it, so the measurement above
was taken with the brief's architecture line read as `Swift 6.4 ~Copyable`. The fourth case lands
with the next binary roll, and this sentence is replaced by its per-cell measurement when it does.

### 4. A coding Long Play

`umc_direct` with `domain coding` starts a Universal Manifold Controller session under a
`session_id` the page keeps; `umc_resume` resumes it from the latest tip. Both are **grant class
mesh**: an anonymous call is `REFUSED_GRANT_MESH_IDENTITY_REQUIRED` (measured 2026-09-02), so the
page sends `user_vqbit_hash` derived by the one identity law it loads, `GameNATS.userVQbitHash` in
`game-nats.js` — byte-identical to the cell's — over the entity `court-client:<session_id>`. The page
carries no second copy of that hash. Measured 2026-09-02 through the page: `umc_direct` → `CALORIE_GAV_LONG_PLAY`, tip `turn_index 3 · tau_height 3 · torsion 0/1 · amplitudes 3/5, 4/5`, sealed to KV key `coding.<session>.court-client` and subject `gaiaftcl.umc.state.coding.<session>.court-client`; `umc_resume` → `CALORIE_GAV_LONG_PLAY_RESUME`, `turn_index 4 · tau_height 7`. These are the same two tools any MCP host can call.

---

## Running it

Same origin, no configuration:

```
https://affine.earth/language-game/court-client.html
```

From anywhere else, point it at the apex (cross-origin calls go out as `text/plain` so no preflight
is needed; the membrane reads the JSON body regardless — measured HTTP 200):

```
court-client.html?mcp=https://affine.earth/language-invariant/mcp
```

`?source=<attribution>` sets the `source` the Math Court requires on every ingest.

Driving it from a script or an agent — the buttons call the same functions:

```js
CourtClient.tools()                              // the live tools/list
await CourtClient.toolsCall(name, args)          // any tool, args are strings
await CourtClient.addFileBytes(name, bytes)      // load a file without a drop event
CourtClient.startGameFor(name); CourtClient.game()
await CourtClient.submitPromptBrief()            // compose the brief, post the artifact
await CourtClient.instantiate(bytes, name)       // digest-checked module → canvas
```

## What it deliberately is not

- **Not a generator.** The page does not write Swift, Rust or assembler. Generation is the caller's half and the court says so (`REFUSED_NO_ARTIFACT`). The prompt box exists to compose the brief and the exact `tools/call`, so the MCP host that *does* generate posts the same call a CI runner would.
- **Not a second law.** No projection, digest or quantiser lives here. The one hash it computes is SHA-256 over a returned blob, to check the court's own declared digest — a check, not a law.
- **Not a verdict.** WIN, MISS, REFUSED and the rung are read off the cell's reply and shown. The page never derives one.

## Files

| file | role |
|---|---|
| the court client page (private repo) | the page |
| the court client script (private repo) | tools/list → forms; files → games; prompt → brief → crucible; module receive/instantiate/drive |
| the client brief (private repo) | the twelve-field brief for the generic client (fetched by the page) |
| `clients/math-court-mcp/briefs/generic-wasm-ide-client.brief.txt` | the same brief, for agents working from the clients tree |
| `apps/AffineWasmIDE` | the Rust `#![no_std]` shell the brief describes; `affine_wasm_ide.wasm` is its built artifact |

Related: [Affine Coding Court](Affine-Coding-Court-Architecture.md) · [MCP user guide](Affine-Earth-MCP-User-Guide.md) · [Math Court bind guide](Math-Court-User-Guide.md)

## The checkpoint: every study replayed through this page

**replay all studies** posts one row per shear study from `court-client.studies.json` — the strings
each study page cites, unchanged — and records what the cell said. Run 2026-09-02 against the live
apex: **50 LIVE · 2 LEARN · 12 NOT_ON_MCP of 64 rows**, every QC verifier LIVE with the energy the
alignment table names, every `STUDY*_PROVEN` marker returned by the cell. The full table, the six
stale fixtures the courts refused by name, and the one forwarder defect the run exposed:
[Shear studies — Court Client checkpoint](Shear-Studies-Court-Client-Checkpoint.md).
