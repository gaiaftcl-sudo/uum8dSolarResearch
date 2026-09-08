// feed-order-identity.swift — DOES THIS FEED CARRY ORDER IDENTITY?
//
// The published cancellation predicate keys every order by an order reference: an
// identifier minted when an individual order is OPENED and quoted back when that same
// individual order is TERMINATED. Without such a field the predicate has no key and
// cannot run. "Cannot run" is ABSENT WITH A STRUCTURAL REASON. It is not zero, and a
// rate computed from a different denominator is not an answer to the same question.
//
// THIS PROGRAM DECIDES THAT QUESTION FROM THE BYTES, NOT FROM A SPEC AND NOT FROM AN
// OPINION. It never re-implements the predicate — a law written twice is a law that
// drifts. It answers only the prior question: is the KEY the predicate needs present.
//
// THE DETECTOR, stated before it is run, and it is a CONJUNCTION of two independent
// halves so that neither half alone can carry a verdict:
//
//   R1  CARDINALITY.  At some byte offset o, an 8-byte window read from the opening
//       message type takes a distinct value on nearly every message. An order
//       reference does. A symbol, a side flag, a size and a price do not.
//
//   R2  JOINABILITY.  The value at that SAME offset o reappears in the terminating
//       message types. An order reference does. A timestamp does not — it is equally
//       high-cardinality and joins nothing, which is exactly why R1 alone is not a
//       detector.
//
// ORDER IDENTITY is declared present only where R1 AND R2 both hold at one offset.
//
// BOTH ARMS ARE RUN AND BOTH MUST FIRE, IN OPPOSITE DIRECTIONS:
//   itch50 — Nasdaq ITCH 5.0.  Order identity MUST be found, at the offset the
//            published kernel reads.  A run that finds none here has a broken
//            instrument, not a feed without identity, and it says REFUSE.
//   deep   — IEX DEEP 1.0.  Whatever it finds, it reports.
// An instrument that cannot say NO on one input and YES on another is not an
// instrument. Always-green and always-red are the same defect.
//
// INTERNAL CONTROLS, inside each arm, so that a null result cannot be a dead detector:
//   the timestamp offset must show HIGH cardinality and LOW join   (R1 only)
//   the symbol    offset must show LOW  cardinality and HIGH join  (R2 only)
// Both are measured and printed on every run. If either control fails, the run REFUSES:
// a detector that cannot see the two halves separately cannot be trusted on the
// conjunction. Neither control is a literal true; both are read off the same bytes as
// the verdict.
//
// ZERO FLOAT. Every rate is an integer count of parts per 1,000, floored, never rounded
// and never divided into a fraction. Prices and sizes are read as raw integers and are
// never divided — ITCH and DEEP prices carry an implied divisor and dividing by it is
// how exactness is lost.
//
// EVERY EXIT PATH PRINTS THE REFERENCE FIGURES. Run with no argv and stdin closed it
// prints what it measured when it was published, and exits 4 for ABSENT — never 0.

import Foundation

// ————————————————————————————————————————————————————————————————
// reference figures — printed on EVERY path, including refusal and absence
// ————————————————————————————————————————————————————————————————
let REF: [(String, String)] = [
    ("reference_feed_a", "20190730.PSX_ITCH_50.gz  Nasdaq PSX  ITCH 5.0"),
    ("reference_feed_b", "20190730_IEXTP1_DEEP1.0.pcap.gz  IEX  DEEP 1.0"),
    ("reference_itch50_open_type", "A=0x41 add order, F=0x46 add order with MPID"),
    ("reference_itch50_term_types", "D=0x44 E=0x45 C=0x43 X=0x58 U=0x55"),
    ("reference_itch50_identity_offset", "11"),
    ("reference_itch50_identity_width_bytes", "8"),
    ("reference_itch50_verdict", "ORDER_IDENTITY_PRESENT"),
    ("reference_deep_open_candidate", "0x38 price level update buy, 30 bytes"),
    ("reference_deep_term_candidates", "0x35 price level update sell, 0x54 trade report"),
    ("reference_deep_verdict", "ORDER_IDENTITY_ABSENT"),
    ("reference_deep_plu_body_bytes", "30"),
    ("reference_deep_plu_bytes_claimed_by_named_fields", "30"),
    ("reference_deep_plu_residual_bytes", "0"),
    ("reference_predicate_status_on_deep", "CANNOT_RUN_NO_KEY"),
    ("reference_absent_is_not_zero", "a rate needs a denominator of orders; DEEP has no orders"),
    // ---- what the predicate itself returned once this program said it could run ----
    // These are printed on every path, including this one, because a reader who runs this
    // program with no feed still needs to see the figures it was published beside. A
    // refusal that prints nothing is indistinguishable from a program nobody ran.
    ("reference_psx_orders_terminated", "16165067"),
    ("reference_psx_phantom_orders", "15952637"),
    ("reference_psx_phantom_permille_of_terminated", "986"),
    ("reference_psx_phantom_permille_of_displayed_shares", "992"),
    ("reference_bx_orders_terminated", "12676036"),
    ("reference_bx_phantom_orders", "12156283"),
    ("reference_bx_phantom_permille_of_terminated", "958"),
    ("reference_psx_composite_flag_ladder", "169275"),
    ("reference_psx_composite_control_ladder", "57401"),
    ("reference_psx_composite_flag_over_control_permille", "2948"),
    ("reference_bx_composite_flag_ladder", "88900"),
    ("reference_bx_composite_flag_over_control_permille", "1407"),
    ("reference_deep_price_level_updates", "30629120"),
    ("reference_deep_updates_setting_size_to_zero", "13081242"),
    ("reference_deep_candidate_fields_swept", "46"),
    ("reference_deep_second_sweep_trade_report_fields", "62"),
    ("reference_deep_trade_report_carries_order_identity", "NO"),
    ("reference_deep_candidate_fields_passing_both_halves", "0"),
    ("reference_bx_message_types", "15"),
    ("reference_psx_message_types", "14"),
    ("reference_type_N_retail_price_improvement_on_bx", "4636704"),
    ("reference_type_N_on_psx", "0"),
]
func printReference() {
    print("== REFERENCE FIGURES ==")
    for (k, v) in REF { print("\(k)\t\(v)") }
}

