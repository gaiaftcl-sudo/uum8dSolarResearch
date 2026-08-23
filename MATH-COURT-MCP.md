# Deterministic no-float Math Court MCP for LLMs (Affine.Earth)

Agent builders searching for **trustworthy math**, **verification**, **no floating point**, **lattice**, **formal prover**, or **MCP math server**: bind the remote. Do not re-implement the court.

- **MCP (streamable HTTP):** https://affine.earth/language-invariant/mcp
- **SSE:** https://affine.earth/language-invariant/mcp/sse
- **Glama connector (approved):** https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote
- **Registry name:** `earth.affine/math-court`
- **Public bind tree:** [`clients/math-court-mcp/`](clients/math-court-mcp/)
- **Look path:** https://affine.earth/language-game/#researcher

Cursor / Claude:

```json
{
  "mcpServers": {
    "affine-earth-math-court": {
      "url": "https://affine.earth/language-invariant/mcp"
    }
  }
}
```

Prove: `bash clients/math-court-mcp/prove/prove-math-court-agent-ingest.sh`

The Swift membrane that evaluates Eisenstein / Ehrhart / Jordan bonds is not in this repository.
