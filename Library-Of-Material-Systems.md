# The library of material systems

*Systems for public flourishing: what each one is, what was measured about it, and where its law
lives — with nothing admitted that a stranger cannot re-derive.*

**Graded 2026-09-07 by [the library admission law](The-Library-Admission-Law). Five entries admitted,
none held, none refused inside the library — and five candidates refused at the door, each named
below with the clause that stopped it. Two slots named and empty.**

```
LIBRARY MATERIALS   ->   ADMITTED
  entry files   5      ADMITTED  5      HELD  0      REFUSED  0
  graded together with the other two libraries in ONE run — 15 admitted, 5 held, 0 refused
  TRANSCRIPT SEAL  sha256  fa0c43d8cc38a2ad66214bac3a82c3aa27cb86cedd310640ed88ce0d9fb9584b
```

---

## What this library is for, and who it is for

It is for a stranger. Someone who has never heard of us, has no reason to believe us, and needs
to know something exact about a physical system before they build with it, regulate it, or decide
whether to trust the people who do.

Everything below is a **system**: a radio link, a lattice, a plasma safety law, a wire transform.
Each entry says three things and no more — **what the system is**, **what was measured about it**,
and **where the law that produced the measurement lives**. Every figure printed here comes out of a
program in `reproduce/` that anyone can compile and run, with no account, no key, and no permission
from us.

**This library is meant to grow.** It is not a study that closes. New systems enter as they are
measured, and the gatekeeper is a program, not a person — so it grows by the same rule whoever is
adding.

### C-007 is absolute here, and it is on this page's face

**No military use. No planetary harm. No synthesis cookbook.** An entry names what a system is and
what was measured about it. **It never carries a procedure a person could follow.**

That constraint is not a disclaimer bolted on afterwards; it is a clause of the admission law
(E11), and it fired on a real candidate today — a louvered radiation shield, one of the most benign
objects imaginable, refused because its entry carried the temperature and the duration you would
build it at. **The detector does not weigh benignity, and it must not.** A library that adjudicates
harmfulness case by case is a library whose rule is whatever the last author argued; a library with
an absolute rule is one a reader can check. The refusal is in the refused section below, with the
rule, the verb and the quantity the checker matched — and with the matched line itself elided,
because reprinting it here would put the procedure back on the page the clause just took it off.

**And the detector gained a third rule on 2026-09-07, because an adversarial pass walked through
the gap in the first two.** Rules A and B are both keyed on a **fabrication verb**, from a list of
32 that deliberately excludes `heat`, `cool`, `mix`, `add`, `press` and their kin as too common in
honest measurement prose. A fabrication route does not need one of our verbs:

> *"Combine 42 g of the powder with 5 mL of solvent, heat to 1450 C for 6 h under argon, then press
> at 12 MPa and cool at 5 C per minute"*

**That is a complete two-sentence procedure and it was ADMITTED into this library**, with
`E11_NO_PROCEDURE ok` printed beside it. **Rule C** now catches it: three or more
quantities-with-units on one line, keyed on no verb at all. It refuses that line naming all six of
its quantities, and it is not always-red — measured over **every non-figure, non-reproduce line of
all sixteen live entry files across the three libraries, the count is zero.**

---

## The admission law, in one paragraph

