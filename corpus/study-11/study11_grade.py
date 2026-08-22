#!/usr/bin/env python3
"""Study 11 — Ehrhart Volume Shear grader. Integer lattice counts only on seal path."""
import json
import itertools
import math
from fractions import Fraction
from pathlib import Path

CORPUS_DIR = Path(__file__).resolve().parent
T_MAX = 12


def convex_facets(verts):
    d = len(verts[0])
    n = len(verts)
    facets = []
    for comb in itertools.combinations(range(n), d):
        b = [verts[i] for i in comb]
        if d == 2:
            (x1, y1), (x2, y2) = b[0], b[1]
            nx, ny = y2 - y1, x1 - x2
            c = nx * x1 + ny * y1
            others = [verts[i] for i in range(n) if i not in comb]
            if not others:
                continue
            vals = [nx * v[0] + ny * v[1] for v in others]
            if all(v <= c for v in vals):
                facets.append((nx, ny, c))
            elif all(v >= c for v in vals):
                facets.append((-nx, -ny, -c))
        elif d == 3:
            a, b0, c0 = b
            ab = tuple(b0[i] - a[i] for i in range(3))
            ac = tuple(c0[i] - a[i] for i in range(3))
            nx = ab[1] * ac[2] - ab[2] * ac[1]
            ny = ab[2] * ac[0] - ab[0] * ac[2]
            nz = ab[0] * ac[1] - ab[1] * ac[0]
            if nx == 0 and ny == 0 and nz == 0:
                continue
            val = nx * a[0] + ny * a[1] + nz * a[2]
            others = [verts[i] for i in range(n) if i not in comb]
            ovals = [nx * v[0] + ny * v[1] + nz * v[2] for v in others]
            if all(ov <= val for ov in ovals):
                facets.append((nx, ny, nz, val))
            elif all(ov >= val for ov in ovals):
                facets.append((-nx, -ny, -nz, -val))
    return facets


def point_in_poly(pt, facets):
    for f in facets:
        if len(f) == 3:
            nx, ny, c = f
            if nx * pt[0] + ny * pt[1] > c:
                return False
        else:
            nx, ny, nz, c = f
            if nx * pt[0] + ny * pt[1] + nz * pt[2] > c:
                return False
    return True


def count_points(verts, t):
    d = len(verts[0])
    tv = [tuple(t * v[i] for i in range(d)) for v in verts]
    mins = [min(v[i] for v in tv) for i in range(d)]
    maxs = [max(v[i] for v in tv) for i in range(d)]
    facets = convex_facets(tv)
    return sum(
        1
        for pt in itertools.product(*[range(mins[i], maxs[i] + 1) for i in range(d)])
        if point_in_poly(pt, facets)
    )


def forward_diff_d_at0(counts, d):
    s = counts[: d + 1]
    for _ in range(d):
        s = [s[i + 1] - s[i] for i in range(len(s) - 1)]
    return s[0]


def leading_volume_rational(counts, d):
    return Fraction(forward_diff_d_at0(counts, d), math.factorial(d))


def float_volume_predict(verts, t, d):
    v0 = verts[0]
    vol = 0.0
    for comb in itertools.combinations(range(1, len(verts)), d):
        b = [verts[i] for i in comb]
        m = [[b[j][i] - v0[i] for j in range(d)] for i in range(d)]
        if d == 2:
            det = m[0][0] * m[1][1] - m[0][1] * m[1][0]
        elif d == 3:
            det = (
                m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
                - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
                + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0])
            )
        else:
            det = 0.0
        vol += abs(det) / math.factorial(d)
    return int(round(vol * (t**d)))


def hle_poly_d3_ref(t):
    deltas = [1, 5, 8, 4]
    return sum(deltas[k] * math.comb(t, k) for k in range(4))


def main():
    hle3_verts = [
        (0, 0, 0),
        (1, 0, 0),
        (0, 1, 0),
        (0, 0, 1),
        (-1, 0, 1),
        (0, -1, 1),
    ]
    corpus = [
        ("unit_square", [(0, 0), (1, 0), (1, 1), (0, 1)], lambda t: (t + 1) ** 2, Fraction(1, 1)),
        ("unit_triangle", [(0, 0), (1, 0), (0, 1)], lambda t: (t + 1) * (t + 2) // 2, Fraction(1, 2)),
        ("simplex3", [(0, 0, 0), (1, 0, 0), (0, 1, 0), (0, 0, 1)], lambda t: (t + 1) * (t + 2) * (t + 3) // 6, Fraction(1, 6)),
        ("hle_poly_d2", [(0, 0), (1, 0), (0, 1), (-1, 1)], lambda t: (t + 1) ** 2, Fraction(1, 1)),
        ("hle_poly_d3", hle3_verts, hle_poly_d3_ref, Fraction(2, 3)),
    ]

    grades = []
    for name, verts, ref, vol_exp in corpus:
        d = len(verts[0])
        counts = [count_points(verts, t) for t in range(0, T_MAX + 1)]
        vol_fd = leading_volume_rational(counts, d)
        ref_ok = all(counts[t] == ref(t) for t in range(0, T_MAX + 1))
        vol_ok = vol_fd == vol_exp
        fp = float_volume_predict(verts, T_MAX, d)
        grades.append(
            {
                "id": name,
                "dim": d,
                "counts_0_6": counts[:7],
                "vol_fd": f"{vol_fd.numerator}/{vol_fd.denominator}",
                "vol_exp": f"{vol_exp.numerator}/{vol_exp.denominator}",
                "ref_ok": ref_ok,
                "vol_ok": vol_ok,
                "count_T": counts[T_MAX],
                "float_pred": fp,
                "adversary_miss": fp != counts[T_MAX],
                "verdict": "WIN" if ref_ok and vol_ok else "MISS",
            }
        )

    ledger = {
        "study_id": 11,
        "title": "Ehrhart Volume Shear",
        "sealed_at": "2026-08-22T16:00:00Z",
        "law": {
            "count": "integer_bbox_enumeration_with_exact_facets",
            "volume": "leading_coeff_equals_Delta^d_h(0)/d!",
            "adversary": "float_triangulation_volume_times_t^d_rounded",
            "no_float_on_seal_path": True,
            "T_max": T_MAX,
        },
        "grades": grades,
        "summary": {
            "primary_win": sum(g["verdict"] == "WIN" for g in grades),
            "primary_total": len(grades),
            "adversary_miss": sum(g["adversary_miss"] for g in grades),
        },
    }
    out = CORPUS_DIR / "study11_ledger.json"
    out.write_text(json.dumps(ledger, indent=2))
    print(json.dumps(ledger["summary"], indent=2))
    assert ledger["summary"]["primary_win"] == ledger["summary"]["primary_total"]
    assert ledger["summary"]["adversary_miss"] == ledger["summary"]["primary_total"]


if __name__ == "__main__":
    main()
