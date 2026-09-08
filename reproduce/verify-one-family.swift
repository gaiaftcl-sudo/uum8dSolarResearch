// INDEPENDENT VERIFIER — ONE FAMILY, deliberately naive.  The strand AND its sixteen
// composition-matched permutations, whole transcriptome, one resident copy, one window at a time,
// one position at a time.  No packed register, no exclusive-or trick, no interleaved histogram.
// It DOES use threads, because threads are a scheduling choice and not a scoring law: every
// accumulator is a per-thread sum merged after the join, and the same corpus returns the same
// integers at any thread count, which is checked by running it at two.  Its only job is to
// DISAGREE with the main instrument if the main instrument is wrong, and in particular to settle
// the two claims the main instrument's headline rests on:
//
//   1. the burden at <= 4 mismatches outside the measured target genes, for the strand and for
//      each of the sixteen permutations, as sixteen separate integers rather than a summary;
//   2. the RANK INTERVAL and the DISPOSITION that follow from those integers — including how many
//      controls tie the strand exactly, which is the number one comparison operator turns into a
//      24-fold difference in a published headline.
//
// The permutation is re-implemented here from the DECLARED rule (Fisher-Yates, seed
// 0x243F6A8885A308D3 + n * 0x9E3779B97F4A7C15, LCG 6364136223846793005 / 1442695040888963407,
// index (s >> 33) % (i+1), i descending) rather than shared with the main program.  Two
// implementations of one declared law is the only way a re-implementation can check it.
//
// Usage — probe as argv[1], defaults to eteplirsen, the family that ties all sixteen at zero:
//   xcrun swiftc -O -swift-version 5 reproduce/verify-one-family.swift -o /tmp/vof
//   gunzip -c gencode.v50.transcripts.fa.gz | /tmp/vof CTCCAACATCAAGGAAGATGGCATTTCTAG
//
// A near-complementary window is a place a molecule COULD pair. It is not a cut, not an
// occupancy, not a clinical event, and not evidence that any medicine harms anyone.

import Foundation

setvbuf(stdout, nil, _IONBF, 0)

let SCRAMBLES = 16
let KMAX = 4

// eteplirsen, UNII AIW6036FAS — the L=30 family that ties every one of its permutations at zero
let DEFAULT_PROBE = "CTCCAACATCAAGGAAGATGGCATTTCTAG"
let probeStr = CommandLine.arguments.count > 1 ? CommandLine.arguments[1].uppercased() : DEFAULT_PROBE

func code(_ c: UInt8) -> Int8 {
    switch c {
    case 65, 97: return 0            // A a
    case 67, 99: return 1            // C c
    case 71, 103: return 2           // G g
    case 84, 116, 85, 117: return 3  // T t U u
    default: return -1
    }
}
// The published reference figures, printed on EVERY exit path including both refusals, so a
// reader who runs this with no corpus still sees the integers the page cites and can tell them
// apart from a run of their own. A refusal that prints nothing fails every figure check a harness
// could pin to it, and this programme has paid for that twice.
func printPublishedReference() {
    print("")
    print("PUBLISHED REFERENCE RUN — printed on every exit path, refusals included")
    print("  reference    : GENCODE v50, gencode.v50.transcripts.fa.gz, sha256")
    print("                 5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56")
    print("                 670670 transcripts, 79139 genes, 1468006855 scoreable 19-mer windows")
    print("  zerlasiran guide strand ATAACTCTGTCCATTACCG, L=19, target LPA and LPAL2:")
    print("                 11 perfect complements; off-target at <= 4 mismatches 965 windows")
    print("                 controls 991 1002 1007 1026 1051 1053 1150 1250 1554 1621 1667 1838")
    print("                          1950 2383 2950 4089")
    print("                 0 controls below it, 0 tie it, rank 1 of 17, BELOW-all-16, kRes 1")
    print("  eteplirsen CTCCAACATCAAGGAAGATGGCATTTCTAG, L=30, target DMD:")
    print("                 20 perfect complements; off-target at <= 4 mismatches 0 windows and")
    print("                 all 16 controls also 0 — 16 tie it exactly, rank interval 1-17,")
    print("                 ties-all-16, kRes 7, and AT kRes it is ABOVE all 16 (51 vs 0-20)")
    print("  RANK 1 MEANS burden < min(controls). A tie is not fewer places.")
    print("  MARKER  INDEPENDENT_VERIFIER_ONE_FAMILY")
    print("")
    print("A near-complementary window is a place a molecule COULD pair. It is not a cut, not an")
    print("occupancy, not a clinical event, and not evidence that any medicine harms anyone. A")
    print("high rank is not a safety finding and a low rank is not a clearance.")
}

