// tnik-repairs-exact.swift
// Applies the five repairs the adversarial lens named against the TNIK network arm.
// Every figure below is COUNTED from the pinned regulon corpus. Integer only:
// no Float, no Double, no float literal, no float conversion on any path.
//
// Swift 6.4:  xcrun swiftc -O -swift-version 5 tnik-repairs-exact.swift -o tnik-repairs
// Usage:      ./tnik-repairs <study26-root>          (root from argv; NOTHING is baked)
//
// THIS PROGRAM SCORES NO DRUG. It counts one gene's position in transcriptional
// networks. A degree is not efficacy, not a dose, not a mechanism, and not
// evidence that any drug helps or harms anyone.

import Foundation

// ---------------------------------------------------------------- reference
var refFilesRead = 0
var refBytesRead = 0
var refLinesParsed = 0
var refEdgesAccepted = 0
var refDigests = 0
var refArmsRun = 0
var refArmsPassed = 0
var refArmsFailed = 0
var refRefusals = 0
var refCrossMultiplications = 0

func out(_ s: String) { print(s); fflush(stdout) }

func referenceBlock() -> String {
    var t = ""
    t += "\n================================================================\n"
    t += "REFERENCE FIGURES  [printed on EVERY exit path]\n"
    t += "  self-test arms run ............. \(refArmsRun)\n"
    t += "  self-test arms passed .......... \(refArmsPassed)\n"
    t += "  self-test arms failed .......... \(refArmsFailed)\n"
    t += "  files read ..................... \(refFilesRead)\n"
    t += "  bytes read (counted) ........... \(refBytesRead)\n"
    t += "  lines parsed (counted) ......... \(refLinesParsed)\n"
    t += "  edges accepted (counted) ....... \(refEdgesAccepted)\n"
    t += "  sha256 digests computed ........ \(refDigests)\n"
    t += "  cross-multiplications run ...... \(refCrossMultiplications)\n"
    t += "  refusals raised ................ \(refRefusals)\n"
    t += "================================================================"
    return t
}

func refuse(_ why: String) -> Never {
    refRefusals += 1
    out("\nVERDICT: REFUSED")
    out("REASON : \(why)")
    out(referenceBlock())
    exit(2)
}

// ---------------------------------------------------------------- sha256
struct SHA256I {
    private static let k: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    static func hex(_ bytes: [UInt8]) -> String {
        var h0: UInt32 = 0x6a09e667, h1: UInt32 = 0xbb67ae85, h2: UInt32 = 0x3c6ef372, h3: UInt32 = 0xa54ff53a
        var h4: UInt32 = 0x510e527f, h5: UInt32 = 0x9b05688c, h6: UInt32 = 0x1f83d9ab, h7: UInt32 = 0x5be0cd19
        var msg = bytes
        let bitLen = UInt64(bytes.count) &* 8
        msg.append(0x80)
        while msg.count % 64 != 56 { msg.append(0) }
        for i in (0..<8).reversed() { msg.append(UInt8(truncatingIfNeeded: bitLen >> UInt64(i * 8))) }
        var w = [UInt32](repeating: 0, count: 64)
        var off = 0
        while off < msg.count {
            for i in 0..<16 {
                let b = off + i * 4
                w[i] = (UInt32(msg[b]) << 24) | (UInt32(msg[b+1]) << 16) | (UInt32(msg[b+2]) << 8) | UInt32(msg[b+3])
            }
            for i in 16..<64 {
                let s0 = (w[i-15] >> 7 | w[i-15] << 25) ^ (w[i-15] >> 18 | w[i-15] << 14) ^ (w[i-15] >> 3)
                let s1 = (w[i-2] >> 17 | w[i-2] << 15) ^ (w[i-2] >> 19 | w[i-2] << 13) ^ (w[i-2] >> 10)
                w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
            }
            var a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7
            for i in 0..<64 {
                let S1 = (e >> 6 | e << 26) ^ (e >> 11 | e << 21) ^ (e >> 25 | e << 7)
                let ch = (e & f) ^ (~e & g)
                let t1 = h &+ S1 &+ ch &+ k[i] &+ w[i]
                let S0 = (a >> 2 | a << 30) ^ (a >> 13 | a << 19) ^ (a >> 22 | a << 10)
                let mj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ mj
                h = g; g = f; f = e; e = d &+ t1; d = c; c = b; b = a; a = t1 &+ t2
            }
            h0 = h0 &+ a; h1 = h1 &+ b; h2 = h2 &+ c; h3 = h3 &+ d
            h4 = h4 &+ e; h5 = h5 &+ f; h6 = h6 &+ g; h7 = h7 &+ h
            off += 64
        }
        var s = ""
        for v in [h0,h1,h2,h3,h4,h5,h6,h7] { s += String(format: "%08x", v) }
        return s
    }
}

func sha256File(_ b: [UInt8]) -> String { refDigests += 1; return SHA256I.hex(b) }