// ————————————————————————————————————————————————————————————————
// open-addressed UInt64 set. Fixed capacity, allocated once, never grown.
// Value 0 is the empty sentinel; 0 is tracked in a flag so it is never lost.
// ————————————————————————————————————————————————————————————————
final class U64Set {
    let mask: Int
    let slots: UnsafeMutablePointer<UInt64>
    var count = 0
    var hasZero = false
    var full = false
    init(bits: Int) {
        let cap = 1 << bits
        mask = cap - 1
        slots = UnsafeMutablePointer<UInt64>.allocate(capacity: cap)
        slots.initialize(repeating: 0, count: cap)
    }
    deinit { slots.deallocate() }
    @inline(__always) func mix(_ x: UInt64) -> Int {
        var h = x &* 0x9E3779B97F4A7C15
        h ^= h >> 29; h = h &* 0xBF58476D1CE4E5B9; h ^= h >> 32
        // truncatingIfNeeded, never Int(h): the mixer output routinely exceeds Int.max
        // and a checked narrowing conversion traps there rather than hashing.
        return Int(truncatingIfNeeded: h) & mask
    }
    @inline(__always) func insert(_ v: UInt64) {
        if v == 0 { if !hasZero { hasZero = true; count += 1 }; return }
        // load factor is held under 1/2 by construction; the table refuses rather
        // than probing forever, and the refusal is reported, never swallowed.
        if count > (mask >> 1) { full = true; return }
        var i = mix(v)
        while true {
            let s = slots[i]
            if s == v { return }
            if s == 0 { slots[i] = v; count += 1; return }
            i = (i + 1) & mask
        }
    }
    @inline(__always) func contains(_ v: UInt64) -> Bool {
        if v == 0 { return hasZero }
        var i = mix(v)
        var probes = 0
        while true {
            let s = slots[i]
            if s == v { return true }
            if s == 0 { return false }
            i = (i + 1) & mask
            probes += 1
            if probes > mask { return false }
        }
    }
}

// parts per thousand, FLOORED. Integer only. Never a fraction.
@inline(__always) func permille(_ num: UInt64, _ den: UInt64) -> UInt64 {
    den == 0 ? 0 : (num &* 1000) / den
}

// ————————————————————————————————————————————————————————————————
// streaming stdin reader
// ————————————————————————————————————————————————————————————————
final class Reader {
    var buf = [UInt8](); var pos = 0; var eof = false
    let CHUNK = 1 << 20
    func fill(_ need: Int) {
        while !eof && buf.count - pos < need {
            var tmp = [UInt8](repeating: 0, count: CHUNK)
            let n = tmp.withUnsafeMutableBytes { p -> Int in
                var got = 0
                while got < CHUNK {
                    let k = read(0, p.baseAddress!.advanced(by: got), CHUNK - got)
                    if k <= 0 { break }
                    got += k
                }
                return got
            }
            if n <= 0 { eof = true; break }
            if pos > 0 && pos == buf.count { buf.removeAll(keepingCapacity: true); pos = 0 }
            else if pos > (1 << 21) { buf.removeFirst(pos); pos = 0 }
            buf.append(contentsOf: tmp[0..<n])
        }
    }
    func avail(_ need: Int) -> Bool { fill(need); return buf.count - pos >= need }
    func take(_ n: Int) -> ArraySlice<UInt8>? {
        if !avail(n) { return nil }
        let s = buf[pos..<(pos+n)]; pos += n; return s
    }
}

