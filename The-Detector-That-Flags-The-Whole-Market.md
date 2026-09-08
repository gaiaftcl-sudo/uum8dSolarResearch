# What is taken from an ordinary swap, and how to find out if it was taken from you

*Over 1,000 consecutive Ethereum blocks — 13,586 seconds of one chain on one day — 108 trades
were inserted around. For 87 of them we computed, in exact integers from the pool's own
arithmetic, what the person would have received had the trade in front of them not been placed.
The typical one lost 476 ten-thousandths of what they were due, about 0.17 ETH. Two programs on this
page put that arithmetic into a reader's own hands, both free and needing nobody's permission: one
answers whether it happened to a given transaction hash and what it cost, and the other answers,
while a signature is still a decision, how much a leg inserted in front of that trade could take.*

**Said once, on the face of the page: detection of a geometry is not proof of intent, and intent is
a statutory element of manipulation.** Nothing here names or implies wrongdoing by any identifiable
participant. Every acting address is printed as a keyed 8-hex pseudonym. Victim transaction hashes
*are* printed, because the harmed party must be able to find their own row.

---

## 1. What is being taken, and from whom

The detector held the answer the whole time and was never asked for it. Every detection carries the
victim's own swap and both bracketing legs, so the counterfactual is exactly computable: run the
**same input** against the **same pool** at the reserve state that stood **before** the front leg,
in integers, with the fee recovered from the victim's own trade rather than assumed.

### The measured result is a table of integers, per token

```
VICTIM SHORTFALL, by the token the victim was paid in. Base units. Exact.
  UNIDENTIFIED@pool:a939ee68  21 victims  155,576,958,801,814,594,396,893
  tok:acf14d4b                13 victims    5,074,012,211,888,792,743,310
  tok:417c0c57                 8 victims   28,924,625,003,219,287,345,953
  WETH                         4 victims        1,689,797,703,211,127,422   (1.6898 WETH)
  DAI                          1 victim              509,114,084,611,795,546,162   (509.11 DAI)
  ... 34 denominations in all, every row published in full

  costed rows        87 of 108 EXACT · 21 NOT_KNOWN, each with a named reason
                     11 LIQUIDITY_CHANGED_BETWEEN_LEGS ·  6 FRONT_NOT_INVERTIBLE
                      3 LEG_NOT_REPRODUCIBLE           ·  1 FEE_NOT_RECOVERABLE
```

**NOT_KNOWN is not zero.** Each of those 21 is a real person whose loss this program declined to
state rather than guess.

### One unit, clearly labelled, because a table of 34 tokens is not an answer a person can hold

```
TOTAL_victim_shortfall_wei_DERIVED  28,889,398,990,674,697,077   ≈ 28.8894 WETH
TOTAL_EXCLUDING_thin_pool_rows_wei  28,247,424,339,991,594,322   ≈ 28.2474 WETH
TOTAL_victim_shortfall_USDC_DERIVED 94,645,772,620 base units    ≈ 94,645.77 USDC
```

The rate is **measured inside this corpus, never fetched**: the deepest WETH/USDC pool's own
reserves at block 14,000,730 give **3,276,141,973** USDC base units per 1e18 wei — 1 ETH ≈ 3276.14
USDC. That is a correct price for 2022-01-13, which is itself a check on the whole token-identification
chain. Altcoin shortfalls reach wei at their **own** pool's pre-front marginal reserve ratio: one
integer division, no oracle. 86 of 87 rows converted; 1 is left in its own token and counted.

**A marginal price overstates what a large shortfall could actually have been realised for.** It is a
courtesy line and it touches no decision anywhere in the program.

### The distribution, published in full, because a mean over a heavy tail is a lie

Relative loss is unit-free — ten-thousandths of what the person was due — so every victim sits on one
scale regardless of which token they were paid in.

```
RELATIVE LOSS, all 87
  min 47 · p10 49 · p25 102 · MEDIAN 476 · p75 1,785 · p90 3,363 · max 9,999
  full sorted list printed by the program: 47,49,49,49,…,7167,7829,9315,9999,9999,9999
  excluding 7 thin-pool rows            median 303 over 80 rows
  constant-product pools  73 victims    median   575
  concentrated liquidity  14 victims    median   105

ABSOLUTE LOSS, DERIVED into wei
  min 968,917,367,415 · p25 0.0784 ETH · MEDIAN 0.170457244547709297 ETH
  p75 0.3618 ETH · max 3.9313 ETH        typical victim ≈ 558.442133 USDC
```

**It is not one whale.** The top victim carries 136 permille of the total and the top five carry
316 — the sum is spread across many people.

**It IS concentrated by venue, and that cuts the other way.** 48 distinct pools carry a detection,
but **one pool carries 22 of the 108** — 203 permille. "108 sheared trades across the market" would
overstate the spread, so the page says so instead.

### That concentration is one episode, not a rate — and the taus survive it

Split the same 1,000 blocks into four 250-block sub-corpora and the warning above understates it:

```
  Q0 14000000-14000249   40 detections   24 pools   busiest 150 permille
  Q1 14000250-14000499   31 detections    8 pools   busiest 580 permille
  Q2 14000500-14000749   19 detections   13 pools   busiest 210 permille
  Q3 14000750-14000999   18 detections   15 pools   busiest 111 permille
```

**Eighteen of the twenty-two sit inside one quarter**, and three more in the next. Q1 carries 31
detections across only eight distinct pools; Q3, the same length of chain, spreads 18 across fifteen
and its busiest takes 111 per 1,000. The published 203 is the average of quarters ranging **111 to
580**, so it describes no quarter of the window it summarises. The detection rate is not flat either
— 40, 31, 19, 18, falling monotonically, a 2.2× spread across one session.

The honest reading is therefore *this corpus contains one burst on one pool*, not *one pool carries a
fifth of the market's shear*. The correction comes from the same corpus that produced the original
number and needed no new data.

**Both Kendall taus keep their signs in all four quarters**: pool-relative +137, +619, +573, +269;
absolute-ETH −464, −592, −590, −657. The magnitudes do not. That is the same shape as the composite
ladder — **the direction replicates, the magnitude does not** — and it is called the same way.

One thing must not be claimed from that. Q1 is both the most concentrated quarter and the one with
the strongest pool-relative tau, so the four are not four independent draws of one process, and four
agreeing signs are weaker evidence than four agreeing signs would ordinarily be.

**An instrument fault found on the way, published because it would mislead anyone reproducing this.**
The first attempt at the split passed `--start` and `--count` to the kernel over the whole corpus and
got **four byte-identical answers from four different sub-windows**. In this kernel those flags are a
**contiguity assertion, not a filter**: it always reads the whole file and only checks that block *i*
is numbered `start + i`. The kernel said so in its own output — `blocks_not_contiguous 1000` on every
quarter but the first — and the error was in not reading it. Every figure above comes from a real
sub-corpus of 250 lines, each reporting `blocks_scanned 250` and `blocks_not_contiguous 0`.

### Out of sample: 3,000 more blocks say the rate is real and the concentration was not

Blocks **14,001,000–14,003,999** were pulled from the same free endpoint — no key, no account —
immediately after the published window. The kernel reports `blocks_scanned 3000` and
`blocks_not_contiguous 0`, so the corpus is the range it claims.

| | published 1,000 | extension 3,000 | reads |
|---|---:|---:|---|
| detections | 108 | 319 | |
| **per 1,000 blocks** | **108** | **106** | **the rate replicates** |
| distinct pools | 48 | 162 | |
| **busiest pool share** | **203 permille** | **78 permille** | **the concentration goes** |
| the pool that carried it | 22 | **6** | an **11× fall** |
| EXACT · NOT_KNOWN | 87 · 21 | 249 · 70 | |
| pool-relative size tau | +491 | **+112** | sign holds |
| absolute ETH size tau | −500 | **−407** | sign holds |

**Three answers, and they are not the same answer.** The per-block rate replicates out of sample —
108 per 1,000 against **106 per 1,000** on three times the data — so the quantity this study measures
is a property of this chain over this period and not an artifact of which thousand blocks were
picked. The pool concentration does not replicate: 203 per 1,000 falls to 78, the pool that carried
it drops from 22 detections to 6, and 48 distinct pools become 162. Taken with the quarter split
above, `a939ee68` was **one burst, not a standing feature**. And both tau signs survive while both
magnitudes fall, which means the published magnitudes are the top of their range rather than its
centre; the sign is what this study should be read as calling.

**A third instrument defect, found by using the kernel outside the window it was written for.**
`detections_per_1000_blocks_MEASURED` is the raw detection **count**, and is a rate only when the
window happens to be exactly 1,000 blocks. On the 3,000-block corpus it printed **319** — which
would have been a threefold overstatement had it been quoted as a rate. The 106 above is computed
from the counts, 319 × 1,000 / 3,000. Same shape as the `--count` defect: a parameter honoured in
the name of a figure but not in its arithmetic. The counts, not the derived rates, are what this
section quotes.

Sign checks: 87 positive, 0 exactly zero, 0 negative. A negative would mean the victim did *better*
than at the pre-front state, which the direction conjunct makes impossible — so a non-zero count
there would be a defect report on this program, not a finding. The self-test proves the function
**can** return a negative, which is what makes the count informative rather than structural.

### Does it fall on the large trades or the small ones? Both answers, and they do not conflict

```
POOL-RELATIVE size (victim input as ten-thousandths of the pool's own input reserve)
  Kendall tau  +491 permille   3,741 pairs · 2,723 concordant · 929 discordant · 89 tied
  median loss  199 bp smaller half   against   1,785 bp larger half
  → relative loss RISES with pool-relative size

ABSOLUTE size in ETH (76 victims paying WETH, no conversion applied)
  Kendall tau  -500 permille   2,850 pairs ·   696 concordant · 2,093 discordant · 61 tied
  → in ABSOLUTE terms the SMALLER trades take the LARGER relative hit
```

Together: **what predicts the hit is the size of your trade relative to the pool you happened to
trade in, not your wealth.** A modest trade in a thin pool is hit harder than a large trade in a deep
one. The first tau is largely the market maker's own arithmetic restated — a bigger trade against a
given depth moves the price more. The second is the flourishing-relevant direction, and it is
measured, not modelled.

### Who these people are, measured off the wire with no rate applied

```
trade size   min 0.3309 ETH · p25 2.0717 · MEDIAN 6.0 ETH · p75 11.9 · max 49.0 ETH
             under 0.1 ETH   0        0.1–1 ETH   12
             1–10 ETH       42        10–92.2 ETH 22        over 92.2 ETH  0
```

