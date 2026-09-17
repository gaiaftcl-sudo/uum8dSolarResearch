# Read this in your own language. The translation is arithmetic, and it will not guess.

**Pick a language at the top of this page.** The site's own words change, and nothing generates them.
Every visitor should be able to reach this work in the language they think in — that is the point of
what follows, and it is why this is the first thing on the page rather than a footnote about
infrastructure.

Here is how it works, because how it works is the whole offer. Each of the nine machines serving this
site derives a **coordinate chart per language in memory the moment it starts**: it reads the raw
rows of one pinned public weight file by byte range at a pinned revision with the header
digest-checked, decodes each row bit-exactly, quantises it onto an integer lattice with the same
quantiser the substrate's own sealed bonds use, and orders candidates by an **exact 256-bit integer
comparison**. Nothing derived is written to disk, so there is no chart file to go stale and none to
trust. A word crosses only if both languages hold it as a pinned public dictionary states them and
its round trip closes. Otherwise the court **refuses that word and names the refusal**.

Measured on the public court, 2026-09-12 — one lattice digest across all nine machines, and a
refusal you can read rather than a guess you cannot check:

```
book   → "libro"   chart:1
water  → null      REFUSED_SHARED:1 of 1:water→agua(pt)
```

The second line is the part to look at. *Water* was withheld not because the court had no answer but
because the spelling it would have returned is shared with a third language, so it says which one
instead of picking. **→ [Study 47 — translation shear](Study-47-Translation-Shear)**

**What this does not do yet, said here rather than lower down.** Five languages are charted today —
Spanish, French, German, Italian, Portuguese — and everything else falls back to the English source,
marked as such. Whole sentences are usually refused; single words usually cross. And a public
dictionary is a list of the words a language *has*, not a list of translations, so a render can be a
real target-language word that is not the translation: *world→verden* and *language→bahasa* in
German are both genuine headwords of the pinned German dictionary. Those are the dictionary's entries
to correct, and the court names what it did. **ABSENT**: any claim about fluency, and any language
pair whose members are not stated.

There is also a gap between **reading** this in your language and **finding** it in your language,
and it is worth naming because only the first half is solved. The projection happens on your device,
after the page arrives, so the text a search engine indexes is the English source. Being reachable
from a search in Spanish or Hindi needs the projection to run before the page is served, not after —
that is the next piece of this work and it is not built.

---

# The machines that serve it hold no model, no GPU, and no float

Three measurements, each on all nine machines behind `affine.earth` and each taken per machine rather
than through the apex that fronts them, because an apex round-robin hides a one-in-nine straggler.

| measured 2026-09-12, per cell | |
|---|---|
| machines running a model process, listening on a model port, or holding an unmasked model unit | **0 of 9** |
| model weight files anywhere on any machine — `.gguf` or `.safetensors`, whole filesystem | **0 of 9** |
| machines with GPU compute: a vendor driver, a device node, or a CUDA / ROCm / OpenCL runtime | **0 of 9** |
| numeric fields in the 51 published court tools that accept a floating-point value | **0 of 51** |

**No model.** The last code path in the substrate that could build a request to a model API was
deleted this week, with its service unit, its installer and its command-line subcommand; the unit is
masked to `/dev/null` on all nine machines and nothing listens on its port. A local model server that
had been running unused on one machine since 23 August was validated unused — 167 seconds of CPU in
19.9 days, no log lines, no connections, the weight file's access time still the second it loaded —
and removed. Two gates refuse the return of either, each with control arms that prove the instrument
discriminates. **→ [No language model in this stack](No-Language-Model-In-This-Stack)**

**No GPU.** All nine machines are ARM Neoverse-N1 and the serving path is CPU integer arithmetic end
to end. No GPU driver, no device node, no CUDA, ROCm or OpenCL runtime on any of the nine — there is
nothing on these machines an accelerator could be asked for, and nothing that asks.

