// 65,536 agents in ONE Canvas: four accumulated Paths, four fills per frame.
// NOT 65,536 views — that would eat the machine and tell you nothing.
import SwiftUI

struct VerdictWall: View {
    let snapshot: ControlSnapshot
    private let side = 256

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("VERDICT WALL").font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(Palette.dim).tracking(1.2)
            Canvas { ctx, size in
                let n = max(snapshot.agentCount, 1)
                let cols = side
                let rows = max(1, (n + cols - 1) / cols)
                let cw = size.width / CGFloat(cols)
                let ch = size.height / CGFloat(rows)
                // Four paths, accumulated then filled once each.
                var paths: [Int: Path] = [0: Path(), 1: Path(), 2: Path(), 3: Path()]
                for d in snapshot.hottest {
                    let i = Int(d.channel)
                    let x = CGFloat(i % cols) * cw
                    let y = CGFloat(i / cols) * ch
                    let key = Int(d.terminal) > 3 ? 0 : Int(d.terminal)
                    paths[key]?.addRect(CGRect(x: x, y: y, width: max(cw, 1), height: max(ch, 1)))
                }
                for (k, p) in paths where !p.isEmpty {
                    ctx.fill(p, with: .color(Palette.forTerminal(UInt32(k))))
                }
            }
            .background(Palette.bg)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Palette.line))
            HStack(spacing: 14) {
                legend("NOMINAL", Palette.nominal, snapshot.terminals[0])
                legend("MITIGATE", Palette.mitigate, snapshot.terminals[1])
                legend("REFUSED env", Palette.refused, snapshot.terminals[2])
                legend("REFUSED mal", Palette.refused, snapshot.terminals[3])
            }
        }
        .padding(12).background(Palette.panel)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Palette.line))
    }
    private func legend(_ n: String, _ c: Color, _ v: UInt32) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2).fill(c).frame(width: 9, height: 9)
            Text("\(n) \(v)").font(.system(size: 10, design: .monospaced)).foregroundStyle(Palette.ink)
        }
    }
}
