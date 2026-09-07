# A plasma control law whose verdict is the same integer on every machine

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7
DIGEST_OF      the ordered verdicts of the exact fusion control law over its whole published corpus
TITLE          The exact fusion control law — 2,992 verdicts, one machine-independent digest
MEASURED       400 streaming traces plus a 2,592-point operating-point grid give 2,992 verdicts, and the ordered verdicts digest to a single sha256 that is the same on every machine, because every verdict is an exact integer comparison with no accumulation and no platform math.
PROGRAM        fusion-determinism-digest
FIGURE         VERDICT DIGEST (sha256): f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7
FIGURE         corpus: 400 streaming traces + a 2592-point operating-point grid = 2992 verdicts
SEAL           f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/fusion-determinism-digest.swift, over the single law in app/FusionCourt/Sources/FusionLaw — compiled in, never copied, so the law cannot fork
REFUSED        not a claim that the law controls a real plasma. No machine data is behind these verdicts and the study that grades this lane says so on its face
REFUSED        not an energy-gain claim. A prior-era headline of Q = 1.8 traces to an input parameter of a test fixture, and this programme published that correction against itself
REFUSED        not a reactor design and not an operating procedure
FALSIFIER      a second machine computing a different digest from the same corpus, which is precisely the failure this architecture exists to make impossible
REPRODUCE      cd reproduce && d=$(mktemp -d) && cp fusion-determinism-digest.swift $d/main.swift && xcrun swiftc -O -swift-version 5 ../app/FusionCourt/Sources/FusionLaw/*.swift ../app/FusionCourt/Sources/FusionOperatingPoint/*.swift $d/main.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
