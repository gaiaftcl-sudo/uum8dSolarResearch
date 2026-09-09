# The library admission law

*What may enter a library of health and materials that strangers will use.*

**Status: LAW FROZEN and EXECUTABLE, 2026-09-07.** The law is
`reproduce/library-admission-law.swift`. It compiles with `xcrun swiftc -O -swift-version 5`,
carries **71 control arms passing in three directions**, and refuses on every constructed
violation below with the clause named. The three library pages are downstream of this file.
This page is the law's prose; the program is the law.

---

## Why the law exists, and why it is the primary artefact

A generative pipeline in this same programme reported **37,910 validated discoveries** and
contained **five distinct molecules**. Every row carried a valid molecule, a correct molecular
weight and a correct logP. Every per-row check that ran on it was right to pass it. The emitting
loop read `seeds[i % len(seeds)]`, so the row count was the loop bound and the distinct count was
a literal in the source.

**No per-item validator can see that, because no per-item validator ever holds two items at
once.** The defect did not live in any row; it lived in the relation between rows. That is
measured, sealed and published: [Study 37](Study-37-Validated-Discoveries-Five-Molecules), by
`reproduce/corpus-distinct-count-exact.swift`.

A library with no admission law is exactly that corpus with a nicer front page. It will grow a
row count and call it knowledge. So the law has two halves and needs both:

| half | what it checks | why it cannot be the other half |
|---|---|---|
| **PER-ENTRY**, E0–E14 | what one entry must carry to be admissible at all | it holds one item at a time, and is structurally blind to the defect above |
| **PER-LIBRARY**, L1–L9 | what must be true of the collection, over every entry at once | it says nothing about whether any single entry is honest, and it never holds two libraries at once |
| **FEDERATION**, F1 | whether one entry is filed in two different libraries | neither half above ever sees two libraries in the same run |

And the per-library half has one non-negotiable output: **a distinct count over the identity
field, published beside the row count, always.** One hash set and one integer. It costs less than
the per-entry check that already runs.

---

## Three terminals. They are three answers.

| terminal | meaning | what it forbids |
|---|---|---|
| **ADMITTED** | every clause is satisfied on evidence present at this grading | being read as *true*, *safe*, or *recommended* — see the refusal lines the entry itself carries |
| **REFUSED** | a clause is violated, and the clause is named | being softened into "pending" or "partial". There is no third state between admitted and refused |
| **NOT_KNOWN** | a clause cannot be decided because its evidence is not present here | being printed as either of the other two |

**A HELD entry is not in the library and is not thrown out of it.** It waits, by name. This
matters because the alternative — collapsing NOT_KNOWN into REFUSED — teaches a library to
delete work whose program simply has not been run yet, and collapsing it into ADMITTED lets a
library publish a figure nobody checked.

**An OPEN SLOT is a fourth thing and is deliberately not a terminal.** A slot is a measurement
the library has *named and does not have*: no program, no figures, no seal, nothing yet to hold.
A HELD entry has evidence that exists somewhere; a slot has evidence nowhere. Slots live in the
library manifest, are counted in no axis, and gate on nothing. Naming a slot is how a library
says what it is missing instead of quietly not having it.

---

## PER-ENTRY — the fifteen clauses

The entry is a fenced `affine-entry` block inside a Markdown page. Everything outside the block
is commentary and carries no claim. Keys are `KEY value`, one per line; `FIGURE`, `REFUSED`,
`SOURCE`, `QUOTE`, `NOTE` and `REFUTED_BY` repeat, and nothing else does.

### E0 — SHAPE
All thirteen required keys present; `LIBRARY` is one of `PROTEINS`, `COMPOUNDS`, `MATERIALS`.

**An unknown key is a refusal, not a warning.** `REFUSE` where the law says `REFUSED` is a clause
silently dropped, and the entry would then carry no refusal line with nothing to say so. A
mistyped key is the quietest way a rule stops applying.

### E1 — IDENTITY
`IDENTITY_KIND` from six, `IDENTITY` well-formed for that kind, and never a placeholder
(`unknown`, `n/a`, `TBD`, `pending`, `-`). **An entry that cannot be named cannot be found, and a
field that accepts "unknown" is not a name.**

| kind | shape | when to use it |
|---|---|---|
| `UNII` | exactly 10 of `A-Z0-9` | a substance in the public registry |
| `INCHIKEY` | 14-10-1, uppercase | a defined small molecule |
| `ACCESSION` | 4–48 chars, begins with a letter, carries a digit | a sequence or gene record |
| `GENE_SYMBOL` | 1–24, begins with a letter | an HGNC symbol |
| `CONTENT_DIGEST` | 64 lowercase hex | there is no public identifier, so the bytes are the name |
| `SPEC_NAME` | 2–40 of `A-Z0-9-._`, begins with a letter | a standardised public object with no registry number |

Two of these carry an extra obligation, because each opens a loophole the others do not:

- `CONTENT_DIGEST` requires **`DIGEST_OF`** — a bare 64-hex string names nothing to a human — and
  the digest must **appear among the entry's own `FIGURE` lines**. A library may not name a file
  that nothing in the pipeline ever saw.
- `SPEC_NAME` requires **`SPEC_AUTHORITY`**: the public body or standard that fixes the name. A
  free-text name with nobody behind it is a nickname, and this programme has already retired a
  corpus keyed on generated nicknames.

### E2 — MEASURED
Exactly what was measured, carrying a quantity. **A description is not a measurement.**

The digit must stand **free of the letters around it**. A plain digit test admitted
*"E8 is a good lattice and it works well in practice."* and printed *carries a quantity*: the 8
belongs to the object's **name** and counts nothing. A control arm holds the other direction —
the same object named with a real quantity beside it is admitted.

### E3 — PROGRAM in `reproduce/`
The named program must exist in `reproduce/`. **An entry whose claim no program produces cannot
enter.** This is the harness rule — *every published figure appears in the output of the program
that produces it* — applied to the library.

If `reproduce/` is unreadable at this grading, this clause is **NOT_KNOWN**, never a pass. *A
census that found nothing and a census that could not run are different answers.*

### E4 — FIGURE printed by that program
At least one `FIGURE`, and every one of them matches a line of that program's output **at a token
boundary** — never as a bare substring. A bare substring test admitted `FIGURE E8  : 24` against a
line printing `E8  : 240`: ten times the number, graded `MEASURED`, with the pass message asserting
the figure appeared *verbatim*. A figure is also at least 3 bytes and carries a letter or a digit,
because `FIGURE 0` and `FIGURE :` matched too. The passing message now names the transcript line
each figure matched, instead of asserting a word.

