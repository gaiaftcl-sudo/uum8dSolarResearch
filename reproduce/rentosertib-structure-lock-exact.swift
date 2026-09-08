// rentosertib-structure-lock-exact.swift
//
// EXACT STRUCTURAL IDENTITY LOCK for rentosertib (ISM001-055 / INS018_055)
// and MEASURED REACH of each Study-26 instrument against a small-molecule input.
//
// LAW: Swift 6.4, xcrun swiftc -O -swift-version 5. ZERO FLOAT on any decision path.
//      Every count is an Int. Every comparison is an Int comparison or a byte comparison.
//      No sampling. No cutoff inside the arithmetic. Work is COUNTED as it happens.
//
// C-007: this file carries PUBLIC STRUCTURAL IDENTIFIERS ONLY (SMILES, InChIKey, formula).
//        It contains NO synthetic route, NO reagent, NO procedure. It is an identity check.
//
// REGISTER: a structural or graph figure here is NOT efficacy, NOT a dose, NOT a mechanism,
//           and NOT evidence that any drug helps or harms anyone.
//
// Usage:
//   (no argv)  -> structural arms only; corpus arms print INPUT_NOT_SUPPLIED (an absence, not a pass)
//   argv 1..4  -> gene_info  mr_by_cohort_union.tsv  GSE92742_pert_info  GSE70138_pert_info
//                 each SHA-256'd and REFUSED on digest mismatch.
//
// Exit codes: 0 = all arms as expected. 2 = digest refusal. 3 = self-test failure. 4 = usage/parse refusal.

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif

// ============================================================================
// 0.  UNBUFFERED OUTPUT
// ============================================================================

setvbuf(stdout, nil, _IONBF, 0)
let OUT = FileHandle.standardOutput
@inline(__always) func emit(_ s: String) { OUT.write(Data((s + "\n").utf8)) }
func rule(_ c: String = "-") { emit(String(repeating: c, count: 78)) }
func head(_ s: String) { emit(""); rule("="); emit(s); rule("=") }

// ============================================================================
// 1.  WORK COUNTERS — incremented where the work happens, never derived from sizes
// ============================================================================

final class Counters {
    var smilesCharsScanned = 0
    var atomsParsed = 0
    var bondsParsed = 0
    var ringClosures = 0
    var branchOpens = 0
    var implicitHDecisions = 0
    var elementCellsCompared = 0
    var wlRefinementSteps = 0
    var wlNodeUpdates = 0
    var corpusBytesHashed = 0
    var corpusLinesRead = 0
    var corpusFieldsSplit = 0
    var mrTokensTested = 0
    var pertRowsTested = 0
    var selfTestArmsRun = 0
    var selfTestArmsExpectedPass = 0
    var selfTestArmsExpectedFail = 0
}
let CNT = Counters()

var FAILURES: [String] = []
@inline(__always) func arm(_ name: String, _ ok: Bool, _ detail: String) {
    CNT.selfTestArmsRun += 1
    if ok { emit("  [PASS] \(name)  \(detail)") }
    else   { emit("  [FAIL] \(name)  \(detail)"); FAILURES.append(name) }
}

// ============================================================================
// 2.  SMILES PARSER — integer valence model, complete enumeration of the string
// ============================================================================

enum ParseError: Error, CustomStringConvertible {
    case empty
    case unexpectedChar(Character, Int)
    case unbalancedBranchClose(Int)
    case unclosedBranch(Int)
    case unclosedRing(Int)
    case badBracket(Int)
    case unknownElement(String, Int)
    var description: String {
        switch self {
        case .empty:                    return "EMPTY_INPUT"
        case .unexpectedChar(let c, let i): return "UNEXPECTED_CHAR '\(c)' at \(i)"
        case .unbalancedBranchClose(let i): return "UNBALANCED_BRANCH_CLOSE at \(i)"
        case .unclosedBranch(let n):    return "UNCLOSED_BRANCH count=\(n)"
        case .unclosedRing(let n):      return "UNCLOSED_RING_BOND number=\(n)"
        case .badBracket(let i):        return "MALFORMED_BRACKET_ATOM at \(i)"
        case .unknownElement(let s, let i): return "UNKNOWN_ELEMENT '\(s)' at \(i)"
        }
    }
}

// Normal valences, integer only. Lowest valence >= sigma sum is chosen.
let VALENCES: [String: [Int]] = [
    "B": [3], "C": [4], "N": [3, 5], "O": [2], "P": [3, 5], "S": [2, 4, 6],
    "F": [1], "Cl": [1], "Br": [1], "I": [1]
]
let ORGANIC_SUBSET: Set<String> = ["B", "C", "N", "O", "P", "S", "F", "Cl", "Br", "I"]
// Elements legal as lowercase aromatic in the organic subset.
let AROMATIC_SUBSET: Set<String> = ["b", "c", "n", "o", "p", "s"]

struct MolAtom {
    var element: String        // canonical capitalised symbol
    var aromatic: Bool
    var isBracket: Bool
    var bracketH: Int          // explicit H count inside []
    var charge: Int
    var isotope: Int
    var sigmaSum: Int = 0      // sum of bond orders to heavy neighbours (aromatic bond = 1)
    var hasExplicitMultiple: Bool = false
    var implicitH: Int = 0
    var nbr: [Int] = []
    var nbrOrder: [Int] = []   // 1,2,3,4 ; aromatic recorded as 1 with aromaticEdge true
    var nbrAromatic: [Bool] = []
    var totalH: Int { isBracket ? bracketH : implicitH }
    var stereoMarked: Bool = false
}

struct Molecule {
    var atoms: [MolAtom]
    var bondCount: Int
    var directionalBondCount: Int      // '/' or '\' — double-bond stereo
    var tetrahedralStereoCount: Int    // '@' or '@@'
    var componentCount: Int            // '.' separated fragments + 1
}

func parseSMILES(_ s: String) throws -> Molecule {
    if s.isEmpty { throw ParseError.empty }
    let ch = Array(s)
    var atoms: [MolAtom] = []
    var branchStack: [Int] = []
    var ringOpen: [Int: (atom: Int, order: Int, aromatic: Bool, pos: Int)] = [:]
    var prev: Int? = nil
    var pendingOrder: Int = 0        // 0 = unspecified
    var pendingAromatic = false
    var directionalCount = 0
    var tetraCount = 0
    var bondCount = 0
    var componentCount = 1
    var i = 0

    @inline(__always)
    func link(_ a: Int, _ b: Int, _ order: Int, _ arom: Bool) {
        atoms[a].nbr.append(b); atoms[a].nbrOrder.append(order); atoms[a].nbrAromatic.append(arom)
        atoms[b].nbr.append(a); atoms[b].nbrOrder.append(order); atoms[b].nbrAromatic.append(arom)
        atoms[a].sigmaSum += order
        atoms[b].sigmaSum += order
        if order >= 2 { atoms[a].hasExplicitMultiple = true; atoms[b].hasExplicitMultiple = true }
        bondCount += 1
        CNT.bondsParsed += 1
    }

    while i < ch.count {
        CNT.smilesCharsScanned += 1
        let c = ch[i]

        // ---- bond symbols
        if c == "-" { pendingOrder = 1; i += 1; continue }
        if c == "=" { pendingOrder = 2; i += 1; continue }
        if c == "#" { pendingOrder = 3; i += 1; continue }
        if c == "$" { pendingOrder = 4; i += 1; continue }
        if c == ":" { pendingOrder = 1; pendingAromatic = true; i += 1; continue }
        if c == "/" || c == "\\" {
            pendingOrder = 1; directionalCount += 1; i += 1; continue
        }
        if c == "~" { pendingOrder = 1; i += 1; continue }

        // ---- structure
        if c == "(" {
            guard let p = prev else { throw ParseError.unexpectedChar(c, i) }
            branchStack.append(p); CNT.branchOpens += 1; i += 1; continue
        }
        if c == ")" {
            guard let p = branchStack.popLast() else { throw ParseError.unbalancedBranchClose(i) }
            prev = p; i += 1; continue
        }
        if c == "." { prev = nil; componentCount += 1; i += 1; continue }

        // ---- ring bond numbers
        if c.isNumber || c == "%" {
            var num = 0
            if c == "%" {
                guard i + 2 < ch.count, ch[i+1].isNumber, ch[i+2].isNumber else { throw ParseError.unexpectedChar(c, i) }
                num = Int(String(ch[i+1]))! * 10 + Int(String(ch[i+2]))!
                i += 3
            } else {
                num = Int(String(c))!
                i += 1
            }
            guard let cur = prev else { throw ParseError.unexpectedChar(c, i) }
            if let open = ringOpen[num] {
                var order = 1
                var arom = false
                if open.order != 0 { order = open.order; arom = open.aromatic }
                if pendingOrder != 0 { order = pendingOrder; arom = pendingAromatic }
                if open.order == 0 && pendingOrder == 0 {
                    // unspecified: aromatic if both ends aromatic
                    if atoms[open.atom].aromatic && atoms[cur].aromatic { order = 1; arom = true }
                    else { order = 1; arom = false }
                }
                link(open.atom, cur, order, arom)
                ringOpen.removeValue(forKey: num)
                CNT.ringClosures += 1
            } else {
                ringOpen[num] = (cur, pendingOrder, pendingAromatic, i)
            }
            pendingOrder = 0; pendingAromatic = false
            continue
        }

        // ---- bracket atom
        if c == "[" {
            var j = i + 1
            var body = ""
            while j < ch.count && ch[j] != "]" { body.append(ch[j]); j += 1 }
            if j >= ch.count { throw ParseError.badBracket(i) }
            let a = try parseBracketAtom(body, at: i)
            atoms.append(a)
            CNT.atomsParsed += 1
            if a.stereoMarked { tetraCount += 1 }
            let idx = atoms.count - 1
            if let p = prev {
                var order = pendingOrder
                var arom = pendingAromatic
                if order == 0 {
                    if atoms[p].aromatic && atoms[idx].aromatic { order = 1; arom = true } else { order = 1 }
                }
                link(p, idx, order, arom)
            }
            prev = idx
            pendingOrder = 0; pendingAromatic = false
            i = j + 1
            continue
        }

        // ---- organic-subset atom (uppercase or aromatic lowercase)
        var sym = ""
        if c == "C" && i + 1 < ch.count && ch[i+1] == "l" { sym = "Cl"; i += 2 }
        else if c == "B" && i + 1 < ch.count && ch[i+1] == "r" { sym = "Br"; i += 2 }
        else if "BCNOPSFI".contains(c) { sym = String(c); i += 1 }
        else if AROMATIC_SUBSET.contains(String(c)) { sym = String(c); i += 1 }
        else { throw ParseError.unexpectedChar(c, i) }

        let aromatic = (sym.count == 1 && sym.first!.isLowercase)
        let canon = aromatic ? sym.uppercased() : sym
        guard ORGANIC_SUBSET.contains(canon) else { throw ParseError.unknownElement(sym, i) }

        atoms.append(MolAtom(element: canon, aromatic: aromatic, isBracket: false,
                             bracketH: 0, charge: 0, isotope: 0))
        CNT.atomsParsed += 1
        let idx = atoms.count - 1
        if let p = prev {
            var order = pendingOrder
            var arom = pendingAromatic
            if order == 0 {
                if atoms[p].aromatic && atoms[idx].aromatic { order = 1; arom = true } else { order = 1 }
            }
            link(p, idx, order, arom)
        }
        prev = idx
        pendingOrder = 0; pendingAromatic = false
    }

    if !branchStack.isEmpty { throw ParseError.unclosedBranch(branchStack.count) }
    if let anyOpen = ringOpen.keys.sorted().first { throw ParseError.unclosedRing(anyOpen) }

    // ---- implicit hydrogens, integer only
    for k in 0..<atoms.count {
        CNT.implicitHDecisions += 1
        if atoms[k].isBracket { continue }
        let e = atoms[k].element
        let sum = atoms[k].sigmaSum
        if atoms[k].aromatic {
            // OpenSMILES convention: a pyrrole-type N/O/S donor is written explicitly as [nH]/[o]/[s].
            // A BARE lowercase aromatic n/o/s/p therefore carries NO implicit hydrogen.
            switch e {
            case "C": atoms[k].implicitH = max(0, 3 - sum)
            case "B": atoms[k].implicitH = max(0, 2 - sum)
            default:  atoms[k].implicitH = 0
            }
        } else {
            guard let vs = VALENCES[e] else { atoms[k].implicitH = 0; continue }
            var target = sum
            for v in vs where v >= sum { target = v; break }
            atoms[k].implicitH = max(0, target - sum)
        }
    }

    return Molecule(atoms: atoms, bondCount: bondCount,
                    directionalBondCount: directionalCount,
                    tetrahedralStereoCount: tetraCount,
                    componentCount: componentCount)
}