The 92.2 boundary is 5·2⁶⁴ wei exactly — a power-of-two so the comparison is an integer limb test
rather than a decimal conversion.

**Median victim trade ≈ 6 ETH, about $19,700 at this corpus's own rate. These are not sub-$100
retail trades, and the study says so rather than spinning it.**

**And there are no tiny victims for a measured reason, not a comforting one.** Median gas across the
two attacker legs is **0.104516232525109603 WETH** per detection. A trade too small to move the price
by more than that is not worth attacking. The absence of victims under a tenth of an ETH is a
property of the **attacker's** arithmetic at this gas price — not evidence that small traders are
safe. Cheaper blockspace moves that floor down and nothing measured here bounds where it stops.

### The rate, and the projection kept strictly apart from it

```
MEASURED    108 detections per 1,000 blocks = 13,586 s · 28 per hour (integer floor)
            92 of 1,000 blocks carry at least one

PROJECTED — NOT MEASURED. Assumption: this rate continues unchanged. NOT tested here,
and this corpus cannot test it — 1,000 blocks is about three and three-quarter hours
of one chain on one day.
            686 per day · 250,390 per year
            108 / 13,586 s × 86,400 = 686/day; × 365 = 250,390/year

PROJECTED_AND_DERIVED — labelled twice because it stacks a projection on a conversion
            601,898,627,584 USDC base units per day
            219,692,999,068,160 per year  ≈ 219,692,999 USDC/year
```

The label is on the key name itself, not only in the prose, so a projection cannot be quoted as a
measurement by anyone reading the program's output alone. No total anywhere else on this page is
scaled by any of these.

### The total is a FLOOR, and here is exactly what is missing from it

1. **Only detections passing every conjunct.** The relaxed geometry — same-address condition dropped
   — is 7,307 brackets of which 54 are extractive. That is quoted as the **ceiling on what
   attribution costs**, never as a second estimate.
2. **Only same-address, two-leg attacks.** A searcher splitting the legs across two addresses, or
   packing both into one transaction, is **invisible** here and counted nowhere.
3. **Only Uniswap-V2-shaped and V3-shaped Swap events.** Every other venue in these blocks
   contributes zero by construction.
4. **Only the sheared leg.** A victim routing through several pools is measured on the pool where the
   shear happened.
5. **Only rows whose arithmetic reproduced exactly** — 87 of 108.
6. **Gas is not netted.** The attacker's net position change is published per detection in both
   tokens and is **gross**; it is never called profit. Gas is stated beside it — 19,545,453,601,946,304,886
   wei across all attacker legs — and deliberately not subtracted, because netting needs a token/ETH
   price and that is a judgement.
7. **1,000 blocks, one chain, one day.**
8. **Detection is not intent.** The null floor is 47 false positives per 212,769 leg pairs.
9. **Measured at the pool boundary.** All 25 unidentified-output rows show a transfer out of the pool
   at exactly **960 permille** of what the Swap says the pool paid — a 4% deduction on transfer,
   identical across 25 rows and two pools. Those victims received **less** than the "received" column,
   so their stated shortfall is a floor on their loss rather than the whole of it.

---

## 2. What a person can do about it today

A regulator dashboard helps nobody who was actually sandwiched. **This does:** one transaction hash,
one answer, on your own machine.

```bash
./wasi-sandwiched 0x03187404aa69d82c6593772665ee9dbf574df9d2a8eeec793e5d7041c6e61f71
```

```
cost         ZERO — no API key, no account, no registration, nobody's permission
needs        a transaction hash and an internet connection
sends        (1) your hash, to ONE public endpoint, to ask which block holds it
             (2) that block's NUMBER, to TWO public endpoints, to fetch and cross-confirm
             nothing else leaves; no wallet, no address of yours, no record kept anywhere
             but your own terminal. Be clear-eyed about (1): that endpoint learns somebody
             asked about that transaction, exactly as a block explorer would. Point
             --endpoint-a at a node you run if that matters to you.
```

### Three verdicts. They never print alike and never share an exit code

```
################  VERDICT:  SANDWICHED  ################             exit 10
   both attacker legs BY HASH and by position index · the leg span against the
   published bound of 3 · what you paid in · what you received · WHAT YOU WOULD HAVE
   RECEIVED at the pre-front reserve state · the SHORTFALL in base units · the loss in
   ten-thousandths · the pool's own pre-front reserves so the row can be re-run by
   hand · and the fee recovered from your own swap rather than assumed.

----------------  VERDICT:  NOT SANDWICHED  ----------------          exit 0
   a real answer, not the absence of one: the swaps in the block, the leg pairs
   examined, and whether the block carries an insertion around SOMEBODY ELSE.

!!!!!!!!!!!!!!!!  VERDICT:  REFUSED  !!!!!!!!!!!!!!!!                 exit 3
   with a reason code, and whether the refusal arose ON THE WIRE or HERE.

== NOTHING WAS GIVEN ==                                              exit 4
   A GATE GIVEN NOTHING MUST NOT PASS. It prints the reference figures instead.
```

Run it with no hash at all and this is the whole of what you get — no verdict, and the numbers a
positive answer would be read against:

```
=====================================================================
  WAS I SANDWICHED, AND WHAT DID IT COST ME?
  affine.earth market-shear · one transaction · one answer
=====================================================================
law_carried   extraction-exact.swift lines 1..2843 — VERBATIM, compiled in

== NOTHING WAS GIVEN ==
A GATE GIVEN NOTHING MUST NOT PASS. No hash was supplied, so nothing was
measured and no verdict is offered. This is not NOT SANDWICHED.

== WHERE THE NUMBERS ON A POSITIVE ANSWER COME FROM ==
  corpus        Ethereum blocks 14,000,000–14,000,999 (1,000 consecutive)
  detector      126 brackets · 108 extractive · 104 blocks · 26 pseudonymous actors
  separation    262,799 naive positional brackets across 848 blocks vs 108
  reproduction  108 of 108 SET-IDENTICAL under an independently written re-derivation
  null floor    47 false positives per 212,769 leg pairs
  typical loss  median 476 ten-thousandths of the output that was due — about 0.17 ETH
```

### A worked positive, pasted from the run

```
0x03187404aa69d82c6593772665ee9dbf574df9d2a8eeec793e5d7041c6e61f71   block 14000480

  position 0   FRONT-RUN LEG  0x38c74669b3ac08e0f2e88b23b15a28c814c4d3d0e856574675a53e08dd196d61
  position 1   YOUR SWAP      0x03187404aa69d82c6593772665ee9dbf574df9d2a8eeec793e5d7041c6e61f71
  position 2   CLOSING LEG    0x0f54d47f93bcc532d12163f0bbcbb874b7f705eb4fb851bd3f235194bf7bd6cb
  leg_span_positions 2 — within the published span bound of 3

you_paid_in                6.0 WETH
you_received               63,932,941,542,564,042,668,520 base units of an unnamed token
you_WOULD_have_received    73,994,263,456,810,691,644,706
SHORTFALL                  10,061,321,914,246,648,976,186
loss                       1,359 ten-thousandths of what you were due
pool before the front leg  68173738336045146338 in / 917268344913346883436997 out
fee recovered from your own swap   997/1000
```

And one where both tokens are known, so the answer needs no explanation at all:

```
0xe252bb6ce18e4b038918ab9ad1d399899b883fa65c26da3bc1b4732e82e451d7   block 14000681, V3

you_paid_in                172454.682844783952555976 DAI
you_received               52.701569795944320899 WETH
you_WOULD_have_received    52.965067694272296471 WETH
SHORTFALL                  0.263497898327975572 WETH        49 ten-thousandths
```

### The four things it will not do to you

**NOT_KNOWN is not zero.** For 21 of the 108 published detections the tool prints NOT_KNOWN with the
detector's own reason string and says a number would be a guess.

**It reads no token contract.** There is no `decimals()` call anywhere in it. It scales only the five
tokens it knows by published address — WETH, USDC, USDT, DAI, WBTC — and prints everything else in
exact base units with a one-line note saying why.

**The attacker's side is printed and kept apart on purpose**: net position change per token, gas
beside it and never netted, and the words *"NOT profit and NOT your loss"*.

**Integer only.** One `Double` exists in the whole program — `URLRequest.timeoutInterval`, built from
an `Int`, never read on any decision path. Measured in the emitted image: **zero** float arithmetic
instructions, and exactly one float constant, `fmov d0, #25.00000000`, living in `main.wsPost` — the
HTTP timeout. The scanner compiles a decoy carrying 3 such instructions on every run, so it is not
blind.

### It is the same code path as the study. Measured, not claimed

The tool defines **no conjunct, no pool arithmetic and no shortfall formula**. It compiles a
**verbatim byte slice** of the detector — `extraction-exact.swift` lines 1..2843, 156,508 bytes,
sha256 `6b093daa07214dd589156235cc4fcb04b21de3750d6b76f008e35baf0c9e2799` — and calls `runCorpus()`,
`computeShortfall()`, `v2Out()`, `v3Step()` and `v3InvertStart()` by their own names. Re-derive that
digest yourself:

```bash
sed -n '1,2535p' reproduce/extraction-exact.swift | shasum -a 256
```

Three gates, all green, all with control arms in both directions:

```bash
./wasi-sandwiched --selftest                    # 79/79 arms  SELFTEST PASS
bash reproduce/wasi-sandwiched-fpscan.sh        # 12/12 arms  WASI_SANDWICHED_ZERO_FLOAT_ON_EVERY_DECISION_PATH
bash reproduce/wasi-sandwiched-one-law.sh       #  9/9  arms  ONE_LAW_ONE_HOME_PROVEN
```

The one-law gate's own control pair caught a broken detector before it could report a false green:
`cmp -n` is not portable here and read as always-`NOT_A_PREFIX`. The real arm went red while its
control stayed red, which is how it was found.

### Verified on known answers, in both directions