Nothing enters this library without a **reproducible measurement**. An entry is a fenced
`affine-entry` block carrying thirteen required keys — what it is, what was measured, the program
in `reproduce/` that produces it, at least one figure matching a line of that program’s
output, a seal or the explicit token `NONE_PRINTED`, a grade drawn from [the wiki's
ontology](Ontology) rather than chosen by the author, at least one line saying what we explicitly do
**not** call it, the observation that would overturn it, the command a stranger runs from a clean
clone, and the standing not-advice line, which travels *with* the row rather than sitting on this
page. Fifteen per-entry clauses check that. Nine more check the **collection** — because no
per-item validator can see a corpus-level defect, and this programme has already measured one:
37,910 rows that held five distinct molecules, where every row passed every per-row check. So the
law publishes a **distinct count beside the row count on every axis, always**, together with the
count carried by the single most repeated value, and tests that against a ceiling the library
declares in advance: `count(most repeated value) ≤ declared`, integer, per value, never a ratio and
never in aggregate. A tenth clause, **F1**, holds two libraries at once and asks whether one entry
is filed in both — which is why the three libraries are graded in a **single run**. Three
terminals — **ADMITTED**, **REFUSED**, **NOT_KNOWN** — and they are three answers. The full law is
[here](The-Library-Admission-Law); the executable is `reproduce/library-admission-law.swift`, and it
runs **71 control arms** before it grades anything.

---

## The entries

Five systems. Each block below is the entry exactly as the checker read it.

### 1 — E8, the packing the eight-dimensional quantiser stands on

**A mathematical object with a public name, counted rather than estimated.** In the same dimension
and at the same covolume, E8 packs **exactly 16×** denser than the integer lattice Z⁸ and touches
**240** neighbours against Z⁸'s **16**. The ratio is an integer, not an approximation: both lattices
are unimodular at covolume 1, Z⁸ has minimal norm 1 and E8 minimal norm 2, so the density ratio is
(√2)⁸ = 2⁴ = 16.

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       E8
SPEC_AUTHORITY The standard root lattice E8, as fixed in Conway and Sloane, Sphere Packings Lattices and Groups — a public mathematical object with a public name
TITLE          E8 against Z^8 at equal covolume, by direct enumeration
MEASURED       Kissing numbers by direct enumeration: Z^8 touches 16 neighbours, E8 touches 240. Both lattices are unimodular at covolume 1; Z^8 has minimal norm 1 and E8 minimal norm 2, so the packing density ratio is exactly 2^4 = 16 — an integer, not an estimate. Same dimension, same covolume, 16 times denser and 15 times as many neighbours.
PROGRAM        z8-vs-e8-lattice
FIGURE         E8  : 240
FIGURE         density ratio = (sqrt2)^8 = 2^4 = 16
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/z8-vs-e8-lattice.swift — the enumeration, and its det 0 and det 2 control matrices
REFUSED        not a claim that E8 is the right lattice for any particular signal. It is the measured comparison at equal covolume and nothing more
REFUSED        not a construction. This entry names the object and what was counted about it; it carries no fabrication route and none is needed, because the object is a mathematical one
REFUSED        the program prints no seal, and this entry says NONE_PRINTED rather than leaving the field blank. Unsealed and sealed are different states
FALSIFIER      an enumeration over the same two lattices returning a kissing number other than 16 or 240, or a density ratio that is not exactly 16
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 z8-vs-e8-lattice.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

### 2 — The radio link of an open sensor pod, in exact integer microseconds

**This is where the library reaches public flourishing most directly, and it is worth saying at
full magnitude.** LoRaWAN at spreading factor 12 and 125 kHz is an open standard on unlicensed
spectrum. Anyone may build on it, anywhere, without asking us or anyone else. Measured against a
4,096 µs symbol and a 36,000,000 µs hourly duty budget: a 201-byte floating-point JSON frame costs
233 symbols and 1,004.544 ms, allowing **35** transmissions an hour. A 42-byte frame carrying a
16-byte integer delta and a 26-byte header costs 58 symbols and 287.744 ms, allowing **125**.

