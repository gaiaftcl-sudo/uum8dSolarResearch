# The exactness seam — Affine.Earth business justification


## 1. The thesis, in one paragraph

Three markets — digital twins, orbital compute, quantum computing — settle their central quantities
in floating point, and in each one the participants document the consequences themselves. Ansys
states results change between product releases. Dassault states Abaqus/Explicit results depend on
the parallel decomposition. NVIDIA states PhysX results vary across platforms, compilers and
optimisation settings, and that adding one non-interacting actor can diverge a scene. The ISO/FDIS
text of 23247-1, the international framework standard for manufacturing digital twins, contains zero
occurrences of *reproducibility*, *repeatability*, *precision* or *floating point*. What follows from
that is narrow and provable, and it must be stated at exactly its size, because the same vendor
documents that establish it also bound it: **re-derivation does close a disagreement inside one
platform-and-version pair — NVIDIA scopes determinism to precisely that, and MathWorks documents
bit-wise agreement at zero tolerance on fixed-point types — and it does not travel across pairs.**
The seam is portability, not the absence of determinism everywhere. So when two parties on different
platforms, versions or decompositions disagree about such a number, neither can hand the other an
object that closes it, and the dispute is resolved by documentation, version control and peer review
instead. Whether that is how each sector *decides* its disputes is a claim this document makes only
for quantum computing, in §4.3, where it is evidenced. **On the measured surface** — 48 served
domain records carrying `no_float: true`, nine exact-rational prices, and one composition scalar —
Affine.Earth is a substrate on which a verdict is an exact rational computed in integer arithmetic,
so that checking it is a re-derivation rather than a re-run. That scoping matters and §3.6 states
why: the claim is made for what was measured, not for the whole substrate. The substrate's
verification claim is stated in one form and no other: **a presented configuration is verified; an unknown configuration is not searched.** What is built on top of the measured surface — a priced
ledger over 48 domains, a lead-time measure for early-warning coverage, a unit-normalising ledger
for atmospheric model intercomparison — sits at three different maturities, and this document labels
each rather than blending them.

**What is not claimed anywhere in this document:** that any life was saved, that any death was
prevented, that any disaster was averted, that any outcome would have been different, that any
ecological harm is established, that incumbent simulations are wrong, that any regulator among those
reviewed requires bit-exact replay, or that the sensing hardware described here is cheaper than the
orbital alternative. The last of those has arithmetic behind it and the arithmetic is in §9.4, where
it goes the other way.

**Two editorial rules, stated once and held throughout.** No casualty figures appear in this
document. Its sources carry them; the measurand here is **lead time in minutes**, casualty counts
are not an input to it, and reproducing them would import a quantity the argument does not use.
And no verdict of "solved" or "impossible" is rendered at any edge where the honest answer is that
the question is open — those are written as open.

---

## 2. The correction this document applied to itself

An adversarial read of the previous draft found **43 defects**, and a second adversarial read of the
draft that corrected them found **56 more**. One of the original 43 matters more than the rest,
because it is the error the document exists to criticise, committed by the document, in the section
where it criticises it.

**The defect.** The draft took a public statement that SpaceX targets about **one million tonnes per
year launched to orbit**, and set it against the measured **1.59 ± 0.05 kt/yr of space-waste mass
re-entering the atmosphere in 2024** and against the largest published modelling scenario of
**8.1 kt/yr**. It concluded: 1,000 kt/yr, *"123× the largest published scenario and 629× the 2024
measurement."*

**Why it is wrong.** *Total upmass delivered to orbit* is payload plus the Starship stack's own dry
mass. *Re-entering space-waste mass* is satellite and debris mass crossing the top of the
atmosphere. Mapping the first onto the second asserts a conversion factor of exactly 1.0 that no
source states. The draft also wrote "at steady state with the five-year satellite lifetime the same
literature uses," which reads as a derivation and is not one: at steady state, re-entering mass
equals launched mass **irrespective of lifetime**, so the lifetime does no work in that sentence.
The assumption actually load-bearing — that essentially all launched mass re-enters — was never
stated. Three paragraphs later the same draft correctly convicts the reentry literature of pairing
four distinguishable mass quantities as if they were interchangeable.

**What replaces it.** The extrapolation is **deleted**, not repaired. What survives is stated in
§4.2 with both quantities named and no ratio taken between them, and the source is labelled for what
it is: a chief executive's stated target reported from a June 2026 interview, whose horizon is
itself reported inconsistently across outlets — "within three years" and "within five years" both
appear from the same remarks. It is not a measurement and not a named house's forecast, and it is
not differenced against peer-reviewed measurements.

**What this implies for reading anyone else's figures, ours included.** The error was not
carelessness about a fact; both numbers were correct. It was a **missing denominator**, and a
missing denominator is invisible in exactly the way a wrong digit is not — the sentence reads
fluently, the arithmetic checks, and the units never appear. That is the general shape of every
finding in §4.3 and §7.3 and of a large share of both adversarial reads. The operational consequence
is a rule this document applies to itself as strictly as to its sources:

> **A ratio without both denominators, or a figure without its definition, is not a number. It is
> two numbers and a hope.**

**And the second read found the same defect again, in the correction itself.** The draft that fixed
the SpaceX conflation went on to publish a corrected ozone figure computed on a basis its source
never used — recomputing a maximum-to-maximum ratio against a source that had stated an
average-to-average one, and then presenting the source as having erred. §7.7 carries that correction
and prints both denominated quantities separately. A correction process that cannot correct its own
corrections is not one, which is why §10 now carries three orders of self-correction and says which
is which.

The remaining corrections are applied in place throughout; the ones a reader is most likely to have
seen in circulation are collected in §10, and those that reversed a claim the previous draft made
**against** the founder's brief are named there explicitly and counted, because a correction that
only ever runs in one direction is not a correction process.

---

## 3. What is shipped today

### 3.1 The live surface, re-measured this session (SHIPPED)

`GET https://affine.earth/language-invariant/games` → HTTP/2 **200**, **94,823 bytes**, sha256
`ce0e342e…1832ee` (measured 2026-09-01T12:17Z). The lattice block declares schema
`affine.earth.lattice.domain_role.v1`, and every count below was re-derived by parsing the served
bytes rather than read from the object's own summary fields:

| field | value | re-derived by parsing |
|---|---|---|
| `domain_count` | 48 | 48 domain records present |
| `role_count` | 88 | 88 role entries across those domains |
| `game_count` | 13 | 13, all `LIVE`, each with a non-empty ingest path |
| `capability_count` | 54 | 54 capability records |
| `servable_count` | 49 | 49 with `servable: true` |
| `absent_count` | 5 | 5 with `servable: false` |
| `no_float` | `true` on 48 of 48 | 48 |
| `pricing_axis` | `entropy_delta_dh_structural` | — |
| `flourishing_kind` | `GUIDE_PUBLIC_FLOURISHING_ALL` | — |

All 48 domains carry five fields with no omissions: `dead_equation`, `new_law`, `proven_marker`,
`study`, `wiki`.

**49 servable, 5 absent** — never "54 capabilities". The catalogue states the law itself:
*"A capability with no cited primitive is visible debt: catalogued, never served, never stubbed."*
Two further notes measured this session, and the first is a correction against the previous draft's
own wording:

- The draft called the five **"declared debt"**. The served object says something weaker and
  something stronger at once. Weaker: all five carry `ui_absence_declared: false` and an **empty**
  `ui_absent_reason`, so the two dedicated fields for declaring an absence are unset — the absence is
  neither declared nor caused *in those fields*. Stronger: each record carries `primitive: "ABSENT"`
  and a description that names the cause in plain words — *"ABSENT: catalogued debt, no primitive,
  never stubbed"*. **The honest form is that the cause is stated in prose and absent from the
  structured fields**, which is a different and more precise finding than "declared debt with an
  empty reason", and it changes the repair from *fill one field* to *fill two, or delete them*.
- **13 of 54** capabilities carry a REST route, against **49** carrying a tool binding and 45 an
  agent-task binding.

### 3.2 Six faces, and a control arm proving they discriminate (SHIPPED)

Every row re-probed 2026-09-01:

| face | route | result, measured |
|---|---|---|
| catalogue | `/language-invariant/games` | 200, 94,823 B |
| context | `/language-invariant/game/geometry/context` | 200, 8,581 B |
| price | `/language-invariant/economics-config` | 200, 20,320 B |
| onboard | `/language-invariant/economics-onboard` | POST 200, body `status: REFUSED` with a named consent block; GET 404 |
| debit | `/language-invariant/domain-debit` | POST 400, names its two required parameters — an account identifier and a domain; GET 404 |
| ingest | `/language-invariant/game/{domain}/ingest` | POST with an unknown role → 404 `REFUSED_UNKNOWN_ROLE`, and the response **lists the three valid roles**; POST with a valid role and no source → 400 `REFUSED_UNATTRIBUTED`, reason: *"POST must name source — absence is recorded, not defaulted"* |
| **control arm** | `/language-invariant/game/NOSUCHDOMAIN/context` | **404, 27 B** |

The control arm carries more weight than the six passes. An instrument returning 200 for everything
has proved nothing. This one returns 404 for a domain that does not exist, and the ingest face
returns **two distinct refusals for two distinct failures** rather than one generic error — a
plausible-but-unknown role and a valid role with no attribution are separated, and the first refusal
prints the valid set.

### 3.3 The fleet (SHIPPED)

`dig +short affine.earth` returns exactly nine A records: `37.27.7.9`, `77.42.32.156`,
`77.42.85.60`, `77.42.88.110`, `135.181.88.134`, `152.53.88.141`, `152.53.91.220`,
`37.120.187.174`, `37.120.187.247`.

The fleet watchdog pins SNI and resolves to each IP in turn so no round-robin can hide a straggler:

> `healthy 9 · broken 0 of 9` · UI 200 at 229,690 bytes on 9/9 · API latency median 0.863 s, no cell
> above 3× · frame latency median 0.448 s, range 0.156–0.969 s, no cell above 3× the frame median →
> **`AFFINE_APEX_FULLY_LIVE`**

**A correction that runs against the previous draft.** That draft reported
`AFFINE_APEX_DEGRADED` with one cell at 1.957 s against a 0.479 s frame median — 4.09× — and carried
it into two further sections and a named open question as a **standing state of the fleet**. It does
not reproduce: the same cell measures 0.495 s. A single latency sample is a sample. The watchdog
does record a genuine unresolved history on **nbg-03** — a freshly recreated container serving
6.7–8.8 s against a peer's 0.16 s at host load 3.28 on 14 cores, measured 2026-08-03, so neither
process state nor CPU saturation — and the draft attached that history to **nbg-00**, which is a
different cell with a different role. Both errors are corrected here: the fleet is fully live today,
and the 2026-08-03 nbg-03 observation stands unexplained and is listed as open.

### 3.4 Byte identity, stated at exactly its measured size (SHIPPED, one gate closed since the last draft, one still open)

This is the document's central shipped property, and it is the place the previous draft was least
accurate. Three separate gates, and they now say three different things from the three they said on
2026-08-31.

**Gate 1 — fleet byte identity, across all nine cells (run 2026-08-31T23:53:24Z).** The gate names
24 artifacts. Counted by what each row actually establishes:

| outcome | count | what it means |
|---|---|---|
| **byte-identical with a real digest on 9/9** | **15** | cell binary `ecaf5c1d1028a8ea`, tau injector `340e596987e4cfaa`, message-bus server, autoheal, tau watchdog, the IR daemon, consensus-DNS runner, a fleet runner, guardian, running tau executable, membrane route table, served index `1591db491710c3a7`, membrane UI home, served Rust shell wasm `1746e602f94192ae`, served law wasm `131db69bd8ef2293` |
| identical **in absence** | 8 | six host daemons absent on all nine; no container binary on any; one served alias returns 404 on all nine. **Four of these eight are declared retired with a written cause** in the gate's own `retired` block |
| **DIVERGENT** | **1** | one fleet artifact, 2 distinct values across 9 |
| verdict | **`FLEET_BYTE_IDENTITY_DIVERGENT`** | set by the divergent lease-holder row |

15 + 8 + 1 = 24, and the partition is stated that way because the previous draft printed
"4 identical in absence, 4 declared retired" as if those were disjoint outcomes. They are not: the
four retired rows are four of the eight absences, distinguished by carrying a stated cause.

**Counting the absences as byte-identity would be this repository's own always-green defect**, and
an earlier draft did exactly that: it reported *"every one of the 24 is `distinct: 1`"* and *"the
cause is not artifact drift — all 24 artifacts are identical on 9/9"*, while the gate's own output
carried a DIVERGENT row. The honest sentence is: **15 artifacts byte-identical on nine cells, 8
identical only in absence of which 4 are declared retired, 1 divergent, and the seal withheld.** The
one divergence is a **lease holder** — ephemeral coordination state with a 15-second TTL, not durable
data — and naming it as an artifact divergence is itself a category confusion the gate should stop
making.

**Two disclosures the previous draft owed and did not make, both against its own standard.**

