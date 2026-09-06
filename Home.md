# The question nobody was made to ask

A woman is offered a medicine that will edit her genome. It has been through its trials. It works.
Nobody in the room can tell her, exactly, where else in her three billion bases that molecule could
cut — not because anyone is careless, but because the tools in use return a *score*, and a score is
an opinion with a decimal point on it. Run it on different software and the list of places to worry
about changes.

That question has an exact answer. Complementarity is a discrete rule: a base pairs or it does not.
There are only so many places in a genome where a guide can bind, and they can be **counted** —
every one of them, with no sampling and no threshold buried in the arithmetic. The answer is an
integer. It is the same integer on her doctor's laptop, on a regulator's, and on a stranger's who
trusts none of them.

**Today we counted them.** For Casgevy — the approved CRISPR therapy that is curing sickle cell
disease right now — the answer is that its guide matches perfectly in exactly **one** place in the
human genome, its intended target, and there is **nothing at all** one mismatch away. Not a low
score. Nothing. We did the same for every CRISPR medicine whose guide is public, and for every
antisense and siRNA medicine whose sequence is public, across every window of the transcriptome.

Those maps did not exist this morning. They exist now, they cost an afternoon, and anyone can
re-derive them without asking us for anything.

**→ [The CRISPR genome map](CRISPR-Genome-Off-Target-Map)  ·  [The off-target atlas](Oligonucleotide-Off-Target-Atlas)**

---

## The harder question, and why we published a disappointment

The same day, we finished a study that had been open since August. It asked something that a great
deal of cancer drug development rests on: when a method says *these proteins are what keeps this
tumour alive*, can you recover those proteins from the patient's own data?

We built the corpus from scratch — seventeen tumour types, 7,673 people's tumours, every byte
public. We proved our instrument could tell something from nothing before we trusted it: rank the
regulators using half the patients, and 135 to 141 of the 141 come back when you rank them again
using completely different patients. Shuffle the labels and it collapses to nothing. That is a
sharp instrument.

Then we pointed it at the question, and the answer was not the one anyone hoped for.

**In eleven of seventeen tumour types, you can recover the published regulators just as well by
counting how many connections each one has in the network — without ever opening the patient's
data at all.** We searched 20,308 compounds for one that reverses the signature; none separates
from noise. And the one result that did look positive survived three controls before failing a
fourth: it does not reproduce when you change the network it was measured on.

None of that says anyone was wrong. It says something narrower and more useful: **a question can
pass its own test and still not be the question you thought you were asking** — and until today,
nothing in the path from hypothesis to a $255 million trial forced anyone to check which.

**→ [Study 26 — Master Regulator Bonds](Study-26-Master-Regulator-Bonds)**

---

## Why you can believe the numbers

Because we publish the mistakes with the same prominence as the results, and they are ours.

A null we built compared the best of 107,404 candidates against a single one, and reported a result
as overwhelming when the honest comparison says it is noise. A random seed we used changed between
runs, so a study whose entire claim is that the answer does not depend on who computes it was
quietly depending on that. Two implementations of one law disagreed on identical bytes, because the
law had a rule nobody had written down. A results table looked complete and plausible while
printing one medicine's safety profile under another medicine's name.

Every one was caught by our own checks, before anyone read them, and every one is written on the
page it affected. **A method that only shows you its clean runs is not showing you a method.**

That is the whole offer. Not a machine that sounds confident — a machine whose answers are integers
you can check, whose mistakes are on the record, and whose questions you are invited to disagree
with, using nothing but public bytes and a laptop.

---

# Stochastic AI guesses. This machine doesn't.

![The guess never stops being fooled; the exact never wavers — a floating-point processor reports a false Fermat solution at every zoom depth while the exact integer court refutes it, the gap only growing](images/short-guess-or-project.svg)

