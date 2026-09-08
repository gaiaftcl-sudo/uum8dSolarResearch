// Study 39 — The actuarial domain, exact against float.
//
// Study 38 measured property-and-casualty reserving. This one covers the rest of the
// domain on public archives: life, pensions, multi-state health, and aggregation at the
// discrete cuts a capital regime is written on.
//
// Every published input here is a FIXED-DECIMAL string, so every input is an exact
// rational before anything is computed. The exact arm never parses a decimal into a
// binary float: values are read as digit strings and carried as integers over a stated
// power of ten. The float arm exists to be graded and is confined to functions named
// *Float.
//
// The subject under grading is the arithmetic and the instrument. No person, insurer,
// pension scheme or country is assessed, and nothing here is advice.

import Foundation
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

// ---------------------------------------------------------------- fixed-decimal reading
// A published "0.00023" is the exact rational 23/100000 and a published "4.42" is 442/100.
// The digits are carried; nothing is parsed into a binary float anywhere in the exact arm.
struct Dec {
    let neg: Bool
    let digits: String      // all significant digits, decimal point removed
    let scale: Int          // number of digits after the point
    init?(_ s: String) {
        var t = s.trimmingCharacters(in: .whitespaces)
        if t.hasPrefix("-") { neg = true; t.removeFirst() } else { neg = false }
        if t.isEmpty { return nil }
        let parts = t.split(separator: ".", omittingEmptySubsequences: false)
        if parts.count > 2 { return nil }
        let ip = String(parts[0]), fp = parts.count == 2 ? String(parts[1]) : ""
        for c in ip + fp where !c.isNumber { return nil }
        if ip.isEmpty && fp.isEmpty { return nil }
        digits = (ip.isEmpty ? "0" : ip) + fp
        scale = fp.count
    }
    // the value times 10^toScale, as an exact integer. toScale must be >= scale.
    func scaled(to toScale: Int) -> Mag {
        precondition(toScale >= scale, "scaled() pads, it never truncates")
        var m = Mag(fromDigits: digits)
        if toScale > scale { for _ in 0..<(toScale - scale) { m = m.mulSmall(10) } }
        return m
    }
    var maxScale: Int { scale }
}

extension Mag {
    init(fromDigits s: String) {
        var acc = Mag(0)
        var chunk = ""
        for c in s {
            chunk.append(c)
            if chunk.count == 9 { acc = acc.mulSmall(1_000_000_000) + Mag(UInt64(chunk)!); chunk = "" }
        }
        if !chunk.isEmpty {
            var p: UInt64 = 1
            for _ in 0..<chunk.count { p *= 10 }
            acc = acc.mulSmall(p) + Mag(UInt64(chunk)!)
        }
        self = acc
    }
    // integer power, by repeated multiplication — the exponents here are small
    static func pow(_ b: Mag, _ e: Int) -> Mag {
        var r = Mag(1), base = b, n = e
        while n > 0 { if n & 1 == 1 { r = r * base }; base = base * base; n >>= 1 }
        return r
    }
}

// ---------------------------------------------------------------- Eurostat life tables
// The JSON is read as TEXT, not through a JSON decoder, because a decoder would turn
// "0.00023" into a binary double and the exactness would be gone before the law ran.
struct LifeTable {
    let geo: String, year: String
    var ageLabels: [Int] = []
    var probDeath: [Dec?] = [], probSurv: [Dec?] = [], survivors: [Dec?] = []
    var numberDying: [Dec?] = [], pyLived: [Dec?] = [], totPyLived: [Dec?] = []
    var lifeExp: [Dec?] = [], deathRate: [Dec?] = []
    var ages: Int { probDeath.count }
}

func slice(_ s: String, after: String, open: Character, close: Character) -> String? {
    guard let r = s.range(of: after) else { return nil }
    var depth = 0, out = "", started = false
    for ch in s[r.upperBound...] {
        if ch == open { depth += 1; started = true; if depth == 1 { continue } }
        if ch == close { depth -= 1; if depth == 0 { return out } }
        if started { out.append(ch) }
    }
    return nil
}

// "KEY":INT pairs from an index object, in key order by their integer position
func indexOrder(_ body: String) -> [String] {
    var pairs: [(String, Int)] = []
    var i = body.startIndex
    while let q1 = body[i...].firstIndex(of: "\"") {
        guard let q2 = body[body.index(after: q1)...].firstIndex(of: "\"") else { break }
        let key = String(body[body.index(after: q1)..<q2])
        guard let colon = body[q2...].firstIndex(of: ":") else { break }
        var numTxt = ""
        var j = body.index(after: colon)
        while j < body.endIndex, body[j] != "," , body[j] != "}" { numTxt.append(body[j]); j = body.index(after: j) }
        if let v = Int(numTxt.trimmingCharacters(in: .whitespaces)) { pairs.append((key, v)) }
        i = j
        if i >= body.endIndex { break }
    }
    return pairs.sorted { $0.1 < $1.1 }.map { $0.0 }
}