```
POSITIVE ARM   108 pass / 0 fail of 108
  every published detection, re-run over the live network against the frozen build and
  compared FIELD BY FIELD: verdict, exit code, block, shortfall in base units, loss in
  ten-thousandths, size in ten-thousandths, cross-confirmation AGREE. NOT_KNOWN rows had
  to carry the detector's exact reason string.
    73 PASS  V2  EXACT              11 PASS  V3  NOT_KNOWN_LIQUIDITY_CHANGED_BETWEEN_LEGS
    14 PASS  V3  EXACT               6 PASS  V3  NOT_KNOWN_FRONT_NOT_INVERTIBLE
                                     3 PASS  V3  NOT_KNOWN_LEG_NOT_REPRODUCIBLE
                                     1 PASS  V2  NOT_KNOWN_FEE_NOT_RECOVERABLE

NEGATIVE ARM    92 pass / 0 fail of  92
  ordinary swaps drawn from the SAME blocks in which the tool answers SANDWICHED for
  somebody else. A tool that says yes to everything is worse than no tool.
```

### The other question, and it is the only one still open before a signature

`wasi-sandwiched` above answers about a transaction that already exists. **A person deciding whether
to sign has a different question, and it is the same arithmetic.**

```bash
./wasi-exposure <pool-address> <token-you-are-paying> <amount-in-base-units>
```

```
cost_to_run_this   ZERO — no API key, no account, no registration, nobody's permission
what_it_needs      a pool address, which token you are paying in, how much, and an internet connection
what_leaves_this_machine
  A POOL ADDRESS and the standard read-only calls every block explorer makes
  against it, to TWO public endpoints. Your amount is NEVER sent: the size you
  type is used only in arithmetic on this machine, against reserves that were
  already public. No address of yours, no wallet, no transaction, no signature.
```

#### It is equation (4) with one word changed, which is why it is not a second implementation

The realised loss this study published is

```
   shortfall      = out(a; S_before_front) − out(a; S_after_front)              (4)
   exposure(a, f) = out(a; S_now)          − out(a; S_now ⊕ f)                  (5)
```

where `out()` is the pool's own output function. **The only difference is which state is called
*before*:** in (4) a state that already stood and was recovered from the chain, in (5) the state
standing now, read from the pool this second. `S ⊕ f` is the pool's transition under a front leg of
size `f` — `R_in + f` and `R_out − out(f; S)` on a constant-product pool, `v3Step(...).sqrtNext` on a
concentrated-liquidity one — so it is `out()` again. **(5) introduces no arithmetic that (4) did not
already carry**, and the program defines none of it: 17 call sites into `v2Out`, `v3Step`,
`v3InvertStart`, `computeShortfall` and `runCorpus`, and **zero definitions** of any of them.

#### The answer is a shape, because whoever inserts the leg picks its size and you do not

Pasted from a live run — 6.0 ETH into a concentrated-liquidity pool, the study's own median victim
size, at the state standing at block 25,935,160:

```
your_trade_as_ten_thousandths_of_this_pools_depth   719

inserted_leg   TAKEN from what you were due       /10000   price move  is one step still credible
1/8x                 49464477735139389566392      171           89  YES_small_move
1/4x                 97669465864779842186877      337          179  MAYBE_check_the_ticks
1/2x                190468864097248583772339      658          358  MAYBE_check_the_ticks
1x                  362706185513692330622045     1254          717  MAYBE_check_the_ticks
2x                  661169437766900944565258     2287         1434  NO_the_real_hit_is_LARGER
4x                 1118888346570417393196236     3871         2869  NO_the_real_hit_is_LARGER
8x                 1694473155128980054873411     5862         5739  NO_the_real_hit_is_LARGER
16x                2240628989265071379429721     7752        11479  NO_the_real_hit_is_LARGER
ladder_monotone_in_inserted_size   YES — as the arithmetic requires
```

**The last two columns are the one limit that can make the printed figure too SMALL, so the program
prints them on the row rather than in a footnote.** A concentrated-liquidity pool holds its liquidity
in ticks; this models one price step at the liquidity standing now and fetches no tick map. Where the
move is large the leg crosses into ranges this program did not read, and on the far side there may be
less liquidity — so the real hit is bigger than the row says. The error has a direction, the direction
is upward, and the row names it. On a constant-product pool the question does not arise: its liquidity
is one range by construction.

#### Verified against 87 losses that already happened

The same binary was replayed over the pinned corpus with the attacker's leg size read out of the block
rather than solved for. **Solving for the size that makes the prediction true would be an always-green
instrument**, so the front leg's own Swap event is the input and the check is allowed to fail.

```
costed victims                      87
CHECKED by equation (5)             87
MATCHED to the base unit            85
DIFFERED                             2      both PREDICTION_ABOVE_REALISED, neither below
NOT_KNOWN                            0
  CONCENTRATED_LIQUIDITY   14 checked / 14 matched
  CONSTANT_PRODUCT         73 checked / 71 matched

################  VALIDATION:  GREEN — EXACT ON 85 OF 87, AN UPPER BOUND ON 2  ################
```

**The cause of the two is measured, not assumed.** A census of all 73 constant-product front legs
found 70 exact-input swaps the formula reproduces exactly, **3 that took LESS out of the pool than an
exact-input swap would give, and 0 that took more** — an exact-*output* or fee-on-transfer leg, whose
smaller real draw leaves the victim a little more than the ladder assumes. **Only 2 of those 3
differed**: `out()` floors to an integer, so a leg that took slightly less can leave the victim's own
output unchanged, and the third row matched to the base unit anyway. The worst of the two over-states
that row's own realised loss by **202 per 10,000**; the other by **0 per 10,000** at the printed
precision. An upper bound is the right direction for a number somebody is about to sign
against, and the wrong direction for a promise. The program prints which one it is.

#### Four answers, four exit codes, and none of them prints like another

```
################  EXPOSURE:  MEASURED  ################               exit 0
   the pool's shape and the block it was read at · what you are due · your size as
   ten-thousandths of that pool's depth · the ladder above · the two panels · and the
   second endpoint's independent read of the same state, agreeing or not

!!!!!!!!!!!!!!!!  EXPOSURE:  REFUSED  !!!!!!!!!!!!!!!!                 exit 3
   with a reason code and whether the refusal arose ON THE WIRE or HERE. REFUSED IS NOT
   ZERO EXPOSURE — an unknown pool is refused, never answered as safe, because somebody
   signs on the answer.

== NOTHING WAS GIVEN ==                                               exit 4
   A GATE GIVEN NOTHING MUST NOT PASS. No pool, so nothing measured and no exposure
   offered. This is NOT a finding of zero exposure. It prints the reference figures.

VALIDATION BROKEN                                                     exit 5
   the replay against the 87 could not be completed, which is its own answer and never a
   quiet pass.
```

Wire answers stay separated into the four this study keeps apart everywhere else — `ABSENCE`,
`REFUSAL`, `BOT_BLOCKED`, `NOT_KNOWN` — and the program never merges them. In the run above the
first confirming endpoint returned an HTML interstitial where a JSON-RPC body belonged; that is
`NOT_KNOWN`, it was recorded as such, and a third endpoint was asked rather than the answer being
taken from one.

Run it with no pool at all and this is what comes back instead of a verdict:

```
=====================================================================
  BEFORE YOU SIGN: HOW MUCH OF WHAT YOU ARE DUE CAN BE TAKEN?
  affine.earth market-shear · one pool · one trade · one shape
=====================================================================

== REFERENCE FIGURES — published, from the pinned corpus. Not this run's measurements. ==
  corpus            Ethereum blocks 14,000,000–14,000,999 · 13,586 s of one chain
  detections        108 inserted trades · 87 costed EXACTLY · 21 NOT_KNOWN, named
  typical hit       MEDIAN 476 ten-thousandths of the output that was due
  absolute          MEDIAN 0.170457244547709297 ETH ≈ 558 USDC per victim
  derived floor     28,889,398,990,674,697,077 wei = 28.8894 WETH = 94,645.77 USDC
  spread            min 47 · p10 49 · p25 102 · MEDIAN 476 · p75 1,785 · max 9,999
  by venue          constant-product 73 victims median 575 · concentrated 14 median 105
  WHAT PREDICTS IT  pool-relative size Kendall tau +491 permille
  concentration     48 distinct pools, ONE carries 22 of 108 (203 permille)
  null floor        47 false positives per 212,769 leg pairs
```

#### One law, one home — the same digest the other tool carries

```bash
./wasi-exposure --selftest                      # 31 arms, no network, both directions
./wasi-exposure --validate --dir corpus/market-shear/eth    # the 87 replayed
bash reproduce/wasi-exposure-one-law.sh         # 19 arms, 6 of them controls
```

**Neither build carries a literal to check its law against — each computes the digest at build time
from the bytes it cut, and the two are then required to agree.** Both cut at the `SECTION 11 — MAIN`
marker rather than at a typed line number, and the gate re-cuts the slice, re-hashes it, checks it is
a byte prefix of the detector's own source, then reads `law_sha256_computed_at_build` out of **both
binaries and requires one digest from the two**. Its control arm appends a single byte and requires
the prefix check to break. A frozen digest was tried first and removed on measurement: the detector
legitimately grew from 2,688 lines to 3,011 the same afternoon and the literal went stale, refusing
over a change that broke nothing. A relation survives the law growing; a literal is the constant that
drifts.

Self-test arm 9 is the join, and it is arithmetic rather than prose: it computes exposure (5) on a
state, assembles that same state as the detector sees it — front leg, victim leg, two `Sync` records
— calls the published `computeShortfall()` verbatim, and requires both to return **19864365895**. Its control
gives a different front size and requires a different number, so the agreement is not vacuous.

**Integer only, on a path where the number is somebody's exposure.** The single `Double` is
`URLRequest.timeoutInterval`, built from an `Int` and never read. The float gate strips comments
before matching — an earlier version fired on the sentence describing the exemption, which is the
same defect one scope over — and carries three controls: a real declaration must be caught, prose
naming a float must not be, and the timeout exemption must not hide a real one beside it.

---

## 3. What knowing this is worth, and to whom

A measurement nobody can act on helps nobody. This section says, per person rather than per
programme, what each kind of reader can now do that they could not, what it costs them, and what it
does not give them.

### If you make swaps: two questions, both free, and one choice you can actually make

```
AFTER    ./wasi-sandwiched <your-transaction-hash>            was it taken, and how much
BEFORE   ./wasi-exposure <pool> <token-in> <amount>           how much COULD be taken if I sign
```

The first is §2 and answers about a transaction that already exists. **The second answers before the
signature rather than after it, which is the only point at which anything can still change.** Its
arithmetic is not a second implementation: it compiles a verbatim byte slice of the same file, cut at
the same named marker, and calls `v2Out()`, `v3Step()` and `v3InvertStart()` by their own names. The
two binaries are required to print one law digest between them, so a drift is a gate failure rather
than a footnote. A law written twice is two laws, so it is written once.

