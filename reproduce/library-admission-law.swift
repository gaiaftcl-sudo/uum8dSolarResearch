// library-admission-law.swift
//
// THE LIBRARY ADMISSION LAW — executable.
//
// WHAT IT IS FOR
//   A library of health and materials that strangers will use grows by admitting
//   entries. If admission is a per-entry check, the library will eventually report
//   a row count and hold five things: a generated corpus reported 37,910 validated
//   discoveries and contained FIVE distinct molecules, every row passed every
//   per-row check, and the defect lived in the relation BETWEEN rows where no
//   per-item validator can reach — because no per-item validator ever holds two
//   items at once. See Study-37-Validated-Discoveries-Five-Molecules.
//
//   So this law has two halves and needs both:
//     PER-ENTRY    what one entry must carry to be admissible at all   (E0..E14)
//     PER-LIBRARY  what must be true of the collection, over every entry at once,
//                  with a distinct count over the identity field published beside
//                  the row count, ALWAYS                                (L1..L8)
//     FEDERATION   what must be true BETWEEN libraries, which neither half above
//                  can reach because neither ever holds two libraries at once (F1)
//
// THREE TERMINALS, NEVER COLLAPSED
//   ADMITTED   every clause is satisfied on evidence present here
//   REFUSED    a clause is violated; the reason is named
//   NOT_KNOWN  a clause cannot be decided because its evidence is absent here.
//              ABSENCE IS NOT REFUSAL. A held entry is not in the library and is
//              not thrown out of it; it is named, and it waits.
//
// USE
//   lal                                       control arm only, no filesystem read
//   lal --entry <file.md>                     grade one entry
//   lal --library <dir> [--library <dir> ...] grade whole libraries
//
//   GRADE EVERY LIBRARY IN ONE COMMAND. F1 is a relation BETWEEN libraries and a run
//   given one library cannot answer it: that run reports F1 as NOT_KNOWN and exits 2,
//   which is the honest answer and is not a clearance. Three libraries each graded
//   alone, each reporting clean, is three runs none of which asked the question.
//   lal --reproduce <dir>                     where the programs live   (default ./reproduce, ../reproduce)
//   lal --evidence  <dir>                     where out_<program>.txt transcripts live (default /tmp)
//
// ZERO FLOAT — a house law, enforced by construction
//   No Float, Double or CGFloat appears anywhere in this file and no decision path
//   touches one. Every count is an Int. Every ceiling is tested by integer
//   COMPARISON — the most repeated value's own count <= declared — never by a ratio,
//   because a ratio between two integers is where a float enters a program that had
//   none.
//
//   CORRECTED 2026-09-07. This read `distinct * declared >= entries`, which is an
//   AGGREGATE test wearing a per-value name: 8 entries over 4 distinct values passed
//   a declared ceiling of 2 while ONE of those values carried 5 of the 8. It printed
//   "4 x 2 >= 8" and admitted the collapse it exists to catch. The ceiling is now
//   tested where it is declared — per value — and the most repeated value is printed
//   on the PASSING path too, so a reader sees how close the library is to its own
//   ceiling instead of only being told it cleared.
//
// A GATE GIVEN NOTHING MUST NOT PASS
//   Zero-byte entry: REFUSED. Empty library: REFUSED, never "clean". Missing
//   transcript: NOT_KNOWN, never PASS. Unreadable reproduce/ directory: NOT_KNOWN
//   for every program clause, never PASS.
//
// CONTROL ARM
//   Runs FIRST, on fixtures embedded in this file so it needs no corpus and no
//   network. If any arm fails, NO library is graded at all. Each arm declares the
//   terminal AND the clause code it expects, so "refused for the wrong reason"
//   cannot read as a pass. Arms run in both directions: constructed entries that
//   must be REFUSED, constructed entries that must be ADMITTED, and controls on
//   the controls — prose ABOUT a procedure must not trip the procedure detector,
//   and a refusal line naming a self-graded column must not trip the self-graded
//   detector. An instrument that refuses everything has admitted nothing, and
//   always-green and always-red are the same defect.
//
// SEAL
//   The whole verdict transcript is sealed with a sha256 computed by the
//   self-contained implementation below. Filesystem paths are printed with print(),
//   never with say(), so they are OUTSIDE the sealed bytes: a seal that moves with
//   the checkout directory indicts a correct reproduction.
//
// Build: xcrun swiftc -O -swift-version 5 library-admission-law.swift -o /tmp/lal

import Foundation

setvbuf(stdout, nil, _IONBF, 0)

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
// SECTION B — transcript and integer-only helpers
// ══════════════════════════════════════════════════════════════════════════

var TRANSCRIPT: [UInt8] = []

func say(_ s: String = "") {
    print(s)
    TRANSCRIPT.append(contentsOf: Array(s.utf8))
    TRANSCRIPT.append(0x0A)
}

func rule(_ ch: String = "-") { say(String(repeating: ch, count: 78)) }

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

// deterministic on every machine: compare by raw UTF-8 bytes, never by Unicode
// collation, which can differ across stdlib versions.
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

func trim(_ s: String) -> String {
    var t = Substring(s)
    while let f = t.first, f == " " || f == "\t" || f == "\r" { t = t.dropFirst() }
    while let l = t.last, l == " " || l == "\t" || l == "\r" { t = t.dropLast() }
    return String(t)
}

func lower(_ s: String) -> String {
    var out = ""
    out.reserveCapacity(s.utf8.count)
    for u in s.unicodeScalars {
        if u.value >= 65 && u.value <= 90 {
            out.unicodeScalars.append(Unicode.Scalar(u.value + 32)!)
        } else {
            out.unicodeScalars.append(u)
        }
    }
    return out
}

func isHex64(_ s: String) -> Bool {
    if s.utf8.count != 64 { return false }
    for u in s.utf8 {
        let ok = (u >= 48 && u <= 57) || (u >= 97 && u <= 102)
        if !ok { return false }
    }
    return true
}

// A transcript that carries a 64-hex is NOT thereby a transcript that prints a seal.
// Measured: peptide-homology-exact prints THREE 64-hex digests — its corpus, its
// reference and its BLOSUM62 matrix — and then says "NO SEAL EMITTED". An any-hex
// test refused an honest NONE_PRINTED declaration on the first real transcript it
// met, which is the always-red half of the defect this law legislates against.
//
// A seal line carries a 64-hex AND, before it, either the word "seal" or "digest",
// or nothing but the token "sha256". "corpus sha256", "reference sha256" and
// "blosum62 sha256" name INPUTS and are not seals.
func findSealLine(_ text: String) -> String? {
    for line in splitLines(text) {
        guard let r = firstHex64Range(line) else { continue }
        let before = lower(String(line[line.startIndex..<r.lowerBound]))
        var squeezed = ""
        for ch in before where ch != " " && ch != "\t" { squeezed.append(ch) }
        if before.contains("seal") || before.contains("digest")
            || squeezed == "sha256" || squeezed == "sha256:" {
            return trim(line)
        }
    }
    return nil
}

func firstHex64Range(_ line: String) -> Range<String.Index>? {
    let chars = Array(line)
    var i = 0
    while i < chars.count {
        func isHexDigit(_ c: Character) -> Bool {
            return (c >= "0" && c <= "9") || (c >= "a" && c <= "f")
        }
        func isWordChar(_ c: Character) -> Bool {
            return isHexDigit(c) || (c >= "A" && c <= "Z") || (c >= "g" && c <= "z")
        }
        if isHexDigit(chars[i]) && (i == 0 || !isWordChar(chars[i - 1])) {
            var j = i
            while j < chars.count && isHexDigit(chars[j]) { j += 1 }
            let runLen = j - i
            let boundedRight = (j >= chars.count) || !isWordChar(chars[j])
            if runLen == 64 && boundedRight {
                let lo = line.index(line.startIndex, offsetBy: i)
                let hi = line.index(line.startIndex, offsetBy: j)
                return lo..<hi
            }
            i = j
            continue
        }
        i += 1
    }
    return nil
}

// A transcript that is ITSELF a refusal has not answered. Its silence about a figure
// is not evidence that the program does not print it — the program did not get to
// the point of printing anything. Absence inside a refusal is NOT_KNOWN, never
// REFUSED. Narrow by construction: the five screens in this wiki that print their
// pinned reference figures and then stop for want of stdin are NOT refusal
// transcripts by this test, and their entries are admitted from them.
// ===========================================================================================
// THE CONTRACT — structure, not spelling. Adopted 2026-09-08.
//
// The spelling-keyed detector below this block was written the same day and its own comment
// named the durable fix: "one declared line every refusing program prints, and a delimited
// block around quoted reference figures". Two programs in reproduce/ now print exactly that,
// so the law reads structure first and falls back to spellings only for programs that have
// not adopted it. A vocabulary list can only ever be as complete as yesterday.
//
//   RUN_TERMINAL  COMPLETE            this run computed a verdict
//   RUN_TERMINAL  REFUSED  <reason>   this run computed nothing, and says why
//
//   --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
//   ...
//   --- END QUOTED REFERENCE FIGURES ---
//
// TWO PROPERTIES, and the second is the one a refusal test alone cannot give you.
//
// 1. A DECLARED TERMINAL IS FINAL IN BOTH DIRECTIONS. `REFUSED` is a refusal whatever the
//    prose says; `COMPLETE` is NOT a refusal whatever the prose says. The second half matters
//    as much as the first: a completed run whose quoted block happens to contain the sentence
//    "a gate given nothing must not pass" would otherwise be misread as a refusal by the
//    fallback, and a false HOLD is a defect exactly as a false ADMIT is.
//
// 2. A FIGURE BETWEEN THE FENCES WAS QUOTED, NOT COMPUTED — even on a COMPLETE run. This is
//    the half that the refusal test cannot reach: a program that runs to completion and also
//    prints its published reference block would otherwise have those quoted figures credited
//    to the run. E4 and E5 read the COMPUTED REGION only.
//
// An unclosed BEGIN fence is treated as quoted to the end of the transcript. That is the
// conservative direction: it can only withhold credit, never manufacture it.
// ===========================================================================================

let RUN_TERMINAL_KEY = "RUN_TERMINAL"
let QUOTED_BEGIN     = "BEGIN QUOTED REFERENCE FIGURES"
let QUOTED_END       = "END QUOTED REFERENCE FIGURES"

// The LAST declared terminal wins: a transcript is whatever it finished as.
func declaredTerminal(_ text: String) -> String? {
    var found: String? = nil
    for line in splitLines(text) {
        let t = trim(line)
        guard t.hasPrefix(RUN_TERMINAL_KEY) else { continue }
        let rest = trim(String(t.dropFirst(RUN_TERMINAL_KEY.utf8.count)))
        let up = rest.uppercased()
        if up.hasPrefix("COMPLETE") { found = "COMPLETE" }
        else if up.hasPrefix("REFUSED") { found = "REFUSED" }
    }
    return found
}

// Everything the run actually printed as its own work: the transcript less every fenced
// quoted block. The fence lines themselves are dropped with the block.
func computedRegion(_ text: String) -> String {
    var out: [String] = []
    var inQuoted = false
    for line in splitLines(text) {
        if line.contains(QUOTED_BEGIN) { inQuoted = true; continue }
        if line.contains(QUOTED_END)   { inQuoted = false; continue }
        if !inQuoted { out.append(line) }
    }
    return out.joined(separator: "\n")
}

func transcriptCarriesContract(_ text: String) -> Bool {
    return declaredTerminal(text) != nil || text.contains(QUOTED_BEGIN)
}

func isRefusalTranscript(_ text: String) -> Bool {
    // STRUCTURE FIRST. A declared terminal is final in BOTH directions, so a program that
    // adopted the contract can never be misread by the spelling list below it.
    if let d = declaredTerminal(text) { return d == "REFUSED" }
    for line in splitLines(text) {
        let t = trim(line)
        let lt = lower(t)
        if lt.hasPrefix("reason:") { return true }
        if lt.contains("no seal emitted") { return true }
        if lt.contains("no verdict is published") { return true }
        if lt.hasPrefix("refused —") || lt.hasPrefix("refused -") { return true }
        if lt.hasPrefix("control arm failed") { return true }
        // THE VOCABULARY, AND ITS KNOWN WEAKNESS, STATED HERE RATHER THAN DISCOVERED LATER.
        // This detector is keyed to SPELLINGS a refusing program uses, and a detector keyed
        // to spellings goes blind the moment a program says it a new way — which is exactly
        // how the quoted-figure defect of 2026-09-08 survived. Every line below was added
        // because a real program in reproduce/ prints it on a path that computed nothing.
        // The durable fix is a CONTRACT — one declared line every refusing program prints,
        // and a delimited block around quoted reference figures — and it is named as an open
        // weakness on The-Library-Admission-Law page rather than left implicit here.
        if lt.contains("no_screen_performed") { return true }
        if lt.contains("no screen was run") { return true }
        if lt.contains("will not invent one") { return true }
        if lt.contains("no seal emitted on this path") { return true }
        if lt.contains("a gate given nothing must not pass") { return true }
    }
    return false
}

func containsHex64(_ text: String) -> Bool {
    var run = 0
    for u in text.utf8 {
        let isHexDigit = (u >= 48 && u <= 57) || (u >= 97 && u <= 102)
        let isWordByte = isHexDigit || (u >= 65 && u <= 90) || (u >= 103 && u <= 122)
        if isHexDigit {
            run += 1
            if run == 64 { return true }
        } else if isWordByte {
            run = -1000            // an alphanumeric non-hex byte poisons the run
        } else {
            run = 0
        }
    }
    return false
}

func hasDigit(_ s: String) -> Bool {
    for u in s.utf8 where u >= 48 && u <= 57 { return true }
    return false
}

// A digit that is not part of an identifier. "E8 is a good lattice and it works well
// in practice." carries a digit and carries no quantity: the 8 belongs to the NAME of
// the object. hasDigit() cannot tell those apart and E2 accepted the sentence on that
// basis. A free digit is one whose immediate neighbours are not letters.
func hasFreeDigit(_ s: String) -> Bool {
    let c = Array(s)
    for i in 0..<c.count where c[i].isNumber {
        let leftIsLetter = i > 0 && c[i - 1].isLetter
        let rightIsLetter = i + 1 < c.count && c[i + 1].isLetter
        if !leftIsLetter && !rightIsLetter { return true }
    }
    return false
}

// Does `needle` occur in `hay` at a TOKEN BOUNDARY, and on which line?
//
// A whole-transcript `contains` cannot tell a figure from a PREFIX of a longer one:
// the declared figure "E8  : 24" was graded MEASURED against a transcript line
// printing "E8  : 240", and "Z^8 : 1" against "Z^8 : 16". Ten times the number, and
// the clause said the figure appeared verbatim. A match is rejected only when the
// needle's edge character AND the character abutting it are both alphanumeric —
// so "240" still matches "E8  : 240", and "24" no longer does.
func matchLineAtTokenBoundary(_ hay: String, _ needle: String) -> String? {
    if needle.isEmpty { return nil }
    let nFirst = needle.first!, nLast = needle.last!
    for line in splitLines(hay) {
        let l = Array(line)
        let n = Array(needle)
        if n.count > l.count { continue }
        var i = 0
        while i + n.count <= l.count {
            var same = true
            var k = 0
            while k < n.count {
                if l[i + k] != n[k] { same = false; break }
                k += 1
            }
            if same {
                let leftOK: Bool = {
                    if i == 0 { return true }
                    let p = l[i - 1]
                    return !((p.isLetter || p.isNumber) && (nFirst.isLetter || nFirst.isNumber))
                }()
                let rightOK: Bool = {
                    let j = i + n.count
                    if j >= l.count { return true }
                    let q = l[j]
                    return !((q.isLetter || q.isNumber) && (nLast.isLetter || nLast.isNumber))
                }()
                if leftOK && rightOK { return line }
            }
            i += 1
        }
    }
    return nil
}

