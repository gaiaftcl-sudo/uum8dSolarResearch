# Study 47 — Translation shear: the meaning that survives a language, and the meaning that does not

**Status: LAW FROZEN · LIVE CLAIM** — the design of the measurement below was written before the run
and has not moved, and the court answers in public on the nine cells right now. Measured for the
exact court, first run 2026-09-11 and again fleet-wide 2026-09-12 (see "What was measured" below).
**The generative comparison arm is ABSENT: there is no generative translator in the stack.** The language strip at the top
of the home renders the site chrome from sealed templates for five languages and shows the English
source, marked as such, for everything the court refuses. The exact projection court this page
describes is served on the nine cells; it refuses every word it cannot project and names it. The
design of the measurement below was written before the run and has not moved.

---

## The instrument under grading

A generative translator turns a sentence into floating-point vectors and samples a target string at a
temperature. Because it samples, the same input can return different outputs on different runs or
different models. **The subject under grading is that instrument, never the languages.**

The projection court takes the opposite discipline. Meaning is held as an invariant in the discrete
lattice; a language is a chart ψ over that invariant; translating from A to B is the transition map
ψ_B⁻¹ ∘ ψ_A, computed in integers. No float, no temperature. If the transform preserves the invariant
the target string is emitted; if it does not (shear residual ≠ 0) the court refuses; if a chart is
absent the court refuses; if the source language is not stated the court refuses — it does not guess
a source.

## The measurement, frozen before the run

- **The statement set.** N = 100 source statements, each carrying at least one exact token: an
  integer dose, an interval, a negation, a modal ("must", "must not"), a named entity. The set is
  committed and digest-pinned before any translator is called; no statement is added or removed
  after.
- **Runs.** K = 5 calls per statement per instrument, plus one round trip A→B→A.
- **Drift.** A statement drifts under an instrument when its K target strings are not byte-identical.
  Each target's SHA-256 is kept, so drift is re-checkable from the digests without keeping the text.
- **Token shear.** For each exact token in a statement, a shear event is a target in which that token
  is absent, altered, or negated while the source was not. Counted per instrument, per token class.
- **Round-trip residual.** One definition, used everywhere: the integer count of exact tokens in the
  source that are absent or altered after A→B→A. The court is required to return residual 0 or refuse.

Every reported figure is an integer count. Baseline target texts are not republished; their digests
and the quoted shear pairs are.

## What this study can and cannot call

**If the counts come back as designed,** the study will call: *the generative instruments tested
drift and shear exact tokens at the counted rates; the projection court, on every pair for which a
chart existed, returned residual 0 or refused, and never returned a drifted target.*

**It will not call,** whatever the counts: that the projection is better prose, more fluent, or more
natural — fluency is not graded here; that any translated sentence is fit for a clinical decision —
no page on this wiki grades that; or anything about a language pair whose chart did not exist at run
time — those pairs are recorded as **ABSENT**, refused by the court, and are not estimated.

## What must exist before the run

- **Material.** A sealed bond cannot chart a language, and this study measured that rather than
  assuming it: a bond keeps a 3-D centroid of one weight row and carries no token id, and over the
  same 3,125 Spanish members the expected translation ranks 1 under the court's 4,096-cell order for
  all eight probe pairs and 222nd to 3,019th under the centroid. The bonds prove a row was mined; the
  row is what separates the words. So the court reads the rows the bonds are sealed from, the same
  way and by the same quantiser, and digests each row by the rule a bond carries as its s2.
- **The court.** `AffineTranslateCourt.swift` + `AffineLatticeChart.swift`: served on the nine cells
  as `affine_translate_text`. A sealed template hit renders; otherwise the ψ chart derived in RAM on
  each cell from the raw BF16 rows of a pinned public shard, with a per-word refusal (not a member,
  round trip open, spelling shared with a third language) and a refusal for an unstated source.
- **The charts.** Derived in context on every start, never written: membership from the sealed
  templates and a pinned public dictionary per language, rows from the pinned shard, the exact
  256-bit cosine order, the round trip. Whether a usable chart could be derived from the bonds
  themselves was a result of this work: it cannot, for the reason under Material.
- **The runner.** `scripts/study-47-translation-shear.sh` in the substrate repository: takes the
  pinned statement set, calls the court K times per statement on every cell by address, keeps the
  targets and their digests, and prints every figure this page carries.

## What was measured on 2026-09-11 (first run — the court alone; no generative instrument was called)

**Status: MEASURED for the exact court, en→es. The generative arm of the charter is not run: no
generative translator is in the stack (founder, 2026-09-11), so the comparison column stays ABSENT.**

### The court that answered

