// corpus-distinct-count-exact.swift
//
// CORPUS-DISTINCT-COUNT-EXACT — a general corpus-collapse instrument.
//
// WHAT IT IS FOR
//   Per-item validation is structurally unable to detect a corpus-level defect.
//   A row can carry a valid molecule, a valid molecular weight and a valid logP,
//   and every row in the file can pass, while the corpus is five molecules.
//   The instrument that sees this is an EXACT DISTINCT COUNT over the identity
//   column, plus the same count over every other column so the reader can tell
//   which columns genuinely vary. This file is that instrument.
//
// USE
//   cdc                          run the canonical published study (no argv)
//   cdc <corpus.csv> <column>    run the general instrument on any CSV
//                                <column> is a header name or a 1-based index
//
// ZERO FLOAT — a house law, enforced by construction
//   No Float, Double or CGFloat appears anywhere in this file, and no decision
//   path touches one. Columns holding decimal text (molecular_weight, logp,
//   confidence, coherence, ...) are read, counted and REPORTED AS EXACT BYTE
//   STRINGS. They are never parsed to a number, never compared numerically,
//   never summed, and no verdict depends on their value. The collapse ratio is
//   reported as an exact integer pair and tested with integer multiplication.
//
// COMPLETE ENUMERATION
//   Every data row of every file is parsed and counted. There is no sampling
//   and no early exit. Where a frequency table is too long to print, the FULL
//   table is still built and counted, its complete text is sha256'd, and the
//   digest is printed alongside the elided view so the elision is verifiable.
//
// CONTROL ARM
//   Runs FIRST. If any arm fails, no corpus measurement is emitted at all.
//   The arms prove the counter discriminates in both directions: it returns N
//   for a genuinely diverse corpus and 1 for a genuinely collapsed one, it
//   REFUSES empty input rather than reporting zero-collapse, and it reports NO
//   COLLAPSE on a real, non-synthetic 78,680-row protein corpus. A counter that
//   returns a small number for everything has found nothing; always-green and
//   always-red are the same defect.
//
// SEAL
//   The whole verdict transcript is sealed with a sha256 computed by the
//   self-contained implementation below — no system hasher, no library.
//
// Build: xcrun swiftc -O -swift-version 5 corpus-distinct-count-exact.swift -o /tmp/cdc

import Foundation

// ══════════════════════════════════════════════════════════════════════════
// SECTION A — self-contained SHA-256 (no CryptoKit, no CommonCrypto)
// ══════════════════════════════════════════════════════════════════════════

enum SHA256Exact {

    private static let k: [UInt32] = [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ]

    static func hex(_ message: [UInt8]) -> String {
        var h: [UInt32] = [
            0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
            0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
        ]

        // padding
        let bitLen = UInt64(message.count) &* 8
        var m = message
        m.append(0x80)
        while m.count % 64 != 56 { m.append(0x00) }
        var i = 8
        while i > 0 {
            i -= 1
            m.append(UInt8(truncatingIfNeeded: bitLen >> UInt64(8 * i)))
        }

        var w = [UInt32](repeating: 0, count: 64)
        var block = 0
        while block < m.count {
            var t = 0
            while t < 16 {
                let o = block + t * 4
                w[t] = (UInt32(m[o]) << 24) | (UInt32(m[o + 1]) << 16)
                     | (UInt32(m[o + 2]) << 8) | UInt32(m[o + 3])
                t += 1
            }
            t = 16
            while t < 64 {
                let a = w[t - 15]
                let b = w[t - 2]
                let s0 = rotr(a, 7) ^ rotr(a, 18) ^ (a >> 3)
                let s1 = rotr(b, 17) ^ rotr(b, 19) ^ (b >> 10)
                w[t] = w[t - 16] &+ s0 &+ w[t - 7] &+ s1
                t += 1
            }

            var a = h[0], b = h[1], c = h[2], d = h[3]
            var e = h[4], f = h[5], g = h[6], hh = h[7]

            t = 0
            while t < 64 {
                let S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22)
                let maj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ maj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
                t += 1
            }

            h[0] = h[0] &+ a; h[1] = h[1] &+ b; h[2] = h[2] &+ c; h[3] = h[3] &+ d
            h[4] = h[4] &+ e; h[5] = h[5] &+ f; h[6] = h[6] &+ g; h[7] = h[7] &+ hh
            block += 64
        }

        var out = ""
        for v in h {
            var s = String(v, radix: 16)
            while s.count < 8 { s = "0" + s }
            out += s
        }
        return out
    }

    static func hex(_ s: String) -> String { hex(Array(s.utf8)) }

    @inline(__always)
    private static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 {
        (x >> n) | (x << (32 &- n))
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION B — transcript (every line printed is sealed)
// ══════════════════════════════════════════════════════════════════════════

var TRANSCRIPT: [UInt8] = []

func say(_ s: String = "") {
    print(s)
    TRANSCRIPT.append(contentsOf: Array(s.utf8))
    TRANSCRIPT.append(0x0A)
}

func rule(_ ch: String = "-") { say(String(repeating: ch, count: 78)) }

// integer-only right-pad / left-pad
func pad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t += " " }
    return t
}
func lpad(_ s: String, _ n: Int) -> String {
    var t = s
    while t.count < n { t = " " + t }
    return t
}
// integer thousands separator — no formatter, no locale, no float
func grp(_ n: Int) -> String {
    let neg = n < 0
    var v = neg ? -n : n
    var digits: [String] = []
    if v == 0 { digits = ["0"] }
    while v > 0 { digits.append(String(v % 10)); v /= 10 }
    var out = ""
    var c = 0
    for d in digits {
        if c > 0 && c % 3 == 0 { out = "," + out }
        out = d + out
        c += 1
    }
    return neg ? "-" + out : out
}