// "N":VALUE pairs from the value object, kept as decimal STRINGS
func valueMap(_ body: String) -> [Int: String] {
    var out: [Int: String] = [:]
    var i = body.startIndex
    while let q1 = body[i...].firstIndex(of: "\"") {
        guard let q2 = body[body.index(after: q1)...].firstIndex(of: "\"") else { break }
        let key = String(body[body.index(after: q1)..<q2])
        guard let colon = body[q2...].firstIndex(of: ":") else { break }
        var numTxt = ""
        var j = body.index(after: colon)
        while j < body.endIndex, body[j] != "," , body[j] != "}" { numTxt.append(body[j]); j = body.index(after: j) }
        if let k = Int(key) { out[k] = numTxt.trimmingCharacters(in: .whitespaces) }
        i = j
        if i >= body.endIndex { break }
    }
    return out
}

func readLifeTable(_ path: String, geo: String, year: String) -> LifeTable? {
    guard let txt = try? String(contentsOfFile: path, encoding: .utf8) else { return nil }
    guard let dimBody = slice(txt, after: "\"dimension\"", open: "{", close: "}") else { return nil }
    guard let indBlock = slice(dimBody, after: "\"indic_de\"", open: "{", close: "}"),
          let indIdx = slice(indBlock, after: "\"index\"", open: "{", close: "}"),
          let ageBlock = slice(dimBody, after: "\"age\"", open: "{", close: "}"),
          let ageIdx = slice(ageBlock, after: "\"index\"", open: "{", close: "}"),
          let valBody = slice(txt, after: "\"value\"", open: "{", close: "}") else { return nil }
    let inds = indexOrder(indIdx), ages = indexOrder(ageIdx)
    let vals = valueMap(valBody)
    // dimension order is freq, indic_de, sex, age, geo, time with sizes 1,n,1,m,1,1
    let nA = ages.count
    // The age dimension carries the single-year ladder AND aggregate categories beside it.
    // Y_GE85 is an aggregation, not an age; reading it as a missing age would delete every
    // younger age from the ladder. The ladder is built by NAME, in age order, and an
    // aggregate is excluded rather than counted absent.
    var ladder: [(pos: Int, age: Int)] = []
    for (i, a) in ages.enumerated() {
        if a == "Y_LT1" { ladder.append((i, 0)) }
        else if a.hasPrefix("Y_GE"), let v = Int(a.dropFirst(4)) { ladder.append((i, v + 10_000)) }
        else if a.hasPrefix("Y"), let v = Int(a.dropFirst(1)) { ladder.append((i, v)) }
    }
    // the open interval is the single largest Y_GE present; any other Y_GE is an aggregate
    let opens = ladder.filter { $0.age >= 10_000 }
    let maxOpen = opens.map { $0.age }.max() ?? -1
    ladder = ladder.filter { $0.age < 10_000 || $0.age == maxOpen }
    ladder.sort { ($0.age >= 10_000 ? 1 : 0, $0.age) < ($1.age >= 10_000 ? 1 : 0, $1.age) }
    var t = LifeTable(geo: geo, year: year)
    // A cell the archive does not serve is ELEMENT_MISSING and is carried as nil. It is
    // never substituted with a zero, and the count of absences is reported.
    func column(_ name: String) -> [Dec?] {
        guard let ii = inds.firstIndex(of: name) else { return [Dec?](repeating: nil, count: ladder.count) }
        var out: [Dec?] = []
        for step in ladder {
            let flat = ii * nA + step.pos
            if let s = vals[flat], let d = Dec(s) { out.append(d) } else { out.append(nil) }
        }
        return out
    }
    t.probDeath = column("PROBDEATH"); t.probSurv = column("PROBSURV")
    t.survivors = column("SURVIVORS"); t.numberDying = column("NUMBERDYING")
    t.pyLived = column("PYLIVED");     t.totPyLived = column("TOTPYLIVED")
    t.lifeExp = column("LIFEXP");      t.deathRate = column("DEATHRATE")
    t.ageLabels = ladder.map { $0.age }
    return t.probDeath.allSatisfy({ $0 == nil }) ? nil : t
}

// ---------------------------------------------------------------- the frozen laws
// Every actuarial present value below is a ratio of two exact integers, built over a
// COMMON denominator so that no rational addition is ever needed:
//
//   v = D/N with D = 10000 and N = 10000 + R for a published rate of R basis points
//   annuity-due   a(x) = SUM_t v^t * l(x+t)/l(x) = [ SUM_t D^t N^(K-t) L(x+t) ] / (N^K L(x))
//   assurance     A(x) = SUM_t v^(t+1) * d(x+t)/l(x) = [ SUM_t D^(t+1) N^(K-t-1) Dd(x+t) ] / (N^K L(x))
//   net premium   P(x) = A(x)/a(x) = ANum(x) / aNum(x)      — the denominators cancel exactly
//
// L and Dd are the published survivor and death columns scaled to whole numbers by their
// own published precision. K is one more than the deepest term, so no exponent is negative.

struct RateSet { let label: String; let bp: [Int] }   // basis points, exact integers

func premiumWeights(bpRate: Int, K: Int) -> (annuity: [Mag], assurance: [Mag], nK: Mag) {
    let D = Mag(10_000), N = Mag(UInt64(10_000 + bpRate))
    var Dp = [Mag](repeating: Mag(1), count: K + 2), Np = Dp
    for t in 1...(K + 1) { Dp[t] = Dp[t - 1] * D; Np[t] = Np[t - 1] * N }
    var wA = [Mag](), wB = [Mag]()
    for t in 0...K { wA.append(Dp[t] * Np[K - t]) }
    for t in 0..<K { wB.append(Dp[t + 1] * Np[K - t - 1]) }
    return (wA, wB, Np[K])
}

