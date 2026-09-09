# Study 43 — Almost every order is cancelled, and that is normal

*Someone tells you a market is being manipulated. They point at a number: this many orders were
placed and then withdrawn without ever trading. How would you know whether that number meant
anything?*

*We ran that check — the standard one, the shape most surveillance products take — over nine
trading sessions. Three exchange operators, two continents, two sets of market rules, 2003 to
2026. It flagged between **935 and 998 out of every 1,000 orders that ended**.*

*A check that says almost everything is suspicious is not detecting anything. It is describing how
a market normally works. **Firms that make markets post prices on both sides of a stock all day and
pull them the moment the world moves. That is their job, not misconduct.** A hundred withdrawals
for one trade is ordinary. Nobody on this page is accused of anything, and — measured, not
promised — nothing in these feeds could support an accusation even if someone wanted one.*

*So the number is not a finding. It is a **denominator**: what an ordinary session scores when
nobody is doing anything. It exists so that any cancellation-based claim has something to be
measured against. Right now such a claim has to beat **958 out of every 1,000 on a complete,
ordinary trading day**.*

*And the half that keeps it honest. Five of our nine sessions are **one exchange operator's five
books on a single morning** — not five independent venues. Five are recordings that stop part-way
through the session, and on one of them 714 of every 1,000 orders were still sitting on the book
when the bytes ran out. On the blockchain half of this work, one of the five conditions the sharper
check uses — plus the separate profit test that is not one of the five — can be side-stepped for
**no fee at all** by someone willing to hold inventory, and **we did not measure what holding that
inventory costs.***

---

## What an order book is, and what "cancelling" means

An **order** is a standing offer: *I will buy 100 shares of this company at this price.* It waits in
a queue with everyone else's offers until somebody trades against it, or until the person who put
it there takes it back. That queue is the **order book**, and the exchange publishes it — every
order arriving, changing, trading and leaving — as a stream of small binary records called a
**feed**. That feed is what this study reads. Not summaries of it. The records themselves.

Taking an order back is a **cancellation**. It is the most common thing that happens on an
exchange, and the reason is not sinister.

A **market maker** is a firm that offers to buy and to sell the same stock at the same time, all
day, so that anyone arriving with an order finds someone on the other side. Its prices have to
follow the world. When a number moves, a headline lands, or a related price shifts a cent, the firm
pulls its quotes and posts new ones — thousands of times a second, across thousands of companies.
Almost none of those quotes ever trade. **That is not a failure of the quote. It is what quoting
is.** A hundred cancellations for every trade is unremarkable in this business, and any measurement
that treats it as remarkable is measuring the business.

That is the whole tension on this page. The most natural surveillance idea in the world — *count
the orders that were shown and then taken away* — lands directly on top of the most ordinary
activity in the market. The industry has a word for size that was displayed and never traded:
**phantom**. This page is about what that word is worth as a measurement.

## Why this matters to somebody who does not work in markets

Because someone is going to sell your pension fund, your exchange, or your regulator a product
built on exactly that idea, and it will come with a number attached. The number will sound
alarming. *Ninety-four per cent of the displayed liquidity in this name never traded* — meaning
ninety-four per cent of the shares somebody offered in that one stock were taken back untraded.

The question that decides whether that sentence means anything is not in the sentence. It is:
**what does the same check score on a day when nothing is happening?**

That is what this page measures, on as many different books as could be read. A cancellation-keyed
check scores between 935 and 998 per 1,000 more or less wherever you point it. So the alarming
sentence is compatible with a completely ordinary morning, and also with a genuinely manipulated
one, and the number by itself cannot tell you which.

This is a small, boring, useful result of the kind that saves people from expensive mistakes. It is
also transferable. The same failure shape — *an instrument whose reading barely moves across every
case it is supposed to tell apart* — turns up in medicine, in fraud scoring, in content moderation
and in safety monitoring. A test that is almost always positive is not a test.

## What we checked, and on what

One check, decided by whole-number arithmetic on the exchange's own fields. No price model, no
threshold chosen by us, no decimals anywhere on the decision path.

> Follow every order the feed opens all the way to its end. Count the ones that ended having traded
> **nothing at all** — deleted, replaced, or run down to zero size on a wire that carries no delete
> message. Report those as a rate per 1,000 orders that actually reached an end.

Two things must be true of a feed before that check can even be attempted, and both were measured
on each feed rather than assumed:

- the feed gives each individual order a **durable identifier** — a number minted when the order
  opens and quoted back when it ends, so the two events can be joined;
- the feed reports cancellation as **its own kind of event**, rather than as a quantity at a price
  quietly getting smaller.

An order still sitting on the book when the recording stops is **not** counted as anything. It goes
into its own bucket — the word for it is *censored* — and it never prints as a zero. Half the
sessions here are truncated recordings, so that bucket does real work, and its size travels with
every number on this page.

### Before any number is believed, the feed has to be admitted

A feed is admitted or it is not, and **both outcomes are results**. There is no "approximately".
The full procedure is twelve steps; three are worth seeing, because each one caught something.

**Count the bytes before you fingerprint them.** A digest — the short fingerprint you compute from
a file to check two people hold the same one — tells you the files match. It does not tell you the
file is whole. A half-downloaded read and a genuinely different file look identical to a digest.
And a compressed file's own claim about its contents becomes fiction the moment it is cut short: on
three partial files the container reported 1.95 GB, 3.85 GB and 2.80 GB, all garbage.

**Prove the price field is the price.** On a binary feed the trap is where in the record you start
reading. This programme once recorded a session high of 1,447,119,960 — which is not a price at
all. Read those four bytes as text and they are the initials of a member firm's code, sitting just
after the price in a longer message. Re-proved on the bytes used here: readable letters at the
wrong position on 49,470 of 49,470 of those messages, and on 0 of 49,470 at the right one.

**Give the joining key a near-miss arm.** Testing whether a field really links an order's opening
to its ending needs four arms, not one. The real key matched 1,000 per 1,000. A deliberately
shifted key finds the accidental-collision floor: 79 per 1,000. A *plausible neighbouring field*
matters most — a sequence number sitting right next to the real key matched **689 per 1,000** and
would have read as a working linkage to anyone who tried only one arm. And a causal reversal, where
the matches have to collapse to nothing, and do: 187,602 down to zero.

## The number

