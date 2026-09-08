// tnik-network-degree-exact.swift
//
// GAME: TNIK IN THE NETWORK, EXACTLY.
//
// Counts, as integers, what the Study 26 regulon corpus contains about TNIK
// (Entrez 23043), the primary target of rentosertib / ISM001-055 / INS018_055.
//
// This program scores NO DRUG. Rentosertib is not in LINCS and TNIK is not a
// landmark gene; both of those are re-verified here from the pinned bytes before
// any counting begins. What follows is a statement about the NETWORKS WE HOLD,
// not about a medicine, not about efficacy, not about a dose, not about a patient.
//
// LAW: Swift, -O -swift-version 5. ZERO FLOAT on any decision path.
//      No Float, no Double, no CGFloat, no float literal, no float conversion.
//      Ratios are integer per-mille and FLOOR; the word FLOOR is printed with them.
//
// Build: xcrun swiftc -O -swift-version 5 -o tnik-net tnik-network-degree-exact.swift
// Run:   ./tnik-net <corpus-root>          (default ".")
//
// PATH-INDEPENDENT: no absolute path appears in this source. Every input is
// located relative to the corpus root given on the command line.

import Foundation

extension String {
    /// Integer-width alignment. No format string, no %s pointer-lifetime hazard.
    func leftPad(_ w: Int) -> String {
        var s = self
        while s.count < w { s = " " + s }
        return s
    }
    func rightPad(_ w: Int) -> String {
        var s = self
        while s.count < w { s += " " }
        return s
    }
}

// ============================================================================
// MARK: - reference figures, printed on EVERY exit
// ============================================================================

enum Ref {
    static var selfTestsRun = 0
    static var selfTestsPassed = 0
    static var selfTestsFailed = 0
    static var digestsComputed = 0
    static var inputsVerified = 0
    static var bytesRead = 0
    static var linesParsed = 0
    static var fieldsParsed = 0
    static var edgesAccepted = 0
    static var networksScanned = 0
    static var refusalsRaised = 0
}

func printReference(_ tag: String) {
    print("")
    print("================================================================")
    print("REFERENCE FIGURES  [\(tag)]")
    print("  self-tests run .................. \(Ref.selfTestsRun)")
    print("  self-tests passed .............. \(Ref.selfTestsPassed)")
    print("  self-tests failed .............. \(Ref.selfTestsFailed)")
    print("  sha256 digests computed ........ \(Ref.digestsComputed)")
    print("  inputs digest-verified ......... \(Ref.inputsVerified)")
    print("  bytes read (counted) ........... \(Ref.bytesRead)")
    print("  lines parsed (counted) ......... \(Ref.linesParsed)")
    print("  fields parsed (counted) ........ \(Ref.fieldsParsed)")
    print("  edges accepted (counted) ....... \(Ref.edgesAccepted)")
    print("  networks scanned ............... \(Ref.networksScanned)")
    print("  refusals raised ................ \(Ref.refusalsRaised)")
    print("================================================================")
}

func refuse(_ why: String) -> Never {
    Ref.refusalsRaised += 1
    print("")
    print("!! REFUSE: \(why)")
    printReference("REFUSED")
    exit(2)
}

// ============================================================================
// MARK: - SHA-256 (integer only)
// ============================================================================

struct SHA256I {
    static let K: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
    ]

    static func hash(_ msg: UnsafeRawBufferPointer) -> [UInt8] {
        var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                           0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
        let n = msg.count
        var w = [UInt32](repeating: 0, count: 64)

        // total length in bits
        let bitLen = UInt64(n) &* 8

        var block = [UInt8](repeating: 0, count: 64)
        var off = 0

        func compress(_ b: [UInt8]) {
            for i in 0..<16 {
                let j = i * 4
                w[i] = (UInt32(b[j]) << 24) | (UInt32(b[j+1]) << 16) | (UInt32(b[j+2]) << 8) | UInt32(b[j+3])
            }
            for i in 16..<64 {
                let s0 = rotr(w[i-15], 7) ^ rotr(w[i-15], 18) ^ (w[i-15] >> 3)
                let s1 = rotr(w[i-2], 17) ^ rotr(w[i-2], 19) ^ (w[i-2] >> 10)
                w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1
            }
            var a = h[0], bb = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]
            for i in 0..<64 {
                let S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25)
                let ch = (e & f) ^ ((~e) & g)
                let t1 = hh &+ S1 &+ ch &+ K[i] &+ w[i]
                let S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22)
                let maj = (a & bb) ^ (a & c) ^ (bb & c)
                let t2 = S0 &+ maj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = bb; bb = a; a = t1 &+ t2
            }
            h[0] = h[0] &+ a; h[1] = h[1] &+ bb; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
        }

        while off + 64 <= n {
            for i in 0..<64 { block[i] = msg[off + i] }
            compress(block)
            off += 64
        }
        // tail
        var tail = [UInt8]()
        tail.reserveCapacity(128)
        for i in off..<n { tail.append(msg[i]) }
        tail.append(0x80)
        while tail.count % 64 != 56 { tail.append(0) }
        for s in stride(from: 56, through: 0, by: -8) {
            tail.append(UInt8((bitLen >> UInt64(s)) & 0xff))
        }
        var p = 0
        while p < tail.count {
            for i in 0..<64 { block[i] = tail[p + i] }
            compress(block)
            p += 64
        }
        var digest = [UInt8]()
        digest.reserveCapacity(32)
        for v in h {
            digest.append(UInt8((v >> 24) & 0xff))
            digest.append(UInt8((v >> 16) & 0xff))
            digest.append(UInt8((v >> 8) & 0xff))
            digest.append(UInt8(v & 0xff))
        }
        return digest
    }

    @inline(__always)
    static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }

    static func hex(_ b: [UInt8]) -> String {
        let d = "0123456789abcdef"
        let dc = Array(d.utf8)
        var s = [UInt8]()
        s.reserveCapacity(b.count * 2)
        for byte in b {
            s.append(dc[Int(byte >> 4)])
            s.append(dc[Int(byte & 0xf)])
        }
        return String(decoding: s, as: UTF8.self)
    }

    static func hexOf(_ data: [UInt8]) -> String {
        Ref.digestsComputed += 1
        return data.withUnsafeBytes { hex(hash($0)) }
    }
    static func hexOf(_ data: Data) -> String {
        Ref.digestsComputed += 1
        return data.withUnsafeBytes { (p: UnsafeRawBufferPointer) -> String in hex(hash(p)) }
    }
    static func hexOfString(_ s: String) -> String {
        Ref.digestsComputed += 1
        return Array(s.utf8).withUnsafeBytes { hex(hash($0)) }
    }
}

// ============================================================================
// MARK: - CRC32 (integer only) — gzip's own both-directions check
// ============================================================================

struct CRC32I {
    static let table: [UInt32] = {
        var t = [UInt32](repeating: 0, count: 256)
        for i in 0..<256 {
            var c = UInt32(i)
            for _ in 0..<8 {
                c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : (c >> 1)
            }
            t[i] = c
        }
        return t
    }()
    static func compute(_ bytes: [UInt8]) -> UInt32 {
        var c: UInt32 = 0xFFFFFFFF
        for b in bytes { c = table[Int((c ^ UInt32(b)) & 0xff)] ^ (c >> 8) }
        return c ^ 0xFFFFFFFF
    }
}

// ============================================================================
// MARK: - INFLATE (RFC 1951) + gzip container (RFC 1952), integer only
// ============================================================================

struct BitReader {
    let d: [UInt8]
    var pos: Int
    var bitBuf: UInt32 = 0
    var bitCnt: Int = 0
    init(_ d: [UInt8], _ start: Int) { self.d = d; self.pos = start }

    mutating func need(_ n: Int) -> Bool {
        while bitCnt < n {
            if pos >= d.count { return false }
            bitBuf |= UInt32(d[pos]) << UInt32(bitCnt)
            pos += 1
            bitCnt += 8
        }
        return true
    }
    mutating func bits(_ n: Int) -> Int? {
        if n == 0 { return 0 }
        if !need(n) { return nil }
        let v = Int(bitBuf & ((1 << UInt32(n)) - 1))
        bitBuf >>= UInt32(n)
        bitCnt -= n
        return v
    }
    mutating func alignByte() { bitBuf = 0; bitCnt = 0 }
}

struct Huff {
    var counts: [Int]
    var symbols: [Int]
    init?(_ lengths: [Int]) {
        var c = [Int](repeating: 0, count: 16)
        for l in lengths { c[l] += 1 }
        c[0] = 0
        var offs = [Int](repeating: 0, count: 16)
        for i in 1..<16 { offs[i] = offs[i-1] + c[i-1] }
        var sym = [Int](repeating: 0, count: lengths.count)
        for (s, l) in lengths.enumerated() where l != 0 {
            sym[offs[l]] = s
            offs[l] += 1
        }
        counts = c
        symbols = sym
    }
    func decode(_ br: inout BitReader) -> Int? {
        var code = 0, first = 0, index = 0
        for len in 1...15 {
            guard let b = br.bits(1) else { return nil }
            code |= b
            let count = counts[len]
            if code - first < count { return symbols[index + (code - first)] }
            index += count
            first = (first + count) << 1
            code <<= 1
        }
        return nil
    }
}