**No float.** This one is checkable from a terminal in three commands, and it discriminates in both
directions. Every numeric input in every published court tool is a **decimal string**, not a number —
the wire has no floating-point type to put a float into. Post integers and the court answers; put a
decimal point in one value, or send a JSON float, and it refuses by name:

```
A = "1,2,3,4,5,6,7,8|1"    →  CALORIE   AFFINE_JZ_OP     result "2,3,4,5,6,7,8,9|1"
A = "1.5,2,3,4,5,6,7,8|1"  →  REFUSED   AFFINE_JZ_PARSE  result ""
A = 1.5  (a JSON float)    →  REFUSED   AFFINE_JZ_PARSE  result ""
```

That is the programme's whole thesis enforced at the door: a verdict that depends on a rounding is
not a verdict, so the court will not accept the rounding in the first place.
**→ [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm)**

---

# Every study on this board runs on your device, not ours

There is a Studio on this site — an editor and a terminal in the page — and it will run the programs
behind these studies on your own hardware. No account, no key, nothing installed, and nothing sent
back to us.

![The Affine.Earth Studio: the study's own files on the left, the Swift source in the editor, a checks strip naming the zero-float rule and the wasm32 target, the terminal below reporting that the workspace is browser-local and the sandbox is a real WASI shell, and a pane on the right wired to the live membrane on a cell](images/studio-workbench.png)

*This is the door, and it is why the language work is at the top of this page rather than the bottom.
A person who can read the board in the language they think in, and then run the arithmetic behind it
on their own laptop with no account and no key, has been handed the thing itself instead of a
description of it.*

| measured from one browser, 2026-09-12 | |
|---|---|
| programs in the sealed manifest at the pinned commit | **90** |
| whose served source matched the manifest's digest of that commit's file, byte for byte | **90 of 90** |
| that run in the browser | **49** |
| that printed the sealed transcript exactly | **45** |
| that differed — one cause, named below | **3** |
| that withheld the comparison rather than claim one | **1** |
| host errors, or programs that failed to open | **0** |
| that do not build for the sandbox, each shown with its compiler's own line | **41** |

**Every study opens on its story.** Before the code, a study opens on seven short chapters — what it
asks in its author's words, the page its figures are published on, what its code reads (each corpus file
by its digest, and whether it takes standard input or its command line), the numbers it has to print and
whether its sealed run computed them or only quoted them, whether it runs here, whether it reproduced,
and, once you press Run, which of those numbers your own device printed. Each chapter is quoted from a
source pinned at the commit and names that source, so the story is checkable the same way the program is.
**→ [How a study tells its story](Run-Any-Study-In-Your-Browser.md)**

**What the Studio actually does.** Each program was compiled once to `wasm32-wasip1` and its native
transcript sealed at the same time. The browser fetches the artifact, holds it to the byte count the
manifest names, inflates it, checks the unpacked SHA-256, and only then instantiates it — inside a
`wasi_snapshot_preview1` host written for this, whose file system is that study's own corpus with
every file pinned by digest. When the run finishes it compares what your device printed against the
sealed transcript and tells you which of three things happened: **the same bytes**, **your inputs
differ**, or **it differs — and that is a finding**. The 49 artifacts are 584,047,128 bytes on the
wire and 1,670,622,786 unpacked; 207 corpus files are pinned by digest; the whole pass took 167
seconds of program time.

**The third verdict is the reason the Studio exists.** A program that prints different bytes on two
machines is exactly what this programme looks for, so the Studio is built to surface that rather than
smooth it over — and to say *inputs changed* instead of *pass* when it cannot make a fair comparison.

**All 90 open, including the 41 that cannot run here.** Each of those shows its source at the pin
and the compiler's own first line, and the front door carries a **◇ reads here** link beside it.
Twenty-six of the 41 are one cause — a 64-bit integer that does not fit wasm32's 32-bit `Int` — nine
need Dispatch types the sandbox's Foundation does not carry, three need a platform module, two a
platform C symbol, and one does not type-check. That is a change to those studies, not to the Studio.
**→ [Run any study in your browser](Run-Any-Study-In-Your-Browser)**