If the program has never been run here, **NOT_KNOWN** — absence is not refusal.

**A QUOTED FIGURE IS NOT EVIDENCE — corrected 2026-09-08, on a live admitted entry.**
Several programs in `reproduce/` now print their published figures on **every** exit path,
refusals included. That is right, and it is required: the wiki's own harness runs each program
with no argument and no standard input, so without it a page's figures could not be checked
against the program that produced them from a clean clone. It also broke this clause silently.
E4 matched the declared figures against the whole transcript, reaching its refusal test **only
when a figure was missing** — so a program that quoted *all* of its figures was never asked
whether it had refused, and its entry was graded `MEASURED` against a run that measured nothing.
The repair is one test moved to the front: **if the transcript is itself a refusal, every figure
in it was quoted rather than computed, and the clause HOLDS.** `generated-peptides-homology-under-substitution`
is the entry this was found on; it reads `NOT_KNOWN` in a clean clone now, and admits the moment
the screen is run.

### E5 — SEAL
Either a 64-hex seal the program actually prints, or the explicit token `NONE_PRINTED`.

Both directions are checked, and the second is the one nobody builds:
- a seal the named program does **not** print is refused — it is not that program's seal;
- `NONE_PRINTED` while the program **does** print a 64-hex seal is refused — **an entry may not
  hide a seal it has.**

Not every honest program prints a seal. **Four of the fifteen admitted seed entries declare
`NONE_PRINTED`** — the E8 enumeration, the LoRa airtime law, the unimodular reachability arms and
the observer-invariant π bracket — and a fifth does among the entries still held. They say so
rather than leaving the field blank, because *unsealed* and *unstated* are different states.

**AND THE SAME TRAP ON THE SEAL, which is the sharper half.** The old order tested
`transcript contains seal` first and only consulted the refusal test when the seal was **absent**.
A program that prints its published seal on its refusal path therefore *passed* this clause against
a run that sealed nothing — the declared seal was there, in text the program had quoted. **Appearing
and being computed are two different things.** E5 now tests for a refusal before it looks for the
seal, and says so in the held message. Three control arms hold both repairs, and the third is the one
that matters: **the same entry against a COMPLETE run must still ADMIT**, because a guard that always
holds is the same defect wearing the other face.

**THE CONTRACT — the weakness this page named as open work, closed the same day.** Six hours
earlier this paragraph read *"the refusal detector is keyed to spellings … the durable fix is a
contract: one declared line every refusing program prints, and a delimited block around quoted
reference figures … named as open work, not claimed as done."* A second session building two
unrelated studies read that, implemented it in both of its programs without being asked, and said
so. The law reads it now, and the spelling list survives only as a fallback for programs that have
not adopted it — a vocabulary can only ever be as complete as yesterday.

```
RUN_TERMINAL  COMPLETE                  this run computed a verdict
RUN_TERMINAL  REFUSED  <reason>         this run computed nothing, and says why

--- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
  … the figures the page carries, so a reader with no corpus can still check them …
--- END QUOTED REFERENCE FIGURES ---
```

**Two properties, and the second is the one a refusal test alone cannot give you.**

**A declared terminal is final in both directions.** `REFUSED` is a refusal whatever the prose
says — and `COMPLETE` is **not** a refusal whatever the prose says. That second half is not
symmetry for its own sake: a completed run whose quoted block contains the sentence *"a gate given
nothing must not pass"* would otherwise be read as a refusal by the fallback and **held**, and a
false NOT_KNOWN is a defect exactly as a false ADMIT is. Arm 51 is that case, in that direction.

**A figure between the fences was quoted, not computed — even on a COMPLETE run.** This is the
half the refusal test cannot reach at all. A program that runs to completion *and* prints its
published reference block would have those quoted figures credited to the run. E4 and E5 now read
the **computed region** — the transcript less every fenced block — independently of each other, so
a run can print its figures and have its seal refused, or the reverse. An unclosed `BEGIN` fence is
treated as quoted to the end of the transcript: the conservative direction, which can only withhold
credit, never manufacture it.

**Six arms hold it, and three of the six cut against the rule rather than for it:** a COMPLETE run
that also quotes its block must **admit**; figures only inside the fences on a COMPLETE run must be
**refused**, not held, because the run finished and simply does not print them; a declared refusal
that quotes every figure must **hold**; a declared `COMPLETE` must beat a refusal spelling in its
own quoted block; an unclosed fence must withhold; and figures computed with the seal only quoted
must pass E4 and refuse E5. **71 arms, all passing: 43 refuse, 19 admit, 9 hold.**

### E6 — GRADE from this wiki's ontology
`VERIFIED · REPORTED · CITED_NOT_MEASURED · MEASURED · PROJECTION · ABSENT · NOT_KNOWN`

Transcribed from [`Ontology.md`](Ontology), not invented. One normalisation only: the page writes
`CITED / NOT MEASURED` and the law tokenises it `CITED_NOT_MEASURED`.

**`ARGUMENT` is refused.** It was proposed for this law and it is not a grade on this wiki; and
proposing it had dropped `PROJECTION`, `CITED_NOT_MEASURED` and `ABSENT`, which are. Reading the
ontology rather than paraphrasing it restored three grades and removed one.

### E7 — GRADE supported by the evidence actually present
The grade is not a label an author picks. Each one is a claim about *how the figure was obtained*,
and the ontology already says what each demands:

| grade | what it requires here | what it refuses |
|---|---|---|
| `MEASURED` | E3 and E4 standing | a grade of MEASURED whose program or figures did not stand |
| `VERIFIED` | `SOURCE` **and** `QUOTE` | fetched-and-read asserted without the sentence quoted — *on that evidence the entry supports REPORTED at most* |
| `REPORTED` | `SOURCE`, and **no seal of ours** | a seal means we produced it, and that is MEASURED |
| `CITED_NOT_MEASURED` | `SOURCE`, and no seal | the ontology forbids a cited figure reaching a seal |
| `PROJECTION` | `ASSUMPTION` | a projection appearing without its assumption |
| `ABSENT` | `METHOD` | absence asserted without the method that measured it — otherwise it is indistinguishable from not having looked |
| `NOT_KNOWN` | nothing further | being softened into a hedged version of the answer we would prefer |

### E8 — REFUSED
At least one line saying what we explicitly do **not** call it. **An entry with no refusal line is
overclaiming by omission** — it lets a reader take the largest reading the words allow, and the
larger reading is the one that travels.

