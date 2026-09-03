# The ontology of this wiki

**Why an ontology page exists at all:** this wiki holds 34 studies across black holes, protein structure, seismology, density functional theory, quantum complexity, heat mortality, and the stratosphere. Without a stated type system that reads as a pile of unrelated enthusiasms. With one, it reads as what it is — **one method, applied 34 times, with its losses published** — and that is the difference between a body of evidence and a body of opinion.

Every claim on these pages carries a type. The types are not decorative. They constrain what a page is allowed to say, and they are the reason a stranger can grade us without trusting us.

---

## The one method

Every study on this wiki does the same thing:

> Take a domain where a **continuous, floating-point model** is the accepted instrument. Compute the same quantity in **exact integers or rationals**. Seal the cases where the two render **opposite verdicts**. Publish the losses.

That is the *shear*: the gap between the continuous form and the exact form, measured rather than argued. The subject under grading is **always the instrument**, never the phenomenon. Study 07 does not claim to know what Sgr A* looks like; it grades whether a normalisation step survives contact with the raw visibilities. Study 28 does not model human physiology; it grades whether an operational heat formula's own published error band is verdict-sized at a survivability line.

**Study 29 is the 29th application of that method, and the atmosphere is where it landed on something life-threatening.** That ordering matters and it is checkable: the method predates the finding. We did not build a court to attack a company. We built a court, ran it 28 times, and the 29th run hit the sky.

---

## Type 1 — Evidence grades

Every factual assertion carries one of these, and pages state them inline in capitals.

| grade | what it means | what it forbids |
|---|---|---|
| **VERIFIED** | fetched and read this session, from the named source, with the row or sentence quoted | nothing — this is the strongest grade, and it still shows its work |
| **REPORTED** | a real published figure, carried as reported wording because the source blocked or paywalled a live fetch | quoting it as verbatim; asserting it as measured by us |
| **CITED / NOT MEASURED** | the literature says it, we have not reproduced it | using it in a seal, or in any arithmetic that reaches a verdict |
| **MEASURED** | produced by a program in `reproduce/`, over a corpus pinned by digest | drifting from the program's actual output — the harness checks this |
| **PROJECTION** | a measurement scaled by a stated assumption | appearing without its assumption and its falsifiers on the same page |
| **ABSENT** | the source exists but serves nothing; measured, with the method of measurement stated | being reported as a failure of the study rather than of the archive |
| **NOT_KNOWN** | the honest edge. The question is well-posed and we cannot answer it | being softened into a hedged version of the answer we would prefer |

**`NOT_KNOWN` is a terminal, not a failure.** A study that reaches it has produced a result. The alternative — rendering a verdict the data does not support — is the single failure mode this whole apparatus exists to prevent.

---

## Type 2 — Study lifecycle states

A study moves through these, and the index states which one each study is in today.

| state | meaning |
|---|---|
| **STANDING CHARTER, NO RUNNABLE CORPUS** | the law is written and frozen; the archive does not yet serve what it needs. The charter is honest about waiting. |
| **OPEN** | we do not have the data. Named as such, never dressed as in-progress. |
| **CHARTER WITH ARCHIVE** | the archive serves; ingest has not run. Distinct from OPEN, because the blocker is different. |
| **PARTIAL_CORPUS_SEAL** | some arms sealed, others void. Both halves published. |
| **LAW FROZEN** | the thresholds and the grading rule are fixed before the corpus is graded, and cannot move afterwards. |
| **DATA SEALED** | corpus pinned by digest, verdicts sealed against the frozen law. |
| **LIVE CLAIM** | the court is reachable and answers in public, right now. |

**Freezing the law before grading is the load-bearing rule.** A threshold moved after seeing the data is not a threshold; it is a decoration on a conclusion already reached.

---

## Type 3 — Verdict terminals

A court returns exactly one of these. They are distinct answers and are never collapsed into each other.

| terminal | meaning |
|---|---|
| **WIN** | the exact form verified the presented claim |
| **MISS** | it did not |
| **REFUSED** | the input was malformed, or fell outside the instrument's published validity domain — no verdict was rendered |
| **VOID** | the run is discarded, not scored. A partial result from a compromised run is void, never partial. |
| **ELEMENT_MISSING** | the source answered with absence |
| **NOT_KNOWN** | the edge |

**`ABSENT` and `REFUSED` are different answers, and both differ from `MISS`.** A station that reports nothing has not said "below threshold." Collapsing absence into a verdict is how a dataset silently invents data, and the courts here are built to keep them apart.

---

## Type 4 — Control arms, and the rule that governs them

Before a court grades anything, it must be shown able to fail. Every study seals its controls first.