Nine sessions carry a comparable rate. Four are complete sessions. Five are truncated heads — the
recording begins at the start of the file and stops before the session does.

| session | operator | date | window, local time | orders that ended | ended without trading | **per 1,000** | orders that *did* trade, per 1,000 | still open when the bytes stopped, per 1,000 opened |
|---|---|---|---|---:|---:|---:|---:|---:|
| Nasdaq | Nasdaq | Fri 2003-01-03 | **complete**, 07:00:00 → 20:00:31 | 2,921,796 | 2,732,598 | **935** | 64 | 0 |
| Nasdaq BX | Nasdaq | Tue 2019-07-30 | **complete**, 03:06:35 → 19:05:00 | 12,676,036 | 12,156,283 | **958** | 41 | 0 |
| Cboe Europe BXE, one instrument | Cboe Europe | Tue 2020-09-01 | **complete**, 08:00:00 → 16:40:29 | 55,251 | 53,909 | **975** | 24 | 0 |
| Nasdaq PSX † | Nasdaq | Tue 2019-07-30 | **complete** session | 16,165,067 | 15,952,637 | **986** † | 13 | 0 |
| NYSE Arca | ICE / NYSE | Wed 2026-04-01 | **truncated**, 04:00:00 → 04:29:00 — 29 min | 253,809 | 251,097 | **989** | 10 | 73 |
| NYSE Texas | ICE / NYSE | Wed 2026-04-01 | **truncated**, 00:18:46 → 09:14:27 — 8 h 56 m | 121,297 | 120,331 | **992** | 7 | 7 |
| NYSE | ICE / NYSE | Wed 2026-04-01 | **truncated**, 06:30:00 → 09:26:06 — 2 h 56 m | 82,132 | 81,648 | **994** | 5 | **714** |
| NYSE American | ICE / NYSE | Wed 2026-04-01 | **truncated**, 07:00:00 → 09:30:06 — crosses the 09:30 opening auction by 6.3 s | 108,421 | 108,137 | **997** | 2 | 143 |
| NYSE National | ICE / NYSE | Wed 2026-04-01 | **truncated**, 07:00:00 → 08:10:39 — 1 h 11 m | 130,683 | 130,451 | **998** | 1 | 6 |

**The bottom five rows are one exchange operator's five books on one date.** They share a wire
format, a day, and one list of stocks divided five ways between them, read five times by one
program. Their nine-point spread is an upper bound on how much a venue can move this number *inside
one family*, tangled with an eighteen-fold difference in how long each recording lasted. It is an
estimate of nothing. And the European row is one instrument's complete day rather than a whole
venue's session — two true statements about the same 55,251 orders, and two different objects.

† The PSX row is another lane's measurement, cited as theirs and not re-derived here. It is the one
row without its own byte scope. Read it as borrowed.

**Three of these nine rows are not new.** Nasdaq 2003 at 935, Nasdaq BX 2019 at 958 and Nasdaq PSX
2019 at 986 were already published, together with the whole blockchain half of this work. What is
new is six more sessions: the first non-US venue, the first non-Nasdaq operators, and the first
truncated recordings. The band "935 … 998 across nine sessions" is six new points bolted onto three
old ones, and it is written that way rather than presented as nine fresh measurements.

**What the extra six rows settle.** The earlier page said in its own words that the band was "an
invariant of Nasdaq-operated books, not yet of electronic limit order books in general" — three
books from one operator was all it had. Three operators later, on two continents, under two
rulebooks and across twenty-three years, the rate still does not leave 935 … 998. What that page
could not say, this one can: the ordinariness is not a Nasdaq property. And the thing that moves
the number is not the exchange at all.

Two further points were run on the European feed and produce no comparable rate. Both are results
and both are printed rather than dropped:

- a second instrument on the same day and feed ended 164 orders, all of them without trading. A
  rate of exactly 1,000 from 164 orders carries no information, so it is reported and withheld from
  every band.
- a third instrument's file converts to a 20-byte stream that frames no message at all. The
  detector exits with an error and says so. **A refusal left out of a table is indistinguishable
  from a feed nobody pointed the instrument at**, so it stays in.

## Why a number this high means the check is not working

Look at the second-to-last column, the one counting orders that actually traded. Between the top and
bottom rows of the table — a complete 2003 session and a 71-minute truncated head from 2026 — the
headline number moves 63 points on a scale of 1,000, from 935 to 998, which reads like almost
nothing. On those same two rows, the population a surveillance product would actually have to look
inside moves from **64 per 1,000 down to 1 per 1,000: a factor of sixty-four.**

Most of that spread is *when the recording was taken*, not *which exchange it came from*. The
sessions with almost no trading are the truncated pre-auction heads, where the day has barely
started. That is the point rather than an objection: the headline number is nearly flat across
conditions that differ enormously, so the headline number is not carrying the information. It has
run out of room at the top of its own scale and stopped responding to the thing it is supposed to
measure.

A detector keyed on cancellation, on how long an order lived, or on displayed size that never
traded is measuring market making. It is a census, not a finding.

## The thing that moves it most is not the exchange

We took one exchange, one truncated New York morning, one program, and ran it once per listed
company: **321 stocks**. The 321 separate runs add back up to the whole-morning run exactly — same
orders, same endings, same rate. Then we kept only the stocks with enough orders to say anything
about, meaning at least 100 orders that reached an end. There are **25 of them**.

- The band across those 25 is **765 … 1,000**.
- **Seven** of the 25 sit at exactly 1,000: every single order that ended, ended without trading.
- **Eleven** of the 25 sit *below* the published Nasdaq figure of 958. **Seven** sit below 935.
- The lowest is `TGT` at **765** — and that 765 is a rate over the 405 of its orders that reached an
  end, while **8,407 of its 8,812 orders were still resting when the recording stopped.**

Those are ticker symbols. They identify the stock the orders were in and say nothing whatever about
the listed company or about anyone trading it.

Set those against the other two things that could move the number, measured on the same corpus:

| what changes | how much the rate moves | how good the comparison is |
|---|---:|---|
| **which stock** — inside one exchange, one morning | **at least 235 points** (765 … 1,000) | one venue, one truncated morning, and only the 25 stocks with enough orders to count |
| **the time of day** — one exchange, one complete session, re-cut at a ladder of earlier end times | **40 points** (958 … 998) | clean: same book, same day, same program — and every rung except the last is itself a truncated window, so each carries its own censored count |
| **the exchange** — Nasdaq BX against Nasdaq PSX, same day, same operator, same program | **28 points** (958 … 986) | **tangled with another difference, and we say so** |

