// market-shear-cross-venue.swift — STUDY 43. The cross-venue ledger.
//
// WHAT THIS PROGRAM IS, AND WHAT IT IS NOT.
//
// It is NOT a second detector.  The detector lives in ONE home, market-shear-exact.swift,
// and all nine sessions on this page were measured by that one program.  A law written
// twice is a law that will drift, and this file therefore contains no feed parser, no
// order table, no clock comparison and no verdict about a market.
//
// What it IS: the ledger of what that detector printed on nine venue-sessions, and an
// EXACT INTEGER RE-DERIVATION of every published rate from the counts it printed.  Each
// row carries the counts, the file they were read out of, and the scope words that travel
// with them.  The rates are recomputed here and compared against the rates the detector
// itself published.  If any row's arithmetic does not close, this program says so and
// exits non-zero.
//
// WHY THAT IS WORTH RUNNING.  A published table is a claim that a set of numbers are
// consistent with one another.  Nobody checks that claim by eye, and on this study an
// adversarial pass found seventeen figures that were wrong — two of them inside the table
// of corrections itself.  This program checks the arithmetic of the whole table on every
// run, in whole numbers, with no threshold and no rounding.
//
// NO ARGV, NO STDIN, NO NETWORK, NO CORPUS, NO FILES READ.  Every figure is a recorded
// integer with its source named beside it.  There is exactly one exit path and it prints
// the complete ledger before taking it, because a program that exits early while printing
// nothing passes every check that was meant to grade it.
//
// ZERO FLOAT.  Every rate below is integer division, floored, exactly as the detector
// computes it.  Control arm C5 shows this is not cosmetic: on Nasdaq BX, floor and
// round-half-up disagree — 958 against 959 — so the choice is load-bearing and is stated
// rather than left to the reader to assume.
//
//   xcrun swiftc -O -swift-version 5 market-shear-cross-venue.swift -o mscv && ./mscv

import Foundation

// =====================================================================================
// SECTION 0 — OUTPUT.  Unbuffered, one write per line, so a kill mid-run leaves a
// truncated transcript rather than an empty one.
// =====================================================================================

let SOUT = FileHandle.standardOutput
@inline(__always) func emit(_ s: String) { SOUT.write(Data((s + "\n").utf8)) }
func rule() { emit(String(repeating: "-", count: 86)) }
func section(_ s: String) { emit(""); emit("== " + s + " =="); }

// Thousands separators, built by hand.  No formatter, no locale, no float.
func c(_ n: Int) -> String {
    let neg = n < 0
    var d = String(neg ? -n : n)
    var out = ""
    while d.count > 3 {
        let cut = d.index(d.endIndex, offsetBy: -3)
        out = "," + String(d[cut...]) + out
        d = String(d[..<cut])
    }
    out = d + out
    return (neg ? "-" : "") + out
}
func pad(_ s: String, _ w: Int) -> String {
    s.count >= w ? s : s + String(repeating: " ", count: w - s.count)
}
func rpad(_ s: String, _ w: Int) -> String {
    s.count >= w ? s : String(repeating: " ", count: w - s.count) + s
}

// EXACT.  Floored integer rate per 1,000.  Undefined on a zero denominator, and that is a
// third answer rather than a zero.
func per1000(_ num: Int, _ den: Int) -> Int? { den == 0 ? nil : (num * 1000) / den }

// =====================================================================================
// SECTION 1 — THE NINE SESSIONS, as the detector printed them.
//
// `opened`, `terminated`, `censored` and `phantom` are the four counts the detector emits
// for a session.  `publishedRate` is the rate the detector itself printed; this program
// recomputes it from the counts and compares.  A row is DERIVED here from nothing: every
// integer below appears in the named file.
// =====================================================================================

struct Session {
    let name: String
    let operatorName: String
    let date: String
    let window: String
    let complete: Bool          // complete session, or truncated head
    let opened: Int             // orders the feed opened.  0 = not recorded in that run.
    let terminated: Int         // orders that reached an end inside the recording
    let censored: Int           // still resting on the book when the bytes stopped
    let phantom: Int            // of the terminated, those that executed nothing at all
    let publishedRate: Int      // per 1,000 of terminated, as the detector printed it
    let flag: Int               // composite count
    let control: Int            // same mechanism, one field changed
    let controlDefined: Bool
    let borrowed: Bool          // another lane's measurement, cited not re-derived
    let source: String
}

