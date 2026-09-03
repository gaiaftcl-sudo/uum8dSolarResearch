// STUDY 33 — running the exact law and measuring it.
//
// THE QUESTION: can an exact-integer verdict law sustain a real tokamak ADC
// rate? DIII-D magnetic probes sample at 2 MHz and the acquisition is quoted
// as 40 million 14-bit values per second. If an integer law keeps up with that
// on ordinary hardware, then batching is a consequence of the ARITHMETIC
// CHOICE, not of the data rate -- which is the claim under test.
//
// HONEST SCOPE, before any number: this is a commodity laptop, single-threaded,
// one channel, no I/O, no actuation, synthetic trace. It is NOT a control-
// hardware measurement and this page never calls it one. What it can settle is
// an ORDER OF MAGNITUDE against a published sampling rate.
import Foundation

// THE LAW IS NOT DEFINED HERE — it lives in app/FusionCourt/Sources/FusionLaw/
// and is compiled in alongside this file. A law written twice IS a hop; on
// 2026-09-02 this programme found it had written this one THREE times and the
// copies disagreed. Enforced by app/FusionCourt/Tools/one-law-one-home.sh.


// one full second of DIII-D-rate single-channel telemetry: 2,000,000 samples
let RATE = 2_000_000
var trace = [Int32](repeating: 0, count: RATE)
for i in 0..<RATE {                       // integer-only synthetic quiescent plasma
    trace[i] = Int32(((i &* 2246822519) >> 22) % 140 - 70)
}
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}

print("╔══ WHAT IS BEING MEASURED ══╗")
print("  one second of single-channel telemetry at the DIII-D magnetic-probe")
print("  rate: \(RATE) samples of 14-bit integer, evaluated by the frozen law.")
print("  Hardware: commodity laptop, single thread, no I/O. NOT control hardware.")
print("")

// warm up, then take the median of nine runs — one timing is not a measurement
var samples:[Double] = []
for _ in 0..<3 { _ = trace.withUnsafeBufferPointer { FusionLaw.screen($0) } }
for _ in 0..<9 {
    let t0 = DispatchTime.now().uptimeNanoseconds
    let v = trace.withUnsafeBufferPointer { FusionLaw.screen($0).verdict }
    let t1 = DispatchTime.now().uptimeNanoseconds
    precondition(v == .NOMINAL)
    samples.append(Double(t1 - t0))
}
samples.sort()
let medNs = samples[4]
let perSampleNs = medNs / Double(RATE)
let throughputMS = Double(RATE) / (medNs / 1_000_000.0)   // samples per millisecond

print("╔══ THE NUMBERS ══╗")
print("  median wall time, 2,000,000 samples   \(String(format:"%.2f", medNs/1_000_000)) ms   (9 runs, median)")
print("  per sample                            \(String(format:"%.2f", perSampleNs)) ns")
print("  sustained throughput                  \(String(format:"%.1f", throughputMS/1000)) million samples/second")
print("")
let headroom = throughputMS * 1000 / Double(RATE)
print("╔══ AGAINST THE PUBLISHED REQUIREMENT ══╗")
print("  DIII-D single-channel probe rate      2.0 million samples/second")
print("  this law sustains                     \(String(format:"%.1f", throughputMS/1000)) million samples/second")
print("  HEADROOM                              \(String(format:"%.1f", headroom))x real time, one thread")
print("")
let chans = Int(headroom)
print("  Read as channels: one core keeps up with roughly \(chans) simultaneous")
print("  2 MHz channels before saturating. DIII-D's quoted 40 million 14-bit")
print("  values per second is \(40_000_000/RATE) channels at this rate —")
print("  \(chans >= 20 ? "WITHIN reach of a single core" : "beyond one core; it needs \(20*RATE/Int(throughputMS*1000)) cores") .")
print("")

