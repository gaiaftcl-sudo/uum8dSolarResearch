// homology-detection-ladder.swift
// ===========================================================================
// THE CONTROL ARM FOR THE HOMOLOGY STUDY, AT THE STUDY'S OWN LENGTH.
//
// The study "peptide-homology-exact" reports the exact optimal Smith-Waterman
// score of 78,680 generated peptides against the whole reviewed human proteome
// and finds a maximum of 90.  That number means nothing on its own.  A reader
// cannot tell an instrument that found no homology from an instrument that
// cannot find homology, and the difference is the entire result.
//
// So this program PLANTS homology and measures what the same law returns.
// It cuts a 66-residue window — the corpus median length — verbatim out of
// eight real human proteins, then walks each window away from its source by a
// fixed, stated substitution schedule, and screens every rung against the
// WHOLE proteome under the SAME recurrence: BLOSUM62, gap of length k costs
// 11 + k, exact integer dynamic programming, every query against every one of
// the 20,431 proteins, no seeding heuristic and no cutoff in the arithmetic.
//
// The output is a detection floor in units a bench can act on: how much of a
// real human protein a 66-mer may lose and still outscore the entire generated
// corpus.
//
// NO E-VALUE.  NO FITTED PARAMETER.  NO FLOAT.  The scoring law here is
// character-for-character the study's own: SHA256Exact, findRoot, the BLOSUM62
// table and swPair are lifted verbatim out of peptide-homology-exact.swift,
// and a second, independently written pointer kernel is checked against
// swPair before any measurement is emitted.
//
// HOUSE RULES OBSERVED: stdout unbuffered from the first statement; the pinned
// reference figures printed before any file is opened, so every refusal path
// carries them; the reference hashed by this program and REFUSED on mismatch;
// no absolute path in the source; a path- and timing-independent seal.
// ===========================================================================

import Foundation

setvbuf(stdout, nil, _IONBF, 0)

let PIN_REF_PROTEINS  = 20431
let PIN_REF_RESIDUES  = 11418237
let PIN_REF_SHA       = "bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e"
let PIN_B62_SHA       = "a2d909d178d587fbaeae1f26eeaaafa65254705a348bf7a48b6b0f87af48ff2c"
let PIN_CORPUS_MAX    = 90     // observed maximum of the real corpus, sealed study
let PIN_NULL_MAX      = 94     // observed maximum of the composition-matched null
let PIN_CORPUS_MEDLEN = 66

print("HOMOLOGY DETECTION LADDER — planted homology at the corpus median length, exact Smith-Waterman")
print("published reference figures (pinned, printed before any file is opened):")
print("  reference proteins        \(PIN_REF_PROTEINS)")
print("  reference residues        \(PIN_REF_RESIDUES)")
print("  reference sha256          \(PIN_REF_SHA)")
print("  blosum62 sha256           \(PIN_B62_SHA)")
print("  window length             \(PIN_CORPUS_MEDLEN)  (the corpus median length)")
print("  real corpus observed max   \(PIN_CORPUS_MAX)   (sealed study 4195961…)")
print("  null observed max          \(PIN_NULL_MAX)")
print("  gap model                 BLASTP default: a gap of length k costs 11 + k")
print("  no e-value is computed anywhere in this program")
print("")

