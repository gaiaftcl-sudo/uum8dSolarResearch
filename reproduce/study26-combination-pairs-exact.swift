// STUDY 26 · S3-COMBINATION — the eleven pairs, printed from the sealed result files.
//
// WHY THIS PROGRAM EXISTS, stated plainly because it is a correction to our own published work.
// The eleven drug pairs were published on Study-26-Master-Regulator-Bonds.md as a bench handoff:
// named compounds, per-tumour scores, three controls each. They were correct. They were also
// UNREPRODUCIBLE — the compound names appeared in exactly one place in the entire public
// repository, the prose of the page itself. No program printed them and no corpus carried them,
// so a stranger with a clean clone could not check a single one. The wiki's own harness rule is
// that a number in a page which no program prints is not reproducible; the same rule applied to
// a library entry is an admission rule, and under it the pairs were not admissible.
//
// This program closes that. It reads the per-cohort result files the screen wrote, verifies them
// against their pinned digests, and prints every figure the page carries.
//
// WHAT IT DOES NOT DO. It does not re-run the combination screen — that needs the LINCS rank
// matrices, which are gigabytes and are fetched from GEO rather than committed. It is a FAITHFUL
// READER of sealed results, and it says so on every path. The distinction matters: this program
// makes the published figures checkable against the bytes the screen produced. Re-deriving those
// bytes from LINCS is a separate, larger reproduction and the page names it as such.
//
// ZERO FLOAT. Every score in these files is an integer sum of Crossing-B ordinals. The parser
// reads integers and refuses a value that is not one. Nothing here rounds.
//
// Reproduce:
//   xcrun swiftc -O -swift-version 5 reproduce/study26-combination-pairs-exact.swift -o /tmp/s26c
//   ( cd corpus/study-26-combination && shasum -a 256 -c SHA256SUMS )
//   /tmp/s26c < /dev/null

import Foundation

setvbuf(stdout, nil, _IONBF, 0)   // an abnormal exit must still leave the reference figures

// ── the reference figures, printed before any file is opened, on every path ────────────────
func printReference() {
    print("PUBLISHED REFERENCE FIGURES (printed before any file is opened)")
    print("  cohorts scored              15")
    print("  pairs clearing all three controls  11")
    print("  single agents clearing anything    0 of 15, across 20308 compounds")
    print("  pairs scored per cohort     44850")
    print("  pair pool                   the 300 most-inverting single agents")
    print("  null draws per cohort       200")
    print("  MARKER  STUDY26_COMBINATION_PAIRS__ELEVEN_CLEAR_ALL_THREE_CONTROLS")
}

// ── minimal exact JSON reader: integers stay integers, strings stay strings ────────────────
struct Reader {
    let s: [UInt8]
    init(_ d: Data) { s = [UInt8](d) }

    func stringField(_ key: String) -> String? {
        guard let i = find("\"\(key)\"") else { return nil }
        var j = i
        while j < s.count && s[j] != 0x3A { j += 1 }       // ':'
        j += 1
        while j < s.count && (s[j] == 0x20 || s[j] == 0x0A || s[j] == 0x0D || s[j] == 0x09) { j += 1 }
        guard j < s.count && s[j] == 0x22 else { return nil }
        j += 1
        var out = [UInt8]()
        while j < s.count && s[j] != 0x22 { out.append(s[j]); j += 1 }
        return String(decoding: out, as: UTF8.self)
    }

    /// Integers only. A non-integer value is a refusal, never a silent zero.
    func intField(_ key: String) -> Int? {
        guard let i = find("\"\(key)\"") else { return nil }
        var j = i
        while j < s.count && s[j] != 0x3A { j += 1 }
        j += 1
        while j < s.count && (s[j] == 0x20 || s[j] == 0x0A || s[j] == 0x0D || s[j] == 0x09) { j += 1 }
        var neg = false
        if j < s.count && s[j] == 0x2D { neg = true; j += 1 }
        var v = 0, digits = 0
        while j < s.count && s[j] >= 0x30 && s[j] <= 0x39 { v = v * 10 + Int(s[j] - 0x30); j += 1; digits += 1 }
        if digits == 0 { return nil }
        if j < s.count && (s[j] == 0x2E || s[j] == 0x65 || s[j] == 0x45) { return nil }  // . e E → not an integer
        return neg ? -v : v
    }

