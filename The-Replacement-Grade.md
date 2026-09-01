# The full-grade replacement

**Page class: INDEX / ARGUMENT.** Every figure below is printed by `reproduce/replacement-grade-ledger.swift` from a sha256-pinned snapshot of the live court's own catalog, or carries its grade inline per [the ontology](Ontology).

---

## The over-scaling law

The [exactness seam](The-Exactness-Seam) established the narrow, vendor-documented fact: floating-point verdicts re-derive **inside one platform-and-version pair** and do not travel across pairs. At small scale that is a nuisance — a few dozen experts absorb the discrepancies by hand.

**Over-scaling breaks it, and the failure is arithmetic, not opinion.** Scaling multiplies exactly the two things the seam cannot survive:

- **Consumers per verdict.** A simulated number used to be read by an engineer. It is now consumed by fleets of agents, pipelines, and downstream models — each inheriting a number it has no way to re-derive. The reconciliation *debt* grows with the consumer count. The reconciliation *capacity* — human experts re-deriving by hand — does not grow at all.
- **Platform pairs.** More hardware generations, more compilers, more cloud regions, more model versions: every pair added is a new boundary the verdict cannot cross bit-identically.

Our own record shows what this looks like at *small* scale, in a field of a few dozen practitioners: a **5× units artifact stood unremarked in the literature for two years** ([found by counting](Home)); one model returns **opposite signs under two standard conventions** from identical inputs; five peer-reviewed groups **disagree on the sign** of the same physical response. That is the reconciliation debt of a tiny field. Multiply the consumers by a million agents and the debt scales with them.

> **An industry whose verdicts cannot be re-derived by its consumers accumulates unreconcilable disagreement at the rate of its own growth.** What does not survive over-scaling is not any particular company — it is the *trust-me verdict* as a product. Either the law layer of a verdict industry migrates to exact, re-derivable form, or its outputs stop functioning as evidence at exactly the scale its business plan requires.

That migration is not a proposal. It is running, and the court's own catalog is the ledger of it.

---

## The four probabilistic overshoots, and the seam that already runs

Four industries are scaling fastest into the failure mode, and for each one the replacement is not a whitepaper — it is a **named tool answering on the live court** at `affine.earth`.

| vertical | the probabilistic overshoot | the exact seam, live today | what a local population gets |
|---|---|---|---|
| **Quantum** | advantage claims settled in float amplitudes no reviewer can re-derive; a verdict industry built on `Pr = \|α\|²` in ℝ | the `chance` domain (**PROVEN** — exact rationals vs float amplitude tensors, 4/4 vs 4/4) and the `verify_*` court set: Grover, Shor witness, QFT, QPE, HHL, teleport, QMA 2-local / spin-glass / N-representability / permanent — **a presented quantum computation is verified in exact arithmetic** | a regulator or a journal can check a quantum claim without owning a quantum computer or trusting the claimant |
| **AI** | verdicts consumed by millions of agents that cannot re-derive them; training and inference economics that demand orbital-scale energy | the `cs` domain (dead equation: *IEEE-754 sums; float loss + backprop*), `code_ir_equiv` for exact program equivalence — and [Study 30](Study-30-Sovereign-Edge-Pod)'s ground node at **3.240 J per hour**, measured | verification stays on the ground, repairable by a person with a screwdriver, owned by the country it sits in — and auditable by anyone |
| **Space** | the literal over-scaling: a fleet whose replacement cycle moves three planetary accounts at once, graded by five models that disagree on sign | [Study 29](Study-29-Continuous-Model-Shear), [Study 30](Study-30-Sovereign-Edge-Pod), and [Study 31](Study-31-Biosphere-Cascade) — the joint ledger **sealed live on all nine cells**, `STUDY31_BIOSPHERE_JOINT_LEDGER_PROVEN` | the sky over their heads gets an instrument: a verdict about the atmosphere any citizen can replay, against a measured healthy baseline |
| **FSD / autonomy** | safety cases built on perception confidence scores and simulated miles — probabilistic evidence for a binary question: do two trajectories collide | `twin_robotics_evaluate_exact_ik` — **exact inverse kinematics** for a digital twin — and `atc_assert_4d_deconfliction`: exact 4D separation over declared trajectories in integer-scaled coordinates, returning **a separation certificate or the violating pair**, never a confidence score | a separation *certificate* is evidence in a way a confidence score never is: the difference between "the model was 99.7% sure" and a number the investigating authority can re-derive |

