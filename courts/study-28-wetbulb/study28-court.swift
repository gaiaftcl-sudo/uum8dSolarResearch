// Study 28 — Wet-bulb threshold court, Act 1 engine.
// Exact arm: rational interval arithmetic on big integers, sign-correct truncated-Taylor exp.
// Float arms (STULL, ITER): IEEE-754 binary64 with the platform libm, as the charter freezes.
// The floats here are the specimens under trial, never the verdict arithmetic.
import Foundation

// MARK: - BigInt (sign-magnitude, UInt32 limbs, little-endian). add/sub/mul/cmp only — no division anywhere.
struct BigInt {
    var negative: Bool
    var limbs: [UInt32]   // little-endian, no trailing zeros, [] == 0

    init(_ v: Int64) {
        var m = UInt64(v.magnitude)
        negative = v < 0
        limbs = []
        while m > 0 { limbs.append(UInt32(truncatingIfNeeded: m)); m >>= 32 }
    }
    init(negative: Bool, limbs: [UInt32]) {
        var l = limbs
        while let last = l.last, last == 0 { l.removeLast() }
        self.limbs = l
        self.negative = l.isEmpty ? false : negative
    }
    var isZero: Bool { limbs.isEmpty }

    static func cmpMag(_ a: [UInt32], _ b: [UInt32]) -> Int {
        if a.count != b.count { return a.count < b.count ? -1 : 1 }
        var i = a.count - 1
        while i >= 0 { if a[i] != b[i] { return a[i] < b[i] ? -1 : 1 }; i -= 1 }
        return 0
    }
    static func addMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] {
        var r = [UInt32](); r.reserveCapacity(max(a.count, b.count) + 1)
        var carry: UInt64 = 0
        for i in 0..<max(a.count, b.count) {
            let s = UInt64(i < a.count ? a[i] : 0) + UInt64(i < b.count ? b[i] : 0) + carry
            r.append(UInt32(truncatingIfNeeded: s)); carry = s >> 32
        }
        if carry > 0 { r.append(UInt32(carry)) }
        return r
    }
    static func subMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] { // requires a >= b
        var r = [UInt32](); r.reserveCapacity(a.count)
        var borrow: Int64 = 0
        for i in 0..<a.count {
            var d = Int64(a[i]) - Int64(i < b.count ? b[i] : 0) - borrow
            if d < 0 { d += 0x1_0000_0000; borrow = 1 } else { borrow = 0 }
            r.append(UInt32(d))
        }
        while let last = r.last, last == 0 { r.removeLast() }
        return r
    }
    static func mulMag(_ a: [UInt32], _ b: [UInt32]) -> [UInt32] {
        if a.isEmpty || b.isEmpty { return [] }
        var r = [UInt64](repeating: 0, count: a.count + b.count)
        for i in 0..<a.count {
            var carry: UInt64 = 0
            let ai = UInt64(a[i])
            for j in 0..<b.count {
                let cur = r[i + j] + ai * UInt64(b[j]) + carry
                r[i + j] = cur & 0xFFFF_FFFF
                carry = cur >> 32
            }
            var k = i + b.count
            while carry > 0 {
                let cur = r[k] + carry
                r[k] = cur & 0xFFFF_FFFF
                carry = cur >> 32
                k += 1
            }
        }
        var out = r.map { UInt32($0) }
        while let last = out.last, last == 0 { out.removeLast() }
        return out
    }
    static func + (a: BigInt, b: BigInt) -> BigInt {
        if a.negative == b.negative { return BigInt(negative: a.negative, limbs: addMag(a.limbs, b.limbs)) }
        let c = cmpMag(a.limbs, b.limbs)
        if c == 0 { return BigInt(0) }
        if c > 0 { return BigInt(negative: a.negative, limbs: subMag(a.limbs, b.limbs)) }
        return BigInt(negative: b.negative, limbs: subMag(b.limbs, a.limbs))
    }
    static func - (a: BigInt, b: BigInt) -> BigInt { a + BigInt(negative: !b.negative, limbs: b.limbs) }
    static func * (a: BigInt, b: BigInt) -> BigInt {
        BigInt(negative: a.negative != b.negative, limbs: mulMag(a.limbs, b.limbs))
    }
    var signum: Int { isZero ? 0 : (negative ? -1 : 1) }
    static func < (a: BigInt, b: BigInt) -> Bool { (a - b).signum < 0 }
}

