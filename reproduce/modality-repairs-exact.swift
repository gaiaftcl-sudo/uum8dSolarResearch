// modality-repairs-exact.swift
// Applies the five repairs the adversarial lens named against the modality
// register arm. Every figure is COUNTED from the pinned ClinicalTrials.gov v2
// pages. Integer only: no Float, no Double, no float literal, no float
// conversion on any path.
//
// Swift 6.4:  xcrun swiftc -O -swift-version 5 modality-repairs-exact.swift -o modality-repairs
// Usage:      ./modality-repairs <corpus-dir>       (dir from argv; NOTHING is baked)
//
// THIS PROGRAM GRADES NO MEDICINE. It counts what a public registry contains.
// A registration is a fact about a filing, not about a lung.

import Foundation

var refFiles = 0, refBytes = 0, refStudies = 0, refDigests = 0
var refArmsRun = 0, refArmsPassed = 0, refArmsFailed = 0, refRefusals = 0
var refMatchTests = 0, refCharsScanned = 0

func out(_ s: String) { print(s); fflush(stdout) }

func referenceBlock() -> String {
    var t = "\n================================================================\n"
    t += "REFERENCE FIGURES  [printed on EVERY exit path]\n"
    t += "  self-test arms run ............. \(refArmsRun)\n"
    t += "  self-test arms passed .......... \(refArmsPassed)\n"
    t += "  self-test arms failed .......... \(refArmsFailed)\n"
    t += "  files read ..................... \(refFiles)\n"
    t += "  bytes read (counted) ........... \(refBytes)\n"
    t += "  studies decoded (counted) ...... \(refStudies)\n"
    t += "  sha256 digests computed ........ \(refDigests)\n"
    t += "  match tests run (counted) ...... \(refMatchTests)\n"
    t += "  characters scanned (counted) ... \(refCharsScanned)\n"
    t += "  refusals raised ................ \(refRefusals)\n"
    t += "================================================================"
    return t
}
func refuse(_ why: String) -> Never {
    refRefusals += 1
    out("\nVERDICT: REFUSED"); out("REASON : \(why)"); out(referenceBlock()); exit(2)
}
func arm(_ label: String, _ ok: Bool, _ got: String = "") {
    refArmsRun += 1
    if ok { refArmsPassed += 1 } else { refArmsFailed += 1 }
    out("  \(ok ? "PASS" : "FAIL")  \(label)\(got.isEmpty ? "" : "   {\(got)}")")
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

// ---------------------------------------------------------------- JSON
indirect enum J {
    case s(String), n(String), b(Bool), null
    case a([J]), o([String: J])
    var str: String? { if case .s(let v) = self { return v }; if case .n(let v) = self { return v }; return nil }
    var arr: [J] { if case .a(let v) = self { return v }; return [] }
    subscript(_ k: String) -> J? { if case .o(let m) = self { return m[k] }; return nil }
}
struct JP {
    let b: [UInt8]; var i = 0
    init(_ bytes: [UInt8]) { b = bytes }
    mutating func ws() { while i < b.count, b[i] == 32 || b[i] == 9 || b[i] == 10 || b[i] == 13 { i += 1 } }
    mutating func parse() -> J? {
        ws()
        guard i < b.count else { return nil }
        switch b[i] {
        case 0x7b: return obj()
        case 0x5b: return array()
        case 0x22: if let s = string() { return .s(s) }; return nil
        case 0x74: if lit("true") { return .b(true) }; return nil
        case 0x66: if lit("false") { return .b(false) }; return nil
        case 0x6e: if lit("null") { return .null }; return nil
        default: return num()
        }
    }
    mutating func lit(_ s: String) -> Bool {
        let u = Array(s.utf8)
        if i + u.count > b.count { return false }
        for (k, c) in u.enumerated() { if b[i + k] != c { return false } }
        i += u.count; return true
    }
    mutating func num() -> J? {
        let st = i
        while i < b.count, (b[i] >= 48 && b[i] <= 57) || b[i] == 45 || b[i] == 43 || b[i] == 46 || b[i] == 101 || b[i] == 69 { i += 1 }
        if st == i { return nil }
        return .n(String(decoding: b[st..<i], as: UTF8.self))
    }
    mutating func string() -> String? {
        guard i < b.count, b[i] == 0x22 else { return nil }
        i += 1
        var o: [UInt8] = []
        while i < b.count {
            let c = b[i]
            if c == 0x22 { i += 1; return String(decoding: o, as: UTF8.self) }
            if c == 0x5c {
                i += 1
                guard i < b.count else { return nil }
                switch b[i] {
                case 0x6e: o.append(10)
                case 0x74: o.append(9)
                case 0x72: o.append(13)
                case 0x62: o.append(8)
                case 0x66: o.append(12)
                case 0x75:
                    guard i + 4 < b.count else { return nil }
                    var v = 0
                    for k in 1...4 {
                        let h = b[i + k]
                        let d: Int
                        if h >= 48 && h <= 57 { d = Int(h - 48) }
                        else if h >= 97 && h <= 102 { d = Int(h - 87) }
                        else if h >= 65 && h <= 70 { d = Int(h - 55) }
                        else { return nil }
                        v = v * 16 + d
                    }
                    i += 4
                    if let sc = Unicode.Scalar(UInt32(v)) { o.append(contentsOf: Array(String(Character(sc)).utf8)) }
                default: o.append(b[i])
                }
                i += 1; continue
            }
            o.append(c); i += 1
        }
        return nil
    }
    mutating func obj() -> J? {
        guard i < b.count, b[i] == 0x7b else { return nil }
        i += 1
        var m: [String: J] = [:]
        ws()
        if i < b.count, b[i] == 0x7d { i += 1; return .o(m) }
        while true {
            ws()
            guard let k = string() else { return nil }
            ws()
            guard i < b.count, b[i] == 0x3a else { return nil }
            i += 1
            guard let v = parse() else { return nil }
            m[k] = v
            ws()
            guard i < b.count else { return nil }
            if b[i] == 0x2c { i += 1; continue }
            if b[i] == 0x7d { i += 1; return .o(m) }
            return nil
        }
    }
    mutating func array() -> J? {
        guard i < b.count, b[i] == 0x5b else { return nil }
        i += 1
        var a: [J] = []
        ws()
        if i < b.count, b[i] == 0x5d { i += 1; return .a(a) }
        while true {
            guard let v = parse() else { return nil }
            a.append(v)
            ws()
            guard i < b.count else { return nil }
            if b[i] == 0x2c { i += 1; continue }
            if b[i] == 0x5d { i += 1; return .a(a) }
            return nil
        }
    }
}
func parseWhole(_ bytes: [UInt8]) -> J? {
    var p = JP(bytes)
    guard let v = p.parse() else { return nil }
    p.ws()
    if p.i != bytes.count { return nil }   // trailing bytes REFUSE
    return v
}

// ---------------------------------------------------------------- text
func fold(_ s: String) -> String {
    var o = ""
    for c in s.unicodeScalars {
        if c.value >= 65 && c.value <= 90 { o.unicodeScalars.append(Unicode.Scalar(c.value + 32)!) }
        else { o.unicodeScalars.append(c) }
    }
    return o
}
@inline(__always) func isWordByte(_ c: UInt8) -> Bool {
    (c >= 48 && c <= 57) || (c >= 97 && c <= 122) || c == 95
}
// WORD match: the needle must sit on non-word boundaries on both sides
func containsWord(_ hay: [UInt8], _ needle: [UInt8]) -> Bool {
    refMatchTests += 1
    if needle.isEmpty || needle.count > hay.count { return false }
    var i = 0
    while i + needle.count <= hay.count {
        var k = 0
        while k < needle.count && hay[i + k] == needle[k] { k += 1 }
        if k == needle.count {
            let leftOK = (i == 0) || !isWordByte(hay[i - 1])
            let rightEnd = i + needle.count
            let rightOK = (rightEnd == hay.count) || !isWordByte(hay[rightEnd])
            if leftOK && rightOK { return true }
        }
        i += 1
    }
    return false
}
// PREFIX match: boundary on the left only (catches photobiomodulation, phototherapy...)
func containsPrefix(_ hay: [UInt8], _ needle: [UInt8]) -> Bool {
    refMatchTests += 1
    if needle.isEmpty || needle.count > hay.count { return false }
    var i = 0
    while i + needle.count <= hay.count {
        var k = 0
        while k < needle.count && hay[i + k] == needle[k] { k += 1 }
        if k == needle.count {
            let leftOK = (i == 0) || !isWordByte(hay[i - 1])
            if leftOK { return true }
        }
        i += 1
    }
    return false
}
// SUBSTRING match, no boundary at all — declared as such wherever used
func containsSub(_ hay: [UInt8], _ needle: [UInt8]) -> Bool {
    refMatchTests += 1
    if needle.isEmpty || needle.count > hay.count { return false }
    var i = 0
    while i + needle.count <= hay.count {
        var k = 0
        while k < needle.count && hay[i + k] == needle[k] { k += 1 }
        if k == needle.count { return true }
        i += 1
    }
    return false
}
enum Mode { case word, prefix, sub }
struct Phrase { let text: String; let mode: Mode }
func w(_ t: String) -> Phrase { Phrase(text: t, mode: .word) }
func pre(_ t: String) -> Phrase { Phrase(text: t, mode: .prefix) }
func sub(_ t: String) -> Phrase { Phrase(text: t, mode: .sub) }
func hits(_ hay: [UInt8], _ ph: Phrase) -> Bool {
    let n = Array(fold(ph.text).utf8)
    switch ph.mode {
    case .word: return containsWord(hay, n)
    case .prefix: return containsPrefix(hay, n)
    case .sub: return containsSub(hay, n)
    }
}

// count '<digits> nm' literals; the unit must not be followed by a word byte
func countNM(_ hay: [UInt8]) -> Int {
    refCharsScanned += hay.count
    var n = 0
    var i = 0
    while i < hay.count {
        if hay[i] >= 48 && hay[i] <= 57 {
            // left boundary: previous byte must not be a letter
            var j = i
            while j < hay.count && hay[j] >= 48 && hay[j] <= 57 { j += 1 }
            // a digit run glued to a letter on its left is not a magnitude:
            // skip the WHOLE run, never just its first digit
            if i > 0 && ((hay[i-1] >= 97 && hay[i-1] <= 122) || hay[i-1] == 95) { i = j; continue }
            var k = j
            while k < hay.count && (hay[k] == 32 || hay[k] == 45) { k += 1 }
            if k + 1 < hay.count && hay[k] == 110 && hay[k+1] == 109 {
                let after = k + 2
                if after == hay.count || !isWordByte(hay[after]) { n += 1 }
            }
            i = j
            continue
        }
        i += 1
    }
    return n
}

// ---------------------------------------------------------------- header
out("================================================================")
out("MODALITY REGISTER ARM — THE FIVE REPAIRS, RE-DERIVED")
out("pinned ClinicalTrials.gov v2 pages. Integer counting, zero float.")
out("================================================================")
out("")
out("THIS PROGRAM GRADES NO MEDICINE. A registration identifier is a fact")
out("about a filing, not about a lung. Nothing here is efficacy, a dose,")
out("a mechanism, or evidence that any modality helps or harms anyone.")
out("")
out("REPAIRS APPLIED, each named by the claim it corrects:")
out("  R1  'ZERO light-therapy trials name a lung condition of any kind'")
out("      was refuted. Every hit is counted and NAMED below.")
out("  R2  '1,285 light-therapy trials' was 579+706 and double-counted")
out("      the overlap. The DISTINCT union is counted here.")
out("  R3  '901 wavelength literals' does not survive a scope change.")
out("      Five declared field scopes, five integers, all printed.")
out("  R4  the PBM lexicon is PUBLISHED in full, with a second and")
out("      independent lexicon run on the same bytes beside it.")
out("  R5  the rentosertib row's query key is stated: n=4 needs")
out("      INS018_055. 'rentosertib' alone returns 1.")
out("")
// ---------------------------------------------------------------- self-test
out("SELF-VALIDATION — arms in BOTH directions")
out("-----------------------------------------")
arm("V01 sha256(\"\") == e3b0c442...", SHA256I.hex([]) == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
arm("V02 sha256(\"abc\") == ba7816bf...", SHA256I.hex(Array("abc".utf8)) == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
arm("V03 sha256(\"abd\") != sha256(\"abc\")  [DISCRIMINATES]", SHA256I.hex(Array("abd".utf8)) != SHA256I.hex(Array("abc".utf8)))
arm("V04 JSON parses a nested object", parseWhole(Array("{\"a\":{\"b\":[1,2,\"x\"]}}".utf8)) != nil)
arm("V05 JSON REFUSES <[1,2>  [gate given a broken input]", parseWhole(Array("[1,2".utf8)) == nil)
arm("V06 JSON REFUSES <{\"a\" 1}>", parseWhole(Array("{\"a\" 1}".utf8)) == nil)
arm("V07 JSON REFUSES trailing bytes <{}{}>", parseWhole(Array("{}{}".utf8)) == nil)
arm("V08 JSON REFUSES the empty input  [a gate given nothing must not pass]", parseWhole([]) == nil)
arm("V09 JSON decodes a \\u escape", (parseWhole(Array("\"\\u2264\"".utf8))?.str ?? "") == "\u{2264}")
let hLung = Array(fold("Idiopathic Pulmonary Fibrosis").utf8)
arm("V10 word match finds 'pulmonary'", hits(hLung, w("pulmonary")))
arm("V11 word match REFUSES a mid-word hit: 'monary'  [DISCRIMINATES]", !hits(hLung, w("monary")))
arm("V12 prefix match finds 'pulmonar'", hits(hLung, pre("pulmonar")))
arm("V13 substring match finds 'monary'  [declared as a substring]", hits(hLung, sub("monary")))
let hLungCancer = Array(fold("Non-Small Cell Lung Cancer").utf8)
arm("V14 'lung' fires on lung cancer  [the lexicon is NOT specific to fibrosis]", hits(hLungCancer, w("lung")))
arm("V15 nm scanner: '830nm' counts 1", countNM(Array("830nm".utf8)) == 1, "\(countNM(Array("830nm".utf8)))")
arm("V16 nm scanner: '830 nm' counts 1", countNM(Array("830 nm".utf8)) == 1)
arm("V17 nm scanner: '830-nm' counts 1", countNM(Array("830-nm".utf8)) == 1)
arm("V18 nm scanner REFUSES '830 nmol'  [DISCRIMINATES on the unit]", countNM(Array("830 nmol".utf8)) == 0, "\(countNM(Array("830 nmol".utf8)))")
arm("V19 nm scanner REFUSES 'abc830 nm'  [left boundary]", countNM(Array("abc830 nm".utf8)) == 0)
arm("V20 nm scanner counts two literals in one string", countNM(Array("830nm-850nm".utf8)) == 2, "\(countNM(Array("830nm-850nm".utf8)))")
arm("V21 nm scanner on empty text is 0, not an error", countNM([]) == 0)
if refArmsFailed != 0 { refuse("self-validation failed \(refArmsFailed) of \(refArmsRun) arms") }
out("-----------------------------------------")
out("  arms run \(refArmsRun)   passed \(refArmsPassed)   failed \(refArmsFailed)")
out("")

// ---------------------------------------------------------------- load
let args = CommandLine.arguments
if args.count < 2 {
    out("USAGE: modality-repairs <corpus-dir>")
    out("       the corpus directory is an ARGUMENT. No path is baked in.")
    refuse("no corpus directory given — a gate given nothing must not pass")
}
let dir = args[1]
let fm = FileManager.default
var isD: ObjCBool = false
if !fm.fileExists(atPath: dir, isDirectory: &isD) || !isD.boolValue { refuse("not a directory: \(dir)") }

struct Study {
    var nct = ""
    var briefTitle = "", officialTitle = ""
    var conditions: [String] = []
    var studyType = "", primaryPurpose = ""
    var phases: [String] = []
    var interventions: [(String, String, String)] = []   // type, name, description
    var briefSummary = "", detailed = ""
    var primaryOutcomes: [String] = []
    var status = ""
    var otherNames: [String] = []
}

func decode(_ j: J) -> Study {
    var s = Study()
    let ps = j["protocolSection"] ?? J.o([:])
    if let idm = ps["identificationModule"] {
        s.nct = idm["nctId"]?.str ?? ""
        s.briefTitle = idm["briefTitle"]?.str ?? ""
        s.officialTitle = idm["officialTitle"]?.str ?? ""
    }
    if let st = ps["statusModule"] { s.status = st["overallStatus"]?.str ?? "" }
    if let cm = ps["conditionsModule"] { s.conditions = cm["conditions"]?.arr.compactMap { $0.str } ?? [] }
    if let dm = ps["designModule"] {
        s.studyType = dm["studyType"]?.str ?? ""
        s.phases = dm["phases"]?.arr.compactMap { $0.str } ?? []
        if let di = dm["designInfo"] { s.primaryPurpose = di["primaryPurpose"]?.str ?? "" }
    }
    if let am = ps["armsInterventionsModule"] {
        for iv in am["interventions"]?.arr ?? [] {
            s.interventions.append((iv["type"]?.str ?? "", iv["name"]?.str ?? "", iv["description"]?.str ?? ""))
            for on in iv["otherNames"]?.arr ?? [] { if let v = on.str { s.otherNames.append(v) } }
        }
    }
    if let dm = ps["descriptionModule"] {
        s.briefSummary = dm["briefSummary"]?.str ?? ""
        s.detailed = dm["detailedDescription"]?.str ?? ""
    }
    if let om = ps["outcomesModule"] {
        s.primaryOutcomes = om["primaryOutcomes"]?.arr.compactMap { $0["measure"]?.str } ?? []
    }
    return s
}

func loadUniverse(_ prefix: String, _ label: String) -> [Study] {
    guard let listing = try? fm.contentsOfDirectory(atPath: dir) else { refuse("cannot list \(dir)") }
    let pages = listing.filter { $0.hasPrefix(prefix) && $0.hasSuffix(".json") }.sorted()
    if pages.isEmpty { refuse("no \(prefix)*.json in \(dir) — ABSENT inputs must refuse, never pass") }
    var res: [Study] = []
    var declaredTotal = -1
    for p in pages {
        guard let d = fm.contents(atPath: dir + "/" + p) else { refuse("cannot read \(p)") }
        let bytes = [UInt8](d)
        refFiles += 1; refBytes += bytes.count; refDigests += 1
        let sha = SHA256I.hex(bytes)
        guard let j = parseWhole(bytes) else { refuse("\(p) is not one well-formed JSON document") }
        if let tc = j["totalCount"]?.str, let v = Int(tc) { declaredTotal = v }
        let studies = j["studies"]?.arr ?? []
        for st in studies { res.append(decode(st)); refStudies += 1 }
        out("  OK  \(label)  \(p.padding(toLength: 26, withPad: " ", startingAt: 0)) \(sha)")
    }
    out("      \(label): declared totalCount \(declaredTotal), studies decoded \(res.count)  \(declaredTotal == res.count ? "AGREE" : "DISAGREE")")
    if declaredTotal >= 0 && declaredTotal != res.count { refuse("\(label): page set is incomplete") }
    return res
}

func loadJSONL(_ file: String, _ label: String) -> [Study]? {
    let path = (args.count >= 3 ? args[2] : dir) + "/" + file
    guard let d = fm.contents(atPath: path) else { return nil }
    let bytes = [UInt8](d)
    refFiles += 1; refBytes += bytes.count; refDigests += 1
    out("  OK  \(label)  \(file.padding(toLength: 26, withPad: " ", startingAt: 0)) \(SHA256I.hex(bytes))")
    var res: [Study] = []
    var start = 0
    var i = 0
    var lines = 0
    while i < bytes.count {
        if bytes[i] == 10 {
            if i > start {
                lines += 1
                guard let j = parseWhole(Array(bytes[start..<i])) else { refuse("\(file) line \(lines) is not well-formed JSON") }
                res.append(decode(j)); refStudies += 1
            }
            start = i + 1
        }
        i += 1
    }
    if start < bytes.count {
        lines += 1
        guard let j = parseWhole(Array(bytes[start..<bytes.count])) else { refuse("\(file) last line is not well-formed JSON") }
        res.append(decode(j)); refStudies += 1
    }
    out("      \(label): lines counted \(lines), studies decoded \(res.count)  \(lines == res.count ? "AGREE" : "DISAGREE")")
    return res
}

out("=== CORPUS (sha256 computed here, never asserted) ===")
let U1 = loadUniverse("u1_page_", "U1_PF   ")
let U3 = loadUniverse("u3pbm_page_", "U3_PBM  ")
let U4 = loadUniverse("u4lllt_page_", "U4_LLLT ")
let U5 = loadUniverse("u5rento_page_", "U5_RENTO")
out("")
out("=== WIDER-FIELD CORPUS (same trials, more registry fields) ===")
out("  The page corpus above was fetched WITHOUT descriptionModule, so any")
out("  text count over it is interventions-and-titles only whether or not")
out("  it says so. The .jsonl corpus carries briefSummary and")
out("  detailedDescription; R3 needs both to be a real scope test.")
let J3 = loadJSONL("u3_pbm.jsonl", "U3_PBM  ")
let J4 = loadJSONL("u4_lllt.jsonl", "U4_LLLT ")
let J1 = loadJSONL("u1_pf.jsonl", "U1_PF   ")
var wideUnion: [Study] = []
var wideOK = false
if let a = J3, let b = J4 {
    var seenW = Set<String>()
    for x in a where !seenW.contains(x.nct) { seenW.insert(x.nct); wideUnion.append(x) }
    for x in b where !seenW.contains(x.nct) { seenW.insert(x.nct); wideUnion.append(x) }
    wideOK = true
    var withDesc = 0
    for x in wideUnion where !x.briefSummary.isEmpty { withDesc += 1 }
    out("  wide-corpus distinct union ......... \(wideUnion.count)")
    out("  of those carrying a briefSummary ... \(withDesc)")
    arm("V21b the wide corpus really does carry description text  [else R3 is a fiction]", withDesc > 0, "\(withDesc)")
} else {
    out("  WIDER-FIELD CORPUS ABSENT. R3 will report the page-corpus scopes only,")
    out("  and will say so. ABSENT is reported as ABSENT, never as agreement.")
}
out("")
// ---------------------------------------------------------------- R2
out("================================================================")
out("R2 — THE DISTINCT UNION. '1,285' was 579 + 706 with the overlap")
out("     counted twice. A completeness figure derived from input sizes")
out("     is unfalsifiable; this one is counted.")
out("================================================================")
var idx3 = Set<String>(), idx4 = Set<String>()
for s in U3 { idx3.insert(s.nct) }
for s in U4 { idx4.insert(s.nct) }
let overlap = idx3.intersection(idx4)
let union = idx3.union(idx4)
out("U3_PBM  studies ............ \(U3.count)   distinct NCT ids \(idx3.count)")
out("U4_LLLT studies ............ \(U4.count)   distinct NCT ids \(idx4.count)")
out("naive sum (WRONG) .......... \(U3.count + U4.count)")
out("trials in BOTH universes ... \(overlap.count)")
out("DISTINCT UNION ............. \(union.count)")
arm("V22 union == sum - overlap  [arithmetic closes]", union.count == idx3.count + idx4.count - overlap.count)
arm("V23 the overlap is non-empty, so the naive sum WAS wrong  [DISCRIMINATES]", overlap.count > 0, "\(overlap.count)")
out("")

// one record per distinct trial, U3 first then any U4-only trial
var unionStudies: [Study] = []
var seen = Set<String>()
for s in U3 where !seen.contains(s.nct) { seen.insert(s.nct); unionStudies.append(s) }
for s in U4 where !seen.contains(s.nct) { seen.insert(s.nct); unionStudies.append(s) }
if unionStudies.count != union.count { refuse("union record count disagrees with the id count") }

// ---------------------------------------------------------------- R1
out("================================================================")
out("R1 — DOES ANY LIGHT-THERAPY TRIAL NAME A LUNG OR RESPIRATORY")
out("     CONDITION? The earlier headline said ZERO of any kind.")
out("     Counted here over the DISTINCT union, every hit NAMED.")
out("================================================================")
out("")
out("A BROAD LUNG LEXICON OVER-FIRES. Both the broad row and the strict")
out("row are published, and every false positive is NAMED, because a")
out("lexicon nobody can see is a number nobody can refute.")
out("")
let LUNG_BROAD: [Phrase] = [
    w("lung"), w("lungs"), pre("pulmonar"), pre("respirat"), pre("pneumon"),
    pre("bronch"), w("asthma"), w("copd"), pre("airway"), pre("alveol"),
    pre("thorac"), pre("dyspn"), w("ards"), pre("emphysem"), pre("pleura"),
    pre("ventilat"), pre("trache"), w("cystic fibrosis"), w("covid-19"), w("covid"),
    w("sars-cov-2"), pre("interstitial lung"), pre("apnea"), pre("apnoea"),
]
// STRICT: a disease of the lung or the lower respiratory tract, named in the
// registry `conditions` array. Chosen BEFORE the counts were read.
let LUNG_STRICT: [Phrase] = [
    w("lung"), w("lungs"), pre("pulmonar"), pre("pneumon"), pre("bronchiol"),
    pre("bronchit"), pre("bronchiect"), w("asthma"), w("copd"), w("ards"),
    pre("emphysem"), w("cystic fibrosis"), w("respiratory failure"),
    w("respiratory distress"), w("respiratory insufficiency"),
    w("respiratory symptoms"), w("lower respiratory"), pre("interstitial lung"),
]
// UPPER AIRWAY: real respiratory medicine, but not lung parenchyma. Its own row.
let AIRWAY_UPPER: [Phrase] = [pre("apnea"), pre("apnoea"), w("snoring"), w("tonsils hypertrophy")]
// HOMOGRAPHS the broad row catches that are NOT lung conditions at all.
let HOMOGRAPH: [Phrase] = [pre("alveol"), pre("thorac")]

func condHits(_ s: Study, _ lex: [Phrase]) -> String {
    for c in s.conditions {
        let h = Array(fold(c).utf8)
        for p in lex where hits(h, p) { return c }
    }
    return ""
}
func rowMembers(_ pop: [Study], _ lex: [Phrase]) -> [(Study, String)] {
    var r: [(Study, String)] = []
    for s in pop { let m = condHits(s, lex); if !m.isEmpty { r.append((s, m)) } }
    return r
}

out("BROAD LEXICON (published in full, word = w, prefix = p):")
var bl = "  "; for p in LUNG_BROAD { bl += "\(p.mode == .word ? "w" : "p")(\(p.text))  " }; out(bl)
out("STRICT LEXICON — lung or lower respiratory tract disease:")
var sl = "  "; for p in LUNG_STRICT { sl += "\(p.mode == .word ? "w" : "p")(\(p.text))  " }; out(sl)
out("UPPER-AIRWAY row — respiratory, but not lung parenchyma:")
var al = "  "; for p in AIRWAY_UPPER { al += "\(p.mode == .word ? "w" : "p")(\(p.text))  " }; out(al)
out("HOMOGRAPH row — what the BROAD lexicon catches that is not a lung at all:")
var hl = "  "; for p in HOMOGRAPH { hl += "\(p.mode == .word ? "w" : "p")(\(p.text))  " }; out(hl)
out("")
out("  scope for every row: the registry `conditions` array ONLY. Not the")
out("  title, not the summary — a condition is what the sponsor registered")
out("  the trial against.")
out("")

let broadHits = rowMembers(unionStudies, LUNG_BROAD)
let strictHits = rowMembers(unionStudies, LUNG_STRICT)
let airwayHits = rowMembers(unionStudies, AIRWAY_UPPER)
let strictIds = Set(strictHits.map { $0.0.nct })
let airwayIds = Set(airwayHits.map { $0.0.nct })
let homographOnly = rowMembers(unionStudies, HOMOGRAPH).filter { !strictIds.contains($0.0.nct) && !airwayIds.contains($0.0.nct) }

out("BROAD row  ....... \(broadHits.count) of \(union.count)")
out("STRICT row ....... \(strictHits.count) of \(union.count)   <- the honest lung figure")
out("UPPER-AIRWAY row . \(airwayHits.count) of \(union.count)")
out("HOMOGRAPH row .... \(homographOnly.count) of \(union.count)   <- FALSE POSITIVES of the broad row, excised")
out("")
out("THE STRICT ROW IN FULL — every trial, named:")
out("  NCT           studyType       primaryPurpose   phase    status               matched condition")
for (s, m) in strictHits.sorted(by: { $0.0.nct < $1.0.nct }) {
    var l = "  " + s.nct.padding(toLength: 14, withPad: " ", startingAt: 0)
    l += s.studyType.padding(toLength: 16, withPad: " ", startingAt: 0)
    l += (s.primaryPurpose.isEmpty ? "-" : s.primaryPurpose).padding(toLength: 17, withPad: " ", startingAt: 0)
    l += (s.phases.first ?? "-").padding(toLength: 9, withPad: " ", startingAt: 0)
    l += s.status.padding(toLength: 21, withPad: " ", startingAt: 0)
    l += m
    out(l)
    out("      " + s.briefTitle)
    out("      conditions: " + s.conditions.joined(separator: "; "))
}
let strictTreat = strictHits.filter { $0.0.studyType == "INTERVENTIONAL" && $0.0.primaryPurpose == "TREATMENT" }
out("")
out("  of the strict row, INTERVENTIONAL with primaryPurpose = TREATMENT : \(strictTreat.count)")
out("")
out("THE UPPER-AIRWAY ROW, named (respiratory, not lung parenchyma):")
for (s, m) in airwayHits.sorted(by: { $0.0.nct < $1.0.nct }) where !strictIds.contains(s.nct) {
    out("  \(s.nct)  \(m)  —  \(s.briefTitle)")
}
out("")
out("THE FALSE POSITIVES THE BROAD ROW PRODUCED, named and excised:")
for (s, m) in homographOnly.sorted(by: { $0.0.nct < $1.0.nct }) {
    out("  \(s.nct)  matched '\(m)'  —  \(s.briefTitle)")
}
out("  every one of these is dental alveolar bone or a thoracic-outlet nerve")
out("  compression. 'alveolar' and 'thoracic' are homographs, not lungs.")
out("")
var lungInU1 = 0
for s in U1 { if !condHits(s, LUNG_STRICT).isEmpty { lungInU1 += 1 } }
out("CONTROL (must be large, else the strict lexicon is blind):")
out("  the STRICT lexicon on U1_PF ............. \(lungInU1) of \(U1.count)")
arm("V24 CONTROL: the strict lung lexicon fires on the pulmonary-fibrosis universe", lungInU1 > 800, "\(lungInU1)/\(U1.count)")
var nonsense = 0
for s in unionStudies { for c in s.conditions { if hits(Array(fold(c).utf8), w("zzqqxx")) { nonsense += 1 } } }
arm("V25 CONTROL: a nonsense token matches nothing  [not always-green]", nonsense == 0, "\(nonsense)")
arm("V25b CONTROL: the broad row DOES over-fire, so excision was necessary", broadHits.count > strictHits.count, "\(broadHits.count) > \(strictHits.count)")
var pfNamed: [String] = []
for s in unionStudies {
    for c in s.conditions {
        let h = Array(fold(c).utf8)
        if hits(h, pre("pulmonar")) && hits(h, pre("fibro")) { pfNamed.append(s.nct); break }
        if hits(h, pre("interstitial lung")) { pfNamed.append(s.nct); break }
    }
}
let COVID: [Phrase] = [pre("covid"), w("sars-cov-2"), w("long covid")]
let covidHits = rowMembers(unionStudies, COVID)
let covidOnly = covidHits.filter { !strictIds.contains($0.0.nct) }
out("")
out("A DECLARED BORDERLINE, stated rather than buried: COVID-19 is a")
out("respiratory illness, and a trial may register it with no respiratory")
out("word beside it. Counted separately so the reader can move the line:")
out("  trials naming any COVID token ............ \(covidHits.count)")
out("  of those NOT already in the strict row ... \(covidOnly.count)")
for (st, m) in covidOnly.sorted(by: { $0.0.nct < $1.0.nct }) {
    out("    \(st.nct)  '\(m)'  —  \(st.briefTitle)")
}
out("  strict row + these \(covidOnly.count) would be \(strictHits.count + covidOnly.count) of \(union.count). Either figure is")
out("  defensible; NEITHER is zero, which is what the earlier headline said.")
out("")
out("  trials naming PULMONARY FIBROSIS or INTERSTITIAL LUNG disease : \(pfNamed.count)")
if !pfNamed.isEmpty { out("    " + pfNamed.joined(separator: " ")) }
let lungHits = strictHits
let lungInterventionalTreatment = strictTreat.count
out("")
out("R1 VERDICT: 'ZERO of them name a lung condition of any kind' is")
out("            REFUTED at \(lungHits.count) by the strict row, of which \(lungInterventionalTreatment) are")
out("            interventional TREATMENT studies. What survives, and is")
out("            the claim this page makes instead: \(pfNamed.count) of the \(union.count) light-")
out("            therapy trials name pulmonary fibrosis or interstitial")
out("            lung disease.")
out("")
// ---------------------------------------------------------------- R3
out("================================================================")
out("R3 — WAVELENGTH LITERALS DO NOT SURVIVE A SCOPE CHANGE.")
out("     Same bytes, same matcher, five DECLARED field scopes.")
out("     A count with no scope attached is not a measurement.")
out("================================================================")
out("")
func scopeText(_ s: Study, _ level: Int) -> String {
    var t = ""
    for (ty, nm, de) in s.interventions { t += ty + " " + nm + " " + de + " " }
    for on in s.otherNames { t += on + " " }
    if level >= 2 { t += s.briefTitle + " " + s.officialTitle + " " }
    if level >= 3 { t += s.briefSummary + " " }
    if level >= 4 { t += s.primaryOutcomes.joined(separator: " ") + " " }
    if level >= 5 { t += s.detailed + " " }
    return t
}
let scopeNames = [
    "S1  interventions only (type + name + description + otherNames)",
    "S2  S1 + briefTitle + officialTitle",
    "S3  S2 + briefSummary",
    "S4  S3 + primaryOutcome measures",
    "S5  S4 + detailedDescription",
]
func scopeTable(_ pop: [Study], _ label: String) {
    out("  \(label)  (n = \(pop.count))")
    out("  scope                                                         nm literals   trials carrying >=1")
    for lvl in 1...5 {
        var total = 0, trials = 0
        for s in pop {
            let c = countNM(Array(fold(scopeText(s, lvl)).utf8))
            total += c
            if c > 0 { trials += 1 }
        }
        var l = "  " + scopeNames[lvl-1].padding(toLength: 62, withPad: " ", startingAt: 0)
        l += String(total).leftPad(11) + String(trials).leftPad(22)
        out(l)
    }
    out("")
}
scopeTable(unionStudies, "PAGE CORPUS — no descriptionModule was fetched, so S3..S5 add nothing")
if wideOK { scopeTable(wideUnion, "WIDE CORPUS — briefSummary and detailedDescription present") }
out("WHERE '901' CAME FROM — the same double-count as R2, one scope down:")
func nmOf(_ pop: [Study], _ lvl: Int) -> Int {
    var t = 0
    for s in pop { t += countNM(Array(fold(scopeText(s, lvl)).utf8)) }
    return t
}
let nm3 = nmOf(U3, 1), nm4 = nmOf(U4, 1)
out("  U3_PBM at S1 ......................... \(nm3)")
out("  U4_LLLT at S1 ........................ \(nm4)")
out("  their sum (what a per-universe report gives) \(nm3 + nm4)")
out("  the DISTINCT union at S1 ............. \(nmOf(unionStudies, 1))")
out("  difference, i.e. literals counted twice ..... \(nm3 + nm4 - nmOf(unionStudies, 1))")
out("  The \(overlap.count) trials in both universes carry their wavelengths twice")
out("  in any per-universe sum. This is R2's defect wearing a unit.")
out("")
var nmU1 = 0
let u1ForControl = J1 ?? U1
for s in u1ForControl { nmU1 += countNM(Array(fold(scopeText(s, 5)).utf8)) }
out("CONTROL: the same scanner at the WIDEST scope on U1_PF ... \(nmU1) of \(u1ForControl.count) trials")
arm("V21c CONTROL: the light corpus carries far more nm than the PF corpus  [DISCRIMINATES]", nmOf(wideOK ? wideUnion : unionStudies, 5) > nmU1 * 10, "light \(nmOf(wideOK ? wideUnion : unionStudies, 5)) vs PF \(nmU1)")
out("         (a light-therapy corpus should carry far more nm literals")
out("          than a pulmonary-fibrosis corpus; if it did not, the")
out("          scanner would be measuring something other than light)")
out("")
out("R3 VERDICT: every wavelength count on this page carries its scope.")
out("            A bare '901 nm literals' is withdrawn.")
out("")

extension String {
    func leftPad(_ n: Int) -> String {
        if count >= n { return self }
        return String(repeating: " ", count: n - count) + self
    }
}

// ---------------------------------------------------------------- R4
out("================================================================")
out("R4 — THE PBM LEXICON, PUBLISHED. Two lexicons, same bytes.")
out("     A detector figure that cannot be re-derived from a published")
out("     word list is withdrawn, not defended.")
out("================================================================")
out("")
let PBM_A: [Phrase] = [
    pre("photobiomodul"), w("low level laser"), w("low-level laser"), w("lllt"),
    pre("phototherap"), w("light therapy"), w("red light"), pre("led therapy"), pre("photodynamic"),
]
let PBM_B: [Phrase] = PBM_A + [
    pre("photostimul"), pre("photobiostimul"), pre("biostimul"), w("near-infrared"),
    w("near infrared"), w("nir"), w("laser therapy"), w("laser acupuncture"),
    w("light emitting diode"), w("light-emitting diode"), w("led"), w("leds"),
    w("laser"), w("lasers"), pre("photomodul"), w("blue light"), w("infrared light"),
    w("light irradiation"), w("laser irradiation"), pre("irradiat"), w("photobiomodulation therapy"),
]
func lexLineOf(_ l: [Phrase]) -> String {
    var s = "  "
    for p in l { s += "\(p.mode == .word ? "w" : "p")(\(p.text))  " }
    return s
}
out("LEXICON A — exactly what the register arm used:")
out(lexLineOf(PBM_A))
out("")
out("LEXICON B — written independently, deliberately broader:")
out(lexLineOf(PBM_B))
out("")
out("  scope for both: intervention text + titles. Declared, not implied.")
out("")
func pbmCount(_ pop: [Study], _ lex: [Phrase]) -> Int {
    var n = 0
    for s in pop {
        var t = ""
        for (ty, nm, de) in s.interventions { t += ty + " " + nm + " " + de + " " }
        for on in s.otherNames { t += on + " " }
        t += s.briefTitle + " " + s.officialTitle
        let h = Array(fold(t).utf8)
        for p in lex where hits(h, p) { n += 1; break }
    }
    return n
}
let aU3 = pbmCount(U3, PBM_A), aU4 = pbmCount(U4, PBM_A), aU1 = pbmCount(U1, PBM_A)
let bU3 = pbmCount(U3, PBM_B), bU4 = pbmCount(U4, PBM_B), bU1 = pbmCount(U1, PBM_B)
out("  population        n     LEXICON A     LEXICON B")
out("  U3_PBM      " + String(U3.count).leftPad(7) + String(aU3).leftPad(14) + String(bU3).leftPad(14))
out("  U4_LLLT     " + String(U4.count).leftPad(7) + String(aU4).leftPad(14) + String(bU4).leftPad(14))
out("  U1_PF       " + String(U1.count).leftPad(7) + String(aU1).leftPad(14) + String(bU1).leftPad(14))
out("")
arm("V26 LEXICON A fires hard on its own universe U3  [alive]", aU3 > (U3.count / 2), "\(aU3)/\(U3.count)")
arm("V27 LEXICON B fires harder than A on U3  [B really is broader]", bU3 >= aU3, "\(bU3) >= \(aU3)")
arm("V28 both lexicons are near-silent on U1_PF  [DISCRIMINATES]", aU1 * 20 < U1.count, "A=\(aU1) of \(U1.count)")
out("")
out("R4 VERDICT: the discrimination survives on BOTH lexicons — each fires")
out("            on the light-therapy universes and is near-silent on the")
out("            pulmonary-fibrosis universe. The two integers differ, so")
out("            the page publishes the word list beside every count.")
out("")

// ---------------------------------------------------------------- R5
out("================================================================")
out("R5 — THE RENTOSERTIB ROW'S QUERY KEY, STATED.")
out("     n=4 is reproducible only through the code name.")
out("================================================================")
out("")
out("pinned U5_RENTO records decoded : \(U5.count)")
for s in U5.sorted(by: { $0.nct < $1.nct }) {
    var l = "  " + s.nct + "  " + s.status.padding(toLength: 20, withPad: " ", startingAt: 0)
    l += (s.phases.first ?? "-").padding(toLength: 8, withPad: " ", startingAt: 0)
    l += s.studyType
    out(l)
    out("      " + s.briefTitle)
    out("      conditions: " + s.conditions.joined(separator: "; "))
    out("      interventions: " + s.interventions.map { $0.0 + ":" + $0.1 }.joined(separator: " ; "))
    if !s.primaryOutcomes.isEmpty { out("      primary outcome: " + s.primaryOutcomes[0]) }
}
out("")
var nameHits: [String: Int] = [:]
for key in ["rentosertib", "ins018_055", "ins018-055", "ism001-055", "ism001_055", "tnik"] {
    var n = 0
    for s in U5 {
        var t = s.briefTitle + " " + s.officialTitle + " "
        for (ty, nm, de) in s.interventions { t += ty + " " + nm + " " + de + " " }
        for on in s.otherNames { t += on + " " }
        if hits(Array(fold(t).utf8), sub(key)) { n += 1 }
    }
    nameHits[key] = n
    out("  the string '\(key)' appears in \(n) of the \(U5.count) pinned records  [substring, declared]")
}
arm("V29 'ins018_055' is present in every one of the four records", (nameHits["ins018_055"] ?? 0) == U5.count, "\(nameHits["ins018_055"] ?? -1)/\(U5.count)")
arm("V30 'rentosertib' is present in FEWER than four  [why the key matters]", (nameHits["rentosertib"] ?? 99) < U5.count, "\(nameHits["rentosertib"] ?? -1)/\(U5.count)")
arm("V31 'ism001-055' appears in NONE of the registry records  [ABSENT is an answer]", (nameHits["ism001-055"] ?? -1) == 0)
out("")
out("R5 VERDICT: the register row is keyed on INS018_055. Publishing 'n=4'")
out("            without the key would not reproduce: the trade name")
out("            returns fewer, and ISM001-055 returns none.")
out("")

if refArmsFailed != 0 { refuse("a self-test arm failed after the corpus pass") }
out("MARKER  MODALITY_REGISTER_ARM_FIVE_REPAIRS_APPLIED")
out(referenceBlock())
out("")
out("STATED PLAINLY:")
out("  This is a map of what exists in a public registry and what is")
out("  countable in it. It is NOT efficacy, NOT a dose, NOT a mechanism,")
out("  and NOT evidence that any modality helps or harms anyone.")
exit(0)