**And the honest part, in the same breath.** The three differences are one cause and it is not
arithmetic: those programs print the directory their corpus came from, and the sealed transcript
carries the absolute path of the machine that sealed it, which no other device can reproduce. Every
digit of their arithmetic agrees. It is a transcript convention to repair upstream and the page names
it with its line numbers. One further disagreement, on the machines rather than in the studies: of
six categories graded across the nine cells, five are unanimous and one is not — two cells carry an
extra settlement unit whose own description says "one payer". It was left running rather than stopped,
and whether that is a defect is **NOT KNOWN** until its exclusivity is traced.

**ARGUMENT** — what the three parts amount to together: you are reading a page translated by
arithmetic you can re-derive, served by machines that hold no model and no accelerator and refuse a
float at the door, carrying programs that run on your own hardware and print the same bytes the
builder's machine printed. None of that asks you to trust us, and that is the only reason the numbers
further down this page are worth your time.

---

# Forty-eight studies, one finding: the exact answer was there the whole time

**This is a line in the sand, and it is drawn with numbers rather than opinions.**

*(This heading read "forty-one" until 2026-09-12 and "forty-six" until 2026-09-17. The board carries
forty-eight studies today — 1 through 45, and 47 through 49. Study 46 is in preparation and is not on
the board, which is why the numbering runs past the count.)*

Across forty-eight studies — the sky, the sea, the ground, the genome, the grid, the ledger, and the
machines this page is served from — we kept meeting the same thing. Somewhere near the bottom of a
serious, careful, expensive piece of work, an exact quantity had been turned into an approximate one,
because that is simply how computing has been done since the 1980s. And every time we went back and
did the same work in exact whole numbers instead, **the answer was already available.** Not better.
Not faster. *Available* — where before there had been a score, an estimate, or a disagreement between
two machines that were supposed to agree.

That is the finding, and it is bigger than any one study on this board:

> **A great many questions the world treats as approximate are not approximate. They are exact
> questions that were handed to approximate arithmetic, and the uncertainty everyone learned to live
> with was manufactured on the way in.**

![Nine machines receive the same events in different orders; the sorting machinery spins up and its cost climbs to four million processor cycles; both paths return the identical integer; then the same fold in ordinary decimals returns two different totals](images/affine-earth-the-wrong-problem.gif)

*Nineteen seconds: the question, the nine machines, what the ordering cost, the identical answer — and the half that keeps it honest. [Full-resolution film](media/affine-earth-the-wrong-problem.mp4).*

## What that has looked like, measured

Nothing below is an argument. Each is a sealed study on this wiki with a program a stranger can run.

- **A medicine.** Where a guide molecule could bind in three billion bases is a counting question, not
  a scoring question. For Casgevy — curing sickle cell disease right now — the count is **one** perfect
  match, its intended target, and **nothing** one mismatch away. Not a low score. Nothing.
- **A tumour.** Seventeen tumour types, 7,673 people's tumours, all public bytes. No single compound
  reversed the signature in any of them — and asked again of **pairs**, the same law with the same
  controls finds candidates in **eleven of fifteen**. Those eleven warrant a laboratory. We do not call
  them safe or ready; that needs a bench.
- **A safety system.** A floating-point control brain for fusion goes deaf after about eight seconds,
  forgets what it learned when moved to a machine it has never seen, and **contradicts itself at 142
  operating points**. The exact court refuses all 142, needs no training, and returns a verdict that is
  **byte-identical on every machine** across a 2,992-verdict corpus.
- **A ledger.** An insurance reserve is an exact ratio of the integers a company already filed. Nothing
  in it mathematically requires approximation.
- **A life table.** Across **10,878** actuarial quantities from public archives, the exact arithmetic
  and the float agree to at least fourteen significant digits — a result we publish as gladly as the
  ones that part, because a programme that only reports its wins is advertising.
