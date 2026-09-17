// STUDY 49 — THE PHASE CODE NEVER NEEDS π
//
// A phase-only spatial light modulator is a pixel array in which each pixel takes one of L phase
// levels spread over one 2π stroke. Eight-bit drive — L = 256 — is the common convention. The device
// state is therefore a point of a finite set: an integer code per pixel, and nothing between codes,
// because the device cannot be driven between them.
//
// THE QUESTION THIS PROGRAM ANSWERS. A synthesiser can compute a pixel's phase as a real number of
// radians, wrap it modulo 2π, scale by L/2π and round to a code. Or it can compute the code itself,
// as an integer. The first route carries π — an irrational the device never uses — through every
// pixel. This measures how often the two routes hand the device a different code, and what the first
// route costs that the second does not.
//
// THE π CANCELS, AND THAT IS THE POINT. For a blazed grating of m periods across N pixels the phase
// is φ_n = 2π·m·n/N, and the code is φ_n·L/(2π) — so the code is L·m·n/N, a ratio of integers.
// For a Fresnel lens of focal length f at wavelength λ on pitch p the PARAXIAL phase is π·p²·r²/(λ·f),
// and the code is L·p²·r²/(2·λ·f) — again a ratio of integers, where r² = Δx² + Δy² is an integer
// count of pixels. In both cases π appears only if you insist on radians, and cancels when you ask
// the question the device actually answers: WHICH CODE. The exact arm never evaluates π, never wraps
// a real number, and never rounds one — and an arm below DERIVES that cancellation symbolically,
// with a paired arm that must NOT hold when the factor of two is dropped from the 2π.
//
// THE PARAXIAL IDEALISATION IS NOT FREE, AND THIS PROGRAM MEASURES ITS SIZE. The quadratic above is
// the paraxial approximation to a spherical wavefront. The spherical phase is (2π/λ)(√(r²p²+f²) − f),
// which carries a square root and is NOT a ratio of integers. Section 6 computes the departure at the
// corner of this panel with an exact integer square root, in thousandths of a level, so a reader can
// see that it is far larger than the one-level differences this study reports — and it is named
// ABSENT, because choosing the quadratic is a modelling decision this study does not grade.
//
// WHAT IS MEASURED HERE, AND WHAT IS NOT. This program drives no modulator, illuminates nothing and
// measures no optical field. It measures the ARITHMETIC that decides a command word: the same
// hologram, computed two ways, compared code by code. No vendor, product or algorithm is named or
// graded; the difference measured is a property of binary floating-point rounding, and it is the
// same in anyone's implementation that carries radians.
//
// THE FLOAT ARMS use only +, −, ×, ÷, comparison and rounding — all correctly rounded by IEEE-754 —
// so they are byte-identical here and under wasm32. No CALL to sin, cos, exp, log, pow or fmod
// appears in this file — stated as calls, because those letters turn up inside ordinary English words
// and a substring claim would be false where the property is true. Those functions are not correctly
// rounded, they differ between libm implementations, and a transcript that depended on them would not
// reproduce. π enters a float arm only as the IEEE double nearest to it, which is what a synthesiser
// has. The one square root in this file is an EXACT INTEGER square root, computed by integer Newton
// iteration and checked by its own arm — no libm is involved.
//
// BOTH ARMS FLOOR, AND THE PROGRAM SAYS SO. A synthesiser must pick one of the levels the device has;
// this study takes the level below (floor) on BOTH sides, so the comparison is like for like. Floor is
// a choice, not a law, so Sections 3 and 4 also print the ROUND-TO-NEAREST counts beside the floor
// counts — they are very different numbers, and which figure is a property of the precision and which
// is a property of the rounding rule is something a reader is entitled to see rather than infer.
//
// REPORTED CONSTANTS (published; not measured here)
//   L = 256 phase levels over one 2π stroke — the common 8-bit drive convention for phase-only LCOS
//   pixel geometries in public use: 1920×1080 at 4.5 µm pitch, 1920×1200 at 8.0 µm pitch
//   λ = 632.8 nm — the iodine-stabilised He-Ne line, a BIPM recommended radiation
//   sources: public phase-only LCOS SLM datasheets from more than one manufacturer (no vendor is
//   named or graded anywhere in this study); BIPM mise en pratique for the He-Ne line
// CHOSEN PARAMETER (ours, stated so it can be changed): focal length f = 100.0 mm for the lens mask.
//
// Run: swiftc -O -swift-version 5 slm-phase-code-exact-vs-float.swift && ./slm-phase-code-exact-vs-float
// It takes no argument and reads no file. MARKER and seal are printed on every exit path.
import Foundation

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
        let d = Array("0123456789abcdef"); var s = ""
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
func gp(_ n: Int64) -> String {
    let neg = n < 0; var v = neg ? -n : n; var parts: [String] = []
    if v == 0 { return "0" }
    while v > 0 { let c = v % 1000; v /= 1000; parts.append(v > 0 ? String(format: "%03d", Int(c)) : String(Int(c))) }
    return (neg ? "-" : "") + parts.reversed().joined(separator: ",")
}
func pad(_ s: String, _ w: Int) -> String { s.count >= w ? s : s + String(repeating: " ", count: w - s.count) }
func padL(_ s: String, _ w: Int) -> String { s.count >= w ? s : String(repeating: " ", count: w - s.count) + s }

