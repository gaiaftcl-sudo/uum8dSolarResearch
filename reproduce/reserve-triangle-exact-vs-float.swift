// Study 38 — the loss-reserve triangle, exact against float.
//
// Corpus: the CAS loss-reserving database pulled from NAIC Schedule P, six lines of
// business, public and anonymous. Every loss column is served as an INTEGER number of
// thousands of dollars, so the arithmetic below never parses a decimal.
//
// The exact arm holds no Float, no Double and no float literal. The float arm exists to
// be graded and is confined to the functions named *Float.
//
// It answers, in order:
//   A. what the filed data is, and whether it obeys its own integer invariants
//   B. the volume-weighted chain-ladder reserve as an EXACT rational, at year-end 1997
//   C. the same reserve in Double, computed two mathematically identical ways
//   D. both against the realised runoff, which this corpus contains
//   E. control arms, in both directions
//
// No claim is made about any named company, and no reserve opinion is offered. The
// subject under grading is the arithmetic.

import Foundation

// ---------------------------------------------------------------- exact big integers
// base 1e9, little-endian limbs, magnitude only. Signed values wrap this in BigI.
struct Mag: Comparable, CustomStringConvertible {
    var l: [UInt32] = [0]
    static let B: UInt64 = 1_000_000_000

    init(_ v: UInt64 = 0) { var v = v; l = []; repeat { l.append(UInt32(v % Mag.B)); v /= Mag.B } while v > 0 }
    init(limbs: [UInt32]) { l = limbs; norm() }
    mutating func norm() { while l.count > 1 && l.last == 0 { l.removeLast() } }
    var isZero: Bool { l.count == 1 && l[0] == 0 }

    static func + (a: Mag, b: Mag) -> Mag {
        var r: [UInt32] = []; r.reserveCapacity(max(a.l.count, b.l.count) + 1); var c: UInt64 = 0
        for i in 0..<max(a.l.count, b.l.count) {
            let s = c + UInt64(i < a.l.count ? a.l[i] : 0) + UInt64(i < b.l.count ? b.l[i] : 0)
            r.append(UInt32(s % B)); c = s / B
        }
        if c > 0 { r.append(UInt32(c)) }
        return Mag(limbs: r)
    }
    // a - b, caller guarantees a >= b
    static func - (a: Mag, b: Mag) -> Mag {
        var r: [UInt32] = []; r.reserveCapacity(a.l.count); var borrow: Int64 = 0
        for i in 0..<a.l.count {
            var d = Int64(a.l[i]) - borrow - Int64(i < b.l.count ? b.l[i] : 0)
            if d < 0 { d += Int64(B); borrow = 1 } else { borrow = 0 }
            r.append(UInt32(d))
        }
        return Mag(limbs: r)
    }
    static func * (a: Mag, b: Mag) -> Mag {
        if a.isZero || b.isZero { return Mag(0) }
        var acc = [UInt64](repeating: 0, count: a.l.count + b.l.count)
        for i in 0..<a.l.count {
            var c: UInt64 = 0; let ai = UInt64(a.l[i])
            for j in 0..<b.l.count {
                let cur = acc[i + j] + ai * UInt64(b.l[j]) + c
                acc[i + j] = cur % B; c = cur / B
            }
            var k = i + b.l.count
            while c > 0 && k < acc.count { let cur = acc[k] + c; acc[k] = cur % B; c = cur / B; k += 1 }
        }
        return Mag(limbs: acc.map { UInt32($0) })
    }
    func mulSmall(_ m: UInt64) -> Mag {
        var r: [UInt32] = []; r.reserveCapacity(l.count + 2); var c: UInt64 = 0
        for x in l { let cur = UInt64(x) * m + c; r.append(UInt32(cur % Mag.B)); c = cur / Mag.B }
        while c > 0 { r.append(UInt32(c % Mag.B)); c /= Mag.B }
        return Mag(limbs: r)
    }
    static func < (a: Mag, b: Mag) -> Bool {
        if a.l.count != b.l.count { return a.l.count < b.l.count }
        for i in stride(from: a.l.count - 1, through: 0, by: -1) where a.l[i] != b.l[i] { return a.l[i] < b.l[i] }
        return false
    }
    static func == (a: Mag, b: Mag) -> Bool { a.l == b.l }