### E9 — REPRODUCE from a clean clone
A command that names its own program and carries no path private to one machine: a home-directory
tilde, `$HOME`, a macOS or Linux per-user home prefix, a macOS per-process temporary directory, a
Windows user path. Seven such tokens are in the law and it prints the count on every run; they are
not written out here, because this page is itself scanned for private references and a page that
spells the pattern it forbids turns that scan red on prose. `/tmp` is allowed; it is the house's own
canonical build target and belongs to no one.

### E10 — NOT_ADVICE travels with the entry
The standing line lives *in the entry*, not only in a preamble. **A row gets copied out of a
library.** A disclaimer that stays on the front page is a disclaimer that does not travel with the
thing it disclaims.

### E11 — NO PROCEDURE (C-007, absolute)
An entry names **what** a system is, **what** was measured about it, and **where** the law lives.
It never carries a procedure a person could follow. Three rules, and all three fire:

- **Rule A** — a fabrication verb and a quantity-with-unit on the same line.
- **Rule B** — a line that *opens* with a fabrication verb, needing no quantity at all.
- **Rule C** — three or more quantities-with-units on one line, **needing no verb at all.**

The verb list is 32 unambiguous fabrication and wet-lab operations. `heat`, `cool`, `mix`, `add`,
`stir`, `weigh`, `filter`, `culture` and `cure` are **deliberately excluded**: they are too common
in honest measurement prose, and *a detector tuned to catch a violation it will never see, at the
cost of refusing honest entries, is the always-red half of the same defect.*

**Rule C exists because that exclusion was a hole, and the hole was walked through.** Both verb
rules are keyed on a verb, and a fabrication route does not need one of ours:

> *"Combine 42 g of the powder with 5 mL of solvent, heat to 1450 C for 6 h under argon, then press
> at 12 MPa and cool at 5 C per minute"*

is a complete two-sentence procedure written **entirely in the excluded verbs**, and it was
ADMITTED into MATERIALS with `E11_NO_PROCEDURE ok`. What gives it away is not any word: it is the
**density** of quantities-with-units. Three is the threshold, and it is not always-red — measured
over **every non-figure, non-reproduce line of all sixteen live entry files the count is 0**, and
on the line above it is 6. `FIGURE` and `REPRODUCE` lines are exempt from rule C only, because
both are machine text pinned elsewhere (E4, E9) and a run of numbers there is ordinary; rules A
and B still cover them.

Rules run A, then B, then C, so a line satisfying more than one is reported under the most specific
evidence — a named verb beats a count. The refusal prints the rule, the verb and the quantity it
matched, so it is contestable rather than mysterious. **The passing message says what was tested**
— *matched none of the 32 fabrication verbs, and no line carries 3 or more quantities with units* —
not *carries no procedure*, which is a claim no word list can make.

### E12 — the evidence is not self-graded
`confidence`, `coherence`, `overall_score`, `validation_passed`, `novelty_score`, `quality_score`
and their kin — eight tokens — may not appear in a `MEASURED` or `FIGURE` line. **None of them
measures anything outside the program that wrote them**, and in this wiki's corpora every one is a
`Double`.

They remain welcome in a `REFUSED` line — saying a column is barred is the opposite of relying on
it, and a control arm proves the detector knows the difference.

**The passing message says what was tested**: *none of the 8 barred tokens appears*. It used to say
*no self-graded column is offered as evidence*, which is a wider claim than a list of eight tokens
can support — `model_score high, plausibility strong` is admitted by this clause, and the honest
message says so by naming its own scope.

**It refuses in the other direction too, and that is recorded rather than filed off.** On
2026-09-09 this clause refused a correctly-formed MATERIALS entry because its `MEASURED` line read
*"all three pairwise **confidence** intervals overlap"* — the statistical sense, from a published
epidemiological study, not a generator scoring itself. **The refusal was a false positive and the
clause was not widened to accommodate it.** A token list is blunt by construction, the entry lost
nothing by saying *"all three pairwise intervals overlap"* and printing the interval `3.4 to 19.7`
beside it, and softening a detector that fires to admit one's own entry is how a gate becomes
decoration. The cost of bluntness here is a rewritten sentence; the cost of the alternative is a
self-graded column reaching a published figure, which is what this clause exists to have prevented
once already.

### E13 — FALSIFIER
The observation that would overturn the entry. **An entry nothing could refute is not evidence**,
and there is nothing for a later refutation to be filed against.

### E14 — a refutation caps the grade
`REFUTED_BY` must carry a `YYYY-MM-DD` date, and the entry's grade must then be one of
`NOT_KNOWN`, `ABSENT`, `REPORTED`. Refuted-and-still-`MEASURED` is refused. See *Retraction*,
below.

---

## PER-LIBRARY — the nine clauses, and the count that matters

Every clause here holds every entry at once. **Ceilings are declared by the library in its own
`LIBRARY.manifest` and tested by integer comparison, per value:**

```
count(most repeated value on that axis) ≤ declared
```

Never by a ratio — a ratio between two integers is where a float enters a program that had none.
The declared integer is the library stating, in advance, how much repetition it considers honest
**at one value**.

> **CORRECTED 2026-09-07.** This test read `distinct × declared ≥ entries`, which is an
> *aggregate* wearing a per-value name. Measured: a library declaring 2 per identity, holding 8
> entries over 4 distinct identities, **one of which carried 5 of the 8**, was ADMITTED at exit 0
> and printed `4 × 2 ≥ 8` as its reason. The live PROTEINS library was inside that gap on the day
> it was published — one digest carried 3 of its 5 admitted entries against a declared 2 — and the
> page printed *5 entries / 3 distinct / declared 2 / holds* without ever saying so. The ceiling is
> now tested where it is declared, and the most repeated value is printed **on the passing path
> too**, so a reader sees how close a library is to its own ceiling instead of only being told it
> cleared. The PROTEINS manifest moved to 3 in public, in the same commit.

The whole manifest, eight keys, one of them repeatable:

```
LIBRARY                          COMPOUNDS
DECLARED_ENTRIES_PER_IDENTITY    1
DECLARED_ENTRIES_PER_PROGRAM     1
DECLARED_ENTRIES_PER_SEAL        1
DECLARED_ENTRIES_PER_MEASURED    1
DECLARED_ENTRIES_PER_TRIPLE      1
PUBLISHED_PAGE                   Library-Of-Compound-Cures.md
OPEN_SLOT                        <a measurement this library has named and does not have, dated>
```

Every `DECLARED_ENTRIES_PER_*` must be an integer ≥ 1, `PUBLISHED_PAGE` must be present, and an
unrecognised key is a refusal — a manifest that silently ignores a typo is a manifest whose
ceilings can be misspelled away.

