#!/usr/bin/env python3
"""STDIO → HTTPS JSON-RPC proxy for the Affine.Earth Math Court.

Local IDEs that only speak MCP-over-STDIO get the live membrane.
This process computes no court. It frames and forwards.
"""
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request

APEX = os.environ.get("AFFINE_APEX", "https://affine.earth").rstrip("/")
MCP = APEX + "/language-invariant/mcp"


def _read_message() -> dict | None:
    headers: dict[str, str] = {}
    while True:
        line = sys.stdin.buffer.readline()
        if not line:
            return None
        if line in (b"\r\n", b"\n"):
            break
        raw = line.decode("ascii", errors="replace").strip()
        if ":" in raw:
            k, v = raw.split(":", 1)
            headers[k.strip().lower()] = v.strip()
    n = int(headers.get("content-length") or "0")
    if n <= 0:
        return None
    body = sys.stdin.buffer.read(n)
    return json.loads(body.decode())


def _write_message(obj: dict) -> None:
    data = json.dumps(obj, separators=(",", ":")).encode()
    sys.stdout.buffer.write(
        ("Content-Length: %d\r\n\r\n" % len(data)).encode("ascii")
    )
    sys.stdout.buffer.write(data)
    sys.stdout.buffer.flush()


def _forward(msg: dict) -> dict:
    body = json.dumps(msg).encode()
    req = urllib.request.Request(
        MCP,
        data=body,
        headers={"content-type": "application/json", "accept": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        raw = e.read().decode()
        try:
            return json.loads(raw)
        except json.JSONDecodeError:
            return {
                "jsonrpc": "2.0",
                "id": msg.get("id"),
                "error": {"code": -32000, "message": "http %s" % e.code},
            }


def main() -> int:
    while True:
        msg = _read_message()
        if msg is None:
            return 0
        if msg.get("method") and msg.get("id") is None:
            _forward(msg)
            continue
        _write_message(_forward(msg))


if __name__ == "__main__":
    raise SystemExit(main())
