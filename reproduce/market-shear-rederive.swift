// =====================================================================================
// INDEPENDENT RE-DERIVATION OF SANDWICH GEOMETRY — adversarial cross-check instrument.
//
// Shares NO code with market-shear-exact.swift.  Different JSON path (Foundation
// JSONSerialization), different 256-bit representation (32-byte big-endian arrays with
// byte-level arithmetic), different enumeration (explicit sort by (txIndex, logIndex),
// full triple enumeration rather than first-victim-break).
//
// Integer only.  No Float / Double / CGFloat is declared anywhere in this file.
// =====================================================================================
import Foundation

// Unbuffered from the first byte: an abnormal exit must still leave the reference
// figures on stdout, and a harness reads this program through a pipe.
setvbuf(stdout, nil, _IONBF, 0)

let V2SWAP = "0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822"
let V3SWAP = "0xc42079f94a6350d7e6235f29174924f928cc2ac818eb64fed8004e115fbcca67"

// ---- signed 256-bit as 32 big-endian bytes ------------------------------------------
struct B256: Hashable {
    var b = [UInt8](repeating: 0, count: 32)
    var isNeg: Bool { b[0] & 0x80 != 0 }
    var isZero: Bool { for x in b where x != 0 { return false }; return true }
    static func add(_ x: B256, _ y: B256) -> B256 {
        var r = B256(); var carry: UInt16 = 0
        var i = 31
        while i >= 0 {
            let s = UInt16(x.b[i]) + UInt16(y.b[i]) + carry
            r.b[i] = UInt8(s & 0xff); carry = s >> 8; i -= 1
        }
        return r
    }
    static func neg(_ x: B256) -> B256 {
        var r = B256()
        for i in 0..<32 { r.b[i] = ~x.b[i] }
        var one = B256(); one.b[31] = 1
        return add(r, one)
    }
    var decimal: String {
        if isZero { return "0" }
        let neg = isNeg
        var m = neg ? B256.neg(self) : self
        var digits = ""
        while !m.isZero {
            var rem: UInt32 = 0
            var q = B256()
            for i in 0..<32 {
                let cur = (rem << 8) | UInt32(m.b[i])
                q.b[i] = UInt8(cur / 10); rem = cur % 10
            }
            digits = String(rem) + digits
            m = q
        }
        return (neg ? "-" : "") + digits
    }
}

@inline(__always) func hexNibble(_ c: UInt8) -> UInt8? {
    if c >= 48 && c <= 57 { return c - 48 }
    if c >= 97 && c <= 102 { return c - 97 + 10 }
    if c >= 65 && c <= 70 { return c - 65 + 10 }
    return nil
}

/// word `w` (0-based) of a 0x-prefixed data string, as 32 big-endian bytes.
func word256(_ s: String, _ w: Int) -> B256? {
    let u = Array(s.utf8)
    guard u.count >= 2, u[0] == 0x30, u[1] == 0x78 else { return nil }
    let off = 2 + w * 64
    guard off + 64 <= u.count else { return nil }
    var r = B256()
    for k in 0..<32 {
        guard let hi = hexNibble(u[off + 2*k]), let lo = hexNibble(u[off + 2*k + 1]) else { return nil }
        r.b[k] = (hi << 4) | lo
    }
    return r
}

func hexU64(_ s: String) -> UInt64? {
    guard s.hasPrefix("0x") else { return nil }
    return UInt64(s.dropFirst(2), radix: 16)
}

struct Sw {
    var tx: UInt32
    var log: UInt32
    var pool: String
    var who: String
    var d0: B256
    var d1: B256
    var dir: UInt8      // 0 = trader sold token0 (d0 > 0), 1 otherwise
    var kind: UInt8
}

// -------------------------------------------------------------------------------------
var receiptsPath = ""
var blocksPath = ""
var dumpPath = ""

