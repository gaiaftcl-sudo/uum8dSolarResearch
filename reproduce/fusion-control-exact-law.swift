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

// ── THE FROZEN LAW ────────────────────────────────────────────────────────
// 14-bit signed ADC: counts in [-8192, 8191]. All bounds are integer counts.
let ADC_MIN = -8192, ADC_MAX = 8191
let ENVELOPE_ABS   = 6000   // |count| above this is outside the declared envelope
let GROWTH_WINDOW  = 8      // samples compared for mode growth
let GROWTH_TRIGGER = 900    // integer growth in |amplitude| across the window
let PERSIST        = 3      // consecutive windows required — one spike is not a mode

enum Verdict: String { case NOMINAL, MITIGATE, REFUSED_OUT_OF_ENVELOPE, REFUSED_MALFORMED }

// The whole law. Integer in, verdict out. No float, no interpolation, no model.
func verdict(_ counts:[Int]) -> (Verdict, Int, Int) {
    guard counts.count > GROWTH_WINDOW else { return (.REFUSED_MALFORMED, 0, 0) }
    for c in counts where c < ADC_MIN || c > ADC_MAX { return (.REFUSED_MALFORMED, 0, 0) }
    var run = 0, peakGrowth = 0, firstTrip = -1
    for i in GROWTH_WINDOW..<counts.count {
        let a = counts[i] < 0 ? -counts[i] : counts[i]
        let b = counts[i-GROWTH_WINDOW] < 0 ? -counts[i-GROWTH_WINDOW] : counts[i-GROWTH_WINDOW]
        // OUTSIDE THE DECLARED ENVELOPE THE LAW REFUSES. It does not extrapolate
        // a verdict from data it was never frozen against -- the exact behaviour
        // a statistical interpolator cannot offer, because it always returns a number.
        if a > ENVELOPE_ABS { return (.REFUSED_OUT_OF_ENVELOPE, i, a) }
        let g = a - b
        if g > peakGrowth { peakGrowth = g }
        if g >= GROWTH_TRIGGER {
            run += 1
            if firstTrip < 0 { firstTrip = i }
            if run >= PERSIST { return (.MITIGATE, firstTrip, peakGrowth) }
        } else { run = 0; firstTrip = -1 }
    }
    return (.NOMINAL, -1, peakGrowth)
}

// ── SYNTHETIC TRACES, integer counts only ────────────────────────────────
func quiescent(_ n:Int)->[Int]{ (0..<n).map{ i in ((i &* 2246822519) >> 22) % 140 - 70 } }
// NOTE, kept because the control arms caught it: the first versions of these
// generators produced values OUTSIDE the 14-bit ADC domain, so the malformed
// guard fired before the arm under test and two arms failed. The law was right
// and the TEST DATA was wrong — which is the arms doing exactly their job.
// Every generator below now stays inside [ADC_MIN, ADC_MAX] by construction.
func growingMode(_ n:Int)->[Int]{ (0..<n).map{ i in
    let env = i < 200 ? 60 : 60 + (i-200)*120            // integer linear growth, bounded
    return (i % 2 == 0 ? env : -env) } }
func singleSpike(_ n:Int)->[Int]{ var v=quiescent(n); if n>60 { v[60] = 3400 }; return v }
// high, FLAT drive: outside the declared envelope with no sustained growth, so
// it isolates the REFUSED terminal instead of tripping MITIGATE first.
func highOffset(_ n:Int)->[Int]{ (0..<n).map{ _ in 6500 } }

print("╔══ THE EXACT LAW, FROZEN ══╗")
print("  ADC domain           [\(ADC_MIN), \(ADC_MAX)]  (14-bit signed, as DIII-D acquires)")
print("  declared envelope    |count| <= \(ENVELOPE_ABS)")
print("  growth window        \(GROWTH_WINDOW) samples")
print("  growth trigger       \(GROWTH_TRIGGER) counts")
print("  persistence          \(PERSIST) consecutive windows")
print("  ARITHMETIC: integer add, subtract, compare. NOTHING ELSE.")
print("")

print("╔══ CONTROL ARMS — the law must be able to fail in every direction ══╗")
let cases:[(String,[Int],Verdict)] = [
  ("quiescent plasma",            quiescent(400),   .NOMINAL),
  ("growing tearing-mode shape",  growingMode(260), .MITIGATE),
  ("single spike, not a mode",    singleSpike(400), .NOMINAL),
  ("drive out of envelope",       highOffset(120),  .REFUSED_OUT_OF_ENVELOPE),
  ("malformed (too short)",       [1,2,3],          .REFUSED_MALFORMED),
]
var pass = 0
print("  \(pad("arm",32))\(pad("expected",26))\(pad("got",26))result")
for (n, trace, want) in cases {
    let (got, idx, peak) = verdict(trace)
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
let (v1,i1,p1) = verdict(growingMode(260))
let (v2,i2,p2) = verdict(growingMode(260))
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