`affine_translate_text` on the nine cells. Two exact paths, no model:

1. **The sealed template** — a source string and its projection sealed by a named author, data on
   the cell. Interface strings only today (36 per language, five languages).
2. **The ψ chart, derived in context** — nothing written anywhere. On every start each cell reads the
   raw BF16 rows of `model.language_model.embed_tokens.weight` from `Qwen/Qwen3.5-9B` at revision
   `c202236235762e1c871ad0ccb60c8ee5ba337b9a` (2,034,237,440 bytes, by HTTP Range, header
   digest-pinned), decodes each row bit-exactly and quantises it onto the 21-bit lattice with the
   corpus bonds' own rule, and keeps the rows of the language members in RAM. A language's members
   are the words of the sealed templates plus the headwords of a public dictionary
   (LibreOffice/dictionaries at `32b006a2c22a4ac7e8ed3f03346f7b3d85a970a4`, sha256 per file) that are
   single tokens. A word projects to the member of the target language nearest under
   sign(p·u)·(p·u)²/(|p|²·|u|²), compared by cross-multiplication in 256-bit integers, ties to the
   lower token id; it renders only if the round trip returns it, it is not the same token, and its
   spelling is not also a word of a third language. Each row is digested by the rule a mined bond
   carries as its s2 — the same rule, on the same bytes.

**What that digest ties, and what it does not.** It is a rule, not a provenance. No bond in the live
corpus was sealed from this tensor: the mining registry holds no Qwen3.5-9B, the default mining mode
excludes tensors whose name contains `embed`, and 0 of the court's 947 distinct row digests appear
among the 7,941 distinct bond digests in a pinned 8,192-bond window of the feed. Mining this model's
embedding rows would close that gap; this page does not claim it is closed.

**Why the rows and not the bonds.** A bond keeps a 3-D centroid of its row, and measured on the
court's own rows every centroid sits within about a thousand of the lattice centre 1,048,576 —
the centroid is the row's mean, and a row's mean is very near zero. Ranked over the same 3,125
Spanish members, with each row's exact dyadics handed to the bond sealer itself:

| probe | rank of the expected translation under the court's order (4,096 cells) | rank under the bond's centroid (3 numbers) | what the centroid picks instead |
|---|---|---|---|
| cat → gato | 1 | 1,671 | dalla |
| dog → perro | 1 | 3,019 | participante |
| house → casa | 1 | 2,878 | elegir |
| king → rey | 1 | 222 | banco |
| book → libro | 1 | 601 | atractivo |
| water → agua | 1 | 1,832 | violencia |
| world → mundo | 1 | 510 | máscara |
| time → tiempo | 1 | 820 | paseo |

The bonds prove a row was mined; the row is what separates the words. Re-run it with
`gaiaftcl gaiaftcl-os translate-chart bond --source en --target es`, which calls
`OmniMinerJordanBond.bond(row:)` — the sealer, not a copy of it — on the rows the court serves from.

### The statement set

100 statements, committed and digest-pinned before the run:
`reproduce/study-47/statements.v1.txt`, sha256 `c0d3dc7db0ab09c90ef01fcbc774f5689297654ae2ec1077c612d15d63e9403a`.
Every statement carries at least one exact token — an integer, an interval, a negation, a modal or
a named entity.

### Figures, en→es, over the 100 statements (660 words)

| | count |
|---|---|
| statements rendered whole | 0 |
| statements refused, a word not a member | 78 |
| statements refused, a word's round trip did not close | 22 |
| words that are members of English | 530 |
| words whose round trip closed | 115 |
| of those, rendered — the target spelling belongs to Spanish alone | 54 |
| of those, withheld — the target spelling is also Italian, Portuguese, French or German | 61 |
| words not members (mostly inflections the dictionary lists as affixes: *hours, minutes, days, has*) | 130 |

The words that never close are the function words. Over the 100 statements *the* occurs 103 times and
closes 0 times in every one of the five pairs; *and* 20 times, 0; *in* 9 times, 0; *of* 3 times, 0. A
word-level projection has no seat for an article's gender or a verb's person, and the round trip says
so every time. Three function words are the exception, and none of them in Spanish: *is→ist* (37 of
37) and *not→nicht* (21 of 21) close and render in German, *not→pas* (21 of 21) in French. Four more
close onto a spelling another language shares and are withheld: *must→deve* (16) in Italian and
Portuguese, *a→à* (10) in French and Portuguese, *from→dari* (4) in German and Italian, *not→niet*
(21) in Italian. The words that do close in Spanish are nouns and a few verbs:
*battery→batería, blood→sangre, book→libro, bridge→puente, city→ciudad, day→día, eye→ojo,
heart→corazón, horse→caballo, island→isla, king→rey, mountain→montaña, night→noche, pressure→presión,
queen→reina, rain→lluvia, vaccine→vacuna, wind→viento, winter→invierno, word→palabra, year→año*.