// exact round-half-away of num/den, both non-negative
func roundExact(_ num: Mag, _ den: Mag) -> Mag {
    let (q, _) = Mag.divMod(num.mulSmall(2) + den, den.mulSmall(2))
    return q
}

func roundHalfAwayD(_ x: Double) -> Int64 {
    if !x.isFinite || abs(x) >= 9.0e18 { return Int64.max }
    return Int64((x < 0 ? -1.0 : 1.0) * (abs(x) + 0.5).rounded(.down))
}

func pad(_ s: String, _ w: Int) -> String { s.count >= w ? s : String(repeating: " ", count: w - s.count) + s }
func comma(_ n: Int) -> String {
    let neg = n < 0; var out = "", c = 0
    for ch in String(n.magnitude).reversed() { if c > 0 && c % 3 == 0 { out.append(",") }; out.append(ch); c += 1 }
    return (neg ? "-" : "") + String(out.reversed())
}

// ---------------------------------------------------------------- corpus location
let GEOS = ["DE", "FR", "IT", "ES", "PL", "NL", "SE"]
let YEARS = ["2019", "2021", "2022"]

func locateActuarial() -> String? {
    let fm = FileManager.default
    var c = ["corpus/actuarial", "../actuarial", "../corpus/actuarial", "../../corpus/actuarial", "actuarial", "."]
    if CommandLine.arguments.count > 1 { c.insert(CommandLine.arguments[1], at: 0) }
    for d in c where fm.fileExists(atPath: d + "/lt_DE_2022.json") { return d }
    return nil
}
func locateScheduleP() -> String? {
    let fm = FileManager.default
    for d in ["corpus/schedule-p", "../schedule-p", "../corpus/schedule-p", "../../corpus/schedule-p"]
    where fm.fileExists(atPath: d + "/ppauto_pos.csv") { return d }
    return nil
}

// the published segment rates under IRC 417(e)(3)(D), read from the pinned page as
// decimal STRINGS and carried as exact basis points
func readSegmentRates(_ path: String) -> [(String, [Int])] {
    guard let txt = try? String(contentsOfFile: path, encoding: .utf8) else { return [] }
    var flat: [String] = []
    var tag = false, buf = ""
    for ch in txt {
        if ch == "<" { tag = true; let t = buf.trimmingCharacters(in: .whitespacesAndNewlines)
                       if !t.isEmpty { flat.append(t) }; buf = "" ; continue }
        if ch == ">" { tag = false; continue }
        if !tag { buf.append(ch) }
    }
    var out: [(String, [Int])] = []
    var i = 0
    while i + 3 < flat.count {
        let label = flat[i]
        let isMonth = label.count >= 5 && label.contains("-") && !label.contains(" ")
        if isMonth, let a = Dec(flat[i + 1]), let b = Dec(flat[i + 2]), let c = Dec(flat[i + 3]),
           a.scale == 2, b.scale == 2, c.scale == 2 {
            // a published "4.42" percent is 442 basis points, exactly
            let bps = [a, b, c].compactMap { Int($0.digits) }
            if bps.count == 3 { out.append((label, bps)) }
            i += 4
        } else { i += 1 }
    }
    return out
}

// ---------------------------------------------------------------- report
print("STUDY 39 — THE ACTUARIAL DOMAIN, EXACT AGAINST FLOAT")
print("Study 38 measured property-and-casualty reserving. This covers the rest of the domain:")
print("life, pensions, multi-state health, and aggregation at the discrete cuts a capital")
print("regime is written on. Every published input is fixed-decimal, therefore exact.")
print("Subject under grading: the arithmetic and the instrument. No person, insurer, scheme")
print("or country is assessed, and nothing here is advice.")
print("")

guard let ADIR = locateActuarial() else {
    print("CORPUS ABSENT — the Eurostat life tables were not found.")
    print("  expected: <corpus>/lt_{DE,FR,IT,ES,PL,NL,SE}_{2019,2021,2022}.json")
    print("  source  : https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/demo_mlifetable")
    print("REFERENCE FIGURES, restated so an absent corpus still shows them:")
    print("  life tables = 21, ages per table = 96, published indicators = 8")
    print("VERDICT: ELEMENT_MISSING — the archive answered with absence, which is not a MISS")
    exit(0)
}

var tables: [LifeTable] = []
for g in GEOS { for y in YEARS {
    if let t = readLifeTable(ADIR + "/lt_\(g)_\(y).json", geo: g, year: y) { tables.append(t) }
} }

print("=== A. what the published life tables are ===")
var minAges = 999, maxAges = 0, absentCells = 0
var scaleHist = [Int: Int]()
for t in tables {
    minAges = min(minAges, t.ages); maxAges = max(maxAges, t.ages)
    for col in [t.probDeath, t.probSurv, t.deathRate, t.survivors, t.numberDying, t.pyLived, t.totPyLived, t.lifeExp] {
        for d in col { if let d = d { scaleHist[d.scale, default: 0] += 1 } else { absentCells += 1 } }
    }
}
print("  life tables read                 = \(tables.count)")
print("  ages per table                   = \(minAges)\(minAges == maxAges ? "" : "-\(maxAges)")")
for k in scaleHist.keys.sorted() {
    print("  values published to \(k) decimal place(s) = \(scaleHist[k]!)")
}
print("  distinct published precisions    = \(scaleHist.count), every one of them finite")
print("  cells the archive does not serve = \(absentCells)   ELEMENT_MISSING, never a zero")
print("  Every published value is fixed-decimal, therefore an exact rational before any")
print("  arithmetic runs. That is a property of the archive, not of this program.")
print("")

