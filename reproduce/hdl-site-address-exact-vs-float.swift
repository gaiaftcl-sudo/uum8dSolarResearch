// STUDY 48 — THE ATOM ALREADY HAS AN ADDRESS
//
// 1 nm hydrogen depassivation lithography (HDL) removes single hydrogen atoms from a passivated
// Si(100)-2×1:H surface with a scanning tunnelling microscope tip. The write targets are not points
// in a plane. They are a finite integer set: a dimer-row index, a dimer index along that row, and
// which of the dimer's two silicon atoms carries the hydrogen. Nothing between those addresses can
// be written, because there is no atom there.
//
// THE QUESTION THIS PROGRAM ANSWERS. A controller can carry the tip as a length — a real number of
// metres, accumulated step by step, divided by a pitch and rounded back to a site when it is time to
// pulse. Or it can carry the tip as a count — an integer address, with the lattice as its own ruler.
// Both arrive at the same place on the first step. This measures where they stop agreeing, and what
// the difference costs in atoms.
//
// WHAT IS MEASURED HERE, AND WHAT IS NOT. This program performs no lithography. It operates no
// microscope, removes no hydrogen, and measures no tip, no piezo and no product. It measures the
// ARITHMETIC a controller does to decide which site to address: the same commanded path, carried
// three ways, compared site by site. Every physical constant it uses is REPORTED from a public
// source and is never presented as this run's measurement. No vendor, product or controller is named
// or graded: the failure described here is a property of binary floating-point addition, and it is
// the same failure in anyone's implementation that accumulates a length.
//
// THE EXACT ARM, AND WHY NO IRRATIONAL EVER APPEARS. Silicon is diamond-cubic with one cubic lattice
// parameter a0. On the 2×1 reconstruction the along-row dimer pitch is a0/√2 and the row-to-row pitch
// is a0·√2 — both irrational in metres. The exact arm never evaluates either. A site is the triple
// (m, n, b): dimer row m, dimer n along that row, and b ∈ {0,1} naming which silicon of that dimer
// carries the hydrogen. Two of those three are lattice steps and one is not, and that distinction is
// the whole of the geometry here:
//
//   along the row     consecutive dimers are ONE dimer pitch apart          3.840 Å  REPORTED
//   across the rows   consecutive dimer rows are TWO dimer pitches apart    7.680 Å  REPORTED
//   within one dimer  the two atoms are bonded ACROSS the row — perpendicular to it — at a Si–Si
//                     distance REPORTED in the surface-science literature as roughly 2.2–2.4 Å
//                     depending on buckling and method
//
// The first two are integer multiples of the dimer pitch. The third is NOT: the intra-dimer bond is a
// surface relaxation parameter, it is perpendicular to the row rather than along it, and no integer
// multiple of any pitch equals it. So b is carried as a LABEL and given no offset in the lattice
// metric, and the integer bracket addresses DIMER CENTRES:
//
//     squared separation = Δn² + 4Δm²,  in units of (dimer pitch)²
//
// The intra-dimer displacement is therefore deliberately ABSENT from that bracket rather than
// approximated inside it, and a control arm below proves the bracket is b-free instead of asserting
// it. The irrational is factored out of the geometry, not approximated inside it, so there is no
// rounding to analyse and no calibration interval to re-derive. Distances are never square-rooted:
// comparisons are integer comparisons of squares.
//
// THE FLOAT ARMS. Three, because one would be a straw man. F32-ACC and F64-ACC accumulate the
// commanded step into a real-valued position, exactly as a controller carrying a length does.
// F32-IDX recomputes the position from the step index instead of accumulating it — the same
// precision, the same pitch, no accumulation — and it is the control arm: if the instrument reported
// mis-addressing for F32-IDX too, it would be measuring the wrong thing. The control is gated at the
// GRADED PATH LENGTH, not at a shorter probe, and the program also prints where F32-IDX itself gives
// out at twice that path — a control whose own ceiling is hidden is a control a reader cannot weigh.
// Every float arm uses only +, −, ×, ÷ and comparison, all correctly rounded by IEEE-754, so the arms
// are byte-identical on this machine and under wasm32. No CALL to sin, cos, exp, log, pow or fmod
// appears anywhere in this file — stated as calls, because the letters themselves turn up inside
// ordinary English words and a substring claim would be false where the property is true. Those
// functions are not correctly rounded, they differ between libm implementations, and a transcript
// that depended on them would not reproduce.
//
// ZERO FLOAT ON THE DECISION PATH. Every verdict, count and pinned figure outside the float arms is
// an integer. The float arms exist to be measured, and their numbers are labelled as theirs.
//
// REPORTED CONSTANTS (published; not measured here)
//   a0(Si) = 5.431020511 Å          CODATA / NIST silicon lattice parameter
//   dimer pitch along a row 3.840 Å = a0/√2, row-to-row pitch 7.680 Å = a0·√2
//   the dimer bond is perpendicular to the dimer row; Si–Si ≈ 2.2–2.4 Å, a relaxation parameter,
//   NOT an integer multiple of any pitch, and ABSENT from every integer this program compares
//   atomically precise HDL writes a line ONE DIMER ROW wide — that practice is what the sources
//   report; the 0.768 nm is not an independent measurement but the row pitch a0·√2 restated,
//   so it is DERIVED from a0 and carries a0's authority, not the patent's
//   sources: US 10,983,142 (depassivation lithography by STM); arXiv:2412.05729 (constant di/dz STM,
//   hydrogen depassivation lithography on Si(100)-2×1:H)
//
// Run: swiftc -O -swift-version 5 hdl-site-address-exact-vs-float.swift && ./hdl-site-address-exact-vs-float
// It takes no argument and reads no file. MARKER and seal are printed on every exit path.
import Foundation

