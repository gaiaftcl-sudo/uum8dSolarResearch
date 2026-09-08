# Study 40 — Who told you the order mattered?

*A distributed system spends most of its machinery imposing one total order on its events — Lamport clocks, vector clocks, Raft. This study measures where that requirement actually comes from. **It is not the events. It is the arithmetic.** Nine cells folding one identical event set in nine different arrival orders reach **one** result in exact rationals and **six** in double precision. And asked whether two operations commute, a floating-point observer is wrong in **both** directions — it invents an order-dependence that is exactly zero, and it erases one that is exactly non-zero. This study grades the **arithmetic**, never the physics it is placed beside.*

> [!NOTE]
> **How to read this page.** The photonic result in §1 is **REPORTED** — a real experiment, cited, and described in its own terms with its own limits. The mapping onto this architecture in §5 is **ARGUMENT** — this program's reading, and it is labelled as such wherever it appears. The only **MEASURED** content on this page is §2–§4, which runs entirely on our own arithmetic and claims nothing about photons. **The test is sealed; the analogy never is.**

## 1. What the physicists measured — REPORTED

In July 2026 *Physical Review Letters* published **"Anomalous Heat Flows and Quantum Otto Engine with (In)definite Causal Order"** — Qing-Feng Xue, Qi Zhang, Xu-Cai Zhuang, Yun-Jie Xia, Enrico Russo, Giulio Chiribella, Rosario Lo Franco and Zhong-Xiao Man, of Qufu Normal University, the University of Hong Kong and the University of Palermo.

Two thermalisation channels act on one system. Classically you must choose: A then B, or B then A. A **quantum switch** refuses the choice — a control qubit is prepared in superposition and an interferometer puts the photon on both paths, so the two channels act in a *superposition of orders*. The team predicted and then demonstrated, on a photonic platform, an **anomalous reversed flow**: the system absorbs heat from reservoirs colder than itself. They built a quantum Otto cycle on it that generates work and refrigerates at the same time.

**Two limits, and the study is worth less without them.** It is a *proof-of-principle* demonstration of a theoretical framework, not an engineering result — the paper reports no efficiency or throughput figure and does not claim one. And **the second law is not bypassed.** The coherence of the control qubit is itself a thermodynamic resource: preparing it, and erasing it afterwards, carries a cost that the anomalous flow is drawn against. What the experiment establishes is narrower and more interesting than a violation — that **causal order is not a background fact the system must be given**. It can be held in superposition, it is physical, and holding it that way does work that no definite order does.