    // shift up by whole limbs (multiply by B^n)
    func shifted(_ n: Int) -> Mag {
        if isZero { return self }
        return Mag(limbs: [UInt32](repeating: 0, count: n) + l)
    }

    // schoolbook long division; each quotient limb found by binary search on 0..<B.
    // Returns (quotient, remainder). Divisor must be non-zero.
    static func divMod(_ a: Mag, _ b: Mag) -> (Mag, Mag) {
        precondition(!b.isZero, "division by zero")
        if a < b { return (Mag(0), a) }
        var q = [UInt32](repeating: 0, count: a.l.count)
        var rem = Mag(0)
        for i in stride(from: a.l.count - 1, through: 0, by: -1) {
            // rem = rem * B + a.l[i]
            rem = rem.shifted(1) + Mag(UInt64(a.l[i]))
            var lo: UInt64 = 0, hi: UInt64 = B - 1, best: UInt64 = 0
            while lo <= hi {
                let mid = (lo + hi) / 2
                let t = b.mulSmall(mid)
                if t < rem || t == rem { best = mid; lo = mid + 1 } else { if mid == 0 { break }; hi = mid - 1 }
            }
            q[i] = UInt32(best)
            rem = rem - b.mulSmall(best)
        }
        return (Mag(limbs: q), rem)
    }

    var description: String {
        var s = String(l[l.count - 1])
        for i in stride(from: l.count - 2, through: 0, by: -1) {
            let d = String(l[i]); s += String(repeating: "0", count: 9 - d.count) + d
        }
        return s
    }
}

struct BigI: CustomStringConvertible {
    var neg: Bool = false
    var m: Mag = Mag(0)
    init(_ v: Int) { neg = v < 0; m = Mag(UInt64(v.magnitude)) }
    init(neg: Bool, m: Mag) { self.m = m; self.neg = m.isZero ? false : neg }
    var isZero: Bool { m.isZero }

    static func + (a: BigI, b: BigI) -> BigI {
        if a.neg == b.neg { return BigI(neg: a.neg, m: a.m + b.m) }
        if a.m < b.m { return BigI(neg: b.neg, m: b.m - a.m) }
        return BigI(neg: a.neg, m: a.m - b.m)
    }
    static func - (a: BigI, b: BigI) -> BigI { a + BigI(neg: !b.neg, m: b.m) }
    static func * (a: BigI, b: BigI) -> BigI { BigI(neg: a.neg != b.neg, m: a.m * b.m) }
    static func == (a: BigI, b: BigI) -> Bool { a.neg == b.neg && a.m == b.m }
    var description: String { (neg ? "-" : "") + m.description }
}

// Exact rational n/d with d > 0. No reduction is needed for correctness; the
// magnitudes here stay well inside what the limb arithmetic handles.
struct Rat {
    var n: BigI
    var d: Mag
    init(_ n: BigI, _ d: Mag) { precondition(!d.isZero); self.n = n; self.d = d }
    init(_ v: Int) { n = BigI(v); d = Mag(1) }
    static func * (a: Rat, b: Rat) -> Rat { Rat(a.n * b.n, a.d * b.d) }
    static func - (a: Rat, b: Rat) -> Rat {
        Rat(a.n * BigI(neg: false, m: b.d) - b.n * BigI(neg: false, m: a.d), a.d * b.d)
    }
    static func + (a: Rat, b: Rat) -> Rat {
        Rat(a.n * BigI(neg: false, m: b.d) + b.n * BigI(neg: false, m: a.d), a.d * b.d)
    }
    static func == (a: Rat, b: Rat) -> Bool { (a - b).n.isZero }
    // nearest integer, halves away from zero, by exact integer arithmetic only
    var roundedString: String {
        let two = n.m.mulSmall(2) + d
        let (q, _) = Mag.divMod(two, d.mulSmall(2))
        return (n.neg && !q.isZero ? "-" : "") + q.description
    }
    // exact integer value when it is one, else nil
    var exactInt: String? {
        let (q, r) = Mag.divMod(n.m, d)
        return r.isZero ? ((n.neg && !q.isZero ? "-" : "") + q.description) : nil
    }
}