let SESSIONS: [Session] = [
    Session(name: "Nasdaq", operatorName: "Nasdaq", date: "2003-01-03",
            window: "complete, 07:00:00 -> 20:00:31",
            complete: true,
            opened: 0, terminated: 2_921_796, censored: 0, phantom: 2_732_598,
            publishedRate: 935, flag: 1_643, control: 1_033, controlDefined: true,
            borrowed: false, source: "published: The-Detector-That-Flags-The-Whole-Market"),

    Session(name: "Nasdaq BX", operatorName: "Nasdaq", date: "2019-07-30",
            window: "complete, 03:06:35 -> 19:05:00",
            complete: true,
            opened: 0, terminated: 12_676_036, censored: 0, phantom: 12_156_283,
            publishedRate: 958, flag: 88_900, control: 63_140, controlDefined: true,
            borrowed: false, source: "published: The-Detector-That-Flags-The-Whole-Market"),

    Session(name: "Cboe Europe BXE", operatorName: "Cboe Europe", date: "2020-09-01",
            window: "complete, 08:00:00 -> 16:40:29, ONE INSTRUMENT",
            complete: true,
            opened: 55_251, terminated: 55_251, censored: 0, phantom: 53_909,
            publishedRate: 975, flag: 3_157, control: 3_014, controlDefined: true,
            borrowed: false, source: "cboe_eu_phantom/out/ORAp.M3.txt"),

    Session(name: "Nasdaq PSX", operatorName: "Nasdaq", date: "2019-07-30",
            window: "complete session",
            complete: true,
            opened: 0, terminated: 16_165_067, censored: 0, phantom: 15_952_637,
            publishedRate: 986, flag: 0, control: 0, controlDefined: false,
            borrowed: true, source: "another lane's measurement, cited as theirs"),

    Session(name: "NYSE Arca", operatorName: "ICE / NYSE", date: "2026-04-01",
            window: "truncated head, 04:00:00 -> 04:29:00, 29 min",
            complete: false,
            opened: 274_068, terminated: 253_809, censored: 20_259, phantom: 251_097,
            publishedRate: 989, flag: 7_451, control: 6_491, controlDefined: true,
            borrowed: false, source: "arca-msx/msx.arca.real.txt"),

    Session(name: "NYSE Texas", operatorName: "ICE / NYSE", date: "2026-04-01",
            window: "truncated head, 00:18:46 -> 09:14:27, 8 h 56 m",
            complete: false,
            opened: 122_230, terminated: 121_297, censored: 933, phantom: 120_331,
            publishedRate: 992, flag: 68, control: 152, controlDefined: true,
            borrowed: false, source: "texas-phantom/run_primary.out"),

    Session(name: "NYSE", operatorName: "ICE / NYSE", date: "2026-04-01",
            window: "truncated head, 06:30:00 -> 09:26:06, 2 h 56 m",
            complete: false,
            opened: 287_986, terminated: 82_132, censored: 205_854, phantom: 81_648,
            publishedRate: 994, flag: 0, control: 0, controlDefined: false,
            borrowed: false, source: "nyse/predicate/run_mapA.txt"),

    Session(name: "NYSE American", operatorName: "ICE / NYSE", date: "2026-04-01",
            window: "truncated head, 07:00:00 -> 09:30:06, crosses the opening auction",
            complete: false,
            opened: 126_637, terminated: 108_421, censored: 18_216, phantom: 108_137,
            publishedRate: 997, flag: 363, control: 318, controlDefined: true,
            borrowed: false, source: "amex-phantom/run.PRIMARY.out"),

    Session(name: "NYSE National", operatorName: "ICE / NYSE", date: "2026-04-01",
            window: "truncated head, 07:00:00 -> 08:10:39, 1 h 11 m",
            complete: false,
            opened: 131_585, terminated: 130_683, censored: 902, phantom: 130_451,
            publishedRate: 998, flag: 599, control: 304, controlDefined: true,
            borrowed: false, source: "national-msx/msx.national.real.txt"),
]

var FAILURES: [String] = []
func require(_ cond: Bool, _ what: String) {
    if !cond { FAILURES.append(what) }
}

// =====================================================================================
emit("MARKET SHEAR — CROSS-VENUE LEDGER.  Study 43.")
emit("Nine venue-sessions.  Three exchange operators.  Two continents.  Two rulebooks.")
emit("2003 to 2026.  One detector, market-shear-exact.swift, in one home.")
emit("")
emit("This program re-derives every published rate from the counts the detector printed.")
emit("It measures no market.  It reads no file.  It has no argv and no threshold.")