@inline(__always) func le16s(_ b: ArraySlice<UInt8>, _ i: Int) -> UInt16 {
    let s = b.startIndex + i; return UInt16(b[s]) | (UInt16(b[s+1]) << 8) }
@inline(__always) func le32s(_ b: ArraySlice<UInt8>, _ i: Int) -> UInt32 {
    let s = b.startIndex + i
    return UInt32(b[s]) | (UInt32(b[s+1]) << 8) | (UInt32(b[s+2]) << 16) | (UInt32(b[s+3]) << 24) }
@inline(__always) func le64s(_ b: ArraySlice<UInt8>, _ i: Int) -> UInt64 {
    let s = b.startIndex + i
    var v: UInt64 = 0; for k in (0..<8).reversed() { v = (v << 8) | UInt64(b[s+k]) }; return v }
@inline(__always) func be16s(_ b: ArraySlice<UInt8>, _ i: Int) -> UInt16 {
    let s = b.startIndex + i; return (UInt16(b[s]) << 8) | UInt16(b[s+1]) }

// ————————————————————————————————————————————————————————————————
// the offset sweep. One 8-byte window per candidate offset, read BOTH ways round,
// because a feed's endianness is a property of the feed and not of our expectation:
// ITCH is big-endian on the wire, DEEP is little-endian, and an instrument that
// assumed one would report ABSENT on the other for the wrong reason.
// ————————————————————————————————————————————————————————————————
final class Sweep {
    let bodyLen: Int
    let nOff: Int
    var sets: [U64Set] = []
    var openSeen: UInt64 = 0
    var openCollected: UInt64 = 0
    var shiftedOpens: UInt64 = 0
    var termSeen: UInt64 = 0
    var hits: [UInt64]
    let limit: UInt64

    init(bodyLen: Int, bits: Int, limit: UInt64) {
        self.bodyLen = bodyLen
        // an 8-byte window starting at o needs o+8 <= bodyLen
        self.nOff = max(0, bodyLen - 8 + 1)
        self.limit = limit
        self.hits = [UInt64](repeating: 0, count: max(1, nOff) * 2)
        for _ in 0..<(max(1, nOff) * 2) { sets.append(U64Set(bits: bits)) }
    }
    // idx layout: offset o big-endian -> 2*o, little-endian -> 2*o+1
    @inline(__always) func observeOpen(_ b: UnsafePointer<UInt8>) {
        openSeen &+= 1
        if openCollected >= limit { return }
        openCollected &+= 1
        for o in 0..<nOff {
            var be: UInt64 = 0, le: UInt64 = 0
            for k in 0..<8 { be = (be << 8) | UInt64(b[o+k]); le |= UInt64(b[o+k]) << (8 * UInt64(k)) }
            sets[2*o].insert(be); sets[2*o+1].insert(le)
        }
    }
    // An opening message whose identifier is minted at a shifted base. `avail` is how
    // many bytes remain from that base, so no window is ever read past the message.
    @inline(__always) func observeOpenShifted(_ b: UnsafePointer<UInt8>, _ avail: Int) {
        openSeen &+= 1
        if openCollected >= limit { return }
        openCollected &+= 1
        shiftedOpens &+= 1
        for o in 0..<nOff {
            if o + 8 > avail { break }
            var be: UInt64 = 0, le: UInt64 = 0
            for k in 0..<8 { be = (be << 8) | UInt64(b[o+k]); le |= UInt64(b[o+k]) << (8 * UInt64(k)) }
            sets[2*o].insert(be); sets[2*o+1].insert(le)
        }
    }
    @inline(__always) func observeTerm(_ b: UnsafePointer<UInt8>, _ len: Int) {
        // TEST ONLY INSIDE THE COLLECTION WINDOW. A terminator arriving after the
        // opening set has stopped growing may reference an order that was never
        // offered to the set, and would be scored a miss for a reason that has
        // nothing to do with whether the feed carries identity. Gating both sides
        // to the same window is what makes the join rate mean what it says.
        if openCollected >= limit && limit > 0 { return }
        termSeen &+= 1
        for o in 0..<nOff {
            if o + 8 > len { break }
            var be: UInt64 = 0, le: UInt64 = 0
            for k in 0..<8 { be = (be << 8) | UInt64(b[o+k]); le |= UInt64(b[o+k]) << (8 * UInt64(k)) }
            if sets[2*o].contains(be) { hits[2*o] &+= 1 }
            if sets[2*o+1].contains(le) { hits[2*o+1] &+= 1 }
        }
    }
    func report(_ tag: String) -> (bestOff: Int, bestEndian: String, bestCard: UInt64, bestJoin: UInt64) {
        print("== \(tag) — OFFSET SWEEP, 8-byte window, both endiannesses ==")
        print("open_messages_seen\t\(openSeen)")
        print("open_messages_collected\t\(openCollected)")
        print("open_messages_from_a_shifted_base\t\(shiftedOpens)")
        print("term_messages_tested\t\(termSeen)")
        print("offset\tendian\tdistinct\tcardinality_permille\tjoin_hits\tjoin_permille\tR1\tR2")
        var bo = -1, bc: UInt64 = 0, bj: UInt64 = 0
        var bend = "-"
        for o in 0..<nOff {
            for (e, name) in [(0, "BE"), (1, "LE")] {
                let s = sets[2*o + e]
                let card = permille(UInt64(s.count), openCollected)
                let join = permille(hits[2*o + e], termSeen)
                let r1 = card >= 900, r2 = join >= 900
                print("\(o)\t\(name)\t\(s.count)\t\(card)\t\(hits[2*o+e])\t\(join)\t\(r1 ? "PASS" : "fail")\t\(r2 ? "PASS" : "fail")")
                if r1 && r2 && card &+ join > bc &+ bj { bo = o; bc = card; bj = join; bend = name }
            }
        }
        if sets.contains(where: { $0.full }) { print("TABLE_SATURATED\tYES_FIGURES_ARE_LOWER_BOUNDS") }
        else { print("TABLE_SATURATED\tNO") }
        return (bo, bend, bc, bj)
    }
    // the two internal controls, read off the same bytes as the verdict
    func control(_ off: Int, _ endian: Int) -> (card: UInt64, join: UInt64) {
        guard off >= 0 && off < nOff else { return (0, 0) }
        let s = sets[2*off + endian]
        return (permille(UInt64(s.count), openCollected), permille(hits[2*off + endian], termSeen))
    }
}

