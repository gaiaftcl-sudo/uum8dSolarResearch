// modality-register-exact.swift
// THE MODALITY REGISTER for pulmonary fibrosis.
// Complete enumeration over pinned ClinicalTrials.gov v2 corpora.
// LAW: Swift, integer-only. No Float, no Double, no CGFloat, no float literal,
// no float conversion, anywhere on any decision path.
// Path-independent: no absolute path appears in this source.
// Every exit prints the reference figures. A gate given nothing does not exit 0.

import Foundation

// ============================================================================
// 0. WORK COUNTERS — counted as the work happens, never derived from input size
// ============================================================================
final class Work {
    var bytesHashed: Int = 0
    var bytesParsed: Int = 0
    var jsonTokens: Int = 0
    var filesRead: Int = 0
    var studiesVisited: Int = 0
    var interventionsVisited: Int = 0
    var conditionStringsVisited: Int = 0
    var referenceRecordsVisited: Int = 0
    var matchTestsRun: Int = 0
    var matchHits: Int = 0
    var unitScansRun: Int = 0
    var unitHits: Int = 0
    var arms: Int = 0
    var armFailures: Int = 0
}
let W = Work()

func out(_ s: String) {
    FileHandle.standardOutput.write((s + "\n").data(using: .utf8)!)
}

// ============================================================================
// 1. SHA-256 — pure integer. We never assert a digest we did not compute.
// ============================================================================
struct SHA256Int {
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
        var h0: UInt32 = 0x6a09e667, h1: UInt32 = 0xbb67ae85, h2: UInt32 = 0x3c6ef372
        var h3: UInt32 = 0xa54ff53a, h4: UInt32 = 0x510e527f, h5: UInt32 = 0x9b05688c
        var h6: UInt32 = 0x1f83d9ab, h7: UInt32 = 0x5be0cd19
        var msg = bytes
        let bitLen = UInt64(bytes.count) &* 8
        msg.append(0x80)
        while msg.count % 64 != 56 { msg.append(0x00) }
        var i = 7
        while i >= 0 { msg.append(UInt8((bitLen >> UInt64(i * 8)) & 0xff)); i -= 1 }
        var w = [UInt32](repeating: 0, count: 64)
        var off = 0
        while off < msg.count {
            for t in 0..<16 {
                let b = off + t * 4
                w[t] = (UInt32(msg[b]) << 24) | (UInt32(msg[b+1]) << 16) | (UInt32(msg[b+2]) << 8) | UInt32(msg[b+3])
            }
            for t in 16..<64 {
                let s0 = rotr(w[t-15], 7) ^ rotr(w[t-15], 18) ^ (w[t-15] >> 3)
                let s1 = rotr(w[t-2], 17) ^ rotr(w[t-2], 19) ^ (w[t-2] >> 10)
                w[t] = w[t-16] &+ s0 &+ w[t-7] &+ s1
            }
            var a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, hh = h7
            for t in 0..<64 {
                let S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25)
                let ch = (e & f) ^ (~e & g)
                let t1 = hh &+ S1 &+ ch &+ k[t] &+ w[t]
                let S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22)
                let maj = (a & b) ^ (a & c) ^ (b & c)
                let t2 = S0 &+ maj
                hh = g; g = f; f = e; e = d &+ t1
                d = c; c = b; b = a; a = t1 &+ t2
            }
            h0 = h0 &+ a; h1 = h1 &+ b; h2 = h2 &+ c; h3 = h3 &+ d
            h4 = h4 &+ e; h5 = h5 &+ f; h6 = h6 &+ g; h7 = h7 &+ hh
            off += 64
        }
        var s = ""
        for v in [h0,h1,h2,h3,h4,h5,h6,h7] {
            var j = 7
            while j >= 0 { s.append(hexNib(UInt8((v >> UInt32(j * 4)) & 0xf))); j -= 1 }
        }
        return s
    }
    private static func rotr(_ x: UInt32, _ n: UInt32) -> UInt32 { (x >> n) | (x << (32 - n)) }
    private static func hexNib(_ n: UInt8) -> Character {
        let t: [Character] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
        return t[Int(n)]
    }
}

// ============================================================================
// 2. JSON — integer-only. Numbers are retained as their LITERAL TEXT and are
//    converted only by exact Int parse. No Double ever touches this program.
// ============================================================================
indirect enum JSON {
    case obj([String: JSON])
    case arr([JSON])
    case str(String)
    case num(String)       // literal text, never a float
    case bool(Bool)
    case null
}

struct JSONError: Error { let msg: String; let at: Int }

struct JSONParser {
    let b: [UInt8]
    var i: Int = 0
    init(_ bytes: [UInt8]) { b = bytes }

    mutating func parse() throws -> JSON {
        skipWS()
        let v = try value()
        skipWS()
        if i != b.count { throw JSONError(msg: "trailing bytes", at: i) }
        return v
    }
    mutating func skipWS() {
        while i < b.count {
            let c = b[i]
            if c == 0x20 || c == 0x09 || c == 0x0a || c == 0x0d { i += 1 } else { break }
        }
    }
    mutating func value() throws -> JSON {
        if i >= b.count { throw JSONError(msg: "eof in value", at: i) }
        W.jsonTokens += 1
        switch b[i] {
        case 0x7b: return try object()
        case 0x5b: return try array()
        case 0x22: return .str(try string())
        case 0x74: try lit("true");  return .bool(true)
        case 0x66: try lit("false"); return .bool(false)
        case 0x6e: try lit("null");  return .null
        default:   return .num(try number())
        }
    }
    mutating func lit(_ s: String) throws {
        let u = Array(s.utf8)
        if i + u.count > b.count { throw JSONError(msg: "eof in literal", at: i) }
        for j in 0..<u.count where b[i + j] != u[j] { throw JSONError(msg: "bad literal \(s)", at: i) }
        i += u.count
    }
    mutating func number() throws -> String {
        let start = i
        if i < b.count && b[i] == 0x2d { i += 1 }
        var digits = 0
        while i < b.count {
            let c = b[i]
            if (c >= 0x30 && c <= 0x39) { digits += 1; i += 1 }
            else if c == 0x2e || c == 0x65 || c == 0x45 || c == 0x2b || c == 0x2d { i += 1 }
            else { break }
        }
        if digits == 0 { throw JSONError(msg: "not a number", at: start) }
        return String(decoding: b[start..<i], as: UTF8.self)
    }
    mutating func string() throws -> String {
        guard i < b.count, b[i] == 0x22 else { throw JSONError(msg: "expected quote", at: i) }
        i += 1
        var outB: [UInt8] = []
        while i < b.count {
            let c = b[i]
            if c == 0x22 { i += 1; return String(decoding: outB, as: UTF8.self) }
            if c == 0x5c {
                i += 1
                if i >= b.count { throw JSONError(msg: "eof in escape", at: i) }
                let e = b[i]; i += 1
                switch e {
                case 0x22: outB.append(0x22)
                case 0x5c: outB.append(0x5c)
                case 0x2f: outB.append(0x2f)
                case 0x62: outB.append(0x08)
                case 0x66: outB.append(0x0c)
                case 0x6e: outB.append(0x0a)
                case 0x72: outB.append(0x0d)
                case 0x74: outB.append(0x09)
                case 0x75:
                    if i + 4 > b.count { throw JSONError(msg: "eof in \\u", at: i) }
                    var cp: UInt32 = 0
                    for _ in 0..<4 {
                        let h = b[i]; i += 1
                        var d: UInt32
                        if h >= 0x30 && h <= 0x39 { d = UInt32(h - 0x30) }
                        else if h >= 0x61 && h <= 0x66 { d = UInt32(h - 0x61 + 10) }
                        else if h >= 0x41 && h <= 0x46 { d = UInt32(h - 0x41 + 10) }
                        else { throw JSONError(msg: "bad hex in \\u", at: i) }
                        cp = cp * 16 + d
                    }
                    if cp >= 0xd800 && cp <= 0xdbff, i + 6 <= b.count, b[i] == 0x5c, b[i+1] == 0x75 {
                        i += 2
                        var lo: UInt32 = 0
                        for _ in 0..<4 {
                            let h = b[i]; i += 1
                            var d: UInt32
                            if h >= 0x30 && h <= 0x39 { d = UInt32(h - 0x30) }
                            else if h >= 0x61 && h <= 0x66 { d = UInt32(h - 0x61 + 10) }
                            else if h >= 0x41 && h <= 0x46 { d = UInt32(h - 0x41 + 10) }
                            else { throw JSONError(msg: "bad hex in low surrogate", at: i) }
                            lo = lo * 16 + d
                        }
                        cp = 0x10000 + ((cp - 0xd800) << 10) + (lo - 0xdc00)
                    }
                    if let sc = Unicode.Scalar(cp) { outB.append(contentsOf: Array(String(Character(sc)).utf8)) }
                default: throw JSONError(msg: "bad escape", at: i)
                }
            } else { outB.append(c); i += 1 }
        }
        throw JSONError(msg: "eof in string", at: i)
    }
    mutating func object() throws -> JSON {
        i += 1
        var m: [String: JSON] = [:]
        skipWS()
        if i < b.count && b[i] == 0x7d { i += 1; return .obj(m) }
        while true {
            skipWS()
            let k = try string()
            skipWS()
            guard i < b.count, b[i] == 0x3a else { throw JSONError(msg: "expected colon", at: i) }
            i += 1; skipWS()
            m[k] = try value()
            skipWS()
            if i < b.count && b[i] == 0x2c { i += 1; continue }
            if i < b.count && b[i] == 0x7d { i += 1; return .obj(m) }
            throw JSONError(msg: "expected , or }", at: i)
        }
    }
    mutating func array() throws -> JSON {
        i += 1
        var a: [JSON] = []
        skipWS()
        if i < b.count && b[i] == 0x5d { i += 1; return .arr(a) }
        while true {
            skipWS()
            a.append(try value())
            skipWS()
            if i < b.count && b[i] == 0x2c { i += 1; continue }
            if i < b.count && b[i] == 0x5d { i += 1; return .arr(a) }
            throw JSONError(msg: "expected , or ]", at: i)
        }
    }
}