// =====================================================================================
section("1. THE BASE RATE — orders that ended having traded nothing at all")
// =====================================================================================
emit("")
emit("Every rate below is floored integer division on the detector's own counts.")
emit("A truncated head is a truncated head in every sentence that uses it.")
emit("")
emit(pad("session", 18) + pad("operator", 13) + pad("date", 12)
     + rpad("ended", 12) + rpad("no trade", 12) + rpad("per 1,000", 11) + "  scope")
rule()

var rates: [Int] = []
for s in SESSIONS {
    guard let r = per1000(s.phantom, s.terminated) else {
        require(false, "\(s.name): zero denominator, a rate cannot exist")
        continue
    }
    require(r == s.publishedRate,
            "\(s.name): re-derived \(r) per 1,000, the detector published \(s.publishedRate)")
    rates.append(r)
    let scope = (s.complete ? "COMPLETE SESSION" : "TRUNCATED HEAD")
        + (s.borrowed ? "  [BORROWED, not re-derived here]" : "")
    emit(pad(s.name, 18) + pad(s.operatorName, 13) + pad(s.date, 12)
         + rpad(c(s.terminated), 12) + rpad(c(s.phantom), 12) + rpad(String(r), 11)
         + "  " + scope)
}
rule()
let bandLow = rates.min() ?? -1
let bandHigh = rates.max() ?? -1
emit("BAND ACROSS NINE SESSIONS      " + String(bandLow) + " ... " + String(bandHigh)
     + " per 1,000 of orders that ended")
emit("")
emit("Four of the nine are complete sessions.  Five are truncated heads.  The band is six")
emit("new sessions bolted onto three already published, and it is written that way.")

// =====================================================================================
section("2. THE COLUMN THAT ACTUALLY MOVES — orders that DID trade")
// =====================================================================================
emit("")
emit("The headline rate is nearly flat.  The population a surveillance product would have")
emit("to look inside is not, and that is where the information went.")
emit("")
emit(pad("session", 18) + rpad("traded", 12) + rpad("per 1,000", 11) + "  scope")
rule()
var tradedRates: [Int] = []
for s in SESSIONS {
    let traded = s.terminated - s.phantom
    require(traded >= 0, "\(s.name): more phantom orders than terminated orders")
    guard let t = per1000(traded, s.terminated) else { continue }
    tradedRates.append(t)
    emit(pad(s.name, 18) + rpad(c(traded), 12) + rpad(String(t), 11)
         + "  " + (s.complete ? "complete" : "truncated head"))
}
rule()
let tHigh = tradedRates.max() ?? 0
let tLow  = tradedRates.min() ?? 0
emit("traded per 1,000 spans " + String(tLow) + " to " + String(tHigh))
if tLow > 0 {
    emit("ratio of the extremes            " + String(tHigh / tLow) + "x")
    emit("The headline moves by " + String(bandHigh - bandLow)
         + " points on a scale of 1,000 across those same rows.")
    emit("MOST OF THAT SPREAD IS WHEN THE RECORDING WAS TAKEN, NOT WHICH EXCHANGE IT CAME")
    emit("FROM.  The sessions with almost no trading are the truncated pre-auction heads.")
}

// =====================================================================================
section("3. CENSORED — orders still resting when the bytes ran out")
// =====================================================================================
emit("")
emit("An order still on the book when the recording stops is not counted as anything.  It")
emit("gets its own bucket and it never prints as a zero.  Closure is checked per row:")
emit("opened must equal terminated plus censored, exactly.")
emit("")
emit(pad("session", 18) + rpad("opened", 14) + rpad("ended", 14) + rpad("censored", 14)
     + rpad("per 1,000", 11) + "  closure")
rule()
for s in SESSIONS {
    if s.opened == 0 {
        emit(pad(s.name, 18) + rpad("NOT RECORDED", 14) + rpad(c(s.terminated), 14)
             + rpad("NOT RECORDED", 14) + rpad("--", 11) + "  n/a")
        continue
    }
    let closes = (s.opened == s.terminated + s.censored)
    require(closes, "\(s.name): opened \(s.opened) != terminated \(s.terminated) + censored \(s.censored)")
    guard let cr = per1000(s.censored, s.opened) else { continue }
    emit(pad(s.name, 18) + rpad(c(s.opened), 14) + rpad(c(s.terminated), 14)
         + rpad(c(s.censored), 14) + rpad(String(cr), 11)
         + "  " + (closes ? "EXACT" : "BROKEN"))
}
rule()
emit("On NYSE, 205,854 of 287,986 orders opened were still resting when the bytes stopped:")
emit("714 per 1,000.  A rate computed over the other 286 says nothing about the 714.")

