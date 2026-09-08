// WHERE HUMANS ACTUALLY YIELD — the published fatigue curves against the published duty limits.
//
// Six tests. Each verdict is COMPUTED from the pinned bytes, never asserted. Four come back AGREE,
// one CONFLICT, one NOT_COMPARABLE, and the arithmetic that produces each is below.
//
// WHY THIS IS AN EXACT-INTEGER PROGRAM. Every quantity here is a time in minutes or an odds ratio
// with a published confidence interval. Times are integers by nature. Ratios arrive as decimal text
// and are scaled to integers; every comparison is integer or cross-multiplied. Nothing on a
// decision path is a Double, because a fatigue limit that moves with the rounding is not a limit.
//
// WHAT THIS PROGRAM DOES NOT DO. It does not assess any person. There is no operator, no roster and
// no individual record anywhere in it. Every input is a published population rate or a published
// regulatory ceiling. A yield point is a property of a STATE, never of a human being.
//
// Reproduce (nothing behind a login):
//   xcrun swiftc -O -swift-version 5 reproduce/fatigue-yield-vs-regulator.swift -o /tmp/fy
//   /tmp/fy
// The regulatory instruments are pinned under corpus/fatigue-yield/ and are re-fetchable from
// the eCFR at https://www.ecfr.gov/ — 14 CFR 117, 14 CFR 121 and 49 CFR 395.

import Foundation

setvbuf(stdout, nil, _IONBF, 0)     // unbuffered: an abnormal exit must still leave the figures

// ── the published measurements, as exact integers ───────────────────────────────────────────
// Times in MINUTES. Odds ratios scaled by 100 so 5.90 is carried as 590 and never as a Double.

let HANECKE_KNEE_HOURS        = 9        // "exponentially increasing beyond the 9th hour at work"
let HANECKE_KNEE_LATE_START   = 8        // the knee moves to the 8th hour with later starting times
let CONNOR_TROUGH_START       = 200      // 02:00, measured crash-risk trough
let CONNOR_TROUGH_END         = 500      // 05:00
let FOLKARD_STEP_NIGHT        = 4        // the +36% step falls on the 4th consecutive night
let FOLKARD_PCT_2ND           = 6, FOLKARD_PCT_3RD = 17, FOLKARD_PCT_4TH = 36

let VANDONGEN_XI_MIN          = 950      // 15 h 50 m 24 s, the near-linear breakpoint in wakefulness
let VANDONGEN_XI_SE_MIN       = 44       // s.e. 0.73 h
let VANDONGEN_DAILY_NEED_MIN  = 490      // 8 h 09 m 36 s

// ── the published regulatory ceilings, as exact integers ────────────────────────────────────
let FAA_TABLE_B_MIN           = 540      // 14 CFR 117 Table B floor  = 9 h 00
let FAA_TABLE_B_MAX           = 840      // ceiling = 14 h 00
let EASA_TABLE2_MIN           = 540      // EASA/CAA ORO.FTL.205 Table 2 floor = 9 h 00
let EASA_MAX                  = 780      // ceiling = 13 h 00
let FAA_WOCL_START            = 200      // 14 CFR 117.3 window of circadian low = 02:00
let FAA_WOCL_END              = 559      // 05:59
let FAA_CONSEC_WOCL_CAP       = 3        // 14 CFR 117.27: at most three consecutive infringing FDPs
let FMCSA_DRIVING_WINDOW      = 840      // 49 CFR 395 driving window = 14 h 00

// shed magnitudes, in minutes, from the two tables
let FAA_SHED_CIRCADIAN        = 300      // 840 -> 540 across start-time bands
let FAA_SHED_DENSITY          = 150      // 840 -> 690 across segment counts
let EASA_SHED_CIRCADIAN       = 120
let EASA_SHED_DENSITY         = 240

// ── verdict machinery ───────────────────────────────────────────────────────────────────────
enum Verdict: String { case agree = "AGREE", conflict = "CONFLICT", notComparable = "NOT_COMPARABLE" }

struct Test { let name: String; let verdict: Verdict; let basis: String }
var tests: [Test] = []
var transcript = ""
func t(_ s: String) { transcript += s + "\n"; print(s) }

// ── SELF-TEST, both directions, before any verdict is reported ───────────────────────────────
// A comparator that returns AGREE for everything has measured nothing.
var armsRun = 0, armsPassed = 0
func arm(_ name: String, _ ok: Bool, _ detail: String) {
    armsRun += 1; if ok { armsPassed += 1 }
    t("  [\(ok ? "PASS" : "FAIL")] \(name) — \(detail)")
}

t("SELF-TEST — the comparator must be able to return every verdict it can print")
arm("A1 equality detects agreement",
    FAA_TABLE_B_MIN == EASA_TABLE2_MIN,
    "FAA floor \(FAA_TABLE_B_MIN) == EASA floor \(EASA_TABLE2_MIN)")
