# Study 40 — The number the simulation throws away

*In July, physicists put two thermalising channels into a superposition of orders and watched heat flow from the colder reservoir. It was written up widely, because heat flowing the wrong way is a good headline.*

*The prediction they confirmed is not a measurement. It is a fraction. We computed it: at z = 1/2 the switch moves exactly **−1/18** of a level gap, and neither ordering moves anything at all.*

*Then we computed the same fraction the way this physics is normally simulated, and **the effect is not there**. Double precision returns `0` above z = 1 − 10⁻¹⁶. Single returns `0` above 10⁻⁸. Half above 10⁻⁴. Not small — zero, with nothing in the output to distinguish it from a real null.*

*The wrong way got an article. **This is why the right way matters more: an effect your arithmetic returns as zero is an effect you cannot go looking for.***

---

## The part that should worry a working physicist

That bench found this effect because nature computed it exactly. There is no floating point in an interferometer.

Now consider the class of effects that look like this one — small, carried by an interference term, living below whatever horizon your number format has. **A simulation does not report them as uncertain, or noisy, or marginal. It reports them as absent**, in the same clean `0.0` it would return if they genuinely did not exist. There is no flag, no warning, no NaN, and no residual to notice.

You cannot survey for what your instrument returns as zero. So the honest reading of the published result is not one surprising effect. It is one effect that happened to be reachable on a bench — and an unknown number of others that a float-based search would have retired as null before anyone built the apparatus.

That is the claim this study exists to support, and everything below is the arithmetic behind it.

## The four ways out, and why none of them is open

Anyone defending the current practice has four moves. Each is a claim about numbers, so each is measured here rather than argued.

**"Use more precision."** Every width has its own horizon, and each one buys a bounded number of decades:

| width | mantissa bits | first rung returning `0` | bought |
|---|---|---|---|
| Float16 (half) | 11 | z = 1 − 10⁻⁴ | — |
| Float32 (single) | 24 | z = 1 − 10⁻⁸ | +4 decades |
| Float64 (double) | 53 | z = 1 − 10⁻¹⁶ | +8 decades |
| **exact integers** | **unbounded** | **none** | **every rung** |

Thirteen more mantissa bits bought four decades; twenty-nine more bought eight. Nothing in that sequence terminates, and the temperature a reservoir may take is not bounded. There is no width at which the escape closes — only a width at which you have not reached the wall yet.

**"Stay in a safe regime."** There isn't one, because the failures are **not monotone in the scale**. On the geometry arm, 10⁵ and 10⁷ come back clean while 10⁴, 10⁶ and 10⁸ do not. Whether the error appears depends on where the operands' bits happen to fall, not on how large they are — so there is no threshold to sit beneath.

**"Rescale it."** Populations are dimensionless and already O(1); there are no units left to choose. And the loss is not a product overflowing, it is a difference cancelling. At z = 1 − 10⁻¹⁶ the exact populations are

```
p1 = 9999999999999999/19999999999999999
p0 = 10000000000000000/19999999999999999
```

two distinct rationals differing by exactly `1/19999999999999999` — and the double holds **one** number, `0.5`, for both. The asymmetry that carries the entire effect is not approximated at that point. It is absent.

**"It's just rounding error."** Rounding error is small and one-directional. This is neither. It returns an exact `0` where the answer is non-zero, and on the geometry arm it fails in *both* directions — inventing curvature on 4 of 6 flat loops and erasing it on 1 of 6 curved ones. A bias you can bound is an error budget. A detector that is wrong in both directions, non-monotonically, is not an error budget.

And one more the defence does not usually think to make: **the horizon is not even a property of the value.** Write the same z two ways — as the decimal `(10¹⁶−1)/10¹⁶`, or by dividing 1 by ten sixteen times — and they land on different floats. One returns zero; the other still sees the effect. The boundary where the physics disappears depends on how the input was *spelled*.

## What this costs the standard picture

The standard computational model of physical law rests on three assumptions. They are rarely stated together, because stated together they are hard to defend.

**One — causal order is definite and given.** Withdrawn on an optical bench. The quantum switch puts two channels into a superposition of orders and gets work out that no definite order gives. Order is a degree of freedom, not a background fact. *(Xue et al., PRL 2026; construction from Felce & Vedral, PRL **125**, 070603, 2020.)*

**Two — real quantities may be carried in finite floating point.** Measured above: wrong in both directions, non-monotone in the scale, failing at every width, with the boundary depending on how the input was written.

**Three — a total order over events exists to be agreed on.** It does not, on a compact coordinate. Nine origins over one unchanged set of events give **nine** different sequences; the cyclic orientation over all 84 triples gives **one** vector under every origin. The sequence is an artefact of the cut. The orientation is the fact — and the cut is not in the data.