- **A discovery pipeline.** A generative system reported **37,910 validated discoveries**. Every row
  passed every check made of it. The number of distinct molecules was **five**.
- **A physics result.** A published effect where heat flows the wrong way predicts a *fraction*, so we
  computed the fraction: exactly **−1/18**, at nine of nine settings. Simulated the way the field
  simulates it, in double precision, the effect is **not small — it is zero.**
- **A writing machine.** Two instruments that are both commanded in whole numbers — a lithography
  that lifts single hydrogen atoms off silicon dimers **3.840 Å** apart, and a modulator whose pixels
  sit **4.5 µm** apart, four orders of magnitude out from it — ask the device which atom, and which of
  **256** codes.
  Carry the atom as a length in single precision and the first wrong atom comes at **step 8,783**,
  with **4,183,204 of 4,194,304** sites written to an address nobody asked for. Ask the modulator in
  radians and it is handed a different command word on **16** of **2,073,600** pixels in double
  precision and **1,974** in single. Counted instead, both are **0** — the address *is* the count.
  Neither program touches hardware: no hydrogen is removed and nothing is illuminated.
- **And today, the machines underneath all of it.** Fifty years of computing has treated "which event
  came first" as a fact about *time*, because the founding paper built it on relativity. It was never
  about time. It was about arithmetic. Nine machines, the same jumbled events: sorted into an agreed
  order and not sorted at all gave **the identical answer every time**, and the sorting cost **177×
  the work** to change nothing. **→ [Study 41 — Fifty years of solving the wrong problem](Study-41-What-The-Ordering-Cost)**

## Two studies where the exact quantity was never a measurement

Every study above takes a quantity the world measures and computes it exactly instead. The two sealed
on 2026-09-17 do something narrower. **The quantity was never a measurement.** It is an *address* —
which atom — or a *command word* — which of 256 codes — and the device receiving it is already
discrete. Nothing lies between two atoms on a silicon lattice and nothing lies between two codes on a
modulator, because in neither case is there a state there to reach.

So in these two domains the approximation was never required by the thing being commanded. **It
entered with the software**, on the day a controller chose to carry a length instead of a count.

And the same control arms that establish that also narrowed it, which is the part worth reading.
Study 49 set out to show that π is what makes a float route hand the device a different code. Cancel
π out of the route and the lens goes 16 → **0** in double precision — but only 1,974 → **970** in
single, so about half of that disagreement never involved π at all. π is a sufficient cause
everywhere these two programs look and a necessary one only on the grating and in double precision:
a narrower claim than the one we first wrote, and we reached it by running the arm that could break
it. Study 48 was narrowed the same way — its first draft had the dimer bond along the row when the
published surface puts it across, and the bond is now carried as a REPORTED length held **ABSENT**
from every integer the study compares, with an arm proving the arithmetic is free of it.

**What these two add is a rung, not the board's reach.** The **3.840 Å** dimer pitch is the smallest
length at which anything here is commanded, and Study 49 sits four orders out from it — but the board
was already far wider than the pair, and the pair does not measure it. The smallest figure on the
board is not theirs and is not an address at all:
[Study 27](Study-27-Exact-Nuclear-Scattering.md) works on nuclei, and reports an **¹¹Li rms matter
radius of 3.27 ± 0.24 fm** — five orders below the dimer pitch. That page is careful about its own
number in a way worth repeating here: matter radii "are not measured directly", they are extracted
from cross sections through Glauber-type analyses, so the figure is REPORTED and deduced rather than
measured, and the study grades the extraction rather than trusting it. Upward,
[Study 06](Study-06-Explosion-vs-Earthquake.md) works at station distances of **Δ ≈ 370 km** and
[Study 05](Study-05-Forbush-Decreases.md) at the **L1 point, 1.5 million km** sunward of Earth.
Counting the scale each page states it works at, that is **twenty-four orders of magnitude**, and the
same sentence holds at every one of them.