var TX: [String] = []
func emit(_ s: String = "") { TX.append(s); print(s) }
func note(_ s: String = "") { print(s) }
func progress(_ s: String) {
    FileHandle.standardError.write(("[progress] " + s + "\n").data(using: .utf8)!)
}
func refuse(_ reason: String) -> Never {
    print("")
    print("REASON: \(reason)")
    print("NO SEAL EMITTED. No verdict is published on a refusal path.")
    exit(2)
}
func nowNs() -> Int {
    var t = timespec()
    clock_gettime(CLOCK_MONOTONIC, &t)
    return t.tv_sec * 1_000_000_000 + t.tv_nsec
}
let T_START = nowNs()
// ---------------------------------------------------------------------------
// SHA-256, self-contained.
// ---------------------------------------------------------------------------
struct SHA256Exact {
    static let k: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    @inline(__always) static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }

    static func hex(_ bytes: UnsafePointer<UInt8>, _ n: Int) -> String {
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                           0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        var w = [UInt32](repeating: 0, count: 64)
        // tail block(s)
        let bitLen = UInt64(n) &* 8
        var tail = [UInt8]()
        let rem = n % 64
        tail.reserveCapacity(128)
        for i in (n - rem)..<n { tail.append(bytes[i]) }
        tail.append(0x80)
        while tail.count % 64 != 56 { tail.append(0) }
        for i in (0..<8).reversed() { tail.append(UInt8((bitLen >> (UInt64(i) * 8)) & 0xff)) }

        func block(_ p: UnsafePointer<UInt8>) {
            for t in 0..<16 {
                w[t] = (UInt32(p[t*4]) << 24) | (UInt32(p[t*4+1]) << 16)
                     | (UInt32(p[t*4+2]) << 8) | UInt32(p[t*4+3])
            }
            for t in 16..<64 {
                let s0 = rotr(w[t-15],7) ^ rotr(w[t-15],18) ^ (w[t-15] >> 3)
                let s1 = rotr(w[t-2],17) ^ rotr(w[t-2],19) ^ (w[t-2] >> 10)
                w[t] = w[t-16] &+ s0 &+ w[t-7] &+ s1
            }
            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            for t in 0..<64 {
                let S1 = rotr(e,6) ^ rotr(e,11) ^ rotr(e,25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rotr(a,2) ^ rotr(a,13) ^ rotr(a,22)
                let mj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ mj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
        }
        var off = 0
        while off + 64 <= n - rem { block(bytes + off); off += 64 }
        tail.withUnsafeBufferPointer { tb in
            var o = 0
            while o < tb.count { block(tb.baseAddress! + o); o += 64 }
        }
        var out = ""
        for v in h {
            for i in (0..<4).reversed() {
                let byte = UInt8((v >> (UInt32(i) * 8)) & 0xff)
                out += String(byte >> 4, radix: 16) + String(byte & 0xf, radix: 16)
            }
        }
        return out
    }
    static func hexOf(_ d: Data) -> String {
        return d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) -> String in
            hex(raw.bindMemory(to: UInt8.self).baseAddress!, raw.count)
        }
    }
    static func hexOf(_ s: String) -> String {
        var a = Array(s.utf8)
        return a.withUnsafeMutableBufferPointer { hex($0.baseAddress!, $0.count) }
    }
    static func firstEightBytes(_ s: [UInt8]) -> UInt64 {
        var a = s
        let hx = a.withUnsafeMutableBufferPointer { hex($0.baseAddress!, $0.count) }
        var v: UInt64 = 0
        for c in hx.utf8.prefix(16) {
            let d: UInt64
            switch c {
            case 0x30...0x39: d = UInt64(c - 0x30)
            default:          d = UInt64(c - 0x61 + 10)
            }
            v = (v << 4) | d
        }
        return v
    }
}

// ---------------------------------------------------------------------------
// study root, found by walking up.  NO ABSOLUTE PATH IN THE SOURCE.
//
// TWO starting points, and the second one has a consequence a reader must know:
// the walk starts from the executable's own directory AND from the WORKING
// DIRECTORY.  The CWD start is what lets the binary be built and run from
// somewhere else against a study tree it is not inside.  It also means that
// MOVING THE BINARY IS NOT ON ITS OWN A RE-ROOT: a probe copied to an empty
// temporary tree, but launched from a shell sitting inside the real study tree,
// finds the real inputs through the CWD start and runs the whole study.
//
// That is not hypothetical.  It is what happened the first time validate.sh ran
// its refusal arms: the arm asserting "no study root anywhere" ran the complete
// 39-minute computation at 431% CPU instead of refusing in milliseconds, and the
// same arm had PASSED by hand ten minutes earlier only because that shell's
// working directory happened to lie outside the tree.  Same binary, same probe,
// same assertion, opposite result, decided by ambient state the arm never named.
// validate.sh now sets the working directory for every probe invocation.
// ---------------------------------------------------------------------------
func findRoot() -> String? {
    let fm = FileManager.default
    func holds(_ d: String) -> Bool {
        return fm.fileExists(atPath: d + "/corpus/proteins_validated.csv")
            && fm.fileExists(atPath: d + "/raw/uniprot_human_reviewed.fasta")
    }
    var starts: [String] = []
    var size: UInt32 = 8192
    var buf = [CChar](repeating: 0, count: Int(size))
    if _NSGetExecutablePath(&buf, &size) == 0 {
        let exe = String(cString: buf)
        starts.append((exe as NSString).deletingLastPathComponent)
    }
    starts.append(fm.currentDirectoryPath)
    for s in starts {
        var d = (s as NSString).standardizingPath
        for _ in 0..<10 {
            if holds(d) { return d }
            let up = (d as NSString).deletingLastPathComponent
            if up == d || up.isEmpty { break }
            d = up
        }
    }
    return nil
}

guard let ROOT = findRoot() else {
    refuse("study root not found. Walked up from the executable's directory and from the working directory looking for an ancestor holding both corpus/proteins_validated.csv and raw/uniprot_human_reviewed.fasta, and found none within 10 levels.")
}
note("study root resolved by ancestor walk (not baked into the source); its path is NOT sealed.")

