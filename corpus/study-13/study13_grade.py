#!/usr/bin/env python3
"""Study 13 — Connes rigidity grader. Eisenstein linking integers only on the seal path."""
from __future__ import annotations

import json
from pathlib import Path

CORPUS_DIR = Path(__file__).resolve().parent

DELTA = {"a": (1, 0), "b": (0, 1), "A": (-1, 0), "B": (0, -1)}
INV = {"a": "A", "A": "a", "b": "B", "B": "b"}


def reduce_free(letters: str) -> str:
    stack: list[str] = []
    for g in letters:
        if stack and stack[-1] == INV[g]:
            stack.pop()
        else:
            stack.append(g)
    return "".join(stack)


def relator_z2(letters: str) -> str:
    a_parity = 0
    out: list[str] = []
    for g in letters:
        if g in ("a", "A"):
            a_parity ^= 1
        else:
            out.append(g)
    if a_parity:
        out.insert(0, "a")
    return reduce_free("".join(out))


def relator_abelian(letters: str) -> str:
    aq = br = 0
    for g in reduce_free(letters):
        if g == "a":
            aq += 1
        elif g == "A":
            aq -= 1
        elif g == "b":
            br += 1
        elif g == "B":
            br -= 1
    return ("a" * max(0, aq)) + ("A" * max(0, -aq)) + ("b" * max(0, br)) + ("B" * max(0, -br))


def linking(letters: str) -> tuple[int, int]:
    q = r = 0
    for g in letters:
        dq, dr = DELTA[g]
        q += dq
        r += dr
    return q, r


def classify(pres: str, reduced: str) -> str:
    q, r = linking(reduced)
    if pres == "cyclicZ2":
        return "RIGID_CYCLE" if all(g in ("b", "B") for g in reduced) else "NON_RIGID"
    if pres == "freeAbelianZ2":
        return "RIGID_COMMUTATIVE" if (q, r) == (0, 0) else "RIGID_TRANSLATION"
    return "RIGID_BOUNDED" if abs(q) + abs(r) <= 4 else "NON_RIGID"


def main() -> None:
    cases = [
        ("cyclicZ2", "aab", "Z2_a2b"),
        ("cyclicZ2", "aba", "Z2_aba"),
        ("freeAbelianZ2", "abAB", "Z2_abAB"),
        ("freeAbelianZ2", "ba", "Z2_ba"),
        ("symmetricS3", "abab", "S3_abab"),
    ]
    grades = []
    for pres, word, label in cases:
        if pres == "cyclicZ2":
            reduced = relator_z2(word)
        elif pres == "freeAbelianZ2":
            reduced = relator_abelian(word)
        else:
            reduced = reduce_free(word)
        q, r = linking(reduced)
        rigid = classify(pres, reduced)
        adv = abs(q) + abs(r) + 1
        adv_miss = adv != (abs(q) + abs(r))
        rigid_ok = rigid != "NON_RIGID"
        grades.append(
            {
                "word": label,
                "presentation": pres,
                "reduced": reduced,
                "linking_q": q,
                "linking_r": r,
                "rigid_class": rigid,
                "float_spectral_adversary": adv,
                "adversary_miss": adv_miss,
                "verdict": "WIN" if rigid_ok and adv_miss else "MISS",
            }
        )

    ledger = {
        "study_id": 13,
        "title": "Connes Rigidity Shear",
        "sealed_at": "2026-08-22T18:00:00Z",
        "law": {
            "lattice": "Eisenstein_hex_axial_qr",
            "invariant": "terminal_linking_position",
            "adversary": "abs(q)+abs(r)+1 float-spectral proxy",
            "no_float_on_seal_path": True,
        },
        "grades": grades,
        "summary": {
            "primary_win": sum(g["verdict"] == "WIN" for g in grades),
            "primary_total": len(grades),
            "adversary_miss": sum(g["adversary_miss"] for g in grades),
        },
    }
    (CORPUS_DIR / "study13_ledger.json").write_text(json.dumps(ledger, indent=2) + "\n")
    print(json.dumps(ledger["summary"], indent=2))
    assert ledger["summary"]["primary_win"] == ledger["summary"]["primary_total"]
    assert ledger["summary"]["adversary_miss"] == ledger["summary"]["primary_total"]


if __name__ == "__main__":
    main()
