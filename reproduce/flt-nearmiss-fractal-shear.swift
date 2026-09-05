// flt-nearmiss-fractal-shear.swift
// Affine.Earth shear study — the Fermat near-miss "fractal shear".
//
// WHAT THIS PROVES (exactly, and no more):
//   For a PRESENTED near-miss (a,b,c,n>2), exact integer arithmetic returns the
//   same verdict — a^n + b^n != c^n, REFUTED — on every machine, and it holds
//   that verdict at EVERY zoom depth (affine dilation by k). A finite-precision
//   observer instead reports a FALSE closure whenever the two sides agree to more
//   significant figures than it resolves, and that false closure PERSISTS at every
//   zoom depth because the ratio is scale-invariant. The float verdict is
//   observer-dependent (it flips with the width you resolve to); the exact verdict
//   is observer-invariant.
//
// WHAT THIS DOES NOT PROVE:
//   Not the universal Fermat's Last Theorem. Dilating one triple only ever visits
//   k*(a,b,c) — one ray — and by homogeneity every scale gives the same verdict for
//   that one triple. This is the REFUTE move on presented inputs, exact and
//   scale-invariant. The universal is the discovery move: NOT KNOWN here, by design.
//
// Zero float in the exact path. Base-1e9 big integers, exact throughout.
// Marker: FLT_NEARMISS_FRACTAL_SHEAR__EXACT_IS_OBSERVER_INVARIANT

// ---------------- exact big unsigned integer, base 1e9 ----------------
let BASE: UInt64 = 1_000_000_000
struct Big: Comparable {
  var d: [UInt64]                    // little-endian base-1e9 limbs
  init(_ v: UInt64) {
    if v == 0 { d = [0] } else { var x = v; d = []; while x > 0 { d.append(x % BASE); x /= BASE } }
  }
  init(limbs: [UInt64]) { d = limbs; if d.isEmpty { d = [0] }; while d.count > 1 && d.last == 0 { d.removeLast() } }
  var isZero: Bool { d.count == 1 && d[0] == 0 }
  static func < (a: Big, b: Big) -> Bool {
    if a.d.count != b.d.count { return a.d.count < b.d.count }
    var i = a.d.count - 1
    while i >= 0 { if a.d[i] != b.d[i] { return a.d[i] < b.d[i] }; i -= 1 }
    return false
  }
  static func == (a: Big, b: Big) -> Bool { a.d == b.d }
  static func + (a: Big, b: Big) -> Big {
    var r = [UInt64](); var carry: UInt64 = 0; let n = max(a.d.count, b.d.count)
    r.reserveCapacity(n + 1)
    for i in 0..<n {
      let s = (i < a.d.count ? a.d[i] : 0) + (i < b.d.count ? b.d[i] : 0) + carry
      r.append(s % BASE); carry = s / BASE
    }
    if carry > 0 { r.append(carry) }
    return Big(limbs: r)
  }
  static func - (a: Big, b: Big) -> Big {              // requires a >= b
    var r = [UInt64](); var borrow: Int64 = 0
    for i in 0..<a.d.count {
      var cur = Int64(a.d[i]) - Int64(i < b.d.count ? b.d[i] : 0) - borrow
      if cur < 0 { cur += Int64(BASE); borrow = 1 } else { borrow = 0 }
      r.append(UInt64(cur))
    }
    return Big(limbs: r)
  }
  static func * (a: Big, b: Big) -> Big {
    var r = [UInt64](repeating: 0, count: a.d.count + b.d.count)
    for i in 0..<a.d.count {
      var carry: UInt64 = 0
      for j in 0..<b.d.count {
        let cur = r[i + j] + a.d[i] * b.d[j] + carry
        carry = cur / BASE; r[i + j] = cur % BASE
      }
      r[i + b.d.count] += carry
    }
    return Big(limbs: r)
  }
  func pow(_ e: Int) -> Big {
    var result = Big(1); var base = self; var ee = e
    while ee > 0 { if ee & 1 == 1 { result = result * base }; base = base * base; ee >>= 1 }
    return result
  }
  func halved() -> Big {
    var r = [UInt64](repeating: 0, count: d.count); var rem: UInt64 = 0; var i = d.count - 1
    while i >= 0 { let cur = rem * BASE + d[i]; r[i] = cur / 2; rem = cur % 2; i -= 1 }
    return Big(limbs: r)
  }
  var digits: String {
    var s = String(d[d.count - 1]); var i = d.count - 2
    while i >= 0 { let t = String(d[i]); s += String(repeating: "0", count: 9 - t.count) + t; i -= 1 }
    return s
  }
  var numDigits: Int { digits.count }
  var shortDigits: String {
    let g = digits
    if g.count <= 30 { return g }
    return "\(g.prefix(22))…\(g.suffix(6))  (\(g.count) digits)"
  }
}
func intNthRoot(_ N: Big, _ n: Int) -> Big {           // floor(N^(1/n))
  if N.isZero { return Big(0) }
  var hi = Big(1); while hi.pow(n) <= N { hi = hi * Big(2) }
  var lo = Big(1)
  while lo + Big(1) < hi { let mid = (lo + hi).halved(); if mid.pow(n) <= N { lo = mid } else { hi = mid } }
  return lo
}

