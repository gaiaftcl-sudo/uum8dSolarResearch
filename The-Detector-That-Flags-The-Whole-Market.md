# The market-surveillance detector that flags the whole market

*A manipulation-geometry instrument built in exact integers, pointed at two complete public
order-book sessions sixteen years apart and at 1,000 contiguous Ethereum blocks. The first thing it
measured was its own field's most-used indicator, and that indicator does not survive the
measurement. What survives is published at the same weight, with its controls, its nulls and its
false-positive floor.*

**Said once, on the face of the page, not in a footnote: detection of a geometry is not proof of
intent, and intent is a statutory element of manipulation.** Nothing here names or implies
wrongdoing by any identifiable participant beyond what a regulator has already published. No
simulation on this page validates a legal theory, and no measurement bypasses intent.

---

## The refutation, first, because it bounds everything under it

The most common shape a surveillance product takes is a detector keyed on cancellation — displayed
size that never executes, orders with short lifetimes, liquidity that vanishes. Run that predicate
alone over a complete session and it does not find anything. **It counts the market.**

```
PHANTOM alone — displayed size that never executed
  Nasdaq BX TotalView-ITCH 5.0, 2019-07-30
    12,676,036 orders terminated · 12,156,283 never executed
    958 per 1,000 of orders  ·  988 per 1,000 of shares

  Nasdaq ITCH v2, 2003-01-03
     2,921,796 orders terminated ·  2,732,598 never executed
    935 per 1,000 of orders  ·  936 per 1,000 of shares
```

Sixteen years and a protocol generation apart — v2 carries no Delete and no Replace message at all,
5.0 splits termination into DELETE 10,164,658 / REPLACE 2,046,443 / DRAINED 464,935 — and the reading
moves by 2.3 points. Reg NMS, sub-penny quoting, maker-taker and modern electronic market making all
arrived between those two files and the number stayed put. That is the signature of a *structural*
quantity, not a behavioural one. Market makers cancel constantly; that is the job.

**A detector keyed on cancellation, on order lifetime, or on displayed liquidity that never trades
measures market making.** This is the denominator every cancellation claim has to be stated against,
and it is the first question to put to any such instrument: *what does it score on an ordinary
session with nobody in it doing anything?*

### The regulator's own indicator lands in the same place

MAR Annex I A(f) is a **conjunction**: orders that change the representation of the best bid or
offer AND are removed before execution. Computed in full over the same session, with a control run
through the identical kernel:

| population | A(f), strict NEW-price reading | A(f), NEW-or-JOIN reading |
|---|---:|---:|
| second conjunct alone (the cancellation half) | **9,589 bp** | — |
| BX session, all 12,676,036 entered orders | **5,384 bp** (6,825,510) | **7,665 bp** (9,716,694) |
| synthetic pure market maker, IMPROVE mode | **9,189 bp** | 9,189 bp |
| synthetic pure market maker, JOIN mode | 0 bp | 9,999 bp |

The control is a two-sided, symmetric, non-directional, zero-advantage quoter that predicts nothing
and re-quotes every round — it improves the displayed touch on **600,000 of 600,000** orders,
`maker_first_bp_N = 10,000` — emitted as a real ITCH byte stream and measured by the same kernel
through its own MPID. **It scores 1.71× the population it is supposed to be separated from.**

And the scalar hides the finding, so the distribution is published instead. Against the 4,786 symbols
carrying ≥ 100 entered orders in the same session:

```
the refuting control sits at the 85.14th percentile of ordinary symbols
  711 of 4,786 symbols score at or above it
3,727 of 4,786 score at or above the session's own 5,384 bp
  170 symbols sit at a perfect 10,000 bp — every entered order improved
      the touch and was withdrawn unexecuted
  mean qualifying symbol rate 7,032 bp
```

The same maker, differing only in whether it quotes one tick *inside* the touch or *at* it, spans 0
to 9,189 bp. **A(f) computed in full sorts by quoting style, not by conduct.** The program prints
this as a verdict token rather than a paragraph:

```
AF_VERDICT_READING_N   REFUTED_CONTROL_SCORES_HIGHER  worst_separation_bp -3805
AF_VERDICT_READING_J   REFUTED_CONTROL_SCORES_HIGHER  worst_separation_bp -2334
```

Handed a single population with no control at all, it refuses rather than warns:
`AF_VERDICT_READING_N REFUSED_SINGLE_POPULATION`.

**The narrow claim, stated narrowly.** The maker is a model; its 9,189 bp is a property of parameters
chosen here, not a measurement of any firm. What is carried is the existence claim — *there exists a
legitimate two-sided quoter that scores 91.89% on the regulator's indicator computed in full* — and
that is sufficient to refute a separating claim, which is all that is asserted.