That third assumption is the oldest and the least examined. It came into computing from physics: Lamport built `happened-before` on the light-cone partial order of special relativity, then extended it to a total order and said in the paper that the extension is **arbitrary**. Fifty years of vector clocks and consensus protocols are built on the extension rather than on the invariant. And when we measure what that machinery is actually repairing — nine cells, one event set, nine arrival orders — we get **one** result in exact arithmetic and **six** in double. It was never holding up causality. It was holding up the rounding.

**Take the three together and the picture does not fit.** Not because it is imprecise, but because each leg has been measured to fail on its own terms.

## Not one study — the fortieth

This is not a result arriving out of nowhere. It is the same claim the board has now restated forty times, reaching physics for the first time.

The claim is that a verdict computed in exact integers is **observer-invariant** — identical on every machine, with no horizon past which it silently changes — and that a verdict computed in floating point is not. [Study 34](Study-34-Observer-Invariant-Verdict) established it on the observer axis, [Study 35](Study-35-The-Safety-Brain-That-Forgets) on the time axis, [Study 36](Study-36-The-Language-Game-of-Fermats-Last-Theorem) on proof synthesis, [Studies 38](Study-38-Loss-Reserve-Triangle) and [39](Study-39-Actuarial-Domain) across the whole actuarial and reserving domain — where, notably, the two arithmetics **agreed** to fourteen significant digits, and the study published that as the finding. The instrument is not tuned to indict float. It says so when float is fine.

Study 40 is where it stops being fine, and the difference is worth naming: in finance the quantities are reported at units eleven digits coarser than the disagreement. In this physics the disagreement *is* the quantity.

The whole board runs on the same footing — exact integers, no floating point in any sealed path, verdicts re-derivable by a stranger from published bytes. See the [programme index](Shear-Studies-Index) and the [method](Zero-Float-Zero-Shear-Paradigm).

## The measurements

**Their experiment, as a fraction.** The switch of two fully thermalising channels, post-selected on the control:

```
ρ₊  =  ¼ [ E₂(E₁(ρ)) + E₁(E₂(ρ)) + X + X† ],     X_ba = p_a q_b ρ_ba
```

The first two terms *are* the definite orders — each just a reservoir's own thermal state, which is why a definite order does nothing here. `X` is the interference term and it is the whole effect. **The step that makes it exact:** choose the reservoir by its Boltzmann factor `z = e^(−βε)` rather than its temperature. Every rational z in (0,1) is a real temperature, so nothing is lost, and every population becomes an exact rational.

System and both reservoirs at the **same** temperature, where classically nothing can happen:

| Boltzmann z | order 1,2 | order 2,1 | switch, exact | energy moved |
|---|---|---|---|---|
| 1/2 | no change | no change | 5/18 | **−1/18** |
| 2/3 | no change | no change | 29/80 | −3/80 |
| 9/10 | no change | no change | 1989/4294 | −45/4294 |
| 99/100 | no change | no change | 2445399/4925449 | −4950/4925449 |
| 999999/10⁶ | no change | no change | 2499994500003999999/4999992500004499999 | −499999500000/4999992500004499999 |

**Nine of nine settings the switch moves energy; zero of nine a definite order does.** Those inert columns are the control — the same experiment with the superposition removed. At z = 1 (infinite temperature, populations exactly 1/2) the switch moves exactly **0**, because there is no asymmetry to act on; without that rung this would be a detector that always says yes. And in the anomalous direction, a cold system at z = 1/100 against two hot reservoirs at z = 99/100 lands at `333267/834917` — **below both definite orders by exactly `16336650/166148483`** — with the control landing on `|+⟩` with probability exactly `2504751/3999701`.

No shot noise, no visibility, no post-selection statistics: not because the apparatus is good, but because there is no apparatus.

**Where the double loses it**, across 22 rungs:

| Boltzmann z | exact | double | |
|---|---|---|---|
| 1 − 10⁻¹ | −45/4294 | −0.010479739170936198 | agree |
| 1 − 10⁻¹⁰ | −49999999995000000000/4999999999250000000044999999999 | −1.000000082740371e-11 | agree |
| 1 − 10⁻¹⁵ | −499999999999999500000000000000/4999999999999992500000000000004499999999999999 | −5.551115123125783e-17 | agree |
| **1 − 10⁻¹⁶** | −49999999999999995000000000000000/4999999999999999250000000000000044999999999999999 | **0** | **effect gone** |
| **… to 1 − 10⁻²²** | non-zero at every rung | **0** | **effect gone** |

**Exact: non-zero on 22 of 22. Double: exactly zero on 7 of 22.**

**The same failure, wearing geometry.** Two affine maps over the rationals are the projective action of integer matrices, so the commutator `A·B·A⁻¹·B⁻¹` is transport around a closed loop and its exact deviation from the identity is **holonomy**. A flat loop returns *exactly* home.

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