// BLOSUM62.  Order A R N D C Q E G H I L K M F P S T W Y V, then X at index 20.
// Index 20 is the matrix's own ambiguity row and is what U is scored through.
// ---------------------------------------------------------------------------
let AA = Array("ARNDCQEGHILKMFPSTWYVX".utf8)
let NA = 21
let B62: [Int8] = [
  4,-1,-2,-2, 0,-1,-1, 0,-2,-1,-1,-1,-1,-2,-1, 1, 0,-3,-2, 0, 0,
 -1, 5, 0,-2,-3, 1, 0,-2, 0,-3,-2, 2,-1,-3,-2,-1,-1,-3,-2,-3,-1,
 -2, 0, 6, 1,-3, 0, 0, 0, 1,-3,-3, 0,-2,-3,-2, 1, 0,-4,-2,-3,-1,
 -2,-2, 1, 6,-3, 0, 2,-1,-1,-3,-4,-1,-3,-3,-1, 0,-1,-4,-3,-3,-1,
  0,-3,-3,-3, 9,-3,-4,-3,-3,-1,-1,-3,-1,-2,-3,-1,-1,-2,-2,-1,-2,
 -1, 1, 0, 0,-3, 5, 2,-2, 0,-3,-2, 1, 0,-3,-1, 0,-1,-2,-1,-2,-1,
 -1, 0, 0, 2,-4, 2, 5,-2, 0,-3,-3, 1,-2,-3,-1, 0,-1,-3,-2,-2,-1,
  0,-2, 0,-1,-3,-2,-2, 6,-2,-4,-4,-2,-3,-3,-2, 0,-2,-2,-3,-3,-1,
 -2, 0, 1,-1,-3, 0, 0,-2, 8,-3,-3,-1,-2,-1,-2,-1,-2,-2, 2,-3,-1,
 -1,-3,-3,-3,-1,-3,-3,-4,-3, 4, 2,-3, 1, 0,-3,-2,-1,-3,-1, 3,-1,
 -1,-2,-3,-4,-1,-2,-3,-4,-3, 2, 4,-2, 2, 0,-3,-2,-1,-2,-1, 1,-1,
 -1, 2, 0,-1,-3, 1, 1,-2,-1,-3,-2, 5,-1,-3,-1, 0,-1,-3,-2,-2,-1,
 -1,-1,-2,-3,-1, 0,-2,-3,-2, 1, 2,-1, 5, 0,-2,-1,-1,-1,-1, 1,-1,
 -2,-3,-3,-3,-2,-3,-3,-3,-1, 0, 0,-3, 0, 6,-4,-2,-2, 1, 3,-1,-1,
 -1,-2,-2,-1,-3,-1,-1,-2,-2,-3,-3,-1,-2,-4, 7,-1,-1,-4,-3,-2,-2,
  1,-1, 1, 0,-1, 0, 0, 0,-1,-2,-2, 0,-1,-2,-1, 4, 1,-3,-2,-2, 0,
  0,-1, 0,-1,-1,-1,-1,-2,-2,-1,-1,-1,-1,-2,-1, 1, 5,-2,-2, 0, 0,
 -3,-3,-4,-4,-2,-2,-3,-2,-2,-3,-2,-3,-1, 1,-4,-3,-2,11, 2,-3,-2,
 -2,-2,-2,-3,-2,-1,-2,-3, 2,-1,-1,-2,-1, 3,-3,-2,-2, 2, 7,-1,-1,
  0,-3,-3,-3,-1,-2,-2,-3,-3, 3, 1,-2, 1,-1,-2,-2, 0,-3,-1, 4,-1,
  0,-1,-1,-1,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-2, 0, 0,-2,-1,-1,-1]
// Alternative convention for U, used ONLY in the sensitivity measurement.
let IDX_C = 4   // cysteine's index in the order above
let IDX_X = 20

func canonicalB62_20x20(_ m: [Int8]) -> String {
    var s = ""
    for a in 0..<20 {
        for b in 0..<20 { if b > 0 { s += " " }; s += String(m[a*NA + b]) }
        s += "\n"
    }
    return s
}

var code = [Int8](repeating: -1, count: 256)
for (i, c) in AA.enumerated() { code[Int(c)] = Int8(i) }
code[Int(UInt8(ascii: "U"))] = Int8(IDX_X)   // selenocysteine scored through the X row

// gap model, verbatim from the study: a gap of length k costs 11 + k.
let GAP_OPEN: Int32 = 12          // first gap position costs 12 (= 11 + 1)
let GAP_EXT:  Int32 = 1           // each further gap position costs 1
enum SWAnswer { case refused(String); case score(Int32) }

func swPairAnswer(_ q: [Int8], _ r: [Int8]) -> SWAnswer {
    if q.isEmpty { return .refused("empty query: a zero-length peptide has no alignment; 0 would be an answer, and there is none") }
    if r.isEmpty { return .refused("empty reference: nothing to align against") }
    return .score(swPair(q, r))
}