let probe0: [Int8] = Array(probeStr.utf8).map { code($0) }
guard !probe0.isEmpty, !probe0.contains(-1) else {
    print("PROBE HAS A NON-STANDARD BASE OR IS EMPTY — refusing. A gate given nothing must not pass.")
    printPublishedReference()
    exit(2)
}
let L = probe0.count

// the declared permutation, re-implemented from the rule rather than shared
func permute(_ base: [Int8], _ n: Int) -> [Int8] {
    var s = UInt64(0x243F6A8885A308D3) &+ (UInt64(n) &* UInt64(0x9E3779B97F4A7C15))
    var a = base
    var i = a.count - 1
    while i > 0 {
        s = s &* 6364136223846793005 &+ 1442695040888963407
        let j = Int((s >> 33) % UInt64(i + 1))
        let t = a[i]; a[i] = a[j]; a[j] = t
        i -= 1
    }
    return a
}
var probes: [[Int8]] = [probe0]
for n in 1...SCRAMBLES { probes.append(permute(probe0, n)) }

// composition must be identical across the family, checked here independently
do {
    func census(_ s: [Int8]) -> [Int] { var c = [Int](repeating: 0, count: 4); for b in s { c[Int(b)] += 1 }; return c }
    let base = census(probe0)
    var same = 0
    for p in probes where census(p) == base { same += 1 }
    print("composition check     : \(same) of \(probes.count) probes carry A=\(base[0]) C=\(base[1]) G=\(base[2]) T=\(base[3])")
    if same != probes.count { print("COMPOSITION BROKEN — refusing"); printPublishedReference(); exit(1) }
}

// ---- read the whole corpus from stdin, hold it resident ----
// The reserve happens only once a first read has actually returned bytes, so a run with no
// corpus refuses without first asking the kernel for a gigabyte and a half it will not use.
var raw = [UInt8]()
let bufSize = 1 << 22
var buf = [UInt8](repeating: 0, count: bufSize)
var reserved = false
while true {
    let n = read(0, &buf, bufSize)
    if n <= 0 { break }
    if !reserved { raw.reserveCapacity(1_600_000_000); reserved = true }
    raw.append(contentsOf: buf[0..<n])
}
guard raw.count > 1000 else {
    print("NO CORPUS ON STANDARD INPUT — refusing. A gate given nothing must not pass.")
    printPublishedReference()
    exit(2)
}

// ---- parse FASTA into one base array + per-transcript spans + gene ids ----
var bases = [UInt8]();  bases.reserveCapacity(raw.count)
var spanStart = [Int](), spanLen = [Int](), spanGene = [Int]()
var geneIds = [String: Int](); var geneNames = [String]()
var i = 0
var curStart = -1
func closeSpan() {
    if curStart >= 0 { spanLen.append(bases.count - curStart); curStart = -1 }
}
while i < raw.count {
    if raw[i] == 62 { // '>'
        closeSpan()
        var j = i + 1
        while j < raw.count && raw[j] != 10 { j += 1 }
        let header = String(decoding: raw[(i+1)..<j], as: UTF8.self)
        let f = header.split(separator: "|", omittingEmptySubsequences: false)
        let gname = f.count > 5 ? String(f[5]) : (f.count > 1 ? String(f[1]) : "?")
        let gid: Int
        if let e = geneIds[gname] { gid = e } else { gid = geneNames.count; geneIds[gname] = gid; geneNames.append(gname) }
        spanStart.append(bases.count); spanGene.append(gid); curStart = bases.count
        i = j + 1
    } else {
        var j = i
        while j < raw.count && raw[j] != 10 { j += 1 }
        if curStart >= 0 { bases.append(contentsOf: raw[i..<j]) }
        i = j + 1
    }
}
closeSpan()
raw = []
let nTx = spanStart.count
guard spanLen.count == nTx else {
    print("PARSE MISMATCH \(spanStart.count) vs \(spanLen.count)")
    printPublishedReference()
    exit(2)
}