// ============================================================================================
// SECTION 0 — the transcript, and the seal over it
// ============================================================================================

var T: [String] = []
func out(_ s: String = "") { T.append(s); print(s) }

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
    static func hex8(_ v: UInt32) -> String {
        let d = Array("0123456789abcdef")
        var s = ""
        for i in stride(from: 28, through: 0, by: -4) { s.append(d[Int((v >> UInt32(i)) & 0xf)]) }
        return s
    }
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

func gp(_ n: Int64) -> String {                      // 1234567 -> "1,234,567"; integers only
    let neg = n < 0
    var v = neg ? -n : n
    var parts: [String] = []
    if v == 0 { return "0" }
    while v > 0 { let chunk = v % 1000; v /= 1000; parts.append(v > 0 ? String(format: "%03d", Int(chunk)) : String(Int(chunk))) }
    return (neg ? "-" : "") + parts.reversed().joined(separator: ",")
}
func pad(_ s: String, _ w: Int) -> String { s.count >= w ? s : s + String(repeating: " ", count: w - s.count) }
func padL(_ s: String, _ w: Int) -> String { s.count >= w ? s : String(repeating: " ", count: w - s.count) + s }

// ============================================================================================
// SECTION 1 — the address space, in integers
// ============================================================================================
// A site is (m, n, b): dimer-row index m, dimer index n along that row, and b ∈ {0,1} naming which
// silicon of that dimer carries the hydrogen. Two of those are lattice steps; one is a label.
//
//     along the row    dimer n sits at n dimer pitches
//     across the rows  row m sits at 2m dimer pitches      (the row pitch is twice the dimer pitch)
//     within a dimer   b names an atom. The dimer bond runs ACROSS the row, not along it, and its
//                      length is not an integer multiple of any pitch — so b carries NO offset here.
//
// Squared separation between two sites is therefore the integer Δn² + 4Δm², in units of (dimer
// pitch)². No length, no square root, no irrational — and no b, which is the point: the bracket is a
// dimer-CENTRE bracket, and the intra-dimer displacement is ABSENT from it by construction, not
// approximated inside it. Arm A5 proves the b-freedom rather than asserting it.
//
// An address is also a single integer. Inside a patch of `dimersPerRow` dimers per row, the packed
// address word is ((m · dimersPerRow) + n) · 2 + b — row, then dimer, then which atom. Arm A1
// round-trips every site in a patch through that word, so all three fields, b included, are tested.