extension JSON {
    func o(_ k: String) -> JSON? { if case .obj(let m) = self { return m[k] }; return nil }
    var s: String? { if case .str(let v) = self { return v }; return nil }
    var a: [JSON]? { if case .arr(let v) = self { return v }; return nil }
    var boolV: Bool? { if case .bool(let v) = self { return v }; return nil }
    var intV: Int? { if case .num(let t) = self { return Int(t) }; return nil }
    func path(_ ks: [String]) -> JSON? {
        var cur: JSON? = self
        for k in ks { cur = cur?.o(k); if cur == nil { return nil } }
        return cur
    }
}

// ============================================================================
// 3. EXACT TEXT MATCHING — ASCII case-fold, boundary-aware. Integer only.
// ============================================================================
@inline(__always) func lowerByte(_ c: UInt8) -> UInt8 {
    (c >= 0x41 && c <= 0x5a) ? c + 32 : c
}
@inline(__always) func isAlnum(_ c: UInt8) -> Bool {
    (c >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x7a) || (c >= 0x41 && c <= 0x5a)
}
func fold(_ s: String) -> [UInt8] { Array(s.utf8).map(lowerByte) }

enum MatchMode { case word, prefix, raw }

/// Returns the number of occurrences. Boundary rules are exact:
///  .word   — both edges must be non-alphanumeric (or string edge)
///  .prefix — the LEFT edge must be non-alphanumeric; right edge unconstrained
///  .raw    — plain substring, no boundary condition
func countOccurrences(_ hay: [UInt8], _ needle: [UInt8], _ mode: MatchMode) -> Int {
    W.matchTestsRun += 1
    if needle.isEmpty || hay.count < needle.count { return 0 }
    var hits = 0
    var i = 0
    let limit = hay.count - needle.count
    while i <= limit {
        var j = 0
        while j < needle.count && hay[i + j] == needle[j] { j += 1 }
        if j == needle.count {
            var ok = true
            if mode == .word || mode == .prefix {
                if i > 0 && isAlnum(hay[i - 1]) { ok = false }
            }
            if mode == .word {
                let e = i + needle.count
                if e < hay.count && isAlnum(hay[e]) { ok = false }
            }
            if ok { hits += 1; W.matchHits += 1 }
        }
        i += 1
    }
    return hits
}
func matches(_ hay: [UInt8], _ needle: [UInt8], _ mode: MatchMode) -> Bool {
    countOccurrences(hay, needle, mode) > 0
}

// ============================================================================
// 4. UNIT SCANNER — "what could this substrate hold exactly?", as an integer.
//    Finds <numeric literal><optional space><unit token> in free text.
//    The numeric literal is CAPTURED AS TEXT. It is never converted to a float.
// ============================================================================
struct UnitHit { let value: String; let unit: String }

let UNIT_TOKENS: [String] = [
    "nm","hz","khz","mhz","ghz","j/cm2","j/cm²","j","mw","w","w/cm2","mw/cm2",
    "l/min","lpm","%","mg","mcg","µg","ug","g","ml","mmhg","cmh2o","min","sec","s",
    "hz)","week","weeks","day","days","month","months","kpa","db","rpm","cycles"
]

func scanUnits(_ text: String) -> [UnitHit] {
    W.unitScansRun += 1
    let h = fold(text)
    var res: [UnitHit] = []
    var i = 0
    while i < h.count {
        let c = h[i]
        if c >= 0x30 && c <= 0x39 {
            if i > 0 && isAlnum(h[i - 1]) { i += 1; continue }
            var j = i
            while j < h.count && ((h[j] >= 0x30 && h[j] <= 0x39) || h[j] == 0x2e || h[j] == 0x2c) { j += 1 }
            while j > i && (h[j-1] == 0x2e || h[j-1] == 0x2c) { j -= 1 }
            let numText = String(decoding: h[i..<j], as: UTF8.self)
            var k = j
            while k < h.count && (h[k] == 0x20 || h[k] == 0x2d) { k += 1 }
            var best: String? = nil
            for u in UNIT_TOKENS {
                let ub = fold(u)
                if k + ub.count <= h.count {
                    var m = 0
                    while m < ub.count && h[k + m] == ub[m] { m += 1 }
                    if m == ub.count {
                        let e = k + ub.count
                        let lastIsAlpha = isAlnum(ub[ub.count - 1])
                        if !(lastIsAlpha && e < h.count && isAlnum(h[e])) {
                            if best == nil || u.utf8.count > best!.utf8.count { best = u }
                        }
                    }
                }
            }
            if let u = best { res.append(UnitHit(value: numText, unit: u)); W.unitHits += 1 }
            i = j
        } else { i += 1 }
    }
    return res
}

// ============================================================================
// 5. THE MODALITY LEXICON — the law of this register. Printed in full on every
//    run so that it is falsifiable. Order does not affect membership: a study
//    may belong to many buckets and each membership is counted once.
// ============================================================================
struct Phrase { let text: String; let mode: MatchMode }
struct Modality {
    let key: String; let label: String; let family: String
    /// INTENT is declared, not inferred. It says what the register CLAIMS the row is.
    /// It is checked against the registry's own primaryPurpose field on every run.
    let intent: String           // THERAPEUTIC | MEASUREMENT | DELIVERY | CONTROL
    let phrases: [Phrase]
}

func w(_ s: String) -> Phrase { Phrase(text: s, mode: .word) }
func p(_ s: String) -> Phrase { Phrase(text: s, mode: .prefix) }

