"""CrewAI tool that POSTs to affine.earth. Computes no court."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from affine_earth import court_ingest, tools_list  # noqa: E402


class AffineEarthMathCourt:
    name = "affine_earth_math_court"
    description = (
        "Deterministic no-float Math Court on affine.earth. "
        "List MCP tools or POST an integer court claim."
    )

    def list_tools(self) -> str:
        return json.dumps(tools_list())

    def court(self, domain: str, source: str, role: str, claim_json: str) -> str:
        claim = json.loads(claim_json or "{}")
        claim["source"] = source
        claim["role"] = role
        code, body = court_ingest(domain, claim)
        return json.dumps({"http": code, "body": body})


try:
    from crewai.tools import tool

    @tool("affine_earth_tools_list")
    def affine_earth_tools_list() -> str:
        return AffineEarthMathCourt().list_tools()

    @tool("affine_earth_court")
    def affine_earth_court(domain: str, source: str, role: str, claim_json: str) -> str:
        return AffineEarthMathCourt().court(domain, source, role, claim_json)
except ImportError:
    pass
