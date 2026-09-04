// LOCAL demonstration — a trained float model goes stale when the machine shifts;
// the exact invariant does not, and needs no training at all.
//
// The true rule is the exact Greenwald verdict: MISS iff 100*ne*a^2*355 >= 85*ip*1e6*113
// (pi ~ 355/113, all integer). A small logistic-regression model — a stand-in for a trained
// float controller — learns to predict it from one machine's operating regime, then is asked
// about a DIFFERENT machine it never trained on. This is a toy on synthetic data; it
// demonstrates the KIND of failure, it is not a measurement of any real vendor's system.
import Foundation

// ---- the exact invariant: the truth, no training, no float ----
func exactMiss(ne: Int, ip: Int, a: Int) -> Bool {
  100 * ne * a * a * 355 >= 85 * ip * 1_000_000 * 113
}

// deterministic pseudo-random (no Date/Math.random); integer LCG
var seed: UInt64 = 0x9E3779B97F4A7C15
func rnd() -> Double { seed = seed &* 6364136223846793005 &+ 1442695040888963407; return Double(seed >> 11) / Double(1 << 53) }
func inRange(_ lo: Int, _ hi: Int) -> Int { lo + Int(rnd() * Double(hi - lo)) }

// an operating point, sampled near that regime's own 0.85 boundary so labels are balanced
func sample(aLo: Int, aHi: Int, ipLo: Int, ipHi: Int) -> (ne: Int, ip: Int, a: Int, y: Int) {
  let a = inRange(aLo, aHi), ip = inRange(ipLo, ipHi)
  let nG = ip * 1_000_000 * 113 / (355 * a * a)     // this regime's Greenwald limit (1.0 point)
  let ne = Int(Double(nG) * (0.6 + 0.5 * rnd()))          // 0.60 .. 1.10 of n_G
  return (ne, ip, a, exactMiss(ne: ne, ip: ip, a: a) ? 1 : 0)
}

// ---- the trained float model: logistic regression on normalised features ----
// features x = [ne/1e6, ip/1e7, 1]; float weights, gradient descent. The model gets NO minor
// radius a — on one machine a is a fixed constant, so a single-machine-trained controller has
// no way to learn the boundary's a-dependence. That is the whole cross-machine failure.
func features(_ ne: Int, _ ip: Int, _ a: Int) -> [Double] { [Double(ne)/1e6, Double(ip)/1e7, 1] }
func sigmoid(_ z: Double) -> Double { 1/(1+exp(-z)) }
func train(_ data: [(ne:Int,ip:Int,a:Int,y:Int)], epochs: Int = 4000, lr: Double = 0.3) -> [Double] {
  var w = [Double](repeating: 0, count: 3)
  for _ in 0..<epochs {
    var g = [Double](repeating: 0, count: 3)
    for d in data { let x = features(d.ne,d.ip,d.a); let p = sigmoid(zip(w,x).map(*).reduce(0,+)); let e = p - Double(d.y)
      for i in 0..<3 { g[i] += e * x[i] } }
    for i in 0..<3 { w[i] -= lr * g[i] / Double(data.count) }
  }
  return w
}
func modelMiss(_ w: [Double], _ ne: Int, _ ip: Int, _ a: Int) -> Bool {
  sigmoid(zip(w, features(ne,ip,a)).map(*).reduce(0,+)) >= 0.5
}
func acc(_ verdict: (Int,Int,Int)->Bool, _ data: [(ne:Int,ip:Int,a:Int,y:Int)]) -> Double {
  var ok = 0; for d in data { if (verdict(d.ne,d.ip,d.a) ? 1:0) == d.y { ok += 1 } }
  return Double(ok)/Double(data.count)
}

// regime A: an ITER-like machine.   regime B: a DIII-D/SPARC-like smaller machine.
let trainA = (0..<3000).map { _ in sample(aLo:2000, aHi:2001, ipLo:10_000_000, ipHi:15_000_000) }
let testA  = (0..<3000).map { _ in sample(aLo:2000, aHi:2001, ipLo:10_000_000, ipHi:15_000_000) }
let testB  = (0..<3000).map { _ in sample(aLo:650, aHi:651, ipLo:10_000_000, ipHi:15_000_000) }

let wA = train(trainA)
print("=== a trained float model vs the exact invariant, as the MACHINE changes ===\n")
print(String(format:"  trained on machine A (ITER-like), tested on machine A held-out : model %5.1f%%  · exact %5.1f%%", 100*acc({modelMiss(wA,$0,$1,$2)}, testA), 100*acc({exactMiss(ne:$0,ip:$1,a:$2)}, testA)))
print(String(format:"  SAME model, now run on machine B (DIII-D/SPARC-like, unseen)   : model %5.1f%%  · exact %5.1f%%", 100*acc({modelMiss(wA,$0,$1,$2)}, testB), 100*acc({exactMiss(ne:$0,ip:$1,a:$2)}, testB)))
let wB = train(testB)   // the retraining treadmill: refit for B...
print(String(format:"  RETRAINED on machine B, then tested back on machine A          : model %5.1f%%  · exact %5.1f%%", 100*acc({modelMiss(wB,$0,$1,$2)}, testA), 100*acc({exactMiss(ne:$0,ip:$1,a:$2)}, testA)))
print("""

  READING (a toy model on synthetic data — the KIND of failure, not a vendor measurement)
   - The model is accurate only where it trained. Move to a machine it never saw and it
     decays toward a coin toss; retrain it there and it forgets the first machine. That is
     the retraining treadmill, and it never covers a regime it has not been trained on.
   - The exact invariant scores 100% on every regime with zero training. It cannot drift:
     there are no weights to go stale, and a machine it has never seen is just new integers
     it computes exactly. "Can it learn if something new happens?" — it does not need to.
  DRIFT_BARRIER_TRAINED_MODEL_STALE_INVARIANT_FIXED
""")