```
what leaves your machine   a pool address, and the read-only calls any block explorer makes,
                           to two public endpoints which are cross-confirmed against each other
your amount                NEVER SENT. The size you type is arithmetic on your own machine,
                           against reserves that were already public. No wallet, no address of
                           yours, no transaction, no signature.
cost                       ZERO — no API key, no account, no registration, nobody's permission
```

What each of the two cannot do:

```
AFTER    cannot recover anything · cannot name who did it · cannot say it will happen again
         21 of 108 published rows are NOT_KNOWN, and it prints NOT_KNOWN rather than a number

BEFORE   cannot predict that anyone WILL insert a leg. It reports what one COULD take.
         cannot see a leg split across two addresses, routed through another pool, or worked
           across blocks — the study's own detector cannot see those either, so neither can this,
           and absence of exposure here is not absence of exposure
         cannot know your slippage limit, your router's path splitting, or anyone's gas
         is an UPPER BOUND, and that is measured rather than asserted: replayed against the 87
           costed victims it reproduced the realised loss TO THE BASE UNIT on 85, and on the
           other 2 it stood ABOVE what was realised, never below (worst over-statement 202 per
           10,000 of that row's own loss; concentrated-liquidity 14 of 14 exact, constant-product
           71 of 73). An upper bound is the right direction for a pre-trade number and the wrong
           direction for a promise, and the program prints which one it is.
```

#### The one fact you can act on: the hit tracks the pool, not your wealth

§1 measures this twice and the two measurements point opposite ways on purpose — pool-relative size
Kendall tau **+491** permille, absolute ETH size **−500** permille. The pre-trade counterpart makes it
a choice instead of a finding. Worked at the study's own median victim size, 6.0 ETH, against a
concentrated-liquidity pool `6ae0cdc5` at the state standing at block 25,935,160:

```
your trade as ten-thousandths of that pool's depth        719
an inserted leg at 1x your size would take              1,254 of the 10,000 you are due
                     (published median realised loss:     476)
```

```
A. THE SAME TRADE, IN A DEEPER POOL        B. A SMALLER TRADE, IN THIS POOL
depth   your size /10,000   taken /10,000   size    your size /10,000   taken /10,000
   1x           719               1,254     full            719               1,254
   2x           359                 669     1/2             359                 669
   5x           143                 278     1/4             179                 346
  10x            71                 141     1/10             71                 141
 100x             7                  14     1/100             7                  14
```

**The two panels are the same lever, and the program's own output is the proof: wherever the
pool-relative column agrees, the take agrees exactly** — 359 → 669, 71 → 141, 7 → 14, in both panels,
reached by two different routes through the arithmetic. Halving your size and doubling the depth are
the same act. That is the +491/−500 pair restated as something a person can do something about, and
it is why the program reports pool-relative size first and prints your trade's absolute size as an
afterthought. The 1x rung of that example prints `MAYBE_check_the_ticks`, so 1,254 is the one-step
figure and the real hit is not bounded above by it — the error on a concentrated-liquidity pool has a
direction, and the direction is upward.

**Splitting is not free, and this will not pretend it is.** Two half-trades at 669 each take
100,097,446,908,321,448,120,683 apiece — 200,194,893,816,642,896,241,366 together, against
362,706,185,513,692,330,622,045 for the single trade. **551 per 1,000 of it**, at the state read and
at one inserted leg per piece. Against that: each piece is exposed on its own, the second piece meets
a pool the first piece moved, and gas is paid per piece. The panels are one state and one attack
shape. They are a reason to look before signing, not a strategy, and no trade, venue, pool or product
is proposed anywhere on this page.

**What actually caps the loss is not in this arithmetic at all.** A slippage limit is a bound the pool
enforces on your behalf; the exposure figure does not model it and says so on every run. What this
adds is the integer that limit would be standing against.

### If you build a wallet, an interface or a router

```
detector kernel     min 2 us · max 75 us          measured on the live wire, §4
block interval      ~12,000 ms
                    at its slowest that is one 160,000th of the gap between blocks
```

**The arithmetic is not the cost. The state read is — and an interface about to show a quote has
already paid it.** In the run above, the six read-only calls took 91–1,181 ms across the two
endpoints that served; the ladder over the integers they return is microseconds. A wallet that
already holds `getReserves()`, or `slot0()` + `liquidity()` + `fee()`, to compute the quote it is
displaying holds everything the ladder needs. **A warning before signature costs a wallet nothing
it is not already spending.**

Embedding is a slice, not a port: the law is one contiguous byte range of one file, delimited by a
named marker rather than a line number, so an implementation can carry it verbatim and re-derive its
digest in one line — `sed -n "1,${END}p" extraction-exact.swift | shasum -a 256`, with `END` read off
the marker. Transliterating it instead produces a second law, and a second law drifts — this study's
own client-side history is where that lesson was paid for.

**Nothing here is a product, and this page does not imply one.** There is no package, no SDK, no
versioning, no support, and no licence grant — the repository carries no LICENSE and the Rights
section says what that means. There is no tick map: a concentrated-liquidity figure models one price
step at the liquidity standing now, so every rung prints the price move it causes and one of
`YES_small_move` / `MAYBE_check_the_ticks` / `NO_the_real_hit_is_LARGER` beside it. An interface that
shows the number and hides that verdict is showing a number whose error has a known direction and
suppressing the direction.

### If you buy — or build — surveillance

The value here is the refutation, and it is the kind that saves money before it is spent.

```
a detector keyed on cancellation alone, over a complete session with nobody doing anything:
  Nasdaq BX ITCH 5.0, 2019-07-30     958 per 1,000 of orders
  Nasdaq ITCH v2,     2003-01-03     935 per 1,000 of orders
```

**The question to ask a vendor is one line: what does your indicator score on an ordinary session with
nobody doing anything?** That question had no published answer to check a vendor's answer against.
It has one now, on two sessions sixteen years apart, from files anyone can fetch without an account.

Two further questions the page equips a buyer to ask, both free:

- **Show me the control, and show me that it can fail.** §6 records a control arm that returned 0
  detections over 223,500 leg pairs — a fact about a 2³¹ generator read at its low bits, not about the
  detector it was certifying. An always-green control and an always-red one are the same defect.
- **Compute the regulator's indicator in full, not its cancellation half.** MAR Annex I A(f) is a
  conjunction; computed whole, one modelled two-sided quoter scores 0 bp or 9,189 bp depending only on
  whether it quotes inside the touch or at it. An indicator that sorts by quoting style generates
  alerts that a person then has to triage.

No money saving is claimed. What is supplied is a denominator and three questions; what they are worth
depends on what was about to be bought, and this page does not know that.

### If you research or regulate

Three things exist now that did not, all on data needing no account, no key and no data-use agreement:

```
a base rate WITH its null shape    958 and 935 per 1,000, n = 2, one publisher — carried as a band
                                   and never as "≈95%", with the null's shape published, because a
                                   separation number without its null shape is not a measurement
a false-positive floor             47 per 212,769 leg pairs — and it is a property of the DATA, not
                                   of the code: ordering alone cannot separate those 47
a set-identical reproduction       108 of 108, by a kernel sharing no code, keyed on
                                   (block, pool, actor, tx_front, tx_victim, tx_back)
```

Enforcement records carry episodes. They do not carry base rates, false-positive floors, or
independent re-derivations — and §7 measures how hard that gap is to close from the other side: of 12
located adjudicated episodes, **1** is validatable on login-free data, **7** sit behind a licensed
dataset, **4** are not validatable at all. **The literature has episodes without base rates. This page
has a base rate without episodes.** Naming that as the gap is the contribution; closing it needs both
halves, and the cheapest missing condition is already staged and named in The call.

### If you build any measuring instrument, in any field

The most portable result here has nothing to do with markets:

> **Count every item into exactly one bucket, and require the buckets to sum to a total derived
> independently of the counting.**

It costs nothing, needs no second source, and it caught an endpoint returning HTTP 200 with the real
block hash, the real transactions root, `gasUsed` 8,119,826, and an empty `transactions[]`. **Data-shaped
emptiness passes every status-code check and every hash check.** A closure does not pass it. §4 names
the five places this study ran that shape; what belongs here is only that it transfers — to a log
pipeline, a lab instrument, a billing reconciliation, a survey, anything that counts things.

Its companion, from §6: **a control must be able to fail.** A control that cannot produce the outcome
it exists to exclude is decoration, and it will read green through the exact failure it was built to
catch.

### What it is worth, plainly

```
one day of one chain · 1,000 blocks · 13,586 seconds
108 inserted trades  against 16,517 covered DEX swap events in the same blocks  = 6 per 1,000
 87 victims costed exactly · 21 NOT_KNOWN
  a floor of 28,889,398,990,674,697,077 wei ≈ 94,645.77 USDC
```

**That is not a large number, and this section will not dress it as one.** It is one working afternoon
of one venue class on one chain. No total anywhere here is scaled to make it look larger.

**The value is not the size of the number. It is that the number exists at all — per transaction, for
anyone, at zero cost, with a published error floor.** Before this, a person who suspected their swap
had been sheared had no way to put an integer on their own row: the counterfactual needs the pool's
own state before the front leg, in exact arithmetic, and nothing free computed it. Now one command
does — and prints NOT_KNOWN on 21 of 108 rather than guessing, which is the half that makes the other
87 worth reading.

**An honest small number anyone can reproduce is worth more than a large one nobody can check.** This
study withdrew four of its own cited figures to keep that true (§6), and the withdrawal cost it a
separation of 843× — exactly the kind of figure a study that wanted a headline would have kept.

### The overclaims this section does not make

Each was available. Each is declined on measurement, not on modesty.

**Not annualised.** The page carries `PROJECTED_AND_DERIVED 219,692,999 USDC/year`, labelled on the key
name itself, and this section carries none of it into any statement of worth. 1,000 blocks is about
three and three-quarter hours; the corpus cannot test whether that rate holds, and one pool carrying
203 permille of the detections means the rate is partly a property of that pool's day.

**Not a market total.** Legs split across two addresses are invisible to the conjunct set. Both legs
inside one transaction are invisible. Every non-Uniswap-shaped venue contributes zero by construction,
and every other chain contributes nothing at all. A market-wide figure needs a denominator this study
does not have, and inventing one would destroy the only property the total has: that it is a floor and
is called one on every line that carries it.

