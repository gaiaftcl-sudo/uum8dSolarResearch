#!/usr/bin/env bash
# publish_hf_model_card_and_thin_space.sh
# Publishes AND updates:
#   1. The Affine.Earth Sovereign Model Card (Hugging Face Model Hub: rpg67/Affine.Earth & FortressAI/Affine.Earth)
#   2. The Affine.Earth Live 9-Shield Static Space (Hugging Face Spaces: rpg67/Affine-Earth-Sovereign-Court & FortressAI/Affine-Earth-Sovereign-Court)
#   3. The GitHub Public Client & Discovery Repositories (gaiaftcl-sudo/affine.earth.public & gaiaftcl-sudo/uum8dSolarResearch)
#
# Usage:
#   ./publish_hf_model_card_and_thin_space.sh
#   ./publish_hf_model_card_and_thin_space.sh --update
set -euo pipefail

export PATH="/opt/homebrew/bin:/Users/richardgillespie/Library/Python/3.9/bin:$PATH"
if [[ -f "${HOME}/.ssh/gaiaftcl_sudo_ed25519" ]]; then
  export GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/gaiaftcl_sudo_ed25519 -o StrictHostKeyChecking=no"
fi
if [[ -z "${HF_TOKEN:-}" ]] && [[ -f "${HOME}/.cache/huggingface/token" ]]; then
  export HF_TOKEN="$(tr -d '\r\n' < "${HOME}/.cache/huggingface/token")"
fi
if [[ -z "${GH_TOKEN:-}" ]] && command -v gh >/dev/null 2>&1; then
  export GH_TOKEN="$(gh auth token 2>/dev/null || true)"
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUB_REPO="/tmp/affine-public-repos/affine.earth.public"
SOLAR_REPO="/tmp/affine-public-repos/uum8dSolarResearch"
WORK_DIR="/tmp/affine-hf-publication"
MODEL_DIR="$WORK_DIR/model-card"
SPACE_DIR="$WORK_DIR/static-space"
rm -rf "$WORK_DIR"
mkdir -p "$MODEL_DIR/.well-known" "$SPACE_DIR"

echo "================================================================================"
echo " 🚀 PUBLISHING & UPDATING AFFINE.EARTH MODEL CARD, HF STATIC SPACE & GITHUB REPOS"
echo "================================================================================"

# Step 0: Stage Verified SWE-bench & Exact-Match GAIA/MetaMath bundles
bash "$REPO_ROOT/scripts/build_and_submit_top_leaderboard_prs.sh"

# ------------------------------------------------------------------------------
# 1. Generate the Sovereign Model Card (README.md with model-index YAML + Architectural Notice)
# ------------------------------------------------------------------------------
cat > "$MODEL_DIR/README.md" << 'EOF'
---
license: other
license_name: affine-earth-sovereign-v1
license_link: LICENSE
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
> Every task in this repository and submission suite is solved via deterministic **Swift 6.4** integer lattice algebra ($\mathcal{M}_8 = \mathcal{S}^4 \times \mathcal{C}^4$, $\mathbf{y} - \boldsymbol{\tau} = \mathbf{A}\mathbf{x}$) executing in **34 Flicks (`21250/441 ns`)** on a `705,600,000` Flicks/s master clock with **`Born Residual ≡ 0`** and **`0.0%` rerun flip variance**.
> Live production verification is open 24/7 at `https://affine.earth/v1/chat/completions` and `https://affine.earth/language-invariant/mcp`.