print("╔══ THE LATENCY THAT ACTUALLY MATTERS ══╗")
// decision latency on a control-sized window, not a whole second
let W = 256
var win = [Int32](repeating: 0, count: W)
for i in 0..<W { win[i] = Int32(i < 200 ? 60 : 60 + (i-200)*120) * (i % 2 == 0 ? 1 : -1) }
// FIRST ATTEMPT AT THIS MEASUREMENT RETURNED 0 ns, AND 0 IS NOT A SPEED.
// The result was discarded and the input never varied, so the optimiser hoisted
// the entire loop away. A benchmark that measures nothing reads exactly like a
// benchmark that measures something instant -- the always-green defect, in a
// timer. Fixed by (a) accumulating the verdict into a sink the compiler cannot
// prove unused, and (b) perturbing one sample per iteration so no call is
// redundant. The sink is printed so it cannot be dead-code eliminated.
var sink = 0
var ws:[Double] = []
let REPS = 20_000
for r in 0..<1000 { win[r % W] &+= 1; let rr = win.withUnsafeBufferPointer { FusionLaw.screen($0) }; let v = rr.verdict, i = rr.firstTrip
                    sink &+= i &+ (v == .MITIGATE ? 1 : 0); win[r % W] &-= 1 }
for _ in 0..<9 {
    let t0 = DispatchTime.now().uptimeNanoseconds
    for r in 0..<REPS {
        win[r % W] &+= 1
        let rr = win.withUnsafeBufferPointer { FusionLaw.screen($0) }; let v = rr.verdict, i = rr.firstTrip
        sink &+= i &+ (v == .MITIGATE ? 1 : 0)
        win[r % W] &-= 1
    }
    let t1 = DispatchTime.now().uptimeNanoseconds
    ws.append(Double(t1-t0)/Double(REPS))
}
ws.sort()
print("  verdict on a \(W)-sample control window   \(String(format:"%.0f", ws[4])) ns   (median of 9 x \(REPS), sink=\(sink))")
print("  = \(String(format:"%.4f", ws[4]/1_000_000)) milliseconds")
print("")
print("  FOR SCALE, and this is the whole point: published AI plasma-control")
print("  loops operate on a MILLISECOND cadence. This verdict renders in")
print("  \(String(format:"%.0f", ws[4])) nanoseconds -- about \(String(format:"%.0f", 1_000_000/ws[4]))x inside a single 1 ms budget.")
print("  The batching is therefore NOT forced by the sample rate. It is forced")
print("  by what the arithmetic costs. Change the arithmetic and the batch")
print("  disappears -- which is exactly the claim this study was built to test.")
print("")

print("╔══ DETERMINISM, checked not assumed ══╗")
var ok = true
let r0 = win.withUnsafeBufferPointer { FusionLaw.screen($0) }; let rv = r0.verdict, ri = r0.firstTrip
for _ in 0..<10_000 {
    let rr = win.withUnsafeBufferPointer { FusionLaw.screen($0) }; let v = rr.verdict, i = rr.firstTrip
    if v != rv || i != ri { ok = false; break }
}
print("  10,000 repeats, identical verdict and index   \(ok)")
print("  verdict rendered                              \(rv.rawValue) at index \(ri)")
print("  No accumulation, no normalisation, no gradient — nothing that could")
print("  differ across machines. The verdict is add, subtract, compare.")
print("")
// A TIMING IS A MEASUREMENT ON A DATE, NOT A REPRODUCIBLE CONSTANT. The wall
// numbers above differ run to run and machine to machine, so the harness cannot
// pin them as strings. What IS stable is the ORDER-OF-MAGNITUDE CLAIM, emitted
// here as a terminal the harness can check -- and it can fail.
let headroomOK = headroom >= 50
let latencyOK  = ws[4] < 100_000            // verdict well inside a 1 ms budget
print("╔══ THE STABLE TERMINALS — what the harness pins ══╗")
print("  HEADROOM_EXCEEDS_50X            \(headroomOK ? "TRUE" : "FALSE")")
print("  VERDICT_INSIDE_ONE_MS_BUDGET    \(latencyOK ? "TRUE" : "FALSE")")
print("  VERDICT_DETERMINISTIC_10K       \(ok ? "TRUE" : "FALSE")")
print("  These are claims, not timings. A slower machine still satisfies them or")
print("  the study is wrong -- which is what makes them checkable rather than")
print("  decorative. The wall numbers above are a dated measurement, not a")
print("  constant, and the page labels them that way.")
print("")
print("╔══ WHAT THESE NUMBERS DO NOT SAY ══╗")
print("  - not measured on control hardware, not through real I/O, no actuation")
print("  - one channel, one thread, synthetic trace, no reactor")
print("  - a real deployment adds acquisition, transport and actuator latency")
print("    that this benchmark does not touch and that will dominate it")
print("  What they DO settle: the ARITHMETIC is not the bottleneck, by orders of")
print("  magnitude. Whatever forces a millisecond batch, it is not integer cost.")