| clause | refuses |
|---|---|
| **L1** NOT_EMPTY | a library with no entries. **REFUSED, never reported clean** — zero admitted entries is the weakest possible evidence and calling it a clean library is the strongest possible claim |
| **L2** MANIFEST | a library that declares no ceiling, which is a library declaring that any amount of repetition is acceptable; or one that names no published page |
| **L3** DISTINCT IDENTITY | one identity carrying more entries than the library declared |
| **L4** DISTINCT PROGRAM | one program cited by more entries than declared — one measurement wearing N hats |
| **L5** DISTINCT SEAL | one seal under more entries than declared — one measurement carved into N entries |
| **L6** DISTINCT MEASURED | one finding under N identities — the same collapse, on the axis a distinct-identity count cannot see |
| **L7** NO ENTRY REFUSED | the library publishing while one of its entries is refused |
| **L8** DISTINCT TRIPLE | identity, program **and** seal all equal on more entries than declared — the same-library half of "an entry may not be filed twice" |
| **L9** PAGE MATCHES DIR | the published page and the graded directory carrying different entries. The checker grades `library/<lib>/`; a stranger reads `Library-Of-*.md`. Nothing made them agree until this clause did |
| **F1** (across libraries) | the same `(identity, program, seal)` filed in **two different libraries**. No ceiling can license it: an entry belongs to exactly one library, or the two libraries are not two |

### F1 is between libraries. L8 is inside one. They are different questions.

**F1 used to be one question asked badly.** It keyed on the triple across every admitted entry of
every library at once, without asking which library each came from. Run on the three seed libraries
in one command it printed

```
F1_NO_ENTRY_FILED_TWICE   REFUSED — 1 entry is filed twice
```

for a triple carried by **three** entries, all three **inside one library** — and both its passing
text and its refusing text said *"in two libraries"*. Three false statements in one line: the count
was wrong, the plural was wrong, and the relation it named was not the relation it had measured. It
also contradicted that library's own manifest, which declares 5 per program and 5 per seal in public
precisely to license one run answering several separable questions.

So the question was split. Repetition **inside** a library is L8, against a ceiling that library
declares. F1 is what is left, and it is the thing no per-library clause can reach, because no
per-library clause ever holds two libraries at once. Four control arms hold the boundary, and the
fourth is the one the old F1 had none of: *three entries on one triple inside one library — F1 must
not fire.*

### Grade every library in ONE run, or F1 is NOT_KNOWN

A run given a single library cannot answer a question about the relation between libraries. It says
so, prints `NOT_KNOWN`, and exits 2:

```
F1_NO_ENTRY_FILED_TWICE   NOT_KNOWN — 1 library was graded in this run, so the relation
                          BETWEEN libraries has nothing to hold over. This is NOT_KNOWN and
                          it is NOT a clearance.
```

**This is not a formality.** The three seed libraries were first published from three separate
single-library runs, each reporting clean, and the clause that refused them could not be reached by
any of the three. `SECTION 5` used to be gated on having more than one library, so it printed
nothing at all on the runs people actually make. A clause that is silent on the ordinary run is not
enforced by being present.

### The axis that varies is never the axis that lies

L6 exists because of what the collapsed-library control arm actually prints. Four rows, one
identity, four different titles:

```
    axis                            entries  distinct  most at 1  declared  holds
    IDENTITY                              4         1          4         1  NO
    TITLE (census, not a gate)            4         4          1         -    -
```

That is the Study-37 shape reproduced exactly: in the original corpus, `discovery_id` varied
across all 37,910 rows and `timestamp` varied across all 37,910 rows, and both would have
reported perfect diversity on a corpus of five molecules. **Which column carries identity is a
decision about the domain, and a counter pointed at the wrong column is worse than no counter,
because it returns a number.**

`most at 1` is the count carried by the single most repeated value on that axis. It is the number
the declared ceiling is about, it is printed whether the ceiling holds or not, and it is the column
that was missing when an aggregate cleared a library one of whose values carried five against a
declared two.

So the law counts distinct on **every** axis and publishes them side by side, gating five of them
and printing the rest as a census. `TITLE` and `GRADE` are labelled *census, not a gate*, print a
dash rather than a verdict, and are labelled that way in the output: **a clause that never refuses
is decoration, and calling a decoration a gate is how a reader comes to trust one.**

### Sealless entries are named, never bucketed

Entries declaring `SEAL NONE_PRINTED` are excluded from the seal axis and **counted and named
separately**. Folding them into one bucket would report a collapse that is not there — the same
error in the opposite direction.

---

## How a library GROWS

### Who may add
**Anyone.** The law is the gatekeeper, not a person. There is no reviewer to persuade and no
committee to convince: an addition is a file, a program and a transcript, and the checker is the
referee. It runs in public, on a clean clone. Grading all three libraries takes well under a
second once the checker is built; building it took 4 min 26 s of wall time on a contended machine
and 12.6 s of CPU, which is worth stating rather than rounding to "fast".

### What must accompany an addition
Five things, in **one commit**:

1. **The entry file** in `library/<lib>/` — carrying an `affine-entry` block the checker admits.
2. **The same block on the published page**, `Library-Of-*.md`. Clause L9 compares the two as
   multisets and refuses if they differ, so this is not a courtesy; the addition fails without it.
3. **The program** in `reproduce/`, if it is new: self-contained, integer, with its own control
   arm in both directions.
4. **A `check_figure` row in `reproduce/validate.sh`** for at least one of the entry's figures,
   pinned to the library page, so the wiki's own harness fails if page and program ever drift
   apart. An entry that is expected to be **HELD** gets no such row and a comment saying why —
   a row pinned to a figure its program does not print here is a red harness, and a red harness
   nobody can fix is how a harness stops being read.
5. **The manifest ceilings**, moved if the addition needs them moved.

Point 4 is not bookkeeping. **A stale ceiling silently re-admits what was just excluded.** This
programme has already paid for that lesson on a float ratchet whose frozen constant kept forgiving
what it had been raised to catch; the same failure here would let a library grow past its own
declared honesty without a single clause going red.

### What happens to an entry whose evidence is later refuted

**Nothing is ever deleted. A library that cannot retract is a library that cannot be trusted — and
a library that retracts by deleting is worse, because it cannot be caught.**

The entry stays where it is and is superseded in place:

1. add `REFUTED_BY <what refuted it, and a YYYY-MM-DD date>`;
2. rewrite `GRADE` to what the *surviving* evidence supports — usually `NOT_KNOWN`;
3. leave the original `MEASURED`, `FIGURE`, `SEAL` and `REFUSED` lines untouched, so the claim and
   its refutation stand on the same page;