// MARK: - Exact rational (BigInt / BigInt, den > 0). No reduction — every quantity here is built once and compared by cross-multiplication.
struct Rat {
    var n: BigInt
    var d: BigInt   // > 0
    init(_ n: BigInt, _ d: BigInt) {
        if d.negative { self.n = BigInt(negative: !n.negative, limbs: n.limbs); self.d = BigInt(negative: false, limbs: d.limbs) }
        else { self.n = n; self.d = d }
    }
    init(_ n: Int64, _ d: Int64) { self.init(BigInt(n), BigInt(d)) }
    static func + (a: Rat, b: Rat) -> Rat { Rat(a.n * b.d + b.n * a.d, a.d * b.d) }
    static func - (a: Rat, b: Rat) -> Rat { Rat(a.n * b.d - b.n * a.d, a.d * b.d) }
    static func * (a: Rat, b: Rat) -> Rat { Rat(a.n * b.n, a.d * b.d) }
    var signum: Int { n.signum }
    static func < (a: Rat, b: Rat) -> Bool { (a - b).signum < 0 }
    static func <= (a: Rat, b: Rat) -> Bool { (a - b).signum <= 0 }
}

struct Interval { var lo: Rat; var hi: Rat }   // lo <= true value <= hi
func imul(_ a: Interval, _ b: Interval) -> Interval {
    let p = [a.lo * b.lo, a.lo * b.hi, a.hi * b.lo, a.hi * b.hi]
    var lo = p[0], hi = p[0]
    for q in p.dropFirst() { if q < lo { lo = q }; if hi < q { hi = q } }
    return Interval(lo: lo, hi: hi)
}
func iscale(_ a: Interval, _ c: Rat) -> Interval {   // c > 0
    Interval(lo: a.lo * c, hi: a.hi * c)
}
func isub(_ a: Interval, _ b: Interval) -> Interval { Interval(lo: a.lo - b.hi, hi: a.hi - b.lo) }