func swPair(_ q: [Int8], _ r: [Int8]) -> Int32 {
    let m = q.count
    var H = [Int32](repeating: 0, count: m)
    var F = [Int32](repeating: 0, count: m)
    var best: Int32 = 0
    for j in 0..<r.count {
        let rj = Int(r[j])
        var diag: Int32 = 0
        var vert: Int32 = 0
        for i in 0..<m {
            let hPrev = H[i]
            var h = diag + Int32(B62[Int(q[i]) * NA + rj])
            if h < 0 { h = 0 }
            if vert > h { h = vert }
            if F[i] > h { h = F[i] }
            if h > best { best = h }
            let hgo = h - GAP_OPEN
            vert = max(vert - GAP_EXT, hgo)
            F[i] = max(F[i] - GAP_EXT, hgo)
            diag = hPrev
            H[i] = h
        }
    }
    return best
}
// ---------------------------------------------------------------------------
// deterministic composition-matched shuffle.  No clock, no arc4random.
// The seed is derived from the SHA-256 of the sequence itself, so the shuffle
// is a function of the sequence CONTENT and is reproducible independently of
// the corpus row order.
// ---------------------------------------------------------------------------
struct SplitMix64 {
    var s: UInt64
    init(_ seed: UInt64) { s = seed }
    mutating func next() -> UInt64 {
        s = s &+ 0x9E3779B97F4A7C15
        var z = s
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
    mutating func below(_ n: Int) -> Int { Int(next() % UInt64(n)) }
}

func shuffled(_ q: [Int8], _ raw: [UInt8], _ round: UInt64) -> [Int8] {
    var seedBytes = raw
    if round > 0 {
        var r = round
        for _ in 0..<8 { seedBytes.append(UInt8(r & 0xff)); r >>= 8 }
    }
    var rng = SplitMix64(SHA256Exact.firstEightBytes(seedBytes))
    var a = q
    var i = a.count - 1
    while i > 0 { let j = rng.below(i + 1); a.swapAt(i, j); i -= 1 }
    return a
}

// ---------------------------------------------------------------------------
// SECOND, INDEPENDENT KERNEL.  A pointer-based scalar Smith-Waterman over the
// whole proteome, returning the maximum and the protein attaining it (first in
// file order on a tie).  It is checked cell-for-cell against the verbatim
// swPair above before any measurement is emitted.  Two implementations of one
// recurrence, written separately, is the only way a zero-mismatch reading is a
// measurement rather than a tautology.
// ---------------------------------------------------------------------------
func screenOne(_ q: [Int8],
               _ refP: UnsafePointer<Int8>,
               _ startsP: UnsafePointer<Int32>,
               _ nProt: Int,
               _ matP: UnsafePointer<Int8>) -> (Int32, Int) {
    let m = q.count
    var best: Int32 = 0
    var bestP = -1
    let H  = UnsafeMutablePointer<Int32>.allocate(capacity: m)
    let F  = UnsafeMutablePointer<Int32>.allocate(capacity: m)
    let qp = UnsafeMutablePointer<Int32>.allocate(capacity: m)
    defer { H.deallocate(); F.deallocate(); qp.deallocate() }
    for i in 0..<m { qp[i] = Int32(q[i]) * Int32(NA) }
    for p in 0..<nProt {
        let s = Int(startsP[p]), e = Int(startsP[p + 1])
        for i in 0..<m { H[i] = 0; F[i] = 0 }
        var pb: Int32 = 0
        for j in s..<e {
            let rj = Int32(refP[j])
            var diag: Int32 = 0
            var vert: Int32 = 0
            for i in 0..<m {
                let hPrev = H[i]
                var h = diag + Int32(matP[Int(qp[i] + rj)])
                if h < 0 { h = 0 }
                if vert > h { h = vert }
                if F[i] > h { h = F[i] }
                if h > pb { pb = h }
                let hgo = h - GAP_OPEN
                vert = max(vert - GAP_EXT, hgo)
                F[i] = max(F[i] - GAP_EXT, hgo)
                diag = hPrev
                H[i] = h
            }
        }
        if pb > best { best = pb; bestP = p }
    }
    return (best, bestP)
}

// ---------------------------------------------------------------------------
// reference proteome, hashed and REFUSED on mismatch, then parsed.
// ---------------------------------------------------------------------------
progress("hashing reference fasta")
guard let refData = FileManager.default.contents(atPath: ROOT + "/raw/uniprot_human_reviewed.fasta") else {
    refuse("reference file could not be read under the resolved study root")
}
let refSha = SHA256Exact.hexOf(refData)
note("  reference sha256 (computed)  \(refSha)")
if refSha != PIN_REF_SHA {
    refuse("reference sha256 \(refSha) does not match the pinned \(PIN_REF_SHA). A verdict will not be sealed over a file that was not read.")
}

var refSeq = [Int8]()
refSeq.reserveCapacity(11_500_000)
var accs = [String]()
var starts = [Int32]()
var hasU = [Bool]()
var uTotal = 0
do {
    var inHeader = false
    var header = [UInt8]()
    var curHasU = false
    var started = false
    refData.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
        let p = raw.bindMemory(to: UInt8.self)
        for idx in 0..<p.count {
            let c = p[idx]
            if c == UInt8(ascii: "\n") {
                if inHeader {
                    var acc = ""
                    var bars = 0
                    for b in header {
                        if b == UInt8(ascii: "|") { bars += 1; continue }
                        if bars == 1 { acc.append(Character(UnicodeScalar(b))) }
                        if bars >= 2 { break }
                    }
                    accs.append(acc.isEmpty ? "?" : acc)
                    inHeader = false
                }
                continue
            }
            if c == UInt8(ascii: "\r") { continue }
            if c == UInt8(ascii: ">") {
                if started { hasU.append(curHasU) }
                started = true
                curHasU = false
                starts.append(Int32(refSeq.count))
                inHeader = true
                header.removeAll(keepingCapacity: true)
                continue
            }
            if inHeader { header.append(c); continue }
            if c == UInt8(ascii: "U") { curHasU = true; uTotal += 1 }
            let k = code[Int(c)]
            if k < 0 { continue }
            refSeq.append(k)
        }
    }
    if started { hasU.append(curHasU) }
    starts.append(Int32(refSeq.count))
}
let nProt = accs.count
if nProt != PIN_REF_PROTEINS {
    refuse("reference parsed to \(nProt) proteins, pinned \(PIN_REF_PROTEINS)")
}
if refSeq.count != PIN_REF_RESIDUES {
    refuse("reference parsed to \(refSeq.count) residues, pinned \(PIN_REF_RESIDUES)")
}

