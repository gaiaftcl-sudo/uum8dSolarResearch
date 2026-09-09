// =====================================================================================
// STUDY 45, ARM A CORE — the genetic code, enumerated exactly
//
// Before a genome is touched, this establishes the CODE-INTRINSIC baseline: over the
// standard genetic code, of every possible single-nucleotide substitution inside a codon,
// how many are synonymous (the amino acid does not change), missense (it changes), nonsense
// (a stop is gained), or stop-lost. This is a closed enumeration — 64 codons x 3 positions
// x 3 alternate bases = 576 substitutions — and the answer is an integer, the same on every
// machine, needing no download, no model, no key.
//
// It is the foundation of the time-to-cure argument: for the synonymous and nonsense classes
// the PROTEIN consequence is EXACTLY determined by this table. A synonymous change leaves the
// protein untouched; a nonsense change truncates it. Neither needs a floating-point model to
// know, and a model that assigns them a continuous "impact" has replaced a certainty a bench
// could act on with a probability it must re-adjudicate.
//
// WHAT THIS DOES NOT SAY: a synonymous DNA change is NOT necessarily biologically silent — it
// can affect splicing, mRNA stability and codon usage, which are exactly the regulatory
// effects AlphaGenome does try to predict. So this table is not a claim that synonymous
// variants are safe. It is a claim about the PROTEIN-CODING consequence, which is the half
// the codon table settles exactly, and it is stated at that scope and no wider.
//
// Zero floats on any decision path: every figure is an integer count.
// =====================================================================================

import Foundation

// The standard genetic code, DNA sense strand (T, not U). 64 codons in TCAG-major order is
// not required; we list them explicitly so the table can be read and checked by eye.
let CODE: [String: Character] = [
    "TTT":"F","TTC":"F","TTA":"L","TTG":"L","CTT":"L","CTC":"L","CTA":"L","CTG":"L",
    "ATT":"I","ATC":"I","ATA":"I","ATG":"M","GTT":"V","GTC":"V","GTA":"V","GTG":"V",
    "TCT":"S","TCC":"S","TCA":"S","TCG":"S","CCT":"P","CCC":"P","CCA":"P","CCG":"P",
    "ACT":"T","ACC":"T","ACA":"T","ACG":"T","GCT":"A","GCC":"A","GCA":"A","GCG":"A",
    "TAT":"Y","TAC":"Y","TAA":"*","TAG":"*","CAT":"H","CAC":"H","CAA":"Q","CAG":"Q",
    "AAT":"N","AAC":"N","AAA":"K","AAG":"K","GAT":"D","GAC":"D","GAA":"E","GAG":"E",
    "TGT":"C","TGC":"C","TGA":"*","TGG":"W","CGT":"R","CGC":"R","CGA":"R","CGG":"R",
    "AGT":"S","AGC":"S","AGA":"R","AGG":"R","GGT":"G","GGC":"G","GGA":"G","GGG":"G",
]

let BASES: [Character] = ["A","C","G","T"]

enum Consequence: String { case synonymous = "SYNONYMOUS", missense = "MISSENSE",
                                nonsense = "NONSENSE", stopLost = "STOP_LOST" }

// The exact rule. Given a codon and a substitution, the consequence is a table lookup.
func classify(_ codon: String, _ posInCodon: Int, _ alt: Character) -> Consequence? {
    var c = Array(codon)
    guard posInCodon >= 0, posInCodon < 3, c[posInCodon] != alt else { return nil }
    let oldAA = CODE[codon]!
    c[posInCodon] = alt
    let newAA = CODE[String(c)]!
    if oldAA == newAA { return .synonymous }        // includes stop -> stop
    if oldAA == "*" { return .stopLost }
    if newAA == "*" { return .nonsense }            // stop gained
    return .missense
}

func gp(_ n: Int) -> String {
    let s = String(n); var o = ""; var k = 0
    for ch in s.reversed() { if k != 0 && k % 3 == 0 { o.append(",") }; o.append(ch); k += 1 }
    return String(o.reversed())
}

