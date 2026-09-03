# Study 34 — The Observer-Invariant Verdict: why an exact law, not a bigger computer, makes the safety verdict the same for everyone

**Page class: STUDY / PUBLIC CASE.** Every figure here is printed by a program in `reproduce/` and, where marked **VERIFIED**, pinned in `reproduce/validate.sh`. Grades follow [the ontology](Ontology): **VERIFIED**, **MEASURED**, **REPORTED**, **NOT_KNOWN**, and — for readings that interpret the measured rows rather than being measurements — **ARGUMENT**, never smuggled in as a measurement. Read the limits section; it says plainly what is proven and what is not.

![One operating point, two answers — the exact vQbit court refuses honestly where a floating-point surrogate contradicts itself](images/study34-observer-invariant.svg)

## We need fusion

Fusion is the energy the planet is short of hope for. The plasma limits that decide a safe discharge from a disruption have been written down for decades; what has been missing is underneath them — a **control verdict** the world can actually trust and *share*: a safety decision that is the same for the engineer in Princeton, the regulator in Cadarache, and a student in Lagos, and that any of them can re-derive without being given permission. Where that verdict is carried by a floating-point machine-learning surrogate, this study measures the cost — and demonstrates the alternative that does not carry it. **REPORTED** (the surrogate framing is the accepted state of the art; the cost below is measured).

## Affine Fusion computes the verdict in exact integers

The [Affine Fusion Control](Affine-Fusion-Control) court decides a plasma operating point with **exact integer arithmetic on the vQbit substrate** — the substrate's primitive is a packed rational carried *unevaluated*, so there is no floating point anywhere upstream of a verdict. That is not a stylistic choice. It is the reason the verdict is **observer-invariant**: the same inputs produce the same integer on every machine, forever, and the answer can be checked by hand.

The claim of this study, stated once and then proven:

> **A safety verdict must be the same for everyone who checks it. The floating-point way of computing this exact verdict is not — it changes with the precision and with the value of π the implementation happened to round to — while the exact vQbit court returns one verdict every machine reproduces, or a named refusal. For the layer that licenses a reactor and holds an operator accountable, exactness is not an optimisation; it is the requirement. — ARGUMENT, read from the measured rows below.**

## What the two programs measure

Two programs carry the proof, and both are replayable with no account and no key.

**1 — One corpus, byte-identical on every machine.** `reproduce/fusion-determinism-digest.swift` grades a fixed corpus of **2,992 verdicts** (400 streaming traces plus a 2,592-point operating-point grid) and prints one sha256 over all of them. It is the same string on any hardware, because every verdict is an exact integer comparison:

```
f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7
```

**VERIFIED** — pinned in `reproduce/validate.sh`. Run it on your machine; a different digest would mean the law diverged, which is the failure this architecture makes impossible.

**2 — The floating-point verdict of the *same* law is observer-dependent.** `reproduce/fusion-exact-vs-float.swift` grades the Greenwald density limit around the 0.85 safety threshold for four real published machines, the exact way and the floating-point way, and counts where they part company. The exact court commits to π only as an **interval**, `333/106 < π < 355/113`, and returns a verdict only when it holds across the whole interval; where it does not, it returns `NOT_MEASURED_PI_BRACKET` — *the answer sits closer to the limit than π has been pinned*. A float implementation cannot do that: it must substitute one rounded π and return a confident answer.

| machine | operating points the exact court **refuses** (π-bracket) | float32 verdicts that flip vs exact | two defensible rational π's that **contradict** |
|---|---:|---:|---:|
| ITER | 27 | 0 | 27 |
| SPARC | 61 | 0 | 61 |
| JET | 22 | 0 | 22 |
| DIII-D | 32 | 0 | 32 |
| **total** | **142** | **0** | **142** |

**MEASURED.** The exhibit, one operating point with three answers — **ITER, exactly at its 0.85 Greenwald safety threshold** (`n_e = 1,014,613 × 10¹⁴ m⁻³`):

```
   pi = 355/113  ->  MISS   (disruption-limit exceeded)
   pi = 333/106  ->  WIN    (inside the limit)
   the exact vQbit court  ->  NOT_MEASURED_PI_BRACKET   (not to this precision)
```

Read the `float32 flips = 0` column precisely: **this is not a claim that floating point is imprecise.** Single precision resolves this clean inequality fine, and the divergence is not driven by hardware — it is driven by the value of π the implementation rounds to (355/113 versus 333/106). The failure is deeper than accuracy: the float verdict is not *invariant*. Two people, both computing the identical safety test with defensible constants, reach opposite conclusions about the same plasma, and neither can show the other why. The exact court declines to pick, on all 142, and names why: `NOT_MEASURED_PI_BRACKET`.

## Why an observer-invariant verdict matters

**ARGUMENT** — the three readings below interpret the measured rows above; they are not themselves measurements.