// raw copies, so the parallel screen touches no Swift array
let REFP = UnsafeMutablePointer<Int8>.allocate(capacity: refSeq.count)
refSeq.withUnsafeBufferPointer { REFP.initialize(from: $0.baseAddress!, count: $0.count) }
let STP = UnsafeMutablePointer<Int32>.allocate(capacity: starts.count)
starts.withUnsafeBufferPointer { STP.initialize(from: $0.baseAddress!, count: $0.count) }
let MATP = UnsafeMutablePointer<Int8>.allocate(capacity: B62.count)
B62.withUnsafeBufferPointer { MATP.initialize(from: $0.baseAddress!, count: $0.count) }

// ---------------------------------------------------------------------------
// THE LADDER, constructed by a rule stated in full so it can be re-derived.
// ---------------------------------------------------------------------------
let W = PIN_CORPUS_MEDLEN                 // 66, the corpus median length
let NSRC = 8
let SUBS = [0, 7, 13, 20, 26, 33, 40, 46, 53, 60, 66]
let STRIDE = 31                           // coprime to 66, so the visit order is a permutation
let SHIFT = 10                            // residue r becomes (r + 10) mod 20

var order = [Int](repeating: 0, count: W)
for i in 0..<W { order[i] = (i * STRIDE) % W }

var picks = [Int]()
for k in 0..<NSRC {
    var i = (k * nProt) / NSRC
    var guardCount = 0
    while guardCount < nProt {
        let len = Int(starts[i + 1] - starts[i])
        if len >= 2 * W && !hasU[i] && !picks.contains(i) { break }
        i = (i + 1) % nProt
        guardCount += 1
    }
    picks.append(i)
}

func windowOf(_ p: Int) -> [Int8] {
    let s = Int(starts[p]), e = Int(starts[p + 1])
    let off = s + (e - s - W) / 2
    var q = [Int8]()
    q.reserveCapacity(W)
    for i in 0..<W { q.append(refSeq[off + i]) }
    return q
}
func mutate(_ q: [Int8], _ s: Int) -> [Int8] {
    var a = q
    for t in 0..<s {
        let pos = order[t]
        a[pos] = Int8((Int(a[pos]) + SHIFT) % 20)
    }
    return a
}
func hamming(_ a: [Int8], _ b: [Int8]) -> Int {
    var n = 0
    for i in 0..<a.count where a[i] != b[i] { n += 1 }
    return n
}
func diagSum(_ q: [Int8]) -> Int32 {
    var t: Int32 = 0
    for r in q { t += Int32(B62[Int(r) * NA + Int(r)]) }
    return t
}
func letters(_ q: [Int8]) -> String {
    var s = ""
    for r in q { s.append(Character(UnicodeScalar(AA[Int(r)]))) }
    return s
}

let intact = picks.map { windowOf($0) }
var queries = [[Int8]]()
var qSrc = [Int]()          // index into picks
var qSubs = [Int]()         // -1 marks the shuffled rung
for (k, w) in intact.enumerated() {
    for s in SUBS { queries.append(mutate(w, s)); qSrc.append(k); qSubs.append(s) }
    queries.append(shuffled(w, Array(letters(w).utf8), 0)); qSrc.append(k); qSubs.append(-1)
}
let NQ = queries.count

// ---------------------------------------------------------------------------
// SELF-TEST.  Runs BEFORE any measurement is emitted.  Arms fire in BOTH
// directions: an arm that can only pass is an arm that measures nothing.
// ---------------------------------------------------------------------------
var armPass = 0, armTotal = 0
var armLines: [String] = []
func arm(_ id: String, _ claim: String, _ ok: Bool, _ detail: String) {
    armTotal += 1
    if ok { armPass += 1 }
    armLines.append("  [\(ok ? "PASS" : "FAIL")] \(id) \(claim) — \(detail)")
}

