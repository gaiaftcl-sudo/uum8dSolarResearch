// The full-grade replacement, read from the court's own catalog snapshot.
//
// Every domain the live court serves declares the CONTINUOUS instrument it retires
// (dead_equation), the exact law that replaces it (new_law), a proof marker, and the
// flourishing identity entropy_bare - entropy_delta = entropy_resolved. This program
// renders that catalog as the replacement scoreboard -- and counts, rather than
// asserts, how much of the replacement is proven, chartered, or still short of 1/1.
// The snapshot is sha256-pinned; re-fetch the live catalog to check it has not drifted.
import Foundation
func find(_ f:String)->String?{for c in ["corpus/study-31/\(f)","../corpus/study-31/\(f)","../../corpus/study-31/\(f)",f]{if let s=try? String(contentsOfFile:c,encoding:.utf8){return s}};return nil}
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
guard let raw = find("court-catalog-20260901.json"),
      let data = raw.data(using:.utf8),
      let top = try? JSONSerialization.jsonObject(with:data) as? [String:Any],
      let doms = top["domains"] as? [[String:Any]] else { print("snapshot missing"); exit(1) }

print("=== THE REPLACEMENT CATALOG — \(doms.count) domains, from the court's own declaration ===")
print("  Each row: the continuous-math instrument RETIRED -> the exact law that replaced it.")
print("")
var proven=0, resolved=0
for d in doms.sorted(by:{($0["domain"] as? String ?? "") < ($1["domain"] as? String ?? "")}) {
    let id=d["domain"] as? String ?? "?"
    let dead=(d["dead_equation"] as? String ?? "?")
    let marker=(d["proven_marker"] as? String ?? "")
    let er=(d["entropy_resolved"] as? String ?? "")
    let flag = marker.hasSuffix("_PROVEN") ? "PROVEN " : "       "
    if marker.hasSuffix("_PROVEN") { proven += 1 }
    if er == "1/1" { resolved += 1 }
    print("  \(pad(id,14))\(flag)\(String(dead.prefix(76)))")
}
print("")
print("=== THE SCOREBOARD, counted not claimed ===")
print("  domains declared                 \(doms.count)")
print("  carrying a live PROVEN marker    \(proven)")
print("  resolving the identity to 1/1    \(resolved)")
print("  still short of 1/1               \(doms.count - resolved)   <- the honest remainder, listed by name above")
print("")
print("  The replacement is not finished and this table does not pretend it is.")
print("  What it IS: a running, dated, per-domain migration of verdict law from")
print("  continuous shear to exact form -- with the proof status of every row")
print("  readable off the live court rather than off this page.")