func printReference() {
    print("")
    print("--- BEGIN QUOTED REFERENCE FIGURES (published; NOT computed on this run) ---")
    print("  codons in the standard code                 64")
    print("  single-base substitutions per codon         9   (3 positions x 3 alternates)")
    print("  total substitutions enumerated              576")
    print("  SYNONYMOUS                                   138")
    print("  MISSENSE                                     392")
    print("  NONSENSE (stop gained)                       23")
    print("  STOP_LOST                                    23")
    print("--- END QUOTED REFERENCE FIGURES ---")
}

// -------------------------------------------------------------------------- self-test
var arms: [(String, Bool, String)] = []
func arm(_ n: String, _ ok: Bool, _ note: String) { arms.append((n, ok, note)) }

arm("synonymous-known-case  TTT>TTC both Phe",
    classify("TTT", 2, "C") == .synonymous, "TTT pos3 T>C -> TTC")
arm("nonsense-known-case  TAC>TAA Tyr>stop",
    classify("TAC", 2, "A") == .nonsense, "TAC pos3 C>A -> TAA")
arm("missense-known-case  ATG>CTG Met>Leu",
    classify("ATG", 0, "C") == .missense, "ATG pos1 A>C -> CTG")
arm("stop-to-stop-is-synonymous  TAA>TAG",
    classify("TAA", 2, "G") == .synonymous, "both are stop, so no protein change")
arm("stop-lost-known-case  TGA>TCA stop>Ser",
    classify("TGA", 1, "C") == .stopLost, "TGA pos2 G>C -> TCA")
arm("no-change-is-not-a-substitution  TTT pos1 T>T",
    classify("TTT", 0, "T") == nil, "alt equal to ref is not a variant")
arm("every-codon-in-the-table",
    CODE.count == 64, "the standard code has exactly 64 codons; table holds \(CODE.count)")

let armsOK = arms.allSatisfy { $0.1 }

print("STUDY 45 — ARM A CORE: the genetic code, enumerated exactly")
print("Of every possible single-nucleotide substitution inside a codon, how many change the")
print("protein and how many do not. An integer, the same on every machine, no model, no key.")
print("")
print("SELF-TEST — the classifier on known cases, before it counts anything")
for (n, ok, note) in arms { print("  [\(ok ? "PASS" : "FAIL")] \(n)\n         \(note)") }
print("  arms: \(arms.count) run, \(arms.filter{$0.1}.count) passed, \(arms.filter{!$0.1}.count) failed")
print("")
if !armsOK {
    printReference()
    print("")
    print("RUN_TERMINAL  REFUSED  SELFTEST_FAILED")
    exit(4)
}

// ---------------------------------------------------------------- the closed enumeration
var counts: [Consequence: Int] = [.synonymous: 0, .missense: 0, .nonsense: 0, .stopLost: 0]
var total = 0
let codonsSorted = CODE.keys.sorted()
for codon in codonsSorted {
    for pos in 0..<3 {
        let ref = Array(codon)[pos]
        for alt in BASES where alt != ref {
            let c = classify(codon, pos, alt)!
            counts[c]! += 1
            total += 1
        }
    }
}