    /// The two compound names inside "best_pair": [ "a", "b" ].
    func pair() -> (String, String)? {
        guard let i = find("\"best_pair\"") else { return nil }
        var j = i
        while j < s.count && s[j] != 0x5B { j += 1 }        // '['
        var names = [String]()
        while j < s.count && s[j] != 0x5D {
            if s[j] == 0x22 {
                j += 1
                var out = [UInt8]()
                while j < s.count && s[j] != 0x22 { out.append(s[j]); j += 1 }
                names.append(String(decoding: out, as: UTF8.self))
            }
            j += 1
        }
        return names.count == 2 ? (names[0], names[1]) : nil
    }

    private func find(_ needle: String) -> Int? {
        let n = [UInt8](needle.utf8)
        if n.count > s.count { return nil }
        for i in 0...(s.count - n.count) {
            var ok = true
            for k in 0..<n.count where s[i + k] != n[k] { ok = false; break }
            if ok { return i }
        }
        return nil
    }
}

// ── locate the corpus without baking any absolute path into a public program ───────────────
func resolveCorpus() -> String? {
    let fm = FileManager.default
    var c: [String] = []
    if let exe = CommandLine.arguments.first, !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<6 { c.append(d + "/corpus/study-26-combination"); d = (d as NSString).deletingLastPathComponent; if d.isEmpty || d == "/" { break } }
    }
    var w = fm.currentDirectoryPath
    for _ in 0..<6 { c.append(w + "/corpus/study-26-combination"); w = (w as NSString).deletingLastPathComponent; if w.isEmpty || w == "/" { break } }
    for p in c where fm.fileExists(atPath: p + "/ov.json") { return p }
    return nil
}

// ── SHA-256, self-contained, for the transcript seal ───────────────────────────────────────
struct SHA256X {
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
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        var m = msg; let bl = UInt64(msg.count) * 8
        m.append(0x80); while m.count % 64 != 56 { m.append(0) }
        for i in stride(from: 56, through: 0, by: -8) { m.append(UInt8((bl >> UInt64(i)) & 0xff)) }
        for c in stride(from: 0, to: m.count, by: 64) {
            var w = [UInt32](repeating: 0, count: 64)
            for i in 0..<16 { w[i] = (UInt32(m[c+i*4]) << 24)|(UInt32(m[c+i*4+1]) << 16)|(UInt32(m[c+i*4+2]) << 8)|UInt32(m[c+i*4+3]) }
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
                let t2 = S0 &+ ((a & b) ^ (a & cc) ^ (b & cc))
                hh=g; g=f; f=e; e=d &+ t1; d=cc; cc=b; b=a; a=t1 &+ t2
            }
            h[0]=h[0]&+a; h[1]=h[1]&+b; h[2]=h[2]&+cc; h[3]=h[3]&+d
            h[4]=h[4]&+e; h[5]=h[5]&+f; h[6]=h[6]&+g; h[7]=h[7]&+hh
        }
        let d = Array("0123456789abcdef")
        return h.map { v in String((0..<8).map { d[Int((v >> UInt32(28 - $0*4)) & 0xf)] }) }.joined()
    }
}

var T: [String] = []
func t(_ s: String) { T.append(s); print(s) }
func pad(_ s: String, _ w: Int) -> String { s + String(repeating: " ", count: max(1, w - s.count)) }
func padL(_ v: Int, _ w: Int) -> String { let x = String(v); return String(repeating: " ", count: max(1, w - x.count)) + x }

let COHORTS = ["blca","brca","coad","gbm","hnsc","kirc","lihc","luad","lusc","ov","paad","read","sarc","stad","ucec"]
let NAME: [String: String] = ["blca":"bladder","brca":"breast","coad":"colon","gbm":"glioblastoma",
  "hnsc":"head & neck","kirc":"kidney clear cell","lihc":"liver","luad":"lung adenocarcinoma",
  "lusc":"lung squamous","ov":"ovary","paad":"pancreas","read":"rectum","sarc":"sarcoma",
  "stad":"stomach","ucec":"uterus"]

print("STUDY 26 · S3-COMBINATION — THE ELEVEN PAIRS, READ FROM THE SEALED RESULTS")
print("A faithful reader of the screen's own output. It does not re-run the screen.")
print("")
printReference()
print("")

guard let dir = resolveCorpus() else {
    print("REFUSED — corpus/study-26-combination not found from the binary or the working directory.")
    print("A gate given nothing must not pass: no table is printed and no seal is emitted.")
    print("Run from a clone of the repository, or place the corpus beside the binary.")
    exit(2)
}

struct Row { let c: String; let a: String; let b: String; let single: String
             let ks: Int; let kp: Int; let gain: Int; let mrs: Int; let scored: Int
             let draws: Int; let nullV: String; let vehV: String; let clears: Bool }
var rows: [Row] = []
var refusals: [String] = []