// ---------------- the finite-precision observer ----------------
// A finite-precision observer resolves D significant decimal digits — the model a
// hand calculator (~10), IEEE single float (~7) or IEEE double (~16) each realizes.
// It "sees closure" when a^n+b^n and c^n agree in its top D significant figures.
// The horizon H is how many significant figures the two sides agree to: the
// largest H with gap * 10^H < min(L,R)  (i.e. relative gap < 10^-H). Any observer
// resolving D <= H figures is fooled; the exact court has no horizon. Computed
// exactly in integers so it is robust across a leading-digit flip (1.999.../2.000...).
func agreementSigFigs(_ L: Big, _ R: Big, _ gap: Big) -> Int {
  if gap.isZero { return 999 }
  let m = L < R ? L : R
  var H = -1; var scaled = gap
  while scaled < m { H += 1; scaled = scaled * Big(10) }
  return max(0, H)
}
func mark(_ closes: Bool) -> String { closes ? "CLOSES (false) — fooled" : "refuted" }

// ============================ the study ============================
print("AFFINE.EARTH SHEAR STUDY — THE FERMAT NEAR-MISS FRACTAL SHEAR")
print("The float sees a solution that is not there. The exact court refutes it — at every scale.")
print("")

struct NM { let a: UInt64; let b: UInt64; let c: UInt64; let n: Int; let label: String }
let cases: [NM] = [
  NM(a: 1782, b: 1841, c: 1922, n: 12, label: "Simpsons, Treehouse of Horror VI (1995)"),
  NM(a: 3987, b: 4365, c: 4472, n: 12, label: "Simpsons, Wizard of Evergreen Terrace (1998)"),
]

var sealLines: [String] = []
print("A · PRESENTED NEAR-MISSES — exact refutation vs finite-precision observers")
print("    (single ~7 figs · calculator ~10 figs · double ~16 figs)")
print(String(repeating: "-", count: 92))
for nm in cases {
  let a = Big(nm.a), b = Big(nm.b), c = Big(nm.c)
  let L = a.pow(nm.n) + b.pow(nm.n), R = c.pow(nm.n)
  let gap = L < R ? R - L : L - R
  let H = agreementSigFigs(L, R, gap)
  print("• \(nm.a)^\(nm.n) + \(nm.b)^\(nm.n)  vs  \(nm.c)^\(nm.n)   — \(nm.label)")
  print("    EXACT     : REFUTED — not a solution · gap = \(gap.shortDigits)")
  print("    the two sides agree to \(H) significant figures, then part.")
  print("    single ~7 : \(mark(7  <= H))   calculator ~10 : \(mark(10 <= H))   double ~16 : \(mark(16 <= H))")
  sealLines.append("\(nm.a),\(nm.b),\(nm.c),\(nm.n)|gap=\(gap.digits)|H=\(H)")
}

print("")
print("B · A CONSTRUCTED NEAR-MISS DEEP ENOUGH TO FOOL THE DOUBLE OBSERVER TOO")
print("    (every finite width has a horizon; the exact court has none)")
print(String(repeating: "-", count: 92))
do {
  let a = Big(100_000_000_000_000_000), b = Big(100_000_000_000_000_000), n = 3
  let S = a.pow(n) + b.pow(n)
  let c = intNthRoot(S, n)
  let L = S, R = c.pow(n)
  let gap = L < R ? R - L : L - R
  let H = agreementSigFigs(L, R, gap)
  print("• (10^17)^3 + (10^17)^3  vs  c^3   with c = floor(cube-root) = \(c.digits)")
  print("    EXACT     : REFUTED — not a solution · gap = \(gap.shortDigits)")
  print("    the two sides agree to \(H) significant figures, then part.")
  print("    single ~7 : \(mark(7  <= H))   calculator ~10 : \(mark(10 <= H))   double ~16 : \(mark(16 <= H))")
  sealLines.append("1e17,1e17,\(c.digits),3|gap=\(gap.digits)|H=\(H)")
}