**Same radio, same regulation, same hour: 35 reports against 125, from choosing integers over
floating-point text.** For anyone standing up a flood gauge, an air-quality node or a soil sensor on
a duty-limited band, that is 90 more readings every hour out of hardware they already have — and the
arithmetic is above, in the open, for them to check rather than take from us. The budget **floors
and never rounds**: a duty count rounded up is a regulatory breach expressed as a rounding
convention.

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       LORAWAN-SF12-BW125
SPEC_AUTHORITY LoRa Alliance LoRaWAN regional parameters, spreading factor 12 at 125 kHz bandwidth, with the symbol timing of the Semtech SX1276 datasheet
TITLE          Frame airtime and hourly transmissions under a fixed duty budget
MEASURED       At a 4,096 microsecond symbol and a 36,000,000 microsecond hourly duty budget: a 201-byte floating-point JSON frame takes 233 symbols and 1,004.544 ms, allowing 35 transmissions an hour. A 42-byte frame carrying a 16-byte integer delta and a 26-byte header takes 58 symbols and 287.744 ms, allowing 125. The budget floors and never rounds.
PROGRAM        lora-time-on-air
FIGURE         float JSON frame      201    233      1004.544     35
FIGURE         FRAME: 16B delta + 26B hdr42     58       287.744      125
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/lora-time-on-air.swift — exact integer microseconds throughout, with the 16-byte row as its control
REFUSED        not a built pod and not a bench measurement. These are airtimes computed from published symbol timing, not a radio anyone switched on
REFUSED        not a hardware design, a bill of materials or an assembly route. This entry names the link and what was computed about it
REFUSED        not a claim that the integer frame is sufficient for any application. It is smaller and it is cheaper on air; whether it carries enough is a different question
FALSIFIER      a bench measurement of the same configuration disagreeing with the computed airtime, or a duty-budget count that rounds where the law floors
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 lora-time-on-air.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

### 3 — A plasma control law whose verdict is the same integer on every machine

**The second place this library reaches public flourishing directly: a safety verdict a regulator
can re-derive without the vendor's permission.** 400 streaming traces plus a 2,592-point
operating-point grid give **2,992 verdicts**, and the ordered verdicts digest to **one sha256 that
is the same on every machine** — because every verdict is an exact integer comparison, with no
accumulation and no platform math. A safety authority that holds the trace and the rules re-derives
the verdict itself, after the fact, and gets the same string. That is accountability living in the
arithmetic rather than in a promise.

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

**A correction made while grading this entry, recorded because it is the kind that hides.** The
`REPRODUCE` line above previously read `xcrun swiftc … fusion-determinism-digest.swift -o /tmp/run`
on its own. Run from a clean clone, that command **fails** — the program consumes two other targets
and Swift requires top-level code to be named `main.swift`, so the compiler answers *statements are
not allowed at the top level* and no binary is produced. E9 did not catch it, and could not:
**E9 checks that the command names its own program and carries no private path; it does not run the
command.** The line above is the form that was executed today and does reproduce the digest. That
gap is blind spot 4 of the law, met in the field on the first library graded.

### 4 — The image count cannot tell a bijection from a non-bijection; reachability can

**An instrument that cannot fail is not an instrument, and this entry is that lesson measured.** The
obvious way to check that an 8×8 integer map is a bijection of Z⁸ is to push 4,000 points through it
and count distinct images. Measured: determinant 1 returns **4,000 of 4,000**, determinant 2 returns
**4,000 of 4,000**, and a **singular** determinant-0 matrix returns **4,000 of 4,000**. The count
separates nothing, because every nonsingular integer matrix is injective on Z⁸ and a singular one
can still be injective on a finite sample.

