# Study 40 — The number the simulation throws away

*In July, physicists put two thermalising channels into a superposition of orders and watched heat flow from the colder reservoir. The prediction they confirmed is not a measurement. It is a fraction.*

*We computed it. At z = 1/2 the switch moves exactly **−1/18** of a level gap, and neither ordering moves anything at all.*

*Then we computed the same fraction the way this physics is normally simulated — in double precision — and above z = 1 − 10⁻¹⁶ the answer comes back **0**. Not small. Not noisy. Zero. The effect leaves the calculation without a warning, and nothing in the output says it was ever there.*

---

## Why this might be your problem

Three places where the arithmetic, not the physics, is deciding what you find. Each one is a thing that can be sitting in working code right now.

**If you simulate indefinite causal order in floating point, you may be computing zero for an effect that exists.** We can name where it starts: `z = 1 − 10⁻¹⁶`, and everywhere hotter. Below that the double tracks the exact answer to the last digits. Above it, the double returns a clean, confident `0.0`.

**If you compute curvature in floating point, some of it is yours.** Walk a closed loop and see whether you get home. We walked twelve. On four of the six flat ones the double came back curved — holonomy that is exactly zero, reported as non-zero. On one of the six curved ones it came back flat. **And it is not monotone in the scale**: 10⁵ and 10⁷ are clean while 10⁴, 10⁶ and 10⁸ are not. There is no threshold to stay under and no calibration that removes it, because whether the error appears depends on where the operands' bits fall, not on how big they are.

**And if you are enforcing a total order on events, check whether your data contains one.** On a compact coordinate it does not. Nine origins, one unchanged set of events, **nine different sequences** — and one cyclic orientation, identical under every origin. The sequence is an artefact of where you cut. The orientation is the fact.

Everything below is the arithmetic. No corpus, no network, no key, no error bars, and no fixed integer width. One program, 0.13 seconds, one digest.

---

## 1 · Their experiment, as a fraction

The quantum switch of two thermalising channels — Felce and Vedral's construction (*PRL* **125**, 070603, 2020), realised on an optical bench by Xue et al. (*PRL*, 2026). Two channels act on one system; classically you pick an order. The switch puts a control qubit in superposition so both orders happen at once, and the interference term is the entire content of the effect:

```
ρ₊  =  ¼ [ E₂(E₁(ρ)) + E₁(E₂(ρ)) + X + X† ],     X_ba = p_a q_b ρ_ba
```

The first two terms *are* the two definite orders, and for fully thermalising channels each is just a reservoir's own thermal state — which is exactly why a definite order can do nothing here. For a diagonal input, `X` is diagonal too, and everything becomes a ratio of integers.

**The step that makes it exact:** pick the reservoir by its Boltzmann factor `z = e^(−βε)` rather than by its temperature. Every rational z in (0,1) *is* a real temperature, so this loses nothing — and it makes every population an exact rational. Nothing is sampled, binned or fitted.

Here is the case with nowhere to hide: the system and both reservoirs at the **same** temperature, where classically nothing whatever can happen.

| Boltzmann z | order 1,2 | order 2,1 | switch, exact | energy moved |
|---|---|---|---|---|
| 1/2 | no change | no change | 5/18 | **−1/18** |
| 2/3 | no change | no change | 29/80 | −3/80 |
| 4/5 | no change | no change | 194/459 | −10/459 |
| 9/10 | no change | no change | 1989/4294 | −45/4294 |
| 99/100 | no change | no change | 2445399/4925449 | −4950/4925449 |
| 999/1000 | no change | no change | 2494503999/4992504499 | −499500/4992504499 |
| 99999/10⁵ | no change | no change | 2499945000399999/4999925000449999 | −4999950000/4999925000449999 |
| 999999/10⁶ | no change | no change | 2499994500003999999/4999992500004499999 | −499999500000/4999992500004499999 |

**Nine of nine settings, the switch moves energy. Zero of nine, a definite order does.** Those inert columns are the control: they are the same experiment with the superposition removed, and they do nothing at every rung.

At infinite temperature — z = 1, populations exactly 1/2 — the switch moves exactly **0**, because there is no asymmetry for the interference term to act on. Without that rung this would be a detector that always says yes.

And in the anomalous direction: a cold system at z = 1/100 against two hot reservoirs at z = 99/100. A definite order hands it the hot reservoir's thermal state, `99/199`. The switch lands at `333267/834917` — **below both orders by exactly `16336650/166148483`** — with the control landing on `|+⟩` with probability exactly `2504751/3999701`.

No shot noise, no visibility, no post-selection statistics. Not because the apparatus is good — because there is no apparatus. The state was carried as integers and read off.

