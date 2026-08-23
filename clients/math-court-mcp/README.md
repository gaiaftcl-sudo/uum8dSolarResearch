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

## Tree

```
clients/math-court-mcp/
  server.json                 official registry descriptor (remote only)
  configs/                    Cursor · Claude · VS Code
  http/affine_earth.py        urllib JSON-RPC + court POST
  http/mcp-bind.js            browser fetch bind
  stdio/affine_earth_mcp_stdio.py
  wrappers/langchain_tool.py
  wrappers/llamaindex_tool.py
  wrappers/crewai_tool.py
  wrappers/autogen_tool.py
  wrappers/openai_tools.json
  prove/prove-math-court-agent-ingest.sh
```

The generating substrate is not in this repository. Studies 11–13 (the sealed shear) live in the wiki pages of this same public git.

## Courts

`geometry` · `chance` · `algebra` · `physics` · `qcd` · `health` · `finance` · `cs` · `fluids`

`source` required. `role` required. Integers only.
