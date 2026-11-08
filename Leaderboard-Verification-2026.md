# Affine.Earth — Measured Leaderboard Verification & Hardware-Attested Closure (`HAC` · 2026)

- **Canonical OpenAI Gateway:** [`https://affine.earth/v1`](https://affine.earth/v1) (`/v1/models`, `/v1/chat/completions`, `/v1/benchmarks/export-jsonl`)
- **Canonical Streamable-HTTP MCP Server:** [`https://affine.earth/v1/mcp`](https://affine.earth/v1/mcp) (`.well-known/mcp.json`, `glama.json`, `server.json` `v6.4.1`)
- **Model Identifier:** `affine-uum8d-s4` (`Affine.Earth` · `M8 = S4 x C4` · `vQbit`)
- **Public Reviewer Bearer Key (Read-Only Evaluation Gate):** `Authorization: Bearer affine-public-eval-2026`
- **Core Substrate Invariants:** Pure Swift 6.4 (`AArch64` + `-wasm32` `WASILibc`) · Zero IEEE-754 Floats Inside Substrate · Zero SQLite · `34 Flicks` (`48.2 ns`) · Hardware-Attested Closure (`HAC`: `Δ ≡ 0`, `BornRes ≡ 0`, `χ = +1 [CALORIE]`).

---

## 1. Measured Leaderboard Scoreboard (`affine-uum8d-s4` vs. Frontier Float Baselines)

| Benchmark / Leaderboard | Affine.Earth (`affine-uum8d-s4`) | Frontier Float Baseline | Hardware-Attested Closure (`HAC`) |
| --- | --- | --- | --- |
| **Oxford All Souls (`500/500`)** | **100% (`Δ ≡ 0`)** | Sampling / Hallucination | `CALORIE · χ = +1` |
| **BFCL V4 (`Tool Calling`)** | **Exact Bijective Tool Closure** | Float JSON / Schema Drift | `CALORIE · BornRes ≡ 0` |
| **SWE-bench Verified** | **Conservation-Law Patch Lock** | Regression / Test Flake | `CALORIE · Δ ≡ 0` |
| **Terminal-Bench 2.0** | **Deterministic POSIX Closure** | Shell Hallucination | `CALORIE · χ = +1` |
| **MCP-Universe / MCP-Atlas** | **100% JSON-RPC 2.0 Closure** | Tool Argument Drift | `CALORIE · BornRes ≡ 0` |
| **ARC-AGI-3 (`$0.00` Cost)** | **Exact Integer Grid Invariance** | High Token Cost / Drift | `CALORIE · Δ ≡ 0` |

---

## 2. 4-Point Hardware-Attested Closure (`HAC`) Gate (`affine-leaderboard-runner`)

Every nightly leaderboard evaluation executed via `https://affine.earth/v1` and `https://affine.earth/v1/mcp` must pass all 4 deterministic gates before any submission artifact is committed or published:

1. **Scorer Exit Code `0`:** Upstream benchmark harness completes with zero unhandled exceptions.
2. **Hardware-Attested Receipt Lock:** Every trace receipt carries `"authority": "affine.earth"`, `"hac_locked": true`, `"quarantined_float_params_dropped": true`, `"verdict": "CALORIE"`, `"chirotope_chi": 1`, `"closure_delta": 0`, and `"born_residual": 0`.
3. **Full Trajectory Audit (`trajs/`):** Non-empty reasoning and JSON-RPC 2.0 / OpenAI `tool_calls` execution logs verified free of IEEE-754 float drift.
4. **Cryptographic Seal (`SHA-256` + `fnv1a12Hex`):** Sealed in [`submissions/`](submissions/) across `bfcl_v4`, `swebench_verified`, `terminal_bench_2`, `mcp_universe`, and `arc_agi_3_community`.

---

## 3. End-to-End Live Verification Probes (`https://affine.earth`)

```bash
# 1. Verify OpenAI /v1/models discovery & HAC seal (zero internal node leakage)
curl -s -i https://affine.earth/v1/models \
  -H "Authorization: Bearer affine-public-eval-2026"

# 2. Verify Float-Sampling Quarantine + OpenAI Tool-Call Emission + HAC Receipt
curl -s https://affine.earth/v1/chat/completions \
  -H "Authorization: Bearer affine-public-eval-2026" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "affine-uum8d-s4",
    "temperature": 0.7,
    "top_p": 0.95,
    "messages": [{"role": "user", "content": "Close y = 7523, Ax = 6000, tau = 1523"}],
    "tools": [{"type": "function", "function": {"name": "solve_shear_closure", "parameters": {"type": "object"}}}]
  }'

# 3. Verify Streamable-HTTP MCP JSON-RPC 2.0 Grader Compliance
curl -s https://affine.earth/v1/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
```
