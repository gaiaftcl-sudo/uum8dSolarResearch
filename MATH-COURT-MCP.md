# Deterministic no-float courts for LLMs (Affine.Earth) — Math, Quantum, Code

Agent builders searching for **trustworthy math**, **verification**, **no floating point**, **lattice**, **formal prover**, **MCP math server**, **exact quantum verifier** or a **coding court that returns the artifact**: bind the remote. Do not re-implement the court.

Three courts on one endpoint, **49 tools** (measured 2026-09-02 per cell on all nine apex cells): the **Math Court** (49 domains behind `math_court`), the **Quantum court** (QMA + QC-001…021 verifiers, two projection tools), and the **Coding Court** (`code_ir_equiv`; `execute_artifact_crucible` — brief + artifact in, sealed artifact out, including a prebuilt `wasm.module` returned byte-exact).

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
Measured 2026-09-02: **49** tools on all nine cells · `prove-live-court.sh` 40 WIN of 41 study rows · QMA fixtures −1/1, −1, WIN, 6 · Coding Court: a posted 4,946-byte wasm module sealed and returned byte-exact at rung 7.

The Swift membrane that evaluates Eisenstein / Ehrhart / Jordan bonds is not in this repository.