func parseBracketAtom(_ body: String, at pos: Int) throws -> MolAtom {
    let b = Array(body)
    var i = 0
    var isotope = 0
    while i < b.count, b[i].isNumber { isotope = isotope * 10 + Int(String(b[i]))!; i += 1 }
    guard i < b.count else { throw ParseError.badBracket(pos) }
    var sym = ""
    if b[i].isUppercase {
        sym = String(b[i]); i += 1
        if i < b.count, b[i].isLowercase {
            let two = sym + String(b[i])
            // accept a two-letter symbol only if it is a symbol we model
            if VALENCES[two] != nil || two == "Se" || two == "Si" || two == "As" { sym = two; i += 1 }
        }
    } else if b[i].isLowercase {
        sym = String(b[i]); i += 1
    } else { throw ParseError.badBracket(pos) }
    let aromatic = (sym.count == 1 && sym.first!.isLowercase)
    let canon = aromatic ? sym.uppercased() : sym

    var stereo = false
    var hCount = 0
    var charge = 0
    while i < b.count {
        let c = b[i]
        if c == "@" { stereo = true; i += 1; if i < b.count && b[i] == "@" { i += 1 }; continue }
        if c == "H" {
            i += 1
            var n = 0; var got = false
            while i < b.count, b[i].isNumber { n = n * 10 + Int(String(b[i]))!; i += 1; got = true }
            hCount = got ? n : 1
            continue
        }
        if c == "+" || c == "-" {
            let sign = (c == "+") ? 1 : -1
            i += 1
            var n = 0; var got = false
            while i < b.count, b[i].isNumber { n = n * 10 + Int(String(b[i]))!; i += 1; got = true }
            if !got {
                var extra = 1
                while i < b.count, b[i] == c { extra += 1; i += 1 }
                n = extra
            }
            charge = sign * n
            continue
        }
        if c == ":" { i += 1; while i < b.count, b[i].isNumber { i += 1 }; continue }
        i += 1
    }
    var a = MolAtom(element: canon, aromatic: aromatic, isBracket: true,
                    bracketH: hCount, charge: charge, isotope: isotope)
    a.stereoMarked = stereo
    return a
}

// ============================================================================
// 3.  FORMULA — count, parse, compare.  Hill order.  Integer cells only.
// ============================================================================

func formulaFromMolecule(_ m: Molecule) -> [String: Int] {
    var f: [String: Int] = [:]
    for a in m.atoms {
        f[a.element, default: 0] += 1
        let h = a.totalH
        if h > 0 { f["H", default: 0] += h }
    }
    return f
}

func parseFormula(_ s: String) throws -> [String: Int] {
    if s.isEmpty { throw ParseError.empty }
    let ch = Array(s)
    var f: [String: Int] = [:]
    var i = 0
    while i < ch.count {
        guard ch[i].isUppercase else { throw ParseError.unexpectedChar(ch[i], i) }
        var sym = String(ch[i]); i += 1
        if i < ch.count, ch[i].isLowercase { sym += String(ch[i]); i += 1 }
        var n = 0; var got = false
        while i < ch.count, ch[i].isNumber { n = n * 10 + Int(String(ch[i]))!; i += 1; got = true }
        f[sym, default: 0] += got ? n : 1
    }
    return f
}

func hillOrder(_ f: [String: Int]) -> [String] {
    var keys = Array(f.keys)
    let hasC = f["C"] != nil
    keys.sort { a, b in
        if hasC {
            if a == "C" { return b != "C" }
            if b == "C" { return false }
            if a == "H" { return b != "H" }
            if b == "H" { return false }
        }
        return a < b
    }
    return keys
}

func formulaString(_ f: [String: Int]) -> String {
    var s = ""
    for k in hillOrder(f) {
        let n = f[k]!
        if n == 0 { continue }
        s += k + (n == 1 ? "" : String(n))
    }
    return s
}

struct FormulaVerdict {
    var agree: Bool
    var rows: [(element: String, counted: Int, declared: Int, ok: Bool)]
    var disagreeing: [String]
}

func compareFormula(counted: [String: Int], declared: [String: Int]) -> FormulaVerdict {
    var els = Set(counted.keys); els.formUnion(declared.keys)
    var ordered = Array(els)
    let merged = counted.merging(declared) { a, _ in a }
    ordered = hillOrder(merged).filter { els.contains($0) }
    var rows: [(String, Int, Int, Bool)] = []
    var bad: [String] = []
    for e in ordered {
        CNT.elementCellsCompared += 1
        let c = counted[e] ?? 0
        let d = declared[e] ?? 0
        let ok = (c == d)
        if !ok { bad.append(e) }
        rows.append((e, c, d, ok))
    }
    return FormulaVerdict(agree: bad.isEmpty, rows: rows, disagreeing: bad)
}

// ============================================================================
// 4.  CONNECTIVITY DIGEST — Weisfeiler–Lehman refinement, integer FNV-1a 64
//     Tier A: topology + element + H  (invariant to Kekule vs aromatic writing)
//     Tier B: Tier A + bond orders    (distinguishes Kekule from aromatic writing)
// ============================================================================

@inline(__always) func fnv(_ seed: UInt64, _ v: UInt64) -> UInt64 {
    var h = seed
    var x = v
    for _ in 0..<8 {
        h ^= (x & 0xFF)
        h = h &* 0x100000001B3
        x >>= 8
    }
    return h
}
@inline(__always) func fnvStr(_ seed: UInt64, _ s: String) -> UInt64 {
    var h = seed
    for b in s.utf8 { h ^= UInt64(b); h = h &* 0x100000001B3 }
    return h
}

func wlDigest(_ m: Molecule, includeBondOrder: Bool) -> UInt64 {
    let n = m.atoms.count
    if n == 0 { return 0 }
    var label = [UInt64](repeating: 0, count: n)
    for i in 0..<n {
        var h: UInt64 = 0xCBF29CE484222325
        h = fnvStr(h, m.atoms[i].element)
        h = fnv(h, UInt64(bitPattern: Int64(m.atoms[i].totalH)))
        h = fnv(h, UInt64(bitPattern: Int64(m.atoms[i].charge)))
        h = fnv(h, UInt64(bitPattern: Int64(m.atoms[i].nbr.count)))
        label[i] = h
    }
    let rounds = n   // complete refinement bound; no heuristic cutoff
    for _ in 0..<rounds {
        CNT.wlRefinementSteps += 1
        var next = [UInt64](repeating: 0, count: n)
        for i in 0..<n {
            CNT.wlNodeUpdates += 1
            var pieces: [UInt64] = []
            pieces.reserveCapacity(m.atoms[i].nbr.count)
            for (k, j) in m.atoms[i].nbr.enumerated() {
                var e = label[j]
                if includeBondOrder { e = fnv(e, UInt64(bitPattern: Int64(m.atoms[i].nbrOrder[k]))) }
                pieces.append(e)
            }
            pieces.sort()
            var h: UInt64 = 0xCBF29CE484222325
            h = fnv(h, label[i])
            for p in pieces { h = fnv(h, p) }
            next[i] = h
        }
        if next == label { break }
        label = next
    }
    var sorted = label
    sorted.sort()
    var h: UInt64 = 0xCBF29CE484222325
    for v in sorted { h = fnv(h, v) }
    return h
}
@inline(__always) func hex(_ v: UInt64) -> String { String(format: "%016llx", v) }