print("=== B. the published tables against their own integer identities ===")
// Each identity is checked EXACTLY, in the published units, with no tolerance. Where a
// published rounding makes exact equality impossible the near-miss is counted separately
// rather than folded into a pass, because those are different answers.
var i1ok = 0, i1off = 0, i1skip = 0, i1near = 0
var i2ok = 0, i2off = 0, i2skip = 0
var i3ok = 0, i3off = 0, i3near = 0, i3skip = 0
for t in tables {
    let n = t.ages
    for x in 0..<(n - 1) {
        if let lx = t.survivors[x], let lx1 = t.survivors[x + 1], let dx = t.numberDying[x] {
            let sc = max(lx.scale, max(lx1.scale, dx.scale))
            let lhs1 = lx1.scaled(to: sc) + dx.scaled(to: sc), rhs1 = lx.scaled(to: sc)
            if lhs1 == rhs1 { i1ok += 1 } else {
                i1off += 1
                if (lhs1 < rhs1 ? rhs1 - lhs1 : lhs1 - rhs1) == Mag(1) { i1near += 1 }
            }
        } else { i1skip += 1 }
        if let tx = t.totPyLived[x], let tx1 = t.totPyLived[x + 1], let Lx = t.pyLived[x] {
            let sc = max(tx.scale, max(tx1.scale, Lx.scale))
            let lhs = tx1.scaled(to: sc) + Lx.scaled(to: sc), rhs = tx.scaled(to: sc)
            if lhs == rhs { i3ok += 1 } else {
                i3off += 1
                if (lhs < rhs ? rhs - lhs : lhs - rhs) == Mag(1) { i3near += 1 }   // one unit in the last published place
            }
        } else { i3skip += 1 }
    }
    for x in 0..<n {
        if let q = t.probDeath[x], let p = t.probSurv[x] {
            let sc = max(q.scale, p.scale)
            var one = Mag(1); for _ in 0..<sc { one = one.mulSmall(10) }
            if q.scaled(to: sc) + p.scaled(to: sc) == one { i2ok += 1 } else { i2off += 1 }
        } else { i2skip += 1 }
    }
}
print("  l(x+1) = l(x) - d(x)   : \(i1ok) hold exactly, \(i1off) do not, of which \(i1near) differ by exactly one published unit; \(i1skip) not testable")
print("  q(x) + p(x) = 1        : \(i2ok) hold exactly, \(i2off) do not, \(i2skip) not testable for absence")
print("  T(x) = T(x+1) + L(x)   : \(i3ok) hold exactly, \(i3off) do not, of which \(i3near) differ by exactly one published unit; \(i3skip) not testable")
print("")
// ---------------------------------------------------------------- rates
let rates = readSegmentRates(ADIR + "/irs-417e-segment-rates.html")
print("=== C. the published discount rates ===")
if rates.isEmpty {
    print("  ELEMENT_MISSING — the segment-rate page served no parsable triple")
} else {
    print("  published monthly segment-rate triples read = \(rates.count)")
    print("  most recent published month                = \(rates[0].0)")
    print("  its three segment rates, in exact basis points = \(rates[0].1.map(String.init).joined(separator: ", "))")
    print("  A rate published to two decimals is an exact rational: 4.42 percent is 442/10000.")
}
print("")

// integer columns for a table, at the table's own published precision
func intColumns(_ t: LifeTable) -> (L: [UInt64?], D: [UInt64?], scale: Int)? {
    var sc = 0
    for v in t.survivors + t.numberDying { if let v = v { sc = max(sc, v.scale) } }
    var L = [UInt64?](), D = [UInt64?]()
    for i in 0..<t.ages {
        if let s = t.survivors[i], let m = UInt64(s.scaled(to: sc).description) { L.append(m) } else { L.append(nil) }
        if let d = t.numberDying[i], let m = UInt64(d.scaled(to: sc).description) { D.append(m) } else { D.append(nil) }
    }
    return (L, D, sc)
}


// The finest decimal resolution at which the exact value and the float value still agree.
// A verdict test at one fixed reporting unit cannot tell "they agree" from "the unit is too
// coarse to show a difference"; this returns the digit at which they first part, or 19 if
// they never part inside the range a Double can even represent.
// How many leading significant digits the exact value and the floating-point value share.
//
// A first version of this compared the two values ROUNDED at each digit, and that instrument
// was wrong in a way worth recording: an exact value whose decimal expansion terminates in a
// 5 sits exactly on a rounding tie, so the exact arm rounds half-away up while the float sits
// infinitesimally below and rounds down. It reported a parting at the 8th digit for two values
// agreeing to the 16th. The tie is a property of the decimal expansion, not of the arithmetic.
//
// This version compares nothing rounded. A Double is a binary rational exactly — sig * 2^e from
// its own bit pattern — so the relative difference is a ratio of two integers and the answer is
// the largest k with |exact - float| * 10^k <= |exact|. Returns 0..20, or -1 when the exact
// value is zero and a relative difference is not defined.
func exactRational(of d: Double) -> (sig: Mag, twoExp: Int)? {
    if !d.isFinite || d == 0 { return nil }
    let bits = d.magnitude.bitPattern
    let expBits = Int((bits >> 52) & 0x7FF)
    let frac = bits & 0x000F_FFFF_FFFF_FFFF
    if expBits == 0 { return (Mag(frac), -1074) }                 // subnormal
    return (Mag(frac | (1 << 52)), expBits - 1075)
}