// ============================================================================================
// The device, in integers
// ============================================================================================
let L: Int64 = 256                       // phase levels over one 2π stroke (8-bit drive, REPORTED)
let NX: Int64 = 1920, NY: Int64 = 1080   // a public panel geometry (REPORTED)
let PITCH_TENTH_NM: Int64 = 45_000       // 4.5 µm pitch, in units of 0.1 nm (REPORTED)
let LAMBDA_TENTH_NM: Int64 = 6_328       // 632.8 nm, in units of 0.1 nm (REPORTED)
let FOCAL_TENTH_NM: Int64 = 1_000_000_000 // 100.0 mm, in units of 0.1 nm (CHOSEN)

// A blazed grating of m periods across N pixels: code_n = floor(L·m·n / N) mod L. Integers only.
@inline(__always) func gratingCodeExact(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let num = L &* m &* n
    return (num / N) % L
}
// A Fresnel lens: code = floor(L·p²·r² / (2·λ·f)) mod L, r² an integer count of pixels. Integers only.
let LENS_NUM: Int64 = L * PITCH_TENTH_NM * PITCH_TENTH_NM            // L·p²   ≈ 5.184e11
let LENS_DEN: Int64 = 2 * LAMBDA_TENTH_NM * FOCAL_TENTH_NM           // 2·λ·f  ≈ 1.266e13
// The product below is taken DIRECTLY, with trapping `*` rather than the wrapping `&*`. r² ≤ 960² +
// 540² = 1,213,200, so LENS_NUM·r² ≤ 6.29e17 against an Int64 ceiling of 9.22e18 — about 14× of
// headroom. An earlier version divided both constants by 8 first; the reduction was exact, but it was
// an unexplained step that would silently stop being exact if a parameter changed. Trapping
// multiplication means a changed panel, wavelength or focal length fails loudly instead of wrapping.
@inline(__always) func lensCodeExact(_ r2: Int64) -> Int64 {
    return (LENS_NUM * r2 / LENS_DEN) % L
}

// —— the π cancellation, carried symbolically so an arm can DERIVE it instead of asserting it ——
// A phase is (π^k)·num/den with k an integer power. Dividing by 2π lowers k by one and doubles den.
// Nothing here evaluates π; k reaching 0 IS the cancellation, and it is checked rather than assumed.
struct PiRational { var piPower: Int64; var num: Int64; var den: Int64 }
@inline(__always) func paraxialLensPhase(_ r2: Int64) -> PiRational {      // φ = π·p²·r²/(λ·f)
    return PiRational(piPower: 1,
                      num: PITCH_TENTH_NM * PITCH_TENTH_NM * r2,
                      den: LAMBDA_TENTH_NM * FOCAL_TENTH_NM)
}
@inline(__always) func gratingPhase(_ n: Int64, _ m: Int64, _ N: Int64) -> PiRational {   // φ = 2π·m·n/N
    return PiRational(piPower: 1, num: 2 * m * n, den: N)
}
// level = φ·L/(2π). The 2π divides: one power of π off, denominator doubled, numerator scaled by L.
@inline(__always) func levelsOf(_ p: PiRational) -> PiRational {
    return PiRational(piPower: p.piPower - 1, num: p.num * L, den: p.den * 2)
}
// The same step with the 2 dropped from the 2π — the exact mistake the paired control arm must catch.
@inline(__always) func levelsOfMissingTwo(_ p: PiRational) -> PiRational {
    return PiRational(piPower: p.piPower - 1, num: p.num * L, den: p.den)
}

// —— an EXACT integer square root, for the paraxial-departure measurement in Section 6 ——
// Integer Newton. No libm, no Double, deterministic on every machine. Its own arm checks it.
func isqrtExact(_ n: Int64) -> Int64 {
    if n < 2 { return n }
    var x = n, y = (x + 1) / 2
    while y < x { x = y; y = (x + n / x) / 2 }
    return x
}

// ============================================================================================
// The float arms — the only place a Double or Float appears
// ============================================================================================
let TWO_PI_F64: Double = 2 * Double.pi
let TWO_PI_F32: Float = 2 * Float.pi