// precode every base once
var bc = [Int8](repeating: -1, count: bases.count)
for k in 0..<bases.count { bc[k] = code(bases[k]) }
bases = []

// ---- PASS 1: which genes carry the REAL strand's perfect complement ----
// Threads are a SCHEDULING choice; the scoring law below is still one position at a time, one
// integer comparison per position, with no packed register and no popcount anywhere. Every
// accumulator is a per-thread sum merged after the join, so the answer does not depend on how
// many threads there were.
let VTHREADS = max(1, min(32, ProcessInfo.processInfo.environment["VOF_THREADS"].flatMap { Int($0) }
                                 ?? ProcessInfo.processInfo.activeProcessorCount))
final class Slice1 { var isTarget: [Bool]; var perfect = 0; var scored = 0
                     init(_ g: Int) { isTarget = [Bool](repeating: false, count: g) } }
var isTarget = [Bool](repeating: false, count: geneNames.count)
var perfectTotal = 0
var scoreableWindows = 0
do {
    var slices: [Slice1] = []
    for _ in 0..<VTHREADS { slices.append(Slice1(geneNames.count)) }
    let box = slices
    let lock = NSLock()
    var nextTx = 0
    let sem = DispatchSemaphore(value: 0)
    let BLK = 256
    var spawned: [Thread] = []
    for tid in 0..<VTHREADS {
        let th = Thread {
            let sl = box[tid]
            bc.withUnsafeBufferPointer { bp in
              let b = bp.baseAddress!
              probe0.withUnsafeBufferPointer { pb in
                let pr = pb.baseAddress!
                while true {
                    lock.lock(); let lo = nextTx; nextTx += BLK; lock.unlock()
                    if lo >= nTx { break }
                    let hi = min(nTx, lo + BLK)
                    for t in lo..<hi {
                        let s = spanStart[t], len = spanLen[t]
                        if len < L { continue }
                        let last = s + len - L
                        var w = s
                        while w <= last {
                            var m = 0; var ok = true
                            var q = 0
                            while q < L {
                                let a = b[w + L - 1 - q]
                                if a < 0 { ok = false; break }
                                if Int(pr[q]) + Int(a) != 3 { m += 1 }
                                q += 1
                            }
                            if ok {
                                sl.scored += 1
                                if m == 0 { sl.isTarget[spanGene[t]] = true; sl.perfect += 1 }
                            }
                            w += 1
                        }
                    }
                }
              }
            }
            sem.signal()
        }
        th.stackSize = 4 << 20
        th.start(); spawned.append(th)
    }
    for _ in 0..<VTHREADS { sem.wait() }
    _ = spawned
    for sl in slices {
        perfectTotal += sl.perfect; scoreableWindows += sl.scored
        for g in 0..<geneNames.count where sl.isTarget[g] { isTarget[g] = true }
    }
    slices.removeAll()
}
var targets = [String]()
for g in 0..<geneNames.count where isTarget[g] { targets.append(geneNames[g]) }
targets.sort()

