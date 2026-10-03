// THE PROGRAM'S D-SHAPED SLICE — 16 integer vertices in mm, and one lattice cell.
// Lifted on 2026-10-03 from reproduce/fusion-affine-density-invariant.swift, which
// now reads it from here, so the script, the app and the Affine IDE hold one table.
//
// These are THIS PROGRAM'S OWN vertices. They are not a published ITER separatrix
// and not anyone's equilibrium. Their height (3,400 mm) over their half-width
// (2,000 mm) is a property of these sixteen numbers and is not quoted as any
// machine's elongation.
//
// Every area here is an exact integer determinant: no pi, no float, no rounding.
// Int64 is ample — the largest product is 2,050 x 3,400 — so nothing here needs
// Int128 and nothing carries an availability mark.

public enum DensitySlice {

    /// The D-shaped cross-section, counter-clockwise from the outboard midplane, mm.
    public static let vertices: [(x: Int64, y: Int64)] = [
        (2000, 0), (1850, 1300), (1400, 2400), (700, 3150), (-200, 3400), (-1100, 3150),
        (-1750, 2400), (-2000, 1300), (-2050, 0), (-2000, -1300), (-1750, -2400),
        (-1100, -3150), (-200, -3400), (700, -3150), (1400, -2400), (1850, -1300),
    ]

    /// One lattice cell, spanned by two integer vectors, mm.
    public static let v1: (x: Int64, y: Int64) = (240, 0)
    public static let v2: (x: Int64, y: Int64) = (17, 208)

    /// The 2x2 determinant p.x * q.y - p.y * q.x — exact.
    @inlinable
    public static func det(_ p: (x: Int64, y: Int64), _ q: (x: Int64, y: Int64)) -> Int64 {
        p.x * q.y - p.y * q.x
    }

    /// The determinant of edge i of the D, det(vertex i, vertex i+1): twice the signed
    /// area of the triangle from the origin to that edge. Summed over the 16 edges it
    /// is the shoelace sum — twice the D's area.
    public static func edgeDeterminant(_ i: Int) -> Int64 {
        let n = vertices.count
        return det(vertices[((i % n) + n) % n], vertices[(((i + 1) % n) + n) % n])
    }

    /// Twice the D's area, mm^2: |sum of the 16 edge determinants| = 44,265,000.
    public static var twiceArea: Int64 {
        var s: Int64 = 0
        for i in 0..<vertices.count { s += edgeDeterminant(i) }
        return s < 0 ? -s : s
    }

    /// The D's area, det(Lambda) of the slice, mm^2: 22,132,500 — one integer.
    public static var areaMm2: Int64 { twiceArea / 2 }

    /// The lattice cell's area |det(v1, v2)|, mm^2: 49,920.
    public static var cellDeterminant: Int64 {
        let d = det(v1, v2)
        return d < 0 ? -d : d
    }

    /// The classical circle the slice replaces: r^2 * piNum / piDen, FLOORED, mm^2.
    /// pi must be given as a ratio, because it cannot be written exactly; the court's
    /// bracket is FusionOperatingPointLaw.piLo / piHi. At r = 2,000 mm the two bounds
    /// give 12,566,037 and 12,566,371: the circle moves 334 mm^2 across the bracket,
    /// while areaMm2 does not move at all. nil for a non-positive radius or pi, or on
    /// Int64 overflow.
    public static func circleAreaFloorMm2(radiusMm r: Int64, piNum: Int64, piDen: Int64) -> Int64? {
        guard r > 0, piNum > 0, piDen > 0 else { return nil }
        let (r2, o1) = r.multipliedReportingOverflow(by: r)
        if o1 { return nil }
        let (p, o2) = r2.multipliedReportingOverflow(by: piNum)
        if o2 { return nil }
        return p / piDen
    }
}