**REPORTED** — [Phys. Rev. Lett. (2026), DOI 10.1103/sx1m-pdhz](https://journals.aps.org/prl/abstract/10.1103/sx1m-pdhz); preprint [arXiv:2511.04028](https://arxiv.org/abs/2511.04028).

## 2. The question this program can actually answer

We cannot measure a photon here, so we do not pretend to. We can measure the one question the physics puts on the table in a form our own machine answers exactly:

> **When a system tells you the order of two operations matters — who is telling you? The operations, or the number system you evaluated them in?**

That question has a closed form. Take two affine maps over the rationals, `A: x ↦ (aₐx + bₐ)/dₐ` and `B: x ↦ (a_bx + b_b)/d_b`. Both composite orders share the denominator `dₐ·d_b`, so the commutator is a pure constant — the same at every `x`, not a sample:

```
(A∘B)(x) − (B∘A)(x)  =  [ b_b·(aₐ − dₐ) − bₐ·(a_b − d_b) ] / (dₐ · d_b)
```

So *"do these two operations commute"* has an exact **yes** or **no**, written in whole integers, before any evaluation runs. We put that question to both arithmetics, down a ladder of scales, and grade them against the closed form. `reproduce/ico-causal-order-shear.swift` compiles to a native binary, carries every constant in the file — no corpus, no network, no key, no argument vector — and prints its reference figures on every exit path.

## 3. The float is wrong in both directions — MEASURED

**ARM 1 — it invents an order that is not there.** Nine pairs built so the commutator numerator is `7·3 − 3·7`, which is **exactly zero**. These maps commute perfectly at every scale. Evaluated at `x = 1`:

| scale | exact commutator | exact verdict | double commutator | double verdict |
|---|---|---|---|---|
| 10³ | 0 | COMMUTES | 0 | COMMUTES |
| **10⁴** | **0** | **COMMUTES** | **−2.220446049250313e-16** | **DOES NOT — order manufactured** |
| 10⁵ | 0 | COMMUTES | 0 | COMMUTES |
| 10⁶ | 0 | COMMUTES | 0 | COMMUTES |
| 10⁷ | 0 | COMMUTES | 0 | COMMUTES |
| **10⁸** | **0** | **COMMUTES** | **−2.220446049250313e-16** | **DOES NOT — order manufactured** |
| 10⁹ | 0 | COMMUTES | 0 | COMMUTES |
| **10¹⁰** | **0** | **COMMUTES** | **−2.220446049250313e-16** | **DOES NOT — order manufactured** |
| 10¹¹ | 0 | COMMUTES | 0 | COMMUTES |

**3 of 9.** A replica set built on that arithmetic would see its nodes disagree, conclude the operations are order-sensitive, and impose a total order to fix it — **for an order-dependence that is exactly zero.** Note the shape of the failures, too: they are at 10⁴, 10⁸ and 10¹⁰, and the rungs between them are clean. **The horizon is not monotone.** You cannot escape it by staying under a scale, because there is no "under".

**ARM 2 — it erases an order that is there.** Nine pairs built so the numerator is `7·3 − 1·20 = 1`. These maps **never** commute; the true gap is exactly `1/(dₐ·d_b)`, and we drive it under the double's resolution on purpose, because that is where the opposite failure lives:

| scale | exact commutator | exact verdict | double commutator | double verdict |
|---|---|---|---|---|
| 10³ | 1/1010021 | DOES NOT | 9.900784243566108e-07 | DOES NOT |
| 10⁴ | 1/100100021 | DOES NOT | 9.990007709959059e-09 | DOES NOT |
| 10⁵ | 1/10001000021 | DOES NOT | 9.99902383114204e-11 | DOES NOT |
| 10⁶ | 1/1000010000021 | DOES NOT | 1.000088900582341e-12 | DOES NOT |
| 10⁷ | 1/100000100000021 | DOES NOT | 9.769962616701378e-15 | DOES NOT |
| **10⁸** | **1/10000001000000021** | **DOES NOT** | **0** | **COMMUTES — order erased** |
| 10⁹ | 1/1000000010000000021 | DOES NOT | 2.220446049250313e-16 | DOES NOT |
| **10¹⁰** | **1/100000000100000000021** | **DOES NOT** | **0** | **COMMUTES — order erased** |
| **10¹¹** | **1/10000000001000000000021** | **DOES NOT** | **0** | **COMMUTES — order erased** |

**3 of 9**, first at 10⁸ — and again not monotone, because 10⁹ recovers. A replica set built on *that* would conclude the two operations are safely interchangeable, skip the ordering it genuinely needed, and diverge in silence with every node reporting agreement.

**ARM 3 — the control, and the page is worth nothing without it.** An instrument that answers the same thing on both populations is a turn counter, not a measurement. The exact arm was graded against the closed form on all eighteen rungs: **18 of 18** — `COMMUTES` on every rung of ARM 1, `DOES NOT` on every rung of ARM 2. It separates the two populations in both directions, which is precisely what the double fails to do in either.

## 4. Nine cells, nine arrival orders, one event set — MEASURED

The fleet is nine cells. Give each of them the same 64 events and a different arrival order — deterministic permutations, strides coprime to 64, no random source anywhere, because a shuffle seeded by a clock would make this program's own verdict unreproducible, which is the defect it exists to measure.

The population is what a replica ledger looks like when large balances and small increments share one stream: 32 alternating magnitudes at 2⁵³ — the exact scale at which a double can no longer hold an odd neighbour — telescoping to exactly −16, plus 32 small fractions.

| cell | stride | exact fold | double fold |
|---|---|---|---|
| hel-00 | 1 | −13494202421495/934495065504 | −14.44010024196028 |
| hel-01 | 3 | −13494202421495/934495065504 | −16.0 |
| hel-02 | 5 | −13494202421495/934495065504 | −16.0 |
| hel-03 | 7 | −13494202421495/934495065504 | −16.0 |
| hel-04 | 9 | −13494202421495/934495065504 | −10.0 |
| nbg-00 | 11 | −13494202421495/934495065504 | −20.0 |
| nbg-01 | 13 | −13494202421495/934495065504 | −16.0 |
| nbg-02 | 15 | −13494202421495/934495065504 | −7.923076923076923 |
| nbg-03 | 17 | −13494202421495/934495065504 | −15.972222222222221 |

**Distinct results: 1 in exact arithmetic, 6 in double.** The exact answer is −13494202421495/934495065504 = −14.440100241960282… on all nine. The double answers span −20.0 to −7.923076923076923 — a spread of 12.0769…, which is **84% of the true value** — from *identical input*, differing only in the order it arrived. And note `hel-00`: one of the nine orders lands within a last place of the exact answer. Eight do not, nothing in the protocol tells you which one you got, and a node that happens to be right is not distinguishable from a node that happens to be wrong.

**ARM 5 — the second control.** Run the same nine orders on 64 small integers, where every partial sum is exactly representable and the double has nothing to round: **1 distinct result in each arithmetic.** Without this rung, ARM 4 is an always-red detector and proves nothing. With it, ARM 4 is measuring rounding — not the permutation generator, not the population size, not the fold.

```
ARM 1 float false positives           3 of 9
ARM 2 float false negatives           3 of 9
ARM 3 exact control                   18 of 18
ARM 4 exact distinct / float distinct 1 / 6
ARM 5 control distinct exact / float  1 / 1
TERMINAL                              ORDER_IS_AN_ARTEFACT_OF_THE_ARITHMETIC

sha256 = ecdcb1cee4111c1ee2094c5e9316a717622ad5cef825f87aeb54ee0abdae86d6
```

## 5. What this says about the architecture — ARGUMENT

**ARGUMENT** — the reading below is this study's thesis. The measurements are above and graded; this section adds no figures.

Consensus is usually explained as a fact about distributed systems: nodes are far apart, messages race, so someone must decide what happened first. §3 and §4 say something narrower and sharper. **A float-valued replica genuinely disagrees with itself under reordering.** That disagreement is real, it is not the network's fault, and a total order is the cheapest available repair for it. Lamport clocks, vector clocks and Raft are not a law of distributed computing — they are, in significant part, **a prosthesis for an arithmetic that cannot be trusted to be associative.** Take the rounding away and the prosthesis has nothing left to hold: nine cells reach one identical result with no ordering protocol at all, because exact rational addition is commutative and associative *exactly*, and exact composition reports commutation when and only when it is there.

That is the seam this architecture is built on, and it runs the same way through every layer:

- **The order need not be collapsed early.** The substrate carries state as unevaluated integer pairs and defers the collapse to the seal, rather than rounding at each hop and then spending a protocol to reconcile the roundings. There is no intermediate value with a wrong last digit, so there is nothing to reconcile.
- **The friction that consensus burns is what this program calls shear.** Waiting on causal locks is not free — it is latency, wait states and fragmentation, spent to suppress a divergence the arithmetic created. Removing the divergence removes the spend, on bare-metal Swift 6.4 with no floating point in the path.
- **And this is why zero-float is not a style rule.** It is the precondition for a fleet that agrees without being ordered.

**Where the physics sits in that argument.** The photonic result does not validate our software; software is not validated by an interferometer, and any page claiming otherwise is trading on the adjacency. What it does is remove an *objection*. The intuition that a definite causal order is a background requirement of reality — that A-then-B or B-then-A must be settled before composition means anything — is the intuition that makes a total order feel mandatory rather than chosen. Nature declines that intuition on an optical bench. Our fleet declines it in integers, for a different reason and by a different mechanism, and the two are **an alignment, not a proof**. One is physics. The other is arithmetic. This page seals only the second.

## 6. What this does not claim

It does **not** demonstrate indefinite causal order, reproduce any photonic experiment, or reverse any heat flow. It does **not** show that our substrate is quantum-mechanical, that M⁸ = S⁴ × C⁴ is the geometry of the universe, or that any physical theory has been confirmed by a Swift program. Those are the DISCOVER move, and the substrate returns **NOT KNOWN** on them by law rather than sampling toward an answer and dressing it as confidence.

What is sealed here is exactly one thing, and it is ours to measure: **order-dependence is a property of the arithmetic, and a machine that does not round does not need to be told what happened first.**

## Evidence, graded

| claim | grade |
|---|---|
| A double-precision observer reports a non-zero commutator for maps that commute exactly (3 of 9 rungs, first at 10⁴, non-monotone), and a zero commutator for maps that do not (3 of 9, first at 10⁸, non-monotone). The exact arm answers the closed form correctly 18 of 18 and separates both populations. | **MEASURED** — `reproduce/ico-causal-order-shear.swift`, seal `ecdcb1ce…` |
| Nine cells folding one 64-event set in nine arrival orders reach 1 distinct result in exact rationals and 6 in double, spanning −7.92 to −20.0; on a population float can hold exactly, both arithmetics reach 1. | **MEASURED** — same program, ARM 4 and its ARM 5 control |
| A photonic quantum switch realises a superposition of two thermalisation orders, producing anomalous heat flow from colder reservoirs and an Otto cycle that works and refrigerates at once; proof-of-principle, and no violation of the second law — the control qubit's coherence is the resource. | **REPORTED** — Xue et al., Phys. Rev. Lett. (2026); arXiv:2511.04028 |
| Total-ordering protocols are substantially a prosthesis for non-associative arithmetic, and removing the rounding removes the need rather than merely the cost. | **ARGUMENT** — this study's reading of §3–§4 |
| That the substrate's geometry is the geometry of the universe, or that the photonic result validates this architecture. | **NOT KNOWN** — the DISCOVER move; refused by law, never claimed |

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
swiftc -O reproduce/ico-causal-order-shear.swift -o /tmp/ico && /tmp/ico
```

No account, no key, no corpus, no network, and no floating point in the exact path. A different digest on your machine would mean the exact arithmetic diverged — which exact integers make impossible. The float arm is the object under measurement, and it is confined to the functions named `float…`.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can inspect it and re-derive every figure. That visibility grants no rights. The repository carries no LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a separate written licensing agreement with the authors.