**That last row used to say "not arguable" and it was wrong.** BX and PSX are the tightest contrast
in the corpus — same operator, same day, same instrument — but they are not matched on the wire. BX
carries 15 kinds of message and PSX 14, and the extra one flags a programme for improving retail
customers' prices that BX runs and PSX does not. BX emits **4,636,704** of them in the session. The
two books also differ in matching engine and fee schedule. So the 28 points is a venue effect with
a market-structure effect folded inside it, and the two cannot be separated from these bytes.

**And the per-stock range needs one more piece of care that an earlier draft got wrong.** On NYSE
Texas the same enumeration gives a floor of **186** — and that floor is `CTEST`, **the venue's own
test symbol**, a placeholder used to check the plumbing. Every real company name in that book's top
fifteen sits between 988 and 1,000. The run prints only the top fifteen and the two extremes, so
**the floor for real company names on that book is NOT MEASURED**, and 186 without `CTEST` beside
it is publishing a test artefact as a market fact.

Two more honest edges here:

- Of the 321 NYSE symbols, **21 report no resolved order at all.** That is not a rate of zero and it
  is never averaged in.
- Of the 300 symbols that did resolve at least one order, the median has **9** orders that reached
  an end. A quarter have 4 or fewer, three-quarters have 21 or fewer, and 275 of 300 have fewer than
  100. An earlier version of this work quoted "85 of 300 symbols below 958", which is arithmetically
  true and should not be quoted, because most of those 300 denominators are smaller than the one
  this study calls degenerate two paragraphs earlier. **11 of 25 is the honest version.**

**So anyone quoting one cancellation number for "the market", or even for one exchange, has quoted a
number for nothing.** Which stock you look at moves it further than which exchange you look at, and
so does what time of day you look.

## Three feeds where the check cannot run at all

Three of the feeds we pointed this at cannot answer the question — and each fails a *different* way.
That distinction matters more than it sounds like it does, because all three would look identical in
a summary that only recorded "no result".

**One: the feed has no order identity.** IEX DEEP publishes changes to a *price level* — how much is
available at a price — not to individual orders. Its update message is 30 bytes, and every one of
those bytes is claimed by a field whose meaning was checked against the bytes rather than taken from
a document: type, flags, timestamp, symbol, size, price. **Bytes left over for an order identifier:
zero.** Forty-six candidate fields were swept and none joins an opening event to a closing one, and
a second, larger message type was swept separately, so the answer does not rest on one message
shape. The feed does publish withdrawals — 13,081,242 of its updates set a size to zero — but the
thing withdrawn is a price level, not an order. There is nothing to count and therefore no
denominator to divide by. *(This one is already published. It is repeated here because the
three-way contrast is the point.)*

**Two: the feed has no event types.** The consolidated tape — the single national stream of best
quotes that most people mean when they say "the market data" — carries no division between kinds of
event at all. A quote getting worse and a quote being cancelled are the same bytes. We swept **466
candidate keys** across 233 positions in the record, in both byte orders. 34 pass a uniqueness test,
418 pass a re-appearance test, and **zero pass both** — every column sits on exactly one side.

The instrument was made to say YES first, on 536,870,912 bytes of real Nasdaq BX data, where it
finds the identifier and scores 1,000 out of 1,000. A NO from an instrument that has never said YES
is worth nothing.

No substitute was put in its place. A *different* quantity was measured and reported as a different
quantity: **344,258 reductions at the top of the book across 772,868 quote transitions, 445 per
1,000** — over a stated 16 MiB head of the file, which because the file is sorted by company name is
a **17-symbol prefix spanning the whole session, not the first few minutes of it**. The tape carries
no trade records at all, so each of those reductions is a withdrawal *or* a fill and the tape does
not say which. And the denominators are different objects: 12,676,036 **orders** against 772,868
quote **transitions**. Quoting one for the other is a category error, not a measurement.

### The empty archive, and why it is the most dangerous of the three

**Three: the file has nothing in it, and every check says it is fine.**

NYSE's own published archive of its Arca order book for Thursday 18 June 2015 is **20 bytes**. Not
cut short in transit — complete, well-formed, and empty by construction:

```
header    10 bytes   gzip magic, deflate
deflate    2 bytes   final block, first symbol = end-of-block
trailer    8 bytes   checksum = 0x00000000, uncompressed size = 0
--------------------
accounted 20 of 20   exact, zero unaccounted bytes
```

Now look at what an operator's automated checks would see:

```
HTTP status         200                                   fine
gzip -t             PASS, exit 0                          fine
md5                 68123fc57aeef19f331acd74803b4c28      a digest is produced
sha256              ca1774d2…88d8b2                       a digest is produced
.MD5 sidecar        present at source, 33 bytes           a checksum sits beside it
gzip internal date  2015-06-18 20:16:09 EDT               a real post-session timestamp
------------------------------------------------------------------------------------
payload byte count  0                                     THE ONLY SIGNAL THAT FIRES
```

Status, integrity, digest, sidecar and timestamp all say the file is good. The container's own
metadata asserts a genuine session on a genuine date, and it is telling the truth about the date —
transplanting those four timestamp bytes into a compressed empty file reproduces NYSE's published
fingerprint exactly. Two standard tools disagree and neither headline is right: `file` calls it
truncated, `gzip -t` calls it valid. It is neither. It is complete and empty.

**A cancellation detector pointed at this file returns zero flagged orders — and a zero here means
"the archive had no bytes", not "the market was calm".** Every standard tool exits cleanly with a
count of 0. An operator running this nightly across a directory of daily archives would see a quiet
day and have no signal at all that they had measured nothing.

**It fails in the reassuring direction.** On a safety instrument that is the dangerous one: it
understates the base rate rather than overstating it. And it is not a freak — **two of the four data
files on that venue's own listing are 20 bytes, and the only two carrying a checksum beside them are
the two with no data in them.** A digest certifies transmission. It does not certify content.

Our detector was pointed at it anyway. It refused, printed `measured_by_this_run NOTHING`, and
exited with an error. That is a fifth kind of answer, distinct from the four this programme already
keeps apart, and it needed its own name: **EMPTY AT SOURCE.**