func agreeingSignificantDigits(num: Mag, den: Mag, f: Double) -> Int {
    if num.isZero { return -1 }
    guard let (sig, e) = exactRational(of: f) else { return -1 }
    // exact = num/den, float = sig * 2^e. Put both over one denominator.
    //   e >= 0 : float = sig*2^e            -> lhs = num,        rhs = sig*2^e*den, scale = num
    //   e <  0 : float = sig/2^(-e)         -> lhs = num*2^(-e), rhs = sig*den,     scale = num*2^(-e)
    var lhs = num, rhs = sig, scale = num
    if e >= 0 {
        rhs = sig * Mag.pow(Mag(2), e) * den
    } else {
        let Q = Mag.pow(Mag(2), -e)
        lhs = num * Q; scale = lhs
        rhs = sig * den
    }
    let diff = lhs < rhs ? rhs - lhs : lhs - rhs
    if diff.isZero { return 20 }                                   // identical rationals
    var k = 0
    var scaled = diff
    while k < 20 {
        let next = scaled.mulSmall(10)
        if scale < next { break }
        scaled = next; k += 1
    }
    return k
}

struct ArmCount {
    var scored = 0; var differ = 0; var worst = 0; var skipped = 0; var maxDepth = 0
    var part = [Int: Int]()          // histogram of the first parting digit
    var minPart = 19
}

print("=== D. life assurance: the net premium, exact against float ===")
print("  whole-life assurance over a whole-life annuity-due, per 100,000 sum assured,")
print("  at each of the three published segment rates. The denominators cancel exactly,")
print("  so the exact premium is a ratio of two integers and nothing is rounded until the")
print("  reporting unit.")
var lifeArm = ArmCount()
let rateSet: [Int] = rates.isEmpty ? [442, 547, 631] : rates[0].1
for t in tables {
    guard let (L, Dd, _) = intColumns(t) else { continue }
    let n = t.ages, K = n
    for bp in rateSet {
        let (wA, wB, _) = premiumWeights(bpRate: bp, K: K)
        let vD = 10000.0 / Double(10000 + bp)
        for x in 0..<n {
            var ok = true
            for i in x..<n where L[i] == nil || Dd[i] == nil { ok = false }
            if !ok || L[x] == nil || L[x]! == 0 { lifeArm.skipped += 1; continue }
            var aNum = Mag(0), ANum = Mag(0)
            for t2 in 0...(n - 1 - x) {
                aNum = aNum + wA[t2].mulSmall(L[x + t2]!)
                ANum = ANum + wB[t2].mulSmall(Dd[x + t2]!)
            }
            if aNum.isZero { lifeArm.skipped += 1; continue }
            let exactP = roundExact(ANum.mulSmall(100_000), aNum)
            var aF = 0.0, AF = 0.0, vp = 1.0
            for t2 in 0...(n - 1 - x) {
                aF += vp * Double(L[x + t2]!) / Double(L[x]!)
                AF += vp * vD * Double(Dd[x + t2]!) / Double(L[x]!)
                vp *= vD
            }
            let floatP = roundHalfAwayD(100_000.0 * AF / aF)
            let pd = agreeingSignificantDigits(num: ANum, den: aNum, f: AF / aF)
            lifeArm.part[pd, default: 0] += 1; lifeArm.minPart = min(lifeArm.minPart, pd)
            lifeArm.scored += 1
            lifeArm.maxDepth = max(lifeArm.maxDepth, n - 1 - x)
            if let e = Int(exactP.description) {
                if Int64(e) != floatP { lifeArm.differ += 1; lifeArm.worst = max(lifeArm.worst, abs(e - Int(floatP))) }
            }
        }
    }
}
print("  ages scored across 21 tables x 3 rates = \(lifeArm.scored)")
print("  ages not scored, a tail cell absent    = \(lifeArm.skipped)")
print("  exact and float premiums differing     = \(lifeArm.differ)")
print("  worst difference, per 100,000 assured  = \(lifeArm.worst)")
print("  deepest term reached                   = \(lifeArm.maxDepth) discount multiplications")
print("  leading significant digits on which exact and float agree (20 = identical rationals):")
for k in lifeArm.part.keys.sorted() { print("    agreeing to \(k) significant digits: \(comma(lifeArm.part[k]!)) cases") }
print("")
print("=== E. pensions: the deferred annuity, exact against float ===")
print("  the lump sum per 1,000 of annual pension deferred to age 65 and paid for life,")
print("  which is the shape the minimum-present-value rule is written on, at the same")
print("  three published segment rates.")
var penArm = ArmCount()
let RETIRE = 65
for t in tables {
    guard let (L, _, _) = intColumns(t) else { continue }
    let n = t.ages, K = n
    for bp in rateSet {
        let (wA, _, nK) = premiumWeights(bpRate: bp, K: K)
        let vD = 10000.0 / Double(10000 + bp)
        for x in 20..<min(RETIRE, n) {
            guard let lx = L[x], lx > 0 else { penArm.skipped += 1; continue }
            var ok = true
            for i in x..<n where L[i] == nil { ok = false }
            if !ok { penArm.skipped += 1; continue }
            let t0 = RETIRE - x
            if t0 > n - 1 - x { penArm.skipped += 1; continue }
            var num = Mag(0)
            for t2 in t0...(n - 1 - x) { num = num + wA[t2].mulSmall(L[x + t2]!) }
            let den = nK.mulSmall(lx)
            let exactV = roundExact(num.mulSmall(1_000), den)
            var acc = 0.0, vp = 1.0
            for _ in 0..<t0 { vp *= vD }
            for t2 in t0...(n - 1 - x) { acc += vp * Double(L[x + t2]!) / Double(lx); vp *= vD }
            let floatV = roundHalfAwayD(1_000.0 * acc)
            let pdp = agreeingSignificantDigits(num: num, den: den, f: acc)
            penArm.part[pdp, default: 0] += 1; penArm.minPart = min(penArm.minPart, pdp)
            penArm.scored += 1
            penArm.maxDepth = max(penArm.maxDepth, n - 1 - x)
            if let e = Int(exactV.description), Int64(e) != floatV {
                penArm.differ += 1; penArm.worst = max(penArm.worst, abs(e - Int(floatV)))
            }
        }
    }
}
print("  entry ages scored                      = \(penArm.scored)")
print("  entry ages not scored                  = \(penArm.skipped)")
print("  exact and float values differing       = \(penArm.differ)")
print("  worst difference, per 1,000 of pension = \(penArm.worst)")
print("  deepest term reached                   = \(penArm.maxDepth) discount multiplications")
print("  leading significant digits on which exact and float agree (20 = identical rationals):")
for k in penArm.part.keys.sorted() { print("    agreeing to \(k) significant digits: \(comma(penArm.part[k]!)) cases") }
print("")