---

## What works, at full magnitude

### The Ethereum conjunct set — 2,433× against the naive geometry, 108 of 108 reproduced independently

On a venue that publishes intra-block ordering as consensus data, the discriminator equities cannot
compute — *same participant on both sides* — is a first-class field. The geometry becomes exactly
decidable, and it separates:

```
naive positional geometry (same submitter at tx a and tx c, anybody between,
  no pool, no direction, no swap event)   262,799 brackets in 848 of 1,000 blocks
the conjunct set                                 108
                                          ------------
reduction                                    2,433x, and all 108 lie inside the 262,799

addresses round-tripping one pool inside one block      256
  flagged                                                26
  NOT flagged                                           230       = 101 per 1,000 flagged
ordered pairs tested 22,287 -> 108                      = 4.8 per 1,000
```

**230 of 256 addresses that round-trip a pool inside a single block are not flagged** — and that is
the population most superficially similar to the one that is.

The 108 were then re-derived by an independently written kernel sharing **no code**: Foundation
`JSONSerialization` instead of a hand-rolled byte scanner, signed 256-bit as 32 big-endian bytes with
byte-level arithmetic instead of four 64-bit limbs, an explicit sort by `(transactionIndex, logIndex)`
where the detector relies on file order.

| quantity | detector | independent re-derivation |
|---|---:|---:|
| receipts · logs | 200,826 · 276,014 | 200,826 · 276,014 |
| Uniswap V2 · V3 swaps | 13,272 · 3,245 | 13,272 · 3,245 |
| ordered pairs tested | 22,287 | 22,287 |
| strict brackets | **126** | **126** |
| extractive | **108** | **108** |
| distinct bracketing · extractive actors | 28 · 26 | 28 · 26 |

Keyed on `(block, pool, actor, tx_front, tx_victim, tx_back)` and diffed: **108 in common, 0
detector-only, 0 re-derive-only**, all 108 `net_token0`/`net_token1` decimal pairs byte-identical
across the two 256-bit implementations. A third route built from transaction submitters alone — no
pool, no direction, no swap event — contains all 108 and none outside.

### The equities composite — it separates from its own control in every cell of its ladder

```
PHANTOM  AND  D2 (a price level whose displayed size >= S never filled)
         AND  D3 (an opposite-side execution within W ns before withdrawal)

BX 2019-07-30   flag 88,900   control 63,140   ratio 1,407 per 1,000
                per-cell min 1,223 · max 3,500 · all 25 cells above 1,000
                = 7.3 per 1,000 of the 12,156,283 phantom orders
ITCH v2 2003    flag  1,643   control  1,033   ratio 1,590 per 1,000 · min 1,377
```

The control is the same mechanism with exactly one field changed — D3 keyed to the **same-side**
execution clock instead of the opposite side. That is the only kind of control worth having: a
control driven by a different mechanism stays lit through the failure it was built to exclude.

**7.3 per 1,000, not 958 per 1,000.** The instrument prints `D3_VERDICT RATIO_PUBLISHED_NO_THRESHOLD`
and applies no cut to that ratio anywhere, and the refusal is itself measured: a reader who draws the
line at 1,450 gets opposite answers on the two sessions from the same code.

---

## The invariants

An invariant here is a relation that held across independent conditions and whose failure would have
been visible. A quantity measured once is a measurement, not an invariant, however large it is.
**Six clear. Four candidates were narrowed before they cleared, and seven adjacent claims are
rejected outright.**

### INV-1 · The cancellation base state of a limit order book — clears as a BAND, orders-weighted only

**The invariant is the band [935, 958] per 1,000, not the point.** Stating it as "≈95%" is an
overclaim from n=2. What clears is the order of magnitude and the direction of stability.

*Why it matters.* It is the denominator. If you are building or buying surveillance, the base state
of the thing you are watching is that almost nothing you see ever trades.

*The control, and the condition that is missing.* Two conditions are genuinely independent — sixteen
years of market structure, and two wire vocabularies with different withdrawal semantics. One is
**not**: both files come from one publisher and one operator family. This is an invariant of
Nasdaq-operated books, not yet of electronic limit order books in general. PSX (30,467,321 messages)
and IEX DEEP (32,123,581 messages) are already fetched and byte-closed, and the predicate has
**not** been run on them. That is the cheapest available third condition and it was not taken.

```bash
bash reproduce/market-shear-run.sh   # builds reproduce/msx, then both ITCH sessions
#                                   (the full recipe is under Reproduce, below)
# or, one session at a time, against the digests pinned in market-shear-corpus.sha256:
reproduce/msx itch50 --gz corpus/market-shear/itch/20190730.BX_ITCH_50.gz --expect-sha256 a0a05701...
reproduce/msx itchv2 --zip corpus/market-shear/itch/S010303-v2.zip --member S010303-v2.txt --expect-sha256 eb67a239...
```