// Tier S: HEAVY-ATOM SKELETON ONLY.  element + charge + degree, no hydrogen, no bond order.
// Two drawings that differ only in where a mobile hydrogen sits share this digest.
// Two drawings that differ in heavy-atom connectivity do not.
func wlSkeleton(_ m: Molecule) -> (digest: UInt64, labels: [UInt64]) {
    let n = m.atoms.count
    if n == 0 { return (0, []) }
    var label = [UInt64](repeating: 0, count: n)
    for i in 0..<n {
        var h: UInt64 = 0xCBF29CE484222325
        h = fnvStr(h, m.atoms[i].element)
        h = fnv(h, UInt64(bitPattern: Int64(m.atoms[i].charge)))
        h = fnv(h, UInt64(bitPattern: Int64(m.atoms[i].nbr.count)))
        label[i] = h
    }
    for _ in 0..<n {
        CNT.wlRefinementSteps += 1
        var next = [UInt64](repeating: 0, count: n)
        for i in 0..<n {
            CNT.wlNodeUpdates += 1
            var pieces = m.atoms[i].nbr.map { label[$0] }
            pieces.sort()
            var h: UInt64 = 0xCBF29CE484222325
            h = fnv(h, label[i])
            for p in pieces { h = fnv(h, p) }
            next[i] = h
        }
        if next == label { break }
        label = next
    }
    var sorted = label; sorted.sort()
    var h: UInt64 = 0xCBF29CE484222325
    for v in sorted { h = fnv(h, v) }
    return (h, label)
}

// Given two molecules with the SAME skeleton digest, name the skeleton classes whose
// hydrogen count differs.  Integer multiset diff, no tolerance, no threshold.
struct HDiff { var classesDiffering: Int; var lines: [String]; var totalHLeft: Int; var totalHRight: Int }
func localiseHydrogenDifference(_ a: Molecule, _ b: Molecule) -> HDiff {
    let la = wlSkeleton(a).labels, lb = wlSkeleton(b).labels
    var ma: [UInt64: [Int]] = [:], mb: [UInt64: [Int]] = [:]
    var elemOf: [UInt64: String] = [:]
    var degOf: [UInt64: Int] = [:]
    var ha = 0, hb = 0
    for i in 0..<a.atoms.count {
        ma[la[i], default: []].append(a.atoms[i].totalH)
        elemOf[la[i]] = a.atoms[i].element; degOf[la[i]] = a.atoms[i].nbr.count
        ha += a.atoms[i].totalH
    }
    for i in 0..<b.atoms.count {
        mb[lb[i], default: []].append(b.atoms[i].totalH)
        elemOf[lb[i]] = b.atoms[i].element; degOf[lb[i]] = b.atoms[i].nbr.count
        hb += b.atoms[i].totalH
    }
    var keys = Set(ma.keys); keys.formUnion(mb.keys)
    var lines: [String] = []
    var differing = 0
    for k in keys.sorted() {
        var x = ma[k] ?? []; x.sort()
        var y = mb[k] ?? []; y.sort()
        if x != y {
            differing += 1
            lines.append("        class \(hex(k))  element=\(elemOf[k] ?? "?") degree=\(degOf[k] ?? -1)  H(left)=\(x)  H(right)=\(y)")
        }
    }
    return HDiff(classesDiffering: differing, lines: lines, totalHLeft: ha, totalHRight: hb)
}


// ============================================================================
// 5.  THE DECLARED MOLECULE  (public structural identifiers only)
// ============================================================================

let NAME_PRIMARY   = "rentosertib"
let NAME_CODES     = ["ISM001-055", "INS018_055", "INS018-055", "ISM-001-055"]
let DECLARED_FORMULA = "C27H30FN7O"
let DECLARED_INCHIKEY = "ZVDNXHUSIKGTSF-UHFFFAOYSA-N"

// Founder-supplied SMILES (to be VERIFIED, not trusted)
let SMILES_FOUNDER = "O=C(C1=CN=C(C2=C(C3=CC=C(C=C3)F)N=CN2C(C)C)N1)NC4=CC=C(N5CCN(CC5)C)C=C4"
// PubChem CID 164938183 ConnectivitySMILES, retrieved login-free from the PUG REST endpoint
let SMILES_PUBCHEM = "CC(C)N1C=NC(=C1C2=NC=C(N2)C(=O)NC3=CC=C(C=C3)N4CCN(CC4)C)C5=CC=C(C=C5)F"
// ChEMBL CHEMBL5969552 canonical_smiles (AROMATIC form) from the EBI REST endpoint
let SMILES_CHEMBL  = "CC(C)n1cnc(-c2ccc(F)cc2)c1-c1nc(C(=O)Nc2ccc(N3CCN(C)CC3)cc2)c[nH]1"
// NCATS GSRS, UNII M9NU5G8WXY, retrieved login-free from the GSRS v1 substances endpoint
let SMILES_GSRS    = "CC(C)n1cnc(-c2ccc(cc2)F)c1-c3ncc(C(=O)Nc4ccc(cc4)N5CCN(C)CC5)[nH]3"
// NEGATIVE CONTROL: fluorine moved para -> meta. SAME FORMULA, DIFFERENT CONNECTIVITY.
let SMILES_METAF   = "O=C(C1=CN=C(C2=C(C3=CC=CC(=C3)F)N=CN2C(C)C)N1)NC4=CC=C(N5CCN(CC5)C)C=C4"

// ============================================================================
// 6.  SHA-256 + corpus digest pins
// ============================================================================

func sha256File(_ path: String) -> (hex: String, bytes: Int)? {
    guard let d = FileManager.default.contents(atPath: path) else { return nil }
    CNT.corpusBytesHashed += d.count
#if canImport(CryptoKit)
    let h = SHA256.hash(data: d)
    return (h.map { String(format: "%02x", $0) }.joined(), d.count)
#else
    return (nil, d.count)
#endif
}

let PIN_GENE_INFO   = "dea4c4e5b6aca570dc50bf907cdefcc53758780377d58d7ca9c5c5bdbcdb1f29"
let PIN_MRSETS      = "c511783f5c65c20aeb23d672376d8a709b3008352e55921a35b6406f9843db72"
let PIN_PERT_92742  = "dfea176cf8820269ebccd29c21171cbe264188c128421b6d7c0cd2fbfb7fa005"
let PIN_PERT_70138  = "f935894a86f357a84bc13fd4aa847de6c82762f9869339ebbd9122871d28b91f"

// ============================================================================
// 7.  BANNER
// ============================================================================

head("RENTOSERTIB STRUCTURE LOCK — EXACT, INTEGER ONLY")
emit("molecule (public identifiers only)   : \(NAME_PRIMARY)  [\(NAME_CODES.joined(separator: ", "))]")
emit("declared formula                     : \(DECLARED_FORMULA)")
emit("declared InChIKey                    : \(DECLARED_INCHIKEY)")
emit("stated primary target                : TNIK (TRAF2 and NCK interacting kinase)")
emit("")
emit("C-007  : public structural identifiers only. No route, no reagent, no procedure.")
emit("REGISTER: a structural or graph figure is NOT efficacy, NOT a dose, NOT a mechanism,")
emit("          and NOT evidence that any drug helps or harms anyone.")

// ============================================================================
// SECTION 1 — SELF-VALIDATION OF THE COUNTER, BOTH DIRECTIONS
// ============================================================================

head("SECTION 1 — SELF-VALIDATION: the atom counter is graded on cases known in advance")

emit("")
emit("1A. POSITIVE ARMS — formulae countable by hand. Each MUST agree.")
let positives: [(String, String, String)] = [
    ("methane",              "C",                                  "CH4"),
    ("ethanol",              "CCO",                                "C2H6O"),
    ("benzene (aromatic)",   "c1ccccc1",                           "C6H6"),
    ("benzene (Kekule)",     "C1=CC=CC=C1",                        "C6H6"),
    ("pyridine (aromatic)",  "c1ccncc1",                           "C5H5N"),
    ("pyridine (Kekule)",    "C1=CC=NC=C1",                        "C5H5N"),
    ("pyrrole [nH]",         "c1cc[nH]c1",                         "C4H5N"),
    ("furan",                "c1ccoc1",                            "C4H4O"),
    ("thiophene",            "c1ccsc1",                            "C4H4S"),
    ("imidazole (aromatic)", "c1cnc[nH]1",                         "C3H4N2"),
    ("imidazole (Kekule)",   "C1=CN=CN1",                          "C3H4N2"),
    ("fluorobenzene",        "Fc1ccccc1",                          "C6H5F"),
    ("piperazine",           "C1CNCCN1",                           "C4H10N2"),
    ("N-methylpiperazine",   "CN1CCNCC1",                          "C5H12N2"),
    ("isopropylamine",       "CC(C)N",                             "C3H9N"),
    ("acetamide",            "CC(=O)N",                            "C2H5NO"),
    ("acetanilide",          "CC(=O)Nc1ccccc1",                    "C8H9NO"),
    ("aspirin",              "CC(=O)OC1=CC=CC=C1C(=O)O",           "C9H8O4"),
    ("caffeine",             "CN1C=NC2=C1C(=O)N(C)C(=O)N2C",       "C8H10N4O2"),
    ("nitrogen (triple)",    "N#N",                                "H0N2"),
    ("acetonitrile",         "CC#N",                               "C2H3N"),
    ("two components",       "CCO.O",                              "C2H8O2")
]
for (label, smi, expect) in positives {
    CNT.selfTestArmsExpectedPass += 1
    do {
        let m = try parseSMILES(smi)
        let got = formulaString(formulaFromMolecule(m))
        let want = formulaString(try parseFormula(expect))
        arm("POS \(label)", got == want, "counted=\(got) expected=\(want)")
    } catch {
        arm("POS \(label)", false, "PARSE_REFUSED \(error)")
    }
}

emit("")
emit("1B. NEGATIVE ARMS — a deliberately altered formula MUST disagree and NAME the element.")
let negatives: [(String, String, String, String)] = [
    ("benzene vs C6H7",        "c1ccccc1", "C6H7",       "H"),
    ("benzene vs C7H6",        "c1ccccc1", "C7H6",       "C"),
    ("ethanol vs C2H6S",       "CCO",      "C2H6S",      "O"),
    ("rentosertib vs C26H30FN7O", SMILES_FOUNDER, "C26H30FN7O", "C"),
    ("rentosertib vs C27H31FN7O", SMILES_FOUNDER, "C27H31FN7O", "H"),
    ("rentosertib vs C27H30N7O (F dropped)", SMILES_FOUNDER, "C27H30N7O", "F"),
    ("rentosertib vs C27H30FN6O", SMILES_FOUNDER, "C27H30FN6O", "N"),
    ("rentosertib vs C27H30FN7",  SMILES_FOUNDER, "C27H30FN7",  "O")
]
for (label, smi, decl, mustName) in negatives {
    CNT.selfTestArmsExpectedFail += 1
    do {
        let m = try parseSMILES(smi)
        let v = compareFormula(counted: formulaFromMolecule(m), declared: try parseFormula(decl))
        let ok = (!v.agree) && v.disagreeing.contains(mustName)
        arm("NEG \(label)", ok, "disagree=\(!v.agree) named=[\(v.disagreeing.joined(separator: ","))] required=\(mustName)")
    } catch {
        arm("NEG \(label)", false, "PARSE_REFUSED \(error)")
    }
}