Read loosely the ceiling is higher still — [Study 08](Study-08-Gaia-BH1-Astrometric-Shear.md)'s Gaia
BH1 is "hundreds of parsecs away", about 3×10¹⁸ m and **thirty-three orders** — and we mark that one a
**bracket rather than a span**, because it is stated only to an order, it is a distance to the target
rather than a length that study grades, and the nine orders beneath it hold **no graded length** —
Studies 07 and 10 do print parsec-scale figures in that band, and both pages forbid posting them into
their own court, so we do not count them here either.
**We do not claim quanta to galaxies.** No page here states a quantum length and none grades a
galactic one; what is measured is nuclear radii to the stellar neighbourhood, and the densely
populated stretch — 3.840 Å up to thousands of kilometres — carries eleven studies.

Neither program touches hardware: no hydrogen is removed, nothing is illuminated, and no voltage is
computed. Each compiles to `wasm32-wasip1` and prints its sealed native transcript byte for byte
under wasmtime. Neither opens in the Studio yet — it is pinned at a commit that carries neither file,
so **the browser figures further up this page are unchanged by these two** and the in-browser run is
**ABSENT** until that pin advances.

**→ [Study 48 — the atom already has an address](Study-48-The-Atom-Already-Has-An-Address)** · **[Study 49 — the phase code never needs π](Study-49-The-Phase-Code-Never-Needs-Pi)**

## Why we think this matters beyond us

Two reasons, and neither requires you to take our side.

**The first is that it can be checked.** Every study here ships as a single file with a hash. No
network, no keys, no database, no permission, no account. You run it and you get our numbers, or you
run it and you don't — and if it cannot measure something honestly it refuses and says so rather than
returning a figure. Set that beside the alternative now in fashion: ten thousand agents, eighty-eight
hours and millions of dollars producing a result that has not been released for anyone to check. It
may well be right. **It is not yet something anyone can act on**, and that is a different and more
serious problem than being wrong. Science's hardest current problem is not dishonesty; it is that most
published results cannot be re-derived by anybody else. **Exact arithmetic removes the last cause of
that by construction: the same input gives the same answer, on any machine, in any order, forever. A
result that can be re-derived exactly cannot rot.**

**The second is what the questions are about.** A tide gauge that can tell a seismic wavefront from a
storm surge inside the first hour is the difference between a coast warned in time and a coast
evacuated for nothing. A seismic ladder that separates an announced explosion from an earthquake in
raw integer counts is the working problem of nuclear-treaty verification. A wet-bulb threshold decides
whether a place stays liveable through an afternoon. A biosphere cascade, a taxi-out floor, a grid, a
reserve, a genome. These are not curiosities. **They are the instruments a civilisation uses to look
after itself and the place it lives**, and every one of them is better for being exact, checkable by
anyone, and the same number for everybody who asks.

## What we are not claiming

We would rather be trusted on the small things than dismissed for a large one.

Nothing here overturns the Standard Model of physics. Not one measurement on this board touches a
particle, a field or a force. What these studies overturn is narrower and entirely real: **a fifty-year
assumption about where uncertainty comes from in computation** — and, one domain at a time, the claim
that a given real-world question *needs* to be approximate. Five studies on this board are still
**OPEN**, meaning we do not have the data yet and say so. Several report results that went against the
expectation, and those stay on the page with their numbers intact. One study on this board reports a
measurement of our own that **proved nothing**, kept because a page that quietly drops its failures is
not a record.

That is the flag. The exact answer is usually already there. It costs an afternoon and a file anyone
can run. **→ [Start here](Shear-Studies-Index)** · [How to read this board](Shear-Studies-Readers-Guide) · [The white paper](Shear-Studies-White-Paper)

---
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

**→ [The CRISPR genome map](CRISPR-Genome-Off-Target-Map)  ·  [The off-target atlas](Oligonucleotide-Off-Target-Atlas)  ·  [The order of the bases](The-Order-Of-The-Bases)**