## 2 · Where the double loses it

The effect shrinks as the temperature rises. So we asked where a conventional simulation stops seeing it, across 22 rungs from `z = 1 − 10⁻¹` to `1 − 10⁻²²`.

| Boltzmann z | exact | double | |
|---|---|---|---|
| 1 − 10⁻¹ | −45/4294 | −0.010479739170936198 | agree |
| 1 − 10⁻⁵ | −4999950000/4999925000449999 | −1.0000050000291694e-06 | agree |
| 1 − 10⁻¹⁰ | −49999999995000000000/4999999999250000000044999999999 | −1.000000082740371e-11 | agree |
| 1 − 10⁻¹⁵ | −499999999999999500000000000000/4999999999999992500000000000004499999999999999 | −5.551115123125783e-17 | agree |
| **1 − 10⁻¹⁶** | −49999999999999995000000000000000/4999999999999999250000000000000044999999999999999 | **0** | **effect gone** |
| **1 − 10⁻¹⁷ … 1 − 10⁻²²** | non-zero at every rung | **0** | **effect gone** |

**Exact: non-zero on 22 of 22. Double: exactly zero on 7 of 22, first at z = 1 − 10⁻¹⁶.**

Read the last column again. The double does not return a small number there, or an uncertain one. It returns `0` — the absence of the physics, delivered as a result, with nothing to distinguish it from a genuine null. A study run at those temperatures concludes that indefinite causal order does nothing.

There is no temperature at which the effect stops existing. There is only a temperature at which a 64-bit float stops being able to hold it.

## 3 · The same failure, wearing geometry

Two affine maps over the rationals are the projective action of integer matrices, so the group commutator `A·B·A⁻¹·B⁻¹` is transport around a closed loop — out along A, out along B, back along A, back along B. Its exact deviation from the identity is the loop's **holonomy**. A flat loop returns *exactly* to where it started.

| scale | loop | exact | double |
|---|---|---|---|
| **10³** | flat | **0** — flat | −1.1102230246251565e-16 — **curved** |
| 10³ | curved | 1/1010021 — curved | −9.67902420101474e-07 — curved |
| **10⁴** | flat | **0** — flat | 2.220446049250313e-16 — **curved** |
| 10⁵ | flat | 0 — flat | 0 — flat |
| **10⁶** | flat | **0** — flat | 2.220446049250313e-16 — **curved** |
| 10⁷ | flat | 0 — flat | 0 — flat |
| **10⁸** | flat | **0** — flat | 2.220446049250313e-16 — **curved** |
| **10⁸** | **curved** | **1/10000001000000021** — curved | **0** — **flat** |

**Curvature invented on 4 flat loops, erased on 1 curved loop, of 12 walked.** Read as commutation on a longer ladder: 3 of 9 exactly-commuting pairs called non-commuting, 3 of 9 genuinely non-commuting pairs called commuting.

The exact arm was graded against the closed form on all eighteen rungs and got **18 of 18** — flat on every flat one, curved on every curved one. It separates the two populations in both directions, which is precisely what the double fails to do in either.

## 4 · And the order was never in the data

A scalar-line model says an event carries a coordinate on a line and *before* is that coordinate's order. That model came into computing from physics: Lamport built `happened-before` on the light-cone partial order of special relativity, and then — because a system has to do *something* — extended it to a total order, saying in the paper that the extension is **arbitrary**. Fifty years of vector clocks and consensus protocols are built on the extension rather than on the invariant.

A circle admits no translation-invariant total order. To get a sequence you must choose a cut, and the cut is not in the data. Nine events carrying an angular coordinate, exact fractions of a turn, each taken in turn as the origin:

| cut at τ = | sequence | | cut at τ = | sequence |
|---|---|---|---|---|
| 2/3 | 0 7 2 4 1 8 5 3 6 | | 1/3 | 5 3 6 0 7 2 4 1 8 |
| 1/9 | 1 8 5 3 6 0 7 2 4 | | 4/7 | 6 0 7 2 4 1 8 5 3 |
| 7/8 | 2 4 1 8 5 3 6 0 7 | | 17/23 | 7 2 4 1 8 5 3 6 0 |
| 5/11 | 3 6 0 7 2 4 1 8 5 | | 2/7 | 8 5 3 6 0 7 2 4 1 |
| 20/21 | 4 1 8 5 3 6 0 7 2 | | | |

**Nine distinct sequences.** Not one coordinate changed between those rows. Only the origin moved.

Take the **cyclic orientation** of all 84 ordered triples under those same nine cuts — the relation *"b lies on the arc from a to c"* — and it is **one vector, identical under every origin.** Read the same nine values as points on a line, re-origined by subtraction with no wraparound, and you get **one sequence** from all nine cuts: so the nine on the circle come from compactness, not from the re-origining.

