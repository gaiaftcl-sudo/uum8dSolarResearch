// A CRISPR / base / prime editor off-target search, both ways. The safety question for a genome
// editor: besides its intended target, where ELSE in the genome does its guide sequence match well
// enough (protospacer + PAM) to risk an edit? Two instruments.
//
// EXACT  — count mismatches to the 20-nt protospacer (integer Hamming distance) and require a valid
//          PAM (NGG). A locus is an off-target candidate when mismatches <= K and the PAM is present.
//          Pure integers: one answer on every machine, re-derivable byte-for-byte, no weights to pick.
// FLOAT  — the field's standard is a per-position weighted score (CFD/MIT-style): a product of float
//          penalties, larger for mismatches near the PAM. A locus is a candidate when the score >= a
//          cutoff. The penalty TABLE is not standardized — CFD, MIT and CRISPOR publish different
//          weights — so the verdict on a borderline locus moves with the table you round to, exactly
//          like the pi choice on the fusion court (Study 34).
//
// Representative synthetic loci; it shows the KIND of divergence, not a result on any real guide.
// Deterministic — no clock, no randomness.
import Foundation

let L = 20
// A=0 C=1 G=2 T=3. Guide protospacer (20 nt) + we test 23-nt loci (20 protospacer + 3-nt PAM NGG).
let guideProto: [Int] = [2,1,2,3,0,2,1,0,2,3,1,2,0,2,3,1,2,0,1,2]

// build loci: perfect protospacer, then plant mismatches at chosen positions (0 = PAM-distal, 19 = PAM-proximal),
// each with a valid NGG PAM. Mismatches near the PAM (high index) hurt the float score most.
func mutate(_ w: [Int], _ pos: [Int]) -> [Int] { var v = w; for p in pos { v[p] = (v[p] + 1) % 4 }; return v }
struct Locus { let name: String; let proto: [Int]; let pam: (Int,Int,Int) }  // pam = 3 nt; NGG means pam.1==G,pam.2==G
let GG = (0,2,2)  // N,G,G  (N=A here, valid)
let loci: [Locus] = [
  Locus(name: "on_target        ", proto: guideProto,                  pam: GG),
  Locus(name: "off_2mm_distal   ", proto: mutate(guideProto,[1,4]),    pam: GG),   // 2 mm, PAM-distal
  Locus(name: "off_3mm_distal   ", proto: mutate(guideProto,[0,3,6]),  pam: GG),   // 3 mm, PAM-distal (float: still high)
  Locus(name: "off_3mm_proximal ", proto: mutate(guideProto,[16,18,19]), pam: GG), // 3 mm, PAM-proximal (float: low — exact flags, float misses)
  Locus(name: "off_3mm_mid      ", proto: mutate(guideProto,[8,10,12]), pam: GG),   // 3 mm, mid — float score straddles the cutoff, flips A vs B
  Locus(name: "off_2mm_noPAM    ", proto: mutate(guideProto,[2,9]),    pam: (0,1,3)), // 2 mm but NO PAM -> exact clears it
  Locus(name: "decoy_7mm        ", proto: mutate(guideProto,[1,3,5,8,11,15,18]), pam: GG),
]

func mismatches(_ p: [Int]) -> Int { (0..<L).reduce(0) { $0 + (p[$1] != guideProto[$1] ? 1 : 0) } }
func validPAM(_ pam: (Int,Int,Int)) -> Bool { pam.1 == 2 && pam.2 == 2 }   // NGG
let EXACT_MAXMM = 3   // <= 3 mismatches AND a PAM -> off-target candidate

// float CFD-style score: product over positions of (mismatch ? weight[i] : 1.0). Two published-style tables.
func score(_ p: [Int], _ w: [Double]) -> Double {
  var s = 1.0
  for i in 0..<L where p[i] != guideProto[i] { s *= w[i] }
  return s
}
// weight table A and B: PAM-proximal mismatches penalized hardest; the two differ within the spread
// real published tables show. (A locus scores >=0 always; lower = more penalized.)
func table(_ base: Double) -> [Double] { (0..<L).map { i in max(0.05, base - Double(i) * (base/28.0)) } }
let WA = table(0.95)   // CFD-like
let WB = table(0.90)   // MIT/CRISPOR-like, slightly harsher
let CUTOFF = 0.20      // score >= cutoff -> off-target candidate

print("=== a genome-editor off-target search: exact (mismatch+PAM) vs float (weighted score) ===\n")
print("  locus               mm   PAM   scoreA   scoreB  | exact    floatA   floatB")
var ex = Set<String>(), fa = Set<String>(), fb = Set<String>()
for lo in loci {
  let m = mismatches(lo.proto), pam = validPAM(lo.pam)
  let sa = score(lo.proto, WA), sb = score(lo.proto, WB)
  let e = (m <= EXACT_MAXMM && pam), oa = (sa >= CUTOFF && pam), ob = (sb >= CUTOFF && pam)
  if e { ex.insert(lo.name) }; if oa { fa.insert(lo.name) }; if ob { fb.insert(lo.name) }
  print(String(format: "  %@  %2d   %@   %.4f   %.4f  | %@   %@   %@",
    lo.name, m, pam ? "yes":"no ", sa, sb, e ? "OFF ":"—   ", oa ? "OFF ":"—   ", ob ? "OFF ":"—   "))
}
print("")
print("  EXACT off-target set:            \(ex.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  FLOAT off-target set, table A:   \(fa.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  FLOAT off-target set, table B:   \(fb.sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("  float sets DISAGREE on: \(fa.symmetricDifference(fb).sorted().map{$0.trimmingCharacters(in:.whitespaces)})")
print("")
print("  READING — synthetic, representative; the KIND of divergence, not a real guide result.")
print("  Off-target candidate identification by exact mismatch count + PAM is observer-invariant and re-derivable;")
print("  the same loci scored by a floating-point CFD/MIT-style weight table reclassify a PAM-proximal borderline")
print("  site on which published table you round to. A prime editor's THREE required matches make the exact set")
print("  sparser still. This is the sequence-safety analogue of the pi-bracket shear on the fusion court.")
print("  CRISPR_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT")