1. **The producing run carried no control arm.** Its own verdict record reads
   `"control_arm_injection": "none"`. §12 asks for exactly this — *an instrument must be shown to
   discriminate on the run that produces the verdict* — and a document that convicts other people's
   instruments of undocumented non-discrimination has to disclose it about its own. The gate's
   refusal text is good (*"A verdict over a subset is the defect this gate committed on
   2026-08-15"*) and a refusal to certify a subset is worth more to a diligence reader than a green
   tick, but neither of those is a control arm.
2. **The previous draft's stated cause for the withheld verdict is withdrawn as unreproducible.**
   It wrote *"withheld for coverage: one service-invoked executable, `affine-tls-expiry-watch.sh`"*.
   The verdict record sets `FLEET_BYTE_IDENTITY_DIVERGENT` from the lease-holder row, and its
   coverage block reads `the covered count: 15, the observed count: 11, complete: false` and **names no
   count and no name of an uncovered executable**. Two different causes were conflated and a figure
   was attributed to an artifact that does not contain it.

**Gate 2 — is the served client artifact the committed one? Now green, and it was not on 2026-08-31.**

Measured 2026-09-01, per cell with a pinned resolution, nine separate fetches:

| cell | HTTP | bytes | sha256 (first 16) |
|---|---|---|---|
| all nine | 200 | **12,347,843** | **`131db69bd8ef2293`** |

The artifact committed at HEAD is **12,347,843 bytes**, sha256 `131db69bd8ef2293`. **The bytes nine
cells serve are the bytes committed at HEAD, exactly.**

The previous draft reported `WASM_NOT_BUILT_FROM_HEAD` against a committed blob of 12,232,641 bytes
(`95691f55ee995584`), with 10 of 14 comparable sections differing, and identified the served bytes as
"the uncommitted worktree copy". The artifact has since been committed, and that verdict is
superseded. **Two method notes survive the repair and are worth more than the verdict was.**

- **The previous draft identified the third object by byte count alone.** It printed digests for the
  served bytes and for the tracked blob but not for the worktree file, while stating the rebuild at
  the *same* 12,347,843 bytes — so size could not discriminate between "a rebuild" and "the worktree
  copy", and the sentence named one of them anyway. **A mismatch shown on one attribute is not an
  identification.** Here both objects are digested and the identity is a digest equality, not a size
  equality.
- **What is proven is artifact identity, not build reproducibility, and they are different claims.**
  "The served bytes equal the committed bytes" is a statement about one object appearing in two
  places. "Two independent builds of this source produce those bytes" is a different statement and
  it is not made here — a whole-file digest over a built artifact bundles the law with a small amount
  of toolchain bookkeeping, and the property the substrate needs is that every law-carrying section
  is identical, which is a per-section claim. The distinction is stated because collapsing it is the
  same move as collapsing a mass figure onto an alumina figure.

**Gate 3 — client frame parity. Still open; last run 2026-08-31 and not re-run this session.**
Verdict: **`CLIENT_FRAME_PARITY_GATE_OPEN`.** The gate rasterises a frame, then runs its own control
arm — move one bond by the smallest step the frame's depth can resolve and require the digest to
change. It did not change. The gate's own words: *"moving a bond by one cell at depth 6 did NOT
change the digest — this comparison cannot detect a wrong frame."* It therefore refuses to certify.
That it is carried here at its 2026-08-31 date rather than restated as current is deliberate: a gate
result is a measurement with an instant, and §10.8 is this document's own demonstration of what
happens when that instant goes unprinted.

**So the claim, at its true size.** What is measured today:

1. **Nine cells serve byte-identical bytes.** Fifteen artifacts, one digest each across 9/9,
   including the served law wasm and the served Rust shell wasm. This is real and it is the property
   that makes "checking costs a fetch" true.
2. **The served law wasm and the served Rust shell wasm are both the artifacts committed at HEAD.**
3. **What is still not measured** is source-to-frame parity: that the same law source, compiled two
   ways, draws the same picture. The gate that would establish it is the one that refuses to
   certify, because its control arm does not fire. That is the instrument declining, not the
   property failing — and **a true fact about a different question is not the question.**

### 3.5 The exact-arithmetic evidence programs, re-run this session from the public tree (SHIPPED)

Every program in the table was fetched from
`github.com/gaiaftcl-sudo/uum8dSolarResearch/tree/main/reproduce`, compiled and executed this
session. **The scope of that sentence is the seven program rows and not the eighth**: the last row
is a checksum manifest, not a program, and the previous draft's *"every program below is committed,
contains zero float types, and was compiled and executed"* ranged over a table one of whose rows
cannot be compiled and one of whose properties was reported for a single row.

| program | key output, reproduced verbatim |
|---|---|
| `reproduce/reentry-alumina-ledger.swift` | yield **3/25** exact; **374.4 t/yr** (= 1872/5) and **1,152 t/yr** from Maloney's own satellite count; alumina-against-alumina ratio **16/5 = 3.20×**; and a second reading of the same paper at **74.88 t/yr** (§7.4) |
| `reproduce/z8-vs-e8-lattice.swift` | kissing 16 vs 240 by direct enumeration; density ratio exactly 2⁴ = 16 |
| `reproduce/lora-time-on-air.swift` | 42-byte frame → 58 symbols → **287.744 ms**; 125 tx/hr at the duty ceiling |
| `reproduce/cost-matrix.swift` | orbital 1:100 aggregation **$1,594,900** vs pod mesh **$1,825,000** (§9.4) |
| `reproduce/pod-energy-budget.swift` | **both** operating points: 3,240,490 µJ/hour at the binding 60 tx/hr and 6,660,932 µJ/hour at the 125 tx/hr ceiling |
| `reproduce/guadalupe-wave-ledger.swift` | peaks, lags, and **180 minutes** of lead time at a threshold frozen in advance |
| `reproduce/rate-of-rise-common-window.swift` | rate of rise on a **common** sampling window (§6.3) |
| `corpus/flood-lead-time/SHA256SUMS` | `shasum -a 256 -c` → **4 of 4 OK** (a manifest, not a program) |

**The float scan is reported for the row it was run on and no others.** A grep for float types on
`guadalupe-wave-ledger.swift` returns zero hits. A set-wide scan is listed in §12 rather than
asserted here.

**The working directory is part of the citation, and omitting it made two of these irreproducible.**
Both flood programs resolve their corpus by bare filename against the current directory. Run from
anywhere else, `rate-of-rise-common-window.swift` prints 0 milli-ft/min on every line and
`guadalupe-wave-ledger.swift` aborts. **Every flood figure in §6.2 and §6.3 reproduces with the
working directory set to `corpus/flood-lead-time/`, and only there.** That is now stated with the
citation, and the deeper defect it exposes is in §6.3.

**Two corrections that run against the previous draft, both in the founder's brief's favour.**

- The draft reported that `pod-energy-budget.swift` *"hardcodes 125 tx/hr"* and that the binding
  60 tx/hr figure was *"emitted by no committed program"*, and instructed that the ceiling figure be
  quoted as the headline. That is false. The program prints **both operating points by
  construction**, binding rate first. The brief was right and the draft's "correction" would have
  made the document quote the non-binding rate as its headline.
- The draft cited the flood corpus at a path that does not exist. It is `corpus/flood-lead-time/`.

### 3.6 Our own gates pass, and passing is not absence

**This is the most important paragraph in the document about its own instruments, and it belongs in
a document that convicts four vendors of undocumented non-determinism.**

Measured this session, the substrate's phase-0 gate set is green: seven gates pass, including all
four float gates, the append-only-not-disarmable gate over the ledger, and the
sanctioned-language gate. The release build completes with rc=0 and both products signed.

**And a green float gate is not an absence of floats.** The type ratchet prints, verbatim:

> `current: 0` … `RESULT: NO_NEW_FLOAT_TYPES — at baseline (0)` … *"The ceiling is ZERO: the
> substrate path holds no float-typed declaration."*

Measured the same hour, inside the paths that gate scopes: **24 float sites — 19 in one module and 5
in another.** None of them is matched by the gate's regex, because they are written as `[Double]`,
`<Double>`, `Float32` and a bare colon-`Float`, and the regex looks for a different spelling. The
gate's own header line prints the second half of the defect: it scanned **"5 of 6 listed paths"** —
the sixth does not exist, and a path that does not exist contributes zero violations, which is
indistinguishable in the total from a path that is clean.

**What is and is not true, stated exactly.** The gate is a **ratchet**, and as a ratchet it works: a
new float written in the spelling it matches fails on the commit that adds it. What it is not is a
certificate of absence, and its own summary line says the stronger thing. The 24 sites are not a
live determinism failure either — the axis domain they occupy is finitely enumerable and exactly
representable, so two cells do not disagree — but that is a fact about those particular sites, not a
property the gate establishes.

**The general form, and it is the rule this whole document runs on:** *always-green and always-red
are the same defect*, and **a rule scoped to where you expect the violation will not catch it where
it happens.** Cite the gates as **passing**. Never cite them as proof of absence. A document that
asks Ansys, Dassault, NVIDIA and ISO to state what their instruments do not cover has to state what
its own do not cover first, and this is it.

---

## 4. The three markets, and the seam each one leaves open

The position in each market is a **property claim about an instrument**. It is not a claim that any
incumbent is wrong, that any customer is harmed, or that any vendor's physics is defective.

**Every figure in this section is third-party, with one labelled exception**: the radiator
normalisation in §4.2 is first-party prose arithmetic over four published constants and is labelled
**DERIVED** where it appears. Each third-party figure carries its house, its year, its publication
date where that differs from its base year, its base year where a growth rate is quoted, and its
definition **where the house publishes one**.

**One fact about the market data itself, which is worth as much as any single figure in it.**
**IoT Analytics is the only house surveyed that publishes its scope boundary in plain terms** —
software only, split explicitly into a *broad scope* (any software providing digital-twin
capabilities: integration, simulation, visualisation, prediction) and a *narrow scope*
(digital-twin-specific software only). That one house's disclosure is what makes the spread below
legible instead of merely wide.

**And the honest form of the conclusion is weaker than the one usually drawn from it.** It is
tempting to write that where houses disagree by a wide margin they are almost always counting
different things. **That is a frequency claim over a population whose definitions are unreadable,
and this document does not make it.** With one house of five publishing a scope boundary, the cause
of the other spreads is **unmeasured** — definitional difference, publication vintage and genuine
disagreement about the same object are all consistent with what is visible, and §4.1 shows the
vintage component is real. What *is* measurable, and is the finding: **four of five surveyed houses
publish no scope boundary at all**, which is a fact about the sector's own instrument and needs no
frequency claim to be damaging.

### 4.1 Digital twins

**The market, with definitions attached where they exist, and publication dates attached because
vintage is doing some of the work.** For the same base year 2025, published estimates span **1.89×**:

| house | 2025 figure | published | definition, as the house states it |
|---|---|---|---|
| Global Market Insights | USD 18.9bn | not stated in material reviewed | **none published** |
| MarketsandMarkets | USD 21.14bn | report SE 5540, **1 August 2025** | **none published** |
| Fortune Business Insights | USD 24.48bn | not stated in material reviewed | **none published** |
| Stratview Research | USD 30.8bn | not stated in material reviewed | **none published** |
| Grand View Research | USD 35.8bn | from a report published **June 2026** | **none published** |

**The 1.89× is not a clean definition spread, and the previous draft presented it as one.** Only one
of the five figures is dated in the material reviewed. Grand View's 35.8bn comes from a June 2026
report — a near-final estimate for a year almost over — while MarketsandMarkets' 21.14bn was
published in August 2025 as a nowcast. **Estimates issued roughly ten months apart for the same year
differ partly by vintage**, and the section's own discipline requires the publication date to travel
with each figure and not with one of five. It is stated here as a spread across five houses at one
base year with four publication dates unknown, which is what was actually measured.

Endpoints diverge further:

- **MarketsandMarkets** (1 August 2025): USD **21.14bn (2025) → 149.81bn (2030)**, stated CAGR
  **47.9%**. Reproduces from its own endpoints: 47.94%.
- **Grand View Research**: the series runs **2026–2033** off a **USD 49.5bn 2026 base** →
  **USD 328.5bn (2033)** at a stated **31.1%**. That reproduces from *its own* base year: 31.04%
  over seven years. Their 2025 figure is 35.8bn, and **compounding 31.1% from 2025 does not reach
  328.5** — that path needs 31.9% over eight years. The 35.8bn belongs in the same-base-year spread
  above; the 31.1% belongs to 2026–2033. They are not the same series and this document does not
  join them.
- **IoT Analytics** additionally reports **29% of global manufacturing companies** had fully or
  partially implemented digital-twin strategies as of **2023**, up from 20% in 2020 — an adoption
  share, not a revenue figure, and not additive with any number above it.

**The seam, in the vendors' own words.** This is the strongest material in the document and none of
it is ours.

- **Ansys**, Release Notes **18.2**, Mechanical APDL backward-compatibility paragraph: results
  obtained from old databases running in new releases *"may differ somewhat from those obtained
  previously"*. The Fluent notes carry the same standing statement for case and data files.
- **Dassault Systèmes SIMULIA**, Abaqus User's Guide, **"Consistency of results"**: analysis results
  are **independent of the number of processors** but *"do depend on the number of parallel domains
  used during the domain decomposition"*, with the cause named as finite-precision effects in nodal
  force assembly order. **Both halves matter and both are kept.** An Abaqus/Explicit verdict is a
  function of the **domain count the analyst chose**, not of the machine the job landed on — an
  earlier draft wrote "a function of the cluster shape it ran on", which is a stronger and different
  dependency than the sentence it rested on, and the vendor's own sentence refutes it. Change the
  decomposition and the trailing digits move; add processors at a fixed decomposition and they do
  not.
- **NVIDIA**, PhysX 5.1 Best Practices Guide: determinism is scoped to a given platform;
  *"Results can vary between platforms due to differences in hardware maths precision and
  differences in how the compiler reorders instructions"*; and *"even the addition of a single actor
  that is not interacting with the existing set of actors in the scene can produce divergent
  results."*
- **NVIDIA**, Isaac Lab reproducibility: guaranteed only for the **same hardware and the same
  version**, and *"PhysX does not guarantee determinism for any scene with non-rigid bodies."*
- **MathWorks**, Simulink Coder, numerical consistency of model and generated code: on fixed-point
  types *"the results agree in a bit-wise comparison"* and *"you can specify an absolute tolerance of
  zero"*; on floating point they agree only *"with an error tolerance that you specify."* That is
  **one premise** of this document's argument, written by a major vendor into its own product
  documentation — the exactness/tolerance dichotomy. It says nothing about exact rationals, fleet
  byte-identity, replay-as-audit or priced ledgers, and the previous draft's claim that it contains
  *"the entire argument of this document"* is withdrawn.
- **ISO/FDIS 23247-1** (ISO/TC 184/SC 4, ballot 2021): full-text extraction gives `reproducib` = 0,
  `repeatab` = 0, `floating` = 0, `precision` = 0. **These counts are measured on the FDIS text, a
  draft**, and that qualifier travels with the claim everywhere it appears in this document
  including §1. Whether the published edition differs is not established here and is carried as an
  open question in §11. The one fidelity requirement in the FDIS is that a twin *"shall describe the
  state of its corresponding OME at an appropriate level of fidelity"* — with *appropriate* left
  undefined.
- Independent measurement of the underlying arithmetic: Shanmugavelu, Taillefumier, Culver,
  Hernandez, Coletti and Sedova (arXiv:2408.05148v3, 30 October 2024, ORNL/CSCS) trained 1,000
  identically-configured GNN runs; all 1,000 produced a unique set of weights — *"completely
  non-reproducible, even for a single user on a single machine"* — and non-deterministic reduction
  variability can approach the tolerance thresholds used in high-accuracy correctness tests.
- The C++ committee is still working the problem: **WG21 P3375R3** (Davidson, 12 May 2025) states
  C++ provides no support for reproducible floating-point programming, with a worked example where
  identical source yields 0.0999997, 0.0999999 and 0.1 on three compiler configurations.

**What regulators actually require, stated precisely so it is not overstated.** FDA's final guidance
of 17 November 2023, built on ASME V&V 40-2018, requires risk-proportionate credibility evidence —
code verification, calculation verification, validation, uncertainty quantification — defining
calculation verification as *"the process of determining the solution accuracy of a calculation."*
EASA CM-S-014 (14 July 2020) addresses credibility, V&V and errors/uncertainties for CS-25
structural certification by analysis; whether it names bit-exact reproducibility is **not
established** from the sources reviewed and is carried as an open question in §11. NRC RG 1.203 with
10 CFR 50 Appendix B and NQA-1 make documentation and independent peer review the assurance
mechanism. The one regime with a reconstruction requirement in plain words is pharmaceutical GxP:
MHRA's Data Integrity Guidance (Revision 1, March 2018) requires records that *"allow reconstruction
of all data processing activities"* — written for records under GxP, not for simulation verdicts,
and extending it to twin outputs is an extension the source does not make.

**The seam.** **No regime among those reviewed requires bit-exact replay**, and §11 lists the ones
not reviewed — EASA CM-S-014, DNV-RP-A204 (paywalled) and NASA-STD-7009A's credibility-factor list
(not retrieved) — so this is a statement about the regimes examined and not a universal negative.
Every one of those examined requires a credibility package assembled from documentation, version
control and peer review. On exact rationals over a byte-identical fleet, that package is replaced by
re-execution: the reviewer re-derives the number instead of reading about how it was produced.
**That is an argument to make to a buyer, not a requirement to cite.** No cost comparison between
the two evidence packages is offered, because none has been done — an earlier draft asserted the
exact-arithmetic package is cheaper with no arithmetic anywhere behind it, three sections before §9.4
refuses a cost claim precisely because the arithmetic goes the other way, and that sentence is
deleted rather than defended.

**What is not claimed:** that incumbent twins are wrong, that their customers are harmed, or that
any regulator requires what we provide.

### 4.2 Orbital compute

**The market, with its spread.**

- **Fortune Business Insights** publishes a three-point series: USD **1.28bn (2025)**, USD
  **1.44bn (2026)**, USD **3.81bn (2034)**, stated CAGR **12.96%**. **The house's own base year is
  2026**, and off that base 1.44 → 3.81 over eight years compounds at **12.93%**, materially closer
  to the stated 12.96% than the 12.88% an earlier draft obtained by taking the 2025 and 2034
  endpoints and re-deriving. **The house's stated rate is 12.96% and this document quotes that**,
  because §4.1's own instruction is to state the house's base year and endpoints and not to
  re-derive a CAGR the house did not state. The earlier re-derivation is withdrawn, and it is the
  same base-year defect the same section convicts Grand View of, committed three paragraphs later.
- **BIS Research**: USD **1,776.7m (2029) → 39,090.5m (2035)**, stated **67.40%** — reproduces
  exactly.
- **MarketsandMarkets**: USD **0.11bn (2026) → 28.16bn (2040)**, *"at a CAGR of 18.3%"*. **Both
  endpoints verify as quoted and the CAGR does not close**: 0.11 → 28.16 over fourteen years is
  ~48.6% compounded, not 18.3%. Flagged here rather than left for a reader to find; use the
  endpoints or the rate, never both as if they agreed.

**The spread across those series is 10.3×, and it is a spread across two different end years**:
Fortune's 3.81bn is a **2034** figure and BIS's 39,090.5m is a **2035** figure. **No causal
attribution to definitional difference is made**, because the same cross-year construction is the
one §4.3 corrects for quantum, and leaving it standing one section earlier would be the document
convicting itself. Both years are printed; the ratio is a two-year-apart comparison and is labelled
as one.

**The cost-premium question is worse, and each figure needs its metric and its horizon named.** The
previous draft's table had no horizon column, which turned a **time spread** into an apparent
**definition spread**: at least three of the six sources publish a converging trajectory rather than
a fixed premium, so part of the range is that the figures are quoted at different points on curves
that are moving toward each other.

| source | figure | metric, as the source defines it | horizon the source states |
|---|---|---|---|
| Bain, 17 July 2026 | ~**1.5×** | **per kilowatt**, a 100 MW orbital constellation against a comparable terrestrial facility — roughly 50% more per kW | present-day, at that stated scale |
| BCG, 2026 | **2.5–3×** | **20-year TCO per MW**: ~USD 660–750M/MW orbital against ~USD 230–300M/MW terrestrial | today, narrowing to ~1.5× over a decade; 1.2× at a 10% failure rate and 1.1× at 5% under full next-generation launch economics |
| **SemiAnalysis, 3 June 2026** | **3.6×** — $8.64 vs $2.37 per GPU-hour | **total cost of ownership per GPU-hour**, B300 | 2026 |
| **SemiAnalysis, same article** | **"over 4×"** | **levelized cost of compute**, adding radiation availability and redundancy | 2026, narrowing to parity around 2040 |
| ABI Research, 11 May 2026 | **78×** | **TCO over the full lifecycle** — launching the hardware, a 5-to-7-year orbital lifespan before the satellites burn up, and continued maintenance of terrestrial training clusters | present-day; ABI expects orbital to approach terrestrial by 2035 |
| Turyshev (JPL/Caltech, arXiv:2604.27197v1, 1 May 2026) | 3.4–13.5× **below** | allowable combined launch-plus-build budget, against the published Falcon 9 price alone | present-day |

**Two corrections against the previous draft in this table.**

- **The SemiAnalysis levelized pair is not corroborated and is no longer printed as a checkable
  figure.** The draft printed USD 10.91 vs USD 2.49 per GPU-hour and computed 4.38× to two decimal
  places. The TCO pair (8.64 / 2.37, 3.6×) is published and retrievable; the levelized pair is not
  present in any accessible rendering of the article or the model page, which confirms only that
  SemiAnalysis computes an LCOC metric and states its headline as **"over 4× in 2026"**. **The
  denominator pair sits behind the paywalled model**, so the clear-text figure is what is quoted.
- **ABI's 78× was flagged as having no stated horizon or system boundary, and ABI states both.**
  The draft wrote that they "are not stated in the material reviewed", flagged the figure "not
  comparable", and carried that as a standing open question. **"Not in the material I reviewed" and
  "not stated by the source" are different claims, and only the first was measured.** ABI publishes
  the lifecycle boundary and dates the figure as present-day by projecting parity by 2035. The
  figure is placed on the axis with the others and the open question is withdrawn.

Six denominators over three horizons. Any document quoting one of these as *the* premium has made a
units error, and any document quoting the spread between them as a pure definition spread has made a
second one.

**The seam is a units seam, and it is demonstrable in three lines of arithmetic (DERIVED).**
Starcloud's whitepaper (Feilden, Oltean and Johnston, Lumen Orbit, September 2024) states
**633.08 W/m²** of net radiated power; Turyshev's base case is routinely paired against it as
"400 W/m²". Neither pairing is like-for-like, and there are two stacked denominator errors.
Starcloud's figure is per square metre of **plate radiating from both sides** — their own derivation
is 2 × 385.24 = 770.48, minus 122.94 absorbed solar, minus 14.46 Earth contribution — which is
**316.54 W/m² of radiating surface**. Turyshev's 400 W/m² is per **IT kilowatt**, not per watt of
heat; heat rejected per m² of effective radiator area in his base case is **500 W/m²**, the 1.25
being his orbital overhead factor. Compared correctly, the sceptical paper's model is
**500/316.54 = 1.58× more optimistic per unit of radiating material** than the vendor's. **The
casual pairing inverts the ordering**, and that is the whole finding.

**The causal clause an earlier draft attached to that ratio is withdrawn, because it does not
reproduce.** The draft wrote that the 1.58× arises *because* the sceptical model runs the radiator
at 350 K where the vendor runs it at 293.15 K. Stefan–Boltzmann on those temperatures alone gives
(350/293.15)⁴ = **2.03**, not 1.58, so temperature is not the whole cause — emissivity, the absorbed
solar term and the Earth term all sit between them, and no derivation closing 2.03 to 1.58 is
offered here. **In a paragraph whose entire value is that a reader can check it in a minute, an
unclosed "because" is worse than no "because" at all.** The ratio stands as measured; the
attribution is deleted.

**This paragraph is labelled DERIVED and not SHIPPED, and the distinction is not cosmetic.** Unlike
the alumina ledger, no program emits these numbers; they are arithmetic in prose over four published
constants. A reader can check them in a minute, but they are not re-executable from the public tree,
and §7.3's claim that the method is general therefore rests on one shipped instance and one derived
one. Committing this arithmetic as a program is listed in §12.

**The reentry ledger is exactly countable, which is the second half of the seam.** Measured annual
space-waste mass influx to the top of the atmosphere: 0.94 kt (2015), flat below 1 kt through 2020,
then 1.06, 1.27, 1.26 and **1.59 ± 0.05 kt in 2024** (Schulz, Glassmeier, Herberhold, Mitchell,
Murphy, Plane and Plaschke, *Advances in Space Research*, accepted 6 March 2026,
doi:10.1016/j.asr.2026.03.026). Their largest published scenario is 75,000 constellation satellites
at **8.1 kt/yr**.

**Separately, and not differenced against those:** SpaceX has publicly targeted about **one million
tonnes per year of total upmass delivered to orbit** — payload plus the launch stack's own dry mass —
up from roughly 2,500 t/yr today. The source is a chief executive's remarks in a June 2026
interview, reported with **inconsistent horizons across outlets**: "within three years" (Light
Reading, 10 June 2026) and "within five years" (Bloomberg-sourced coverage of the same remarks). It
is an aspiration, not a measurement and not a named house's forecast. **The two quantities are not
the same measurand and this document takes no ratio between them.** What is sayable is qualitative
and still worth saying: **the scale being publicly targeted for launch is discussed in units the
reentry modelling literature does not model in**, and closing that gap requires a stated
satellite-mass fraction of upmass that no source reviewed provides. That is a statement about model
coverage. It is never a statement about the atmosphere.

**What is not claimed:** that orbital compute is unviable, that any ecological harm is established,
or that Affine.Earth measures anything above the boundary layer. Turyshev's own C1/C2/C3 split is
the honest reading of where orbital closes: space-native preprocessing first, communications-
integrated edge second, terrestrial-user general compute last and only under narrow conditions.

### 4.3 Quantum

**The market, and the definitions are the whole story.** The figures usually listed side by side do
not count the same thing:

| house | figure | year | definition |
|---|---|---|---|
| BCC Research | USD 1.6bn → 7.3bn by 2030, stated CAGR **34.6%** | 2025 | quantum **computing** |
| MarketsandMarkets | USD 3.52bn → 20.20bn by 2030 | 2025 | quantum **computing** |
| **QED-C** | **USD 1.9bn** | 2025 | **the whole quantum technology industry** — USD 1.4bn computing **plus** USD 0.47bn sensing |
| **The Business Research Company** | **USD 3.62bn** | **2025** | quantum computing |
| Grand View Research | USD 1.9bn | 2026 | quantum computing |
| The Business Research Company | USD 5.09bn | 2026 | quantum computing |

**BCC's own internal base-year discrepancy is flagged here, because the same class of defect is
flagged for MarketsandMarkets two subsections earlier and applying a discipline to one house and not
the other is not a discipline.** BCC's report highlights read *"from $1.6 billion in 2025 to reach
$7.3 billion by the end of 2030, at a CAGR of 34.6% from 2025 to 2030"*, while its own synopsis table
carries a **2024 base-year value of USD 1.3bn**. The stated CAGR is quoted rather than re-derived,
and the internal inconsistency is printed where the figure is used rather than left to be found.

**The QED-C figure is a different measurand from the ones it is normally printed beside**, and
listing it under "the same named sector" is the exact conflation the paragraph exists to expose.
Its comparable line is the **USD 1.4bn computing** figure.

**The spread, with its year set stated, and with a same-year figure the previous draft omitted.**
Held to **2025** alone, quantum-computing estimates run BCC **USD 1.6bn** to TBRC **USD 3.62bn** =
**2.26×**, widening to **2.59×** against QED-C's USD 1.4bn computing line. **TBRC's own 2025 value
is higher than MarketsandMarkets' 3.52bn**, and the previous draft's spread — BCC 1.6 to M&M 3.52 =
2.2× — omitted it from a cited house, in the one comparison whose entire validity rests on holding
the year fixed. Held to **2026** alone: Grand View USD 1.9bn to TBRC USD 5.09bn = **2.7×**. An
earlier "3.2× on the same named sector in the same year" was computed across **two base years** —
2025 low against 2026 high. Corrected: **2.26×–2.59× within 2025, 2.7× within 2026, and neither is
3.2×.**

**McKinsey's Quantum Technology Monitor 2026** projects USD **1.3–2.7 trillion of economic value by
2035** and sizes the **quantum technology market at USD 60–100bn by 2035** — of which **quantum
computing is USD 43–71bn**. **The horizon travels with both measurands, which is the correction
here**: an earlier draft printed "by 2035" on the value figure and omitted it from the market
figure, which invites exactly the reading the paragraph warns against — a 2035 projection differenced
against an apparent present-day market. The ratio between them depends on which ends are paired:
**13×** (1.3T against 100bn), **45×** (2.7T against 60bn), and **21.7× / 27×** on the like-for-like
low and high ends. "Roughly 20×" is one of four defensible answers and an earlier draft picked it
without saying which. The **USD 43–71bn computing line is the one comparable with the
quantum-computing rows in the table above**, and it is given so a reader can make that comparison
rather than the wrong one. Context: more than USD 1bn of sector revenue in 2025 against USD 12.6bn
of investment.

**The seam is verification, and the sector is already paying for it.**

- The central problem class makes classical checking hard by construction. The k-local Hamiltonian
  problem is QMA-complete (Kitaev; Kempe, Kitaev and Regev, FSTTCS 2004, LNCS 3328, 372–383) — the
  witness is quantum. Boson-sampling output probabilities are permanents of complex matrices, and
  computing permanents of random matrices is #P-hard (Aaronson and Arkhipov, STOC 2011; Valiant,
  *Theoretical Computer Science* 8(2), 1979). Verification and advantage are the same wall seen from
  two sides.