**Nobody is a parasite, because nobody is named.** Detection is a statement about ordering and pool
state, not about purpose. 47 false positives arise on a null where nothing was inserted. Intent is a
statutory element and no arithmetic here reaches it. Acting addresses stay keyed pseudonyms for that
reason, not as a courtesy.

**This stops nothing.** It removes no leg, reorders no block, prevents no insertion, and returns no
money to anyone. It changes exactly one thing: **a person can see.** Before signing — the size of what
a leg could take. After signing — what one did take, in integers, from their own hash. Detection after
the fact tells someone they were taken; a check before the signature tells them what they are exposed
to. Neither is protection, and calling either one protection would be the first false sentence on this
page.

**And the pre-trade check does not protect you either.** `COULD, NOT WILL` is printed on every exposure
answer it gives. Most swaps are not sandwiched — 108 across 1,000 blocks carrying 200,826 transactions.
A large exposure is not a warning that it is about to happen, and a small one is not a promise that it
will not.

---

## 4. How it is known

### The conjunct set, reimplementable from this paragraph alone

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

SHORTFALL(j), equation (4): the SAME input as swap j, against the SAME pool, at the
 reserve state that stood BEFORE leg i, with the fee recovered from j's own numbers.
```

*Why conjunct (4) is load-bearing.* Its complement — the enclosed swap running **against** the front
leg — is the shape of ordinary two-sided quoting, and it is counted and published as **round-trip
straddle** rather than discarded, because the straddle count is the two-sided-quoting denominator.

The **live-wire** variant adds two conjuncts and drops one requirement, and that difference travels
with the claim: (6) no swap by `who(i)` on *P* lies strictly between the legs — they must be that
address's own *adjacent* swaps on the pool; (4b) `tx(k) − tx(i) ≤ MAX_LEG_SPAN`, default 3, a
**stated and fitted** parameter printed on every run; and EXTRACTIVE is *reported* as a field rather
than required, so a live detection is not an extraction claim.

### 2,433× against the naive geometry

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

### 108 of 108, reproduced by a kernel sharing no code

The re-derivation uses Foundation `JSONSerialization` instead of a hand-rolled byte scanner, signed
256-bit as 32 big-endian bytes with byte-level arithmetic instead of four 64-bit limbs, and an
explicit sort by `(transactionIndex, logIndex)` where the detector relies on file order.

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
across the two 256-bit implementations. A third route built from transaction submitters alone
contains all 108 and none outside.

The **shortfall** arithmetic carries its own agreement test that does not depend on the corpus at
all: a V3 step is checked against the constant-product formula on the same virtual reserves and
agrees to **zero difference**, and the arm that proves it *can* fail (a wrong fee tier) moves it by
6,986,111,700,549.

### The reserve decoding is validated against the data, not against a table of well-known hashes

Consecutive `Sync` events on one V2 pool must differ by exactly the intervening swap's own deltas.
**6,116 of 6,366 consecutive pairs agree exactly; 250 do not**, and the program prints the
disagreement count rather than filtering it away. That check is what stands behind the `Sync` topic
constant, the uint112 reserve decoding and the delta sign convention.

### The null floor — what "detection is not intent" looks like as arithmetic

On a population where nothing was inserted by construction, the instrument still returns hits with
the same shape as a live detection: same address, same pool, opposite adjacent legs, one enclosed
foreign swap running with the front leg, inside the span bound.

```
span bound OFF   755 false positives / 110,831 leg pairs =  68,121 per 10,000,000
span bound 3      47 false positives / 212,769 leg pairs =   2,208 per 10,000,000
separation       1.75x unbounded  ->  53.95x bounded      (a 30.8x lift)
IRREDUCIBLE FLOOR                                 47
```

**The floor is a property of the data, not of the code.** Ordering alone cannot separate those 47,
and no further conjunct on these bytes will. The rate is also a property of the null's *shape*:
across seven shapes it ranges 1.33×–4.44× unbounded and 31.7×–220.6× bounded. **A single separation
number without its null shape is not a measurement.**

### The block self-consistency guard, which caught a live trap every weaker check passes

```
txCount == 0  <=>  gasUsed == 0  <=>  transactionsRoot == EMPTY_TRIE_ROOT (0x56e81f17…b421)
```

Gas cannot be burned by no transactions. `rpc.flashbots.net`, asked for block 14,000,000, returns
HTTP 200, no JSON-RPC error, a well-formed body, the **real** block hash `0x9bff4917…d9446`, the real
`transactionsRoot`, `gasUsed` 8,119,826 — and `transactions[]` empty. A status check passes it. A
hash check passes it. Three independent endpoints return 112 transactions for that block. Refusal
reason, verbatim:

> `txcount=0 but gasUsed=8119826 — gas cannot be burned by no transactions`

Four verdicts, never a boolean: `ACCEPT`, `ACCEPT_GENUINELY_EMPTY`, `REFUSE_SELF_CONTRADICTORY_EMPTY`
(naming which contradiction fired), `REFUSE_TX_WITHOUT_GAS`. And another endpoint here returned HTTP
200 carrying the body `Hello World!`. **Verify by content, never by status.**

*Why it matters far past this study.* It is one instance of a shape that costs nothing and needs no
second source: **count every item into exactly one bucket and require the buckets to sum to a total
derived independently.** This study runs that shape in FOUR MORE places and every one closed — the ITCH
byte closure (780,003,536 payload + 57,469,372 framing = 837,472,908 decompressed, 0 trailing
unconsumed); the 4×4 contingency table summing to 12,676,036; the wire detector's refusal ladder
summing to leg pairs examined; the log partition (V2 1,667 + V3 3,706 + wrong-shape 0 + other topic0
166,825 = 172,198). If you take one thing from this page into unrelated work, take this one.

### The live wire, at zero cost

```
run 2   721 s · 60 blocks 25,927,780..25,927,839 · contiguous
        559 head polls (499 saw no new block)
        0 head jumps greater than 1 block in 1,076 polls across both live runs
        60 of 60 cross-confirmed by a SECOND INDEPENDENT ENDPOINT —
           identical block hash, identical receipt count, BYTE-IDENTICAL derived swap set
        0 quarantined · 4 insertions emitted with full transaction hashes

        detector kernel  min 2 us · max 75 us   against a ~12,000 ms block interval
        observation lag  min 0 s · max 12 s · mean 2 s

COST    815 HTTP requests · 100,426,957 bytes
        no API key · no account · no licence · no exchange agreement
        no counterparty permission · no subscription · no market-data fee
```

**The most trustworthy thing the watcher does is the run that emitted nothing.** An earlier watch
found four detections of the same shape and **held every one of them unemitted**, because the
confirming endpoint returned `NOT_KNOWN` on 55 of 56 blocks.

| run | blocks | cross-confirmed | quarantined | detections |
|---|---:|---|---:|---|
| live 1 | 56 | 1 of 56 | **55** | 4 — **HELD, never emitted** |
| live 2 | 60 | 60 of 60 | 0 | **4 emitted** |
| replay | 20 | 20 of 20 | 0 | 1 emitted |

Including run 1's four held detections would move the separation **up**, from 83× to 94× — so the
choice is not load-bearing, and the lower figure is the one carried. Four answers are kept apart on
every wire verdict and never print alike: **ABSENCE**, **REFUSAL**, **BOT_BLOCKED** and **NOT_KNOWN**.

The five live rows on disk all reproduce their own attacker-net arithmetic exactly; their victim
shortfall is **NOT_KNOWN_NO_RESERVE_STATE_ON_DISK**, and what would close it is named exactly — the
receipts for those blocks. The offline kernel does not fetch them, because reaching for a network
there would make its answer depend on an endpoint already measured serving `Hello World!` at HTTP 200.

### Why exactness, stated as this corpus's own arithmetic rather than as a principle

```
extraction kernel, whole binary   58,314 instructions · 0 fp arithmetic · 29 fmov
                  decision path   29 symbols · 4,143 instructions · 0 SYMBOLS_NOT_FOUND
                                  · 0 fp arithmetic · 8 fmov
  CONTROL_1 (positive, same per-symbol path)  a Double function: 5 instructions, 4 fp
  CONTROL_2 (negative)  a symbol that cannot exist: 0 instructions → SCOPE_IS_A_SCOPE

detection kernel, decision path   15,393 instructions across 93 symbols · 0 fp arithmetic
```

The generic argument — reproducibility across libm versions — is true and weak. The specific one is
decisive and visible in this corpus's own printed integers. The EXTRACTIVE filter is the entire step
that takes 126 brackets to 108, and it is decided by the **sign** of `n0` and `n1`. The two residuals
nearest the boundary:

```
block 14000708  pool ef4553a9   net_token0                  -2   net_token1  54,100,100,869,088,297
block 14000677  pool d2111624   net_token0 239,952,055,114,733,238   net_token1               -113
```

Those are differences of leg amounts of order 1e17–1e19. IEEE-754 binary64 is exact only below
2⁵³ ≈ 9.007e15; near 1.4e19 — the magnitude of a real leg amount here,
`14,077,314,269,560,450,260` — one unit in the last place is **2,048**. A residual of −2 or −113 is
three orders of magnitude below the rounding error of its own operands. In a double pipeline the sign
of the extraction test is not computed from the data; it is an artefact of the rounding, and the same
bracket classifies either way on two hosts.

**The same argument applies to every shortfall on this page**, which is somebody's money and is
therefore the worst possible place for a number that depends on the host.

---

## 5. The refutation — why the positive result above can be believed

The most common shape a surveillance product takes is a detector keyed on cancellation: displayed
size that never executes, orders with short lifetimes, liquidity that vanishes. Run that predicate
alone over a complete session and it does not find anything. **It counts the market.**

```
PHANTOM alone — displayed size that never executed
  Nasdaq BX TotalView-ITCH 5.0, 2019-07-30
    orders terminated                     12,676,036
    never executed                        12,156,283
    per 1,000 of orders                          958
    per 1,000 of displayed shares                988
    termination split   DELETE 10,164,658 · REPLACE 2,046,443 · DRAINED 464,935
  Nasdaq PSX TotalView-ITCH 5.0, 2019-07-30 — THE SAME DAY, A DIFFERENT BOOK
    orders terminated                     16,165,067
    never executed                        15,952,637
    per 1,000 of orders                          986
    per 1,000 of displayed shares                992
    termination split   DELETE 13,582,830 · REPLACE 2,405,437 · DRAINED 176,800
  Nasdaq ITCH v2, 2003-01-03
    orders terminated                      2,921,796
    never executed                         2,732,598
    per 1,000 of orders                          935
    per 1,000 of displayed shares                936

  IEX DEEP 1.0, 2019-07-30 — THE PREDICATE CANNOT RUN.  ABSENT, NOT ZERO.