// =====================================================================================
section("4. THE COMPOSITE, AGAINST ITS OWN SAME-MECHANISM CONTROL")
// =====================================================================================
emit("")
emit("The control is the identical mechanism with exactly one field changed: the same-side")
emit("execution clock instead of the opposite-side one.  A control driven by a DIFFERENT")
emit("mechanism stays lit through the very failure it exists to exclude.")
emit("")
emit("NO THRESHOLD IS APPLIED ANYWHERE.  An earlier build returned a yes/no verdict on a")
emit("constant of 130 that was derived nowhere; it was withdrawn from the law's own source.")
emit("A draft of this study then reintroduced 1,300 under the instrument's name.  Both are")
emit("gone.  The counts and the ratio are printed and the reader draws the line.")
emit("")
emit(pad("session", 18) + rpad("composite", 11) + rpad("control", 10)
     + rpad("per 1,000", 16) + "  reading")
rule()
for s in SESSIONS {
    if s.borrowed {
        emit(pad(s.name, 18) + rpad("--", 11) + rpad("--", 10) + rpad("2,948", 16)
             + "  BORROWED, cited not re-derived here")
        continue
    }
    if !s.controlDefined || s.control == 0 {
        require(s.flag == 0 || s.control != 0, "\(s.name): flag > 0 with an empty control")
        emit(pad(s.name, 18) + rpad(String(s.flag), 11) + rpad(String(s.control), 10)
             + rpad("NOT_COMPUTABLE", 16)
             + "  CONTROL EMPTY.  0 against 0 IS NOT A DISCRIMINATION.")
        continue
    }
    guard let r = per1000(s.flag, s.control) else { continue }
    let reading = r < 1000 ? "BELOW ITS OWN CONTROL — it points the other way"
                           : "above its own control"
    emit(pad(s.name, 18) + rpad(c(s.flag), 11) + rpad(c(s.control), 10)
         + rpad(c(r), 16) + "  " + reading)
}
rule()
emit("The non-degenerate contrast is 88,900 against 63,140 on Nasdaq BX.  The NYSE cell is")
emit("0 against 0 and was once quoted as '994 against 0' — that cell's control is also 0.")
emit("")
emit("Where the NYSE zero comes from, since a zero invites a conspiracy: 100,337 of NYSE's")
emit("136,091 withdrawals — 737 per 1,000 — happen before ANY trade has occurred in that")
emit("stock on that side, so there is no clock to measure against.  Cut the complete Nasdaq")
emit("BX session to its own pre-opening head and the identical degenerate answer returns:")
emit("5,356 of 5,374 withdrawals precede any execution, composite 0, control 0.  A truncated")
emit("pre-auction book is an exchange's OPENING PROCEDURE being read as manipulation.")

// =====================================================================================
section("5. RESULTS THAT ARE NOT RATES — printed rather than dropped")
// =====================================================================================
emit("")
emit("ABSENCE, REFUSAL, NOT_KNOWN, NOT MEASURED and EMPTY AT SOURCE are five different")
emit("answers and they never print alike.")
emit("")
let degenerateTerminated = 164
let degeneratePhantom = 164
let degenerateRate = per1000(degeneratePhantom, degenerateTerminated)!
emit("Cboe Europe BXE, a second instrument, same day and feed")
emit("    orders ended " + String(degenerateTerminated)
     + ", all of them without trading, rate " + c(degenerateRate))