- **Cross-entropy benchmarking, the scoring method for random-circuit-sampling advantage, is not
  computed directly at advantage scale.** XEB fidelity is **estimated by extrapolation from smaller
  and patched circuits**, which is precisely why those claims are contestable rather than
  self-certifying. An earlier draft wrote that XEB *requires* classically simulating the very circuit
  whose classical simulation is claimed infeasible — an assertion of impossibility that the published
  experiments demonstrably worked around. The corrected form is sharper for the argument, not
  weaker: the score that establishes advantage is itself an extrapolation, so the verdict rests on a
  modelling step rather than on a re-derivable object.
- **Certified randomness is the clearest priced instance.** JPMorganChase with Quantinuum, Argonne,
  Oak Ridge and UT Austin (*Nature*, announced 26 March 2025) certified **71,313 bits** of entropy
  using a combined sustained **1.1 ExaFLOPS** of classical machinery — verification consuming vastly
  more resource than the computation, and itself defined in floating-point operations.
- **DARPA's Quantum Benchmarking Initiative**, Stage B selections announced **November 2025**,
  advanced **eleven companies** at **up to USD 15M each — a ceiling of USD 165M in obligations, not
  an amount awarded or spent** — over a stage running approximately one year, to *"rigorously verify
  and validate"* whether any approach reaches utility scale by 2033, with a government V&V team at
  the final stage. **The corrected reading, against the previous draft's:** the Stage B awards fund
  the eleven companies' **own development while under evaluation**, so characterising the whole
  ceiling as purchased verification overstates it. What the programme does establish is that **the
  buyer of last resort has made independent verification the gating condition on the money**, and has
  staffed a government V&V team to do it — which is the claim the seam actually needs. In a bullet
  whose weight rests on what is being bought, the difference between a ceiling and a disbursement is
  the denominator.
- The commercial validation layer is instrument-vendor-owned: Keysight acquired Quantum Benchmark in
  May 2021, and the community alternative (the QED-C suite) was developed with participation from
  the vendors it benchmarks.
- Disputed verdicts in the sector are float-defined and settled by argument rather than by
  re-derivation: suppression factors with error bars (Google Willow, Λ = 2.14 ± 0.02, distance-7 at
  0.143% ± 0.003% per cycle, *Nature*, 9 December 2024, doi:10.1038/s41586-024-08449-y), and speed
  ratios that moved by orders of magnitude within days (Sycamore's 10,000 years reduced by IBM to
  2.5 days, then to about 15 hours on GPUs by Pan Zhang's group; Quantum Echoes at 13,000×,
  currently standing, *Nature*, October 2025, doi:10.1038/s41586-025-09526-6).

**One example withdrawn, and why.** The previous draft offered Quantinuum Helios as "same machine,
two numbers" — 99.921% from a vendor datasheet against 99.7% from Sandia. **That is the reverse of
what the source says.** The peer-reviewed Sandia/Quantinuum work (*Nature*, June 2026) reports
**Sandia-verified** two-qubit gate fidelity of **99.921%** (average infidelity 7.9 × 10⁻⁴),
single-qubit 99.9975% and SPAM 99.967% on the 98-qubit Helios. The only 99.7% traced is a single
secondary outlet reporting "99.7 percent and 99.7 percent, respectively, in single- and two-qubit
operations", which contradicts the 99.9975% single-qubit figure in the same body of work and reads
as that outlet's own rounding. **One independently verified measurement and one outlet's rounding is
not a disputed pair**, and the example is deleted rather than repaired. The seam does not need it:
the 1.1 ExaFLOPS certification and DARPA's staffed V&V gate carry the argument on their own.

**The seam.** When two parties disagree here, they disagree about a real-valued quantity computed by
different codes on different machines, and neither can hand the other an object that settles it.
That is a gap in the instrument, not a verdict on anyone's physics. Classical verification of
quantum computation is a live research programme — Mahadev, FOCS 2018, 259–267, is interactive and
rests on the hardness of Learning With Errors — not an offline certificate.

**What is not claimed:** any sizing of a market for exact verification as a distinct line item.
**No analyst house surveyed prices it.** The segment is unpriced by every one of the definitions
reviewed, and manufacturing a number for it would be the exact failure this document exists to
avoid. There is likewise no maintained registry adjudicating advantage claims, so any "N% of
advantage claims have fallen" figure in circulation is unsourced.

---

## 5. The flourishing ledger, priced

### 5.1 The correction that must travel with every ledger figure (SHIPPED)

The founder's brief states that every domain carries the entropy triple and a cost. Measured on the
live catalogue and on the pinned domain spine (24,996 bytes, sha256 `b46bb35b…0261c`): **nine of 48
domains are priced. Thirty-nine are not.** In the pinned spine, `entropy_delta` and `qfot_cost` are
present as `null` on exactly 39 records and as an exact rational on exactly 9. The nine are
geometry, chance, algebra, physics, qcd, health, finance, cs, fluids — exactly the set the brief's
examples are drawn from, so the examples are the whole population rather than a sample of it.