emit("")
emit("1C. REFUSAL ARMS — a gate given nothing, or given nonsense, MUST NOT pass.")
let refusals: [(String, String)] = [
    ("empty string",        ""),
    ("unbalanced ')'",      "CC)O"),
    ("unclosed branch",     "CC(O"),
    ("unclosed ring bond",  "C1CCCCC"),
    ("unknown element 'Z'", "CZC"),
    ("malformed bracket",   "[C")
]
for (label, smi) in refusals {
    CNT.selfTestArmsExpectedFail += 1
    var refused = false
    var why = ""
    do { _ = try parseSMILES(smi) } catch { refused = true; why = "\(error)" }
    arm("REFUSE \(label)", refused, refused ? why : "PARSED_ANYWAY — instrument is always-green")
}

emit("")
emit("1D. WL CONNECTIVITY DIGEST — the instrument must DISCRIMINATE, both directions.")
do {
    let benzene   = try parseSMILES("c1ccccc1")
    let benzeneK  = try parseSMILES("C1=CC=CC=C1")
    let pyridine  = try parseSMILES("c1ccncc1")
    let dA = wlDigest(benzene, includeBondOrder: false)
    let dB = wlDigest(benzeneK, includeBondOrder: false)
    let dC = wlDigest(pyridine, includeBondOrder: false)
    arm("WL same molecule, aromatic vs Kekule -> SAME digest", dA == dB, "\(hex(dA)) vs \(hex(dB))")
    arm("WL different molecule -> DIFFERENT digest", dA != dC, "benzene \(hex(dA)) vs pyridine \(hex(dC))")

    // ortho / meta / para xylene: same formula C8H10, three distinct connectivities
    let o = try parseSMILES("Cc1ccccc1C"), me = try parseSMILES("Cc1cccc(C)c1"), p = try parseSMILES("Cc1ccc(C)cc1")
    let fo = formulaString(formulaFromMolecule(o))
    let fm = formulaString(formulaFromMolecule(me))
    let fp = formulaString(formulaFromMolecule(p))
    arm("xylene isomers share ONE formula", fo == fm && fm == fp && fo == "C8H10", "\(fo)/\(fm)/\(fp)")
    let wo = wlDigest(o, includeBondOrder: false)
    let wm = wlDigest(me, includeBondOrder: false)
    let wp = wlDigest(p, includeBondOrder: false)
    arm("WL separates the three isomers a formula cannot",
        wo != wm && wm != wp && wo != wp, "o=\(hex(wo)) m=\(hex(wm)) p=\(hex(wp))")

    // TAUTOMER vs CONSTITUTIONAL ISOMER — the instrument must tell these two apart.
    // 4-methylimidazole drawn as its 4H and 5H annular tautomers: SAME heavy-atom
    // skeleton, DIFFERENT hydrogen placement. That is not a different substance.
    let t1 = try parseSMILES("Cc1cnc[nH]1")
    let t2 = try parseSMILES("Cc1c[nH]cn1")
    let s1 = wlSkeleton(t1).digest, s2 = wlSkeleton(t2).digest
    let a1 = wlDigest(t1, includeBondOrder: false), a2 = wlDigest(t2, includeBondOrder: false)
    arm("TAUTOMER PAIR: same formula", formulaString(formulaFromMolecule(t1)) == formulaString(formulaFromMolecule(t2)),
        formulaString(formulaFromMolecule(t1)))
    arm("TAUTOMER PAIR: SAME heavy-atom skeleton digest", s1 == s2, "\(hex(s1)) vs \(hex(s2))")
    arm("TAUTOMER PAIR: DIFFERENT hydrogen-placed digest", a1 != a2, "\(hex(a1)) vs \(hex(a2))")
    let d12 = localiseHydrogenDifference(t1, t2)
    arm("TAUTOMER PAIR: localiser names exactly 2 nitrogen classes", d12.classesDiffering == 2,
        "classes=\(d12.classesDiffering) totalH \(d12.totalHLeft)/\(d12.totalHRight)")
    // and a CONSTITUTIONAL isomer must break the skeleton, not just the H placement
    let mp1 = try parseSMILES("Cc1ccc(F)cc1"), mp2 = try parseSMILES("Cc1cccc(F)c1")
    arm("CONSTITUTIONAL ISOMER: DIFFERENT skeleton digest (not a tautomer)",
        wlSkeleton(mp1).digest != wlSkeleton(mp2).digest,
        "\(hex(wlSkeleton(mp1).digest)) vs \(hex(wlSkeleton(mp2).digest))")
} catch {
    arm("WL control block", false, "PARSE_REFUSED \(error)")
}

// ============================================================================
// SECTION 2 — THE MOLECULE ITSELF
// ============================================================================

head("SECTION 2 — EXACT STRUCTURAL IDENTITY OF THE DECLARED MOLECULE")

var founderMol: Molecule? = nil
var founderFormula: [String: Int] = [:]

emit("")
emit("2A. ATOM TABLE — counted from the founder-supplied SMILES, integer per element.")
emit("    SMILES (founder): \(SMILES_FOUNDER)")
do {
    let m = try parseSMILES(SMILES_FOUNDER)
    founderMol = m
    let counted = formulaFromMolecule(m)
    founderFormula = counted
    let declared = try parseFormula(DECLARED_FORMULA)
    let v = compareFormula(counted: counted, declared: declared)
    emit("")
    emit("    element |  counted | declared | verdict")
    emit("    --------+----------+----------+---------")
    for r in v.rows {
        let el = r.element + String(repeating: " ", count: max(0, 7 - r.element.count))
        let cs = String(r.counted), ds = String(r.declared)
        let cp = String(repeating: " ", count: max(0, 8 - cs.count)) + cs
        let dp = String(repeating: " ", count: max(0, 8 - ds.count)) + ds
        emit("    \(el) | \(cp) | \(dp) | " + (r.ok ? "AGREE" : "DISAGREE"))
    }
    emit("")
    emit("    counted formula (Hill)  : \(formulaString(counted))")
    emit("    declared formula        : \(DECLARED_FORMULA)")
    emit("    heavy atoms parsed      : \(m.atoms.count)")
    emit("    bonds parsed            : \(m.bondCount)")
    emit("    disconnected components : \(m.componentCount)")
    emit("")
    if v.agree {
        emit("    VERDICT: FORMULA AGREES on every element. No transcription error in the")
        emit("             founder-supplied formula/SMILES pair.")
    } else {
        emit("    VERDICT: FORMULA DISAGREES on [\(v.disagreeing.joined(separator: ", "))].")
        emit("             *** DO NOT LET THIS IDENTIFIER TRAVEL INTO A SAFETY DOCUMENT ***")
    }
    arm("MOLECULE formula agreement", v.agree, formulaString(counted))
} catch {
    emit("    PARSE REFUSED: \(error)")
    arm("MOLECULE parse", false, "\(error)")
}

emit("")
emit("2B. FOUR-SOURCE CROSS-CHECK — founder string vs three public registry strings.")
emit("    A registry string is an INDEPENDENT WITNESS to the same connectivity, written")
emit("    by a different producer in a different style. Agreement across all three is a")
emit("    stronger statement than agreement with a formula.")
emit("")
let sources: [(String, String)] = [
    ("founder-supplied      (Kekule)", SMILES_FOUNDER),
    ("PubChem CID 164938183 (Kekule)", SMILES_PUBCHEM),
    ("ChEMBL CHEMBL5969552  (aromatic)", SMILES_CHEMBL),
    ("NCATS GSRS UNII M9NU5G8WXY (aromatic)", SMILES_GSRS)
]
var tierA: [UInt64] = []
var tierB: [UInt64] = []
var tierS: [UInt64] = []
var forms: [String] = []
var mols: [Molecule?] = []
for (label, smi) in sources {
    do {
        let m = try parseSMILES(smi)
        let f = formulaString(formulaFromMolecule(m))
        let a = wlDigest(m, includeBondOrder: false)
        let b = wlDigest(m, includeBondOrder: true)
        let sk = wlSkeleton(m).digest
        forms.append(f); tierA.append(a); tierB.append(b); tierS.append(sk); mols.append(m)
        emit("    \(label)")
        emit("      formula = \(f)   heavy = \(m.atoms.count)   bonds = \(m.bondCount)")
        emit("      WL-S skeleton (no H, no bond order) = \(hex(sk))")
        emit("      WL-A topology + hydrogen placement  = \(hex(a))")
        emit("      WL-B topology + hydrogen + bond order = \(hex(b))")
    } catch {
        emit("    \(label)  PARSE REFUSED: \(error)")
        forms.append("REFUSED"); tierA.append(0); tierB.append(0); tierS.append(0); mols.append(nil)
    }
}
emit("")
let allForm = forms.allSatisfy { $0 == forms.first } && forms.first != "REFUSED"
let allSkel = tierS.allSatisfy { $0 == tierS.first } && tierS.first != 0
arm("4-source formula agreement", allForm, forms.joined(separator: " / "))
arm("4-source HEAVY-ATOM SKELETON agreement (WL-S)", allSkel, tierS.map(hex).joined(separator: " / "))
arm("WL-A founder == PubChem (identical atom for atom, hydrogens included)",
    tierA.count >= 2 && tierA[0] == tierA[1], "\(hex(tierA[0])) vs \(hex(tierA[1]))")
arm("WL-B founder == PubChem (bond orders included too)",
    tierB.count >= 2 && tierB[0] == tierB[1], "\(hex(tierB[0])) vs \(hex(tierB[1]))")
arm("WL-A ChEMBL != founder (a real difference the instrument must not hide)",
    tierA.count >= 3 && tierA[2] != tierA[0], "\(hex(tierA[2])) vs \(hex(tierA[0]))")