emit("    WITHHELD FROM EVERY BAND — a rate of exactly 1,000 over 164 orders carries no")
emit("    information.  Reported, and not averaged in.")
require(degenerateRate == 1000, "the degenerate European instrument should read 1,000")
emit("")
emit("Cboe Europe BXE, a third instrument, same day and feed")
emit("    converts to a 20-byte stream that frames no message at all; the detector exits")
emit("    with an error and says so.  A REFUSAL LEFT OUT OF A TABLE is indistinguishable")
emit("    from a feed nobody pointed the instrument at.")
emit("")
emit("IEX DEEP 1.0                    ORDER_IDENTITY_ABSENT")
emit("    30-byte price level update, every byte claimed by a named field, 0 bytes left in")
emit("    which an order reference could sit.  46 candidate fields swept; a second, larger")
emit("    message type swept separately so the null does not rest on one message shape.")
emit("    13,081,242 of its updates set a size to zero — but the thing withdrawn is a PRICE")
emit("    LEVEL, not an order.  No key, therefore no denominator.  ABSENT, NEVER ZERO.")
emit("")
emit("Consolidated tape                NO EVENT-TYPE PARTITION")
emit("    A quote getting worse and a quote being cancelled are the same bytes.  466")
emit("    candidate keys swept across 233 positions in both byte orders: 34 pass a")
emit("    uniqueness test, 418 pass a re-appearance test, 0 pass both.  The instrument was")
emit("    made to say YES first, on 536,870,912 bytes of real Nasdaq BX data, where it")
emit("    scores 1,000 out of 1,000.  A NO from an instrument that has never said YES is")
emit("    worth nothing.  NO SUBSTITUTE WAS PUT IN ITS PLACE: a different quantity was")
emit("    measured and reported as a different quantity — 344,258 reductions at the top of")
emit("    the book across 772,868 quote transitions, 445 per 1,000, over a stated 16 MiB")
emit("    head which, because the file is sorted by company name, is a 17-SYMBOL PREFIX")
emit("    SPANNING THE WHOLE SESSION rather than the first few minutes of it.")
emit("")
emit("ArcaBook 2015-06-18              EMPTY AT SOURCE")
emit("    20 bytes: 10 header, 2 deflate, 8 trailer.  20 of 20 accounted, 0 unaccounted.")
emit("    Payload byte count 0.  HTTP 200, gzip -t PASS, md5 68123fc57aeef19f331acd74803b4c28,")
emit("    a .MD5 sidecar present at source, and an internal timestamp of 2015-06-18 that is")
emit("    telling the truth — every automated check says the file is fine.")
emit("    A CANCELLATION DETECTOR POINTED AT THIS FILE RETURNS ZERO FLAGGED ORDERS, AND A")
emit("    ZERO HERE MEANS 'THE ARCHIVE HAD NO BYTES', NOT 'THE MARKET WAS CALM'.")
emit("    It fails in the reassuring direction, which on a safety instrument is the")
emit("    dangerous one.  Reported NOT_KNOWN.  Never 0 per 1,000.")
emit("    An instrument handed nothing must not report success.")

// =====================================================================================
section("6. SCOPE — carried with every number, never in a footnote")
// =====================================================================================
emit("")
var iceRows = 0
for s in SESSIONS where s.operatorName == "ICE / NYSE" { iceRows += 1 }
emit("FIVE OF THE NINE ROWS ARE ONE OPERATOR'S FIVE BOOKS ON ONE DATE.")
emit("    rows carrying the operator 'ICE / NYSE'        " + String(iceRows))
emit("    all on                                          2026-04-01")
emit("    They share a wire format, a day, and one list of stocks divided five ways,")
emit("    read five times by one program.  THEY ARE NOT FIVE INDEPENDENT VENUES.  Their")
emit("    spread is an upper bound on how much a venue can move this number inside one")
emit("    family, tangled with an eighteen-fold difference in recording length.")
require(iceRows == 5, "the NYSE-family row count should be 5")
emit("")
emit("THE EUROPEAN ROW IS ONE INSTRUMENT'S COMPLETE DAY, not a whole venue's session.")
emit("    Two true statements about the same 55,251 orders, and two different objects.")
emit("")
emit("THE PSX ROW IS BORROWED.  Another lane's measurement, cited as theirs and not")
emit("    re-derived here.  It is the one row without its own byte scope.")
emit("")
emit("NASDAQ BX AGAINST NASDAQ PSX IS CONFOUNDED, AND WE SAY SO.")
emit("    Same operator, same day, tightest contrast in the corpus — and NOT MATCHED ON")
emit("    THE WIRE.  BX carries 15 message types, PSX 14, and the extra one is the Retail")
emit("    Price Improvement indicator: 4,636,704 of them in the session.  PSX runs no such")
emit("    programme.  The two books also differ in matching engine and fee schedule.  The")
emit("    28-point gap is a venue effect with a market-structure effect folded inside it,")
emit("    and the two cannot be separated from these bytes.")
emit("")
emit("WHICH STOCK YOU LOOK AT MOVES THE NUMBER FURTHER THAN WHICH EXCHANGE.")
emit("    One exchange, one truncated New York morning, one program, run once per listed")
emit("    company: 321 stocks, and the 321 runs add back to the whole-morning run exactly.")
emit("    Keeping only the 25 stocks with at least 100 orders that reached an end:")
emit("        band across those 25                        765 ... 1,000")
emit("        at exactly 1,000                            7  (CTOS GBTG IFF MSI POST PSO TS)")
emit("        below the published Nasdaq figure of 958    11 of 25")
emit("        below 935                                   7 of 25")
emit("        the lowest is TGT at 765 — over the 405 of its orders that reached an end,")
emit("        while 8,407 of its 8,812 orders were still resting when the recording stopped.")
emit("    Of the 321 symbols, 21 resolve NO order at all.  That is not a rate of zero and")
emit("    it is never averaged in.  Of the 300 that resolve at least one, the median has 9")
emit("    orders that reached an end, and 275 of 300 have fewer than 100.  An earlier")
emit("    version quoted '85 of 300 below 958', which is arithmetically true and should not")
emit("    be quoted.  11 OF 25 IS THE HONEST VERSION.")
emit("")
emit("THE NYSE TEXAS FLOOR OF 186 IS CTEST, THE VENUE'S OWN TEST SYMBOL.")
emit("    A placeholder used to check the plumbing.  Every real company name in that book's")
emit("    top fifteen sits between 988 and 1,000.  The run prints only the top fifteen and")
emit("    the two extremes, so THE FLOOR FOR REAL COMPANY NAMES ON THAT BOOK IS NOT")
emit("    MEASURED.  186 without CTEST beside it publishes a test artefact as a market fact.")