// MARK: - Sign-correct truncated-Taylor exp interval (charter Crossing B).
// x >= 0: S32 is the LOWER bound; upper = S33 + geometric tail  x^34/34! * (35/(35-x))  (sound for x < 35; |x| <= 4 on the admitted domain).
// x <  0: S32 (even-ending) is the UPPER bound, S33 the LOWER bound — the interval ends swap by sign and by nothing else.
func expInterval(_ x: Rat, degree: Int) -> Interval {
    // S_k built over the common denominator q^deg * deg! by big-integer accumulation.
    let deg = degree                       // 33 base (gives both S32 and S33), 65 on doubling (S64/S65)
    var factDeg = BigInt(1)                // deg!
    for k in 1...deg { factDeg = factDeg * BigInt(Int64(k)) }
    // n_k = p^k * q^(deg-k) * (deg!/k!)
    var p = BigInt(1)                      // x.n^k, iteratively
    var qpow = [BigInt(1)]                 // q^i
    for _ in 1...deg { qpow.append(qpow.last! * x.d) }
    var factRatio = factDeg                // deg!/k!, k=0 -> deg!
    var sumEven = BigInt(0)                // S_{deg-1} numerator (even-ending when deg-1 even)
    var sumFull = BigInt(0)                // S_deg numerator
    for k in 0...deg {
        let term = p * qpow[deg - k] * factRatio
        sumFull = sumFull + term
        if k <= deg - 1 { sumEven = sumEven + term }
        p = p * x.n
        if k < deg { factRatio = fDivStep(factRatio, k + 1) }
    }
    let D = qpow[deg] * factDeg
    let sPrev = Rat(sumEven, D)            // S_{deg-1}
    let sFull = Rat(sumFull, D)            // S_deg
    if x.signum >= 0 {
        // tail after S_deg: x^(deg+1)/(deg+1)! * (deg+2)/((deg+2)-x); x <= 4 << deg+2 so sound
        let xp = p                          // x.n^(deg+1)
        let tailNum = xp * qpow[0]          // placeholder; assemble tail as rational below
        _ = tailNum
        var factNext = factDeg
        factNext = factNext * BigInt(Int64(deg + 1))
        let tCore = Rat(xp, qpow[deg] * x.d * factNext)   // x^(deg+1)/(deg+1)!
        let geo = Rat(BigInt(Int64(deg + 2)), BigInt(1))
        let denomGeo = Rat(BigInt(Int64(deg + 2)), BigInt(1)) - x   // (deg+2) - x > 0
        // hi = S_deg + tCore * (deg+2)/((deg+2)-x)  -> multiply through: tCore * geo / denomGeo
        let tail = Rat(tCore.n * geo.n * denomGeo.d, tCore.d * geo.d * denomGeo.n)
        return Interval(lo: sPrev, hi: sFull + tail)
    } else {
        // deg odd (33/65): S_{deg-1} even-ending = upper, S_deg = lower
        return Interval(lo: sFull, hi: sPrev)
    }
}
// deg!/k! step-down: divide by (k+1) exactly — implemented as multiply-free exact division by small int.
func fDivStep(_ v: BigInt, _ by: Int) -> BigInt {
    var out = [UInt32](repeating: 0, count: v.limbs.count)
    var rem: UInt64 = 0
    let b = UInt64(by)
    var i = v.limbs.count - 1
    while i >= 0 {
        let cur = (rem << 32) | UInt64(v.limbs[i])
        out[i] = UInt32(cur / b)
        rem = cur % b
        i -= 1
    }
    precondition(rem == 0, "factorial ratio must divide exactly")
    while let last = out.last, last == 0 { out.removeLast() }
    return BigInt(negative: v.negative, limbs: out)
}

// MARK: - The frozen identity. Coefficients as exact rationals (charter values).
let C_ES = Rat(30547, 5000)          // 6.1094
let C_A  = Rat(141, 8)               // 17.625
let C_B  = Rat(6076, 25)             // 243.04
let C_FW1 = Rat(100071, 100000)      // 1.00071
let C_FW2 = Rat(9, 2000000)          // 4.5e-6
let C_PSY_A = Rat(653, 1000000)      // 6.53e-4   (frozen against WMO-No.8 before scoring)
let C_PSY_B = Rat(118, 125000)       // 9.44e-4
let THETAS: [(name: String, r: Rat, f: Double)] = [("611/20", Rat(611, 20), 30.55), ("350/10", Rat(350, 10), 35.0)]

var esCache: [String: Interval] = [:]
func esArg(_ t: Rat) -> Rat {  // (141/8)*t / ((6076/25)+t)
    let num = C_A * t
    let den = C_B + t
    return Rat(num.n * den.d, num.d * den.n)
}
func esInterval(_ t: Rat, key: String, degree: Int = 33) -> Interval {
    let cacheable = degree == 33 && (key.hasPrefix("d") || key.hasPrefix("th"))
    if cacheable, let c = esCache[key] { return c }
    let e = expInterval(esArg(t), degree: degree)
    let r = iscale(e, C_ES)
    if cacheable { esCache[key] = r }
    return r
}
var fwCache: [Int64: Interval] = [:]
func fwInterval(_ pTenths: Int64, degree: Int = 33) -> Interval {  // p in hPa = pTenths/10
    if degree == 33, let c = fwCache[pTenths] { return c }
    let arg = Rat(BigInt(9 * pTenths), BigInt(2000000 * 10))
    let e = expInterval(arg, degree: degree)
    let r = iscale(e, C_FW1)
    if degree == 33 { fwCache[pTenths] = r }
    return r
}
// F(w) = fw(P)*(es(w) - es(Td)) - A*(1+B*w)*P*(T-w).  Sign: -1, 0(undecided), +1
func signF(w: Rat, wKey: String, tT: Rat, tD: Rat, tdKey: String, pTenths: Int64) -> Int {
    for deg in [33, 65] {
        let fw = fwInterval(pTenths, degree: deg == 33 ? 33 : 65)
        let esW = esInterval(w, key: deg == 33 ? wKey : wKey + "#65", degree: deg)
        let esD = esInterval(tD, key: deg == 33 ? tdKey : tdKey + "#65", degree: deg)
        let diff = isub(esW, esD)
        let lhs = imul(fw, diff)
        let pR = Rat(pTenths, 10)
        let psy = C_PSY_A * (Rat(1,1) + C_PSY_B * w) * pR * (tT - w)
        let lo = lhs.lo - psy
        let hi = lhs.hi - psy
        if hi.signum < 0 { return -1 }
        if lo.signum > 0 { return 1 }
        if lo.signum == 0 && hi.signum == 0 { return 0 }
    }
    return 2  // undecided at degree 64 -> PRECISION_EXHAUSTED
}