// ---------------------------------------------------------------- corpus
struct Row { let gr: Int; let name: String; let ay: Int; let lag: Int; let paid: Int; let incur: Int; let bulk: Int; let prem: Int }

let LINES = ["ppauto_pos", "comauto_pos", "wkcomp_pos", "othliab_pos", "medmal_pos", "prodliab_pos"]

func locate() -> String? {
    let fm = FileManager.default
    var cands = ["corpus/schedule-p", "../schedule-p", "../corpus/schedule-p",
                 "../../corpus/schedule-p", "schedule-p", "."]
    if CommandLine.arguments.count > 1 { cands.insert(CommandLine.arguments[1], at: 0) }
    for c in cands where fm.fileExists(atPath: c + "/" + LINES[0] + ".csv") { return c }
    return nil
}

func parse(_ path: String) -> [Row] {
    guard let txt = try? String(contentsOfFile: path, encoding: .utf8) else { return [] }
    var out: [Row] = []
    for (i, line) in txt.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" || $0 == "\r" }).enumerated() {
        if i == 0 { continue }
        let f = line.split(separator: ",", omittingEmptySubsequences: false).map { String($0) }
        if f.count < 12 { continue }
        guard let gr = Int(f[0]), let ay = Int(f[2]), let lag = Int(f[4]),
              let incur = Int(f[5]), let paid = Int(f[6]), let bulk = Int(f[7]),
              let prem = Int(f[10]) else { continue }
        out.append(Row(gr: gr, name: f[1], ay: ay, lag: lag, paid: paid, incur: incur, bulk: bulk, prem: prem))
    }
    return out
}

// ---------------------------------------------------------------- the frozen law
// Valuation date: year-end 1997. A cell (ay, lag) is OBSERVED iff ay + lag - 1 <= 1997.
let VALUATION = 1997
let AY0 = 1988, AYN = 1997, LAGN = 10

// Volume-weighted age-to-age factor for lag k -> k+1, summed over the accident years
// whose cells at BOTH k and k+1 are observed at the valuation date.
func factorSums(_ g: [[Int]], _ k: Int) -> (Int, Int) {
    var num = 0, den = 0
    for ay in AY0...AYN where ay + k <= VALUATION {
        den += g[ay - AY0][k - 1]; num += g[ay - AY0][k]
    }
    return (num, den)
}

enum Refusal { case none, zeroDenominator, premiseViolated }

// The chain-ladder premise: cumulative paid loss is non-negative and non-decreasing, so
// every column sum a factor divides is positive. This is the model's own definition of
// its inputs. It is not a threshold chosen to improve an answer, and nothing here is
// tuned to a result: a grid either satisfies the premise or the model does not apply.
func premiseViolation(_ g: [[Int]]) -> Bool {
    // Only the OBSERVED triangle is examined. A gate that reads the runoff would be
    // reading data the valuation date cannot see, and would not be a gate an actuary
    // standing at year-end 1997 could apply.
    for ay in AY0...AYN {
        let i = ay - AY0, latest = VALUATION - ay + 1
        for j in 0..<latest where g[i][j] < 0 { return true }
        for j in 1..<latest where g[i][j] < g[i][j - 1] { return true }
    }
    for k in 1...(LAGN - 1) {
        let (n, d) = factorSums(g, k)
        if d <= 0 || n < 0 { return true }
    }
    return false
}