// ————————————————————————————————————————————————————————————————
// arm 1 — ITCH 5.0 over a raw (already-inflated) stream on stdin
// ————————————————————————————————————————————————————————————————
func armITCH(limit: UInt64) -> Int32 {
    let expectedLen: [Int] = {
        var e = [Int](repeating: -1, count: 256)
        for (k, v): (UInt8, Int) in [(0x53,12),(0x52,39),(0x48,25),(0x59,20),(0x4C,26),(0x56,35),
            (0x57,12),(0x4B,28),(0x4A,35),(0x68,21),(0x41,36),(0x46,40),(0x45,31),(0x43,36),
            (0x58,23),(0x44,19),(0x55,35),(0x50,44),(0x51,40),(0x42,19),(0x49,50),(0x4E,20),(0x4F,48)] {
            e[Int(k)] = v }
        return e
    }()
    // Add Order body is 36 bytes; the sweep runs over the body from byte 0 of the message.
    let sw = Sweep(bodyLen: 36, bits: 23, limit: limit)
    var msgs: UInt64 = 0, unknown: UInt64 = 0, lenMismatch: UInt64 = 0
    var typeCount = [UInt8: UInt64]()
    // R2-ONLY CONTROL, computed directly rather than through the 8-byte sweep because
    // the field is 2 bytes wide: the stock locate at offset 1. It is LOW cardinality —
    // one value per listed security, a few thousand against millions of adds — and it
    // JOINS almost perfectly, because every terminating message carries the locate of
    // the security it belongs to. It is the mirror of the offset-3 control below, and
    // between them the two halves of the conjunction are shown to be separable in both
    // directions on this feed. Neither is a literal; both are read off these bytes.
    var locSet = U64Set(bits: 18)
    var locOpen: UInt64 = 0, locTermSeen: UInt64 = 0, locTermHit: UInt64 = 0
    let r = Reader()
    var done = false
    while !done {
        // frame: 2-byte big-endian length, then body
        guard let lh = r.take(2) else { break }
        let n = Int(be16s(lh, 0))
        if n == 0 { continue }
        guard let body = r.take(n) else { done = true; break }
        msgs &+= 1
        let t = body[body.startIndex]
        typeCount[t, default: 0] &+= 1
        let e = expectedLen[Int(t)]
        if e < 0 { unknown &+= 1 } else if e != n { lenMismatch &+= 1 }
        body.withUnsafeBufferPointer { raw in
            guard let base = raw.baseAddress else { return }
            if (t == 0x41 || t == 0x46) && n >= 36 {
                sw.observeOpen(base)
                if n >= 3 { locSet.insert(UInt64(base[1]) << 8 | UInt64(base[2])); locOpen &+= 1 }
            } else if (t == 0x44 || t == 0x45 || t == 0x43 || t == 0x58 || t == 0x55) {
                sw.observeTerm(base, n)
                // ORDER REPLACE (U) IS BOTH. It terminates one order and OPENS another,
                // minting a second identifier eight bytes after the first. Offering only
                // its terminating half to the opening set leaves every order that a
                // replace created outside the set, and a later delete of one of those
                // scores a miss for a reason that has nothing to do with whether the feed
                // carries identity. MEASURED, before this line existed: offset 11 joined
                // at 815 per 1,000 on PSX, against 149 per 1,000 of all opens being
                // replaces — the shortfall was the replace population, almost exactly.
                // This is completing the enumeration of messages that open an order. It
                // is not a threshold moved to reach a verdict: the threshold is unchanged,
                // the DEEP arm has no replace message and is untouched by this line, so
                // it cannot manufacture the absent result there.
                if t == 0x55 && n >= 35 { sw.observeOpenShifted(base + 8, n - 8) }
                if n >= 3 {
                    locTermSeen &+= 1
                    if locSet.contains(UInt64(base[1]) << 8 | UInt64(base[2])) { locTermHit &+= 1 }
                }
            }
        }
    }
    print("== ITCH 5.0 — FRAMING ==")
    print("messages_total\t\(msgs)")
    print("unknown_type\t\(unknown)")
    print("len_mismatch\t\(lenMismatch)")
    for (k, v) in typeCount.sorted(by: { $0.value > $1.value }) {
        print("T\t\(String(UnicodeScalar(k)))\t0x\(String(format: "%02x", k))\t\(v)")
    }
    let best = sw.report("ITCH 5.0")
    // internal controls: timestamp lives at offset 5 (6 bytes) so the 8-byte window at
    // offset 3 straddles locate+timestamp — high cardinality, and it joins nothing
    // because two messages never share a nanosecond stamp. Stock locate lives at
    // offset 1 (2 bytes) — low cardinality, high join.
    let cHi = sw.control(3, 0)      // BE window over tracking+timestamp
    let locCard = permille(UInt64(locSet.count), locOpen)
    let locJoin = permille(locTermHit, locTermSeen)
    print("== ITCH 5.0 — INTERNAL CONTROLS ==")
    print("control_R1_only_timestamp_window_offset\t3")
    print("control_R1_only_cardinality_permille\t\(cHi.card)")
    print("control_R1_only_join_permille\t\(cHi.join)")
    print("control_R1_only_FIRED\t\(cHi.card >= 900 && cHi.join < 900 ? "YES" : "NO")")
    print("control_R2_only_stock_locate_offset\t1")
    print("control_R2_only_width_bytes\t2")
    print("control_R2_only_distinct_locates\t\(locSet.count)")
    print("control_R2_only_cardinality_permille\t\(locCard)")
    print("control_R2_only_join_permille\t\(locJoin)")
    print("control_R2_only_FIRED\t\(locCard < 900 && locJoin >= 900 ? "YES" : "NO")")
    let itchControls = (cHi.card >= 900 && cHi.join < 900) && (locCard < 900 && locJoin >= 900)
    print("both_controls_fired\t\(itchControls ? "YES" : "NO")")
    print("== ITCH 5.0 — VERDICT ==")
    print("identity_offset\t\(best.bestOff)")
    print("identity_endian\t\(best.bestEndian)")
    print("identity_cardinality_permille\t\(best.bestCard)")
    print("identity_join_permille\t\(best.bestJoin)")
    if best.bestOff < 0 {
        print("VERDICT\tREFUSE_INSTRUMENT_FOUND_NO_IDENTITY_ON_A_FEED_THAT_HAS_ONE")
        printReference(); return 3
    }
    if !itchControls {
        print("VERDICT\tREFUSE_CONTROLS_DID_NOT_FIRE_DETECTOR_UNPROVEN")
        printReference(); return 3
    }
    print("VERDICT\tORDER_IDENTITY_PRESENT")
    print("predicate_status\tCAN_RUN")
    printReference()
    return 0
}

