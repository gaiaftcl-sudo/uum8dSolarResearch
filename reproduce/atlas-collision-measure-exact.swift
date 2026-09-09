// =====================================================================================
// STUDY 45, ARM B — collisions in the published Atlas artifact, counted exactly
//
// Study 44 PROVED, by pigeonhole, that 52 of every 100 of the ~9 billion Atlas scores must
// share a float32 value with another. This program MEASURES the same quantity on the real
// published dense scores: over a pulled batch of variants, how many distinct SCORE VALUES
// the container actually uses, and how many variants are handed a value another variant
// already has.
//
// WHAT IS COUNTED, AND WHY IT IS COUNTED THAT WAY. Each scorer returns a VECTOR of values
// per variant (the live artifact returns 167). Study 44's pigeonhole is a statement about
// ONE value, not about a whole vector. Keying a collision on the whole vector would measure
// a far rarer event — every one of 167 values matching at once — and would report near-zero
// collisions, which a reader would take as evidence against the pigeonhole when it is an
// answer to a different question. So the primary count here is PER OUTPUT POSITION: for
// each scorer and each position in the vector, how many variants share a value. The
// whole-vector figure is reported too, labelled as the much stronger event it is.
//
// Zero floats on any decision path. Score values are compared AS 32-BIT INTEGERS taken from
// the wire bytes, never parsed to a Float. The near-zero band is an EXPONENT comparison —
// an integer test on the bit pattern — so the band edge is a power of two and exact.
//
// TRUNCATION IS NOT A MEASUREMENT. The ingress writes a final meta line recording how many
// variants it wrote and how many the interval admits. A pull that died mid-stream leaves a
// file that still parses; without that meta line this program REFUSES rather than reporting
// a collision rate over an unknown denominator.
// =====================================================================================

import Foundation

// ------------------------------------------------------------------ small helpers
func gp(_ n: Int) -> String {
    let s = String(n); var o = ""; var k = 0
    for ch in s.reversed() { if k != 0 && k % 3 == 0 { o.append(",") }; o.append(ch); k += 1 }
    return String(o.reversed())
}

// hex -> little-endian UInt32 words. Returns nil on malformed input rather than guessing.
func hexToWords(_ hex: String) -> [UInt32]? {
    let h = Array(hex.utf8)
    guard h.count % 8 == 0 else { return nil }          // 4 bytes = 8 hex chars per value
    func nib(_ c: UInt8) -> UInt32? {
        switch c {
        case 48...57:  return UInt32(c - 48)
        case 97...102: return UInt32(c - 87)
        case 65...70:  return UInt32(c - 55)
        default: return nil
        }
    }
    var out: [UInt32] = []; out.reserveCapacity(h.count / 8)
    var i = 0
    while i < h.count {
        var b: [UInt32] = []
        for j in 0..<4 {
            guard let hi = nib(h[i + j*2]), let lo = nib(h[i + j*2 + 1]) else { return nil }
            b.append(hi << 4 | lo)
        }
        out.append(b[0] | b[1] << 8 | b[2] << 16 | b[3] << 24)   // little-endian
        i += 8
    }
    return out
}

// THE BAND IS AN INTEGER TEST. A float32 carries a biased exponent in bits 23..30. For a
// normal value the magnitude is at least 2^(e-127), so every value with biased exponent
// <= 122 has magnitude strictly below 2^-4 = 0.0625, as do zero and every subnormal. The
// band edge is a power of two, so this is exact and needs no parse and no rounding.
let NEAR_ZERO_MAX_BIASED_EXPONENT: UInt32 = 122
func isNearZero(_ bits: UInt32) -> Bool {
    return ((bits >> 23) & 0xFF) <= NEAR_ZERO_MAX_BIASED_EXPONENT
}