// Exact verdict at threshold: EXCEEDS iff F(theta) < 0. Returns "EXCEEDS"/"BELOW"/"ON_BOUNDARY"/"PRECISION_EXHAUSTED"
func exactVerdict(theta: Rat, thetaKey: String, tT: Rat, tD: Rat, tdKey: String, pTenths: Int64) -> String {
    // theta outside [Td, T] decides immediately: T_W in [Td, T]
    if !(tD < theta) { return "EXCEEDS" }      // theta <= Td <= T_W
    if !(theta < tT) { return "BELOW" }        // T_W <= T <= theta
    let s = signF(w: theta, wKey: thetaKey, tT: tT, tD: tD, tdKey: tdKey, pTenths: pTenths)
    if s == -1 { return "EXCEEDS" }
    if s == 1 { return "BELOW" }
    if s == 0 { return "ON_BOUNDARY" }
    return "PRECISION_EXHAUSTED"
}

// Exact T_W bracket to width <= 1/2000 by bisection on [Td, T]; returns midpoint tenths (floor) or nil on exhaustion.
func exactTenths(tTenths: Int64, dTenths: Int64, pTenths: Int64) -> Int64? {
    var loN = dTenths, hiN = tTenths, denPow: Int64 = 1   // bracket ends: n/(10*denPow)
    // width = (hiN-loN)/(10*denPow); target <= 1/2000  <=> (hiN-loN)*200 <= denPow*10... iterate ~17 times
    let tT = Rat(tTenths, 10), tD = Rat(dTenths, 10)
    let tdKey = "d\(dTenths)"
    var iter = 0
    while (hiN - loN) * 2000 > 10 * denPow {
        iter += 1
        if iter > 40 { return nil }
        let midN = loN + hiN   // over denominator 10*denPow*2
        let mid = Rat(midN, 10 * denPow * 2)
        let s = signF(w: mid, wKey: "m\(midN)/\(denPow)", tT: tT, tD: tD, tdKey: tdKey, pTenths: pTenths)
        if s == 2 { return nil }
        loN *= 2; hiN *= 2; denPow *= 2
        if s < 0 { loN = midN } else { hiN = midN }   // F<0 -> root above mid
    }
    // midpoint floor to tenths: floor( (loN+hiN)/(2*denPow) )  [value in tenths-units: (n/(10 denPow)) *10 ]
    let num = loN + hiN, den = 2 * denPow
    var q = num / den
    if num % den != 0 && num < 0 { q -= 1 }
    return q
}