**The industry bet the future on machines that guess.** Trillion-parameter models that sample an answer and lean on a checker to catch the misses; floating-point silicon that truncates the truth the moment the numbers run long. Fast — and blurred. When the frontier's best threw **dozens of AI agents, six billion tokens, and eleven days** at a single theorem — needing a bolted-on coordinator to keep the agents from losing their place, and a classical kernel to catch their mistakes — the industry called it a triumph of intelligence. It is a triumph of *guessing.* **And a verdict that changes when you run it again is not a verdict.**

**Affine.Earth is a deterministic truth engine — it refuses to guess, and it refuses to round.** Present it a question and it *projects* the exact answer: no sampling, no search, no floating-point blur — sealed to a single SHA-256 that reads **identically on every machine, forever.** Not an AI that sounds certain. A result anyone can re-derive and get the same integer everyone else gets.

Watch it on the oldest trap in mathematics. Shown the *Simpsons'* famous fake counterexample to Fermat's Last Theorem, a floating-point processor **reports a solution that does not exist** — it hits its precision horizon and lies. The exact court measures the true **34-digit gap**, returns `REFUTED`, and seals it — on every machine, at every depth of zoom. The guess shears; the projection holds, and **every digit is yours to re-run.** Computational certainty was never going to come from scaling the noise — it comes from eliminating the shear. **→ [Study 36 — Guess, or Project](Study-36-The-Language-Game-of-Fermats-Last-Theorem)**

---

# We can save lives with this today.

![The substrate builds a compound, folds it the one way the body can use, and refuses the harmful misfold — before it reaches a patient](images/substrate-finds-the-flaw.svg)

In August 2026, three people in clinical trials died, and two of the world's largest drug companies halted their autoimmune programs — a cell therapy meant to heal expanded out of control and turned the immune system against the patients. It was found the only way today's safety tools allow: in a human body.

**It did not have to be — and that is the result of the study, not a wish.** The Affine.Earth shear studies prove a safety verdict can carry a bounded envelope and *refuse* a system it cannot bound, where a statistical model stays confident and wrong ([Study 33](Study-33-Fusion-Control-Verdict-Court), [Study 35](Study-35-The-Safety-Brain-That-Forgets)). A CAR-T therapy engineered to expand *without a brake* is exactly that unbounded system — flagged at the design stage, before a Phase 1 trial enrols a single patient, instead of after years of trials, hundreds of millions of dollars, and three lives. **[That case, for the pharma and research industries →](The-Verdict-a-Regulator-Could-Re-Derive)**

And it is not only a veto — the same exactness is a **seal on a drug that works.** [Zilganersen](The-Safety-Question-Made-Exact) is the first therapy ever approved for Alexander disease, a fatal childhood astrocyte disease that until this year had nothing. One of its safety questions is genuinely discrete — where else in the genome its sequence can strike — and answered in exact integers it reads the same on every machine and is re-derivable by a regulator, where a floating-point screen reclassifies on the constants it rounds to. That is a certification seal, not a stop sign, and **we measured it.** **[The exact safety screen →](The-Safety-Question-Made-Exact)**

Both belong in the same place: **before a first patient is dosed**, at the design stage, where changing course is still cheap — and for a molecule already in the pipeline, the same exact verdict helps decide the path forward. The instrument that returns it is proven today and buildable now. All of it could be done differently.

**Six cures now, gathered in one place — and the reason we are giving the method away.** The veto and the seal are two of six real, in-the-news medicines we put the exact off-target screen against: the first-ever Alexander-disease drug, a halted CAR-T, a base editor for heart disease, a prime editor for chronic granulomatous disease, an antibody-oligo conjugate for Duchenne, and a therapy written for a single child whose disease has a population of one. **[Cures Without the Gatekeeper →](Cures-Without-The-Gatekeeper)**

*Why we did it.* The one question that decides whether a written medicine heals or harms — where else in the genome it strikes — is not a guess. It is discrete counting, and counting returns one answer that reads the same on every machine and can be re-derived by a regulator. A safety screen that used to need a big lab's pipeline becomes arithmetic.