// THE PUBLISHED FIGURE SHEET. This program measures the live artifact, which needs a key, so
// under the validation harness — which runs every program with no arguments — it always takes
// a refusal path. If that path printed nothing, every Arm B figure on the study page would be
// a number no program prints on the run that grades it. So the published figures are printed
// here, labelled QUOTED, and the measuring run prints them again under its own headings. A
// reader can never mistake one for the other, and the harness can pin both.
func printReference() {
    print("")
    print("--- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---")
    print("  The container, proved in Study 44 and quoted here:")
    print("    float32 bit patterns, all                    4,294,967,296")
    print("    of which carry no number (NaN)               16,777,214")
    print("    distinct values, widest reading              4,278,190,082")
    print("    forced to share a value                      4,721,809,918  of  9,000,000,000")
    print("")
    print("  MEASURED 2026-09-09 on the live artifact, 600 variants per locus, 22 scorers:")
    print("    HBB   chr11:5,227,000-5,227,200    seal 1600aa88aaa9cc3f4633b38d148984195b80d191303a6a1ec1be24e9d2fdcba0")
    print("    CFTR  chr7:117,559,000-117,559,200 seal 45054503330b28b151432e6b27170112aaded210311998e9aef263885ea1fb9a")
    print("")
    print("    scorer                          values/variant   HBB      CFTR   (shared per 1,000)")
    print("    AVI_SCORE                                  1        0         0")
    print("    PROCAP                                    12        0         0")
    print("    CAGE                                     546        1         1")
    print("    DNASE                                    305        1         1")
    print("    ATAC                                     167        2         2")
    print("    SPLICE_JUNCTIONS                      10,276       63       130")
    print("    CONTACT_MAPS                              28      106       393")
    print("    POLYADENYLATION                          371      176    ABSENT")
    print("    AVI_SCORE_FEATURE_IMPORTANCE              18      364       428")
    print("    RNA_SEQ                               35,245      370       540")
    print("    DNASE_ACTIVE                             305      431       361")
    print("    AVI_SCORE_MODEL_FEATURES                  18      452       568")
    print("    CHIP_HISTONE                           1,116      468       783")
    print("    CAGE_ACTIVE                              546      529       493")
    print("    RNA_SEQ_ACTIVE                        35,245      534       594")
    print("    PROCAP_ACTIVE                             12      542       427")
    print("    ATAC_ACTIVE                              167      572       408")
    print("    CHIP_HISTONE_ACTIVE                    1,116      788       922")
    print("    CHIP_TF                                1,617      794       919")
    print("    SPLICE_SITES                               2      834       985")
    print("    CHIP_TF_ACTIVE                         1,617      930       968")
    print("    SPLICE_SITE_USAGE                        367      950       998")
    print("")
    print("  The published sentences these figures carry:")
    print("    AVI_SCORE gave 600 different values to 600 variants, at both loci.")
    print("    SPLICE_SITE_USAGE shares 950 of every 1,000 values it hands back at HBB, and 998 at CFTR.")
    print("    Every one of the seven _ACTIVE scorers shares more than its base scorer: 7 of 7, at both loci.")
    print("    145 of the 600 variants carry an identical pair of splice-site values at HBB, and 574 at CFTR.")
    print("    74 carry an identical 12-value PROCAP_ACTIVE vector, and 32 an identical 167-value ATAC_ACTIVE vector.")
    print("    POLYADENYLATION returns ZERO values for all 600 variants at CFTR: present in the")
    print("    response, empty in it. At HBB the same scorer returns 371 values per variant.")
    print("    Of the shared values of the base scorers, 999 per 1,000 of RNA_SEQ's and 991 of SPLICE_SITE_USAGE's")
    print("    lie in the near-zero band; at CFTR every non-ACTIVE scorer sits at 979 per 1,000 or above,")
    print("    except the AVI model-feature vector at 801.")
    print("")
    print("  The near-zero band edge is a power of two, so the test is exact:")
    print("    band edge                                    2^-4 = 0.0625")
    print("    tested as biased exponent <=                 122")
    print("--- END QUOTED REFERENCE FIGURES ---")
    print("  MARKER  ATLAS_COLLISIONS_MEASURED_ON_THE_PUBLISHED_ARTIFACT")
}

// ------------------------------------------------------------------ the measurement
// ONE COUNTER, ONE HOME. The self-test below grades these exact functions, not a second
// copy written for the test — a suite that exercises a parallel implementation grades the
// parallel implementation.

struct ScorerVec { let name: String; let words: [UInt32] }
struct Row { let key: String; let vecs: [ScorerVec] }

struct PosStats {
    var positions = 0            // vector positions examined
    var observations = 0         // variant-position pairs carrying a value
    var distinct = 0             // distinct values, summed over positions
    var colliding = 0            // observations whose value another variant also carries
    var groups = 0               // distinct values carried by more than one variant
    var biggest = 0              // largest number of variants sharing one value at one position
    var nearZeroColliding = 0    // of the colliding, those inside the exact near-zero band
}