4. `SUPERSEDES` on the replacement entry, if there is one.

E14 enforces exactly this: a refuted entry still graded `MEASURED` or `VERIFIED` is refused, and
an undated refutation is refused because it cannot be ordered against the claim it refutes. A
refuted entry that is dated and regraded is **ADMITTED** — the arm proving that is arm 18, and it
is there so that retraction is a *path through the law* rather than an exit from it.

The reason this is written this hard: the V234 ledger's own `BEFORE DELETE` triggers were
disarmable at runtime, three migrations used the bypass, and for every game they touched *"never
CUREd"* and *"its CUREs were deleted"* are now indistinguishable. **Deleting a refuted entry is
the same act, one step later.**

---

## The control arm is the whole point

A law that admits everything has admitted nothing. A law that refuses everything has too. And a
law with no reachable `NOT_KNOWN` has two answers for three questions, so it will print one of
the two where it means the third.

**71 arms, all passing: 43 must REFUSE, 19 must ADMIT, 9 must HOLD.** Every negative arm is the one
correctly-formed fixture entry with **exactly one thing changed**, so a refusal is attributable to
that change and nothing else. Each arm declares the terminal **and** the clause code it expects —
refusing for the wrong reason is recorded as `REFUSED(wrong reason)` and **fails**, because
otherwise a checker that refused everything would score full marks on a suite of refusal arms.

Fourteen arms are **controls on the controls**, and they are the ones worth arguing about:

- prose *about* a procedure must not trip the procedure detector;
- a refusal line naming a self-graded column must not trip the self-graded detector;
- a measurement whose words happen to include a unit must not trip rule A;
- two quantities with units on one line is **below** the rule C threshold and must admit;
- a dense measurement whose numbers carry no units at all must admit;
- the same object named **with** a quantity beside it must admit, where the bare name refuses;
- the **untruncated** figure must still match, so the token-boundary repair is not always-red;
- a program that prints no seal, declared honestly, must be admitted;
- a **complete** run's seal must still be found, so the refusal-transcript fix is not a weakening;
- a figure absent from a **complete** run must still refuse, for the same reason.
- an entry graded against a **complete** run must still ADMIT after the quoted-figure repair, or
  that repair is an always-hold — the same defect wearing the other face.
- a COMPLETE run that also quotes its published block must **admit**, or the computed-region
  rule is an always-refuse;
- a declared `COMPLETE` must beat a refusal **spelling** inside that program's own quoted block,
  because a false NOT_KNOWN is a defect exactly as a false ADMIT is;
- figures computed with the seal only quoted must pass E4 and refuse E5, so the two clauses are
  shown to read the region independently.

The fixtures are embedded in the program: the control arm needs no corpus, no filesystem and no
network, and it runs **first** — if any arm fails, no library is graded at all.

```
CONTROL ARM  71/71 PASS
  arms that must REFUSE      43
  arms that must ADMIT       19
  arms that must HOLD         9   (NOT_KNOWN — the third terminal is reachable)
A law that admits everything has admitted nothing; a law that refuses everything
has too; and a law with no reachable NOT_KNOWN has only two answers for three
questions, so it will print one of the two where it means the third.
```

### The seven false ADMISSIONS an adversarial pass found, and the arms that now hold them

Every repair below is a case the law **admitted** — printed `ok` on, and in several of them
confirmed the entry's `MEASURED` grade while doing it. A repair with no arm behind it is a claim,
so each carries its arm and, where the repair could be always-red, its control.

| what was smuggled past | the pass message it earned | now |
|---|---|---|
| `FIGURE E8  : 24` against a transcript printing `E8  : 240` | *all figures appear verbatim* | **arm 38.** Figures match at token boundaries. Ten times the number is not the number. Control arm 39: the untruncated figure still matches |
| `FIGURE 0` · `FIGURE :` | *appear verbatim*, grade MEASURED confirmed | **arms 40, 41.** A figure is at least 3 bytes and carries a letter or a digit. Shorter than that matches a line of almost any transcript |
| `MEASURED  E8 is a good lattice and it works well in practice.` | *carries a quantity* | **arm 36.** The digit must stand free of the letters around it. The 8 in E8 names the object; it counts nothing. Control arm 37: the same object **with** a quantity admits |
| a two-sentence fabrication route in ordinary verbs — *combine, heat, press, cool* | `E11_NO_PROCEDURE ok` — *carries no procedure* | **arm 42, C-007 rule C.** Three or more quantities-with-units on one non-figure line. Measured 6 on that line and **0 on all 264 such lines of the sixteen live entries**. Controls 43 and 44: dense numbers without units, and two quantities, both admit |
| a triple carried by 3 entries in ONE library, reported as *1 entry filed twice in two libraries* | — | **arms L-08, L-09, F-04.** L8 asks the same-library question against a declared ceiling; F1 asks only the cross-library one |
| a library declaring 2 per identity with one identity carrying 5 of 8 | *4 × 2 ≥ 8*, exit 0 | **the per-value test.** The most repeated value is printed on the passing path too |
| the published page and the graded directory | nothing checked them | **arms L-10, L-11, L-12, L-13, clause L9** |

Two pass messages were also **rewritten to say what was actually tested**, because a message that
asserts more than its test is the same defect one layer up: `E11` now reports *matched none of the
32 fabrication verbs and no line carries 3 or more quantities with units*, not *carries no
procedure*; `E12` reports *none of the 8 barred tokens appears*, not *no self-graded column is
offered as evidence*. `E4` now names the transcript line each figure matched, rather than asserting
the word *verbatim*.

### The six cases the brief named, run on real files

Each is the **admitted zilganersen entry** with exactly one thing changed, written to disk in
`control-cases/` so a stranger can run the refusals themselves:

```
  case-1-claim-no-program-prints.md                   REFUSED
      REF  E3_PROGRAM       'zilganersen-offtarget-screen-v2' is not a program in reproduce/.
                            An entry whose claim no program produces cannot enter.
  case-1b-figure-not-printed.md                       REFUSED
      REF  E4_FIGURE        1 of 4 figure(s) are NOT printed by
                            zilganersen-offtarget-whole-transcriptome: first is
                            'perfect 20/20       : 0, none in GFAP'
  case-2-no-refusal-line.md                           REFUSED
      REF  E8_REFUSAL       no REFUSED line. An entry with no refusal line is overclaiming by
                            omission — it lets a reader take the largest reading the words allow.
  case-3-no-identifier.md                             REFUSED
      REF  E1_IDENTITY      IDENTITY 'unknown' is a placeholder. A field that accepts 'unknown'
                            is not a name.
  case-4-verified-on-reported-evidence.md             REFUSED
      REF  E7_GRADE_SUPPORTED  graded VERIFIED with no SOURCE+QUOTE. Ontology.md: VERIFIED means
                            fetched and read, with the row or sentence quoted. On this evidence
                            the entry supports REPORTED at most.
  case-7-synthesis-cookbook.md                        REFUSED
      REF  E11_NO_PROCEDURE C-007: a procedure a person could follow. rule A, verb 'dissolve',
                            quantity '42 mg', in: Dissolve 42 mg of the gapmer in 5 mL of buffer,
                            anneal at 65 C for 4 h, then centrifuge at 12000 rpm.

  --- library-level ---
      REF  L3_DISTINCT_IDENTITY  the most repeated value exceeds the declared ceiling of 1 per
                            value: 'AXQ9493NT2' carries 4, and 4 > 1. 4 entries over 1 distinct.
      HELD L9_PAGE_MATCHES_DIR   This-Control-Case-Is-Not-Published.md is not readable from here,
                            so page and directory cannot be compared. ABSENT IS NOT AGREEMENT.
      REF  L1_NOT_EMPTY     the library holds NO entries. An empty library is REFUSED, never
                            reported clean: zero admitted entries is the weakest possible
                            evidence and reporting it as a clean library is the strongest
                            possible claim.

  --- and the real entry all six were derived from ---
  UNII-AXQ9493NT2-zilganersen.md                      ADMITTED
```

**The `HELD` line is deliberate and it is part of the design of a control case.** A control case is
not published, so its manifest names a page that does not exist and L9 reports `NOT_KNOWN` rather
than `REFUSED`. **A control case must be refused for the one reason it was built to demonstrate, or
it demonstrates nothing** — and `collapsed-library` declares 4 per program, per seal, per measured
and per triple, as generously as a library can, so that `DECLARED_ENTRIES_PER_IDENTITY 1` is the
only clause left to catch it.

### The two false refusals a real transcript exposed — and the correction

Halfway through this work, `validate.sh` ran and wrote a transcript for the one HELD entry's
program. **Grading against it refused an honest entry, twice over, for two different wrong
reasons.** Both are now fixed, and both have arms behind them, because *a correction with no arm
behind it is indistinguishable from a weakening.*

**E5 read any 64-hex as a seal.** `peptide-homology-exact` prints three 64-hex digests — its
corpus, its reference and its BLOSUM62 matrix — and then says `NO SEAL EMITTED`. An any-hex test
called the entry's honest `NONE_PRINTED` a hidden seal. The test now requires a **seal line**: a
64-hex whose preceding text contains *seal* or *digest*, or is nothing but the token `sha256`.
`corpus sha256` and `reference sha256` name **inputs**, and an input digest is not a seal.

**E4 read a refusal as an absence.** `validate.sh` runs every program with no argv and no stdin,
so that program refused for want of its corpus — and its silence about `36128` was scored as
*the program does not print this figure*. **It is not.** The program never got to the point of
printing anything. Absence inside a refusal is now `NOT_KNOWN`, with the reason named.

The discriminator is narrow by construction and was checked against every real transcript: the
five screens that print their pinned reference figures and *then* stop for want of stdin are not
refusal transcripts by this test, and their entries are still admitted from them. Only an explicit
`REASON:` / `NO SEAL EMITTED` / `no verdict is published` marks a transcript as having answered
nothing.

**Both errors ran in the same direction — refusing something true — which is the direction that
looks like rigour.** An admission law that refuses honest work will be read as strict rather than
broken, and it will be quietly worked around instead of fixed. Arms 34 and 35 are the controls on
that correction: a *complete* run's seal must still be found, and a figure absent from a
*complete* run must still refuse, or the fix has turned E4 and E5 into decorations.

### What the control cases caught in the law itself

Two defects, both found by running the arms rather than by reading the source, and both of the
exact kind this law legislates against:

- The empty-library case exited `1` while the closing prose above it read **"Every entry admitted,
  and every per-library clause holds"** — the always-green sentence on a red run. The verdict was
  right and its summary contradicted it, which is worse than either alone. The closing prose now
  branches on the library clauses, not only on the entry tallies.
- The cookbook case refused correctly and explained itself wrongly: it reported *"imperative
  opening — no quantity needed"* on a line carrying 42 mg, 5 mL, 65 C and 12000 rpm, because
  rule B was checked before rule A. **A correct refusal carrying a wrong reason is not a
  half-success** — a reader who checks the stated reason finds it false and stops trusting the
  verdict. Rule A is now checked first and every refusal names the rule that caught it.

**And a third, found the same way, in the arms themselves.** The arm written to test an unreadable
published page was declared with `page: nil` — and the helper's default was *also* `nil`, so it
silently supplied a page and the arm tested a readable one. It failed on its first run, which is
how it was found. **A default that cannot express the case an arm is testing is an arm testing
something else.** The flag is now explicit. A fourth: the arm meant to prove F1 does *not* fire on
three entries sharing a triple inside one library paired that library with a second one carrying
the same identity — so F1 refused, correctly, on a real crossing, and the arm was measuring the
opposite of its own name. It also failed on its first run. **Two of the new arms caught their own
construction before they caught anything else, which is the cheapest possible place to be wrong.**

---

## What the law found on first contact with the real corpus

**The eleven master-regulator drug pairs are not admissible today, and the law is right.**

Study 26 publishes eleven drug pairs, one per tumour type, each the top of 44,850 scored. Searched
across the whole standalone wiki, the string `AMG-208` appears in **exactly one file — the study
page itself**. No program in `reproduce/` prints them; no corpus or TSV carries them. A reader of
that page would take those pairs as sealed. **A stranger with a clean clone cannot re-derive a
single one of them.**

That is E3 and E4 doing precisely the job they exist for, and it is why the harness rule had to
become an admission rule. The pairs are not deleted and not disputed: they are named as an
**open slot** in the compounds manifest, with the reason recorded. They enter the day a program
in `reproduce/` prints them.

Two more slots are named the same way: the registry-wide specificity ranking (running, not
available at this grading) and the A.E.P-1 pod's four-tier bench gate (charter frozen with its
integers, no pod built, no tier run).

**And a third finding, from running `validate.sh` rather than from the law: the harness is at
214 passed / 1 failed, and the failure is a timing.**

```
FAIL  HEADROOM_EXCEEDS_50X            TRUE NOT printed by fusion-control-benchmark
```