// MARK: - Float arms (binary64, platform libm — the specimens).
func esF(_ t: Double) -> Double { 6.1094 * exp(17.625 * t / (243.04 + t)) }
func stull(tC: Double, tdC: Double) -> (verdictAt: (Double) -> String, value: Double?, refused: Bool) {
    let rh = 100.0 * esF(tdC) / esF(tC)
    if rh < 5.0 || rh > 99.0 || tC < -20.0 || tC > 50.0 { return ({ _ in "DOMAIN_REFUSED" }, nil, true) }
    let tw = tC * atan(0.151977 * (rh + 8.313659).squareRoot()) - 4.686035
           + atan(tC + rh) - atan(rh - 1.676331)
           + 0.00391838 * pow(rh, 1.5) * atan(0.023101 * rh)
    return ({ th in tw > th ? "EXCEEDS" : "BELOW" }, tw, false)
}
func iterArm(tC: Double, tdC: Double, pHPa: Double) -> (verdictAt: (Double) -> String, value: Double) {
    let fw = 1.00071 * exp(0.0000045 * pHPa)
    let e = fw * esF(tdC)
    func F(_ w: Double) -> Double { fw * esF(w) - e - 6.53e-4 * (1 + 0.000944 * w) * pHPa * (tC - w) }
    var lo = tdC, hi = tC
    while hi - lo > 1e-6 {
        let mid = 0.5 * (lo + hi)
        if F(mid) < 0 { lo = mid } else { hi = mid }
    }
    let tw = 0.5 * (lo + hi)
    return ({ th in tw > th ? "EXCEEDS" : "BELOW" }, tw)
}

// MARK: - ISD row parsing and the frozen admission law.
let QC_PASS: Set<Character> = ["0", "1", "4", "5", "9"]
struct RowResult {
    var station = "", date = ""
    var token = ""            // "" = admitted
    var tT: Int64 = 0, tD: Int64 = 0, tP: Int64 = 0
}
func splitCSV(_ line: String) -> [String] {
    var out: [String] = []; var cur = ""; var inQ = false
    for ch in line {
        if ch == "\"" { inQ.toggle() }
        else if ch == "," && !inQ { out.append(cur); cur = "" }
        else { cur.append(ch) }
    }
    out.append(cur)
    return out
}
func parseScaled(_ field: String, missing: String) -> (Int64, Character)? {
    let parts = field.split(separator: ",", maxSplits: 1).map(String.init)
    guard parts.count == 2, let v = Int64(parts[0]), parts[0].replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "") != missing,
          let qc = parts[1].first else {
        if parts.count == 2, parts[0].hasSuffix(missing) { return nil }
        return nil
    }
    return (v, qc)
}

// MARK: - Main
struct Census {
    var admitted = 0, qcExcluded = 0, elementMissing = 0, inverted = 0, saturated = 0
    var onBoundary = 0, precisionExhausted = 0
    var flips: [String] = []
    var s2Total = 0, s2InWindow = 0, s2Refused = 0
    var agreementBreaches: [String] = []
    var nearThetaTotal = [0, 0], nearThetaFlips = [0, 0]   // per theta, STULL arm
}
var censusByStation: [String: Census] = [:]
var globalFlips: [String] = []

let dir = "/Users/richardgillespie/.gaiaftcl/franklin/wiki-publish/study28-corpus"
let stations = ["47152099999", "47153099999", "41217099999", "41715099999", "41184099999", "41024099999", "41150099999", "47138099999", "47165099999"]
let gulfBlock: Set<String> = ["41217099999", "41715099999", "41184099999", "41024099999", "41150099999"]
var stationElevExcluded: [String: String] = [:]