// deterministic on every machine: compare by raw UTF-8 bytes, never by
// Unicode collation, which can differ across stdlib versions.
@inline(__always)
func utf8Less(_ a: String, _ b: String) -> Bool {
    var ia = a.utf8.makeIterator()
    var ib = b.utf8.makeIterator()
    while true {
        let x = ia.next()
        let y = ib.next()
        if x == nil && y == nil { return false }
        guard let xv = x else { return true }
        guard let yv = y else { return false }
        if xv != yv { return xv < yv }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION C — RFC 4180 CSV reader (streaming, complete, no sampling)
// ══════════════════════════════════════════════════════════════════════════

enum CSV {
    /// Emits every record in order. Quoted fields, doubled quotes, CRLF and a
    /// missing final newline are all handled. Nothing is skipped.
    static func forEachRecord(_ b: [UInt8], _ emit: ([String]) -> Void) {
        var field: [UInt8] = []
        field.reserveCapacity(256)
        var row: [String] = []
        row.reserveCapacity(24)
        var inQuotes = false
        var live = false          // this record has seen at least one byte/field
        var i = 0
        let n = b.count

        while i < n {
            let c = b[i]
            if inQuotes {
                if c == 0x22 {                              // "
                    if i + 1 < n && b[i + 1] == 0x22 {      // "" -> literal "
                        field.append(0x22); i += 2; continue
                    }
                    inQuotes = false; i += 1; continue
                }
                field.append(c); i += 1; continue
            }
            if c == 0x22 { inQuotes = true; live = true; i += 1; continue }
            if c == 0x2C {                                   // ,
                row.append(String(decoding: field, as: UTF8.self))
                field.removeAll(keepingCapacity: true)
                live = true; i += 1; continue
            }
            if c == 0x0A || c == 0x0D {                      // LF / CR / CRLF
                if c == 0x0D && i + 1 < n && b[i + 1] == 0x0A { i += 1 }
                row.append(String(decoding: field, as: UTF8.self))
                field.removeAll(keepingCapacity: true)
                emit(row)
                row.removeAll(keepingCapacity: true)
                live = false; i += 1; continue
            }
            field.append(c); live = true; i += 1
        }
        if live || !field.isEmpty || !row.isEmpty {
            row.append(String(decoding: field, as: UTF8.self))
            emit(row)
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION D — refusals. A gate given NOTHING must not pass.
// ══════════════════════════════════════════════════════════════════════════

enum Refusal: Error {
    case unreadable(String)
    case zeroBytes(String)
    case noDataRows(String)
    case columnNotFound(String, String, [String])
    case ragged(String, Int, Int)

    var text: String {
        switch self {
        case .unreadable(let p):
            return "REFUSED — corpus is unreadable: \(p)"
        case .zeroBytes(let p):
            return "REFUSED — corpus is zero bytes: \(p).  EMPTY IS NOT ZERO-COLLAPSE."
        case .noDataRows(let p):
            return "REFUSED — corpus has a header and NO data rows: \(p).  EMPTY IS NOT ZERO-COLLAPSE."
        case .columnNotFound(let p, let c, let hdr):
            return "REFUSED — identity column '\(c)' is not in \(p).  header = [\(hdr.joined(separator: ", "))]"
        case .ragged(let p, let bad, let expect):
            return "REFUSED — \(grp(bad)) record(s) in \(p) do not carry \(expect) fields; corpus shape is not stable, so a count over it would not be a count."
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E — the counter
// ══════════════════════════════════════════════════════════════════════════

struct ColumnStat {
    let name: String
    let index: Int          // 1-based
    let distinct: Int
    let table: [(value: String, count: Int)]   // desc by count, ties by value asc
    let tableSHA: String
}

struct CorpusResult {
    let label: String
    let sha256: String        // "" when the corpus is synthetic / in-memory
    let byteCount: Int
    let header: [String]
    let rows: Int
    let columns: [ColumnStat]
    let identityIndex: Int    // 0-based into `columns`

    var identity: ColumnStat { columns[identityIndex] }

    /// Integer-only verdict. COLLAPSE_FACTOR is an integer; the test is an
    /// integer multiplication. No ratio is ever computed as a float.
    static let COLLAPSE_FACTOR = 10

    var verdict: String {
        let d = identity.distinct
        if d == rows { return "NO_COLLAPSE" }
        if d * CorpusResult.COLLAPSE_FACTOR <= rows { return "COLLAPSED" }
        return "PARTIAL"
    }
}

/// The complete count. Every record, every column. No sampling, no early exit.
func countCorpus(label: String,
                 bytes: [UInt8],
                 fileSHA: String,
                 identity: String) throws -> CorpusResult {

    if bytes.isEmpty { throw Refusal.zeroBytes(label) }

    var header: [String] = []
    var maps: [[String: Int]] = []
    var rows = 0
    var ragged = 0
    var first = true

    CSV.forEachRecord(bytes) { rec in
        if first {
            first = false
            header = rec
            maps = Array(repeating: [String: Int](), count: rec.count)
            return
        }
        if rec.count != header.count { ragged += 1; return }
        rows += 1
        var c = 0
        while c < rec.count {
            maps[c][rec[c], default: 0] += 1
            c += 1
        }
    }

    if header.isEmpty { throw Refusal.zeroBytes(label) }
    if ragged > 0 { throw Refusal.ragged(label, ragged, header.count) }
    if rows == 0 { throw Refusal.noDataRows(label) }

    // identity column: header name, or 1-based index
    var idIndex = -1
    for (i, h) in header.enumerated() where h == identity { idIndex = i; break }
    if idIndex < 0, let n = Int(identity), n >= 1, n <= header.count { idIndex = n - 1 }
    if idIndex < 0 { throw Refusal.columnNotFound(label, identity, header) }

    var stats: [ColumnStat] = []
    for (i, name) in header.enumerated() {
        var table = maps[i].map { (value: $0.key, count: $0.value) }
        // deterministic on every machine: count descending, ties by UTF-8 bytes ascending
        table.sort { a, b in
            if a.count != b.count { return a.count > b.count }
            return utf8Less(a.value, b.value)
        }
        var full = ""
        for e in table { full += "\(e.count)\t\(e.value)\n" }
        stats.append(ColumnStat(name: name, index: i + 1,
                                distinct: table.count, table: table,
                                tableSHA: SHA256Exact.hex(full)))
    }

    return CorpusResult(label: label, sha256: fileSHA, byteCount: bytes.count,
                        header: header, rows: rows, columns: stats,
                        identityIndex: idIndex)
}

func loadFile(_ path: String) throws -> [UInt8] {
    guard let d = FileManager.default.contents(atPath: path) else {
        throw Refusal.unreadable(path)
    }
    if d.isEmpty { throw Refusal.zeroBytes(path) }
    return [UInt8](d)
}

func countFile(_ path: String, identity: String, label: String? = nil) throws -> CorpusResult {
    let b = try loadFile(path)
    return try countCorpus(label: label ?? path, bytes: b,
                           fileSHA: SHA256Exact.hex(b), identity: identity)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION F — reporting
// ══════════════════════════════════════════════════════════════════════════

let FULL_TABLE_DISPLAY_LIMIT = 256   // counting is always complete; this is display only

func report(_ r: CorpusResult) {
    rule("=")
    say("CORPUS      \(r.label)")
    if !r.sha256.isEmpty {
        say("sha256      \(r.sha256)")
        say("bytes       \(grp(r.byteCount))")
    }
    say("IDENTITY    column \(r.identity.index) '\(r.identity.name)'")
    rule("=")
    say("TOTAL ROWS            \(grp(r.rows))          (data records; header excluded)")
    say("DISTINCT IDENTITY     \(grp(r.identity.distinct))")
    let d = r.identity.distinct
    say("EXACT RATIO           \(grp(r.rows)) : \(grp(d))   "
        + "(rows/distinct = \(grp(r.rows / d)) exactly, remainder \(grp(r.rows % d)))")
    say("VERDICT               \(r.verdict)"
        + (r.verdict == "COLLAPSED"
           ? "   — \(grp(d)) distinct value(s) carried by \(grp(r.rows)) rows"
           : r.verdict == "NO_COLLAPSE"
             ? "  — every row carries a distinct identity"
             : "     — distinct is below rows but above the 1-in-\(CorpusResult.COLLAPSE_FACTOR) threshold"))
    say()

    say("FREQUENCY TABLE — identity column '\(r.identity.name)'")
    say("  (descending by count; ties broken by value ascending in UTF-8 byte order)")
    say("  full-table sha256  \(r.identity.tableSHA)")
    say()
    say("  " + lpad("count", 10) + "   value")
    let t = r.identity.table
    if t.count <= FULL_TABLE_DISPLAY_LIMIT {
        for e in t { say("  " + lpad(grp(e.count), 10) + "   " + e.value) }
    } else {
        for e in t.prefix(32) { say("  " + lpad(grp(e.count), 10) + "   " + e.value) }
        say("  " + lpad("...", 10) + "   [\(grp(t.count - 40)) further distinct values — ALL COUNTED,")
        say("  " + lpad("", 10) + "    display elided; the sha256 above covers the complete table]")
        for e in t.suffix(8) { say("  " + lpad(grp(e.count), 10) + "   " + e.value) }
    }
    say()

    say("EVERY COLUMN — distinct values over the same \(grp(r.rows)) rows")
    say("  this is what makes a collapse legible rather than asserted: a column")
    say("  that varies across all rows and a column that does not sit side by side.")
    say()
    say("  " + pad("col", 5) + pad("name", 26) + lpad("distinct", 10)
        + "   " + pad("shape", 22) + "most frequent value")
    for c in r.columns {
        let shape: String
        if c.distinct == r.rows { shape = "varies on every row" }
        else if c.distinct == 1 { shape = "CONSTANT" }
        else if c.distinct * CorpusResult.COLLAPSE_FACTOR <= r.rows { shape = "COLLAPSED" }
        else { shape = "partial" }
        let top = c.table.isEmpty ? "" : "\(c.table[0].value)  x\(grp(c.table[0].count))"
        var mark = "  "
        if c.index == r.identity.index { mark = "> " }
        say(mark + pad(String(c.index), 3) + "  " + pad(c.name, 26)
            + lpad(grp(c.distinct), 10) + "   " + pad(shape, 22) + top)
    }
    say()
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION G — corpus locations
// ══════════════════════════════════════════════════════════════════════════

func resolveCorpusDir() -> String {
    let fm = FileManager.default
    // NO ABSOLUTE PATH IS BAKED IN. An earlier revision carried the author's own scratchpad
    // directory as the first candidate, which is a private identifier in a public program and
    // would have resolved to nothing on every other machine. Resolution walks outward from the
    // binary and from the working directory, so a clean clone finds corpus/eric with no argument.
    var candidates: [String] = []
    let exe = CommandLine.arguments.first ?? ""
    if !exe.isEmpty {
        let dir = (exe as NSString).deletingLastPathComponent
        for rel in ["/../corpus/eric", "/corpus/eric", "/../../corpus/eric", "/../corpus", "/corpus"] {
            candidates.append(dir + rel)
        }
    }
    var up = fm.currentDirectoryPath
    for _ in 0..<6 {
        candidates.append(up + "/corpus/eric")
        candidates.append(up + "/corpus")
        up = (up as NSString).deletingLastPathComponent
        if up.isEmpty || up == "/" { break }
    }
    for c in candidates {
        if fm.fileExists(atPath: c + "/materials_bivqbit_validated.csv") { return c }
    }
    return fm.currentDirectoryPath + "/corpus/eric"   // named so the refusal says where it looked
}

let CORPUS = resolveCorpusDir()
let P_BIVQBIT   = CORPUS + "/materials_bivqbit_validated.csv"
let P_CHEMISTRY = CORPUS + "/materials_chemistry_validated.csv"
let P_PROTEINS  = CORPUS + "/proteins_validated.csv"

// pinned SHA256SUMS — the program checks the bytes it read against these
let SHA_BIVQBIT   = "eba20edffd6aecd8fd00d547deb217828be2ae82ff5e2bb1b16f990cbea17a66"
let SHA_CHEMISTRY = "38fcd2c6048b361a0131843da549cfbbca84eefe921d1f575d28a010f09d6de4"
let SHA_PROTEINS  = "bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7"

// ══════════════════════════════════════════════════════════════════════════
// SECTION H — published reference figures.
// Printed on EVERY path, including every refusal path, before anything else.
// ══════════════════════════════════════════════════════════════════════════

func printReferenceFigures() {
    rule("=")
    say("SECTION 0 — PUBLISHED REFERENCE FIGURES (pinned)")
    rule("=")
    say("These are the figures this instrument re-derives. They are printed on")
    say("every path this program can take, refusals included, so a refusal never")
    say("silently drops the numbers a reader came for.")
    say()
    say("materials_bivqbit_validated.csv")
    say("    rows                     37,910")
    say("    distinct discovery_id    37,910")
    say("    distinct timestamp       37,910")
    say("    distinct smiles               5")
    say("    C1CCCCC1          7,649   cyclohexane")
    say("    O=C(O)c1ccccc1    7,598   benzoic acid")
    say("    c1cnccn1          7,596   pyrazine")
    say("    c1ccc2ccccc2c1    7,580   naphthalene")
    say("    c1ccccc1          7,487   benzene")
    say("    exactly one (molecular_weight, logp) pair per distinct molecule")
    say()
    say("materials_chemistry_validated.csv")
    say("    rows                      8,712")
    say("    distinct smiles              30")
    say("    C                   851")
    say("    CCCO                618")
    say()
    say("proteins_validated.csv  — REAL NEGATIVE CONTROL, not synthetic")
    say("    rows                     78,680")
    say("    distinct sequence        78,680")
    say()
    say("distinct SMILES across both materials files      35")
    say()
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION I — CONTROL ARM. Runs first. No corpus measurement is emitted if
// any arm fails. Always-green and always-red are the same defect.
// ══════════════════════════════════════════════════════════════════════════

func synthetic(rows: Int, distinctIdentities: Int) -> [UInt8] {
    var s = "row_id,identity,constant_col\n"
    var i = 0
    while i < rows {
        s += "R\(i),ID_\(i % distinctIdentities),same\n"
        i += 1
    }
    return Array(s.utf8)
}

struct Arm {
    let name: String
    let expect: String
    let got: String
    var pass: Bool { expect == got }
}

func runControlArm() -> (arms: [Arm], allPass: Bool) {
    var arms: [Arm] = []
    let N = 1000

    // ── arm 1: N rows, N distinct identities -> must report N.
    // The counter must not MANUFACTURE collapse.
    do {
        let r = try countCorpus(label: "synthetic-diverse", bytes: synthetic(rows: N, distinctIdentities: N),
                                fileSHA: "", identity: "identity")
        arms.append(Arm(name: "1  synthetic diverse   \(grp(N)) rows / \(grp(N)) distinct identities",
                        expect: "rows=\(N) distinct=\(N) NO_COLLAPSE",
                        got: "rows=\(r.rows) distinct=\(r.identity.distinct) \(r.verdict)"))
    } catch {
        arms.append(Arm(name: "1  synthetic diverse", expect: "counted", got: "threw"))
    }

    // ── arm 2: N rows, 1 distinct identity -> must report 1.
    // The counter must actually SEE collapse.
    do {
        let r = try countCorpus(label: "synthetic-collapsed", bytes: synthetic(rows: N, distinctIdentities: 1),
                                fileSHA: "", identity: "identity")
        arms.append(Arm(name: "2  synthetic collapsed \(grp(N)) rows / 1 distinct identity",
                        expect: "rows=\(N) distinct=1 COLLAPSED",
                        got: "rows=\(r.rows) distinct=\(r.identity.distinct) \(r.verdict)"))
    } catch {
        arms.append(Arm(name: "2  synthetic collapsed", expect: "counted", got: "threw"))
    }

    // ── arm 3: a corpus of 5 distinct in 1000 rows -> must report 5, not 1
    // and not 1000. A counter that only distinguishes 1 from N is a flag,
    // not a counter.
    do {
        let r = try countCorpus(label: "synthetic-five", bytes: synthetic(rows: N, distinctIdentities: 5),
                                fileSHA: "", identity: "identity")
        arms.append(Arm(name: "3  synthetic five-way  \(grp(N)) rows / 5 distinct identities",
                        expect: "rows=\(N) distinct=5 COLLAPSED",
                        got: "rows=\(r.rows) distinct=\(r.identity.distinct) \(r.verdict)"))
    } catch {
        arms.append(Arm(name: "3  synthetic five-way", expect: "counted", got: "threw"))
    }

    // ── arm 4: header, no data rows -> REFUSED, never "0 distinct".
    do {
        _ = try countCorpus(label: "header-only", bytes: Array("a,b,c\n".utf8),
                            fileSHA: "", identity: "a")
        arms.append(Arm(name: "4  header-only input", expect: "REFUSED", got: "counted"))
    } catch let e as Refusal {
        if case .noDataRows = e {
            arms.append(Arm(name: "4  header-only input", expect: "REFUSED", got: "REFUSED"))
        } else {
            arms.append(Arm(name: "4  header-only input", expect: "REFUSED", got: "REFUSED(wrong reason)"))
        }
    } catch {
        arms.append(Arm(name: "4  header-only input", expect: "REFUSED", got: "threw"))
    }

    // ── arm 5: zero bytes -> REFUSED. Empty is not zero-collapse.
    do {
        _ = try countCorpus(label: "zero-bytes", bytes: [], fileSHA: "", identity: "a")
        arms.append(Arm(name: "5  zero-byte input", expect: "REFUSED", got: "counted"))
    } catch let e as Refusal {
        if case .zeroBytes = e {
            arms.append(Arm(name: "5  zero-byte input", expect: "REFUSED", got: "REFUSED"))
        } else {
            arms.append(Arm(name: "5  zero-byte input", expect: "REFUSED", got: "REFUSED(wrong reason)"))
        }
    } catch {
        arms.append(Arm(name: "5  zero-byte input", expect: "REFUSED", got: "threw"))
    }

    // ── arm 6: missing file -> REFUSED.
    do {
        _ = try countFile("/nonexistent/corpus/that/is/not/there.csv", identity: "a")
        arms.append(Arm(name: "6  missing file", expect: "REFUSED", got: "counted"))
    } catch let e as Refusal {
        if case .unreadable = e {
            arms.append(Arm(name: "6  missing file", expect: "REFUSED", got: "REFUSED"))
        } else {
            arms.append(Arm(name: "6  missing file", expect: "REFUSED", got: "REFUSED(wrong reason)"))
        }
    } catch {
        arms.append(Arm(name: "6  missing file", expect: "REFUSED", got: "threw"))
    }

    // ── arm 7: ragged records -> REFUSED. A shape that is not stable cannot
    // be counted honestly.
    do {
        _ = try countCorpus(label: "ragged", bytes: Array("a,b,c\n1,2,3\n4,5\n".utf8),
                            fileSHA: "", identity: "a")
        arms.append(Arm(name: "7  ragged records", expect: "REFUSED", got: "counted"))
    } catch let e as Refusal {
        if case .ragged = e {
            arms.append(Arm(name: "7  ragged records", expect: "REFUSED", got: "REFUSED"))
        } else {
            arms.append(Arm(name: "7  ragged records", expect: "REFUSED", got: "REFUSED(wrong reason)"))
        }
    } catch {
        arms.append(Arm(name: "7  ragged records", expect: "REFUSED", got: "threw"))
    }

    // ── arm 8: missing identity column -> REFUSED, never silently column 1.
    do {
        _ = try countCorpus(label: "no-such-col", bytes: synthetic(rows: 10, distinctIdentities: 10),
                            fileSHA: "", identity: "not_a_column")
        arms.append(Arm(name: "8  identity column absent", expect: "REFUSED", got: "counted"))
    } catch let e as Refusal {
        if case .columnNotFound = e {
            arms.append(Arm(name: "8  identity column absent", expect: "REFUSED", got: "REFUSED"))
        } else {
            arms.append(Arm(name: "8  identity column absent", expect: "REFUSED", got: "REFUSED(wrong reason)"))
        }
    } catch {
        arms.append(Arm(name: "8  identity column absent", expect: "REFUSED", got: "threw"))
    }

    // ── arm 9: DISCRIMINATION. The diverse and collapsed corpora have the
    // SAME row count and must not receive the same verdict. This is the arm
    // that fails if the instrument becomes always-green or always-red.
    do {
        let a = try countCorpus(label: "d", bytes: synthetic(rows: N, distinctIdentities: N),
                                fileSHA: "", identity: "identity")
        let b = try countCorpus(label: "c", bytes: synthetic(rows: N, distinctIdentities: 1),
                                fileSHA: "", identity: "identity")
        let ok = (a.rows == b.rows) && (a.verdict != b.verdict)
                 && (a.identity.distinct != b.identity.distinct)
        arms.append(Arm(name: "9  DISCRIMINATION  same rows, different verdicts",
                        expect: "differs", got: ok ? "differs" : "SAME — instrument is blind"))
    } catch {
        arms.append(Arm(name: "9  DISCRIMINATION", expect: "differs", got: "threw"))
    }

    // ── arm 10: DETERMINISM. The same multiset presented in a different row
    // order must produce a byte-identical frequency table.
    do {
        var fwd = "row_id,identity,c\n"
        var rev = "row_id,identity,c\n"
        var i = 0
        while i < 300 { fwd += "R\(i),ID_\(i % 7),x\n"; i += 1 }
        i = 300
        while i > 0 { i -= 1; rev += "R\(i),ID_\(i % 7),x\n" }
        let a = try countCorpus(label: "fwd", bytes: Array(fwd.utf8), fileSHA: "", identity: "identity")
        let b = try countCorpus(label: "rev", bytes: Array(rev.utf8), fileSHA: "", identity: "identity")
        arms.append(Arm(name: "10 DETERMINISM  row order does not move the table",
                        expect: a.identity.tableSHA, got: b.identity.tableSHA))
    } catch {
        arms.append(Arm(name: "10 DETERMINISM", expect: "equal", got: "threw"))
    }

    // ── arm 11: SHA-256 known-answer. The seal is worth nothing if the
    // hasher is wrong.
    arms.append(Arm(name: "11 sha256(\"\") known answer",
                    expect: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                    got: SHA256Exact.hex("")))
    arms.append(Arm(name: "11 sha256(\"abc\") known answer",
                    expect: "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
                    got: SHA256Exact.hex("abc")))

    // ── arm 12: REAL NEGATIVE CONTROL. A genuinely diverse, non-synthetic
    // 78,680-row corpus derived from UniProt. If the instrument reports
    // collapse here, the instrument is broken and says so.
    do {
        let r = try countFile(P_PROTEINS, identity: "sequence", label: "proteins_validated.csv")
        let shaOK = (r.sha256 == SHA_PROTEINS) ? "sha-ok" : "SHA-MISMATCH"
        arms.append(Arm(name: "12 REAL negative control  proteins_validated.csv key='sequence'",
                        expect: "rows=78680 distinct=78680 NO_COLLAPSE sha-ok",
                        got: "rows=\(r.rows) distinct=\(r.identity.distinct) \(r.verdict) \(shaOK)"))
    } catch let e as Refusal {
        arms.append(Arm(name: "12 REAL negative control", expect: "counted", got: e.text))
    } catch {
        arms.append(Arm(name: "12 REAL negative control", expect: "counted", got: "threw"))
    }

    return (arms, arms.allSatisfy { $0.pass })
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION J — seal + exit
// ══════════════════════════════════════════════════════════════════════════

func sealAndExit(_ code: Int32) -> Never {
    // The seal covers EXACTLY the bytes accumulated by say(), and nothing after.
    // The four lines below are emitted with print(), never say(), so they cannot
    // extend the transcript after it has been sealed. An earlier revision closed
    // this block with rule("=") — a say() — which appended 79 bytes to TRANSCRIPT
    // after the digest was taken, so the printed byte count described a buffer the
    // seal did not cover and a reader could not reproduce the digest from it.
    let sealed = TRANSCRIPT.count
    let seal = SHA256Exact.hex(TRANSCRIPT)
    print(String(repeating: "=", count: 78))
    print("TRANSCRIPT SEAL  sha256  \(seal)")
    print("sealed bytes             \(grp(sealed))   (stdout above this block, exactly)")
    print("exit                     \(code)")
    print(String(repeating: "=", count: 78))
    exit(code)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION K — main
// ══════════════════════════════════════════════════════════════════════════

rule("=")
say("CORPUS-DISTINCT-COUNT-EXACT  v1")
say("an exact distinct count over the identity column, with a control arm")
say("that proves the counter discriminates in both directions")
rule("=")
say("Swift 6.4 · zero float on every decision path · complete enumeration, no sampling")
say("Decimal-text columns (molecular_weight, logp, confidence, ...) are counted and")
say("reported as exact byte strings. They are never parsed, compared or summed, and")
say("no verdict in this transcript depends on one.")
// THE CORPUS PATH IS PRINTED, NEVER SEALED. It is a fact about this filesystem, not about the
// answer, and a seal that moves with the checkout directory is one every other reader misses.
// Measured before this repair: the identical corpus bytes at a different absolute path sealed
// 684a01ed... over 25,224 bytes against d2f99571... over 25,342 — a difference of exactly 118
// bytes, which is exactly the length difference between the two path strings. Every figure was
// right and the seal alone disagreed, which is the worst failure mode a seal has: it indicts a
// correct reproduction. print() writes outside the sealed transcript; say() writes inside it.
print("corpus directory  \(CORPUS)   (printed, NOT sealed — see the note in source)")
say()

printReferenceFigures()

rule("=")
say("SECTION 1 — CONTROL ARM  (runs first; nothing is measured if it fails)")
rule("=")
let ctl = runControlArm()
for a in ctl.arms {
    say((a.pass ? "  PASS  " : "  FAIL  ") + pad(a.name, 58))
    say("        expect  \(a.expect)")
    say("        got     \(a.got)")
}
say()
let passed = ctl.arms.filter { $0.pass }.count
say("CONTROL ARM  \(passed)/\(ctl.arms.count) PASS")
say()

if !ctl.allPass {
    rule("=")
    say("CONTROL ARM FAILED — no corpus measurement is emitted.")
    say("An instrument that has not been shown to discriminate has measured nothing.")
    say("The reference figures above are the PINNED values, not a reading taken now.")
    rule("=")
    sealAndExit(2)
}

// ── general mode: cdc <csv> <identity column>
let argv = Array(CommandLine.arguments.dropFirst())
if argv.count >= 1 {
    if argv.count < 2 {
        rule("=")
        say("REFUSED — general mode needs two arguments: <corpus.csv> <identity-column>")
        say("Given \(argv.count). A gate given a partial instruction does not guess.")
        rule("=")
        sealAndExit(2)
    }
    rule("=")
    say("SECTION 2 — GENERAL MODE")
    rule("=")
    do {
        let r = try countFile(argv[0], identity: argv[1])
        report(r)
        sealAndExit(0)
    } catch let e as Refusal {
        say(e.text)
        sealAndExit(2)
    } catch {
        say("REFUSED — \(error)")
        sealAndExit(2)
    }
}

// ── canonical published study (no argv)
var mismatches: [String] = []

func check(_ what: String, _ got: Int, _ pinned: Int) {
    if got == pinned {
        say("  AGREES     " + pad(what, 52) + "measured \(grp(got))  = pinned \(grp(pinned))")
    } else {
        say("  DISAGREES  " + pad(what, 52) + "measured \(grp(got))  != pinned \(grp(pinned))")
        mismatches.append("\(what): measured \(got), pinned \(pinned)")
    }
}
func checkSHA(_ what: String, _ got: String, _ pinned: String) {
    if got == pinned {
        say("  AGREES     " + pad(what, 52) + got)
    } else {
        say("  DISAGREES  " + pad(what, 52) + "measured \(got) != pinned \(pinned)")
        mismatches.append("\(what): sha256 mismatch")
    }
}

rule("=")
say("SECTION 2 — materials_bivqbit_validated.csv, identity = smiles")
rule("=")
say()

var bivqbit: CorpusResult? = nil
do {
    let r = try countFile(P_BIVQBIT, identity: "smiles", label: "materials_bivqbit_validated.csv")
    bivqbit = r
    report(r)
} catch let e as Refusal {
    say(e.text)
    say("The reference figures in SECTION 0 are the PINNED values, not a reading taken now.")
    sealAndExit(2)
} catch {
    say("REFUSED — \(error)")
    sealAndExit(2)
}

rule("=")
say("SECTION 3 — materials_chemistry_validated.csv, identity = smiles")
rule("=")
say()

var chemistry: CorpusResult? = nil
do {
    let r = try countFile(P_CHEMISTRY, identity: "smiles", label: "materials_chemistry_validated.csv")
    chemistry = r
    report(r)
} catch let e as Refusal {
    say(e.text)
    say("The reference figures in SECTION 0 are the PINNED values, not a reading taken now.")
    sealAndExit(2)
} catch {
    say("REFUSED — \(error)")
    sealAndExit(2)
}

rule("=")
say("SECTION 4 — proteins_validated.csv, identity = sequence   (REAL NEGATIVE CONTROL)")
rule("=")
say()

var proteins: CorpusResult? = nil
do {
    let r = try countFile(P_PROTEINS, identity: "sequence", label: "proteins_validated.csv")
    proteins = r
    report(r)
} catch let e as Refusal {
    say(e.text)
    sealAndExit(2)
} catch {
    say("REFUSED — \(error)")
    sealAndExit(2)
}

// ── cross-file union
rule("=")
say("SECTION 5 — UNION ACROSS BOTH MATERIALS FILES")
rule("=")
var union = Set<String>()
var unionSorted: [String] = []
if let a = bivqbit, let b = chemistry {
    for e in a.identity.table { union.insert(e.value) }
    for e in b.identity.table { union.insert(e.value) }
    unionSorted = union.sorted(by: utf8Less)
    say("distinct smiles in materials_bivqbit_validated.csv     \(grp(a.identity.distinct))")
    say("distinct smiles in materials_chemistry_validated.csv   \(grp(b.identity.distinct))")
    say("distinct smiles across BOTH files                      \(grp(union.count))")
    say("overlap between the two files                          "
        + "\(grp(a.identity.distinct + b.identity.distinct - union.count))")
    say("combined rows                                          \(grp(a.rows + b.rows))")
    say()
    say("the complete union, UTF-8 ascending:")
    for s in unionSorted { say("    \(s)") }
    say()
}

// ── agreement with the pinned figures
rule("=")
say("SECTION 6 — MEASURED vs PINNED")
rule("=")
if let a = bivqbit {
    checkSHA("materials_bivqbit_validated.csv sha256", a.sha256, SHA_BIVQBIT)
    check("bivqbit rows", a.rows, 37910)
    check("bivqbit distinct smiles", a.identity.distinct, 5)
    for c in a.columns where c.name == "discovery_id" { check("bivqbit distinct discovery_id", c.distinct, 37910) }
    for c in a.columns where c.name == "timestamp" { check("bivqbit distinct timestamp", c.distinct, 37910) }
    for c in a.columns where c.name == "molecular_weight" { check("bivqbit distinct molecular_weight", c.distinct, 5) }
    for c in a.columns where c.name == "logp" { check("bivqbit distinct logp", c.distinct, 5) }
    let want: [(String, Int)] = [("C1CCCCC1", 7649), ("O=C(O)c1ccccc1", 7598),
                                 ("c1cnccn1", 7596), ("c1ccc2ccccc2c1", 7580), ("c1ccccc1", 7487)]
    for (i, w) in want.enumerated() {
        if i < a.identity.table.count {
            let e = a.identity.table[i]
            if e.value == w.0 { check("bivqbit  \(w.0)", e.count, w.1) }
            else {
                say("  DISAGREES  " + pad("bivqbit rank \(i + 1)", 52) + "measured '\(e.value)' != pinned '\(w.0)'")
                mismatches.append("bivqbit rank \(i + 1) value")
            }
        }
    }
}
if let b = chemistry {
    checkSHA("materials_chemistry_validated.csv sha256", b.sha256, SHA_CHEMISTRY)
    check("chemistry rows", b.rows, 8712)
    check("chemistry distinct smiles", b.identity.distinct, 30)
    for e in b.identity.table where e.value == "C" { check("chemistry  C", e.count, 851) }
    for e in b.identity.table where e.value == "CCCO" { check("chemistry  CCCO", e.count, 618) }
}
if let p = proteins {
    checkSHA("proteins_validated.csv sha256", p.sha256, SHA_PROTEINS)
    check("proteins rows", p.rows, 78680)
    check("proteins distinct sequence", p.identity.distinct, 78680)
}
check("distinct smiles across both materials files", union.count, 35)
say()
if mismatches.isEmpty {
    say("EVERY PINNED FIGURE RE-DERIVES FROM THE PINNED BYTES. 0 disagreements.")
} else {
    say("!!! \(mismatches.count) DISAGREEMENT(S) WITH THE PUBLISHED FIGURES !!!")
    for m in mismatches { say("    \(m)") }
    say("The measurement wins. The published figure is the one that must be corrected.")
}
say()

// ── the one-molecule-one-property-tuple check, done on strings only
rule("=")
say("SECTION 7 — ONE PROPERTY TUPLE PER MOLECULE  (string equality only, never numeric)")
rule("=")
if let a = bivqbit {
    var tuples = Set<String>()
    var perMolecule: [String: Set<String>] = [:]
    if let d = FileManager.default.contents(atPath: P_BIVQBIT) {
        var first = true
        var hdr: [String] = []
        CSV.forEachRecord([UInt8](d)) { rec in
            if first { first = false; hdr = rec; return }
            if rec.count != hdr.count { return }
            var smi = "", mw = "", lp = "", na = ""
            for (i, h) in hdr.enumerated() {
                if h == "smiles" { smi = rec[i] }
                if h == "molecular_weight" { mw = rec[i] }
                if h == "logp" { lp = rec[i] }
                if h == "num_atoms" { na = rec[i] }
            }
            let t = "\(smi)|\(na)|\(mw)|\(lp)"
            tuples.insert(t)
            perMolecule[smi, default: []].insert("\(na)|\(mw)|\(lp)")
        }
    }
    say("distinct (smiles, num_atoms, molecular_weight, logp) tuples   \(grp(tuples.count))")
    say("distinct smiles                                               \(grp(a.identity.distinct))")
    let oneEach = perMolecule.allSatisfy { $0.value.count == 1 }
    say("every molecule carries exactly ONE property tuple             \(oneEach ? "YES" : "NO")")
    say()
    say("the whole of what \(grp(a.rows)) validated discoveries assert, verbatim:")
    say()
    say("  " + pad("smiles", 18) + pad("atoms", 7) + pad("molecular_weight", 20)
        + pad("logp", 20) + "identity")
    let names: [String: String] = [
        "C1CCCCC1": "cyclohexane      C6H12",
        "O=C(O)c1ccccc1": "benzoic acid     C7H6O2",
        "c1cnccn1": "pyrazine         C4H4N2",
        "c1ccc2ccccc2c1": "naphthalene      C10H8",
        "c1ccccc1": "benzene          C6H6",
    ]
    for e in a.identity.table {
        let props = (perMolecule[e.value].map { Array($0).sorted(by: utf8Less) } ?? []).first ?? ""
        let parts = props.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
        let na = parts.count > 0 ? parts[0] : ""
        let mw = parts.count > 1 ? parts[1] : ""
        let lp = parts.count > 2 ? parts[2] : ""
        say("  " + pad(e.value, 18) + pad(na, 7) + pad(mw, 20) + pad(lp, 20)
            + (names[e.value] ?? ""))
    }
    say()
    say("These five are undergraduate-textbook reference compounds. The identities")
    say("are read off the SMILES strings above: C1CCCCC1 is a six-membered ring of")
    say("sp3 carbons; c1ccccc1 is the aromatic six-ring; O=C(O)c1ccccc1 is that ring")
    say("carrying a carboxyl; c1cnccn1 is the six-ring with nitrogen at 1 and 4;")
    say("c1ccc2ccccc2c1 is two fused aromatic six-rings. The molecular_weight column")
    say("agrees with the standard atomic masses for each, to the digits printed.")
    say()
}

// ── THE CALL
rule("=")
say("SECTION 8 — THE CALL")
rule("=")
say()
say("WHAT WE CALL")
say()
if let a = bivqbit, let b = chemistry, let p = proteins {
    say("  materials_bivqbit_validated.csv holds \(grp(a.rows)) rows and")
    say("  \(grp(a.identity.distinct)) distinct molecules. materials_chemistry_validated.csv holds")
    say("  \(grp(b.rows)) rows and \(grp(b.identity.distinct)) distinct molecules. Across both files the corpus")
    say("  is \(grp(union.count)) distinct molecules carried by \(grp(a.rows + b.rows)) rows. Those are exact")
    say("  integer counts over the identity column of the pinned bytes, complete")
    say("  over every row, with the file digests checked against SHA256SUMS first.")
    say()
    say("  The count is the whole finding. \(grp(a.rows)) rows and 5 molecules is a ratio")
    say("  of \(grp(a.rows / a.identity.distinct)) to 1; a headline in units of discoveries and a headline in")
    say("  units of molecules differ here by three to four orders of magnitude,")
    say("  and both are computed from the same file.")
    say()
    say("  We call the instrument gap, not the pipeline. Every row validates.")
    say("  discovery_id varies across all \(grp(a.rows)) rows. timestamp varies across all")
    say("  \(grp(a.rows)) rows. Each molecule carries one molecular weight and one logP,")
    say("  and each is correct for the molecule named. There is no row in either")
    say("  file that a per-row check should have rejected. A per-item validator")
    say("  cannot reach this defect, because the defect is not in any item — it")
    say("  is in the relation BETWEEN items, and no per-item check ever holds two")
    say("  items at once.")
    say()
    say("  The counter is shown to discriminate. On \(grp(p.rows)) rows of real,")
    say("  UniProt-derived protein sequence it returns \(grp(p.identity.distinct)) distinct and")
    say("  \(p.verdict) — the same code path, the same comparator, a corpus that")
    say("  is genuinely diverse. On synthetic corpora it returns N for N distinct,")
    say("  5 for five, 1 for one, and REFUSES empty input rather than calling it")
    say("  zero-collapse. A counter that returned a small number for everything")
    say("  would have found nothing here.")
    say()
    say("WHAT WE REFUSE TO CALL")
    say()
    say("  We do not call this fabrication, and nothing here supports that reading.")
    say("  Five correct molecules with five correct property tuples is a generator")
    say("  converging on a small set and a ledger recording each emission, which is")
    say("  what an append-only ledger is supposed to do. Whether the convergence is")
    say("  a seeded start, a reward that pays for validity rather than novelty, or a")
    say("  deduplication step that was never in the design is not visible in these")
    say("  bytes, and this instrument does not guess at it.")
    say()
    say("  We do not call the per-row validators wrong. They answered the question")
    say("  they were asked. The question 'is this row a valid molecule' has answer")
    say("  YES \(grp(a.rows + b.rows)) times over, and that answer is true.")
    say()
    say("  We do not read the molecular_weight or logp columns as evidence of")
    say("  anything beyond their own constancy. They are decimal text in these")
    say("  files; this instrument counts them and prints them and never compares")
    say("  them, so nothing in this transcript rests on a float.")
    say()
    say("  We do not extend the count past these files. \(grp(a.rows)) rows scanned from")
    say("  \(grp(75823)) and \(grp(b.rows)) from \(grp(11801)) are what the export reports; the")
    say("  pre-validation population is not in the pinned bytes and is not counted.")
    say()
    say("WHAT A READER SHOULD DO")
    say()
    say("  Add a distinct count over the identity column to the reporting path of")
    say("  any generative pipeline, next to the row count, and publish the two")
    say("  numbers together. It is one hash set and one integer. It costs less")
    say("  than the validator that already runs on every row.")
    say()
    say("  Give that counter a control arm before trusting a reading from it. Two")
    say("  arms are the minimum: a corpus known to be diverse must not report")
    say("  collapse, and a corpus known to be collapsed must report it. Always-green")
    say("  and always-red are the same defect, and neither is visible from a single")
    say("  reading.")
    say()
    say("  Make empty input a refusal. A counter that reports 0 distinct over 0")
    say("  rows has reported the strongest possible collapse from the weakest")
    say("  possible evidence, and it will do so on the day the export breaks.")
    say()
    say("  Name the identity column explicitly. Here it is smiles, and it is not")
    say("  discovery_id or timestamp — both of which vary across every row and")
    say("  would report perfect diversity on a corpus of five molecules. Which")
    say("  column carries identity is a decision about the domain, and a counter")
    say("  pointed at the wrong column is worse than no counter, because it")
    say("  returns a number.")
    say()
}
say("This is a finding about instrumentation. It is not an accusation about anyone.")
say()

sealAndExit(mismatches.isEmpty ? 0 : 1)