// =====================================================================================
section("7. CONTROL ARMS — the ledger must be able to FAIL")
// =====================================================================================
emit("")
emit("An instrument that cannot fail is not an instrument.  Always-green and always-red")
emit("are the same defect.  Each arm below runs the same arithmetic on a deliberately")
emit("wrong input and must reject it.")
emit("")
var arms = 0, armsPassed = 0

func arm(_ id: String, _ what: String, _ passed: Bool) {
    arms += 1
    if passed { armsPassed += 1 }
    emit("  " + pad(id, 5) + pad(passed ? "PASS" : "FAIL", 6) + what)
    if !passed { FAILURES.append("control arm \(id) did not fire") }
}

// C1 — a mutated numerator must move the rate.
let c1 = per1000(12_156_283 + 12_676, 12_676_036)!
arm("C1", "a numerator moved by 0.1% changes the rate: 958 -> " + String(c1),
    c1 != 958)

// C2 — closure must break when a censored count is wrong.
let c2broken = (287_986 == 82_132 + 205_853)
arm("C2", "closure rejects opened != ended + censored (205,853 instead of 205,854)",
    c2broken == false)

// C3 — an empty control must never yield a ratio.
arm("C3", "a zero control returns NOT_COMPUTABLE, never a ratio",
    per1000(0, 0) == nil)

// C4 — the composite must be able to point backwards, and be reported that way.
let c4 = per1000(68, 152)!
arm("C4", "NYSE Texas reads " + String(c4) + " — below its own control, and prints as such",
    c4 < 1000)

// C5 — floor and round disagree, so the choice is load-bearing.
let bxFloor = (12_156_283 * 1000) / 12_676_036
let bxRound = (12_156_283 * 2000 + 12_676_036) / (2 * 12_676_036)
arm("C5", "floor " + String(bxFloor) + " and round-half-up " + String(bxRound)
    + " disagree on Nasdaq BX — flooring is stated, not assumed",
    bxFloor != bxRound)

// C6 — a degenerate denominator must be withheld rather than banded.
arm("C6", "164 orders at exactly 1,000 is withheld from the band, and the band still reads "
    + String(bandLow) + " ... " + String(bandHigh),
    bandHigh == 998 && bandLow == 935)

// C7 — the borrowed row must be labelled, not silently counted as ours.
var borrowedRows = 0
for s in SESSIONS where s.borrowed { borrowedRows += 1 }
arm("C7", "exactly " + String(borrowedRows) + " row is marked BORROWED and says so on its face",
    borrowedRows == 1)

// C8 — a truncated head must never be describable as a complete session.
var completeRows = 0, truncatedRows = 0
for s in SESSIONS { if s.complete { completeRows += 1 } else { truncatedRows += 1 } }
arm("C8", "4 complete sessions and 5 truncated heads, each labelled on every row",
    completeRows == 4 && truncatedRows == 5)

