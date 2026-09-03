// Cross-machine determinism, made checkable in one number.
//
// The whole architectural claim is that a verdict is an exact integer any
// machine re-derives IDENTICALLY. Property claims are cheap; a digest is not.
// This runs BOTH laws over a large fixed corpus and prints a sha256 of every
// verdict. The digest is pinned in the repo. If your machine prints a different
// digest, the law diverged on your hardware — which is exactly the bug this
// architecture exists to make impossible, and we want to hear about it.
#if compiler(>=6.0)
import Foundation
import CryptoKit

var blob = ""

// 1. the streaming disruption law over a deterministic sweep of traces
let W = 256
for seed in 0..<400 {
    var t = [Int32](repeating: 0, count: W)
    for i in 0..<W {
        let noise = Int(((seed &* 2654435761 &+ i &* 40503) >> 13) % 240) - 120
        let onset = 40 + (seed % 180)
        let env = i < onset ? 0 : (i - onset) * (40 + seed % 200)
        var v = noise + (i % 2 == 0 ? env : -env)
        if seed % 53 == 0 && i == seed % W { v = 30000 }   // some malformed
        t[i] = Int32(clamping: v)
    }
    let r = t.withUnsafeBufferPointer { FusionLaw.screen($0) }
    blob += "\(r.verdict.rawValue):\(r.firstTrip):\(r.peakGrowth):\(r.atIndex)\n"
}

// 2. the operating-point court over a deterministic parameter grid
for ip in stride(from: Int64(0), through: 20_000_000, by: 2_500_000) {
    for a in stride(from: Int64(400), through: 6000, by: 800) {
        for ne in stride(from: Int64(200_000), through: 9_000_000, by: 1_100_000) {
            for bn in [Int64(1800), 2500] {
                for qm in [Int64(1500), 3000] {
                    let v = FusionOperatingPointLaw.grade(OperatingEnvelope(
                        ne14: ne, ipAmp: ip, minorRadiusMm: a, betaNMilli: bn, qMinMilli: qm))
                    blob += "\(v.verdict)|\(v.bindingBranch?.rawValue ?? "-")|\(v.piIndependent)\n"
                }
            }
        }
    }
}

let digest = SHA256.hash(data: Data(blob.utf8)).map { String(format: "%02x", $0) }.joined()
let lines = blob.split(separator: "\n").count
print("=== FUSION DETERMINISM DIGEST ===")
print("  corpus: 400 streaming traces + a \(lines - 400)-point operating-point grid = \(lines) verdicts")
print("  VERDICT DIGEST (sha256): \(digest)")
print("")
print("  This digest is the same on every machine, because every verdict is an")
print("  exact integer comparison — no float, no accumulation, no platform math.")
print("  A different digest on your machine means the law diverged, which is the")
print("  failure this architecture exists to make impossible.")
#endif
