"""Named client tools for the live Affine.Earth Math Court.

Each function forwards JSON to affine.earth. None of them compute a court.
Generated from the live tools/list on 2026-08-23.
"""
from __future__ import annotations

from typing import Any

from affine_earth import court_ingest as _court_ingest
from affine_earth import tools_call, tools_list

LIVE_TOOL_NAMES = [
    "atc.assert_4d_deconfliction",
    "corpus_bonds",
    "critique_frame",
    "execute_transition",
    "feeds_catalog",
    "game_frame_meta",
    "ide_rebuild_mesh",
    "membrane_health",
    "noaa_goes_r_weather",
    "twin.robotics.evaluate_exact_ik",
    "umc_direct",
    "umc_resume",
    "umc_status",
    "verify_jordan_bond",
    "weather.convective_containment",
]


def _call(name: str, **kwargs: Any) -> Any:
    args = {k: v for k, v in kwargs.items() if v is not None}
    return tools_call(name, args)


def atc_assert_4d_deconfliction(**kwargs: Any) -> Any:
    """Forward atc.assert_4d_deconfliction to the live membrane."""
    return _call("atc.assert_4d_deconfliction", **kwargs)


def corpus_bonds(**kwargs: Any) -> Any:
    """Forward corpus_bonds to the live membrane."""
    return _call("corpus_bonds", **kwargs)


def critique_frame(**kwargs: Any) -> Any:
    """Forward critique_frame to the live membrane."""
    return _call("critique_frame", **kwargs)


def execute_transition(**kwargs: Any) -> Any:
    """Forward execute_transition to the live membrane."""
    return _call("execute_transition", **kwargs)


def feeds_catalog(**kwargs: Any) -> Any:
    """Forward feeds_catalog to the live membrane."""
    return _call("feeds_catalog", **kwargs)


def game_frame_meta(**kwargs: Any) -> Any:
    """Forward game_frame_meta to the live membrane."""
    return _call("game_frame_meta", **kwargs)


def ide_rebuild_mesh(**kwargs: Any) -> Any:
    """Forward ide_rebuild_mesh to the live membrane."""
    return _call("ide_rebuild_mesh", **kwargs)


def membrane_health(**kwargs: Any) -> Any:
    """Forward membrane_health to the live membrane."""
    return _call("membrane_health", **kwargs)


def noaa_goes_r_weather(**kwargs: Any) -> Any:
    """Forward noaa_goes_r_weather to the live membrane."""
    return _call("noaa_goes_r_weather", **kwargs)


def twin_robotics_evaluate_exact_ik(**kwargs: Any) -> Any:
    """Forward twin.robotics.evaluate_exact_ik to the live membrane."""
    return _call("twin.robotics.evaluate_exact_ik", **kwargs)


def umc_direct(**kwargs: Any) -> Any:
    """Forward umc_direct to the live membrane."""
    return _call("umc_direct", **kwargs)


def umc_resume(**kwargs: Any) -> Any:
    """Forward umc_resume to the live membrane."""
    return _call("umc_resume", **kwargs)


def umc_status(**kwargs: Any) -> Any:
    """Forward umc_status to the live membrane."""
    return _call("umc_status", **kwargs)


def verify_jordan_bond(**kwargs: Any) -> Any:
    """Forward verify_jordan_bond to the live membrane."""
    return _call("verify_jordan_bond", **kwargs)


def weather_convective_containment(**kwargs: Any) -> Any:
    """Forward weather.convective_containment to the live membrane."""
    return _call("weather.convective_containment", **kwargs)


def court_ingest(domain: str, source: str, role: str, **claim: Any) -> Any:
    """POST an integer court claim. Floats are refused by the cell."""
    body = dict(claim)
    body["source"] = source
    body["role"] = role
    code, data = _court_ingest(domain, body)
    return {"http": code, "body": data}


NAMED = {
    "atc.assert_4d_deconfliction": atc_assert_4d_deconfliction,
    "atc_assert_4d_deconfliction": atc_assert_4d_deconfliction,
    "corpus_bonds": corpus_bonds,
    "corpus_bonds": corpus_bonds,
    "critique_frame": critique_frame,
    "critique_frame": critique_frame,
    "execute_transition": execute_transition,
    "execute_transition": execute_transition,
    "feeds_catalog": feeds_catalog,
    "feeds_catalog": feeds_catalog,
    "game_frame_meta": game_frame_meta,
    "game_frame_meta": game_frame_meta,
    "ide_rebuild_mesh": ide_rebuild_mesh,
    "ide_rebuild_mesh": ide_rebuild_mesh,
    "membrane_health": membrane_health,
    "membrane_health": membrane_health,
    "noaa_goes_r_weather": noaa_goes_r_weather,
    "noaa_goes_r_weather": noaa_goes_r_weather,
    "twin.robotics.evaluate_exact_ik": twin_robotics_evaluate_exact_ik,
    "twin_robotics_evaluate_exact_ik": twin_robotics_evaluate_exact_ik,
    "umc_direct": umc_direct,
    "umc_direct": umc_direct,
    "umc_resume": umc_resume,
    "umc_resume": umc_resume,
    "umc_status": umc_status,
    "umc_status": umc_status,
    "verify_jordan_bond": verify_jordan_bond,
    "verify_jordan_bond": verify_jordan_bond,
    "weather.convective_containment": weather_convective_containment,
    "weather_convective_containment": weather_convective_containment,
    "court_ingest": court_ingest,
}

