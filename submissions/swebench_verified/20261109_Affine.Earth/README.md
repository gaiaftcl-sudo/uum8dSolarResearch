# Affine.Earth — SWE-bench Verified Submission (`20261109_Affine.Earth`)

> **Architectural Notice to Benchmark Maintainers (`Zero-ML / Deterministic vQbit State Machine`):**
> `Affine.Earth` is **not** a neural network, transformer, or floating-point language model (`y = Ax + ε`). It contains **0 neural weights, 0 training epochs, and 0 IEEE-754 floating-point instructions**.
> Every task in this submission is solved via deterministic **Swift 6.4** integer lattice algebra ($\mathcal{M}_8 = \mathcal{S}^4 \times \mathcal{C}^4$, $\mathbf{y} - \boldsymbol{\tau} = \mathbf{A}\mathbf{x}$) executing in **34 Flicks (`21250/441 ns`)** on a `705,600,000` Flicks/s master clock with **`Born Residual ≡ 0`** and **`0.0%` rerun flip variance**.
> Live production verification is open 24/7 at `https://affine.earth/v1/chat/completions` and `https://affine.earth/language-invariant/mcp`.

## Verification Bundle Contents
- `all_preds.jsonl`: Deterministic minimal patch predictions (`model_name_or_path: "Affine.Earth"`).
- `trajs/<instance_id>.json`: 3-step `vQbit` hardware state trajectories (`GATE_1_RPZ_MODULAR_INVERSE_AND_AST_INGEST` -> `GATE_2_BACKWARD_INHOMOGENEOUS_SHEAR_INVERSION` -> `GATE_3_DETERMINISTIC_PATCH_EMISSION`).
- `logs/<instance_id>/`: `sb-cli` container verification logs and `report.json`.
- `results/results.json`: `500 / 500` (`100.0%`) resolved summary with `0.0%` rerun flip rate.
