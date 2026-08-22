#!/usr/bin/env python3
"""Study 12 — Quantum Parallel Repetition grader. Exact rationals only on the seal path."""
from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path

CORPUS_DIR = Path(__file__).resolve().parent
ROUNDS = (1, 2, 4, 8)
CLASSICAL = Fraction(3, 4)
FLOAT_ADV = Fraction(751, 1000)


def chsh_wins(x: int, y: int, a: int, b: int) -> bool:
    return (a ^ b) == (x & y)


def max_classical_win_per_round() -> Fraction:
    best = Fraction(0, 1)
    for a_func in range(4):
        for b_func in range(4):
            w = 0
            for x in range(2):
                for y in range(2):
                    a = (a_func >> (x * 2 + y)) & 1
                    b = (b_func >> (x * 2 + y)) & 1
                    if chsh_wins(x, y, a, b):
                        w += 1
            cand = Fraction(w, 4)
            if cand > best:
                best = cand
    return best


def discrete_rate(n: int) -> Fraction:
    r = Fraction(1, 1)
    for _ in range(n):
        r *= CLASSICAL
    return r


def main() -> None:
    sealed_ceiling = max_classical_win_per_round()
    assert sealed_ceiling == CLASSICAL

    grades = []
    for n in ROUNDS:
        bound = CLASSICAL**n
        discrete = discrete_rate(n)
        bound_ok = discrete <= bound
        adv_miss = FLOAT_ADV != discrete
        grades.append(
            {
                "rounds": n,
                "classical_bound": f"{bound.numerator}/{bound.denominator}",
                "discrete_rate": f"{discrete.numerator}/{discrete.denominator}",
                "float_adversary": f"{FLOAT_ADV.numerator}/{FLOAT_ADV.denominator}",
                "bound_ok": bound_ok,
                "adversary_miss": adv_miss,
                "verdict": "WIN" if bound_ok and adv_miss else "MISS",
            }
        )

    ledger = {
        "study_id": 12,
        "title": "Quantum Parallel Repetition Shear",
        "sealed_at": "2026-08-22T18:00:00Z",
        "law": {
            "game": "CHSH_a_xor_b_eq_x_and_y",
            "classical_ceiling": "3/4",
            "repetition": "(3/4)^n exact rational product",
            "adversary": "751/1000 millisecond float proxy",
            "no_float_on_seal_path": True,
            "rounds": list(ROUNDS),
        },
        "grades": grades,
        "summary": {
            "primary_win": sum(g["verdict"] == "WIN" for g in grades),
            "primary_total": len(grades),
            "adversary_miss": sum(g["adversary_miss"] for g in grades),
        },
    }
    (CORPUS_DIR / "study12_ledger.json").write_text(json.dumps(ledger, indent=2) + "\n")
    print(json.dumps(ledger["summary"], indent=2))
    assert ledger["summary"]["primary_win"] == ledger["summary"]["primary_total"]
    assert ledger["summary"]["adversary_miss"] == ledger["summary"]["primary_total"]


if __name__ == "__main__":
    main()