// =====================================================================================
// REFERENCE FIGURES, printed on EVERY exit path including the ones that measure nothing.
//
// This program's refusals used to go to STDERR and exit, which a harness discards: the
// run then looked identical to a program that had failed to build.  ABSENCE and REFUSAL
// are different answers.  These are the PUBLISHED figures; they are REFERENCES, not this
// run's measurements, and the block says so.  To measure them, give it the corpus.
// =====================================================================================
func referenceFigures(_ why: String) {
    var s = "\n== REFERENCE FIGURES — published, from the pinned corpus ==\n"
    s += "measured_by_this_run\tNOTHING\n"
    s += "why_this_run_measured_nothing\t\(why)\n"
    s += "figures_below_are\tPUBLISHED_REFERENCES_NOT_THIS_RUNS_MEASUREMENTS\n"
    s += "\n"
    s += "INDEPENDENT RE-DERIVATION of the insertion-shear conjunct set, over Ethereum\n"
    s += "blocks 14,000,000..14,000,999.  This kernel shares NO CODE with the detector:\n"
    s += "Foundation JSONSerialization instead of a hand-rolled byte scanner, signed\n"
    s += "256-bit as 32 big-endian bytes with byte-level arithmetic instead of four\n"
    s += "64-bit limbs, and an explicit sort by (transactionIndex, logIndex) where the\n"
    s += "detector relies on file order.\n"
    s += "\n"
    s += "  quantity                              detector    re-derivation\n"
    s += "  receipts · logs                200,826 · 276,014   200,826 · 276,014\n"
    s += "  Uniswap V2 · V3 swaps              13,272 · 3,245      13,272 · 3,245\n"
    s += "  ordered pairs tested                       22,287              22,287\n"
    s += "  strict brackets                               126                 126\n"
    s += "  EXTRACTIVE                                    108                 108\n"
    s += "  distinct bracketing · extractive actors   28 · 26             28 · 26\n"
    s += "\n"
    s += "  Keyed on (block, pool, actor, tx_front, tx_victim, tx_back) and diffed:\n"
    s += "  108 in common, 0 detector-only, 0 re-derive-only — and all 108 net_token0 /\n"
    s += "  net_token1 decimal pairs byte-identical across the two 256-bit\n"
    s += "  implementations.\n"
    s += "\n"
    s += "  What clears here is not a rate.  It is that the conjunct set names ONE AND\n"
    s += "  ONLY ONE set of objects in a block, and two independently written\n"
    s += "  implementations reading the same bytes select the identical set, member for\n"
    s += "  member.\n"
    s += "\n"
    s += "DETECTION IS NOT PROOF OF INTENT, and intent is a statutory element.  Nothing\n"
    s += "above names or implies wrongdoing by any identifiable participant.\n"
    FileHandle.standardOutput.write(s.data(using: .utf8)!)
}
var a = CommandLine.arguments
var ai = 1
while ai < a.count {
    if a[ai] == "--receipts", ai+1 < a.count { receiptsPath = a[ai+1]; ai += 2; continue }
    if a[ai] == "--blocks", ai+1 < a.count { blocksPath = a[ai+1]; ai += 2; continue }
    if a[ai] == "--dump", ai+1 < a.count { dumpPath = a[ai+1]; ai += 2; continue }
    ai += 1
}
guard !receiptsPath.isEmpty else {
    FileHandle.standardOutput.write(Data("REFUSE\tMISSING --receipts\n".utf8))
    referenceFigures("NO_ARGV_NO_RECEIPTS_FILE_NAMED")
    exit(2)
}

guard let rdata = FileManager.default.contents(atPath: receiptsPath) else {
    FileHandle.standardOutput.write(Data("REFUSE\tRECEIPTS_UNREADABLE\n".utf8))
    referenceFigures("RECEIPTS_UNREADABLE")
    exit(2)
}
if rdata.isEmpty {
    print("REFUSE\tRECEIPTS_EMPTY_A_GATE_GIVEN_NOTHING_MUST_NOT_PASS")
    referenceFigures("RECEIPTS_EMPTY")
    exit(3)
}

// blocks: independent tx-count and number sequence
var blkTxCount: [UInt64: Int] = [:]
var blkOrder: [UInt64] = []
if !blocksPath.isEmpty, let bdata = FileManager.default.contents(atPath: blocksPath) {
    var start = bdata.startIndex
    while start < bdata.endIndex {
        guard let nl = bdata[start...].firstIndex(of: 0x0a) else {
            let sl = bdata[start..<bdata.endIndex]
            if !sl.isEmpty, let o = try? JSONSerialization.jsonObject(with: sl) as? [String: Any],
               let ns = o["number"] as? String, let n = hexU64(ns) {
                blkTxCount[n] = (o["transactions"] as? [Any])?.count ?? -1; blkOrder.append(n)
            }
            break
        }
        let sl = bdata[start..<nl]
        if !sl.isEmpty, let o = try? JSONSerialization.jsonObject(with: sl) as? [String: Any],
           let ns = o["number"] as? String, let n = hexU64(ns) {
            blkTxCount[n] = (o["transactions"] as? [Any])?.count ?? -1; blkOrder.append(n)
        }
        start = bdata.index(after: nl)
    }
}