### INV-2 · The insertion-shear conjunct set is implementation-invariant and a strict refinement — clears

What clears is not a rate. It is that the conjunct set names **one and only one** set of objects in a
block, and two independently written implementations reading the same bytes select the identical set,
member for member. Reimplementable from this paragraph alone:

For block *B* and AMM pool *P*, let `SWAPS(B,P)` be the swap events on *P* ordered by the integer
pair `(transactionIndex, logIndex)`. Uniformly across Uniswap V2 and V3, define the signed 256-bit
deltas **the pool received**: V2 `d0 = amount0In − amount0Out`, `d1 = amount1In − amount1Out`; V3
`d0 = amount0`, `d1 = amount1` (already pool-relative signed). Then

```
dir(s) = 0 if d0(s) > 0 else 1        which token the trader sold
who(s) = the `from` address of the transaction carrying s — the submitting EOA,
         NOT the router named in the event's indexed `sender` topic
tx(s)  = its transactionIndex

SHEAR(i,j,k), for i < j < k in SWAPS(B,P):
 (1) who(i) == who(k)      same participant on BOTH bracketing legs
 (2) who(j) != who(i)      the bracketed vector is a different party
 (3) dir(i) != dir(k)      the bracketing legs are on OPPOSITE sides
 (4) dir(j) == dir(i)      the bracketed vector runs WITH the front leg
 (5) tx(i), tx(j), tx(k) all distinct

EXTRACTIVE(i,k), price-free and exact, in signed 256-bit:
 n0 = -(d0(i)+d0(k)),  n1 = -(d1(i)+d1(k))
 EXTRACTIVE == n0 >= 0 AND n1 >= 0 AND (n0 > 0 OR n1 > 0)
 — not worse off in either token, strictly better in at least one.
 No price, no oracle, no conversion, no float.
```

The **live-wire** variant adds two conjuncts and drops one requirement, and that difference travels
with the claim: (6) no swap by `who(i)` on *P* lies strictly between the legs — they must be that
address's own *adjacent* swaps on the pool; (4b) `tx(k) − tx(i) ≤ MAX_LEG_SPAN`, default 3, a
**stated and fitted** parameter printed on every run; and EXTRACTIVE is *reported* as a field rather
than required, so a live detection is not an extraction claim.

*Why conjunct (4) is load-bearing.* It is the same logic as A(f)'s never-computed first conjunct: did
the front leg move the price in the direction the next participant then paid? Its complement — the
enclosed swap running **against** the front leg — is the shape of ordinary two-sided quoting, and it
is counted and published as **round-trip straddle** rather than discarded, because the straddle count
is the two-sided-quoting denominator.

```bash
reproduce/msx eth --dir corpus/market-shear/eth --start 14000000 --count 1000 \
     --expect-blocks 2f3c1b9f... --expect-receipts af09271d...

# the independent re-derivation, sharing no code with the kernel above
swiftc -O reproduce/market-shear-rederive.swift -o /tmp/rederive
/tmp/rederive --receipts corpus/market-shear/eth/receipts.ndjson \
              --blocks   corpus/market-shear/eth/blocks.ndjson

# the naive positional geometry — the 262,799-bracket null
swiftc -O reproduce/market-shear-positional.swift -o /tmp/positional
/tmp/positional --receipts corpus/market-shear/eth/receipts.ndjson
```

### INV-3 · The sign of the composite-versus-control separation — clears as a SIGN only, and is the weakest of the six

The composite exceeds its own same-mechanism control in every cell of a 5×5 (S,W) ladder on both
corpora and the direction never reverses. **The direction clears on two independent sessions. The
magnitude does not** — 1,407 against 1,590 aggregate, 1,223 to 3,500 per cell.

*What must not be claimed.* Per-cell agreement across a ladder is **not** 25 independent
confirmations. The cells are nested — the same orders are counted at successive thresholds — so
ladder agreement is internal consistency, not replication. The replication is the second corpus, and
n there is 2. The v2 ladder is partly degenerate by construction, which the aggregate hides: that
corpus timestamps in **milliseconds**, so its W = 1,000 / 10,000 / 100,000 ns columns are identical
(18/18/18, 12/12/12, 9/9/9, 9/9/9, 5/5/5) — at most 15 of its 25 cells are distinct measurements. On
BX the smallest cells carry 2 against 1 and 7 against 2; those are integers out of single digits and
carry almost no weight. The separation is carried by the large cells — 28,629 against 20,686 at
(S=100, W=1e7), 12,032 against 7,187 at (S=100, W=1e6).