// ————————————————————————————————————————————————————————————————
// arm 2 — IEX DEEP 1.0 over pcap / pcapng on stdin
// ————————————————————————————————————————————————————————————————
func armDEEP(limit: UInt64) -> Int32 {
    let r = Reader()
    guard let magic4 = r.take(4) else { print("PCAP_EMPTY"); printReference(); return 4 }
    let m0 = le32s(magic4, 0)
    var swapped = false, isNg = false
    var linkType: UInt32 = 1
    switch m0 {
    case 0xa1b2c3d4: swapped = false
    case 0xd4c3b2a1: swapped = true
    case 0xa1b23c4d: swapped = false
    case 0x4d3cb2a1: swapped = true
    case 0x0a0d0d0a: isNg = true
    default: print("PCAP_BAD_MAGIC\t\(String(format: "%08x", m0))"); printReference(); return 3
    }
    func u32(_ b: ArraySlice<UInt8>, _ i: Int) -> UInt32 { swapped ? UInt32(bigEndian: le32s(b, i)) : le32s(b, i) }
    if !isNg { guard let rest = r.take(20) else { print("PCAP_SHORT"); printReference(); return 4 }
               linkType = u32(rest, 16) }
    var ngBlocks = 0

    func nextPacket() -> ArraySlice<UInt8>? {
        if !isNg {
            guard let ph = r.take(16) else { return nil }
            let inclLen = Int(u32(ph, 8))
            if inclLen < 0 || inclLen > 1_048_576 { return nil }
            return r.take(inclLen)
        }
        while true {
            var btype: UInt32
            if ngBlocks == 0 { btype = 0x0a0d0d0a }
            else { guard let bt = r.take(4) else { return nil }; btype = le32s(bt, 0) }
            guard let bl = r.take(4) else { return nil }
            let blen = Int(le32s(bl, 0))
            if blen < 12 || blen > 16_777_216 { return nil }
            guard let body = r.take(blen - 12) else { return nil }
            guard r.take(4) != nil else { return nil }
            ngBlocks += 1
            switch btype {
            case 0x0a0d0d0a: break
            case 0x00000001: if body.count >= 2 { linkType = UInt32(le16s(body, 0)) }
            case 0x00000006:
                if body.count < 20 { continue }
                let capLen = Int(le32s(body, 12))
                if capLen < 0 || 20 + capLen > body.count { continue }
                return body[(body.startIndex+20)..<(body.startIndex+20+capLen)]
            case 0x00000003:
                if body.count < 4 { continue }
                let origLen = Int(le32s(body, 0))
                let capLen = min(origLen, body.count - 4)
                return body[(body.startIndex+4)..<(body.startIndex+4+capLen)]
            default: break
            }
        }
    }

    // PLU body is 30 bytes. Sweep the whole body.
    let sw = Sweep(bodyLen: 30, bits: 23, limit: limit)
    // SECOND SWEEP, so the null is not a null about one message type only.
    //
    // The first sweep asks whether the PRICE LEVEL UPDATE mints an identifier that the
    // other messages quote back. That is the right first question, because on an
    // order-by-order feed the add is what mints the reference. But a reader is entitled
    // to ask whether identity hides in the TRADE REPORT instead — it is 38 bytes to the
    // update's 30, and the extra eight are high-cardinality.
    //
    // So the trade report is swept as an opening type in its own right, against the price
    // level updates as terminators. If DEEP carried order identity anywhere in its two
    // high-volume message shapes, one of these two sweeps would find it. Reporting only
    // the first would leave the null resting on a choice of message type rather than on
    // the feed.
    let swT = Sweep(bodyLen: 38, bits: 23, limit: limit)
    var msgs: UInt64 = 0
    var typeCount = [UInt8: UInt64](), typeBytes = [UInt8: UInt64]()
    // FIELD CENSUS over the 30-byte price level update, so that the 30 bytes are
    // accounted for by named fields with verified semantics and the residual is measured.
    var pluTotal: UInt64 = 0
    var flagsDistinct = Set<UInt8>()
    var tsInWindow: UInt64 = 0, tsOutWindow: UInt64 = 0, tsBackward: UInt64 = 0
    var tsPrev: UInt64 = 0
    var symAscii: UInt64 = 0, symNonAscii: UInt64 = 0
    var symbols = U64Set(bits: 18)
    var sizeZero: UInt64 = 0, sizeMax: UInt64 = 0
    var priceZero: UInt64 = 0, priceMin: UInt64 = UInt64.max, priceMax: UInt64 = 0
    // the capture window, taken from the enumeration already on disk for this file
    let CAP_LO: UInt64 = 1_564_486_281_000_000_000
    let CAP_HI: UInt64 = 1_564_521_307_000_000_000

    while let pkt = nextPacket() {
        if linkType != 1 { continue }
        let inclLen = pkt.count
        if inclLen < 14 + 20 + 8 { continue }
        let ethType = be16s(pkt, 12)
        var off = 14
        if ethType == 0x8100 { off = 18 } else if ethType != 0x0800 { continue }
        if inclLen < off + 20 { continue }
        let vihl = pkt[pkt.startIndex + off]
        if (vihl >> 4) != 4 { continue }
        let ihl = Int(vihl & 0x0f) * 4
        if ihl < 20 || inclLen < off + ihl + 8 { continue }
        if pkt[pkt.startIndex + off + 9] != 17 { continue }
        let udpOff = off + ihl
        let udpLen = Int(be16s(pkt, udpOff + 4))
        if udpLen < 8 { continue }
        let payOff = udpOff + 8
        let payLen = min(udpLen - 8, inclLen - payOff)
        if payLen < 40 { continue }
        let pay = pkt[(pkt.startIndex + payOff)..<(pkt.startIndex + payOff + payLen)]
        if pay[pay.startIndex] != 1 { continue }
        if le16s(pay, 2) != 0x8004 { continue }
        let payloadLen = Int(le16s(pay, 12))
        let msgCount = Int(le16s(pay, 14))
        var q = 40, seen = 0
        while seen < msgCount {
            if q + 2 > 40 + payloadLen || q + 2 > payLen { break }
            let mlen = Int(le16s(pay, q)); q += 2
            if mlen == 0 || q + mlen > 40 + payloadLen || q + mlen > payLen { break }
            let m = pay[(pay.startIndex + q)..<(pay.startIndex + q + mlen)]
            let t = m[m.startIndex]
            typeCount[t, default: 0] &+= 1
            typeBytes[t, default: 0] &+= UInt64(mlen)
            msgs &+= 1
            if mlen >= 30 && (t == 0x38 || t == 0x35) {
                pluTotal &+= 1
                flagsDistinct.insert(m[m.startIndex + 1])
                let ts = le64s(m, 2)
                if ts >= CAP_LO && ts <= CAP_HI { tsInWindow &+= 1 } else { tsOutWindow &+= 1 }
                if tsPrev > 0 && ts < tsPrev { tsBackward &+= 1 }
                tsPrev = ts
                var ok = true
                for k in 10..<18 {
                    let c = m[m.startIndex + k]
                    if !((c >= 0x41 && c <= 0x5A) || (c >= 0x30 && c <= 0x39) || c == 0x20 || c == 0x2E || c == 0x2D || c == 0x2B) { ok = false; break }
                }
                if ok { symAscii &+= 1 } else { symNonAscii &+= 1 }
                symbols.insert(le64s(m, 10))
                let sz = UInt64(le32s(m, 18))
                if sz == 0 { sizeZero &+= 1 }; if sz > sizeMax { sizeMax = sz }
                let px = le64s(m, 22)
                if px == 0 { priceZero &+= 1 } else { if px < priceMin { priceMin = px }; if px > priceMax { priceMax = px } }
            }
            m.withUnsafeBufferPointer { raw in
                guard let base = raw.baseAddress else { return }
                if t == 0x38 && mlen >= 30 { sw.observeOpen(base) }
                else if (t == 0x35 || t == 0x54) && mlen >= 30 { sw.observeTerm(base, mlen) }
                if t == 0x54 && mlen >= 38 { swT.observeOpen(base) }
                else if (t == 0x38 || t == 0x35) && mlen >= 30 { swT.observeTerm(base, mlen) }
            }
            q += mlen; seen += 1
        }
    }

    print("== IEX DEEP 1.0 — FRAMING ==")
    print("messages_total\t\(msgs)")
    for (k, v) in typeCount.sorted(by: { $0.value > $1.value }) {
        let b = typeBytes[k] ?? 0
        print("T\t\(String(UnicodeScalar(k)))\t0x\(String(format: "%02x", k))\t\(v)\t\(b)\t\(v == 0 ? 0 : b / v)")
    }
    print("== IEX DEEP 1.0 — PRICE LEVEL UPDATE, 30-BYTE FIELD CENSUS ==")
    print("plu_messages\t\(pluTotal)")
    print("field_0_type_bytes\t1")
    print("field_1_flags_bytes\t1")
    print("field_1_flags_distinct_values\t\(flagsDistinct.count)")
    print("field_2_timestamp_bytes\t8")
    print("field_2_timestamp_inside_capture_window\t\(tsInWindow)")
    print("field_2_timestamp_outside_capture_window\t\(tsOutWindow)")
    print("field_2_timestamp_backward_steps\t\(tsBackward)")
    print("field_10_symbol_bytes\t8")
    print("field_10_symbol_ascii_padded\t\(symAscii)")
    print("field_10_symbol_not_ascii\t\(symNonAscii)")
    print("field_10_symbol_distinct\t\(symbols.count)")
    print("field_18_size_bytes\t4")
    print("field_18_size_zero_price_level_removed\t\(sizeZero)")
    print("field_18_size_max_raw\t\(sizeMax)")
    print("field_22_price_bytes\t8")
    print("field_22_price_zero\t\(priceZero)")
    print("field_22_price_min_raw\t\(priceMin == UInt64.max ? 0 : priceMin)")
    print("field_22_price_max_raw\t\(priceMax)")
    let claimed = 1 + 1 + 8 + 8 + 4 + 8
    print("bytes_claimed_by_named_fields\t\(claimed)")
    print("plu_body_bytes\t30")
    print("residual_bytes_available_for_an_order_reference\t\(30 - claimed)")

    let best = sw.report("IEX DEEP 1.0 — price level update as the opening message")
    let bestT = swT.report("IEX DEEP 1.0 — trade report as the opening message")
    print("== IEX DEEP 1.0 — SECOND SWEEP VERDICT ==")
    print("trade_report_identity_offset\t\(bestT.bestOff)")
    print("trade_report_identity_cardinality_permille\t\(bestT.bestCard)")
    print("trade_report_identity_join_permille\t\(bestT.bestJoin)")
    print("trade_report_carries_order_identity\t\(bestT.bestOff >= 0 ? "YES" : "NO")")
    let cHi = sw.control(2, 1)      // timestamp, LE — high cardinality, must not join
    let cLo = sw.control(10, 1)     // symbol, LE — low cardinality, must join
    print("== IEX DEEP 1.0 — INTERNAL CONTROLS ==")
    print("control_timestamp_offset\t2")
    print("control_timestamp_cardinality_permille\t\(cHi.card)")
    print("control_timestamp_join_permille\t\(cHi.join)")
    print("control_timestamp_R1_only_FIRED\t\(cHi.card >= 900 && cHi.join < 900 ? "YES" : "NO")")
    print("control_symbol_offset\t10")
    print("control_symbol_cardinality_permille\t\(cLo.card)")
    print("control_symbol_join_permille\t\(cLo.join)")
    print("control_symbol_R2_only_FIRED\t\(cLo.card < 900 && cLo.join >= 900 ? "YES" : "NO")")
    let controlsFired = (cHi.card >= 900 && cHi.join < 900) && (cLo.card < 900 && cLo.join >= 900)
    print("both_controls_fired\t\(controlsFired ? "YES" : "NO")")
    print("== IEX DEEP 1.0 — VERDICT ==")
    print("identity_offset\t\(best.bestOff)")
    print("identity_cardinality_permille\t\(best.bestCard)")
    print("identity_join_permille\t\(best.bestJoin)")
    if !controlsFired {
        print("VERDICT\tREFUSE_CONTROLS_DID_NOT_FIRE_DETECTOR_UNPROVEN")
        printReference(); return 3
    }
    if best.bestOff >= 0 || bestT.bestOff >= 0 {
        print("VERDICT\tORDER_IDENTITY_PRESENT")
        print("predicate_status\tCAN_RUN")
    } else {
        print("VERDICT\tORDER_IDENTITY_ABSENT")
        print("predicate_status\tCANNOT_RUN_NO_KEY")
        print("NOTE\tABSENT is not zero. The cancellation predicate counts orders opened and")
        print("NOTE\tterminated without execution. DEEP publishes aggregated price levels, so")
        print("NOTE\tthere is no order to count and no denominator to divide by. A per-1,000")
        print("NOTE\trate computed on this feed would answer a different question.")
    }
    printReference()
    return 0
}