// A synthesiser carrying radians: compute φ, wrap modulo 2π, scale to levels, take the level.
@inline(__always) func gratingCodeF64(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let phi = TWO_PI_F64 * Double(m) * Double(n) / Double(N)
    let turns = (phi / TWO_PI_F64).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F64
    return Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.down)) % L
}
@inline(__always) func gratingCodeF32(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let phi = TWO_PI_F32 * Float(m) * Float(n) / Float(N)
    let turns = (phi / TWO_PI_F32).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F32
    return Int64((wrapped * Float(L) / TWO_PI_F32).rounded(.down)) % L
}
// The same grating, accumulated pixel to pixel the way a raster pipeline carries a running phase.
func gratingCodesF64Recurrence(_ N: Int64, _ m: Int64) -> [Int64] {
    var codes = [Int64](repeating: 0, count: Int(N))
    let step = TWO_PI_F64 * Double(m) / Double(N)
    var phi: Double = 0
    for n in 0..<Int(N) {
        let turns = (phi / TWO_PI_F64).rounded(.down)
        let wrapped = phi - turns * TWO_PI_F64
        codes[n] = Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.down)) % L
        phi += step
    }
    return codes
}
// The same grating, accumulated from the far end: the same physics, the other order of summation.
// HOW THE FAR END IS REACHED IS ITSELF A CHOICE, and it dominates the answer, so the program runs
// both and says so. `seedBySummation == false` reaches the far end with ONE multiplication, which is
// what an earlier version of this program did; `true` reaches it by adding the same step N−1 times,
// which is what "the same sum, the other way round" actually means. Reporting only the first would
// have credited the direction of summation with a difference mostly caused by the seed.
func gratingCodesF64RecurrenceReversed(_ N: Int64, _ m: Int64, _ seedBySummation: Bool) -> [Int64] {
    var codes = [Int64](repeating: 0, count: Int(N))
    let step = TWO_PI_F64 * Double(m) / Double(N)
    var phi: Double
    if seedBySummation { phi = 0; for _ in 0..<(Int(N) - 1) { phi += step } }
    else { phi = step * Double(N - 1) }
    for n in stride(from: Int(N) - 1, through: 0, by: -1) {
        let turns = (phi / TWO_PI_F64).rounded(.down)
        let wrapped = phi - turns * TWO_PI_F64
        codes[n] = Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.down)) % L
        phi -= step
    }
    return codes
}
@inline(__always) func lensCodeF64(_ r2: Int64) -> Int64 {
    let p = Double(PITCH_TENTH_NM), lam = Double(LAMBDA_TENTH_NM), f = Double(FOCAL_TENTH_NM)
    let phi = Double.pi * p * p * Double(r2) / (lam * f)
    let turns = (phi / TWO_PI_F64).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F64
    return Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.down)) % L
}
@inline(__always) func lensCodeF32(_ r2: Int64) -> Int64 {
    let p = Float(PITCH_TENTH_NM), lam = Float(LAMBDA_TENTH_NM), f = Float(FOCAL_TENTH_NM)
    let phi = Float.pi * p * p * Float(r2) / (lam * f)
    let turns = (phi / TWO_PI_F32).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F32
    return Int64((wrapped * Float(L) / TWO_PI_F32).rounded(.down)) % L
}

// ROUND-TO-NEAREST twins. Floor is this study's comparison rule on both sides; these exist so the
// transcript can say which headline figures survive the other rule and which do not.
@inline(__always) func gratingCodeExactNearest(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    return (((2 * L * m * n + N) / (2 * N)) % L + L) % L
}
@inline(__always) func gratingCodeF64Nearest(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let phi = TWO_PI_F64 * Double(m) * Double(n) / Double(N)
    let turns = (phi / TWO_PI_F64).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F64
    return ((Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.toNearestOrEven)) % L) + L) % L
}
@inline(__always) func gratingCodeF32Nearest(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let phi = TWO_PI_F32 * Float(m) * Float(n) / Float(N)
    let turns = (phi / TWO_PI_F32).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F32
    return ((Int64((wrapped * Float(L) / TWO_PI_F32).rounded(.toNearestOrEven)) % L) + L) % L
}
@inline(__always) func lensCodeExactNearest(_ r2: Int64) -> Int64 {
    // (2·LENS_NUM·r² + LENS_DEN) / (2·LENS_DEN) would overflow; halve the denominator instead, which is
    // exact because LENS_DEN = 2·λ·f is even by construction.
    let half = LENS_DEN / 2
    return (((LENS_NUM * r2 + half) / LENS_DEN) % L + L) % L
}
@inline(__always) func lensCodeF64Nearest(_ r2: Int64) -> Int64 {
    let p = Double(PITCH_TENTH_NM), lam = Double(LAMBDA_TENTH_NM), f = Double(FOCAL_TENTH_NM)
    let phi = Double.pi * p * p * Double(r2) / (lam * f)
    let turns = (phi / TWO_PI_F64).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F64
    return ((Int64((wrapped * Double(L) / TWO_PI_F64).rounded(.toNearestOrEven)) % L) + L) % L
}
@inline(__always) func lensCodeF32Nearest(_ r2: Int64) -> Int64 {
    let p = Float(PITCH_TENTH_NM), lam = Float(LAMBDA_TENTH_NM), f = Float(FOCAL_TENTH_NM)
    let phi = Float.pi * p * p * Float(r2) / (lam * f)
    let turns = (phi / TWO_PI_F32).rounded(.down)
    let wrapped = phi - turns * TWO_PI_F32
    return ((Int64((wrapped * Float(L) / TWO_PI_F32).rounded(.toNearestOrEven)) % L) + L) % L
}

// THE ARM THE THESIS NEEDS. Every float arm above carries π. This page attributes the disagreement to
// π, so a float route WITHOUT π — the same Double arithmetic, the same floor, the closed form with the
// π already cancelled — has to be run, or the attribution is a claim and not a measurement.
@inline(__always) func gratingCodeF64NoPi(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let level = (Double(L) * Double(m) * Double(n) / Double(N)).rounded(.down)
    return ((Int64(level) % L) + L) % L
}
@inline(__always) func lensCodeF64NoPi(_ r2: Int64) -> Int64 {
    let p = Double(PITCH_TENTH_NM), lam = Double(LAMBDA_TENTH_NM), f = Double(FOCAL_TENTH_NM)
    let level = (Double(L) * p * p * Double(r2) / (2 * lam * f)).rounded(.down)
    return ((Int64(level) % L) + L) % L
}
// And the SINGLE-precision twins, because until these were run no arm touched a float32 path at all,
// and the study was attributing the float32 counts to π on the strength of a float64 result.
@inline(__always) func gratingCodeF32NoPi(_ n: Int64, _ m: Int64, _ N: Int64) -> Int64 {
    let level = (Float(L) * Float(m) * Float(n) / Float(N)).rounded(.down)
    return ((Int64(level) % L) + L) % L
}
@inline(__always) func lensCodeF32NoPi(_ r2: Int64) -> Int64 {
    let p = Float(PITCH_TENTH_NM), lam = Float(LAMBDA_TENTH_NM), f = Float(FOCAL_TENTH_NM)
    let level = (Float(L) * p * p * Float(r2) / (2 * lam * f)).rounded(.down)
    return ((Int64(level) % L) + L) % L
}