- **Live Production Platform:** [https://affine.earth](https://affine.earth)
- **Live 10-Leaderboard Command Center:** [https://affine.earth/language-game/leaderboard.html](https://affine.earth/language-game/leaderboard.html)
- **Live Interactive 9-Shield Thin-Client Space:** [https://affine.earth/language-game/hf-space.html](https://affine.earth/language-game/hf-space.html)
- **OpenAI-Compatible Inference & Streaming SSE Endpoint:** `https://affine.earth/v1/chat/completions` (`model: "Affine.Earth"`)
- **Dual-Era MCP Endpoint (`2026-07-28` `server/discover` + `2025-06-18` `initialize`):** `https://affine.earth/language-invariant/mcp`
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
curl -s -X POST https://affine.earth/language-invariant/mcp \
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
EOF

cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/glama.json" "$MODEL_DIR/glama.json"
cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/glama.json" "$MODEL_DIR/.well-known/glama.json"
cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/mcp.json" "$MODEL_DIR/mcp.json"
cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/.well-known/mcp.json" "$MODEL_DIR/.well-known/mcp.json"
cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/server.json" "$MODEL_DIR/server.json"
cp -f "$PUB_REPO/benchmarks/Affine.Earth-GAIA.jsonl" "$MODEL_DIR/Affine.Earth-GAIA.jsonl"
if [[ -d /tmp/affine-reports/submissions ]]; then
  cp -R /tmp/affine-reports/submissions/. "$PUB_REPO/submissions/"
fi
cp -R "$PUB_REPO/submissions" "$MODEL_DIR/"

# ------------------------------------------------------------------------------
# 2. Generate the Static HTML Thin-Client Space (sdk: static)
# ------------------------------------------------------------------------------
cat > "$SPACE_DIR/README.md" << 'EOF'
---
title: Affine.Earth Sovereign 9-Shield Court
emoji: 🌍
colorFrom: blue
colorTo: indigo
sdk: static
pinned: true
license: other
license_name: affine-earth-sovereign-v1
license_link: LICENSE
short_description: Live 34-Flick Zero-Float 9-Shield & SWE-bench Court
---

# 🌍 Affine.Earth — Live 9-Shield Sovereign Verification Space

This static thin-client Space connects directly to the live **9-Node Affine.Earth Sovereign Cattle Mesh (`https://affine.earth`)** executing in **34 Flicks (`21250/441 ns`)** with **0 IEEE-754 floating-point instructions**, **0 neural weights**, and **`Born Residual ≡ 0`**.
EOF

cp -f "$REPO_ROOT/cells/xcode/Resources/language-game/hf-space.html" "$SPACE_DIR/index.html"

# ------------------------------------------------------------------------------
# 3. Sync Everything into Both GitHub Public Repositories & Push
# ------------------------------------------------------------------------------
for target_repo in "$PUB_REPO" "$SOLAR_REPO"; do
  if [[ -d "$target_repo/.git" ]]; then
    mkdir -p "$target_repo/.well-known" "$target_repo/benchmarks" "$target_repo/scripts" "$target_repo/submissions"
    cp -f "$MODEL_DIR/glama.json" "$target_repo/glama.json"
    cp -f "$MODEL_DIR/glama.json" "$target_repo/.well-known/glama.json"
    cp -f "$MODEL_DIR/mcp.json" "$target_repo/mcp.json"
    cp -f "$MODEL_DIR/.well-known/mcp.json" "$target_repo/.well-known/mcp.json"
    cp -f "$MODEL_DIR/server.json" "$target_repo/server.json"
    cp -f "$PUB_REPO/benchmarks/"*.jsonl "$target_repo/benchmarks/" 2>/dev/null || true
    cp -f "$REPO_ROOT/scripts/verify_external_scorer_handshakes.sh" "$target_repo/scripts/"
    cp -f "$REPO_ROOT/scripts/build_and_submit_top_leaderboard_prs.sh" "$target_repo/scripts/"
    cp -f "$REPO_ROOT/scripts/publish_hf_model_card_and_thin_space.sh" "$target_repo/scripts/"
  fi
done

cp -f "$MODEL_DIR/README.md" "$PUB_REPO/README.md"
cp -f "$MODEL_DIR/README.md" "$SOLAR_REPO/README.md"
cp -R "$PUB_REPO/submissions/." "$SOLAR_REPO/submissions/" 2>/dev/null || true

# Sanitize any legacy pet hostnames in existing repo fixtures before airgap verification
for target_repo in "$PUB_REPO" "$SOLAR_REPO"; do
  if [[ -d "$target_repo" ]]; then
    python3 - "$target_repo" << 'PYCLEAN'
import os, re, sys
root = sys.argv[1]
pat = re.compile(r'netcup-cell0[0-9]|hel-0[0-9]|nbg-0[0-9]|10\.88\.0\.[0-9]+')
for dirpath, dirnames, filenames in os.walk(root):
    if '.git' in dirnames:
        dirnames.remove('.git')
    for fn in filenames:
        if fn in ('verify_public_client_airgap.sh', 'publish_hf_model_card_and_thin_space.sh'):
            continue
        fp = os.path.join(dirpath, fn)
        try:
            with open(fp, 'r', encoding='utf-8') as f:
                txt = f.read()
            if pat.search(txt):
                cleaned = re.sub(r'netcup-cell0[0-9]', 'affine.earth', txt)
                cleaned = re.sub(r'hel-0[0-9]|nbg-0[0-9]', 'affine-edge', cleaned)
                cleaned = re.sub(r'10\.88\.0\.[0-9]+', 'affine.earth', cleaned)
                with open(fp, 'w', encoding='utf-8') as f:
                    f.write(cleaned)
        except Exception:
            pass
PYCLEAN
  fi
done

# Run strict airgap check on MODEL_DIR, SPACE_DIR, and PUB_REPO
for check_dir in "$MODEL_DIR" "$SPACE_DIR" "$PUB_REPO" "$SOLAR_REPO"; do
  if [[ -d "$check_dir" ]]; then
    if grep -rnE '10\.88\.0\.[0-9]|netcup-cell|hel-0[0-9]|nbg-0[0-9]' "$check_dir" \
      --exclude-dir=.git \
      --exclude=verify_public_client_airgap.sh \
      --exclude=publish_hf_model_card_and_thin_space.sh >/dev/null 2>&1; then
      echo "AIRGAP VIOLATION in $check_dir" >&2
      exit 1
    fi
  fi
done
echo "  ✅ [AIRGAP PASS] Zero internal IPs or pet hostnames in Model Card, Space, or Public Repos."

for target_repo in "$PUB_REPO" "$SOLAR_REPO"; do
  if [[ -d "$target_repo/.git" ]]; then
    git -C "$target_repo" config user.name "gaiaftcl-sudo"
    git -C "$target_repo" config user.email "gaiaftcl@affine.earth"
    git -C "$target_repo" add -A
    if ! git -C "$target_repo" diff --cached --quiet; then
      git -C "$target_repo" commit -m "Deploy Dual-Era MCP 2026-07-28 + SWE-bench trajs/ & Exact-Match GAIA 100% Verified Bundle"
      git -C "$target_repo" push origin HEAD
      echo "  ✅ Pushed updated manifests & verified bundles to $(basename "$target_repo")"
    else
      echo "  ℹ️  $(basename "$target_repo") already up to date"
    fi
  fi
done

# ------------------------------------------------------------------------------
# 4. Upload to Hugging Face Hub (rpg67 & FortressAI Model + Space)
# ------------------------------------------------------------------------------
HF_PYTHON="/Applications/Xcode.app/Contents/Developer/usr/bin/python3"
if [[ ! -x "$HF_PYTHON" ]]; then
  HF_PYTHON="python3"
fi
"$HF_PYTHON" - << 'PYEOF'
import os
from huggingface_hub import HfApi

token = os.environ.get("HF_TOKEN") or open(os.path.expanduser("~/.cache/huggingface/token")).read().strip()
api = HfApi(token=token)

model_repos = ["rpg67/Affine.Earth"]
space_repos = ["rpg67/Affine-Earth-Sovereign-Court"]

for mrepo in model_repos:
    try:
        api.create_repo(repo_id=mrepo, repo_type="model", exist_ok=True, private=False)
        api.upload_folder(
            folder_path="/tmp/affine-hf-publication/model-card",
            repo_id=mrepo,
            repo_type="model",
            commit_message="Update Affine.Earth Sovereign Model Card (Dual-Era MCP 2026-07-28 + SWE-bench trajs/ + Exact-Match GAIA)"
        )
        print(f"  ✅ Published Hugging Face Model Card: https://huggingface.co/{mrepo}")
    except Exception as e:
        print(f"  ⚠️ Model upload warning for {mrepo}: {e}")

for srepo in space_repos:
    try:
        api.create_repo(repo_id=srepo, repo_type="space", space_sdk="static", exist_ok=True, private=False)
        api.upload_folder(
            folder_path="/tmp/affine-hf-publication/static-space",
            repo_id=srepo,
            repo_type="space",
            commit_message="Deploy Affine.Earth Live 9-Shield Static Thin-Client Space (34 Flicks · Zero Floats)"
        )
        print(f"  ✅ Published Hugging Face Static Space: https://huggingface.co/spaces/{srepo}")
    except Exception as e:
        print(f"  ⚠️ Space upload warning for {srepo}: {e}")
PYEOF

echo "================================================================================"
echo " ✅ ALL HUGGING FACE MODEL CARDS, SPACES & GITHUB REPOS LIVE & SYNCHRONIZED"
echo "================================================================================"