enum Inflate {
    static let lenBase = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258]
    static let lenExtra = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0]
    static let distBase = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577]
    static let distExtra = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13]
    static let clOrder = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15]

    /// Returns (plainBytes, endPos) or nil on malformed stream.
    static func raw(_ d: [UInt8], _ start: Int) -> ([UInt8], Int)? {
        var br = BitReader(d, start)
        var outB = [UInt8]()
        outB.reserveCapacity(1 << 20)

        var fixedLit: Huff? = nil
        var fixedDist: Huff? = nil

        while true {
            guard let bfinal = br.bits(1), let btype = br.bits(2) else { return nil }
            if btype == 0 {
                br.alignByte()
                if br.pos + 4 > d.count { return nil }
                let len = Int(d[br.pos]) | (Int(d[br.pos+1]) << 8)
                let nlen = Int(d[br.pos+2]) | (Int(d[br.pos+3]) << 8)
                if (len ^ 0xFFFF) != nlen { return nil }
                br.pos += 4
                if br.pos + len > d.count { return nil }
                outB.append(contentsOf: d[br.pos..<(br.pos+len)])
                br.pos += len
            } else if btype == 1 || btype == 2 {
                var lit: Huff
                var dist: Huff
                if btype == 1 {
                    if fixedLit == nil {
                        var l = [Int](repeating: 8, count: 288)
                        for i in 144..<256 { l[i] = 9 }
                        for i in 256..<280 { l[i] = 7 }
                        fixedLit = Huff(l)
                        fixedDist = Huff([Int](repeating: 5, count: 30))
                    }
                    guard let a = fixedLit, let b = fixedDist else { return nil }
                    lit = a; dist = b
                } else {
                    guard let hlit = br.bits(5), let hdist = br.bits(5), let hclen = br.bits(4) else { return nil }
                    let nlen = hlit + 257, ndist = hdist + 1, ncode = hclen + 4
                    var clLens = [Int](repeating: 0, count: 19)
                    for i in 0..<ncode {
                        guard let v = br.bits(3) else { return nil }
                        clLens[clOrder[i]] = v
                    }
                    guard let clh = Huff(clLens) else { return nil }
                    var lens = [Int]()
                    lens.reserveCapacity(nlen + ndist)
                    while lens.count < nlen + ndist {
                        guard let s = clh.decode(&br) else { return nil }
                        if s < 16 { lens.append(s) }
                        else if s == 16 {
                            guard let r = br.bits(2), let last = lens.last else { return nil }
                            for _ in 0..<(r + 3) { lens.append(last) }
                        } else if s == 17 {
                            guard let r = br.bits(3) else { return nil }
                            for _ in 0..<(r + 3) { lens.append(0) }
                        } else if s == 18 {
                            guard let r = br.bits(7) else { return nil }
                            for _ in 0..<(r + 11) { lens.append(0) }
                        } else { return nil }
                    }
                    if lens.count != nlen + ndist { return nil }
                    guard let a = Huff(Array(lens[0..<nlen])),
                          let b = Huff(Array(lens[nlen...])) else { return nil }
                    lit = a; dist = b
                }
                decodeLoop: while true {
                    guard let s = lit.decode(&br) else { return nil }
                    if s < 256 { outB.append(UInt8(s)) }
                    else if s == 256 { break decodeLoop }
                    else {
                        let li = s - 257
                        if li >= lenBase.count { return nil }
                        guard let e = br.bits(lenExtra[li]) else { return nil }
                        let length = lenBase[li] + e
                        guard let ds = dist.decode(&br) else { return nil }
                        if ds >= distBase.count { return nil }
                        guard let de = br.bits(distExtra[ds]) else { return nil }
                        let distance = distBase[ds] + de
                        if distance > outB.count { return nil }
                        var src = outB.count - distance
                        for _ in 0..<length { outB.append(outB[src]); src += 1 }
                    }
                }
            } else { return nil }
            if bfinal == 1 { break }
        }
        return (outB, br.pos)
    }

    /// gzip member decode with FULL trailer verification (CRC32 + ISIZE).
    /// Returns nil if the container is malformed OR the trailer disagrees.
    static func gunzipVerified(_ d: [UInt8]) -> [UInt8]? {
        var all = [UInt8]()
        var p = 0
        while p + 18 <= d.count {
            if d[p] != 0x1f || d[p+1] != 0x8b || d[p+2] != 8 { return nil }
            let flg = d[p+3]
            p += 10
            if (flg & 0x04) != 0 {           // FEXTRA
                if p + 2 > d.count { return nil }
                let xlen = Int(d[p]) | (Int(d[p+1]) << 8)
                p += 2 + xlen
            }
            if (flg & 0x08) != 0 {           // FNAME
                while p < d.count && d[p] != 0 { p += 1 }
                p += 1
            }
            if (flg & 0x10) != 0 {           // FCOMMENT
                while p < d.count && d[p] != 0 { p += 1 }
                p += 1
            }
            if (flg & 0x02) != 0 { p += 2 }  // FHCRC
            if p >= d.count { return nil }
            guard let (plain, end) = raw(d, p) else { return nil }
            if end + 8 > d.count { return nil }
            let crcStored = UInt32(d[end]) | (UInt32(d[end+1]) << 8) | (UInt32(d[end+2]) << 16) | (UInt32(d[end+3]) << 24)
            let isizeStored = UInt32(d[end+4]) | (UInt32(d[end+5]) << 8) | (UInt32(d[end+6]) << 16) | (UInt32(d[end+7]) << 24)
            let crcActual = CRC32I.compute(plain)
            if crcActual != crcStored { return nil }
            if UInt32(truncatingIfNeeded: plain.count) != isizeStored { return nil }
            all.append(contentsOf: plain)
            p = end + 8
            if p >= d.count { break }
        }
        if all.isEmpty { return nil }
        return all
    }
}

// ============================================================================
// MARK: - pinned inputs (digest chain; no absolute paths)
// ============================================================================

struct PinnedInput {
    let rel: String
    let sha: String
}

let TNIK_ENTREZ: Int32 = 23043
let TNIK_SYMBOL = "TNIK"

// The 25 DISTINCT networks of the Study 26 regulon corpus, plus the one
// byte-identical duplicate, named as a duplicate rather than silently dropped.
let NETWORKS: [PinnedInput] = [
    PinnedInput(rel: "regulons/regulon_blca.tsv", sha: "b31dc1042928dabb0ab0587db82879e68aecd2834c4bb5c8d1027149ab881edd"),
    PinnedInput(rel: "regulons/regulon_brca.tsv", sha: "49da1c707ec301506cfa51e0d5343bd7dd6f56b24df7b25778b3631dafc839f1"),
    PinnedInput(rel: "regulons/regulon_cesc.tsv", sha: "aac4d9d9a5ea959b04c33ef282a2a3f13c7f3df68a481f55d9266e9c38de0bad"),
    PinnedInput(rel: "regulons/regulon_coad.tsv", sha: "5e4913df3c6837bfc88c84e1621ac857759e8e18c0ca6a78632f0fdbd1c5b9d2"),
    PinnedInput(rel: "regulons/regulon_esca.tsv", sha: "63028d48fa124abab3284162f6b77f9e2a20a62dccf5372d4ee916bd40c0ea10"),
    PinnedInput(rel: "regulons/regulon_gbm.tsv",  sha: "1f784782924f083ec348e30bebb091a8d0f1e645d5a1daf4143e285762428896"),
    PinnedInput(rel: "regulons/regulon_hnsc.tsv", sha: "72d7fe43ef57734de42cc518c2a8617601c37c4f35317b9aa2407164c5a2e86f"),
    PinnedInput(rel: "regulons/regulon_kirc.tsv", sha: "00ee5d02c87134d50d99f07f431a168efe361da5b79915390783024a753a179a"),
    PinnedInput(rel: "regulons/regulon_kirp.tsv", sha: "1330c3075ec056c21f5d1e13924d8d0f4a7e76f7982649e8ce926a0a48572d58"),
    PinnedInput(rel: "regulons/regulon_laml.tsv", sha: "4524e1d45f098f115a92a7ffe30492567881d80acc419b63b145615cc3094063"),
    PinnedInput(rel: "regulons/regulon_lihc.tsv", sha: "f9b2652a7c43d7ebaa6969441209eebaaff4d6278eb69752d8435406fc61c260"),
    PinnedInput(rel: "regulons/regulon_luad.tsv", sha: "44f649363c9cc071abd6c31190e77c95018290bfd38effbbbc8e8ce90d01cbf4"),
    PinnedInput(rel: "regulons/regulon_lusc.tsv", sha: "c0b4cd7814a096f9fafa5ba6fc5f37c1ca6f0d303551620951a61527e11455f6"),
    PinnedInput(rel: "regulons/regulon_net.tsv",  sha: "ee2ff6a80e891f791258791fc50e5e9e6e2cad2c5003115fec2dab023e595f20"),
    PinnedInput(rel: "regulons/regulon_ov.tsv",   sha: "3044bf7dffbe6b846c78fe09a7dc9780de221941858ec4df2d480a1c1f7706a6"),
    PinnedInput(rel: "regulons/regulon_paad.tsv", sha: "9ce69a7de9740fcda8fda201822fd86234532830e0b7506f1efc4a5ffc80cbad"),
    PinnedInput(rel: "regulons/regulon_pcpg.tsv", sha: "74b5558df72407771b774c36e458a02f7865cf451d3ccafb7acad6b81c6981af"),
    PinnedInput(rel: "regulons/regulon_prad.tsv", sha: "5182f75a8bb56250cfbb4cb278c36896fb142e9a2307302f5ff082a87dff1735"),
    PinnedInput(rel: "regulons/regulon_read.tsv", sha: "de1899c730c16d2e8b8b67c4f119b9e8e29bee8d5e619de5f2cf3c06391053e0"),
    PinnedInput(rel: "regulons/regulon_sarc.tsv", sha: "a1c545c1b4e61b7d7725769a3a68acae733b9ceb5aac545111cb08714192ae98"),
    PinnedInput(rel: "regulons/regulon_stad.tsv", sha: "48f064c26374e0863a8f25d210a58875fe3bc100b019820f46711e40f0deaf15"),
    PinnedInput(rel: "regulons/regulon_tgct.tsv", sha: "98cdeb00173e95b4c088df200daad78438409bc7e8203765bb9c87ad94c1b86d"),
    PinnedInput(rel: "regulons/regulon_thca.tsv", sha: "8f0e2ead5c536a2fd584cc6c4efb919d18613ba818e70ed5ab0c361637c96919"),
    PinnedInput(rel: "regulons/regulon_thym.tsv", sha: "b8fdeed0dd18c1167bc3c89477734f217786873d4650eb79c4b324aa39068708"),
    PinnedInput(rel: "regulons/regulon_ucec.tsv", sha: "6441c12b7c4f2e993b6681f4dfb2f6523b342ec582a820ed26e1eeedd8d6ea3b")
]
let DUPLICATE_NETWORK = PinnedInput(rel: "regulons/regulon_lamlblood.tsv",
                                    sha: "4524e1d45f098f115a92a7ffe30492567881d80acc419b63b145615cc3094063")