// A running phase carried WITHOUT π: accumulate the LEVEL, not the radian. Section 5 runs this in both
// directions, because the closing finding turns on whether π or float accumulation is what makes an
// answer order-dependent — and that has to be measured, not asserted.
func gratingLevelsF64NoPiRecurrence(_ N: Int64, _ m: Int64, _ reversed: Bool) -> [Int64] {
    var codes = [Int64](repeating: 0, count: Int(N))
    let step = Double(L) * Double(m) / Double(N)
    if !reversed {
        var lv: Double = 0
        for n in 0..<Int(N) { codes[n] = ((Int64(lv.rounded(.down)) % L) + L) % L; lv += step }
    } else {
        var lv: Double = 0                                  // seeded by SUMMATION, not by one multiply
        for _ in 0..<(Int(N) - 1) { lv += step }
        for n in stride(from: Int(N) - 1, through: 0, by: -1) {
            codes[n] = ((Int64(lv.rounded(.down)) % L) + L) % L; lv -= step
        }
    }
    return codes
}

@inline(__always) func circularGap(_ a: Int64, _ b: Int64) -> Int64 {    // levels apart, the short way
    let d = ((a - b) % L + L) % L
    return min(d, L - d)
}

// ============================================================================================
// The run
// ============================================================================================
out("STUDY 49 — THE PHASE CODE NEVER NEEDS π")
out("A phase-only modulator takes one of 256 codes per pixel. The code is a ratio of integers.")
out("")
out("REFERENCE FIGURES — published constants, REPORTED, not measured by this run")
out("  phase levels L                 256 over one 2π stroke (8-bit drive)      REPORTED")
out("  panel geometry                 1,920 × 1,080 pixels, 4.5 µm pitch        REPORTED")
out("  wavelength λ                   632.8 nm (iodine-stabilised He-Ne)        REPORTED")
out("  focal length f                 100.0 mm                                  CHOSEN, ours")
out("  sources: public phase-only SLM datasheets · BIPM mise en pratique")
out("  This program drives no modulator and measures no optical field. It measures control arithmetic.")
out("")

out("SECTION 1 — CONTROL ARM (both directions; nothing is graded if one fails)")
var armsRun = 0, armsFailed = 0
func arm(_ name: String, _ mustHold: Bool, _ held: Bool) {
    armsRun += 1
    let ok = (held == mustHold); if !ok { armsFailed += 1 }
    out("  [\(ok ? "HOLDS" : "BROKEN")] \(pad(name, 64)) \(mustHold ? "must hold" : "must NOT hold")")
}

// A1 — two independent integer routes to the same code agree on every pixel of a grating.
var twoRoutesAgree = true
do {
    let m: Int64 = 7
    var acc: Int64 = 0                                  // exact recurrence: add L·m, reduce by N
    for n in Int64(0)..<NX {
        let byFormula = gratingCodeExact(n, m, NX)
        let byRecurrence = (acc / NX) % L
        if byFormula != byRecurrence { twoRoutesAgree = false }
        acc &+= L &* m
    }
}
arm("A1 two integer routes to the code agree on every pixel", true, twoRoutesAgree)

// A2 — the comparison fires, and its twin proves it is not firing on nothing. The injection goes into
// the array that is actually compared, not into a local copy the comparison never sees.
var injectedSeen = false, cleanReportsDifference = false
do {
    let m: Int64 = 7
    var codes = [Int64](repeating: 0, count: Int(NX))
    for n in Int64(0)..<NX { codes[Int(n)] = gratingCodeExact(n, m, NX) }
    for n in Int64(0)..<NX where codes[Int(n)] != gratingCodeExact(n, m, NX) { _ = n; cleanReportsDifference = true }
    codes[977] = (codes[977] + 1) % L                       // one level, one pixel, in the compared array
    for n in Int64(0)..<NX where codes[Int(n)] != gratingCodeExact(n, m, NX) { _ = n; injectedSeen = true }
}
arm("A2 a single injected level offset is detected", true, injectedSeen)
arm("A2-control the un-injected array reports no difference", false, cleanReportsDifference)

// A3 — where the disagreement lives, and where it does not. The exact code is floor(L·m·n/N), so the
// remainder (L·m·n) mod N says how far into the level the exact value sits, in units of 1/N of a
// level. On pixels in the MIDDLE HALF of a level — a quarter level clear of either boundary — the
// float route must agree, or the arithmetic would be wrong everywhere rather than at the edges. That
// is the control: it holds, and it localises every disagreement below to a level boundary.
// (A geometry with no rounding at all is NOT available: even where L·m·n/N is a whole number, the
// float route lands a hair below it and floors down. That is the measurement, not a control.)
var interiorAgrees = true, interiorPixels: Int64 = 0
do {
    let m: Int64 = 7
    for n in Int64(0)..<NX {
        let r = (L &* m &* n) % NX
        if r >= NX / 4 && r <= 3 &* NX / 4 {
            interiorPixels &+= 1
            if gratingCodeExact(n, m, NX) != gratingCodeF64(n, m, NX) { interiorAgrees = false }
        }
    }
}
arm("A3 float64 agrees on every pixel a quarter level clear of a boundary (control)", true, interiorAgrees)

