# Where humans actually yield, against what the rules already require

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       d5fab6529c34126003aec8d8ea2f80cb1558ccf9feb3b4896eaef739758206a1
DIGEST_OF      the sealed transcript of the six-test comparison between published fatigue-yield curves and the duty limits three regulators already impose
TITLE          Six tests of what regulators require against where the measured curve actually bends
MEASURED       Six tests comparing filed duty limits against published human performance curves. Four AGREE: the duty-hour floor lands exactly on the measured knee; the floor moves earlier for night starts and so does the knee; the consecutive-night cap lands on the step rather than before it; the defined circadian trough is the measured trough. One CONFLICT: asked which matters more, the clock or the workload, two regulators invert each other. One NOT_COMPARABLE: the axis with the best curve is the one no instrument writes down, at OR 8.2 with a 3.4 to 19.7 interval. All three pairwise intervals overlap, so the ordering of causes is NOT KNOWN and is published as NOT KNOWN.
PROGRAM        fatigue-yield-vs-regulator
FIGURE         d5fab6529c34126003aec8d8ea2f80cb1558ccf9feb3b4896eaef739758206a1
FIGURE         FATIGUE_YIELD_VS_REGULATOR__FOUR_AGREE_ONE_CONFLICT_ONE_NOT_COMPARABLE
SEAL           d5fab6529c34126003aec8d8ea2f80cb1558ccf9feb3b4896eaef739758206a1
GRADE          MEASURED
SOURCE         14 CFR 117, 14 CFR 121 and 49 CFR 395, pinned under corpus/fatigue-yield/ and re-fetchable from the eCFR, against published performance curves
WHERE_THE_LAW_LIVES  reproduce/fatigue-yield-vs-regulator.swift
REFUSED        not a finding about any person, operator, crew or carrier. Every comparison is between a filed rule and a published curve, and the subject under grading is the instrument, never anybody's fitness
REFUSED        not a recommendation to change any duty limit. An AGREE says a rule and a curve land on the same integer; it does not say the rule is right, and a CONFLICT does not say either regulator is wrong
REFUSED        not a causal ordering. All three pairwise intervals overlap, so which of sleepiness, circadian phase or workload matters most is NOT KNOWN here and is printed as NOT KNOWN rather than as the largest odds ratio
REFUSED        not a safety certification of any operation. Six discrete comparisons are not a fatigue risk management system
FALSIFIER      a re-fetch of 14 CFR 117, 14 CFR 121 or 49 CFR 395 whose limits do not match the pinned corpus; or a re-run that reaches a different verdict on any of the six tests from the same public bytes
REPRODUCE      xcrun swiftc -O -swift-version 5 reproduce/fatigue-yield-vs-regulator.swift -o /tmp/fy && /tmp/fy
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation about anyone's duty, rest or fitness to work.
ADDED          2026-09-09
```
