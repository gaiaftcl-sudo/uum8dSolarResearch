"""LangChain @tool that POSTs to affine.earth. Computes no court."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from affine_earth import court_ingest, tools_call, tools_list  # noqa: E402


def affine_earth_tools_list() -> str:
    return json.dumps(tools_list())


def affine_earth_tools_call(name: str, arguments_json: str = "{}") -> str:
    args = json.loads(arguments_json or "{}")
    return json.dumps(tools_call(name, args))


def affine_earth_court(domain: str, source: str, role: str, claim_json: str) -> str:
    claim = json.loads(claim_json or "{}")
    claim["source"] = source
    claim["role"] = role
    code, body = court_ingest(domain, claim)
    return json.dumps({"http": code, "body": body})


try:
    from langchain_core.tools import tool

    affine_earth_tools_list = tool(affine_earth_tools_list)  # type: ignore[assignment]
    affine_earth_tools_call = tool(affine_earth_tools_call)  # type: ignore[assignment]
    affine_earth_court = tool(affine_earth_court)  # type: ignore[assignment]
except ImportError:
    pass