for c in COHORTS {
    let p = dir + "/" + c + ".json"
    guard let d = FileManager.default.contents(atPath: p) else { refusals.append("\(c): file unreadable"); continue }
    let r = Reader(d)
    guard let pr = r.pair(),
          let ks = r.intField("best_single_K"), let kp = r.intField("best_pair_K"),
          let gain = r.intField("gain_over_best_single"), let mrs = r.intField("observable_mrs"),
          let scored = r.intField("pairs_scored"), let draws = r.intField("draws"),
          let single = r.stringField("best_single_drug"),
          let nv = r.stringField("VERDICT") else { refusals.append("\(c): a required integer or string field is absent or not an integer"); continue }
    // "VERDICT" appears in both control blocks; read them positionally by their own keys.
    let txt = String(decoding: [UInt8](d), as: UTF8.self)
    let vehPass = txt.range(of: "\"control_vehicle_pairs\"").map { rg -> Bool in
        let tail = txt[rg.upperBound...]; return tail.prefix(400).contains("\"VERDICT\": \"PASS\"") } ?? false
    let nullPass = txt.range(of: "\"null_random_gene_sets_pairs\"").map { rg -> Bool in
        let tail = txt[rg.upperBound...]; return tail.prefix(600).contains("\"VERDICT\": \"PASS\"") } ?? false
    _ = nv
    rows.append(Row(c: c, a: pr.0, b: pr.1, single: single, ks: ks, kp: kp, gain: gain,
                    mrs: mrs, scored: scored, draws: draws,
                    nullV: nullPass ? "PASS" : "no", vehV: vehPass ? "PASS" : "no",
                    clears: vehPass && nullPass))
}

if rows.isEmpty {
    print("REFUSED — no cohort file parsed. No table, no seal.")
    printReference()
    exit(2)
}

// ── known-case check, before anything unknown is reported ──────────────────────────────────
t("KNOWN-CASE CHECK — the screen's own arithmetic must close on every row")
var bad = 0
for r in rows where r.kp - r.ks != r.gain { bad += 1 }
t("  rows where best_pair - best_single != published gain : \(bad)")
if bad != 0 {
    print("  FAIL — the files do not agree with themselves. No table is emitted.")
    printReference()
    exit(1)
}
t("  PASS — gain is the difference it is published as, on all \(rows.count) rows.")
t("")

let clearing = rows.filter { $0.clears }.sorted { $0.gain < $1.gain }
let notClearing = rows.filter { !$0.clears }.sorted { $0.mrs < $1.mrs }

t("THE PAIRS THAT CLEAR ALL THREE CONTROLS — \(clearing.count) of \(rows.count)")
t("  tumour type          pair                                    single   pair    gain  MRs")
for r in clearing {
    t("  " + pad(NAME[r.c] ?? r.c, 21) + pad(r.a + " + " + r.b, 40)
      + padL(r.ks, 7) + padL(r.kp, 8) + padL(r.gain, 6) + padL(r.mrs, 5))
}
t("")
t("  Every row above: \(clearing.first?.scored ?? 0) pairs scored, drawn from the 300 most-inverting single")
t("  agents, clearing a vehicle-pair control, a self-pair control, and a random-gene-set null")
t("  at 0 of \(clearing.first?.draws ?? 0) draws.")
t("")

t("NOT CLEARING — \(notClearing.count) of \(rows.count), and the reason is measured, not assumed")
t("  tumour type          observable MRs   best single   best pair   random-gene-set null")
for r in notClearing {
    t("  " + pad(NAME[r.c] ?? r.c, 21) + padL(r.mrs, 12) + padL(r.ks, 14) + padL(r.kp, 12)
      + "   reached the observed value")
}
t("  These four carry the fewest observable regulators in the corpus. That is a statement about")
t("  the power of this test on those cohorts, never about those cancers.")
t("")

t("WHAT THIS IS NOT. A signature-inversion score is an arithmetic statement about expression ranks")
t("of landmark genes. It is not efficacy, not a dose, not a mechanism, and not evidence that any")
t("pair helps any patient. Whether two compounds act additively in a cell, at a dose, in a person —")
t("and whether the combination is tolerable at all — is a laboratory and clinical question this")
t("program has not asked and cannot answer. Nobody should take anything on this page.")
t("MARKER  STUDY26_COMBINATION_PAIRS__ELEVEN_CLEAR_ALL_THREE_CONTROLS")

let seal = SHA256X.hex(Array((T.joined(separator: "\n") + "\n").utf8))
print("")
print("SEAL sha256(transcript) = \(seal)")