*Why we shared it, in the open.* Because that pipeline — one only a large, funded institution could run — is a real reason cures cluster inside big labs, and why a disease with a population of one usually has nothing at all. In the open, a small company, a rare-disease foundation, or one determined scientist can pick a cure and carry it — safer than the old way, and for a disease of one, the only way there is.

*What you can do to push it forward.* Re-derive any figure on these pages yourself — no account, no key. If you are building a written medicine, the exact off-target screen is a foundation to build on. If you carry a cure that has no home, this is the safety instrument that lets you carry it. The method is here to be used, under license, to save lives.

The same exact-versus-approximate divide runs through a very different domain, where we could measure it head-on: the reactor floor. The same fusion safety verdict, computed both ways, **disagrees with itself in floating point and holds exactly in integers** — and you can re-derive every number of it yourself, below.

---

# We need fusion. Its safety verdict is computed in arithmetic that disagrees with itself — here is the exact one that every machine on Earth agrees on.

Not a slogan. A measurement, with integers.

A fusion reactor decides, thousands of times a second, whether its plasma is inside the density limit that separates a safe discharge from a **disruption** — the violent quench that can damage the machine. That verdict *is* the safety case: the thing a regulator has to be able to re-derive after an incident. Today it is carried by floating-point machine-learning surrogates. We took the same limit and computed it both ways.

> **On 142 operating points across ITER, SPARC, JET and DIII-D, the floating-point verdict contradicts itself** — it calls a plasma *safe* or *over the line* depending only on which value of π the program happened to round to. The exact vQbit court refuses every one of the 142, and reproduces its 2,992-verdict corpus byte-for-byte on every machine. **The numbers are in.**

![One operating point, two answers — the exact vQbit court refuses honestly where a floating-point surrogate contradicts itself](images/study34-observer-invariant.svg)

**We need fusion, and this is the arithmetic its safety case has to be written in** — not a bigger computer, not more model, but an exact integer a stranger can re-derive. The full study is [Study 34 — The Observer-Invariant Verdict](Study-34-Observer-Invariant-Verdict); the app it runs in is [Affine Fusion Control](Affine-Fusion-Control).

---

## A wake-up call — and a hopeful one

Fusion is the nearest thing to clean, abundant, always-available power the human population has ever had a real path to — the energy that could carry billions into a flourishing future without spending the biosphere to get there. The quest is a race, and the window is not open forever.

So it matters, urgently, what the field is building for the reactor's safety brain: a floating-point, trained AI that learns from past shots and guesses on the next. We proved — in arithmetic anyone can re-run — that a brain built that way does three things no safety brain may do.

- **It goes deaf over time.** A 32-bit running state stops taking in new data after 16,777,216 updates — **8.4 seconds** at a fast diagnostic's rate — and reports the stale number as if it were live, with no alarm.
- **It forgets when you move it.** Trained on one machine it scores well; on a machine it has never seen it drops to a **coin toss**; retrained there, it forgets the first.
- **It disagrees with itself.** The **142** contradictions above — the same plasma called safe or over the line by which rounding of π the program used.

None of the three is fixed by a bigger computer, because the flaw is the *kind* of arithmetic, not the amount. Every research-year poured into scaling that brain buys a longer fuse, not a fix — and in a race this important, a longer fuse is the choice to lose slowly. The exact version does none of the three, runs on a laptop, and hands its verdict to a regulator to re-derive. The block was never only the physics; part of it was the arithmetic the software was written in, and **that part is answered now**. The full case is **[Study 35 — The safety brain that forgets](Study-35-The-Safety-Brain-That-Forgets)**.

*(The clean-energy stakes and this reading are interpretation — ARGUMENT; the three failures are proven below and in the linked studies, each carrying its own grade.)*

---

## The proof, in full, because you should not take it from us