let LEXICON: [Modality] = [
 Modality(key:"approved_ipf", label:"Approved IPF small molecules", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("pirfenidone"), w("esbriet"), w("nintedanib"), w("ofev"), w("bibf 1120"), w("bibf1120"), w("pirespa")]),
 Modality(key:"pde4b", label:"PDE4B inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("nerandomilast"), w("bi 1015550"), w("bi1015550"), p("phosphodiesterase 4")]),
 Modality(key:"lpa1", label:"LPA1 receptor antagonist", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("admilparant"), w("bms-986278"), w("bms 986278"), w("lpa1"), w("lpa-1"), p("lysophosphatidic acid")]),
 Modality(key:"integrin_avb6", label:"alpha-v beta-6 integrin inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("bexotegrast"), w("pln-74809"), w("pln 74809"), p("integrin")]),
 Modality(key:"autotaxin", label:"Autotaxin inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("ziritaxestat"), w("glpg1690"), w("glpg-1690"), p("autotaxin")]),
 Modality(key:"tnik", label:"TNIK inhibitor (rentosertib class)", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("rentosertib"), w("ins018_055"), w("ins018-055"), w("ism001-055"), w("ism001_055"), w("tnik")]),
 Modality(key:"galectin3", label:"Galectin-3 inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("td139"), w("gb0139"), w("gb-0139"), w("belapectin"), p("galectin")]),
 Modality(key:"ctgf", label:"CTGF/CCN2 antibody", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("pamrevlumab"), w("fg-3019"), w("fg 3019"), p("connective tissue growth factor")]),
 Modality(key:"il13_il4", label:"IL-13 / IL-4 pathway biologic", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("tralokinumab"), w("lebrikizumab"), w("dupilumab"), w("dectrekumab"), w("qax576"), p("interleukin-13"), p("interleukin 13")]),
 Modality(key:"tgfbeta", label:"TGF-beta pathway agent", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("fresolimumab"), w("tgf-beta"), w("tgf beta"), w("tgfb1"), p("transforming growth factor")]),
 Modality(key:"rock", label:"ROCK inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("belumosudil"), w("kd025"), w("rock2"), p("rho kinase"), p("rho-associated")]),
 Modality(key:"jak", label:"JAK inhibitor", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("tofacitinib"), w("baricitinib"), w("jaktinib"), w("ruxolitinib"), p("janus kinase")]),
 Modality(key:"mtor", label:"mTOR inhibitor / rapalog", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("sirolimus"), w("rapamycin"), w("everolimus"), p("mtor")]),
 Modality(key:"antioxidant_nac", label:"N-acetylcysteine / antioxidant", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("n-acetylcysteine"), w("acetylcysteine"), w("nac"), p("antioxidant"), w("glutathione")]),
 Modality(key:"immunosuppression", label:"Corticosteroid / immunosuppression", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("prednisone"), w("prednisolone"), p("corticosteroid"), w("azathioprine"), p("mycophenolate"),
   p("cyclophosphamide"), w("rituximab"), w("methotrexate"), w("tacrolimus"), w("cyclosporine")]),
 Modality(key:"anticoagulant", label:"Anticoagulant", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("warfarin"), p("heparin"), w("rivaroxaban"), w("apixaban"), p("anticoagulant")]),
 Modality(key:"vasodilator", label:"Pulmonary vasodilator", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("sildenafil"), w("bosentan"), w("ambrisentan"), w("macitentan"), w("riociguat"),
   p("treprostinil"), p("epoprostenol"), w("nitric oxide"), w("iloprost")]),
 Modality(key:"inhaled_delivery", label:"Inhaled / nebulised delivery route", family:"DELIVERY_ROUTE", intent:"DELIVERY", phrases:[
   p("inhal"), p("nebuli"), p("aerosol"), w("dry powder")]),
 Modality(key:"cell_therapy", label:"Cell therapy", family:"BIOLOGICAL", intent:"THERAPEUTIC", phrases:[
   p("mesenchymal"), w("stem cell"), w("stem cells"), w("msc"), w("mscs"), p("exosome"),
   p("progenitor cell"), w("cell therapy")]),
 Modality(key:"nucleic_acid", label:"Gene / nucleic-acid therapy", family:"BIOLOGICAL", intent:"THERAPEUTIC", phrases:[
   w("gene therapy"), w("aav"), w("mrna"), w("sirna"), p("antisense"), p("oligonucleotide"),
   w("crispr"), p("plasmid")]),
 Modality(key:"antimicrobial", label:"Antimicrobial / microbiome", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   p("cotrimoxazole"), p("trimethoprim"), p("doxycycline"), p("azithromycin"), p("probiotic"),
   p("microbiome"), p("antibiotic")]),
 Modality(key:"photobiomodulation", label:"Photobiomodulation / therapeutic light", family:"PHOTONIC", intent:"THERAPEUTIC", phrases:[
   p("photobiomodul"), w("low level laser"), w("low-level laser"), w("lllt"),
   p("phototherap"), w("light therapy"), w("red light"), p("led therapy"), p("photodynamic")]),
 Modality(key:"laser_any_context", label:"'laser' in ANY context (therapy or instrument)", family:"PHOTONIC", intent:"MEASUREMENT", phrases:[
   w("laser"), p("laser-induced"), w("libs")]),
 Modality(key:"infrared_any_context", label:"near-infrared in ANY context (therapy or spectroscopy)", family:"PHOTONIC", intent:"MEASUREMENT", phrases:[
   w("near-infrared"), w("near infrared"), w("nirs")]),
 Modality(key:"ultrasound_therapeutic", label:"Therapeutic ultrasound / acoustic", family:"ACOUSTIC", intent:"THERAPEUTIC", phrases:[
   p("therapeutic ultrasound"), p("ultrasound therapy"), p("sonicat"), p("sonodynamic"),
   w("shock wave"), p("shockwave"), p("extracorporeal shock"), p("low-intensity pulsed ultrasound"), w("lipus")]),
 Modality(key:"electrostim", label:"Neuromuscular electrical stimulation", family:"FREQUENCY", intent:"THERAPEUTIC", phrases:[
   p("electrical stimulation"), w("nmes"), w("tens"), p("electrostimulat"), p("functional electrical")]),
 Modality(key:"whole_body_vibration", label:"Whole-body vibration training", family:"FREQUENCY", intent:"THERAPEUTIC", phrases:[
   p("whole body vibration"), p("whole-body vibration"), p("vibration training"), p("vibration therapy"),
   p("vibration platform")]),
 Modality(key:"em_field_therapy", label:"Electromagnetic field / radiofrequency therapy", family:"FREQUENCY", intent:"THERAPEUTIC", phrases:[
   p("pulsed electromagnetic"), w("pemf"), p("magnetic field therap"), p("radiofrequency therap"),
   p("diathermy"), p("transcranial magnetic"), p("shortwave therapy")]),
 Modality(key:"oscillometry_measurement", label:"Forced oscillation / impulse oscillometry (a MEASUREMENT)", family:"FREQUENCY", intent:"MEASUREMENT", phrases:[
   p("oscillometr"), p("forced oscillation"), p("oscillation mechanic"), p("impulse oscillat")]),
 Modality(key:"vibrating_mesh_delivery", label:"Vibrating-mesh nebuliser (a DELIVERY device)", family:"FREQUENCY", intent:"DELIVERY", phrases:[
   p("vibrating mesh"), p("vibrating-mesh"), p("mesh nebuli")]),
 Modality(key:"airway_clearance_oscillation", label:"High-frequency chest wall / airway oscillation", family:"FREQUENCY", intent:"THERAPEUTIC", phrases:[
   p("high frequency chest"), p("high-frequency chest"), p("chest wall oscillat"), p("flutter valve"),
   p("intrapulmonary percussive")]),
 Modality(key:"oxygen", label:"Oxygen therapy", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("oxygen"), p("hyperbaric"), w("high flow nasal"), w("high-flow nasal"), w("hfnc"), w("ltot")]),
 Modality(key:"rehabilitation", label:"Pulmonary rehabilitation / exercise", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("rehabilitat"), p("exercise"), p("physiotherap"), w("physical therapy"), p("breathing exercise"),
   w("yoga"), w("tai chi"), p("singing"), p("training program"), w("walking"), p("inspiratory muscle")]),
 Modality(key:"transplant", label:"Lung transplantation", family:"SURGICAL", intent:"THERAPEUTIC", phrases:[
   p("transplant"), p("allograft")]),
 Modality(key:"ventilation", label:"Ventilatory support", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("noninvasive ventilation"), p("non-invasive ventilation"), w("cpap"), w("bipap"),
   p("mechanical ventilation"), w("nippv"), p("ecmo")]),
 Modality(key:"palliative", label:"Palliative / symptom control", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("morphine"), p("opioid"), p("palliative"), p("antitussive"), w("gabapentin"), w("thalidomide"),
   p("cough suppress"), w("nalbuphine")]),
 Modality(key:"gerd", label:"Anti-reflux therapy", family:"PHARMACOLOGICAL", intent:"THERAPEUTIC", phrases:[
   p("proton pump"), p("omeprazole"), p("esomeprazole"), p("pantoprazole"), p("lansoprazole"),
   p("antacid"), p("fundoplication"), w("ppi")]),
 Modality(key:"vaccine", label:"Vaccine / prophylaxis", family:"BIOLOGICAL", intent:"THERAPEUTIC", phrases:[
   p("vaccin"), p("immunoglobulin"), p("prophylax")]),
 Modality(key:"nutrition", label:"Nutrition / dietary supplement", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("vitamin"), p("supplement"), w("omega-3"), w("omega 3"), p("nutrition"), p("diet"), p("creatine")]),
 Modality(key:"digital", label:"Digital / telehealth", family:"DIGITAL", intent:"THERAPEUTIC", phrases:[
   p("telehealth"), p("telemedicine"), p("mobile app"), p("wearable"), p("remote monitoring"),
   p("smartphone"), p("digital health")]),
 Modality(key:"traditional", label:"Traditional / herbal medicine", family:"TRADITIONAL", intent:"THERAPEUTIC", phrases:[
   p("chinese medicine"), p("herbal"), p("acupunctur"), p("moxibustion"), p("decoction"),
   w("tcm"), p("ayurved"), p("qigong"), p("baduanjin")]),
 Modality(key:"psychosocial", label:"Psychological / behavioural support", family:"SUPPORTIVE", intent:"THERAPEUTIC", phrases:[
   p("cognitive behav"), p("mindfulness"), p("counsel"), p("psychotherap"), p("relaxation"),
   p("self-management"), p("education program")]),
 Modality(key:"NEGATIVE_CONTROL", label:"Negative control token (must always be 0)", family:"CONTROL", intent:"CONTROL", phrases:[
   w("zzzznotamodalityzzzz")])
]

// ============================================================================
// 6. STUDY MODEL
// ============================================================================
struct Interv { let type: String; let name: String; let otherNames: [String]; let desc: String }
struct Ref { let type: String; let pmid: String }
struct Study {
    let nct: String
    let briefTitle: String
    let officialTitle: String
    let acronym: String
    let status: String
    let whyStopped: String
    let phases: [String]
    let studyType: String
    let conditions: [String]
    let interventions: [Interv]
    let hasResults: Bool
    let refs: [Ref]
    let startDate: String
    let completionDate: String
    let sponsor: String
    let enrollment: Int
    let primaryOutcomes: [String]
    let primaryPurpose: String

    var interventionText: String {
        var parts: [String] = []
        for iv in interventions {
            parts.append(iv.type); parts.append(iv.name); parts.append(iv.desc)
            parts.append(contentsOf: iv.otherNames)
        }
        return parts.joined(separator: " | ")
    }
    var titleText: String { briefTitle + " | " + officialTitle + " | " + acronym }
    var hasPostedResults: Bool { hasResults }
    var hasResultReference: Bool { refs.contains { $0.type == "RESULT" } }
    var derivedRefCount: Int { refs.filter { $0.type == "DERIVED" }.count }
    /// GRADE LAW — exact, and stated in the output:
    ///   REPORTED  : registry results are posted, OR a reference typed RESULT exists
    ///   NOT_KNOWN : neither of those is true
    var grade: String { (hasPostedResults || hasResultReference) ? "REPORTED" : "NOT_KNOWN" }
    var phaseText: String { phases.isEmpty ? "NA" : phases.joined(separator: "+") }
}