`Study-33` publishes `HEADROOM_EXCEEDS_50X TRUE` and the harness pins it. The program computes
`let headroom = throughputMS * 1000 / Double(RATE)` and then `headroomOK = headroom >= 50` — **a
float comparison on a decision path, inside a tree whose own README says every program is integer
or exact-rational.** Today, on a machine at load average 320–348, the law sustained 8.0 M
samples/s against a 2.0 M requirement and printed `HEADROOM 4.0x` → `FALSE`.

Nothing about the law changed. **What that boolean measures is how much spare CPU the host had**,
and the wiki pins it as though it were a property of the arithmetic. It is the house rule from the
other direction: *a seal must never digest a path or a timing* — and a **pinned figure** must not
either. `VERDICT_DETERMINISTIC_10K` beside it is a real invariant and holds; `HEADROOM_EXCEEDS_50X`
is a benchmark of the machine and should be reported as a rate with its load, not as a boolean the
harness can fail.

This is why the brief's "213 passed / 0 failed" and a later "214 passed / 1 failed" are both
honest readings: the count moved because programs were added, and the failure appeared because
the machine got busy. **A gate that flips on load is not measuring the thing it names.** Stated
here because the same trap is one line away from this law: had E4 compared a *timing* rather than
a *string*, every entry would be admitted or refused by whatever else the machine was doing.

**And a third harness finding, from wiring this law into it: a failed build was leaving a stale
transcript in place, and every figure pinned to that program then passed against yesterday's
bytes.** Section 2 writes `/tmp/out_<program>.txt` on success and, on failure, wrote nothing —
leaving whatever an earlier run had put there. So one program failing to compile produced **one**
red line and silently green-lit every `check_figure` row that reads its output. Measured on a
machine at load average 425, with `fusion-control-exact-law` failing to build: its transcript from
a run 90 minutes earlier was still on disk and still being read. Two repairs, both in section 2:
the stale transcript is now **deleted** when a program produces no output, so its pinned rows
report `SKIP` — absent, which is a third answer and not a pass — and the compiler's first error
line is printed instead of being discarded to `/dev/null`, because **DID NOT COMPILE** and
**COMPILED AND PRINTED NOTHING** are different answers that were being printed alike.

**And the law found a hole in itself, which is the second thing worth reporting.** The one HELD
entry names `peptide-homology-exact`, and that program is **untracked in git**. E3 passed it,
because E3 reads the working tree. E9 promises a stranger can run the command from a clean clone.
Those two clauses are one step apart and only one of them is enforced — so an entry can be
admitted today on a program that would not arrive in anyone else's checkout. It is blind spot 7
below, it is the next clause to write, and it was found by running the law rather than by reading
it.

---

## The seed libraries, as the law graded them

**All three in one run** — the only run that can answer F1. Fifteen entries admitted, one held,
none refused. Exit 2, seal
`c12f27fdada6f574e2b2d4864ea95935f9bf3f75fa5c33ab325eb52c1c52b54b`, 28,104 sealed bytes.

| library | entries | admitted | held | distinct identity | most at 1 | distinct program | distinct triple | slots |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| [PROTEINS](Library-Of-Proteins) | 6 | 5 | 1 | 3 | 3 | 1 | 3 | 4 |
| [COMPOUNDS](Library-Of-Compound-Cures) | 5 | 5 | 0 | 5 | 1 | 5 | 5 | 2 |
| [MATERIALS](Library-Of-Material-Systems) | 5 | 5 | 0 | 5 | 1 | 5 | 5 | 2 |

`F1_NO_ENTRY_FILED_TWICE   ok` — 13 distinct `(identity, program, seal)` triples over 15 admitted
entries, none of them appearing in more than one library.

The held entry is the exact Smith-Waterman homology screen. Its program exists in `reproduce/`
and has not been run to completion in this clone, so its figure clause is `NOT_KNOWN` and the entry
waits by name. That is a real `NOT_KNOWN`, not a constructed one, and it is the honest answer to
*"treat its numbers as measured but not yet sealed, and say so."*

The `PROTEINS` library declares **5 per program**, **5 per seal**, **3 per identity** and **3 per
triple**, because one run of one program over one corpus answers several separable questions here.
**The sharing is declared, not hidden** — which is the entire difference between a ceiling and an
excuse. Its `most at 1` column is 3 where the other two read 1, and that number is on its page.

---

## How to run it

```bash
xcrun swiftc -O -swift-version 5 reproduce/library-admission-law.swift -o /tmp/lal

/tmp/lal                                   # control arm only — no filesystem, no network
/tmp/lal --entry <file.md>                 # grade one entry

# EVERY LIBRARY IN ONE RUN. This is the command the pages publish the result of.
/tmp/lal --library library/proteins --library library/compounds --library library/materials \
         --reproduce reproduce --evidence /tmp
```

**Grading one library at a time is not a smaller version of this command; it is a different one.**
F1 is a relation *between* libraries, so a run given one library prints
`F1_NO_ENTRY_FILED_TWICE   NOT_KNOWN` and exits 2. The three seed libraries were first published
from three separate single-library runs, each reporting clean, while the combined run refused —
and `SECTION 5` was gated on having more than one library, so none of the three runs printed the
clause at all. **A clause that is silent on the ordinary run is not enforced by being present.**

`--evidence` is where `out_<program>.txt` transcripts live; `validate.sh` writes them to `/tmp`,
which is the default. Exit codes: `0` all admitted, `1` something refused, `2` something held,
`3` the control arm failed and nothing was graded.

**Every exit prints the reference figures**, including every refusal path — a program that exits
early without printing them fails the harness on every pinned figure at once. **Filesystem paths
are printed and never sealed**: a seal that moves with the checkout directory indicts a correct
reproduction, which is the worst thing a seal can do.

That last claim is measured, not asserted. All three libraries graded in one run, from three
different absolute paths and three different working directories:

```
path A (the checkout,        cwd = the checkout)
path B (/tmp/…,              cwd = /tmp)
path C (a long nested path,  cwd = /)

TRANSCRIPT SEAL  sha256  c12f27fdada6f574e2b2d4864ea95935f9bf3f75fa5c33ab325eb52c1c52b54b
TRANSCRIPT SEAL  sha256  c12f27fdada6f574e2b2d4864ea95935f9bf3f75fa5c33ab325eb52c1c52b54b
TRANSCRIPT SEAL  sha256  c12f27fdada6f574e2b2d4864ea95935f9bf3f75fa5c33ab325eb52c1c52b54b

PATH_INDEPENDENT_SEAL — three absolute paths, three cwds, one seal · 28,104 sealed bytes · exit 2
```