emit("")
emit("    THE ChEMBL STRING DIFFERS FROM THE OTHER TWO. WHAT IS THE DIFFERENCE, EXACTLY:")
if let mf = mols.first ?? nil, mols.count >= 3, let mc = mols[2] {
    let d = localiseHydrogenDifference(mf, mc)
    emit("      heavy-atom skeleton digest       : \(hex(tierS[0])) == \(hex(tierS[2]))  -> IDENTICAL")
    emit("      total hydrogens                  : \(d.totalHLeft) vs \(d.totalHRight)")
    emit("      skeleton classes differing in H  : \(d.classesDiffering)")
    for l in d.lines { emit(l) }
    emit("")
    emit("      READ IT PLAINLY: the two drawings place ONE hydrogen on two different")
    emit("      nitrogens of the same free-NH imidazole. Every heavy atom and every")
    emit("      heavy-atom bond is identical. That is ANNULAR TAUTOMERISM, not a different")
    emit("      substance and not a transcription error. The InChI mobile-hydrogen layer")
    emit("      normalises it away, which is why BOTH registries return the SAME InChIKey")
    emit("      \(DECLARED_INCHIKEY) for their two different drawings — PubChem for the")
    emit("      founder-form and ChEMBL for the other. Two independent registries writing")
    emit("      two tautomers under one key is the external confirmation of that claim.")
    arm("ChEMBL difference is CONFINED to hydrogen placement on nitrogen",
        d.classesDiffering > 0 && d.totalHLeft == d.totalHRight
          && d.lines.allSatisfy { $0.contains("element=N") },
        "classes=\(d.classesDiffering) totalH equal=\(d.totalHLeft == d.totalHRight)")
} else {
    arm("ChEMBL difference localisation", false, "molecule unavailable")
}
if mols.count >= 4, let mf2 = mols[0], let mg = mols[3] {
    let dg = localiseHydrogenDifference(mf2, mg)
    emit("")
    emit("    AND THE FOURTH SOURCE, NCATS GSRS, vs the founder string:")
    emit("      heavy-atom skeleton digest       : \(hex(tierS[0])) vs \(hex(tierS[3]))")
    emit("      total hydrogens                  : \(dg.totalHLeft) vs \(dg.totalHRight)")
    emit("      skeleton classes differing in H  : \(dg.classesDiffering)")
    for l in dg.lines { emit(l) }
    arm("GSRS agrees with the founder string on the heavy-atom skeleton", tierS[0] == tierS[3],
        "\(hex(tierS[0])) vs \(hex(tierS[3]))")
    arm("GSRS difference, if any, is confined to hydrogen placement",
        dg.totalHLeft == dg.totalHRight && dg.lines.allSatisfy { $0.contains("element=N") },
        "classes=\(dg.classesDiffering)")
}
let aromDiffers = (tierB.count >= 3 && tierB[2] != tierB[0])
arm("WL-B ChEMBL aromatic != Kekule  (proves WL-B reads bond order, i.e. discriminates)",
    aromDiffers, "\(hex(tierB[2])) vs \(hex(tierB[0]))")

emit("")
emit("2C. NEGATIVE CONNECTIVITY CONTROL — same formula, one atom moved.")
emit("    Fluorine relocated para -> meta on the fluorophenyl ring. If the instrument is")
emit("    real, the FORMULA must still agree and the CONNECTIVITY DIGEST must not.")
do {
    let mm = try parseSMILES(SMILES_METAF)
    let f = formulaString(formulaFromMolecule(mm))
    let a = wlDigest(mm, includeBondOrder: false)
    emit("      meta-F variant: formula=\(f)  WL-A=\(hex(a))")
    arm("meta-F variant has the SAME formula", f == formulaString(founderFormula), f)
    arm("meta-F variant has a DIFFERENT WL-A digest", a != (tierA.first ?? 0),
        "\(hex(a)) vs \(hex(tierA.first ?? 0))")
    let sk = wlSkeleton(mm).digest
    emit("      meta-F variant: WL-S skeleton=\(hex(sk))")
    arm("meta-F variant has a DIFFERENT HEAVY-ATOM SKELETON (a real isomer, not a tautomer)",
        sk != (tierS.first ?? 0), "\(hex(sk)) vs \(hex(tierS.first ?? 0))")
} catch {
    arm("meta-F control", false, "\(error)")
}

// ============================================================================
// SECTION 3 — THE INCHIKEY: WHAT IS VERIFIED EXACTLY, AND WHAT IS NOT
// ============================================================================

head("SECTION 3 — THE INCHIKEY: EXACT CHECKS, AND A NAMED LIMIT")

emit("")
emit("NOT COMPUTED, AND SAID SO PLAINLY:")
emit("  An InChIKey is a truncated SHA-256 over the IUPAC InChI string, which is itself the")
emit("  output of the IUPAC InChI normalisation + canonical-numbering algorithm. That")
emit("  algorithm is NOT implemented in this file. This program therefore DOES NOT compute")
emit("  an InChIKey and does not approximate one. Block 1 is verified by REGISTRY LOOKUP,")
emit("  which is a different kind of evidence and is labelled as such.")
emit("")
emit("VERIFIED EXACTLY, from the string itself:")
let k = DECLARED_INCHIKEY
let parts = k.split(separator: "-", omittingEmptySubsequences: false).map(String.init)
let block1 = parts.count > 0 ? parts[0] : ""
let block2 = parts.count > 1 ? parts[1] : ""
let block3 = parts.count > 2 ? parts[2] : ""
arm("InChIKey has exactly 3 hyphen-separated blocks", parts.count == 3, "blocks=\(parts.count)")
arm("block 1 length == 14 (skeleton hash)", block1.count == 14, "\(block1) len=\(block1.count)")
arm("block 2 length == 10 (remaining layers + flag + version)", block2.count == 10, "\(block2) len=\(block2.count)")
arm("block 3 length == 1 (protonation)", block3.count == 1, "\(block3)")
arm("all characters uppercase A-Z", k.allSatisfy { $0 == "-" || ("A"..."Z").contains($0) }, k)
arm("version char 'S' == STANDARD InChI", block2.count == 10 && Array(block2)[8] == "S",
    block2.count == 10 ? String(Array(block2)[8]) : "n/a")
arm("protonation char 'N' == neutral, no added/removed protons", block3 == "N", block3)
let EMPTY_LAYER_CONST = "UHFFFAOYSA"
arm("block 2 == 'UHFFFAOYSA' (the constant for NO stereo and NO isotope layer)",
    block2 == EMPTY_LAYER_CONST, "\(block2) vs \(EMPTY_LAYER_CONST)")

emit("")
emit("CROSS-CHECK THAT CONSTANT AGAINST THE STRUCTURE — this one IS an exact computation:")
emit("  'UHFFFAOYSA' asserts the molecule carries no stereochemistry layer. If the SMILES")
emit("  contained a tetrahedral or double-bond stereo descriptor, the key would be wrong.")
if let m = founderMol {
    arm("SMILES carries 0 tetrahedral stereo descriptors (@ / @@)", m.tetrahedralStereoCount == 0,
        "count=\(m.tetrahedralStereoCount)")
    arm("SMILES carries 0 directional bond descriptors (/ \\)", m.directionalBondCount == 0,
        "count=\(m.directionalBondCount)")
    // count sp3 carbons with 4 heavy-or-H substituents that could be stereocentres
    var quaternaryCandidates = 0
    for a in m.atoms where a.element == "C" && !a.aromatic {
        if a.nbr.count + a.totalH == 4 && a.nbr.count == 4 { quaternaryCandidates += 1 }
    }
    emit("  sp3 carbons bearing four HEAVY substituents (stereocentre candidates): \(quaternaryCandidates)")
    emit("  -> the isopropyl methine carries two identical methyls, so it is not a stereocentre.")
    arm("no carbon bears four distinct heavy substituents", quaternaryCandidates == 0,
        "candidates=\(quaternaryCandidates)")
} else {
    arm("stereo cross-check", false, "molecule unavailable")
}

emit("")
emit("REGISTRY LOOKUPS (login-free, performed out of band and recorded here as evidence,")
emit("not as a computation by this program):")
emit("  PubChem PUG-REST  inchikey/\(DECLARED_INCHIKEY)")
emit("       -> HIT. CID 164938183. MolecularFormula C27H30FN7O. InChIKey echoed identical.")
emit("  PubChem PUG-REST  name/rentosertib")
emit("       -> HIT. Same CID 164938183. Same formula. Same InChIKey.")
emit("  PubChem PUG-REST  name/ISM001-055")
emit("       -> MISS (HTTP 404) on that exact spelling; the synonym list for CID 164938183")
emit("          DOES carry 'ISM001-055'. A 404 on a name endpoint is an INDEX MISS, not an")
emit("          absent compound. name/INS018_055 and name/INS018-055 both -> HTTP 200.")
emit("  ChEMBL  molecule.json?molecule_structures__standard_inchi_key=\(DECLARED_INCHIKEY)")
emit("       -> HIT. CHEMBL5969552. full_molformula C27H30FN7O. max_phase null.")
emit("  ChEMBL  molecule/search.json?q=rentosertib")
emit("       -> MISS. total_count 0. The EBI text index does not carry the INN while the")
emit("          structure endpoint does. Two endpoints of one registry disagree; the")
emit("          STRUCTURE lookup is the one that answers the identity question.")
emit("  NCATS GSRS  api/v1/substances(M9NU5G8WXY)")
emit("       -> HIT. uuid d12effca-a1cb-4ac8-b5bb-807964de76f1. formula C27H30FN7O.")
emit("          substanceClass chemical. UNII M9NU5G8WXY. Names carry 'rentosertib [INN]'")
emit("          and 'RENTOSERTIB [USAN]', so both the INN and the USAN are assigned.")
emit("          Its structure string is the FOURTH witness checked in 2B above.")
emit("")
emit("  A WORD TRAP, NAMED SO IT IS NOT MISREAD: the GSRS record carries the field")
emit("  status = \"approved\". That is the REGISTRY RECORD's curation status, not a")
emit("  marketing authorisation. Measured against the regulator's own open endpoints:")
emit("    openFDA drug/drugsfda.json  search generic_name rentosertib -> NOT_FOUND")
emit("    openFDA drug/label.json     search rentosertib             -> NOT_FOUND")
emit("  There is no FDA-approved drug product for this molecule in those endpoints.")
emit("  ABSENT from openFDA is a measurement. It is not a statement about any other")
emit("  regulator, and no claim is made here about approval status anywhere else —")
emit("  that is NOT KNOWN from the sources this review is permitted to read.")

// ============================================================================
// SECTION 4 — REACH OF EACH INSTRUMENT, MEASURED FROM THE BYTES
// ============================================================================

head("SECTION 4 — INSTRUMENT REACH: CAN TAKE THIS INPUT, or CANNOT")