print("")
print("C · INFINITE ZOOM — dilate the (3987,4365,4472) near-miss by k; refute at every depth")
print("    exact gap grows as k^n and never vanishes; the observer horizon is scale-invariant,")
print("    so a calculator's false closure persists at EVERY depth.")
print(String(repeating: "-", count: 92))
print("   depth k          EXACT                         calculator ~10 figs")
let bcase = cases[1]
var k = Big(1)
for e in 0...6 {
  let a = Big(bcase.a) * k, b = Big(bcase.b) * k, c = Big(bcase.c) * k
  let L = a.pow(bcase.n) + b.pow(bcase.n), R = c.pow(bcase.n)
  let gap = L < R ? R - L : L - R
  let H = agreementSigFigs(L, R, gap)
  let kd = k.digits
  let pad = String(repeating: " ", count: max(0, 12 - kd.count))
  print("   10^\(e)=\(kd)\(pad)  REFUTED (gap \(gap.numDigits) digits)      \(mark(10 <= H))")
  sealLines.append("zoom10^\(e)|gapdigits=\(gap.numDigits)|H=\(H)")
  k = k * Big(10)
}

// ---------------- minimal SHA-256 (no Foundation) ----------------
enum SHA256 {
  static let k: [UInt32] = [
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
  static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }
  static func hash(_ text: String) -> String {
    var m = Array(text.utf8); let ml = UInt64(m.count) * 8
    m.append(0x80); while m.count % 64 != 56 { m.append(0) }
    for i in (0..<8).reversed() { m.append(UInt8((ml >> (UInt64(i) * 8)) & 0xff)) }
    var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
    var chunk = 0
    while chunk < m.count {
      var w = [UInt32](repeating: 0, count: 64)
      for i in 0..<16 {
        w[i] = (UInt32(m[chunk+i*4]) << 24) | (UInt32(m[chunk+i*4+1]) << 16) | (UInt32(m[chunk+i*4+2]) << 8) | UInt32(m[chunk+i*4+3])
      }
      for i in 16..<64 {
        let s0 = rotr(w[i-15],7) ^ rotr(w[i-15],18) ^ (w[i-15] >> 3)
        let s1 = rotr(w[i-2],17) ^ rotr(w[i-2],19) ^ (w[i-2] >> 10)
        w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
      }
      var a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7]
      for i in 0..<64 {
        let S1 = rotr(e,6) ^ rotr(e,11) ^ rotr(e,25); let ch = (e & f) ^ (~e & g)
        let t1 = hh &+ S1 &+ ch &+ k[i] &+ w[i]
        let S0 = rotr(a,2) ^ rotr(a,13) ^ rotr(a,22); let maj = (a & b) ^ (a & c) ^ (b & c)
        let t2 = S0 &+ maj
        hh = g; g = f; f = e; e = d &+ t1; d = c; c = b; b = a; a = t1 &+ t2
      }
      h[0]=h[0]&+a; h[1]=h[1]&+b; h[2]=h[2]&+c; h[3]=h[3]&+d; h[4]=h[4]&+e; h[5]=h[5]&+f; h[6]=h[6]&+g; h[7]=h[7]&+hh
      chunk += 64
    }
    let hx = Array("0123456789abcdef"); var out = ""
    for word in h { for i in (0..<8).reversed() { out.append(hx[Int((word >> (UInt32(i)*4)) & 0xf)]) } }
    return out
  }
}

let seal = SHA256.hash(sealLines.joined(separator: "\n"))
print("")
print(String(repeating: "=", count: 92))
print("MARKER: FLT_NEARMISS_FRACTAL_SHEAR__EXACT_IS_OBSERVER_INVARIANT")
print("SEAL   sha256 over every exact verdict = \(seal)")
print("       byte-identical on every machine, because every verdict is an exact integer comparison.")
print("")
print("SCOPE — stated by the program, not just the page:")
print("  This REFUTES presented near-misses exactly, at every zoom depth. It does NOT prove the")
print("  universal Fermat's Last Theorem: dilation visits only the ray k*(a,b,c), and by homogeneity")
print("  every scale returns the same verdict for that one triple. The universal is the discovery")
print("  move — NOT KNOWN here, by design (LAW 1: verify the presented, never a solved-from-search verdict).")