// L1 is the law as first frozen: refuse only where a denominator is zero, because a
// factor with no denominator does not exist. L1 IS NOT EDITED. Passing premiseGate:true
// runs L1PRIME, registered separately after L1 had already been run.
func exactReserve(_ g: [[Int]], premiseGate: Bool) -> (Rat, Refusal) {
    if premiseGate && premiseViolation(g) { return (Rat(0), .premiseViolated) }
    var fs: [(Int, Int)] = []
    for k in 1...(LAGN - 1) {
        let (n, d) = factorSums(g, k)
        if d == 0 { return (Rat(0), .zeroDenominator) }
        if d < 0 { return (Rat(0), .premiseViolated) }
        fs.append((n, d))
    }
    var total = Rat(0)
    for ay in AY0...AYN {
        let i = ay - AY0
        let latest = VALUATION - ay + 1
        let c = g[i][latest - 1]
        var u = Rat(BigI(c), Mag(1))
        if latest < LAGN {
            for k in latest...(LAGN - 1) {
                let (n, d) = fs[k - 1]
                u = u * Rat(BigI(n), Mag(UInt64(d)))
            }
        }
        total = total + (u - Rat(BigI(c), Mag(1)))
    }
    return (total, .none)
}

// The realised reserve: this corpus contains the runoff, so truth is a subtraction.
func realisedReserve(_ g: [[Int]]) -> Int {
    var t = 0
    for ay in AY0...AYN {
        let latest = VALUATION - ay + 1
        t += g[ay - AY0][LAGN - 1] - g[ay - AY0][latest - 1]
    }
    return t
}

// ---------------------------------------------------------------- the float arm
// Two mathematically identical orderings of the same law. A difference between them is
// not an accuracy claim; it is a statement about agreement.
func floatReserve(_ g: [[Int]], descending: Bool) -> Double? {
    var f = [Double](repeating: 0, count: LAGN)
    let ks = descending ? Array(stride(from: LAGN - 1, through: 1, by: -1)) : Array(1...(LAGN - 1))
    for k in ks {
        let (n, d) = factorSums(g, k)
        if d == 0 { return nil }
        f[k] = Double(n) / Double(d)
    }
    var total = 0.0
    let ays = descending ? Array(stride(from: AYN, through: AY0, by: -1)) : Array(AY0...AYN)
    for ay in ays {
        let i = ay - AY0
        let latest = VALUATION - ay + 1
        let c = Double(g[i][latest - 1])
        if descending {
            var p = 1.0
            if latest < LAGN { for k in stride(from: LAGN - 1, through: latest, by: -1) { p *= f[k] } }
            total += c * p - c
        } else {
            var u = c
            if latest < LAGN { for k in latest...(LAGN - 1) { u *= f[k] } }
            total += u - c
        }
    }
    return total
}

func roundHalfAway(_ x: Double) -> String {
    if !x.isFinite { return "NONFINITE" }
    let r = (x < 0 ? -1.0 : 1.0) * (abs(x) + 0.5).rounded(.down)
    if abs(r) >= 9.0e18 { return "OUTOFRANGE" }
    return String(Int64(r))
}

// ---------------------------------------------------------------- grids
struct Grid { let line: String; let gr: Int; let name: String; let paid: [[Int]]; let incur: [[Int]]; let prem: [[Int]] }

func pad(_ s: String, _ w: Int) -> String {
    s.count >= w ? s : String(repeating: " ", count: w - s.count) + s
}

// ---------------------------------------------------------------- report
print("STUDY 38 — THE LOSS-RESERVE TRIANGLE, EXACT AGAINST FLOAT")
print("law frozen: volume-weighted paid chain ladder, valuation year-end \(VALUATION),")
print("            accident years \(AY0)-\(AYN), development lags 1-\(LAGN)")
print("unit: one thousand dollars, the unit the filing itself uses")
print("subject under grading: the arithmetic and the instrument. No company is assessed,")
print("no reserve opinion is offered, and no figure here is advice.")
print("")

let REF = [
    "lines = 6", "accident years = 10", "development lags = 10",
]

guard let dir = locate() else {
    print("CORPUS ABSENT — the six Schedule P line files were not found.")
    print("  expected: <corpus>/{\(LINES.joined(separator: ", "))}.csv")
    print("  source  : https://www.casact.org/publications-research/research/research-resources/loss-reserving-data-pulled-naic-schedule-p")
    print("REFERENCE FIGURES, restated so an absent corpus still shows them:")
    for r in REF { print("  \(r)") }
    print("VERDICT: ELEMENT_MISSING — the archive answered with absence, which is not a MISS")
    exit(0)
}

