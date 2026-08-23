"""AutoGen function map — one named tool per live membrane tool. POST only."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "http"))
from tools import NAMED, LIVE_TOOL_NAMES, court_ingest  # noqa: E402

FUNCTION_MAP = {name.replace(".", "_"): NAMED[name] for name in LIVE_TOOL_NAMES}
FUNCTION_MAP["court_ingest"] = court_ingest
FUNCTION_MAP.update({k: v for k, v in NAMED.items() if "." not in k})