- **Always-green control** — an input where every arm must agree. If it disagrees, the scorer is broken and no physics is scored.
- **Always-red control** — an input that must fail. Where one cannot honestly be constructed, the page says so and substitutes a **refusal arm** rather than fabricating one.
- **Absence control** — a real feed row carrying a missing sentinel. The court must print `ELEMENT_MISSING`, never a substituted default.
- **Guard band** — a flip may only be sealed within a frozen distance of the threshold. Outside it, disagreement is an instrument defect.
- **Flip ceiling** — a near-threshold census that flips more often than a coin is not reading a real band; it is reading its own noise, and is retired on the page.

> **An instrument that always passes and an instrument that always fails are the same defect.** Both have zero discriminating power. This is the most frequently violated rule in scientific tooling and it is checked explicitly here, on every court, before any result is claimed.

---

## Type 5 — Page classes

| class | what it holds | example |
|---|---|---|
| **Charter** | the frozen law: thresholds, grading rule, loss conditions, controls — written before the corpus | [Study 28](Study-28-Wet-Bulb-Threshold-Court) |
| **Corpus** | the pinned data, by digest, with provenance | [Study 06 corpus](Study-06-Explosion-vs-Earthquake-Corpus) |
| **Results** | verdicts sealed against the frozen law | [Study 11 results](Study-11-Ehrhart-Volume-Results) |
| **Registry** | the append-only record of what was sealed when | [Study 07 registry](Study-07-SgrA-Milky-Way-Registry) |
| **Impact study** | what a sealed result means for a field that relies on the sheared instrument | [Fourier Phantom](Impact-Study-Fourier-Phantom) |
| **Index / guide** | navigation and method, holding no claims of its own | [Shear Studies Index](Shear-Studies-Index) |
| **Public case** | the human-facing argument, carrying only claims typed above | [Ask someone you trust](Ask-Someone-You-Trust-To-Check-This) |

A Results page may not contain a claim absent from its Charter's grading rule. A Public case may not contain a figure absent from a Results page. **The direction of flow is one-way, and the validation harness enforces it** by checking that every figure quoted on a public page appears in the output of the program that claims to produce it.

---

## The edges

Pages are nodes; these are the relations that make it a graph rather than a list.

| edge | meaning |
|---|---|
| `produced_by` | this figure comes from that program in `reproduce/` |
| `pinned_by` | this corpus is fixed at that sha256 |
| `frozen_before` | this law was sealed before that corpus was graded |
| `refuted_by` | this claim of ours is contradicted by that published source |
| `favours` | this evidence supports the party we are criticising |
| `resolves_to` | this domain's exact form reaches this rational |

**`refuted_by` and `favours` are first-class edges, and pages are required to carry them.** The reentry pages carry four facts that cut against our own concern, including one model reporting the opposite sign and one propellant finding that scores the operator we criticise *well*. A page with no `favours` edge has not looked.

---

## The identity every domain is graded against

> **entropy_bare − entropy_delta = entropy_resolved = 1/1**

The continuous form of a law carries excess structural entropy, always greater than one. Adopting the exact form removes precisely Δ. What remains is unity: one answer, replayable by anyone, on any machine.

Across the 49-domain mesh — the biosphere domain joined the 48 on 2026-09-01 — **nine domains currently satisfy it.** The rest are listed as work in progress, by name.

**The atmosphere domain does not satisfy it.** Its forcing side resolves to 1/1 by counting. Its response side is stuck at 6/1, and counting cannot finish it — because the residual is not a harder sum, it is **a measurement nobody has taken**. That is the whole planetary argument, expressed in the ontology's own terms: not "the sky is falling," but *this domain cannot be resolved because the instrument does not exist*.

---

## What this ontology is for

Two audiences, and the type system serves both.

**For a researcher:** every page tells you its grade, its lifecycle state, its controls, and what would falsify it, before it tells you its conclusion. You can attack any single link without having to accept or reject the whole. That is what we want. Run the harness, find a failure, and tell us — the [validation instructions](Home) take four minutes and require no account.

**For everyone else:** the reason to take the atmospheric finding seriously is not that we say so. It is that the same court, run 28 times before it reached the sky, published its losses each time — the studies marked OPEN, the ones marked VOID, the 240× of our own over-estimate that we removed by counting, and the four facts on the record that cut against our own case.

**A warning that will not correct itself is propaganda.** This ontology is the machinery that forces ours to correct itself, in public, with the corrections dated on the page.

---

**Start here:** [The planetary case](Home) · [Ask someone you trust to check this](Ask-Someone-You-Trust-To-Check-This) · [The evidence](Reentry-Forcing-Nobody-Measures) · [The method](Zero-Float-Zero-Shear-Paradigm) · [All 34 studies](Shear-Studies-Index)
