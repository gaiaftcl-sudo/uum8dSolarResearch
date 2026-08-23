"""Affine.Earth Math Court — HTTP client only.

No volume. No Ehrhart. No Eisenstein. POST integers; read the sealed receipt.
The law lives on https://affine.earth. This file is a door.
"""
from __future__ import annotations

import json
import os
import urllib.error
import urllib.request
from typing import Any

APEX = os.environ.get("AFFINE_APEX", "https://affine.earth").rstrip("/")
MCP = APEX + "/language-invariant/mcp"
COURT = APEX + "/language-invariant/game/{domain}/ingest"
CATALOG = APEX + "/language-invariant/games"


def _post(url: str, payload: dict[str, Any], timeout: int = 20) -> tuple[int, Any]:
    body = json.dumps(payload).encode()
    req = urllib.request.Request(
        url,
        data=body,
        headers={"content-type": "application/json", "accept": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            raw = r.read().decode()
            return r.status, json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        raw = e.read().decode()
        try:
            return e.code, json.loads(raw) if raw else {"status": "HTTP_%s" % e.code}
        except json.JSONDecodeError:
            return e.code, {"status": "HTTP_%s" % e.code, "body": raw}


def _get(url: str, timeout: int = 20) -> tuple[int, Any]:
    req = urllib.request.Request(url, headers={"accept": "application/json"}, method="GET")
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.status, json.loads(r.read().decode())


def mcp(method: str, params: dict[str, Any] | None = None, rpc_id: str = "client") -> Any:
    """JSON-RPC to the live membrane. Does not interpret the result."""
    payload: dict[str, Any] = {"jsonrpc": "2.0", "id": rpc_id, "method": method}
    if params is not None:
        payload["params"] = params
    code, data = _post(MCP, payload)
    if code != 200:
        raise RuntimeError("mcp http=%s body=%s" % (code, data))
    return data


def tools_list() -> list[str]:
    data = mcp("tools/list")
    tools = ((data.get("result") or {}).get("tools") or [])
    return [t.get("name") for t in tools if t.get("name")]


def tools_call(name: str, arguments: dict[str, Any]) -> Any:
    return mcp("tools/call", {"name": name, "arguments": arguments})


def catalog() -> Any:
    code, data = _get(CATALOG)
    if code != 200:
        raise RuntimeError("catalog http=%s" % code)
    return data


def court_ingest(domain: str, claim: dict[str, Any]) -> tuple[int, Any]:
    """POST a sourced integer claim. Floats are refused by the cell, not here."""
    return _post(COURT.format(domain=domain), claim)