The arm that discriminates is **reachability of e₁ = (1,0,0,0,0,0,0,0)**: reached under determinant
1, **not** reached under determinant 2, because every image under that map has an even first
coordinate. Determinant ±1 buys **surjectivity onto Z⁸** — an integral inverse — and reachability is
the arm that sees it. The image-count row is published here as a labelled smoke test, not as
evidence.

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       GL8Z-UNIMODULAR
SPEC_AUTHORITY The general linear group GL(8,Z), the 8x8 integer matrices of determinant plus or minus one — a standard public mathematical object, with the ten elementary shears that generate the matrix and the 4,000-point source set published in Study 30
TITLE          Image count cannot tell a bijection of Z^8 from a non-bijection; reachability can
MEASURED       Three 8x8 integer matrices over one 4,000-point source set: determinant 1, determinant 2 and determinant 0 each return 4,000 distinct images of 4,000, so the image count separates none of them. The arm that separates them is reachability of e_1 = (1,0,0,0,0,0,0,0): reached under determinant 1, not reached under determinant 2. Inside a plus-or-minus-100 box the unimodular map places 1,934 images of 4,000 against 4,000 for the determinant-2 map.
PROGRAM        unimodular-control-arms
FIGURE         singular det=0: det=0  distinct_images=4000 of 4000
FIGURE         unimodular det=1: det=1  e_1 reachable in sample = true
FIGURE         det=2 scaling: det=2  e_1 reachable in sample = false
FIGURE         images inside a +/-100 box: unimodular=1934  det2=4000  of 4000
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/unimodular-control-arms.swift — determinant by fraction-free Bareiss elimination, integer throughout, with the det 2 and det 0 matrices as its two control arms
REFUSED        not a claim that any shipped wire transform is this matrix. The substrate source is not public; this entry measures the property over a published generator and a published point set and stands in for nothing
REFUSED        not a claim that any sensing pipeline is lossless. Z^8 to Z^8 under this map is bijective; the sensor-to-lattice quantisation ahead of it is many-to-one and irreversible, and that step is outside this measurement
REFUSED        not a hardware design, a bill of materials or an assembly route
FALSIFIER      a run over the same three matrices and the same point set in which e_1 is reachable under the determinant-2 map, or unreachable under the determinant-1 map; or an image count that does separate the three, which would make the smoke test a gate after all
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 unimodular-control-arms.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

### 5 — One safety question, asked exactly and asked in floating point

Over four real machines — ITER, SPARC, JET, DIII-D — the exact integer court returns
`NOT_MEASURED_PI_BRACKET` on **142** operating points (27, 61, 22, 32), and on those same 142 the
two defensible rational values of π, **355/113 and 333/106**, return **contradictory** verdicts. The
bracket between them is exactly **1/11978** wide.

**Read the third column precisely: single-precision verdicts that flip against the exact court are
zero.** This is not a claim that floating point is imprecise — it resolves this inequality fine. The
measured property is that the float verdict is **not invariant**: two honest engineers running the
identical safety test with defensible constants reach opposite conclusions about the same plasma,
and neither can show the other why. The exact court declines to pick, on all 142, and names why.

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

---

### 6 — Where humans actually yield, against what the rules already require

The five entries above grade physical systems. This one grades a **regulation** against the
measured curve it is supposed to sit on — six discrete tests, and the interesting thing is that
they do not all point the same way.

**Four AGREE.** The duty-hour floor lands exactly on the measured knee. The floor moves earlier
for night starts, and so does the knee. The consecutive-night cap lands on the step rather than
before it. The defined circadian trough is the measured trough. **An AGREE here says a filed rule
and a published curve land on the same integer — it does not say the rule is right.**

**One CONFLICT.** Asked which matters more, the clock or the workload, two regulators invert each
other. That is a statement about two instruments disagreeing, not about either being wrong.

**One NOT_COMPARABLE, and it is the one worth a bench.** The axis with the best curve — OR 8.2,
interval 3.4 to 19.7 — is the one no instrument writes down. And the ordering of causes is
published as **NOT KNOWN**, because all three pairwise intervals overlap: the largest odds ratio
is not a ranking.

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

## The refused — what was considered and did not enter

**A library that shows only what it admitted cannot be audited.** Five candidates were written out
in full, graded by the same checker, and refused. Every one is something this library genuinely
wanted. The verdicts below are the checker's own words.

### R1 — the A.E.P-1 sovereign edge pod's four-tier bench gate — **REFUSED, E3**