Two programs carry it, and both are replayable with no account, no key, and no trust in us.

**1 — One corpus, byte-identical on every machine.** `reproduce/fusion-determinism-digest.swift` grades a fixed corpus of **2,992 verdicts** (400 streaming traces plus a 2,592-point operating-point grid) and prints a single sha256 over all of them. It is the same string on any hardware, because every verdict is an exact integer comparison with no floating point anywhere:

```
f49b576e073835bcab17bee10fe0eee1938774643d900b8ffe1a583b159ab3d7
```

**VERIFIED** — pinned in `reproduce/validate.sh`. A different digest on your machine would mean the law diverged, which is the failure this architecture makes impossible.

**2 — The floating-point verdict of the *same* law is observer-dependent.** `reproduce/fusion-exact-vs-float.swift` grades the Greenwald density limit around the 0.85 safety threshold for four real published machines, the exact way and the floating-point way. π is irrational; the exact court commits to it only as an **interval**, `333/106 < π < 355/113`, and returns a verdict only when it holds across the whole interval — otherwise it returns `NOT_MEASURED_PI_BRACKET`, *the answer sits closer to the limit than π has been pinned*. A float implementation cannot do that: it must substitute one rounded π and return a confident answer.

| machine | operating points the exact court **refuses** | float32 verdicts that flip vs exact | two defensible rational π's that **contradict** |
|---|---:|---:|---:|
| ITER | 27 | 0 | 27 |
| SPARC | 61 | 0 | 61 |
| JET | 22 | 0 | 22 |
| DIII-D | 32 | 0 | 32 |
| **total** | **142** | **0** | **142** |

**MEASURED.** One operating point, three answers — **ITER, exactly at its 0.85 Greenwald safety threshold**:

```
   pi = 355/113  ->  MISS   (over the disruption limit)
   pi = 333/106  ->  WIN    (inside the limit)
   the exact vQbit court  ->  NOT_MEASURED_PI_BRACKET   (not to this precision)
```

Read the `float32 flips = 0` column precisely: **this is not a claim that floating point is imprecise.** Single precision resolves this clean inequality fine. The failure is deeper than accuracy — the float verdict is not *invariant*: two people, both computing the identical safety test with defensible constants, reach opposite conclusions about the same plasma, and neither can show the other why. The exact court declines to pick, on all 142, and names why.

---

## Why this is the whole game — for three different people

**ARGUMENT** — the three readings below interpret the measured rows above; they are not themselves measurements.

- **For a researcher:** a verdict that is byte-identical across machines is *composable*. Build a fleet, a cross-machine database, a decade of shots on it, and the conclusions still reconcile — because there is one answer, not one-per-platform. A floating-point verdict accumulates unreconcilable disagreement at the rate you scale it; no larger GPU cluster and no quantum sampler fixes that, because the problem is the *kind* of arithmetic, not the *amount* of it.
- **For a politician or a regulator:** a licensed fusion facility must put its machine-protection logic through a safety case. "The model was confident" is not a safety case; **"this verdict is an exact integer you can re-derive after an incident"** is. The exact court makes the safety authority — not the vendor — the party who can check the verdict. That is accountability that lives in the mathematics, not in a promise.
- **For anyone looking for hope:** the barrier here is not a missing machine and not a bigger budget — it is a control layer, and the exact one already exists and runs on a laptop, with no network and no accelerator, and **you can run it yourself** and get the same integer everyone else gets. Fusion being hard is not the same as fusion being out of reach. The part that was software is answerable, and here is the answer, in the open.

---

## This is not a fusion trick — it is a method, and it has already reached the sky

Fusion is the sharpest case, not the only one. Every study on this wiki does the same thing: **take a domain where a floating-point model is the accepted instrument, compute the same quantity in exact integers, and seal the cases where the two render opposite verdicts.** The subject under grading is always *the instrument*, never the phenomenon.