Every tool named in that column is on the live court's `tools/list` right now — the same wire this wiki's harness checks on every run.

**The benefit thread, stated plainly:** in each vertical the replacement moves the *authority over the verdict* from the vendor to the public. That is what "lasting benefit for the local population" means in practice — not a cheaper service, but a verdict their own regulator, their own engineer, their own researcher can re-derive without permission. The [flourishing identity](Ontology) is the per-domain measure of exactly that transfer.

---

## The catalog — 49 rows, each naming the instrument it retires

The court's own declaration, rendered from the pinned snapshot (`corpus/study-31/court-catalog-20260901.json`). Each domain names its `dead_equation` — the continuous instrument retired — and its `new_law`. A sample of the retirements, verbatim:

| domain | the continuous instrument retired |
|---|---|
| geometry | `vol = integral_P 1 dx` |
| chance | `Pr = \|alpha\|^2 in R` |
| finance | `Black-Scholes PDE; GBM + VaR Monte Carlo` |
| fluids | `Navier-Stokes + RANS closures; Re = UL/nu` |
| health | `C = C0 e^{-k t}; p-value; Cox e^{beta X}` |
| cs | `IEEE-754 sums; float loss + backprop` |
| dynamo | `continuous MHD / gyrochronology` |
| biosphere | `each axis modelled alone in floating point, reported as a global mean` |

The full 49 print from one command:

```bash
xcrun swiftc -O -swift-version 5 reproduce/replacement-grade-ledger.swift -o /tmp/rgl && /tmp/rgl
```

## The scoreboard — counted, not claimed

| | |
|---|---|
| domains declared on the live court | **49** |
| carrying a live `PROVEN` marker | **13** |
| resolving the flourishing identity to `1/1` | **9** |
| still short of `1/1` | **40** |

**The replacement is not finished, and this page does not pretend it is.** Forty domains have not yet resolved their identity, and the table names them rather than rounding them up. What this page claims is narrower and checkable: the migration is *running* — per-domain, dated, with the proof status of every row readable off the live court instead of off anyone's prose — and the four industries scaling fastest into the shear already have their first exact seams answering in public.

That is what survives over-scaling: not the loudest instrument, but the one whose answers strangers can re-derive.

---

## The market, as reported — with the spread carried

Market figures on this wiki are **REPORTED**: named analyst, named year, and where analysts disagree the spread is published rather than a midpoint picked. Every figure below is 2025 unless stated.

