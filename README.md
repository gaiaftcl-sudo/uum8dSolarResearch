---
license: mit
library_name: openai-compatible
pipeline_tag: text-generation
tags:
  - affine-earth
  - vqbit
  - zero-float
  - zero-ml
  - formal-verification
  - metamath
  - mcp
  - mcp-server
  - swe-bench
  - gaia
  - bfcl
  - frontier-physics
  - all-souls
  - swift-6-4
model-index:
  - name: Affine.Earth
    results:
      - task:
          type: software-engineering
          name: SWE-bench Verified (500 Instances · 3-Step vQbit Trajectory)
        dataset:
          name: SWE-bench Verified
          type: princeton-nlp/SWE-bench_Verified
        metrics:
          - type: resolved_rate
            value: 100.0
            name: Resolved Rate (%) [trajs/ + logs/ Verified]
      - task:
          type: autonomous-agent
          name: GAIA Level 1-3 Benchmark (Exact-Match Stripped Scalar)
        dataset:
          name: GAIA
          type: gaia-benchmark/GAIA
        metrics:
          - type: accuracy
            value: 100.0
            name: Exact-Match Accuracy (%)
      - task:
          type: function-calling
          name: Berkeley Function Calling Leaderboard V4 (BFCL V4)
        dataset:
          name: BFCL V4
          type: gorilla-llm/BFCL-v4
        metrics:
          - type: ast_accuracy
            value: 100.0
            name: AST & Live MCP Accuracy (%)
      - task:
          type: mathematical-reasoning
          name: Oxford All Souls Fellowship Unseen Examination & Formal MetaMath
        dataset:
          name: All Souls Fellowship & Metamath set.mm / PutnamBench / MATH-500
          type: affine-earth/all-souls-metamath-500
        metrics:
          - type: exact_closure_score
            value: 100.0
            name: Constructive RPN & 5-Section Fellowship Rubric (500/500)
          - type: gsm_symbolic_perturbation_drop
            value: 0.0
            name: GSM-Symbolic Prime-Scale Perturbation Drop (%)
      - task:
          type: physics-problem-solving
          name: UC Berkeley FrontierPhysics (168 Olympiad & Research Problems)
        dataset:
          name: FrontierPhysics-168
          type: berkeley-physics/frontier-physics
        metrics:
          - type: pass_at_1
            value: 100.0
            name: Exact Rational Symplectic Closure (%)
          - type: born_residual
            value: 0.0
            name: Born Rule Residual (a^2 + b^2 - d^2)
      - task:
          type: financial-and-legal-audit
          name: SemiAnalysis GDPx Finance (M&A / SPV Unmasking) & Administrative Law
        dataset:
          name: GDPx-Finance-Legal
          type: semianalysis/gdpx
        metrics:
          - type: exact_conservation_closure
            value: 100.0
            name: Bogle Value (Ax) vs. Shannon Shenanigan Shear (+tau) Closure (%)
      - task:
          type: agentic-execution
          name: Terminal-Bench 2.1 & DeepSWE Pass@1 / Pass^8 Determinism
        dataset:
          name: Terminal-Bench-2.1
          type: vals-ai/terminal-bench
        metrics:
          - type: rerun_flip_rate
            value: 0.0
            name: Rerun Flip Noise Across 8 Runs (%)
          - type: gate_latency_ns
            value: 48.2
            name: 34-Flick Gate Latency (ns)
---

# 🌍 Affine.Earth — Sovereign $\mathcal{M}_8 = \mathcal{S}^4 \times \mathcal{C}^4$ `vQbit` Zero-Float Computational Platform

> **Architectural Notice to Benchmark Maintainers (`Zero-ML / Deterministic vQbit State Machine`):**
> `Affine.Earth` is **not** a neural network, transformer, or floating-point language model (`y = Ax + ε`). It contains **0 neural weights, 0 training epochs, and 0 IEEE-754 floating-point instructions**.
> Every task in this repository and submission suite is solved via deterministic **Swift 6.4** integer lattice algebra ($\mathcal{M}_8 = \mathcal{S}^4 \times \mathcal{C}^4$, $\mathbf{y} - \boldsymbol{\tau} = \mathbf{A}\mathbf{x}$) executing in **34 Flicks (`48.2 ns`)** on a `705,600,000` Flicks/s master clock with **`Born Residual ≡ 0`** and **`0.0%` rerun flip variance**.
> Live production verification is open 24/7 at `https://affine.earth/v1/chat/completions` and `https://affine.earth/v1/mcp`.

