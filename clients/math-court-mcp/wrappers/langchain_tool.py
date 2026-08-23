"""LangChain tools — one named tool per live membrane tool. POST only."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from tools import NAMED, LIVE_TOOL_NAMES, court_ingest  # noqa: E402


def _as_json(fn, **kwargs):
    return json.dumps(fn(**kwargs), default=str)


try:
    from langchain_core.tools import StructuredTool

    LANGCHAIN_TOOLS = []
    for name in LIVE_TOOL_NAMES:
        fn = NAMED[name]
        LANGCHAIN_TOOLS.append(
            StructuredTool.from_function(
                func=lambda _fn=fn, **kwargs: _as_json(_fn, **kwargs),
                name=name.replace(".", "_"),
                description="Affine.Earth MCP tool %s. Forwards to affine.earth." % name,
            )
        )
    LANGCHAIN_TOOLS.append(
        StructuredTool.from_function(
            func=lambda domain, source, role, **claim: _as_json(
                court_ingest, domain=domain, source=source, role=role, **claim
            ),
            name="court_ingest",
            description="POST an integer lattice-court claim. Floats refused.",
        )
    )
except ImportError:
    LANGCHAIN_TOOLS = []