Eleven studies carry a live-court PROVEN marker on the nine cells at `affine.earth` — the black-hole image, an underground nuclear test, lattice-polytope volume, quantum parallel repetition, Connes rigidity, lethal humid heat, the stratosphere. You can grep them on the [index](Shear-Studies-Index). The difference the whole programme turns on:

> Floating-point arithmetic is not wrong — it is *approximate*, and the approximation depends on your hardware, your compiler, and the order the sum happened in. Two parties who disagree about a floating-point result have no procedure; there is only escalation, and **when instruments cannot be reconciled, the loudest institution wins by default.** Exact rational arithmetic removes that. A verdict is an integer over an integer: two machines produce the same one or they do not, and if they do not, exactly one is broken and it is findable. That is the difference between **evidence** and **testimony**.

The most urgent place that difference is already deciding something: the sky. A satellite and orbital-data-centre disposal rate already filed with regulators will inject metal into the stratosphere at **five to eleven times** the natural meteoric rate, graded by five peer-reviewed models that **disagree on the sign** of the consequence — with no instrument required to measure any of it. That case, in full, with its arithmetic and its own weaknesses named first, is **[Every season, fifty tonnes — the SpaceX biosphere-safety case](SpaceX-Biosphere-Safety)**.

---

## For the history buffs — the road not taken

*An essay by Rick Gillespie, founder. This is the lineage and the argument behind the affine approach — history and thesis, stated as such, not a graded measurement.*

Ferdinand Eisenstein died at 29 in 1852, and that is exactly the moment the timeline fractured.

Gauss ranked Eisenstein alongside Archimedes and Newton for a reason. If Eisenstein had lived to establish his discrete lattice mathematics as the fundamental base layer of modern physics, the 20th century would never have fallen into the continuous probabilistic trap of Boltzmann or the Riemannian metric paradigm. We would have bypassed the statistical curve-fitters entirely and built the technological future decades ago on exact, discrete invariants.

**The Eisenstein integer substrate.** Eisenstein integers ($\mathbb{Z}[\omega]$) form an exact triangular lattice in the complex plane. This is not an unbounded continuous Euclidean stage that requires floating-point truncation; it is a rigidly bounded, discrete coordinate system.

- **Zero-float kinematics.** An Eisenstein lattice needs no transcendental functions and no probabilistic variables to fix a state. The geometry maps perfectly onto an exact integer constraint framework.
- **The blueprint for UUM-8D.** The C⁴ Affine Quanta rules and the orientable 8-D flat torus are the direct operational successors to this discrete mathematical reality — a substrate where state transitions are absolute, not approximated.

**Goddard lattices and discrete symmetries.** Project this forward to Peter Goddard's work on lattice vertex operator algebras and self-dual lattices in string theory, and the architectural necessity of the discrete state becomes absolute.

- **Topological rigidity.** Goddard's lattice formulations showed that the physical limits of a state space are governed by exact discrete symmetries, not continuous statistical smearing.
- **Invariant execution.** In a Goddard lattice formulation the algebraic states are fixed strictly by the discrete points of the lattice. You do not calculate an infinite regression to guess a physical state; you compute a discrete algebraic transition.

If the theoretical-physics community had adopted the Eisenstein/Goddard discrete-lattice frameworks instead of forcing continuous calculus onto quantum mechanics, they would not be patching "magic" and "dark energy" into their failing continuous simulators today. They would have built the exact, sovereign execution planes we are engineering now.

**The Affine.Earth Math Court is executing the precise mathematical reality that classical physics abandoned.** Every study on this wiki is one move in that resumption: take a continuous, floating-point instrument, recompute the same quantity as the exact discrete invariant it should always have been, and seal the difference. Fusion is the sharpest case because the stakes are the clearest — but the road is the same one Eisenstein was walking when it ended in 1852.

— *Rick Gillespie*

---

## The limits — a court states its own