### INV-4 · Block self-consistency — the cleanest of the six, and the one that generalises furthest

For any Ethereum block, three fields a response carries redundantly must agree:

```
txCount == 0  <=>  gasUsed == 0  <=>  transactionsRoot == EMPTY_TRIE_ROOT (0x56e81f17...b421)
```

Gas cannot be burned by no transactions. A transactions root that is not the empty-trie root commits
to transactions the body omits. Both directions are checked and the guard emits four distinct
verdicts rather than a boolean: `ACCEPT`, `ACCEPT_GENUINELY_EMPTY`,
`REFUSE_SELF_CONTRADICTORY_EMPTY` (naming which contradiction fired), `REFUSE_TX_WITHOUT_GAS`.

*This is not a statistical finding and it was not discovered here.* It is a protocol invariant this
study **checked**, and the value is entirely in the checking — it caught a live trap every weaker
check passes. `rpc.flashbots.net`, asked for block 14,000,000, returns HTTP 200, no JSON-RPC error, a
well-formed body, the **real** block hash `0x9bff4917…d9446`, the real `transactionsRoot`, `gasUsed`
8,119,826 — and `transactions[]` empty. A status check passes it. A hash check passes it. Three
independent endpoints return 112 transactions for that block. Refusal reason, verbatim:

> `txcount=0 but gasUsed=8119826 — gas cannot be burned by no transactions`

*Why it matters far past this study.* It is one instance of a general shape that costs nothing and
needs no second source: **count every item into exactly one bucket and require the buckets to sum to
a total derived independently.** The study runs that shape in four more places and every one closed —
the ITCH byte closure (780,003,536 payload + 57,469,372 framing = 837,472,908 decompressed, 0
trailing unconsumed); the 4×4 A(f) contingency table summing to 12,676,036 with all five marginals
matching their references; the wire detector's refusal ladder summing to leg pairs examined; the log
partition (V2 1,667 + V3 3,706 + wrong-shape 0 + other topic0 166,825 = 172,198). If you take one
thing from this page into unrelated work, take this one.

```bash
reproduce/lww --emptiness   # runs the guard against the documented trap, both directions
```

### INV-5 · Exactness on the decision path, and what it actually buys

```
whole binary   59,694 instructions ·  0 fp arithmetic · 25 fmov (value-witness copies,
                                                        emission, self-test closures)
decision path  15,393 instructions across 93 symbols · 0 fp arithmetic · 0 fp moves
control        a two-line Double program, rebuilt on every scan ·  5 fp
               (fmul 2, fdiv 1, fadd 1, scvtf 1)
```

The generic argument — reproducibility across machines and libm versions — is true and weak. The
specific one is decisive, and it is visible in this corpus's own printed integers. The EXTRACTIVE
filter is the entire step that takes 126 brackets to 108, and it is decided by the **sign** of `n0`
and `n1`. The two residuals nearest the boundary:

```
block 14000708  pool ef4553a9   net_token0                  -2   net_token1  54,100,100,869,088,297
block 14000677  pool d2111624   net_token0 239,952,055,114,733,238   net_token1               -113
```

Those are differences of leg amounts of order 1e17–1e19. IEEE-754 binary64 is exact only below
2⁵³ ≈ 9.007e15; near 1.4e19 — the magnitude of a real leg amount in this corpus,
`14,077,314,269,560,450,260` — one unit in the last place is **2,048**. A residual of −2 or −113 is
three orders of magnitude below the rounding error of its own operands. In a double pipeline the sign
of the extraction test is not computed from the data; it is an artefact of the rounding, and the same
bracket classifies either way on two hosts.

**That is what exactness buys.** The verdict is a function of the bytes and of nothing else. Two
parties on opposite sides of a dispute re-run the pinned bytes and reach the same integers, or the
pin fails and the run refuses. A float pipeline cannot offer that, because *"re-run it"* stops being
a resolution procedure the moment the answer depends on the host.

This is not a constraint imposed on the problem — it is the problem restored to its own
representation. ITCH prices are integer ticks, sizes integer shares, timestamps integer nanoseconds;
Ethereum amounts are 256-bit integers and gas prices integer wei. Ratios throughout are floor-divided
integer permille, which is why the composite prints **1,407** and not 1.408.

```bash
# The scanner builds and scans its own two-line Double control on EVERY run and refuses
# if that control does not fire, so a reading of zero is never a reading from a dead
# instrument. Run it with no subject to see the control alone:
bash reproduce/market-shear-fpscan.sh --control-only          # 5 — the control fires
bash reproduce/market-shear-fpscan.sh reproduce/msx $(cat reproduce/market-shear-decision-syms.txt)
                                                             # 0 of 15,393
```