// A4 — π cancels, DERIVED rather than asserted. The earlier version of this arm compared
// lensCodeExact against a copy of its own body, so no error in the cancellation could break it: a
// dropped factor of two in 2·λ·f mis-coded more than two million pixels and the arm still held. It is
// now built the other way round — the phase is carried with its power of π kept symbolically, the
// division by 2π is performed on that symbol, and the arm checks BOTH that the power reached zero
// (which IS the cancellation) and that the resulting rational is the code. A4-control performs the
// same derivation with the 2 dropped from the 2π and must NOT reproduce the code.
var piFree = true, piPowerReachedZero = true, missingTwoStillMatches = true
var gratingPiFree = true
do {
    for r2 in stride(from: Int64(0), through: Int64(1_213_200), by: 9_973) {
        let lv = levelsOf(paraxialLensPhase(r2))
        if lv.piPower != 0 { piPowerReachedZero = false }
        if (lv.num / lv.den) % L != lensCodeExact(r2) { piFree = false }
        let bad = levelsOfMissingTwo(paraxialLensPhase(r2))
        if (bad.num / bad.den) % L != lensCodeExact(r2) { missingTwoStillMatches = false }
    }
    // the same derivation on the grating, whose phase carries the 2π in the numerator instead
    for n in stride(from: Int64(0), to: NX, by: 37) {
        let lv = levelsOf(gratingPhase(n, 7, NX))
        if lv.piPower != 0 || (lv.num / lv.den) % L != gratingCodeExact(n, 7, NX) { gratingPiFree = false }
    }
}
arm("A4 dividing the phase by 2π drives the power of π to zero", true, piPowerReachedZero)
arm("A4b the π-free rational that remains IS the lens code", true, piFree)
arm("A4c the same derivation gives the grating code", true, gratingPiFree)
arm("A4-control dropping the 2 from 2π still reproduces the code", false, missingTwoStillMatches)

// A5 — the exact arm does not depend on the order the pixels are visited.
var exactOrderInvariant = true
do {
    let m: Int64 = 7
    var forward = [Int64](), backward = [Int64](repeating: 0, count: Int(NX))
    for n in Int64(0)..<NX { forward.append(gratingCodeExact(n, m, NX)) }
    for n in stride(from: NX - 1, through: 0, by: -1) { backward[Int(n)] = gratingCodeExact(n, m, NX) }
    if forward != backward { exactOrderInvariant = false }
}
arm("A5 the exact codes do not change with the order of the pixels", true, exactOrderInvariant)

// A6 — the exact integer square root Section 6 depends on, checked at and just below a perfect square.
var isqrtOK = true
do {
    for k in stride(from: Int64(2), through: Int64(2_000_000_000), by: 19_999_991) {
        if isqrtExact(k * k) != k { isqrtOK = false }
        if isqrtExact(k * k - 1) != k - 1 { isqrtOK = false }
        if isqrtExact(k * k + 1) != k { isqrtOK = false }
    }
}
arm("A6 the integer square root is exact at and around a perfect square", true, isqrtOK)

// A7 — THE ARM THE THESIS NEEDS. The page attributes the disagreement to π. So the same Double
// arithmetic, the same floor, with the π already cancelled out of the closed form, must agree with the
// exact codes on every pixel of BOTH masks. If it did not, the attribution would be wrong and the
// study would be measuring floating point in general.
var noPiAgreesGrating = true, noPiAgreesLens = true
do {
    for n in Int64(0)..<NX where gratingCodeF64NoPi(n, 7, NX) != gratingCodeExact(n, 7, NX) {
        _ = n; noPiAgreesGrating = false
    }
    for y in Int64(0)..<NY {
        let dy = y - NY / 2
        for x in Int64(0)..<NX {
            let dx = x - NX / 2
            let r2 = dx * dx + dy * dy
            if lensCodeF64NoPi(r2) != lensCodeExact(r2) { noPiAgreesLens = false }
        }
    }
}
arm("A7 a float64 route with π cancelled out agrees with the exact grating codes", true, noPiAgreesGrating)
arm("A7b the same π-free float64 route agrees on all 2,073,600 lens pixels", true, noPiAgreesLens)

// A8 — the SINGLE-precision π-free route on the grating. It agrees, so it is an arm. Its lens
// counterpart does NOT agree, so that one is reported as a measurement in Section 4 and never dressed
// up as a control: an arm written around a result it was allowed to choose proves nothing.
var noPi32AgreesGrating = true
for n in Int64(0)..<NX where gratingCodeF32NoPi(n, 7, NX) != gratingCodeExact(n, 7, NX) {
    _ = n; noPi32AgreesGrating = false
}
arm("A8 a float32 route with π cancelled out agrees with the exact grating codes", true, noPi32AgreesGrating)

out("  arms run \(armsRun), broken \(armsFailed)")
if armsFailed != 0 {
    out("")
    out("VERDICT : REFUSED — a control arm did not hold, so no figure below is graded.")
    out("MARKER  SLM_PHASE_CODE__CONTROL_ARM_REFUSED")
    print("SEAL    sha256 \(SHA256Min.hex(Array(T.joined(separator: "\n").utf8)))")
    exit(2)
}
out("")