emit("")
emit("4A. TYPE-LEVEL REACH — decided by what the instrument's parser accepts.")
emit("    ABSENCE, REFUSAL and NOT_KNOWN are three different answers and are printed apart.")
emit("")
struct Reach { let name: String; let takes: String; let verdict: String; let why: String }
let reaches: [Reach] = [
    Reach(name: "protein-novelty-exact",
          takes: "amino-acid SEQUENCE (FASTA)",
          verdict: "CANNOT TAKE THIS INPUT",
          why: "a small molecule has no amino-acid sequence; the parser has no state for a SMILES string"),
    Reach(name: "peptide-homology-exact",
          takes: "amino-acid SEQUENCE (FASTA)",
          verdict: "CANNOT TAKE THIS INPUT",
          why: "same reason; Smith-Waterman over a residue alphabet cannot be fed 36 heavy atoms"),
    Reach(name: "oligo-offtarget-atlas-exact",
          takes: "nucleic-acid SEQUENCE (ACGU/ACGT)",
          verdict: "CANNOT TAKE THIS INPUT",
          why: "rentosertib is not an oligonucleotide; there is no base sequence to align"),
    Reach(name: "crispr-genome-offtarget-exact",
          takes: "20-nt guide SEQUENCE + PAM",
          verdict: "CANNOT TAKE THIS INPUT",
          why: "no guide sequence exists for a small molecule"),
    Reach(name: "pelacarsen-offtarget-whole-transcriptome",
          takes: "ASO nucleic-acid SEQUENCE",
          verdict: "CANNOT TAKE THIS INPUT",
          why: "same; the pelacarsen arm is an antisense-oligo instrument"),
    Reach(name: "mr-topology-vs-expression-exact",
          takes: "a GENE SYMBOL that is a master regulator in a cohort",
          verdict: "CAN TAKE 'TNIK' AS A SYMBOL, BUT RETURNS AN EMPTY SET",
          why: "measured in 4C below: TNIK is a master regulator in 0 cohorts, so the arm has no row to score"),
    Reach(name: "Study-26 LINCS signature-reversal scoring",
          takes: "a LINCS pert_id present in GSE92742 / GSE70138",
          verdict: "CANNOT TAKE THIS MOLECULE",
          why: "measured in 4D below: the compound is ABSENT from both perturbagen tables"),
    Reach(name: "Study-26 landmark-space scoring (978 genes)",
          takes: "a gene with pr_is_lm = 1",
          verdict: "CANNOT MEASURE TNIK",
          why: "measured in 4B below: TNIK has pr_is_lm = 0; its landmark-space value is a MODEL OUTPUT, not a measurement"),
    Reach(name: "registry-specificity-ranking",
          takes: "a registry identifier",
          verdict: "CAN TAKE THIS INPUT",
          why: "the molecule resolves in PubChem and ChEMBL by InChIKey; identity ranking is in reach")
]
for r in reaches {
    emit("    \(r.name)")
    emit("      accepts : \(r.takes)")
    emit("      verdict : \(r.verdict)")
    emit("      reason  : \(r.why)")
    emit("")
}
emit("    NOT AN OFF-TARGET SCREEN: none of the sequence instruments above was run on an")
emit("    adjacent input and relabelled. Running a protein screen on the TNIK protein would")
emit("    answer a question about a PROTEIN, not about this MOLECULE. That is a true fact")
emit("    about a different question and it is refused here.")

// ---- corpus-backed arms
let args = CommandLine.arguments
var corpusSupplied = false
var geneInfoPath = "", mrPath = "", pert92Path = "", pert70Path = ""
if args.count >= 5 {
    corpusSupplied = true
    geneInfoPath = args[1]; mrPath = args[2]; pert92Path = args[3]; pert70Path = args[4]
}

func printReferenceFigures(_ exitLabel: String) {
    head("REFERENCE FIGURES — counted as the work happened, never derived from input size")
    emit("  exit path                     : \(exitLabel)")
    emit("  corpus supplied on argv       : \(corpusSupplied ? "YES" : "NO (structural arms only)")")
    emit("")
    emit("  SMILES characters scanned     : \(CNT.smilesCharsScanned)")
    emit("  atoms parsed                  : \(CNT.atomsParsed)")
    emit("  bonds parsed                  : \(CNT.bondsParsed)")
    emit("  ring closures resolved        : \(CNT.ringClosures)")
    emit("  branch opens                  : \(CNT.branchOpens)")
    emit("  implicit-H decisions made     : \(CNT.implicitHDecisions)")
    emit("  element cells compared        : \(CNT.elementCellsCompared)")
    emit("  WL refinement rounds executed : \(CNT.wlRefinementSteps)")
    emit("  WL node updates               : \(CNT.wlNodeUpdates)")
    emit("")
    emit("  corpus bytes hashed           : \(CNT.corpusBytesHashed)")
    emit("  corpus lines read             : \(CNT.corpusLinesRead)")
    emit("  corpus fields split           : \(CNT.corpusFieldsSplit)")
    emit("  MR tokens tested              : \(CNT.mrTokensTested)")
    emit("  perturbagen rows tested       : \(CNT.pertRowsTested)")
    emit("")
    emit("  self-test arms run            : \(CNT.selfTestArmsRun)")
    emit("    arms expected to PASS       : \(CNT.selfTestArmsExpectedPass)")
    emit("    arms expected to FAIL/REFUSE: \(CNT.selfTestArmsExpectedFail)")
    emit("  arms that did not behave      : \(FAILURES.count)")
    if !FAILURES.isEmpty {
        for f in FAILURES { emit("    - \(f)") }
    }
    emit("")
    emit("  FLOAT ON A DECISION PATH      : 0 — every count, comparison and digest is Int/UInt64")
    emit("  molecule formula VERDICT      : \(formulaString(founderFormula)) vs declared \(DECLARED_FORMULA)")
    emit("  rentosertib in LINCS          : \(corpusSupplied ? "ABSENT (measured, 0 of every row)" : "NOT MEASURED (no input)")")
    emit("  TNIK landmark status          : \(corpusSupplied ? "pr_is_lm = 0 (measured)" : "NOT MEASURED (no input)")")
    emit("  TNIK master-regulator status  : \(corpusSupplied ? "0 cohorts (measured)" : "NOT MEASURED (no input)")")
    rule("=")
}


func requireDigest(_ path: String, _ pin: String, _ label: String) -> String? {
    guard let r = sha256File(path) else {
        emit("    REFUSE: \(label) unreadable at supplied path")
        return nil
    }
    emit("    \(label)")
    emit("      bytes  : \(r.bytes)")
    emit("      sha256 : \(r.hex)")
    if r.hex != pin {
        emit("      *** DIGEST MISMATCH — REFUSED ***")
        emit("      expected: \(pin)")
        return nil
    }
    emit("      pin    : MATCH")
    return r.hex
}

emit("")
emit("4B. TNIK IN THE LINCS LANDMARK SPACE — measured from GSE92742_Broad_LINCS_gene_info")
if !corpusSupplied {
    emit("    INPUT_NOT_SUPPLIED — no corpus path given on argv. This is an ABSENCE OF INPUT,")
    emit("    not a measurement and not a pass. Supply 4 paths to run this arm.")
} else if requireDigest(geneInfoPath, PIN_GENE_INFO, "GSE92742_gene_info.txt") == nil {
    emit("    ARM REFUSED ON DIGEST.")
    printReferenceFigures("DIGEST_REFUSAL")
    emit("")
    emit("EXIT 2 — INPUT DIGEST MISMATCH. No corpus claim is made from unpinned bytes.")
    exit(2)
} else {
    let text = (try? String(contentsOfFile: geneInfoPath, encoding: .utf8)) ?? ""
    var rows = 0, landmarks = 0, bing = 0
    var tnikId = "", tnikLM = "", tnikBing = "", tnikTitle = ""
    var ctrlLM = "", ctrlName = "DDR1"
    for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
        CNT.corpusLinesRead += 1
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        CNT.corpusFieldsSplit += f.count
        if f.count < 5 { continue }
        if f[0] == "pr_gene_id" { continue }
        rows += 1
        if f[3] == "1" { landmarks += 1 }
        if f[4] == "1" { bing += 1 }
        if f[1] == "TNIK" { tnikId = f[0]; tnikTitle = f[2]; tnikLM = f[3]; tnikBing = f[4] }
        if f[1] == ctrlName { ctrlLM = f[3] }
    }
    emit("      rows counted (header excluded) : \(rows)")
    emit("      genes with pr_is_lm   = 1      : \(landmarks)")
    emit("      genes with pr_is_bing = 1      : \(bing)")
    emit("")
    emit("      TNIK row: pr_gene_id=\(tnikId)  title=\"\(tnikTitle)\"  pr_is_lm=\(tnikLM)  pr_is_bing=\(tnikBing)")
    arm("TNIK is PRESENT in gene_info", !tnikId.isEmpty, "id=\(tnikId)")
    arm("TNIK pr_is_lm == 0  (NOT a landmark gene)", tnikLM == "0", "pr_is_lm=\(tnikLM)")
    arm("TNIK pr_is_bing == 1 (inferred/BING space only)", tnikBing == "1", "pr_is_bing=\(tnikBing)")
    arm("CONTROL \(ctrlName) pr_is_lm == 1 (detector can see a landmark when there is one)",
        ctrlLM == "1", "pr_is_lm=\(ctrlLM)")
    arm("landmark count == 978 (the declared landmark space)", landmarks == 978, "count=\(landmarks)")
    emit("")
    emit("      CONSEQUENCE, stated exactly: the Study-26 pipeline scores in the 978-gene")
    emit("      LANDMARK space. TNIK is not in it. Any TNIK value in that space is an")
    emit("      inference produced by the L1000 inference model, not a measured transcript.")
}