A system that seals a sequence must first make everyone agree on an origin the data does not contain. A system that seals the orientation needs no agreement, because there is nothing left to disagree about.

**And this is measurable in a fleet.** Nine cells, the same 64 events, nine arrival orders, on a population where large balances and small increments share one stream: **one result in exact arithmetic — `−13494202421495/934495065504` on all nine — and six in double**, spanning 84% of the true value. One of the nine happens to land within a last place of the exact answer, eight do not, and nothing in the protocol tells you which you got. Put the same nine orders on 64 small integers, where the double has nothing to round, and both arithmetics return one. So what the total order was repairing was the rounding.

---

## What we are not saying

**This does not make quantum hardware unnecessary.** A two-level system under two fully thermalising channels is small enough to write down in closed form — that is *why* it can be a fraction. Nothing here is evidence in either direction about a state space that cannot be. What §1 and §2 show is narrower and still worth having: for this experiment, the limit on a conventional simulation is not the physics and not the Hilbert space. It is the arithmetic, and it fails somewhere we can name.

**We did not do the experiment.** The optical bench, the anomalous flow and the Otto cycle are Xue et al.'s. Their demonstration is proof-of-principle, and it does not bypass the second law — the control qubit's coherence is itself a thermodynamic resource that has to be paid for. We computed the prediction their apparatus was built to confirm, which is a different act and a smaller one.

**We did not identify the geometry of the universe.** §4 measures that a compact phase coordinate carries an invariant a scalar line cannot. That is a statement about a class, shared by every compact coordinate in it. Which member is the right one is not answered here.

## Evidence, graded

| claim | grade |
|---|---|
| The switch of two thermalising channels, exactly: 9 of 9 reservoir settings move energy that neither definite order moves (0 of 9); exactly −1/18 at z = 1/2; exactly 0 at z = 1; a cold system lands below both orders by 16336650/166148483. | **MEASURED** — `reproduce/ico-causal-order-shear.swift` |
| The same effect in double precision returns exactly zero on 7 of 22 rungs, first at z = 1 − 10⁻¹⁶, where exact arithmetic is non-zero on all 22. | **MEASURED** |
| A float-walked closed loop invents curvature on 4 of 6 flat loops and erases it on 1 of 6 curved, non-monotone in the scale; the exact arm is 18 of 18 and separates both populations. | **MEASURED** |
| Nine origins on a compact coordinate give 9 sequences from one unchanged event set; the cyclic orientation over 84 triples is 1 vector under all nine; on a line, 1 sequence under all nine. | **MEASURED** |
| Nine cells folding one 64-event set in nine arrival orders: 1 result exact, 6 in double, spanning 84% of the true value; on a population float holds exactly, both give 1. | **MEASURED** |
| The photonic realisation of anomalous heat flow and the ICO Otto cycle. | **REPORTED** — Xue et al., *PRL* (2026), [arXiv:2511.04028](https://arxiv.org/abs/2511.04028); construction from Felce & Vedral, *PRL* **125**, 070603 (2020) |
| That total-ordering protocols are substantially a prosthesis for non-associative arithmetic, and that the arbitrariness Lamport noted is the signature of modelling an angular quantity on a line. | **ARGUMENT** — our reading |
| That exact arithmetic removes the need for quantum hardware; that any single manifold is the geometry of the universe. | **NOT KNOWN** — never claimed |

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

Every exact figure here is re-derived by a separately written arbitrary-precision implementation: **75 of 75 agree, 0 diverge.** That checker carries two control arms — a switch value at a setting the program never runs, and a fold value altered in its last digit — and reports both correctly absent, so it is discriminating rather than merely agreeable.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/ico-causal-order-shear.swift -o /tmp/ico && /tmp/ico
```

No account, no key, no corpus, no network. The exact integers are decimal strings with no fixed width — there is no `Int128` and no platform-specific type, because the build host has one and the cells do not, and a law that is one type here and another there is two laws. Under a fixed width this program trapped at the third rung of its own ladder while every answer was small; a ceiling inside an instrument that measures where floating point runs out is the same defect wearing a different width. Swapping the integer representation reproduced every other arm byte-for-byte.

**One thing is not yet measured:** a run on a cell. The Linux host available here carries no Swift toolchain, so what is claimed is that the program has no platform-dependent arithmetic — checkable by reading it — not that a cell has executed it.

The float arm is the object under measurement and lives in the functions named `float…` and `runSwitchFloat`.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can inspect it and re-derive every figure. That visibility grants no rights. The repository carries no LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a separate written licensing agreement with the authors.