// ---- PASS 2: off-target histogram for ALL SEVENTEEN probes, target genes excluded ----
var hist = [[Int]](repeating: [Int](repeating: 0, count: L + 1), count: probes.count)
var scoredPerProbe = [Int](repeating: 0, count: probes.count)
do {
    var flat = [Int8](); flat.reserveCapacity(probes.count * L)
    for p in probes { flat.append(contentsOf: p) }
    let nP = probes.count
    final class Slice2 { var h: [Int]; var scored: [Int]
                         init(_ nP: Int, _ L: Int) { h = [Int](repeating: 0, count: nP * (L + 1))
                                                     scored = [Int](repeating: 0, count: nP) } }
    var slices: [Slice2] = []
    for _ in 0..<VTHREADS { slices.append(Slice2(nP, L)) }
    let box = slices
    let lock = NSLock()
    var nextTx = 0
    let sem = DispatchSemaphore(value: 0)
    let BLK = 256
    var spawned: [Thread] = []
    for tid in 0..<VTHREADS {
        let th = Thread {
            let sl = box[tid]
            bc.withUnsafeBufferPointer { bp in
              let b = bp.baseAddress!
              flat.withUnsafeBufferPointer { fb in
                let f = fb.baseAddress!
                sl.h.withUnsafeMutableBufferPointer { hb in
                  let h = hb.baseAddress!
                  sl.scored.withUnsafeMutableBufferPointer { sb in
                    let sc = sb.baseAddress!
                    while true {
                        lock.lock(); let lo = nextTx; nextTx += BLK; lock.unlock()
                        if lo >= nTx { break }
                        let hi = min(nTx, lo + BLK)
                        for t in lo..<hi {
                            if isTarget[spanGene[t]] { continue }
                            let s = spanStart[t], len = spanLen[t]
                            if len < L { continue }
                            let last = s + len - L
                            var w = s
                            while w <= last {
                                // window cleanliness is decided ONCE, before any probe looks at it
                                var ok = true
                                var q = 0
                                while q < L { if b[w + q] < 0 { ok = false; break }; q += 1 }
                                if ok {
                                    for pi in 0..<nP {
                                        var m = 0
                                        var p = 0
                                        while p < L {
                                            if Int(f[pi * L + p]) + Int(b[w + L - 1 - p]) != 3 { m += 1 }
                                            p += 1
                                        }
                                        h[pi * (L + 1) + m] += 1
                                        sc[pi] += 1
                                    }
                                }
                                w += 1
                            }
                        }
                    }
                  }
                }
              }
            }
            sem.signal()
        }
        th.stackSize = 4 << 20
        th.start(); spawned.append(th)
    }
    for _ in 0..<VTHREADS { sem.wait() }
    _ = spawned
    for sl in slices {
        for pi in 0..<nP {
            scoredPerProbe[pi] += sl.scored[pi]
            for m in 0...L { hist[pi][m] += sl.h[pi * (L + 1) + m] }
        }
    }
    slices.removeAll()
}

func burden(_ h: [Int], _ k: Int) -> Int { var c = 0; for m in 0...min(k, h.count - 1) { c += h[m] }; return c }

print("")
print("INDEPENDENT VERIFIER — naive scorer, one family, whole transcriptome")
print("probe                 : \(probeStr)  (L=\(L))")
print("transcripts parsed    : \(nTx)")
print("threads (scheduling only, the scoring law is unchanged): \(VTHREADS)")
print("genes parsed          : \(geneNames.count)")
print("scoreable windows     : \(scoreableWindows)   (pass 1, whole corpus, length \(L))")
print("perfect complements   : \(perfectTotal)")
print("measured target genes : \(targets.count == 0 ? "NONE — this strand is REFUSED, which is not zero off-targets" : targets.prefix(6).joined(separator: ",") + (targets.count > 6 ? " +\(targets.count - 6) more" : ""))")
print("off-target windows scored per probe: \(scoredPerProbe[0])")
var allSame = true
for pi in 1..<probes.count where scoredPerProbe[pi] != scoredPerProbe[0] { allSame = false }
print("every probe scored the same window set: \(allSame)")
print("")
let letters = Array("ACGT")
print("probe                            m0     m1     m2     m3     m4    <=4      m5      m6      m7      m8")
for pi in 0..<probes.count {
    let txt = String(probes[pi].map { letters[Int($0)] })
    let tag = pi == 0 ? "STRAND " : "perm\(pi < 10 ? "0" : "")\(pi)  "
    print(tag + txt.prefix(24).padding(toLength: 25, withPad: " ", startingAt: 0)
          + (0...4).map { String(format: "%7d", hist[pi][min($0, L)]) }.joined()
          + String(format: "%7d", burden(hist[pi], 4))
          + (5...8).map { String(format: "%8d", $0 <= L ? hist[pi][$0] : 0) }.joined())
}
print("")

