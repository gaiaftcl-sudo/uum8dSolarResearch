# Deterministic no-float Math Court MCP for LLMs (Affine.Earth)

Agent builders searching for **trustworthy math**, **verification**, **no floating point**, **lattice**, **formal prover**, or **MCP math server**: bind the remote. Do not re-implement the court.

- **MCP (streamable HTTP):** https://affine.earth/language-invariant/mcp
- **SSE:** https://affine.earth/language-invariant/mcp/sse
- **Glama connector (approved):** https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote
- **Registry name:** `earth.affine/math-court`
- **Public bind tree:** [`clients/math-court-mcp/`](clients/math-court-mcp/)
- **Swift example (entire court):** [`clients/math-court-mcp/swift-example/`](clients/math-court-mcp/swift-example/)
- **User guides:** [bind](Math-Court-User-Guide.md) · [example app](Math-Court-Example-App.md) · [Glama](Affine-Math-Court-Glama.md)
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

Prove the door: `bash clients/math-court-mcp/prove/prove-math-court-agent-ingest.sh`  
Prove the whole court: `swift run --scratch-path /tmp/affine-math-court-mcp --package-path clients/math-court-mcp/swift-example affine-math-court`  
Measured 2026-08-26: **21** tools · **29 LIVE · 0 LEARN** · QMA fixtures −1/1, −1, WIN, 6.

The Swift membrane that evaluates Eisenstein / Ehrhart / Jordan bonds is not in this repository.