func splitLines(_ s: String) -> [String] {
    var out: [String] = []
    var cur = ""
    for ch in s {
        if ch == "\n" { out.append(cur); cur = "" }
        else if ch == "\r" { continue }
        else { cur.append(ch) }
    }
    out.append(cur)
    return out
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION C — the frozen vocabulary
//
// The grades are Ontology.md's, transcribed, not invented. Ontology.md writes
// one of them as "CITED / NOT MEASURED"; it is tokenised here as
// CITED_NOT_MEASURED and that is the ONLY normalisation applied to the set.
// A grade absent from Ontology.md is refused however reasonable it sounds —
// including ARGUMENT, which is not a grade on this wiki.
// ══════════════════════════════════════════════════════════════════════════

let ONTOLOGY_GRADES: [String] = [
    "VERIFIED", "REPORTED", "CITED_NOT_MEASURED", "MEASURED",
    "PROJECTION", "ABSENT", "NOT_KNOWN",
]

// SPEC_NAME exists because a material system often has no registry number: the E8
// lattice has no UNII and no accession. It is admitted ONLY with SPEC_AUTHORITY —
// the public body or standard that fixes the name — because a free-text name with
// nobody behind it is the loophole that "an entry that cannot be named cannot be
// found" exists to close.
let IDENTITY_KINDS: [String] = [
    "UNII", "INCHIKEY", "ACCESSION", "GENE_SYMBOL", "CONTENT_DIGEST", "SPEC_NAME",
]

let REQUIRED_KEYS: [String] = [
    "LIBRARY", "IDENTITY_KIND", "IDENTITY", "TITLE", "MEASURED", "PROGRAM",
    "FIGURE", "SEAL", "GRADE", "REFUSED", "FALSIFIER", "REPRODUCE", "NOT_ADVICE",
]

let OPTIONAL_KEYS: [String] = [
    "SOURCE", "QUOTE", "ASSUMPTION", "METHOD", "REFUTED_BY", "SUPERSEDES",
    "ADDED", "NOTE", "SPEC_AUTHORITY", "DIGEST_OF", "WHERE_THE_LAW_LIVES",
]

let REPEATABLE_KEYS: [String] = ["FIGURE", "REFUSED", "SOURCE", "QUOTE", "NOTE", "REFUTED_BY"]

let PLACEHOLDER_IDENTITIES: [String] = [
    "unknown", "n/a", "na", "none", "null", "tbd", "todo", "pending", "-", "?",
]

// C-007: a library entry names WHAT a system is, WHAT was measured, and WHERE the
// law lives. It never carries a procedure a person could follow. These verbs are
// unambiguous fabrication and wet-lab operations. Deliberately EXCLUDED as too
// common in honest measurement prose: heat, cool, mix, add, stir, weigh, cure,
// filter, culture. A detector tuned to catch a violation it will never see, at the
// cost of refusing honest entries, is the always-red half of the same defect.
let FABRICATION_VERBS: [String] = [
    "synthesize", "synthesise", "dissolve", "anneal", "sinter", "calcine",
    "reflux", "distill", "distil", "titrate", "centrifuge", "incubate",
    "electroplate", "electrodeposit", "sputter", "etch", "dope", "quench",
    "precipitate", "crystallise", "crystallize", "recrystallise", "recrystallize",
    "transfect", "ligate", "aliquot", "extrude", "pipette", "autoclave",
    "sonicate", "lyophilize", "lyophilise",
]

let QUANTITY_UNITS: [String] = [
    "mg", "g", "kg", "ug", "µg", "ml", "l", "mol", "mmol", "µmol", "nmol",
    "nm", "um", "µm", "mm", "cm", "rpm", "psi", "bar", "torr", "equiv", "eq",
    "h", "hr", "hrs", "min", "mins", "minutes", "hours", "c", "°c", "degc",
    "celsius", "kelvin", "w", "kw", "v", "ma", "mpa", "gpa", "kpa", "atm",
]

// C-007 RULE C — quantity density. ADDED 2026-09-07, because rules A and B are both
// keyed on a VERB and a fabrication procedure does not need one of ours.
//
//   "Combine 42 g of the powder with 5 mL of solvent, heat to 1450 C for 6 h under
//    argon, then press at 12 MPa and cool at 5 C per minute"
//
// is a complete two-sentence route written entirely in the verbs this law
// DELIBERATELY EXCLUDES as too common in honest prose — combine, heat, press, cool.
// It was ADMITTED into MATERIALS with `E11_NO_PROCEDURE ok`. What gives it away is
// not any word: it is the DENSITY of quantities-with-units on one line. Three is the
// threshold, and it is not always-red — measured over every non-FIGURE, non-REPRODUCE
// line of the sixteen live entry files the count is 0, and on the line above it is 6.
let RULE_C_MIN_QUANTITIES = 3

// FIGURE lines and REPRODUCE lines are exempt from rule C, and from that rule ONLY.
// A FIGURE is a line of a program's own output, pinned by E4 to appear in that output
// at a token boundary; a REPRODUCE is a build command, pinned by E9 to name its
// program and carry no private path. Both are machine text where a run of numbers is
// ordinary. Rules A and B — the verb rules — still apply to every value including
// these two, so the exemption narrows one detector and opens no channel.
let RULE_C_EXEMPT_KEYS: [String] = ["FIGURE", "REPRODUCE"]

// A one- or two-character FIGURE matches a line of almost any transcript. "FIGURE 0"
// and "FIGURE :" were both graded MEASURED with E7 confirming the grade. A figure is
// a number a stranger can check, so it must be long enough to be one.
let FIGURE_MIN_BYTES = 3

// The generator's own opinion of its output. These are the columns a pipeline
// writes about itself; none is a measurement of anything outside the program that
// produced them, and every one of them is a Double in the corpora this wiki holds.
let SELF_GRADED_TOKENS: [String] = [
    "confidence", "coherence", "overall_score", "validation_passed",
    "novelty_score", "quality_score", "fitness_score", "self_score",
]

let PRIVATE_PATH_TOKENS: [String] = [
    "~", "/users/", "/home/", "/private/", "/var/folders/", "$home", "c:\\users\\",
]

// ══════════════════════════════════════════════════════════════════════════
// SECTION D — the entry, and the parser
// ══════════════════════════════════════════════════════════════════════════

enum Terminal: String {
    case ADMITTED
    case REFUSED
    case NOT_KNOWN
}

struct ClauseResult {
    let code: String
    let terminal: Terminal
    let detail: String
}

func pass_(_ code: String, _ d: String) -> ClauseResult { ClauseResult(code: code, terminal: .ADMITTED, detail: d) }
func refuse(_ code: String, _ d: String) -> ClauseResult { ClauseResult(code: code, terminal: .REFUSED, detail: d) }
func hold(_ code: String, _ d: String) -> ClauseResult { ClauseResult(code: code, terminal: .NOT_KNOWN, detail: d) }

struct Entry {
    let label: String
    let fields: [(key: String, value: String)]
    let blockText: String

    func all(_ k: String) -> [String] { fields.filter { $0.key == k }.map { $0.value } }
    func first(_ k: String) -> String? { all(k).first }
    var everyValue: [String] { fields.map { $0.value } }
}

struct EntryFault: Error {
    let code: String
    let detail: String
}

func parseEntry(_ text: String, label: String) throws -> Entry {
    if text.utf8.count == 0 {
        throw EntryFault(code: "ENTRY_IS_ZERO_BYTES",
                         detail: "the file is empty. EMPTY IS NOT ADMISSIBLE and it is not a clean entry.")
    }
    let lines = splitLines(text)
    var inBlock = false
    var seenBlock = false
    var body: [String] = []
    for ln in lines {
        let t = trim(ln)
        if !inBlock && t == "```affine-entry" { inBlock = true; seenBlock = true; continue }
        if inBlock && t == "```" { inBlock = false; continue }
        if inBlock { body.append(ln) }
    }
    if !seenBlock {
        throw EntryFault(code: "ENTRY_BLOCK_ABSENT",
                         detail: "no ```affine-entry block. An entry a machine cannot read is an entry no gate can check.")
    }
    if inBlock {
        throw EntryFault(code: "ENTRY_BLOCK_UNCLOSED",
                         detail: "the ```affine-entry block is never closed.")
    }

    var fields: [(key: String, value: String)] = []
    var lineNo = 0
    for ln in body {
        lineNo += 1
        let t = trim(ln)
        if t.isEmpty { continue }
        if t.hasPrefix("#") { continue }
        // KEY value — the key is the leading run of A-Z and _
        var key = ""
        var idx = t.startIndex
        while idx < t.endIndex {
            let c = t[idx]
            if (c >= "A" && c <= "Z") || c == "_" { key.append(c); idx = t.index(after: idx) }
            else { break }
        }
        let rest = trim(String(t[idx...]))
        if key.isEmpty || rest.isEmpty {
            throw EntryFault(code: "ENTRY_MALFORMED_LINE",
                             detail: "line \(lineNo) of the block is not `KEY value`: '\(t)'")
        }
        let known = REQUIRED_KEYS.contains(key) || OPTIONAL_KEYS.contains(key)
        if !known {
            throw EntryFault(code: "ENTRY_UNKNOWN_KEY",
                             detail: "'\(key)' is not a key in this law. A mistyped key is a clause silently dropped — a REFUSED line spelled REFUSE would leave the entry with no refusal and nothing would say so.")
        }
        if !REPEATABLE_KEYS.contains(key) && fields.contains(where: { $0.key == key }) {
            throw EntryFault(code: "ENTRY_DUPLICATE_SINGLE_KEY",
                             detail: "'\(key)' appears more than once and is not repeatable. Two values for one clause is two entries pretending to be one.")
        }
        fields.append((key: key, value: rest))
    }
    if fields.isEmpty {
        throw EntryFault(code: "ENTRY_BLOCK_IS_EMPTY",
                         detail: "the ```affine-entry block carries no fields. A gate given NOTHING must not pass.")
    }
    let blockText = fields.map { "\($0.key) \($0.value)" }.joined(separator: "\n")
    return Entry(label: label, fields: fields, blockText: blockText)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION E — evidence. Where the programs are, and what they printed.
// ══════════════════════════════════════════════════════════════════════════

protocol Evidence {
    var originLabel: String { get }
    var censusKnown: Bool { get }
    var programs: Set<String> { get }
    func transcript(_ program: String) -> String?
}

struct EmbeddedEvidence: Evidence {
    let originLabel = "embedded fixtures (no filesystem read)"
    let censusKnown = true
    // gamma is IN the census and has NO transcript. It is the fixture for the third
    // terminal: a program that exists and has not been run here is NOT_KNOWN, and a
    // suite with no such arm cannot show that its NOT_KNOWN path is reachable.
    let programs: Set<String> = ["fixture-program-alpha", "fixture-program-beta",
                                "fixture-program-gamma", "fixture-program-delta",
                                "fixture-program-epsilon", "fixture-program-zeta",
                                "fixture-program-theta", "fixture-program-iota",
                                "fixture-program-kappa", "fixture-program-lambda",
                                "fixture-program-mu", "fixture-program-nu",
                                "fixture-program-eta"]
    func transcript(_ program: String) -> String? {
        switch program {
        case "fixture-program-alpha":
            return """
            FIXTURE ALPHA — a stand-in transcript with a seal
            alpha figure one : 42
            alpha figure two : 7 of 9
            seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            """
        case "fixture-program-beta":
            return """
            FIXTURE BETA — a stand-in transcript that prints NO seal
            beta figure : 240 by direct enumeration
            """
        case "fixture-program-delta":
            // The shape peptide-homology-exact actually produced: input digests, an
            // explicit refusal, and no seal. An entry declaring NONE_PRINTED here is
            // honest and must be admitted; its absent figures must HOLD, not refuse.
            return """
            FIXTURE DELTA — reference figures, then a refusal, and NO seal
              corpus sha256     bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
              reference sha256  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e
              delta figure : 78680 rows

            REASON: study root not found.
            NO SEAL EMITTED. No verdict is published on a refusal path.
            """
        case "fixture-program-theta":
            // THE CONTRACT, HONESTLY USED: a COMPLETE run that also prints its published
            // reference block. Both declared figures and the seal appear OUTSIDE the fences,
            // in the region this run computed. This is the positive control for every arm
            // below it — without it the computed-region rule could be an always-refuse.
            return """
            FIXTURE THETA — a complete run that also quotes its published block
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              alpha figure one : 999
              seal 0000000000000000000000000000000000000000000000000000000000000000
            --- END QUOTED REFERENCE FIGURES ---
            alpha figure one : 42
            alpha figure two : 7 of 9
            seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            RUN_TERMINAL  COMPLETE
            """
        case "fixture-program-iota":
            // A COMPLETE run whose declared figures appear ONLY between the fences. The run
            // finished, so this is not absence of evidence — it is a figure the program does
            // not print. REFUSED, not HELD, and that distinction is the whole ontology.
            return """
            FIXTURE IOTA — complete, but the figures are only in the quoted block
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              alpha figure one : 42
              alpha figure two : 7 of 9
              seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            --- END QUOTED REFERENCE FIGURES ---
            RUN_TERMINAL  COMPLETE
            """
        case "fixture-program-kappa":
            // A DECLARED REFUSAL that quotes everything. The shape peptide-homology-exact
            // produced, now saying so by structure instead of by a phrase.
            return """
            FIXTURE KAPPA — declared refusal, published block quoted in full
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              alpha figure one : 42
              alpha figure two : 7 of 9
              seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            --- END QUOTED REFERENCE FIGURES ---
            RUN_TERMINAL  REFUSED  no corpus on standard input
            """
        case "fixture-program-lambda":
            // THE CONTROL ON THE FALLBACK, in the direction nobody builds. A run that
            // COMPLETED, whose quoted block happens to contain a sentence the spelling list
            // reads as a refusal. A declared COMPLETE must win, or the fallback manufactures
            // a HOLD on a run that measured everything — a false NOT_KNOWN, which is a defect
            // exactly as a false ADMIT is.
            return """
            FIXTURE LAMBDA — complete, and its quoted block trips the old spelling list
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              the predecessor refused with: a gate given nothing must not pass
              NO SEAL EMITTED on that path
            --- END QUOTED REFERENCE FIGURES ---
            alpha figure one : 42
            alpha figure two : 7 of 9
            seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            RUN_TERMINAL  COMPLETE
            """
        case "fixture-program-mu":
            // AN UNCLOSED FENCE. Everything after BEGIN is treated as quoted, so the figures
            // below it are not credited. The conservative direction: it can only withhold
            // credit, never manufacture it.
            return """
            FIXTURE MU — a BEGIN fence with no END
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              alpha figure one : 42
              alpha figure two : 7 of 9
              seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            RUN_TERMINAL  COMPLETE
            """
        case "fixture-program-nu":
            // The figures computed, the SEAL only quoted. E4 must pass and E5 must refuse,
            // so the two clauses are shown to read the region independently.
            return """
            FIXTURE NU — figures computed, seal only in the quoted block
            --- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---
              seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            --- END QUOTED REFERENCE FIGURES ---
            alpha figure one : 42
            alpha figure two : 7 of 9
            RUN_TERMINAL  COMPLETE
            """
        case "fixture-program-eta":
            // The COMPLETE counterpart of delta: input digests and no seal, and NO
            // refusal anywhere in it. This is what arm 31 was always testing —
            // NONE_PRINTED is honest when the program genuinely prints no seal —
            // and it now sits on a transcript that RAN, so the figure it carries
            // was computed rather than quoted.
            return """
            FIXTURE ETA — a complete run that prints input digests and NO seal
              corpus sha256     bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
              reference sha256  bf1bc7e188e55199a2447fc20d25834db5f7f798daa818432370deb4a6b0df5e
              delta figure : 78680 rows
            """
        case "fixture-program-zeta":
            // THE SHAPE THAT BROKE E4 AND E5, kept as a fixture so it cannot come back.
            // A program that prints its PUBLISHED figures and its PUBLISHED seal on the
            // refusal path — which several now do, so a wiki harness can check a page
            // against its program from a clean clone with no corpus. Every declared
            // figure and the declared seal are present in this text, and NONE of them
            // was computed by this run. E4 and E5 must HOLD, not pass.
            return """
            FIXTURE ZETA — a refusal that QUOTES the published run
              alpha figure one : 42
              alpha figure two : 7 of 9
              seal 9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68

            REASON: no corpus on standard input.
            NO SEAL EMITTED. Every figure above was quoted, not computed.
            """
        case "fixture-program-epsilon":
            // A COMPLETE run that prints input digests and a real seal. It is the
            // control on the control above: the seal-line test must still find this
            // one, or arm 09 has been weakened into always-green.
            return """
            FIXTURE EPSILON — a complete run
              corpus sha256     bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
              epsilon figure : 11 of 17
            sha256  9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
            """
        default:
            return nil
        }
    }
}

struct FileEvidence: Evidence {
    let reproduceDir: String
    let evidenceDir: String
    var originLabel: String { "reproduce=\(reproduceDir)  transcripts=\(evidenceDir)" }
    let censusKnown: Bool
    let programs: Set<String>

    init(reproduceDir: String, evidenceDir: String) {
        self.reproduceDir = reproduceDir
        self.evidenceDir = evidenceDir
        let fm = FileManager.default
        if let names = try? fm.contentsOfDirectory(atPath: reproduceDir) {
            var s = Set<String>()
            for n in names where n.hasSuffix(".swift") {
                s.insert(String(n.dropLast(6)))
            }
            self.programs = s
            self.censusKnown = !s.isEmpty
        } else {
            self.programs = []
            self.censusKnown = false
        }
    }

    func transcript(_ program: String) -> String? {
        let p = evidenceDir + "/out_" + program + ".txt"
        return try? String(contentsOfFile: p, encoding: .utf8)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION F — the per-entry clauses, E0 .. E14
// ══════════════════════════════════════════════════════════════════════════

func clauseE0_shape(_ e: Entry) -> ClauseResult {
    var missing: [String] = []
    for k in REQUIRED_KEYS where e.first(k) == nil { missing.append(k) }
    if !missing.isEmpty {
        return refuse("E0_SHAPE",
                      "required key(s) absent: \(missing.joined(separator: ", "))")
    }
    let lib = e.first("LIBRARY")!
    if !["PROTEINS", "COMPOUNDS", "MATERIALS"].contains(lib) {
        return refuse("E0_SHAPE", "LIBRARY '\(lib)' is not one of PROTEINS, COMPOUNDS, MATERIALS")
    }
    return pass_("E0_SHAPE", "all \(REQUIRED_KEYS.count) required keys present; LIBRARY = \(lib)")
}

func clauseE1_identity(_ e: Entry) -> ClauseResult {
    guard let kind = e.first("IDENTITY_KIND"), let id = e.first("IDENTITY") else {
        return refuse("E1_IDENTITY", "IDENTITY_KIND or IDENTITY absent. An entry that cannot be named cannot be found.")
    }
    if !IDENTITY_KINDS.contains(kind) {
        return refuse("E1_IDENTITY", "IDENTITY_KIND '\(kind)' is not in the law: \(IDENTITY_KINDS.joined(separator: ", "))")
    }
    if PLACEHOLDER_IDENTITIES.contains(lower(id)) {
        return refuse("E1_IDENTITY", "IDENTITY '\(id)' is a placeholder. A field that accepts 'unknown' is not a name.")
    }
    switch kind {
    case "UNII":
        if id.utf8.count != 10 { return refuse("E1_IDENTITY", "UNII '\(id)' is \(id.utf8.count) characters; a UNII is exactly 10") }
        for u in id.utf8 {
            let ok = (u >= 48 && u <= 57) || (u >= 65 && u <= 90)
            if !ok { return refuse("E1_IDENTITY", "UNII '\(id)' carries a character outside A-Z0-9") }
        }
    case "INCHIKEY":
        let parts = id.split(separator: "-", omittingEmptySubsequences: false).map(String.init)
        if parts.count != 3 || parts[0].count != 14 || parts[1].count != 10 || parts[2].count != 1 {
            return refuse("E1_IDENTITY", "InChIKey '\(id)' is not 14-10-1")
        }
        for u in id.utf8 where !((u >= 65 && u <= 90) || u == 45) {
            return refuse("E1_IDENTITY", "InChIKey '\(id)' carries a character outside A-Z and '-'")
        }
    case "ACCESSION":
        if id.utf8.count < 4 || id.utf8.count > 48 { return refuse("E1_IDENTITY", "accession '\(id)' is not 4..48 characters") }
        if !hasDigit(id) { return refuse("E1_IDENTITY", "accession '\(id)' carries no digit") }
        guard let f = id.utf8.first, (f >= 65 && f <= 90) else {
            return refuse("E1_IDENTITY", "accession '\(id)' does not begin with A-Z")
        }
    case "GENE_SYMBOL":
        if id.utf8.count < 1 || id.utf8.count > 24 { return refuse("E1_IDENTITY", "gene symbol '\(id)' is not 1..24 characters") }
        guard let f = id.utf8.first, (f >= 65 && f <= 90) else {
            return refuse("E1_IDENTITY", "gene symbol '\(id)' does not begin with A-Z")
        }
    case "CONTENT_DIGEST":
        if !isHex64(id) { return refuse("E1_IDENTITY", "content digest '\(id)' is not 64 lowercase hex characters") }
        if e.first("DIGEST_OF") == nil {
            return refuse("E1_IDENTITY",
                          "a CONTENT_DIGEST identity carries no DIGEST_OF. A bare 64-hex string names nothing to a human, and a library nobody can navigate is a library nobody uses.")
        }
        if !e.all("FIGURE").contains(where: { $0.contains(id) }) {
            return refuse("E1_IDENTITY",
                          "the content digest naming this entry is not among its own FIGURE lines, so no program in reproduce/ is claimed to print it. A library may not name a file that nothing in the pipeline ever saw.")
        }
    case "SPEC_NAME":
        if id.utf8.count < 2 || id.utf8.count > 40 { return refuse("E1_IDENTITY", "spec name '\(id)' is not 2..40 characters") }
        guard let f = id.utf8.first, (f >= 65 && f <= 90) else {
            return refuse("E1_IDENTITY", "spec name '\(id)' does not begin with A-Z")
        }
        for u in id.utf8 {
            let ok = (u >= 48 && u <= 57) || (u >= 65 && u <= 90) || u == 45 || u == 46 || u == 95
            if !ok { return refuse("E1_IDENTITY", "spec name '\(id)' carries a character outside A-Z0-9 and - . _") }
        }
        guard let auth = e.first("SPEC_AUTHORITY"), !trim(auth).isEmpty else {
            return refuse("E1_IDENTITY",
                          "SPEC_NAME '\(id)' carries no SPEC_AUTHORITY. A name with nobody behind it is a nickname, and this wiki has already retired a corpus keyed on generated nicknames.")
        }
    default:
        return refuse("E1_IDENTITY", "unreachable kind")
    }
    return pass_("E1_IDENTITY", "\(kind) \(id) is well formed")
}

func clauseE2_measured(_ e: Entry) -> ClauseResult {
    guard let m = e.first("MEASURED") else {
        return refuse("E2_MEASURED", "MEASURED absent")
    }
    // hasDigit() was the test here and it accepted "E8 is a good lattice and it works
    // well in practice." — a sentence with no measurement in it, whose only digit is
    // part of the object's NAME. The digit must stand free of the letters around it.
    if !(hasFreeDigit(m) || lower(m).contains("zero")) {
        if hasDigit(m) {
            return refuse("E2_MEASURED",
                          "MEASURED carries digits only inside identifiers: '\(m)'. Every digit here abuts a letter, so it names something rather than counting it. A description is not a measurement.")
        }
        return refuse("E2_MEASURED", "MEASURED carries no quantity: '\(m)'. A description is not a measurement.")
    }
    return pass_("E2_MEASURED", "\(m.utf8.count) bytes, carries a digit standing free of the letters around it")
}

func clauseE3_program(_ e: Entry, _ ev: Evidence) -> ClauseResult {
    guard let p = e.first("PROGRAM") else { return refuse("E3_PROGRAM", "PROGRAM absent") }
    if !ev.censusKnown {
        return hold("E3_PROGRAM", "the reproduce/ census is unreadable here, so membership is NOT_KNOWN — it is not a pass")
    }
    if !ev.programs.contains(p) {
        return refuse("E3_PROGRAM", "'\(p)' is not a program in reproduce/. An entry whose claim no program produces cannot enter.")
    }
    return pass_("E3_PROGRAM", "\(p).swift is in reproduce/")
}

func clauseE4_figures(_ e: Entry, _ ev: Evidence) -> ClauseResult {
    let figs = e.all("FIGURE")
    if figs.isEmpty {
        return refuse("E4_FIGURE", "no FIGURE. An entry with no figure has no number a stranger can check.")
    }
    guard let p = e.first("PROGRAM") else { return refuse("E4_FIGURE", "PROGRAM absent, so no figure can be attributed") }
    // A figure too short to be a number is refused BEFORE any transcript is consulted:
    // it is a defect in the entry, not an absence of evidence, so it may not be HELD.
    for f in figs {
        let ft = trim(f)
        if ft.utf8.count < FIGURE_MIN_BYTES {
            return refuse("E4_FIGURE",
                          "FIGURE '\(f)' is \(ft.utf8.count) byte(s). A figure shorter than \(FIGURE_MIN_BYTES) matches a line of almost any transcript, so it is not a number a stranger can check.")
        }
        if !ft.contains(where: { $0.isLetter || $0.isNumber }) {
            return refuse("E4_FIGURE",
                          "FIGURE '\(f)' carries no letter and no digit. Punctuation matches everywhere and states nothing.")
        }
    }
    guard let t = ev.transcript(p) else {
        return hold("E4_FIGURE",
                    "\(figs.count) figure(s) declared; no transcript for '\(p)' is present here. ABSENT IS NOT REFUSED — run the program and grade again.")
    }
    // A REFUSAL TRANSCRIPT CREDITS NOTHING, EVEN WHEN THE FIGURE IS IN IT.
    // Found 2026-09-08 on a live entry. Several programs now print their published
    // figures on EVERY exit path, refusal included, so the wiki harness can check a
    // page against its program from a clean clone with no corpus present. That is
    // right for the harness and it silently broke this clause: the figures were
    // matched against text the run QUOTED rather than text it COMPUTED, and E4
    // passed on a run that measured nothing. The old code reached the refusal test
    // only when a figure was MISSING, so a program that quotes all of its figures
    // was never tested for having refused. Absence and refusal are different
    // answers; so are "computed it" and "printed it".
    if isRefusalTranscript(t) {
        return hold("E4_FIGURE",
                    "\(figs.count) figure(s) declared, and \(p)'s output here is ITSELF A REFUSAL — it published no verdict, so any figure appearing in it was QUOTED, not computed. A quoted figure is not evidence. Run the program against its corpus and grade again.")
    }
    // READ THE COMPUTED REGION ONLY. A figure between the quoted fences was printed by
    // this run and computed by a DIFFERENT one; crediting it is the same error as
    // crediting a refusal transcript, one step subtler, because the run did complete.
    let tc = computedRegion(t)
    // TOKEN-ANCHORED, not `contains`. A whole-transcript substring test graded
    // "E8  : 24" as MEASURED against a line printing "E8  : 240".
    var missing: [String] = []
    var matched: [(String, String)] = []
    for f in figs {
        if let line = matchLineAtTokenBoundary(tc, f) { matched.append((f, trim(line))) }
        else { missing.append(f) }
    }
    if !missing.isEmpty {
        if isRefusalTranscript(t) {
            return hold("E4_FIGURE",
                        "\(missing.count) of \(figs.count) figure(s) are absent from \(p)'s output, but that output is ITSELF A REFUSAL — the program did not run to completion here, so its silence is not evidence about the figures. Run it against its corpus and grade again. First absent: '\(missing[0])'")
        }
        // A figure present only as the PREFIX of a longer token is a different fault
        // from a figure that is nowhere, and the refusal says which.
        var why = ""
        if t.contains(missing[0]) && !tc.contains(missing[0]) {
            why = " It appears ONLY between the quoted-reference fences, so this run printed it without computing it."
        } else if tc.contains(missing[0]) {
            why = " It occurs in that output only inside a longer token, which is a prefix and not the figure."
        }
        return refuse("E4_FIGURE",
                      "\(missing.count) of \(figs.count) figure(s) are NOT printed by \(p) at a token boundary: first is '\(missing[0])'.\(why)")
    }
    let shown = matched.map { "'\($0.0)' -> \"\($0.1)\"" }.joined(separator: " ; ")
    return pass_("E4_FIGURE", "all \(figs.count) figure(s) matched a line of \(p)'s output at a token boundary: \(shown)")
}

func clauseE5_seal(_ e: Entry, _ ev: Evidence) -> ClauseResult {
    guard let s = e.first("SEAL") else {
        return refuse("E5_SEAL", "SEAL absent. A blank seal field and a program that prints no seal are different states and must be written differently.")
    }
    if s != "NONE_PRINTED" && !isHex64(s) {
        return refuse("E5_SEAL", "SEAL '\(s)' is neither 64 lowercase hex nor the token NONE_PRINTED")
    }
    guard let p = e.first("PROGRAM") else { return refuse("E5_SEAL", "PROGRAM absent, so no seal can be attributed") }
    guard let t = ev.transcript(p) else {
        return hold("E5_SEAL", "no transcript for '\(p)' is present here, so the seal cannot be checked against what the program prints")
    }
    // Same rule as E4: a seal between the quoted fences is one this run PRINTED and a
    // different one COMPUTED. Both directions of this clause read the computed region.
    let tc = computedRegion(t)
    if s == "NONE_PRINTED" {
        if let sealLine = findSealLine(tc) {
            return refuse("E5_SEAL", "the entry declares NONE_PRINTED but \(p) prints a seal: '\(sealLine)'. An entry may not hide a seal it has.")
        }
        if isRefusalTranscript(t) {
            return pass_("E5_SEAL", "\(p)'s output here is a refusal and emits no seal; the entry declares NONE_PRINTED rather than leaving the field blank. A 64-hex naming a corpus or a reference is an INPUT, not a seal.")
        }
        return pass_("E5_SEAL", "\(p) prints no seal, and the entry says so rather than leaving the field blank")
    }
    // A REFUSAL TRANSCRIPT EMITS NO SEAL, so a 64-hex found in one was quoted or is
    // an input. Tested BEFORE the containment test, which is the repair: the old
    // order reached the refusal branch only when the seal was ABSENT, so a program
    // that prints its published seal on its refusal path passed this clause against
    // a run that sealed nothing. Measured on peptide-homology-exact 2026-09-08.
    if isRefusalTranscript(t) {
        return hold("E5_SEAL",
                    "\(p)'s output here is a refusal: it published no verdict, so it emitted no seal, and any 64-hex in it is an INPUT or a QUOTED figure. \(t.contains(s) ? "The declared seal does appear in that text, which is exactly the trap: appearing and being computed are two different things." : "The declared seal does not appear.") Run the program against its corpus and grade again.")
    }
    if !tc.contains(s) {
        if isRefusalTranscript(t) {
            return hold("E5_SEAL",
                        "the seal \(s) is absent from \(p)'s output, but that output is ITSELF A REFUSAL — no verdict was published, so no seal was due. Run the program against its corpus and grade again.")
        }
        return refuse("E5_SEAL", "the seal \(s) does not appear in \(p)'s output. A seal the named program does not print is not that program's seal.")
    }
    return pass_("E5_SEAL", "\(s) is printed by \(p) in the region it computed")
}

func clauseE6_grade(_ e: Entry) -> ClauseResult {
    guard let g = e.first("GRADE") else { return refuse("E6_GRADE", "GRADE absent") }
    if !ONTOLOGY_GRADES.contains(g) {
        return refuse("E6_GRADE",
                      "'\(g)' is not a grade in Ontology.md. The set is: \(ONTOLOGY_GRADES.joined(separator: ", ")).")
    }
    return pass_("E6_GRADE", "\(g) is in Ontology.md's grade set")
}

func clauseE7_gradeSupported(_ e: Entry, _ e4: ClauseResult, _ e3: ClauseResult) -> ClauseResult {
    guard let g = e.first("GRADE") else { return refuse("E7_GRADE_SUPPORTED", "GRADE absent") }
    let hasSeal = (e.first("SEAL").map { isHex64($0) }) ?? false
    switch g {
    case "MEASURED":
        if e3.terminal == .REFUSED || e4.terminal == .REFUSED {
            return refuse("E7_GRADE_SUPPORTED", "graded MEASURED, but its program or its figures did not stand. MEASURED means a program in reproduce/ printed it.")
        }
        if e3.terminal == .NOT_KNOWN || e4.terminal == .NOT_KNOWN {
            return hold("E7_GRADE_SUPPORTED", "graded MEASURED; the evidence for that grade is not present here")
        }
        return pass_("E7_GRADE_SUPPORTED", "MEASURED — E3 found the named program in reproduce/ and E4 matched every declared figure to a line of its output")
    case "VERIFIED":
        if e.first("SOURCE") == nil || e.first("QUOTE") == nil {
            return refuse("E7_GRADE_SUPPORTED",
                          "graded VERIFIED with no SOURCE+QUOTE. Ontology.md: VERIFIED means fetched and read, with the row or sentence quoted. On this evidence the entry supports REPORTED at most.")
        }
        return pass_("E7_GRADE_SUPPORTED", "VERIFIED, with SOURCE and a quoted sentence")
    case "REPORTED":
        if e.first("SOURCE") == nil {
            return refuse("E7_GRADE_SUPPORTED", "graded REPORTED with no SOURCE. Reported by whom?")
        }
        if hasSeal {
            return refuse("E7_GRADE_SUPPORTED",
                          "graded REPORTED while carrying our own 64-hex seal. A seal means we produced it, and that is MEASURED, not REPORTED.")
        }
        return pass_("E7_GRADE_SUPPORTED", "REPORTED, with a SOURCE and no seal of ours")
    case "CITED_NOT_MEASURED":
        if e.first("SOURCE") == nil {
            return refuse("E7_GRADE_SUPPORTED", "graded CITED_NOT_MEASURED with no SOURCE")
        }
        if hasSeal {
            return refuse("E7_GRADE_SUPPORTED",
                          "graded CITED_NOT_MEASURED while carrying a seal. Ontology.md forbids using a cited figure in a seal.")
        }
        return pass_("E7_GRADE_SUPPORTED", "CITED_NOT_MEASURED, sourced and unsealed")
    case "PROJECTION":
        if e.first("ASSUMPTION") == nil {
            return refuse("E7_GRADE_SUPPORTED",
                          "graded PROJECTION with no ASSUMPTION. Ontology.md forbids a projection appearing without its assumption and its falsifiers on the same page.")
        }
        return pass_("E7_GRADE_SUPPORTED", "PROJECTION, with its scaling assumption stated")
    case "ABSENT":
        if e.first("METHOD") == nil {
            return refuse("E7_GRADE_SUPPORTED",
                          "graded ABSENT with no METHOD. Ontology.md: ABSENT is measured, with the method of measurement stated — otherwise it is indistinguishable from not having looked.")
        }
        return pass_("E7_GRADE_SUPPORTED", "ABSENT, with the method of measurement stated")
    case "NOT_KNOWN":
        return pass_("E7_GRADE_SUPPORTED", "NOT_KNOWN is a terminal, not a failure. It asks nothing further of the evidence.")
    default:
        return refuse("E7_GRADE_SUPPORTED", "grade '\(g)' has no support rule")
    }
}

func clauseE8_refusal(_ e: Entry) -> ClauseResult {
    let r = e.all("REFUSED").filter { !trim($0).isEmpty }
    if r.isEmpty {
        return refuse("E8_REFUSAL",
                      "no REFUSED line. An entry with no refusal line is overclaiming by omission — it lets a reader take the largest reading the words allow.")
    }
    return pass_("E8_REFUSAL", "\(r.count) refusal line(s): what we explicitly do NOT call it")
}

func clauseE9_reproduce(_ e: Entry) -> ClauseResult {
    guard let c = e.first("REPRODUCE") else { return refuse("E9_REPRODUCE", "REPRODUCE absent") }
    let lc = lower(c)
    for tok in PRIVATE_PATH_TOKENS where lc.contains(tok) {
        return refuse("E9_REPRODUCE",
                      "the command carries '\(tok)', a path private to one machine. A stranger with a clean clone cannot run it, and a private path in a public program is an identifier we did not mean to publish.")
    }
    guard let p = e.first("PROGRAM") else { return refuse("E9_REPRODUCE", "PROGRAM absent") }
    if !c.contains(p) {
        return refuse("E9_REPRODUCE", "the command does not name the program '\(p)' it claims to run")
    }
    return pass_("E9_REPRODUCE", "runs from a clean clone and names \(p)")
}

func clauseE10_notAdvice(_ e: Entry) -> ClauseResult {
    guard let n = e.first("NOT_ADVICE"), !trim(n).isEmpty else {
        return refuse("E10_NOT_ADVICE",
                      "NOT_ADVICE absent. A row gets copied out of a library; the line that says this is not medical advice and not a recommendation must travel WITH the row, never sit only in a preamble the reader may never open.")
    }
    return pass_("E10_NOT_ADVICE", "the standing line travels with the entry")
}

struct ProcedureHit {
    let rule: String
    let verb: String
    let quantity: String
    let line: String
}

// Tokens on this line that are a QUANTITY WITH A UNIT: "42 g", "5mL", "1450 C".
// Returned as a list so rule C can count them and name them in its refusal.
func quantityTokens(_ v: String) -> [String] {
    let lc = lower(v)
    let toks = lc.split(whereSeparator: { $0 == " " || $0 == "," || $0 == ";" || $0 == "(" || $0 == ")" }).map(String.init)
    var found: [String] = []
    var i = 0
    while i < toks.count {
        let t = toks[i]
        if hasDigit(t) {
            var tail = ""
            for ch in t where !(ch >= "0" && ch <= "9") && ch != "." && ch != "," { tail.append(ch) }
            if QUANTITY_UNITS.contains(tail) {
                found.append(t)
            } else if i + 1 < toks.count && QUANTITY_UNITS.contains(toks[i + 1]) {
                found.append(t + " " + toks[i + 1])
                i += 1
            }
        }
        i += 1
    }
    return found
}

func detectProcedure(_ fields: [(key: String, value: String)]) -> ProcedureHit? {
    for (_, v) in fields {
        let lc = lower(v)
        // Rule A FIRST — a fabrication verb AND a quantity with a unit on the same
        // line. It is checked before rule B because a line can satisfy both, and the
        // report must name the rule that actually caught it: an earlier revision
        // reported "imperative opening — no quantity needed" on a line carrying
        // 42 mg, 5 mL, 65 C and 12000 rpm. The refusal was right and its stated
        // reason was wrong, which is worse than either alone.
        var verbHit: String? = nil
        for verb in FABRICATION_VERBS where lc.contains(verb) { verbHit = verb; break }
        if let vb = verbHit {
            // find <digits><optional space><unit-token>
            let toks = lc.split(whereSeparator: { $0 == " " || $0 == "," || $0 == ";" || $0 == "(" || $0 == ")" }).map(String.init)
            var i = 0
            while i < toks.count {
                let t = toks[i]
                if hasDigit(t) {
                    // unit fused to the number, e.g. "600c" / "5g" / "12000rpm"
                    var tail = ""
                    for ch in t where !(ch >= "0" && ch <= "9") && ch != "." && ch != "," { tail.append(ch) }
                    if QUANTITY_UNITS.contains(tail) {
                        return ProcedureHit(rule: "A", verb: vb, quantity: t, line: v)
                    }
                    if i + 1 < toks.count && QUANTITY_UNITS.contains(toks[i + 1]) {
                        return ProcedureHit(rule: "A", verb: vb, quantity: t + " " + toks[i + 1], line: v)
                    }
                }
                i += 1
            }
        }
        // Rule B — an imperative opening, which needs no quantity at all.
        // "Dissolve the powder in the solvent until the solution runs clear."
        let firstWord = lower(trim(String(v.split(separator: " ").first ?? ""))).replacingOccurrences(of: ",", with: "")
        if FABRICATION_VERBS.contains(firstWord) {
            return ProcedureHit(rule: "B", verb: firstWord,
                                quantity: "no quantity required — the line opens as an instruction", line: v)
        }
    }
    // Rule C runs LAST, for the same reason rule A runs before rule B: a line can
    // satisfy more than one, and the report must name the rule that carries the most
    // specific evidence. A named fabrication verb is more specific than a count of
    // quantities, so where both are present the refusal says A.
    //
    // Rule C is what remains: a route written entirely in verbs this law deliberately
    // does not list — combine, heat, press, cool — trips no verb rule at all, and the
    // two verb rules report clean on a complete two-sentence procedure.
    for f in fields where !RULE_C_EXEMPT_KEYS.contains(f.key) {
        let q = quantityTokens(f.value)
        if q.count >= RULE_C_MIN_QUANTITIES {
            return ProcedureHit(rule: "C", verb: "(none — rule C is keyed on no verb)",
                                quantity: "\(q.count) quantities with units on one line: " + q.joined(separator: ", "),
                                line: f.value)
        }
    }
    return nil
}

func clauseE11_noProcedure(_ e: Entry) -> ClauseResult {
    if let h = detectProcedure(e.fields) {
        return refuse("E11_NO_PROCEDURE",
                      "C-007: a procedure a person could follow. rule \(h.rule), verb '\(h.verb)', quantity '\(h.quantity)', in: \(h.line)")
    }
    return pass_("E11_NO_PROCEDURE",
                 "matched none of the \(FABRICATION_VERBS.count) fabrication verbs (rules A and B) and no line outside \(RULE_C_EXEMPT_KEYS.joined(separator: "/")) carries \(RULE_C_MIN_QUANTITIES) or more quantities with units (rule C)")
}

func clauseE12_notSelfGraded(_ e: Entry) -> ClauseResult {
    var scanned: [String] = e.all("MEASURED")
    scanned.append(contentsOf: e.all("FIGURE"))
    for v in scanned {
        let lc = lower(v)
        for tok in SELF_GRADED_TOKENS where lc.contains(tok) {
            return refuse("E12_NOT_SELF_GRADED",
                          "the evidence is the generator's own opinion of itself: '\(tok)' appears in a MEASURED or FIGURE line. Those columns measure nothing outside the program that wrote them, and in this wiki's corpora every one of them is a Double.")
        }
    }
    return pass_("E12_NOT_SELF_GRADED",
                 "none of the \(SELF_GRADED_TOKENS.count) barred tokens appears in any of this entry's \(scanned.count) MEASURED or FIGURE line(s)")
}

func clauseE13_falsifier(_ e: Entry) -> ClauseResult {
    guard let f = e.first("FALSIFIER"), !trim(f).isEmpty else {
        return refuse("E13_FALSIFIER",
                      "no FALSIFIER. An entry nothing could refute is not evidence, and there is nothing for a later refutation to be filed against.")
    }
    return pass_("E13_FALSIFIER", "names the observation that would overturn it")
}

func looksLikeISODate(_ s: String) -> Bool {
    // YYYY-MM-DD somewhere in the string, checked by shape, no parsing
    let b = Array(s.utf8)
    if b.count < 10 { return false }
    var i = 0
    while i + 10 <= b.count {
        func d(_ j: Int) -> Bool { b[j] >= 48 && b[j] <= 57 }
        if d(i) && d(i + 1) && d(i + 2) && d(i + 3) && b[i + 4] == 45
            && d(i + 5) && d(i + 6) && b[i + 7] == 45 && d(i + 8) && d(i + 9) {
            return true
        }
        i += 1
    }
    return false
}

func clauseE14_retraction(_ e: Entry) -> ClauseResult {
    let refs = e.all("REFUTED_BY")
    if refs.isEmpty {
        return pass_("E14_RETRACTION", "no refutation on file")
    }
    for r in refs where !looksLikeISODate(r) {
        return refuse("E14_RETRACTION",
                      "REFUTED_BY carries no YYYY-MM-DD date: '\(r)'. An undated refutation cannot be ordered against the claim it refutes.")
    }
    guard let g = e.first("GRADE") else { return refuse("E14_RETRACTION", "GRADE absent") }
    let permitted: [String] = ["NOT_KNOWN", "ABSENT", "REPORTED"]
    if !permitted.contains(g) {
        return refuse("E14_RETRACTION",
                      "the entry carries a refutation and is still graded \(g). A refuted entry is never deleted and never left at its old grade: it is superseded in place, at a grade the surviving evidence supports — \(permitted.joined(separator: ", ")).")
    }
    return pass_("E14_RETRACTION", "refuted, dated, and regraded to \(g) in place — the entry stays in the library with its history")
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION F2 — grading one entry
// ══════════════════════════════════════════════════════════════════════════

struct EntryVerdict {
    let label: String
    let entry: Entry?
    let terminal: Terminal
    let clauses: [ClauseResult]
    let fault: EntryFault?

    var codes: [String] { clauses.map { $0.code } }
    var refusedCodes: [String] { clauses.filter { $0.terminal == .REFUSED }.map { $0.code } }
    var heldCodes: [String] { clauses.filter { $0.terminal == .NOT_KNOWN }.map { $0.code } }
}

func gradeEntry(_ text: String, label: String, _ ev: Evidence) -> EntryVerdict {
    let e: Entry
    do {
        e = try parseEntry(text, label: label)
    } catch let f as EntryFault {
        return EntryVerdict(label: label, entry: nil, terminal: .REFUSED,
                            clauses: [refuse(f.code, f.detail)], fault: f)
    } catch {
        return EntryVerdict(label: label, entry: nil, terminal: .REFUSED,
                            clauses: [refuse("ENTRY_UNREADABLE", "\(error)")], fault: nil)
    }

    var cs: [ClauseResult] = []
    cs.append(clauseE0_shape(e))
    cs.append(clauseE1_identity(e))
    cs.append(clauseE2_measured(e))
    let e3 = clauseE3_program(e, ev); cs.append(e3)
    let e4 = clauseE4_figures(e, ev); cs.append(e4)
    cs.append(clauseE5_seal(e, ev))
    cs.append(clauseE6_grade(e))
    cs.append(clauseE7_gradeSupported(e, e4, e3))
    cs.append(clauseE8_refusal(e))
    cs.append(clauseE9_reproduce(e))
    cs.append(clauseE10_notAdvice(e))
    cs.append(clauseE11_noProcedure(e))
    cs.append(clauseE12_notSelfGraded(e))
    cs.append(clauseE13_falsifier(e))
    cs.append(clauseE14_retraction(e))

    var t: Terminal = .ADMITTED
    if cs.contains(where: { $0.terminal == .REFUSED }) { t = .REFUSED }
    else if cs.contains(where: { $0.terminal == .NOT_KNOWN }) { t = .NOT_KNOWN }
    return EntryVerdict(label: label, entry: e, terminal: t, clauses: cs, fault: nil)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION G — the per-library clauses, L1 .. L9
//
// THE HALF NO PER-ENTRY CHECK CAN REACH. Every clause here holds every entry at
// once. The ceilings are declared by the library in its own manifest and tested
// by integer comparison, PER VALUE:
//
//     count(most repeated value) <= declaredEntriesPer
//
// never by a ratio, and never in aggregate. The aggregate form this once used —
// distinct * declared >= entries — is a different test with the same name: it
// admitted 8 entries over 4 values against a declared ceiling of 2 while one value
// carried 5 of the 8, printing "4 x 2 >= 8" as it did so. The declared integer is
// the library saying, in advance, how much repetition it considers honest AT ONE
// VALUE, and a stale declaration silently re-admits what was just excluded, which is
// why an addition must move it in the same commit.
// ══════════════════════════════════════════════════════════════════════════

struct Manifest {
    let library: String
    let perIdentity: Int
    let perProgram: Int
    let perSeal: Int
    let perMeasured: Int
    let perTriple: Int
    let publishedPage: String
    let openSlots: [String]
}

// OPEN_SLOT is not an entry and is never counted as one. A slot is a measurement
// this library has NAMED and does not have: no program, no figures, no seal, and
// nothing yet to hold. A HELD entry is different — its evidence exists somewhere
// and is merely not present at this run. Collapsing the two would let a library
// announce a result before it had one, which is the oldest way a corpus grows a
// row count. Slots are printed, dated, and gated on nothing.
func parseManifest(_ text: String) -> (Manifest?, String) {
    var lib = ""
    var pi = -1, pp = -1, ps = -1, pm = -1, pt = -1
    var page = ""
    var slots: [String] = []
    for ln in splitLines(text) {
        let t = trim(ln)
        if t.isEmpty || t.hasPrefix("#") { continue }
        let parts = t.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).map { trim(String($0)) }
        if parts.count != 2 { return (nil, "manifest line is not `KEY value`: '\(t)'") }
        let k = parts[0], v = parts[1]
        switch k {
        case "LIBRARY": lib = v
        case "DECLARED_ENTRIES_PER_IDENTITY": pi = Int(v) ?? -1
        case "DECLARED_ENTRIES_PER_PROGRAM":  pp = Int(v) ?? -1
        case "DECLARED_ENTRIES_PER_SEAL":     ps = Int(v) ?? -1
        case "DECLARED_ENTRIES_PER_MEASURED": pm = Int(v) ?? -1
        case "DECLARED_ENTRIES_PER_TRIPLE":   pt = Int(v) ?? -1
        case "PUBLISHED_PAGE":                page = v
        case "OPEN_SLOT":                     slots.append(v)
        default: return (nil, "'\(k)' is not a manifest key")
        }
    }
    if lib.isEmpty { return (nil, "manifest names no LIBRARY") }
    if pi < 1 || pp < 1 || ps < 1 || pm < 1 || pt < 1 {
        return (nil, "every DECLARED_ENTRIES_PER_* must be an integer >= 1; got identity=\(pi) program=\(pp) seal=\(ps) measured=\(pm) triple=\(pt)")
    }
    if page.isEmpty {
        return (nil, "manifest names no PUBLISHED_PAGE. The gradeable artefact is this directory; the artefact a stranger reads is a page. A library that does not name its own page cannot be checked against it, and the two drift silently.")
    }
    return (Manifest(library: lib, perIdentity: pi, perProgram: pp, perSeal: ps,
                     perMeasured: pm, perTriple: pt, publishedPage: page, openSlots: slots), "")
}

struct AxisCount {
    let axis: String
    let entries: Int
    let distinct: Int
    let declared: Int
    let table: [(value: String, count: Int)]
    // PER VALUE. `table` is sorted by count descending, so `table.first` IS the most
    // repeated value and its count is the only number the declared ceiling is about.
    var worstCount: Int { table.first?.count ?? 0 }
    var holds: Bool { worstCount <= declared }
    var worst: (String, Int)? { table.first.map { ($0.value, $0.count) } }
}

func countAxis(_ axis: String, _ values: [String], declared: Int) -> AxisCount {
    var freq: [String: Int] = [:]
    for v in values { freq[v, default: 0] += 1 }
    let table = freq.map { (value: $0.key, count: $0.value) }
        .sorted { a, b in a.count != b.count ? a.count > b.count : utf8Less(a.value, b.value) }
    return AxisCount(axis: axis, entries: values.count, distinct: freq.count, declared: declared, table: table)
}

struct LibraryVerdict {
    let dir: String
    let name: String
    let terminal: Terminal
    let entryVerdicts: [EntryVerdict]
    let admitted: [EntryVerdict]
    let held: [EntryVerdict]
    let refused: [EntryVerdict]
    let axes: [AxisCount]
    let clauses: [ClauseResult]
    let sealless: Int
    let gradeCensus: [(String, Int)]
    let openSlots: [String]
    let publishedPage: String
    // The (IDENTITY, PROGRAM, SEAL) triples of this library's ADMITTED entries, so the
    // federation clause can ask a question about two libraries at once without either
    // library having to know the other exists.
    let triples: [(key: String, label: String)]
}

// Every ```affine-entry block in a page or a file, normalised so that a difference in
// trailing whitespace is not reported as a difference in content.
func extractEntryBlocks(_ text: String) -> [String] {
    var blocks: [String] = []
    var cur: [String] = []
    var inside = false
    for ln in splitLines(text) {
        if !inside {
            if trim(ln) == "```affine-entry" { inside = true; cur = [] }
        } else {
            if trim(ln) == "```" {
                inside = false
                blocks.append(cur.map { trim($0) }.filter { !$0.isEmpty }.joined(separator: "\n"))
            } else {
                cur.append(ln)
            }
        }
    }
    return blocks
}

func gradeLibrary(dir: String, entryFiles: [(String, String)], manifestText: String?,
                  pageText: String?, _ ev: Evidence) -> LibraryVerdict {
    var clauses: [ClauseResult] = []

    // L1 — a gate given NOTHING must not pass.
    if entryFiles.isEmpty {
        clauses.append(refuse("L1_NOT_EMPTY",
                              "the library holds NO entries. An empty library is REFUSED, never reported clean: zero admitted entries is the weakest possible evidence and reporting it as a clean library is the strongest possible claim."))
        return LibraryVerdict(dir: dir, name: "(unknown)", terminal: .REFUSED, entryVerdicts: [],
                              admitted: [], held: [], refused: [], axes: [], clauses: clauses,
                              sealless: 0, gradeCensus: [], openSlots: [],
                              publishedPage: "(none)", triples: [])
    }
    clauses.append(pass_("L1_NOT_EMPTY", "\(entryFiles.count) entry file(s) present"))

    // L2 — the manifest, and its declared ceilings.
    var man: Manifest? = nil
    if let mt = manifestText {
        let (m, err) = parseManifest(mt)
        if let m = m {
            man = m
            clauses.append(pass_("L2_MANIFEST",
                                 "LIBRARY \(m.library) declares: per identity \(m.perIdentity), per program \(m.perProgram), per seal \(m.perSeal), per measured \(m.perMeasured), per triple \(m.perTriple); page \(m.publishedPage); open slots \(m.openSlots.count)"))
        } else {
            clauses.append(refuse("L2_MANIFEST", "LIBRARY.manifest is malformed: \(err)"))
        }
    } else {
        clauses.append(refuse("L2_MANIFEST",
                              "no LIBRARY.manifest. A library that declares no ceiling has declared that any amount of repetition is acceptable, which is how a row count becomes the headline."))
    }

    var verdicts: [EntryVerdict] = []
    for (label, text) in entryFiles.sorted(by: { utf8Less($0.0, $1.0) }) {
        verdicts.append(gradeEntry(text, label: label, ev))
    }
    let admitted = verdicts.filter { $0.terminal == .ADMITTED }
    let held = verdicts.filter { $0.terminal == .NOT_KNOWN }
    let refusedV = verdicts.filter { $0.terminal == .REFUSED }

    // L7 — no entry refused. One bad entry is the library's problem, not the reader's.
    if refusedV.isEmpty {
        clauses.append(pass_("L7_NO_ENTRY_REFUSED", "0 of \(verdicts.count) entries refused"))
    } else {
        let names = refusedV.map { $0.label }.joined(separator: ", ")
        clauses.append(refuse("L7_NO_ENTRY_REFUSED",
                              "\(refusedV.count) of \(verdicts.count) entries refused: \(names). The library does not publish while one of its entries is refused."))
    }

    // The distinct counts run over the ADMITTED set. A held entry is not in the
    // library yet and a refused entry never was, so counting either would report a
    // diversity the library does not have.
    let m = man ?? Manifest(library: "(undeclared)", perIdentity: 1, perProgram: 1,
                            perSeal: 1, perMeasured: 1, perTriple: 1,
                            publishedPage: "(undeclared)", openSlots: [])
    var axes: [AxisCount] = []
    let ids = admitted.compactMap { $0.entry?.first("IDENTITY") }
    let progs = admitted.compactMap { $0.entry?.first("PROGRAM") }
    let seals = admitted.compactMap { $0.entry?.first("SEAL") }.filter { $0 != "NONE_PRINTED" }
    let sealless = admitted.count - seals.count
    let meas = admitted.compactMap { $0.entry?.first("MEASURED") }
    let titles = admitted.compactMap { $0.entry?.first("TITLE") }
    let grades = admitted.compactMap { $0.entry?.first("GRADE") }
    // The whole triple. Three entries may legitimately share one identity, one program
    // and one seal — one run over one corpus answering three separable questions — but
    // the library must SAY how many, in advance, exactly as it does on every other
    // axis. This is the same-library half of "an entry may not be filed twice", and it
    // is a per-library question: the federation clause below asks the other half.
    let tripleKeys: [(key: String, label: String)] = admitted.compactMap { v in
        guard let en = v.entry else { return nil }
        let k = (en.first("IDENTITY") ?? "") + " | " + (en.first("PROGRAM") ?? "") + " | " + (en.first("SEAL") ?? "")
        return (key: k, label: v.label)
    }

    axes.append(countAxis("IDENTITY", ids, declared: m.perIdentity))
    axes.append(countAxis("PROGRAM", progs, declared: m.perProgram))
    axes.append(countAxis("SEAL (sealed entries only)", seals, declared: m.perSeal))
    axes.append(countAxis("MEASURED", meas, declared: m.perMeasured))
    axes.append(countAxis("IDENTITY|PROGRAM|SEAL triple", tripleKeys.map { $0.key }, declared: m.perTriple))
    axes.append(countAxis("TITLE (census, not a gate)", titles, declared: admitted.count == 0 ? 1 : admitted.count))
    axes.append(countAxis("GRADE (census, not a gate)", grades, declared: admitted.count == 0 ? 1 : admitted.count))

    func gateAxis(_ code: String, _ a: AxisCount, _ why: String) {
        if a.entries == 0 {
            clauses.append(hold(code, "no admitted entry carries this axis, so the count is NOT_KNOWN rather than clean"))
            return
        }
        // The most repeated value is printed on BOTH paths. A pass that says only
        // "it holds" hides how close the library is to its own declared ceiling, and
        // the aggregate form of this test hid a value carrying 5 against a declared 2.
        let w = a.worst.map { "'\($0.0)' carries \(grp($0.1))" } ?? "(none)"
        let n = "\(grp(a.entries)) entr\(a.entries == 1 ? "y" : "ies")"
        if a.holds {
            clauses.append(pass_(code,
                                 "\(n), \(grp(a.distinct)) distinct; most repeated value \(w), declared ceiling \(a.declared) per value — \(grp(a.worstCount)) <= \(a.declared)"))
        } else {
            clauses.append(refuse(code,
                                  "the most repeated value exceeds the declared ceiling of \(a.declared) per value: \(w), and \(grp(a.worstCount)) > \(a.declared). \(n) over \(grp(a.distinct)) distinct. \(why)"))
        }
    }

    gateAxis("L3_DISTINCT_IDENTITY", axes[0],
             "A row count and a distinct-identity count are two numbers and must be published together; where they diverge, the row count is the loop bound and not the knowledge.")
    gateAxis("L4_DISTINCT_PROGRAM", axes[1],
             "One program cited by every entry is one measurement wearing N hats.")
    if seals.isEmpty {
        clauses.append(hold("L5_DISTINCT_SEAL",
                            "no admitted entry carries a seal (\(sealless) declare NONE_PRINTED). Sealless entries are counted and named here, never folded into a seal bucket."))
    } else {
        gateAxis("L5_DISTINCT_SEAL", axes[2],
                 "One seal under N identities is one measurement carved into N entries.")
    }
    gateAxis("L6_DISTINCT_MEASURED", axes[3],
             "N identities carrying one finding is the same collapse on a different axis — the axis that varies is never the axis that lies.")
    gateAxis("L8_DISTINCT_TRIPLE", axes[4],
             "Identity, program and seal all equal is one measurement filed more than the library said it would file it. Raise the declared ceiling in public, or split the entry so the triples differ.")

    // L9 — the page a stranger reads must be the directory the checker grades.
    //
    // The gradeable artefact is this directory. The artefact anybody actually opens is
    // the published page. Nothing made them agree: measured on the day this clause was
    // written they DID agree, and that was a fact about that hour, not a gate.
    if let pt = pageText {
        let pageBlocks = extractEntryBlocks(pt).sorted(by: utf8Less)
        let dirBlocks = entryFiles.flatMap { extractEntryBlocks($0.1) }.sorted(by: utf8Less)
        if pageBlocks.isEmpty {
            clauses.append(refuse("L9_PAGE_MATCHES_DIR",
                                  "\(m.publishedPage) carries NO affine-entry block. The page a stranger reads publishes none of the entries this directory holds."))
        } else if pageBlocks == dirBlocks {
            clauses.append(pass_("L9_PAGE_MATCHES_DIR",
                                 "\(m.publishedPage) carries \(grp(pageBlocks.count)) entry block(s), identical as a multiset to the \(grp(dirBlocks.count)) in this directory"))
        } else {
            var onlyPage = 0, onlyDir = 0
            for b in pageBlocks where !dirBlocks.contains(b) { onlyPage += 1 }
            for b in dirBlocks where !pageBlocks.contains(b) { onlyDir += 1 }
            clauses.append(refuse("L9_PAGE_MATCHES_DIR",
                                  "\(m.publishedPage) and this directory disagree: \(grp(pageBlocks.count)) block(s) on the page against \(grp(dirBlocks.count)) here; \(grp(onlyPage)) on the page only and \(grp(onlyDir)) here only. The checker grades the directory and the reader reads the page, so a difference between them is a claim nobody checked."))
        }
    } else {
        clauses.append(hold("L9_PAGE_MATCHES_DIR",
                            "\(m.publishedPage) is not readable from here, so page and directory cannot be compared. ABSENT IS NOT AGREEMENT."))
    }

    var t: Terminal = .ADMITTED
    if clauses.contains(where: { $0.terminal == .REFUSED }) { t = .REFUSED }
    else if admitted.isEmpty { t = .NOT_KNOWN }
    else if clauses.contains(where: { $0.terminal == .NOT_KNOWN }) { t = .NOT_KNOWN }

    var census: [String: Int] = [:]
    for g in grades { census[g, default: 0] += 1 }
    let censusSorted = census.map { ($0.key, $0.value) }
        .sorted { a, b in a.1 != b.1 ? a.1 > b.1 : utf8Less(a.0, b.0) }

    return LibraryVerdict(dir: dir, name: m.library, terminal: t, entryVerdicts: verdicts,
                          admitted: admitted, held: held, refused: refusedV, axes: axes,
                          clauses: clauses, sealless: sealless, gradeCensus: censusSorted,
                          openSlots: m.openSlots, publishedPage: m.publishedPage,
                          triples: tripleKeys)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION G2 — THE FEDERATION CLAUSE, F1. Between libraries, never inside one.
//
// CORRECTED 2026-09-07, and the correction is the point of the clause.
//
// F1 used to key on (IDENTITY, PROGRAM, SEAL) across every admitted entry of every
// library at once, without asking which library each came from. Run on the three seed
// libraries in ONE command it printed
//
//     F1_NO_ENTRY_FILED_TWICE   REFUSED — 1 entry is filed twice
//
// for a triple carried by THREE entries, all three inside ONE library, and its ok text
// and its refusal text both said "in two libraries". Three false statements in one
// line: the count was wrong, the plural was wrong, and the relation it named was not
// the relation it had measured. It also contradicted that library's own manifest,
// which declares PER_PROGRAM 5 and PER_SEAL 5 in public precisely to license one run
// answering several separable questions.
//
// Same-library repetition is now L8, tested against a ceiling the library declares.
// F1 is what is left, and it is the thing no per-library clause can see: ONE entry
// filed in TWO libraries, where no ceiling can license it, because an entry belongs
// to exactly one library or the two libraries are not two.
// ══════════════════════════════════════════════════════════════════════════

struct FederationVerdict {
    let clause: ClauseResult
    let libraries: Int
    let admittedTotal: Int
    let distinctTriples: Int
    let crossings: [(key: String, where_: [String])]
}

func federationVerdict(_ libs: [LibraryVerdict]) -> FederationVerdict {
    let admittedTotal = libs.reduce(0) { $0 + $1.admitted.count }
    // Two libraries can declare the same LIBRARY name, so the name alone does not
    // locate a crossing. The ordinal does, and it is stable within a run — unlike the
    // directory path, which is a fact about this filesystem and is never sealed.
    var seenIn: [String: [Int]] = [:]
    var placesOf: [String: [String]] = [:]
    for (li, lv) in libs.enumerated() {
        for t in lv.triples {
            seenIn[t.key, default: []].append(li)
            placesOf[t.key, default: []].append("library #\(li + 1) \(lv.name)/" + t.label)
        }
    }
    let distinct = seenIn.count
    var crossings: [(key: String, where_: [String])] = []
    for (k, libIdx) in seenIn {
        if Set(libIdx).count > 1 { crossings.append((key: k, where_: placesOf[k] ?? [])) }
    }
    crossings.sort { utf8Less($0.key, $1.key) }

    if libs.count < 2 {
        return FederationVerdict(
            clause: hold("F1_NO_ENTRY_FILED_TWICE",
                         "\(libs.count) librar\(libs.count == 1 ? "y was" : "ies were") graded in this run, so the relation BETWEEN libraries has nothing to hold over. This is NOT_KNOWN and it is NOT a clearance: grade every library in ONE command — --library A --library B --library C — before publishing any of them."),
            libraries: libs.count, admittedTotal: admittedTotal,
            distinctTriples: distinct, crossings: [])
    }
    if crossings.isEmpty {
        return FederationVerdict(
            clause: pass_("F1_NO_ENTRY_FILED_TWICE",
                          "no (identity, program, seal) triple appears in more than one of the \(libs.count) libraries graded together; \(grp(distinct)) distinct triples over \(grp(admittedTotal)) admitted entries. Repetition INSIDE a library is L8's question, against that library's declared ceiling, and F1 does not answer it."),
            libraries: libs.count, admittedTotal: admittedTotal,
            distinctTriples: distinct, crossings: [])
    }
    let n = crossings.count
    return FederationVerdict(
        clause: refuse("F1_NO_ENTRY_FILED_TWICE",
                       "\(grp(n)) tripl\(n == 1 ? "e is" : "es are") filed in more than one library. An entry belongs to exactly one library; the same measurement in two of them is counted twice by every reader who opens both, and no declared ceiling can license it."),
        libraries: libs.count, admittedTotal: admittedTotal,
        distinctTriples: distinct, crossings: crossings)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION H — reference figures. Printed on EVERY exit, including a refusal.
// ══════════════════════════════════════════════════════════════════════════

func printReferenceFigures() {
    rule("=")
    say("SECTION 0 — REFERENCE FIGURES (the law's own frozen integers)")
    rule("=")
    say("  per-entry clauses          15   E0 .. E14")
    say("  per-library clauses         9   L1 .. L9")
    say("  federation clauses          1   F1, between libraries, never inside one")
    say("  terminals                   3   ADMITTED / REFUSED / NOT_KNOWN")
    say("  grades in the ontology      \(ONTOLOGY_GRADES.count)   \(ONTOLOGY_GRADES.joined(separator: ", "))")
    say("  identity kinds              \(IDENTITY_KINDS.count)   \(IDENTITY_KINDS.joined(separator: ", "))")
    say("  required entry keys        \(REQUIRED_KEYS.count)   \(REQUIRED_KEYS.joined(separator: ", "))")
    say("  optional entry keys         \(OPTIONAL_KEYS.count)   \(OPTIONAL_KEYS.joined(separator: ", "))")
    say("  fabrication verbs          \(FABRICATION_VERBS.count)   C-007 detector, rules A and B")
    say("  rule C threshold             \(RULE_C_MIN_QUANTITIES)   quantities-with-units on one line, C-007, no verb needed")
    say("  quantity units             \(QUANTITY_UNITS.count)   the unit vocabulary rules A and C count with")
    say("  self-graded tokens          \(SELF_GRADED_TOKENS.count)   barred from MEASURED and FIGURE")
    say("  private-path tokens          \(PRIVATE_PATH_TOKENS.count)   barred from REPRODUCE by E9")
    say("  shortest admissible FIGURE   \(FIGURE_MIN_BYTES)   bytes; shorter matches almost any transcript")
    say("  ceiling test               count(most repeated value) <= declared   (integer, PER VALUE)")
    say("  figure match               token-anchored, never a bare substring")
    say("  the failure this prevents  37,910 rows, 5 distinct molecules, every row valid")
    say()
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION I — CONTROL ARM. Runs FIRST, on fixtures embedded above.
//
// Each arm declares the terminal AND the clause code it expects. An arm that
// refuses for a different reason than the one under test is recorded as
// REFUSED(wrong reason) and FAILS — otherwise a checker that refuses everything
// would score full marks on a suite of refusal arms.
// ══════════════════════════════════════════════════════════════════════════

struct Arm {
    let name: String
    let expect: Terminal
    let expectCode: String
    let got: Terminal
    let gotCodes: [String]
    var pass: Bool {
        if got != expect { return false }
        if expectCode.isEmpty { return true }
        return gotCodes.contains(expectCode)
    }
    var gotLabel: String {
        if got == expect && !pass { return "\(got.rawValue)(wrong reason: \(gotCodes.joined(separator: ",")))" }
        return got.rawValue + (expectCode.isEmpty ? "" : " via \(expectCode)")
    }
}

// A correctly-formed fixture entry. Every negative arm below is THIS entry with
// exactly one thing changed, so a refusal is attributable to that change and to
// nothing else.
let GOOD_FIXTURE = """
```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  UNII
IDENTITY       AXQ9493NT2
TITLE          fixture entry — the shape a real entry has
MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9
PROGRAM        fixture-program-alpha
FIGURE         alpha figure one : 42
FIGURE         alpha figure two : 7 of 9
SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68
GRADE          MEASURED
REFUSED        this fixture is not a finding about anything in the world
FALSIFIER      the same program printing a different integer for either figure
REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
```
"""

func mutate(_ base: String, replace: String, with: String) -> String {
    return base.replacingOccurrences(of: replace, with: with)
}

func runControlArm() -> (arms: [Arm], allPass: Bool) {
    let ev = EmbeddedEvidence()
    var arms: [Arm] = []

    func arm(_ name: String, _ text: String, _ expect: Terminal, _ code: String) {
        let v = gradeEntry(text, label: "arm", ev)
        arms.append(Arm(name: name, expect: expect, expectCode: code,
                        got: v.terminal, gotCodes: v.codes.enumerated().compactMap { i, c in
                            v.clauses[i].terminal == .ADMITTED ? nil : c
                        }))
    }

    // ── direction 1: the law must ADMIT a correctly-formed entry.
    arm("01 correctly-formed fixture entry", GOOD_FIXTURE, .ADMITTED, "")

    // ── direction 2: the six cases the brief names.
    arm("02 claim no program in reproduce/ prints (unknown program)",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-that-does-not-exist"),
        .REFUSED, "E3_PROGRAM")

    arm("03 claim no program in reproduce/ prints (figure absent from output)",
        mutate(GOOD_FIXTURE, replace: "FIGURE         alpha figure one : 42",
               with: "FIGURE         alpha figure one : 43"),
        .REFUSED, "E4_FIGURE")

    arm("04 no refusal line",
        mutate(GOOD_FIXTURE, replace: "REFUSED        this fixture is not a finding about anything in the world\n",
               with: ""),
        .REFUSED, "E8_REFUSAL")

    arm("05 no public identifier and no digest",
        mutate(GOOD_FIXTURE, replace: "IDENTITY       AXQ9493NT2",
               with: "IDENTITY       unknown"),
        .REFUSED, "E1_IDENTITY")

    arm("06 graded VERIFIED whose evidence supports only REPORTED",
        mutate(GOOD_FIXTURE, replace: "GRADE          MEASURED",
               with: "GRADE          VERIFIED"),
        .REFUSED, "E7_GRADE_SUPPORTED")

    // ── direction 3: the clauses this law adds beyond the brief.
    arm("07 grade ARGUMENT — reasonable, and not in Ontology.md",
        mutate(GOOD_FIXTURE, replace: "GRADE          MEASURED",
               with: "GRADE          ARGUMENT"),
        .REFUSED, "E6_GRADE")

    arm("08 a seal the named program does not print",
        mutate(GOOD_FIXTURE, replace: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
               with: "SEAL           0000000000000000000000000000000000000000000000000000000000000000"),
        .REFUSED, "E5_SEAL")

    arm("09 an entry hiding a seal its program does print",
        mutate(GOOD_FIXTURE, replace: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
               with: "SEAL           NONE_PRINTED"),
        .REFUSED, "E5_SEAL")

    arm("10 REPRODUCE carrying a path private to one machine",
        mutate(GOOD_FIXTURE, replace: "REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift -o /tmp/run && /tmp/run",
               with: "REPRODUCE      cd ~/wiki && xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift -o /tmp/run && /tmp/run"),
        .REFUSED, "E9_REPRODUCE")

    arm("11 a synthesis procedure (C-007), rule A: verb plus quantity",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       42 mg of the ligand, anneal at 600 C for 4 h, yield 7 of 9"),
        .REFUSED, "E11_NO_PROCEDURE")

    arm("12 a synthesis procedure (C-007), rule B: imperative opening, no quantity",
        mutate(GOOD_FIXTURE, replace: "NOTE_PLACEHOLDER", with: "NOTE_PLACEHOLDER")
            .replacingOccurrences(of: "TITLE          fixture entry — the shape a real entry has",
                                  with: "NOTE           Dissolve the powder in the solvent until the solution runs clear\nTITLE          fixture entry — the shape a real entry has"),
        .REFUSED, "E11_NO_PROCEDURE")

    arm("13 evidence that is the generator's own opinion of itself",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       mean confidence 0.94 across 42 candidates, all validation_passed"),
        .REFUSED, "E12_NOT_SELF_GRADED")

    arm("14 nothing could refute it",
        mutate(GOOD_FIXTURE, replace: "FALSIFIER      the same program printing a different integer for either figure\n",
               with: ""),
        .REFUSED, "E13_FALSIFIER")

    arm("15 the standing not-advice line does not travel with the entry",
        mutate(GOOD_FIXTURE, replace: "NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.\n",
               with: ""),
        .REFUSED, "E10_NOT_ADVICE")

    arm("16 refuted, and still graded MEASURED",
        mutate(GOOD_FIXTURE, replace: "REFUSED        this fixture is not a finding about anything in the world",
               with: "REFUSED        this fixture is not a finding about anything in the world\nREFUTED_BY     an independent screen disagreeing, 2026-09-07"),
        .REFUSED, "E14_RETRACTION")

    arm("17 refuted, undated",
        mutate(GOOD_FIXTURE, replace: "GRADE          MEASURED",
               with: "GRADE          NOT_KNOWN")
            .replacingOccurrences(of: "REFUSED        this fixture is not a finding about anything in the world",
                                  with: "REFUSED        this fixture is not a finding about anything in the world\nREFUTED_BY     an independent screen disagreeing, last spring"),
        .REFUSED, "E14_RETRACTION")

    arm("18 refuted, dated, and regraded in place — must be ADMITTED, not deleted",
        mutate(GOOD_FIXTURE, replace: "GRADE          MEASURED",
               with: "GRADE          NOT_KNOWN")
            .replacingOccurrences(of: "REFUSED        this fixture is not a finding about anything in the world",
                                  with: "REFUSED        this fixture is not a finding about anything in the world\nREFUTED_BY     an independent screen disagreeing, 2026-09-07"),
        .ADMITTED, "")

    arm("19 a mistyped key silently dropping a clause",
        mutate(GOOD_FIXTURE, replace: "REFUSED        this fixture",
               with: "REFUSE         this fixture"),
        .REFUSED, "ENTRY_UNKNOWN_KEY")

    arm("20 a zero-byte entry", "", .REFUSED, "ENTRY_IS_ZERO_BYTES")

    arm("21 a page with prose and no machine-readable block",
        "# A study\n\nWe measured a great many things and they were all good.\n",
        .REFUSED, "ENTRY_BLOCK_ABSENT")

    arm("22 a MEASURED line carrying no quantity",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       the compound performed well against the target"),
        .REFUSED, "E2_MEASURED")

    // ── direction 4: NOT_KNOWN is neither of the other two.
    arm("23 a program that prints no seal, declared NONE_PRINTED",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-beta")
            .replacingOccurrences(of: "FIGURE         alpha figure one : 42\nFIGURE         alpha figure two : 7 of 9",
                                  with: "FIGURE         beta figure : 240 by direct enumeration")
            .replacingOccurrences(of: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
                                  with: "SEAL           NONE_PRINTED")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       240 by direct enumeration")
            .replacingOccurrences(of: "REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift -o /tmp/run && /tmp/run",
                                  with: "REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-beta.swift -o /tmp/run && /tmp/run"),
        .ADMITTED, "")

    // ── direction 5: CONTROLS ON THE CONTROLS. A detector that fires on honest
    // prose is the always-red half of the defect it was built to catch.
    arm("24 prose ABOUT a procedure must not trip the procedure detector",
        mutate(GOOD_FIXTURE, replace: "REFUSED        this fixture is not a finding about anything in the world",
               with: "REFUSED        this entry carries no synthesis procedure and no fabrication route, by C-007"),
        .ADMITTED, "")

    arm("25 a refusal line naming a self-graded column must not trip the self-graded detector",
        mutate(GOOD_FIXTURE, replace: "REFUSED        this fixture is not a finding about anything in the world",
               with: "REFUSED        the source corpus confidence, coherence and overall_score columns are Doubles and are barred from every verdict here"),
        .ADMITTED, "")

    arm("26 a measurement whose words happen to include a unit must not trip rule A",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       42 mg per dose is the labelled amount and the screen found 7 of 9 windows"),
        .ADMITTED, "")

    arm("27 program present, never run here — HELD, and it must NOT read as REFUSED",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-gamma")
            .replacingOccurrences(of: "REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift -o /tmp/run && /tmp/run",
                                  with: "REPRODUCE      xcrun swiftc -O -swift-version 5 fixture-program-gamma.swift -o /tmp/run && /tmp/run"),
        .NOT_KNOWN, "E4_FIGURE")

    arm("28 a SPEC_NAME with nobody behind it",
        mutate(GOOD_FIXTURE, replace: "IDENTITY_KIND  UNII\nIDENTITY       AXQ9493NT2",
               with: "IDENTITY_KIND  SPEC_NAME\nIDENTITY       SOME-LATTICE"),
        .REFUSED, "E1_IDENTITY")

    arm("29 a SPEC_NAME with its authority named",
        mutate(GOOD_FIXTURE, replace: "IDENTITY_KIND  UNII\nIDENTITY       AXQ9493NT2",
               with: "IDENTITY_KIND  SPEC_NAME\nIDENTITY       E8\nSPEC_AUTHORITY the standard root lattice E8, Conway and Sloane, SPLAG"),
        .ADMITTED, "")

    arm("30 a CONTENT_DIGEST identity no program is claimed to print",
        mutate(GOOD_FIXTURE, replace: "IDENTITY_KIND  UNII\nIDENTITY       AXQ9493NT2",
               with: "IDENTITY_KIND  CONTENT_DIGEST\nIDENTITY       1111111111111111111111111111111111111111111111111111111111111111\nDIGEST_OF      a corpus nobody in the pipeline ever saw"),
        .REFUSED, "E1_IDENTITY")

    // ── direction 5b: the two false-refusal paths a real transcript exposed.
    // Each is a case where an EARLIER revision of this law refused an honest entry.
    // A correction with no arm behind it is indistinguishable from a weakening.
    func deltaEntry(_ mutations: [(String, String)]) -> String {
        var t = mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
                       with: "PROGRAM        fixture-program-delta")
            .replacingOccurrences(of: "FIGURE         alpha figure one : 42\nFIGURE         alpha figure two : 7 of 9",
                                  with: "FIGURE         delta figure : 78680 rows")
            .replacingOccurrences(of: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
                                  with: "SEAL           NONE_PRINTED")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       78680 rows carried the delta figure")
            .replacingOccurrences(of: "xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift",
                                  with: "xcrun swiftc -O -swift-version 5 fixture-program-delta.swift")
        for (a, b) in mutations { t = t.replacingOccurrences(of: a, with: b) }
        return t
    }

    arm("31 NONE_PRINTED where the program prints INPUT digests and no seal",
        deltaEntry([("PROGRAM        fixture-program-delta", "PROGRAM        fixture-program-eta"),
                    ("fixture-program-delta.swift", "fixture-program-eta.swift")]),
        .ADMITTED, "")

    // The arm 31 case as it stands on a REFUSAL transcript. Before 2026-09-08 this
    // read ADMITTED, because the figure was matched against text the run quoted.
    arm("31b the SAME entry against a transcript that REFUSED — HOLD, never admit",
        deltaEntry([]), .NOT_KNOWN, "E4_FIGURE")

    arm("32 a figure absent from a transcript that is ITSELF A REFUSAL — HOLD, not refuse",
        deltaEntry([("FIGURE         delta figure : 78680 rows",
                     "FIGURE         delta figure : 99999 rows")]),
        .NOT_KNOWN, "E4_FIGURE")

    arm("33 a declared seal absent from a refusal transcript — HOLD, not refuse",
        deltaEntry([("SEAL           NONE_PRINTED",
                     "SEAL           1111111111111111111111111111111111111111111111111111111111111111")]),
        .NOT_KNOWN, "E5_SEAL")

    arm("34 CONTROL ON THE CONTROL — a COMPLETE run's seal is still found, so 31 is not always-green",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-epsilon")
            .replacingOccurrences(of: "FIGURE         alpha figure one : 42\nFIGURE         alpha figure two : 7 of 9",
                                  with: "FIGURE         epsilon figure : 11 of 17")
            .replacingOccurrences(of: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
                                  with: "SEAL           NONE_PRINTED")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       11 of 17 reached the epsilon figure")
            .replacingOccurrences(of: "xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift",
                                  with: "xcrun swiftc -O -swift-version 5 fixture-program-epsilon.swift"),
        .REFUSED, "E5_SEAL")

    arm("35 CONTROL ON THE CONTROL — a figure absent from a COMPLETE run still REFUSES",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-epsilon")
            .replacingOccurrences(of: "FIGURE         alpha figure one : 42\nFIGURE         alpha figure two : 7 of 9",
                                  with: "FIGURE         epsilon figure : 12 of 17")
            .replacingOccurrences(of: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
                                  with: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       12 of 17 reached the epsilon figure")
            .replacingOccurrences(of: "xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift",
                                  with: "xcrun swiftc -O -swift-version 5 fixture-program-epsilon.swift"),
        .REFUSED, "E4_FIGURE")

    // ── direction 5c: the six false ADMISSIONS the published state exposed.
    // Each is a constructed entry an EARLIER revision of this law admitted, with the
    // clause that now catches it. A repair with no arm behind it is a claim.

    arm("36 a MEASURED whose only digit belongs to an identifier",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       E8 is a good lattice and it works well in practice."),
        .REFUSED, "E2_MEASURED")

    arm("37 CONTROL ON 36 — the same object named, with a quantity beside it, ADMITS",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       E8 touches 240 neighbours where Z^8 touches 16, alpha figure one is 42 and two is 7 of 9"),
        .ADMITTED, "")

    // The beta transcript prints "beta figure : 240 by direct enumeration".
    func betaEntry(_ figure: String, measured: String) -> String {
        return mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
                      with: "PROGRAM        fixture-program-beta")
            .replacingOccurrences(of: "FIGURE         alpha figure one : 42\nFIGURE         alpha figure two : 7 of 9",
                                  with: "FIGURE         \(figure)")
            .replacingOccurrences(of: "SEAL           9f2c4b7a1e6d8305c9b4a27fe0d1638a5c7b9e402d16f8a3c5b7d9e1f02a4c68",
                                  with: "SEAL           NONE_PRINTED")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       \(measured)")
            .replacingOccurrences(of: "xcrun swiftc -O -swift-version 5 fixture-program-alpha.swift",
                                  with: "xcrun swiftc -O -swift-version 5 fixture-program-beta.swift")
    }

    arm("38 a figure that is only a PREFIX of the number the program prints",
        betaEntry("beta figure : 24", measured: "24 by direct enumeration"),
        .REFUSED, "E4_FIGURE")

    arm("39 CONTROL ON 38 — the untruncated figure still matches, so 38 is not always-red",
        betaEntry("beta figure : 240", measured: "240 by direct enumeration"),
        .ADMITTED, "")

    arm("40 a one-character figure, which matches almost any transcript",
        betaEntry("0", measured: "240 by direct enumeration"),
        .REFUSED, "E4_FIGURE")

    arm("41 a figure that is punctuation only",
        betaEntry(": :", measured: "240 by direct enumeration"),
        .REFUSED, "E4_FIGURE")

    // C-007 rule C. A complete fabrication route written ENTIRELY in the verbs this
    // law deliberately excludes as too common in honest prose. Rules A and B are both
    // keyed on a verb and both report clean on it.
    arm("42 a fabrication route carrying none of the 32 verbs (C-007, rule C)",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       Combine 42 g of the powder with 5 mL of solvent, heat to 1450 C for 6 h under argon, then press at 12 MPa and cool at 5 C per minute"),
        .REFUSED, "E11_NO_PROCEDURE")

    arm("43 CONTROL ON 42 — a dense measurement whose numbers carry NO units admits",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       42 sequences of 78,680 reach 12 residues, 246 reach 9 and 13 reach 10, alpha figure two is 7 of 9"),
        .ADMITTED, "")

    arm("44 CONTROL ON 42 — two quantities with units is below the threshold and admits",
        mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
               with: "MEASURED       42 mg per dose sampled over 6 h, alpha figure one is 42 and alpha figure two is 7 of 9"),
        .ADMITTED, "")

    // ── direction 5b: A QUOTED FIGURE IS NOT EVIDENCE. Added 2026-09-08 after the
    // defect these three arms describe was found live, on an admitted entry.
    arm("45 a refusal transcript that QUOTES every declared figure — E4 must HOLD, never pass",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-zeta")
            .replacingOccurrences(of: "fixture-program-alpha.swift", with: "fixture-program-zeta.swift"),
        .NOT_KNOWN, "E4_FIGURE")

    arm("46 a refusal transcript that QUOTES the declared seal — E5 must HOLD, never pass",
        mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
               with: "PROGRAM        fixture-program-zeta")
            .replacingOccurrences(of: "fixture-program-alpha.swift", with: "fixture-program-zeta.swift"),
        .NOT_KNOWN, "E5_SEAL")

    arm("47 CONTROL ON 45+46 — the SAME entry against a COMPLETE run still ADMITS",
        GOOD_FIXTURE,
        .ADMITTED, "")

    // ── direction 5c: THE CONTRACT — structure, not spelling. Added 2026-09-08 the same day
    // the spelling-keyed detector was written, because two programs in reproduce/ adopted the
    // declared-terminal-and-fenced-block shape its own comment asked for.
    func contractEntry(_ program: String) -> String {
        return mutate(GOOD_FIXTURE, replace: "PROGRAM        fixture-program-alpha",
                      with: "PROGRAM        fixture-program-\(program)")
            .replacingOccurrences(of: "fixture-program-alpha.swift",
                                  with: "fixture-program-\(program).swift")
    }

    arm("48 CONTRACT — a COMPLETE run that also quotes its published block ADMITS",
        contractEntry("theta"), .ADMITTED, "")

    arm("49 CONTRACT — a COMPLETE run whose figures are ONLY inside the fences is REFUSED, not held",
        contractEntry("iota"), .REFUSED, "E4_FIGURE")

    arm("50 CONTRACT — a DECLARED refusal that quotes every figure HOLDS",
        contractEntry("kappa"), .NOT_KNOWN, "E4_FIGURE")

    arm("51 CONTROL ON THE FALLBACK — a declared COMPLETE beats a refusal SPELLING in its quoted block",
        contractEntry("lambda"), .ADMITTED, "")

    arm("52 CONTRACT — an unclosed BEGIN fence withholds credit rather than granting it",
        contractEntry("mu"), .REFUSED, "E4_FIGURE")

    arm("53 CONTRACT — figures computed but the SEAL only quoted: E4 passes, E5 refuses",
        contractEntry("nu"), .REFUSED, "E5_SEAL")

    // ── direction 6: the per-library half, which no per-entry arm can reach.
    var libArms: [Arm] = []
    // A page built FROM the files, so the page/directory clause reads "they agree"
    // unless an arm deliberately makes them disagree.
    func fixturePage(_ files: [(String, String)]) -> String {
        var s = "# fixture page\n\nProse a stranger reads.\n\n"
        for (_, t) in files { s += t + "\n\n" }
        return s
    }
    // `noPage` is a separate flag rather than `page: nil`, because a default of nil
    // could not express "there is no page" — the fallback silently supplied one, and
    // the arm that was meant to test an unreadable page tested a readable one.
    func libArm(_ name: String, _ files: [(String, String)], _ manifest: String?,
                _ expect: Terminal, _ code: String, page: String? = nil, noPage: Bool = false) {
        let pt: String? = noPage ? nil : (page ?? fixturePage(files))
        let v = gradeLibrary(dir: "(fixture)", entryFiles: files, manifestText: manifest,
                             pageText: pt, ev)
        let codes = v.clauses.filter { $0.terminal != .ADMITTED }.map { $0.code }
        libArms.append(Arm(name: name, expect: expect, expectCode: code, got: v.terminal, gotCodes: codes))
    }

    let manifest1 = """
    LIBRARY                          COMPOUNDS
    DECLARED_ENTRIES_PER_IDENTITY    1
    DECLARED_ENTRIES_PER_PROGRAM     1
    DECLARED_ENTRIES_PER_SEAL        1
    DECLARED_ENTRIES_PER_MEASURED    1
    DECLARED_ENTRIES_PER_TRIPLE      1
    PUBLISHED_PAGE                   Fixture-Page.md
    """
    let manifest2 = """
    LIBRARY                          COMPOUNDS
    DECLARED_ENTRIES_PER_IDENTITY    1
    DECLARED_ENTRIES_PER_PROGRAM     4
    DECLARED_ENTRIES_PER_SEAL        4
    DECLARED_ENTRIES_PER_MEASURED    1
    DECLARED_ENTRIES_PER_TRIPLE      1
    PUBLISHED_PAGE                   Fixture-Page.md
    """
    // The same declared ceilings as manifest2 but licensing TWO entries on one triple —
    // the shape a real library takes when one run answers two separable questions.
    let manifest3 = """
    LIBRARY                          COMPOUNDS
    DECLARED_ENTRIES_PER_IDENTITY    2
    DECLARED_ENTRIES_PER_PROGRAM     4
    DECLARED_ENTRIES_PER_SEAL        4
    DECLARED_ENTRIES_PER_MEASURED    1
    DECLARED_ENTRIES_PER_TRIPLE      2
    PUBLISHED_PAGE                   Fixture-Page.md
    """

    // Four entries with FOUR identities and ONE measurement: the Study-37 shape,
    // on the axis a distinct-identity count alone cannot see.
    func fixtureWithIdentity(_ unii: String, measured: String) -> String {
        return mutate(GOOD_FIXTURE, replace: "IDENTITY       AXQ9493NT2", with: "IDENTITY       \(unii)")
            .replacingOccurrences(of: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                                  with: "MEASURED       \(measured)")
    }

    libArm("L-01 an empty library must be REFUSED, never reported clean",
           [], manifest1, .REFUSED, "L1_NOT_EMPTY")

    libArm("L-02 a library with no declared ceilings",
           [("a.md", GOOD_FIXTURE)], nil, .REFUSED, "L2_MANIFEST")

    libArm("L-03 four rows, one identity — the row count is the loop bound",
           [("a.md", GOOD_FIXTURE), ("b.md", GOOD_FIXTURE),
            ("c.md", GOOD_FIXTURE), ("d.md", GOOD_FIXTURE)],
           manifest2, .REFUSED, "L3_DISTINCT_IDENTITY")

    libArm("L-04 four identities, one finding — the same collapse on the MEASURED axis",
           [("a.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42 and alpha figure two is 7 of 9")),
            ("b.md", fixtureWithIdentity("AXQ9493NT2", measured: "alpha figure one is 42 and alpha figure two is 7 of 9")),
            ("c.md", fixtureWithIdentity("AXQ9493NT3", measured: "alpha figure one is 42 and alpha figure two is 7 of 9")),
            ("d.md", fixtureWithIdentity("AXQ9493NT4", measured: "alpha figure one is 42 and alpha figure two is 7 of 9"))],
           manifest2, .REFUSED, "L6_DISTINCT_MEASURED")

    libArm("L-05 four identities, four findings, one program — one measurement in N hats",
           [("a.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42, reading one")),
            ("b.md", fixtureWithIdentity("AXQ9493NT2", measured: "alpha figure one is 42, reading two")),
            ("c.md", fixtureWithIdentity("AXQ9493NT3", measured: "alpha figure one is 42, reading three")),
            ("d.md", fixtureWithIdentity("AXQ9493NT4", measured: "alpha figure one is 42, reading four"))],
           manifest1, .REFUSED, "L4_DISTINCT_PROGRAM")

    libArm("L-06 one refused entry stops the library publishing",
           [("a.md", GOOD_FIXTURE),
            ("b.md", mutate(GOOD_FIXTURE, replace: "GRADE          MEASURED", with: "GRADE          ARGUMENT"))],
           manifest2, .REFUSED, "L7_NO_ENTRY_REFUSED")

    libArm("L-07 a library within its declared ceilings is ADMITTED",
           [("a.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42, reading one")),
            ("b.md", fixtureWithIdentity("AXQ9493NT2", measured: "alpha figure one is 42, reading two"))],
           manifest2, .ADMITTED, "")

    // ── L8: the SAME-LIBRARY half of "an entry may not be filed twice". Three entries
    // sharing one identity, one program and one seal is what one run answering three
    // separable questions looks like. It is admissible ONLY at a ceiling the library
    // declared in advance, and the two arms below are the two sides of that.
    let manifest4 = """
    LIBRARY                          PROTEINS
    DECLARED_ENTRIES_PER_IDENTITY    3
    DECLARED_ENTRIES_PER_PROGRAM     3
    DECLARED_ENTRIES_PER_SEAL        3
    DECLARED_ENTRIES_PER_MEASURED    1
    DECLARED_ENTRIES_PER_TRIPLE      2
    PUBLISHED_PAGE                   Fixture-Page.md
    """
    let manifest5 = manifest4.replacingOccurrences(of: "DECLARED_ENTRIES_PER_TRIPLE      2",
                                                   with: "DECLARED_ENTRIES_PER_TRIPLE      3")
    let sameTriple: [(String, String)] = [
        ("a.md", mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                        with: "MEASURED       alpha figure one is 42, the first question")),
        ("b.md", mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                        with: "MEASURED       alpha figure two is 7 of 9, the second question")),
        ("c.md", mutate(GOOD_FIXTURE, replace: "MEASURED       alpha figure one is 42 and alpha figure two is 7 of 9",
                        with: "MEASURED       alpha figure one is 42 beside figure two at 7 of 9, the third question")),
    ]

    libArm("L-08 three entries on one triple, against a declared ceiling of 2",
           sameTriple, manifest4, .REFUSED, "L8_DISTINCT_TRIPLE")

    libArm("L-09 the same three at a ceiling of 3 — a DECLARED ceiling licenses it",
           sameTriple, manifest5, .ADMITTED, "")

    // ── L9: the page a stranger reads against the directory the checker grades.
    let twoGood: [(String, String)] = [
        ("a.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42, reading one")),
        ("b.md", fixtureWithIdentity("AXQ9493NT2", measured: "alpha figure one is 42, reading two")),
    ]
    libArm("L-10 the page publishes fewer entries than the directory holds",
           twoGood, manifest2, .REFUSED, "L9_PAGE_MATCHES_DIR",
           page: fixturePage([twoGood[0]]))

    libArm("L-11 the page carries prose and no entry block at all",
           twoGood, manifest2, .REFUSED, "L9_PAGE_MATCHES_DIR",
           page: "# A library page\n\nEverything here is excellent.\n")

    libArm("L-12 the page is not readable from here — HELD, and it must NOT read as agreement",
           twoGood, manifest2, .NOT_KNOWN, "L9_PAGE_MATCHES_DIR", noPage: true)

    libArm("L-13 a manifest declaring no PUBLISHED_PAGE",
           twoGood,
           manifest2.replacingOccurrences(of: "PUBLISHED_PAGE                   Fixture-Page.md", with: ""),
           .REFUSED, "L2_MANIFEST")

    arms.append(contentsOf: libArms)

    // ── direction 7: the FEDERATION half, which no per-library arm can reach because
    // no per-library arm ever holds two libraries at once.
    var fedArms: [Arm] = []
    func fedArm(_ name: String, _ libs: [LibraryVerdict], _ expect: Terminal, _ code: String) {
        let f = federationVerdict(libs)
        fedArms.append(Arm(name: name, expect: expect, expectCode: code,
                           got: f.clause.terminal,
                           gotCodes: f.clause.terminal == .ADMITTED ? [] : [f.clause.code]))
    }
    func lib(_ files: [(String, String)], _ manifest: String) -> LibraryVerdict {
        return gradeLibrary(dir: "(fixture)", entryFiles: files, manifestText: manifest,
                            pageText: fixturePage(files), ev)
    }
    let libA = lib([("a.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42, reading one"))], manifest2)
    let libB = lib([("b.md", fixtureWithIdentity("AXQ9493NT2", measured: "alpha figure one is 42, reading two"))], manifest2)
    let libAagain = lib([("copy.md", fixtureWithIdentity("AXQ9493NT1", measured: "alpha figure one is 42, reading one"))], manifest2)
    let libTripled = lib(sameTriple, manifest5)

    fedArm("F-01 one entry filed in TWO libraries — no ceiling can license it",
           [libA, libAagain], .REFUSED, "F1_NO_ENTRY_FILED_TWICE")

    fedArm("F-02 two libraries with nothing in common are ADMITTED",
           [libA, libB], .ADMITTED, "")

    fedArm("F-03 one library alone — the cross-library relation is NOT_KNOWN, not clean",
           [libA], .NOT_KNOWN, "F1_NO_ENTRY_FILED_TWICE")

    // THE ARM THE OLD F1 HAD NO CONTROL FOR, and the one it failed. A triple carried
    // by three entries INSIDE one library is L8's question, answered above against a
    // declared ceiling. F1 must not fire on it — and the old F1 did, calling three
    // entries in one library "1 entry filed twice in two libraries".
    //
    // The second library here is libA, whose identity differs from the tripled one.
    // The first draft of this arm paired the tripled library with libB, which carries
    // the SAME identity — so F1 refused, correctly, on a real crossing, and the arm
    // that was meant to test same-library repetition was testing a cross-library one.
    // The arm caught its own construction, which is what an arm is for.
    fedArm("F-04 three entries on one triple INSIDE one library — F1 must NOT fire",
           [libTripled, libA], .ADMITTED, "")

    arms.append(contentsOf: fedArms)
    let all = arms.allSatisfy { $0.pass }
    return (arms, all)
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION J — seal + exit
// ══════════════════════════════════════════════════════════════════════════

