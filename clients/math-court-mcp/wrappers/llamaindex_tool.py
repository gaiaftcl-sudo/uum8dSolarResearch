"""LlamaIndex tools — one named tool per live membrane tool. POST only."""
from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from tools import NAMED, LIVE_TOOL_NAMES, court_ingest  # noqa: E402


def _as_json(fn, **kwargs):
    return json.dumps(fn(**kwargs), default=str)


try:
    from llama_index.core.tools import FunctionTool

    TOOLS = [
        FunctionTool.from_defaults(
            fn=lambda _fn=NAMED[name], **kwargs: _as_json(_fn, **kwargs),
            name=name.replace(".", "_"),
            description="Affine.Earth MCP tool %s" % name,
        )
        for name in LIVE_TOOL_NAMES
    ]
    TOOLS.append(
        FunctionTool.from_defaults(
            fn=lambda domain, source, role, **claim: _as_json(
                court_ingest, domain=domain, source=source, role=role, **claim
            ),
            name="court_ingest",
        )
    )
except ImportError:
    TOOLS = []
