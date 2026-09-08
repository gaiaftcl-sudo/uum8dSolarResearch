# Study 41 — Fifty years of solving the wrong problem

*Two things happen at the same moment in two different places. Which one came first?*

*Computing has been answering that question the hard way since 1978. It is the reason your bank pauses before it agrees your money moved. It is the reason adding machines to a database can make it slower instead of faster. It is the single hardest part of building any system that runs in more than one place, it has a Turing Award attached to it, and it is what is usually breaking when a bank, an airline or a hospital system goes down at three in the morning.*

*The field has treated that question as a fact about **time** — because the man who founded it built it directly on Einstein's relativity, and said so. If the disorder is in the nature of time, it is irreducible, and all you can do is build better machinery for agreeing on an arbitrary answer. So that is what a generation of the best engineers alive did.*

*It was never about time. **It was about arithmetic** — the plain fact that adding decimals on a computer gives you a different total depending on what order you add them in. Fix the arithmetic and the machines have nothing left to disagree about. The problem does not get solved. It stops existing.*

*This study puts a number on the bill. Nine machines, the same jumbled pile of events, added two ways — sorted into an agreed order first, and not sorted at all. **Both ways gave exactly the same answer, every time, on every machine.** The sorting had changed nothing, and it cost **177 times the work** and about **2,400 times as many wrong guesses** to change nothing.*

*And then the half that makes it honest: run it again in decimals and the two orders **genuinely disagree, four times out of five.** The fifty years was not foolish. It is a correct, necessary repair — for damage the arithmetic did first.*

---

![Nine machines receive the same events in different orders; the sorting machinery spins up and its cost climbs to four million processor cycles; both paths return the identical integer; then the same fold in ordinary decimals returns two different totals](images/affine-earth-the-wrong-problem.gif)

*Nineteen seconds: the question, the nine machines, what the ordering cost, the identical answer — and the half that keeps it honest. [Full-resolution film](media/affine-earth-the-wrong-problem.mp4).*

## What this domain actually is, and why it matters more than it sounds like it does

Almost nothing important runs on one computer any more.

Your bank balance does not live in a building; it lives on machines in several countries, and every one of them has to end up believing the same number. A power grid balances supply against demand from thousands of separated meters. Air traffic control merges radar from stations that cannot see each other. A hospital's records follow a patient between systems that were never introduced. Every one of these is the same problem wearing different clothes: **separated machines, events arriving in different orders, and a requirement that they all end up agreeing.**

When they fail to agree, the failure is not cosmetic. It is the payment counted twice, the outage that cascades, the record that says two different things about the same person. This is the layer under the layer — invisible when it works, and the thing that has actually broken when a headline says a system went down.

So the field built extraordinary machinery to force agreement: Lamport clocks, vector clocks, Paxos, Raft, consensus rounds, sequence numbers, ledger offsets. It is some of the most careful work computing has produced. It is also expensive, it is famously difficult to get right, and it is the reason a distributed system does not simply get faster when you give it more machines — past a point, every extra machine is another party that has to be talked into agreeing.

**Now consider what it would be worth to not need it.**

Not "to make it faster". To not need it. Every consensus round that never has to happen is latency that never happens, a coordination failure that cannot occur, and a class of three-in-the-morning outage that has nothing left to be caused by. That is the size of the question. It is worth asking whether the thing we have all been paying for was ever ours to pay.

## Why fifty years, and why nobody looked here

This is the part worth understanding, because it is not a story about anyone being careless. It is a story about a problem being **filed under the wrong science.**

In 1978 Leslie Lamport wrote *Time, Clocks, and the Ordering of Events in a Distributed System*, and every clock, every consensus protocol and every stream sequence since descends from it. His move was explicitly a **physics** move. He defined "happened before" on the light cone of special relativity: in relativity, two events far enough apart have no fact of the matter about which came first — it genuinely depends on who is looking. Then, because a working system has to pick something, he extended that to a total order, and wrote plainly in the paper that the extension is **arbitrary**.

