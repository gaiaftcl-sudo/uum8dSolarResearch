typealias M8 = [[Int64]]
func ident() -> M8 { (0..<8).map { i in (0..<8).map { j in i == j ? Int64(1) : Int64(0) } } }
func mul(_ a: M8, _ b: M8) -> M8 {
    var r = (0..<8).map { _ in [Int64](repeating: 0, count: 8) }
    for i in 0..<8 { for k in 0..<8 where a[i][k] != 0 { for j in 0..<8 { r[i][j] &+= a[i][k] &* b[k][j] } } }
    return r
}
func shear(_ t: Int, _ s: Int, _ c: Int64) -> M8 { var e = ident(); e[t][s] = c; return e }
func detBareiss(_ m0: M8) -> Int64 {
    var m = m0, sign: Int64 = 1, prev: Int64 = 1
    for k in 0..<7 {
        if m[k][k] == 0 {
            var sw = -1
            for i in (k+1)..<8 where m[i][k] != 0 { sw = i; break }
            if sw < 0 { return 0 }
            m.swapAt(k, sw); sign = -sign
        }
        for i in (k+1)..<8 { for j in (k+1)..<8 { m[i][j] = (m[i][j] &* m[k][k] &- m[i][k] &* m[k][j]) / prev } }
        prev = m[k][k]
    }
    return sign &* m[7][7]
}
func points() -> [[Int64]] {
    var v: [[Int64]] = []
    for a in 0..<10 { for b in 0..<10 { for c in 0..<10 { for e in 0..<4 {
        v.append([Int64(a), Int64(b), Int64(c), Int64(e), Int64(a &- b), Int64(b &- c), Int64(c &- e), Int64(a &+ e)])
    } } } }
    return v
}
func apply(_ M: M8, _ v: [Int64]) -> [Int64] {
    var w = [Int64](repeating: 0, count: 8)
    for i in 0..<8 { var s: Int64 = 0; for j in 0..<8 { s &+= M[i][j] &* v[j] }; w[i] = s }
    return w
}
func key(_ v: [Int64]) -> String { v.map(String.init).joined(separator: ",") }

// ARM A: image count (detects INJECTIVITY only)
func imageCount(_ M: M8) -> Int { Set(points().map { key(apply(M, $0)) }).count }

// ARM B: integral round-trip through the inverse (detects UNIMODULARITY)
// Solve M x = e_i over the rationals by Gaussian elimination on Int64 fractions:
// instead, test surjectivity directly — is each standard basis vector in the image lattice?
// Equivalent and cheaper: det = +/-1  <=>  adjugate/det is integral. We test by
// checking whether M maps ONTO a full-density region: count images landing in a box
// versus lattice points of that box.
func ontoDensity(_ M: M8, half: Int64) -> (hits: Int, boxed: Int) {
    // count how many images of a large source cube land inside the target box,
    // against how many integer points the box contains along the first 3 axes
    var hits = 0
    let src = points()
    for v in src {
        let w = apply(M, v)
        if w.allSatisfy({ $0 >= -half && $0 <= half }) { hits += 1 }
    }
    return (hits, src.count)
}

var U = ident()
for (t, s, c) in [(0,1,3),(2,0,-1),(4,3,2),(1,5,-4),(6,2,1),(7,6,5),(3,7,-2),(5,4,3),(2,6,-1),(0,7,2)] as [(Int,Int,Int64)] {
    U = mul(shear(t, s, c), U)
}
var D2 = ident(); D2[0][0] = 2                      // det = 2: injective, NOT onto Z^8
var SING = ident(); SING[3] = SING[2]               // two equal rows -> det = 0

print("=== ARM A — image count (detects injectivity) ===")
for (n, M) in [("unimodular det=1", U), ("det=2 scaling", D2), ("singular det=0", SING)] {
    print("  \(n): det=\(detBareiss(M))  distinct_images=\(imageCount(M)) of 4000")
}
print()
print("=== ARM B — is e_1 = (1,0,0,0,0,0,0,0) in the image lattice? (detects unimodularity) ===")
// e_1 has an integral preimage under M iff M^-1 e_1 is integral. For det=+/-1 always true.
// Test by brute preimage search over a bounded box for the det=2 case on axis 0.
for (n, M) in [("unimodular det=1", U), ("det=2 scaling", D2)] {
    let d = detBareiss(M)
    // For D2, column 0 is doubled: any image has even first coordinate -> e_1 unreachable.
    var parityHit = false
    for v in points() where apply(M, v)[0] == 1 { parityHit = true; break }
    print("  \(n): det=\(d)  e_1 reachable in sample = \(parityHit)")
}
print()
print("=== the discrimination the page needs ===")
let (h1, n1) = ontoDensity(U, half: 100)
let (h2, _)  = ontoDensity(D2, half: 100)
print("  images inside a +/-100 box: unimodular=\(h1)  det2=\(h2)  of \(n1)")