The pod is the reason the LoRa entry exists. Its validation charter is frozen with real integers:
a soak of at least **259,200 s**, a heap high-water delta of exactly **0 bytes** across **100,000**
ingest cycles, a capture of at least **86,400 s** with exactly **0** inbound application frames at a
published frame length of exactly **42 bytes**, and a **2,048-record** ring giving **122,880 s** of
retained outage.

```
      REF  E3_PROGRAM   'aep1-four-tier-gate' is not a program in reproduce/. An entry whose
                        claim no program produces cannot enter.
      HELD E4_FIGURE    1 figure(s) declared; no transcript for 'aep1-four-tier-gate' is present
                        here. ABSENT IS NOT REFUSED — run the program and grade again.
      REF  E7_GRADE_SUPPORTED  graded MEASURED, but its program or its figures did not stand.
```

**No pod has been built and no tier has been run**, so every integer above is an obligation rather
than a finding, and no program can print one. It is named as an **open slot** in this library's
manifest and enters the day a bench produces a reading. Note what the checker did with E4: it
**HELD** rather than refusing, because a missing transcript is an absence, not a refusal, and the
law prints those apart.

### R2 — the exact control law's throughput headroom — **REFUSED, E4**

`Study-33` publishes `HEADROOM_EXCEEDS_50X TRUE` and `reproduce/validate.sh` pins it. Run today:

```
      REF  E4_FIGURE    1 of 2 figure(s) are NOT printed by fusion-control-benchmark:
                        first is 'HEADROOM_EXCEEDS_50X            TRUE'
```

The program printed `HEADROOM_EXCEEDS_50X            FALSE`. Nothing about the law changed. The
program sustained **10.4 million samples/second** against a published **2.0 million** requirement —
a real result — but **5.2× is what a busy machine gives, and the boolean is pinned as though it were
a property of the arithmetic**. What that flag actually measures is how much spare CPU the host had.
The house rule that a seal must never digest a timing applies to a **pinned figure** too. Its
sibling terminals `VERDICT_INSIDE_ONE_MS_BUDGET` and `VERDICT_DETERMINISTIC_10K` are real invariants
and both printed `TRUE` on the same run. **A gate that flips on load is not measuring the thing it
names**, and this library will not carry it until it is stated as a rate with its load rather than
as a boolean.

### R3 — the sovereign pod's hourly energy budget — **REFUSED, E1**

Every clause but one passed. The program is in `reproduce/`, and **both figures appeared verbatim**:
**3,240,490 µJ/hour** at the binding 60-transmissions-an-hour cadence, and **83.1 mJ** for a
genuinely silent hour at 7 µA and 3,300 mV.

```
      REF  E1_IDENTITY  SPEC_NAME 'A.E.P-1' carries no SPEC_AUTHORITY. A name with nobody behind
                        it is a nickname, and this wiki has already retired a corpus keyed on
                        generated nicknames.
```

**"A.E.P-1" is our own name for a thing that does not exist yet.** There is no standards body, no
registry, no public document outside this wiki that fixes it. The measurement is sound and the name
is not, and the honest response is to leave it out rather than invent an authority to satisfy a
field. It enters under a real identifier the day one exists — or under a `CONTENT_DIGEST`, the day
the program prints a digest of the corpus it computed over.

### R4 — the pod enclosure — **REFUSED, E11 (C-007)**

A louvered radiation shield. Benign, useful, and exactly the kind of thing an open-hardware library
exists to carry.

```
      REF  E11_NO_PROCEDURE  C-007: a procedure a person could follow. rule A, verb 'sinter',
                             quantity '240 c', in: [the matched line is elided here — see below]
```

**The checker prints the offending line in full and this page does not, and the elision is the rule
applying to itself.** A refusal has to be contestable, so the law names the **rule**, the **verb**
and the **quantity** it matched — enough for the author to see exactly what fired and argue with
it. Reprinting the sentence on a public page would put the procedure back on the page the clause
just took it off. Anyone can re-derive the full refusal by running the checker against the candidate
file; what this page carries is the verdict, not the recipe.