What these 20 bytes cannot support is worth stating too, because it is the most available mistake:
they say nothing about the market on that day, and nothing about whether the ArcaBook format carries
order identity. That was never measured here and is not asserted.

**The general shape is bigger than markets.** A machine that reports "all clear" because it read
nothing is the failure mode that safety monitoring, medical screening and content pipelines share.
The fix is arithmetic rather than vigilance: require a payload byte count and a message count before
any verdict, including a null one, and refuse when either is zero. **An instrument handed nothing
must not report success.**

## The sharper check fails on the new venues, and on one of them it points backwards

Counting cancellations alone is a census. The obvious repair is to require more things at once, so
we did: an order that traded nothing, **and** sat at a price level whose displayed size never
filled, **and** was withdrawn closer in time to a trade on the *opposite* side than to one on its
own side.

Against it runs a control that is the same mechanism with exactly one field changed — the same-side
clock instead of the opposite-side clock. That is the only kind of control worth having. A control
driven by a different mechanism stays lit through the very failure it exists to exclude.

The test is run at a range of settings — how much displayed size counts as a wall, how close in time
counts as close — which gives a grid of results rather than one. On three Nasdaq books the composite
beat its control in every square of that grid. Our own earlier page said so in those terms: *"The
equities composite does separate — in sign, on every cell of its ladder."* On the evidence it had,
that was true.

Six more sessions now exist, and the sentence is false of nine:

| session | window | composite count | its own control | ratio, per 1,000 |
|---|---|---:|---:|---:|
| Nasdaq PSX 2019-07-30 † | complete | — | — | **2,948** † |
| NYSE National 2026-04-01 | truncated | 599 | 304 | **1,970** |
| Nasdaq 2003-01-03 | complete | — | — | **1,590** |
| Nasdaq BX 2019-07-30 | complete | 88,900 | 63,140 | **1,407** |
| NYSE Arca 2026-04-01 | truncated | 7,451 | 6,491 | **1,147** |
| NYSE American 2026-04-01 | truncated | 363 | 318 | **1,141** |
| Cboe Europe BXE 2020-09-01 | complete | 3,157 | 3,014 | **1,047** |
| **NYSE Texas 2026-04-01** | truncated | **68** | **152** | **447 — below its own control, pointing the other way** |
| NYSE 2026-04-01 | truncated | **0** | **0** | undefined |

Read the last two rows first. On NYSE Texas the composite fires **less** often than the control it is
supposed to beat. On NYSE it fires zero times and so does the control — and `0 against 0` is not a
triumph, it is the instrument announcing that this window contains nothing to condition on. Inside
the European book, breaking the aggregate into its own grid, **8 of the 15 cells that have a defined
ratio sit below 1,000**, meaning below their own control.

**The instrument prints the two counts and their ratio and refuses to draw a line across them**, and
the reason is the most useful thing in this section. An earlier build of it returned a yes-or-no
verdict on `flag × 100 > control × 130`. The constant 130 appeared once in the source and was
derived nowhere. A self-test arm now builds a stream, measures a real pair of counts from it, and
shows that **the same measurement returns opposite verdicts when that constant moves.** The
instrument's own words for what 130 was: *a chosen threshold wearing the costume of a measurement.*
That verdict was withdrawn. Every current run prints `RATIO_PUBLISHED_NO_THRESHOLD`, and the reader
draws the line.

**We then made exactly the same mistake one level up, and it is corrected here.** A draft of this
work replaced the threshold of 1,000 with a threshold of 1,300, sourced it to "the instrument's own
rule", and labelled four venues *indistinguishable from control* on that authority. The instrument
had already struck that rule from its own source. It asserts neither number. This page prints the
counts and the ratio and nothing else — which is a better story than a threshold anyway, because it
hands the judgement to the person who has to live with it.

**Where the NYSE zero comes from, since a zero invites a conspiracy.** It is a property of the
window, not of the venue: **100,337 of NYSE's 136,091 withdrawals — 737 per 1,000 — happen before
*any* trade has occurred in that stock on that side**, so there is no clock to measure against. Cut
the complete Nasdaq BX session down to its own pre-opening head and the identical degenerate answer
comes back: 5,356 of 5,374 withdrawals precede any execution, composite 0, control 0. A truncated
pre-auction book is an exchange's **opening procedure** being read as manipulation.

**Stated plainly, because it is our own claim being refuted by our own data:** the published sentence
held on the three books it was measured on and does not hold on nine. What survives is narrower and
more useful — the composite carries information on some venues, and says so when it does not.

## The one check that does separate, and what it would cost to dodge

The exchange feeds have a hole in the middle of them, and it is the same hole every time: nobody is
on the wire. A public blockchain does not have that hole. Every transaction carries the address that
sent it, and the order of transactions inside a block is part of the published record rather than
something inferred from clocks.

That makes a much sharper question decidable. Take three trades on one automated exchange contract
inside a single block, in the order the block puts them, and ask five things at once: were the first
and third sent by the same party, was the middle one somebody else's, were the outer two on opposite
sides, did the middle one run the same way as the first, and are they three distinct transactions.
Then one further test on what the outer party was left holding: more of at least one thing, and less
of nothing. All of it is decided in whole numbers on public data.

Over 1,000 consecutive blocks — three hours and forty-six minutes of chain time — that check fires
**108 times out of 22,287 candidate triples: 4.8 per 1,000.** Set it beside the cancellation check's
958 per 1,000 on an ordinary exchange session and the contrast is the whole argument of this page.
**An indicator that fires on 95.8% of a session is measuring the session. One that fires on half a
per cent of its candidates is not.** *(That result is already published. This study did not
re-measure it.)*

**What is new here is an attack on it.** Suppose somebody reads those conditions and sets out to fall
outside them. What does it cost, priced against these actors' own transaction fees in the same
corpus?

- **Two of the tests can be dodged for nothing** — and it is worth being exact about which. One is a
  condition: alternate the two roles between two addresses you have already funded, and the
  same-party test fails. The other is not one of the five at all; it is the separate profit test
  that cuts 126 candidate triples down to 108. Sell back one unit more of the bought token than you
  bought and that test fails too. Both are free to the last unit.