print("=== F. multi-state: the n-step survival chain, exact against float ===")
print("  a life table is a two-state Markov chain and its n-step transition is an exact")
print("  product of published rationals. Reported in parts per billion.")
var mkArm = ArmCount()
var worstChain = "none"
for t in tables {
    let n = t.ages
    // The chain runs to the last CLOSED age. The published table's open interval carries
    // q = 1 exactly, so any chain passing through it terminates with probability exactly
    // zero — a true statement about the table, and one that measures nothing about
    // arithmetic. Excluding it is what makes this arm able to fail.
    for x in 0..<(n - 1) {
        var num = Mag(1), steps = 0, ok = true
        var fp = 1.0
        for i in x..<(n - 1) {
            guard let q = t.probDeath[i], q.scale <= 5 else { ok = false; break }
            let qs = q.scaled(to: 5)
            let hundredK = Mag(100_000)
            if hundredK < qs { ok = false; break }
            num = num * (hundredK - qs)
            fp *= (100000.0 - Double(qs.description)!) / 100000.0
            steps += 1
        }
        if !ok || steps == 0 { mkArm.skipped += 1; continue }
        var den = Mag(1)
        for _ in 0..<steps { den = den.mulSmall(100_000) }
        let exactPPB = roundExact(num.mulSmall(1_000_000_000), den)
        let floatPPB = roundHalfAwayD(1_000_000_000.0 * fp)
        let pdm = agreeingSignificantDigits(num: num, den: den, f: fp)
        mkArm.part[pdm, default: 0] += 1
        if pdm >= 0 && pdm < mkArm.minPart {
            mkArm.minPart = pdm
            worstChain = "\(t.geo) \(t.year), from age \(t.ageLabels[x] >= 10_000 ? t.ageLabels[x] - 10_000 : t.ageLabels[x]), \(steps) steps"
        }
        mkArm.scored += 1
        mkArm.maxDepth = max(mkArm.maxDepth, steps)
        if let e = Int(exactPPB.description), Int64(e) != floatPPB {
            mkArm.differ += 1; mkArm.worst = max(mkArm.worst, abs(e - Int(floatPPB)))
        }
    }
}
print("  chains scored                          = \(mkArm.scored)")
print("  exact and float differing              = \(mkArm.differ)")
print("  worst difference, parts per billion    = \(mkArm.worst)")
print("  longest chain                          = \(mkArm.maxDepth) steps, ending at the last closed age")
print("  leading significant digits on which exact and float agree (20 = identical rationals):")
for k in mkArm.part.keys.sorted() { print("    agreeing to \(k) significant digits: \(comma(mkArm.part[k]!)) cases") }
print("  fewest agreeing digits anywhere in this arm: \(mkArm.minPart), in \(worstChain)")
print("  A THREE-STATE morbidity chain is NOT measured here and is not claimed. The")
print("  transition rates it needs are not served by an open archive: the SOA MORT tables")
print("  are behind a postback application that returns HTML to a direct request, and the")
print("  Human Mortality Database returns a login page. Both were measured 2026-09-08.")
print("  That is ABSENT — a fact about the archives, not a result about morbidity.")
print("")
print("=== G. aggregation: does the order of the sum change the total ===")
print("  a capital figure is a sum over many positions, and addition in floating point is")
print("  not associative. The same law, the same data, three orderings.")
if let SP = locateScheduleP() {
    var vals: [Int] = []
    for line in ["ppauto_pos", "comauto_pos", "wkcomp_pos", "othliab_pos", "medmal_pos", "prodliab_pos"] {
        guard let txt = try? String(contentsOfFile: SP + "/" + line + ".csv", encoding: .utf8) else { continue }
        var byCo: [Int: [Int: [Int: Int]]] = [:]
        for (i, ln) in txt.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" || $0 == "\r" }).enumerated() {
            if i == 0 { continue }
            let f = ln.split(separator: ",", omittingEmptySubsequences: false).map(String.init)
            if f.count < 12 { continue }
            guard let gr = Int(f[0]), let ay = Int(f[2]), let lag = Int(f[4]), let paid = Int(f[6]) else { continue }
            byCo[gr, default: [:]][ay, default: [:]][lag] = paid
        }
        for (_, g) in byCo {
            var r = 0, ok = true
            for ay in 1988...1997 {
                let latest = 1997 - ay + 1
                guard let a = g[ay]?[10], let b = g[ay]?[latest] else { ok = false; break }
                r += a - b
            }
            if ok { vals.append(r) }
        }
    }
    let exactTotal = vals.reduce(0, +)
    var asc = vals.sorted(), desc = vals.sorted(by: >)
    func fsum(_ a: [Int]) -> Double { var s = 0.0; for v in a { s += Double(v) }; return s }
    let fFiled = fsum(vals), fAsc = fsum(asc), fDesc = fsum(desc)
    var distinct = Set<String>()
    for v in [fFiled, fAsc, fDesc] { distinct.insert(String(format: "%.10f", v)) }
    print("  values summed                          = \(vals.count) filed integers")
    print("  the exact total, one value             = \(comma(exactTotal))")
    print("  distinct float totals across 3 orders  = \(distinct.count)")
    let spread = max(max(fFiled, fAsc), fDesc) - min(min(fFiled, fAsc), fDesc)
    print("  spread between float orderings         = \(roundHalfAwayD(spread)) unit(s)")
    print("  float total equals the exact total     = \(roundHalfAwayD(fFiled) == Int64(exactTotal))")
    let biggest = vals.map { abs($0) }.max() ?? 0
    print("  largest single value                   = \(comma(biggest))")
    print("  the exact-integer ceiling of a Double  = 9,007,199,254,740,992")
    print("  Every value and the running total sit below that ceiling, so each addition is")
    print("  exact and the ordering cannot matter. That is a statement about magnitude, and")
    print("  the always-red arm below shows the same code parting once the ceiling is passed.")
    asc = []; desc = []
} else {
    print("  ELEMENT_MISSING — the Schedule P corpus was not found beside this one.")
    print("  It is the corpus of Study 38 and lives at corpus/schedule-p.")
}
print("")
// ---------------------------------------------------------------- control arms
print("=== H. control arms, in both directions ===")
var armsRun = 0, armsFailed = 0
func arm(_ name: String, _ ok: Bool) {
    armsRun += 1; if !ok { armsFailed += 1 }
    print("  \(ok ? "PASS" : "FAIL")  \(name)")
}