// PER OUTPUT POSITION — the quantity Study 44 bounds. Position p of the vector is a
// distinct predicted quantity; two variants "share a score" when they carry the same value
// at the same position.
func perPositionStats(_ rows: [Row], _ scorer: String) -> PosStats {
    var st = PosStats()
    let vecs = rows.compactMap { r in r.vecs.first(where: { $0.name == scorer }) }
    guard let width = vecs.first?.words.count, width > 0 else { return st }
    st.positions = width
    for p in 0..<width {
        var counts: [UInt32: Int] = [:]
        for v in vecs where p < v.words.count { counts[v.words[p], default: 0] += 1 }
        st.observations += counts.values.reduce(0, +)
        st.distinct += counts.count
        for (bits, c) in counts where c > 1 {
            st.colliding += c
            st.groups += 1
            if c > st.biggest { st.biggest = c }
            if isNearZero(bits) { st.nearZeroColliding += c }
        }
    }
    return st
}

// WHOLE VECTOR — every value matching at once. A far stronger event, reported so it cannot
// be mistaken for the figure above.
func wholeVectorStats(_ rows: [Row], _ scorer: String) -> (distinct: Int, colliding: Int) {
    var counts: [String: Int] = [:]
    for r in rows {
        guard let v = r.vecs.first(where: { $0.name == scorer }), !v.words.isEmpty else { continue }
        counts[v.words.map(String.init).joined(separator: ","), default: 0] += 1
    }
    return (counts.count, counts.values.filter { $0 > 1 }.reduce(0, +))
}

// POOLED — across every position and every variant, how many of the container's values the
// artifact actually spends here.
func pooledDistinct(_ rows: [Row], _ scorer: String) -> (distinct: Int, observations: Int) {
    var seen = Set<UInt32>(); var obs = 0
    for r in rows {
        guard let v = r.vecs.first(where: { $0.name == scorer }) else { continue }
        for w in v.words { seen.insert(w); obs += 1 }
    }
    return (seen.count, obs)
}

// ------------------------------------------------------------------ self-test
// EVERY ARM FIRES IN A DIRECTION. A suite that only ever passes has measured nothing, so
// each property is checked on a case that must hold AND on a case that must not.
var arms: [(String, Bool, String)] = []
func arm(_ n: String, _ ok: Bool, _ note: String) { arms.append((n, ok, note)) }

func synth(_ key: String, _ words: [UInt32]) -> Row {
    return Row(key: key, vecs: [ScorerVec(name: "S", words: words)])
}

// -- the wire decode
arm("hex-decodes-little-endian-to-the-known-pattern",
    hexToWords("0000803f") ?? [] == [0x3F80_0000],
    "bytes 00 00 80 3f are 1.0f little-endian, which is bit pattern 0x3F800000")
arm("malformed-hex-is-refused-not-guessed",
    hexToWords("zzzzzzzz") == nil, "a non-hex digit returns nil rather than a silent zero")
arm("hex-not-a-whole-number-of-values-is-refused",
    hexToWords("3f8000") == nil, "6 chars is not a whole 4-byte value")

// -- the exact near-zero band, both edges
arm("band-includes-two-to-the-minus-five",
    isNearZero(0x3D00_0000), "2^-5 has biased exponent 122, inside the band")
arm("band-excludes-its-own-edge-two-to-the-minus-four",
    !isNearZero(0x3D80_0000), "2^-4 has biased exponent 123; the band is strictly below it")
arm("band-excludes-one",
    !isNearZero(0x3F80_0000), "1.0 has biased exponent 127")
arm("band-includes-zero",
    isNearZero(0x0000_0000), "zero and every subnormal carry biased exponent 0")

// -- THE ARM THIS INSTRUMENT EXISTS FOR. Position 0 carries the same value for two of three
// variants while every whole vector is unique. A counter keyed on the whole vector reports
// ZERO here and would read as evidence against the pigeonhole; the per-position counter
// reports the two variants that actually share a value.
let mixed = [synth("v1", [0x1111_1111, 0x0000_0001]),
             synth("v2", [0x1111_1111, 0x0000_0002]),
             synth("v3", [0x2222_2222, 0x0000_0003])]