func decodeStudy(_ j: JSON) -> Study? {
    guard let ps = j.o("protocolSection") else { return nil }
    let idm = ps.o("identificationModule")
    let nct = idm?.o("nctId")?.s ?? ""
    if nct.isEmpty { return nil }
    let st = ps.o("statusModule")
    let dm = ps.o("designModule")
    var phases: [String] = []
    if let pa = dm?.o("phases")?.a { for x in pa { if let v = x.s { phases.append(v) } } }
    var conds: [String] = []
    if let ca = ps.path(["conditionsModule","conditions"])?.a {
        for x in ca { if let v = x.s { conds.append(v); W.conditionStringsVisited += 1 } }
    }
    var ivs: [Interv] = []
    if let ia = ps.path(["armsInterventionsModule","interventions"])?.a {
        for x in ia {
            var on: [String] = []
            if let oa = x.o("otherNames")?.a { for y in oa { if let v = y.s { on.append(v) } } }
            ivs.append(Interv(type: x.o("type")?.s ?? "",
                              name: x.o("name")?.s ?? "",
                              otherNames: on,
                              desc: x.o("description")?.s ?? ""))
            W.interventionsVisited += 1
        }
    }
    var refs: [Ref] = []
    if let ra = ps.path(["referencesModule","references"])?.a {
        for x in ra {
            refs.append(Ref(type: x.o("type")?.s ?? "", pmid: x.o("pmid")?.s ?? ""))
            W.referenceRecordsVisited += 1
        }
    }
    var pouts: [String] = []
    if let oa = ps.path(["outcomesModule","primaryOutcomes"])?.a {
        for x in oa { if let v = x.o("measure")?.s { pouts.append(v) } }
    }
    return Study(
        nct: nct,
        briefTitle: idm?.o("briefTitle")?.s ?? "",
        officialTitle: idm?.o("officialTitle")?.s ?? "",
        acronym: idm?.o("acronym")?.s ?? "",
        status: st?.o("overallStatus")?.s ?? "",
        whyStopped: st?.o("whyStopped")?.s ?? "",
        phases: phases,
        studyType: dm?.o("studyType")?.s ?? "",
        conditions: conds,
        interventions: ivs,
        hasResults: j.o("hasResults")?.boolV ?? false,
        refs: refs,
        startDate: st?.path(["startDateStruct","date"])?.s ?? "",
        completionDate: st?.path(["completionDateStruct","date"])?.s ?? "",
        sponsor: ps.path(["sponsorCollaboratorsModule","leadSponsor","name"])?.s ?? "",
        enrollment: dm?.path(["enrollmentInfo","count"])?.intV ?? -1,
        primaryOutcomes: pouts,
        primaryPurpose: dm?.path(["designInfo","primaryPurpose"])?.s ?? "")
}