- **Everything that costs an extra transaction is unaffordable at the margins actually observed.** On
  the median case, fees already take **983 of every 1,000 units of what was taken** — 975 at the
  lower quartile, 990 at the upper, above 900 on 78 of 95 priced cases. One additional transfer
  costs more than that entire remaining margin on **74 of 95** priced cases. Unwinding on a second
  contract forfeits more than the whole margin on **every** case that could be priced. Holding the
  position open until a rival arrives costs the whole margin on 31 of 35 priced cases at a quarter
  of the actor's own size, 33 of 35 at their own size, and 35 of 35 at four times.
- **Two of those priced dodges do not defeat the check on this page at all.** The decoy trade and the
  widened hold defeat a *live* watcher that requires the two outer legs to be adjacent and close
  together. The published check has no such requirement — it scans every position between the legs.
  Those two are priced here because a reader will reach for them, not because they work.
- **The two free dodges do not make the extraction invisible. They destroy precision.** Re-attribute
  every closing leg to a fresh address and re-enumerate the whole corpus: the counts move exactly and
  the arithmetic closes on itself, because the contract-side calculation is blind to who submitted
  what. What changes is that **857 extractive cases per 1,000 candidates becomes 21 per 1,000 — a 40×
  loss.**
- **And the bound this work cannot close, said before anyone relies on the count.** Those free dodges
  need inventory sitting ready. The inventory is visible in the data — 26 distinct actors, 19 of them
  acting more than once. **What it costs to hold is not measured here.** This work prices transaction
  fees and contract arithmetic. It does not price capital and it does not guess. **The count is a
  floor, never a census.**

## What it costs to run

Compute only. One host, one process, one stream, ordinary load.

**About 11.4 microseconds per message.** That is sized on the slowest of **twelve** recorded runs of
one identical input — 391,242,214 bytes, fingerprint verified before each run, 28,734,686 messages,
the same 958 every time. The twelve range from 46.568 s to **328.043 s**.

**And that 7× spread is not all machine load, which is a correction this section owes the reader.**
The twelve runs span several builds of the program written over a week, and **every run records the
input's fingerprint and none records the program's.** Two of those builds are proven identical
everywhere a decision is made — 34 differing lines, all of them text the program prints. The earlier
builds are not proven anything, and the slowest run came from one of them. So the figure is an
envelope over a set of builds rather than one program's cost, and it is sized on the slowest because
for anyone sizing hardware that is the safe direction to be wrong in.

Against the exchange's own message rate, on the same session:

| horizon | messages the feed delivers | what the check costs | ratio |
|---|---:|---:|---:|
| the whole session — 57,505 s, just under 16 hours | 28,734,686 | 328.0 s | **about 6 per 1,000 of the session** |
| the busiest 1 second | 63,447 | 724 ms | 0.72× |
| the busiest 100 ms | 26,635 | 304 ms | **3.0×** |
| the busiest 50 ms | 22,420 | 256 ms | **5.1×** |
| the busiest 1 ms | 1,336 | 15.3 ms | **15.3×** |
| the busiest 100 µs | 165 | 1.88 ms | **18.8×** |

**Read both halves together: it is cheap over a day and it cannot keep up inside a burst.** Over the
whole session the check costs about six thousandths of the time the session itself took. Inside the
busiest millisecond it runs roughly fifteen times slower than the market is talking, then catches up
in the quiet that follows. Someone wanting it live rather than a few seconds behind needs either a
buffer of a few hundred milliseconds, or enough parallel streams to cover the burst — sixteen at the
slowest rate observed, three at the fastest. The work splits cleanly by stock: the 321 per-stock runs
add back to the whole-morning run exactly, so the natural way to divide it is also an exact one.

On the blockchain side the shape is the opposite, because the unit of work is a block and the block
*is* the clock: **31.8 ms per block against a mean block interval of 13.586 seconds** — two
thousandths of the available time, about 427× headroom, sized again on the slower of two runs.

**One thing is not in these figures and is named rather than implied:** converting a text feed into
the binary form the detector reads was not separately timed. Anyone sizing such a venue has to
measure that step themselves.

## What this does not say

**It does not say anyone did anything.** On every exchange feed in this corpus, the party acting is
not on the wire. Counted over the orders each feed opens:

| feed | who placed the order |
|---|---|
| Nasdaq 2003 | none on **2,921,796 of 2,921,796** |
| Nasdaq BX 2019 | 49,470 of 10,629,593 carry one — **4 per 1,000** — across **two** distinct member identifiers in a whole session |
| NYSE | five spaces on **287,986 of 287,986** |
| NYSE American | none on 122,439 of 122,584; the 145 that carry one carry the *same* one |
| NYSE National | none on 114,236 of 114,236 |
| NYSE Texas | blank on 120,409 of 121,611; the only non-blank value appears on two test symbols |
| NYSE Arca | blank on 210,356 of 210,367 |
| Cboe Europe BXE | **no such field exists at all** |

So the sharpest question a surveillance check could ask — *is the same firm showing one side while
trading the other?* — cannot be computed on any exchange feed here. Not "no". **The feed does not
contain the answer.** This instrument cannot tell one firm quoting both sides from two firms each
quoting one. **Every stock-market number on this page is a statement about a book, never about a
party.**

**It does not say why an order was cancelled.** Where a reason field exists it carries exactly one
value on every record — 81,693 of 81,693 on NYSE, 104,109 of 104,109 on American, 113,147 of 113,147
on National, 119,762 of 119,762 on Texas — and on the European and Nasdaq feeds no such field exists.
A field with one value carries the same information as a field that is missing: none. A deliberate
withdrawal, an order expiring, and the venue itself pulling an order are one undifferentiated event.
Order type, how long an order was meant to last, whether it was displayed, and whether it tracked a
moving price are all absent everywhere. **No amount of reading these bytes turns a cancellation count
into a finding about intent** — and that absence is uniform across three exchange families, two
continents, two rulebooks and twenty-three years.

**It does not carry a shape in the data across into a point of law.** Measured against the pinned
legal texts — 38 quotations checked word for word, 0 not found, and three one-word mutations that
must be found nowhere, all correctly not found:

- A pattern in the mechanics of a market, by itself, establishes **no element** of an EU market abuse
  offence.
