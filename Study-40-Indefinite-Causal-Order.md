# Study 40 — The order was never in the data

*Computation did not invent its model of causality. It imported it from physics — Lamport built the ordering of events on the light-cone partial order of special relativity, and every vector clock and consensus protocol since descends from that one move. **This study takes that premise apart from both ends, and then runs the physics experiment itself in whole numbers.** We compute the quantum switch of two thermalising channels exactly: at every one of nine reservoir settings the switch moves energy that **neither** definite order moves, and at z = 1/2 it moves exactly **−1/18** — a fraction, with no qubit, no interferometer, no shot noise and no error bar, because nothing was sampled. A double-precision simulation of that same physics returns **exactly zero** — no effect at all — from z = 1 − 10⁻¹⁶ onward, on 7 of 22 rungs where the exact arithmetic returns a non-zero fraction on every one. Alongside it: a closed loop walked in floating point **invents curvature where the manifold is flat and erases it where the manifold is curved**, and on a compact phase coordinate there is no total order to find at all — nine origins give **nine** sequences from one unchanged set of events while the cyclic orientation over 84 triples comes back as **one** vector from every origin. This study grades the **arithmetic and the geometry**, never the physics it is placed beside.*

> [!NOTE]
> **How to read this page, because it makes a large claim and the grades are what keep it honest.** The photonic experiment in §2 is **REPORTED** — someone else's work, cited, with its own limits in its own terms. §3–§7 are **MEASURED** on this repository's machine: exact integer arithmetic, cross-checked against an independently written arbitrary-precision implementation, sealed to one digest. §1 and §8 are **ARGUMENT**. §9 says what is **NOT KNOWN**, and it is specific rather than decorative. **The test is sealed. The analogy never is.**

## 1. Where computation got its causality — ARGUMENT

**ARGUMENT** — this section is history and reading, not measurement.

In 1978 Leslie Lamport wrote *Time, Clocks, and the Ordering of Events in a Distributed System*, and it is the root of the field. Its move is explicit and it is a **physics** move: `happened-before` is defined as a **partial** order, and Lamport says plainly that this is the ordering of special relativity — the invariant structure is the light cone, and the order of two spacelike-separated events is not a fact about the events but a fact about the observer.

Then, because a system has to do something, he extends that partial order to a **total** one — and says, in the paper, that the extension is **arbitrary**: any total order consistent with the partial one will serve, different choices give different orders, and nothing in the events selects among them.

That arbitrariness is this study's subject. It was stated at the origin, and then fifty years of engineering was built on the extension rather than on the invariant. Vector clocks, Raft, Paxos, the stream sequence, the ledger offset: every one is machinery for making a fleet agree on a choice the original paper says the data does not make. **The premise underneath all of it is that a definite total order is out there to be agreed on.**

## 2. Physics has withdrawn that premise — REPORTED

In July 2026 *Physical Review Letters* published **"Anomalous Heat Flows and Quantum Otto Engine with (In)definite Causal Order"** — Qing-Feng Xue, Qi Zhang, Xu-Cai Zhuang, Yun-Jie Xia, Enrico Russo, Giulio Chiribella, Rosario Lo Franco and Zhong-Xiao Man, of Qufu Normal University, the University of Hong Kong and the University of Palermo. It realises on an optical bench the **quantum switch** of two thermalising channels — the construction of Felce and Vedral, *Quantum Refrigeration with Indefinite Causal Order*, PRL **125**, 070603 (2020).

Two thermalisation channels act on one system. Classically you must choose: A then B, or B then A. The switch refuses the choice — a control qubit is prepared in superposition and an interferometer puts the photon on both paths, so the channels act in a *superposition of orders*. On that platform the team predicted and demonstrated an **anomalous reversed flow**: the system absorbs heat from reservoirs colder than itself, and an Otto cycle built on it generates work and refrigerates at once.

**Two limits, and the study is worth less without them.** It is a *proof-of-principle* demonstration — the paper reports no efficiency or throughput figure and does not claim one. And **the second law is not bypassed:** the control qubit's coherence is itself a thermodynamic resource, and preparing and erasing it carries a cost the anomalous flow is drawn against.