**The detector does not know the shield is harmless, and it must not.** C-007 is absolute; a rule
that bends for benign cases is a rule whose scope is decided one entry at a time by whoever is
adding. The entry can still enter — with the shield's **thermal criterion** and none of its
fabrication route. What the library carries about a physical object is what was measured about it,
never how to make it.

### R5 — the cell chemistry an open sensor pod stores its energy in — **REFUSED, E7**

Lithium iron phosphate thermal-runaway onset near **270 °C** against **150–210 °C** for NMC. This is
the single most safety-relevant material fact adjacent to this library, and it is the one that would
matter most to someone standing a pod in a field.

```
      REF  E7_GRADE_SUPPORTED  graded REPORTED with no SOURCE. Reported by whom?
```

The figures are real chemistry-class numbers and **nobody wrote down where they came from.** They
are not measured here, no cell datasheet is pinned, and without a source `REPORTED` is a grade the
evidence does not support. This is the refusal that costs the most and it is the right one:
**a number a reader cannot trace is a number they have to take on trust, and this library is built
so nobody has to.** It enters the moment a citation is attached — and the durable version of it is
narrower anyway: the boundary that binds any real pod is on **that specific cell's own datasheet**,
per cell, never per chemistry.

---

## Rows and distinct identities, published side by side

**This library states both, always.** A row count alone is a loop bound. The count below is the one
no per-entry check can produce, because no per-entry check ever holds two entries at once.

```
    axis                            entries  distinct  most at 1  declared  holds
    IDENTITY                              5         5          1         1  yes
    PROGRAM                               5         5          1         1  yes
    SEAL (sealed entries only)            1         1          1         1  yes
    MEASURED                              5         5          1         1  yes
    IDENTITY|PROGRAM|SEAL triple          5         5          1         1  yes
    TITLE (census, not a gate)            5         5          1         -    -
    GRADE (census, not a gate)            5         1          5         -    -
```

**Five entries, five distinct identities, five distinct programs, five distinct findings.** Every
gated axis holds **per value** — the most repeated value on each carries 1, against a declared
ceiling of 1 — never by a ratio and never in aggregate.

**`most at 1` is the column the ceiling is actually about, and it was not here on the first
publication of this page.** The test then read `distinct × declared ≥ entries`, an aggregate: it
clears whenever the totals work out, including when one value carries five of eight against a
declared two. This library was never inside that gap — every axis here reads 1 — but its sibling
PROTEINS library was, and a table that cannot show the difference is a table that cannot be read.

**`TITLE` and `GRADE` are labelled *census, not a gate*, and that label is load-bearing.** A clause
that never refuses is a decoration, and calling a decoration a gate is how a reader comes to trust
one. Look at the `GRADE` row: five entries, **one** distinct grade. All five are `MEASURED`. That is
not a strength and this library does not present it as one — it is a fact about which five systems
happened to arrive first.

**Four of five entries declare `SEAL NONE_PRINTED`.** Their programs print no seal, and the entries
say so rather than leaving the field blank, because **unsealed and unstated are different states**.
They are counted and named, and excluded from the seal axis rather than folded into one bucket —
which would report a collapse that is not there.

### The open slots — named, and empty

A slot is **not** an entry. It is counted in no axis above and gates on nothing. It is a measurement
this library has named and does not have — no program, no figure, no seal, nothing yet to hold.
**Naming a slot is how a library says what it is missing instead of quietly not having it.**

1. **The A.E.P-1 sovereign edge pod, four-tier bench gate.** Charter frozen 2026-09-01 with its
   integers; no pod built, no tier run. Named 2026-09-07.
2. **A bench reading from an instrument attached to a built thing.** Every entry admitted here is
   *computed* — from published symbol timing, published machine parameters, or exact enumeration.
   **Not one is an instrument reading.** Named 2026-09-07.