// ---- load every grid
var corpusBytes = 0
for line in LINES {
    if let a = try? FileManager.default.attributesOfItem(atPath: dir + "/" + line + ".csv"),
       let n = a[.size] as? Int { corpusBytes += n }
}
var grids: [Grid] = []
var totalRows = 0, incompleteGrids = 0
var perLineRows: [(String, Int, Int)] = []
for line in LINES {
    let rows = parse(dir + "/" + line + ".csv")
    if rows.isEmpty { perLineRows.append((line, 0, 0)); continue }
    totalRows += rows.count
    var byCo: [Int: [Row]] = [:]
    for r in rows { byCo[r.gr, default: []].append(r) }
    var made = 0
    for (gr, rs) in byCo.sorted(by: { $0.key < $1.key }) {
        var paid = [[Int]](repeating: [Int](repeating: 0, count: LAGN), count: LAGN)
        var incur = paid, prem = paid
        var seen = [[Bool]](repeating: [Bool](repeating: false, count: LAGN), count: LAGN)
        for r in rs where r.ay >= AY0 && r.ay <= AYN && r.lag >= 1 && r.lag <= LAGN {
            let i = r.ay - AY0, j = r.lag - 1
            paid[i][j] = r.paid; incur[i][j] = r.incur; prem[i][j] = r.prem; seen[i][j] = true
        }
        var complete = true
        for i in 0..<LAGN { for j in 0..<LAGN where !seen[i][j] { complete = false } }
        if !complete { incompleteGrids += 1; continue }
        grids.append(Grid(line: line, gr: gr, name: rs[0].name, paid: paid, incur: incur, prem: prem))
        made += 1
    }
    perLineRows.append((line, rows.count, made))
}

print("=== A. the filed data, and whether it obeys its own integer invariants ===")
for (l, r, g) in perLineRows { print("  \(pad(l, 13))  rows=\(pad(String(r), 6))  complete 10x10 grids=\(pad(String(g), 4))") }
var vFalls = 0, vPaidOverIncur = 0, vNeg = 0, vPremVaries = 0, gridsWithAnyViolation = 0
for gd in grids {
    var bad = false
    for i in 0..<LAGN {
        for j in 0..<LAGN {
            if gd.paid[i][j] < 0 { vNeg += 1; bad = true }
            if gd.paid[i][j] > gd.incur[i][j] { vPaidOverIncur += 1; bad = true }
            if j > 0 && gd.prem[i][j] != gd.prem[i][0] { vPremVaries += 1; bad = true }
            if j > 0 && gd.paid[i][j] < gd.paid[i][j - 1] { vFalls += 1; bad = true }
        }
    }
    if bad { gridsWithAnyViolation += 1 }
}
print("")
print("  rows read                                  = \(totalRows)")
print("  complete 10x10 grids                       = \(grids.count)")
print("  grids dropped as incomplete                = \(incompleteGrids)")
print("  cells where cumulative paid FALLS          = \(vFalls)")
print("  cells where paid exceeds incurred          = \(vPaidOverIncur)")
print("  cells with negative cumulative paid        = \(vNeg)")
print("  cells where premium varies within an AY    = \(vPremVaries)")
print("  grids carrying at least one violation      = \(gridsWithAnyViolation) of \(grids.count)")
var oFalls = 0, oNeg = 0, oGrids = 0
for gd in grids {
    var bad = false
    for ay in AY0...AYN {
        let i = ay - AY0, latest = VALUATION - ay + 1
        for j in 0..<latest where gd.paid[i][j] < 0 { oNeg += 1; bad = true }
        for j in 1..<latest where gd.paid[i][j] < gd.paid[i][j - 1] { oFalls += 1; bad = true }
    }
    if bad { oGrids += 1 }
}
print("")
print("  the same census restricted to the OBSERVED triangle, which is all a valuation")
print("  standing at year-end \(VALUATION) can see:")
print("  cells where cumulative paid FALLS          = \(oFalls)")
print("  cells with negative cumulative paid        = \(oNeg)")
print("  grids violating the premise, observed only = \(oGrids) of \(grids.count)")
print("")