```

Nasdaq ITCH v2 and BX 5.0 are sixteen years and a protocol generation apart — v2 carries no Delete
and no Replace message at all, 5.0 splits termination into DELETE / REPLACE / DRAINED — and the
reading moves by 2.3 points. Reg NMS, sub-penny quoting, maker-taker and modern electronic market
making all arrived between those two files and the number stayed put.

**Then the third venue moved it by more in one session than sixteen years had.** BX and PSX are the
same day on two books run by the same operator, read by the same binary, and the reading moves by
**2.8**. Every macro variable is held fixed: same market, same headlines, same volatility. The two
books differ in matching engine and fee model, and they differ visibly on the wire — BX carries 15
message types to PSX's 14, and the one BX has is **N**, the Retail Price Improvement indicator,
**4,636,704** of them. PSX runs no such programme.

**So the base rate is venue-dependent, and that makes the refutation sharper rather than weaker.**
Anyone selling a cancellation-keyed surveillance indicator has to say which venue their number came
from before it means anything, and "Nasdaq" is not specific enough: two Nasdaq books on one day are
28 per 1,000 apart. The quantity is still structural rather than behavioural — market makers cancel
constantly, that is the job — but *how much* of a session it claims is a property of the book.

**A detector keyed on cancellation, on order lifetime, or on displayed liquidity that never trades
measures market making.** That is the denominator every cancellation claim has to be stated against.

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
through its own MPID. **It scores 1.71× the population it is supposed to be separated from**, and
against the 4,786 symbols carrying ≥ 100 entered orders it sits at the **85.14th percentile** of
ordinary symbols (711 of 4,786 score at or above it; 3,727 score at or above the session's own
5,384 bp; 170 symbols sit at a perfect 10,000 bp; mean qualifying symbol rate **7,032 bp**).

The same maker, differing only in whether it quotes one tick *inside* the touch or *at* it, spans 0
to 9,189 bp. **A(f) computed in full sorts by quoting style, not by conduct.** The program prints a
verdict token rather than a paragraph, and refuses outright when handed one population:

```
AF_VERDICT_READING_N   REFUTED_CONTROL_SCORES_HIGHER  worst_separation_bp -3805
AF_VERDICT_READING_J   REFUTED_CONTROL_SCORES_HIGHER  worst_separation_bp -2334
AF_VERDICT_READING_N   REFUSED_SINGLE_POPULATION      (no control supplied)
```

**The narrow claim, stated narrowly.** The maker is a model; its 9,189 bp is a property of parameters
chosen here, not a measurement of any firm. What is carried is the existence claim — *there exists a
legitimate two-sided quoter that scores 91.89% on the regulator's indicator computed in full* — and
that is sufficient to refute a separating claim, which is all that is asserted.

### The equities composite does separate — in sign, on every cell of its ladder

```
PHANTOM  AND  D2 (a price level whose displayed size >= S never filled)
         AND  D3 (an opposite-side execution within W ns before withdrawal)

    BX 2019-07-30     flag 88,900   control 63,140   1,407 per 1,000
                      per-cell min 1,223 · max 3,500 · all 25 cells above 1,000
                      = 7.3 per 1,000 of the 12,156,283 phantom orders
    PSX 2019-07-30    flag 169,275  control 57,401   2,948 per 1,000
                      = 1,061 per 100,000 of the 15,952,637 phantom orders
    ITCH v2 2003      flag  1,643   control  1,033   1,590 per 1,000
```

The control is the same mechanism with exactly one field changed — D3 keyed to the **same-side**
execution clock instead of the opposite side. That is the only kind of control worth having: a
control driven by a different mechanism stays lit through the failure it was built to exclude.

**7.3 per 1,000, not 958 per 1,000.** The instrument prints `RATIO_PUBLISHED_NO_THRESHOLD` and
applies no cut to that ratio anywhere, and the refusal is itself measured: a reader who draws the
line at 1,450 gets opposite answers on the two sessions from the same code.

**What must not be claimed.** Per-cell agreement across a ladder is **not** 25 independent
confirmations — the cells are nested, so ladder agreement is internal consistency and the replication
is the second corpus, where n is 2. The v2 corpus timestamps in milliseconds, so its W = 1,000 /
10,000 / 100,000 ns columns are identical and at most 15 of its 25 cells are distinct measurements.
**The direction clears on two independent sessions. The magnitude does not** — 1,407 against 1,590.

### One of the two staged feeds cannot carry the predicate at all

IEX DEEP 1.0 for 2019-07-30 is 32,123,581 messages and closes byte-exactly. The predicate still
cannot run on it, and the reason is structural rather than a shortage of data.

The predicate keys every order by an **order reference** — an identifier minted when an individual
order is opened and quoted back when that same order is terminated. Whether a feed carries such a
field was decided from the bytes by `reproduce/feed-order-identity.swift`, with the detector
declared before it ran, as a conjunction whose halves fail independently:

```
R1  CARDINALITY  an 8-byte window at some offset takes a distinct value on nearly
                 every opening message                         >= 900 per 1,000
R2  JOINABILITY  the value at THAT SAME offset reappears in the terminating
                 messages                                      >= 900 per 1,000
ORDER IDENTITY is declared only where R1 AND R2 hold at one offset.
```

R1 alone is not a detector — a timestamp passes it and joins nothing. R2 alone is not a detector — a
stock symbol passes it and identifies nothing. Both halves are measured on both feeds, in opposite
directions, so neither can be carrying a verdict by itself:

| | R1-only control · high cardinality, must NOT join | R2-only control · low cardinality, must join |
|---|---|---|
| ITCH 5.0 | timestamp window: card 1,000 · join 0 — fires | stock locate: card 0 · join 1,000 — fires |
| IEX DEEP | timestamp: card 932 · join 0 — fires | symbol: card 2 · join 980 — fires |

On both ITCH feeds the instrument reports `identity_offset 11`, big-endian, cardinality 1,000 and
join 1,000:

```
VERDICT               ORDER_IDENTITY_PRESENT
predicate_status      CAN_RUN
```

Offset 11 is exactly where this study's own kernel reads the order reference. The instrument was not
told where to look.

On DEEP it sweeps 23 offsets in both endiannesses — 46 candidate fields — and none passes both
halves:

```
reference_deep_candidate_fields_swept	46
reference_deep_candidate_fields_passing_both_halves	0
VERDICT               ORDER_IDENTITY_ABSENT
predicate_status      CANNOT_RUN_NO_KEY
```

The reason is visible in the message. DEEP's Price Level Update is 30 bytes and every one of them is
claimed by a field whose meaning was checked against the bytes rather than taken from a document:

```
offset  0  type        1   0x38 buy · 0x35 sell
offset  1  flags       1   2 distinct values across 30629120 messages
offset  2  timestamp   8   30629120 inside the capture window · 0 outside
offset 10  symbol      8   30629049 ASCII space-padded · 71 not · 6,237 distinct
offset 18  size        4   13081242 of them ZERO — the price level was removed
offset 22  price       8   0 zero · min 100 · max 3,700,000,000 raw
                     ----
   bytes claimed by named fields                              30
   price level update body                                    30
   RESIDUAL BYTES AVAILABLE FOR AN ORDER REFERENCE             0