let b62canon = canonicalB62_20x20(B62)
arm("L1", "BLOSUM62 matches the INDEPENDENT matrix the study pinned",
    SHA256Exact.hexOf(b62canon) == PIN_B62_SHA,
    "canonical 20x20 sha256 \(SHA256Exact.hexOf(b62canon))")
do {
    var m = B62; m[0] = 5
    let h = SHA256Exact.hexOf(canonicalB62_20x20(m))
    arm("L2", "the matrix digest gate DISCRIMINATES",
        h != PIN_B62_SHA, "one cell changed (A:A 4->5) gives \(String(h.prefix(16)))…, not the pinned digest")
}
do {
    func s(_ a: String, _ b: String) -> Int32 {
        swPair(Array(a.utf8).map { code[Int($0)] }, Array(b.utf8).map { code[Int($0)] })
    }
    let ok = s("AW","AW") == 15 && s("WWWW","WWAWW") == 32 && s("WAW","WAW") == 26
          && s("WCW","WAW") == 22 && s("C","W") == 0
    arm("L3", "hand-computed alignments agree exactly", ok,
        "AW/AW=\(s("AW","AW")) WWWW/WWAWW=\(s("WWWW","WWAWW")) WAW/WAW=\(s("WAW","WAW")) WCW/WAW=\(s("WCW","WAW")) C/W=\(s("C","W"))")
}
do {
    // the two implementations, on 8 real windows against 24 real proteins each
    var mism = 0, cmp = 0
    var sawNonZero = 0
    for (k, w) in intact.enumerated() {
        for t in 0..<24 {
            let p = (picks[k] + t * 811) % nProt
            let s0 = Int(starts[p]), e0 = Int(starts[p + 1])
            var prot = [Int8](); prot.reserveCapacity(e0 - s0)
            for i in s0..<e0 { prot.append(refSeq[i]) }
            let a = swPair(w, prot)
            var best: Int32 = 0
            w.withUnsafeBufferPointer { _ in }
            prot.withUnsafeBufferPointer { pb in
                var one = [Int32](repeating: 0, count: 2); one[0] = 0; one[1] = Int32(prot.count)
                one.withUnsafeBufferPointer { ob in
                    B62.withUnsafeBufferPointer { mb in
                        best = screenOne(w, pb.baseAddress!, ob.baseAddress!, 1, mb.baseAddress!).0
                    }
                }
            }
            cmp += 1
            if a != best { mism += 1 }
            if a > 0 { sawNonZero += 1 }
        }
    }
    arm("L4", "the two independently written kernels agree on real data",
        mism == 0 && sawNonZero == cmp,
        "\(cmp) window/protein pairs compared, \(mism) disagreements, \(sawNonZero) of \(cmp) non-zero — a zero-mismatch reading over all-zero scores would prove nothing")
}
do {
    let a = swPair(Array("W".utf8).map { code[Int($0)] }, Array("W".utf8).map { code[Int($0)] })
    let b = swPair(Array("W".utf8).map { code[Int($0)] }, Array("A".utf8).map { code[Int($0)] })
    arm("L5", "the equality comparator DOES fire on unequal input", a != b,
        "W/W=\(a) and W/A=\(b) compare unequal, so L4's zero is a measurement")
}
do {
    var refused = false, zeroAnswered = false
    switch swPairAnswer([], [0, 1, 2]) { case .refused: refused = true; case .score: refused = false }
    switch swPairAnswer(Array("C".utf8).map { code[Int($0)] }, Array("W".utf8).map { code[Int($0)] }) {
        case .refused: zeroAnswered = false
        case .score(let v): zeroAnswered = (v == 0)
    }
    arm("L6", "an EMPTY query is REFUSED while a legitimate ZERO is ANSWERED",
        refused && zeroAnswered,
        "empty query refused; C vs W answered as score 0 — ABSENCE and REFUSAL are different answers here")
}
do {
    let distinct = Set(order).count
    var everyChanged = true
    for (k, w) in intact.enumerated() {
        let full = mutate(w, W)
        for i in 0..<W where full[i] == w[i] { everyChanged = false; _ = k }
    }
    arm("L7", "the substitution schedule is a PERMUTATION and every substitution changes the residue",
        distinct == W && everyChanged,
        "\(distinct) distinct positions of \(W); at 66 substitutions no position retains its residue in any of the \(NSRC) windows")
}
do {
    var wrong = 0
    for qi in 0..<NQ where qSubs[qi] >= 0 {
        if hamming(queries[qi], intact[qSrc[qi]]) != qSubs[qi] { wrong += 1 }
    }
    arm("L8", "the realised substitution count equals the scheduled one on every rung",
        wrong == 0, "\(NQ - NSRC) substitution rungs, \(wrong) whose Hamming distance to the intact window differs from its label")
}
do {
    var multisetOK = true, notIdentity = 0
    for qi in 0..<NQ where qSubs[qi] == -1 {
        let a = queries[qi].sorted(), b = intact[qSrc[qi]].sorted()
        if a != b { multisetOK = false }
        if queries[qi] != intact[qSrc[qi]] { notIdentity += 1 }
    }
    arm("L9", "the shuffled rung preserves composition EXACTLY and is not the identity",
        multisetOK && notIdentity == NSRC,
        "\(NSRC) shuffles, residue multiset preserved on all, \(notIdentity) differ from the intact window")
}
do {
    arm("L10", "the eight source proteins are DISTINCT, long enough, and carry no U",
        Set(picks).count == NSRC
        && picks.allSatisfy { Int(starts[$0 + 1] - starts[$0]) >= 2 * W }
        && picks.allSatisfy { !hasU[$0] },
        "\(Set(picks).count) distinct of \(NSRC); every one at least \(2 * W) residues; U-bearing proteins skipped so the query alphabet is the 20 standard residues, as the corpus is")
}