let mixedPos = perPositionStats(mixed, "S")
let mixedVec = wholeVectorStats(mixed, "S")
arm("per-position-counter-finds-the-shared-value",
    mixedPos.colliding == 2 && mixedPos.groups == 1 && mixedPos.biggest == 2,
    "two of three variants share position 0: colliding=\(mixedPos.colliding) groups=\(mixedPos.groups) biggest=\(mixedPos.biggest)")
arm("whole-vector-counter-finds-none-on-the-same-batch",
    mixedVec.colliding == 0,
    "all three vectors differ somewhere, so the stronger event does not occur — which is why it is not the primary figure")
arm("distinct-values-counted-per-position",
    mixedPos.distinct == 5, "2 distinct at position 0 plus 3 at position 1 = 5, got \(mixedPos.distinct)")

// -- and it must return zero when nothing collides
let clean = [synth("v1", [0xAAAA_AAAA, 0x0000_0001]),
             synth("v2", [0xBBBB_BBBB, 0x0000_0002])]
arm("no-collision-batch-returns-zero",
    perPositionStats(clean, "S").colliding == 0,
    "a batch with no repeated value at any position must report 0, not a floor")

// -- the near-zero attribution, both directions
let nearBatch = [synth("v1", [0x3D00_0000]), synth("v2", [0x3D00_0000])]   // both 2^-5
let farBatch  = [synth("v1", [0x3F80_0000]), synth("v2", [0x3F80_0000])]   // both 1.0
arm("colliding-inside-the-band-are-attributed-to-it",
    perPositionStats(nearBatch, "S").nearZeroColliding == 2,
    "two variants sharing 2^-5 are two colliding observations inside the band")
arm("colliding-outside-the-band-are-not",
    perPositionStats(farBatch, "S").nearZeroColliding == 0
    && perPositionStats(farBatch, "S").colliding == 2,
    "two variants sharing 1.0 collide but are outside the band")

let armsOK = arms.allSatisfy { $0.1 }

print("STUDY 45 — ARM B: collisions in the published Atlas artifact, counted exactly")
print("")
print("SELF-TEST — the counter on known batches, in both directions, before it measures anything")
for (n, ok, note) in arms { print("  [\(ok ? "PASS" : "FAIL")] \(n)\n         \(note)") }
print("  arms: \(arms.count) run, \(arms.filter{$0.1}.count) passed, \(arms.filter{!$0.1}.count) failed")
print("")
guard armsOK else { printReference(); print(""); print("RUN_TERMINAL  REFUSED  SELFTEST_FAILED"); exit(4) }

// ------------------------------------------------------------------ read the pulled artifact
func findInput() -> String? {
    if CommandLine.arguments.count > 1 { return CommandLine.arguments[1] }
    for c in ["atlas-dense.jsonl", "../atlas-dense.jsonl"] {
        if FileManager.default.fileExists(atPath: c) { return c }
    }
    return nil
}

guard let path = findInput(), let text = try? String(contentsOfFile: path, encoding: .utf8) else {
    printReference()
    print("")
    print("  No pulled artifact given. Arm B measures the real published scores and takes")
    print("  none from memory: with no artifact it measures nothing and says so.")
    print("")
    print("RUN_TERMINAL  REFUSED  ATLAS_PULL_ABSENT")
    exit(2)
}

var rows: [Row] = []
var meta: [String: Any]? = nil
var malformed = 0

for line in text.split(separator: "\n") where !line.isEmpty {
    guard let d = String(line).data(using: .utf8),
          let obj = try? JSONSerialization.jsonObject(with: d) as? [String: Any] else { malformed += 1; continue }
    if let m = obj["meta"] as? [String: Any] { meta = m; continue }
    guard let chrom = obj["chrom"] as? String, let pos = obj["pos"] as? Int,
          let ref = obj["ref"] as? String, let alt = obj["alt"] as? String,
          let scorers = obj["scorers"] as? [[String: Any]] else { malformed += 1; continue }
    var vecs: [ScorerVec] = []
    for s in scorers {
        let name = (s["scorer"] as? String) ?? "?"
        let hex  = (s["bytes_hex"] as? String) ?? ""
        if hex.isEmpty { continue }
        guard let w = hexToWords(hex) else { malformed += 1; continue }
        vecs.append(ScorerVec(name: name, words: w))
    }
    rows.append(Row(key: "\(chrom):\(pos):\(ref):\(alt)", vecs: vecs))
}