```

And the null does not rest on a choice of message type. DEEP's trade report is 38 bytes to the
update's 30, and the extra eight are high-cardinality, so it was swept as an opening type in its own
right against the price level updates as terminators — 62 further candidate fields:

```
trade_report_identity_offset                -1
trade_report_carries_order_identity         NO
```

Neither of DEEP's two high-volume message shapes mints an identifier the other quotes back.

DEEP does publish a withdrawal — **13081242** of its updates set size to zero — but the thing
withdrawn is a **price level**, not an order. Type `A` on this feed is Auction Information at 80
bytes and type `D` is Security Directory at 31; the message lengths say so before the names do.

**The answer is ABSENT, and ABSENT is not zero.** The predicate counts orders opened and then
terminated without executing. On DEEP there are no orders to count and therefore no denominator to
divide by. A per-1,000 rate computed here would answer a different question while looking like an
answer to this one — which is the specific way a number stops being merely wrong and starts being
misleading.

**That is worth knowing before buying an indicator.** A cancellation-keyed surveillance claim cannot
be computed on aggregated depth data at all. If a product quotes one over a depth feed, the quantity
behind it is not the quantity its name describes.

---

## 6. The corrections this study made to itself

Published on the page's own face, because a study that shows its corrections is the only kind worth
trusting.

**A price field that decoded to four capital letters.** `src/itchcount.swift`, a staging tool, read
type F's price at offset **36**. That is not the price — it is the four-character MPID attribution
that F carries *after* the price. Add Order with MPID Attribution is Add Order's 36 bytes plus 4 of
attribution, so the price stays at offset 32 and only the message gets longer. The misread printed
its own signature: `max_price_raw 1447119960` is `0x56414C58`, ASCII **`VALX`**. Any maximum that
tool reported over a session containing F messages was the largest MPID in it, sorted as a
big-endian integer. Corrected, PSX reads **40,866,100** and BX **40,901,400**. **No published figure
is affected** — the kernel behind every number on this page reads offset 32 for both A and F — and
it is recorded here because the wrong number sat in a staged log where a reader could have taken it.

**A line number typed into three files.** The boundary that slices `extraction-exact.swift` into the
law shared with the WASI tools was the literal `2535` in `wasi-sandwiched-build.sh`,
`wasi-sandwiched-one-law.sh` and `validate.sh`. Any addition to the law was therefore a four-file
change, and three of the four would have gone on quoting a stale number. It is now derived from the
`SECTION 11 — MAIN` marker with the structural check unchanged, and the derived rule was verified to
return exactly **2535** on the untouched file it was written for while tracking the boundary on the
file that moved.

That change had a consequence worth showing, because it is the gate doing its job. Growing the law
moved the slice from lines 1..2535 to 1..2843 and changed its digest — and this page cited the old
range and the old digest in four places. The harness **failed the run** on two of them, by name:
*the page cites a number its program does not produce*. Every figure above was corrected from the
program's own output rather than by hand, which is the only reason a reader can trust the rest of
this manifest.

**Four cited numbers were withdrawn when a null turned out degenerate.** The first null's harness
tied the address draw to the direction draw inside one LCG, so **14,506 of 14,591 same-sender leg
pairs (99.4%) ran the same direction**, suppressing opposite-direction round trips ~85×. A proper
null gives 51.2%. The withdrawn figures — "7 false positives over 222,154 null leg pairs, separation
241× → 843×" — are declined on measurement. The repair itself stands; the surviving figures are the
ones in §4 above.

**An always-green control, caught by measurement rather than by review.** A 2³¹-modulus LCG read at
its low bits produced **0 detections across 223,500 leg pairs** — an arm reporting a false-positive
rate of zero that was a fact about the generator, not about the detector. Three sibling failures were
found the same way: a fixed 5,000 bp cut that certified the MAR indicator as sound at exactly the
point where the indicator was blind; a **two-order** control that flipped a verdict to `SEPARATES
4,418 bp` because at n=2 one order is worth half the scale; and a float scanner scoped to `_main`
that reported 0 FP arithmetic over a two-line `Double` program. The repair is a gate, not a
paragraph: **a control must be INFORMATIVE, not merely present**, with `CONTROL_MIN_ORDERS = 10,001`
derived from the program's own basis-point arithmetic and a second floor requiring the control's
arithmetic ceiling to reach the separation bar. Both `AF_VERDICT` lines above are **unchanged** by
that gate.

**A price read at the wrong offset, closed by its own fingerprint.** An earlier ITCH reader took the
type-F price at offset **36** — which is the MPID — and produced a session maximum "price" of
`1,447,119,960`: the ASCII bytes **V-A-L-X**, a ticker read as a price. The price offset is **32**.
Both kernels here read 32.

**A printed table that changed between runs of an exact program.** Measured 2026-09-08: the
by-pool concentration table sorted a Swift `Dictionary`'s values by count, and Swift randomises
Dictionary order per process, so an unstable sort received a different input order on every run and
the tie rows printed different members. Two runs of the same binary over byte-identical corpora
disagreed. No total, no verdict and no shortfall moved — but a study whose entire argument is that
the answer is a function of the bytes cannot ship a table that is a function of the process. Fixed by
ordering the keys first and breaking the tie on the pseudonym; **three consecutive runs of the same
binary are now byte-identical**, which is the arm that should have existed from the start.

**The bounded detection set is NOT a subset of the unbounded one — by exactly 10.** The bound is a
conjunct inside a greedy matching loop, so refusing a wide pair leaves leg A unconsumed to match a
nearer leg B the unbounded run never reached. Candidate pairs examined *rise* under the bound,
110,831 → 212,769. The clean-removal framing failed its own arm and the arm prints the gap rather
than asserting it away. **Conjunct 7 fires 25 times on a proper null, not 0**, and the program prints
`CONJUNCT 7 DID NOT FIRE ON THE EMITTED LIVE POPULATION` beside every live count — so the detection
totals are explicitly *not* evidence that arm did any work there. **On live data the span bound costs
nothing**: 200 blocks replayed three ways are identical — **4,766 swaps**, **1,427 leg pairs**, 17
detections, 0 straddles, 0 pairs refused by the bound.

**A label defect in the published report, named here rather than quietly fixed.** The line
`blocks_carrying_a_shear 104` sits directly under the extractive count and reads as 104 blocks
carrying one of the 108. It is not: that counter increments on every **bracket**, so 104 is the block
count for the 126. The extractive figure — the one every rate on this page is computed from — is
**92**. Both numbers are printed and both are true of different questions.

**A truncation warning that cost a false reading once.** A `curl --max-time 40` against a 12 MB
transfer returned partial files whose digests read as further artefacts. **Check the byte count
before hashing** — a truncated read and a different artefact are indistinguishable by digest alone.

---

## 7. What this cannot do

**Geometry is not intent, and intent is a statutory element.** Every predicate here identifies
orderings and states exactly decidable from public data. None attaches a label to any address or
firm. The same order sequence is lawful liquidity provision or unlawful conduct depending on purpose
at the moment of placement — a fact about the participant's plan, not about the book. The regulator's
own text says as much of its own list: *"non-exhaustive indicators, which shall not necessarily be
deemed, in themselves, to constitute market manipulation."* The 47-per-212,769 null floor is that
sentence written as arithmetic.

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

No public equities feed closes this, and no amount of engineering substitutes for it. It is also why
the extraction total on this page exists only for Ethereum: the counterfactual needs the pool's own
state, and a central limit order book does not publish the equivalent.

**Ethereum recall has measured holes.** 70 uncovered DEX swap events against 16,517 covered
(4 per 1,000: Curve TokenExchange 20, TokenExchangeUnderlying 13, Balancer V2 Swap 37); 1 cross-pool
bracket by one actor; 0 both-legs-in-one-transaction. And the conjunct set requires the same address
on both legs, so **a participant splitting legs across two addresses is not recalled** — and is
therefore not in the total.

**One venue class publishes the ordering.** Ethereum publishes intra-block ordering as consensus data
and anyone may read it for nothing. That property is why this geometry is decidable here and only
partially decidable on a public equities feed.

**The base-rate band is n = 3 from one publisher, and it is wider than it looked.**
[935, 986] per 1,000 is an invariant of Nasdaq-operated books, not yet of electronic limit order
books in general. PSX has now been run — 30,467,321 messages, byte closure exact, sequence
intact, `VERDICT ACCEPT` — and it reads 986, twenty-eight points above the BX session it shares
a day with. IEX DEEP (32,123,581 messages) has been run and **cannot** carry the predicate at
all; that is measured from its own bytes, not assumed. The third condition the band needed has
been taken, and the fourth turned out to be a different kind of answer.

**No execution path was built.** "Detect the shear so we can trade ahead of it" is the same
extraction this study exists to measure, one layer up. The tree contains no order-entry code, no
venue credentials and no account of any kind.

**Scope of the adjudicated-episode search, plainly:**

```
adjudicated / published episodes located                       12
  validatable on login-free data                                1   (Ethereum, block-and-hash exact)
  CME futures, behind a licensed dataset                        7   OUT_OF_SCOPE_BY_HOUSE_RULE
  not validatable at all                                        4
```

The seven CME rows are **not absent** — they are located, dated and classified, and the data that
would validate them is a licensed product. That is a property of that market, recorded once and
routed around. The equities intersection is **zero** by arithmetic, not judgement: the only
adjudicated equities episode whose venue class has public order-book data ran 2010–2016, and the
earliest public ITCH file is 2019-01-30.


### The 21 NOT_KNOWN rows: the premise was wrong, and that is the result

This page previously said each of the 21 uncosted rows needed two extra reserve states. It does not.
Three routes to the missing pre-front state were tried on every row, in order of provenance:

1. invert the front leg through `v3InvertStart` — the published route, needs nothing but the leg
2. the last swap on that pool earlier in the same block — free, already on disk, and better
   provenance than a fetched value because the chain emitted it in the same block
3. `slot0()` at the parent block and `fee()`, read from a free public archive endpoint

Every route passes the same gate: the candidate price must run the front leg **forward** through the
same `v3Step` onto the price the leg itself reported and the amount it itself returned, and a
candidate fee must reproduce the victim's own leg exactly. The program prints:

```
  states fetched from the free wire                                    9
  endpoint refusals                                                    0
  states REJECTED because they did not reproduce the leg               9
  rows closed from an earlier swap in the same block                   0
  rows closed in total                                                 0
  EXACT rows, unchanged                                               87
  NOT_KNOWN rows, unchanged                                           21
  floor, unchanged            28,889,398,990,674,697,077 wei
```


**Nothing was fitted.** Of the six `FRONT_NOT_INVERTIBLE` rows, five had no earlier swap on that pool
anywhere in the block — so the parent-block price *was* the price before the front leg, and it still
did not reproduce it. Of the three `LEG_NOT_REPRODUCIBLE` rows the pool's own fee was read — 500,
3,000 and 10,000 pips — and none reproduces the victim leg either, so those three now carry the
sharper status `NOT_KNOWN_NOT_REPRODUCIBLE_AT_THE_POOLS_OWN_FEE`: the fee is determined and the model
still fails, which is a refutation rather than a gap.

**Twenty of the twenty-one fail for one structural reason: the single-tick, constant-liquidity step
this counterfactual uses cannot reproduce those legs** — nine because the leg does not reproduce at
the pool's own fee, eleven because in-range liquidity is not constant between the two legs. Whether
that is a tick crossing or a mint or burn inside the step is **not** distinguished here and is not
claimed. Either way what closes them is a multi-tick counterfactual over the pool's tick map — a
larger law than the one written here, and one that would have to be built and validated before any
number it produced could be published.

---

## The call

**What we call.** Insertion shear takes a measurable amount from identifiable transactions, and this
is what it took over 1,000 consecutive Ethereum blocks: **87 costed victims, a per-token integer
table, a derived floor of 28,889,398,990,674,697,077 wei ≈ 94,645.77 USDC**, a median relative loss
of **476 ten-thousandths** of what the person was due and a median absolute loss of **0.170457244547709297
ETH**. What predicts the hit is size **relative to the pool**, not wealth — pool-relative Kendall tau
+491 permille, absolute-ETH tau **−500** permille. On the instrument itself: the five-conjunct
insertion set is a strict refinement, **2,433×** below the naive geometry with **108 of 108**
reproduced set-identical by an independently written kernel; a single-predicate cancellation detector
is **broken as a detector** and retained only as a denominator (958 and 935 per 1,000 on two sessions
sixteen years apart); and MAR Annex I A(f) computed in full does not rescue it.

**What we refuse to call.** No participant is named and no conduct is alleged. The total is a
**floor** and is called one on every line that carries it. The money figures are **DERIVED** and the
annual figures are **PROJECTED_AND_DERIVED** — labelled in the program's own key names, not only in
prose. 21 of 108 rows are **NOT_KNOWN**, which is not zero — and the reason is now measured
rather than open: every free route to the missing state was tried, all nine fetched states were
rejected by the gate that admits any other price, and twenty of the twenty-one need arithmetic
a single-tick step cannot express. The floor did not move. The composite's separation **magnitude**
is not called, only its sign. The base-rate band is not called as "≈95%". And 47 false positives on a
null with nothing inserted is published as the floor rather than argued down.

**Where a reader should point next.** Run the tool on your own hash — that costs nothing and it
is the only part of this page that answers a question about you. The three things this page used
to send a reader to do have now been done, and each opened something narrower:

- **The base rate on a third venue** — done. PSX reads 986 against BX's 958 on the same day, so
  the question is no longer whether the band is real but **how far it spreads across operators**.
  Cboe BZX/BYX/EDGA/EDGX publish PITCH and NYSE publishes Integrated Feed; neither is read here.
- **A fourth venue** — done, and it answered a different question. IEX DEEP cannot carry a
  cancellation predicate at all. What replaces it is **which other products are quoted over depth
  feeds**, because none of them can mean what their names say.
- **The 21 NOT_KNOWN rows** — attempted on every free route, none closed, and the cause is now
  named: twenty of them need arithmetic a single-tick step cannot express. The work that closes
  them is a **multi-tick counterfactual**, which is a specified piece of work rather than a guess
  about missing reserves.
- **Past 1,000 blocks** — the concentration was tested inside the window first and it
  **dissolved**: eighteen of the busiest pool's twenty-two detections sit in one 250-block
  quarter. A wider window should be read as a test of whether bursts like that are common, not of
  whether one pool is special.

And treat the self-consistency guard as the
transferable result: count every item into exactly one bucket, require the buckets to sum to an
independently derived total, and the trap that returns HTTP 200 with a real block hash and an empty
body stops passing.

---

## Reproduce

Everything is path-independent: no absolute path is baked into any source or script, every path is
derived from the script's own location, and digests are read from the pin file at run time. The
corpora are large and publicly fetchable, so they are **fetched**, not committed.

**Every program here prints its published reference figures on every exit path, including the ones
that measure nothing.** Run one with no arguments and it tells you what it would have measured and
why it did not — because a figure a page cites that its program never prints is not reproducible, and
an uninstrumented early exit is indistinguishable from a program that was never built.

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
```