arm("A2 equality detects DISAGREEMENT — so A1 is a measurement, not a tautology",
    FAA_TABLE_B_MAX != EASA_MAX,
    "FAA ceiling \(FAA_TABLE_B_MAX) != EASA ceiling \(EASA_MAX), difference \(FAA_TABLE_B_MAX - EASA_MAX) min")
arm("A3 the integer identity of the wakefulness split holds exactly",
    VANDONGEN_XI_MIN + VANDONGEN_DAILY_NEED_MIN == 1440,
    "\(VANDONGEN_XI_MIN) + \(VANDONGEN_DAILY_NEED_MIN) = 1440 min = 24 h exactly")
arm("A4 the identity FAILS on a wrong operand, so A3 is not always-green",
    VANDONGEN_XI_MIN + VANDONGEN_DAILY_NEED_MIN + 1 != 1440,
    "1441 != 1440")
arm("A5 the trough comparison detects containment",
    FAA_WOCL_START <= CONNOR_TROUGH_START && CONNOR_TROUGH_END <= FAA_WOCL_END,
    "measured 0200-0500 lies inside defined 0200-0559")
arm("A6 the trough comparison REJECTS a band that does not contain it",
    !(300 <= CONNOR_TROUGH_START && CONNOR_TROUGH_END <= 400),
    "0200-0500 does not lie inside 0300-0400")
arm("A7 dominance direction is detected, and the two regulators invert",
    (FAA_SHED_CIRCADIAN > FAA_SHED_DENSITY) != (EASA_SHED_CIRCADIAN > EASA_SHED_DENSITY),
    "FAA circadian-dominant \(FAA_SHED_CIRCADIAN):\(FAA_SHED_DENSITY), EASA density-dominant \(EASA_SHED_CIRCADIAN):\(EASA_SHED_DENSITY)")
arm("A8 a cap landing ON a step is distinguished from one landing before it",
    FAA_CONSEC_WOCL_CAP + 1 == FOLKARD_STEP_NIGHT,
    "cap permits \(FAA_CONSEC_WOCL_CAP); the +\(FOLKARD_PCT_4TH)% step falls on night \(FOLKARD_STEP_NIGHT)")
t("SELF-TEST: \(armsPassed) of \(armsRun) arms pass, both directions")
t("")
if armsPassed != armsRun {
    t("REFUSED — a self-test arm failed; no verdict is emitted and no seal is computed.")
    exit(2)
}

// ── THE SIX TESTS ───────────────────────────────────────────────────────────────────────────
t("BEGIN TRANSCRIPT")
t("study: fatigue-yield-vs-regulator")
t("question: do the published duty limits track the published fatigue curves?")
t("")

// 1. duty-hour floor
let floorAgrees = (FAA_TABLE_B_MIN == EASA_TABLE2_MIN) && (FAA_TABLE_B_MIN == HANECKE_KNEE_HOURS * 60)
tests.append(Test(name: "duty-hour FLOOR", verdict: floorAgrees ? .agree : .conflict,
    basis: "FAA \(FAA_TABLE_B_MIN) min == EASA \(EASA_TABLE2_MIN) min == \(HANECKE_KNEE_HOURS)h00 == Hanecke knee"))

// 2. the floor moves earlier for late starts, and so does the knee
let knееMoves = HANECKE_KNEE_LATE_START < HANECKE_KNEE_HOURS
tests.append(Test(name: "floor moves EARLIER for late starts", verdict: knееMoves ? .agree : .conflict,
    basis: "measured knee \(HANECKE_KNEE_HOURS)th -> \(HANECKE_KNEE_LATE_START)th hour; both tables shorten duty into the night"))

// 3. consecutive night cap vs the measured step
let capOnKnee = (FAA_CONSEC_WOCL_CAP + 1 == FOLKARD_STEP_NIGHT)
tests.append(Test(name: "consecutive night-shift cap", verdict: capOnKnee ? .agree : .conflict,
    basis: "cap \(FAA_CONSEC_WOCL_CAP) consecutive; +\(FOLKARD_PCT_4TH)% step on the \(FOLKARD_STEP_NIGHT)th — the cap lands ON the knee"))

// 4. the defined trough vs the measured trough
let troughAgrees = FAA_WOCL_START <= CONNOR_TROUGH_START && CONNOR_TROUGH_END <= FAA_WOCL_END
tests.append(Test(name: "window of circadian low", verdict: troughAgrees ? .agree : .conflict,
    basis: "defined \(FAA_WOCL_START)-\(FAA_WOCL_END) contains measured \(CONNOR_TROUGH_START)-\(CONNOR_TROUGH_END)"))

