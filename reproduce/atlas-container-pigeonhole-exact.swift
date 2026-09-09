// =====================================================================================
// STUDY 44 — THE ATLAS CONTAINER
//
// A catalogue of 9 billion predictions ships its numbers as single-precision floats.
// This program measures what that container can hold, in exact integers, and compares it
// with how many things are put into it. Nothing here grades a model, a prediction, or a
// biological claim. The subject under grading is the CONTAINER.
//
// Every figure below is an integer. No floating-point arithmetic appears on any decision
// path: the IEEE-754 facts are BIT PATTERN COUNTS, which are integers, and each one is
// checked against the value the platform actually produces before it is used.
//
// INPUTS, both public, neither requiring an account, a key, or accepting any terms:
//   1. corpus/alphagenome-atlas/atlas_service.proto   (Apache-2.0, Google DeepMind)
//      digest verified here; the sentence this study turns on is GREPPED from that file
//      rather than quoted from memory.
//   2. a row count, carried two ways — their announced figure as REPORTED, and a count
//      re-derived from a corpus already in this repository.
// =====================================================================================

import Foundation

let PROTO_SHA256 = "037e8ca50171582db7bf63780e87cb37d8dfeb2c078573412bdd71c0d69f1ed9"
// The sentence, split as it is split across two comment lines in the file.
let CLAIM_A = "Values are stored as single"
let CLAIM_B = "precision floats."

// Row counts. The study uses the SMALLER wherever a larger one would flatter it.
let ANNOUNCED_VARIANTS = 9_000_000_000                 // REPORTED, their announcement
let GRCH38_BASES       = 3_099_750_718                 // MEASURED, our own corpus
let ALT_PER_BASE       = 3
let DERIVED_VARIANTS   = GRCH38_BASES * ALT_PER_BASE

// ---------------------------------------------------------------- IEEE-754, as integers
let F32_TOTAL_PATTERNS  = 1 << 32                       // 4294967296
let F32_MANTISSA_BITS   = 23
let F32_NAN_PATTERNS    = 2 * ((1 << F32_MANTISSA_BITS) - 1)   // both signs, non-zero mantissa
let F32_INF_PATTERNS    = 2                             // +inf, -inf: not scores
let F32_DUPLICATE_ZERO  = 1                             // +0 and -0 are one value
let F32_ONE_PATTERN     = 0x3F80_0000                   // 1.0f
let F64_ONE_PATTERN     = 0x3FF0_0000_0000_0000         // 1.0d

func sha256Hex(_ bytes: [UInt8]) -> String {
    var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
    let k: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    var m = bytes
    let bitLen = UInt64(bytes.count) * 8
    m.append(0x80)
    while m.count % 64 != 56 { m.append(0) }
    for i in (0..<8).reversed() { m.append(UInt8truncating(bitLen >> (8 * UInt64(i)))) }
    func UInt8truncating(_ v: UInt64) -> UInt8 { UInt8(v & 0xff) }
    var idx = 0
    while idx < m.count {
        var w = [UInt32](repeating: 0, count: 64)
        for i in 0..<16 {
            let o = idx + i * 4
            w[i] = (UInt32(m[o]) << 24) | (UInt32(m[o+1]) << 16) | (UInt32(m[o+2]) << 8) | UInt32(m[o+3])
        }
        for i in 16..<64 {
            let s0 = (w[i-15] >> 7 | w[i-15] << 25) ^ (w[i-15] >> 18 | w[i-15] << 14) ^ (w[i-15] >> 3)
            let s1 = (w[i-2] >> 17 | w[i-2] << 15) ^ (w[i-2] >> 19 | w[i-2] << 13) ^ (w[i-2] >> 10)
            w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
        }
        var a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7]
        for i in 0..<64 {
            let S1 = (e >> 6 | e << 26) ^ (e >> 11 | e << 21) ^ (e >> 25 | e << 7)
            let ch = (e & f) ^ (~e & g)
            let t1 = hh &+ S1 &+ ch &+ k[i] &+ w[i]
            let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
            let mj = (a & b) ^ (a & c) ^ (b & c)
            let t2 = S0 &+ mj
            hh = g; g = f; f = e; e = d &+ t1; d = c; c = b; b = a; a = t1 &+ t2
        }
        h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
        h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
        idx += 64
    }
    return h.map { String(format: "%08x", $0) }.joined()
}

func gp(_ n: Int) -> String {
    let s = String(n); var out = ""; var c = 0
    for ch in s.reversed() { if c != 0 && c % 3 == 0 { out.append(",") }; out.append(ch); c += 1 }
    return String(out.reversed())
}