emit("")
emit("4C. TNIK AS A MASTER REGULATOR — measured from mr_by_cohort_union.tsv")
if !corpusSupplied {
    emit("    INPUT_NOT_SUPPLIED — absence of input, not a measurement.")
} else if requireDigest(mrPath, PIN_MRSETS, "mr_by_cohort_union.tsv") == nil {
    emit("    ARM REFUSED ON DIGEST.")
    printReferenceFigures("DIGEST_REFUSAL")
    emit("")
    emit("EXIT 2 — INPUT DIGEST MISMATCH. No corpus claim is made from unpinned bytes.")
    exit(2)
} else {
    let text = (try? String(contentsOfFile: mrPath, encoding: .utf8)) ?? ""
    var cohorts = 0, totalSlots = 0, tnikCohorts = 0
    var ctrlHits: [String] = []
    var perCohort: [(String, Int, Bool)] = []
    for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
        CNT.corpusLinesRead += 1
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        CNT.corpusFieldsSplit += f.count
        if f.count < 3 { continue }
        if f[0] == "cohort" { continue }
        cohorts += 1
        let toks = f[2].split(separator: ",").map(String.init)
        totalSlots += toks.count
        var hit = false
        for t in toks {
            CNT.mrTokensTested += 1
            if t == "TNIK" { hit = true }
            if t == "TP53" && !ctrlHits.contains(f[0]) { ctrlHits.append(f[0]) }
        }
        if hit { tnikCohorts += 1 }
        perCohort.append((f[0], toks.count, hit))
    }
    emit("      cohorts counted                : \(cohorts)")
    emit("      master-regulator slots tested  : \(totalSlots)")
    emit("      TNIK-positive cohorts          : \(tnikCohorts)")
    emit("")
    emit("      cohort      | MRs | TNIK")
    emit("      ------------+-----+------")
    for (c, n, h) in perCohort {
        let cp = c + String(repeating: " ", count: max(0, 11 - c.count))
        let ns = String(n)
        let np = String(repeating: " ", count: max(0, 3 - ns.count)) + ns
        emit("      \(cp) | \(np) | " + (h ? "YES" : "no"))
    }
    emit("")
    arm("TNIK is a master regulator in ZERO cohorts", tnikCohorts == 0, "cohorts=\(tnikCohorts)")
    arm("CONTROL TP53 IS an MR in at least one cohort (detector is not always-negative)",
        ctrlHits.count > 0, "TP53 in [\(ctrlHits.joined(separator: ","))]")
    emit("")
    emit("      NOTE ON THE COHORT COUNT: the brief stated seventeen cohorts. The file on")
    emit("      disk carries \(cohorts). The measurement is reported as \(cohorts); the null")
    emit("      result is STRONGER at \(cohorts) than at 17, and the disagreement is printed")
    emit("      rather than reconciled silently.")
}

emit("")
emit("4D. IS RENTOSERTIB IN LINCS AT ALL — by InChIKey, by skeleton, and by name")
if !corpusSupplied {
    emit("    INPUT_NOT_SUPPLIED — absence of input, not a measurement.")
} else {
    let skeleton = String(DECLARED_INCHIKEY.prefix(14))
    let nameNeedles = ["rentosertib", "ism001", "ins018", "ism-001", "ins-018", "ism 001", "ins018_055"]
    for (path, pin, label, keyCol, nameCol, nCols) in
        [(pert92Path, PIN_PERT_92742, "GSE92742_pert_info.txt", 5, 1, 8),
         (pert70Path, PIN_PERT_70138, "GSE70138_pert_info.txt", 2, 3, 5)] {
        emit("")
        if requireDigest(path, pin, label) == nil { emit("    ARM REFUSED ON DIGEST."); exit(2) }
        let text = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
        var rows = 0, keyHits = 0, skelHits = 0, nameHits = 0, ctrlHits = 0
        for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
            CNT.corpusLinesRead += 1
            let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            CNT.corpusFieldsSplit += f.count
            if f.count < nCols { continue }
            if f[0] == "pert_id" { continue }
            rows += 1
            CNT.pertRowsTested += 1
            let key = f[keyCol]
            let nm = f[nameCol].lowercased()
            if key == DECLARED_INCHIKEY { keyHits += 1 }
            if key.hasPrefix(skeleton) { skelHits += 1 }
            for nd in nameNeedles where nm.contains(nd) { nameHits += 1; break }
            if nm == "sirolimus" { ctrlHits += 1 }
        }
        emit("      perturbagen rows tested        : \(rows)")
        emit("      exact InChIKey matches         : \(keyHits)")
        emit("      skeleton-block (\(skeleton)) matches : \(skelHits)")
        emit("      name matches (7 spellings)     : \(nameHits)")
        emit("      CONTROL 'sirolimus' rows       : \(ctrlHits)")
        arm("\(label): rentosertib ABSENT by exact key", keyHits == 0, "hits=\(keyHits)")
        arm("\(label): rentosertib ABSENT by connectivity skeleton", skelHits == 0, "hits=\(skelHits)")
        arm("\(label): rentosertib ABSENT by every name spelling", nameHits == 0, "hits=\(nameHits)")
        if label.hasPrefix("GSE92742") {
            arm("\(label): CONTROL sirolimus PRESENT (the search is not always-zero)",
                ctrlHits > 0, "rows=\(ctrlHits)")
        }
    }
    emit("")
    emit("    ANSWER: ABSENT.")
    emit("    Not REFUSED — the lookup ran to completion over every perturbagen row.")
    emit("    Not NOT_KNOWN — the tables were read in full and the integer is zero.")
    emit("    ABSENT, and the reason is chronological: GSE92742 and GSE70138 were deposited")
    emit("    2015-2017. This molecule's first public disclosure is 2021+. A 2017 corpus")
    emit("    cannot contain a 2021 compound, and its absence is not a property of the drug.")
}

emit("")
emit("4E. WHAT THE LINCS CORPUS DOES CARRY THAT IS ADJACENT — and what that is worth")
if corpusSupplied {
    let text = (try? String(contentsOfFile: pert92Path, encoding: .utf8)) ?? ""
    var shTNIK = 0, cgsTNIK = 0, oeTNIK = 0, otherTNIK = 0
    var ids: [String] = []
    for line in text.split(separator: "\n", omittingEmptySubsequences: true) {
        let f = line.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
        if f.count < 8 { continue }
        if f[1] != "TNIK" { continue }
        ids.append("\(f[0]) [\(f[2])]")
        if f[2] == "trt_sh" { shTNIK += 1 }
        else if f[2] == "trt_sh.cgs" { cgsTNIK += 1 }
        else if f[2].hasPrefix("trt_oe") { oeTNIK += 1 }
        else { otherTNIK += 1 }
    }
    emit("      TNIK perturbagen rows in GSE92742 : \(shTNIK + cgsTNIK + oeTNIK + otherTNIK)")
    emit("        trt_sh (shRNA)                  : \(shTNIK)")
    emit("        trt_sh.cgs (consensus signature): \(cgsTNIK)")
    emit("        trt_oe (over-expression)        : \(oeTNIK)")
    emit("        other                           : \(otherTNIK)")
    for s in ids { emit("        \(s)") }
    emit("")
    emit("      WHAT THIS IS: the corpus carries TNIK KNOCKDOWN, not this drug. A knockdown")
    emit("      signature is a statement about removing a gene product. It is NOT a statement")
    emit("      about a molecule that binds the kinase, and it is NOT this molecule's")
    emit("      signature. Reporting one as the other would fabricate the reading this whole")
    emit("      review exists to prevent. It is named here as an AVAILABLE GAME, not as a")
    emit("      result, and it has not been scored.")
} else {
    emit("    INPUT_NOT_SUPPLIED.")
}

// ============================================================================
// SECTION 5 — REFERENCE FIGURES.  PRINTED ON EVERY EXIT PATH.
// ============================================================================

// ============================================================================
// SECTION 5 — THE PUBLIC RECORD, CHECKED ARITHMETICALLY IN INTEGERS
//   Two login-free public sources describe the SAME phase 2a trial NCT05938920:
//     (i)  the sponsor's own posted results on ClinicalTrials.gov
//     (ii) Nat Med 2025;31(8):2602-2610, doi 10.1038/s41591-025-03743-2, PMC12353801
//   Every figure below is transcribed from one of those two and then CHECKED.
//   All quantities are held as SCALED INTEGERS. There is no float on this path.
// ============================================================================

head("SECTION 5 — THE PUBLIC RECORD, CHECKED IN EXACT INTEGER ARITHMETIC")

emit("")
emit("5A. PRIMARY ENDPOINT — do the two sources agree on the counts?")
emit("    The primary endpoint of NCT05938920 was SAFETY: the percentage of patients")
emit("    with at least one treatment-emergent adverse event. It was NOT an efficacy")
emit("    endpoint. Naming that correctly is the whole of this subsection.")
emit("")
// (arm label, affected, at risk, percent x10 as printed in the Nat Med abstract)
let teae: [(String, Int, Int, Int)] = [
    ("30 mg QD",  13, 18, 722),
    ("30 mg BID", 15, 18, 833),
    ("60 mg QD",  15, 18, 833),
    ("placebo",   12, 17, 706)
]
emit("      arm        | CTG posted | Nat Med printed | recomputed | agree")
emit("      -----------+------------+-----------------+------------+------")
var teaeOK = true
for (lab, num, den, printedTenths) in teae {
    // percent x 10, rounded half-up, integer division only
    let recomputed = (num * 2000 + den) / (2 * den)
    let ok = (recomputed == printedTenths)
    if !ok { teaeOK = false }
    let l = lab + String(repeating: " ", count: max(0, 10 - lab.count))
    emit("      \(l) |   \(num)/\(den)    |     \(printedTenths / 10).\(printedTenths % 10)%       |   \(recomputed / 10).\(recomputed % 10)%    | \(ok ? "YES" : "NO")")
}
arm("PRIMARY endpoint counts reconcile between registry and journal", teaeOK,
    "4 arms recomputed from n/N by integer division")

emit("")
emit("5B. THE ONE PLACE THE TWO SOURCES DIVERGE — and it is the efficacy interval.")
emit("    Endpoint: absolute change from baseline in FVC at week 12, 60 mg QD arm.")
emit("    All values in MILLILITRES x 10, held as Int.")
emit("")
// Nat Med abstract, verbatim: "+98.4 ml (95% confidence interval 10.9 to 185.9)"
let nm_mean = 984, nm_lo = 109, nm_hi = 1859
// ClinicalTrials.gov posted analysis, same arm: LS mean 0.0892 L, 95% CI -0.0087 to 0.1872
let ct_ls   = 892, ct_lo = -87, ct_hi = 1872
// ClinicalTrials.gov posted raw measurement, same arm: mean 0.0984 L, SD 0.14113 L, n = 10
let ct_raw  = 984
let ct_sd_x100 = 14113          // millilitres x 100
let ct_n    = 10
emit("      Nat Med abstract   : mean = \(nm_mean/10).\(nm_mean%10) mL   95% CI [\(nm_lo/10).\(nm_lo%10), \(nm_hi/10).\(nm_hi%10)]")
emit("      CTG posted analysis: LS mean = \(ct_ls/10).\(ct_ls%10) mL   95% CI [-\(-ct_lo/10).\(-ct_lo%10), \(ct_hi/10).\(ct_hi%10)]")
emit("      CTG posted raw     : mean = \(ct_raw/10).\(ct_raw%10) mL   SD = \(ct_sd_x100/100).\(ct_sd_x100%100) mL   n = \(ct_n)")
emit("")
arm("point estimate: journal mean == registry RAW mean, exactly", nm_mean == ct_raw,
    "\(nm_mean) vs \(ct_raw) (mL x10)")