out("SECTION 2 — THE DEVICE IS A FINITE SET")
let pixels = NX &* NY
out("  pixels \(gp(pixels)) · levels \(gp(L)) · the state space is one code per pixel and nothing between codes")
out("  a mask is \(gp(pixels &* 8)) bits of command word: \(gp(pixels)) pixels × 8 bits, exactly")
out("  the code for a blazed grating is L·m·n/N, and for a lens L·p²·r²/(2·λ·f) — ratios of integers")
out("")

out("SECTION 3 — A BLAZED GRATING, TWO WAYS (m = 7 periods across 1,920 pixels)")
let m7: Int64 = 7
var gDiff64: Int64 = 0, gDiff32: Int64 = 0, gFirst64: Int64 = -1, gFirst32: Int64 = -1
var gMax64: Int64 = 0, gMax32: Int64 = 0
for n in Int64(0)..<NX {
    let e = gratingCodeExact(n, m7, NX)
    let a = gratingCodeF64(n, m7, NX), b = gratingCodeF32(n, m7, NX)
    if a != e { gDiff64 &+= 1; if gFirst64 < 0 { gFirst64 = n }; gMax64 = max(gMax64, circularGap(a, e)) }
    if b != e { gDiff32 &+= 1; if gFirst32 < 0 { gFirst32 = n }; gMax32 = max(gMax32, circularGap(b, e)) }
}
out("  \(pad("radians in float64, wrapped, then quantised", 46)) different codes: \(padL(gp(gDiff64), 7)) of \(gp(NX))   first at pixel \(gFirst64 < 0 ? "none" : gp(gFirst64))   largest gap \(gp(gMax64)) level(s)")
out("  \(pad("radians in float32, wrapped, then quantised", 46)) different codes: \(padL(gp(gDiff32), 7)) of \(gp(NX))   first at pixel \(gFirst32 < 0 ? "none" : gp(gFirst32))   largest gap \(gp(gMax32)) level(s)")
// Where the disagreement lives. The exact code is floor(L·m·n/N), so r = (L·m·n) mod N says how far
// into the level the exact value sits, in units of 1/N of a level. TWO partitions are reported,
// because they are not the same claim and the weaker one was being read as the stronger:
//   "near a boundary"  — r outside the middle half of a level, i.e. within a quarter level of an edge
//   "ON a boundary"    — r == 0 exactly, the level changing at that very pixel
var gNearBoundary: Int64 = 0, gInterior: Int64 = 0, gOnBoundary: Int64 = 0
var wholeNumberPixels: Int64 = 0, wholeNumberDisagree: Int64 = 0
var only64: Int64 = 0, only32: Int64 = 0, both6432: Int64 = 0
for n in Int64(0)..<NX {
    let r = (L &* m7 &* n) % NX
    let nearBoundary = !(r >= NX / 4 && r <= 3 &* NX / 4)
    let e = gratingCodeExact(n, m7, NX)
    let d64 = gratingCodeF64(n, m7, NX) != e, d32 = gratingCodeF32(n, m7, NX) != e
    if r == 0 { wholeNumberPixels &+= 1; if d64 { wholeNumberDisagree &+= 1 } }
    if d64 { if nearBoundary { gNearBoundary &+= 1 } else { gInterior &+= 1 }; if r == 0 { gOnBoundary &+= 1 } }
    if d64 && d32 { both6432 &+= 1 } else if d64 { only64 &+= 1 } else if d32 { only32 &+= 1 }
}
out("  on the grating, float64 hands the device \(gp(gDiff64)) different codes in \(gp(NX)) pixels, and float32 hands it \(gp(gDiff32))")
out("  \"near a boundary\" here means the exact value lies outside the middle half of its level — a")
out("  quarter level or less from an edge — and that is the band arm A3 gates on. By that partition,")
out("  every float64 disagreement sits near a level boundary: \(gp(gNearBoundary)) near-boundary pixels, \(gp(gInterior)) in the body of a level")
out("  the stronger statement is also true and is the one to read: \(gp(gOnBoundary)) of the \(gp(gDiff64)) sit EXACTLY on a")
out("  boundary — the level changes at that very pixel, remainder zero, not merely close to one")
out("  of the \(gp(wholeNumberPixels)) pixels where L·m·n/N is a whole number, the radians route lands below it on \(gp(wholeNumberDisagree))")
out("  — not on all of them, which is why this is reported as a count and not as a rule")
out("  float32 differs on FEWER grating pixels than float64, and they are mostly different pixels:")
out("  \(gp(both6432)) pixels common to both arms, \(gp(only64)) float64 only, \(gp(only32)) float32 only. On this mask the")
out("  difference is a floor-at-an-exact-integer effect, so the DIRECTION of the float error decides the")
out("  count rather than its size — less precision does not mean more differing codes here")
out("  a pixel at a boundary is a pixel whose exact code the device could hold and the radians route could not name")
out("")
// The comparison rule is floor on both sides. It is a choice, so the other rule is reported beside it.
var gNear64: Int64 = 0, gNear32: Int64 = 0
for n in Int64(0)..<NX {
    let e = gratingCodeExactNearest(n, m7, NX)
    if gratingCodeF64Nearest(n, m7, NX) != e { gNear64 &+= 1 }
    if gratingCodeF32Nearest(n, m7, NX) != e { gNear32 &+= 1 }
}
out("  BOTH ARMS ABOVE FLOOR. Under round-to-nearest on both sides instead, the same grating gives")
out("  float64 \(gp(gNear64)) of \(gp(NX)) and float32 \(gp(gNear32)) of \(gp(NX)) different codes.")
out("  That is the honest shape of this result: on this mask the counts above are a property of the")
out("  rounding rule as much as of the precision, and a reader is entitled to see both rather than one.")
out("")