struct Site: Equatable { var m: Int64; var n: Int64; var b: Int64 }

@inline(__always) func alongPitches(_ s: Site) -> Int64 { s.n }
@inline(__always) func acrossPitches(_ s: Site) -> Int64 { 2 &* s.m }
@inline(__always) func sqSeparation(_ a: Site, _ b: Site) -> Int64 {
    let du = alongPitches(a) &- alongPitches(b)          // Δn
    let dv = acrossPitches(a) &- acrossPitches(b)        // 2Δm
    return du &* du &+ dv &* dv                          // Δn² + 4Δm², in units of (dimer pitch)²
}

@inline(__always) func packAddress(_ s: Site, _ dimersPerRow: Int64) -> Int64 {
    return ((s.m &* dimersPerRow) &+ s.n) &* 2 &+ s.b
}
@inline(__always) func unpackAddress(_ w: Int64, _ dimersPerRow: Int64) -> Site {
    let b = w & 1, rest = w >> 1
    return Site(m: rest / dimersPerRow, n: rest % dimersPerRow, b: b)
}

// REPORTED constants, in integer picometres where a length is unavoidable. The exact arm never uses
// them for a decision; they exist to state a result in units a reader outside the lattice can hold.
let A0_FM: Int64 = 543_102_051            // a0 = 5.431020511 Å, in units of 10^-16 m (0.1 fm)
let PITCH_PM_REPORTED: Int64 = 384        // 3.840 Å, the along-row dimer pitch, REPORTED
let ROW_PITCH_PM_REPORTED: Int64 = 768    // 7.680 Å, the row-to-row pitch, REPORTED
// The intra-dimer Si–Si bond is REPORTED as roughly 2.2–2.4 Å, perpendicular to the row. It is
// deliberately not given an integer here: no decision, count or seal in this program depends on it.

// ============================================================================================
// SECTION 2 — the float arms (the only place a Double or Float appears)
// ============================================================================================
// Each arm carries the tip along one dimer row, one commanded dimer step at a time, and decides the
// site it is on the way a continuous-space controller does: divide the carried length by the pitch
// and round to nearest. Only +, −, ×, ÷ and comparison are used; all are correctly rounded, so these
// arms produce the same bytes here and under wasm32.

let PITCH_F64: Double = 3.84e-10          // the REPORTED pitch as a controller would hold it, in metres
let PITCH_F32: Float  = 3.84e-10

@inline(__always) func nearestIndexF32(_ x: Float) -> Int64 {
    let q = x / PITCH_F32
    return Int64((q + (q >= 0 ? 0.5 : -0.5)))          // round-half-away-from-zero, stated, not implied
}
@inline(__always) func nearestIndexF64(_ x: Double) -> Int64 {
    let q = x / PITCH_F64
    return Int64((q + (q >= 0 ? 0.5 : -0.5)))
}

struct ArmResult { var firstWrong: Int64; var wrong: Int64; var lastIndex: Int64 }