### INV-6 · A single population carries no verdict — clears on four independent mechanisms

A rate measured on one population is a measurement. It becomes a verdict only against a control run
through the same kernel. **The study broke this four separate times, in four unrelated subsystems,
and caught each one by measurement rather than by review.**

1. **MAR A(f).** The old verdict line was a fixed 5,000 bp cut on one population. Fed the JOIN-mode
   maker — a legitimate quoter on which the strict reading is definitionally 0 — it printed
   `DISCRIMINATES 0 bp`. It certified the indicator as sound at precisely the point where the
   indicator was blind.
2. **The control's own size.** A control of **two** orders flipped the verdict to `SEPARATES 4,418 bp`,
   because at n=2 one order is worth 5,000 bp — half the entire scale the verdict is printed in.
3. **The null generator.** A 2³¹-modulus LCG read at its low bits produced **0 detections across
   223,500 leg pairs** — an always-green arm reporting a false-positive rate of zero that was a fact
   about the generator, not the detector.
4. **The float scanner's own control.** Scoped to `_main`, the control over a two-line `Double`
   program reported 0 FP arithmetic — a rule scoped to where you expect the violation will not catch
   it where it happens.

The repair is a gate, not a paragraph: **a control must be INFORMATIVE, not merely present.** Two
floors, both derived from the program's own printed arithmetic before any measurement, never chosen:

- **Floor 1, on control size.** Every rate is an integer basis point and `bp(x,n) = 10000x/n` floored,
  so one order in a control of *n* is worth `10000/n` bp. A control where one order moves the score by
  a whole basis point cannot be read at the resolution the verdict is printed in. Smallest *n* with
  `10000/n < 1` is **`CONTROL_MIN_ORDERS = 10,001`**.
- **Floor 2, on control orders that REACHED the conjunction.** A(f) is a conjunction, so an order
  reaches the second conjunct only if it satisfied the first under the reading being scored. The
  control's arithmetic ceiling is `bp(reached, entered)`; a control with ceiling *C* can change the
  verdict only for measured populations in `[SEP, SEP+C)`, and at C=0 that band is **empty**. Require
  `C >= SEPARATION_REQUIRED_BP`, i.e. `ceil(SEP × entered / 10000)` = **120,000** at 600,000 orders
  against the 2,000 bp bar.

A failing pair prints `AF_CONTROL_UNINFORMATIVE` with its counts and contributes no verdict input; a
reading with no admitted control prints `REFUSED_CONTROL_UNINFORMATIVE`; and when nothing is admitted
at all the separation header is not printed either (`separation_rendered NONE`) — because an empty
table and a table never built are different answers. Both `AF_VERDICT` lines above are **unchanged**
by this gate, because the row carrying the refutation was never the row that was uninformative.

```bash
reproduce/afc --selftest                          # 31 arms, R10 floors included
AF_NO_CONTROL=1 reproduce/afc lbl < session       # REFUSED_SINGLE_POPULATION
reproduce/lww --null-shape 3 12 100000            # NULL_POPULATION_UNINFORMATIVE, exits 1
```

---

## The live wire, at zero cost

An agent sat on the Ethereum mainnet wire at the chain head and emitted insertion detections with
transaction hashes while the chain advanced.

```
run 2   721 s · 60 blocks 25,927,780..25,927,839 · contiguous
        559 head polls (499 saw no new block)
        0 head jumps greater than 1 block in 1,076 polls across both live runs
        60 of 60 cross-confirmed by a SECOND INDEPENDENT ENDPOINT —
           identical block hash, identical receipt count, BYTE-IDENTICAL derived swap set
        0 quarantined · 4 insertions emitted with full transaction hashes

        detector kernel  min 2 us · max 75 us   against a ~12,000 ms block interval
        observation lag  min 0 s · max 12 s · mean 2 s   (chain propagation + poll interval)

COST    815 HTTP requests · 100,426,957 bytes
        no API key · no account · no licence · no exchange agreement
        no counterparty permission · no subscription · no market-data fee
```

Ethereum mainnet publishes intra-block ordering as consensus data and anyone may read it for
nothing. That property is the reason this arm exists, and it is the reason the geometry is decidable
here and only partially decidable on a public equities feed.

**The most trustworthy thing the watcher does is the run that emitted nothing.** An earlier watch
found four detections of the same shape and **held every one of them unemitted**, because the
confirming endpoint returned `NOT_KNOWN` on 55 of 56 blocks:

| run | blocks | cross-confirmed | quarantined | detections |
|---|---:|---|---:|---|
| live 1 | 56 | 1 of 56 | **55** | 4 — **HELD, never emitted** |
| live 2 | 60 | 60 of 60 | 0 | **4 emitted** |
| replay | 20 | 20 of 20 | 0 | 1 emitted |