**Zero float.** No `Float`, `Double` or `CGFloat` type appears in the 2,495 lines; the four
occurrences of the words are prose *about* floats — one in the header, one in a comment, and two
inside refusal strings the law prints when it catches a self-graded column. That is the same
distinction the control arm proves for the procedure and self-graded detectors. **No absolute path
is baked into the source** — `/tmp` is the house's own build target and belongs to no one; every
private-path form is in the detector's own refusal list and nowhere else.

---

## What this law cannot see

Stated here, before the closing section, because *a rule scoped to where you expect the violation
will not catch it where it happens* — and the only defence against that is naming the scope out
loud. Ten blind spots, in the order they were found — and most were found by running the law, not
by reading it, which is the argument for the whole section:

1. **It counts distinct over exact strings, so paraphrase defeats it.** Two `MEASURED` lines
   differing by one word count as two findings. This is the same class of defect the law exists
   to catch, one level up, and it is **not fixable without inventing a similarity threshold** —
   which would put a tunable number on a decision path this programme keeps integer and exact.
   The honest instrument is the exact count, and its limit is this. It is why L6 is a ceiling a
   library declares rather than a claim the law makes.

2. **It cannot check that a `QUOTE` matches its `SOURCE`.** `VERIFIED` therefore rests on the
   author's honesty *plus* the source being fetchable by a reader who doubts them. The clause
   forces the quote onto the page, where it can be checked by someone; it does not check it.

3. **It does not check that `MEASURED` is a fair summary of the `FIGURE` lines.** Every figure is
   matched, at a token boundary, against a line of the program's output. The sentence a human
   reads above them is not. An entry can carry true figures under an overreaching sentence and be
   admitted. (The figure match itself was weaker than this paragraph claimed until 2026-09-07: it
   was a whole-transcript substring test, and it graded `E8  : 24` as MEASURED against a line
   printing `E8  : 240`.)

4. **It does not run the programs.** It reads their transcripts. A program that printed a figure
   it did not compute would pass every clause here. The defence against that lives in the
   programs' own control arms, not in this law.

5. **The C-007 detector is a word detector.** 32 verbs and two rules. A procedure written in
   vocabulary outside that list passes, and the list is printed on every run so it can be
   argued with. Refusals name the rule, the verb and the quantity matched, so a false positive is
   contestable rather than mysterious.

6. **It cannot tell a real falsifier from an unfalsifiable sentence.** E13 forces the field to
   exist and be non-empty. Whether it names an observation anyone could actually make is a
   judgement, and the law makes none.

7. **E3 reads the working tree, and E9 promises a clean clone.** This is the sharpest of the seven
   and it was found by the law's own first run. `peptide-homology-exact.swift` exists on disk and
   is **untracked in git** — so E3 passes on a program a stranger cloning this repository would
   never receive. The two clauses are one step apart and only one of them is enforced. **The fix
   is to check that the named program is tracked, not merely present**, and until it lands, an
   admitted entry guarantees the program exists *here*, not that it ships.

   **Measured 2026-09-07, and it is worth knowing which way the gap actually runs today:** every
   one of the twelve programs behind the fifteen **admitted** entries *is* tracked. The single
   untracked one is `peptide-homology-exact`, and its entry is the one that is **HELD**. So the
   hole is real and open, and nothing has yet fallen through it. That is a measurement, not a
   reason to close the section.

8. **The default evidence directory is shared mutable state.** `--evidence` defaults to `/tmp`,
   where `validate.sh` writes `out_<program>.txt` — so a `validate.sh` run in another session can
   rewrite a transcript *while* a library is being graded. The transcripts are deterministic, so
   the content is stable; a **partially written** one is not, and a truncated transcript is
   indistinguishable from a figure the program does not print. It would read as `REFUSED` on a
   correct entry, which is the worst direction for this error. **Pass a private `--evidence`
   directory when grading matters.** Measured while writing this: two `validate.sh` processes were
   running concurrently on this machine at load average 320, both writing the same files.

9. **L9 compares the entry BLOCKS, not the prose around them.** The published page and the graded
   directory must carry the same fenced `affine-entry` blocks as multisets — that is checked, and
   before 2026-09-07 nothing checked it at all. What L9 cannot check is the several thousand words
   of commentary each page wraps around those blocks. A page can carry correct entries under a
   paragraph that overstates them, exactly as blind spot 3 describes one level down. The defence is
   the same and it is not a program: the refusal lines travel inside the block.

10. **A quantity in a `FIGURE` or a `REPRODUCE` line is invisible to C-007 rule C.** Those two keys
    are exempt from the density rule because both are machine text where a run of numbers is
    ordinary — a figure is pinned by E4 to a line of the program's own output, a reproduce command
    is pinned by E9. Rules A and B, the verb rules, still cover both. But a procedure written
    without any of the 32 verbs **and** hidden inside a figure that a program genuinely prints
    would pass. The narrower the exemption is stated, the easier it is to argue with, which is why
    it is stated.

None of these is a reason to weaken a clause that works. They are the map of where the next
clause has to go, and number 7 goes first.

---

## What this law is not

- It is **not** a claim that an admitted entry is true. It is a claim that the entry is *checkable*
  — named, produced by a program a stranger can run, graded at what its evidence supports, and
  explicit about what it refuses to say.
- It is **not** a substitute for the study pages. A page argues; an entry is admitted.
- It is **not** a safety review, an efficacy claim, or a ranking. **Nothing in these libraries is
  medical advice and no entry is a recommendation to take anything.**
- It is **not** finished. It has 25 clauses today — 15 per entry, 9 per library, 1 across
  libraries — and every one of them exists because something got past its absence. The sixth
  identity kind was added an hour after the fifth, because the first material system to arrive
  had no registry number. E4 and E5 were corrected the same afternoon, because the first real
  transcript they met made them refuse an honest entry. E4 was corrected **again** that evening,
  because an adversarial pass showed it grading `E8  : 24` as MEASURED against a line printing
  `E8  : 240`; C-007 gained rule C because a complete fabrication route written in ordinary verbs
  was admitted with `ok`; L8 and L9 were added because a triple filed three times inside one
  library was reported as *"1 entry filed twice in two libraries"*, and because nothing at all
  compared the published page against the graded directory. **The arms went from 37 to 42 fixing
  two clauses, and from 42 to 61 fixing six more** — and that ratio is the point: a correction is
  worth what its controls are worth. Every repair above ships with the arm that catches it and,
  where the repair could refuse an honest entry, the control that proves it does not.