// F32-ACC / F64-ACC: accumulate the step. F32-IDX: recompute from the index, never accumulating.
func armF32Accumulate(_ steps: Int64) -> ArmResult {
    var x: Float = 0, firstWrong: Int64 = -1, wrong: Int64 = 0, last: Int64 = 0
    var k: Int64 = 1
    while k <= steps {
        x += PITCH_F32
        let idx = nearestIndexF32(x)
        if idx != k { if firstWrong < 0 { firstWrong = k }; wrong &+= 1 }
        last = idx; k &+= 1
    }
    return ArmResult(firstWrong: firstWrong, wrong: wrong, lastIndex: last)
}
func armF64Accumulate(_ steps: Int64) -> ArmResult {
    var x: Double = 0, firstWrong: Int64 = -1, wrong: Int64 = 0, last: Int64 = 0
    var k: Int64 = 1
    while k <= steps {
        x += PITCH_F64
        let idx = nearestIndexF64(x)
        if idx != k { if firstWrong < 0 { firstWrong = k }; wrong &+= 1 }
        last = idx; k &+= 1
    }
    return ArmResult(firstWrong: firstWrong, wrong: wrong, lastIndex: last)
}
func armF32FromIndex(_ steps: Int64) -> ArmResult {
    var firstWrong: Int64 = -1, wrong: Int64 = 0, last: Int64 = 0
    var k: Int64 = 1
    while k <= steps {
        let x = Float(k) * PITCH_F32                    // no accumulation: the index is the truth
        let idx = nearestIndexF32(x)
        if idx != k { if firstWrong < 0 { firstWrong = k }; wrong &+= 1 }
        last = idx; k &+= 1
    }
    return ArmResult(firstWrong: firstWrong, wrong: wrong, lastIndex: last)
}

// The exact arm, for the same path: the address IS the count. Written as a loop so the transcript
// reports a measurement and not an assertion.
func armExact(_ steps: Int64) -> ArmResult {
    var site = Site(m: 0, n: 0, b: 0)
    var firstWrong: Int64 = -1, wrong: Int64 = 0
    var k: Int64 = 1
    while k <= steps {
        site.n &+= 1
        if site.n != k { if firstWrong < 0 { firstWrong = k }; wrong &+= 1 }
        k &+= 1
    }
    return ArmResult(firstWrong: firstWrong, wrong: wrong, lastIndex: site.n)
}

// Where a precision stops tracking at all: once one pitch falls below half the spacing between
// representable numbers, adding a pitch becomes a no-op. The THRESHOLD is wanted here, not a power of
// two above it — doubling until the add is lost reports the grid point, which can be nearly twice the
// real answer and would be published as if it were measured. So the doubling only brackets, and the
// threshold itself is found by bisecting the IEEE-754 bit pattern, which is monotone in the value for
// positive floats. The result is the LEAST carried travel at which one pitch added changes nothing.
func stallBracketF32() -> Float {
    var x: Float = PITCH_F32
    while x + PITCH_F32 != x { x *= 2 }
    return x
}
func stallBracketF64() -> Double {
    var x: Double = PITCH_F64
    while x + PITCH_F64 != x { x *= 2 }
    return x
}
func stallThresholdF32() -> Float {
    var lo = PITCH_F32.bitPattern                       // here the step still lands
    var hi = stallBracketF32().bitPattern               // here it is lost
    while hi &- lo > 1 {
        let mid = lo &+ (hi &- lo) / 2
        let x = Float(bitPattern: mid)
        if x + PITCH_F32 != x { lo = mid } else { hi = mid }
    }
    return Float(bitPattern: hi)
}
func stallThresholdF64() -> Double {
    var lo = PITCH_F64.bitPattern
    var hi = stallBracketF64().bitPattern
    while hi &- lo > 1 {
        let mid = lo &+ (hi &- lo) / 2
        let x = Double(bitPattern: mid)
        if x + PITCH_F64 != x { lo = mid } else { hi = mid }
    }
    return Double(bitPattern: hi)
}
func metresText(_ v: Double) -> String {               // a float arm's own number, printed as text
    if v >= 1 { return String(format: "%.3g m", v) }
    if v >= 1e-3 { return String(format: "%.3g mm", v * 1e3) }
    if v >= 1e-6 { return String(format: "%.3g µm", v * 1e6) }
    return String(format: "%.3g nm", v * 1e9)
}

// ============================================================================================
// SECTION 3 — the run
// ============================================================================================