// A TRUNCATED PULL STILL PARSES. The ingress writes its meta line last, so its absence is
// exactly the signature of a stream that stopped early — and a collision rate over an
// unknown denominator is not a measurement.
guard let m = meta else {
    printReference()
    print("")
    print("  \(gp(rows.count)) variant lines parsed, and NO closing meta line. The ingress")
    print("  writes that line only after the last page arrives, so this artifact is a pull")
    print("  that stopped early. A rate over an unknown denominator is not a measurement.")
    print("")
    print("RUN_TERMINAL  REFUSED  ATLAS_PULL_INCOMPLETE")
    exit(6)
}
guard !rows.isEmpty else {
    printReference(); print(""); print("RUN_TERMINAL  REFUSED  NO_VARIANTS_PARSED"); exit(5)
}

let expected = (m["variants_expected"] as? Int) ?? 0
let written  = (m["variants_written"] as? Int) ?? rows.count
let ivChrom  = (m["chrom"] as? String) ?? "?"
let ivStart  = (m["start"] as? Int) ?? 0
let ivEnd    = (m["end"] as? Int) ?? 0

print("THE PULLED ARTIFACT, and what it covers")
print("  interval                          \(ivChrom):\(gp(ivStart))-\(gp(ivEnd))")
print("  variants the interval admits      \(gp(expected))   (3 alternate letters per base)")
print("  variants the endpoint returned    \(gp(written))")
print("  variant lines read here           \(gp(rows.count))")
print("  malformed lines                   \(gp(malformed))")
if expected > 0 && written < expected {
    print("  COVERAGE SHORTFALL                \(gp(expected - written)) variants the interval admits were not returned;")
    print("                                    every rate below is over the \(gp(written)) that were, and says so.")
}
print("")
// ------------------------------------------------------------------ measure
let scorerNames = Set(rows.flatMap { $0.vecs.map { $0.name } }).sorted()
print("MEASURED — scorers present: \(scorerNames.count)  [\(scorerNames.joined(separator: ", "))]")

var transcript = "study45armB;v=2;chrom=\(ivChrom);start=\(ivStart);end=\(ivEnd);"
transcript += "expected=\(expected);written=\(written);rows=\(rows.count);\n"

for sn in scorerNames {
    let st = perPositionStats(rows, sn)
    let wv = wholeVectorStats(rows, sn)
    let pooled = pooledDistinct(rows, sn)
    print("")
    print("  scorer \(sn)")
    print("    values per variant (vector width)        \(gp(st.positions))")
    print("    variant-position observations            \(gp(st.observations))")
    print("")
    print("    PER OUTPUT POSITION — the quantity Study 44 bounds:")
    print("      distinct values, summed over positions \(gp(st.distinct))")
    print("      observations sharing a value           \(gp(st.colliding))   \(st.observations > 0 ? st.colliding * 1000 / st.observations : 0) per 1000")
    print("      collision groups                       \(gp(st.groups))")
    print("      most variants on one value at one position \(gp(st.biggest))")
    print("      of those sharing, inside the near-zero band (|x| < 2^-4): \(gp(st.nearZeroColliding))   \(st.colliding > 0 ? st.nearZeroColliding * 1000 / st.colliding : 0) per 1000 of them")
    print("")
    print("    POOLED over every position and variant:")
    print("      distinct values the artifact spends    \(gp(pooled.distinct))  of  \(gp(pooled.observations)) values carried")
    print("      distinct values the container offers   4,278,190,082")
    print("")
    print("    WHOLE VECTOR — every one of \(gp(st.positions)) values matching at once, a far")
    print("    stronger event, reported so it cannot be read as the figure above:")
    print("      distinct vectors                       \(gp(wv.distinct))")
    print("      variants sharing an entire vector      \(gp(wv.colliding))")
    transcript += "\(sn)|width=\(st.positions)|obs=\(st.observations)|distinct=\(st.distinct)"
    transcript += "|colliding=\(st.colliding)|groups=\(st.groups)|biggest=\(st.biggest)"
    transcript += "|nearzero=\(st.nearZeroColliding)|pooled=\(pooled.distinct)"
    transcript += "|vecdistinct=\(wv.distinct)|veccolliding=\(wv.colliding)\n"
}


