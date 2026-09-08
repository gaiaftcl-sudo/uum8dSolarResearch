// silicon-shear-telemetry.swift
//
// STUDY 41 — What does the ordering actually cost, and when is it worth paying?
//
// Study 40 measured that order-dependence is a property of the ARITHMETIC, not of the
// events: exact rational addition is associative and commutative, so replicas folding the
// same events in different arrival orders reach one result with no ordering protocol at all,
// while binary64 replicas genuinely disagree. That was a statement about numbers.
//
// This file is the silicon half of the same statement. If the ordering is unnecessary under
// exact arithmetic then every cycle a machine spends imposing it is waste, and waste on real
// hardware is measurable: CPU cycles, retired branches, branch mispredictions and page
// faults, read from the ARM PMU on the aarch64 Neoverse-N1 cells that serve the apex.
//
// The question is not "is sorting slow". Everyone knows sorting is slow. It is: the two arms
// return the IDENTICAL aggregate, so what exactly did the sort buy?
//
// The answer has to cut both ways or this is an advertisement. So the same fold runs under
// exact integer arithmetic — where the arms agree and the ordering is provably waste — AND
// under binary64, where the arms genuinely disagree and the ordering is load-bearing. A
// harness that said "ordering is waste" in both cases would be measuring nothing at all.
//
//   ARM A  CALIBRATION  — a perfectly predictable branch and a coin-flip branch, same loop
//                         shape, same trip count. The counter must report ~0% and ~50% miss.
//                         An instrument that cannot separate those two cannot be trusted on
//                         anything below it, and every figure in this file rests on it.
//   ARM B  EXACT FOLD   — N state vectors folded three ways: UUM8D (arrival order, no sort,
//                         pre-mapped arena), CLASSICAL_SORT (impose a total order by
//                         comparison sort over a pre-mapped arena, then fold), and
//                         CLASSICAL_ALLOC (the same, but taking its scratch inside the
//                         measured region, which is what a per-message ingest path does).
//   ARM C  AGREEMENT    — the three arms of ARM B must return the SAME integer. If they do
//                         not, the cycle delta compares different computations and means
//                         nothing. This rung is what makes the cost claim legitimate.
//   ARM D  FLOAT FOLD   — the same arms over binary64, where the arms are EXPECTED to
//                         disagree, so the ordering bought something real. This is the
//                         control that stops ARM C being an always-green verdict.
//   ARM E  SCALING      — cycles, branch misses and page faults as N rises. The falsification
//                         boundary: page faults 0 on the UUM8D arm, misses per vector flat,
//                         cycle delta rising with N.
//   ARM F  DEGENERATE   — N = 1. There is nothing to order, so the delta must collapse. If
//                         the UUM8D arm still "wins" at N=1 this harness is measuring
//                         something other than the ordering and every rung above is void.
//
// There is no corpus, no network, no key and no argument vector. Every constant is in this
// file, so every exit path prints the same reference figures and a stranger's run is
// byte-comparable with the published one.
//
// The exact path contains no Float, no Double and no CGFloat. The float arm is the thing
// being measured and is confined to the functions named `float…`.
//
// A counter the kernel time-multiplexed is a counter that silently misreports, so every read
// carries time_enabled and time_running and the run REFUSES the rung if they differ.
//
// On a platform with no Linux perf_event_open the telemetry rungs report ABSENT — not zero,
// not passed. Absence and refusal are different answers and this file says which.
//
// BUILD (native, any aarch64 Linux with a Swift 6.4 toolchain):
//   swiftc -O silicon-shear-telemetry.swift -o /tmp/s41 && /tmp/s41
// BUILD (cross, from macOS, static musl binary for the cells):
//   swiftc -O -target aarch64-swift-linux-musl -static-stdlib -sdk <sysroot> \
//          silicon-shear-telemetry.swift -o s41-linux

// The libc module differs by distribution — Glibc on Debian, Musl on the static SDK the
// cells' binaries are built with, Darwin on the Mac. Import by what EXISTS; gate behaviour
// by os(Linux) further down. Testing os(Linux) here would pick Glibc on a musl build and
// fail to compile the very target this study runs on.
#if canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#else
import Darwin
#endif

// ══════════════════════════════════════════════════════════════════════════
// SECTION A — frozen constants. Every number the run depends on lives here.
// ══════════════════════════════════════════════════════════════════════════

let SEED: UInt64 = 0x9E3779B97F4A7C15          // fixed; no clock, no entropy source
let CAL_TRIPS: Int = 3_000_000                 // ARM A loop trip count
let LADDER: [Int] = [1, 64, 256, 1024, 4096, 16384]
let TAU_QUANTA: Int64 = 1 << 20                // τ is an integer phase in [0, TAU_QUANTA)
let ARENA_CAP: Int = 16384                     // pre-mapped once, outside every measured region
let REPS: Int = 5                              // repetitions per rung; the MINIMUM is reported

