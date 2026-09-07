# One safety question, asked exactly and asked in floating point

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       GREENWALD-DENSITY-LIMIT
SPEC_AUTHORITY The Greenwald density limit, the standard tokamak operational density bound of the published fusion literature, graded here at the published parameters of ITER, SPARC, JET and DIII-D
TITLE          142 operating points where two defensible rational values of pi give opposite safety answers, and the exact court declines to pick
MEASURED       Over four real machines the exact integer court returns NOT_MEASURED_PI_BRACKET on 142 operating points — 27 ITER, 61 SPARC, 22 JET, 32 DIII-D — and on those same 142 the two rational values of pi 355/113 and 333/106 return contradictory verdicts. Single-precision verdicts that flip against the exact court: 0. The bracket between the two rationals is exactly 1/11978 wide.
PROGRAM        fusion-exact-vs-float
FIGURE         TOTALS  exact-refused points = 142 · float32 flips vs exact = 0 · two-pi float contradictions = 142
FIGURE         PI_BRACKET  355/113 - 333/106 = 1/11978
FIGURE         PROOF_EXACT_VERDICT_IS_OBSERVER_INVARIANT
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/fusion-exact-vs-float.swift, over app/FusionCourt/Sources/FusionLaw and FusionOperatingPoint — the same single law the determinism digest grades, compiled in rather than copied
REFUSED        not a claim that floating point is imprecise. The float32 flip count is 0, and this entry prints it. What is measured is that the float verdict is not invariant across two defensible constants, which is a different property from accuracy
REFUSED        not a claim about any real discharge, any real machine's safety, or any operator's practice. These are published machine parameters evaluated by a published limit, and no plasma was involved
REFUSED        not a reactor design and not an operating procedure
REFUSED        the program prints a marker and no 64-hex seal, and this entry says NONE_PRINTED rather than leaving the field blank
FALSIFIER      a run over the same four machines returning a refused-point count other than 142, or a non-zero float32 flip count against the exact court, or a pair of rational pi values inside the stated bracket that agree on all 142
REPRODUCE      cd reproduce && d=$(mktemp -d) && cp fusion-exact-vs-float.swift $d/main.swift && xcrun swiftc -O -swift-version 5 ../app/FusionCourt/Sources/FusionLaw/*.swift ../app/FusionCourt/Sources/FusionOperatingPoint/*.swift $d/main.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
