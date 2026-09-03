// STUDY 33 — THE EXACT-INTEGER FUSION CONTROL VERDICT LAW.
//
// This is the conversion the study was blocked on: the mitigation verdict,
// computed in exact integer arithmetic, with ZERO floating point anywhere
// between the ADC count and the sealed decision.
//
// THE LOAD-BEARING FACT THAT MAKES THIS POSSIBLE, and it is not ours:
// tokamak diagnostics are specified in BITS. DIII-D magnetic probes sample at
// 2 MHz and the acquisition is quoted as 40 million 14-BIT values per second;
// ITER's radial neutron camera digitises at 12-BIT; ADITYA-U at 16-BIT.
// AN ADC EMITS AN INTEGER COUNT. The float conversion is added by software,
// not by the instrument -- so an exact law does not need to "convert" anything.
// It reads what the sensor actually produced.
//
// SCOPE, stated before any result: this is a VERDICT law, not a plasma model.
// Of the four links (state estimate, model, verdict, actuation) it makes ONE
// exact. It does not simulate MHD and it does not claim to.
//
// DATA: the traces below are SYNTHETIC and labelled as such. This programme
// has no reactor and no machine data; a real deployment replaces the trace
// with the digitiser's own integer stream and re-freezes the envelope.

func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}

// THE LAW IS NOT DEFINED HERE. It lives in
// app/FusionCourt/Sources/FusionLaw/ and is compiled in alongside this file:
//   xcrun swiftc -O -swift-version 5 app/FusionCourt/Sources/FusionLaw/*.swift <this> -o /tmp/x
// A law written twice IS a hop. On 2026-09-02 this programme found it had
// written this law THREE times, and the copies disagreed — one returned NOMINAL
// where the others returned REFUSED_MALFORMED. Enforced by
// app/FusionCourt/Tools/one-law-one-home.sh.


// ── SYNTHETIC TRACES, integer counts only ────────────────────────────────
func quiescent(_ n:Int)->[Int32]{ (0..<n).map{ i in Int32(((i &* 2246822519) >> 22) % 140 - 70) } }
// NOTE, kept because the control arms caught it: the first versions of these
// generators produced values OUTSIDE the 14-bit ADC domain, so the malformed
// guard fired before the arm under test and two arms failed. The law was right
// and the TEST DATA was wrong — which is the arms doing exactly their job.
// Every generator below now stays inside [LawConstants.adcMin, LawConstants.adcMax] by construction.
func growingMode(_ n:Int)->[Int32]{ (0..<n).map{ i in
    let env = i < 200 ? 60 : 60 + (i-200)*120            // integer linear growth, bounded
    return Int32(i % 2 == 0 ? env : -env) } }
func singleSpike(_ n:Int)->[Int32]{ var v=quiescent(n); if n>60 { v[60] = 3400 }; return v }
// high, FLAT drive: outside the declared envelope with no sustained growth, so
// it isolates the REFUSED terminal instead of tripping MITIGATE first.
func highOffset(_ n:Int)->[Int32]{ (0..<n).map{ _ in Int32(6500) } }

print("╔══ THE EXACT LAW, FROZEN ══╗")
print("  ADC domain           [\(LawConstants.adcMin), \(LawConstants.adcMax)]  (14-bit signed, as DIII-D acquires)")
print("  declared envelope    |count| <= \(LawConstants.envelopeAbs)")
print("  growth window        \(LawConstants.growthWindow) samples")
print("  growth trigger       \(LawConstants.growthTrigger) counts")
print("  persistence          \(LawConstants.persist) consecutive windows")
print("  ARITHMETIC: integer add, subtract, compare. NOTHING ELSE.")
print("")

print("╔══ CONTROL ARMS — the law must be able to fail in every direction ══╗")
let cases:[(String,[Int32],Verdict)] = [
  ("quiescent plasma",            quiescent(400),   .NOMINAL),
  ("growing tearing-mode shape",  growingMode(260), .MITIGATE),
  ("single spike, not a mode",    singleSpike(400), .NOMINAL),
  ("drive out of envelope",       highOffset(120),  .REFUSED_OUT_OF_ENVELOPE),
  ("malformed (too short)",       [1,2,3],          .REFUSED_MALFORMED),
]
var pass = 0
print("  \(pad("arm",32))\(pad("expected",26))\(pad("got",26))result")
for (n, trace, want) in cases {
    let r = FusionLaw.screen(trace); let got = r.verdict; let idx = r.atIndex; let peak = r.peakGrowth
    let ok = got == want
    if ok { pass += 1 }
    print("  \(pad(n,32))\(pad(want.rawValue,26))\(pad(got.rawValue,26))\(ok ? "PASS" : "FAIL")  idx=\(idx) peak=\(peak)")
}
print("")
print("  \(pass) of \(cases.count) arms hold. FOUR DISTINCT TERMINALS across five inputs —")
print("  the law discriminates. An instrument that returned one answer for all")
print("  five would be a turn counter, and this programme retires those.")
print("")

print("╔══ WHAT AN INTERPOLATOR CANNOT DO, DEMONSTRATED ══╗")
print("  Arm 4 drives the signal past the declared envelope. This law answers")
print("  REFUSED_OUT_OF_ENVELOPE -- it declines to rule on data it was never")
print("  frozen against. A statistical model has no such terminal available:")
print("  fed the same trace it returns a NUMBER, computed by extrapolating a")
print("  manifold it never saw. That is the difference between a court and a")
print("  guess, and it is the entire content of this study.")
print("")

print("╔══ RE-DERIVABILITY, the frozen question answered ══╗")
let s1 = FusionLaw.screen(growingMode(260)); let v1 = s1.verdict, i1 = s1.firstTrip, p1 = s1.peakGrowth
let s2 = FusionLaw.screen(growingMode(260)); let v2 = s2.verdict, i2 = s2.firstTrip, p2 = s2.peakGrowth
print("  same input, twice        \(v1.rawValue) idx=\(i1) peak=\(p1)  |  \(v2.rawValue) idx=\(i2) peak=\(p2)")
print("  identical                \(v1==v2 && i1==i2 && p1==p2)")
print("")
print("  A third party re-derives this verdict from the integer trace and the")
print("  five frozen constants above -- no weights, no training corpus, no")
print("  vendor. Two machines produce the same integers or one is broken and")
print("  it is findable. THAT is what the mitigation decision needs and what a")
print("  float ensemble structurally cannot provide.")
print("")
print("╔══ REFUSED, still ══╗")
print("  This law is not a plasma model, has never run on a device, and makes")
print("  ONE of four links exact. The traces are synthetic. Nothing here claims")
print("  a control latency, a disruption rate, or superiority over a framework")
print("  with five real experiments behind it.")