A detection that cannot be confirmed on a second independent endpoint is not published as a
detection. Including run 1's four held detections would raise the live rate and move the separation
**up**, from 83× to 94× — so the choice is not load-bearing, and the lower figure is the one carried.

Four answers are kept apart on every wire verdict and never print alike: **ABSENCE**, **REFUSAL**,
**BOT_BLOCKED** and **NOT_KNOWN**.

---

## The corrections this study made to itself

Published on the page's own face, because a study that shows its corrections is the only kind worth
trusting.

**Four cited numbers were withdrawn when a null turned out degenerate.** The first null's harness
tied the address draw to the direction draw inside one LCG, so **14,506 of 14,591 same-sender leg
pairs (99.4%) ran the same direction**, suppressing opposite-direction round trips ~85×. A proper
null gives 51.2%. The withdrawn figures — "7 false positives over 222,154 null leg pairs, separation
241× → 843×" — are declined on measurement. **The repair itself stands.** Use only these:

```
span bound OFF   755 false positives / 110,831 leg pairs =  68,121 per 10,000,000
span bound 3      47 false positives / 212,769 leg pairs =   2,208 per 10,000,000
separation       1.75x unbounded  ->  53.95x bounded      (a 30.8x lift)
IRREDUCIBLE FLOOR                                 47
```

**Conjunct 7 fires 25 times on a proper null, not 0.** Its live claim stands and was re-confirmed on
data fetched the same day: **0 straddles across 1,427 replay and 388 live leg pairs**, and the
program prints `CONJUNCT 7 DID NOT FIRE ON THE EMITTED LIVE POPULATION` beside every count — so the
detection totals are explicitly **not** evidence that the arm did any work there. On the null it
does: it fires 25 times, and it rejects 5 in the negative self-test arm.

**The bounded detection set is NOT a subset of the unbounded one — by exactly 10.** The bound is a
conjunct inside a greedy matching loop, so refusing a wide pair leaves leg A unconsumed to match a
nearer leg B the unbounded run never reached. Candidate pairs examined *rise* under the bound,
110,831 → 212,769. The clean-removal framing failed its own arm and the arm prints the gap rather
than asserting it away.

**On live data the span bound costs nothing.** 200 blocks replayed three ways — baseline binary,
repaired unbounded, repaired at span 3 — are identical: **4,766 swaps, 1,427 leg pairs, 17
detections, 0 straddles, 0 pairs refused by the bound**, all 17 at span 2–3 with exactly **one**
enclosed transaction.

**A reader bug, closed by its own fingerprint.** An earlier ITCH reader took the type-F price at
offset **36** — which is the MPID — and produced a session maximum "price" of `1,447,119,960`: the
ASCII bytes **V-A-L-X**, a ticker read as a price. The price offset is **32**. Both kernels here read
32.

**A truncation warning that cost a false reading once.** A `curl --max-time 40` against a 12 MB
transfer returned partial files whose digests read as further artefacts. **Check the byte count
before hashing** — a truncated read and a different artefact are indistinguishable by digest alone.

---

## What this instrument cannot do

**Geometry is not intent, and intent is a statutory element.** Every predicate here identifies
orderings and states exactly decidable from public data. None attaches a label to any address or
firm, none asserts anything about anyone's purpose. The same order sequence is lawful liquidity
provision or unlawful spoofing depending on purpose at the moment of placement — a fact about the
participant's plan, not about the book. The regulator's own text says as much of its own list:
*"non-exhaustive indicators, which shall not necessarily be deemed, in themselves, to constitute
market manipulation."*

**The null floor is what that sentence looks like as arithmetic.** On a population where nothing was
inserted by construction, this instrument still returns **47 detections carrying the same shape as a
live detection** — same address, same pool, opposite adjacent legs, one enclosed foreign swap running
with the front leg, inside the span bound. Ordering alone cannot separate them, and no further
conjunct on these bytes will. **The floor is a property of the data, not of the code.** And the rate
is a property of the null's shape: across seven shapes it ranges 1.33×–4.44× unbounded and
31.7×–220.6× bounded. **A single separation number without its null shape is not a measurement.**

**Same-participant is structurally NOT_COMPUTABLE on ITCH.** This is the biggest limitation of the
equities half. Type `A` Add Order carries no participant field of any kind; type `F` names the
**member firm**, never the firm's customer; cancel, delete, replace and execution messages carry
nothing at all.

```
10,580,123 unattributed adds  against  49,470 attributed  =  0.47% of adds
                                                             39 bp of entered orders
2 distinct MPIDs in a whole session of 28,734,686 messages
D1_same_participant_both_sides   NOT_COMPUTABLE      (printed on every ITCH run)
```