print("THE CLOSED ENUMERATION — 64 codons x 3 positions x 3 alternate bases")
print("  total substitutions                          \(total)")
print("  SYNONYMOUS   (protein unchanged, exactly)    \(counts[.synonymous]!)   \(counts[.synonymous]! * 1000 / total) per 1000")
print("  MISSENSE     (amino acid changes)            \(counts[.missense]!)   \(counts[.missense]! * 1000 / total) per 1000")
print("  NONSENSE     (stop gained, truncating)       \(counts[.nonsense]!)   \(counts[.nonsense]! * 1000 / total) per 1000")
print("  STOP_LOST    (stop -> amino acid)            \(counts[.stopLost]!)   \(counts[.stopLost]! * 1000 / total) per 1000")
print("")
let exactlyDetermined = counts[.synonymous]! + counts[.nonsense]! + counts[.stopLost]!
print("  substitutions whose PROTEIN consequence is a CERTAINTY from this table alone:")
print("    synonymous + nonsense + stop-lost          \(exactlyDetermined) of \(total)   \(exactlyDetermined * 1000 / total) per 1000")
print("  (missense is exactly identified TOO — the amino acid change is certain — but WHICH")
print("   change matters and that is a further question; the three above need no further one")
print("   for the protein-coding consequence.)")
print("")
print("SCOPE, stated at the width it holds and no wider:")
print("  This is the PROTEIN-CODING consequence, settled by the codon table. It is NOT a claim")
print("  that a synonymous change is biologically silent: splicing, mRNA stability and codon")
print("  usage are real, and are exactly the regulatory effects a sequence model tries to")
print("  predict. The point is the reverse — for the coding consequence the table is exact and")
print("  free, so a continuous score adds cost there, not information.")
print("")
print("  These are the CODE-INTRINSIC fractions, weighted by the code alone. The GENOME-WEIGHTED")
print("  counts — how many of the ~9.3 billion actual single-nucleotide variants fall in each")
print("  class, weighted by real coding sequence and codon usage — are the slow run that needs")
print("  the GENCODE CDS annotation and the assembly, and they are NOT computed here.")
print("")

var transcript = "study45armA;v=1;codons=\(CODE.count);total=\(total);"
for c in [Consequence.synonymous, .missense, .nonsense, .stopLost] { transcript += "\(c.rawValue)=\(counts[c]!);" }
transcript += "arms=\(arms.count)/\(arms.filter{$0.1}.count)\n"

func sha256Hex(_ bytes: [UInt8]) -> String {
    var h: [UInt32] = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
    let k: [UInt32] = [
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]
    var m = bytes; let bitLen = UInt64(bytes.count) * 8
    m.append(0x80); while m.count % 64 != 56 { m.append(0) }
    for i in (0..<8).reversed() { m.append(UInt8((bitLen >> (8 * UInt64(i))) & 0xff)) }
    var idx = 0
    while idx < m.count {
        var w = [UInt32](repeating: 0, count: 64)
        for i in 0..<16 { let o = idx + i*4
            w[i] = (UInt32(m[o])<<24)|(UInt32(m[o+1])<<16)|(UInt32(m[o+2])<<8)|UInt32(m[o+3]) }
        for i in 16..<64 {
            let s0 = (w[i-15]>>7|w[i-15]<<25)^(w[i-15]>>18|w[i-15]<<14)^(w[i-15]>>3)
            let s1 = (w[i-2]>>17|w[i-2]<<15)^(w[i-2]>>19|w[i-2]<<13)^(w[i-2]>>10)
            w[i] = w[i-16] &+ s0 &+ w[i-7] &+ s1 }
        var a=h[0],b=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7]
        for i in 0..<64 {
            let S1=(e>>6|e<<26)^(e>>11|e<<21)^(e>>25|e<<7); let ch=(e&f)^(~e&g)
            let t1=hh &+ S1 &+ ch &+ k[i] &+ w[i]
            let S0=(a>>2|a<<30)^(a>>13|a<<19)^(a>>22|a<<10); let mj=(a&b)^(a&c)^(b&c)
            let t2=S0 &+ mj; hh=g;g=f;f=e;e=d &+ t1;d=c;c=b;b=a;a=t1 &+ t2 }
        h[0]=h[0]&+a;h[1]=h[1]&+b;h[2]=h[2]&+c;h[3]=h[3]&+d
        h[4]=h[4]&+e;h[5]=h[5]&+f;h[6]=h[6]&+g;h[7]=h[7]&+hh; idx += 64
    }
    return h.map { String(format:"%08x",$0) }.joined()
}

printReference()
print("")
print("MARKER  CODON_TABLE_SETTLES_THE_PROTEIN_CONSEQUENCE_FOR_FREE")
print("sha256  \(sha256Hex(Array(transcript.utf8)))")
print("RUN_TERMINAL  COMPLETE")