**The extraction — what was taken, in integers.** This is the program that produces every figure in
§1.

```bash
bash reproduce/extraction-run.sh
#   builds reproduce/extraction-exact, runs its 29 self-test arms, scans the emitted image
#   for floating point with both controls, then measures the corpus. Source digest is
#   bracketed around the whole run, so a source edited mid-run is reported, not hidden.

reproduce/extraction-exact            # no corpus: prints the reference figures, exits 4
```

With no corpus it measures nothing and says so, then prints what it measured when the corpus was
there — labelled on the key itself, so the two can never be read as one:

```
scope                            WHAT_WAS_TAKEN__ATTACKER_NET_AND_VICTIM_SHORTFALL
legal_position                   GEOMETRY_ONLY_DETECTION_IS_NOT_PROOF_OF_INTENT
acting_addresses_on_output       KEYED_PSEUDONYM_8HEX
victim_transaction_hashes        PRINTED — the harmed party must be able to find their own row
CORPUS_ABSENT                    no --dir given
ABSENT is not a REFUSAL and it is not a pass: the corpus is fetched, never committed.

figures_below_are   PUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS
  detector          126 brackets · 108 extractive · 104 blocks · 26 extractive actors
  discrimination    262,799 naive positional brackets across 848 blocks vs 108
  reproduction      108 of 108 SET-IDENTICAL under an independent re-derivation
  null floor        47 false positives per 212,769 leg pairs under the span bound
  costed rows       87 of 108 EXACT · 21 NOT_KNOWN, each with a named reason
  relative loss     min 47 · p25 102 · MEDIAN 476 · p75 1,785 · max 9,999 bp
  rate MEASURED     108 detections per 1,000 blocks = 13,586 s · 28 per hour
  PROJECTED         686 per day · 250,390 per year — NOT MEASURED, untested assumption
THE TOTAL IS A FLOOR AND IS CALLED ONE.
```

**The tool — was I sandwiched, and what did it cost me.**

```bash
bash reproduce/wasi-sandwiched-build.sh          # slices the law, pins its digest, compiles
./reproduce/wasi-sandwiched <your-transaction-hash>

./reproduce/wasi-sandwiched --selftest           # 79 arms, no network
bash reproduce/wasi-sandwiched-fpscan.sh         # 12 arms, both directions
bash reproduce/wasi-sandwiched-one-law.sh        #  9 arms — the tool defines no law
```

**The pre-trade check — how much of what I am due can be taken, before I sign.**

```bash
bash reproduce/wasi-exposure-build.sh            # slices the SAME law, pins its digest, compiles
./reproduce/wasi-exposure <pool> <token-in> <amount-in-base-units>

./reproduce/wasi-exposure --selftest             # 31 arms, no network, both directions
./reproduce/wasi-exposure --validate --dir corpus/market-shear/eth
                                                 # replayed against the 87 costed victims:
                                                 # 85 exact to the base unit, 2 an upper bound
bash reproduce/wasi-exposure-one-law.sh          # 19 arms, 6 of them controls
./reproduce/wasi-exposure                        # no argv: exits 4, prints the reference figures
```

The law slice digest below is the one `wasi-sandwiched` prints. The figure this program forecasts
and the figure the study measured come from one law, and the one-law gate measures that rather than
asserting it.

**The detection instrument, the independent re-derivation, and the naive null.**

```bash
bash reproduce/market-shear-run.sh        # builds reproduce/msx, then both ITCH sessions

reproduce/msx eth --dir corpus/market-shear/eth --start 14000000 --count 1000 \
     --expect-blocks 2f3c1b9f... --expect-receipts af09271d...
reproduce/msx itch50 --gz corpus/market-shear/itch/20190730.BX_ITCH_50.gz --expect-sha256 a0a05701...
reproduce/msx itchv2 --zip corpus/market-shear/itch/S010303-v2.zip --member S010303-v2.txt \
     --expect-sha256 eb67a239...

swiftc -O reproduce/market-shear-rederive.swift -o /tmp/rederive     # shares no code
/tmp/rederive --receipts corpus/market-shear/eth/receipts.ndjson \
              --blocks   corpus/market-shear/eth/blocks.ndjson

swiftc -O reproduce/market-shear-positional.swift -o /tmp/positional # the 262,799 null
/tmp/positional --receipts corpus/market-shear/eth/receipts.ndjson
```

**The controls, the nulls and the wire arm.** Each exits non-zero when it should.

```bash
swiftc -O -swift-version 5 reproduce/af-conjunct-exact.swift -o reproduce/afc
swiftc -O -swift-version 5 reproduce/live-wire-watch.swift   -o reproduce/lww

reproduce/afc --selftest         # 31 arms, both directions
AF_NO_CONTROL=1 reproduce/afc lbl < session      # REFUSED_SINGLE_POPULATION
reproduce/lww --selftest         # 37 arms
reproduce/lww --emptiness        # the self-contradiction guard, on the live trap
reproduce/lww --null             # the false-positive floor, with its refusal ladder
reproduce/lww --null-shape 3 12 100000           # NULL_POPULATION_UNINFORMATIVE, exits 1
reproduce/lww --watch --seconds 720 --out .      # the live wire. Cost: 0.
reproduce/lww                    # no argv: self-test + null + reference figures, ZERO network
bash reproduce/market-shear-fpscan.sh --control-only   # the FP scanner, on its own control
```

**`--watch` is the only mode that touches the network, and it is never the default.** The no-argv
path was `--all` — probe the endpoints, then watch the chain head for 600 seconds — which made a
harness spend ten minutes on the wire to decide whether a program builds. `--all` still does exactly
what the old default did; it is now named rather than assumed.

Pinned digests, so a reader can confirm they hold the same bytes:

```
20190730.BX_ITCH_50.gz  391,242,214 B  a0a057010cc5172cfaf2d8a7b4d5f133557fa47b3a5837fcf985b6e5533e50eb
S010303-v2.zip           58,907,174 B  eb67a239cf09b7de1843f6b0ede3c473616cc5cac777b293bbe15608bf51794d
eth/blocks.ndjson       274,405,185 B  2f3c1b9f23645c7b0ad652b1ba677691a16b7a6b538f31af5680189cbf47e5ff
eth/receipts.ndjson     378,717,564 B  af09271d39451288bbd9728f6488bb7a7e0d3441428caa22530d159af562feb0

extraction-exact.swift         3,011 lines  3b67f7e92bdb2305671c20e8686aaae442349b8daa9162fd955fd7bc64756b3a
wasi-sandwiched.swift          1,463 lines  e2742ecd94d8001741fcc14be01cc29968271345120921cd2820407b2e26560e
  its compiled-in law slice  156,508 B  6b093daa07214dd589156235cc4fcb04b21de3750d6b76f008e35baf0c9e2799
wasi-exposure.swift            1,782 lines  2b1c6c21c1fd51d3373cf44bb43a88231523c6f98b8d0856557e3f2812342439
  its law slice is the SAME one, cut from the SAME file at the SAME marker as the line above —
  no separate digest is pinned for it, because two pins for one fact become two facts
market-shear-exact.swift       2,763 lines  619637839ee57b2102c409c6f7487fcf993fe771c48c5c40dfdc66f31e6d9fe5
af-conjunct-exact.swift        1,510 lines  9d669a55f4fa42547dc8d417bd80edff4ea7824f0c9fddb9810932fdaadcc838
live-wire-watch.swift          2,576 lines  85403365cf25700f2beb8db27588382a953ec482ce81c7c4b1425cf53eb3e675
market-shear-rederive.swift      380 lines  f6558631196f4a35e322fbb66163b74a4260a631c236376f8dbb3997057599ed
market-shear-positional.swift    117 lines  e9b7be225145224992ccd1a8f0ee02e8d209e370ca8c8eb59c102be439f52332
feed-order-identity.swift        670 lines  05390a8c6539604e9ced25965a23cd323f1d8db653d35c980447fd414896f8e4
```

**Two honest notes on those digests.** For NASDAQ ITCH there are no publisher digests: the listing
advertises `.md5sum` sidecars beside every archive and a GET returns HTTP 404, re-measured for the
pinned files, so both ITCH digests are ours and the artefact says so on its face. They prove two
readers hold the same bytes; they do not prove those bytes are what the publisher meant to serve, and
nothing here claims they do. And a JSON-RPC response is **not byte-canonical across providers** —
some emit a non-consensus `blockTimestamp` per transaction and some do not, a 3,360-byte difference
on block 14,000,000 with block hash, ordering and every transaction hash identical. The `eth/*`
digests are over the stored form from the named endpoint. Digest the consensus content and two honest
archives agree exactly; digest the response bytes and they read as a divergence that is not there.

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