No public equities feed closes this, and no amount of engineering substitutes for it.

**Ethereum recall has measured holes.** 70 uncovered DEX swap events against 16,517 covered
(4 per 1,000: Curve TokenExchange 20, TokenExchangeUnderlying 13, Balancer V2 Swap 37); 1 cross-pool
bracket by one actor; 0 both-legs-in-one-transaction. And the conjunct set requires the same address
on both legs, so **a participant splitting legs across two addresses is not recalled.**

**One venue class publishes the ordering.** Ethereum publishes intra-block ordering as consensus
data; a central limit order book does not publish the equivalent. The wire result shows the geometry
is computable and live where the data exists, not that it transfers to venues that do not publish it.

**No execution path was built.** "Detect the shear so we can trade ahead of it" is the same
extraction the study exists to measure, one layer up. The tree contains no order-entry code, no venue
credentials and no account of any kind.

---

## Scope, plainly

```
adjudicated / published episodes located                       12
  validatable on login-free data                                1   (Ethereum, block-and-hash exact)
  CME futures, behind a licensed dataset                        7   OUT_OF_SCOPE_BY_HOUSE_RULE
  not validatable at all                                        4
```

The seven CME rows are **not absent** — they are located, dated and classified, and the historical
market-by-order data that would validate them is a licensed product. That is a property of that
market, recorded once and routed around; the work here is done entirely on data that requires no
account.

**The equities intersection is zero, and it is arithmetic, not judgement.** The only adjudicated
equities episode whose venue class has public order-book data ran 2010–2016. The earliest public ITCH
file is 2019-01-30. **Intersection 0** — and that episode names no security. Equities recall is
`NOT_KNOWN` and cannot be measured on public data.

---

## The call

**What we call.** A single-predicate cancellation detector is **broken as a detector** and is
retained only as a **denominator**: 958 and 935 per 1,000 on two sessions sixteen years apart. MAR
Annex I A(f) computed in full **does not rescue it** — it ranks a legitimate two-sided quoter at the
85.14th percentile of ordinary symbols and 1.71× above the population it was pointed at, and the
program refuses to render a verdict from one population at all. On Ethereum, the five-conjunct
insertion set **is** a strict refinement — 2,433× below the naive geometry, 108 of 108 reproduced
set-identical by an independent kernel — and on equities the three-way composite separates from its
own same-mechanism control in every cell of both ladders. Both hold on integers, with a control, on
bytes anyone can fetch.

**What we refuse to call.** No participant is named, no conduct is alleged, and no geometry on this
page is evidence of intent. The composite's separation **magnitude** is not called — only its sign,
because 1,407 and 1,590 are the same direction and different numbers, and no threshold is applied
anywhere in the instrument. The base-rate band is not called as "≈95%": it is [935, 958] from n=2 on
one publisher's books. Recall on equities is not called at all. And 47 false positives on a null with
nothing inserted is published as the floor rather than argued down.

**Where a reader should point next.** Run the base-rate predicate on **PSX and IEX DEEP** — both
staged, both byte-closed, neither run — because that is the third independent condition INV-1 is
missing and it costs nothing. Extend the Ethereum window past 1,000 blocks to test whether actor
concentration (top three carry 45 of 108) is stable; that also costs nothing. Mine day-level dates
out of the published complaint and order PDFs, which are public, to convert `RANGE_MULTIYEAR` rows
into locators. And treat **INV-4** as the transferable one: count every item into exactly one bucket,
require the buckets to sum to an independently derived total, and the trap that returns HTTP 200 with
a real block hash and an empty body stops passing.

---

## Reproduce

Everything is path-independent: no absolute path is baked into any source or script, every path is
derived from the script's own location, and digests are read from the pin file at run time. The
corpora are large and publicly fetchable, so they are **fetched**, not committed.

**Every program here prints its published reference figures on every exit path, including the ones
that measure nothing.** Run one with no arguments and it tells you what it would have measured and
why it did not — because a figure a page cites that its program never prints is not reproducible,
and an uninstrumented early exit is indistinguishable from a program that was never built.

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# --- corpora, fetched from their publishers. No account, no key, no agreement. ---
mkdir -p corpus/market-shear/itch corpus/market-shear/eth
curl -sL -o corpus/market-shear/itch/20190730.BX_ITCH_50.gz \
  'https://emi.nasdaq.com/ITCH/Nasdaq%20BX%20ITCH/20190730.BX_ITCH_50.gz'
curl -sL -o corpus/market-shear/itch/S010303-v2.zip \
  'https://emi.nasdaq.com/ITCH/Nasdaq%20ITCH/S010303-v2.zip'