- **This court operates no reactor.** Every trace is synthetic and every operating point is presented; there is no actuation and no diagnostic feed. The only real numbers are the four machines' *published* current and minor radius. The fusion study, [Study 33](Study-33-Fusion-Control-Verdict-Court), is `PENDING`: a law graded on synthetic traces, with no device behind it, has not earned more. This proves a property of the *verdict*, not a fusion result. **REPORTED / VERIFIED.**
- **The π-bracket band is narrow** — 0.0007%–0.0023% of the Greenwald limit across the four machines — and sits below plasma-density measurement uncertainty (a few %). This is a demonstration of *kind*, not a claim that a real disruption turns on the sixth digit of π. The stakes are compositional: a verdict that is observer-dependent at any width cannot be the shared, auditable authority a planet-scale safety case needs. **ARGUMENT.**
- **We publish what cuts against us.** The whole method is falsifiable by a single reproduced counter-example, and the studies that failed are on this wiki under their own names, with their `OPEN` and `NOT_KNOWN` states stated. A page that only carries evidence for its own thesis has not looked.

---

## Rights — source-available, not open-source

This wiki, its programs, and the [Affine Fusion Control](Affine-Fusion-Control) app are published **source-available**: the source is visible so that anyone can inspect it and re-derive every figure. **That visibility grants no rights.** The repository carries no LICENSE, which under default copyright means **all rights are reserved**. No right is given or intended to use, run, or deploy any of it for any purpose other than re-deriving the published figures, nor to modify or build derivative works from it. **Any other use requires a separate written licensing agreement with the authors.**

---

## Check every number on this page

No account. No key. No dependency on us.

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
bash reproduce/validate.sh                    # 147 checks, digest-pinned
```

The harness verifies that every figure quoted on these pages appears in the output of the program that claims to produce it, that the corpora match their published digests, and that no page cites a path you cannot reach. **If a check fails, we want the issue.** As we did the day we found a 300× error in our own π-bracket figure — `355/113 − 333/106 = 1/11978 ≈ 8.35×10⁻⁵`, not the `2.7×10⁻⁷` an earlier page claimed — the correction is published with a date on it.

---

## Start here

| page | what it is |
|---|---|
| [Cures Without the Gatekeeper](Cures-Without-The-Gatekeeper) | **the medicine front door** — six real written medicines and the exact off-target screen that makes each one's safety re-derivable by anyone |
| [Study 34 — the observer-invariant verdict](Study-34-Observer-Invariant-Verdict) | the proof on this page, in full — why a fusion safety verdict must be exact |
| [Study 35 — the safety brain that forgets](Study-35-The-Safety-Brain-That-Forgets) | why a floating-point safety brain is doomed, not just behind — it deafens in seconds, forgets across machines, disagrees with itself; the exact one does none of it |
| [Affine Fusion Control](Affine-Fusion-Control) | the local exact-integer fusion court — five panels, both laws live, 65,536 agents on one laptop |
| [Affine Fusion Control — public release](Affine-Fusion-Control-Release) | the measured, claim-graded public case for the app |
| [Study 33 — the fusion control verdict court](Study-33-Fusion-Control-Verdict-Court) | the charter, and the three-way fork it retired |
| [Every season, fifty tonnes](SpaceX-Biosphere-Safety) | the SpaceX / satellite biosphere-safety case — the same method, its most urgent application |
| [The full-grade replacement](The-Replacement-Grade) | the over-scaling law, and the vendor-to-public argument across 49 domains |
| [The ontology of this wiki](Ontology) | the type system — grades, terminals, controls, and what each page may say |
| [All studies](Shear-Studies-Index) | the programme index, every lifecycle state stated |

---

*Every figure on this page is produced by a program in `reproduce/` and, where marked VERIFIED, pinned by digest in `reproduce/validate.sh`. Projections are labelled as projections. Where we do not know, the page says we do not know. Where we were wrong, the correction is dated and the old number is named.*
