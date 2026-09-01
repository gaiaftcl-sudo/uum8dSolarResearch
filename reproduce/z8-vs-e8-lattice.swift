// Z^8 (the lattice the substrate actually uses) vs E8, by exact integer enumeration.
// Coordinates DOUBLED so the half-integer E8 vectors stay integral: x -> 2x.
// Under doubling, norm N -> 4N, so E8 minimal norm 2 becomes 8, Z^8 minimal norm 1 becomes 4.

func kissingZ8() -> Int {
    // minimal vectors of Z^8: norm 1 -> doubled norm 4 -> (+-2, 0,...)
    var c = 0
    for i in 0..<8 { for s in [-2, 2] { _ = i; _ = s; c += 1 } }
    return c
}

func kissingE8() -> Int {
    // E8 = { x in Z^8 union (Z+1/2)^8 : sum x_i even }.  Doubled: all coords same parity,
    // integer-class coords even, half-integer-class coords odd; sum of ORIGINAL coords even.
    var count = 0
    // class A: doubled coords in {-2,0,2}, exactly two nonzero  (originals +-1,+-1)
    for i in 0..<8 { for j in (i+1)..<8 {
        for si in [-2, 2] { for sj in [-2, 2] {
            var v = [Int](repeating: 0, count: 8); v[i] = si; v[j] = sj
            let norm = v.reduce(0) { $0 + $1*$1 }                 // doubled norm
            let sumOrig = v.reduce(0, +) / 2                       // original coord sum
            if norm == 8 && sumOrig % 2 == 0 { count += 1 }
        } }
    } }
    // class B: all doubled coords +-1 (originals +-1/2), sum of originals even
    for mask in 0..<256 {
        var v = [Int](repeating: 0, count: 8)
        for b in 0..<8 { v[b] = (mask >> b) & 1 == 1 ? -1 : 1 }
        let norm = v.reduce(0) { $0 + $1*$1 }                      // = 8 always
        // original sum = (sum of doubled)/2 ; needs to be an even integer
        let s = v.reduce(0, +)
        if norm == 8 && s % 4 == 0 { count += 1 }
    }
    return count
}

print("=== kissing number, by exact enumeration ===")
print("  Z^8 : \(kissingZ8())")
print("  E8  : \(kissingE8())")
print("")
print("=== packing density ratio, EXACT ===")
// Both are unimodular (covolume 1). Packing radius = half the minimal distance.
// Z^8 min distance 1 -> r = 1/2.   E8 min norm 2 -> min distance sqrt2 -> r = sqrt2/2.
// ratio = (sqrt2/2)^8 / (1/2)^8 = (sqrt2)^8 = 2^4
print("  both lattices are unimodular: covolume 1")
print("  Z^8 minimal norm 1 -> minimal distance 1")
print("  E8  minimal norm 2 -> minimal distance sqrt(2)")
print("  density ratio = (sqrt2)^8 = 2^4 = \(1 << 4)  — EXACTLY 16x, an integer")
print("")
print("  So in the SAME dimension, at the SAME covolume, E8 packs 16x denser")
print("  and touches \(kissingE8() / kissingZ8())x as many neighbours.")