// 1 — the exact integer machinery
arm("Mag: 10^18 / 7 = 142857142857142857 remainder 1",
    Mag.divMod(Mag(1_000_000_000_000_000_000), Mag(7)).0.description == "142857142857142857"
    && Mag.divMod(Mag(1_000_000_000_000_000_000), Mag(7)).1.description == "1")
arm("Mag.pow: 10^19 has twenty characters", Mag.pow(Mag(10), 19).description.count == 20)
arm("roundExact is half-away: 3/2 -> 2 and 1/2 -> 1",
    roundExact(Mag(3), Mag(2)).description == "2" && roundExact(Mag(1), Mag(2)).description == "1")

// 2 — the fixed-decimal reader keeps digits, and refuses what is not a decimal
arm("Dec reads 0.00023 as 23 at scale 5", Dec("0.00023")!.digits == "000023" && Dec("0.00023")!.scale == 5)
arm("Dec reads 4.42 as 442 at scale 2", Dec("4.42")!.digits == "442" && Dec("4.42")!.scale == 2)
arm("Dec reads a bare integer at scale 0", Dec("100000")!.scale == 0)
arm("Dec refuses a non-decimal", Dec("abc") == nil && Dec("1.2.3") == nil && Dec("") == nil)
arm("scaled() pads and never truncates", Dec("4.42")!.scaled(to: 5).description == "442000")

// 3 — the age ladder excludes an aggregate rather than counting it absent
if let t0 = tables.first {
    let single = t0.ageLabels.filter { $0 < 10_000 }
    let terminal = t0.ageLabels.filter { $0 >= 10_000 }
    arm("age ladder is contiguous from 0 with one terminal open interval",
        single == Array(0...(single.count - 1)) && terminal.count == 1)
    arm("age ladder holds 96 steps, not the 97 categories the archive serves",
        t0.ageLabels.count == 96)
} else { arm("age ladder checks require a table", false) }

// 4 — ALWAYS-GREEN: a table nobody dies in
var greenL = [UInt64?](repeating: 100_000, count: 20), greenD = [UInt64?](repeating: 0, count: 20)
do {
    let K = 20
    let (wA, wB, _) = premiumWeights(bpRate: 442, K: K)
    var aNum = Mag(0), ANum = Mag(0)
    for t2 in 0..<20 { aNum = aNum + wA[t2].mulSmall(greenL[t2]!); ANum = ANum + wB[t2].mulSmall(greenD[t2]!) }
    arm("always-green: with no deaths the assurance numerator is exactly zero", ANum.isZero)
    arm("always-green: the annuity numerator is not zero", !aNum.isZero)
}

