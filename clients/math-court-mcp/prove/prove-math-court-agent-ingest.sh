#!/usr/bin/env bash
# Three arms an agent builder runs against the live membrane.
set -euo pipefail
APEX="${AFFINE_APEX:-https://affine.earth}"
CURL=(curl -sS --max-time 20)

fail() { echo "REFUSED: $*" >&2; exit 1; }

list="$("${CURL[@]}" -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":"ingest","method":"tools/list"}' \
  "$APEX/language-invariant/mcp")"
echo "$list" | python3 -c '
import json,sys
d=json.load(sys.stdin)
tools=((d.get("result") or {}).get("tools") or [])
names=[t.get("name") for t in tools]
need=["execute_transition","verify_jordan_bond","membrane_health","umc_status"]
missing=[n for n in need if n not in names]
if missing:
    raise SystemExit("missing tools: "+",".join(missing))
print("ARM1 tools/list n=%d" % len(tools))
'

code="$(curl -sS --max-time 15 -o /tmp/mc-float.json -w '%{http_code}' \
  -H 'content-type: application/json' \
  -d '{"source":"agent-ingest","role":"cad_engineer","polytope_id":"unit_square","dilation":1.5}' \
  "$APEX/language-invariant/game/geometry/ingest")"
[[ "$code" == "400" ]] || fail "float arm http=$code want 400"
python3 -c '
import json
d=json.load(open("/tmp/mc-float.json"))
s=d.get("status") or ""
if s != "REFUSED_FLOAT":
    raise SystemExit("float arm status="+s)
print("ARM2 REFUSED_FLOAT")
'

python3 - <<'PY'
import json, urllib.request, os
apex = os.environ.get("AFFINE_APEX", "https://affine.earth")
body = json.dumps({
    "source": "agent-ingest",
    "role": "cad_engineer",
    "polytope_id": "unit_square",
    "dilation": 12,
}).encode()
req = urllib.request.Request(
    apex + "/language-invariant/game/geometry/ingest",
    data=body,
    headers={"content-type": "application/json"},
    method="POST",
)
with urllib.request.urlopen(req, timeout=20) as r:
    d = json.loads(r.read().decode())
lc = d.get("lattice_court") or {}
if d.get("status") != "CALORIE_GAME_INGEST":
    raise SystemExit("integer arm status="+str(d.get("status")))
if lc.get("verdict") != "WIN":
    raise SystemExit("integer arm verdict="+str(lc.get("verdict")))
if lc.get("lattice_count") != 169:
    raise SystemExit("integer arm count="+str(lc.get("lattice_count")))
print("ARM3 WIN count=%s vol=%s float_adversary=%s" % (
    lc.get("lattice_count"), lc.get("volume"), lc.get("float_adversary")))
PY

echo "MATH_COURT_AGENT_INGEST_PROVEN"