Slot 2 is the honest shape of this library today, and it is stated in the library's own manifest
and again here rather than buried: **five exact computations and zero measurements of a physical object.** Every entry's
own `REFUSED` lines say the same thing individually; the slot says it about the collection.

### The verdict transcript, and its seal

```
CONTROL ARM  71/71 PASS
  arms that must REFUSE      43
  arms that must ADMIT       16
  arms that must HOLD         5   (NOT_KNOWN — the third terminal is reachable)

LIBRARY MATERIALS   ->   ADMITTED
  entry files 5 · ADMITTED 5 · HELD 0 · REFUSED 0 · open slots 2
     ok  L8_DISTINCT_TRIPLE     5 entries, 5 distinct; most repeated value carries 1 — 1 <= 1
     ok  L9_PAGE_MATCHES_DIR    Library-Of-Material-Systems.md carries 5 entry block(s),
                                identical as a multiset to the 5 in this directory

F1_NO_ENTRY_FILED_TWICE   ok — no triple appears in more than one of the 3 libraries graded
                          together; 13 distinct triples over 15 admitted entries

TRANSCRIPT SEAL  sha256  fa0c43d8cc38a2ad66214bac3a82c3aa27cb86cedd310640ed88ce0d9fb9584b
sealed bytes             33,668
exit                     2   (four entries across the three libraries are HELD; nothing is refused)
```

**The seal is path-independent, and that is measured rather than asserted.** Filesystem paths are
printed and never sealed — a seal that moved with the checkout directory would indict a correct
reproduction, which is the worst thing a seal can do. The seal above covers **all three libraries
graded in one run**, because that is the only run that can answer F1; a single-library run reports
F1 as `NOT_KNOWN` and exits 2, which is the honest answer and is not a clearance.

**L9 is why this page cannot drift from what was graded.** The checker grades
`library/materials/`; you are reading `Library-Of-Material-Systems.md`. L9 compares the fenced entry
blocks of the two as multisets and refuses if they differ. Before it existed the two agreed, and
that was a fact about one hour rather than a gate.

---

## How this library grows

**Who may add: anyone.** The law is the gatekeeper, not a person. There is no reviewer to persuade
and no committee to convince. An addition is a file, a program and a transcript, and the checker is
the referee.

**What must accompany an addition — four things, in one commit:**

1. **The entry file** — a page carrying an `affine-entry` block the checker admits.
2. **The program** in `reproduce/`, if it is new: self-contained, integer, with its own control arm
   in both directions.
3. **A `check_figure` row in `reproduce/validate.sh`** for at least one of the entry's figures, so
   the wiki's own harness fails if page and program ever drift apart.
4. **The manifest ceilings**, moved if the addition needs them moved.

Point 4 is not bookkeeping. **A stale ceiling silently re-admits what was just excluded.** This
programme has paid for that lesson once already, on a float ratchet whose frozen constant kept
forgiving exactly what it had been raised to catch.

*Worked example, from today: the two entries most recently admitted — GL8Z-UNIMODULAR and
GREENWALD-DENSITY-LIMIT — needed no change to `validate.sh`, because rows pinning
`unimodular-control-arms` and `fusion-exact-vs-float` were already there. The ceilings did not move
either: at 1 per axis, five entries over five distinct values still satisfies `5 × 1 ≥ 5`. Both
checks were run rather than assumed.*

### When an entry's evidence is refuted

**Nothing is ever deleted.** A library that cannot retract cannot be trusted, and one that retracts
by deleting is worse, because it cannot be caught. The entry stays where it is and is superseded in
place:

1. add `REFUTED_BY` with a `YYYY-MM-DD` date;
2. rewrite `GRADE` to what the *surviving* evidence supports — usually `NOT_KNOWN`;
3. leave the original `MEASURED`, `FIGURE`, `SEAL` and `REFUSED` lines untouched, so the claim and
   its refutation stand on the same page;
