// STUDY 33 — the figure, emitted BY THE LAW.
// A screenshot can drift from the code it depicts; a figure the law itself
// draws cannot. This reads the same verdict stream the client renders and
// writes images/study33-verdict-shot.svg — version-controlled, reproducible,
// and impossible to disagree with the verdict it shows.
import Foundation
func find(_ f:String)->String?{for c in ["corpus/study-33/\(f)","../corpus/study-33/\(f)","../../corpus/study-33/\(f)"]{if let s=try? String(contentsOfFile:c,encoding:.utf8){return s}};return nil}
guard let raw = find("verdict-stream.json"), let data = raw.data(using:.utf8),
      let j = try? JSONSerialization.jsonObject(with:data) as? [String:Any],
      let trace = j["trace_decimated_8x"] as? [Int],
      let verdicts = j["verdicts"] as? [[String:Any]],
      let law = j["law"] as? [String:Any] else { print("stream missing"); exit(1) }
let env = law["envelope_abs"] as? Int ?? 6000
let W = 1600, H = 420, mid = 210, pad = 56
let sc = Double(H/2 - 60) / 8192.0
func x(_ i:Int)->Int{ pad + i * (W - pad - 20) / max(trace.count-1,1) }
func y(_ v:Int)->Int{ mid - Int(Double(v) * sc) }

// verdict bands, from the law's own output
var bands = ""
var prev = "", start = 0
let colors = ["NOMINAL":"#132a18","MITIGATE":"#2e2410","REFUSED_OUT_OF_ENVELOPE":"#2d1416","REFUSED_MALFORMED":"#2d1416"]
for (n, v) in verdicts.enumerated() {
    let t = v["v"] as? String ?? ""
    if t != prev {
        if !prev.isEmpty, let c = colors[prev] {
            let x0 = pad + start*(W-pad-20)/verdicts.count, x1 = pad + n*(W-pad-20)/verdicts.count
            bands += "<rect x='\(x0)' y='20' width='\(x1-x0)' height='\(H-70)' fill='\(c)'/>"
        }
        prev = t; start = n
    }
}
if let c = colors[prev] {
    let x0 = pad + start*(W-pad-20)/verdicts.count
    bands += "<rect x='\(x0)' y='20' width='\(W-20-x0)' height='\(H-70)' fill='\(c)'/>"
}
var path = ""
for (i,v) in trace.enumerated() { path += (i==0 ? "M" : "L") + "\(x(i)) \(y(v)) " }
let mitIdx = verdicts.firstIndex { ($0["v"] as? String) == "MITIGATE" } ?? -1
let refIdx = verdicts.firstIndex { ($0["v"] as? String)?.hasPrefix("REFUSED") ?? false } ?? -1
var marks = ""
for (idx,lbl,col) in [(mitIdx,"MITIGATE","#e3b341"),(refIdx,"ENVELOPE BREACH","#f85149")] where idx >= 0 {
    let px = pad + idx*(W-pad-20)/verdicts.count
    let us = ((verdicts[idx]["i"] as? Int ?? 0)/2)
    marks += "<line x1='\(px)' y1='20' x2='\(px)' y2='\(H-50)' stroke='\(col)' stroke-width='2' stroke-dasharray='5,4'/>"
    marks += "<text x='\(px+6)' y='\(lbl=="MITIGATE" ? 44 : 62)' fill='\(col)' font-size='13' font-family='ui-monospace,monospace'>\(lbl) · \(us) µs</text>"
}
let lead = (mitIdx >= 0 && refIdx >= 0)
  ? ((verdicts[refIdx]["i"] as? Int ?? 0) - (verdicts[mitIdx]["i"] as? Int ?? 0))/2 : 0
let svg = """
<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 \(W) \(H)' width='\(W)' height='\(H)' role='img' aria-label='Study 33 fusion verdict shot'>
<rect width='\(W)' height='\(H)' fill='#0a0e14'/>
\(bands)
<line x1='\(pad)' y1='\(y(env))' x2='\(W-20)' y2='\(y(env))' stroke='#f85149' stroke-width='1.5' stroke-dasharray='7,7'/>
<line x1='\(pad)' y1='\(y(-env))' x2='\(W-20)' y2='\(y(-env))' stroke='#f85149' stroke-width='1.5' stroke-dasharray='7,7'/>
<text x='\(pad+4)' y='\(y(env)-8)' fill='#f85149' font-size='12' font-family='ui-monospace,monospace'>declared envelope ±\(env) counts</text>
<path d='\(path)' fill='none' stroke='#58a6ff' stroke-width='1.1'/>
\(marks)
<text x='\(pad)' y='\(H-22)' fill='#8b98a8' font-size='12' font-family='ui-monospace,monospace'>Study 33 · exact-integer mitigation law over 14-bit telemetry at 2 MHz · warning lead \(lead) µs before envelope breach</text>
<text x='\(pad)' y='\(H-6)' fill='#5f7285' font-size='11' font-family='ui-monospace,monospace'>green NOMINAL · amber MITIGATE · red REFUSED_OUT_OF_ENVELOPE — bands are the law's own verdicts, not annotations</text>
</svg>
"""
for d in ["images","../images","../../images"] where FileManager.default.fileExists(atPath:d) {
    try? svg.write(toFile:"\(d)/study33-verdict-shot.svg", atomically:true, encoding:.utf8)
    print("FIGURE \(d)/study33-verdict-shot.svg  \(svg.count) bytes")
    print("  warning lead \(lead) us before envelope breach")
    print("  as the page states it: \(lead) \u{b5}s"); exit(0)
}
print("images/ not found from cwd")