// ------------------------------------------------------------- the published reference
func printQuotedReference() {
    print("")
    print("--- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---")
    print("  the container, from atlas_service.proto line 76-77, field 4 of DenseVariantScore:")
    print("      // N-d array of scores, in row-major order. Values are stored as single")
    print("      // precision floats.")
    print("      bytes scores = 4;")
    print("  proto sha256          \(PROTO_SHA256)")
    print("  announced variants    9,000,000,000            REPORTED, Google DeepMind 2026-09-08")
    print("  GRCh38 bases          3,099,750,718            MEASURED, corpus/crispr-clinical/")
    print("  non-NaN float32       4,278,190,082")
    print("  forced collisions     4,721,809,918            52 per 100 variants, unconditional")
    print("  float32 values in 0..1  1,065,353,216")
    print("  float64 values in 0..1  4,607,182,418,800,017,408")
    print("--- END QUOTED REFERENCE FIGURES ---")
}

func refuse(_ reason: String, _ code: Int32) -> Never {
    printQuotedReference()
    print("")
    print("RUN_TERMINAL  REFUSED  \(reason)")
    exit(code)
}

print("STUDY 44 — THE ATLAS CONTAINER")
print("How many distinct numbers can a single-precision container hold, against how many")
print("things are put into it. The subject under grading is the CONTAINER, never a model,")
print("never a prediction, and never anybody's biology.")
print("")

// ------------------------------------------------------------------- arms, before input
var arms: [(String, Bool, String)] = []
func arm(_ n: String, _ ok: Bool, _ note: String) { arms.append((n, ok, note)) }

// The platform must agree with the constants, or the constants are decoration.
arm("float32-one-bit-pattern-is-what-ieee-says",
    Float(1.0).bitPattern == UInt32(F32_ONE_PATTERN),
    "0x3F800000 == \(F32_ONE_PATTERN); platform reports \(Float(1.0).bitPattern)")
arm("float64-one-bit-pattern-is-what-ieee-says",
    Double(1.0).bitPattern == UInt64(F64_ONE_PATTERN),
    "platform reports \(Double(1.0).bitPattern)")
arm("float32-zero-is-pattern-zero",
    Float(0.0).bitPattern == 0, "so the 0..1 span is exactly the 1.0 pattern")
arm("nan-count-derived-not-assumed",
    F32_NAN_PATTERNS == 16_777_214 && Float(Float32.nan).isNaN,
    "2 x (2^23 - 1) = \(gp(F32_NAN_PATTERNS)) patterns carry no number")

// NEGATIVE ARM: pigeonhole must return ZERO when the container is big enough.
let smallN = 1_000
let forcedSmall = max(0, smallN - (F32_TOTAL_PATTERNS - F32_NAN_PATTERNS))
arm("pigeonhole-returns-zero-when-container-suffices",
    forcedSmall == 0,
    "1,000 variants in \(gp(F32_TOTAL_PATTERNS - F32_NAN_PATTERNS)) slots forces \(forcedSmall) collisions")

// POSITIVE ARM: and a non-zero answer when it does not.
let slotsAll = F32_TOTAL_PATTERNS - F32_NAN_PATTERNS
let forcedAll = max(0, ANNOUNCED_VARIANTS - slotsAll)
arm("pigeonhole-returns-nonzero-when-it-does-not",
    forcedAll > 0, "\(gp(ANNOUNCED_VARIANTS)) variants in \(gp(slotsAll)) slots forces \(gp(forcedAll))")

// The derived count must exceed the announced one, or we may not call it conservative.
arm("derived-count-exceeds-announced-so-announced-is-the-conservative-choice",
    DERIVED_VARIANTS > ANNOUNCED_VARIANTS,
    "\(gp(GRCH38_BASES)) x 3 = \(gp(DERIVED_VARIANTS)) > \(gp(ANNOUNCED_VARIANTS))")

print("INSTRUMENT ARMS — every one runs before a byte of the proto is read")
for (n, ok, note) in arms { print("  [\(ok ? "PASS" : "FAIL")] \(n)\n         \(note)") }
let armsOK = arms.allSatisfy { $0.1 }
print("  arms: \(arms.count) run, \(arms.filter{$0.1}.count) passed, \(arms.filter{!$0.1}.count) failed")
print("")
if !armsOK { refuse("SELFTEST_FAILED", 4) }

// ------------------------------------------------------------------------ find the proto
func findProto() -> String? {
    var roots: [String] = [FileManager.default.currentDirectoryPath]
    if CommandLine.arguments.count > 1 { roots.insert(CommandLine.arguments[1], at: 0) }
    roots.append((CommandLine.arguments[0] as NSString).deletingLastPathComponent)
    for r0 in roots {
        var d = r0
        for _ in 0..<8 {
            let p = d + "/corpus/alphagenome-atlas/atlas_service.proto"
            if FileManager.default.fileExists(atPath: p) { return p }
            d = (d as NSString).deletingLastPathComponent
            if d.isEmpty || d == "/" { break }
        }
    }
    return nil
}