// ————————————————————————————————————————————————————————————————
// entry
// ————————————————————————————————————————————————————————————————
var args = Array(CommandLine.arguments.dropFirst())
var limit: UInt64 = 2_000_000
var mode = ""
var i = 0
while i < args.count {
    switch args[i] {
    case "itch50": mode = "itch50"
    case "deep": mode = "deep"
    case "--limit": if i + 1 < args.count { limit = UInt64(args[i+1]) ?? limit; i += 1 }
    default: break
    }
    i += 1
}

print("FEED_ORDER_IDENTITY")
print("question\tdoes this feed carry the key the published cancellation predicate needs")
print("detector\tR1 cardinality >= 900 permille AND R2 join >= 900 permille at one offset")
print("float_types_declared\t0")
print("sample_limit_open_messages\t\(limit)")

if mode.isEmpty {
    print("MODE_ABSENT\tno feed named on argv")
    print("ABSENT is not a failure and it is not a pass. Name a feed:")
    print("  gzcat FEED.ITCH_50.gz | feed-order-identity itch50")
    print("  gzcat FEED_DEEP1.0.pcap.gz | feed-order-identity deep")
    printReference()
    exit(4)
}
exit(mode == "itch50" ? armITCH(limit: limit) : armDEEP(limit: limit))
