// STUDY 33 — the verdict STREAM emitter. Swift owns the law; the client only
// draws what the law produced. One law, one home — the client re-implements
// nothing, which is the whole point of the architecture.
//
// Emits: corpus/study-33/verdict-stream.json — a full shot's worth of 14-bit
// integer telemetry with the exact law's verdict at every control window.
import Foundation

// THE LAW IS NOT DEFINED HERE — it lives in app/FusionCourt/Sources/FusionLaw/
// and is compiled in alongside this file. A law written twice IS a hop; on
// 2026-09-02 this programme found it had written this one THREE times and the
// copies disagreed. Enforced by app/FusionCourt/Tools/one-law-one-home.sh.
let WINDOW = 256, SHOT = 12_000          // 12,000 samples = 6 ms at 2 MHz

func verdictAt(_ c:[Int32], _ end:Int) -> (String, Int) {
    let lo = max(0, end - WINDOW)
    let r = c[lo..<end].withUnsafeBufferPointer { FusionLaw.screen($0) }
    return (r.verdict.rawValue, r.peakGrowth)
}

// A shot: quiescent, then a tearing-mode precursor grows, integer-only.
var trace = [Int32](repeating: 0, count: SHOT)
for i in 0..<SHOT {
    let noise = ((i &* 2246822519) >> 22) % 120 - 60
    let env = i < 7000 ? 0 : (i - 7000) * 120      // integer growth ABOVE the 900/8-sample trigger
    let mode = (i % 2 == 0 ? env : -env)
    var v = noise + mode
    if v > LawConstants.adcMax { v = LawConstants.adcMax }; if v < LawConstants.adcMin { v = LawConstants.adcMin }
    trace[i] = Int32(v)
}

var rows:[String] = []
var firstMitigate = -1
var stride = 8
var i = WINDOW
while i < SHOT {
    let (v, p) = verdictAt(trace, i)
    if v == "MITIGATE" && firstMitigate < 0 { firstMitigate = i }
    rows.append("{\"i\":\(i),\"v\":\"\(v)\",\"peak\":\(p),\"amp\":\(abs(trace[i]))}")
    i += stride
}
let traceJSON = trace.enumerated().filter { $0.offset % 8 == 0 }.map { "\($0.element)" }.joined(separator: ",")
let json = """
{"schema":"affine.earth.study33.verdict_stream.v1",
 "law":{"adc_min":\(LawConstants.adcMin),"adc_max":\(LawConstants.adcMax),"envelope_abs":\(LawConstants.envelopeAbs),
        "growth_window":\(LawConstants.growthWindow),"growth_trigger":\(LawConstants.growthTrigger),"persist":\(LawConstants.persist)},
 "shot_samples":\(SHOT),"sample_rate_hz":2000000,"window":\(WINDOW),"stride":\(stride),
 "first_mitigate_index":\(firstMitigate),
 "first_mitigate_us":\(firstMitigate < 0 ? -1 : firstMitigate / 2),
 "trace_decimated_8x":[\(traceJSON)],
 "verdicts":[\(rows.joined(separator: ","))]}
"""
let dirs = ["corpus/study-33","../corpus/study-33","../../corpus/study-33"]
var wrote = false
for d in dirs {
    var isDir: ObjCBool = false
    if FileManager.default.fileExists(atPath: d, isDirectory: &isDir), isDir.boolValue {
        try? json.write(toFile: "\(d)/verdict-stream.json", atomically: true, encoding: .utf8)
        print("EMITTED \(d)/verdict-stream.json"); wrote = true; break
    }
}
if !wrote { print("corpus/study-33 not found from cwd — refusing to write a stray file") }
print("shot \(SHOT) samples = \(SHOT/2) us at 2 MHz")
print("verdict rows \(rows.count)")
print("FIRST MITIGATE at sample \(firstMitigate) = \(firstMitigate/2) us into the shot")