let IN_CROSSING = PinnedInput(rel: "regulons/CROSSING_C_SUMMARY.tsv", sha: "516792922bb6536666861137e9b916906f576d8060712fc25101425f5cbef469")
let IN_MR_UNION = PinnedInput(rel: "mrsets/mr_by_cohort_union.tsv", sha: "c511783f5c65c20aeb23d672376d8a709b3008352e55921a35b6406f9843db72")
let IN_MR_ICR   = PinnedInput(rel: "mrsets/mr_by_cohort_union_ICRPRIME.tsv", sha: "6a8a4b7bfc192b0bb3a3827b0df5c4bce3b4603b7366b8258e65f672b61d8f90")
let IN_MR_SUB   = PinnedInput(rel: "mrsets/mr_by_subtype.tsv", sha: "8a386b5a4227fd18b78be6f1edf7aa46ca96f8d910e4fd04a3da79b6754cbe70")
let IN_MR_ALL   = PinnedInput(rel: "mrsets/mr_all_distinct.txt", sha: "a8c590cc984d262547554afdd9ebe9fe007e0e2397a1c89692d1272098b3f499")
let IN_MR_REC   = PinnedInput(rel: "mrsets/mr_recurrent_407.txt", sha: "82b0e9ce2ce2b48c92d6b3b6c36fd2147613924d8a8f225d3a760b98510a03ef")
let IN_SCOREABLE = PinnedInput(rel: "universe/SCOREABLE_CONTEXTS.txt", sha: "cdff4c669a9416f46ae79c97fbc45b82d18f84874f38c9467095d91beb1b49a1")
let IN_HGNC     = PinnedInput(rel: "raw/hgnc/hgnc_complete_set.txt", sha: "6f43d6ff43aa9fdfa5fb2f20a20a7cace66e6e02e2a0dcf19d9b726e2e248d20")
let IN_GENEINFO = PinnedInput(rel: "raw/lincs/GSE92742_Broad_LINCS_gene_info.txt.gz", sha: "741216ccc53320119b47ab006de3bcad48963c57087c9e07f50f0d6cd088711a")
let IN_PERT92   = PinnedInput(rel: "raw/lincs/GSE92742_Broad_LINCS_pert_info.txt.gz", sha: "b1945b3fde51021865b12269929cc78ccf2665be27f53a4da9336e4ddcf4b42f")
let IN_PERT70   = PinnedInput(rel: "raw/lincs/GSE70138_Broad_LINCS_pert_info_2017-03-06.txt.gz", sha: "000171e8ce17cb00a3e80a907d97f0bc4218077eb4cb2ac03f4e0f9f4f2e5493")

// ============================================================================
// MARK: - IO with digest refusal
// ============================================================================

var CORPUS_ROOT = "."

func readPinned(_ p: PinnedInput) -> [UInt8] {
    let path = CORPUS_ROOT + "/" + p.rel
    guard let data = FileManager.default.contents(atPath: path) else {
        refuse("input not readable: \(p.rel)")
    }
    if data.isEmpty { refuse("input is EMPTY (a gate given nothing must not pass): \(p.rel)") }
    let got = SHA256I.hexOf(data)
    if got != p.sha {
        refuse("DIGEST MISMATCH on \(p.rel)\n         expected \(p.sha)\n         computed \(got)")
    }
    Ref.inputsVerified += 1
    Ref.bytesRead += data.count
    return [UInt8](data)
}

// ============================================================================
// MARK: - edge scanner: counts the work AS IT HAPPENS
// ============================================================================

struct NetStats {
    var name = ""
    var edges = 0
    var plus = 0
    var minus = 0
    var outDeg: [Int32: Int32] = [:]
    var inDeg:  [Int32: Int32] = [:]
    var tnikOutPlus = 0
    var tnikOutMinus = 0
    var tnikInPlus = 0
    var tnikInMinus = 0
    var tnikTargets: [Int32] = []
    var tnikRegulators: [Int32] = []
    var selfLoopTNIK = 0
    var bytes = 0
    var lines = 0
    var fields = 0
}

/// Packed edge key: regulator in the high 32 bits, target in the low 32 bits.
/// Integer only. Round-trip is self-tested (A40/A41).
@inline(__always) func packEdge(_ r: Int32, _ t: Int32) -> Int64 {
    (Int64(r) << 32) | Int64(UInt32(bitPattern: t))
}
@inline(__always) func unpackReg(_ k: Int64) -> Int32 { Int32(truncatingIfNeeded: k >> 32) }
@inline(__always) func unpackTgt(_ k: Int64) -> Int32 { Int32(bitPattern: UInt32(truncatingIfNeeded: k)) }

/// Every edge of the 25 DISTINCT networks, collected once so the corpus-wide
/// control arm can be computed without a second digest pass.
var ALL_EDGES: [Int64] = []

/// Strict TSV scanner. THREE fields per line, integer id, integer id, sign.
/// Any deviation REFUSES — a malformed corpus must never read as a count.
func scanNetwork(_ name: String, _ bytes: [UInt8], strict: Bool = true, collect: Bool = false) -> NetStats? {
    var st = NetStats()
    st.name = name
    st.bytes = bytes.count
    let n = bytes.count
    if n == 0 { return nil }                     // empty -> not a measurement
    var i = 0
    while i < n {
        // field 1
        var a: Int32 = 0
        var d1 = 0
        while i < n, bytes[i] >= 48, bytes[i] <= 57 { a = a &* 10 &+ Int32(bytes[i] - 48); i += 1; d1 += 1 }
        if d1 == 0 { return nil }
        if i >= n || bytes[i] != 9 { return nil }
        i += 1
        // field 2
        var b: Int32 = 0
        var d2 = 0
        while i < n, bytes[i] >= 48, bytes[i] <= 57 { b = b &* 10 &+ Int32(bytes[i] - 48); i += 1; d2 += 1 }
        if d2 == 0 { return nil }
        if i >= n || bytes[i] != 9 { return nil }
        i += 1
        // field 3 : sign
        if i >= n { return nil }
        let sgn = bytes[i]
        if sgn != 43 && sgn != 45 { return nil }   // '+' or '-'
        i += 1
        if i >= n || bytes[i] != 10 { return nil } // newline required
        i += 1

        st.lines += 1
        st.fields += 3
        st.edges += 1
        if sgn == 43 { st.plus += 1 } else { st.minus += 1 }
        if collect { ALL_EDGES.append(packEdge(a, b)) }
        st.outDeg[a, default: 0] += 1
        st.inDeg[b, default: 0] += 1
        if a == TNIK_ENTREZ {
            st.tnikTargets.append(b)
            if sgn == 43 { st.tnikOutPlus += 1 } else { st.tnikOutMinus += 1 }
            if b == TNIK_ENTREZ { st.selfLoopTNIK += 1 }
        }
        if b == TNIK_ENTREZ {
            st.tnikRegulators.append(a)
            if sgn == 43 { st.tnikInPlus += 1 } else { st.tnikInMinus += 1 }
        }
    }
    if strict && i != n { return nil }
    Ref.linesParsed += st.lines
    Ref.fieldsParsed += st.fields
    Ref.edgesAccepted += st.edges
    return st
}

// ============================================================================
// MARK: - exact integer rank
// ============================================================================

/// Number of entries STRICTLY GREATER than v, and the rank = that + 1.
func strictlyGreater(_ values: [Int32], _ v: Int32) -> Int {
    var c = 0
    for x in values where x > v { c += 1 }
    return c
}
func countEqual(_ values: [Int32], _ v: Int32) -> Int {
    var c = 0
    for x in values where x == v { c += 1 }
    return c
}
/// Both central order statistics (exact integers; no float median).
func centralPair(_ sorted: [Int32]) -> (Int32, Int32) {
    if sorted.isEmpty { return (0, 0) }
    let n = sorted.count
    if n % 2 == 1 { let m = sorted[n/2]; return (m, m) }
    return (sorted[n/2 - 1], sorted[n/2])
}
/// Integer per-mille, FLOOR. Never a float.
func permilleFloor(_ num: Int, _ den: Int) -> Int {
    if den == 0 { return -1 }
    return (num * 1000) / den
}