out("STUDY 48 — THE ATOM ALREADY HAS AN ADDRESS")
out("1 nm hydrogen depassivation lithography: the write target is a count, not a length.")
out("")
out("REFERENCE FIGURES — published constants, REPORTED, not measured by this run")
out("  a0(Si)                         5.431020511 Å        CODATA / NIST lattice parameter")
out("  dimer pitch along a row        3.840 Å = a0/√2      REPORTED")
out("  row-to-row pitch               7.680 Å = a0·√2      REPORTED")
out("  atomically precise line width  0.768 nm = one dimer row   the PRACTICE is REPORTED;")
out("                                 the number is the row pitch a0·√2 restated, so it is DERIVED from a0")
out("  sources: US 10,983,142 · arXiv:2412.05729")
out("  This program performs no lithography and measures no instrument. It measures control arithmetic.")
out("")

// ---- SECTION 1: control arm. Nothing below is graded if an arm here does not hold. ----
out("SECTION 1 — CONTROL ARM (both directions; nothing is graded if one fails)")
var armsRun = 0, armsFailed = 0
func arm(_ name: String, _ mustHold: Bool, _ held: Bool) {
    armsRun += 1
    let ok = (held == mustHold)
    if !ok { armsFailed += 1 }
    out("  [\(ok ? "HOLDS" : "BROKEN")] \(pad(name, 62)) \(mustHold ? "must hold" : "must NOT hold")")
}

// A1 — the address round-trips: pack and unpack every site of a 64×64 patch, exactly, all three
// fields, b included.
var roundTripOK = true
let a1Dimers: Int64 = 64
for m in Int64(0)..<64 { for n in Int64(0)..<a1Dimers { for b in Int64(0)...1 {
    let s = Site(m: m, n: n, b: b)
    if unpackAddress(packAddress(s, a1Dimers), a1Dimers) != s { roundTripOK = false }
} } }
arm("A1 every site round-trips through its packed address word", true, roundTripOK)

// A2 — origin invariance: shift the origin, every squared separation is unchanged.
var originOK = true
for i in Int64(0)...200 {
    let a = Site(m: i % 7, n: i % 13, b: i & 1), b2 = Site(m: (i % 5) - 2, n: (i % 11) - 5, b: (i >> 1) & 1)
    let shifted = { (s: Site) in Site(m: s.m + 7, n: s.n - 3, b: s.b) }
    if sqSeparation(a, b2) != sqSeparation(shifted(a), shifted(b2)) { originOK = false }
}
arm("A2 squared separations do not move when the origin moves", true, originOK)

// A3 — the instrument fires: a one-site offset in the same path must be detected as wrong.
let injected = armExact(1024)
var injectedWrong = false
do {
    var site = Site(m: 0, n: 0, b: 0); var k: Int64 = 1
    while k <= 1024 { site.n &+= 1; if k == 512 { site.n &+= 1 }      // a single lost step
        if site.n != k { injectedWrong = true }; k &+= 1 }
}
arm("A3 a single injected mis-step is detected by the same comparison", true, injectedWrong)
arm("A3-control the un-injected exact path reports no mis-addressed site", false, injected.wrong != 0)

// A4 — squares decide, and they decide the closest case there is: two separations one unit apart,
// both on b = 0 so the comparison is between dimer centres and nothing else. (0,2,0) sits 2 dimer
// pitches along the row: squared separation 4. (1,1,0) sits 1 along and 2 across: 1 + 4 = 5. One unit
// apart in the integers, ordered without a root.
let s0 = Site(m: 0, n: 0, b: 0)
let nearSite = Site(m: 0, n: 2, b: 0), farSite = Site(m: 1, n: 1, b: 0)
let nearSq = sqSeparation(s0, nearSite), farSq = sqSeparation(s0, farSite)
arm("A4 two dimer-centre separations one unit apart are ordered as integers", true,
    nearSq == 4 && farSq == 5 && nearSq < farSq)