guard let protoPath = findProto(), let raw = FileManager.default.contents(atPath: protoPath) else {
    refuse("PROTO_ABSENT", 2)
}
let measuredDigest = sha256Hex([UInt8](raw))
print("CONTAINER SPECIFICATION — read from the file, never asserted")
print("  atlas_service.proto     \(raw.count) bytes")
print("  sha256 measured         \(measuredDigest)")
print("  sha256 pinned           \(PROTO_SHA256)")
if measuredDigest != PROTO_SHA256 { refuse("PROTO_DIGEST_MISMATCH", 3) }
print("  verdict                 MATCH — this is the file the study was written against")

guard let text = String(data: raw, encoding: .utf8) else { refuse("PROTO_NOT_UTF8", 5) }
let hasClaim = text.contains(CLAIM_A) && text.contains(CLAIM_B)
print("  the sentence, GREPPED from that file rather than quoted from memory:")
print("      \"\(CLAIM_A) \(CLAIM_B)\"   present: \(hasClaim)")
if !hasClaim { refuse("CONTAINER_SENTENCE_ABSENT", 6) }
print("")

// -------------------------------------------------------------------------- the measure
let slotsUnit = F32_ONE_PATTERN                        // patterns for [0,1]
let f64Unit   = F64_ONE_PATTERN
let forcedUnit = max(0, ANNOUNCED_VARIANTS - slotsUnit)

print("WHAT THE CONTAINER HOLDS — every number an integer count of bit patterns")
print("  float32 patterns, all            \(gp(F32_TOTAL_PATTERNS))")
print("  of which carry no number (NaN)   \(gp(F32_NAN_PATTERNS))")
print("  usable, widest possible reading  \(gp(slotsAll))")
print("     (this is a CEILING: it still counts both infinities and both zeros, so the")
print("      collision figures below are FLOORS and the true ones are larger)")
print("  float32 patterns in 0..1         \(gp(slotsUnit))")
print("  float64 patterns in 0..1         \(gp(f64Unit))")
print("")
print("WHAT IS PUT INTO IT")
print("  announced single-nucleotide variants   \(gp(ANNOUNCED_VARIANTS))   REPORTED")
print("  re-derived from GRCh38 in this repo    \(gp(DERIVED_VARIANTS))   \(gp(GRCH38_BASES)) x 3")
print("  the study uses the SMALLER of the two, which is theirs")
print("")
print("THE PIGEONHOLE, and it is arithmetic rather than an opinion about anyone's model")
print("  UNCONDITIONAL — holds whatever range the score takes:")
print("    variants that MUST share a value with another variant : \(gp(forcedAll))")
print("    that is \(forcedAll * 100 / ANNOUNCED_VARIANTS) of every 100 variants in the catalogue")
print("  IF the score is bounded to 0..1 — a reading this program does NOT verify:")
print("    variants that MUST share a value                      : \(gp(forcedUnit))")
print("    that is \(forcedUnit * 100 / ANNOUNCED_VARIANTS) of every 100")
print("    mean variants per representable value                 : \(ANNOUNCED_VARIANTS / slotsUnit)")
print("  the same catalogue in double precision, 0..1:")
print("    values available                                      : \(gp(f64Unit))")
print("    variants forced to share                              : \(max(0, ANNOUNCED_VARIANTS - f64Unit))")
print("")
print("WHAT THIS DOES NOT SAY, at the same volume as what it does")
print("  Not that any particular pair of variants collides. Pigeonhole proves collisions")
print("  EXIST; it names none of them, and this program names none.")
print("  Not that the model is wrong. Two variants may be genuinely equally impactful, and")
print("  a container that cannot tell those apart from two that are not is the finding.")
print("  Not a clinical statement of any kind. Their own terms say these predictions must")
print("  not be used for clinical decision-making, and this study does not use them at all:")
print("  it reads no prediction value, and none appears anywhere in this repository.")
print("")

var transcript = "study44;v=1;proto=\(measuredDigest);announced=\(ANNOUNCED_VARIANTS);derived=\(DERIVED_VARIANTS);"
transcript += "slotsAll=\(slotsAll);slotsUnit=\(slotsUnit);f64Unit=\(f64Unit);"
transcript += "forcedAll=\(forcedAll);forcedUnit=\(forcedUnit);arms=\(arms.count)/\(arms.filter{$0.1}.count)\n"
printQuotedReference()
print("")
print("MARKER  ATLAS_CONTAINER_CANNOT_DISTINGUISH_ITS_OWN_ROWS")
print("sha256  \(sha256Hex(Array(transcript.utf8)))")
print("RUN_TERMINAL  COMPLETE")