- Where the state of mind sits in that regime is measured rather than argued. Counting exact
  mental-state phrases: the effects limb most often cited scores **0**, the limb covering algorithmic
  and high-frequency trading scores **0**, and all seven indicators of the regulation's first annex
  score **0** — but **Article 12 as a whole scores 5**, and the Commission's delegated act naming the
  practices scores **24**. An effects-based framing does not remove intent from the European regime;
  **it relocates it**, one level down into the delegated act and into Article 12's own surrounding
  paragraphs. And a phrase count is not a legal test in the other direction either: the American
  provision most often cited scores **0**, and a mental element is nonetheless required.
- Comparing the EU original with the UK version brought across after Brexit, 3 of 6 provisions
  differ, and the difference in the algorithmic limb is the phrase *", including any cancellation or
  modification thereof,"*. The EU text names cancellation explicitly there. That is a fact about the
  text and nothing more.
- Of the nine indicators in that annex, **none is computable from a single European venue feed** under
  the strict reading, where the denominator the text names is the instrument's own market-wide
  activity. Under a venue-local reading, three become computable. That gap measures something real:
  **Europe has no consolidated tape**, so the strict reading has nowhere to be computed from.

**It says nothing about what any firm actually reported to a regulator, and it does not replace the
audit trail.** The two records hold different things and neither is sufficient. The audit trail holds
*who*: the customer, the order's identity across firms, the broker on each side of a route. **The
exchange feed holds none of that.** What the exchange feed holds is *order* — its sequence is the
position in the stream rather than a comparison of clocks, and on a complete Nasdaq BX session that
sequence never goes backwards once, across 28,734,686 messages.

That matters because clocks have legal slack. The rule that created the audit trail requires
timestamps at least to the millisecond and names **no clock tolerance at all**. The tolerance lives in
two technical specifications, at 100 microseconds for exchanges and 50 milliseconds for
broker-dealers, and both say it is a *total* error budget rather than what is left over after
correction. Two compliant reporters may sit at opposite edges, so the gap between them adds up — up to
200 µs between two exchanges, 50.1 ms between an exchange and a broker, 100 ms between two brokers.

Measured against that complete session, **447 of every 1,000 adjacent messages arrive within one
exchange's tolerance of each other, and 998 of every 1,000 within one broker-dealer's.** The longest
unbroken run of messages that the feed puts in order and a one-second clock comparison does not is
**63,447** — which is also, on the same session, the count of messages in the busiest single second.
One venue on one day, and therefore a floor: every other venue's events land in the same windows and
can only raise it.

**None of that is an observation about anybody's compliance.** No audit-trail record was read — that
is ABSENT here. The widths above are what the specifications permit, stated as such, and the actual
clock error at any reporter is **NOT_KNOWN from these artefacts.**

## The questions to ask anyone selling a surveillance number

One line, and it is the whole page compressed:

> **What does your indicator score on an ordinary session with nobody doing anything — and on which
> venue, which session, which window from when to when, which companies, and over how many orders
> examined?**

A vendor who cannot answer has not measured it. A vendor who answers with a single number and no
scope has measured something that moves, on our data, by more than whatever effect they are selling.

Three follow-ups that each cost this study a correction, so they are cheap for you:

- **"Show me the control arm's two absolute counts, not the ratio."** A ratio of 0 against 0 and a
  ratio of 68 against 152 look the same in a ratio column and are completely different findings. On
  this page one of them is an empty window and the other points backwards.
- **"If you converted the feed, which conversion?"** On NYSE, reading the modify record as a partial
  cancellation gives 82,132 orders that ended, at 994 per 1,000. Reading it as a replacement — a
  defensible alternative on the same bytes — gives 136,583 at 996: **a 66% larger denominator from a
  choice, not from the market.** Ours is not a preference, it is a measurement: the modify record
  never changes price (54,443 of 54,443), never changes side (54,443 of 54,443), always shrinks
  (54,443 of 54,443) and never follows a partial trade (0 of them). A rate from a converted feed
  carries the conversion's name or it carries nothing.
- **"What does it report on a day whose archive is empty?"** If the answer is a number, the product
  will one day report a calm market because it read nothing.

## What would prove us wrong

Each of these is an observation someone could make, not a wish, and each is reachable with data of
the kind already used here.

**A complete session reading materially below the band.** The claim is 935 … 998 per 1,000 on
ordinary flow. A *complete* session — not a truncated head — on any order-by-order feed returning,
say, 700 per 1,000 over a denominator large enough to mean something refutes the band as stated.
**Already dented by our own measurement at the level of a single stock:** on one truncated New York
morning `TGT` reads 765 over the 405 of its orders that reached an end, and 11 of the 25 stocks with
enough orders to count sit below 958. The band survives at the session level and is already false at
the level of one stock, which is exactly why every number here carries its stock population in the
same sentence.

**A feed whose cancel-reason field is not constant.** This is the falsification most worth having. If
a feed carried a populated reason code and the 99x per 1,000 turned out to be dominated by expiries
and venue-initiated kills rather than deliberate withdrawals, the denominator would mean something
different from what it means today. That refutes the *interpretation* rather than the arithmetic.

**A composite that clears its control on every venue.** Already refuted by our own measurement: 447
on NYSE Texas is below its control, 8 of 15 defined European cells invert, and NYSE is 0 against 0.
The surviving claim is the narrow one — that it carries information on some venues and announces when
it does not.

**A venue whose stream order is not total.** Part of the argument here rests on the feed carrying an
ordering that a clock comparison cannot reconstruct. Checked, not assumed: **0 ordering violations
across 28,734,686 messages** on Nasdaq BX. And that check needed two arms and two mechanisms, because
a *wrong* reading position for the timestamp also passes the ordering test — one wrong offset fails
only 10 times in 2.3 million messages, and decodes to 49.6 hours past midnight. Ordering alone admits
a wrong reading.

**On the blockchain half: a set of these in-block triples that mostly turns out to take nothing.** 108
of the 126 triples that satisfy the positional shape also take something — 857 per 1,000. A different
block window returning, say, 200 per 1,000 would say the conditions describe an ordinary trading shape
and the taking test is doing all the work. That is the cheapest falsification available and needs only
another window of blocks.

**A third independent implementation returning a different set.** Two kernels sharing no code already
return the same 108 of 108. A third, written from the published definition alone, returning a
different membership would refute the claim that the geometry is exactly decidable from public data.
Two implementations disagreeing has already caught real defects here, so this is not a formality.