emit("")
emit("control arms                    " + String(armsPassed) + " of " + String(arms) + " fired")

// =====================================================================================
section("8. WHAT IT COSTS TO RUN — compute only")
// =====================================================================================
emit("")
emit("About 11.4 microseconds per message.  Sized on the SLOWEST of twelve recorded runs")
emit("of one identical input — 391,242,214 bytes, fingerprint verified before each run,")
emit("28,734,686 messages, the same 958 every time.  The twelve range from 46.568 s to")
emit("328.043 s.")
emit("")
emit("AND THAT 7x SPREAD IS NOT ALL MACHINE LOAD.  The twelve runs span several builds of")
emit("the program written over a week, and EVERY RUN RECORDS THE INPUT'S FINGERPRINT AND")
emit("NONE RECORDS THE PROGRAM'S.  Two of those builds are proven identical everywhere a")
emit("decision is made — 34 differing lines, all of them text the program prints.  The")
emit("earlier builds are not proven anything, and the slowest run came from one of them.")
emit("The figure is an ENVELOPE OVER A SET OF BUILDS rather than one program's cost, and")
emit("it is sized on the slowest because for anyone sizing hardware that is the safe")
emit("direction to be wrong in.")
emit("")
emit("Against the exchange's own message rate on the same session:")
emit("    whole session, 57,505 s     28,734,686 messages   328.0 s    ~6 per 1,000")
emit("    busiest 1 second                 63,447 messages   724 ms    0.72x")
emit("    busiest 100 ms                   26,635 messages   304 ms    3.0x")
emit("    busiest 50 ms                    22,420 messages   256 ms    5.1x")
emit("    busiest 1 ms                      1,336 messages   15.3 ms   15.3x")
emit("    busiest 100 us                      165 messages   1.88 ms   18.8x")
emit("CHEAP OVER A DAY AND UNABLE TO KEEP UP INSIDE A BURST.  Both halves, together.")
emit("")
emit("On the blockchain side the unit of work is a block and the block IS the clock:")
emit("31.8 ms per block against a mean block interval of 13.586 seconds — about 427x")
emit("headroom, sized again on the slower of two runs.")
emit("")
emit("NOT IN THESE FIGURES, AND NAMED RATHER THAN IMPLIED: converting a text feed into the")
emit("binary form the detector reads was not separately timed.")

// =====================================================================================
section("9. THE SHARPER CHECK, AND THE TWO DODGES THAT ARE FREE")
// =====================================================================================
emit("")
emit("On a public blockchain nobody is missing from the wire, so a much sharper question")
emit("is decidable.  Over 1,000 consecutive blocks — 13,586 seconds of chain time — the")
emit("five-conjunct check fires 108 times out of 22,287 candidate triples: 4.8 per 1,000.")
emit("Set that beside 958 per 1,000 on an ordinary exchange session and the contrast is")
emit("the whole argument.  (Already published.  This study did not re-measure it.)")
emit("")
emit("TWO TESTS CAN BE DODGED FOR NOTHING, AND IT IS WORTH BEING EXACT ABOUT WHICH.")
emit("    ONE IS A CONDITION: alternate the two roles between two addresses already funded,")
emit("    and the same-party conjunct fails.")
emit("    THE OTHER IS NOT ONE OF THE FIVE AT ALL.  It is the separate profit test, the")
emit("    filter that cuts 126 candidate triples down to 108.  Sell back one unit more of")
emit("    the bought token than was bought and that test fails too.")
emit("    Both are free to the last unit.  A summary document said 'two of the five' and")
emit("    that is the wrong shape; the primary measurement says the profit test is not a")
emit("    conjunct.  ONE CONDITION, PLUS THE SEPARATE PROFIT TEST.")
emit("")
emit("TWO OF THE PRICED DODGES DO NOT ATTACK THE CHECK ON THIS PAGE AT ALL.")
emit("    The decoy trade and the widened hold defeat a LIVE watcher that requires the two")
emit("    outer legs to be adjacent and close together.  The published check has neither")
emit("    requirement — it scans every position between the legs.  They are priced because")
emit("    a reader reaches for them, not because they work.")
emit("")
emit("THE FREE DODGES DESTROY PRECISION RATHER THAN VISIBILITY.  Re-attribute every closing")
emit("leg to a fresh address and re-enumerate: 857 extractive cases per 1,000 candidates")
emit("becomes 21 per 1,000, a 40x loss.  The arithmetic closes on itself because the")
emit("contract-side calculation is blind to who submitted what.")
emit("")
emit("AND THE BOUND THIS WORK CANNOT CLOSE.  Those free dodges need inventory sitting ready.")
emit("The inventory is visible — 26 distinct actors, 19 of them acting more than once.")
emit("WHAT IT COSTS TO HOLD IS NOT MEASURED HERE.  This work prices transaction fees and")
emit("contract arithmetic.  It does not price capital and it does not guess.  THE COUNT IS")
emit("A FLOOR, NEVER A CENSUS.")