out("SECTION 4 — A FRESNEL LENS ON THE WHOLE PANEL, TWO WAYS")
var lDiff64: Int64 = 0, lDiff32: Int64 = 0, lMax64: Int64 = 0, lMax32: Int64 = 0
var lFirstX: Int64 = -1, lFirstY: Int64 = -1
for y in Int64(0)..<NY {
    let dy = y - NY / 2
    for x in Int64(0)..<NX {
        let dx = x - NX / 2
        let r2 = dx &* dx &+ dy &* dy
        let e = lensCodeExact(r2)
        let a = lensCodeF64(r2), b = lensCodeF32(r2)
        if a != e { lDiff64 &+= 1; lMax64 = max(lMax64, circularGap(a, e)); if lFirstX < 0 { lFirstX = x; lFirstY = y } }
        if b != e { lDiff32 &+= 1; lMax32 = max(lMax32, circularGap(b, e)) }
    }
}
out("  \(pad("radians in float64, wrapped, then quantised", 46)) different codes: \(padL(gp(lDiff64), 9)) of \(gp(pixels))   largest gap \(gp(lMax64)) level(s)")
out("  \(pad("radians in float32, wrapped, then quantised", 46)) different codes: \(padL(gp(lDiff32), 9)) of \(gp(pixels))   largest gap \(gp(lMax32)) level(s)")
// per million, because per thousand rounds both rates to zero and a rate that reads zero says nothing
let perMillion64 = lDiff64 &* 1_000_000 / pixels, perMillion32 = lDiff32 &* 1_000_000 / pixels
out("  that is \(gp(perMillion64)) per million pixels handed a different command word in float64, \(gp(perMillion32)) per million in float32")
out("  on the lens, float64 hands the device \(gp(lDiff64)) different codes in \(gp(pixels)) pixels, and float32 hands it \(gp(lDiff32))")
out("  the exact arm hands the device 0 different codes, on any panel, in any order")
var lNear64: Int64 = 0, lNear32: Int64 = 0
for y in Int64(0)..<NY {
    let dy = y - NY / 2
    for x in Int64(0)..<NX {
        let dx = x - NX / 2
        let r2 = dx &* dx &+ dy &* dy
        let e = lensCodeExactNearest(r2)
        if lensCodeF64Nearest(r2) != e { lNear64 &+= 1 }
        if lensCodeF32Nearest(r2) != e { lNear32 &+= 1 }
    }
}
out("  under round-to-nearest on both sides instead: float64 \(gp(lNear64)) and float32 \(gp(lNear32)) of \(gp(pixels))")
out("  the float32 lens figure is the one headline here that survives the change of rounding rule, and")
out("  it is the largest — which is what a precision effect looks like, as against a rule effect")
// How much of the lens disagreement is π, and how much is simply the precision? Measured, not split
// by assumption — and on this mask the answer is not the one the rest of this study would suggest.
var lensNoPi32: Int64 = 0, lensNoPi64: Int64 = 0
for y in Int64(0)..<NY {
    let dy = y - NY / 2
    for x in Int64(0)..<NX {
        let dx = x - NX / 2
        let r2 = dx &* dx &+ dy &* dy
        let e = lensCodeExact(r2)
        if lensCodeF32NoPi(r2) != e { lensNoPi32 &+= 1 }
        if lensCodeF64NoPi(r2) != e { lensNoPi64 &+= 1 }
    }
}
out("  π IS NOT THE WHOLE STORY ON THE LENS IN SINGLE PRECISION, and this study says so rather than")
out("  letting its own headline stand unqualified. Cancel π out of the float route and run it again:")
out("  float64 drops from \(gp(lDiff64)) to \(gp(lensNoPi64)), so on the lens every float64 disagreement is π. float32")
out("  drops only from \(gp(lDiff32)) to \(gp(lensNoPi32)) — so about half of the single-precision lens disagreement is")
out("  the precision alone, with no π involved. On the grating the π-free route agrees in BOTH precisions")
out("  (arms A7 and A8). π is a sufficient cause everywhere this study looks and a necessary one only")
out("  on the grating and in double precision.")
out("")