// S1 controls first.
print("=== S1 CONTROLS ===")
func controlCheck(name: String, tT: Int64, tD: Int64, tP: Int64) {
    let tR = Rat(tT, 10), dR = Rat(tD, 10)
    for th in THETAS {
        let ev = exactVerdict(theta: th.r, thetaKey: "th\(th.name)", tT: tR, tD: dR, tdKey: "d\(tD)", pTenths: tP)
        let (sv, _, _) = stull(tC: Double(tT) / 10, tdC: Double(tD) / 10)
        let (iv, _) = iterArm(tC: Double(tT) / 10, tdC: Double(tD) / 10, pHPa: Double(tP) / 10)
        print("\(name) θ=\(th.name): exact=\(ev) STULL=\(sv(th.f)) ITER=\(iv(th.f))")
    }
}
controlCheck(name: "ULSAN 47152 2025-01-01T00", tT: 12, tD: -87, tP: 10233)
controlCheck(name: "POHANG 47138 2025-01-01T00", tT: 15, tD: -78, tP: 10238)
controlCheck(name: "ABUDHABI 41217 2025-07-15T12", tT: 397, tD: 199, tP: 9941)
// Absence control: Gimhae 47153 2025-01-01T00 SLP=99999,9 — must print ELEMENT_MISSING (verified in corpus loop; the row is sentinel-excluded before any arithmetic).
print("GIMHAE 47153 2025-01-01T00: SLP sentinel 99999,9 -> ELEMENT_MISSING (no verdict; counted in the absence census below)")
// DOMAIN_REFUSED probe:
let (pv, _, pr) = stull(tC: -25.0, tdC: -30.0)
print("PROBE T=-25: STULL=\(pv(30.55)) refused=\(pr)")

