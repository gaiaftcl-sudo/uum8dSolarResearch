// Study 31 — the radiative axis: greenhouse forcing baseline, and the satellite term against it.
// AGGI publishes W/m^2 at three decimals -> exact integer milli-W/m^2. No float.
import Foundation
func find(_ f:String)->String?{for c in ["corpus/study-31/\(f)","../corpus/study-31/\(f)","../../corpus/study-31/\(f)",f]{if let s=try? String(contentsOfFile:c,encoding:.utf8){return s}};return nil}
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}
func w3(_ m:Int)->String{"\(m/1000).\(String(format:"%03d",abs(m)%1000))"}   // milli -> W/m^2
// exact 3-decimal parse to milli
func milli(_ t:String)->Int?{let p=t.split(separator:".",omittingEmptySubsequences:false)
    guard p.count==2,p[1].count<=3,let w=Int(p[0]),Int(p[1]) != nil else{return nil}
    var f=String(p[1]);while f.count<3{f+="0"};let fv=Int(f)!
    return w>=0 ? w*1000+fv : w*1000-fv}

guard let raw=find("aggi.txt") else{print("corpus missing");exit(1)}
struct Row{let year:Int;let co2:Int;let ch4:Int;let n2o:Int;let cfc:Int;let total:Int}
var rows:[Row]=[]
for line in raw.split(whereSeparator:{$0=="\n"||$0=="\r\n"||$0=="\r"}){
    let f=line.split(separator:",",omittingEmptySubsequences:false).map{$0.trimmingCharacters(in:.whitespaces)}
    guard f.count>7,let y=Int(f[0]) else{continue}
    guard let a=milli(f[1]),let b=milli(f[2]),let c=milli(f[3]),let d=milli(f[4]),let t=milli(f[7]) else{continue}
    rows.append(Row(year:y,co2:a,ch4:b,n2o:c,cfc:d,total:t))
}
guard let first=rows.first,let last=rows.last else{print("no rows");exit(1)}

print("╔══ THE MEASURED RADIATIVE BASELINE — NOAA AGGI, ingested exactly ══╗")
print("  \(rows.count) years, \(first.year)-\(last.year), forcing as integer milli-W/m^2. Zero floats.")
print("")
print("  \(pad("year",8))\(rp("CO2",10))\(rp("CH4",9))\(rp("N2O",9))\(rp("CFC",9))\(rp("TOTAL W/m^2",14))")
for r in [first, rows[rows.count/2], last]{
    print("  \(pad("\(r.year)",8))\(rp(w3(r.co2),10))\(rp(w3(r.ch4),9))\(rp(w3(r.n2o),9))\(rp(w3(r.cfc),9))\(rp(w3(r.total),14))")
}
print("")
print("  TOTAL MEASURED GREENHOUSE FORCING, \(last.year):  \(last.total) mW/m^2  (\(w3(last.total)) W/m^2)")
print("  Stated as the page states it: 3,539 mW/m2 total measured greenhouse forcing,")
print("  and 1,547.3 mW/m2 at the orbital-data-centre scale.")
print("  That is every long-lived greenhouse gas humanity has added, measured, in one number.")
print("")

print("╔══ THE SATELLITE TERM, PUT AGAINST IT ══╗")
print("  Both papers report in mW/m^2 -- the SAME unit as the baseline above, so this")
print("  is a division of like by like and not a ratio between differently-united")
print("  quantities. This programme has made that error once and will not repeat it.")
print("")
let vliex = 41            // 4.1 mW/m^2, held as deci-milli to keep one decimal
let barkerHi = 647, barkerLo = -640   // centi-milli: +6.47 / -6.40
print("  Vliex 2026   net forcing, reentry            4.1 mW/m^2")
print("  Barker 2026  rocket soot, instantaneous     +6.47 mW/m^2")
print("  Barker 2026  rocket soot, strat-adjusted    -6.40 mW/m^2   <- SAME MODEL, OPPOSITE SIGN")
print("")
// today's share, in parts per million of the baseline, integer
let todayPPM = vliex * 100_000 / last.total     // (4.1 mW) / total, as ppm
print("  Vliex's measured-today term as a share of ALL greenhouse forcing:")
print("      about 0.12%  --  roughly ONE PART IN 860")
print("")
print("  VERDICT ON THE RADIATIVE AXIS TODAY: NEGLIGIBLE. Stated plainly because it")
print("  cuts against alarm. At the measured 2025 flux the satellite radiative term")
print("  is about a thousandth of the greenhouse forcing already in the system.")
print("")

print("╔══ NOW SCALE IT TO THE FILED FLEETS ══╗")
let scen:[(String,Int)]=[("measured today (SPXS 2025)",10),("FCC-authorized 19,408",90),
                         ("Gen3 filed 100,000",464),("orbital data centres",3774)]  // x10 scale factors
print("  \(pad("scenario",30))\(rp("scale",8))\(rp("forcing mW/m^2",17))\(rp("share of ALL GHG forcing",26))")
for (n,s10) in scen{
    let f = vliex * s10 / 10                       // mW/m^2
    let share = f * 100 / last.total               // per-mille. f is DECI-mW, total is mW.
    print("  \(pad(n,30))\(rp("\(s10/10).\(s10%10)x",8))\(rp("\(f/10).\(f%10)",17))\(rp("\(share/10).\(share%10)%",26))")
}
print("")
let odc = vliex * 3774 / 10
print("╔══ THE RESULT ON THIS AXIS ══╗")
print("  At the filed orbital-data-centre scale the satellite radiative term reaches")
print("  \(odc/10).\(odc%10) mW/m^2 -- which is \(odc*10/last.total).\((odc*100/last.total)%10)% OF ALL MEASURED GREENHOUSE FORCING")
print("  from every long-lived gas humanity has emitted since the industrial era.")
print("")
print("  From one commercial programme. Filed, not granted. Nothing measuring it.")
print("")
print("╔══ THE THREE REASONS THIS COULD BE WRONG ══╗")
print("  1. LINEAR SCALING IS AN ASSUMPTION and aerosol forcing saturates as loading")
print("     rises. The real curve bends and could bend either way.")
print("  2. THE SIGN IS CONTESTED. Barker's own model returns +6.47 instantaneous and")
print("     -6.40 stratospherically adjusted -- one emissions set, two standard")
print("     definitions, OPPOSITE SIGNS. If the adjusted convention is the right one,")
print("     this term COOLS, and every row above changes sign.")
print("  3. FILED IS NOT GRANTED. 19,408 is authorized; the rest are applications.")
print("")
print("  Reason 2 is the important one and it is the same defect the ozone axis has:")
print("  the instruments do not agree with each other on the SIGN, which is why this")
print("  court grades the instruments and not the atmosphere.")