note("SELF-TEST: \(armPass) of \(armTotal) arms pass")
for l in armLines { note(l) }
if armPass != armTotal {
    refuse("self-test failed: \(armTotal - armPass) of \(armTotal) arms did not hold. No measurement is emitted on a failed self-test.")
}
note("")

// ---------------------------------------------------------------------------
// THE SCREEN.  Every rung against every one of the 20,431 proteins.
// ---------------------------------------------------------------------------
let T_SCREEN = nowNs()
progress("screening \(NQ) ladder queries against \(nProt) proteins")
let SC = UnsafeMutablePointer<Int32>.allocate(capacity: NQ)
let AP = UnsafeMutablePointer<Int32>.allocate(capacity: NQ)
DispatchQueue.concurrentPerform(iterations: NQ) { qi in
    let r = screenOne(queries[qi], REFP, STP, nProt, MATP)
    SC[qi] = r.0
    AP[qi] = Int32(r.1)
}
let SCREEN_MS = (nowNs() - T_SCREEN) / 1_000_000

var cells = 0
for q in queries { cells += q.count * refSeq.count }

// ---------------------------------------------------------------------------
// TRANSCRIPT
// ---------------------------------------------------------------------------
emit("BEGIN LADDER TRANSCRIPT")
emit("CONTROL ARM: does this instrument FIND homology when homology is PLANTED?")
emit("INSTRUMENT: exact Smith-Waterman local alignment, BLOSUM62, integer affine gaps (a gap of length k costs 11 + k)")
emit("NO E-VALUE. NO FITTED PARAMETER. NO SEEDING HEURISTIC. NO SAMPLING. NO CUTOFF INSIDE THE ARITHMETIC.")
emit("This is the SAME law as the sealed study: SHA256Exact, findRoot, the BLOSUM62 table and swPair are")
emit("lifted verbatim from peptide-homology-exact.swift, and a second kernel is checked against swPair (L4).")
emit("")
emit("INPUT, hashed by this program and refused on mismatch")
emit("  reference sha256 (computed)  \(refSha)")
emit("  blosum62 sha256 (computed)   \(SHA256Exact.hexOf(b62canon))")
emit("  reference proteins \(nProt)")
emit("  reference residues \(refSeq.count)")
emit("")
emit("SELF-TEST: \(armPass) of \(armTotal) arms pass")
for l in armLines { emit(l) }
emit("")
emit("COMPLETENESS, stated as a count rather than as a word")
emit("  ladder queries \(NQ), every one against every one of the \(nProt) reference proteins")
emit("  dynamic programming cells: \(cells)")
emit("")
emit("THE PLANTED SEQUENCES — a \(W)-residue window cut VERBATIM out of a real human protein")
emit("  selection rule: for k = 0..\(NSRC - 1), start at protein index k*\(nProt)/\(NSRC) and walk forward to the")
emit("  first protein of at least \(2 * W) residues carrying no U. Window start = (length - \(W))/2, integer division.")
emit("  source  accession  protein_len  window_start_in_protein  window_self_score(sum of its BLOSUM62 diagonal)")
for (k, p) in picks.enumerated() {
    let len = Int(starts[p + 1] - starts[p])
    emit("  P\(k + 1)      \(accs[p])     \(len)          \((len - W) / 2)                      \(diagSum(intact[k]))")
}
emit("")
emit("THE SUBSTITUTION SCHEDULE — stated in full so the ladder can be re-derived")
emit("  positions are substituted in the order (i * \(STRIDE)) mod \(W) for i = 0,1,2,...; \(STRIDE) and \(W) are coprime,")
emit("  so the order is a permutation of the \(W) positions and substitutions stay spread across the window (L7).")
emit("  a residue at index r of \"ARNDCQEGHILKMFPSTWYVX\" is replaced by the residue at index (r + \(SHIFT)) mod 20.")
emit("  Some of those replacements are conservative under BLOSUM62 (R->K = +2, I->V = +3) and most are not.")
emit("  The rule is fixed and blind to the score: it is not tuned to make the ladder fall at any particular rate.")
emit("")
emit("THE LADDER — maximum exact Smith-Waterman score against the WHOLE proteome")
emit("  identity is stated as an integer count of retained positions out of \(W).")
var header = "  subs  identity"
for k in 0..<NSRC { header += "   P\(k + 1)" }
header += "    min   max"
emit(header)
for s in SUBS {
    var row = "  "
    row += String(format: "%4d", s)
    var idt = "\(W - s)/\(W)"
    while idt.count < 6 { idt = " " + idt }
    row += "   " + idt + "   "
    var vals = [Int32]()
    for k in 0..<NSRC {
        var v: Int32 = -1
        for qi in 0..<NQ where qSrc[qi] == k && qSubs[qi] == s { v = SC[qi] }
        vals.append(v)
        row += String(format: "%5d", Int(v))
    }
    row += "  " + String(format: "%5d", Int(vals.min()!)) + " " + String(format: "%5d", Int(vals.max()!))
    emit(row)
}
do {
    var idt2 = "0/\(W)"
    while idt2.count < 6 { idt2 = " " + idt2 }
    var row = "  shuf   " + idt2 + "   "
    var vals = [Int32]()
    for k in 0..<NSRC {
        var v: Int32 = -1
        for qi in 0..<NQ where qSrc[qi] == k && qSubs[qi] == -1 { v = SC[qi] }
        vals.append(v)
        row += String(format: "%5d", Int(v))
    }
    row += "  " + String(format: "%5d", Int(vals.min()!)) + " " + String(format: "%5d", Int(vals.max()!))
    emit(row)
    emit("  the shuf row holds the SAME residues in a different ORDER — composition is identical to the 0-subs row.")
}
emit("")
emit("DOES THE SCREEN STILL NAME THE RIGHT PROTEIN? argmax accession per rung")
emit("  subs  " + (0..<NSRC).map { "P\($0 + 1)" }.joined(separator: "      "))
for s in SUBS {
    var row = "  " + String(format: "%4d", s) + "  "
    for k in 0..<NSRC {
        var a = -1
        for qi in 0..<NQ where qSrc[qi] == k && qSubs[qi] == s { a = Int(AP[qi]) }
        row += (a == picks[k] ? "self  " : accs[a] + " ")
    }
    emit(row)
}
do {
    var row = "  shuf  "
    for k in 0..<NSRC {
        var a = -1
        for qi in 0..<NQ where qSrc[qi] == k && qSubs[qi] == -1 { a = Int(AP[qi]) }
        row += (a == picks[k] ? "self  " : accs[a] + " ")
    }
    emit(row)
}
emit("")
emit("THE DETECTION FLOOR, against the sealed study's own observed maxima")
var floorAll = -1, floorAny = -1
for s in SUBS {
    var vals = [Int32]()
    for k in 0..<NSRC {
        for qi in 0..<NQ where qSrc[qi] == k && qSubs[qi] == s { vals.append(SC[qi]) }
    }
    if vals.allSatisfy({ $0 > Int32(PIN_CORPUS_MAX) }) { floorAll = s }
    if vals.contains(where: { $0 > Int32(PIN_CORPUS_MAX) }) { floorAny = s }
}
emit("  real corpus observed maximum (sealed study): \(PIN_CORPUS_MAX)")
emit("  null observed maximum        (sealed study): \(PIN_NULL_MAX)")
emit("  highest substitution count at which ALL \(NSRC) windows still outscore \(PIN_CORPUS_MAX): \(floorAll)  (identity \(W - floorAll)/\(W))")
emit("  highest substitution count at which ANY window still outscores \(PIN_CORPUS_MAX): \(floorAny)  (identity \(W - floorAny)/\(W))")
do {
    var above = 0, total = 0
    for qi in 0..<NQ where qSubs[qi] == -1 { total += 1; if SC[qi] > Int32(PIN_CORPUS_MAX) { above += 1 } }
    emit("  shuffled windows scoring above \(PIN_CORPUS_MAX): \(above) of \(total) — the ladder's own negative rung")
}
emit("")
emit("WHAT THIS ARM ESTABLISHES AND WHAT IT DOES NOT")
emit("MEASURES: that this exact-integer instrument, run against the whole proteome with no seeding")
emit("  heuristic, returns scores far above the generated corpus's observed maximum for peptides that")
emit("  carry real human sequence, and keeps doing so as that sequence is degraded by substitution")
emit("  until the identity falls to the level stated above. An instrument that cannot find homology")
emit("  and an instrument that found none are indistinguishable without this arm.")
emit("DOES NOT MEASURE: any property of the generated corpus. This program never opens the corpus.")
emit("  It also says nothing about cross-reactivity, MHC presentation, antibody binding, or safety.")
emit("END LADDER TRANSCRIPT")

let seal = SHA256Exact.hexOf(TX.joined(separator: "\n") + "\n")
print("SEAL sha256(ladder transcript) = \(seal)")
print("")
print("UNSEALED timings — outside the seal, because a seal that moves when nothing about the answer moved")
print("is a turn counter.")
print("  screen  \(SCREEN_MS) ms")
print("  total   \((nowNs() - T_START) / 1_000_000) ms")