**And the bound this work cannot close, repeated here because it belongs in this list.** Two of the
blockchain tests can be dodged for nothing by someone holding inventory, and **what that inventory
costs to hold is not measured here.** Measuring it is a defined piece of work, and until somebody does
it the count stands as a floor rather than a census.

## Where this study's own drafts were wrong

Kept on the page rather than in a changelog, because the corrections are the argument for the method.
An adversarial pass against the measurement files caught eleven figures or framings in an earlier
draft, a second pass caught six more — including one inside the table of corrections itself — and a
third pass, editing this page for a general reader, caught four more.

**The eleven, in short:** a 16 MiB head reported without saying it was a head; five truncated windows
collapsed into one band; "994 against 0" quoted as proof the composite discriminates when that cell's
control is also 0; a threshold asserted that the instrument does not use; NYSE Texas's floor of 186
quoted without `CTEST` beside it; "85 of 300 symbols" on a median denominator of nine orders; BX
against PSX called unarguable when it is tangled on the wire; a matched-phase band that silently
excluded the one point outside it; and three timing figures that appeared in no measurement file at
all.

**The six found next, and the first is the worst:**

1. **A threshold was reintroduced under the instrument's name.** The correction table said "the
   instrument's own rule is 1,300, not 1,000" and marked four venues *indistinguishable from control*
   on that authority. **The instrument had already withdrawn that rule**, in its own source and in a
   self-test arm that proves the same measurement flips when the constant moves. One replaced a
   fabricated threshold with another, inside the table of corrections — the exact failure the
   procedure exists to prevent, committed in the place least likely to be re-checked.
2. **The compute figure was sized on a run that was not the slowest.** The draft said "slowest of 4
   runs, 249.483 s". **Twelve** runs of that identical input are on disk and the slowest is
   **328.043 s**. Every downstream ratio moves: the busiest 100 ms from 2.3× to 3.0×, the busiest
   millisecond from 11.6× to 15.3×, the busiest 100 µs from 14.3× to 18.8×.
3. **A correction fabricated an absence.** The draft said an earlier figure of 110.631 s "appears in
   no file". It is in a run log, on a verified input. The correct correction is that it was not the
   slowest — not that it did not exist. **Claiming a number is unsourced is itself a claim, and it
   needs the same evidence as any other.**
4. **"Six symbols at exactly 1,000" is seven.** Recomputed from the per-symbol output: CTOS, GBTG,
   IFF, MSI, POST, PSO, TS.
5. **"8 of 19 defined cells below control" on the European book is 8 of 15.** Nineteen is the count of
   cells where the composite fires at all; fifteen is the count where a ratio is defined, because four
   of the nineteen have an empty control. The finding is unchanged and the denominator was wrong.
6. **The faster of two runs was published in the one section whose rule is to publish the slower.** One
   converted feed was printed at 1.969 s as though it were the only run; a second run of the same
   427,226 messages took 2.637 s.

**The four found in the plain-English pass:**

7. **The twelve compute runs are not twelve runs of one program, and correction 2 read as though they
   were.** They span several builds written over a week; the output files record the input's
   fingerprint and never the program's. Two builds are proven identical on the decision path — 34
   differing lines, all of them printed text. The earlier ones are not, and the slowest run came from
   one of them. The figure stands at 11.4 microseconds because slowest is the safe direction for
   anyone sizing hardware, and it is now labelled as an envelope over a set of builds. The chain
   figure in the same section had already been corrected once for comparing two different programs.
   **The same defect can be repaired on one line and committed on the next.**
8. **"Two of the five blockchain conditions are evadable for free" names the wrong two.** The primary
   measurement says in its own words that the profit test **is not one of the five conditions** — it is
   the filter that cuts 126 candidates to 108. One condition is free to dodge, and the separate profit
   test is free to dodge. That is a smaller and truer claim than the one carried forward from the
   summary document.
9. **Two of the five priced dodges do not attack the check on this page.** The decoy trade and the
   widened hold defeat a *live* watcher's adjacency and span requirements. The published check has
   neither. They are priced because a reader reaches for them, and that is now said where they are
   priced.
10. **A completeness claim about reproduction was refused by the tree.** An earlier draft said the two
    known cases are re-run "on every venue arm in this study". They are re-run in three of the venue
    directories. The others carry controls of their own kinds — a positive control on real exchange
    bytes, transcode arms with known ground truth, a published-law mirror. Every arm has controls;
    they are not all the same control, and saying so was an overclaim.

A document that publishes an error inside its own error table is making the argument for the rest of
it. This section stays.

---

### Evidence, graded