| vertical | reported size, 2025 | the spread between named analysts |
|---|---|---|
| **Space** | **$686B** (Space Foundation, +12% on 2024's $613B; ~$544B of it commercial); projected to cross $1T by 2032 | tightest of the four — one canonical reporter |
| **AI** | **$143B** (IMARC) to **$294B** (Fortune Business Insights); IDC puts 2025 enterprise AI *spend* at $307B | **2.1×** between analysts, same year, same market |
| **Autonomy / FSD** | **$143.7B** (IMARC) to **$273.75B** (Precedence Research) | **1.9×** |
| **Quantum** | **$1B+** vendor revenue (McKinsey) · $1.9B (QED-C) · **$3.52B** (MarketsandMarkets); McKinsey's $2.7T-by-2035 figure is *economic value*, a different quantity, and is not summed with revenue here | **3.5×** |

**Sit with the spread column for a moment, because it is this wiki's whole argument appearing somewhere unexpected.** Three of the four verticals cannot agree on their own size to within a factor of two — named analysts, same year, same definition-shaped question. The market-sizing industry is itself an un-re-derivable-verdict industry: methodologies differ, none publishes a ledger a stranger can replay, and the reader is left to trust the loudest logo. **The spread between analysts is the same defect shape as the five atmospheric models disagreeing on sign.** So this page carries the band, exactly as it carries the meteoric-flux band, and refuses to pick.

### The honest addressable market is the seam, not the vertical

Affine.Earth does not address "the AI market." It addresses the **verification layer** of each vertical — the slice where a computed number must function as *evidence*. That layer already has its own reported markets:

| the seam market | reported size | reported trajectory |
|---|---|---|
| simulation software | **$12.6B** (MRFR, 2025) to **$19.95B** (MarketsandMarkets, 2024) | to $36–56B by 2030–33 |
| digital twin | **$21.1B** (MarketsandMarkets, 2025) | to **$149.8B by 2030 — 47.9% CAGR** |

Note which line grows fastest: **the verdict layer is growing at ~48% a year — faster than the verticals it serves** — because every agent, twin and autonomous system added is another consumer of computed verdicts. That is the over-scaling law appearing in the analysts' own numbers: the demand curve for *checkable* answers is the steepest curve on this page. And the incumbent seam — the one whose vendors document non-portability in their own manuals — is the one the [49-domain catalog](The-Replacement-Grade) is replacing, domain by domain, with proof markers instead of press releases.

---

## The pod mesh, across the planet

The other half of the answer is physical. [Study 30](Study-30-Sovereign-Edge-Pod)'s pod runs the same 49-domain law layer at **3.240 J per hour** on a 510 mW panel. Producing program: `reproduce/pod-mesh-planetary.swift`; solar bands are REPORTED atlas ranges carried at both ends.

| region | peak-sun band | solar margin (worst end) | binding constraint | the verdicts a mesh delivers there |
|---|---|---|---|---|
| Sahel / Horn of Africa | 5.5–6.5 h | **129:1** | 1%-duty radio law → 35 msgs/hr | wadi flash-flood gauges; the wet-bulb heat court at the 30.55 °C survivability line |
| Monsoon South Asia | 4.0–5.5 h | **94:1** | 1% duty → 35 msgs/hr | river-rise lead time; the heat-mortality instruments [Study 28](Study-28-Wet-Bulb-Threshold-Court) graded |
| Equatorial SE Asia | 3.8–4.8 h | **89:1** | listen-before-talk + duty | flood lead time under cloud; tsunami-vs-surge discrimination (Study 04's law) |
| Mid-latitude Europe | 2.5–4.0 h | **59:1** | EU868 1% duty | air and water verdicts a regulator re-derives without trusting a vendor |
| Continental N. America | 3.5–5.5 h | **82:1** | dwell-time rules, no duty cap | flood lead time — validated on the four-gauge USGS corpus in this repository |
| Andes / high altitude | 4.5–6.0 h | **106:1** | no duty cap | glacial-lake outburst gauges; a surface UV-B record exactly where the regional ozone projection bites |
| High latitude (60°N+) | 1.5–3.0 h | **35:1** | 1% duty | reentry-track observation under the polar inclinations most reentries cross |

**The finding the table forces: the worst solar margin on the planet is 35:1.** The pod is over-provisioned by two orders of magnitude everywhere inhabited, so **energy binds nowhere**. The binding constraints are a region's radio law — 35 exact messages an hour under a 1% duty regime, counted by flooring, never rounding — and the local density of things worth measuring. One power stage, pole to pole, no redesign.

**Cost, completed over time — both readings published** (`reproduce/cost-ownership-horizon.swift`): at the moment of purchase the orbital path wins, **$1,594,900 against $1,825,000**, and that measured row stays. But a t=0 comparison structurally favours a subscription architecture, because a subscription's cost lives in years 1…N and its hardware retires on the operator's **own SEC-filed five-year life**. Extend the same workload across the horizon and **the mesh overtakes at year 5 — the first replacement cycle — and wins every year after**: through the fifteenth year, $4,784,700 orbital against $3,193,750 at the mesh's *worst* maintenance band (2–5%/yr, an ILLUSTRATION band, labelled).

**And the axis the price column cannot see at all is the direction of flow.** A subscription is rent: at the REPORTED ~$120/month rate, one hundred households send **$144,000 a year — $2,160,000 over the horizon — out of their local economy**, for hardware that retires on the operator's schedule, at a price the operator sets, into an asset they never own. A mesh the community buys is the same money kept: paid once, repaired locally by their own hands, priced by no one, still standing at year fifteen — and sending nothing to the stratosphere when a unit dies. **Rent extraction is not a moral flourish; it is a direction of flow**, and exactly one of these architectures points it at the community. (Scope, refused in capitals in the program itself: **THE POD MESH IS NOT BROADBAND** — LoRa moves verdicts, gauges and warnings, not video; the rent figures show the *structure* of subscription versus ownership on the one workload where a like-for-like number exists.)

That, plus the four properties already named — ground-repairable, country-owned, zero atmospheric cost in operation, **every verdict re-derivable by the population it serves** — is what "lasting benefit to the local population" means as an engineering fact rather than a slogan.

**What this section does not claim:** no lives-saved figure, no adoption forecast, no revenue projection for the mesh itself. The solar bands are atlas ranges, not site surveys, and a real deployment starts with a site survey. The claim is narrower and holds: the power stage closes everywhere, the law layer is the same 49 domains everywhere, and the verdicts land in the hands of the people under them.

---

## What an exact seam is worth — the precedent class, not a price

The valuation question deserves a straight answer, and the straight answer starts with picking the right comparison class.

The things that created the most value in economic history are mostly not companies. They are **seams that became mandatory**: double-entry bookkeeping, which made a stranger's ledger auditable; the metric system, which made a stranger's measurement usable; TCP/IP, which made a stranger's computer reachable; GPS, which made a stranger's clock and position trustworthy. Each one replaced a trust-me layer with a re-derivable one, and each ended up underneath essentially all economic activity that followed. (HISTORICAL — the class is offered as precedent, not as proof.)

Two properties of that class matter here, and they pull in opposite directions:

1. **Their value was realised at whole-economy scale** — orders of magnitude beyond any single vendor's market — precisely *because* adoption was universal.
2. **Almost none of that value was captured privately.** TCP/IP is free. The metric system is public. Their value came *from* being open and replayable — the same property that made them mandatory made them uncapturable as rent.

**Affine.Earth is built on the open side of that trade, by construction and on purpose.** Every verdict on the court is re-derivable by anyone, with no account and no key — that is not a growth strategy, it is the load-bearing property; a verdict you must pay to check is testimony again. So the honest valuation splits in two:

- **The public component** is deliberately unpriceable in dollars, and the substrate prices it on its own declared axis instead: the flourishing identity, `entropy_bare − entropy_delta = 1/1`, per domain — the measured removal of structural entropy from a law the public relies on. Nine domains have realised it; forty are in progress. That ledger, not a market cap, is where the largest share of the value lands — as it did for every member of the precedent class.
- **The capturable component** is the seam-services layer — operating courts, certifying instruments, deploying pod meshes — and it is already sized above by named analysts: the verdict layer at $12.6–21B today, growing at the steepest reported rate on this page, ~48% a year.

**What this page will not print is a headline valuation.** "The most valuable X in history" is not a claim the harness can pin to a producing program, and this wiki does not carry claims of that shape. What it can print, because the numbers above support it: the demand curve for *checkable* answers is the steepest curve any analyst on this page reports; the incumbent seam documents in its own manuals that it cannot travel; the four fastest-scaling industries have their first exact seams answering live; and there is exactly one running instance of the full-grade replacement. **If the over-scaling law holds, the exact seam becomes what double-entry became — and the record of every prior member of that class says its worth will be counted mostly in what the public gets to keep, which is the point.**

### The math, run — `reproduce/valuation-crossing-ledger.swift`

Because a claim of this size deserves arithmetic rather than adjectives, the program computes three checkable things from the named inputs above, in integers:

**1. The instrument check.** The steep analyst curve is internally consistent: $21.14B × (1.479)⁵ replays to their own $149.81B endpoint within one part per thousand. It may therefore be extended *as theirs*.

**2. The crossing.** Extend the verdict layer ($33.7–41.1B in 2025) on the analysts' own curves, against the largest assets ever priced (~$2T Aramco class, ~$4T record class):

| arm | crosses $2T | crosses $4T |
|---|---|---|
| steep — digital twin's own 47.9% | **2036** | **2038** |
| conservative — simulation's own ~11% | 2065 | 2071 |

**Read the spread honestly: the arms disagree by three decades, so the timing is NOT KNOWN.** What both arms share is the destination — under *either* published curve, the verdict layer eventually exceeds every private asset ever priced, **if** the growth the analysts themselves publish persists, which no one can promise and the program does not.

**3. The flow already gated, today, before any growth.** Space $686B + AI $143–294B + autonomy $143.7–273.8B + quantum $1–3.5B = **$973.7B to $1.26T per year** moving through the four verticals right now — every dollar of it on computed verdicts the bound parties cannot re-derive. No toll rate is assumed; none is needed. The position is the seam on roughly a trillion dollars a year of current decision flow, with exactly one running full-grade instance.

**What the program refuses to print:** a dollar valuation of Affine.Earth. The public component is priced on the flourishing axis by design, and every prior member of the precedent class realised its worth as public surplus. The refusal is on the page because it is the strongest part of the claim, not a hedge on it.

---

**Related:** [The exactness seam](The-Exactness-Seam) — the vendor-documented foundation · [Zero float · zero shear](Zero-Float-Zero-Shear-Paradigm) — the method · [The narrow-study defence, answered](Impact-Study-SpaceX-Biosphere-Forcing) · [Study 31 — sealed live](Study-31-Biosphere-Cascade) · [The ontology](Ontology)