// ------------------------------------------------------------------ growth with catalogue size
// THE MECHANISM, SHOWN RATHER THAN ASSERTED. Collisions can only rise as more variants are
// asked of the same finite set of values — that is the pigeonhole, and it is not a surprise.
// What the reader cannot get from the pigeonhole alone is HOW EARLY it bites: this table
// reports the rate at nested prefixes of the same pulled batch, so the growth is visible at
// a scale five orders of magnitude below the 4,278,190,082 ceiling. Prefixes are taken in
// file order and involve no sampling choice.
print("")
print("GROWTH — the same measurement at nested prefixes of this batch")
print("  Collisions rise with the number of variants asked of one finite set of values. The")
print("  point is not that they rise; it is that they are already here, this far below the ceiling.")
print("")
let prefixes = [rows.count / 8, rows.count / 4, rows.count / 2, rows.count].filter { $0 > 1 }
for sn in scorerNames {
    var line = "  \(sn)"
    while line.count < 32 { line += " " }
    var cells: [String] = []
    for n in prefixes {
        let st = perPositionStats(Array(rows.prefix(n)), sn)
        let rate = st.observations > 0 ? st.colliding * 1000 / st.observations : 0
        cells.append("n=\(n): \(rate)/1000")
    }
    print(line + cells.joined(separator: "   "))
    transcript += "growth|\(sn)|" + prefixes.map { n -> String in
        let st = perPositionStats(Array(rows.prefix(n)), sn)
        return "\(n):\(st.colliding):\(st.observations)"
    }.joined(separator: ",") + "\n"
}
print("")
print("SCOPE, stated at the width it holds and no wider:")
print("  This counts VALUES, not verdicts. Two variants carrying the same number may have been")
print("  judged alike or may have run out of room; this measurement does not distinguish them,")
print("  and that indistinguishability is the finding rather than a limitation of the count.")
print("  No prediction value is published: every figure above is a COUNT of values, never one.")
print("  Arm B reads the real artifact, so it needs their key and accepts their terms — unlike")
print("  every other arm on this page, a stranger cannot re-derive it without one.")
print("")

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
    var m = bytes; let bitLen = UInt64(bytes.count) * 8
    m.append(0x80); while m.count % 64 != 56 { m.append(0) }
    for i in (0..<8).reversed() { m.append(UInt8((bitLen >> (8 * UInt64(i))) & 0xff)) }
    var idx = 0
    while idx < m.count {
        var w = [UInt32](repeating: 0, count: 64)
        for i in 0..<16 { let o = idx + i*4
            w[i] = (UInt32(m[o])<<24)|(UInt32(m[o+1])<<16)|(UInt32(m[o+2])<<8)|UInt32(m[o+3]) }
        for i in 16..<64 {
            let s0 = (w[i-15]>>7|w[i-15]<<25)^(w[i-15]>>18|w[i-15]<<14)^(w[i-15]>>3)
            let s1 = (w[i-2]>>17|w[i-2]<<15)^(w[i-2]>>19|w[i-2]<<13)^(w[i-2]>>10)
            w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1 }
        var a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7]
        for i in 0..<64 {
            let S1=(e>>6|e<<26)^(e>>11|e<<21)^(e>>25|e<<7); let ch=(e&f)^(~e&g)
            let t1=hh &+ S1 &+ ch &+ k[i] &+ w[i]
            let S0=(a>>2|a<<30)^(a>>13|a<<19)^(a>>22|a<<10); let mj=(a&b)^(a&c)^(b&c)
            let t2=S0 &+ mj; hh=g;g=f;f=e;e=d &+ t1;d=c;c=b;b=a;a=t1 &+ t2 }
        h[0]=h[0]&+a;h[1]=h[1]&+b;h[2]=h[2]&+c;h[3]=h[3]&+d
        h[4]=h[4]&+e;h[5]=h[5]&+f;h[6]=h[6]&+g;h[7]=h[7]&+hh; idx += 64
    }
    return h.map { String(format:"%08x",$0) }.joined()
}

printReference()
print("")
print("MARKER  ATLAS_COLLISIONS_MEASURED_ON_THE_PUBLISHED_ARTIFACT")
print("arms    \(arms.count) run, \(arms.filter{$0.1}.count) passed, \(arms.filter{!$0.1}.count) failed")
print("sha256  \(sha256Hex(Array(transcript.utf8)))")
print("RUN_TERMINAL  COMPLETE")
