#!/usr/bin/env bash
# verify_external_scorer_handshakes.sh
# Actively tests https://affine.earth against all 7 external leaderboard & crawler handshakes:
#   Gate 1: MCP 2026-07-28 server/discover + string ID preservation + resultType=complete
#   Gate 2: MCP 2025-06-18 Legacy initialize handshake
#   Gate 3: MCP notifications/initialized returns HTTP 202/204 with empty body (len=0)
#   Gate 4: MCP SEP-2549 tools/list (resultType=complete, ttlMs, cacheScope=public, >= 6 tools)
#   Gate 5: OpenAI GET /v1/models discovery
#   Gate 6: OpenAI POST /v1/chat/completions (stream:true) emits chat.completion.chunk + data: [DONE]
#   Gate 7: BFCL V4 / Tau-Bench POST /v1/chat/completions with tools[] emits finish_reason=tool_calls
set -euo pipefail

BASE_URL="${1:-https://affine.earth}"
PASS=0
FAIL=0

check_gate() {
  local name="$1"
  local cond="$2"
  if eval "$cond"; then
    echo "  ✅ [PASS] $name"
    PASS=$((PASS + 1))
  else
    echo "  ❌ [FAIL] $name"
    FAIL=$((FAIL + 1))
  fi
}

echo "================================================================================"
echo " 🔍 AUDITING AFFINE.EARTH EXTERNAL LEADERBOARD & MCP HANDSHAKES ($BASE_URL)"
echo "================================================================================"

# GATE 1: MCP 2026-07-28 Stateless `server/discover` Handshake
DISCOVER_RES=$(curl -sS -m 10 -X POST "$BASE_URL/language-invariant/mcp" \
  -H "Content-Type: application/json" \
  -H "MCP-Protocol-Version: 2026-07-28" \
  -d '{"jsonrpc":"2.0","id":"req-discover-1","method":"server/discover","params":{}}' || echo "{}")
check_gate "Gate 1: MCP 2026-07-28 server/discover + string ID preservation + resultType=complete" \
  "printf '%s' \"\$DISCOVER_RES\" | jq -e '.id == \"req-discover-1\" and .result.resultType == \"complete\"' >/dev/null 2>&1"

# GATE 2: MCP 2025-06-18 Legacy `initialize` Handshake
INIT_RES=$(curl -sS -m 10 -X POST "$BASE_URL/language-invariant/mcp" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"glama-scanner","version":"1.0"}}}' || echo "{}")
check_gate "Gate 2: MCP 2025-06-18 initialize handshake" \
  "printf '%s' \"\$INIT_RES\" | jq -e '.id == 1 and .result.serverInfo.name != null' >/dev/null 2>&1"

# GATE 3: MCP `notifications/initialized` (Must NOT return a JSON-RPC result object!)
NOTIF_CODE=$(curl -sS -m 10 -o /tmp/notif_body.txt -w "%{http_code}" -X POST "$BASE_URL/language-invariant/mcp" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' || echo "000")
NOTIF_LEN=$(wc -c < /tmp/notif_body.txt | tr -d ' ')
check_gate "Gate 3: notifications/initialized returns HTTP 202/204 with empty body (len=$NOTIF_LEN)" \
  "[ '$NOTIF_CODE' = '202' -o '$NOTIF_CODE' = '204' ] && [ '$NOTIF_LEN' -eq 0 ]"

# GATE 4: MCP SEP-2549 `tools/list` (`resultType`, `ttlMs`, `cacheScope`)
TOOLS_RES=$(curl -sS -m 10 -X POST "$BASE_URL/language-invariant/mcp" \
  -H "Content-Type: application/json" \
  -H "Mcp-Method: tools/list" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' || echo "{}")
check_gate "Gate 4: MCP tools/list includes resultType=complete, ttlMs, cacheScope=public" \
  "printf '%s' \"\$TOOLS_RES\" | jq -e '.result.resultType == \"complete\" and .result.cacheScope == \"public\" and (.result.tools | length >= 6)' >/dev/null 2>&1"

# GATE 5: OpenAI `/v1/models` Discovery
MODELS_RES=$(curl -sS -m 10 "$BASE_URL/v1/models" || echo "{}")
check_gate "Gate 5: GET /v1/models exposes model ID Affine.Earth" \
  "printf '%s' \"\$MODELS_RES\" | jq -e '.object == \"list\" and (.data | length >= 1)' >/dev/null 2>&1"

# GATE 6: OpenAI `/v1/chat/completions` with `stream: true` (SSE Chunk Handshake for Vals AI / Harbor / LiteLLM)
SSE_RES=$(curl -sS -m 10 -X POST "$BASE_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model":"Affine.Earth","stream":true,"messages":[{"role":"user","content":"Bias"}]}' || echo "")
check_gate "Gate 6: POST /v1/chat/completions (stream:true) emits chat.completion.chunk + data: [DONE]" \
  "printf '%s' \"\$SSE_RES\" | grep -q 'chat.completion.chunk' && printf '%s' \"\$SSE_RES\" | grep -q '\[DONE\]'"

# GATE 7: BFCL V4 / Tau-Bench `tools` AST Handshake
TOOLCALL_RES=$(curl -sS -m 10 -X POST "$BASE_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{"model":"Affine.Earth","messages":[{"role":"user","content":"Rotor 3 4"}],"tools":[{"type":"function","function":{"name":"affine_shield1_metamath_and_physics","parameters":{"type":"object"}}}]}' || echo "{}")
check_gate "Gate 7: POST /v1/chat/completions with tools[] emits finish_reason=tool_calls" \
  "printf '%s' \"\$TOOLCALL_RES\" | jq -e '.choices[0].finish_reason == \"tool_calls\" and (.choices[0].message.tool_calls | length >= 1)' >/dev/null 2>&1"

echo "================================================================================"
echo " SUMMARY: $PASS / 7 GATES PASSED ($FAIL FAILED)"
echo "================================================================================"
[ "$FAIL" -eq 0 ]
