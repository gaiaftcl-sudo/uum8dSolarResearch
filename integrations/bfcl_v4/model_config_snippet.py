# Berkeley Function Calling Leaderboard v4 (ShishirPatil/gorilla)
# Canonical OpenAI-compatible Function Calling registration for Affine.Earth
# Requires: export AFFINE_API_KEY="<founder-issued-bearer-key>"

from bfcl_eval.model_handler.api_inference.openai_completion import OpenAICompletionsHandler
from bfcl_eval.constants.enums import ModelStyle

AFFINE_EARTH_BFCL_MODELS = {
    "affine-uum8d-s4-FC": {
        "model_name": "affine-uum8d-s4",
        "model_handler": OpenAICompletionsHandler,
        "url": "https://affine.earth/leaderboard",
        "org": "Affine.Earth",
        "license": "Proprietary",  # Source-Available: LicenseRef-Affine-Earth-Sovereign-1.0
        "model_style": ModelStyle.OPENAI_COMPLETIONS,
        "is_fc_model": True,
        "base_url": "https://affine.earth/v1",
        "api_key_env": "AFFINE_API_KEY",
    },
    "affine-vqbit-FC": {
        "model_name": "affine-vqbit",
        "model_handler": OpenAICompletionsHandler,
        "url": "https://affine.earth/leaderboard",
        "org": "Affine.Earth",
        "license": "Proprietary",  # Source-Available: LicenseRef-Affine-Earth-Sovereign-1.0
        "model_style": ModelStyle.OPENAI_COMPLETIONS,
        "is_fc_model": True,
        "base_url": "https://affine.earth/v1",
        "api_key_env": "AFFINE_API_KEY",
    },
}