// ---- the rank interval and the disposition, computed here from these integers ----
var ctrl: [Int] = []
for pi in 1..<probes.count { ctrl.append(burden(hist[pi], KMAX)) }
ctrl.sort()
let d = burden(hist[0], KMAX)
var below = 0, equal = 0
for v in ctrl { if v < d { below += 1 } else if v == d { equal += 1 } }
let rLo = 1 + below, rHi = 1 + below + equal
let cmin = ctrl.first ?? 0, cmax = ctrl.last ?? 0, cmed = ctrl[SCRAMBLES / 2]
let disp: String
if d < cmin { disp = "BELOW-all-16" }
else if d > cmax { disp = "ABOVE-all-16" }
else if cmin == cmax { disp = "ties-all-16" }
else if d == cmin { disp = "ties-lowest" }
else if d == cmax { disp = "ties-highest" }
else { disp = "inside" }
print("AT <= \(KMAX) MISMATCHES, OUTSIDE THE MEASURED TARGET GENES")
print("  strand burden                       : \(d)")
print("  control burdens, sorted             : \(ctrl.map(String.init).joined(separator: " "))")
print("  control min / upper median / max    : \(cmin) / \(cmed) / \(cmax)")
print("  controls strictly BELOW the strand  : \(below)")
print("  controls EXACTLY EQUAL to the strand: \(equal)")
print("  rank interval                       : \(rLo == rHi ? String(rLo) : "\(rLo)-\(rHi)") of \(SCRAMBLES + 1)")
print("  rank under 'ties favour the strand' : \(rLo)")
print("  rank under 'ties count against it'  : \(rHi)")
print("  disposition                         : \(disp)")
if equal == SCRAMBLES {
    print("  THIS FAMILY TIES EVERY ONE OF ITS \(SCRAMBLES) PERMUTATIONS. It did not pair in fewer places;")
    print("  it paired in the SAME number of places. Under a strict-only rank rule it would print")
    print("  rank 1 and be counted as designed specificity, which is the error this verifier exists")
    print("  to settle. Rank 1 must mean burden < min(controls), and here it does not.")
}
// the resolving threshold — the smallest k at which the controls do not all agree
var kRes = -1
for k in 0...L {
    var lo = Int.max, hi = Int.min
    for pi in 1..<probes.count { let b = burden(hist[pi], k); lo = min(lo, b); hi = max(hi, b) }
    if hi > lo { kRes = k; break }
}
print("  resolving threshold kRes            : \(kRes)\(kRes < 0 ? "  (the controls never disagree anywhere in 0...L — no rank can be read)" : "")")
if kRes >= 0 {
    var c2: [Int] = []
    for pi in 1..<probes.count { c2.append(burden(hist[pi], kRes)) }
    c2.sort()
    let d2 = burden(hist[0], kRes)
    var b2 = 0, e2 = 0
    for v in c2 { if v < d2 { b2 += 1 } else if v == d2 { e2 += 1 } }
    let disp2: String
    if d2 < (c2.first ?? 0) { disp2 = "BELOW-all-16" }
    else if d2 > (c2.last ?? 0) { disp2 = "ABOVE-all-16" }
    else if c2.first == c2.last { disp2 = "ties-all-16" }
    else if d2 == c2.first { disp2 = "ties-lowest" }
    else if d2 == c2.last { disp2 = "ties-highest" }
    else { disp2 = "inside" }
    print("  at kRes=\(kRes): strand \(d2), controls \(c2.first!)-\(c2.last!), rank \(1 + b2 == 1 + b2 + e2 ? String(1 + b2) : "\(1 + b2)-\(1 + b2 + e2)"), disposition \(disp2)")
}
print("")
print("A near-complementary window is a place a molecule COULD pair. It is not a cut, not an")
print("occupancy, not a clinical event, and not evidence that any medicine harms anyone. A high")
print("rank is not a safety finding and a low rank is not a clearance.")
print("MARKER  INDEPENDENT_VERIFIER_ONE_FAMILY")
printPublishedReference()