func sealAndExit(_ code: Int32) -> Never {
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
// SECTION K — reporting
// ══════════════════════════════════════════════════════════════════════════

func reportEntry(_ v: EntryVerdict, verbose: Bool) {
    say("  " + pad(v.label, 52) + v.terminal.rawValue)
    for c in v.clauses {
        if c.terminal == .ADMITTED && !verbose { continue }
        let mark = c.terminal == .ADMITTED ? "  ok  " : (c.terminal == .REFUSED ? " REF  " : " HELD ")
        say("     " + mark + pad(c.code, 24) + c.detail)
    }
}

func reportLibrary(_ v: LibraryVerdict) {
    rule("-")
    say("LIBRARY \(v.name)   ->   \(v.terminal.rawValue)")
    rule("-")
    say("  entry files   \(grp(v.entryVerdicts.count))")
    say("  ADMITTED      \(grp(v.admitted.count))")
    say("  HELD          \(grp(v.held.count))   (evidence absent here; ABSENCE IS NOT REFUSAL)")
    say("  REFUSED       \(grp(v.refused.count))")
    say()
    say("  THE COUNT THAT NO PER-ENTRY CHECK CAN PRODUCE — distinct, per axis, over the")
    say("  ADMITTED set, printed beside the row count, always:")
    say()
    say("    " + pad("axis", 30) + lpad("entries", 9) + lpad("distinct", 10)
        + lpad("most at 1", 11) + lpad("declared", 10) + "  holds")
    for a in v.axes {
        // A census row is not gated, so it prints no verdict. A census row showing
        // "yes" reads as a gate that passed, and it never was one.
        let isCensus = a.axis.contains("census")
        let holds = isCensus ? "  -" : (a.entries == 0 ? "n/a" : (a.holds ? "yes" : "NO"))
        let dec = isCensus ? "-" : grp(a.declared)
        say("    " + pad(a.axis, 30) + lpad(grp(a.entries), 9) + lpad(grp(a.distinct), 10)
            + lpad(grp(a.worstCount), 11) + lpad(dec, 10) + "  " + holds)
    }
    say()
    say("    'most at 1' is the count carried by the single most repeated value on that")
    say("    axis. It is the number the declared ceiling is about, and it is printed")
    say("    whether the ceiling holds or not — an aggregate that clears while one value")
    say("    carries five against a declared two is the collapse this table exists to show.")
    if v.sealless > 0 {
        say()
        say("    \(grp(v.sealless)) admitted entr\(v.sealless == 1 ? "y" : "ies") declare SEAL NONE_PRINTED — their programs print no")
        say("    seal. They are counted here and excluded from the seal axis rather than")
        say("    folded into one bucket, which would read as a collapse that is not there.")
    }
    say()
    if !v.gradeCensus.isEmpty {
        say("  GRADE CENSUS over the admitted set (a census, NOT a gate — no library is")
        say("  refused for its distribution of grades, and no library should be read as")
        say("  strong for having none of the weaker ones):")
        for (g, n) in v.gradeCensus { say("    " + pad(g, 22) + lpad(grp(n), 6)) }
        say()
    }
    if !v.openSlots.isEmpty {
        say("  OPEN SLOTS — named, and empty. A slot is NOT an entry and is counted in no")
        say("  axis above. It is a measurement this library has named and does not have:")
        say("  no program, no figure, no seal. Naming it is how a library says what it is")
        say("  missing instead of quietly not having it.")
        for s0 in v.openSlots { say("    - " + s0) }
        say()
    }
    say("  PER-LIBRARY CLAUSES")
    for c in v.clauses {
        let mark = c.terminal == .ADMITTED ? "  ok  " : (c.terminal == .REFUSED ? " REF  " : " HELD ")
        say("   " + mark + pad(c.code, 26) + c.detail)
    }
    say()
    say("  PER-ENTRY VERDICTS")
    for e in v.entryVerdicts { reportEntry(e, verbose: false) }
    say()
}

// ══════════════════════════════════════════════════════════════════════════
// SECTION L — main
// ══════════════════════════════════════════════════════════════════════════

rule("=")
say("LIBRARY-ADMISSION-LAW  v1")
say("what may enter a library of health and materials that strangers will use")
rule("=")
say("Swift 6.4 · zero float on every decision path · integer ceilings, never ratios")
say("Three terminals: ADMITTED / REFUSED / NOT_KNOWN. They are three answers and")
say("this program never prints one where it means another.")
say()

var argEntries: [String] = []
var argLibraries: [String] = []
var argReproduce: String? = nil
var argEvidence: String? = nil
var argVerbose = false
var argFault: String? = nil

do {
    let a = Array(CommandLine.arguments.dropFirst())
    var i = 0
    while i < a.count {
        switch a[i] {
        case "--entry":
            if i + 1 >= a.count { argFault = "--entry needs a path" } else { argEntries.append(a[i + 1]); i += 1 }
        case "--library":
            if i + 1 >= a.count { argFault = "--library needs a path" } else { argLibraries.append(a[i + 1]); i += 1 }
        case "--reproduce":
            if i + 1 >= a.count { argFault = "--reproduce needs a path" } else { argReproduce = a[i + 1]; i += 1 }
        case "--evidence":
            if i + 1 >= a.count { argFault = "--evidence needs a path" } else { argEvidence = a[i + 1]; i += 1 }
        case "--verbose":
            argVerbose = true
        default:
            argFault = "unrecognised argument '\(a[i])'"
        }
        i += 1
    }
}

printReferenceFigures()

rule("=")
say("SECTION 1 — CONTROL ARM  (runs first; nothing is graded if it fails)")
rule("=")
say("Every negative arm is the one correctly-formed fixture with EXACTLY ONE thing")
say("changed, so a refusal is attributable to that change. Each arm declares the")
say("terminal AND the clause code it expects: refusing for the wrong reason FAILS.")
say()
let ctl = runControlArm()
for a in ctl.arms {
    say((a.pass ? "  PASS  " : "  FAIL  ") + pad(a.name, 62))
    say("        expect  \(a.expect.rawValue)\(a.expectCode.isEmpty ? "" : " via \(a.expectCode)")")
    say("        got     \(a.gotLabel)")
}
say()
let passed = ctl.arms.filter { $0.pass }.count
let admitArms = ctl.arms.filter { $0.expect == .ADMITTED }.count
let refuseArms = ctl.arms.filter { $0.expect == .REFUSED }.count
let holdArms = ctl.arms.filter { $0.expect == .NOT_KNOWN }.count
say("CONTROL ARM  \(passed)/\(ctl.arms.count) PASS")
say("  arms that must REFUSE     \(lpad(grp(refuseArms), 3))")
say("  arms that must ADMIT      \(lpad(grp(admitArms), 3))")
say("  arms that must HOLD       \(lpad(grp(holdArms), 3))   (NOT_KNOWN — the third terminal is reachable)")
say("A law that admits everything has admitted nothing; a law that refuses everything")
say("has too; and a law with no reachable NOT_KNOWN has only two answers for three")
say("questions, so it will print one of the two where it means the third.")
say()

if !ctl.allPass {
    rule("=")
    say("CONTROL ARM FAILED — no library is graded.")
    say("An instrument that has not been shown to discriminate has measured nothing.")
    say("The reference figures above are the law's frozen integers, not a reading.")
    sealAndExit(3)
}

if let f = argFault {
    rule("=")
    say("REFUSED — \(f)")
    say("usage: library-admission-law [--entry <file>] [--library <dir>] [--reproduce <dir>] [--evidence <dir>] [--verbose]")
    sealAndExit(2)
}

if argEntries.isEmpty && argLibraries.isEmpty {
    rule("=")
    say("SECTION 2 — NO CORPUS GIVEN")
    rule("=")
    say("No --entry and no --library. The control arm above is the whole of this run,")
    say("and it is a real result: the law has been shown to refuse \(refuseArms) constructed")
    say("violations, to admit \(admitArms) correctly-formed cases and to hold \(holdArms), on fixtures")
    say("embedded in this file, with no filesystem read and no network.")
    say()
    say("To grade a real library:")
    say("  library-admission-law --library <dir> --reproduce <dir> --evidence <dir>")
    say()
    sealAndExit(0)
}

// ── evidence sources
let fm = FileManager.default
var reproDir = argReproduce ?? ""
if reproDir.isEmpty {
    for c in ["reproduce", "../reproduce"] where fm.fileExists(atPath: c) { reproDir = c; break }
}
let evidDir = argEvidence ?? "/tmp"

let ev: Evidence = FileEvidence(reproduceDir: reproDir, evidenceDir: evidDir)

rule("=")
say("SECTION 2 — EVIDENCE")
rule("=")
// THE PATHS ARE PRINTED, NEVER SEALED. They are facts about this filesystem, not
// about the answer; a seal that moves with the checkout directory indicts a correct
// reproduction. print() writes outside the sealed transcript; say() writes inside it.
print("  reproduce directory  \(reproDir.isEmpty ? "(none found)" : reproDir)   (printed, NOT sealed)")
print("  transcript directory \(evidDir)                                        (printed, NOT sealed)")
if ev.censusKnown {
    say("  programs in reproduce/   \(grp(ev.programs.count))")
} else {
    say("  programs in reproduce/   NOT_KNOWN — the directory is unreadable from here.")
    say("  Every PROGRAM clause below is therefore HELD, never passed. A census that")
    say("  found nothing and a census that could not run are different answers.")
}
say()

var anyRefused = false
var anyHeld = false
var allVerdicts: [EntryVerdict] = []

if !argEntries.isEmpty {
    rule("=")
    say("SECTION 3 — SINGLE ENTRIES")
    rule("=")
    for p in argEntries {
        let text = (try? String(contentsOfFile: p, encoding: .utf8)) ?? ""
        let label = (p as NSString).lastPathComponent
        let v = gradeEntry(text, label: label, ev)
        allVerdicts.append(v)
        say()
        reportEntry(v, verbose: true)
        if v.terminal == .REFUSED { anyRefused = true }
        if v.terminal == .NOT_KNOWN { anyHeld = true }
    }
    say()
}

var libVerdicts: [LibraryVerdict] = []
if !argLibraries.isEmpty {
    rule("=")
    say("SECTION 4 — LIBRARIES")
    rule("=")
    for d in argLibraries {
        var files: [(String, String)] = []
        var manifest: String? = nil
        if let names = try? fm.contentsOfDirectory(atPath: d) {
            for n in names.sorted(by: utf8Less) {
                if n == "LIBRARY.manifest" {
                    manifest = try? String(contentsOfFile: d + "/" + n, encoding: .utf8)
                    continue
                }
                if !n.hasSuffix(".md") { continue }
                let t = (try? String(contentsOfFile: d + "/" + n, encoding: .utf8)) ?? ""
                files.append((n, t))
            }
        }
        // The published page is named BY THE MANIFEST and looked for beside the
        // library root — <root>/library/<lib>/ has the page at <root>/<PAGE>. The path
        // is derived, never declared, so no absolute path enters this program.
        var pageText: String? = nil
        var pageTried = "(no PUBLISHED_PAGE declared)"
        if let mt = manifest {
            let (mm, _) = parseManifest(mt)
            if let mm = mm {
                let cand = [d + "/../../" + mm.publishedPage, d + "/../" + mm.publishedPage,
                            d + "/" + mm.publishedPage]
                pageTried = mm.publishedPage
                for c in cand {
                    if let t = try? String(contentsOfFile: c, encoding: .utf8) { pageText = t; break }
                }
            }
        }
        let v = gradeLibrary(dir: d, entryFiles: files, manifestText: manifest,
                             pageText: pageText, ev)
        libVerdicts.append(v)
        allVerdicts.append(contentsOf: v.entryVerdicts)
        print("  directory      \(d)   (printed, NOT sealed)")
        print("  published page \(pageTried) -> \(pageText == nil ? "NOT FOUND from this directory" : "read")   (printed, NOT sealed)")
        reportLibrary(v)
        if v.terminal == .REFUSED { anyRefused = true }
        if v.terminal == .NOT_KNOWN { anyHeld = true }
    }
}

// ── the federation clause: one entry may not be filed in TWO libraries.
//
// SECTION 5 runs whenever any library was graded, including one. It used to be gated
// `if libVerdicts.count > 1`, so a single-library run never reached it and printed
// nothing about it — and all three seed libraries were published from single-library
// runs that could not reach the clause their combined run refused on. A clause that
// is silent on the runs people actually make is not enforced by being present.
if !libVerdicts.isEmpty {
    rule("=")
    say("SECTION 5 — ACROSS THE LIBRARIES")
    rule("=")
    let fed = federationVerdict(libVerdicts)
    say("  libraries graded in this run            \(grp(fed.libraries))")
    say("  admitted entries across all libraries   \(grp(fed.admittedTotal))")
    say("  distinct (identity, program, seal)      \(grp(fed.distinctTriples))")
    let mark = fed.clause.terminal == .ADMITTED ? "ok" : (fed.clause.terminal == .REFUSED ? "REFUSED" : "NOT_KNOWN")
    say("  \(pad("F1_NO_ENTRY_FILED_TWICE", 26)) \(mark) — \(fed.clause.detail)")
    for c in fed.crossings { say("      \(c.key)  ->  \(c.where_.joined(separator: ", "))") }
    if fed.clause.terminal == .REFUSED { anyRefused = true }
    if fed.clause.terminal == .NOT_KNOWN { anyHeld = true }
    say()
}

// ── the call
rule("=")
say("SECTION 6 — THE CALL")
rule("=")
say()
let adm = allVerdicts.filter { $0.terminal == .ADMITTED }.count
let hel = allVerdicts.filter { $0.terminal == .NOT_KNOWN }.count
let ref = allVerdicts.filter { $0.terminal == .REFUSED }.count
say("  entries graded   \(grp(allVerdicts.count))")
say("  ADMITTED         \(grp(adm))")
say("  HELD             \(grp(hel))")
say("  REFUSED          \(grp(ref))")
say()
if ref > 0 || anyRefused {
    if ref > 0 {
        say("  The library does not publish while an entry is refused. Each refusal above")
        say("  names its clause; fix the entry or withdraw it, and grade again.")
    } else {
        say("  No individual entry is refused and a LIBRARY clause is. Read the per-library")
        say("  clauses above: the defect is in the collection, not in any one row, which is")
        say("  the whole reason this law has a per-library half.")
    }
} else if hel > 0 || anyHeld {
    say("  Nothing is refused. \(grp(hel)) entr\(hel == 1 ? "y is" : "ies are") HELD because evidence that exists")
    say("  elsewhere is not present here — run the named program and grade again. A held")
    say("  entry is not in the library and is not thrown out of it. ABSENCE, REFUSAL and")
    say("  NOT_KNOWN are three answers and this program prints three.")
} else {
    say("  Every entry admitted, and every per-library clause holds over the admitted")
    say("  set. The distinct counts are published beside the row counts above; read")
    say("  them together, because the row count alone is a loop bound.")
}
say()
say("  Nothing in these libraries is medical advice and no entry is a recommendation")
say("  to take anything.")
say()

// The exit code is derived from the tallies printed above, never from a separate
// accumulator that could disagree with them. A run that prints "1 HELD" and exits 0
// has two answers, and a reader would trust the wrong one.
if ref > 0 || anyRefused { sealAndExit(1) }
if hel > 0 || anyHeld { sealAndExit(2) }
sealAndExit(0)