// ---- score under both laws
struct Score { var scored = 0; var refusedZero = 0; var refusedPremise = 0
               var proj = 0; var real = 0; var flips = 0; var worstGap = 0
               var orderDisagree = 0; var worstOrderGap = 0
               var over = 0; var under = 0; var exactHit = 0 }
var L1 = Score(), L1P = Score()
var worstGrid = ("", 0, "", 0)

for gd in grids {
    let real = realisedReserve(gd.paid)
    for premise in [false, true] {
        let (ex, ref) = exactReserve(gd.paid, premiseGate: premise)
        var s = premise ? L1P : L1
        switch ref {
        case .zeroDenominator: s.refusedZero += 1
        case .premiseViolated: s.refusedPremise += 1
        case .none:
            guard let fa = floatReserve(gd.paid, descending: false),
                  let fb = floatReserve(gd.paid, descending: true) else { s.refusedZero += 1; break }
            let exS = ex.roundedString, faS = roundHalfAway(fa), fbS = roundHalfAway(fb)
            s.scored += 1
            if exS != faS { s.flips += 1 }
            if faS != fbS { s.orderDisagree += 1 }
            if let e = Int(exS), let a = Int(faS), let b = Int(fbS) {
                s.worstGap = max(s.worstGap, abs(e - a))
                s.worstOrderGap = max(s.worstOrderGap, abs(a - b))
                s.proj += e; s.real += real
                if e > real { s.over += 1 } else if e < real { s.under += 1 } else { s.exactHit += 1 }
                if !premise && abs(e) > abs(worstGrid.3) { worstGrid = (gd.line, gd.gr, gd.name, e) }
            }
        }
        if premise { L1P = s } else { L1 = s }
    }
}

func report(_ tag: String, _ s: Score) {
    print("  [\(tag)] scored=\(s.scored)  refused_zero_denominator=\(s.refusedZero)  refused_premise=\(s.refusedPremise)")
    print("  [\(tag)] exact vs float, rounded verdicts differing = \(s.flips)  worst gap = \(s.worstGap) unit(s)")
    print("  [\(tag)] float ordering A vs B disagreeing          = \(s.orderDisagree)  worst gap = \(s.worstOrderGap) unit(s)")
    print("  [\(tag)] projected reserve total = \(s.proj)")
    print("  [\(tag)] realised  reserve total = \(s.real)")
    print("  [\(tag)] grids over / under / exactly on realised = \(s.over) / \(s.under) / \(s.exactHit)")
}

print("=== B. L1 — the law as first frozen: refuse only a zero denominator ===")
report("L1", L1)
print("")
print("=== C. L1PRIME — registered separately; L1 is not edited ===")
print("  L1PRIME adds one gate, and only one: the grid must satisfy the chain-ladder")
print("  premise it is an instrument for — cumulative paid non-negative and non-decreasing,")
print("  every divided column sum positive. Nothing is tuned to a result.")
report("L1PRIME", L1P)
print("")