And they are now somewhere a person can look. The woman in that room, or her doctor, or the
regulator who has to sign for her, can open a **library** and find the molecule: what was measured
about it, by which program, and the one command that re-derives it from public bytes. Three
libraries — [proteins](Library-Of-Proteins), [compound cures](Library-Of-Compound-Cures),
[material systems](Library-Of-Material-Systems) — and each of them says, inside every row, what it
refuses to claim. They are not studies that close. They grow as new cures and new materials are
measured, and nothing enters without a program a stranger can run.

What keeps them libraries rather than lists is the thing in front of them: **[an admission
law](The-Library-Admission-Law)**, executable, that refuses. This programme has already published a
generated corpus that reported 37,910 validated discoveries and held five distinct molecules, where
every single row passed every check made of it. A library with no law is that corpus with a nicer
front page. So the law is the first artefact, and the libraries are downstream of it.

---

## The harder question, and what asking it again found

The same day, we finished a study that had been open since August. It asked something a great deal
of cancer drug development rests on: when a method says *these proteins are what keeps this tumour
alive*, can you recover those proteins from the patient's own data?

We built the corpus from scratch — seventeen tumour types, 7,673 people's tumours, every byte
public. We proved the instrument could tell something from nothing before trusting it: rank the
regulators using half the patients, and 135 to 141 of the 141 come back when you rank them again
using completely different patients. Shuffle the labels and it collapses to nothing. That is a
sharp instrument.

**In eleven of seventeen tumour types, the published regulators come back just as well from
counting how many connections each one has in the network — without opening the patient's data at
all.** In acute myeloid leukaemia the gap is wider still: reading the expression recovers four,
counting connections recovers nine. That is a real result about what the recovery is made of, and
it is worth knowing precisely because it is cheap to check and nobody had checked it.

Then the question that mattered. We searched 20,308 compounds for a single drug that reverses the
signature and found none in any tumour type — and that answer, taken as the end, would have been
the wrong place to stop. Cancer is not treated with one drug. **Asked again of pairs, the same law
with the same controls finds them in eleven of fifteen tumour types**, clearing the exact null that
eliminated every single agent, in every case at zero of two hundred draws.

**Those eleven show promise and warrant laboratory follow-up.** We do not call them safe, effective,
or ready for anyone — that needs a bench, and the page says so as plainly as it says the rest.

None of this says anyone was wrong. It says something more useful: **a question can pass its own
test and still not be the question you meant to ask** — and until today, nothing between a
hypothesis and a $255 million trial made anyone check which.

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

And it is not only a veto — the same exactness is a **seal on a drug that works.** [Zilganersen](The-Safety-Question-Made-Exact) is the first therapy ever approved for Alexander disease, a fatal childhood astrocyte disease that until this year had nothing. One of its safety questions is genuinely discrete — where else in the human transcriptome its sequence can strike — and we have now counted every place, on the real approved molecule: **1,467,336,203 windows enumerated, two perfect matches, both in its own target gene, and not one site anywhere at nineteen of twenty or eighteen of twenty.** After its target, the nearest thing in human biology is three mismatches away. Against sixteen re-orderings of its own bases the real drug carries under half their median off-target burden, so that specificity was designed and can be measured in any candidate **before it is ever synthesised.** That is a certification seal, not a stop sign, and **we measured it.** **[The exact safety screen →](The-Safety-Question-Made-Exact)**

Both belong in the same place: **before a first patient is dosed**, at the design stage, where changing course is still cheap — and for a molecule already in the pipeline, the same exact verdict helps decide the path forward. The instrument that returns it is proven today and buildable now. All of it could be done differently.