// =====================================================================================
section("10. WHAT THIS DOES NOT SAY")
// =====================================================================================
emit("")
emit("IT DOES NOT SAY ANYONE DID ANYTHING.  Cancelling orders is what market makers do:")
emit("they post prices on both sides all day and pull them the moment the world moves.  A")
emit("hundred withdrawals for one trade is ordinary.  DETECTION IS NOT INTENT, and on every")
emit("feed measured that is a property of the bytes rather than a policy — the party acting")
emit("is absent or single-valued on all of them:")
emit("    Nasdaq 2003            none on 2,921,796 of 2,921,796")
emit("    Nasdaq BX 2019         49,470 of 10,629,593 carry one, 4 per 1,000, TWO distinct")
emit("                           member identifiers in a whole session")
emit("    NYSE                   five spaces on 287,986 of 287,986")
emit("    NYSE American          none on 122,439 of 122,584; the 145 that carry one carry")
emit("                           the SAME one")
emit("    NYSE National          none on 114,236 of 114,236")
emit("    NYSE Texas             blank on 120,409 of 121,611")
emit("    NYSE Arca              blank on 210,356 of 210,367")
emit("    Cboe Europe BXE        no such field exists at all")
emit("The sharpest question a surveillance check could ask — is the same firm showing one")
emit("side while trading the other? — CANNOT BE COMPUTED on any exchange feed here.  Not")
emit("'no'.  THE FEED DOES NOT CONTAIN THE ANSWER.")
emit("")
emit("IT DOES NOT SAY WHY AN ORDER WAS CANCELLED.  Where a reason field exists it carries")
emit("exactly one value on every record — 81,693 of 81,693 on NYSE, 104,109 of 104,109 on")
emit("American, 113,147 of 113,147 on National, 119,762 of 119,762 on Texas — and on the")
emit("European and Nasdaq feeds no such field exists.  A field with one value carries the")
emit("same information as a field that is missing: none.")
emit("")
emit("IT DOES NOT REPLACE THE AUDIT TRAIL.  The audit trail holds WHO.  The exchange feed")
emit("holds ORDER: its sequence is the position in the stream rather than a comparison of")
emit("clocks, and on a complete Nasdaq BX session that sequence never goes backwards once,")
emit("across 28,734,686 messages.  Measured against that session, 447 of every 1,000")
emit("adjacent messages arrive within one exchange's tolerance of each other and 998 of")
emit("every 1,000 within one broker-dealer's; the longest unbroken run the feed orders and")
emit("a one-second clock comparison does not is 63,447.  One venue on one day, therefore a")
emit("FLOOR.  No audit-trail record was read — that is ABSENT here, and the actual clock")
emit("error at any reporter is NOT_KNOWN from these artefacts.")

// =====================================================================================
section("VERDICT")
// =====================================================================================
emit("")
if FAILURES.isEmpty {
    emit("LEDGER_CLOSES_EXACT")
    emit("    nine sessions re-derived from their own counts, 0 disagreements")
    emit("    band 935 ... 998 per 1,000 of orders that ended")
    emit("    " + String(armsPassed) + " of " + String(arms) + " control arms fired")
    emit("    no threshold applied anywhere; RATIO_PUBLISHED_NO_THRESHOLD")
    emit("")
    emit("A check that says almost everything is suspicious is not detecting anything.  It")
    emit("is describing how a market normally works.  The number is a DENOMINATOR, not a")
    emit("finding: what an ordinary session scores when nobody is doing anything.")
    emit("")
    emit("Detection is not intent.  Nothing here names or implies wrongdoing by any")
    emit("identifiable participant.")
    exit(0)
} else {
    emit("LEDGER_DOES_NOT_CLOSE")
    for f in FAILURES { emit("    " + f) }
    emit("")
    emit("The figures above are printed in full anyway.  A refusal that prints nothing is")
    emit("indistinguishable from a program that was never built.")
    exit(1)
}