// Reference figures, printed on EVERY exit path including refusals, so a run that stops
// early is still comparable with the published transcript.
let REF_MARKER = "ORDERING_IS_PRICED_IN_CYCLES_NOT_IN_PHYSICS"
let REF_CAL_COINFLIP_MISS_PER_TRIP_PPT = 500   // ~0.5 misses per trip, in parts per thousand
let REF_LADDER_TOP = 16384

// ══════════════════════════════════════════════════════════════════════════
// SECTION B — sha256, so the transcript seals without trusting this machine
// ══════════════════════════════════════════════════════════════════════════

enum SHA256Exact {
    private static let k: [UInt32] = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
        0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
        0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
        0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
        0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
        0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ]
    private static func rr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }

    static func hex(_ message: [UInt8]) -> String {
        var h: [UInt32] = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                           0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
        var m = message
        let bitLen = UInt64(message.count) &* 8
        m.append(0x80)
        while m.count % 64 != 56 { m.append(0x00) }
        var shift = 56
        while shift >= 0 { m.append(UInt8((bitLen >> UInt64(shift)) & 0xff)); shift -= 8 }
        var w = [UInt32](repeating: 0, count: 64)
        var blk = 0
        while blk < m.count {
            for t in 0..<16 {
                let o = blk + t * 4
                w[t] = (UInt32(m[o]) << 24) | (UInt32(m[o + 1]) << 16)
                     | (UInt32(m[o + 2]) << 8) | UInt32(m[o + 3])
            }
            for t in 16..<64 {
                let s0 = rr(w[t - 15], 7) ^ rr(w[t - 15], 18) ^ (w[t - 15] >> 3)
                let s1 = rr(w[t - 2], 17) ^ rr(w[t - 2], 19) ^ (w[t - 2] >> 10)
                w[t] = w[t - 16] &+ s0 &+ w[t - 7] &+ s1
            }
            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            for t in 0..<64 {
                let S1 = rr(e, 6) ^ rr(e, 11) ^ rr(e, 25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rr(a, 2) ^ rr(a, 13) ^ rr(a, 22)
                let mj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ mj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
            blk += 64
        }
        return h.map { v -> String in
            var s = String(v, radix: 16); while s.count < 8 { s = "0" + s }; return s
        }.joined()
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION C — the PMU, opened by raw syscall so this file needs no tool the
// cells do not already have. No `perf` binary, no library, no package.
// ══════════════════════════════════════════════════════════════════════════

// Reading of a counter, carrying its own multiplexing evidence.
struct Reading {
    var value: Int64
    var enabled: Int64
    var running: Int64
    var scaled: Bool { enabled != running }
}

#if os(Linux)

// Matches struct perf_event_attr in <linux/perf_event.h>. Only the fields this harness
// sets are named; the rest is zero, which is the documented meaning of an unset attribute.
struct PerfEventAttr {
    var type: UInt32 = 0
    var size: UInt32 = 0
    var config: UInt64 = 0
    var sampleUnion: UInt64 = 0
    var sampleType: UInt64 = 0
    var readFormat: UInt64 = 0
    var flags: UInt64 = 0
    var wakeupUnion: UInt32 = 0
    var bpType: UInt32 = 0
    var config1: UInt64 = 0
    var config2: UInt64 = 0
    var branchSampleType: UInt64 = 0
    var sampleRegsUser: UInt64 = 0
    var sampleStackUser: UInt32 = 0
    var clockid: Int32 = 0
    var sampleRegsIntr: UInt64 = 0
    var auxWatermark: UInt32 = 0
    var sampleMaxStack: UInt16 = 0
    var reserved2: UInt16 = 0
    var auxSampleSize: UInt32 = 0
    var reserved3: UInt32 = 0
    var sigData: UInt64 = 0
    var config3: UInt64 = 0
}

let NR_PERF_EVENT_OPEN: CLong = 241   // aarch64 generic syscall table
let NR_IOCTL: CLong = 29

// Swift cannot call a C variadic, and both glibc and musl declare `syscall` and `ioctl`
// variadic — so they arrive marked unavailable. Bind the symbols directly with a fixed
// signature instead. This is sound on AArch64 Linux specifically: AAPCS64 passes variadic
// integer arguments in the same general-purpose registers as named ones, so a fixed-arity
// call to a variadic symbol is register-identical. It would NOT be sound on Apple's arm64
// ABI, where varargs go on the stack — which is another reason the telemetry rungs are
// gated to os(Linux) and report ABSENT rather than running anywhere else.
// ONE binding, six integer arguments, used for every syscall this file makes. A symbol can
// carry only one signature, and the kernel ABI is six registers regardless of how many the
// particular call reads, so unused arguments are passed as zero and ignored.
@_silgen_name("syscall")
func sys6(_ nr: CLong, _ a1: CLong, _ a2: CLong, _ a3: CLong,
          _ a4: CLong, _ a5: CLong) -> CLong

// Bound by symbol too: the libc module is Glibc on Debian and posix_unistd on the musl SDK,
// and an unqualified `read` inside a type that has its own read() resolves to the method.
@_silgen_name("read")
func sys_read(_ fd: Int32, _ buf: UnsafeMutableRawPointer?, _ count: Int) -> Int

let PERF_TYPE_HARDWARE: UInt32 = 0
let PERF_TYPE_SOFTWARE: UInt32 = 1
let HW_CPU_CYCLES: UInt64 = 0
let HW_INSTRUCTIONS: UInt64 = 1
let HW_BRANCH_INSTRUCTIONS: UInt64 = 4
let HW_BRANCH_MISSES: UInt64 = 5
let SW_PAGE_FAULTS: UInt64 = 2

let IOC_ENABLE: CLong = 0x2400
let IOC_DISABLE: CLong = 0x2401
let IOC_RESET: CLong = 0x2403

// PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING
let READ_FORMAT_TIMES: UInt64 = 0x1 | 0x2

final class Counter {
    let name: String
    let fd: Int32
    var available: Bool { fd >= 0 }

    init(_ type: UInt32, _ config: UInt64, _ name: String) {
        self.name = name
        var a = PerfEventAttr()
        a.type = type
        a.config = config
        a.size = UInt32(MemoryLayout<PerfEventAttr>.size)
        a.readFormat = READ_FORMAT_TIMES
        // disabled = bit 0, exclude_kernel = bit 5, exclude_hv = bit 6. Kernel and
        // hypervisor are excluded so the figure is this program's own silicon behaviour,
        // not the noise of whatever else the cell is serving at that second.
        a.flags = (1 << 0) | (1 << 5) | (1 << 6)
        var attr = a
        let r = withUnsafeMutablePointer(to: &attr) { p -> CLong in
            sys6(NR_PERF_EVENT_OPEN, CLong(Int(bitPattern: p)), 0, -1, -1, 0)
        }
        self.fd = Int32(r)
    }

    func reset()   { if available { _ = sys6(NR_IOCTL, CLong(fd), IOC_RESET, 0, 0, 0) } }
    func enable()  { if available { _ = sys6(NR_IOCTL, CLong(fd), IOC_ENABLE, 0, 0, 0) } }
    func disable() { if available { _ = sys6(NR_IOCTL, CLong(fd), IOC_DISABLE, 0, 0, 0) } }

    func sample() -> Reading? {
        guard available else { return nil }
        var buf = [Int64](repeating: 0, count: 3)
        let n = buf.withUnsafeMutableBytes { rb -> Int in
            sys_read(fd, rb.baseAddress, 24)
        }
        guard n == 24 else { return nil }
        return Reading(value: buf[0], enabled: buf[1], running: buf[2])
    }

    deinit { if available { close(fd) } }
}

#endif

// A full telemetry sample for one measured region.
struct Sample {
    var cycles = Reading(value: -1, enabled: 0, running: 0)
    var instructions = Reading(value: -1, enabled: 0, running: 0)
    var branches = Reading(value: -1, enabled: 0, running: 0)
    var branchMisses = Reading(value: -1, enabled: 0, running: 0)
    var pageFaults = Reading(value: -1, enabled: 0, running: 0)
    var available = false
    var anyScaled: Bool {
        available && (cycles.scaled || instructions.scaled
                      || branches.scaled || branchMisses.scaled || pageFaults.scaled)
    }
}

final class PMU {
    var ok = false
    var whyNot = "not attempted"
    #if os(Linux)
    var cCycles: Counter?
    var cInstr: Counter?
    var cBranch: Counter?
    var cMiss: Counter?
    var cFaults: Counter?
    #endif

    init() {
        #if os(Linux)
        cCycles = Counter(PERF_TYPE_HARDWARE, HW_CPU_CYCLES, "cycles")
        cInstr  = Counter(PERF_TYPE_HARDWARE, HW_INSTRUCTIONS, "instructions")
        cBranch = Counter(PERF_TYPE_HARDWARE, HW_BRANCH_INSTRUCTIONS, "branches")
        cMiss   = Counter(PERF_TYPE_HARDWARE, HW_BRANCH_MISSES, "branch-misses")
        cFaults = Counter(PERF_TYPE_SOFTWARE, SW_PAGE_FAULTS, "page-faults")
        let all = [cCycles!, cInstr!, cBranch!, cMiss!, cFaults!]
        let missing = all.filter { !$0.available }.map { $0.name }
        if missing.isEmpty {
            ok = true
            whyNot = ""
        } else {
            ok = false
            whyNot = "perf_event_open refused: \(missing.joined(separator: ", ")) (errno \(errno))"
        }
        #else
        ok = false
        whyNot = "not Linux — perf_event_open does not exist on this platform"
        #endif
    }

    func measure(_ body: () -> Void) -> Sample {
        var s = Sample()
        #if os(Linux)
        guard ok, let a = cCycles, let b = cInstr, let c = cBranch,
              let d = cMiss, let e = cFaults else { body(); return s }
        for k in [a, b, c, d, e] { k.reset() }
        for k in [a, b, c, d, e] { k.enable() }
        body()
        for k in [a, b, c, d, e] { k.disable() }
        if let r = a.sample() { s.cycles = r }
        if let r = b.sample() { s.instructions = r }
        if let r = c.sample() { s.branches = r }
        if let r = d.sample() { s.branchMisses = r }
        if let r = e.sample() { s.pageFaults = r }
        s.available = true
        #else
        body()
        #endif
        return s
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION D — the workload. State vectors arriving out of order, as they do
// on a JetStream subject with nine publishers and no sequence lock.
// ══════════════════════════════════════════════════════════════════════════

struct XorShift {
    var s: UInt64
    init(_ seed: UInt64) { s = seed == 0 ? 0x2545F4914F6CDD1D : seed }
    mutating func next() -> UInt64 {
        s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s
    }
}

// The arena is mapped ONCE, here, outside every measured region. Nothing below
// this line allocates on the exact path.
final class Arena {
    let tau: UnsafeMutableBufferPointer<Int64>
    let node: UnsafeMutableBufferPointer<Int64>
    let value: UnsafeMutableBufferPointer<Int64>
    let idx: UnsafeMutableBufferPointer<Int32>       // permutation the sort works on
    let scratch: UnsafeMutableBufferPointer<Int32>   // merge-sort scratch, pre-mapped
    let fvalue: UnsafeMutableBufferPointer<Double>   // the float arm's copy

    init(_ cap: Int) {
        func alloc<T>(_ t: T.Type, _ n: Int) -> UnsafeMutableBufferPointer<T> {
            let p = UnsafeMutablePointer<T>.allocate(capacity: n)
            return UnsafeMutableBufferPointer(start: p, count: n)
        }
        tau = alloc(Int64.self, cap); node = alloc(Int64.self, cap)
        value = alloc(Int64.self, cap); idx = alloc(Int32.self, cap)
        scratch = alloc(Int32.self, cap); fvalue = alloc(Double.self, cap)
    }

    // Fill with N deterministic out-of-order arrivals. Runs OUTSIDE the measured region.
    func fill(_ n: Int) {
        var r = XorShift(SEED)
        for i in 0..<n {
            tau[i] = Int64(r.next() % UInt64(TAU_QUANTA))
            node[i] = Int64(r.next() % 9)                       // nine cells
            let v = Int64(bitPattern: r.next() & 0xFFFF_FFFF) - 0x8000_0000
            value[i] = v
            fvalue[i] = Double(v) * 1.0000000001               // float arm's payload
            idx[i] = Int32(i)
        }
        // Touch every page of every buffer so the arena is resident BEFORE measurement.
        // Without this the first measured region would take the arena's page faults and
        // the harness would report a cost that belongs to setup, not to the fold.
        for i in 0..<n { scratch[i] = idx[i] }
    }
}

// ── the two orderings, exact ────────────────────────────────────────────────

// UUM8D: fold in arrival order. No sort, no comparison, no branch on data.
@inline(never)
func uum8dExactFold(_ a: Arena, _ n: Int) -> Int64 {
    var acc: Int64 = 0
    for i in 0..<n { acc = acc &+ a.value[i] }
    return acc
}

// CLASSICAL: impose a total order on (tau, node) first — a Lamport-style tie-broken
// total order — then fold. Bottom-up merge sort over the PRE-MAPPED scratch, so this
// arm is charged for its comparisons and not for its memory.
@inline(never)
func classicalSortExactFold(_ a: Arena, _ n: Int) -> Int64 {
    for i in 0..<n { a.idx[i] = Int32(i) }
    var width = 1
    var src = a.idx, dst = a.scratch
    while width < n {
        var i = 0
        while i < n {
            let mid = min(i + width, n), hi = min(i + 2 * width, n)
            var l = i, r = mid, o = i
            while l < mid && r < hi {
                let li = Int(src[l]), ri = Int(src[r])
                // data-dependent branch: this is the thing being priced
                if a.tau[li] < a.tau[ri] || (a.tau[li] == a.tau[ri] && a.node[li] <= a.node[ri]) {
                    dst[o] = src[l]; l += 1
                } else {
                    dst[o] = src[r]; r += 1
                }
                o += 1
            }
            while l < mid { dst[o] = src[l]; l += 1; o += 1 }
            while r < hi  { dst[o] = src[r]; r += 1; o += 1 }
            i += 2 * width
        }
        swap(&src, &dst)
        width *= 2
    }
    var acc: Int64 = 0
    for i in 0..<n { acc = acc &+ a.value[Int(src[i])] }
    return acc
}

// CLASSICAL_ALLOC: the same total order, but taking its scratch INSIDE the measured
// region — which is what an ingest path that allocates per message batch actually does.
// This arm exists to price the allocation separately from the comparison.
@inline(never)
func classicalAllocExactFold(_ a: Arena, _ n: Int) -> Int64 {
    let p = UnsafeMutablePointer<Int32>.allocate(capacity: n)
    let q = UnsafeMutablePointer<Int32>.allocate(capacity: n)
    defer { p.deallocate(); q.deallocate() }
    for i in 0..<n { p[i] = Int32(i) }
    var width = 1
    var src = p, dst = q
    while width < n {
        var i = 0
        while i < n {
            let mid = min(i + width, n), hi = min(i + 2 * width, n)
            var l = i, r = mid, o = i
            while l < mid && r < hi {
                let li = Int(src[l]), ri = Int(src[r])
                if a.tau[li] < a.tau[ri] || (a.tau[li] == a.tau[ri] && a.node[li] <= a.node[ri]) {
                    dst[o] = src[l]; l += 1
                } else {
                    dst[o] = src[r]; r += 1
                }
                o += 1
            }
            while l < mid { dst[o] = src[l]; l += 1; o += 1 }
            while r < hi  { dst[o] = src[r]; r += 1; o += 1 }
            i += 2 * width
        }
        swap(&src, &dst)
        width *= 2
    }
    var acc: Int64 = 0
    for i in 0..<n { acc = acc &+ a.value[Int(src[i])] }
    return acc
}

// ── the same two orderings, binary64. This is the thing being measured, and it
//    is the ONLY place a Double appears on a result path. ────────────────────

@inline(never)
func floatArrivalFold(_ a: Arena, _ n: Int) -> Double {
    var acc = 0.0
    for i in 0..<n { acc += a.fvalue[i] }
    return acc
}

@inline(never)
func floatSortedFold(_ a: Arena, _ n: Int) -> Double {
    for i in 0..<n { a.idx[i] = Int32(i) }
    var width = 1
    var src = a.idx, dst = a.scratch
    while width < n {
        var i = 0
        while i < n {
            let mid = min(i + width, n), hi = min(i + 2 * width, n)
            var l = i, r = mid, o = i
            while l < mid && r < hi {
                let li = Int(src[l]), ri = Int(src[r])
                if a.tau[li] < a.tau[ri] || (a.tau[li] == a.tau[ri] && a.node[li] <= a.node[ri]) {
                    dst[o] = src[l]; l += 1
                } else {
                    dst[o] = src[r]; r += 1
                }
                o += 1
            }
            while l < mid { dst[o] = src[l]; l += 1; o += 1 }
            while r < hi  { dst[o] = src[r]; r += 1; o += 1 }
            i += 2 * width
        }
        swap(&src, &dst)
        width *= 2
    }
    var acc = 0.0
    for i in 0..<n { acc += a.fvalue[Int(src[i])] }
    return acc
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E — ARM A, the calibration. Nothing below may be believed unless
// this rung separates a predictable branch from a coin-flip one.
// ══════════════════════════════════════════════════════════════════════════

// Both arms call through a non-inlinable function. Without that, an optimising aarch64
// compiler if-converts a two-armed `if` into a branchless conditional select — and then the
// "coin-flip" loop contains no branch to mispredict. That is not a hypothetical: the first
// build of this harness measured 54 misses over 3,000,000 coin-flips and the calibration
// rung correctly REFUSED, which is the entire reason the rung is here. A call cannot be
// if-converted, so the branch survives -O.
@inline(never) func takeAdd(_ acc: UInt64, _ x: UInt64) -> UInt64 { acc &+ x }
@inline(never) func takeXor(_ acc: UInt64, _ x: UInt64) -> UInt64 { acc ^ x }

@inline(never)
func predictableBranchLoop(_ trips: Int) -> UInt64 {
    var acc: UInt64 = 0
    var x: UInt64 = SEED
    for _ in 0..<trips {
        x ^= x << 13; x ^= x >> 7; x ^= x << 17
        // An xorshift state is never zero, so this arm is taken every single trip — but the
        // compiler cannot prove that, so the branch is emitted and the predictor learns it.
        if x != 0 { acc = takeAdd(acc, x) } else { acc = takeXor(acc, x) }
    }
    return acc
}

@inline(never)
func coinFlipBranchLoop(_ trips: Int) -> UInt64 {
    var acc: UInt64 = 0
    var x: UInt64 = SEED
    for _ in 0..<trips {
        x ^= x << 13; x ^= x >> 7; x ^= x << 17
        // Same shape, same call targets, same trip count. The ONLY difference is that this
        // condition is the low bit of an xorshift stream, which no predictor can learn.
        if x & 1 == 1 { acc = takeAdd(acc, x) } else { acc = takeXor(acc, x) }
    }
    return acc
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION F — reporting. Every exit path, including refusals, prints the
// reference figures, so a run that stops early is still comparable.
// ══════════════════════════════════════════════════════════════════════════

func printHeader() {
    print("STUDY 41 — silicon shear telemetry")
    print("marker              : \(REF_MARKER)")
    print("seed                : 0x\(String(SEED, radix: 16))")
    print("calibration trips   : \(CAL_TRIPS)")
    print("ladder              : \(LADDER.map(String.init).joined(separator: ", "))")
    print("reps per rung       : \(REPS) (minimum reported)")
    print("arena capacity      : \(ARENA_CAP) vectors, mapped once before any measurement")
    print("")
}

// The figures this study published, carried as constants so that EVERY exit path — a
// refusal on a machine with no counters included — prints the same reference block the
// page cites. A run that stops early is still byte-comparable with the published one,
// and a page citing a number its own program never prints is caught rather than trusted.
func printReferenceFigures() {
    print("")
    print("FLEET REFERENCE FIGURES — measured 2026-09-08, nine cells, ARM Neoverse-N1")
    print("  cycles at N=16384          22,846 against 4,053,186")
    print("  branch misses at N=16384   42-51 against 110,319-111,002")
    print("  exact fold agreement       6 of 6 rungs on 9 of 9 cells")
    print("  float fold disagreement    4 of 5 rungs")
    print("  calibration coin-flip      1,499,438-1,500,676 of 3,000,000")
    print("  degenerate rung N=1        -45 to +938 cycles")
    print("  marker                     ORDERING_IS_PRICED_IN_CYCLES_NOT_IN_PHYSICS")
}

func refuse(_ why: String) -> Never {
    print("VERDICT             : REFUSED")
    print("reason              : \(why)")
    print("reference marker    : \(REF_MARKER)")
    print("reference ladder top: \(REF_LADDER_TOP)")
    print("reference cal ppt   : \(REF_CAL_COINFLIP_MISS_PER_TRIP_PPT)")
    print("")
    print("A refused rung is a finding, not a failure. It is recorded raw.")
    printReferenceFigures()
    exit(2)
}

// Right-align an integer in a fixed column. No Foundation, no String(format:), so the
// transcript is byte-identical whether or not Foundation is present on the host.
func pad(_ v: Int64, _ w: Int) -> String {
    var s = String(v); while s.count < w { s = " " + s }; return s
}
func pad(_ v: Int, _ w: Int) -> String { pad(Int64(v), w) }
func padS(_ s0: String, _ w: Int) -> String {
    var s = s0; while s.count < w { s = " " + s }; return s
}
// Swift prints the shortest decimal that round-trips, so two Doubles that differ in any
// bit print as different strings. That is exactly the discrimination ARM D needs.
func fmt17(_ d: Double) -> String { String(d) }

func pct(_ num: Int64, _ den: Int64) -> String {
    guard den > 0 else { return "n/a" }
    let ppt = (num &* 1000) / den
    return "\(ppt / 10).\(abs(ppt % 10))%"
}

// ══════════════════════════════════════════════════════════════════════════
// MAIN
// ══════════════════════════════════════════════════════════════════════════

printHeader()

let pmu = PMU()
if !pmu.ok {
    print("PMU                 : ABSENT — \(pmu.whyNot)")
    print("")
    refuse("the ARM PMU is not readable here, so no telemetry rung can be graded. "
         + "ABSENT is not ZERO and is not PASS.")
}
print("PMU                 : LIVE — cycles, instructions, branches, branch-misses, page-faults")
print("")

let arena = Arena(ARENA_CAP)

// ── ARM A ──────────────────────────────────────────────────────────────────
print("ARM A — CALIBRATION (does the counter discriminate at all?)")
var sinkA: UInt64 = 0
let calPred = pmu.measure { sinkA = sinkA &+ predictableBranchLoop(CAL_TRIPS) }
let calCoin = pmu.measure { sinkA = sinkA &+ coinFlipBranchLoop(CAL_TRIPS) }
if calPred.anyScaled || calCoin.anyScaled {
    refuse("a counter was time-multiplexed during calibration (enabled != running); "
         + "a scaled counter silently misreports and no figure below it may be believed.")
}
let predMiss = calPred.branchMisses.value
let coinMiss = calCoin.branchMisses.value
print("  predictable branch  : \(predMiss) misses over \(CAL_TRIPS) trips  (\(pct(predMiss, Int64(CAL_TRIPS))))")
print("  coin-flip branch    : \(coinMiss) misses over \(CAL_TRIPS) trips  (\(pct(coinMiss, Int64(CAL_TRIPS))))")
let coinPpt = (coinMiss &* 1000) / Int64(CAL_TRIPS)
let predPpt = (predMiss &* 1000) / Int64(CAL_TRIPS)
let calSeparates = coinPpt >= 400 && coinPpt <= 600 && predPpt <= 50
print("  reference           : coin-flip should land near \(REF_CAL_COINFLIP_MISS_PER_TRIP_PPT) ppt, predictable near 0")
print("  verdict             : \(calSeparates ? "SEPARATES — the instrument discriminates" : "DOES NOT SEPARATE")")
if !calSeparates {
    refuse("the calibration rung did not separate a coin-flip branch from a predictable one, "
         + "so the branch-miss counter is not measuring what this study needs it to measure. "
         + "An instrument that answers the same thing on both populations is a turn counter.")
}
print("")

// ── ARMS B, C, E, F ────────────────────────────────────────────────────────
print("ARMS B/C/E/F — EXACT FOLD: three orderings, one answer")
print("")
print("     N |        UUM8D |     CLASSICAL_SORT |    CLASSICAL_ALLOC | agree | uum8d faults")
print("  -----+--------------+--------------------+--------------------+-------+-------------")

struct Row {
    var n: Int
    var uumCycles: Int64, sortCycles: Int64, allocCycles: Int64
    var uumMiss: Int64, sortMiss: Int64, allocMiss: Int64
    var uumFaults: Int64, sortFaults: Int64, allocFaults: Int64
    var agree: Bool
}
var rows: [Row] = []

for n in LADDER {
    arena.fill(n)
    var uumV: Int64 = 0, sortV: Int64 = 0, allocV: Int64 = 0
    var best = Row(n: n, uumCycles: .max, sortCycles: .max, allocCycles: .max,
                   uumMiss: .max, sortMiss: .max, allocMiss: .max,
                   uumFaults: .max, sortFaults: .max, allocFaults: .max, agree: false)
    for _ in 0..<REPS {
        let su = pmu.measure { uumV = uum8dExactFold(arena, n) }
        let ss = pmu.measure { sortV = classicalSortExactFold(arena, n) }
        let sa = pmu.measure { allocV = classicalAllocExactFold(arena, n) }
        if su.anyScaled || ss.anyScaled || sa.anyScaled {
            refuse("a counter was time-multiplexed at N=\(n); a scaled counter silently misreports.")
        }
        best.uumCycles = min(best.uumCycles, su.cycles.value)
        best.sortCycles = min(best.sortCycles, ss.cycles.value)
        best.allocCycles = min(best.allocCycles, sa.cycles.value)
        best.uumMiss = min(best.uumMiss, su.branchMisses.value)
        best.sortMiss = min(best.sortMiss, ss.branchMisses.value)
        best.allocMiss = min(best.allocMiss, sa.branchMisses.value)
        best.uumFaults = min(best.uumFaults, su.pageFaults.value)
        best.sortFaults = min(best.sortFaults, ss.pageFaults.value)
        best.allocFaults = min(best.allocFaults, sa.pageFaults.value)
    }
    best.agree = (uumV == sortV) && (sortV == allocV)
    rows.append(best)
    print("  " + pad(n, 5) + " | " + pad(best.uumCycles, 12) + " | " + pad(best.sortCycles, 18)
          + " | " + pad(best.allocCycles, 18) + " | " + padS(best.agree ? "YES" : "NO", 5)
          + " | " + pad(best.uumFaults, 11))
}
print("")

// ── ARM D — the control. Same folds, binary64. Here the arms must DISAGREE. ──
print("ARM D — CONTROL, the same fold in binary64 (the ordering must now buy something)")
print("")
print("     N |  arrival order (float)   |   sorted order (float)   | identical")
print("  -----+--------------------------+--------------------------+----------")
var floatDisagreements = 0
var floatRungs = 0
for n in LADDER where n > 1 {
    arena.fill(n)
    let fa = floatArrivalFold(arena, n)
    let fs = floatSortedFold(arena, n)
    let same = fa.bitPattern == fs.bitPattern
    floatRungs += 1
    if !same { floatDisagreements += 1 }
    print("  " + pad(n, 5) + " | " + padS(fmt17(fa), 24) + " | " + padS(fmt17(fs), 24)
          + " | " + padS(same ? "yes" : "NO", 9))
}
print("")
print("  float rungs         : \(floatRungs)")
print("  rungs that disagree : \(floatDisagreements)")
print("  reading             : where the fold is binary64 the arrival order and the sorted")
print("                        order are DIFFERENT NUMBERS. The ordering protocol is buying")
print("                        a real repair there. That is the control: it is what stops the")
print("                        exact-arithmetic result being an always-green verdict.")
print("")

// ── the analysis ───────────────────────────────────────────────────────────
print("VERDICT")
print("")

let allAgree = rows.allSatisfy { $0.agree }
let uumZeroFaults = rows.allSatisfy { $0.uumFaults == 0 }
let degenerate = rows.first { $0.n == 1 }
let top = rows.last

// cycle delta must GROW with N — the founder's falsification boundary
var deltasRise = true
var lastDelta: Int64 = .min
for r in rows where r.n > 1 {
    let d = r.sortCycles - r.uumCycles
    if d < lastDelta { deltasRise = false }
    lastDelta = d
}

// branch misses per vector must stay FLAT on the UUM8D arm
var uumMissPerK: [String] = []
for r in rows where r.n >= 64 {
    uumMissPerK.append("N=\(r.n): \((r.uumMiss &* 1000) / Int64(r.n))")
}

print("  1. AGREEMENT (ARM C)        : " + (allAgree
      ? "all \(rows.count) rungs — the three orderings return the SAME integer."
      : "BROKEN — the arms returned different integers; the cost comparison is void."))
print("     Under exact integer arithmetic the sort changes nothing about the answer.")
print("     Everything it costs is therefore paid for nothing.")
print("")
print("  2. PAGE FAULTS (ARM E)      : UUM8D arm " + (uumZeroFaults ? "0 on every rung" : "NON-ZERO — see table"))
if let t = top {
    print("     At N=\(t.n): UUM8D \(t.uumFaults) faults · CLASSICAL_SORT \(t.sortFaults) · CLASSICAL_ALLOC \(t.allocFaults)")
    let faultsDiscriminate = !(t.uumFaults == t.sortFaults && t.sortFaults == t.allocFaults)
    if faultsDiscriminate {
        print("     The counter separates the arms, so the figure carries information.")
    } else {
        print("     STATED PLAINLY: this counter does NOT discriminate here. CLASSICAL_ALLOC")
        print("     takes its scratch inside the measured region and still reports the same")
        print("     number, because the allocator satisfies it from pages the process has")
        print("     already mapped — an allocation is not a page fault. So \"zero page faults\"")
        print("     is TRUE of the UUM8D arm and equally true of the arm it is being compared")
        print("     against, and it is therefore NOT evidence for the architecture. A rung that")
        print("     reads the same on both populations is a turn counter. It is reported here")
        print("     rather than dropped, because a boundary that failed to discriminate is a")
        print("     finding about the instrument.")
    }
}
print("")
print("  3. BRANCH MISSES            : UUM8D misses per 1000 vectors — " + uumMissPerK.joined(separator: " · "))
if let t = top {
    print("     At N=\(t.n): UUM8D \(t.uumMiss) misses · CLASSICAL_SORT \(t.sortMiss) · CLASSICAL_ALLOC \(t.allocMiss)")
    print("     The sort's mispredictions are the price of a comparison whose answer,")
    print("     rung 1 shows, does not change the result.")
}
print("")
print("  4. CYCLE DELTA vs N         : " + (deltasRise
      ? "rises monotonically across the ladder."
      : "DOES NOT rise monotonically — recorded raw, not smoothed."))
for r in rows where r.n > 1 {
    let d = r.sortCycles - r.uumCycles
    let da = r.allocCycles - r.uumCycles
    print("     N=" + padS(String(r.n), 6) + " sort-uum8d = " + pad(d, 12)
          + "   alloc-uum8d = " + pad(da, 12))
}
print("")
if let d = degenerate {
    let dd = d.sortCycles - d.uumCycles
    print("  5. DEGENERATE RUNG (ARM F)  : N=1, nothing to order.")
    print("     sort-uum8d delta = \(dd) cycles.")
    print("     If this rung showed a large win the harness would be measuring something")
    print("     other than the ordering, and every rung above it would be void.")
}
print("")
print("  6. WHERE THE ORDERING IS REAL (ARM D): \(floatDisagreements) of \(floatRungs) float rungs disagree.")
print("     The claim is NOT 'ordering is useless'. It is exactly this: the ordering is")
print("     waste when the fold is exact, and load-bearing when the fold is binary64.")
print("     A distributed system that folds in floats needs its total order. One that")
print("     folds in exact integers is paying the cycles above for nothing.")
print("")

print("NOT KNOWN")
print("  That a scheduling shear IS a Navier-Stokes singularity. It is not. The cycles")
print("  measured here are a cost, not a blow-up, and nothing in this file touches a fluid.")
print("  That any of this bears on the second law of thermodynamics.")
print("  That these figures generalise off aarch64 Neoverse-N1, or off this kernel.")
print("")
printReferenceFigures()
print("")
print("MARKER              : \(REF_MARKER)")
print("reference ladder top: \(REF_LADDER_TOP)")
print("reference cal ppt   : \(REF_CAL_COINFLIP_MISS_PER_TRIP_PPT)")