// A5 — the bracket is b-free, and it is proved here rather than asserted. Changing only the atom
// label must leave every squared separation unchanged: the intra-dimer bond runs across the row and
// is not an integer multiple of any pitch, so it is ABSENT from the integer geometry by construction.
var bFreeOK = true
for i in Int64(0)...400 {
    let p = Site(m: (i % 9) - 4, n: (i % 17) - 8, b: 0)
    let q = Site(m: (i % 5) - 2, n: (i % 23) - 11, b: 0)
    let base = sqSeparation(p, q)
    for pb in Int64(0)...1 { for qb in Int64(0)...1 {
        let pl = Site(m: p.m, n: p.n, b: pb), ql = Site(m: q.m, n: q.n, b: qb)
        if sqSeparation(pl, ql) != base { bFreeOK = false }
    } }
}
arm("A5 the integer bracket is b-free: the atom label carries no offset", true, bFreeOK)

// A6 — the float control arm: recomputing from the index must agree with the exact arm OVER THE
// GRADED PATH ITSELF, or the instrument is measuring floating point in general rather than the
// accumulation of a length. The probe is the graded path length, not a shorter one: a control gated
// below the measurement it guards cannot fire where the measurement is taken.
let probeSteps: Int64 = 1 << 22
let idxArmProbe = armF32FromIndex(probeSteps)
arm("A6 float32 from the index mis-addresses nothing over the graded path", true, idxArmProbe.wrong == 0)

out("  arms run \(armsRun), broken \(armsFailed)")
if armsFailed != 0 {
    out("")
    out("VERDICT : REFUSED — a control arm did not hold, so no figure below is graded.")
    out("MARKER  HDL_SITE_ADDRESS__CONTROL_ARM_REFUSED")
    let seal = SHA256Min.hex(Array(T.joined(separator: "\n").utf8))
    print("SEAL    sha256 \(seal)")
    exit(2)
}
out("")

// ---- SECTION 2: the address space itself ----
out("SECTION 2 — THE ADDRESS SPACE, IN INTEGERS")
let patchRows: Int64 = 1_024, patchDimers: Int64 = 1_024
let sitesInPatch = patchRows &* patchDimers &* 2
out("  a site is (dimer row m, dimer n along the row, b ∈ {0,1} — which silicon of the dimer)")
out("  a patch of \(gp(patchRows)) rows × \(gp(patchDimers)) dimers holds \(gp(sitesInPatch)) writable sites")
out("  every dimer-centre separation is the integer Δn² + 4Δm², in units of (dimer pitch)² — no length, no root")
out("  b is a LABEL, not an offset: the dimer bond runs across the row, not along it, and its REPORTED")
out("  2.2–2.4 Å is not an integer multiple of any pitch — so it is ABSENT from the bracket, and arm A5 proves it")
out("  the patch spans \(gp(patchDimers &* PITCH_PM_REPORTED)) pm along a row and \(gp(patchRows &* ROW_PITCH_PM_REPORTED)) pm across rows, at the REPORTED pitches")
out("")