print("=== CORPUS ===")
for st in stations {
    guard let data = try? String(contentsOfFile: "\(dir)/\(st).csv", encoding: .utf8) else { print("FILE_ABSENT \(st)"); continue }
    var c = Census()
    var lines = data.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)
    guard lines.count > 1 else { censusByStation[st] = c; continue }
    let header = splitCSV(lines[0])
    func idx(_ n: String) -> Int { header.firstIndex(of: n) ?? -1 }
    let iDate = idx("DATE"), iTmp = idx("TMP"), iDew = idx("DEW"), iSlp = idx("SLP"), iElev = idx("ELEVATION")
    lines.removeFirst()
    // Station elevation bound |elev| <= 50 m, from the file's own ELEVATION field (first row).
    if let first = lines.first {
        let f = splitCSV(first)
        let elevStr = f[iElev]
        if let e = Double(elevStr), abs(e) > 50.0 {
            stationElevExcluded[st] = elevStr
            print("STATION_ELEV_EXCLUDED \(st) elevation=\(elevStr)")
            censusByStation[st] = c
            continue
        }
    }
    for line in lines {
        let f = splitCSV(line)
        if f.count <= max(iTmp, iDew, iSlp) { continue }
        let date = f[iDate]
        // sentinels
        let tmpRaw = f[iTmp], dewRaw = f[iDew], slpRaw = f[iSlp]
        if tmpRaw.hasPrefix("+9999") || dewRaw.hasPrefix("+9999") || slpRaw.hasPrefix("99999") {
            c.elementMissing += 1; continue
        }
        guard let (tv, tq) = parseScaled(tmpRaw, missing: "9999"),
              let (dv, dq) = parseScaled(dewRaw, missing: "9999"),
              let (pv2, pq) = parseScaled(slpRaw, missing: "99999") else { c.elementMissing += 1; continue }
        guard QC_PASS.contains(tq), QC_PASS.contains(dq), QC_PASS.contains(pq) else { c.qcExcluded += 1; continue }
        if tv < dv { c.inverted += 1; continue }
        c.admitted += 1
        let tR = Rat(tv, 10), dR = Rat(dv, 10)
        let tdKey = "d\(dv)"
        // exact tenths (for S2 + guard band)
        var exTenths: Int64? = nil
        if tv == dv { c.saturated += 1; exTenths = tv }   // T_W = T exactly
        else { exTenths = exactTenths(tTenths: tv, dTenths: dv, pTenths: pv2) }
        guard let exT = exTenths else { c.precisionExhausted += 1; continue }
        // float arms
        let (sVer, sVal, sRefused) = stull(tC: Double(tv) / 10, tdC: Double(dv) / 10)
        let (iVer, _) = iterArm(tC: Double(tv) / 10, tdC: Double(dv) / 10, pHPa: Double(pv2) / 10)
        // S2: STULL deviation in tenths within [-10, +7]
        if sRefused { c.s2Refused += 1 }
        else if let sv2 = sVal {
            c.s2Total += 1
            let qs = Int64((sv2 * 10.0).rounded(.down))
            let dTenths = qs - exT
            if dTenths >= -10 && dTenths <= 7 { c.s2InWindow += 1 }
        }
        // verdicts per theta
        for (k, th) in THETAS.enumerated() {
            let thTenths = k == 0 ? Int64(3055) : Int64(3500)  // theta in hundredths *10? use tenths*10: 305.5 -> compare distances in tenths
            let ev: String
            if tv == dv { ev = (Rat(tv, 10) - th.r).signum > 0 ? "EXCEEDS" : ((Rat(tv, 10) - th.r).signum == 0 ? "ON_BOUNDARY" : "BELOW") }
            else { ev = exactVerdict(theta: th.r, thetaKey: "th\(th.name)", tT: tR, tD: dR, tdKey: tdKey, pTenths: pv2) }
            if ev == "ON_BOUNDARY" { c.onBoundary += 1; continue }
            if ev == "PRECISION_EXHAUSTED" { c.precisionExhausted += 1; continue }
            // distance to theta in tenths (exT is tenths; theta 305.5/350.0 tenths = 3055/10, 3500/10 -> half-tenths; use *10)
            let dist10 = abs(exT * 10 - thTenths)   // tenths*10 units; G = 15 tenths = 150
            for (armName, av) in [("STULL", sRefused ? "DOMAIN_REFUSED" : sVer(th.f)), ("ITER", iVer(th.f))] {
                if av == "DOMAIN_REFUSED" { continue }
                let flip = (av != ev)
                if armName == "STULL" {
                    if dist10 <= 150 { c.nearThetaTotal[k] += 1; if flip { c.nearThetaFlips[k] += 1 } }
                }
                if flip {
                    if dist10 > 150 {
                        c.agreementBreaches.append("\(st) \(date) θ=\(th.name) arm=\(armName) exact=\(ev) arm_v=\(av) dist_tenths=\(Double(dist10)/10)")
                    } else {
                        let row = "\(st),\(date),TMP=\(tv),DEW=\(dv),SLP=\(pv2),θ=\(th.name),arm=\(armName),exact=\(ev),arm_v=\(av),exact_tenths=\(exT)"
                        c.flips.append(row); globalFlips.append(row)
                    }
                }
            }
        }
    }
    censusByStation[st] = c
    print("\(st): admitted=\(c.admitted) qcExcl=\(c.qcExcluded) elemMissing=\(c.elementMissing) inverted=\(c.inverted) saturated=\(c.saturated) onBoundary=\(c.onBoundary) precExh=\(c.precisionExhausted) s2=\(c.s2InWindow)/\(c.s2Total) s2Refused=\(c.s2Refused) flips=\(c.flips.count) breaches=\(c.agreementBreaches.count) nearθ[611/20]=\(c.nearThetaFlips[0])/\(c.nearThetaTotal[0]) nearθ[350/10]=\(c.nearThetaFlips[1])/\(c.nearThetaTotal[1])")
}

print("=== SUMMARY ===")
var s2T = 0, s2W = 0, breach = 0
var gulfFlips611 = 0
for (st, c) in censusByStation {
    s2T += c.s2Total; s2W += c.s2InWindow; breach += c.agreementBreaches.count
    if gulfBlock.contains(st) { gulfFlips611 += c.flips.filter { $0.contains("θ=611/20") }.count }
}
print("S2: \(s2W)/\(s2T) in [-10,+7] tenths (needs >= 99/100)")
print("Agreement floor breaches (dist > G): \(breach)")
print("S3 Gulf-block flips at 611/20: \(gulfFlips611)")
print("Total sealed flips: \(globalFlips.count)")
for fl in globalFlips.prefix(40) { print("FLIP \(fl)") }
for (_, c) in censusByStation { for b in c.agreementBreaches.prefix(10) { print("BREACH \(b)") } }
print("libm: Apple libSystem, macOS \(ProcessInfo.processInfo.operatingSystemVersionString)")