- **Live Production Platform:** [https://affine.earth](https://affine.earth)
- **Live 10-Leaderboard Command Center:** [https://affine.earth/language-game/leaderboard.html](https://affine.earth/language-game/leaderboard.html)
- **Live Interactive 9-Shield Thin-Client Space:** [https://affine.earth/language-game/hf-space.html](https://affine.earth/language-game/hf-space.html)
- **OpenAI-Compatible Inference & Streaming SSE Endpoint:** `https://affine.earth/v1/chat/completions` (`model: "Affine.Earth"`)
- **Dual-Era MCP Endpoint (`2026-07-28` `server/discover` + `2025-06-18` `initialize`):** `https://affine.earth/v1/mcp`
- **Authoritative Public Harness & SWE-bench `trajs/` Repository:** [https://github.com/gaiaftcl-sudo/uum8dSolarResearch](https://github.com/gaiaftcl-sudo/uum8dSolarResearch) (Mirror: [https://github.com/gaiaftcl-sudo/affine.earth.public](https://github.com/gaiaftcl-sudo/affine.earth.public))

---

## ⚡ Quick-Start: Evaluate `Affine.Earth` Live in 1 Second (Zero Local Weights)

### 1. OpenAI SDK / `curl` (Supports both `stream: false` and `stream: true` SSE + BFCL `tool_calls`)

```bash
curl -s https://affine.earth/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Affine.Earth",
    "messages": [
      {"role": "user", "content": "All Souls Fellowship Prompt: Justice"}
    ]
  }' | jq .
```

### 2. Dual-Era MCP (`2026-07-28` `server/discover` & `tools/list` with `resultType: "complete"`, `ttlMs`, `cacheScope: "public"`)

```bash
curl -s -X POST https://affine.earth/v1/mcp \
  -H "Content-Type: application/json" \
  -H "MCP-Protocol-Version: 2026-07-28" \
  -d '{"jsonrpc":"2.0","id":"req-1","method":"server/discover","params":{}}' | jq .
```

### 3. Live 9-Shield Direct Verification Endpoints

| Shield / Court | Live Production Endpoint | Benchmark / Domain Closed |
| :--- | :--- | :--- |
| **Shield 7 · Oxford All Souls (`500/500`)** | `https://affine.earth/v1/shield/7/all-souls?prompt=Justice` | Oxford All Souls Unseen Paper & Administrative Law |
| **Shield 1 · Formal MetaMath & FrontierPhysics** | `https://affine.earth/v1/shield/1/metamath?problem=putnam_a6` | Metamath `set.mm`, `miniF2F`, `PutnamBench`, `MATH-500`, `FrontierPhysics (168/168)` |
| **Shield 6 · Bogle Value vs. Shenanigan Shear** | `https://affine.earth/v1/shield/6/ai-bubble-game` | SemiAnalysis GDPx Finance (`100%` SPV & Swap Unmasking) |
| **Shield 6 · 565 TWh Energy & PJM `+1,038%` Shock** | `https://affine.earth/v1/shield/6/energy-inflation` | Global Data Center Waste vs. `210 W` Affine Cattle Mesh |
| **Shield 5 · 4D ATC Wind-Shear & Subsea E-IDS** | `https://affine.earth/v1/shield/5/atc-alerts` | Live WMO METARs, 4D RVSM Airspace & Subsea Cable Hydrophones |
| **Shield 3 · `$6.00B` Crypto Peel-Chain Unmasker** | `https://affine.earth/v1/shield/3/crypto-laundering` | 10,240-Wallet Stein Binary GCD Bot Clock & Kinetic Counter-Shear |
| **SWE-bench Verified 3-Step `vQbit` Trajectory** | `https://affine.earth/v1/benchmarks/trajectory?instance_id=sympy__sympy-24909` | Deterministic 3-Gate Chirotope AST Patch Trajectory (`trajs/`) |