// ---- SECTION 3: one commanded path, four arms ----
let steps: Int64 = 1 << 22                     // 4,194,304 single-dimer steps along one row
out("SECTION 3 — ONE COMMANDED PATH, FOUR ARMS")
out("  the path: \(gp(steps)) single-dimer steps along one dimer row, each step exactly one pitch")
out("  an arm is wrong at a step when the site it decides is not the site the command reached")
out("")
let ex  = armExact(steps)
let f32 = armF32Accumulate(steps)
let f64 = armF64Accumulate(steps)
let idx = armF32FromIndex(steps)
func row(_ name: String, _ r: ArmResult) {
    let first = r.firstWrong < 0 ? "never" : "step " + gp(r.firstWrong)
    out("  \(pad(name, 34)) first wrong: \(pad(first, 16)) mis-addressed sites: \(padL(gp(r.wrong), 12))")
}
row("EXACT integer address", ex)
row("FLOAT32 accumulated length", f32)
row("FLOAT64 accumulated length", f64)
row("FLOAT32 from the index (control)", idx)
out("")
if f32.firstWrong > 0 {
    let travelPm = f32.firstWrong &* PITCH_PM_REPORTED
    out("  float32, accumulating, mis-addresses its first hydrogen site at step \(gp(f32.firstWrong))")
    out("  that is \(gp(travelPm)) pm of commanded travel at the REPORTED pitch — \(gp(travelPm / 1_000)) nm")
    out("  from that step on it is writing at the wrong address, and nothing in the arithmetic says so")
}
out("  float32 accumulating mis-addresses \(gp(f32.wrong)) of \(gp(steps)) sites; float64 accumulating mis-addresses \(gp(f64.wrong)); float32 recomputed from the index mis-addresses \(gp(idx.wrong))")
out("  the exact arm mis-addresses \(gp(ex.wrong)) sites in \(gp(steps)) steps, and cannot: the address is the count")
out("")
// The control arm is honest about its own ceiling. Recomputing from the index is not unconditionally
// clean — it is clean over THIS path. Double the path and single precision runs out of integers to
// name, so the study states where, rather than leaving a reader to assume the control never breaks.
let idxTwice = armF32FromIndex(steps &* 2)
if idxTwice.firstWrong > 0 {
    out("  the control arm has a ceiling of its own, and this study states it: doubled to \(gp(steps &* 2)) steps,")
    out("  float32 recomputed from the index first mis-addresses at step \(gp(idxTwice.firstWrong)) and gets \(gp(idxTwice.wrong)) sites wrong")
    out("  it is clean over the graded path and not beyond it — which is exactly the per-path, per-scale")
    out("  analysis the exact arm never has to do")
} else {
    out("  doubled to \(gp(steps &* 2)) steps, float32 recomputed from the index still mis-addresses nothing")
}
out("")

// ---- SECTION 4: where each precision stops moving at all ----
out("SECTION 4 — WHERE EACH PRECISION STOPS TRACKING (IEEE-754, the threshold itself, bisected)")
let stall32 = stallThresholdF32(), stall64 = stallThresholdF64()
let brack32 = stallBracketF32(), brack64 = stallBracketF64()
out("  float32: one pitch added to \(metresText(Double(stall32))) of carried travel changes nothing — the step is lost")
out("  float64: one pitch added to \(metresText(stall64)) of carried travel changes nothing — the step is lost")
out("  these are the LEAST such travels, found by bisecting the bit pattern. Doubling alone would have")
out("  reported \(metresText(Double(brack32))) and \(metresText(brack64)) — the grid point above each threshold, not the threshold.")
out("  the exact arm has no such point: an address is an integer, and the next site is the next integer")
out("")

// ---- SECTION 5: what this does not say ----
out("SECTION 5 — WHAT THIS DOES NOT SAY")
out("  It does not say any instrument, controller or product is wrong: it measures arithmetic, not hardware.")
out("  It does not claim a lithography experiment. No hydrogen was removed; nothing here touches a microscope.")
out("  It does not say double precision fails at this scale — measured above, it does not; it says the exact")
out("  arm needs no error budget, no ulp analysis and no re-calibration interval to make that claim.")
out("  Thermal drift, tip condition, piezo creep and the physics of desorption are ABSENT from this study.")
out("")
out("  THE FINDING: the surface supplies its own ruler. A controller that carries the count writes the")
out("  atom it named; a controller that carries the length writes the atom the rounding leaves it on.")
out("")
out("MARKER  HDL_SITE_ADDRESS__THE_LATTICE_IS_ITS_OWN_RULER")
let seal = SHA256Min.hex(Array(T.joined(separator: "\n").utf8))
print("SEAL    sha256 \(seal)")