Withheld by the shared-spelling rule, and correct Spanish in every case but two: *cat→gato,
dog→perro, house→casa, water→agua, world→mundo, take→tomar, never→nunca, because→porque, before→antes,
between→entre* — and the two that show why the rule exists: *on→sur* (the French *on*; *sur* is
Spanish *south*) and *rose→roses*.

Rendered and wrong, because the dictionary lists the target: *million→juta*, *screen→layar*,
*dose→doses*, *sea→seas*, *bus→buses*. The court's claim is the projection onto the dictionary's
words, not the dictionary; a headword the dictionary should not hold is the dictionary's entry to
correct, and the projection names it.

### The other four pairs, same statements, same rules

| pair | round trip closed | rendered (spelling belongs to the target alone) | withheld (spelling shared with a third language) | statements rendered whole |
|---|---|---|---|---|
| en→es | 115 | 54 | 61 | 0 |
| en→fr | 149 | 100 | 49 | 0 |
| en→de | 169 | 142 | 27 | 0 |
| en→it | 138 | 56 | 82 | 0 |
| en→pt | 130 | 42 | 88 | 0 |

The source side is the same in every pair (530 member words, 130 not members), so the refusal
counts per statement do not move; what moves is how many closed projections a target language keeps
for itself. German keeps most (its spellings are its own); Portuguese keeps least (it shares most of
its nouns with Spanish and Italian).

### Drift, cell shear and the round trip

The pinned set went to the court on all nine cells, five pairs, K = 5 calls per statement per cell —
225 batched calls, 450 requests, each addressed to a named cell rather than to the apex, because the
apex round-robin hides a one-in-nine straggler.

| | count |
|---|---|
| statements whose five targets on one cell were not byte-identical (drift) | 0 of 100, in every pair |
| statements whose target differed across the nine cells (cell shear) | 0 of 100, in every pair |
| pairs in which the nine cells reported one lattice digest | 5 of 5, `a053fbf73022aaae…` |
| statements refused because a word is not a member | 78, identically on every cell |
| statements refused because a word's round trip did not close | 22, identically on every cell |

**The round-trip residual has nothing to count at statement level, and that is the honest reading.**
No statement renders whole, so there is no A→B→A string to compare, and the residual is 0 by vacancy
rather than by success. The round trip is not skipped: it *is* the render condition. A word is
emitted only when the projection of its projection is the word again, which is exactly why those 22
statements are refused.

The same instrument caught the defect it was built for, on the way. For a few hours the nine cells
ran two builds, and the four on the earlier one each reported a **different** lattice digest
(`3fcc755d…`, `2b5a309d…`, `431c2877…`, `b8876b26…`) while the five on the fixed build all reported
`a053fbf7…`. The cause was member slots being numbered while walking a hash set, so slot order
followed each process's own seed. Nothing the court *answered* was wrong — the projection order is
total, so the nine agreed on every string — but the digest that is supposed to prove nine machines
computed the same charts did not. It does now:
The identity gate, `prove-translate-court-identity.sh`, passes on the live fleet and refuses a
mutated digest, a still-warming cell, and an empty fleet.

### What this run calls

- **The court is one machine.** Nine cells derived their charts independently, in memory, from the
  same pinned public inputs, and agreed on one lattice digest, one row count, one set of member
  counts and one answer per call. Five calls per statement per cell produced no drift, and no
  statement's target differed between cells. The Mac, building the same source for a different
  processor and a different operating system, derives the same digest.
- **It refuses far more than it renders, and it names what it refuses.** Of the 100 statements it
  rendered none whole: 78 carry a word that is not a member of English as the chart states it, and 22
  a word whose round trip does not close. Of the 530 member words, between 115 and 169 close
  depending on the pair, and between 42 and 142 render.
- **A word-level projection over the raw vectors renders content words and refuses function words.**
  It does not render a sentence. That is the measured shape of this instrument, not a defect to be
  hidden; phrase charts over the sealed sentence pairs are a separate study.

### What it refuses to call

Anything about fluency; anything about a language pair whose members are not stated (nineteen of
the twenty-five languages on the strip); anything clinical.

## Related

- [Study 34 — the observer-invariant verdict](Study-34-Observer-Invariant-Verdict) — why a safety verdict needs an exact law
- [Study 35 — the safety brain that forgets](Study-35-The-Safety-Brain-That-Forgets) — what a floating instrument does across machines
- [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm) — the method in one page