What it establishes is narrower than a violation and more interesting: **causal order is not a background fact the system must be handed.** It is a degree of freedom, it is physical, and holding it in superposition does work no definite order does. The premise §1 traced from relativity into computation is exactly the one nature declines on that bench.

**REPORTED** — [Phys. Rev. Lett. (2026), DOI 10.1103/sx1m-pdhz](https://journals.aps.org/prl/abstract/10.1103/sx1m-pdhz); preprint [arXiv:2511.04028](https://arxiv.org/abs/2511.04028).

## 3. We ran their experiment. In whole numbers. — MEASURED

The switch's claim is that it does something **no definite order does**. That is a number, so we computed the number rather than believing it or approximating it.

**The algebra, written out so it is checkable by hand.** A fully thermalising qubit channel with populations `(p₀, p₁)` has Kraus operators `K_ab = √(p_a)|a⟩⟨b|`. For two such channels — `K` with populations `p`, `L` with populations `q` — the switch with control `|+⟩`, post-selected on `|+⟩`, leaves the system in

```
ρ₊  =  ¼ [ E₂(E₁(ρ)) + E₁(E₂(ρ)) + X + X† ],     X_ba = p_a q_b ρ_ba
```

The first two terms **are** the two definite orders, and for fully thermalising channels they are just each reservoir's own thermal state — which is precisely why a definite order can do nothing here. `X` is the interference term, and it is the entire content of indefinite causal order. For a diagonal input it is diagonal too, so every quantity is a ratio of integers:

```
u₀ = ( p₀ + q₀ + 2 p₀q₀r₀ ) / 4      u₁ = ( p₁ + q₁ + 2 p₁q₁r₁ ) / 4
P(+) = u₀ + u₁                        n₁ = u₁ / (u₀ + u₁)
```

**Why this is exact and not a discretisation of theirs.** A thermal population is `p₁ = z/(1+z)` with `z = e^(−βε)` the Boltzmann factor. Selecting a reservoir by its **Boltzmann factor** instead of by its temperature is a bijection onto the same physics — every rational `z` in (0,1) is a real temperature — and it makes every population an exact rational. Nothing is sampled, binned, fitted or rounded. **The state is the state, and the answer is a fraction.**

**The case with nowhere to hide: the system and both reservoirs at the same temperature.** Classically nothing whatever can happen, because a thermalising channel hands back its own thermal state and an already-thermal system is left exactly where it was.

| Boltzmann z | order 1,2 | order 2,1 | switch, exact | energy moved, exact |
|---|---|---|---|---|
| 1/2 | no change | no change | 5/18 | **−1/18** |
| 2/3 | no change | no change | 29/80 | −3/80 |
| 4/5 | no change | no change | 194/459 | −10/459 |
| 9/10 | no change | no change | 1989/4294 | −45/4294 |
| 99/100 | no change | no change | 2445399/4925449 | −4950/4925449 |
| 999/1000 | no change | no change | 2494503999/4992504499 | −499500/4992504499 |
| 9999/10⁴ | no change | no change | 2499450039999/4999250044999 | −49995000/4999250044999 |
| 99999/10⁵ | no change | no change | 2499945000399999/4999925000449999 | −4999950000/4999925000449999 |
| 999999/10⁶ | no change | no change | 2499994500003999999/4999992500004499999 | −499999500000/4999992500004499999 |

**The switch moved energy at 9 of 9 settings. A definite order moved energy at 0 of 9.** The definite-order columns are the control: they are inert at every rung, so the switch column is the only thing in the experiment doing anything.

**The other control, which the page needs more than the result.** At `z = 1` — infinite temperature, populations exactly 1/2 — the interference term cannot break a symmetry that is not there, and the switch must move **nothing**. It moves exactly **0**. Without that rung this arm would be an always-red detector and would report nothing at all.

**And the anomalous direction.** A cold system at `z = 1/100` against two hot reservoirs at `z = 99/100`: a definite order hands it the hot reservoir's own thermal state, `99/199`. The switch lands at `333267/834917` — **below both definite orders by exactly `16336650/166148483`** — with the control landing on `|+⟩` with probability exactly `2504751/3999701`.

**No shot noise. No visibility. No error bar. No post-selection statistics.** Not because the apparatus is good, but because nothing was measured — the state was carried as integers and read off. Every figure above is cross-checked against an independently written arbitrary-precision implementation and agrees exactly.

## 4. Where a double loses that physics — MEASURED

The anomaly shrinks as the temperature rises. A conventional simulation of this experiment computes it in double precision. **We asked where that stops working**, over 22 rungs from `z = 1 − 10⁻¹` to `z = 1 − 10⁻²²`:

| Boltzmann z | exact energy moved | double | verdict |
|---|---|---|---|
| 1 − 10⁻¹ | −45/4294 | −0.010479739170936198 | both see it |
| 1 − 10⁻⁵ | −4999950000/4999925000449999 | −1.0000050000291694e-06 | both see it |
| 1 − 10⁻¹⁰ | −49999999995000000000/4999999999250000000044999999999 | −1.000000082740371e-11 | both see it |
| 1 − 10⁻¹⁵ | −499999999999999500000000000000/4999999999999992500000000000004499999999999999 | −5.551115123125783e-17 | both see it |
| **1 − 10⁻¹⁶** | **−49999999999999995000000000000000/4999999999999999250000000000000044999999999999999** | **0** | **DOUBLE SAYS NO EFFECT** |
| **1 − 10⁻¹⁷** | −4999999999999999950000000000000000/… | **0** | **DOUBLE SAYS NO EFFECT** |
| … through 1 − 10⁻²² | non-zero fraction at every rung | **0** | **DOUBLE SAYS NO EFFECT** |

**Exact: a non-zero fraction on 22 of 22. Double: exactly zero on 7 of 22, first at z = 1 − 10⁻¹⁶.**

Read what that column says. The double does not report a *small* effect there, or an *uncertain* one. It reports **0** — the absence of the physics, returned as a result, with no flag and no warning. A simulation run at those temperatures concludes that indefinite causal order does nothing. **There is no temperature at which the effect stops existing. There is only a temperature at which a 64-bit float stops being able to hold it.**

## 5. A float-valued observer measures a different geometry — MEASURED

Not a blurred one. A different one, and wrong in both directions.

Two affine maps over the rationals are the projective action of integer matrices, so the group commutator `K = A·B·A⁻¹·B⁻¹` is **transport around a closed loop** — out along A, out along B, back along A, back along B — and its exact deviation from the identity is the loop's **holonomy**. A flat loop returns *exactly* to where it started. Twelve loops, six scales, flat and curved at each:

| scale | loop | exact holonomy | exact geometry | double holonomy | double geometry |
|---|---|---|---|---|---|
| **10³** | flat | **0** | **FLAT** | −1.1102230246251565e-16 | **CURVED — invented** |
| 10³ | curved | 1/1010021 | CURVED | −9.67902420101474e-07 | CURVED |
| **10⁴** | flat | **0** | **FLAT** | 2.220446049250313e-16 | **CURVED — invented** |
| 10⁴ | curved | 1/100100021 | CURVED | −9.967092262641586e-09 | CURVED |
| 10⁵ | flat | 0 | FLAT | 0 | FLAT |
| 10⁵ | curved | 1/10001000021 | CURVED | −9.996703465020573e-11 | CURVED |
| **10⁶** | flat | **0** | **FLAT** | 2.220446049250313e-16 | **CURVED — invented** |
| 10⁶ | curved | 1/1000010000021 | CURVED | −9.999778782798785e-13 | CURVED |
| 10⁷ | flat | 0 | FLAT | 0 | FLAT |
| 10⁷ | curved | 1/100000100000021 | CURVED | −1.0103029524088925e-14 | CURVED |
| **10⁸** | flat | **0** | **FLAT** | 2.220446049250313e-16 | **CURVED — invented** |
| **10⁸** | **curved** | **1/10000001000000021** | **CURVED** | **0** | **FLAT — erased** |

**Curvature invented on 4 flat loops. Curvature erased on 1 curved loop. Of 12 walked.** Read as commutation on a longer ladder: **3 of 9** exactly-commuting pairs reported as non-commuting, **3 of 9** genuinely non-commuting pairs reported as commuting.

**The failures are not monotone in the scale**, and that is the load-bearing observation rather than the counts. A monotone error is a horizon — you calibrate it, or you stay under it. This has neither property: 10⁵ and 10⁷ are clean while 10⁴, 10⁶ and 10⁸ are not, so there is **no scale you can stay under and no correction that removes it**, because whether the error appears depends on where the operands' bits fall, not on how large they are.

**Control.** The exact arm was graded against the closed form on all eighteen commutation rungs: **18 of 18** — flat on every flat one, curved on every curved one. It separates the two populations in both directions, which is exactly what the double fails to do in either.

## 6. On a compact coordinate there is no total order to find — MEASURED

A scalar-line model says an event carries a coordinate on a line and *before* is that coordinate's order. A **phase** model says the coordinate is angular. And a circle admits **no translation-invariant total order**: to get a sequence you must first choose a cut, and *the cut is not in the data.*

Nine events carrying an angular coordinate, exact fractions of one turn, listed in an arrival order deliberately not their angular order. Take each in turn as the origin:

| cut at τ = | induced sequence |
|---|---|
| 2/3 | 0 7 2 4 1 8 5 3 6 |
| 1/9 | 1 8 5 3 6 0 7 2 4 |
| 7/8 | 2 4 1 8 5 3 6 0 7 |
| 5/11 | 3 6 0 7 2 4 1 8 5 |
| 20/21 | 4 1 8 5 3 6 0 7 2 |
| 1/3 | 5 3 6 0 7 2 4 1 8 |
| 4/7 | 6 0 7 2 4 1 8 5 3 |
| 17/23 | 7 2 4 1 8 5 3 6 0 |
| 2/7 | 8 5 3 6 0 7 2 4 1 |

**Nine distinct sequences.** Nothing about the events changed between those rows — not one coordinate, not one value. Only the origin moved.

Now take, under those same nine cuts, the **cyclic orientation** of all 84 ordered triples — the ternary relation *"b lies on the arc from a to c"*: **one vector, identical under all nine origins.**

**Control.** The same nine values read as points on a **line**, re-origined by subtraction with no wraparound: **1 distinct sequence** across all nine cuts. So the nine on the circle come from **compactness**, not from the re-origining mechanism.

The sequence is an artefact of the cut. **The orientation is the fact.** A model that seals a *sequence* must first make every observer agree on an origin the data does not contain. A model that seals the *orientation* needs no such agreement, because there is nothing left to disagree about.

## 7. And the prosthesis was never holding up causality — MEASURED

Nine cells, the same 64 events, nine different arrival orders. The population is what a replica ledger looks like when large balances and small increments share one stream: 32 alternating magnitudes at 2⁵³ — the scale at which a double can no longer hold an odd neighbour — telescoping to exactly −16, plus 32 small fractions.

The exact answer is `−13494202421495/934495065504` = −14.440100241960282… on all nine. The double answers are −20.0, −16.0, −15.972222222222221, −14.44010024196028, −10.0, −7.923076923076923: **1 distinct result exactly, 6 in double**, a spread of 84% of the true value from identical input. One of the nine orders lands within a last place of the exact answer, eight do not, nothing in the protocol tells you which you got, and a node that happens to be right is indistinguishable from one that happens to be wrong.

**Control.** The same nine orders on 64 small integers, where every partial sum is exactly representable: **1 distinct result in each arithmetic.** So this arm measures rounding — not the permutation generator, not the population size.

```
ARM 1 float false positives           3 of 9
ARM 2 float false negatives           3 of 9
ARM 3 exact control                   18 of 18
ARM 4 exact distinct / float distinct 1 / 6
ARM 5 control distinct exact / float  1 / 1
ARM 6 curvature invented / erased     4 / 1 of 12 loops
ARM 7 sequences / orientations / line  9 / 1 / 1
ARM 8 switch moved / definite moved   9 / 0 of 9 settings
ARM 8 largest energy moved            -1/18 at z = 1/2
ARM 9 double lost the physics         7 of 22, first at 1 - 10^-16
TERMINAL                              ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC

sha256 = 7f14484bc973503f5de0276cf1bb37ec8c8ee422730f631b565e8ca460958570
```

**Every exact figure on this page is re-derived by a separately written arbitrary-precision implementation: 75 of 75 agree, 0 diverge.** That checker carries two control arms — a switch value at a reservoir setting the program never runs, and a fold value altered in its last digit — and both are correctly reported absent, so it is discriminating rather than merely agreeable. It is also the second time this page's own instruments were caught: the first run of that checker read a truncated excerpt of the output and reported 11 divergences that were windows it had not read, not disagreements.

**Every arm above ran in 0.13 seconds on one machine, with no fixed integer width anywhere.** The exact numbers are carried as decimal strings rather than as a native 128-bit integer, because the build host has `Int128` and the cells do not — and a law that is one type here and another type there is two laws, which is the exact defect this study is about. The strings are also why §4 reaches 10⁻²²: under a fixed width this program's own switch algebra trapped at the third rung of its ladder while every *answer* was small, and a ceiling inside an instrument that measures where floating point runs out is the same defect wearing a different width. **A control on that rewrite: swapping the integer type reproduced every earlier arm byte-for-byte.**

## 8. What this costs the scalar-time model — ARGUMENT

**ARGUMENT** — the reading. The measurements are above and graded; nothing new is counted here.

A model in which events carry a scalar coordinate on a line, and *before* is that coordinate's order, needs two things this program does not find.

**It needs a cut that is in the data.** §6 says that on a compact coordinate there is not one: nine origins, nine sequences, one unchanged set of events. Lamport said the extension was arbitrary in 1978 and the field built on the extension anyway. What §6 adds is that the arbitrariness is not a nuisance to be standardised away — it is **the signature of having modelled an angular quantity on a line.** The invariant was never the sequence. It was the orientation, and it was sitting there the whole time, identical under every origin, over every triple.

**And it needs an arithmetic whose composition is associative.** §5 says the arithmetic the world computes in is not, and §4 says what that costs when you point it at real physics: an observer computing a manifold in floating point measures curvature its arithmetic invented and misses curvature that is there, and an observer computing the anomalous heat flow in floating point concludes, from `z = 1 − 10⁻¹⁶` onward, that **there is no anomalous heat flow.** That is not a precision statement. It is a statement about which world is being measured.

Take either leg away and the sequence stops being a fact about the events. **Both legs are gone at once, and they were removed from opposite ends** — physics withdrew the definite order on an optical bench, and our own arithmetic turns out to have been the thing our total orders were repairing all along, since §7 measures a fleet disagreeing with *itself* on identical input, which is a rounding failure wearing the costume of a causality problem.

What survives both is angular. An orientation on a compact coordinate is cut-independent by construction, so a substrate that carries τ as a phase and seals the **invariant** rather than the **sequence** does not need a protocol to make nine cells agree — not because the protocol was optimised away, but because there is no longer a disagreement for it to resolve. That is what this architecture does, and §6 and §7 are the two halves of why it works: exact arithmetic so the fold is order-invariant, and an angular coordinate so there is no cut to argue about. **Every consensus round a fleet runs is a payment against one of those two, and this study measures both bills.**

And §3 is what the combination buys. The bench measures one setting, statistically, with a visibility and an error bar. The substrate returns the same physics as a fraction — nine settings and twenty-two rungs, exactly, deterministically, in a tenth of a second, identical on every machine that runs it.

## 9. What is NOT KNOWN — stated precisely, because the claim above is large

**This does not make quantum hardware unnecessary, and §3 must not be read that way.** A two-level system under two fully thermalising channels is a small enough Hilbert space to be written down in closed form, which is exactly why it *can* be computed as a fraction. Nothing here says the same holds for a system whose state space is not classically writable, and nothing here is evidence about that question either way. What §3 and §4 establish is narrower and still worth having: **for this experiment, the limit on a conventional simulation is not the physics and not the Hilbert space — it is the arithmetic**, and it fails at a place we can name.

It does **not** demonstrate indefinite causal order, reproduce the photonic apparatus, or reverse any heat flow. It computes the prediction that apparatus was built to confirm. That work is §2's, it is cited, and it belongs to the people who did it.

It does **not** single out one manifold. §6 measures that **a compact phase coordinate carries an invariant a scalar line cannot** — a statement about a *class*, shared by every compact coordinate in it. That `M⁸ = S⁴ × C⁴` in particular is the right one, or is the geometry of the universe, **is not answered here and is not claimed here.** Naming the class is the measurement; naming the member is the DISCOVER move, and the substrate returns **NOT KNOWN** on it by law rather than sampling toward an answer and dressing it as confidence.

The honest form of the strong claim is this: **the scalar-order model is not required; where it is used it carries an arbitrariness and an arithmetic error that are both measurable; and the arithmetic error is large enough to delete a real physical effect from a simulation without warning.** That is far weaker than "the universe is a torus" and far stronger than "floating point is imprecise" — and unlike either, every clause of it is a number in a table above.

## Evidence, graded

| claim | grade |
|---|---|
| The quantum switch of two thermalising channels, computed exactly: at 9 of 9 reservoir settings it moves energy that neither definite order moves (0 of 9), exactly −1/18 at z = 1/2; at z = 1 it moves exactly 0; a cold system against two hot reservoirs lands below both definite orders by exactly 16336650/166148483. | **MEASURED** — `reproduce/ico-causal-order-shear.swift`, cross-checked against an independent arbitrary-precision implementation |
| Computing that same effect in double precision returns **exactly zero** on 7 of 22 rungs, first at z = 1 − 10⁻¹⁶, where the exact arithmetic returns a non-zero fraction on all 22. | **MEASURED** — same program, ARM 9 |
| Walking the closed loop A·B·A⁻¹·B⁻¹ in double invents curvature on 4 of 6 flat loops and erases it on 1 of 6 curved loops; read as commutation, 3 of 9 each way; non-monotone in the scale in both directions; the exact arm answers the closed form 18 of 18 and separates both populations. | **MEASURED** — same program, ARMs 1–3 and 6 |
| Nine origins on a compact phase coordinate induce 9 distinct sequences from one unchanged event set while the cyclic orientation over 84 triples is 1 vector under all nine; the same values on a line give 1 sequence under all nine. | **MEASURED** — same program, ARM 7 with its line control |
| Nine cells folding one 64-event set in nine arrival orders reach 1 distinct result exactly and 6 in double, spanning 84% of the true value; on a population float holds exactly, both reach 1. | **MEASURED** — same program, ARM 4 with its ARM 5 control |
| A photonic quantum switch realises a superposition of two thermalisation orders, producing anomalous heat flow from colder reservoirs and an Otto cycle that works and refrigerates at once. Proof-of-principle; the second law is not bypassed — the control qubit's coherence is the resource. | **REPORTED** — Xue et al., PRL (2026), arXiv:2511.04028; construction from Felce & Vedral, PRL 125, 070603 (2020) |
| Computation inherited its causal order from relativity via Lamport (1978), which itself states the total extension is arbitrary; that arbitrariness is the signature of modelling an angular quantity on a line, and total-ordering protocols are substantially a prosthesis for non-associative arithmetic. | **ARGUMENT** — this study's reading of §4–§7 |
| That exact arithmetic removes the need for quantum hardware in general; that `M⁸ = S⁴ × C⁴` or any single manifold is the geometry of the universe; that the photonic result validates this architecture. | **NOT KNOWN** — refused by law, never claimed |

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/ico-causal-order-shear.swift -o /tmp/ico && /tmp/ico
```

No account, no key, no corpus, no network, and no floating point in the exact path. The float arm is the object under measurement and is confined to the functions named `float…` and `runSwitchFloat`.

**What is measured about portability, and what is not.** The exact integers are decimal-string-backed and unbounded: there is no `Int128`, no fixed-width type in the exact path, and no import beyond `Foundation`. Swapping the integer representation reproduced every earlier arm byte-for-byte, and 75 of 75 exact figures are reproduced by an independent implementation. **What has not been measured is an execution on a cell** — the Linux host available here carries no Swift toolchain, so the run above is the build host's. The claim on this page is therefore that the program has no platform-dependent arithmetic, which is checkable by reading it; not that a cell run has been observed, which would need a cell run.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can inspect it and re-derive every figure. That visibility grants no rights. The repository carries no LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a separate written licensing agreement with the authors.