// 5 — ALWAYS-RED: the premium comparator must part once the inputs pass 2^53
do {
    let K = 12
    let (wA, wB, _) = premiumWeights(bpRate: 442, K: K)
    var L = [UInt64](), D = [UInt64]()
    var v: UInt64 = 900_000_000
    for _ in 0..<12 { L.append(v); D.append(v / 7 + 1); v = v * 3 / 4 }
    var aNum = Mag(0), ANum = Mag(0)
    var aF = 0.0, AF = 0.0, vp = 1.0
    let vD = 10000.0 / 10442.0
    for t2 in 0..<12 {
        // scale each term past the exactly-representable range of a Double
        let big = Mag(L[t2]).mulSmall(20_000_000)
        aNum = aNum + wA[t2] * big
        ANum = ANum + wB[t2] * Mag(D[t2]).mulSmall(20_000_000)
        aF += vp * Double(L[t2]) * 20_000_000.0
        AF += vp * vD * Double(D[t2]) * 20_000_000.0
        vp *= vD
    }
    let d = agreeingSignificantDigits(num: ANum, den: aNum, f: AF / aF)
    arm("always-red: agreement is finite, not identical, on inputs past 2^53", d >= 0 && d < 20)
}

// 6 — ALWAYS-RED: the parting instrument on a case whose answer is known in advance
do {
    let dThird = agreeingSignificantDigits(num: Mag(1), den: Mag(3), f: 1.0 / 3.0)
    arm("always-red: exact 1/3 against Double(1/3) agrees to 15-17 digits, not more",
        dThird >= 15 && dThird <= 17)
    let dWrong = agreeingSignificantDigits(num: Mag(1), den: Mag(3), f: 0.34)
    arm("always-red: exact 1/3 against 0.34 agrees to at most 1 significant digit", dWrong <= 1)
    let dSame = agreeingSignificantDigits(num: Mag(1), den: Mag(4), f: 0.25)
    arm("always-green: exact 1/4 against 0.25 is the identical rational", dSame == 20)
}

// 7 — ALWAYS-RED: aggregation order does part once the ceiling is passed
do {
    var big: [Double] = [9_007_199_254_740_993.0]
    for _ in 0..<200 { big.append(1.0) }
    var up = 0.0; for v in big { up += v }
    var down = 0.0; for v in big.reversed() { down += v }
    arm("always-red: the same 201 values summed both ways differ once past 2^53", up != down)
}

// 8 — the zero sentinel is a distinct answer, not agreement
do {
    let z = agreeingSignificantDigits(num: Mag(0), den: Mag(7), f: 0.0)
    arm("a value of exactly zero returns the not-measurable sentinel, never a digit count", z == -1)
    // the tie that broke the first instrument: 0.636038925 terminates in a 5 at digit 9
    let tie = agreeingSignificantDigits(num: Mag(6_360_389_250), den: Mag(10_000_000_000),
                                        f: (100000.0 - 19310.0) / 100000.0 * ((100000.0 - 21175.0) / 100000.0))
    arm("the rounding tie that fooled the first instrument agrees to 15 digits or more, not 8",
        tie >= 15)
}

// 9 — the identity checks are testing something
arm("identity arm ran on every published age", i2ok + i2off == 2016)
arm("the three identity arms do not all return the same census",
    !(i1ok == i2ok && i2ok == i3ok))

print("")
print("  control arms run    = \(armsRun)")
print("  control arms failed = \(armsFailed)")
print(armsFailed == 0 ? "SELFTEST PASS" : "SELFTEST FAIL")
print("")
print("=== I. the same figures in the form the study page states them ===")
func minKey(_ h: [Int: Int]) -> Int { h.keys.filter { $0 >= 0 }.min() ?? -1 }
print("  life tables                            = \(comma(tables.count))")
print("  published values read                  = \(comma(scaleHist.values.reduce(0, +)))")
print("  cells the archive does not serve       = \(absentCells)")
print("  q(x) + p(x) = 1, exact / not           = \(comma(i2ok)) / \(i2off)")
print("  l(x+1) = l(x) - d(x), exact / not / one-unit = \(comma(i1ok)) / \(comma(i1off)) / \(comma(i1near))")
print("  T(x) = T(x+1) + L(x), exact / not / one-unit = \(comma(i3ok)) / \(comma(i3off)) / \(comma(i3near))")
print("  identity tests run in total            = \(comma(i1ok + i1off + i3ok + i3off)) across the two accumulation identities")
print("  segment-rate triples                   = \(comma(rates.count))")
print("  life premiums scored                   = \(comma(lifeArm.scored)), fewest agreeing significant digits \(minKey(lifeArm.part))")
print("  pension values scored                  = \(comma(penArm.scored)), fewest agreeing significant digits \(minKey(penArm.part))")
print("  survival chains scored                 = \(comma(mkArm.scored)), fewest agreeing significant digits \(minKey(mkArm.part))")
print("  verdicts differing at the reporting unit = \(lifeArm.differ + penArm.differ + mkArm.differ) of \(comma(lifeArm.scored + penArm.scored + mkArm.scored))")
print("")
print("STUDY39_ACTUARIAL_DOMAIN_EXACT_VS_FLOAT")