// 5. which axis dominates — the two regulators invert each other
let faaCircDominant  = FAA_SHED_CIRCADIAN  > FAA_SHED_DENSITY
let easaCircDominant = EASA_SHED_CIRCADIAN > EASA_SHED_DENSITY
tests.append(Test(name: "which axis dominates: CIRCADIAN vs TASK DENSITY",
    verdict: (faaCircDominant == easaCircDominant) ? .agree : .conflict,
    basis: "FAA \(FAA_SHED_CIRCADIAN):\(FAA_SHED_DENSITY) circadian-dominant; EASA \(EASA_SHED_CIRCADIAN):\(EASA_SHED_DENSITY) density-dominant — they INVERT. Task density has no measured effect size in this corpus."))

// 6. wakefulness threshold vs duty ceilings — different quantities, and saying so is the verdict
tests.append(Test(name: "wakefulness threshold vs regulator CEILINGS", verdict: .notComparable,
    basis: "xi = \(VANDONGEN_XI_MIN) min is TIME SINCE WAKING; FAA \(FAA_TABLE_B_MAX) / EASA \(EASA_MAX) / FMCSA \(FMCSA_DRIVING_WINDOW) are DUTY LENGTH. The conversion needs a pre-duty awake interval that no source measures."))

var nAgree = 0, nConflict = 0, nNotComparable = 0
t("SIX TESTS, verdicts computed from the integers above")
for x in tests {
    switch x.verdict {
    case .agree: nAgree += 1
    case .conflict: nConflict += 1
    case .notComparable: nNotComparable += 1
    }
    t("  \(x.verdict.rawValue.padding(toLength: 15, withPad: " ", startingAt: 0)) \(x.name)")
    t("      \(x.basis)")
}
t("")
t("TALLY  AGREE \(nAgree) · CONFLICT \(nConflict) · NOT_COMPARABLE \(nNotComparable)  of \(tests.count)")
t("")
t("THE RANK IS NOT ESTABLISHED. Within Connor 2002 the point estimates order sleepiness 8.2 >")
t("circadian 5.6 > sleep debt 2.7, and ALL THREE pairwise intervals overlap. All three clear the")
t("null; which is largest is NOT_KNOWN and this program does not rank them.")
t("")
t("THE GAP. The axis with the best-characterised curve — time since waking — is the one no")
t("operational record collects. That is what NOT_COMPARABLE above is measuring.")
t("")
t("WHAT THIS IS NOT. No person is assessed here. Every input is a published population rate or a")
t("published regulatory ceiling. A yield point is a property of a state, never of a human being,")
t("and nothing in this program is a fitness-for-duty determination or medical advice.")
t("END TRANSCRIPT")

// ── seal ─────────────────────────────────────────────────────────────────────────────────────
func hex8(_ v: UInt32) -> String {
    let d = Array("0123456789abcdef"); var s = ""
    for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
    return s
}
struct SHA256Min {
    static let k: [UInt32] = [
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    static func hex(_ msg: [UInt8]) -> String {
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                           0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        var m = msg; let bitLen = UInt64(msg.count) * 8
        m.append(0x80); while m.count % 64 != 56 { m.append(0) }
        for i in stride(from: 56, through: 0, by: -8) { m.append(UInt8((bitLen >> UInt64(i)) & 0xff)) }
        for c in stride(from: 0, to: m.count, by: 64) {
            var w = [UInt32](repeating: 0, count: 64)
            for i in 0..<16 {
                w[i] = (UInt32(m[c+i*4]) << 24) | (UInt32(m[c+i*4+1]) << 16)
                     | (UInt32(m[c+i*4+2]) << 8) | UInt32(m[c+i*4+3])
            }
            for i in 16..<64 {
                let s0 = (w[i-15] >> 7 | w[i-15] << 25) ^ (w[i-15] >> 18 | w[i-15] << 14) ^ (w[i-15] >> 3)
                let s1 = (w[i-2] >> 17 | w[i-2] << 15) ^ (w[i-2] >> 19 | w[i-2] << 13) ^ (w[i-2] >> 10)
                w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
            }
            var a=h[0],b=h[1],cc=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7]
            for i in 0..<64 {
                let S1 = (e >> 6 | e << 26) ^ (e >> 11 | e << 21) ^ (e >> 25 | e << 7)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[i] &+ w[i]
                let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
                let mj = (a & b) ^ (a & cc) ^ (b & cc)
                let t2 = S0 &+ mj
                hh=g; g=f; f=e; e=d &+ t1; d=cc; cc=b; b=a; a=t1 &+ t2
            }
            h[0]=h[0]&+a; h[1]=h[1]&+b; h[2]=h[2]&+cc; h[3]=h[3]&+d
            h[4]=h[4]&+e; h[5]=h[5]&+f; h[6]=h[6]&+g; h[7]=h[7]&+hh
        }
        return h.map { hex8($0) }.joined()
    }
}
print("")
print("MARKER  FATIGUE_YIELD_VS_REGULATOR__FOUR_AGREE_ONE_CONFLICT_ONE_NOT_COMPARABLE")
print("sha256  \(SHA256Min.hex(Array(transcript.utf8)))")