| what | grade | where it comes from |
|---|---|---|
| The six new venue-session rates, their counts, windows and censored columns | **Measured** | one unchanged binary per venue: `nyse/predicate/run_mapA.txt`, `arca-msx/msx.arca.real.txt`, `texas-phantom/run_primary.out`, `amex-phantom/run.PRIMARY.out`, `national-msx/msx.national.real.txt`, `cboe_eu_phantom/out/ORAp.M3.txt`, 2026-09-08 |
| The three already-published rates — Nasdaq 2003 · BX 2019 · PSX 2019 | **Published, cited** | [What is taken from an ordinary swap](The-Detector-That-Flags-The-Whole-Market.md); PSX is another lane's and is marked † |
| Per-stock band 765 … 1,000 over the 25 stocks with ≥100 orders ended, 7 of them at exactly 1,000 — on a 2 h 56 m truncated morning, 714 per 1,000 censored | **Measured** | `nyse/predicate/per_symbol_out.txt`, 321 runs summing to the whole-morning run, `CLOSURE EXACT` |
| NYSE Texas floor of 186 being `CTEST`, the venue's test symbol | **Measured** | `texas-phantom/run_primary.out` — the real-name floor is **NOT MEASURED** |
| Composite counts and controls on all nine sessions | **Measured** | the same six run files; every current build prints `RATIO_PUBLISHED_NO_THRESHOLD` |
| The withdrawn threshold, and the self-test arm that shows the same pair flipping | **Measured** | `market-shear-exact.swift`, arm `d3_retired_binary_was_threshold_dependent` |
| Consolidated tape: 466 keys swept, zero passing both halves | **Measured** | tape run; positive control on 536,870,912 real BX bytes, 1,000/1,000 |
| ArcaBook 2015-06-18 empty at source, 20 of 20 bytes accounted, timestamp reproducing the fingerprint | **Measured** | `arca2015/` — the `.MD5` sidecar's content was not read and is **NOT_KNOWN** |
| IEX DEEP carrying no order identity | **Published, cited** | already on the family page; repeated here for the three-way contrast |
| Compute: twelve runs of one input, 46.568 s … 328.043 s, sized on the slowest | **Measured, with a stated limit** | twelve run logs, identical input fingerprint, identical 958 every time — and **no run log records which build produced it**; the figure is an envelope over several builds, two of which are proven identical on the decision path |
| The composite refuting the earlier page's own published sentence | **Measured** | the six new run files against `The-Detector-That-Flags-The-Whole-Market.md` |
| The priced evasions, which two are free, and which two attack only the live watcher | **Measured** | adversary pricing, 56 arms passed / 0 failed, refusing unless the compiled law reproduces the published 126 / 108 partition |
| Adjacent-message gaps against the audit trail's clock tolerances — 447 and 998 per 1,000, longest run 63,447 | **Measured** | one complete Nasdaq BX session, 28,734,685 adjacent pairs; a floor, since other venues' events land in the same windows |
| EU and UK text measurements, 38 quotations verbatim | **Measured** | `eu_regime/` against pinned texts, with three mutation controls correctly silent |
| Annex I computability, 0 of 9 strict and 3 of 9 venue-local | **Measured** | `eu_regime/indicators.out`, verdict `DISCRIMINATES over 18 cells` |
| Audit-trail clock tolerances | **Reported, from the specifications** | worst case as written; actual clock error at any reporter is **NOT_KNOWN** |
| What any firm actually reported to a regulator | **Absent** | no audit-trail record was read |
| The real-name floor on NYSE Texas; the session totals behind the five truncated heads | **Not known** | stated as not known, never estimated |
| What holding inventory costs the two free dodges | **Not measured here** | named rather than guessed |
| "A cancellation-keyed indicator is a census, not a detector" | **Argument** | reasoning from the nine measured sessions |

### Reproduce

Every corpus here is publicly fetchable, and each is large, so the corpora are fetched rather than
committed. No account, no key, no agreement, and no floating point anywhere on the decision path.

**One law, one home.** All nine sessions were measured by the same detector, with the per-venue work
confined to converting a feed's vocabulary into the wire the detector already reads. The conversion
carries no test, no threshold, no rate and no verdict.

```
the decision path        market-shear-exact.swift   152,085 B
                         619637839ee57b2102c409c6f7487fcf993fe771c48c5c40dfdc66f31e6d9fe5

pinned inputs            20190730.BX_ITCH_50.gz     391,242,214 B
                         a0a057010cc5172cfaf2d8a7b4d5f133557fa47b3a5837fcf985b6e5533e50eb
                         S010303-v2.zip              58,907,174 B
                         eb67a239cf09b7de1843f6b0ede3c473616cc5cac777b293bbe15608bf51794d
                         BXE_2020-09-01.ORAp.csv      5,995,847 B
                         79740f59f48b63ab87c98f0bc91294a390afeab021c6ef2d5f00ca3602757894
                         nyse_exact.raw              32,374,680 B
                         35ad00eb382ec3cf4c80fec7fa75e27f35d5a719e3a6fd5b2538f9012cb92c6a
```

```
xcrun swiftc -O -swift-version 5 market-shear-exact.swift -o msx && ./msx <stream.gz>
```

**Two known cases, and an honest note about where they run.** Nasdaq BX 2019 must return 958 and
Nasdaq 2003 must return 935. That pair is re-run on the same pinned bytes from three of the venue
directories. The others carry controls of their own kinds rather than the same pair — a positive
control on 536 MB of real exchange bytes, transcode arms with known ground truth landing at 1,000, 0
and 300, and a mirror of the published law. Every arm has a control. They are not all the same
control, and an earlier draft said otherwise.

**Every exit path prints the reference figures, refusals included.** A program that exits early while
printing nothing passes every check that was meant to grade it, because there is nothing left to
grade.

**The table on this page is itself checkable, and checking it is a second program.** A published
table is a claim that a set of numbers are consistent with one another, and nobody checks that claim
by eye — on this study an adversarial pass found seventeen figures that were wrong, two of them
inside the table of corrections. `market-shear-cross-venue.swift` carries the counts the detector
printed on all nine sessions, with the file each was read out of, and re-derives every rate from them
in whole numbers: the base rate, the traded rate, and the censored rate, plus a closure check that
orders opened equals orders ended plus orders still resting. It measures no market, reads no file,
takes no argument and applies no threshold. Eight control arms make it able to fail — among them that
flooring and rounding genuinely disagree on Nasdaq BX, 958 against 959, so the choice is stated
rather than assumed. Move any published count by one and it prints `LEDGER_DOES_NOT_CLOSE`, names the
row, and still prints the whole ledger on the way out.

```
xcrun swiftc -O -swift-version 5 market-shear-cross-venue.swift -o mscv && ./mscv
                         -> LEDGER_CLOSES_EXACT, 8 of 8 control arms fired
```

### Related

- [What is taken from an ordinary swap, and how to find out if it was taken from
  you](The-Detector-That-Flags-The-Whole-Market.md) — the family page this study extends. Three of the
  nine sessions here, and the entire blockchain arm, are its measurements. It also named these venues
  as unread, and this study is that page's own stated next step, executed.
- [Study 41 — Fifty years of solving the wrong problem](Study-41-What-The-Ordering-Cost.md) — the same
  discipline about instruments, on a measurement that caught itself lying.
- [Shear studies index](Shear-Studies-Index.md) · [Ontology](Ontology.md)

### Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone can
inspect it and re-derive every figure. That visibility grants no rights. The repository carries no
LICENSE, which under default copyright means **all rights are reserved**. Any other use requires a
separate written licensing agreement with the authors.

---

*Detection is not intent. Nothing on this page names or implies wrongdoing by any identifiable
participant, and on every feed measured that is a property of the bytes rather than a policy: the
party acting is absent or single-valued on all of them. Cancelling orders is ordinary market making.
This is a statement about arithmetic performed on public exchange feeds, and about the structural
integrity of an instrument.*