START=14000000 COUNT=1000 bash reproduce/market-shear-pull-eth.sh   # free public JSON-RPC, no key

# --- verify the bytes BEFORE counting anything ---
awk 'NF==3 && $1!~/^#/ {print $1"  "$3}' reproduce/market-shear-corpus.sha256 \
  | ( cd corpus/market-shear && shasum -a 256 -c - )    # 4 of 4 OK, 1,103,272,137 bytes

# --- build, self-test, then one pass over every pinned corpus ---
bash reproduce/market-shear-run.sh        # source digest bracketed around the whole run
```

`market-shear-run.sh` builds the kernel as `reproduce/msx`. The other two build the same way, and
the short names below are the ones the command blocks above use:

```bash
swiftc -O -swift-version 5 reproduce/af-conjunct-exact.swift -o reproduce/afc
swiftc -O -swift-version 5 reproduce/live-wire-watch.swift   -o reproduce/lww
```

Pinned digests, so a reader can confirm they hold the same bytes:

```
20190730.BX_ITCH_50.gz  391,242,214 B  a0a057010cc5172cfaf2d8a7b4d5f133557fa47b3a5837fcf985b6e5533e50eb
S010303-v2.zip           58,907,174 B  eb67a239cf09b7de1843f6b0ede3c473616cc5cac777b293bbe15608bf51794d
eth/blocks.ndjson       274,405,185 B  2f3c1b9f23645c7b0ad652b1ba677691a16b7a6b538f31af5680189cbf47e5ff
eth/receipts.ndjson     378,717,564 B  af09271d39451288bbd9728f6488bb7a7e0d3441428caa22530d159af562feb0

market-shear-exact.swift       2,737 lines  d072169f1f6637d537e942786963849d1a2a696ed30c98ee722d6a49ace517e4
af-conjunct-exact.swift        1,510 lines  9d669a55f4fa42547dc8d417bd80edff4ea7824f0c9fddb9810932fdaadcc838
live-wire-watch.swift          2,576 lines  85403365cf25700f2beb8db27588382a953ec482ce81c7c4b1425cf53eb3e675
market-shear-rederive.swift      380 lines  f6558631196f4a35e322fbb66163b74a4260a631c236376f8dbb3997057599ed
market-shear-positional.swift    117 lines  e9b7be225145224992ccd1a8f0ee02e8d209e370ca8c8eb59c102be439f52332
```

**Two honest notes on those digests.** For NASDAQ ITCH there are no publisher digests: the listing
advertises `.md5sum` sidecars beside every archive and a GET returns HTTP 404, re-measured for the
pinned files, so both ITCH digests are ours and the artefact says so on its face. They prove two
readers hold the same bytes; they do not prove those bytes are what the publisher meant to serve,
and nothing here claims they do. And a JSON-RPC response is **not byte-canonical across providers** —
some emit a non-consensus `blockTimestamp` per transaction and some do not, a 3,360-byte difference
on block 14,000,000 with block hash, ordering and every transaction hash identical. The `eth/*`
digests are over the stored form from the named endpoint. Digest the consensus content and two
honest archives agree exactly; digest the response bytes and they read as a divergence that is not
there.

The controls, the null and the wire arm run separately, and each one exits non-zero when it should:

```bash
reproduce/afc --selftest         # 31 arms, both directions
reproduce/lww --selftest         # 37 arms
reproduce/lww --emptiness        # the self-contradiction guard, on the live trap
reproduce/lww --null             # the false-positive floor, with its refusal ladder
reproduce/lww --watch --seconds 720 --out .   # the live wire. Cost: 0.
reproduce/lww                    # no argv: self-test + null + reference figures, ZERO network
bash reproduce/market-shear-fpscan.sh --control-only   # the FP scanner, on its own control
```

**`--watch` is the only mode that touches the network, and it is never the default.** The no-argv
path was `--all` — probe the endpoints, then watch the chain head for 600 seconds — which made a
harness spend ten minutes on the wire to decide whether a program builds, and made that run's output
depend on reachability rather than on the code under test. `--all` still does exactly what the old
default did; it is now named rather than assumed.

No account, no key, no data-use agreement, and no floating point anywhere on the decision path.

## Related

- [Study 34 — The observer-invariant verdict](Study-34-Observer-Invariant-Verdict.md) — the same
  exactness argument, on a verdict that changes with who computes it.
- [Study 35 — The safety brain that forgets](Study-35-The-Safety-Brain-That-Forgets.md) — what a
  floating-point decision path costs over time.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md) —
  the same discipline over a discrete biological rule.
- [Shear studies index](Shear-Studies-Index.md) · [Ontology](Ontology.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