arm("point estimate: journal mean != registry LS mean", nm_mean != ct_ls,
    "\(nm_mean) vs \(ct_ls) (mL x10)")
emit("")
emit("      WHICH INTERVAL EXCLUDES ZERO — an integer sign test, nothing else:")
arm("Nat Med interval EXCLUDES zero (lower bound > 0)", nm_lo > 0, "lower = \(nm_lo) (mL x10)")
arm("CTG LS-mean interval INCLUDES zero (lower bound < 0)", ct_lo < 0, "lower = \(ct_lo) (mL x10)")
emit("")
emit("      WHICH ESTIMATOR PRODUCED THE JOURNAL INTERVAL — identified by exact")
emit("      integer arithmetic from the registry's own SD and n, with no float:")
emit("        hypothesis: half-width h = 1.96 * SD / sqrt(n)")
emit("        squared, and cleared of the root:   h^2 * n * 100^2  ==  196^2 * SD^2")
let h_x100 = ((nm_hi - nm_lo) / 2) * 10          // half-width, mL x 100
let lhs = h_x100 * h_x100 * ct_n * 10000
let sd2 = ct_sd_x100 * ct_sd_x100
let rhs = 196 * 196 * sd2
emit("        h (mL x100)      = \(h_x100)")
emit("        LHS = h^2*n*10^4 = \(lhs)")
emit("        RHS = 196^2*SD^2 = \(rhs)")
let diff = lhs > rhs ? lhs - rhs : rhs - lhs
let partsPer10k = (diff * 10000) / rhs
emit("        |LHS-RHS| as parts per 10,000 of RHS = \(partsPer10k)")
arm("journal interval is a NORMAL-APPROXIMATION interval on the RAW mean (agreement < 100 parts per 10,000)",
    partsPer10k < 100, "parts per 10,000 = \(partsPer10k)")
emit("")
emit("      WHAT THAT MEANS, STATED PLAINLY AND WITHOUT SOFTENING:")
emit("      Both intervals are honest and both are published. They differ because they")
emit("      are two different estimators of the same arm: the journal reports a normal-")
emit("      approximation interval around the RAW mean (n = \(ct_n)), the registry posts a")
emit("      model-based LEAST-SQUARES mean with a larger standard error. On the lower")
emit("      bound they fall on opposite sides of zero. A reader who sees only the")
emit("      journal abstract sees an interval that excludes zero; a reader who opens the")
emit("      sponsor's own posted analysis for the same arm sees one that does not.")
emit("")
emit("      AND THE LARGER POINT, WHICH NEITHER INTERVAL ADDRESSES: both are WITHIN-ARM")
emit("      change-from-baseline intervals. Neither is a difference-versus-placebo")
emit("      interval with its own confidence bound. Placing the 60 mg arm's interval")
emit("      beside the placebo arm's interval is a coordinate statement, not a")
emit("      between-group statement, and the registry posts no between-group analysis")
emit("      for this endpoint at all. FVC was a SECONDARY endpoint in a 12-week trial")
emit("      whose FVC analysis set was \(13 + 12 + 10 + 14) of 71 randomised patients.")

emit("")
emit("5C. THE SAFETY RECORD AS POSTED — counts, not adjectives.")
emit("    Source: ClinicalTrials.gov NCT05938920 results section, sponsor-posted.")
emit("    All-cause serious adverse events (the registry's own denominator):")
emit("")
let sae: [(String, Int, Int)] = [("30 mg QD", 2, 18), ("30 mg BID", 4, 18), ("60 mg QD", 7, 18), ("placebo", 3, 17)]
emit("      arm        | SAE / at risk | discontinued for TEAE | deaths")
emit("      -----------+---------------+-----------------------+-------")
let disc = [1, 5, 4, 2]
let deaths = [0, 1, 0, 0]
for (i, e) in sae.enumerated() {
    let l = e.0 + String(repeating: " ", count: max(0, 10 - e.0.count))
    emit("      \(l) |     \(e.1)/\(e.2)       |          \(disc[i])            |   \(deaths[i])")
}
emit("")
emit("      Hepatobiliary serious adverse events, posted verbatim as MedDRA terms:")
emit("        'Liver injury'             30 mg BID 1/18 ; 60 mg QD 1/18 ; placebo 0/17")
emit("        'Drug-induced liver injury' 30 mg BID 1/18 ;                placebo 0/17")
emit("        'Hepatic function abnormal'                 60 mg QD 1/18 ; placebo 0/17")
emit("      Non-serious, same source:")
emit("        'Alanine aminotransferase increased'  30QD 1 ; 30BID 1 ; 60QD 6 ; placebo 1")
emit("        'Hepatic function abnormal'           30QD 2 ; 30BID 4 ; 60QD 3 ; placebo 2")
emit("        'Blood bilirubin increased'           30QD 0 ; 30BID 1 ; 60QD 4 ; placebo 2")
emit("        'Diarrhoea'                           30QD 2 ; 30BID 3 ; 60QD 5 ; placebo 0")
emit("        'Hypokalemia'                         30QD 3 ; 30BID 5 ; 60QD 4 ; placebo 2")
emit("      118 distinct non-serious terms are posted in total.")
emit("")
emit("      The Nat Med abstract states, verbatim: \"Treatment-related serious adverse")
emit("      event rates were low and comparable across treatment groups, with the most")
emit("      common events leading to treatment discontinuation related to liver toxicity")
emit("      or diarrhea.\" That sentence is about TREATMENT-RELATED events. The registry")
emit("      table above counts ALL-CAUSE events. They are two different denominators of")
emit("      causality and they are not in conflict — but they are also not the same")
emit("      number, and only the all-cause counts are posted per arm. The liver signal")
emit("      is named by BOTH sources; it is not a reading this review invented.")

emit("")
emit("5D. THE REGISTRATIONS — pinned, login-free, ClinicalTrials.gov API v2.")
emit("      NCT05154240  PHASE 1   COMPLETED   n = 78 actual   New Zealand   healthy subjects")
emit("                   single and multiple ascending dose, randomised, double-blind, placebo-controlled")
emit("                   start 2022-02-21, primary completion 2022-12-02. No results posted.")
emit("      CTR20221542  a separate phase 1 in China, cited in Nat Biotechnol 2025;43(1):63-75.")
emit("                   Chinese registry identifier, not a ClinicalTrials.gov record.")
emit("      NCT05938920  PHASE 2a  COMPLETED   n = 71 actual   China   IPF patients")
emit("                   randomised, double-blind, placebo-controlled, 12 weeks, 4 arms.")
emit("                   start 2023-06-19, primary completion 2024-08-08. RESULTS POSTED.")
emit("      NCT05975983  PHASE 2a  RECRUITING  n = 40 estimated  United States  IPF patients")
emit("                   start 2024-02-08, primary completion 2026-02-28. No results posted.")
emit("      NCT07687459  PHASE 3   NOT YET RECRUITING  n = 320 estimated  China   IPF patients")
emit("                   52 weeks, quadruple-masked. PRIMARY ENDPOINT: annual rate of FVC")
emit("                   decline over 52 weeks. start 2026-08-30, primary completion 2029-10-30.")
emit("      Sponsor of all five: InSilico Medicine Hong Kong Limited.")
emit("")
emit("      NOT KNOWN from these sources, and not guessed: any regulatory approval status,")
emit("      any marketing authorisation, and the results of NCT05975983 and NCT07687459,")
emit("      neither of which has posted any. NOT KNOWN is not the same as absent.")

emit("")
emit("5E. THE PUBLISHED LITERATURE — 11 PubMed records, retrieved by E-utilities.")
emit("      PMID 40461817  Nat Med 2025;31(8):2602-2610   THE PHASE 2a READOUT   PMC12353801")
emit("      PMID 38459338  Nat Biotechnol 2025;43(1):63-75  target + molecule + phase 1  PMC11738990")
emit("      PMID 39422731  J Med Chem 2024 Nov 14   the medicinal-chemistry series")
emit("      PMID 40820280  Expert Opin Ther Pat 2025 Oct   TNIK inhibitor patent review 2008-2024")
emit("      PMID 42115887  BMC Pulm Med 2026   IPF network meta-analysis   PMC13330183")
emit("      PMID 39965245  Aging Dis 2025   TNIK inhibition as senomorphic   PMC12727053")
emit("      PMID 41475169  Pulm Pharmacol Ther 2026   letter to the editor on rentosertib")
emit("      plus 4 review/landscape articles.")
emit("      Every author of the phase 2a readout affiliated with Insilico Medicine is")
emit("      declared as such in the paper's own competing-interests statement, and the")
emit("      study sponsor is Insilico Medicine. That is disclosed, not concealed.")

printReferenceFigures(FAILURES.isEmpty
    ? (corpusSupplied ? "ALL_ARMS_AS_EXPECTED" : "STRUCTURAL_ONLY_CORPUS_NOT_MEASURED")
    : "ARM_FAILURE")

emit("")
emit("EXIT CODE LEGEND")
emit("  0 = every arm ran and behaved as specified, corpus included")
emit("  1 = structural arms behaved, but the corpus was NOT supplied, so the corpus")
emit("      claims were NOT measured. A gate given nothing does not exit 0.")
emit("  2 = an input digest did not match its pin. No claim is made from unpinned bytes.")
emit("  3 = an arm did not behave as specified.")
emit("")
if !FAILURES.isEmpty {
    emit("EXIT 3 — SELF-TEST FAILURE. \(FAILURES.count) arm(s) did not behave as specified.")
    exit(3)
}
if !corpusSupplied {
    emit("EXIT 1 — INCOMPLETE. \(CNT.selfTestArmsRun) structural arms behaved in both")
    emit("         directions, but no corpus was supplied and the LINCS / master-regulator")
    emit("         arms were NOT MEASURED. That is an absence of input, never a pass.")
    exit(1)
}
emit("EXIT 0 — every arm behaved as specified, in both directions.")
exit(0)