out("SECTION 5 — THE SAME MASK, THE OTHER WAY ROUND")
let fwd = gratingCodesF64Recurrence(NX, m7)
let revSummed = gratingCodesF64RecurrenceReversed(NX, m7, true)
let revMultiplied = gratingCodesF64RecurrenceReversed(NX, m7, false)
var orderDiffSummed: Int64 = 0, orderDiffMultiplied: Int64 = 0
var fwdVsExact: Int64 = 0, revVsExact: Int64 = 0
for n in 0..<Int(NX) {
    let e = gratingCodeExact(Int64(n), m7, NX)
    if fwd[n] != revSummed[n] { orderDiffSummed &+= 1 }
    if fwd[n] != revMultiplied[n] { orderDiffMultiplied &+= 1 }
    if fwd[n] != e { fwdVsExact &+= 1 }
    if revSummed[n] != e { revVsExact &+= 1 }
}
out("  a running phase accumulated left to right, and the same phase accumulated right to left:")
out("  \(gp(orderDiffSummed)) of \(gp(NX)) pixels take a different code depending on which end the sum started")
out("  HOW THE FAR END IS REACHED MATTERS MORE THAN THE DIRECTION, and this study reports both rather")
out("  than the larger one. Reaching the far end with a single multiplication instead of by summing the")
out("  step \(gp(NX - 1)) times gives \(gp(orderDiffMultiplied)) of \(gp(NX)) — so most of that larger figure is the seed, not the")
out("  direction. The \(gp(orderDiffSummed)) above is the one that answers the question the section asks.")
out("  against the exact codes, which is the comparison the thesis is actually about:")
out("  the forward recurrence differs from exact on \(gp(fwdVsExact)) pixels and the reversed on \(gp(revVsExact)) of \(gp(NX))")
out("  the exact codes are identical either way — arm A5 above, and by construction: there is no sum")
out("")
// Does π cause the order dependence, or does carrying a real number? Measured, not assumed.
let npFwd = gratingLevelsF64NoPiRecurrence(NX, m7, false)
let npRev = gratingLevelsF64NoPiRecurrence(NX, m7, true)
var noPiOrderDiff: Int64 = 0
for n in 0..<Int(NX) where npFwd[n] != npRev[n] { noPiOrderDiff &+= 1 }
out("  AND π IS NOT WHAT CAUSES THIS. The same recurrence with π cancelled out of it — accumulating the")
out("  LEVEL rather than the radian, no π anywhere — still differs on \(gp(noPiOrderDiff)) of \(gp(NX)) pixels between the two")
out("  directions. Carrying a real number per pixel is what makes an answer depend on the order of the")
out("  sum; π is what makes the closed-form route disagree with the exact code at all (arm A7). Two")
out("  separate defects, and this study had attributed both to π until this arm was run.")
out("")

out("SECTION 6 — WHAT THE PARAXIAL IDEALISATION COSTS (measured in integers, and named ABSENT)")
// The quadratic lens phase used above is the PARAXIAL approximation. The spherical wavefront is
// (2π/λ)(√(r²p² + f²) − f), which carries a square root and is NOT a ratio of integers. Its size is
// measured here, exactly, with the integer square root of arm A6 — in thousandths of a level, so the
// comparison against the one-level differences above needs no float and no rounding.
do {
    let r2corner = (NX / 2) * (NX / 2) + (NY / 2) * (NY / 2)
    let radial = PITCH_TENTH_NM * PITCH_TENTH_NM * r2corner         // r²p², in (0.1 nm)²
    let hyp = isqrtExact(radial + FOCAL_TENTH_NM * FOCAL_TENTH_NM)  // √(r²p² + f²), exact integer
    let sag = hyp - FOCAL_TENTH_NM                                   // the optical path difference
    let sphericalMilli = L * sag * 1000 / LAMBDA_TENTH_NM            // L·sag/λ, in milli-levels
    let a = LENS_NUM * r2corner                                      // L·p²·r² — too large to scale by 1000
    let paraxialMilli = (a / LENS_DEN) * 1000 + ((a % LENS_DEN) * 1000) / LENS_DEN
    let gapMilli = paraxialMilli - sphericalMilli
    out("  at the corner of this panel (r² = \(gp(r2corner)) pixels), the paraxial phase and the spherical")
    out("  wavefront differ by \(gp(gapMilli / 1000)).\(String(format: "%03d", Int(abs(gapMilli) % 1000))) levels — measured exactly, by integer square root")
    out("  that is larger than every one-level difference reported above, by a factor of about \(gp(gapMilli / 1000))")
    out("  CHOOSING THE QUADRATIC IS A MODELLING DECISION, AND THIS STUDY DOES NOT GRADE IT. It is named")
    out("  here so no reader mistakes 'the code is a ratio of integers' for a claim about the wavefront:")
    out("  it is a claim about the quadratic mask, which is what optical benches actually write. The")
    out("  spherical code is not a ratio of integers, and its shear is ABSENT from this study.")
}
out("")

out("SECTION 7 — WHAT THIS DOES NOT SAY")
out("  It does not say any modulator, product or algorithm is wrong: it measures arithmetic, not devices.")
out("  It does not claim an optical experiment. Nothing here was illuminated, imaged or diffracted.")
out("  Diffraction efficiency, speckle, crosstalk, phase flicker and the physics of the liquid crystal")
out("  are ABSENT from this study: a differing code is a differing command word, not a measured field.")
out("  The paraxial approximation itself is ABSENT too, and Section 6 measures how large it is rather")
out("  than leaving the reader to assume it is small.")
out("  It does not say float64 is unusable: measured above, most of its codes agree. It says the exact")
out("  route agrees with itself, needs no wrap, no error budget, and no π.")
out("")
out("  THE FINDING: the device asks WHICH CODE, and that question is a ratio of integers. Two separate")
out("  costs follow from answering it in real numbers instead, and this program separates them: π is")
out("  why the closed-form float route hands the device a different code at all, and carrying a real")
out("  number per pixel — with or without π — is why the answer can depend on the order of the sum.")
out("  The integer route pays neither: there is no π to carry and no sum to order.")
out("")
out("MARKER  SLM_PHASE_CODE__THE_CODE_IS_A_RATIO_OF_INTEGERS")
print("SEAL    sha256 \(SHA256Min.hex(Array(T.joined(separator: "\n").utf8)))")