**The claim that survives diligence:** 48 domains restated from a retired equation to a new law, all
48 carrying `no_float: true`, of which **nine are priced in exact rationals**. "A priced ledger per
domain" does not survive and should not be written.

### 5.2 The per-domain triple — a definition, not a verified invariant (SHIPPED, correctly scoped)

For each priced domain *d*, the served object carries three exact rationals, and they satisfy:

> H_bare(d) − ΔH(d) = H_res(d) = 1/1   and   qfot_cost(d) = ΔH(d)

| domain | H_bare | ΔH | H_res | cost |
|---|---|---|---|---|
| geometry | 6/5 | 1/5 | 1/1 | 1/5 |
| chance | 5/4 | 1/4 | 1/1 | 1/4 |
| algebra | 6/5 | 1/5 | 1/1 | 1/5 |
| physics | 4/3 | 1/3 | 1/1 | 1/3 |
| qcd | 4/3 | 1/3 | 1/1 | 1/3 |
| health | 3/2 | 1/2 | 1/1 | 1/2 |
| finance | 3/2 | 1/2 | 1/1 | 1/2 |
| cs | 6/5 | 1/5 | 1/1 | 1/5 |
| fluids | 4/3 | 1/3 | 1/1 | 1/3 |

**This table cannot fail, and saying so is the point.** The served catalogue carries `entropy_bare`
and `entropy_resolved` nine times each — but the **pinned spine the server reads carries neither**,
only `entropy_delta` and `qfot_cost`. **The server derives the other two**, as 1 + ΔH and 1/1. So
H_bare − ΔH = H_res = 1/1 is an identity over derived values — always green for any input
whatsoever. Every H_bare in the table above is exactly 1 + its own ΔH, which is what a tautology
looks like in a table. The same applies to cost = ΔH: a mismatch detector returns zero mismatches
because the two fields are the same string in the same source object.

By this repository's own standard — **an instrument must discriminate; always-green and always-red
are the same defect** — the previous draft's phrase *"one identity holds with zero residual"* claimed
evidential weight the check cannot carry. **It is stated here as a definition.** H_res = 1/1 is the
*definition* of a resolved court: every domain resolves to exactly one law. What would make it an
invariant is a second, independent derivation of H_bare — from the retired equation's own term count
rather than from ΔH — so the subtraction can go red. That is listed in §12.

### 5.3 The composition arithmetic, in full (SHIPPED, over nine authored constants)

Ledger delta over the priced set P:

    ΔH(P) = 1/5 + 1/4 + 1/5 + 1/3 + 1/3 + 1/2 + 1/2 + 1/5 + 1/3

Reduce to L = lcm(5,4,5,3,3,2,2,5,3) = 60. The nine numerators over 60 are 12, 15, 12, 20, 20, 30,
30, 12, 20, summing to 171:

    ΔH(P) = 171/60 = 57/20        (exact; 2.85 is a rendering, never the value)
    Σ H_bare = 9 + 57/20 = 237/20 = 711/60
    Σ H_res  = 9/1 = 540/60

    ΔH / Σ H_bare      = 171/711 = 19/79      (structural entropy removed)
    Σ H_res / Σ H_bare = 540/711 = 60/79      (structure surviving as law)
    19/79 + 60/79 = 1

**19/79 is the single auditable flourishing scalar for the ledger as it stands — over 9 of 48
domains, and over nine authored constants.** One exact rational. Nine cells re-derive it from the
same served bytes because every step is integer.

**Both qualifiers are part of the quantity, not caveats attached to it, and the second one was
missing from the previous draft.** §5.2 establishes that H_bare is derived as 1 + ΔH, and §5.5
states that the nine ΔH are authored with no served derivation rule. **19/79 is therefore a function
of nine authored constants and nothing else.** By this document's own rule that the denominator
travels with the value, **"authored" travels with 19/79 wherever it appears** — including here,
including §5.4, and including any slide that quotes it. The composition is exact and auditable; what
is composed is authored. Those are different properties and both are stated.

### 5.4 The five composition rules

1. **Additive only over distinct laws.** ΔH sums across domains because each retires one equation
   and installs one law. It does **not** sum over the 88 role edges (they are read paths; pricing
   them counts one law once per reader) and it does **not** sum over ingests. Two domains sharing a
   law must be merged before either is priced.
2. **The denominator is part of the value.** Every figure is a triple: numerator, denominator,
   priced-domain cardinality. 171/60 over 9-of-48 and 171/60 over 48-of-48 are different quantities.
3. **Replay is the entire audit.** Fetch the catalogue, parse each triple as an integer pair, check
   the per-domain relation, take the lcm, sum the numerators, compare to the sealed total. No
   tolerance to choose, no reference implementation to trust, no version to pin. This is the
   zero-tolerance side of the MathWorks sentence quoted in §4.1.
4. **The invoice is the flourishing statement.** Cost equals ΔH on all nine, so the debit face
   charges **exactly the authored ΔH**. The previous draft wrote that it charges *"exactly the
   structural entropy the domain removes"*, which presupposes a removal that has not been measured —
   the constant is authored, not derived from the retired equation's term count, so what is charged
   is a published price and not a measured quantity. Billing ledger and flourishing ledger are the
   same integers, sealed once. In all three incumbent markets the bill and the credibility evidence
   are separate artifacts assembled by different people.
5. **Append-only, so a window sum is stable.** A correction labels a row rather than removing it,
   and the runtime path that could once disarm the append-only triggers is closed and gated — the
   gate carries nine arms of which five are controls, and it passes at the current head. ΔH over any
   past window is re-derivable later from rows that cannot have been removed.

### 5.5 The one place this is not exact, stated before anyone else finds it

Composition and replay are exact. **The nine ΔH constants are authored.**

No derivation rule for them is served, and none is derivable from the ingest counts — geometry has
three ingest fields at 1/5, chance has one at 1/4, so the counts do not produce the denominators.
Two of the nine carry their counting argument inside the new law itself: geometry's Ehrhart form has
a factorial denominator, which is a counting fact, and chance's Wₙ = (3/4)ⁿ has denominator 4ⁿ. The
remaining seven do not.

**An authored constant is legitimate as a published price. It is not a measurement, and this
document does not present it as one.** The assignment becomes falsifiable when each court publishes
the counting argument that produces its denominator. Named open item, §11.

**Maturity.** SHIPPED: the 48-domain spine, the nine priced pairs, ΔH = 171/60, 19/79 over nine
authored constants, the six faces, `no_float: true` on 48/48. CHARTERED: the counting arguments for
the seven authored constants, an independent derivation of H_bare, and the two prospective domains
in §7.6 and §9. DRAWN: nothing in this field.

---

## 6. The lives lane — lead time is the measured quantity

### 6.1 The quantity, defined exactly (SHIPPED — the definition and the Guadalupe instance)

For a site *s*, a hazard *h*, and a threshold θ **frozen and published before the test**:

> L(s, h, θ) = t_cross(s, h, θ) − t_detect(h, θ)

t_detect is the first crossing of θ anywhere upstream on the same channel; t_cross is the first
crossing at *s*. Both are integer minutes from a stated epoch. The measurand is carried as an
integer in milli-units, derived by string split on the served decimal string — never by a float
parse. **L is a difference of two integers.** There is no model in it, no fit, no counterfactual and
no population.

**Lead time is the measured quantity, and it is the only one claimed.** Lives saved, deaths
prevented and disasters averted are not derivable from a stage record and are not claimed anywhere
in this document.

### 6.2 The worked example — Guadalupe River, 4 July 2025 (SHIPPED)

Corpus: `corpus/flood-lead-time/`, four USGS NWIS series, parameter 00065, public and anonymous, no
key. **All four sha256 re-verified this session: 4 of 4 OK.** Ledger:
`reproduce/guadalupe-wave-ledger.swift`, **run this session with the working directory set to
`corpus/flood-lead-time/`** — the program resolves its inputs by bare filename and aborts from
anywhere else, so the working directory is part of the citation. A grep for float types on it
returns zero hits.

Threshold frozen at **10.000 ft** before the test. t_detect = Hunt, 07-04 03:00, at 10.100 ft.

| site | crosses θ | L | label |
|---|---|---|---|
| Kerrville | 06:00 | **180 min** | **SHIPPED** — emitted by the program |
| Comfort | 09:15 | **375 min** | **DERIVED** — independent integer parse of the same pinned bytes |
| Spring Branch | 22:45 | **1,185 min** | **DERIVED** — same |

Kerrville stood at **1.470 ft** when Hunt crossed. Peaks: Hunt 37.520 ft at 05:10; Kerrville
37.510 ft at 06:45 (**+95 min**); Comfort 35.640 ft at 11:00 (**+350**); Spring Branch 30.030 ft at
07-05 04:45 (**+1,415**).

**The label distinction is load-bearing and the previous draft dropped it in the one place a buyer
reads.** The ledger prints the Kerrville leg only. The other two legs are correct and reproducible
by anyone with the pinned bytes, and no program currently emits them. Extending the ledger to emit
all three legs and the site-minute total is a one-function change, listed in §12.

### 6.3 Rate of rise, on a common window — two defects found in our own artifact (SHIPPED)

Hunt rose from 10.100 ft at 03:00 to 29.450 ft at **04:35** — 19.350 ft in 95 minutes. (The 04:35
endpoint is stated because 95 minutes is *also* the Hunt→Kerrville peak lag, and the two 95s are
different quantities that read as one number reused.)

**The peak-rate comparison an earlier draft carried is not a comparison and its two numbers do not
appear together in this document.** The two gauges do not share a sampling window: Hunt reports every
5 minutes and Kerrville every 15. A maximum rate is monotone in the shortness of the window, so a
5-minute maximum set against a 15-minute maximum is a ratio with two denominators and no meaning.

`reproduce/rate-of-rise-common-window.swift`, run this session from `corpus/flood-lead-time/`,
computes both gauges on a **common** window:

| window | Hunt | Kerrville | ratio |
|---|---|---|---|
| 15 min | 316 milli-ft/min | 885 milli-ft/min | **2.80×** (280/100 exact) |
| 30 min | 248 milli-ft/min | 679 milli-ft/min | **2.73×** (273/100 exact) |

**The wave steepened downstream by about 2.8×**, and that finding survives — the direction was never
in doubt, because resampling Kerrville to 5 minutes could only raise its figure. What did not
survive is the magnitude.

**Two further defects in the same program, found by running it against a control and stated because
they are the shape this repository names as its own worst failure mode.**

1. **The sampling counts are a hardcoded print, not a measurement.** The program prints
   `sampling: Hunt every 5 min (343 of 344 gaps), Kerrville every 15 min (235 of 236)` as a literal
   string. **Demonstrated this session:** run from a directory with no corpus, the program printed
   that line **unchanged** while every rate printed 0 — the always-green shape. The counts are
   independently **true** (reparsed from the pinned bytes: Hunt 345 points / 344 gaps, 343 of them at
   5 minutes with one 35-minute gap; Kerrville 237 / 236, 235 at 15 minutes with one 75-minute gap),
   so the repair is to **compute and print them**, not to restate them.
2. **A gate given nothing exits 0.** The loader returns an empty array on a failed read, so with no
   corpus present the program prints zeros on every line, prints `ratio = 0/100`, and **exits 0**.
   That is the same defect as the always-green identity in §5.2, in our own artifact, in the section
   whose subject is instruments that cannot discriminate. Making a missing corpus fail loudly is
   listed in §12.

**This is the same defect class as §2, found in our own artifact, twice**, and it is why the program
now takes the window as a parameter and why the working directory now travels with every citation of
it.

### 6.4 How lead time composes into coverage

    Coverage(H) = Σ over hazards, Σ over downstream sites, of L(s, h, θ)   [site-minutes]

On this channel, one hazard, three downstream sites: 180 + 375 + 1,185 = **1,740 site-minutes**
(**DERIVED**, at a 10.000 ft threshold, over 3 sites and 1 hazard — one of its three legs is SHIPPED
and two are not, per §6.2). Change the threshold and you get a different, equally exact number,
which is precisely why the threshold is frozen in advance.

Coverage is **monotone in the mesh**: adding a site adds a term and never subtracts one. That is
what makes it a procurement quantity — after an event, a buyer can re-derive exactly what each site
contributed, integer by integer, from public bytes.

**What an earlier draft claimed here and this one does not.** It wrote that the term *"is computable
the moment the site's channel position is known"* and that *"a buyer can be told what a site adds
before it is installed."* **That is a forward claim and it is not available.** L is defined in §6.1
as a difference between two **realised** threshold crossings, and §6.9 states that this lane is not a
prediction system. Computing a site's term in advance of an event requires a propagation model this
document does not have and does not claim. **What is available prospectively is the ordering, not
the magnitude**: a site further down a channel will have a term at least as large as one above it on
the same wave, which is a statement about monotonicity and not a number. The number is available
after the event, exactly, and that is the procurement quantity being offered.

### 6.5 The topology finding, and its limit (SHIPPED)

The Hunt record shows a 35-minute gap from 04:35 (29.450 ft) to one final reading at 05:10 of
37.520 ft, and then nothing. **The record ends at its own maximum: the instrument was in the flood
it was measuring.** Node survival through the event, integer over integer: **3/4**.

This is not a criticism of that network. A gauge in a channel is exposed by design and it was doing
exactly what it was built to do. It is a statement about topology: a single instrument on a channel
stops reporting at the moment of maximum information value, and losing one node of a mesh costs one
node. **One measurement of 3/4 on one day is one measurement, not a reliability rate**, and it is
not offered as one.

**The same criticism applies to our own surface, or the argument is asymmetric.** The fleet gate
reports the wire publisher as a **single cell** holding a lease aged 42 s against a 15 s TTL, with
one running injector build on the fleet. A single publisher is a single publisher, whatever
nine-cell replication sits behind it.

### 6.6 A second channel, measured independently — Nepal/Tibet, 26 August 2026 (DERIVED, third-party quantities)

The value of this case is that the **propagation quantities were measured by others**, on a channel
with no relay, and they are the same measurand as §6.2.

**An ice-and-rock avalanche — not a glacial lake outburst flood and not earthquake-triggered**
(Petley, Landslide Blog / *Eos*; USGS). Sources place the detachment on either side of the
Nepal–Tibet border, with Petley giving 28.2765°N, 85.5194°E, effectively on it.

**The collapse geometry is contested across published accounts and is given as a range rather than
as point values.** An earlier draft printed one account's figures as settled. Measured against a
second set of published accounts of the same event, they do not agree:

| quantity | account A | account B |
|---|---|---|
| detached area | ~0.2 km² | ~620,000 m² (~0.62 km²) — about 3× |
| detachment elevation | ~5,200 m | ~5,140 m |
| vertical fall | ~1,200 m | ~3,300 m — about 2.75× |

The document names the contested-ness of the SpaceX upmass horizon and cites two outlets for it;
**the same discipline is owed here**, in a section whose stated value is that the quantities were
measured by others. What reproduces cleanly across accounts is the arrival timing, and that is what
the argument uses.

**The propagation quantities, with the channel each is taken over named.** This was the previous
draft's sharpest unmarked defect: two rows measured on two different channels sat adjacent in one
table, and a reader checking the table against itself computes ~50 m/s × 7 minutes ≈ 21 km and finds
it 3.4× short of the 72 km in the row below.

| quantity | value | channel it is taken over | source |
|---|---|---|---|
| seismic signal radiated by the collapse | equivalent **M5.2** | — | USGS, confirmed generated by the collapse |
| debris-flow front speed | **~50 m/s (180 km/h)** | the Tibet-side channel | *Eos* / The Conversation |
| seismic event → arrival at Gyirong Port | **7 minutes** | **the Tibet-side channel**, ~20 km runout | surveillance-camera timestamp |
| settlements struck along | **72 km** of reach | **the Nepal-side reach**, a different channel | Nepal NDRRMA |
| gauge rise at Galchhi | **~9 m in 30 minutes** | Nepal-side, downstream | ICIMOD via Reuters |