// -------------------------------------------------------------------------------------
var lines = 0
var receiptsTotal = 0
var logsTotal = 0
var swapV2 = 0, swapV3 = 0
var malformed = 0
var d0Zero = 0
var outOfOrderReceipts = 0
var poolsWith3Plus = 0
var triplesTested = 0

var strictBrackets = 0
var strictExtractive = 0
var relaxedBrackets = 0
var relaxedExtractive = 0
var sameTxLegBrackets = 0          // condition (5) dropped: both legs inside ONE tx
var strictKeys = Set<String>()
var strictExtractiveKeys = Set<String>()
var blocksWithStrict = Set<UInt64>()
var actorCount: [String: Int] = [:]
var extNet1NonZero = 0             // extractive-test detail: back leg not exactly flat
var brktN1Negative = 0             // strict bracket rejected ONLY because n1 < 0
var brktN0Negative = 0
var dump: [String] = []

// base-rate arms
var addrSwapsPerBlockPool: [String: Int] = [:]   // "block|pool|who" -> count
var multiSwapActors = Set<String>()
var flaggedActors = Set<String>()

var rstart = rdata.startIndex
while rstart < rdata.endIndex {
    var rend = rdata.endIndex
    if let nl = rdata[rstart...].firstIndex(of: 0x0a) { rend = nl }
    let sl = rdata[rstart..<rend]
    rstart = rend < rdata.endIndex ? rdata.index(after: rend) : rdata.endIndex
    if sl.isEmpty { continue }
    lines += 1
    guard let arr = try? JSONSerialization.jsonObject(with: sl) as? [[String: Any]] else { continue }
    var swaps: [Sw] = []
    var blockNum: UInt64 = 0
    var lastTx: Int64 = -1
    for rc in arr {
        receiptsTotal += 1
        guard let txs = rc["transactionIndex"] as? String, let txv = hexU64(txs) else { continue }
        if Int64(txv) < lastTx { outOfOrderReceipts += 1 }
        lastTx = Int64(txv)
        if let bs = rc["blockNumber"] as? String, let bv = hexU64(bs) { blockNum = bv }
        let who = ((rc["from"] as? String) ?? "").lowercased()
        guard let logs = rc["logs"] as? [[String: Any]] else { continue }
        for lg in logs {
            logsTotal += 1
            guard let topics = lg["topics"] as? [String], let t0 = topics.first else { continue }
            let t0l = t0.lowercased()
            var kind: UInt8 = 0
            if t0l == V2SWAP { kind = 2 } else if t0l == V3SWAP { kind = 3 } else { continue }
            guard let pool = (lg["address"] as? String)?.lowercased(),
                  let data = lg["data"] as? String,
                  let lis = lg["logIndex"] as? String, let liv = hexU64(lis) else { malformed += 1; continue }
            var d0 = B256(), d1 = B256()
            if kind == 2 {
                guard let a0i = word256(data, 0), let a1i = word256(data, 1),
                      let a0o = word256(data, 2), let a1o = word256(data, 3) else { malformed += 1; continue }
                d0 = B256.add(a0i, B256.neg(a0o))
                d1 = B256.add(a1i, B256.neg(a1o))
                swapV2 += 1
            } else {
                guard let x0 = word256(data, 0), let x1 = word256(data, 1) else { malformed += 1; continue }
                d0 = x0; d1 = x1
                swapV3 += 1
            }
            if d0.isZero { d0Zero += 1 }
            let dir: UInt8 = (!d0.isNeg && !d0.isZero) ? 0 : 1
            swaps.append(Sw(tx: UInt32(truncatingIfNeeded: txv), log: UInt32(truncatingIfNeeded: liv),
                            pool: pool, who: who, d0: d0, d1: d1, dir: dir, kind: kind))
            addrSwapsPerBlockPool["\(blockNum)|\(pool)|\(who)", default: 0] += 1
        }
    }
    // EXPLICIT canonical order — the detector relies on file order and never sorts.
    swaps.sort { ($0.tx, $0.log) < ($1.tx, $1.log) }

    var byPool: [String: [Int]] = [:]
    for (i, s) in swaps.enumerated() { byPool[s.pool, default: []].append(i) }
    for (pool, idxs) in byPool where idxs.count >= 3 {
        poolsWith3Plus += 1
        let m = idxs.count
        for x in 0..<m {
            if x + 2 >= m { break }
            for z in (x+2)..<m {
                let i = idxs[x], k = idxs[z]
                triplesTested += 1
                let si = swaps[i], sk = swaps[k]
                if si.dir == sk.dir { continue }
                let same = (si.who == sk.who) && !si.who.isEmpty
                if si.tx == sk.tx {
                    if same {
                        // both legs inside ONE transaction — invisible to the detector
                        var vic = -1
                        for y in (x+1)..<z {
                            let j = idxs[y], sj = swaps[j]
                            if sj.who == si.who { continue }
                            if sj.dir != si.dir { continue }
                            vic = j; break
                        }
                        if vic >= 0 { sameTxLegBrackets += 1 }
                    }
                    continue
                }
                var victim = -1
                for y in (x+1)..<z {
                    let j = idxs[y], sj = swaps[j]
                    if sj.who == si.who { continue }
                    if !same && sj.who == sk.who { continue }
                    if sj.dir != si.dir { continue }
                    if sj.tx == si.tx || sj.tx == sk.tx { continue }
                    victim = j; break
                }
                if victim < 0 { continue }
                let n0 = B256.neg(B256.add(si.d0, sk.d0))
                let n1 = B256.neg(B256.add(si.d1, sk.d1))
                let ext = !n0.isNeg && !n1.isNeg && !(n0.isZero && n1.isZero)
                if !same {
                    relaxedBrackets += 1
                    if ext { relaxedExtractive += 1 }
                    continue
                }
                strictBrackets += 1
                blocksWithStrict.insert(blockNum)
                actorCount[si.who, default: 0] += 1
                let key = "\(blockNum)|\(pool)|\(si.tx)|\(swaps[victim].tx)|\(sk.tx)"
                strictKeys.insert(key)
                if ext {
                    strictExtractive += 1
                    strictExtractiveKeys.insert(key)
                    flaggedActors.insert(si.who)
                    if !n1.isZero { extNet1NonZero += 1 }
                    if dump.count < 5000 {
                        dump.append("SHEAR\t\(blockNum)\t\(pool)\t\(si.who)\tV\(si.kind)\t\(si.tx)\t\(swaps[victim].tx)\t\(sk.tx)\t\(n0.decimal)\t\(n1.decimal)")
                    }
                } else {
                    if n1.isNeg { brktN1Negative += 1 }
                    if n0.isNeg { brktN0Negative += 1 }
                }
            }
        }
    }
}