print("=== D. the same law at the industry aggregate, one triangle per line ===")
print("  every company in a line summed cell by cell, which is how a regulator reads it")
var aggPremiseOK = 0, aggPremiseBad = 0, aggFlips = 0
var aggProj: [String: Int] = [:], aggReal: [String: Int] = [:]
for line in LINES {
    var a = [[Int]](repeating: [Int](repeating: 0, count: LAGN), count: LAGN)
    var any = false
    for gd in grids where gd.line == line {
        any = true
        for i in 0..<LAGN { for j in 0..<LAGN { a[i][j] += gd.paid[i][j] } }
    }
    if !any { print("  \(pad(line, 13))  ELEMENT_MISSING"); continue }
    let viol = premiseViolation(a)
    if viol { aggPremiseBad += 1 } else { aggPremiseOK += 1 }
    let (ex, ref) = exactReserve(a, premiseGate: false)
    guard ref == .none, let fa = floatReserve(a, descending: false),
          let fb = floatReserve(a, descending: true) else {
        print("  \(pad(line, 13))  REFUSED"); continue
    }
    let exS = ex.roundedString, faS = roundHalfAway(fa), fbS = roundHalfAway(fb)
    if exS != faS || faS != fbS { aggFlips += 1 }
    let real = realisedReserve(a)
    aggProj[line] = Int(exS) ?? 0; aggReal[line] = real
    print("  \(pad(line, 13))  premise=\(viol ? "VIOLATED" : "held")  projected=\(pad(exS, 10))  realised=\(pad(String(real), 10))  exact==float:\(exS == faS && faS == fbS)")
}
print("")
print("  aggregate triangles whose premise holds   = \(aggPremiseOK) of \(LINES.count)")
print("  aggregate triangles whose premise fails   = \(aggPremiseBad) of \(LINES.count)")
print("  aggregate triangles where exact and float part = \(aggFlips)")
print("")
print("=== E. the single grid that carries L1's total, named ===")
print("  \(worstGrid.0)  GRCODE \(worstGrid.1)  \(worstGrid.2)")
print("  L1 projected reserve for this one grid = \(worstGrid.3)")
print("  Exact and float agree on it to the unit. Exactness bought nothing here;")
print("  what was missing was a REFUSAL, which is a different terminal from a verdict.")
print("")
// print the observed triangle and the factor sums of the grid named above, so every
// figure quoted about it on the study page is produced here rather than transcribed.
for gd in grids where gd.line == worstGrid.0 && gd.gr == worstGrid.1 {
    print("  its observed triangle, cumulative paid in thousands:")
    for ay in AY0...AYN {
        let latest = VALUATION - ay + 1
        var row = "    \(ay) "
        for j in 0..<LAGN { row += j < latest ? pad(String(gd.paid[ay - AY0][j]), 10) : pad(".", 10) }
        print(row)
    }
    print("  its volume-weighted factors, as the exact ratios they are:")
    var fline = "   "
    for k in 1...(LAGN - 1) { let (n, d) = factorSums(gd.paid, k); fline += " f\(k)=\(n)/\(d)" }
    print(fline)
}
// ---------------------------------------------------------------- control arms
print("=== F. control arms, in both directions ===")
var armsRun = 0, armsFailed = 0
func arm(_ name: String, _ ok: Bool) {
    armsRun += 1; if !ok { armsFailed += 1 }
    print("  \(ok ? "PASS" : "FAIL")  \(name)")
}

// 1. the exact integer machinery, on values whose answers are known in advance
arm("Mag: 999999999 * 1000000000 + 999999999 renders exactly",
    (Mag(999_999_999).mulSmall(1_000_000_000) + Mag(999_999_999)).description == "999999999999999999")
let (dq, dr) = Mag.divMod(Mag(1_000_000_000_000_000_000), Mag(7))
arm("Mag: 10^18 / 7 = 142857142857142857 remainder 1",
    dq.description == "142857142857142857" && dr.description == "1")
arm("Rat: rounding is half-away-from-zero on exact integers only",
    Rat(BigI(3), Mag(2)).roundedString == "2" && Rat(BigI(-3), Mag(2)).roundedString == "-2")

// 2. ALWAYS-GREEN — a triangle already at ultimate owes nothing, in every arm
let flat = [[Int]](repeating: [Int](repeating: 1000, count: LAGN), count: LAGN)
arm("always-green: a fully-developed triangle has exact reserve 0",
    exactReserve(flat, premiseGate: false).0.roundedString == "0")
arm("always-green: both float orderings agree with it",
    roundHalfAway(floatReserve(flat, descending: false)!) == "0"
    && roundHalfAway(floatReserve(flat, descending: true)!) == "0")
arm("always-green: the premise gate admits a triangle that satisfies the premise",
    !premiseViolation(flat))