**The two timing rows are consistent once the channels are named:** ~50 m/s over 7 minutes is ~21 km,
which matches the reported ~20 km Tibet-side runout to Gyirong Port. The 72 km is a count of
settlements along the Nepal-side reach and is not a distance travelled in seven minutes.

**Seismic waves travel at ~6 km/s; the debris flow travelled at ~0.05 km/s. The signal outran the
water by a factor of roughly 120.** The USGS had the signal on the day; what lagged was
interpretation — it was first read as a tectonic earthquake.

Two facts that make this a topology case rather than a forecasting case, and both are reported by
others rather than by us. **Upstream monitoring stations were swept away before alerts could be
sent** — the second independent instance, on a second continent, of an instrument dying in the event
it was measuring. And **fourteen months earlier, in the same valley**, a previously unnoticed
supraglacial lake at ~5,150 m and ~36 km upstream drained suddenly (Rasuwagadhi, 8 July 2025,
attributed by Nepal's DHM and ICIMOD); the lake was **visible growing in satellite imagery between
December 2024 and June 2025, and was unmonitored**. Same channel, twice in fourteen months, with the
precursor sitting in archive data nobody was reading. **That is an argument for a fixed mesh on a
known corridor, not for better forecasting.**

**What the Chinese authorities state, given as their stated expectation and not as this document's
causal verdict on the 26 August failure.** They now monitor the residual barrier lake with
satellites, radar and drones and state they believe they can deliver **approximately 30 minutes of
warning** if it deteriorates. **That is a prospective statement about a different, now-monitored
hazard on the same channel.** An earlier draft rendered it as *"the constraint was instrumentation
and cross-border relay, not physics"* — a retrospective causal verdict on an event whose upstream
stations were destroyed, resting on prospective third-party evidence. The defensible form is the
narrower one: **the authorities' own position is that the achievable warning time on that channel is
set by instrumentation rather than by propagation physics**, and they have staffed it accordingly.
What caused the 26 August failure is not established here.

**The peer-reviewed instance of exactly this quantity** is Chamoli, Uttarakhand, 7 February 2021:
about 27 million m³ of rock and ice fell from Ronti Peak, with measured front velocities of
**~25 m/s at 15 km** and **~16 m/s at 26 km** (Shugar et al., *Science*, 2021,
doi:10.1126/science.abh4455). A subsequent study of the regional seismic network quantified the
warning potential retrospectively from the collapse's seismic signature alone: **~10 minutes at
13 km and ~14 minutes at 19.7 km** (*Earth Systems and Environment*,
doi:10.1007/s41748-023-00364-y). **That is the only peer-reviewed lead-time measurement of this
hazard class available to this document**, and it is the one the lane's argument rests on.

**A news item was headlined that early warning could have saved hundreds of lives in the 2026 Nepal
floods. That is that outlet's framing. It is recorded as such and it is not adopted.** Casualty
figures reported for these events are not reproduced here and are not an input to any quantity in
this document.

### 6.7 What the literature supports, and what it does not

**Cited for context; none of it adopted as ours.**

- **WMO and UNDRR, *Global Status of Multi-Hazard Early Warning Systems 2025*, launched at COP30 in
  Belém in November 2025**: **119 countries — 60%** — report an MHEWS, a 113% increase over ten
  years; Asia-Pacific highest at 72%, the Americas and Caribbean lowest at 51%, Small Island
  Developing States 43%. Pillar scores are **self-reported capability, not demonstrated
  performance**.
  **The denominator of that 60%:** the report's own percentage implies a denominator near 198.
  Against WMO's 193 Members, 119 is **61.7%**. The count is the robust figure; the percentage moves
  with a denominator the report does not print beside it.
- **The weakest-pillar figure is restated, because the previous draft's version is not
  corroborated.** It wrote that *"only 22% of countries report accessible, understandable and
  relevant risk information"*. The retrievable published statistic is that **risk knowledge is the
  least-reported pillar at 20%**, against **warning dissemination and communication as the most
  reported at 42%**. Those are the figures quoted here. **The 22% could not be verified against the
  report's own text**, and "reports a pillar" and "reports accessible, understandable and relevant
  risk information" are in any case different questions with different denominators. The
  20%-against-42% pair carries the same argument and is retrievable, and that argument is the
  load-bearing one: **it cuts against the intuitive "the last mile is the only gap" framing**, since
  dissemination is the *best*-reported pillar and risk knowledge the worst.
- The same report states disaster-related mortality is nearly six times lower in countries with more
  comprehensive MHEWS capabilities. **That is a between-country association, not a controlled causal
  estimate.** Those countries also differ on income, governance, building stock and health systems.
  **It licenses no statement of the form "N lives saved", and none is made.**
- **The universally cited 9:1 benefit-cost ratio is not traceable to a primary study.** The
  Anticipation Hub traced it to the Global Commission on Adaptation / WRI *Adapt Now* (2019), whose
  cited background papers can no longer be found, and thence to a 2007 statement by former WMO
  Secretary-General Michel Jarraud about the wider economic benefit of national hydrometeorological
  services at 1:7 — a different quantity. Cite it as widely quoted with contested provenance, or not
  at all.
- **"24 hours' notice reduces damage by 30%"** traces to a 1970 technical note by Harold Day on
  flood-warning benefits in one river basin. Its reviewer's explicit recommendation is not to use
  it. We do not.
- **The Hallegatte figures are corrected in full, not just reframed.** The previous draft retired
  *"USD 800 million avoids USD 3–16 billion"* as a one-time figure and restated it as an annual
  investment over five years across 80 countries — **correcting the framing while carrying the
  unverified endpoints forward**, in the one bullet list whose stated purpose is retiring figures
  whose provenance does not hold. Hallegatte (World Bank, 2012) publishes different ranges:
  investment of around **USD 1 billion per year** against total benefits of **USD 4–36 billion per
  year** — avoided asset losses USD 0.3–2bn/yr, 23,000 lives/yr valued at USD 0.7–3.5bn/yr, and
  USD 3–30bn/yr in additional economic benefits — for a **benefit–cost ratio of 4–36**. **Neither
  the USD 800m investment figure, the USD 16bn ceiling, the five-year window nor the 80-country
  scope is corroborated**, and none of them is carried forward.

**What the mesh reports against instead.** Sendai Framework Global Target G, indicators **G-3**
(people per 100,000 covered by early warning information through local governments or national
dissemination mechanisms) and **G-6** (percentage of exposed population protected through
pre-emptive evacuation following early warning). Both are counts, both are quantities a
sensing-and-relay mesh can claim to move and can re-derive.

**The global-scale gap, with the real figures and their real denominators.** An earlier draft
asserted that ITU *Facts and Figures 2025* reports 99% mobile-network coverage. **It does not.** ITU
F&F 2025 states **3G-or-higher coverage at 96%**, **4G at 93%**, **5G at 55%**, and that about
**312 million people — 4%** — have no mobile broadband coverage at all.

- **The mobile-ownership figure needs its population, and the previous draft printed it without
  one**, in the paragraph correcting ITU figures for that exact class of omission. ITU states
  **82% of individuals aged 10 years and over** own a mobile phone — the population is not "people",
  it is **10+**. ITU also publishes the distribution the argument actually turns on: **over 95% in
  high-income economies, over 90% upper-middle-income, and 53% in low-income economies.** **A
  section arguing that reach exists where sensing does not has to carry the 53%**, not the global
  mean stripped of its age floor, and it is carried here.
- **The cell-broadcast count is restated with its as-of date, its source's definition and its income
  qualifier, all three of which the previous draft dropped.** The sourced statement (WMO Bulletin
  Vol. 74(2), 2025, on ITU/GSMA material) is that **as of early 2025, around 44 countries —
  primarily high-income economies — have operational cell-broadcast systems or are in the process of
  deploying them**. The draft rendered this as 44 countries with cell broadcast *or location-based
  SMS*, with no date and no income qualifier: **location-based SMS was added to the definition with
  no source, and the income qualifier is the single most load-bearing fact for the
  coverage-versus-alerting argument the figure is used to make.** The earlier "45 implemented plus
  13 developing" double-counted the same population and no source was found for a separate 13. The
  "about 195 countries" denominator is this document's, not the source's, and is labelled as such.

Restated correctly, the argument is unchanged and better sourced: **physical reach at 3G-or-higher
covers 96% of the population; handset ownership among those aged 10 and over is 53% in low-income
economies; and the alerting mechanism is operational or deploying, primarily in high-income
economies, in around 44 countries as of early 2025.** That is a claim about **alerting**, not about
**sensing** — and it is exactly what the Guadalupe ledger shows in one basin: the data existed, it
was public, and 180 minutes separated two threshold crossings.

### 6.8 The funding line, with its definition attached

The *Early Warnings for All: Executive Action Plan 2023–2027* (WMO, UNDRR, ITU, IFRC; COP27,
November 2022) calls for **USD 3.1bn of new targeted investment**, itemised as USD 374m disaster
risk knowledge, USD 1.18bn observations and forecasting, USD 1.0bn preparedness and response,
USD 550m dissemination and communication.

**The two line items nearest a sensing-plus-relay lane are observations/forecasting plus
dissemination/communication = USD 1.73bn over five years, and that is not the same as calling them
addressable.** The previous draft wrote "directly addressable". **Addressability is asserted for an
object §9.3 states does not exist and §9.4 prices above the alternative it would displace**, and the
document's own §6.7 says the dissemination line is cell broadcast and location-based SMS — which a
sensing mesh does not provide. The honest form is the one used here: **these are the two line items
nearest the lane, and no basis is offered on which the lane addresses the dissemination
line.** What that number establishes is that a multilateral plan has costed the category and
published the breakdown, which is more than a vendor TAM offers.

**The plan describes this as "about 50 cents per person per year", and the arithmetic inside the
source does not close against the source's own stated scope.** The Executive Action Plan states its
denominator explicitly: the plan *"would cost just 50 cents per person per year for the next five
years to reach everyone on Earth with early warnings"*. Against a world population of ~8.1bn, USD
3.1bn over five years is USD 620m/yr, which is **USD 0.077 per person per year** — not USD 0.50.
**The previous draft inferred a hidden target population of about 1.24bn to make the figure work.
The source rules that out**, and inferring a denominator that rescues an arithmetic is the opposite
of this document's own rule. **The finding is an internal inconsistency in the source against its
own stated scope**, reported as such. This document uses the USD 1.73bn line-item figure and not the
per-person one.

This is a stated multilateral funding requirement with a published breakdown. **It is not a realised
market and it is not a vendor TAM**, and it is used here precisely because a commercial market-size
estimate for this category lacks all three of those properties.

### 6.9 What this lane cannot do, stated plainly

It does not establish that any outcome would have been different. That is not derivable from a stage
record, a camera timestamp or a seismogram, and it is not asserted anywhere. It is **not a
prediction system**: the quantity is lead time **after** detection. Current science cannot forecast
when a given slope will fail or when a given cell will drop its rain, and nothing here claims
otherwise.

No value-of-a-statistical-life monetisation is attempted — and US federal practice is itself in
flux, with EPA declining to monetise health benefits in its January 2026 combustion-turbine
regulatory impact analysis and CPSC withdrawing its VSL guidance effective 24 February 2026
(91 FR 8845), against an HHS schedule that is itself a **3.3× range** (USD 6.3M / 13.6M / 20.7M,
constant 2024 dollars, for 2025). **Lead time is reported in minutes and site-minutes, and stops
there.**

---

## 7. The atmosphere lane — instrument integrity

### 7.1 What a terrestrial mesh cannot do, stated first

- **It cannot measure stratospheric aerosol optical depth.** SAOD is a stratospheric column quantity
  reported at 550 nm and retrieved by satellite solar and limb occultation (SAGE III/ISS, OMPS-LP,
  aggregated in GloSSAC at 525 and 1020 nm) or by ground-based lidar. For scale, the January 2022
  Hunga eruption produced an estimated global SAOD perturbation of 0.0055 at 550 nm under the EVA_H
  model (*Atmospheric Chemistry and Physics* 25, 6353, 2025). No surface network sees that at any
  density.
- **It cannot contribute to the total column ozone record.** That measurement uses Dobson and Brewer
  spectrophotometers at four selected ultraviolet wavelengths with absolute calibration traceable to
  a world standard instrument. **Two counts in circulation for that network's size — roughly 125 GAW
  stations reporting total ozone to the World Ozone and UV Data Centre, and about 50 Dobsons
  remaining operational — are carried in this document without a house or a date**, and that is
  stated rather than hidden, because §7.5 applies exactly this rule to other people's constants.
  They are not load-bearing for any ratio here; attributing or replacing them is an open item in §11.
- **It therefore cannot adjudicate the reentry ozone question at any pod count.** **The sign of that
  effect is contested across the published positions, and the contested-ness is the finding.** No
  ecological harm is established anywhere in this document, and none is claimed.
- **It is not reference-grade for legal or regulatory enforcement.** WMO GAW Report No. 293 (2024)
  states low-cost sensors *"are not yet widely accepted for use in legal applications, in which
  measurements that are traceable to established standards are needed."* **Exactness of a seal is
  not traceability of a calibration**: exact arithmetic downstream of a sensing element confers no
  metrological traceability on that element, and claiming otherwise would be the same category error
  as pricing a rendering as a fact.

### 7.2 What it can do — density where there is none, with the limits quoted rather than paraphrased

WMO GAW Report No. 293 states the coverage gap in its own terms: of settlements reporting
reference-grade monitor data to WHO in 2023, **only 8% were in low- and middle-income countries.**

The same report states the boundary: low-cost sensors give lower trueness and precision, sensitivity
and specificity; measurement is indirect (PM inferred from light scattering); relative humidity
causes PM overestimation; temperature degrades performance; cross-sensitivities are complicated,
non-linear and poorly characterised under field conditions; sensing elements age; co-location with a
reference-grade monitor is required to derive calibration; and in clean areas R² ≥ 0.70 is difficult
to achieve. It further warns that re-calibration and replacement *"can greatly increase the
long-term operational costs of LCS networks"* — which lands directly on the ten-year cost model and
is carried there in §9.4 rather than buried.

The honest claim is **spatial and temporal density in unmonitored places, in the boundary layer, and
nothing above it.**

### 7.3 What it can do that nothing else in this market does — grade models exactly (SHIPPED)

This is the lane's product. The instrument question is: when two published numbers disagree, do they
disagree because the physics differs, or because the **denominators** differ? **The second is
decidable by exact rational arithmetic, with zero model runs and zero new measurement.**

**The worked example.** Ferreira et al. (2024) give a yield of 30 kg Al₂O₃ per 250 kg satellite —
**3/25 exactly**, so the ledger is pure counting with no float anywhere. Maloney et al. (2025) state
**more than 60,000 satellites** on a five-year life.

**Every figure below is a lower bound, because "more than 60,000" is a lower bound.** An earlier
draft carried all three as point estimates. The inequality is free to state and costs nothing:

| reading | satellites re-entering / yr | mass / yr | alumina / yr |
|---|---|---|---|
| at 260 kg (Starlink v1.5) | ≥ 12,000 | ≥ 3,120 t | **≥ 374.4 t** (exactly 1872/5) |
| at 800 kg (v2 mini) | ≥ 12,000 | ≥ 9,600 t | **≥ 1,152 t** |
| at 1,250 kg (v2 full) | ≥ 12,000 | ≥ 15,000 t | ≥ 1,800 t |

**What is decidable from this table, scoped to exactly what it covers.** At the ≥12,000/yr reentry
count and the three quoted bus masses, **the maximum alumina anywhere in the table is 1,800 t/yr**,
which is 5.6× below 10 Gg. **So at that count and those bus masses, 10 Gg/yr is reachable as mass —
it is passed between the 800 kg and 1,250 kg rows — and not reachable as alumina.** That is the
whole claim and it is scoped to the row set.

**Two corrections to how the previous draft argued this, both of which it got wrong in the
document's own signature way.**

1. **It drew an upper-bound conclusion from figures it had just declared lower bounds.**
   "Unreachable" simpliciter requires a ceiling the table does not have. The scoped form above is
   what the arithmetic supports.
2. **Its impossibility argument was computed on a row that is not the binding one.** It argued that
   10,000 t of alumina from 9,600 t of satellite would require a yield of 1.0417, above 100% — but
   the table's own largest mass row is 15,000 t/yr, where 10,000/15,000 = 0.667, comfortably below
   100%, so the >100% argument does not close against the document's own figures. The program prints
   the counterexample itself: its CHECK 4 reads 10,000 t/yr of alumina back to **83,333 t/yr of
   satellite mass and 320,512 satellites per year**. **The conclusion survives, on the fixed 3/25
   yield and the maximum table row, and that is the derivation printed above.**

**The circulating figure the ledger dissolves, derived here so a reader can see it constructed:**
10,000 t/yr ÷ 360 t/yr = **27.8×**, commonly rounded to "28×". **That is a ratio between a mass and
an alumina figure.** On one consistent unit set, alumina against alumina:

    1,152 / 360 = 16/5 = 3.20×          (Maloney at 800 kg, against Ferreira's scenario)
    374.4 / 360 = 26/25 = 1.04          (Maloney at 260 kg, against the same)

**Ferreira's 360 t/yr sits 3.85% below 374.4** (denominator 374.4), equivalently **374.4 is 4.00%
above 360** (denominator 360). Both are printed because a percentage without its denominator is the
defect this whole section is about.

**A truncating printer found in our own program, and it is not fully repaired.** The ledger once
printed `374.0` — integer division, remainder 10 discarded — under a banner reading *"EVERY LINE
ABOVE IS EXACT RATIONAL ARITHMETIC."* The exact rational was always right; the **display**
truncated, and an earlier draft carried the truncated value into a headline percentage, producing
3.9% where the exact value gives 3.85%. That line now renders 374.4 correctly. **Other lines in the
same program still truncate**, re-measured this session: `11538.0` for 3000/0.26 = 11,538.46,
`141.66` for 425/3, and — the one that matters most — **`4.80` for 360/74.88 = 125/26 = 4.8077…,
which rounds to 4.81 and is not 4.80.** **In a document whose thesis is that a rendering is never
the value, a truncating printer is not a cosmetic defect**, and a truncated ratio that the document
then quoted three times is the proof of that.

**No atmospheric model was run to find any of this.**

### 7.4 The second reading of the same paper, and the ratio the previous draft got wrong three times

The ledger contains **two** readings of Maloney's inputs, and only one produces the 3.20× result.
Both are printed by the program and both belong here.

| check | reading | alumina | against Ferreira 360 t/yr |
|---|---|---|---|
| **CHECK 6** | 60,000 on orbit / 5-yr life = **12,000 re-entering per year** | ≥ 374.4 t/yr at 260 kg; ≥ 1,152 t/yr at 800 kg | 1,152 / 360 = **16/5 = 3.20×** |
| **CHECK 3** | the circulating **12,000 / 5-yr = 2,400 per year** projection → 624 t/yr mass | **74.88 t/yr** | 360 / 74.88 = **125/26 = 4.81×** |

**The ratio between the two readings is exactly 5.00×, not 4.80×, and the previous draft printed
4.80 in three places — inside the section whose subject is misappropriated ratios.**

    374.4 / 74.88 = 5   exactly   (it is the 12,000-against-2,400 satellite-count ratio, 5:1)
    1,152 / 74.88 = 15.38×        (against the 800 kg reading)
    360   / 74.88 = 125/26 = 4.81×  (Ferreira against CHECK 3 — a different pair entirely)

**4.80 is the program's Ferreira-against-CHECK-3 line, truncated**, and it was attached to "the two
readings of Maloney" in §7.4's prose, in §10 and in §11 — one factor stated for two different pairs,
neither of which is 4.80. It is a **denominator swap**, which is the exact defect this document
exists to catch, committed by this document, three times. Corrected form: **the two readings of
Maloney differ by exactly 5×; Ferreira's 360 t/yr stands 4.81× above the CHECK 3 reading.**

**The two readings are not two readings of one scenario.** CHECK 3 assumes 2,400 satellites
re-entering per year; Ferreira's 360 t/yr scenario implies about 11,538. The comparison is between
two different constellation sizes, and the open question in §11 — what Maloney's 10 Gg/yr label
actually denotes — is what decides which reading applies.

**Presenting only CHECK 6 — the reading that supports the finding — would be cherry-picking a
program's own output, which is the defect this document exists to name.** Both are stated. The 3.20×
result is contingent on the CHECK 6 reading being the right one, and that contingency is not
resolved.

### 7.5 The caveats that travel with the finding, and do

**The arithmetic establishes what is *consistent* with the published constants. It does not
establish what the Maloney paper *says*.** Confirming the label is an open item (§11) and is not
skipped. The study's own honest-limits section carries two related items: Maloney's resolution and
bin structure are recorded as **unknown**, with an explicit instruction not to assert model defaults
from general knowledge; and Ferreira's population chain does not close from print alone
(41.7/308.9 = 0.1350 and 5.36/121.8 = 0.0440, neither equal to the stated 0.30), which the ledger
prints as `UNREPRODUCIBLE_FROM_PRINT` and excludes from its census pending the paper's dataset.

**The same trap sits inside the reentry literature itself**, which is the general point. Four
distinguishable quantities are routinely paired as interchangeable: **mass influx to the top of the
atmosphere** (pre-ablation), **injected mass** (post-ablation, 40–60% of influx depending on object
mix), **elemental aluminium**, and **alumina**. The conversion between the last two is exact and
purely stoichiometric: 101.961 / 53.9634 = **1.8894** (**DERIVED** — prose arithmetic over two
published molar masses). Schulz et al. (2026) report **1,855.5 t/yr elemental Al** in their
75,000-satellite scenario — at most **3,505.9 t/yr** Al₂O₃ if fully oxidised — and 618.6 t/yr in
their 19,400-satellite scenario, at most **1,168.8 t/yr** (both **DERIVED** by the same conversion).
**Their figures include rocket upper and core stages**, which contributed 1.32 kt of the 1.59 kt
measured 2024 influx, so a satellite-only alumina ledger and their aluminium ledger are **not the
same quantity and must never be differenced directly.**

**One denominator reconciled, since two values for it were in circulation.** ESA's *Annual Space
Environment Report* (GEN-DB-LOG-00288-OPS-SD, Issue 10.0, 1 May 2026) carries **both** figures, and
they are different quantities from the same source: **486.7 t total re-entered mass** in calendar
2025 across 1,881 objects, of which **442.8 t re-entered from LEO**.

**The denominator of that ratio has no house and this document says so.** Meteoric ablation is
carried here at **25 t/day = 9,125 t/yr**, and **that constant is unattributed and undated in this
document**. It is the denominator of every ratio in this paragraph and of Study 29's background-arm
exclusion, so **applying this document's own rule to its own load-bearing constant means printing
the gap rather than the attribution**. Sourcing it is an open item in §11. On that constant, the
ratio is **18.75×** on ESA's total and **20.61×** on the LEO subset (both **DERIVED**). Study 29 uses
the total; the ledger's CHECK 5 uses the LEO subset. Neither is wrong; **naming which one a ratio is
taken over is not optional**, and an earlier draft's "roughly 19×" was correct only because it
happened to be the total.

### 7.6 What would be sold, and how it would enter the ledger (CHARTERED — the domain does not exist)

**Stated in the conditional, because there is no such domain today.** Measured on the pinned spine:
**no domain carries a temperature, humidity or pressure field**, so the pod-class domain does not
exist. Study 30 states the same on its own face.

*If* this lane were instantiated, what would be sold is not better physics. It is **a residual
nobody can argue about, and a comparison whose re-derivation costs a fetch rather than a re-run**. A
sealed reading would be an integer in milli-units with a sealed time and a sealed site; a model's
prediction at that site and time, stated in the same exact units, would yield a residual that is
exact and replays identically wherever it is checked.

It would enter the priced ledger as a **domain**, on the same five fields as the nine. Its retired
equation would be the float-defined model-intercomparison verdict — a spread reported without its
denominators. Its new law would be the unit-normalised integer ledger with every denominator
declared. Its resolved entropy would have to be 1/1, and its ΔH is **CHARTERED, not measured**:
atmosphere is not among the nine priced domains today and contributes **0** to ΔH = 171/60 until it
passes replay.

### 7.7 The precedent, and the grammar to copy

The Montreal Protocol is the one case where "the atmosphere is measurably healing" is an established
scientific finding rather than an aspiration. Total column ozone is expected to return to 1980
values around **2066** in the Antarctic, **2045** in the Arctic and **2040** for the near-global
average between 60°N and 60°S, if current policies remain in place (WMO and UNEP, *Scientific
Assessment of Ozone Depletion: 2022*).

**Two separately-denominated quantities, and this is the correction the previous draft got exactly
backwards.**

| quantity | 2025 | comparison year | ratio |
|---|---|---|---|
| **average extent**, 7 September – 13 October | **7.23 million sq mi = 18.71 M km²** | 2006, the largest hole ever observed, average area **10.27 million sq mi = 26.60 M km²** | **29.7% smaller** |
| **single-day maximum** | **22.86 M km², on 9 September 2025** | — | — |
| rank by average extent | **fifth-smallest since 1992** | — | — |

Source: NASA and NOAA, December 2025.

**What went wrong, and it is the pairing error the paragraph claims to catch.** An earlier draft
withdrew a "~30% smaller than the 2006 maximum" figure, recomputed 22.86 M km² against a commonly
cited **29.6 M km²** single-day 2006 maximum, published **22.8%** as the corrected value, and
presented the source as having erred. **The source did not err.** NASA/NOAA take the ~30% over
**average** extent, not over single-day maxima: (26.60 − 18.71) / 26.60 = **29.7%**, like-for-like
and correct on its own basis. **The document assumed a max-to-max basis, re-derived a number the
source never claimed, and convicted the source of its own assumption** — and it never printed
18.71 M km², the quantity its own corrected ratio was missing. **The 22.8% is deleted.** Both
denominated quantities are given above and neither is differenced against the other. A single year
is not a trend in either case, because hole area responds strongly to polar stratospheric
meteorology.

**It was established by a global measurement network plus a treaty. Network first, verdict second.**
Copy its grammar for any benefit claim: UNEP's Environmental Effects Assessment Panel estimates up
to 2 million skin-cancer cases prevented each year by 2030 through implementation of the Protocol
and its amendments. **That is a modelled counterfactual projection, attributed to a named panel,
with a stated horizon.** It is never a retrospective claim of benefit already delivered by a specific
system, and neither is anything in this document.

---

## 8. The study board as the evidence base

The recipe the board enforces on itself, in the index's own words: a study must pair a forcing that
carries its own public clock and track with a public raw archive, a sealed adversary, and standing
future events for pre-registration. *"A study missing any one of them is not a shear study; it is a
correlation hunt."*

### 8.1 The count — and here the previous draft was wrong and the founder's brief was right

Measured 2026-09-01 against the copy that publishes and against the public raw endpoint:

| what | measured |
|---|---|
| published index | **22,712 bytes, 30 numbered rows, 1 through 30** |
| row 30 | **is Study 30**, with a full status line |
| Study 30 page, published | **HTTP 200, 129,041 bytes** |
| Study 29 page, published | HTTP 200, 105,830 bytes |
| the flood work | unnumbered, and self-labelled *"evidence, not a study"* |
| copy served from the apex | **15,186 bytes, 25 rows — stale, re-confirmed 2026-09-01** |
| copy tracked in the repository | 15,359 bytes, 25 rows — also stale |

**The defensible count is 30 numbered studies published**, plus one unnumbered evidence file. An
earlier draft reported 29 rows, a 404 on Study 30 and a 62,648-byte local charter, and derived a
founder decision — *"decide whether Study 30 is listed or deliberately unlisted"* — from a premise
that does not hold. **The correction ran against the founder's brief and the brief was right.**

**One reconciliation is still required before any count is published elsewhere:** the apex-served
copy and the in-tree copy both carry **25** rows against the published **30**, and the in-tree copy
is what a repository reader will find first.

### 8.2 Status tally across the 30 rows, with the counting rule stated

**The counting rule, which the previous draft used and did not state: a row carrying more than one
status marker is counted at its strongest marker.** That rule is necessary here and stating it is
not optional — **12 rows carry LAW FROZEN, of which 10 carry the compound marker "LAW FROZEN + LIVE
CLAIM"**, and only two rows are LIVE CLAIM alone. The draft's header, "one status per row", is
**false on the source**: it silently dropped ten LIVE CLAIM markers to make the column sum to 30.
Every other figure reproduces exactly.

| status | rows | note |
|---|---|---|
| LAW FROZEN | 12 | **10 of these also carry LIVE CLAIM** and are counted here |
| OPEN | 6 | |
| LIVE ON GLAMA | 4 | |
| LIVE CLAIM (alone) | 2 | 10 further rows carry it as a secondary marker |
| DATA SEALED | 1 | |
| PARTIAL_CORPUS_SEAL | 1 | |
| ACT 1 SEALED | 1 | |
| CITED | 1 | |
| CHARTER WITH ARCHIVE | 1 | |
| STANDING CHARTER, NO RUNNABLE CORPUS | 1 | |
| **total** | **30** | one row counted once, at its strongest marker |

**A tally that does not sum to its own population is not a tally**, and a tally that sums only
because it silently discarded markers is not one either. An earlier draft's version summed to 41
assignments over a stated 29 rows; its successor summed to 30 by dropping ten markers; this one sums
to 30 under a stated rule and prints the markers it subsumes. Studies 22–25 are live on a public tool
surface with named tools and printed exact verdicts (−1/1, −1, WIN, permanent 6).

### 8.3 The six open studies, with archive status separated rather than flattened

Archive availability measured 2026-08-27 except where noted:

- **Study 03** — GOES X-ray served anonymously; **Stanford SID endpoints absent** (empty index, dead
  host). That leg needs a replacement source before it can run.
- **Study 05** — NMDB served (anonymous ASCII lane, 1-minute resolution, data two days fresh);
  ingest unblocked.
- **Study 26** — GDC open API anonymous; LINCS via GEO GSE92742, with the key-gated route bypassed.
  Charter only.
- **Study 27** — EXFOR x4get API and AME2020, both anonymous; configuration corpus not yet ingested.
- **Study 29** — charter frozen 2026-08-31; archives measured served on both sides, response corpus
  not ingested, gate not run.
- **Study 30** — charter frozen 2026-08-31; no pod built, no tier run.

**Study 08 is not "open"; it is STANDING CHARTER, NO RUNNABLE CORPUS.** Measured: the ESA archive
serves the mean-RV row but epoch RVs are absent (zero rows in both epoch tables) and DR4 is
unpublished. Nothing can ingest until **Gaia DR4, announced for 2026-12-02**. **Study 28** is ACT 1
SEALED: its gate went green 2026-08-27 with 17 flips sealed at the 611/20 survivability line on a
pinned 2025 Gulf slice, S2 23,620/23,741, zero far-field breaches; Act 2 is gated on a 2026 access
set.

### 8.4 Study 29's adversary set, as the quality exemplar

- Frozen exact rational separator **Al/Fe > 1/10**, with niobium and hafnium as presence tests
  having no meteoric counterpart. Chosen because it **discriminates**: Murphy et al. (*PNAS*
  120(43), e2313374120, 2023) state that Mg/Fe returns the same answer under both hypotheses, so
  Mg/Fe is explicitly rejected as a separator.
- A background arm carried and excluded **on shape, not on size**: meteoric ablation is roughly
  **18.75× larger by mass** (the unattributed 9,125 t/yr constant of §7.5 against ESA's 486.7 t total
  catalogued re-entered mass in calendar 2025 — denominator named, and the numerator's missing
  attribution named with it), and it is excluded because it announces no individual events and so
  cannot be pre-registered.
- A second sealed arm — the 2019/20 Australian New Year's fires — chosen as the sharper mechanism
  twin, because its published mechanism is aerosol-surface chlorine activation absent
  polar-stratospheric-cloud temperatures.
- A pre-committed admission rule: the ledger must state, **before scoring**, whether it counts dry
  mass at reentry epoch or ablated mass. That requirement is derived from a measured contradiction —
  Murphy et al. give reentry exceeding meteoric by 10.5×, Ferreira et al. give 0.30×, the two ratios
  differ by about 35×, and **both are correct**, because one compares ablated to ablated and the
  other top-of-atmosphere to top-of-atmosphere.
- The absolute-arrival leg is deliberately **not graded**, and the page says so on its face, because
  published settling times span months to two years (Maloney, EGU25-3866), about four years (Dhomse
  2013 via Schneider et al. 2021) and up to 30 years (Ferreira 2024) — **a window spanning the
  field's own extremes discriminates nothing.**
- Its verdict class is stated repeatedly on the page: **about the instrument, never about the
  atmosphere.**

---

## 9. What is chartered but not run, and what is drawn but not built

### 9.1 Study 30 grades itself one of four, and that self-grade is the asset (CHARTERED)

Study 30, the sovereign edge pod charter, frozen 2026-08-31, opens: *"OPEN — hardware and protocol
validation charter; no pod built, no tier run."* It then grades itself against the index's own
four-piece recipe and scores **one of four**:

| piece | verdict, in the page's own words |
|---|---|
| forcing with a public clock and track | ✗ — local proper time is intrinsic, not a public ephemeris announced before the response is examined, and no ground track is named |
| public raw response archive | ✗ — *"no pod exists, so no archive exists"* |
| sealed adversary | ✓ — its null is that the transport advantage is an encoding artifact any protocol engineer reproduces by swapping verbose JSON for a tight binary schema |
| standing future events for pre-registration | ✗ |

*"This page is not a shear study. It carries one of the index's four pieces and names the three it
lacks."* A business case that presents Study 30 as a shear study is contradicted by its own source
page, and this one does not.

The page separates its own maturities in its second paragraph: the **geometry** is running code with
a cited implementation site — the wrapped lattice with an explicit winding number, verified present
this session, and the unimodular bijection the evolution law rests on — while the **hardware** *"is a
drawing. Every hardware number on this page is a datasheet figure or a distributor price at a stated
quantity break, never a measurement of a built object."*

**The geometry claim is stated at its true size rather than inflated.** The wire block emits a
winding for **three spatial axes only**; five further record components are emitted unwrapped. A
three-axis spatial quotient map ships; the eight-axis map is the design. The repair that shipped is
nonetheless load-bearing: the pre-change code pinned anything with |value| ≥ 4 to a single ceiling
cell, so every fact past ±4 routed to the same sector as every other — distinct facts collapsed onto
one cell, and a centralised store wearing a lattice's name. **Wrapping is not a wider clamp**; it is
a different operation, total and injective inside one period.

### 9.2 The four validation tiers, at the runnability the source states (CHARTERED)

T1 thermal soak, T2 zero-heap ingest, T3 message-bus leaf asymmetry, T4 asynchronous replay — each
carrying frozen integers, the exact observation that fails it, and a control arm proving the detector
fires.

**Study 30's own frozen text, quoted rather than paraphrased:** *"T2 and T4 are runnable against a
built pod. T3 is runnable on three of its four arms"* — *"T1 is not runnable"*: its cell charge
ceiling pins only when a cell is named by manufacturer and part number, and its enclosure ΔK
criterion pins only at build stage.

**The 3/4 does not close from what the page names, and that is reported rather than smoothed over.**
The page names **two** T3 arms that run — inbound-frame and 42-byte-length — and **one** that waits,
its subject-equality arm, on an allow-list the page does not freeze. Two running plus one waiting is
three arms named against a four-arm tier, and **the third runnable arm is never named**, so a reader
cannot reproduce the source's own "three of four". The source's figure is quoted as the source's;
the arithmetic gap is an open item in §11.

An earlier draft wrote *"T2, T3 and T4 are runnable"*, **promoting a partially-runnable tier to
runnable** above its own source. Corrected.

**And the harvester bound is resolved, not live.** An earlier draft presented the BQ25570's 510 mW
rated peak input (TI SLUSBH2G) against a drafted 1–2 W panel as a live **2.0–3.9× overrun** blocking
T1. **Study 30 states the opposite status:** *"The harvester bound that would otherwise have blocked
T1 is resolved here by specification"* — the PMIC input pinned at 510 mW against a **~400 mW nominal
panel, 481 mW worst case at −20 °C.** T1's non-runnability is due **only** to the unpinned cell
charge ceiling and enclosure ΔK.

**The finding that survives, and it is the argument for having a charter at all:** a specification
conflict was caught **at charter cost rather than at fabrication cost**, and resolved before a board
was made. Quoting the pre-resolution overrun as the current state understates the charter by
describing its success as a failure.

### 9.3 The pod, A.E.P-1 (DRAWN)

**No pod exists.** Every figure below is a datasheet value, a distributor price at a stated quantity
break read in August 2026, or arithmetic over those:

- ESP32-C6 + SX1262, **42-byte wire frame** (16 B delta + 26 B header); N = 65,536 fixed by the
  int16 axis width
- **287.744 ms** airtime at SF9/BW125, **58 symbols** — **this figure is computed exactly by a public
  program re-run this session**, so the airtime is arithmetic; the radio it would run on is the
  drawing
- **125 tx/hr** regulatory duty ceiling in the **EU 868.0–868.6 MHz sub-band, band g1**, against a
  36-second hourly airtime budget; **60 tx/hr binding**, because the frozen 60-second ingest period
  binds before the duty ceiling. **The duty-cycle count floors; it never rounds.**
- built cost USD 22–30 at the 1,000-unit break; silicon floor USD 12.43–13.40 with distributors
  named per line
- enclosure, power chain and bill of materials: all drawn

**The transport comparison, with the frame it is actually taken over named (DERIVED over the
program's own printed table).** The program prints ratios against the raw 16-byte and 32-byte deltas
rather than against the 42-byte frame the pod would send. On the **operational 42-byte frame**
against the 201-byte float JSON frame the comparison exists to displace: **airtime 3.49×** (1,004.544
ms against 287.744 ms) and **tx/hr 3.57×** (125 against 35). Those are the numbers a buyer should be
quoted, and they are smaller than the 6.09×/6.23× the program prints for the raw 16-byte delta,
because the header is real and the raw delta is not a frame. Extending the program to print the
operational ratios is listed in §12.

**The energy budget, both operating points, from one public program (SHIPPED arithmetic over a
DRAWN object).** `reproduce/pod-energy-budget.swift` prints both by construction — it does **not**
hardcode the ceiling, and any statement that it does is wrong:

| operating point | exact hourly budget | against a 60 W terminal-class hour (216,000 J) |
|---|---|---|
| **60 tx/hr — binding** | **3,240,490 µJ/hour** (3.240 J) | **66,656 : 1** |
| 125 tx/hr — regulatory ceiling, never reached at a 60 s cadence | **6,660,932 µJ/hour** (6.660 J) | **32,427 : 1** |

Both ratios are **exact integer division** of 216,000,000,000 µJ by the hourly budget in µJ.
**The 60 W terminal figure is a class figure attributed to no vendor**, and it is the denominator of
both ratios, so it is named as unattributed here rather than left to be discovered. Earlier figures
of 66,657 and 32,430 are superseded. Component terms: **42.7 mJ per transmission** and **9.9 mJ per
wake** at both operating points. A genuinely silent hour — the quiet floor, not the sleep remainder
inside a transmitting hour — is **83.1 mJ**; the sleep term at the ceiling is **82,184 µJ**, and
those are different quantities. On a commercial dev board measured at 72 µA of leakage rather than
the datasheet 7 µA, the binding rate becomes 4.008 J/hour and the silent hour 855.3 mJ, which is the
sensitivity a buyer should be shown.

### 9.4 No cost advantage is claimed, and here is the arithmetic (SHIPPED, with one derived split)

Charged symmetrically at 1:100 aggregation on identical uplinks, over 10,000 sites and 10 years:

| leg | orbital, 1:100, US Standard + MAX | A.E.P-1 mesh, 10,000 pods at BOM $25 |
|---|---|---|
| site hardware | — | 10,000 × $25 = **$250,000** |
| aggregation hardware | 100 terminal kits × $349 = **$34,900** (DERIVED) | 100 gateways × $150 = **$15,000** (printed) |
| uplink, 120 months | 100 × $130 × 120 = **$1,560,000** (DERIVED) | 100 × $130 × 120 = **$1,560,000** (printed) |
| **10-year total** | **$1,594,900** (printed) | **$1,825,000** (printed) |

At BOM $30 the mesh total is **$1,875,000**.

**Which of those figures the program actually prints, because the previous draft claimed all of
them.** It wrote that the program prints the table *"with the legs shown, so the symmetry claim can
be checked against the totals"* — in a section headed SHIPPED. **That is false for the orbital
column.** The aggregated orbital row prints **one total**, $1,594,900. Only the pod row prints its
legs. The $34,900 terminal-kit and $1,560,000 uplink split is **this document's arithmetic over the
program's own published constants** (100 terminals, $349 kit, $130/month, 120 months) and is labelled
DERIVED above. Extending the program to print the orbital legs is listed in §12; until it does, the
symmetry claim is checkable by reading two constants in a public source file rather than by reading
two printed lines.

**The uplinks are identical — $1,560,000 on both sides — so the symmetry claim holds.** The entire
aggregation-hardware difference is $19,900, and the pod side then adds $250,000 of site hardware the
orbital side does not have. **The pod mesh is the more expensive option on this comparison, and the
public ledger prints it that way.** On the lower-tariff column the gap is far wider still: the same
program prints the Kenya Mini + 50 GB aggregation at **$125,280** against the mesh's $1,825,000.
**The refusal to claim a cost advantage is not modesty; it is what the arithmetic says.**

It also does not yet carry the WMO GAW re-calibration and replacement term from §7.2, which would
push the pod side further up. **The case for the mesh is topology and coverage in places with no
monitoring, not price.**

### 9.5 The Z⁸ → E8 question, open (SHIPPED arithmetic, open decision)

By direct integer enumeration, re-run this session: kissing number **16** for Z⁸ against **240** for
E8. Both are unimodular, so at the same covolume the density ratio is exactly (√2)⁸ = 2⁴ = **16**.
E8 is the densest packing in ℝ⁸ among all packings (Viazovska, *Annals of Mathematics* 185 (2017)
991–1015) and is a free ℤ[ω]-module of rank 4. The substrate uses Z⁸. **Whether to move is an open
architectural question, not a defect and not a roadmap commitment.**

---

## 10. What a hostile diligence finds, answered directly

Each item is a real finding. The correction follows the finding, and the corrected form is what
appears elsewhere in this document.

**Three markers, and the counts are stated because a marker whose population does not match its
count is the defect §8.2 convicts.**

- **⇄ — a correction that reversed a previous draft's claim in the founder's brief's favour. Three
  items: 10.7, 10.9, 10.11.** The previous draft claimed four and marked five, and one of the five
  it marked (10.5) is not a reversal in the brief's favour at all — it corrects an overstatement
  *downward*, against the brief. That marker is removed from it with the reason stated, and 10.10 —
  a self-correction of the draft's own tally with no brief claim at stake — likewise.
- **⟲ — a correction applied to a previous correction.** Four items: 10.5, 10.10, 10.14 and 10.27.
- Everything unmarked is a first-order correction.

**10.1 The document committed the units error it criticises.** The SpaceX upmass conflation, §2. It
is placed at the front rather than here, because burying it would defeat the purpose.

**10.2 "Every domain carries a price" is false.** Nine of 48 are priced; 39 are not, on both the
live surface and the pinned copy. *Corrected form:* 48 domains restated retired-equation to new-law
with `no_float: true`, of which nine carry an exact-rational price — and, per §5.3, nine authored
constants.

**10.3 The per-domain identity cannot fail.** The pinned spine carries only ΔH and cost; the server
derives H_bare and H_res from ΔH. The relation is a **definition**, not a verified invariant.
*Corrected form:* §5.2.

**10.4 The nine ΔH constants are authored.** No derivation rule is served and none is derivable from
ingest counts. **Legitimate as a published price; not a measurement** — and "authored" travels with
19/79 wherever it is quoted. §5.3, §5.5, §11.

**10.5 The byte-identity claim was overstated, then mis-partitioned, then under-disclosed.** ⟲ Three
readings of one gate. First draft: all 24 identical, *"the cause is not artifact drift"* — refuted
by the gate's own DIVERGENT row. Second draft: 15 identical, "4 in absence, 4 retired, 1 divergent"
— arithmetically 15+4+4+1 = 24 but **the partition is wrong**; there are **8 absences of which 4 are
declared retired**. This draft: 15 / 8 (4 retired) / 1, **plus the two disclosures the second draft
owed** — the producing run recorded `control_arm_injection: "none"`, and its stated cause for the
withheld verdict (a named uncovered executable) is **not in the artifact it cited**. *Corrected
form:* §3.4. **This item carries no ⇄**: every correction in it runs against the claim, not for it.

**10.6 The served client artifact now equals the committed one, and it did not on 2026-08-31.**
Measured 2026-09-01, per cell: nine cells serve 12,347,843 bytes, `131db69bd8ef2293`, and the
artifact committed at HEAD is the same bytes and the same digest. The previous draft's
`WASM_NOT_BUILT_FROM_HEAD` is superseded by a commit. **The method note survives the repair:** that
draft identified a third object *by byte count alone*, having printed no digest for it, in a document
whose thesis is that a mismatch shown on one attribute is not an identification. `CLIENT_FRAME_PARITY_GATE_OPEN`
**remains open**, last run 2026-08-31 and not re-run this session; its control arm did not fire, so
it refuses to certify. *Corrected form:* §3.4.

**10.7 The apex was reported degraded, and it does not reproduce.** ⇄ The watchdog returns
`AFFINE_APEX_FULLY_LIVE`, 9 healthy 0 broken, no cell above 3× on either probe. A single latency
sample was written as a standing state in three places including a named open question. The genuine
unresolved observation is on **nbg-03**, dated 2026-08-03, and the draft attributed it to **nbg-00**.
*Corrected form:* §3.3.

**10.8 The TLS single point of failure — the previous draft's highest-severity item — was renewed
between the two measurements, and this is why a measurement instant is not a date.** Measured
**2026-09-01T12:17Z**, per cell across all nine: `notAfter` = **2026-11-30T10:11:13Z**, issuer
**Let's Encrypt YE1**, **identical on all nine**. The previous draft measured, on 2026-08-31,
`notAfter` = 2026-10-17T19:22:43Z from **Let's Encrypt YR2**, and reported "46 days 19 hours". **That
figure was producible only inside the last ~37 minutes of that day UTC** — at 2026-09-01T00:28:36Z
the same certificate read 46 d 18 h. On the document's highest-severity operational item, **the
measurement instant, not the date, is the denominator**, and it now travels with the figure.

**What is fixed and what is not.** The certificate was renewed; at the instant measured above,
**89 days 21 hours remain** (flooring). **The correlated structure is unchanged**: all nine cells
still expire at the same instant, so a lapse would still take down every endpoint this document
cites simultaneously. **Whether the renewal was automated or manual is not determinable from
outside**, and it is not asserted either way — it is carried as an open question in §11 and as a
founder decision, because "it renewed once" and "it renews" are different claims and only the first
was measured.

**10.9 The study count was corrected in the wrong direction.** ⇄ The published index carries **30**
numbered rows and Study 30 is published at 129,041 bytes. The founder's figure of 30 was right and
the draft's "29" was wrong. What is genuinely stale is the **apex-served and in-tree copies at 25
rows**, re-confirmed 2026-09-01. *Corrected form:* §8.1.

**10.10 The status tally was fixed by discarding markers.** ⟲ The first draft's tally summed to 41
over a stated 29 rows. Its successor summed to 30 under the header "one status per row" — which is
**false on the source**: 10 of the 12 LAW FROZEN rows also carry LIVE CLAIM, and dropping those ten
markers is what made the column close. This draft states the counting rule (**a dual-marked row is
counted at its strongest marker**) and prints the markers it subsumes. *Corrected form:* §8.2.
**This item carries no ⇄**: it is a self-correction of the document's own tally, not a reversal of a
claim about the brief.

**10.11 The pod energy correction was itself the error.** ⇄ `pod-energy-budget.swift` prints
**both** operating points by construction; the binding 60 tx/hr figure of 3,240,490 µJ/hour is
emitted by public code, and following the draft's instruction would have made the document quote the
non-binding ceiling as its headline. *Corrected form:* §9.3.

**10.12 Five capabilities serve nothing, and the phrase "declared debt" is wrong in both
directions.** 54 catalogued, **49 servable, 5 absent** — never "54 capabilities". All five carry
`ui_absence_declared: **false**` and an empty `ui_absent_reason`, so the absence is *not* declared in
the fields built for it; and all five carry `primitive: "ABSENT"` with the cause written in prose in
the description. Only **13 of 54** carry a REST route. *Corrected form:* §3.1.

**10.13 A truncating printer under an "exact" banner, and it is not fully repaired.** The alumina
ledger once printed 374.0 for 1872/5 = 374.4 and the draft carried the truncation into a headline
percentage. That line now renders correctly; **`11538.0`, `141.66` and — the consequential one —
`4.80` for 125/26 = 4.81 still truncate**, re-measured this session. *Corrected form:* §7.3.

**10.14 The two-readings ratio is 5.00×, not 4.80×, and 4.80 belongs to a different pair.** ⟲ The
first draft quoted only the reading that supported the finding. Its successor added the second
reading — and attached to it a factor of **4.80** in three separate places, which is the program's
truncated **Ferreira-against-CHECK-3** line, not the ratio between the two readings. **374.4 / 74.88
= 5 exactly** (the 12,000-against-2,400 count ratio); **360 / 74.88 = 125/26 = 4.81×**. A denominator
swap, in the section about denominator swaps. *Corrected form:* §7.4.

**10.15 Two maxima over different windows were presented as a comparison.** A 5-minute maximum
against a 15-minute maximum is a ratio with two denominators. On a common window the steepening is
**2.80× at 15 minutes and 2.73× at 30**. *Corrected form:* §6.3.

**10.16 Third-party CAGRs that do not reproduce, and one this document re-derived when it should not
have.** Grand View's 31.1% is a 2026–2033 rate and does not compound from its 2025 figure;
MarketsandMarkets' space-data-centre 18.3% does not close against its own endpoints (~48.6%). **And
Fortune's 12.96% was re-derived to 12.88% off the wrong base year** — off Fortune's own 2026 base of
1.44bn the series compounds at 12.93%, and the house's stated 12.96% is what this document now
quotes. *Corrected form:* §4.1, §4.2.

**10.17 A market figure of a different definition, listed as if it were the same.** QED-C's USD
1.9bn is the whole quantum technology industry; its computing line is USD 1.4bn. *Corrected form:*
§4.3.

**10.18 A "same year" spread computed across two years, and then a same-year figure omitted from the
fix.** 3.2× spanned BCC 2025 against TBRC 2026. The corrected within-2025 spread quoted BCC 1.6 to
M&M 3.52 = 2.2×, **omitting TBRC's own 2025 figure of USD 3.62bn** — higher than M&M's, from a house
the document already cites, in the one comparison whose validity rests on holding the year fixed.
Corrected: **2.26×–2.59× in 2025, 2.7× in 2026.** *Corrected form:* §4.3.

**10.19 A cited fidelity pair that was inverted, and was never a pair.** The 99.921% figure is
Sandia-verified in peer-reviewed work; the 99.7% traces to one secondary outlet's rounding. Example
deleted. *Corrected form:* §4.3.

**10.20 ITU figures corrected, then corrected again for their own denominators.** 3G-or-higher is
**96%**, 4G 93%, 5G 55%, with ~312 million people uncovered — not 99%. The ownership figure is **82%
of individuals aged 10 and over**, not "four in five people", and the distribution that the argument
turns on is **53% in low-income economies**. The cell-broadcast count is **around 44 as of early
2025, primarily high-income economies, cell broadcast** — location-based SMS was added to the
definition with no source. *Corrected form:* §6.7.

**10.21 A publication date.** The WMO/UNDRR MHEWS 2025 status report launched at COP30 in **Belém in
November 2025**. Its 119-country and pillar-ranking figures verify; **the "22% risk knowledge"
figure does not, and the retrievable pair is 20% least-reported against 42% most-reported.**

**10.22 Ratios whose denominators were never printed.** The MHEWS 60%, the EW4All "50 cents",
McKinsey's "20×", the 60 W terminal class figure, and the meteoric-ablation constant. Each is now
restated with its denominator, or with the fact that its denominator has no attribution.
**ABI's 78× is no longer among them:** its horizon and system boundary *are* stated by ABI, the
previous draft asserted an absence it had not measured, and the figure is placed on the axis with a
horizon column beside it. *Corrected form:* §4.2, §4.3, §6.7, §6.8, §7.5, §9.3.

**10.23 One publisher.** The fleet gate reports the wire publisher as a **single cell** holding a
lease aged 42 s against a 15 s TTL. A document whose flood section's headline finding is that a
single instrument is a single point of failure must apply the same criticism to its own surface, and
§6.5 does.

**10.24 Citation paths, and a working directory.** The corpus is at `corpus/flood-lead-time/` in the
public tree. **And the path alone is not the citation:** both flood programs resolve their inputs by
bare filename, so every flood figure reproduces only with the working directory set to that
directory. Stated with every citation now. *Corrected form:* §3.5, §6.2, §6.3.

**10.25 The repository's own measured-state notes go stale, and the instruction they carry is the
right one.** The current cell binary is `ecaf5c1d1028a8ea` and the served law wasm is
`131db69bd8ef2293`; digests recorded in prose elsewhere in the tree do not all match. The standing
instruction — **count from the tool, never from the table** — is correct and this document follows
it. Correcting those notes is listed in §12.

**10.26 Vocabulary hazards inherited from the sources.** The live catalogue and one linked page
carry field names and page titles in registers that do not belong in a public flourishing document.
This document refers to the 13 games by count, describes the debit face as requiring an account
identifier and a domain, and does not carry those names across.

**10.27 A corrected ozone figure computed on a basis its source never used.** ⟲ The first draft
wrote "about 30% smaller than the 2006 maximum" with no 2006 value. Its successor "corrected" this
to 22.8% by recomputing against a single-day 2006 maximum — **but NASA/NOAA's ~30% is over average
extent, and on that basis it is 29.7% and correct.** The document assumed a basis, re-derived a
number the source never claimed, and presented the source as having erred, while never printing
18.71 M km², the quantity its own ratio was missing. **The 22.8% is deleted.** *Corrected form:*
§7.7.

**10.28 Our own float gate reports zero while 24 float sites live inside the paths it scopes.** The
ratchet is sound *as a ratchet* and its summary line overclaims: its regex does not match `[Double]`,
`<Double>`, `Float32` or a bare colon-`Float`, and one of its six scoped paths does not exist, whose
absence is indistinguishable from cleanliness. **A green gate is not an absence.** *Corrected form:*
§3.6 — and it is the paragraph this document most needs, because §4 convicts four vendors of exactly
this class of undisclosed instrument limit.

---

## 11. Open questions, unanswered

1. **The nine ΔH constants are authored.** No derivation rule is present in the served catalogue and
   none is derivable from ingest counts. Two of nine carry their counting argument inside the new
   law; seven do not. Until each court publishes the counting argument that produces its
   denominator, the assignment is not falsifiable. **An authored constant is a legitimate published
   price; it is not a measurement.**
2. **Whether the per-domain relation can be made falsifiable.** It is a definition today because the
   server derives H_bare from ΔH. An independent derivation of H_bare — from the retired equation's
   own term count — would let the subtraction go red, and would turn §5.2 from a definition into an
   instrument.
3. **Does Maloney et al. (2025) state 10 Gg/yr as satellite mass or as alumina?** The exact-rational
   ledger establishes what is consistent with the published constants, not what the paper says, and
   **this is the question that decides between the ledger's two readings, which differ by exactly
   5×** (374.4 t/yr against 74.88 t/yr). Related and also open: the paper's model resolution and bin
   structure, and Ferreira's population chain, which the ledger prints as
   `UNREPRODUCIBLE_FROM_PRINT`.
4. **Why the frame-parity gate's control arm does not fire at depth 6.** Until it does, the gate
   cannot detect a wrong frame and correctly refuses to certify one. This is now the only open gate
   under §3.4.
5. **Whether the fleet's TLS renewal is automated or manual.** All nine certificates were replaced
   between 2026-08-31 and 2026-09-01 and all nine still expire at the same instant. **"It renewed
   once" and "it renews" are different claims and only the first is measured from outside.**
6. **The 2026-08-03 nbg-03 frame-latency observation.** 6.7–8.8 s against a peer's 0.16 s at host
   load 3.28 on 14 cores; a restart does not fix it; neither process state nor CPU saturation. The
   fleet measures fully live today, which does not explain that day.
7. **Whether to move the substrate lattice from Z⁸ to E8.** 16× denser at the same covolume, 15× the
   kissing number, and the densest packing in ℝ⁸ among all packings. Architectural, not a defect.
8. **Whether EASA CM-S-014 names bit-exact reproducibility as a credibility factor.** Not
   established from the sources reviewed and not to be asserted either way. The same applies to
   DNV-RP-A204 (paywalled) and to the verbatim credibility-factor list in NASA-STD-7009A (not
   retrieved).
9. **Whether the published edition of ISO 23247-1 carries the same zero counts as the FDIS text.**
   The counts in §1 and §4.1 are measured on the FDIS (ballot 2021), a draft. The published edition
   has not been read here and the claim is scoped to the draft everywhere it appears.
10. **What Study 30's third runnable T3 arm is.** The page states three of four arms are runnable and
    names two that run and one that waits. The arithmetic does not close from what is printed.
11. **Whether any digital-twin project failure or abandonment rate exists.** None found. The Gartner
    generative-AI (30% by end 2025) and agentic-AI (over 40% by end 2027) figures are about a
    different technology and must not be borrowed for this category.
12. **What the market for exact verification is as a distinct line item.** Unpriced by every analyst
    definition surveyed, despite named and dated demand signals — DARPA QBI's November 2025 Stage B
    selections with a government V&V gate, 1.1 ExaFLOPS spent certifying 71,313 bits, an
    instrument-vendor-owned validation toolchain, and no independent claims registry.
    **Manufacturing a number for it is refused here.**
13. **Whether the pod mesh's ten-year cost model survives the re-calibration and replacement term.**
    WMO GAW Report No. 293 states this can greatly increase long-term low-cost-sensor operating
    costs; the term is not yet in the public cost matrix, and adding it moves the pod side of an
    already-unfavourable comparison further up.
14. **Whether an operator will contract against coverage and lead time** — Sendai G-3 and G-6,
    site-minutes — rather than against an outcome claim. Untested, and it is the commercial
    hypothesis this whole document rests on.
15. **Whether to price the remaining 39 domains, or to publish the ledger permanently as "9 of 48
    priced."** Both are defensible; only one can be described as a per-domain priced ledger.
16. **The provenance of three unattributed constants this document uses.** Meteoric ablation at
    25 t/day, the 60 W terminal class figure, and the GAW total-ozone station counts. None carries a
    house or a date here. The first two are denominators of published ratios, which is exactly the
    condition under which §4's own rule says a figure is not yet a number.
17. **Whether the "22% risk knowledge" MHEWS figure appears in the 2025 report's own text**, and if
    so on what definition. Could not be verified this session; the retrievable pair (20% / 42%) is
    what §6.7 quotes.

---

## 12. Repairs owed — the engineering queue behind this document

Each item below is named somewhere above. None of them is a decision; they are work, and they are
listed so a reader can see the distance between what is claimed and what is green.

1. **Deepen the frame-parity fixture until its control arm fires.** A gate that cannot detect a
   wrong frame must not certify a right one, and it correctly refuses (§3.4). This is now the only
   open gate under the document's central shipped property.
2. **Inject a control arm on every identity-gate run.** The producing run recorded
   `control_arm_injection: "none"`. By this repository's own standard an instrument must be shown to
   discriminate **on the run that produces the verdict** (§3.4).
3. **Reclassify the lease holder in the identity gate.** An ephemeral 15-second lease is not a
   durable artifact, and reporting its rotation as artifact divergence mislabels a healthy system
   (§3.4).
4. **Make the float gates match the property rather than the spelling.** The type ratchet matches
   neither `[Double]`, `<Double>`, `Float32` nor a bare colon-`Float`, and one scoped path does not
   exist. **Fix the scope and the regex, and change the summary line so it claims a ratchet rather
   than an absence** (§3.6).
5. **Make a missing corpus fail loudly.** Both flood programs return an empty array on a failed read
   and exit 0 printing zeros. A gate given nothing must not exit 0 (§6.3).
6. **Compute and print the gauge sampling counts instead of hardcoding them.** They are
   independently true and they print unchanged on an empty corpus, which is the always-green shape
   (§6.3).
7. **Derive H_bare independently** — from the retired equation's own term count rather than from ΔH
   — so the per-domain subtraction can go red and §5.2 becomes an instrument rather than a
   definition.
8. **Publish the counting argument for each of the seven authored ΔH constants** (§5.5).
9. **Extend the Guadalupe ledger to emit all three legs and the site-minute total**, so §6.4's
   procurement quantity is SHIPPED rather than two-thirds DERIVED (§6.2).
10. **Fix the alumina ledger's printer to render exact rationals** under a banner that claims
    exactness — `4.80` for 125/26, `11538.0` for 3000/0.26 and `141.66` for 425/3 all still truncate
    (§7.3, §7.4).
11. **Extend the cost matrix to print the orbital legs**, so the symmetry claim is read off printed
    lines rather than derived from constants (§9.4).
12. **Extend the airtime program to print the ratios for the operational 42-byte frame** (3.49×
    airtime, 3.57× tx/hr) rather than only for the raw 16- and 32-byte deltas (§9.3).
13. **Add the WMO GAW re-calibration and replacement term to the public cost matrix**, and republish
    the ten-year comparison with it (§7.2, §9.4).
14. **Run and report the float scan across the whole public program set**, not one row of it (§3.5).
15. **Commit the radiator normalisation as a program**, so §4.2's method claim rests on two shipped
    instances rather than one shipped and one derived.
16. **Fill or delete the five absent capabilities' `ui_absence_declared` and `ui_absent_reason`
    fields**, so the structured fields agree with the description that already states the cause
    (§3.1).
17. **Push the 30-row study index to the apex-served copy and to the in-tree copy**, both of which
    stand at 25 rows, re-confirmed 2026-09-01 (§8.1).
18. **Correct the stale digests recorded in the repository's own measured-state notes** (§10.25).

---

## Still yours — decisions that are the founder's

1. **TLS renewal: is it a mechanism or was it an event?** The certificate that was 46 days from
   expiry on 2026-08-31 was replaced, and all nine cells now carry one expiring
   **2026-11-30T10:11:13Z** — 89 days 21 hours out as measured. **What is not established is whether
   anything renews it automatically.** All nine still expire at the same instant, so the correlated
   single-point structure is unchanged and a lapse still takes down every endpoint this document
   cites at once. Either an ACME client and timer are confirmed on the fleet, or the next renewal is
   calendared with a named owner. The pressure is off; the question is not answered.
2. **The one remaining open gate under the central claim.** `WASM_NOT_BUILT_FROM_HEAD` is closed —
   nine cells serve exactly the bytes committed at HEAD. `CLIENT_FRAME_PARITY_GATE_OPEN` is not:
   its control arm does not fire at depth 6, so it cannot detect a wrong frame and refuses to
   certify a right one. Until it is green, §3.4's claim is the artifact-identity claim and not the
   source-parity claim, and the document says so in both places.
3. **Whether to price the remaining 39 domains, or to publish permanently as "9 of 48 priced."**
   Both are defensible. Only one of them can be described as a per-domain priced ledger, and the
   other is what is true today.
