"""CrewAI tools — one named tool per live membrane tool. POST only."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from tools import NAMED, LIVE_TOOL_NAMES, court_ingest  # noqa: E402

try:
    from crewai.tools import tool

    CREW_TOOLS = []
    for name in LIVE_TOOL_NAMES:
        fn = NAMED[name]

        @tool(name.replace(".", "_"))
        def _fwd(_fn=fn, **kwargs) -> str:
            return json.dumps(_fn(**kwargs), default=str)

        CREW_TOOLS.append(_fwd)

    @tool("court_ingest")
    def crew_court_ingest(domain: str, source: str, role: str, claim_json: str = "{}") -> str:
        claim = json.loads(claim_json or "{}")
        return json.dumps(court_ingest(domain, source, role, **claim), default=str)

    CREW_TOOLS.append(crew_court_ingest)
except ImportError:
    CREW_TOOLS = []