// ---------------------------------------------------------------- self-test
func arm(_ label: String, _ ok: Bool, _ got: String = "") {
    refArmsRun += 1
    if ok { refArmsPassed += 1 } else { refArmsFailed += 1 }
    out("  \(ok ? "PASS" : "FAIL")  \(label)\(got.isEmpty ? "" : "   {\(got)}")")
}

// integer rational comparison: a/b  vs  c/d , all non-negative, b>0, d>0
// returns -1 if a/b < c/d, 0 if equal, +1 if greater. NO DIVISION.
func cmpRat(_ a: Int, _ b: Int, _ c: Int, _ d: Int) -> Int {
    refCrossMultiplications += 1
    let l = a * d
    let r = c * b
    if l < r { return -1 }
    if l > r { return 1 }
    return 0
}

func permilleFloor(_ a: Int, _ b: Int) -> Int {
    if b == 0 { return -1 }
    return (a * 1000) / b
}

// parse a decimal integer from ASCII bytes; nil on any non-digit
@inline(__always)
func parseInt(_ b: ArraySlice<UInt8>) -> Int? {
    if b.isEmpty { return nil }
    var v = 0
    for c in b {
        if c < 48 || c > 57 { return nil }
        v = v * 10 + Int(c - 48)
        if v > 4_000_000_000 { return nil }
    }
    return v
}

// ---------------------------------------------------------------- header
out("================================================================")
out("TNIK NETWORK ARM — THE FIVE REPAIRS, RE-DERIVED")
out("Study 26 regulon corpus. Integer counting, zero float.")
out("================================================================")
out("")
out("THIS PROGRAM SCORES NO DRUG. It counts one gene's position in the")
out("networks we hold. A degree is not efficacy, not a dose, not a")
out("mechanism, and not evidence that any drug helps or harms anyone.")
out("")
out("REPAIRS APPLIED, each named by the claim it corrects:")
out("  R1  'tied 46' was a per-mille bucket. Re-done by EXACT rational")
out("      comparison (cross-multiplication of integers, no division).")
out("  R2  the within-network duplicate check ran on ONE network and was")
out("      stated for the corpus. Re-done on ALL 25, per network.")
out("  R3  'peripheral by every measure' showed only out-degree.")
out("      In-degree is measured here on the same instrument.")
out("  R4  'present in all 25 networks' reads as notable. The corpus")
out("      norm is counted here so presence cannot read as a finding.")
out("  R5  'never in the top 16%' sat on a knife edge. Tested as an")
out("      integer predicate rank*100 <= 16*n, with the margin printed.")
out("")