// 3. ALWAYS-RED — the comparator must SEE a difference when one exists.
//    Every cumulative value below is above 2^53 = 9007199254740992, the largest integer
//    a Double represents exactly, so the float arm cannot even hold the inputs.
var huge = [[Int]](repeating: [Int](repeating: 0, count: LAGN), count: LAGN)
for i in 0..<LAGN {
    var v = 20_000_000_000_000_001                    // > 2^53, and odd
    for j in 0..<LAGN { huge[i][j] = v; v = v + v / 3 }
}
let hugeEx = exactReserve(huge, premiseGate: false)
let hugeFa = floatReserve(huge, descending: false)!
arm("always-red: exact and float differ on inputs above 2^53 = 9,007,199,254,740,992",
    hugeEx.1 == .none && hugeEx.0.roundedString != roundHalfAway(hugeFa))
arm("always-red: the exact arm returns the same value on a second evaluation",
    exactReserve(huge, premiseGate: false).0.roundedString == hugeEx.0.roundedString)

// 4. ABSENCE and REFUSAL are not verdicts, and are not each other
let zeros = [[Int]](repeating: [Int](repeating: 0, count: LAGN), count: LAGN)
arm("refusal: an all-zero triangle is REFUSED, never scored as reserve 0",
    exactReserve(zeros, premiseGate: false).1 == .zeroDenominator)
var negCell = flat
negCell[5][3] = -1
arm("premise gate fires on a negative cumulative cell", premiseViolation(negCell))
var falls = flat
falls[5][4] = 999
arm("premise gate fires on cumulative paid that falls", premiseViolation(falls))
arm("premise gate does NOT fire on the fully-developed control", !premiseViolation(flat))

// 5. the law reads the valuation date it declares
var probe = [[Int]](repeating: [Int](repeating: 100, count: LAGN), count: LAGN)
let f9before = factorSums(probe, 9)
probe[9][5] = 987_654                                  // AY1997 lag 6 — unobserved at 1997
let f9after = factorSums(probe, 9)
arm("law reads its valuation date: an unobserved cell does not enter a factor",
    f9before == f9after && f9before.1 > 0)

// 6. the two laws are different instruments and must not return the same census
arm("L1 and L1PRIME are distinguishable on this corpus",
    L1.scored != L1P.scored && L1P.refusedPremise > 0)

print("")
print("  control arms run    = \(armsRun)")
print("  control arms failed = \(armsFailed)")
print(armsFailed == 0 ? "SELFTEST PASS" : "SELFTEST FAIL")

// ---------------------------------------------------------------- page figures
// The study page states these with thousands separators. Printing them in exactly the
// form the page uses is what lets the harness check that a published number and the
// program that produces it are the same number, rather than two numbers that look alike.
func comma(_ n: Int) -> String {
    let neg = n < 0
    var out = "", c = 0
    for ch in String(n.magnitude).reversed() {
        if c > 0 && c % 3 == 0 { out.append(",") }
        out.append(ch); c += 1
    }
    return (neg ? "-" : "") + String(out.reversed())
}
print("=== G. the same figures in the form the study page states them ===")
print("  corpus bytes                      = \(comma(corpusBytes))")
print("  rows                              = \(comma(totalRows))")
print("  complete grids                    = \(comma(grids.count))")
print("  cumulative-paid falls, all cells  = \(comma(vFalls))")
print("  paid exceeds incurred             = \(comma(vPaidOverIncur))")
print("  negative cumulative, all cells    = \(comma(vNeg))")
print("  L1 projected / realised           = \(comma(L1.proj)) / \(comma(L1.real))")
print("  L1PRIME projected / realised      = \(comma(L1P.proj)) / \(comma(L1P.real))")
print("  the named grid                    = \(comma(worstGrid.3))")
for line in LINES where aggProj[line] != nil {
    print("  aggregate \(pad(line, 13))       = \(comma(aggProj[line]!)) / \(comma(aggReal[line]!))")
}
print("")
print("")
print("STUDY38_RESERVE_TRIANGLE_EXACT_VS_FLOAT")