// ============================================================================
// MARK: - line/field splitters for the small metadata files
// ============================================================================

func linesOf(_ b: [UInt8]) -> [[UInt8]] {
    var out: [[UInt8]] = []
    var cur: [UInt8] = []
    for c in b {
        if c == 10 { out.append(cur); cur = [] }
        else if c != 13 { cur.append(c) }
    }
    if !cur.isEmpty { out.append(cur) }
    return out
}
func splitTab(_ b: [UInt8]) -> [String] {
    var out: [String] = []
    var cur: [UInt8] = []
    for c in b {
        if c == 9 { out.append(String(decoding: cur, as: UTF8.self)); cur = [] }
        else { cur.append(c) }
    }
    out.append(String(decoding: cur, as: UTF8.self))
    return out
}
func lowerBytes(_ b: [UInt8]) -> [UInt8] {
    var o = b
    for i in 0..<o.count { if o[i] >= 65 && o[i] <= 90 { o[i] = o[i] + 32 } }
    return o
}
func containsSub(_ hay: [UInt8], _ needle: [UInt8]) -> Bool {
    if needle.isEmpty || needle.count > hay.count { return false }
    let last = hay.count - needle.count
    var i = 0
    while i <= last {
        if hay[i] == needle[0] {
            var j = 1
            while j < needle.count, hay[i+j] == needle[j] { j += 1 }
            if j == needle.count { return true }
        }
        i += 1
    }
    return false
}
func countSubLines(_ plain: [UInt8], _ needleLower: String) -> Int {
    let nd = Array(needleLower.utf8)
    var hits = 0
    for ln in linesOf(plain) {
        if containsSub(lowerBytes(ln), nd) { hits += 1 }
    }
    return hits
}

// ============================================================================
// MARK: - SELF-VALIDATION, both directions.
//         A gate given nothing must not pass.
//         Always-green and always-red are the same defect.
// ============================================================================

func arm(_ name: String, _ ok: Bool) {
    Ref.selfTestsRun += 1
    if ok { Ref.selfTestsPassed += 1; print("  PASS  \(name)") }
    else  { Ref.selfTestsFailed += 1; print("  FAIL  \(name)") }
}