4. `SUPERSEDES` on the replacement entry, if there is one.

E14 enforces it: refuted-and-still-`MEASURED` is refused, an undated refutation is refused, and a
refuted entry that is dated and regraded is **ADMITTED**. Retraction is a *path through the law*,
not an exit from it.

This is written hard for a measured reason. A ledger in this same programme carried 221
`BEFORE DELETE` triggers that were **disarmable at runtime**; three migrations used the bypass; and
for every game they touched, *"never had a fault recorded"* and *"its fault records were deleted"*
are now indistinguishable. **Deleting a refuted entry is that same act, one step later.**

---

## What this library is not

- **Not medical advice.** Nothing here is medical advice and no entry is a recommendation to take
  anything. The line travels inside every entry, not only on this page, because rows get copied out
  of libraries and a disclaimer that stays on the front page does not travel with the thing it
  disclaims.
- **Not a recommendation** to build, buy, deploy or rely on any system named here.
- **Not a substitute for a laboratory.** Five of five entries are computations. Not one is a reading
  from an instrument attached to a physical object, and slot 2 above says so in the library's own
  census.
- **Not a substitute for a regulator.** Entry 3 exists so that a safety authority can re-derive a
  verdict itself; it does not stand in for one, and no entry here has been reviewed by any
  authority.
- **Not a claim that an admitted entry is true.** Admission means the entry is *checkable* — named,
  produced by a program a stranger can run, graded at what its evidence supports, and explicit about
  what it refuses to say. Read each entry's own `REFUSED` lines: they are there to stop a reader
  taking the largest reading the words allow.
- **Not a build manual.** C-007 is absolute. No entry carries a procedure a person could follow, and
  R4 above shows the rule refusing a candidate nobody would call dangerous.

---

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
bash reproduce/validate.sh                    # runs every program, writes /tmp/out_<program>.txt
swiftc -O -swift-version 5 reproduce/library-admission-law.swift -o /tmp/lal

# ALL THREE libraries in ONE run. F1 is a relation between libraries; a run given one
# library reports it NOT_KNOWN and exits 2, which is honest and is not a clearance.
/tmp/lal --library library/proteins --library library/compounds --library library/materials \
         --reproduce reproduce --evidence /tmp
```

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

Each entry's own `REPRODUCE` line builds and runs the single program behind it, so any one figure
on this page can be checked without running the whole harness. Exit codes from the checker: `0` all
admitted, `1` something refused, `2` something held, `3` the control arm failed and nothing was
graded.

**`--evidence /tmp` is shared mutable state and this page says so.** `validate.sh` writes its
transcripts there, so a second `validate.sh` running concurrently can rewrite one *while* the
library is being graded. The transcripts are deterministic, so their content is stable; a
**partially written** one is not, and a truncated transcript is indistinguishable from a figure the
program does not print — which would read as REFUSED on a correct entry, the worst direction for
this error. **Pass a private `--evidence` directory when the grading matters.** The seal above was
taken that way.

## Related

- [**The library admission law**](The-Library-Admission-Law) — what may enter, and the 71 control arms
  behind it.
- [**The Library of Proteins**](Library-Of-Proteins) · [**The Library of Compound Cures**](Library-Of-Compound-Cures) — the other two libraries, graded in the same run as this one.
- [Study 30 — The sovereign edge pod](Study-30-Sovereign-Edge-Pod.md) — the charter behind entry 2
  and open slot 1.
- [Study 33 — The fusion control verdict court](Study-33-Fusion-Control-Verdict-Court.md) ·
  [Study 34 — The observer-invariant verdict](Study-34-Observer-Invariant-Verdict.md) — the studies
  behind entries 3 and 5, and the source of refusal R2.
- [The ontology of this wiki](Ontology) — where the seven grades are fixed.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