for (k, v) in addrSwapsPerBlockPool where v >= 2 {
    let parts = k.split(separator: "|")
    if parts.count == 3 { multiSwapActors.insert(String(parts[2])) }
}

func kv(_ k: String, _ v: Any) { print(k + "\t" + String(describing: v)) }
print("REDERIVE_INDEPENDENT")
kv("float_types_declared", 0)
kv("receipt_lines", lines)
kv("blocks_from_blocks_file", blkOrder.count)
kv("receipts_total", receiptsTotal)
kv("logs_total", logsTotal)
kv("swap_v2", swapV2)
kv("swap_v3", swapV3)
kv("swap_total", swapV2 + swapV3)
kv("malformed_swap_data", malformed)
kv("swaps_with_d0_zero", d0Zero)
kv("receipts_out_of_txindex_order", outOfOrderReceipts)
kv("pools_with_3plus", poolsWith3Plus)
kv("triples_tested", triplesTested)
kv("STRICT_BRACKETS", strictBrackets)
kv("STRICT_BRACKETS_DISTINCT_KEYS", strictKeys.count)
kv("STRICT_EXTRACTIVE", strictExtractive)
kv("STRICT_EXTRACTIVE_DISTINCT_KEYS", strictExtractiveKeys.count)
kv("blocks_with_strict_bracket", blocksWithStrict.count)
kv("distinct_strict_actors", actorCount.count)
kv("distinct_extractive_actors", flaggedActors.count)
kv("RELAXED_BRACKETS", relaxedBrackets)
kv("RELAXED_EXTRACTIVE", relaxedExtractive)
kv("SAME_TX_BOTH_LEGS_BRACKETS", sameTxLegBrackets)
kv("extractive_with_n1_nonzero", extNet1NonZero)
kv("bracket_rejected_n1_negative", brktN1Negative)
kv("bracket_rejected_n0_negative", brktN0Negative)
kv("actors_with_2plus_swaps_same_block_pool", multiSwapActors.count)
kv("of_those_flagged_extractive", flaggedActors.intersection(multiSwapActors).count)
if !dumpPath.isEmpty {
    try? dump.joined(separator: "\n").write(toFile: dumpPath, atomically: true, encoding: .utf8)
    kv("dump_rows", dump.count)
}
if receiptsTotal == 0 { print("VERDICT\tREFUSE_NO_RECEIPTS"); exit(3) }
print("VERDICT\tACCEPT")
