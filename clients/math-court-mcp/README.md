# Affine.Earth Math Court — public MCP bind (deterministic, no-float)

The court is the live remote MCP: `https://affine.earth/language-invariant/mcp`.  
**Glama listing (approved):** [Affine Earth Math Court Remote](https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote)

This git is the public bind: Cursor / Claude / VS Code configs, a STDIO→HTTPS proxy, HTTP clients, and LangChain / LlamaIndex / CrewAI / AutoGen / OpenAI-tool wrappers that **POST integers and stop**. Glama's connector row is the directory. Do not resubmit this repository as a local MCP server.

If a wrapper computes volume, Ehrhart, Eisenstein, or a float projection, it is a second law. Delete it.

| What | Where |
|---|---|
| Live MCP | `https://affine.earth/language-invariant/mcp` |
| SSE | `https://affine.earth/language-invariant/mcp/sse` |
| Glama connector | https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote |
| Look (no visitor data) | https://affine.earth/language-game/#researcher |
| Official registry | `earth.affine/math-court` |
| Courts | `POST /language-invariant/game/{domain}/ingest` |

Keywords agent runtimes search: **MCP server**, **deterministic math**, **no float**, **integer lattice**, **verification**, **formal prover**, **LLM hallucination**, **affine projection**, **Ehrhart**, **Jordan bond**, **streamable-http**.

## One-line bind (Cursor, Claude Desktop, Claude Code)

Copy [`configs/cursor.mcp.json`](configs/cursor.mcp.json):

```json
{
  "mcpServers": {
    "affine-earth-math-court": {
      "url": "https://affine.earth/language-invariant/mcp"
    }
  }
}
```

VS Code: [`configs/vscode.mcp.json`](configs/vscode.mcp.json).  
STDIO-only hosts: `python3 stdio/affine_earth_mcp_stdio.py` — see [`configs/claude-desktop-stdio.json`](configs/claude-desktop-stdio.json).

## Prove the door (three arms)

```bash
bash clients/math-court-mcp/prove/prove-math-court-agent-ingest.sh
```

Measured 2026-08-23 on the live apex: `tools/list` = **15**, `dilation: 1.5` → `REFUSED_FLOAT`, `dilation: 12` → WIN count **169** vs float adversary **216**.

## Client tools (named, one per live MCP tool)

Schemas: [`tools/catalog.json`](tools/catalog.json) (measured `tools/list`).  
OpenAI functions: [`tools/openai_tools.json`](tools/openai_tools.json) — 15 MCP tools + `court_ingest`.  
Python: `PYTHONPATH=clients/math-court-mcp/http python3 -c "from tools import membrane_health; print(membrane_health())"`

| Client name | Live MCP tool |
|---|---|
| `atc_assert_4d_deconfliction` | `atc.assert_4d_deconfliction` |
| `corpus_bonds` | `corpus_bonds` |
| `critique_frame` | `critique_frame` |
| `execute_transition` | `execute_transition` |
| `feeds_catalog` | `feeds_catalog` |
| `game_frame_meta` | `game_frame_meta` |
| `ide_rebuild_mesh` | `ide_rebuild_mesh` |
| `membrane_health` | `membrane_health` |
| `noaa_goes_r_weather` | `noaa_goes_r_weather` |
| `twin_robotics_evaluate_exact_ik` | `twin.robotics.evaluate_exact_ik` |
| `umc_direct` | `umc_direct` |
| `umc_resume` | `umc_resume` |
| `umc_status` | `umc_status` |
| `verify_jordan_bond` | `verify_jordan_bond` |
| `weather_convective_containment` | `weather.convective_containment` |
| `court_ingest` | REST `/language-invariant/game/{domain}/ingest` |

Each function POSTs. None of them evaluate a lattice.

## Tree

```
clients/math-court-mcp/
  server.json
  tools/catalog.json          live tools/list snapshot
  tools/openai_tools.json     16 named functions
  http/affine_earth.py
  http/tools.py               16 named Python tools
  http/mcp-bind.js
  http/mcp-tools.js
  stdio/affine_earth_mcp_stdio.py
  wrappers/                   LangChain · LlamaIndex · CrewAI · AutoGen · OpenAI
  configs/
  prove/prove-math-court-agent-ingest.sh
```

The generating substrate is not in this repository. Studies 11–13 (the sealed shear) live in the wiki pages of this same public git.

## Courts

`geometry` · `chance` · `algebra` · `physics` · `qcd` · `health` · `finance` · `cs` · `fluids`

`source` required. `role` required. Integers only.