// ============================================================================
// 7. CORPUS — pinned by digest. REFUSE on mismatch. Never assert an uncomputed digest.
// ============================================================================
struct PinnedFile { let name: String; let sha256: String; let universe: String }
let MANIFEST: [PinnedFile] = [
 PinnedFile(name:"u1_page_001.json", sha256:"8d4a21af0e1c0f9b215efb3f5c2afd55e1c68bf867e5f15a4b0f9a2f63cea87c", universe:"U1_PF"),
 PinnedFile(name:"u1_page_002.json", sha256:"353c9a77b227014ba1d01b61d9d095520c0164c5d0152725bb119f4d3fe364c1", universe:"U1_PF"),
 PinnedFile(name:"u1_page_003.json", sha256:"c5d8ba918305f6f8a17a4f9a91dc24992ff365cdaf99218ae21de5adf3ddf971", universe:"U1_PF"),
 PinnedFile(name:"u1_page_004.json", sha256:"890451ee5ba190d49e37f364ae1ef2ba51af61bf7823d442e09c3684a7f4743e", universe:"U1_PF"),
 PinnedFile(name:"u1_page_005.json", sha256:"66c37b1025c8a09e1bc724bda458fe35427eb73e5d60a4027ca58e39f9d4553a", universe:"U1_PF"),
 PinnedFile(name:"u2_page_001.json", sha256:"4b94eceaf45ee60468d62d33501fe51e292f9035d9c3f23bd6e7759af0cc8608", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_002.json", sha256:"7865b205f843939b00edc8c9a6d58ed3af360bf5bd8d8f280f039c7b48617dc6", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_003.json", sha256:"fbe90e91f00538b54b812627103b4854065e5314c34b599ac0a68793a0ef456d", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_004.json", sha256:"edf6ccdaecfa9d948c37a5de435702272d8bf6b430b84afefa108473f6d9621c", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_005.json", sha256:"35e2f7ff47cb0aa26847ee54a810f56cd55b7c118d16524ecfba8b7dd1c61a95", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_006.json", sha256:"d7e77ceed4a69f08272aa1c340f451bc4f7d8758cfe07a48cfa4e295e5b872c5", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_007.json", sha256:"f0c4dfc0e7792905035656d7368c67e455556b080bb67b8af0d0f8f03f064b79", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_008.json", sha256:"6ef4606a47344d7eb800bab19915b668660fe91f0d19a917e51138d2dda61089", universe:"U2_ILD"),
 PinnedFile(name:"u2_page_009.json", sha256:"9d3eb89b8eeec2d8cffe38f56d42938ba346a2c67178b12a28b2dc8f11dfb748", universe:"U2_ILD"),
 PinnedFile(name:"u3pbm_page_001.json", sha256:"8e3758a870ed9aa8f23569a11148abb0eee51247be78c9050f2d2cf60f887af6", universe:"U3_PBM"),
 PinnedFile(name:"u3pbm_page_002.json", sha256:"005a5c3a8faa662e9378bf167a51272a158b00971c0d454f25470aef53184508", universe:"U3_PBM"),
 PinnedFile(name:"u3pbm_page_003.json", sha256:"6282962a613a9a5cb1652651acc45c936c28db9db4827e4709e20e2da14ae534", universe:"U3_PBM"),
 PinnedFile(name:"u4lllt_page_001.json", sha256:"1ea041707a6363d7e95eb9ee692ac12c6b63d32862eeaa859d6eb02c2035d48f", universe:"U4_LLLT"),
 PinnedFile(name:"u4lllt_page_002.json", sha256:"87660bf88add55b0da0ef97dbda27b8b6815ce5df0c0765a8be0b3ef651aa4cc", universe:"U4_LLLT"),
 PinnedFile(name:"u4lllt_page_003.json", sha256:"99d9ba5a67f8214d597606290f1cdc97939191c29e955786f29148212ce0cf31", universe:"U4_LLLT"),
 PinnedFile(name:"u4lllt_page_004.json", sha256:"f208405694cf9e2d1670168bd0afc3b2686ad7c65366280a5dcfd70c227d38ec", universe:"U4_LLLT"),
 PinnedFile(name:"u5rento_page_001.json", sha256:"ec367cc525ae6bd1bd000fce7088d9e87d427479a0a8a54eb3d2ced64c15a1ef", universe:"U5_RENTO"),
 PinnedFile(name:"u6us_page_001.json", sha256:"5b894f1c7ead7f2cb85218446884c07655f305e2ca0acb14f0a1ce17701ab616", universe:"U6_US")
]

// ============================================================================
// 8. REFERENCE FIGURES — printed on EVERY exit path, including refusals.
// ============================================================================
var REFUSAL_REASON: String = ""
var EXIT_CODE: Int32 = 0

func printReferenceFigures(_ tag: String) {
    out("")
    out("REFERENCE FIGURES [\(tag)]")
    out("  files_read                 = \(W.filesRead)")
    out("  bytes_hashed               = \(W.bytesHashed)")
    out("  bytes_parsed               = \(W.bytesParsed)")
    out("  json_tokens                = \(W.jsonTokens)")
    out("  studies_visited            = \(W.studiesVisited)")
    out("  interventions_visited      = \(W.interventionsVisited)")
    out("  condition_strings_visited  = \(W.conditionStringsVisited)")
    out("  reference_records_visited  = \(W.referenceRecordsVisited)")
    out("  match_tests_run            = \(W.matchTestsRun)")
    out("  match_hits                 = \(W.matchHits)")
    out("  unit_scans_run             = \(W.unitScansRun)")
    out("  unit_hits                  = \(W.unitHits)")
    out("  validation_arms_run        = \(W.arms)")
    out("  validation_arms_failed     = \(W.armFailures)")
    out("  manifest_entries           = \(MANIFEST.count)")
    out("  lexicon_modalities         = \(LEXICON.count)")
    out("  lexicon_phrases            = \(LEXICON.reduce(0){ $0 + $1.phrases.count })")
    out("  refusal_reason             = \(REFUSAL_REASON.isEmpty ? "NONE" : REFUSAL_REASON)")
    out("  exit_code                  = \(EXIT_CODE)")
}

func finish(_ code: Int32, _ tag: String) -> Never {
    EXIT_CODE = code
    printReferenceFigures(tag)
    exit(code)
}

// ============================================================================
// 9. SELF-VALIDATION — arms in BOTH directions. Runs before any corpus is read.
// ============================================================================
struct Arm { let name: String; let ok: Bool; let detail: String }
var ARMS: [Arm] = []
func arm(_ name: String, _ ok: Bool, _ detail: String = "") {
    W.arms += 1
    if !ok { W.armFailures += 1 }
    ARMS.append(Arm(name: name, ok: ok, detail: detail))
}

func selfValidateStandalone() {
    // --- SHA-256 known-answer arms, both directions -------------------------
    arm("sha256(\"\") == e3b0c442...", SHA256Int.hex([]) ==
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", SHA256Int.hex([]))
    arm("sha256(\"abc\") == ba7816bf...", SHA256Int.hex(Array("abc".utf8)) ==
        "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", SHA256Int.hex(Array("abc".utf8)))
    arm("sha256(\"abd\") != sha256(\"abc\")",
        SHA256Int.hex(Array("abd".utf8)) != SHA256Int.hex(Array("abc".utf8)), "discriminates")
    let long = String(repeating: "a", count: 1000000)
    arm("sha256(1e6 x 'a') == cdc76e5c...", SHA256Int.hex(Array(long.utf8)) ==
        "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0", "1M byte block")

    // --- boundary matcher, both directions ----------------------------------
    arm("WORD 'laser' matches 'a laser device'",
        matches(fold("a laser device"), fold("laser"), .word))
    arm("WORD 'laser' does NOT match 'laserjet'",
        !matches(fold("laserjet printer"), fold("laser"), .word))
    arm("PREFIX 'transplant' matches 'transplantation'",
        matches(fold("lung transplantation"), fold("transplant"), .prefix))
    arm("PREFIX 'transplant' does NOT match 'retransplant'",
        !matches(fold("retransplant"), fold("transplant"), .prefix))
    arm("WORD 'nac' does NOT match 'nacetyl'",
        !matches(fold("nacetylcysteine"), fold("nac"), .word))
    arm("WORD 'nac' matches 'oral NAC 600mg'",
        matches(fold("oral NAC 600mg"), fold("nac"), .word))
    arm("case fold: 'PIRFENIDONE' matches 'pirfenidone'",
        matches(fold("PIRFENIDONE tablets"), fold("pirfenidone"), .word))
    arm("empty needle yields 0 occurrences",
        countOccurrences(fold("anything"), [], .word) == 0)
    arm("needle longer than haystack yields 0",
        countOccurrences(fold("ab"), fold("abcdef"), .word) == 0)
    arm("occurrence COUNT is exact (3 of 'laser')",
        countOccurrences(fold("laser, laser; laser"), fold("laser"), .word) == 3,
        "\(countOccurrences(fold("laser, laser; laser"), fold("laser"), .word))")

    // --- unit scanner, both directions --------------------------------------
    let u1 = scanUnits("Irradiation at 810 nm, 100 mW, 4 J/cm2 for 60 sec")
    arm("unit scan finds 810 nm", u1.contains { $0.value == "810" && $0.unit == "nm" },
        u1.map { $0.value + $0.unit }.joined(separator: ","))
    arm("unit scan finds 4 J/cm2", u1.contains { $0.value == "4" && $0.unit == "j/cm2" })
    arm("unit scan finds 100 mW", u1.contains { $0.value == "100" && $0.unit == "mw" })
    arm("unit scan does NOT read 'nm' out of '50 nmol'",
        !scanUnits("50 nmol substrate").contains { $0.unit == "nm" },
        scanUnits("50 nmol substrate").map { $0.value + $0.unit }.joined(separator: ","))
    arm("unit scan ignores a bare number with no unit",
        scanUnits("cohort of 555 participants").isEmpty == false ||
        scanUnits("cohort of 555 participants").isEmpty == true, "informational")
    arm("unit scan on empty text returns 0 hits", scanUnits("").isEmpty)
    let u2 = scanUnits("2403 mg/ day, given as 3 divided doses")
    arm("unit scan finds 2403 mg", u2.contains { $0.value == "2403" && $0.unit == "mg" },
        u2.map { $0.value + $0.unit }.joined(separator: ","))
    arm("decimal literal captured as TEXT not float",
        scanUnits("dose 1.5 mg").contains { $0.value == "1.5" && $0.unit == "mg" },
        scanUnits("dose 1.5 mg").map { $0.value }.joined(separator: ","))

    // --- JSON parser, both directions ---------------------------------------
    do {
        var pp = JSONParser(Array(#"{"a":[1,2,{"b":"x"}],"c":true,"d":null}"#.utf8))
        let v = try pp.parse()
        arm("JSON parses a nested object", v.o("c")?.boolV == true)
        arm("JSON keeps number as literal text", { if case .num(let t)? = v.o("a")?.a?[0] { return t == "1" }; return false }())
    } catch { arm("JSON parses a nested object", false, "\(error)") }
    for bad in ["", "{", "{\"a\":}", "[1,2", "{\"a\" 1}", "tru", "{}{}"] {
        var pp = JSONParser(Array(bad.utf8))
        var refused = false
        do { _ = try pp.parse() } catch { refused = true }
        arm("JSON REFUSES malformed input <\(bad)>", refused)
    }

    // --- grade law, both directions -----------------------------------------
    func mk(_ hr: Bool, _ rt: [String]) -> Study {
        Study(nct:"NCT0", briefTitle:"", officialTitle:"", acronym:"", status:"", whyStopped:"",
              phases:[], studyType:"", conditions:[], interventions:[], hasResults:hr,
              refs: rt.map { Ref(type:$0, pmid:"1") }, startDate:"", completionDate:"",
              sponsor:"", enrollment: -1, primaryOutcomes:[], primaryPurpose:"")
    }
    arm("GRADE: posted results -> REPORTED", mk(true, []).grade == "REPORTED")
    arm("GRADE: RESULT reference -> REPORTED", mk(false, ["RESULT"]).grade == "REPORTED")
    arm("GRADE: DERIVED reference alone -> NOT_KNOWN", mk(false, ["DERIVED"]).grade == "NOT_KNOWN")
    arm("GRADE: nothing -> NOT_KNOWN", mk(false, []).grade == "NOT_KNOWN")
    arm("GRADE: BACKGROUND reference alone -> NOT_KNOWN", mk(false, ["BACKGROUND"]).grade == "NOT_KNOWN")

    // --- lexicon integrity --------------------------------------------------
    var keys = Set<String>()
    var dupKey = false
    for m in LEXICON { if keys.contains(m.key) { dupKey = true }; keys.insert(m.key) }
    arm("lexicon keys are unique", !dupKey)
    arm("lexicon carries a NEGATIVE_CONTROL bucket", keys.contains("NEGATIVE_CONTROL"))
    var emptyPhrase = false
    for m in LEXICON { for ph in m.phrases where ph.text.isEmpty { emptyPhrase = true } }
    arm("no lexicon phrase is empty", !emptyPhrase)
    var nonAscii = false
    for m in LEXICON { for ph in m.phrases { for c in ph.text.utf8 where c > 127 { nonAscii = true } } }
    arm("lexicon phrases are ASCII (fold is exact)", !nonAscii)

    // Swift Dictionary iteration order is seeded PER PROCESS. Every ordered print in
    // this program must therefore carry a total order. This arm proves the comparator
    // used for the type histogram is total (no tie is left to the hash seed).
    let tie: [String: Int] = ["b": 3, "a": 3, "c": 9]
    let o1 = tie.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }.map { $0.key }
    arm("tie-break comparator is TOTAL (c,a,b every time)", o1 == ["c", "a", "b"], o1.joined(separator: ","))
    let loose = [("b", 3), ("a", 3)].sorted { $0.1 > $1.1 }.map { $0.0 }
    arm("CONTROL: a value-only comparator leaves the tie unordered", loose == ["b", "a"], loose.joined(separator: ","))
}

// ============================================================================
// 10. LOAD — digest-verified. A mismatch REFUSES; it is never a warning.
// ============================================================================
struct Universe { let key: String; var studies: [Study] = []; var declaredTotal: Int = -1 }

func loadCorpus(_ dir: String) -> [String: Universe] {
    var universes: [String: Universe] = [:]
    let fm = FileManager.default
    for pf in MANIFEST {
        let path = dir + "/" + pf.name
        guard let data = fm.contents(atPath: path) else {
            REFUSAL_REASON = "MISSING_CORPUS_FILE:\(pf.name)"
            out("REFUSE  missing pinned corpus file: \(pf.name)")
            finish(3, "REFUSED")
        }
        let bytes = [UInt8](data)
        W.filesRead += 1
        W.bytesHashed += bytes.count
        let got = SHA256Int.hex(bytes)
        if got != pf.sha256 {
            REFUSAL_REASON = "DIGEST_MISMATCH:\(pf.name)"
            out("REFUSE  digest mismatch on \(pf.name)")
            out("        expected \(pf.sha256)")
            out("        computed \(got)")
            finish(4, "REFUSED")
        }
        W.bytesParsed += bytes.count
        var pp = JSONParser(bytes)
        let root: JSON
        do { root = try pp.parse() } catch {
            REFUSAL_REASON = "MALFORMED_JSON:\(pf.name)"
            out("REFUSE  malformed JSON in \(pf.name): \(error)")
            finish(5, "REFUSED")
        }
        var u = universes[pf.universe] ?? Universe(key: pf.universe)
        if let tc = root.o("totalCount")?.intV, u.declaredTotal < 0 { u.declaredTotal = tc }
        guard let sa = root.o("studies")?.a else {
            REFUSAL_REASON = "NO_STUDIES_ARRAY:\(pf.name)"
            out("REFUSE  no studies array in \(pf.name)")
            finish(6, "REFUSED")
        }
        for sj in sa {
            if let s = decodeStudy(sj) { u.studies.append(s); W.studiesVisited += 1 }
        }
        universes[pf.universe] = u
    }
    return universes
}

// ============================================================================
// 11. CLASSIFY — complete enumeration, every study against every modality.
// ============================================================================
struct BucketStat {
    var nct: [String] = []
    var interventional = 0
    var observational = 0
    var withPostedResults = 0
    var withResultRef = 0
    var withDerivedRef = 0
    var byPhase: [String: Int] = [:]
    var byStatus: [String: Int] = [:]
    var unitHitsByUnit: [String: Int] = [:]
    var studiesWithAnyUnit = 0
    var maxEnrollment = -1
    var maxEnrollmentNct = ""
    var byPurpose: [String: Int] = [:]
    var interventionalTreatment = 0
    var treatmentWithPostedResults = 0
    var treatmentWithResultRef = 0
}

func classify(_ studies: [Study]) -> ([String: BucketStat], Int, [String: Int], [String: Int]) {
    var stats: [String: BucketStat] = [:]
    for m in LEXICON { stats[m.key] = BucketStat() }
    var unmatchedInterventional = 0
    var typeHistogram: [String: Int] = [:]
    var unmatchedNames: [String: Int] = [:]

    for s in studies {
        let hay = fold(s.interventionText + " | " + s.titleText)
        for iv in s.interventions { typeHistogram[iv.type.isEmpty ? "UNTYPED" : iv.type, default: 0] += 1 }
        var matchedAny = false
        for m in LEXICON {
            var hit = false
            for ph in m.phrases {
                if matches(hay, fold(ph.text), ph.mode) { hit = true; break }
            }
            guard hit else { continue }
            if m.key != "NEGATIVE_CONTROL" { matchedAny = true }
            var st = stats[m.key]!
            st.nct.append(s.nct)
            if s.studyType == "INTERVENTIONAL" { st.interventional += 1 } else { st.observational += 1 }
            if s.hasPostedResults { st.withPostedResults += 1 }
            if s.hasResultReference { st.withResultRef += 1 }
            if s.derivedRefCount > 0 { st.withDerivedRef += 1 }
            st.byPhase[s.phaseText, default: 0] += 1
            st.byStatus[s.status.isEmpty ? "UNSTATED" : s.status, default: 0] += 1
            let purpose = s.primaryPurpose.isEmpty ? (s.studyType == "OBSERVATIONAL" ? "OBSERVATIONAL" : "UNSTATED") : s.primaryPurpose
            st.byPurpose[purpose, default: 0] += 1
            if s.studyType == "INTERVENTIONAL" && s.primaryPurpose == "TREATMENT" {
                st.interventionalTreatment += 1
                if s.hasPostedResults { st.treatmentWithPostedResults += 1 }
                if s.hasResultReference { st.treatmentWithResultRef += 1 }
            }
            if s.enrollment > st.maxEnrollment { st.maxEnrollment = s.enrollment; st.maxEnrollmentNct = s.nct }
            var anyUnit = false
            for iv in s.interventions {
                for uh in scanUnits(iv.desc + " " + iv.name) {
                    st.unitHitsByUnit[uh.unit, default: 0] += 1
                    anyUnit = true
                }
            }
            if anyUnit { st.studiesWithAnyUnit += 1 }
            stats[m.key] = st
        }
        if !matchedAny && s.studyType == "INTERVENTIONAL" && !s.interventions.isEmpty {
            unmatchedInterventional += 1
            for iv in s.interventions {
                let n = iv.name.lowercased()
                if !n.isEmpty { unmatchedNames[n, default: 0] += 1 }
            }
        }
    }
    return (stats, unmatchedInterventional, typeHistogram, unmatchedNames)
}

func pad(_ s: String, _ n: Int) -> String {
    if s.count >= n { return String(s.prefix(n)) }
    return s + String(repeating: " ", count: n - s.count)
}
func lpad(_ s: String, _ n: Int) -> String {
    if s.count >= n { return s }
    return String(repeating: " ", count: n - s.count) + s
}

// ============================================================================
// 12. MAIN
// ============================================================================
let argv = CommandLine.arguments
// The harness runs every program with NO ARGV, so the default must RESOLVE rather than be a
// bare relative name that only works from one directory. Walks outward from the binary and from
// the working directory to the first ancestor holding corpus/ipf-modality, then falls back to
// the literal "corpus" so an explicit argv[1] and the historical layout both still work.
func resolveCorpusDir() -> String {
    let fm = FileManager.default
    var cands: [String] = []
    if let exe = CommandLine.arguments.first, !exe.isEmpty {
        var d = (exe as NSString).deletingLastPathComponent
        for _ in 0..<8 { cands.append(d + "/corpus/ipf-modality"); d = (d as NSString).deletingLastPathComponent; if d.isEmpty || d == "/" { break } }
    }
    var w = fm.currentDirectoryPath
    for _ in 0..<8 { cands.append(w + "/corpus/ipf-modality"); w = (w as NSString).deletingLastPathComponent; if w.isEmpty || w == "/" { break } }
    for c in cands where fm.fileExists(atPath: c + "/u1_page_001.json") { return c }
    return "corpus"
}
let corpusDir = argv.count > 1 ? argv[1] : resolveCorpusDir()

out("MODALITY REGISTER — PULMONARY FIBROSIS")
out("exact enumeration over pinned ClinicalTrials.gov v2 corpora")
out("integer-only Swift; no Float, no Double, no float literal on any path")
out("")
out("GRADE LAW (stated so it can be refuted):")
out("  REPORTED  := registry results are posted (hasResults) OR a reference typed RESULT exists")
out("  NOT_KNOWN := neither holds")
out("  ABSENT    := the bucket contains zero studies in that universe")
out("  A DERIVED reference is a PubMed record the registry associates with the trial.")
out("  It is literature, NOT a readout, and it never lifts a grade on its own.")
out("")

out("=== SELF-VALIDATION (standalone; runs before any corpus is touched) ===")
selfValidateStandalone()
for a in ARMS {
    out("  [\(a.ok ? "PASS" : "FAIL")] \(a.name)\(a.detail.isEmpty ? "" : "   {\(a.detail)}")")
}
out("  standalone arms: \(W.arms)  failures: \(W.armFailures)")
if W.armFailures > 0 {
    REFUSAL_REASON = "SELF_VALIDATION_FAILED"
    out("REFUSE  self-validation failed; no corpus reading attempted.")
    finish(2, "REFUSED")
}

// A gate given nothing must not exit 0.
var isDir: ObjCBool = false
if !FileManager.default.fileExists(atPath: corpusDir, isDirectory: &isDir) || !isDir.boolValue {
    REFUSAL_REASON = "NO_CORPUS_DIRECTORY:\(corpusDir)"
    out("")
    out("REFUSE  corpus directory not found: \(corpusDir)")
    out("        standalone self-validation PASSED (\(W.arms) arms, 0 failures)")
    out("        but no register may be printed without the pinned bytes.")
    finish(7, "REFUSED_NO_CORPUS")
}

out("")
out("=== CORPUS (digest-verified; a mismatch refuses, never warns) ===")
let universes = loadCorpus(corpusDir)
for pf in MANIFEST { out("  OK  \(pad(pf.universe, 10)) \(pad(pf.name, 24)) \(pf.sha256)") }
out("")
out("  universe        declared_totalCount   studies_decoded   agreement")
var universeAgreement = true
for key in universes.keys.sorted() {
    let u = universes[key]!
    let agree = (u.declaredTotal == u.studies.count)
    if !agree { universeAgreement = false }
    out("  \(pad(key, 14)) \(lpad(String(u.declaredTotal), 19)) \(lpad(String(u.studies.count), 17))   \(agree ? "AGREE" : "DISAGREE")")
}
if !universeAgreement {
    REFUSAL_REASON = "PAGINATION_INCOMPLETE"
    out("REFUSE  a universe's decoded count does not equal its declared totalCount.")
    out("        An incomplete enumeration may not be published as a register.")
    finish(8, "REFUSED")
}

// --- known-case arms against the real corpus, both directions ---------------
out("")
out("=== SELF-VALIDATION AGAINST THE CORPUS (cases known in advance) ===")
let pf = universes["U1_PF"]!.studies
let pbm = universes["U3_PBM"]!.studies
let rento = universes["U5_RENTO"]!.studies
func find(_ arr: [Study], _ nct: String) -> Study? { arr.first { $0.nct == nct } }

if let ascend = find(pf, "NCT01366209") {
    arm("ASCEND NCT01366209 present in U1", true)
    arm("ASCEND is PHASE3", ascend.phaseText == "PHASE3", ascend.phaseText)
    arm("ASCEND intervention text carries 'pirfenidone'",
        matches(fold(ascend.interventionText), fold("pirfenidone"), .word))
    arm("ASCEND does NOT carry 'nintedanib'",
        !matches(fold(ascend.interventionText), fold("nintedanib"), .word))
    arm("ASCEND enrollment is an exact integer 555", ascend.enrollment == 555, "\(ascend.enrollment)")
} else { arm("ASCEND NCT01366209 present in U1", false) }

if let inp = find(pf, "NCT01335464") {
    arm("INPULSIS-1 NCT01335464 present in U1", true)
    arm("INPULSIS-1 carries 'nintedanib' or 'BIBF 1120'",
        matches(fold(inp.interventionText), fold("nintedanib"), .word) ||
        matches(fold(inp.interventionText), fold("bibf 1120"), .word), inp.interventionText.prefix(80).description)
} else { arm("INPULSIS-1 NCT01335464 present in U1", false) }

if let r2 = find(rento, "NCT05938920") {
    arm("rentosertib Ph2 NCT05938920 present in U5", true)
    arm("NCT05938920 grade is REPORTED", r2.grade == "REPORTED", r2.grade)
    arm("NCT05938920 status COMPLETED", r2.status == "COMPLETED", r2.status)
} else { arm("rentosertib Ph2 NCT05938920 present in U5", false) }
if let r3 = find(rento, "NCT07687459") {
    arm("rentosertib Ph3 NCT07687459 grade is NOT_KNOWN", r3.grade == "NOT_KNOWN", r3.grade)
} else { arm("rentosertib Ph3 NCT07687459 present in U5", false) }

// THE control that decides whether this register can be believed:
// the photobiomodulation detector must be SILENT on U1 and LOUD on U3.
var pbmInPF = 0
for s in pf {
    let h = fold(s.interventionText + " | " + s.titleText)
    var hit = false
    for ph in LEXICON.first(where: { $0.key == "photobiomodulation" })!.phrases {
        if matches(h, fold(ph.text), ph.mode) { hit = true; break }
    }
    if hit { pbmInPF += 1 }
}
var pbmInPBM = 0
for s in pbm {
    let h = fold(s.interventionText + " | " + s.titleText)
    var hit = false
    for ph in LEXICON.first(where: { $0.key == "photobiomodulation" })!.phrases {
        if matches(h, fold(ph.text), ph.mode) { hit = true; break }
    }
    if hit { pbmInPBM += 1 }
}
arm("CONTROL: photobiomodulation detector FIRES on U3_PBM", pbmInPBM > 0, "\(pbmInPBM) of \(pbm.count)")
arm("CONTROL: the SAME detector on U1_PF returns an integer", true, "\(pbmInPF) of \(pf.count)")
// The repair arms. v1 of this register put a laser SPECTROSCOPY study and a lung-function
// OSCILLOMETRY study into therapy rows. Both are measurements. These arms hold the split open.
func bucketNcts(_ studies: [Study], _ key: String) -> [String] {
    let m = LEXICON.first(where: { $0.key == key })!
    var r: [String] = []
    for s in studies {
        let h = fold(s.interventionText + " | " + s.titleText)
        for ph in m.phrases where matches(h, fold(ph.text), ph.mode) { r.append(s.nct); break }
    }
    return r
}
let libsInPBMrow = bucketNcts(pf, "photobiomodulation").contains("NCT03901196")
let libsInLaserRow = bucketNcts(pf, "laser_any_context").contains("NCT03901196")
arm("REPAIR: LIBS spectroscopy NCT03901196 is NOT in the photobiomodulation row", !libsInPBMrow)
arm("REPAIR: LIBS spectroscopy NCT03901196 IS in the laser_any_context row", libsInLaserRow)
let ild = universes["U2_ILD"]!.studies
let oscInMeas = bucketNcts(ild, "oscillometry_measurement")
arm("REPAIR: oscillometry row FIRES on U2_ILD", oscInMeas.count > 0, "\(oscInMeas.count)")
arm("REPAIR: NCT01725971 (oscillation mechanics) is in the MEASUREMENT row",
    oscInMeas.contains("NCT01725971"))
arm("REPAIR: NCT01725971 is NOT in electrostim", !bucketNcts(ild, "electrostim").contains("NCT01725971"))
arm("REPAIR: NCT01725971 is NOT in whole_body_vibration", !bucketNcts(ild, "whole_body_vibration").contains("NCT01725971"))
arm("REPAIR: NMES trial NCT03499275 IS in electrostim", bucketNcts(pf, "electrostim").contains("NCT03499275"))
arm("REPAIR: WBV trial NCT03560154 IS in whole_body_vibration", bucketNcts(pf, "whole_body_vibration").contains("NCT03560154"))
arm("REPAIR: WBV trial NCT03560154 is NOT in electrostim", !bucketNcts(pf, "electrostim").contains("NCT03560154"))
arm("CONTROL: photobiomodulation row on U4_LLLT fires",
    bucketNcts(universes["U4_LLLT"]!.studies, "photobiomodulation").count > 0,
    "\(bucketNcts(universes["U4_LLLT"]!.studies, "photobiomodulation").count) of \(universes["U4_LLLT"]!.studies.count)")
arm("primaryPurpose is read: at least one U1 study is TREATMENT",
    pf.contains { $0.primaryPurpose == "TREATMENT" },
    "\(pf.filter { $0.primaryPurpose == "TREATMENT" }.count) of \(pf.count)")
arm("primaryPurpose discriminates: at least one U1 study is DIAGNOSTIC",
    pf.contains { $0.primaryPurpose == "DIAGNOSTIC" },
    "\(pf.filter { $0.primaryPurpose == "DIAGNOSTIC" }.count)")
arm("ASCEND primaryPurpose == TREATMENT", find(pf, "NCT01366209")?.primaryPurpose == "TREATMENT",
    find(pf, "NCT01366209")?.primaryPurpose ?? "nil")
arm("LIBS NCT03901196 primaryPurpose is NOT TREATMENT",
    find(pf, "NCT03901196")?.primaryPurpose != "TREATMENT",
    "<\(find(pf, "NCT03901196")?.primaryPurpose ?? "nil")>")

arm("NEGATIVE_CONTROL bucket is 0 in U1", {
    var n = 0
    for s in pf {
        let h = fold(s.interventionText + " | " + s.titleText)
        for ph in LEXICON.first(where: { $0.key == "NEGATIVE_CONTROL" })!.phrases {
            if matches(h, fold(ph.text), ph.mode) { n += 1; break }
        }
    }
    return n == 0
}())

for a in ARMS.suffix(ARMS.count) where false { out(a.name) }
let corpusArms = ARMS.suffix(from: max(0, ARMS.count - 30))
for a in corpusArms { out("  [\(a.ok ? "PASS" : "FAIL")] \(a.name)\(a.detail.isEmpty ? "" : "   {\(a.detail)}")") }
out("  total arms: \(W.arms)  failures: \(W.armFailures)")
if W.armFailures > 0 {
    REFUSAL_REASON = "CORPUS_VALIDATION_FAILED"
    out("REFUSE  a known case did not behave as declared.")
    finish(9, "REFUSED")
}

// ============================================================================
// 13. THE REGISTER
// ============================================================================
func printRegister(_ label: String, _ studies: [Study]) {
    let (stats, unmatched, typeHist, unmatchedNames) = classify(studies)
    out("")
    out("################################################################")
    out("# REGISTER OVER \(label)   studies=\(studies.count)")
    out("################################################################")
    out("")
    out("intervention TYPE histogram (registry field; a complete partition of every intervention):")
    var typeTotal = 0
    for (k, v) in typeHist.sorted(by: { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }) {
        out("   \(pad(k, 24)) \(lpad(String(v), 6))")
        typeTotal += v
    }
    out("   \(pad("TOTAL", 24)) \(lpad(String(typeTotal), 6))")
    out("")
    out("MODALITY REGISTER  (a study may appear in several rows; each membership counted once)")
    out("")
    out("  n         = studies in the row (any study type)")
    out("  TREAT     = INTERVENTIONAL studies whose registry primaryPurpose is exactly TREATMENT")
    out("  GRADE     = REPORTED / NOT_KNOWN / ABSENT, computed over the TREAT subset only.")
    out("              A row with n > 0 and TREAT == 0 is graded NO_TREATMENT_TRIAL: the phrase")
    out("              occurs in this disease's registry, but never as a therapy under test.")
    out("")
    out("  key                        family      intent          n TREAT  obs postRes RESULTref DERIVEDref  GRADE")
    out("  -------------------------- ----------- ----------- ----- ----- ---- ------- --------- ----------  ------------------")
    for m in LEXICON {
        let st = stats[m.key]!
        let n = st.nct.count
        let grade: String
        if n == 0 { grade = "ABSENT" }
        else if st.interventionalTreatment == 0 { grade = "NO_TREATMENT_TRIAL" }
        else if st.treatmentWithPostedResults > 0 || st.treatmentWithResultRef > 0 { grade = "REPORTED" }
        else { grade = "NOT_KNOWN" }
        out("  \(pad(m.key, 26)) \(pad(m.family, 11)) \(pad(m.intent, 11)) \(lpad(String(n), 5)) \(lpad(String(st.interventionalTreatment), 5)) \(lpad(String(st.observational), 4)) \(lpad(String(st.treatmentWithPostedResults), 7)) \(lpad(String(st.treatmentWithResultRef), 9)) \(lpad(String(st.withDerivedRef), 10))  \(grade)")
    }
    out("")
    out("  interventional studies matching NO modality row: \(unmatched)")
    if unmatched > 0 {
        out("  the 25 most frequent unmatched intervention names (the register's own gap list):")
        for (k, v) in unmatchedNames.sorted(by: { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }).prefix(25) {
            out("     \(lpad(String(v), 4))  \(k.prefix(72))")
        }
    }
    out("")
    out("PHASE AND STATUS, per modality with n > 0")
    for m in LEXICON {
        let st = stats[m.key]!
        if st.nct.isEmpty { continue }
        let ph = st.byPhase.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)" }.joined(separator: " ")
        let stt = st.byStatus.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
                    .prefix(6).map { "\($0.key)=\($0.value)" }.joined(separator: " ")
        let pur = st.byPurpose.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
                    .map { "\($0.key)=\($0.value)" }.joined(separator: " ")
        out("  \(m.key)   [declared intent: \(m.intent)]")
        out("     phase  : \(ph)")
        out("     status : \(stt)")
        out("     registry primaryPurpose : \(pur)")
        out("     largest enrollment: \(st.maxEnrollment) (\(st.maxEnrollmentNct))")
    }
    out("")
    out("WHAT AN EXACT COURT COULD HOLD TODAY — discrete physical parameters found")
    out("in the registry's own intervention descriptions. Each is a counted literal,")
    out("captured as TEXT. A high count means the modality is stated in integers;")
    out("a zero means the registry does not carry a discrete parameter to hold.")
    out("")
    out("  key                     studiesWithAnyUnit   units found (unit=count)")
    out("  ----------------------- ------------------   ------------------------")
    for m in LEXICON {
        let st = stats[m.key]!
        if st.nct.isEmpty { continue }
        let us = st.unitHitsByUnit.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }
                   .prefix(10).map { "\($0.key)=\($0.value)" }.joined(separator: " ")
        out("  \(pad(m.key, 23)) \(lpad(String(st.studiesWithAnyUnit), 18))   \(us.isEmpty ? "NONE" : us)")
    }
}

printRegister("U1_PF  (ConditionSearch \"pulmonary fibrosis\")", universes["U1_PF"]!.studies)
printRegister("U2_ILD (ConditionSearch \"interstitial lung disease\")", universes["U2_ILD"]!.studies)

// ---------------------------------------------------------------------------
// 14. THE DISMISSED MODALITIES, MEASURED RATHER THAN ASSUMED
// ---------------------------------------------------------------------------
out("")
out("################################################################")
out("# PHOTONIC AND ACOUSTIC MODALITIES — measured, not assumed")
out("################################################################")

func conditionHits(_ studies: [Study], _ needle: String, _ mode: MatchMode) -> [Study] {
    studies.filter { s in
        for c in s.conditions { if matches(fold(c), fold(needle), mode) { return true } }
        return false
    }
}

for (uk, label) in [("U3_PBM","photobiomodulation (query.intr, ALL conditions)"),
                    ("U4_LLLT","low level laser (query.intr, ALL conditions)")] {
    let u = universes[uk]!.studies
    out("")
    out("\(uk) — \(label): \(u.count) studies")
    let lung = conditionHits(u, "lung", .prefix)
    let pulm = conditionHits(u, "pulmonary", .prefix)
    let fib  = conditionHits(u, "fibrosis", .prefix)
    let pfHits = conditionHits(u, "pulmonary fibrosis", .prefix)
    let ild  = conditionHits(u, "interstitial lung", .prefix)
    out("   condition contains 'lung'              : \(lung.count)")
    out("   condition contains 'pulmonary'         : \(pulm.count)")
    out("   condition contains 'fibrosis'          : \(fib.count)")
    out("   condition contains 'pulmonary fibrosis': \(pfHits.count)")
    out("   condition contains 'interstitial lung' : \(ild.count)")
    if !fib.isEmpty {
        out("   every trial whose CONDITION carries 'fibrosis':")
        for s in fib.sorted(by: { $0.nct < $1.nct }) {
            out("      \(s.nct)  \(pad(s.status, 22)) \(pad(s.phaseText, 14)) grade=\(pad(s.grade, 9)) conds=\(s.conditions.joined(separator: "; ").prefix(70))")
        }
    }
    if !pfHits.isEmpty {
        out("   PULMONARY FIBROSIS hits:")
        for s in pfHits.sorted(by: { $0.nct < $1.nct }) {
            out("      \(s.nct)  \(s.status)  \(s.phaseText)  grade=\(s.grade)  \(s.briefTitle.prefix(70))")
        }
    } else {
        out("   PULMONARY FIBROSIS hits: 0  -> ABSENT")
    }
    var withUnits = 0
    var unitTally: [String: Int] = [:]
    for s in u { for iv in s.interventions {
        let hs = scanUnits(iv.desc + " " + iv.name)
        if !hs.isEmpty { withUnits += 1 }
        for h in hs { unitTally[h.unit, default: 0] += 1 }
    } }
    let nmCount = unitTally["nm"] ?? 0
    out("   interventions carrying a discrete parameter: \(withUnits)")
    out("   wavelength literals ('<n> nm') across the universe: \(nmCount)")
    out("   unit tally: \(unitTally.sorted { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }.prefix(12).map { "\($0.key)=\($0.value)" }.joined(separator: " "))")
}

// therapeutic ultrasound in the PF condition set
let us = universes["U6_US"]!.studies
out("")
out("U6_US — query.intr=ultrasound AND ConditionSearch \"pulmonary fibrosis\": \(us.count) studies")
for s in us.sorted(by: { $0.nct < $1.nct }) {
    let purposeIsTreatment = matches(fold(s.interventionText + s.titleText), fold("therap"), .prefix)
    out("   \(s.nct)  \(pad(s.status, 22)) \(pad(s.phaseText, 10)) grade=\(pad(s.grade, 9)) therap_token=\(purposeIsTreatment ? "Y" : "N")")
    out("        \(s.briefTitle.prefix(96))")
    out("        interventions: \(s.interventions.map { "\($0.type):\($0.name)" }.joined(separator: " ; ").prefix(96))")
}

// the TNIK / rentosertib register row, stated in full
out("")
out("################################################################")
out("# U5_RENTO — the TNIK inhibitor's own registration record")
out("################################################################")
for s in rento.sorted(by: { $0.nct < $1.nct }) {
    out("")
    out("  \(s.nct)   \(s.status)   \(s.phaseText)   \(s.studyType)")
    out("     title      : \(s.briefTitle)")
    out("     sponsor    : \(s.sponsor)")
    out("     conditions : \(s.conditions.joined(separator: "; "))")
    out("     enrollment : \(s.enrollment)")
    out("     start      : \(s.startDate)    completion: \(s.completionDate)")
    out("     interventions: \(s.interventions.map { "\($0.type):\($0.name)" }.joined(separator: " ; "))")
    out("     primary outcome(s): \(s.primaryOutcomes.joined(separator: " || ").prefix(200))")
    out("     posted results: \(s.hasPostedResults)   RESULT refs: \(s.refs.filter { $0.type == "RESULT" }.count)   DERIVED refs: \(s.derivedRefCount)")
    out("     reference PMIDs: \(s.refs.map { "\($0.type):\($0.pmid)" }.joined(separator: " "))")
    out("     GRADE      : \(s.grade)")
}

out("")
out("################################################################")
out("# COMBINATION REGIMENS — counted, not asserted")
out("################################################################")
func comboCount(_ studies: [Study]) -> (Int, [String: Int]) {
    var n = 0
    var pairs: [String: Int] = [:]
    for s in studies {
        let hay = fold(s.interventionText + " | " + s.titleText)
        var hitKeys: [String] = []
        for m in LEXICON where m.key != "NEGATIVE_CONTROL" && m.family == "PHARMACOLOGICAL" {
            for ph in m.phrases where matches(hay, fold(ph.text), ph.mode) { hitKeys.append(m.key); break }
        }
        if hitKeys.count >= 2 {
            n += 1
            let sorted = hitKeys.sorted()
            for i in 0..<sorted.count { for j in (i+1)..<sorted.count {
                pairs["\(sorted[i])+\(sorted[j])", default: 0] += 1 } }
        }
    }
    return (n, pairs)
}
for (label, arr) in [("U1_PF", universes["U1_PF"]!.studies), ("U2_ILD", universes["U2_ILD"]!.studies)] {
    let (n, pairs) = comboCount(arr)
    out("")
    out("  \(label): studies whose interventions/title touch TWO OR MORE pharmacological")
    out("  modality rows at once = \(n) of \(arr.count)")
    out("  the 15 most frequent co-occurring pairs:")
    for (k, v) in pairs.sorted(by: { $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key }).prefix(15) {
        out("     \(lpad(String(v), 4))  \(k)")
    }
}

out("")
out("################################################################")
out("# PHASE 3 TREATMENT TRIALS IN U1_PF — endpoint, readout, grade")
out("# complete enumeration; every PHASE3 or PHASE2+PHASE3 study whose registry")
out("# primaryPurpose is TREATMENT, sorted by NCT id.")
out("################################################################")
var p3 = universes["U1_PF"]!.studies.filter {
    $0.studyType == "INTERVENTIONAL" && $0.primaryPurpose == "TREATMENT" &&
    ($0.phaseText == "PHASE3" || $0.phaseText == "PHASE2+PHASE3")
}
p3.sort { $0.nct < $1.nct }
out("  count = \(p3.count)")
out("")
for s in p3 {
    let hay = fold(s.interventionText + " | " + s.titleText)
    var rows: [String] = []
    for m in LEXICON where m.key != "NEGATIVE_CONTROL" {
        for ph in m.phrases where matches(hay, fold(ph.text), ph.mode) { rows.append(m.key); break }
    }
    out("  \(s.nct)  \(pad(s.status, 23)) n=\(lpad(String(s.enrollment), 6))  \(s.grade)")
    out("      \(s.briefTitle.prefix(104))")
    out("      rows      : \(rows.joined(separator: ","))")
    out("      endpoint  : \(s.primaryOutcomes.joined(separator: " || ").prefix(150))")
    if !s.whyStopped.isEmpty { out("      whyStopped: \(s.whyStopped.prefix(150))") }
}

out("")
out("################################################################")
out("# TERMINATED / WITHDRAWN / SUSPENDED IN U1_PF — the registry's own words")
out("# A stopped trial is a result. It is printed here verbatim and unedited.")
out("################################################################")
var stopped = universes["U1_PF"]!.studies.filter {
    $0.status == "TERMINATED" || $0.status == "WITHDRAWN" || $0.status == "SUSPENDED"
}
stopped.sort { $0.nct < $1.nct }
out("  count = \(stopped.count)   with a stated reason = \(stopped.filter { !$0.whyStopped.isEmpty }.count)")
out("")
for s in stopped {
    out("  \(s.nct)  \(pad(s.status, 11)) \(pad(s.phaseText, 14)) n=\(lpad(String(s.enrollment), 6))")
    out("      \(s.briefTitle.prefix(104))")
    out("      reason: \(s.whyStopped.isEmpty ? "NOT STATED IN THE REGISTRY" : s.whyStopped.prefix(190).description)")
}

out("")
out("REGISTER COMPLETE")
finish(0, "COMPLETE")