**Seven cures now, gathered in one place — and the reason we are giving the method away.** The veto and the seal are two of seven real, in-the-news medicines we put the exact off-target screen against: the first-ever Alexander-disease drug, a halted CAR-T, a base editor for heart disease, a prime editor for chronic granulomatous disease, an antibody-oligo conjugate for Duchenne, and a therapy written for a single child whose disease has a population of one. **[Cures Without the Gatekeeper →](Cures-Without-The-Gatekeeper)**

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
bash reproduce/validate.sh                    # every published figure, digest-pinned
```

The harness prints its own count on every run — it grows with the work, so no page quotes a number that can go stale. It verifies that every figure quoted on these pages appears in the output of the program that claims to produce it, that the corpora match their published digests, and that no page cites a path you cannot reach. **If a check fails, we want the issue.** As we did the day we found a 300× error in our own π-bracket figure — `355/113 − 333/106 = 1/11978 ≈ 8.35×10⁻⁵`, not the `2.7×10⁻⁷` an earlier page claimed — the correction is published with a date on it.

---

## Start here

**If you have five minutes, read down the first block. It is the shortest path from "what is this"
to a medicine, and every row in it is re-derivable from public bytes on a laptop.**

| page | what it is |
|---|---|
| **CURES** ||
| [Cures Without the Gatekeeper](Cures-Without-The-Gatekeeper) | **the medicine front door** — seven real written medicines and the exact off-target screen that makes each one's safety re-derivable by anyone |
| [The off-target atlas](Oligonucleotide-Off-Target-Atlas) | every nucleic-acid medicine the public registry publishes a sequence for — **where** each one can pair, across the whole transcriptome |
| [The order of the bases](The-Order-Of-The-Bases) | and **whether that burden is unusual** — 472 strands each ranked against sixteen rearrangements of its own bases |
| [The library admission law](The-Library-Admission-Law) | the executable law that refuses; the three libraries are downstream of it |
| [Study 26 — master regulator bonds](Study-26-Master-Regulator-Bonds) | 17 tumour types — what actually recovers a published regulator set, and eleven compound pairs where no single agent among 20,308 cleared any |
| **THE METHOD** ||
| [The ontology of this wiki](Ontology) | the type system — grades, terminals, controls, and what each page may say |
| [Study 34 — the observer-invariant verdict](Study-34-Observer-Invariant-Verdict) | the proof on this page, in full — why a safety verdict must be exact |
| [Study 35 — the safety brain that forgets](Study-35-The-Safety-Brain-That-Forgets) | why a floating-point safety brain is doomed, not just behind — it deafens in seconds, forgets across machines, disagrees with itself; the exact one does none of it |
| [Study 48 — the atom already has an address](Study-48-The-Atom-Already-Has-An-Address) | 1 nm hydrogen depassivation lithography — the write target is an integer address on silicon dimers 3.840 Å apart, and a controller carrying a length in single precision mis-addresses its first atom at step 8,783 |
| [Study 49 — the phase code never needs π](Study-49-The-Phase-Code-Never-Needs-Pi) | a modulator takes one of 256 codes per pixel, so the code is a ratio of integers — and the study's own arms narrow where π is the cause and where it is not |
| [All studies](Shear-Studies-Index) | the programme index, every lifecycle state stated |
| **FUSION, AND THE PLANET** ||
| [Affine Fusion Control](Affine-Fusion-Control) | the local exact-integer fusion court — five panels, both laws live, 65,536 agents on one laptop |
| [Affine Fusion Control — public release](Affine-Fusion-Control-Release) | the measured, claim-graded public case for the app |
| [Study 33 — the fusion control verdict court](Study-33-Fusion-Control-Verdict-Court) | the charter, and the three-way fork it retired |
| [Every season, fifty tonnes](SpaceX-Biosphere-Safety) | the SpaceX / satellite biosphere-safety case — the same method, its most urgent application |
| [The full-grade replacement](The-Replacement-Grade) | the over-scaling law, and the vendor-to-public argument across 49 domains |

---

*Every figure on this page is produced by a program in `reproduce/` and, where marked VERIFIED, pinned by digest in `reproduce/validate.sh`. Projections are labelled as projections. Where we do not know, the page says we do not know. Where we were wrong, the correction is dated and the old number is named.*