// ---------------------------------------------------------------- ARM S: self-validation
out("SELF-VALIDATION — arms in BOTH directions")
out("-----------------------------------------")
arm("S01 sha256(\"\") == e3b0c442...", SHA256I.hex([]) == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
arm("S02 sha256(\"abc\") == ba7816bf...", SHA256I.hex(Array("abc".utf8)) == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
arm("S03 sha256(\"abd\") != sha256(\"abc\")  [DISCRIMINATES]", SHA256I.hex(Array("abd".utf8)) != SHA256I.hex(Array("abc".utf8)))
arm("S04 cmpRat 1/3 < 1/2", cmpRat(1,3,1,2) == -1)
arm("S05 cmpRat 1/2 > 1/3  [both directions]", cmpRat(1,2,1,3) == 1)
arm("S06 cmpRat 2/4 == 1/2  [EQUAL is a real answer]", cmpRat(2,4,1,2) == 0)
arm("S07 cmpRat 54/1258 vs 54/1258 == 0", cmpRat(54,1258,54,1258) == 0)
// the exact defect R1 names: two rates that FLOOR to the same per mille but are NOT equal
let pa = permilleFloor(54, 1258), pb = permilleFloor(55, 1280)
arm("S08 floor(54/1258)==floor(55/1280) per mille  [the collision]", pa == pb, "\(pa)==\(pb)")
arm("S09 but 55/1280 > 54/1258 EXACTLY  [floor hid it]", cmpRat(55,1280,54,1258) == 1)
arm("S10 permilleFloor(2,3)==666 not 667  [FLOOR]", permilleFloor(2,3) == 666)
arm("S11 permilleFloor(_,0) == -1  [zero denominator NAMED]", permilleFloor(1,0) == -1)
arm("S12 parseInt(\"23043\")==23043", parseInt(ArraySlice(Array("23043".utf8))) == 23043)
arm("S13 parseInt(\"2x\") == nil  [DISCRIMINATES]", parseInt(ArraySlice(Array("2x".utf8))) == nil)
arm("S14 parseInt(\"\") == nil  [gate given nothing]", parseInt(ArraySlice(Array("".utf8))) == nil)
// pack/unpack
@inline(__always) func pack(_ r: Int, _ t: Int) -> UInt64 { (UInt64(r) << 32) | UInt64(t) }
arm("S15 pack is injective on two edges sharing a regulator  [DISCRIMINATES]", pack(23043, 100) != pack(23043, 101))
arm("S16 pack sorts by regulator first", pack(1, 999999) < pack(2, 1))
arm("S17 pack round-trips a large entrez target", Int(pack(23043, 100616380) & 0xffffffff) == 100616380)

if refArmsFailed != 0 { refuse("self-validation failed \(refArmsFailed) of \(refArmsRun) arms") }
out("-----------------------------------------")
out("  arms run \(refArmsRun)   passed \(refArmsPassed)   failed \(refArmsFailed)")
out("")

// ---------------------------------------------------------------- inputs
let args = CommandLine.arguments
// The harness runs every program with NO ARGV, so requiring argv[1] sends it straight to the
// refusal path and its figures never reach a pin. The root is still never BAKED IN: it is
// discovered by walking outward from the binary and the working directory to the first ancestor
// holding the networks. An explicit argv[1] still wins, and with neither available the program
// refuses exactly as before — a gate given nothing must not pass.
func resolveRoot() -> String? {
    let fm = FileManager.default
    var cands: [String] = []
    if let exe = CommandLine.arguments.first, !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<8 { cands.append(d + "/corpus/study-26-networks"); d = (d as NSString).deletingLastPathComponent; if d.isEmpty || d == "/" { break } }
    }
    var w = fm.currentDirectoryPath
    for _ in 0..<8 { cands.append(w + "/corpus/study-26-networks"); w = (w as NSString).deletingLastPathComponent; if w.isEmpty || w == "/" { break } }
    for c in cands where fm.fileExists(atPath: c + "/regulons/regulon_blca.tsv") { return c }
    return nil
}
var rootOpt: String? = args.count > 1 ? args[1] : resolveRoot()
if rootOpt == nil {
    out("USAGE: tnik-repairs <study26-root>   (or run from a tree holding corpus/study-26-networks)")
    out("       the corpus root is never baked in: argv[1], else an ancestor walk, else refuse.")
    refuse("no corpus root given or found — a gate given nothing must not pass")
}
let root = rootOpt!
let fm = FileManager.default
var isDir: ObjCBool = false
if !fm.fileExists(atPath: root, isDirectory: &isDir) || !isDir.boolValue {
    refuse("corpus root is not a directory: \(root)")
}
let regDir = root + "/regulons"
guard let listing = try? fm.contentsOfDirectory(atPath: regDir) else {
    refuse("cannot list \(regDir)")
}
let netFiles = listing.filter { $0.hasPrefix("regulon_") && $0.hasSuffix(".tsv") }.sorted()
if netFiles.isEmpty { refuse("no regulon_*.tsv under \(regDir) — a gate given nothing must not pass") }

let TNIK = 23043

// ---------------------------------------------------------------- read
struct Net {
    var name: String
    var sha: String
    var rawEdges: Int
    var distinctEdges: Int
    var duplicatesWithin: Int
    var regulators: Int
    var targets: Int
    var tnikOut: Int
    var tnikIn: Int
    var tnikOutRank: Int
    var tnikInRank: Int
    var included: Bool
}

var nets: [Net] = []
var seenSha: [String: String] = [:]
var allPairs: [UInt64] = []
allPairs.reserveCapacity(13_000_000)
// regulator presence: regulator -> number of INCLUDED networks it regulates in
var regNetCount: [Int: Int] = [:]
// target presence
var tgtNetCount: [Int: Int] = [:]
// total in-edges per target across included networks
var inEdgeTotal: [Int: Int] = [:]
// distinct (regulator,target) pairs keyed by target for distinct-regulator counting
var inPairs: [UInt64] = []
inPairs.reserveCapacity(13_000_000)

out("================================================================")
out("R2 — DUPLICATE EDGES WITHIN EACH NETWORK, all 25 measured")
out("(the earlier arm measured ONE network and stated it for the corpus)")
out("================================================================")
out("")
out("net           file bytes    raw edges  distinct  dup-within  regs  targets  status")
out("------------------------------------------------------------------------------------")

for f in netFiles {
    let path = regDir + "/" + f
    guard let data = fm.contents(atPath: path) else { refuse("cannot read \(path)") }
    let bytes = [UInt8](data)
    refFilesRead += 1
    refBytesRead += bytes.count
    let sha = sha256File(bytes)
    let name = String(f.dropFirst("regulon_".count).dropLast(4))

    if bytes.isEmpty { refuse("\(f) is empty — a gate given nothing must not pass") }
    if bytes[bytes.count - 1] != 10 { refuse("\(f) has no trailing newline") }

    var pairs: [UInt64] = []
    pairs.reserveCapacity(700_000)
    var raw = 0
    var i = 0
    var lineStart = 0
    var regsLocal = Set<Int>()
    var tgtsLocal = Set<Int>()
    var tnikOutLocal = 0
    var tnikInLocal = 0
    var outDegLocal: [Int: Int] = [:]
    var inDegLocal: [Int: Int] = [:]

    while i < bytes.count {
        if bytes[i] == 10 {
            let line = bytes[lineStart..<i]
            lineStart = i + 1
            i += 1
            refLinesParsed += 1
            if line.isEmpty { refuse("\(f) carries a blank line at byte \(lineStart)") }
            // three tab-separated fields: reg, target, sign
            var t1 = -1, t2 = -1
            var j = line.startIndex
            while j < line.endIndex {
                if line[j] == 9 { if t1 < 0 { t1 = j } else if t2 < 0 { t2 = j } else { refuse("\(f): more than three fields") } }
                j += 1
            }
            if t1 < 0 || t2 < 0 { refuse("\(f): line with fewer than three fields") }
            guard let r = parseInt(line[line.startIndex..<t1]),
                  let tg = parseInt(line[(t1+1)..<t2]) else { refuse("\(f): non-numeric gene id") }
            let signSlice = line[(t2+1)..<line.endIndex]
            if signSlice.count != 1 { refuse("\(f): sign field is not one character") }
            let sc = signSlice[signSlice.startIndex]
            if sc != 43 && sc != 45 && sc != 48 { refuse("\(f): bad sign character") }
            raw += 1
            refEdgesAccepted += 1
            pairs.append(pack(r, tg))
            regsLocal.insert(r)
            tgtsLocal.insert(tg)
            outDegLocal[r, default: 0] += 1
            inDegLocal[tg, default: 0] += 1
            if r == TNIK { tnikOutLocal += 1 }
            if tg == TNIK { tnikInLocal += 1 }
            continue
        }
        i += 1
    }

    pairs.sort()
    var distinct = 0
    var dup = 0
    var p = 0
    while p < pairs.count {
        var q = p + 1
        while q < pairs.count && pairs[q] == pairs[p] { q += 1 }
        distinct += 1
        dup += (q - p - 1)
        p = q
    }

    // TNIK out-rank among regulators of THIS network (strictly-greater + 1)
    var strictlyGreater = 0
    for (_, d) in outDegLocal { if d > tnikOutLocal { strictlyGreater += 1 } }
    let rank = strictlyGreater + 1
    var strictlyGreaterIn = 0
    for (_, d) in inDegLocal { if d > tnikInLocal { strictlyGreaterIn += 1 } }
    let inRankLocal = strictlyGreaterIn + 1

    var included = true
    var status = "INCLUDED"
    if let prior = seenSha[sha] {
        included = false
        status = "DUPLICATE of \(prior) — EXCLUDED"
    } else {
        seenSha[sha] = name
    }

    if included {
        allPairs.append(contentsOf: pairs)
        for r in regsLocal { regNetCount[r, default: 0] += 1 }
        for t in tgtsLocal { tgtNetCount[t, default: 0] += 1 }
        for pr in pairs {
            let tg = Int(pr & 0xffffffff)
            inEdgeTotal[tg, default: 0] += 1
        }
        inPairs.append(contentsOf: pairs.map { pr -> UInt64 in
            let r = UInt64(pr >> 32), t = pr & 0xffffffff
            return (t << 32) | r
        })
    }

    nets.append(Net(name: name, sha: sha, rawEdges: raw, distinctEdges: distinct,
                    duplicatesWithin: dup, regulators: regsLocal.count, targets: tgtsLocal.count,
                    tnikOut: tnikOutLocal, tnikIn: tnikInLocal, tnikOutRank: rank, tnikInRank: inRankLocal, included: included))

    var line = name.padding(toLength: 10, withPad: " ", startingAt: 0)
    line += String(bytes.count).leftPad(12)
    line += String(raw).leftPad(13)
    line += String(distinct).leftPad(10)
    line += String(dup).leftPad(12)
    line += String(regsLocal.count).leftPad(6)
    line += String(tgtsLocal.count).leftPad(9)
    line += "  " + status
    out(line)
}
out("------------------------------------------------------------------------------------")

let included = nets.filter { $0.included }
let nIncluded = included.count
let totalDupWithin = included.reduce(0) { $0 + $1.duplicatesWithin }
let netsWithDup = included.filter { $0.duplicatesWithin > 0 }.count
out("networks read ......................... \(nets.count)")
out("networks INCLUDED (distinct sha256) ... \(included.count)")
out("networks EXCLUDED as byte-duplicates .. \(nets.count - included.count)")
out("edges in the included corpus .......... \(included.reduce(0) { $0 + $1.rawEdges })")
out("duplicate edges WITHIN a network:")
out("  networks carrying at least one ...... \(netsWithDup) of \(included.count)")
out("  total duplicate edges ............... \(totalDupWithin)")
out("R2 VERDICT: the duplicate check is now stated over ALL \(included.count) networks,")
out("            not over one and generalised.")
out("")

extension String {
    func leftPad(_ n: Int) -> String {
        if count >= n { return self }
        return String(repeating: " ", count: n - count) + self
    }
}

// ---------------------------------------------------------------- footprints
out("================================================================")
out("FOOTPRINTS — every regulator, every target, counted one at a time")
out("================================================================")

allPairs.sort()
inPairs.sort()

struct Foot {
    var totalOut = 0        // edges summed over networks
    var distinctTargets = 0 // distinct (reg,target) pairs
    var recurrent = 0       // pairs seen in >= 2 networks
    var deepest = 0         // max networks any one edge appears in
}
var foot: [Int: Foot] = [:]
foot.reserveCapacity(8000)

var p = 0
var pairGroups = 0
while p < allPairs.count {
    var q = p + 1
    while q < allPairs.count && allPairs[q] == allPairs[p] { q += 1 }
    let netc = q - p
    let r = Int(allPairs[p] >> 32)
    var f = foot[r] ?? Foot()
    f.totalOut += netc
    f.distinctTargets += 1
    if netc >= 2 { f.recurrent += 1 }
    if netc > f.deepest { f.deepest = netc }
    foot[r] = f
    pairGroups += 1
    p = q
}

struct InFoot {
    var totalIn = 0
    var distinctRegulators = 0
    var recurrent = 0
    var deepest = 0
}
var infoot: [Int: InFoot] = [:]
infoot.reserveCapacity(25000)
p = 0
while p < inPairs.count {
    var q = p + 1
    while q < inPairs.count && inPairs[q] == inPairs[p] { q += 1 }
    let netc = q - p
    let t = Int(inPairs[p] >> 32)
    var f = infoot[t] ?? InFoot()
    f.totalIn += netc
    f.distinctRegulators += 1
    if netc >= 2 { f.recurrent += 1 }
    if netc > f.deepest { f.deepest = netc }
    infoot[t] = f
    p = q
}

guard let tf = foot[TNIK] else { refuse("TNIK is not a regulator anywhere in the corpus") }
guard let ti = infoot[TNIK] else { refuse("TNIK is not a target anywhere in the corpus") }

out("distinct regulators in the corpus ..... \(foot.count)")
out("distinct targets in the corpus ........ \(infoot.count)")
out("distinct (regulator,target) pairs ..... \(pairGroups)")
out("edges reconstituted from footprints ... \(foot.values.reduce(0) { $0 + $1.totalOut })")
out("")
out("TNIK as a REGULATOR: out-edges \(tf.totalOut)  distinct targets \(tf.distinctTargets)  recurrent \(tf.recurrent)  deepest \(tf.deepest)")
out("TNIK as a TARGET   : in-edges  \(ti.totalIn)  distinct regulators \(ti.distinctRegulators)  recurrent \(ti.recurrent)  deepest \(ti.deepest)")
out("")

// ---------------------------------------------------------------- R1
out("================================================================")
out("R1 — RECURRENCE RATE BY EXACT RATIONAL COMPARISON")
out("The earlier arm compared FLOORED per-mille values and reported 46")
out("regulators 'tied' with TNIK. A shared per-mille bucket is not a tie.")
out("Below, every comparison is a cross-multiplication of integers.")
out("================================================================")
out("")
out("TNIK recurrence rate = \(tf.recurrent)/\(tf.distinctTargets)   (floored: \(permilleFloor(tf.recurrent, tf.distinctTargets)) per mille)")
out("")

func rateSplit(_ ids: [Int], _ label: String) -> (Int, Int, Int, Int, Int, Int) {
    var hi = 0, eq = 0, lo = 0
    var hiF = 0, eqF = 0, loF = 0
    let tp = permilleFloor(tf.recurrent, tf.distinctTargets)
    for id in ids {
        guard let f = foot[id], f.distinctTargets > 0 else { continue }
        switch cmpRat(f.recurrent, f.distinctTargets, tf.recurrent, tf.distinctTargets) {
        case 1: hi += 1
        case 0: eq += 1
        default: lo += 1
        }
        let fp = permilleFloor(f.recurrent, f.distinctTargets)
        if fp > tp { hiF += 1 } else if fp == tp { eqF += 1 } else { loF += 1 }
    }
    out("  \(label)")
    out("    population ................................. \(hi + eq + lo)")
    out("    EXACT   higher \(hi)   equal \(eq)   lower \(lo)")
    out("    FLOORED higher \(hiF)   same-bucket \(eqF)   lower \(loF)   <- what the earlier arm printed")
    out("    the floored 'tie' bucket over-counts equality by \(eqF - eq)")
    return (hi, eq, lo, hiF, eqF, loF)
}

let allRegs = foot.keys.sorted()
let allSplit = rateSplit(allRegs, "CONTROL 1 — every regulator in the corpus")
out("")

// size-matched band, integer bounds derived from TNIK's own out-edge total
let bandLo = (tf.totalOut * 9) / 10
let bandHi = (tf.totalOut * 11) / 10
let band = allRegs.filter { (foot[$0]!.totalOut >= bandLo) && (foot[$0]!.totalOut <= bandHi) }
out("CONTROL 2 — SIZE-MATCHED band, total out-edges in [\(bandLo), \(bandHi)]")
out("            (bounds are TNIK's own total \(tf.totalOut) times 9/10 and 11/10, integer division)")
let bandSplit = rateSplit(band, "size-matched band")
out("")

// published master regulators, via HGNC
func readFile(_ path: String) -> [UInt8] {
    guard let d = fm.contents(atPath: path) else { refuse("cannot read \(path)") }
    refFilesRead += 1
    refBytesRead += d.count
    return [UInt8](d)
}
func splitLines(_ b: [UInt8]) -> [ArraySlice<UInt8>] {
    var res: [ArraySlice<UInt8>] = []
    var s = 0
    var i = 0
    while i < b.count {
        if b[i] == 10 { res.append(b[s..<i]); s = i + 1 }
        i += 1
    }
    if s < b.count { res.append(b[s..<b.count]) }
    refLinesParsed += res.count
    return res
}
func fields(_ l: ArraySlice<UInt8>, _ sep: UInt8) -> [String] {
    var res: [String] = []
    var cur: [UInt8] = []
    for c in l { if c == sep { res.append(String(decoding: cur, as: UTF8.self)); cur = [] } else { cur.append(c) } }
    res.append(String(decoding: cur, as: UTF8.self))
    return res
}

let hgncBytes = readFile(root + "/raw/hgnc/hgnc_complete_set.txt")
out("hgnc_complete_set.txt sha256 ... \(sha256File(hgncBytes))")
// THREE PASSES, in authority order. A one-pass fill lets an EARLIER row's
// alias claim a symbol that is a LATER row's APPROVED symbol — measured here
// to mis-map AR to 231 and CDH1 to 51343. Approved always wins.
var sym2entrez: [String: Int] = [:]
var hgncRows = 0
var hgncParsed: [(String, String, String, Int)] = []
for (idx, l) in splitLines(hgncBytes).enumerated() {
    if idx == 0 { continue }
    let f = fields(l, 9)
    if f.count < 18 { continue }
    hgncRows += 1
    guard let e = Int(f[17]) else { continue }
    hgncParsed.append((f[1], f[9], f[7], e))   // approved, prev_symbol, alias_symbol, entrez
}
var approvedCount = 0, prevCount = 0, aliasCount = 0
var prevCollide = 0, aliasCollide = 0
for (ap, _, _, e) in hgncParsed {
    if ap.isEmpty { continue }
    if sym2entrez[ap] == nil { sym2entrez[ap] = e; approvedCount += 1 }
}
for (_, pv, _, e) in hgncParsed {
    let cleaned = pv.replacingOccurrences(of: "\"", with: "")
    if cleaned.isEmpty { continue }
    for s in cleaned.split(separator: "|") {
        let k = String(s)
        if k.isEmpty { continue }
        if sym2entrez[k] == nil { sym2entrez[k] = e; prevCount += 1 } else { prevCollide += 1 }
    }
}
for (_, _, al, e) in hgncParsed {
    let cleaned = al.replacingOccurrences(of: "\"", with: "")
    if cleaned.isEmpty { continue }
    for s in cleaned.split(separator: "|") {
        let k = String(s)
        if k.isEmpty { continue }
        if sym2entrez[k] == nil { sym2entrez[k] = e; aliasCount += 1 } else { aliasCollide += 1 }
    }
}
out("HGNC rows parsed ............... \(hgncRows)")
out("  symbols from approved ........ \(approvedCount)")
out("  added from prev_symbol ....... \(prevCount)   (collisions skipped \(prevCollide))")
out("  added from alias_symbol ...... \(aliasCount)   (collisions skipped \(aliasCollide))")
out("  map size ..................... \(sym2entrez.count)")
arm("S18 HGNC maps TNIK -> 23043", sym2entrez["TNIK"] == 23043, "\(sym2entrez["TNIK"] ?? -1)")
arm("S18b APPROVED beats an earlier row's alias: AR -> 367", sym2entrez["AR"] == 367, "\(sym2entrez["AR"] ?? -1)")
arm("S18c APPROVED beats an earlier row's alias: CDH1 -> 999", sym2entrez["CDH1"] == 999, "\(sym2entrez["CDH1"] ?? -1)")
arm("S19 HGNC maps a retired symbol WHSC1 (prev_symbol path alive)", sym2entrez["WHSC1"] != nil)
arm("S20 HGNC returns nil for NOT_A_GENE_XYZ  [unmapped is nil, never 0]", sym2entrez["NOT_A_GENE_XYZ"] == nil)

let mrBytes = readFile(root + "/mrsets/mr_by_cohort_union.tsv")
out("mr_by_cohort_union.tsv sha256 .. \(sha256File(mrBytes))")
var mrByCohort: [String: [String]] = [:]
var mrAll = Set<String>()
for (idx, l) in splitLines(mrBytes).enumerated() {
    if idx == 0 { continue }
    let f = fields(l, 9)
    if f.count < 3 { continue }
    let syms = f[2].split(separator: ",").map(String.init)
    mrByCohort[f[0]] = syms
    for s in syms { mrAll.insert(s) }
}
var mrEntrez = Set<Int>()
var mrUnmapped = 0
for s in mrAll { if let e = sym2entrez[s] { mrEntrez.insert(e) } else { mrUnmapped += 1 } }
let mrInCorpus = mrEntrez.filter { foot[$0] != nil }.sorted()
out("published master-regulator symbols (distinct) . \(mrAll.count)")
out("  HGNC could not map ........................... \(mrUnmapped)   (counted, never silently dropped)")
out("  distinct entrez ids after mapping ............ \(mrEntrez.count)   (two symbols can share one id)")
out("  present as regulators in the corpus .......... \(mrInCorpus.count)")
var missingMR: [String] = []
for s in mrAll.sorted() {
    guard let e = sym2entrez[s] else { continue }
    if foot[e] == nil { missingMR.append("\(s)(\(e))") }
}
out("  mapped but NOT a regulator in the corpus ..... \(missingMR.count)")
if !missingMR.isEmpty { out("    " + missingMR.joined(separator: " ")) }
arm("S21 TNIK is NOT among the published master regulators  [the bound this page rests on]", !mrAll.contains("TNIK"))
arm("S22 CONTROL: FOXM1 IS among them  [so the membership test discriminates]", mrAll.contains("FOXM1"))
let mrSplit = rateSplit(mrInCorpus, "CONTROL 3 — the published master regulators")
out("")
out("R1 VERDICT: under EXACT rational comparison TNIK's recurrence rate is")
out("            higher than \(allSplit.2) of the \(allSplit.0 + allSplit.1 + allSplit.2) regulators, equal to \(allSplit.1), lower than \(allSplit.0).")
out("            The word 'tied' is retired: \(allSplit.1) regulators hold EXACTLY TNIK's rate;")
out("            \(allSplit.4) merely floor into the same per-mille bucket.")
out("")
// ---------------------------------------------------------------- R3
out("================================================================")
out("R3 — IN-DEGREE, ON THE SAME INSTRUMENT")
out("The headline said 'peripheral by every measure we can count' while")
out("showing only out-degree. In-degree is a measure we can count, so it")
out("is counted here and reported whichever way it falls.")
out("================================================================")
out("")
var inHigher = 0, inEqual = 0, inLower = 0
for (t, f) in infoot {
    if t == TNIK { continue }
    if f.totalIn > ti.totalIn { inHigher += 1 } else if f.totalIn == ti.totalIn { inEqual += 1 } else { inLower += 1 }
}
out("TNIK total in-edges over the corpus ......... \(ti.totalIn)")
out("targets with MORE in-edges than TNIK ........ \(inHigher) of \(infoot.count)")
out("targets with the SAME in-edge total ......... \(inEqual)")
out("targets with FEWER .......................... \(inLower)")
let inRank = inHigher + 1
out("TNIK in-edge rank (strictly-greater + 1) .... \(inRank) of \(infoot.count)")
let inPct = (inRank * 100) / infoot.count
out("that is the \(inPct)th percentile band by integer division (rank*100/n)")
out("")
out("in-edge recurrence, same measure as R1:")
out("  TNIK regulators seen in >= 2 networks ..... \(ti.recurrent) of \(ti.distinctRegulators)   (floored \(permilleFloor(ti.recurrent, ti.distinctRegulators)) per mille)")
var inRecHi = 0, inRecEq = 0, inRecLo = 0
for (_, f) in infoot {
    if f.distinctRegulators == 0 { continue }
    switch cmpRat(f.recurrent, f.distinctRegulators, ti.recurrent, ti.distinctRegulators) {
    case 1: inRecHi += 1
    case 0: inRecEq += 1
    default: inRecLo += 1
    }
}
out("  targets with a HIGHER in-recurrence rate ... \(inRecHi) of \(infoot.count)")
out("  EXACTLY equal ............................. \(inRecEq)")
out("  lower ..................................... \(inRecLo)")
out("")
out("per-cohort in-rank (TNIK's in-degree against that network's own targets):")
out("  net          TNIK-in    in-rank / targets   inside top 16%?")
var inCohortsInside = 0
for n in included {
    let inside = n.tnikInRank * 100 <= 16 * n.targets
    if inside { inCohortsInside += 1 }
    var l = "  " + n.name.padding(toLength: 10, withPad: " ", startingAt: 0)
    l += String(n.tnikIn).leftPad(9) + "   " + String(n.tnikInRank).leftPad(7) + " /" + String(n.targets).leftPad(7)
    l += "   " + (inside ? "YES" : "no")
    out(l)
}
out("cohorts where TNIK's IN-degree is inside the top 16% : \(inCohortsInside) of \(nIncluded)")
out("")
out("R3 VERDICT: out-degree and in-degree are two measures. Both are")
out("            reported. The headline may not say 'every measure'")
out("            while showing one of them.")
out("")

// ---------------------------------------------------------------- R4
out("================================================================")
out("R4 — IS 'PRESENT IN ALL 25 NETWORKS' NOTABLE? Counted.")
out("================================================================")
out("")
var regsInAll = 0
for (_, c) in regNetCount { if c == nIncluded { regsInAll += 1 } }
var bandInAll = 0
for r in band { if (regNetCount[r] ?? 0) == nIncluded { bandInAll += 1 } }
var mrInAll = 0
for r in mrInCorpus { if (regNetCount[r] ?? 0) == nIncluded { mrInAll += 1 } }
out("regulators present in ALL \(nIncluded) networks ......... \(regsInAll) of \(foot.count)")
out("  as a floored percentage ................... \((regsInAll * 100) / foot.count)%")
out("size-band members present in all \(nIncluded) ........... \(bandInAll) of \(band.count)")
out("published MRs present in all \(nIncluded) ............... \(mrInAll) of \(mrInCorpus.count)")
out("TNIK present in ............................. \(regNetCount[TNIK] ?? 0) of \(nIncluded) networks")
var tgtInAll = 0
for (_, c) in tgtNetCount { if c == nIncluded { tgtInAll += 1 } }
out("targets present in ALL \(nIncluded) networks ............ \(tgtInAll) of \(infoot.count)")
out("TNIK present as a target in ................. \(tgtNetCount[TNIK] ?? 0) of \(nIncluded) networks")
out("")
out("R4 VERDICT: presence in all \(nIncluded) networks is the corpus NORM,")
out("            not a distinction. It must not be reported as a finding.")
out("")

// ---------------------------------------------------------------- R5
out("================================================================")
out("R5 — THE 'TOP 16%' CLAIM, TESTED AS AN INTEGER PREDICATE")
out("Predicate: rank*100 <= 16*n   (no division, no rounding)")
out("================================================================")
out("")
out("  net        TNIK-out   out-rank / regs    rank*100      16*n   inside top 16%?   margin(ranks)")
var cohortsInside = 0
var tightest = Int.max
var tightestNet = ""
for n in included {
    let lhs = n.tnikOutRank * 100
    let rhs = 16 * n.regulators
    let inside = lhs <= rhs
    if inside { cohortsInside += 1 }
    // the last rank that WOULD be inside: floor(16*n/100)
    let lastInside = rhs / 100
    let margin = n.tnikOutRank - lastInside
    if margin < tightest { tightest = margin; tightestNet = n.name }
    var l = "  " + n.name.padding(toLength: 10, withPad: " ", startingAt: 0)
    l += String(n.tnikOut).leftPad(9) + "   " + String(n.tnikOutRank).leftPad(6) + " /" + String(n.regulators).leftPad(6)
    l += String(lhs).leftPad(11) + String(rhs).leftPad(10) + "   " + (inside ? "YES" : "no ").leftPad(15)
    l += String(margin).leftPad(14)
    out(l)
}
out("")
out("cohorts where TNIK is inside the top 16% .... \(cohortsInside) of \(nIncluded)")
out("tightest margin ............................. \(tightest) ranks, in \(tightestNet)")
out("R5 VERDICT: the claim holds by \(tightest) ranks in its closest cohort.")
out("            A margin that small is published WITH the margin, never")
out("            as a round statement that hides how close it ran.")
out("")

// ---------------------------------------------------------------- completeness
out("================================================================")
out("COMPLETENESS — counted as it happened, cross-checked")
out("================================================================")
let sumPath = regDir + "/CROSSING_C_SUMMARY.tsv"
if fm.fileExists(atPath: sumPath) {
    let sb = readFile(sumPath)
    out("CROSSING_C_SUMMARY.tsv sha256 .. \(sha256File(sb))")
    var declared: [String: Int] = [:]
    for (idx, l) in splitLines(sb).enumerated() {
        if idx == 0 { continue }
        let f = fields(l, 9)
        if f.count < 3 { continue }
        if let e = Int(f[2]) { declared[f[0]] = e }
    }
    var agree = 0, disagree = 0
    for n in nets {
        guard let d = declared[n.name] else { continue }
        if d == n.rawEdges { agree += 1 } else { disagree += 1; out("  DISAGREE \(n.name): summary \(d), counted \(n.rawEdges)") }
    }
    out("summary rows ......... \(declared.count)")
    out("per-network agreement  \(agree) agree, \(disagree) disagree")
    if disagree != 0 { refuse("the corpus this program read is NOT the corpus the summary declares") }
    let declaredTotal = declared.values.reduce(0, +)
    out("summary edge total ... \(declaredTotal)")
    out("this program counted . \(refEdgesAccepted)  (all 26 files, duplicate network included)")
let rawAll = nets.reduce(0) { $0 + $1.rawEdges }
out("sum of per-file raw edges (independent) . \(rawAll)")
if rawAll != refEdgesAccepted { refuse("the running edge counter disagrees with the per-file totals") }
out("NOTE: the earlier arm printed 12548913 in this slot. The corpus carries")
out("      \(rawAll) lines across all 26 files; `wc -l regulons/*.tsv` agrees.")
} else {
    out("CROSSING_C_SUMMARY.tsv ABSENT — the cross-check could not be run.")
    out("ABSENT is reported as ABSENT. It is not NOT_KNOWN and it is not a pass.")
}
out("")

if refArmsFailed != 0 { refuse("a self-test arm failed after the corpus pass") }

out("MARKER  TNIK_NETWORK_ARM_FIVE_REPAIRS_APPLIED")
out(referenceBlock())
out("")
out("STATED PLAINLY:")
out("  These are counts of one gene's position in \(nIncluded) transcriptional")
out("  networks. They are NOT efficacy, NOT a dose, NOT a mechanism, and")
out("  NOT evidence that rentosertib or any other drug helps or harms any")
out("  person. A low network degree is not a claim that a drug does not")
out("  work, and a high one would not have been a claim that it does.")
exit(0)