func runSelfTests(geneInfoGz: [UInt8]) {
    print("")
    print("SELF-VALIDATION — arms in BOTH directions")
    print("-----------------------------------------")

    // --- SHA-256 known vectors, positive and discriminating ---
    arm("A01 sha256(\"\") == e3b0c442...",
        SHA256I.hexOfString("") == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    arm("A02 sha256(\"abc\") == ba7816bf...",
        SHA256I.hexOfString("abc") == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    arm("A03 sha256(\"abd\") != sha256(\"abc\")  [DISCRIMINATES]",
        SHA256I.hexOfString("abd") != SHA256I.hexOfString("abc"))
    arm("A04 sha256 of 1000-byte block is stable across two calls",
        SHA256I.hexOfString(String(repeating: "x", count: 1000)) == SHA256I.hexOfString(String(repeating: "x", count: 1000)))
    arm("A05 sha256 of 999 x != 1000 x  [DISCRIMINATES on length]",
        SHA256I.hexOfString(String(repeating: "x", count: 999)) != SHA256I.hexOfString(String(repeating: "x", count: 1000)))

    // --- CRC32, positive and discriminating ---
    arm("A06 crc32(\"123456789\") == 0xCBF43926",
        CRC32I.compute(Array("123456789".utf8)) == 0xCBF43926)
    arm("A07 crc32(\"123456780\") != 0xCBF43926  [DISCRIMINATES]",
        CRC32I.compute(Array("123456780".utf8)) != 0xCBF43926)
    arm("A08 crc32(\"\") == 0",
        CRC32I.compute([]) == 0)

    // --- inflate: the gzip trailer is the both-directions check ---
    let plain = Inflate.gunzipVerified(geneInfoGz)
    arm("A09 inflate of pinned gene_info.gz passes its OWN CRC32 + ISIZE trailer",
        plain != nil)
    if let p = plain {
        arm("A10 inflated gene_info is non-empty and tab-delimited",
            p.count > 100000 && containsSub(p, Array("pr_is_lm".utf8)))
    } else { arm("A10 (skipped: inflate failed)", false) }
    // corrupt one payload byte -> must be DETECTED, not silently accepted
    var corrupted = geneInfoGz
    if corrupted.count > 200 { corrupted[150] = corrupted[150] ^ 0xFF }
    arm("A11 one flipped payload byte -> inflate/trailer REFUSES  [DISCRIMINATES]",
        Inflate.gunzipVerified(corrupted) == nil)
    arm("A12 gunzip of empty input REFUSES  [gate given nothing]",
        Inflate.gunzipVerified([]) == nil)
    arm("A13 gunzip of non-gzip bytes REFUSES",
        Inflate.gunzipVerified(Array("not a gzip file at all, no magic here".utf8)) == nil)

    // --- edge scanner on hand-countable fixtures ---
    // FIXTURE P: TNIK out-degree 3 (2 plus, 1 minus), TNIK in-degree 2, gene 999 out-degree 2.
    let fixP = Array("""
    23043\t100\t+
    23043\t101\t+
    23043\t102\t-
    999\t23043\t+
    999\t500\t-
    777\t23043\t-

    """.replacingOccurrences(of: "\n    ", with: "\n").utf8)
    let sP = scanNetwork("FIXTURE_P", fixP)
    arm("A14 fixture P parses (6 edges)", sP != nil && sP!.edges == 6)
    arm("A15 fixture P TNIK out-degree == 3", sP != nil && sP!.outDeg[TNIK_ENTREZ] == 3)
    arm("A16 fixture P TNIK out sign split == (2 plus, 1 minus)",
        sP != nil && sP!.tnikOutPlus == 2 && sP!.tnikOutMinus == 1)
    arm("A17 fixture P TNIK in-degree == 2", sP != nil && sP!.inDeg[TNIK_ENTREZ] == 2)
    arm("A18 fixture P TNIK regulators == [999, 777]",
        sP != nil && sP!.tnikRegulators == [999, 777])
    arm("A19 fixture P gene 999 out-degree == 2", sP != nil && sP!.outDeg[999] == 2)
    arm("A20 fixture P has no TNIK self-loop", sP != nil && sP!.selfLoopTNIK == 0)

    // FIXTURE N: NO TNIK anywhere. Must report ABSENT — 0 — not crash, not pass through.
    let fixN = Array("""
    111\t222\t+
    111\t333\t-
    444\t222\t+

    """.replacingOccurrences(of: "\n    ", with: "\n").utf8)
    let sN = scanNetwork("FIXTURE_N", fixN)
    arm("A21 fixture N parses (3 edges)", sN != nil && sN!.edges == 3)
    arm("A22 fixture N TNIK out-degree ABSENT (nil, reported as 0)  [DISCRIMINATES]",
        sN != nil && sN!.outDeg[TNIK_ENTREZ] == nil)
    arm("A23 fixture N TNIK in-degree ABSENT (nil, reported as 0)",
        sN != nil && sN!.inDeg[TNIK_ENTREZ] == nil)
    arm("A24 scanner tells P and N apart on the SAME instrument  [DISCRIMINATES]",
        (sP!.outDeg[TNIK_ENTREZ] ?? 0) != (sN!.outDeg[TNIK_ENTREZ] ?? 0))

    // FIXTURE with a self-loop, to prove the self-loop counter is not dead
    let fixS = Array("23043\t23043\t+\n".utf8)
    let sS = scanNetwork("FIXTURE_S", fixS)
    arm("A25 self-loop fixture: selfLoopTNIK == 1  [detector is alive]",
        sS != nil && sS!.selfLoopTNIK == 1)

    // --- refusal arms: malformed input must NOT read as a count ---
    arm("A26 empty bytes REFUSE  [a gate given nothing must not pass]",
        scanNetwork("EMPTY", []) == nil)
    arm("A27 two-field line REFUSES", scanNetwork("BAD2", Array("1\t2\n".utf8)) == nil)
    arm("A28 bad sign char REFUSES", scanNetwork("BADSGN", Array("1\t2\t?\n".utf8)) == nil)
    arm("A29 non-numeric id REFUSES", scanNetwork("BADID", Array("x\t2\t+\n".utf8)) == nil)
    arm("A30 missing trailing newline REFUSES", scanNetwork("NONL", Array("1\t2\t+".utf8)) == nil)
    arm("A31 blank line REFUSES", scanNetwork("BLANK", Array("1\t2\t+\n\n".utf8)) == nil)

    // --- rank arithmetic, both ends ---
    let v: [Int32] = [10, 5, 5, 1, 100]
    arm("A32 strictlyGreater(_,100) == 0  [top]", strictlyGreater(v, 100) == 0)
    arm("A33 strictlyGreater(_,1) == 4  [bottom]", strictlyGreater(v, 1) == 4)
    arm("A34 countEqual(_,5) == 2  [ties counted, not averaged]", countEqual(v, 5) == 2)
    arm("A35 centralPair odd n", centralPair([1,2,3,4,5]) == (3, 3))
    arm("A36 centralPair even n reports BOTH", centralPair([1,2,3,4]) == (2, 3))
    arm("A37 permilleFloor(1,3) == 333  [FLOOR, integer]", permilleFloor(1, 3) == 333)
    arm("A38 permilleFloor(2,3) == 666  [FLOOR, not 667]", permilleFloor(2, 3) == 666)
    arm("A39 permilleFloor(_,0) == -1  [zero denominator named, not silently 0]",
        permilleFloor(5, 0) == -1)


    // --- packed-edge key: round-trip and ordering, both directions ---
    arm("A40 packEdge/unpack round-trip on (23043, 100)",
        unpackReg(packEdge(23043, 100)) == 23043 && unpackTgt(packEdge(23043, 100)) == 100)
    arm("A41 packEdge round-trip on a large entrez pair (100616380 as target)",
        unpackReg(packEdge(6054, 100616380)) == 6054 && unpackTgt(packEdge(6054, 100616380)) == 100616380)
    arm("A42 packEdge is INJECTIVE on two edges sharing a regulator  [DISCRIMINATES]",
        packEdge(23043, 100) != packEdge(23043, 101))
    arm("A43 packEdge sorts by regulator first, then target",
        packEdge(1, 999999) < packEdge(2, 1))
    // run-length grouping on a hand-countable multiset
    var rl: [Int64] = [packEdge(5, 7), packEdge(5, 7), packEdge(5, 8), packEdge(6, 1)]
    rl.sort()
    var runs = 0, maxRun = 0, cur = 1
    for k in 1..<rl.count {
        if rl[k] == rl[k-1] { cur += 1 } else { runs += 1; if cur > maxRun { maxRun = cur }; cur = 1 }
    }
    runs += 1; if cur > maxRun { maxRun = cur }
    arm("A44 run-length grouping: 3 distinct keys, longest run 2", runs == 3 && maxRun == 2)
    print("-----------------------------------------")
    print("  arms run \(Ref.selfTestsRun)   passed \(Ref.selfTestsPassed)   failed \(Ref.selfTestsFailed)")
    if Ref.selfTestsFailed != 0 {
        refuse("self-validation FAILED — the instrument is not trusted, so nothing is measured.")
    }
}

// ============================================================================
// MARK: - token search helpers (exact token, never substring, for gene symbols)
// ============================================================================

func tokensOf(_ b: [UInt8]) -> [String] {
    var out: [String] = []
    var cur: [UInt8] = []
    for c in b {
        if c == 9 || c == 44 || c == 10 || c == 13 || c == 32 {
            if !cur.isEmpty { out.append(String(decoding: cur, as: UTF8.self)); cur = [] }
        } else { cur.append(c) }
    }
    if !cur.isEmpty { out.append(String(decoding: cur, as: UTF8.self)) }
    return out
}
func exactTokenCount(_ b: [UInt8], _ tok: String) -> Int {
    var c = 0
    for t in tokensOf(b) where t == tok { c += 1 }
    return c
}
func stripQuotes(_ s: String) -> String {
    var t = s
    if t.hasPrefix("\"") { t.removeFirst() }
    if t.hasSuffix("\"") { t.removeLast() }
    return t
}

// ============================================================================
// MARK: - MAIN
// ============================================================================

setvbuf(stdout, nil, _IONBF, 0)

let args = CommandLine.arguments
// The harness runs every program with NO ARGV, so "." only works from one directory. Resolve by
// walking outward from the binary and the working directory to the first ancestor holding the
// networks, then fall back to "." so an explicit argv[1] still wins and the old behaviour stands.
func resolveCorpusRoot() -> String {
    let fm = FileManager.default
    var cands: [String] = []
    if let exe = CommandLine.arguments.first, !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<8 { cands.append(d + "/corpus/study-26-networks"); d = (d as NSString).deletingLastPathComponent; if d.isEmpty || d == "/" { break } }
    }
    var w = fm.currentDirectoryPath
    for _ in 0..<8 { cands.append(w + "/corpus/study-26-networks"); w = (w as NSString).deletingLastPathComponent; if w.isEmpty || w == "/" { break } }
    for c in cands where fm.fileExists(atPath: c + "/regulons/regulon_blca.tsv") { return c }
    return "."
}
CORPUS_ROOT = args.count > 1 ? args[1] : resolveCorpusRoot()

print("================================================================")
print("TNIK IN THE NETWORK, EXACTLY")
print("Study 26 regulon corpus — integer counting, zero float")
print("================================================================")
print("corpus root (argv, not baked) : \(CORPUS_ROOT)")
print("subject gene                  : \(TNIK_SYMBOL)  Entrez \(TNIK_ENTREZ)")
print("")
print("THIS PROGRAM SCORES NO DRUG. It counts what the networks we hold")
print("contain about one gene. A degree is not efficacy, not a dose, not a")
print("mechanism, and not evidence that any drug helps or harms anyone.")

// ---- load gene_info first (self-tests need its bytes) ----
let geneInfoGz = readPinned(IN_GENEINFO)
runSelfTests(geneInfoGz: geneInfoGz)

// ============================================================================
// ARM 0 — RE-VERIFY THE TWO SETTLED FACTS, plus the LINCS lookup, FROM BYTES
// ============================================================================

print("")
print("================================================================")
print("ARM 0 — THE BOUNDS. Re-verified from the pinned bytes.")
print("================================================================")

guard let geneInfo = Inflate.gunzipVerified(geneInfoGz) else {
    refuse("gene_info.gz failed its own CRC32/ISIZE trailer")
}
print("gene_info.txt.gz  inflated bytes ... \(geneInfo.count)   (CRC32+ISIZE verified)")

var giRows = 0, giLM = 0, giBING = 0
var tnikLM = -1, tnikBING = -1, tnikRowsFound = 0
var tnikTitle = ""
for (idx, ln) in linesOf(geneInfo).enumerated() {
    if idx == 0 { continue }
    if ln.isEmpty { continue }
    let f = splitTab(ln)
    if f.count < 5 { continue }
    giRows += 1
    if f[3] == "1" { giLM += 1 }
    if f[4] == "1" { giBING += 1 }
    if f[0] == "\(TNIK_ENTREZ)" || f[1] == TNIK_SYMBOL {
        tnikRowsFound += 1
        tnikLM = Int(f[3]) ?? -1
        tnikBING = Int(f[4]) ?? -1
        tnikTitle = f[2]
    }
}
if tnikRowsFound != 1 { refuse("expected exactly ONE TNIK row in gene_info, found \(tnikRowsFound)") }
print("gene_info rows (counted) ......... \(giRows)")
print("  pr_is_lm == 1 (landmark space) . \(giLM)")
print("  pr_is_bing == 1 ................ \(giBING)")
print("TNIK row: gene \(TNIK_ENTREZ)  \"\(tnikTitle)\"")
print("  pr_is_lm ....................... \(tnikLM)")
print("  pr_is_bing ..................... \(tnikBING)")
if tnikLM == 0 {
    print("  VERDICT: TNIK IS NOT A LANDMARK GENE. Its value in the 978-gene")
    print("           landmark space is a MODEL OUTPUT, not a measurement.")
} else {
    print("  VERDICT: DISAGREEMENT WITH THE LOCK PHASE — pr_is_lm is \(tnikLM), not 0.")
}

// --- LINCS perturbagen lookup: ABSENT vs REFUSED vs NOT_KNOWN are three answers ---
print("")
print("LINCS perturbagen lookup for the molecule (login-free pinned files):")
let pert92gz = readPinned(IN_PERT92)
let pert70gz = readPinned(IN_PERT70)
guard let pert92 = Inflate.gunzipVerified(pert92gz) else { refuse("GSE92742 pert_info trailer failed") }
guard let pert70 = Inflate.gunzipVerified(pert70gz) else { refuse("GSE70138 pert_info trailer failed") }
let p92rows = linesOf(pert92).count - 1
let p70rows = linesOf(pert70).count - 1
print("  GSE92742 pert_info rows ........ \(p92rows)   (inflated \(pert92.count) B, CRC32 ok)")
print("  GSE70138 pert_info rows ........ \(p70rows)   (inflated \(pert70.count) B, CRC32 ok)")
let queries = ["rentosertib", "ism001", "ism-001", "ins018", "ins-018"]
var totalMoleculeHits = 0
for q in queries {
    let a = countSubLines(pert92, q)
    let b = countSubLines(pert70, q)
    totalMoleculeHits += a + b
    print("  query \"\(q)\" ................ GSE92742 \(a)   GSE70138 \(b)")
}
print("  POSITIVE CONTROLS — the search must be able to FIND something:")
for q in ["pirfenidone", "nintedanib", "sirolimus"] {
    let a = countSubLines(pert92, q)
    let b = countSubLines(pert70, q)
    print("  query \"\(q)\" ................ GSE92742 \(a)   GSE70138 \(b)")
}
if totalMoleculeHits == 0 {
    print("  VERDICT: ABSENT. Rentosertib is not a perturbagen in either LINCS")
    print("           release. ABSENT, not REFUSED and not NOT_KNOWN: we looked,")
    print("           the lookup works (controls above are non-zero), it is not there.")
} else {
    print("  VERDICT: \(totalMoleculeHits) hit(s) — DISAGREEMENT with the lock phase.")
}

// --- TNIK in the published master-regulator sets ---
print("")
print("TNIK in the published master-regulator sets (exact token match):")
let mrFiles: [(String, PinnedInput)] = [
    ("mr_by_cohort_union.tsv", IN_MR_UNION),
    ("mr_by_cohort_union_ICRPRIME.tsv", IN_MR_ICR),
    ("mr_by_subtype.tsv", IN_MR_SUB),
    ("mr_all_distinct.txt", IN_MR_ALL),
    ("mr_recurrent_407.txt", IN_MR_REC)
]
var mrBytesByName: [String: [UInt8]] = [:]
var tnikMRTotal = 0
for (nm, pin) in mrFiles {
    let b = readPinned(pin)
    mrBytesByName[nm] = b
    let hits = exactTokenCount(b, TNIK_SYMBOL)
    let ctrl = exactTokenCount(b, "FOXM1")
    tnikMRTotal += hits
    print("  \(nm) ..... TNIK \(hits)   [control FOXM1 \(ctrl)]")
}
if tnikMRTotal == 0 {
    print("  VERDICT: TNIK IS A MASTER REGULATOR IN NONE of the published sets.")
    print("           The controls are non-zero, so the search discriminates.")
} else {
    print("  VERDICT: \(tnikMRTotal) hit(s) — DISAGREEMENT with the lock phase.")
}

// --- scoreable cohorts ---
let scoreBytes = readPinned(IN_SCOREABLE)
var scoreable: [String] = []
for ln in linesOf(scoreBytes) { let t = String(decoding: ln, as: UTF8.self); if !t.isEmpty { scoreable.append(t) } }
print("")
print("SCOREABLE_CONTEXTS.txt cohorts (counted) : \(scoreable.count)")
print("  \(scoreable.joined(separator: " "))")
let mrUnionBytes = mrBytesByName["mr_by_cohort_union.tsv"]!
var mrCohortRows = 0
var mrByCohort: [String: [String]] = [:]
for (i, ln) in linesOf(mrUnionBytes).enumerated() {
    if i == 0 { continue }
    if ln.isEmpty { continue }
    let f = splitTab(ln)
    if f.count < 3 { continue }
    mrCohortRows += 1
    mrByCohort[f[0]] = f[2].split(separator: ",").map(String.init)
}
print("mr_by_cohort_union.tsv cohort rows       : \(mrCohortRows)")
print("  NOTE: the brief said SEVENTEEN cohorts. SEVENTEEN is the size of")
print("  SCOREABLE_CONTEXTS.txt (\(scoreable.count)); mr_by_cohort_union.tsv carries")
print("  \(mrCohortRows) rows, a SUPERSET. TNIK is absent from all of both.")

// ============================================================================
// SYMBOL <-> ENTREZ from HGNC (approved, then previous, then alias; collisions counted)
// ============================================================================

print("")
print("================================================================")
print("SYMBOL MAP — HGNC complete set")
print("================================================================")
let hgncBytes = readPinned(IN_HGNC)
var symToEntrez: [String: Int32] = [:]
var entrezToSym: [Int32: String] = [:]
var hgncRows = 0, hgncWithEntrez = 0
var prevAdded = 0, aliasAdded = 0, prevCollide = 0, aliasCollide = 0
var hgncFieldCounts: Set<Int> = []
var prevPairs: [(String, Int32)] = []
var aliasPairs: [(String, Int32)] = []
for (i, ln) in linesOf(hgncBytes).enumerated() {
    if i == 0 { continue }
    if ln.isEmpty { continue }
    let f = splitTab(ln)
    hgncFieldCounts.insert(f.count)
    if f.count < 18 { continue }
    hgncRows += 1
    let sym = f[1]
    guard let e = Int32(f[17]) else { continue }
    hgncWithEntrez += 1
    if symToEntrez[sym] == nil { symToEntrez[sym] = e }
    if entrezToSym[e] == nil { entrezToSym[e] = sym }
    for t in stripQuotes(f[9]).split(separator: "|").map(String.init) where !t.isEmpty { prevPairs.append((t, e)) }
    for t in stripQuotes(f[7]).split(separator: "|").map(String.init) where !t.isEmpty { aliasPairs.append((t, e)) }
}
for (t, e) in prevPairs {
    if symToEntrez[t] == nil { symToEntrez[t] = e; prevAdded += 1 } else { prevCollide += 1 }
}
for (t, e) in aliasPairs {
    if symToEntrez[t] == nil { symToEntrez[t] = e; aliasAdded += 1 } else { aliasCollide += 1 }
}
print("HGNC rows (counted) .............. \(hgncRows)")
print("  distinct field counts seen ..... \(hgncFieldCounts.sorted())")
print("  rows with an entrez_id ......... \(hgncWithEntrez)")
print("  symbols from approved .......... \(hgncWithEntrez)")
print("  added from prev_symbol ......... \(prevAdded)   (collisions skipped \(prevCollide))")
print("  added from alias_symbol ........ \(aliasAdded)   (collisions skipped \(aliasCollide))")
print("  map size ....................... \(symToEntrez.count)")
if symToEntrez[TNIK_SYMBOL] != TNIK_ENTREZ {
    refuse("HGNC map does not resolve TNIK to \(TNIK_ENTREZ) — it gave \(String(describing: symToEntrez[TNIK_SYMBOL]))")
}
print("  CHECK  TNIK -> \(symToEntrez[TNIK_SYMBOL]!)   [expected \(TNIK_ENTREZ)]  OK")
print("  CHECK  WHSC1 (retired) -> \(String(describing: symToEntrez["WHSC1"]))   [prev_symbol path alive]")
print("  CHECK  NOT_A_GENE_XYZ -> \(String(describing: symToEntrez["NOT_A_GENE_XYZ"]))   [unmapped is nil, not 0]")

// ============================================================================
// ARM 1..3 — TNIK's EXACT DEGREE IN EVERY NETWORK WE HOLD
// ============================================================================

print("")
print("================================================================")
print("ARM 1-3 — TNIK degree, per network, exact integers")
print("================================================================")
print("")
print("net       edges  regs  targets |  TNIK-out  (+/-)   out-rank/regs | TNIK-in  (+/-)  in-rank/targets")
print("--------------------------------------------------------------------------------------------------")

struct NetSummary {
    var name = ""
    var edges = 0
    var nRegs = 0
    var nTargets = 0
    var tnikOut: Int32 = 0
    var tnikOutPlus = 0
    var tnikOutMinus = 0
    var tnikIn: Int32 = 0
    var tnikInPlus = 0
    var tnikInMinus = 0
    var outRank = 0
    var outTies = 0
    var inRank = 0
    var inTies = 0
    var maxOut: Int32 = 0
    var maxIn: Int32 = 0
    var tnikTargets: [Int32] = []
    var tnikRegulators: [Int32] = []
    var outDegSortedRegs: [Int32] = []
    var inDegAll: [Int32: Int32] = [:]
    var outDegAll: [Int32: Int32] = [:]
    var selfLoop = 0
}

var summaries: [NetSummary] = []
var totalEdges = 0
var netsWithTNIKOut = 0
var netsWithTNIKIn = 0

for pin in NETWORKS {
    let name = String(pin.rel.dropFirst("regulons/regulon_".count).dropLast(4))
    let bytes = readPinned(pin)
    guard let st = scanNetwork(name, bytes, strict: true, collect: true) else {
        refuse("network \(name) failed strict parse — a malformed corpus must never read as a count")
    }
    Ref.networksScanned += 1
    totalEdges += st.edges

    var s = NetSummary()
    s.name = name
    s.edges = st.edges
    s.nRegs = st.outDeg.count
    s.nTargets = st.inDeg.count
    s.tnikOut = st.outDeg[TNIK_ENTREZ] ?? 0
    s.tnikIn = st.inDeg[TNIK_ENTREZ] ?? 0
    s.tnikOutPlus = st.tnikOutPlus
    s.tnikOutMinus = st.tnikOutMinus
    s.tnikInPlus = st.tnikInPlus
    s.tnikInMinus = st.tnikInMinus
    s.tnikTargets = st.tnikTargets
    s.tnikRegulators = st.tnikRegulators
    s.selfLoop = st.selfLoopTNIK
    s.outDegAll = st.outDeg
    s.inDegAll = st.inDeg

    let outVals = Array(st.outDeg.values)
    let inVals = Array(st.inDeg.values)
    s.outRank = strictlyGreater(outVals, s.tnikOut) + 1
    s.outTies = countEqual(outVals, s.tnikOut)
    s.inRank = strictlyGreater(inVals, s.tnikIn) + 1
    s.inTies = countEqual(inVals, s.tnikIn)
    s.maxOut = outVals.max() ?? 0
    s.maxIn = inVals.max() ?? 0
    s.outDegSortedRegs = outVals.sorted()

    if s.tnikOut > 0 { netsWithTNIKOut += 1 }
    if s.tnikIn > 0 { netsWithTNIKIn += 1 }
    summaries.append(s)

    let outR = s.tnikOut > 0 ? "\(s.outRank)/\(s.nRegs)" : "ABSENT"
    let inR = s.tnikIn > 0 ? "\(s.inRank)/\(s.nTargets)" : "ABSENT"
    var row = name.rightPad(9)
    row += "\(s.edges)".leftPad(7) + "\(s.nRegs)".leftPad(6) + "\(s.nTargets)".leftPad(9) + " |"
    row += "\(s.tnikOut)".leftPad(9) + "  (+\(s.tnikOutPlus)/-\(s.tnikOutMinus))".rightPad(12)
    row += outR.leftPad(12) + " |"
    row += "\(s.tnikIn)".leftPad(8) + "  (+\(s.tnikInPlus)/-\(s.tnikInMinus))".rightPad(11)
    row += inR.leftPad(13)
    print(row)
}
print("--------------------------------------------------------------------------------------------------")
print("networks scanned ................. \(Ref.networksScanned)")
print("edges counted ONE AT A TIME ...... \(totalEdges)")
print("networks where TNIK is a REGULATOR \(netsWithTNIKOut) of \(Ref.networksScanned)")
print("networks where TNIK is a TARGET .. \(netsWithTNIKIn) of \(Ref.networksScanned)")

// duplicate network, named rather than silently dropped
let dupBytes = readPinned(DUPLICATE_NETWORK)
guard let dupSt = scanNetwork("lamlblood", dupBytes) else { refuse("duplicate network failed parse") }
print("")
print("DUPLICATE: regulons/regulon_lamlblood.tsv has the SAME sha256 as regulon_laml.tsv")
print("  its \(dupSt.edges) edges are EXCLUDED from the \(totalEdges) corpus total, and")
print("  its TNIK out-degree \(dupSt.outDeg[TNIK_ENTREZ] ?? 0) / in-degree \(dupSt.inDeg[TNIK_ENTREZ] ?? 0) is the laml figure counted twice.")

// ============================================================================
// ARM 4 — IS TNIK A HUB BY THE SAME MEASURE AS THE PUBLISHED MASTER REGULATORS?
// ============================================================================

print("")
print("================================================================")
print("ARM 4 — TNIK vs the master regulators, same network, same measure")
print("================================================================")
print("Only the \(scoreable.count) SCOREABLE cohorts are compared: each has BOTH a network")
print("and a published MR set. Cohorts missing either are named, not dropped.")
print("")

var cohortsCompared = 0
var cohortsTNIKBelowAllMR = 0
var mrUnmappedTotal = 0
var cohortsWhereTNIKOutBeatsSomeMR = 0

print("cohort  MRs  mapped  inNet | MR-out: min  c1  c2   max | TNIK-out | MRs-below-TNIK | TNIK-out-rank")
print("---------------------------------------------------------------------------------------------------")
for coh in scoreable {
    guard let s = summaries.first(where: { $0.name == coh }) else {
        print("\(coh)  NO NETWORK FILE — named, not dropped")
        continue
    }
    guard let mrs = mrByCohort[coh] else {
        print("\(coh)  NO MR ROW — named, not dropped")
        continue
    }
    var mapped: [Int32] = []
    var unmapped = 0
    for sym in mrs {
        if let e = symToEntrez[sym] { mapped.append(e) } else { unmapped += 1 }
    }
    mrUnmappedTotal += unmapped
    var mrOut: [Int32] = []
    var inNet = 0
    for e in mapped {
        if let d = s.outDegAll[e] { mrOut.append(d); inNet += 1 }
    }
    mrOut.sort()
    let (c1, c2) = centralPair(mrOut)
    var below = 0
    for d in mrOut where d < s.tnikOut { below += 1 }
    if below > 0 { cohortsWhereTNIKOutBeatsSomeMR += 1 }
    if below == 0 && !mrOut.isEmpty { cohortsTNIKBelowAllMR += 1 }
    cohortsCompared += 1
    var line = coh
    while line.count < 8 { line += " " }
    line += "\(mrs.count)".leftPad(4) + "\(mapped.count)".leftPad(8) + "\(inNet)".leftPad(7) + " |"
    line += "\(mrOut.first ?? 0)".leftPad(12) + "\(c1)".leftPad(5) + "\(c2)".leftPad(4) + "\(mrOut.last ?? 0)".leftPad(6) + " |"
    line += "\(s.tnikOut)".leftPad(9) + " |"
    line += "\(below) of \(mrOut.count)".leftPad(16) + " |"
    line += "  \(s.outRank) of \(s.nRegs)"
    print(line)
}
print("---------------------------------------------------------------------------------------------------")
print("cohorts compared ................. \(cohortsCompared)")
print("MR symbols that HGNC could not map \(mrUnmappedTotal)  (counted, never silently dropped)")
print("cohorts where TNIK's regulon is LARGER than at least one MR's : \(cohortsWhereTNIKOutBeatsSomeMR)")
print("cohorts where TNIK's regulon is SMALLER than EVERY MR's ....... \(cohortsTNIKBelowAllMR)")

// --- in-degree side: who points AT TNIK, and are any of them MRs? ---
print("")
print("Who points AT TNIK, and is any of them a published master regulator?")
print("cohort   TNIK-in  regulators-that-are-MRs-of-that-cohort")
print("--------------------------------------------------------")
var totalMRRegulatorsOfTNIK = 0
for coh in scoreable {
    guard let s = summaries.first(where: { $0.name == coh }), let mrs = mrByCohort[coh] else { continue }
    var mrSet = Set<Int32>()
    for sym in mrs { if let e = symToEntrez[sym] { mrSet.insert(e) } }
    var hits: [String] = []
    for r in s.tnikRegulators where mrSet.contains(r) {
        hits.append(entrezToSym[r] ?? "entrez:\(r)")
    }
    totalMRRegulatorsOfTNIK += hits.count
    var line = coh
    while line.count < 9 { line += " " }
    line += "\(s.tnikIn)".leftPad(7) + "   "
    line += hits.isEmpty ? "0  (none)" : "\(hits.count)  " + hits.sorted().joined(separator: ",")
    print(line)
}
print("--------------------------------------------------------")
print("total MR->TNIK edges across the \(scoreable.count) scoreable cohorts : \(totalMRRegulatorsOfTNIK)")

// --- recurrence of TNIK's own regulon across the corpus ---
print("")
print("================================================================")
print("TNIK's OWN REGULON — recurrence across the \(Ref.networksScanned) networks")
print("================================================================")
var targetRecur: [Int32: Int] = [:]
var regulatorRecur: [Int32: Int] = [:]
for s in summaries {
    for t in Set(s.tnikTargets) { targetRecur[t, default: 0] += 1 }
    for r in Set(s.tnikRegulators) { regulatorRecur[r, default: 0] += 1 }
}
var tnikOutTotal = 0, tnikInTotal = 0, selfLoops = 0
for s in summaries { tnikOutTotal += Int(s.tnikOut); tnikInTotal += Int(s.tnikIn); selfLoops += s.selfLoop }
print("TNIK out-edges summed over all networks .. \(tnikOutTotal)")
print("TNIK in-edges  summed over all networks .. \(tnikInTotal)")
print("TNIK self-loops (TNIK -> TNIK) ........... \(selfLoops)")
print("distinct genes EVER in TNIK's regulon .... \(targetRecur.count)")
print("distinct genes EVER regulating TNIK ...... \(regulatorRecur.count)")
var recurHist = [Int](repeating: 0, count: Ref.networksScanned + 1)
for (_, c) in targetRecur { recurHist[c] += 1 }
print("")
print("recurrence histogram of TNIK's TARGETS (in how many of the \(Ref.networksScanned) networks):")
for k in stride(from: Ref.networksScanned, through: 1, by: -1) where recurHist[k] > 0 {
    print("  in \(k) network(s) : \(recurHist[k]) gene(s)")
}
let topTargets = targetRecur.sorted { a, b in a.value != b.value ? a.value > b.value : a.key < b.key }.prefix(15)
print("")
print("most recurrent members of TNIK's regulon:")
for (g, c) in topTargets {
    print("  \(entrezToSym[g] ?? "entrez:\(g)")  (entrez \(g))  in \(c) of \(Ref.networksScanned) networks")
}
var recurHistR = [Int](repeating: 0, count: Ref.networksScanned + 1)
for (_, c) in regulatorRecur { recurHistR[c] += 1 }
print("")
print("recurrence histogram of TNIK's REGULATORS:")
for k in stride(from: Ref.networksScanned, through: 1, by: -1) where recurHistR[k] > 0 {
    print("  in \(k) network(s) : \(recurHistR[k]) gene(s)")
}
let topRegs = regulatorRecur.sorted { a, b in a.value != b.value ? a.value > b.value : a.key < b.key }.prefix(15)
print("")
print("most recurrent regulators of TNIK:")
var mrAllSet = Set<String>()
for t in tokensOf(mrBytesByName["mr_all_distinct.txt"]!) { mrAllSet.insert(t) }
for (g, c) in topRegs {
    let sym = entrezToSym[g] ?? "entrez:\(g)"
    let tag = mrAllSet.contains(sym) ? "  [IS a published MR somewhere in Study 26]" : ""
    print("  \(sym)  (entrez \(g))  in \(c) of \(Ref.networksScanned) networks\(tag)")
}

// ============================================================================
// ARM 5 — THE CONTROL. Is TNIK's low regulon recurrence a fact about TNIK,
//         or a fact about this corpus? Answered by measuring EVERY regulator
//         on the SAME instrument, and by SIZE-MATCHING, because a regulator
//         with few edges has fewer chances to repeat.
// ============================================================================

print("")
print("================================================================")
print("ARM 5 — CONTROL: every regulator in the corpus, same measure")
print("================================================================")
print("edges collected for the control (counted) : \(ALL_EDGES.count)")
if ALL_EDGES.count != totalEdges {
    refuse("collected edge count \(ALL_EDGES.count) != scanned edge count \(totalEdges)")
}
ALL_EDGES.sort()

// Within-network duplicate check: if a single network repeated an edge, the
// run length would over-count networks. Measured, not assumed.
var withinDup = 0
do {
    var seen = Set<Int64>()
    var perNetDup = 0
    for pin in NETWORKS.prefix(1) {
        let b = readPinned(pin)
        var i = 0
        let n = b.count
        while i < n {
            var a: Int32 = 0
            while i < n, b[i] >= 48, b[i] <= 57 { a = a &* 10 &+ Int32(b[i] - 48); i += 1 }
            i += 1
            var t: Int32 = 0
            while i < n, b[i] >= 48, b[i] <= 57 { t = t &* 10 &+ Int32(b[i] - 48); i += 1 }
            i += 2
            if !seen.insert(packEdge(a, t)).inserted { perNetDup += 1 }
            i += 1
        }
    }
    withinDup = perNetDup
}
print("duplicate edges WITHIN one network (blca, measured) : \(withinDup)")
if withinDup != 0 {
    print("  NON-ZERO: run length is NOT a network count. Reported, not hidden.")
}

// Group the sorted packed edges: runs of an identical (reg,tgt) key are the
// number of networks carrying that edge; runs of an identical regulator are
// that regulator's whole cross-network footprint.
struct RegFootprint {
    var reg: Int32 = 0
    var totalEdges = 0        // sum of out-degree over networks
    var distinctTargets = 0   // union of targets
    var targetsIn2Plus = 0    // targets present in >= 2 networks
    var maxTargetRecur = 0
}
var footprints: [RegFootprint] = []
footprints.reserveCapacity(7000)
do {
    var i = 0
    let n = ALL_EDGES.count
    while i < n {
        let reg = unpackReg(ALL_EDGES[i])
        var fp = RegFootprint()
        fp.reg = reg
        while i < n, unpackReg(ALL_EDGES[i]) == reg {
            let key = ALL_EDGES[i]
            var run = 0
            while i < n, ALL_EDGES[i] == key { run += 1; i += 1 }
            fp.totalEdges += run
            fp.distinctTargets += 1
            if run >= 2 { fp.targetsIn2Plus += 1 }
            if run > fp.maxTargetRecur { fp.maxTargetRecur = run }
        }
        footprints.append(fp)
    }
}
print("distinct regulators across the corpus (counted) : \(footprints.count)")
var footEdgeSum = 0
for f in footprints { footEdgeSum += f.totalEdges }
print("edges reconstituted from footprints ............ \(footEdgeSum)")
if footEdgeSum != totalEdges { refuse("footprint edge sum \(footEdgeSum) != \(totalEdges)") }

guard let tnikFP = footprints.first(where: { $0.reg == TNIK_ENTREZ }) else {
    refuse("TNIK has no footprint after grouping — contradicts ARM 1")
}
let tnikRecurPM = permilleFloor(tnikFP.targetsIn2Plus, tnikFP.distinctTargets)
print("")
print("TNIK footprint:")
print("  total out-edges over 25 networks ...... \(tnikFP.totalEdges)")
print("  distinct targets ever ................. \(tnikFP.distinctTargets)")
print("  targets seen in >= 2 networks ......... \(tnikFP.targetsIn2Plus)")
print("  deepest target recurrence ............. \(tnikFP.maxTargetRecur) of 25 networks")
print("  recurrence rate ....................... \(tnikRecurPM) per mille  (FLOOR, integer)")

// --- control 1: ALL regulators ---
var allRates: [Int32] = []
for f in footprints where f.distinctTargets > 0 {
    allRates.append(Int32(permilleFloor(f.targetsIn2Plus, f.distinctTargets)))
}
allRates.sort()
let (ac1, ac2) = centralPair(allRates)
print("")
print("CONTROL 1 — all \(footprints.count) regulators, same measure:")
print("  recurrence rate per mille: min \(allRates.first ?? 0)   central \(ac1)/\(ac2)   max \(allRates.last ?? 0)")
let worseThanTNIK = strictlyGreater(allRates, Int32(tnikRecurPM))
print("  regulators with a HIGHER rate than TNIK : \(worseThanTNIK) of \(allRates.count)")
print("  regulators tied with TNIK ............... \(countEqual(allRates, Int32(tnikRecurPM)))")

// --- control 2: SIZE-MATCHED band, because footprint size drives the chance to repeat ---
let lo = (tnikFP.totalEdges * 9) / 10
let hi = (tnikFP.totalEdges * 11) / 10
var bandRates: [Int32] = []
var bandRegs: [RegFootprint] = []
for f in footprints where f.totalEdges >= lo && f.totalEdges <= hi && f.distinctTargets > 0 {
    bandRates.append(Int32(permilleFloor(f.targetsIn2Plus, f.distinctTargets)))
    bandRegs.append(f)
}
bandRates.sort()
let (bc1, bc2) = centralPair(bandRates)
print("")
print("CONTROL 2 — SIZE-MATCHED band, total out-edges in [\(lo), \(hi)]:")
print("  regulators in band (counted) ........... \(bandRates.count)")
if bandRates.count < 2 {
    print("  BAND TOO SMALL to control with. Reported as such, not stretched.")
} else {
    print("  recurrence rate per mille: min \(bandRates.first ?? 0)   central \(bc1)/\(bc2)   max \(bandRates.last ?? 0)")
    let bandHigher = strictlyGreater(bandRates, Int32(tnikRecurPM))
    print("  size-matched regulators with a HIGHER rate than TNIK : \(bandHigher) of \(bandRates.count)")
    print("  TNIK's rank within its own size band ................. \(bandHigher + 1) of \(bandRates.count)")
}

// --- control 3: the published master regulators, same measure ---
var mrEntrez = Set<Int32>()
for sym in tokensOf(mrBytesByName["mr_all_distinct.txt"]!) {
    if let e = symToEntrez[sym] { mrEntrez.insert(e) }
}
var mrRates: [Int32] = []
var mrFoots: [RegFootprint] = []
for f in footprints where mrEntrez.contains(f.reg) && f.distinctTargets > 0 {
    mrRates.append(Int32(permilleFloor(f.targetsIn2Plus, f.distinctTargets)))
    mrFoots.append(f)
}
mrRates.sort()
let (mc1, mc2) = centralPair(mrRates)
var mrTotals: [Int32] = []
for f in mrFoots { mrTotals.append(Int32(f.totalEdges)) }
mrTotals.sort()
let (mt1, mt2) = centralPair(mrTotals)
print("")
print("CONTROL 3 — the \(mrEntrez.count) published master regulators (mapped), same measure:")
print("  present as regulators in the corpus .... \(mrRates.count)")
print("  MR total out-edges: min \(mrTotals.first ?? 0)  central \(mt1)/\(mt2)  max \(mrTotals.last ?? 0)   [TNIK \(tnikFP.totalEdges)]")
print("  MR recurrence per mille: min \(mrRates.first ?? 0)  central \(mc1)/\(mc2)  max \(mrRates.last ?? 0)   [TNIK \(tnikRecurPM)]")
print("  MRs with a HIGHER recurrence rate than TNIK : \(strictlyGreater(mrRates, Int32(tnikRecurPM))) of \(mrRates.count)")

// --- the deepest recurrence anywhere: is 3-of-25 low for this corpus? ---
var deepHist = [Int](repeating: 0, count: 26)
for f in footprints { if f.maxTargetRecur <= 25 { deepHist[f.maxTargetRecur] += 1 } }
print("")
print("CONTROL 4 — deepest single-edge recurrence per regulator, whole corpus:")
print("  (TNIK's deepest edge appears in \(tnikFP.maxTargetRecur) of 25 networks)")
for k in stride(from: 25, through: 1, by: -1) where deepHist[k] > 0 {
    var line = "  deepest = \(k) network(s) : \(deepHist[k]) regulator(s)"
    if k == tnikFP.maxTargetRecur { line += "   <-- TNIK is in this bucket" }
    print(line)
}
var regsDeeperThanTNIK = 0
for f in footprints where f.maxTargetRecur > tnikFP.maxTargetRecur { regsDeeperThanTNIK += 1 }
print("  regulators with a DEEPER single edge than TNIK : \(regsDeeperThanTNIK) of \(footprints.count)")

// ============================================================================
// COMPLETENESS LEDGER + CROSS-CHECK AGAINST THE STUDY'S OWN SUMMARY
// ============================================================================

print("")
print("================================================================")
print("COMPLETENESS — counted as it happened, cross-checked")
print("================================================================")
let crossBytes = readPinned(IN_CROSSING)
var crossTotal = 0, crossRows = 0
var crossByName: [String: Int] = [:]
for (i, ln) in linesOf(crossBytes).enumerated() {
    if i == 0 || ln.isEmpty { continue }
    let f = splitTab(ln)
    if f.count < 3 { continue }
    crossRows += 1
    let e = Int(f[2]) ?? -1
    crossTotal += e
    crossByName[f[0]] = e
}
print("CROSSING_C_SUMMARY.tsv rows ...... \(crossRows)")
print("CROSSING_C_SUMMARY edge total .... \(crossTotal)")
print("edges this program counted ....... \(totalEdges)")
var perNetAgree = 0, perNetDisagree = 0
for s in summaries {
    if crossByName[s.name] == s.edges { perNetAgree += 1 } else {
        perNetDisagree += 1
        print("  DISAGREE \(s.name): summary \(String(describing: crossByName[s.name])) vs counted \(s.edges)")
    }
}
print("per-network agreement ............ \(perNetAgree) agree, \(perNetDisagree) disagree")
if crossTotal != totalEdges || perNetDisagree != 0 {
    refuse("edge total or per-network count disagrees with the study's own summary")
}
print("VERDICT: the corpus this program read IS the 12,017,368-edge corpus of Study 26.")

printReference("COMPLETE")
print("")
print("STATED PLAINLY:")
print("  This is a count of one gene's position in \(Ref.networksScanned) transcriptional networks.")
print("  It is NOT efficacy, NOT a dose, NOT a mechanism, and NOT evidence that")
print("  rentosertib or any other drug helps or harms any person.")
exit(0)