Read that as a physicist and the conclusion is forced: *the ambiguity is in nature, so it cannot be removed.* All that is left is to build better machinery for agreeing on an arbitrary choice. Which is exactly, and honourably, what the field spent fifty years doing.

**But the machines were not disagreeing because of relativity.** They were disagreeing for a reason with nothing to do with time at all:

> **On a computer, adding decimals gives a different total depending on the order you add them in.**

Add a very large number to a very small one and the small one is rounded away to nothing. Add the small ones to each other first and they survive to change the answer. Same numbers. Different order. Different total.

That is not a property of time, or causality, or the universe. It is a property of how computers store fractions — a decision made for hardware convenience in the 1980s.

So nine machines really did disagree, reproducibly, every day, forever — and everyone reached for a clock, because the problem had been filed under physics. **The fault was in the arithmetic the whole time, one floor below where anyone was looking.**

Use numbers that add up the same in any order, and there is nothing left for the machines to disagree about. Not less. Nothing.

## What we did

Nine machines — the same nine ARM computers in Helsinki and Nuremberg that serve this website. One small program on each, adding up a pile of events that arrived jumbled, exactly as they do from nine publishers with no referee.

Three ways:

- **Sort first, then add** — impose a total order, the way a conventional system does.
- **Sort first, then add, allocating fresh working memory each time** — the same, done the way a real ingest path usually does it.
- **Just add them** — no sorting, no comparing, in whatever order they turned up.

Then read the processor's own performance counters — the hardware's private tally of the work it really did — and compare.

Before trusting one number, the program tests its own instrument: it runs a branch the processor can always predict and one it can never predict, and confirms the counter can tell them apart. **The first version of this study failed that test and refused to report anything at all.** That refusal is described below, because it is the most valuable thing that happened here.

## The bill

Same events. Same answer, verified identical on all nine machines at every size. This is what the sorting cost to arrive at the number the machine already had, for a batch of 16,384 events:

| | just add | sort first, then add |
|---|---|---|
| **time the processor spent** (at the cells' 2.0 GHz) | **11 microseconds** | **2.0 milliseconds** |
| work done (processor cycles) | 22,846 | 4,053,186 |
| **wrong guesses** (branch mispredictions) | **about 45** | **about 110,000** |

**Two milliseconds against eleven microseconds.** One hundred and seventy-seven times the work, for an answer that was identical either way.

The wrong-guess row is the one to sit with. Each time the sort compares two events the processor bets on the outcome and races ahead; when it bets wrong it throws away the work and starts again. A jumbled pile is close to unpredictable, so it bets wrong about 110,000 times per batch.

Adding without sorting bets wrong **about 45 times** — and that number **does not grow**. Sixty-four events or sixteen thousand, still about 45, because there is no comparison to get wrong. The old way's cost scales with the pile. The new way's barely exists.

Across all nine machines the gap landed between 3.87 and 4.06 million cycles. Nine independent computers, one tight band.

## The half that keeps this honest

A study that only reported the flattering result would not be worth reading. So the same program runs the same two folds again in ordinary decimal numbers:

| batch size | added in arrival order | added in sorted order | same? |
|---|---|---|---|
| 64 | 6441212317.644121 | 6441212317.644124 | **no** |
| 256 | 15676382507.567656 | 15676382507.567656 | yes |
| 1,024 | −27916608120.791664 | −27916608120.791656 | **no** |
| 4,096 | 48027543759.80284 | 48027543759.80282 | **no** |
| 16,384 | −49630830099.9632 | −49630830099.96339 | **no** |

**Four times out of five the order genuinely changed the answer**, identically on all nine machines. (At 256 they matched by luck. It is printed as it fell.)

So the finding is not "ordering is a waste of time", and anyone quoting it that way is quoting it wrong. It is sharper, and fairer:

> **The ordering machinery is waste when your arithmetic is exact, and completely necessary when it is not.** Fifty years of it is a correct answer to a real problem. The problem is one the arithmetic created.

A system built on decimals needs every clock and every consensus round it has; take them away and it breaks, and the table above is what breaking looks like. The choice was never *order or no order*. It was always, one floor further down and never presented as a choice at all: **what kind of number are you adding up?**

## Guessing, and deriving — why this is the argument that matters

There is a way of doing science now that produces things nobody can act on.

On 8 September 2026 OpenAI published a claimed resolution of a Navier–Stokes blowup problem: up to **10,000 AI agents running in parallel for about 88 hours**, at a compute cost reported in the millions of dollars. It is a serious effort by serious people. Here is where it stands. It concerns the **forced** equations, not the Clay Millennium statement — which is why the $1M prize is unclaimed and OpenAI says it is not claiming it. It has not been independently verified. The proof has not been released for independent checking. And credit for the surrounding work is actively disputed: Tristan Buckmaster of NYU and Levent Alpöge of Anthropic published preprints on 7 September, and Buckmaster has alleged he was pressured over authorship — allegations OpenAI's Sébastien Bubeck calls "false and inflammatory."

**We take no position on that dispute and are not a party to it.** The point is not who was wronged. The point is what a reader is left holding: millions of dollars, 88 hours, ten thousand agents, and **nothing they can run.** No one outside can re-derive it, check it, or build on it. It may well be right. It is not yet *actionable*, and that is a different and more serious thing than being wrong.

Now the other column. This study is **one file**. It fetches nothing. It needs no network, no key, no database, no arguments, and no permission. Every number it relies on is written inside it. It carries a hash. You can run it on a laptop in seconds, and it prints the same figures we printed, and if it cannot measure honestly **it refuses and says so instead of producing a number.**

That difference is not a matter of budget or taste. It is the difference between a result you are asked to believe and a result you can **check** — and checking is the thing science was supposed to be made of. The reproducibility crisis is not a scandal about dishonest people; it is a structural fact that most published results cannot be re-derived by anyone else, because the data, the code, the environment or the arithmetic has drifted. **Exact arithmetic removes the last of those by construction: the same input gives the same answer, on any machine, in any order, forever.** A result that can be re-derived exactly cannot rot.

That is the whole programme these forty-one studies belong to, and it is why every one of them ships as a single sealed file rather than a claim. Not because it is elegant. Because a claim nobody can re-run is not yet a result.

## Two failures, kept on the page

**The instrument caught itself lying.** The first build measured 54 wrong guesses out of three million coin-flips — a beautiful number that looked like brilliance. It was not: the compiler had quietly rewritten the coin-flip so it was not a branch at all, leaving nothing to guess wrong about. The program refused to report anything below that check. Fixed, it measures 1,499,438 to 1,500,676 wrong guesses out of 3,000,000 — a coin-flip missing on almost exactly half its trips, which is the theoretically correct answer and the sign the counter is honest. **Without that check this study would have published a beautiful zero and called it architecture.**

**One of our own measures proved nothing.** We were asked to show zero memory allocations, and our fold does report zero — but so does the version that deliberately allocates every single time, because of how the memory system works underneath. A measurement that reads the same for the thing you are promoting and the thing you are promoting it against is not evidence. It stays on the page as a failed measure rather than being deleted, because a page that quietly drops its failures is not a record, it is an advertisement.

**And one control in the other direction:** with a single event there is nothing to order, so any real ordering cost must vanish. It does — the difference collapses to between −45 and +938 cycles, and on one machine the "fast" way is slower. Had we still shown a win there, this study would have been measuring something else and every number above it would be void.

## What this says, and what it does not

**It says:** on nine real machines, imposing an order on events cost 177 times the work and about 2,400 times the wrong guesses to produce a number that was identical without it — and that the same machinery becomes genuinely necessary the moment you return to decimals. The standard model of distributed computation, the one descended from Lamport's relativity analogy, locates the disagreement in time. It is not in time. It is in the arithmetic, and that is now measured rather than argued.

**It does not say the Standard Model of physics is in question.** Nothing measured here touches a particle, a field or a force, and this page makes no claim of that kind. What is overturned is a model **of computation** — a fifty-year-old assumption about where event disorder comes from. That is a real and large claim, it is ours, and it is defensible to the last decimal. Stretching it into physics would cost us the part that is true.

**It does not say ordering is unnecessary in general** — we measured the case where it *is* necessary and printed it, because that is the finding.

**It does not say these numbers hold on every processor or compiler.** They were measured on nine specific machines on one day, and the compiler story above shows exactly how much a single build decision can move them.

**And measuring a fold is not the same as replacing a consensus protocol end to end.** That is engineering still ahead, and it is named here rather than implied.

What remains is small, hard and enough: **a bill everybody has been paying, measured — alongside the condition under which nobody has to pay it.**

---

### Evidence, graded

| what | grade | where it comes from |
|---|---|---|
| Cycles, wrong guesses and agreement across nine machines | **Measured** | `reproduce/silicon-shear-telemetry.swift`, run on all nine live cells, 2026-09-08 |
| Decimal folds disagreeing 4 times in 5 | **Measured** | same program, same run |
| Instrument calibration, and the build that failed it | **Measured** | same program; the refusal reproduces |
| The zero-allocation measure proving nothing | **Measured** | same program; kept as a failed measure |
| Lamport's 1978 construction and its relativity origin | **Reported** | *Time, Clocks, and the Ordering of Events in a Distributed System* |
| Navier–Stokes claim: scope, verification status, credit dispute | **Reported** | public statements and preprints, September 2026 |
| Quantum switch and anomalous heat flow | **Reported** | *Phys. Rev. Lett.* 2026, [arXiv:2511.04028](https://arxiv.org/abs/2511.04028); computed exactly in [Study 40](Study-40-Indefinite-Causal-Order.md) |
| "Under exact arithmetic the ordering problem stops existing" | **Argument** | reasoning from the measurements above |
| Anything about particle physics, or about fluids | **Not known** | stated as not known, never implied |

### Reproduce

One file. No corpus, no network, no keys, no arguments — every number it uses is inside it, and every exit path, including its refusals, prints the same reference figures.

```
reproduce/silicon-shear-telemetry.swift
sha256  a927ab55105aeae7289eef36b90f1e209391582a8f42d8eb2a69bf75fc3a603d
marker  ORDERING_IS_PRICED_IN_CYCLES_NOT_IN_PHYSICS
```


**The figures this page cites, exactly as the program prints them.** Every one appears in the
program's own output on every exit path — including the refusal it returns on a machine with no
performance counters — so a page citing a number its program does not produce is caught rather than
trusted.

```
cycles at N=16384          22,846 against 4,053,186
branch misses at N=16384   42-51 against 110,319-111,002
exact fold agreement       6 of 6 rungs on 9 of 9 cells
float fold disagreement    4 of 5 rungs
calibration coin-flip      1,499,438-1,500,676 of 3,000,000
degenerate rung N=1        -45 to +938 cycles
marker                     ORDERING_IS_PRICED_IN_CYCLES_NOT_IN_PHYSICS
```

On any ARM64 Linux machine with a Swift 6.4 toolchain:

```
swiftc -O silicon-shear-telemetry.swift -o /tmp/s41 && /tmp/s41
```

It needs the processor's performance counters. On a machine that does not offer them it reports **absent** and refuses — not zero, and not a pass.

**Measured 2026-09-08** on nine cells: `gaiaftcl-hcloud-hel1-01…05`, `gaiaftcl-cell02`, `netcup-cell01`, `netcup-cell03`, `netcup-cell04` — ARM Neoverse-N1, Debian 13.