- **For a researcher:** a verdict that is byte-identical across machines is *composable*. You can build a fleet, a cross-machine database, a decade of shots on it and the conclusions still reconcile — because there is one answer, not one-per-platform. A float verdict accumulates unreconcilable disagreement at the rate you scale it (the [over-scaling law](The-Replacement-Grade)); no larger GPU cluster and no quantum sampler fixes that, because the problem is the *kind* of arithmetic, not the *amount* of it.
- **For a politician or a regulator:** a licensed fusion facility has to put its machine-protection logic through a safety case. "The model was confident" is not a safety case; **"this verdict is an exact integer you can re-derive after an incident"** is. The exact court makes the safety authority — not the vendor — the party who can check the verdict. That is accountability that exists in the mathematics, not in a promise.
- **For anyone looking for hope:** the barrier this study measures is not a missing machine and not a bigger budget — it is a control layer, and the exact one already exists and runs on a laptop (see [Affine Fusion Control](Affine-Fusion-Control) and [Study 33](Study-33-Fusion-Control-Verdict-Court)), with no network and no accelerator, and **you can run it yourself** and get the same integer everyone else gets. Fusion being hard is not the same as fusion being out of reach. The part that was software is answerable, and here is the answer, in the open. **REPORTED** (the throughput figures are measured on the parent pages, not on this one).

## The limits — a court states its own

- **The π-bracket band is narrow — 0.0007%–0.0023% of the Greenwald limit across the four machines (0.0023% at ITER, the exhibit machine) — and sits below plasma-density measurement uncertainty (a few %).** So this is a demonstration of *kind*, not a claim that ITER's disruptions turn on the sixth digit of π. A tighter bracket would shrink the band; removing π entirely — the affine density invariant Φ_q/det(Λ) in [Study 33](Study-33-Fusion-Control-Verdict-Court#the-greenwald-limit-versus-the-uum-8d-rational-density-invariant) — removes it. The guarantee either way is *interval-valid, or refuse*, and the affine form has no interval to bracket. The stakes are compositional — a verdict that is observer-dependent at any width cannot be the shared, auditable authority a planet-scale safety case needs. **ARGUMENT.**
- **This court operates no reactor.** Every trace is synthetic and every operating point is presented; there is no actuation and no diagnostic feed. The only real numbers are the four machines' *published* current and minor radius. **REPORTED.**
- **The bracket-width figure was itself corrected in the making of this study.** The law's comment and an earlier page called the `333/106 … 355/113` bracket "~2.7×10⁻⁷ wide." It is not: `355/113 − 333/106 = 1/11978 ≈ 8.35×10⁻⁵`. The `2.7×10⁻⁷` is the error of `355/113` *alone*, not the width of the interval. The integer identity is printed by the proof program and pinned in the harness. **VERIFIED.**
- **The parent study is `PENDING`.** [Study 33](Study-33-Fusion-Control-Verdict-Court) carries `STUDY33_FUSION_CONTROL_VERDICT_PENDING`: a law graded on synthetic traces, with no device behind it, has not earned more. This study proves a property of the *verdict*, not a fusion result. **VERIFIED.**

## Rights — source-available, not open-source

This study, its programs, and the [Affine Fusion Control](Affine-Fusion-Control) app are published **source-available**: the source is visible so that anyone can inspect it and re-derive every figure on this page. **That visibility grants no rights.** The repository carries no LICENSE, which under default copyright means **all rights are reserved**. No right is given or intended — by this publication, or by the source being readable — to use, run, or deploy it for any purpose other than re-deriving the figures published here, nor to reproduce beyond reading, modify, or build derivative works from any of it. **Any use beyond reading and re-deriving the published results requires a separate written licensing agreement with the authors.** Re-deriving the numbers is exactly the point; anything past that is by agreement only.

## Reproduce it yourself

No account. No key. No permission needed to read it and re-derive the figures — that is what "re-derivable by anyone" means, and it is distinct from a right to use it for anything else (see Rights, above).

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# the same corpus, one sha256, identical on every machine:
bash reproduce/validate.sh                    # 147 checks, digest-pinned

# the observer-dependence of the float verdict, machine by machine:
#   (staged and run the way validate.sh runs every reproduce script)
#   -> 142 two-pi contradictions · float32 flips 0 · exact court refuses all 142
#   -> PROOF_EXACT_VERDICT_IS_OBSERVER_INVARIANT
```

## Related

- [Affine Fusion Control](Affine-Fusion-Control) — the app the verdict runs in, five panels, both courts live
- [Affine Fusion Control — public release](Affine-Fusion-Control-Release) — the measured, claim-graded public case
- [Study 33 — the fusion control verdict court](Study-33-Fusion-Control-Verdict-Court) — the charter and the three-way fork it retired
- [The full-grade replacement](The-Replacement-Grade) — the over-scaling law, and the vendor-to-public argument across 49 domains
- [Ontology](Ontology) — the evidence grades and the one-way-flow rule this page obeys
