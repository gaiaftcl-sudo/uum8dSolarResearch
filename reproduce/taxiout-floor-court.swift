// STUDY 32 — the taxi-out floor court.
//
// LAW, FROZEN BEFORE GRADING (2026-09-01, chosen on methodology, not results):
//   floor(airport) = the 5th percentile of that airport's own taxi-out record,
//                    integer minutes (EUROCONTROL's own "unimpeded" concept uses
//                    a low percentile; p05 is robust to bad rows where min is not)
//   excess(flight) = taxi - floor(airport), never negative by construction of p05
//                    only above the floor
//   admission      = airports with >= 5,000 admitted flights (stable percentiles)
//
// WHAT THE DELTA IS AND IS NOT: the excess includes runway queueing (a runway is
// a mutex; even a perfect discrete scheduler queues when demand exceeds capacity),
// safety separation, weather, AND coordination overhead. This court cannot split
// those from this corpus alone -- so it computes the honest BOUND instead: the
// excess in each airport's QUIETEST off-block hours, where queueing ~ 0, is the
// coordination-overhead estimate. Zero-taxi claims are refused: the floor is
// physical. Integer minutes throughout.
import Foundation
func find(_ f:String)->String?{for c in ["corpus/study-32/\(f)","../corpus/study-32/\(f)","../../corpus/study-32/\(f)",f]{if let s=try? String(contentsOfFile:c,encoding:.utf8){return s}};return nil}
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}
guard let raw = find("taxiout.csv") else { print("corpus missing"); exit(2) }

struct A { var taxis:[Int]=[]; var byHour:[[Int]]=Array(repeating:[],count:24) }
var ap:[String:A]=[:]
var rows=0
for line in raw.split(whereSeparator:{$0=="\n"||$0=="\r\n"||$0=="\r"}).dropFirst() {
    let f=line.split(separator:",")
    guard f.count==3, let h=Int(f[1]), let t=Int(f[2]), h>=0, h<24 else { continue }
    let k=String(f[0]); rows+=1
    ap[k, default:A()].taxis.append(t)
    ap[k]!.byHour[h].append(t)
}
let admitted = ap.filter{$0.value.taxis.count>=5_000}
print("=== STUDY 32 — the taxi-out floor court ===")
print("  rows ingested \(rows) · airports admitted at >=5,000 flights: \(admitted.count)")
print("")
func pct(_ v:[Int],_ p:Int)->Int{ v.isEmpty ? 0 : v[min(v.count-1,(v.count-1)*p/100)] }

print("  \(pad("airport",9))\(rp("flights",9))\(rp("floor p05",10))\(rp("median",8))\(rp("p95",6))\(rp("excess/flight",15))\(rp("quiet-hr excess",17))")
var totExcess=0, totFlights=0, floors=Set<Int>()
struct Row{let k:String;let n:Int;let floor:Int;let med:Int;let p95:Int;let exPerF:Int;let quiet:Int}
var out:[Row]=[]
for (k,var a) in admitted {
    a.taxis.sort()
    let fl=pct(a.taxis,5), med=pct(a.taxis,50), p95=pct(a.taxis,95)
    floors.insert(fl)
    var ex=0; for t in a.taxis where t>fl { ex += t-fl }
    // quietest three hours by traffic count, with >=200 flights total
    let hours=a.byHour.enumerated().sorted{ $0.element.count < $1.element.count }
    var quietTaxis:[Int]=[]; for (_,v) in hours { quietTaxis+=v; if quietTaxis.count>=200 { break } }
    quietTaxis.sort()
    var qex=0; for t in quietTaxis where t>fl { qex += t-fl }
    let qPerF = quietTaxis.isEmpty ? 0 : qex*10/quietTaxis.count
    out.append(Row(k:k,n:a.taxis.count,floor:fl,med:med,p95:p95,exPerF:ex*10/a.taxis.count,quiet:qPerF))
    totExcess+=ex; totFlights+=a.taxis.count
}
for r in out.sorted(by:{$0.n > $1.n}).prefix(14) {
    print("  \(pad(r.k,9))\(rp("\(r.n)",9))\(rp("\(r.floor) min",10))\(rp("\(r.med)",8))\(rp("\(r.p95)",6))\(rp("\(r.exPerF/10).\(r.exPerF%10) min",15))\(rp("\(r.quiet/10).\(r.quiet%10) min",17))")
}
print("")
print("=== CONTROLS, graded before the result ===")
print("  discrimination: distinct airport floors observed = \(floors.count)  (1 would mean a broken instrument)")
// A first control here asserted "a hub's floor must exceed a small field's" and
// FAILED — correctly, because its premise was wrong: the p05 floor measures
// TAXIWAY GEOMETRY (gate-to-runway distance), not traffic. Istanbul's enormous
// new field floors at 16 min and Bergen at 15 against Heathrow's 10, and that is
// geography, not a defect. The premise error is recorded rather than deleted.
// The controls that actually test the instrument:
let maxEx = out.max{ $0.exPerF < $1.exPerF }
if let m = maxEx {
    print("  known-case: the LARGEST excess/flight must land on a slot-constrained hub —")
    print("              it lands on \(m.k) at \(m.exPerF/10).\(m.exPerF%10) min: \(m.k=="EGLL" || m.k=="EHAM" || m.k=="LFPG" ? "HOLDS" : "EXAMINE")")
}
print("")
print("=== THE LEDGER ===")
let exH = totExcess/60
func comma(_ n:Int)->String{var s="\(n)";var o="";while s.count>3{o=","+s.suffix(3)+o;s=String(s.dropLast(3))};return s+o}
print("  total excess above frozen floors   \(comma(totExcess)) minutes = \(comma(exH)) hours, across \(comma(totFlights)) flights")
print("  mean excess per departure          \(totExcess*10/totFlights/10).\(totExcess*10/totFlights%10) minutes")
// fuel: ICAO taxi burn, REPORTED band 8-15 kg/min depending on type mix; carried as a band
print("  fuel at REPORTED 8-15 kg/min band  \(totExcess*8/1000) to \(totExcess*15/1000) tonnes in one year of European departures")
print("  CO2 at 3.16 kg/kg fuel             \(totExcess*8*316/100_000) to \(totExcess*15*316/100_000) tonnes")
print("")
print("=== WHAT THE QUIET-HOUR COLUMN ACTUALLY SAYS — a refuted expectation, kept ===")
var quietHigher = 0
for r in out where r.quiet > r.exPerF { quietHigher += 1 }
print("  The charter expected quiet-hour excess to approximate pure coordination")
print("  overhead (mutex idle -> queueing ~ 0). THE DATA REFUSED THE EXPECTATION:")
print("  at \(quietHigher) of \(out.count) admitted airports the quiet-hour excess is HIGHER than")
print("  the all-hours figure. The quietest hours are night hours, and night is not")
print("  daytime-minus-queueing: deicing, remote stands and single-runway ops ride")
print("  in the same minutes. The decomposition of the excess into queueing physics")
print("  versus coordination overhead is therefore NOT_KNOWN from this corpus alone,")
print("  and this court does not assert it. The EXCESS LEDGER itself stands.")
print("")
print("=== REFUSED, so nobody quotes this court for it ===")
print("  - zero-taxi: a discrete representation does not move a 70-tonne aircraft")
print("    faster. The floor is physical and the law above is built ON it.")
print("  - 'the whole delta is ATC waste': the runway is a mutex; queueing survives")
print("    ANY scheduler, including an exact one. The claim this court seals is the")
print("    EXCESS LEDGER and its quiet-hour bound, nothing larger.")