Curvature invented on 4 flat loops, erased on 1 curved, of 12 walked. The exact arm was graded against the closed form on all eighteen commutation rungs and got **18 of 18** — it separates the two populations in both directions, which is exactly what the double fails to do in either.

**And the cut.** Nine events on an angular coordinate, exact fractions of a turn, each taken in turn as origin:

| cut at τ = | sequence | | cut at τ = | sequence |
|---|---|---|---|---|
| 2/3 | 0 7 2 4 1 8 5 3 6 | | 1/3 | 5 3 6 0 7 2 4 1 8 |
| 1/9 | 1 8 5 3 6 0 7 2 4 | | 4/7 | 6 0 7 2 4 1 8 5 3 |
| 7/8 | 2 4 1 8 5 3 6 0 7 | | 17/23 | 7 2 4 1 8 5 3 6 0 |
| 5/11 | 3 6 0 7 2 4 1 8 5 | | 2/7 | 8 5 3 6 0 7 2 4 1 |
| 20/21 | 4 1 8 5 3 6 0 7 2 | | | |

**Nine sequences.** Not one coordinate changed — only the origin moved. The cyclic orientation over all 84 triples is **one vector under all nine**. Read the same values on a line and all nine cuts give **one** sequence, so this is compactness and not the re-origining.

The fleet measurement alongside it: nine cells, the same 64 events, nine arrival orders, on a population where large balances and small increments share one stream — **one result exact (`−13494202421495/934495065504`), six in double**, spanning 84% of the true value. Same nine orders on 64 small integers, where the double has nothing to round: both give one.

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
ARM 10 horizons half/single/double    10^-4 / 10^-8 / 10^-16, exact NONE
TERMINAL                              ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC

sha256 = 7e5d40d56faaa936877a3d6ad9707637106426c4785258079be9e29ece2eb40f
```

Every exact figure is re-derived by a separately written arbitrary-precision implementation: **75 of 75 agree, 0 diverge.** That checker carries two control arms — a switch value at a setting the program never runs, and a fold value altered in its last digit — and reports both correctly absent.

## What is settled here, and what is not

**Settled, and not by argument.** Exact-integer evaluation of this physics has no horizon: it returns the same fraction at every rung, on every machine, and the seal re-derives from published bytes. Floating point does not, at any width. Those are the tables above and they are reproducible in one command by anyone. **"On every machine" is now a measurement and not a manner of speaking:** nine live cells and the build host, two operating systems, one byte-identical transcript.

**Not settled, and we do not claim it.** This does **not** make quantum hardware unnecessary — a two-level system under two fully thermalising channels is small enough to write in closed form, which is precisely *why* it can be a fraction, and nothing here is evidence in either direction about a state space that cannot be. We did **not** do the experiment; the bench, the anomalous flow and the Otto cycle are Xue et al.'s, their demonstration is proof-of-principle, and it does not bypass the second law — the control qubit's coherence is a thermodynamic resource that has to be paid for. And we have **not** identified the geometry of the universe: the cut arm measures that a compact phase coordinate carries an invariant a scalar line cannot, which is a statement about a class. Which member is the right one is not answered here.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/ico-causal-order-shear.swift -o /tmp/ico && /tmp/ico
```

No account, no key, no corpus, no network, 0.13 seconds. The exact integers are decimal strings with no fixed width — no `Int128`, no platform-specific type, because the build host has one and the cells do not and a law that is one type here and another there is two laws. Under a fixed width this program trapped at the third rung of its own ladder while every answer was small; a ceiling inside an instrument that measures where floating point runs out is the same defect wearing a different width. Swapping the integer representation reproduced every other arm byte-for-byte.

**Measured on the fleet, 2026-09-09.** Cross-compiled for `aarch64-swift-linux-musl` as a static executable and run on all nine live cells — Debian 13 (trixie), Linux 6.12.96, aarch64 — and on the macOS 27 build host. **All ten produce a byte-identical transcript**, sha256 `10bea22dc61d19ae2cb07d85634f44f6c9b444ee72682b6a3a757c24cc7a198c`, carrying the same internal seal `7e5d40d5…`. Matching hosts: `gaiaftcl-hcloud-hel1-01` through `-05`, `gaiaftcl-cell02`, `netcup-cell01`, `netcup-cell03`, `netcup-cell04`, and the build host.

Two operating systems, two C libraries — musl static on the cells, Darwin on the host — one source file, and not one differing byte.

The float arm is the object under measurement and lives in the functions named `float…`, `runSwitchFloat` and `switchAnomalyF16/32/64`.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can inspect it and re-derive every figure. That visibility grants no rights. The repository carries no LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a separate written licensing agreement with the authors.
