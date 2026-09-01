// The public flourishing ledger, verified as exact rational arithmetic.
//
// Every domain the substrate serves declares three quantities:
//   entropy_bare      what the CONTINUOUS form costs — always greater than 1
//   entropy_delta     what adopting the exact form REMOVES
//   entropy_resolved  what remains
//
// The claim under test is that this is not a slogan but an identity:
//     bare - delta == resolved == 1/1
// One answer, replayable, with the excess removed exactly. If any row fails, the ledger
// is decorative and this program says so.
//
// Values read from https://affine.earth/language-invariant/games (lattice_courts.domains).
struct Q {
    var n: Int, d: Int
    init(_ n: Int, _ d: Int) {
        var a = abs(n), b = abs(d)
        while b != 0 { let t = a % b; a = b; b = t }
        let g = a == 0 ? 1 : a
        self.n = (d < 0 ? -n : n) / g; self.d = abs(d) / g
    }
    static func -(a: Q, b: Q) -> Q { Q(a.n * b.d - b.n * a.d, a.d * b.d) }
    static func ==(a: Q, b: Q) -> Bool { a.n == b.n && a.d == b.d }
    var s: String { "\(n)/\(d)" }
}

let rows: [(String, String, Q, Q, Q)] = [
    ("geometry", "volume is a count a regulator can replay",              Q(6,5), Q(1,5), Q(1,1)),
    ("chance",   "chance is Q; no float amplitude tax on consensus",      Q(5,4), Q(1,4), Q(1,1)),
    ("algebra",  "linking (q,r) is a table, not a spectral object",       Q(6,5), Q(1,5), Q(1,1)),
    ("physics",  "the appointment is clock + track + table",              Q(4,3), Q(1,3), Q(1,1)),
    ("qcd",      "no isolated color row; freedom is small dilation",      Q(4,3), Q(1,3), Q(1,1)),
    ("health",   "dose on a body is n/d; exponential PK is adversary",    Q(3,2), Q(1,2), Q(1,1)),
    ("finance",  "tick PnL; Black-Scholes PDE is extraction entropy",     Q(3,2), Q(1,2), Q(1,1)),
    ("cs",       "seals agree across cells; IEEE-754 is adversary",       Q(6,5), Q(1,5), Q(1,1)),
    ("fluids",   "sum Phi = 0; NS+RANS is not a certification court",     Q(4,3), Q(1,3), Q(1,1)),
]

print("=== the flourishing identity: bare - delta == resolved == 1/1 ===")
var pass = 0, fail = 0
for (d, why, bare, delta, resolved) in rows {
    let got = bare - delta
    let ok = (got == resolved) && (resolved == Q(1,1))
    var nm = d; while nm.count < 10 { nm += " " }
    print("  \(ok ? "PASS" : "FAIL")  \(nm) \(bare.s) - \(delta.s) = \(got.s)   \(why)")
    if ok { pass += 1 } else { fail += 1 }
}
print("")
print("=== control: the identity must be able to FAIL ===")
let bad = Q(7,5) - Q(1,5)
print("  a domain declaring bare 7/5 with delta 1/5 gives \(bad.s), not 1/1 — \(bad == Q(1,1) ? "NOT CAUGHT (broken)" : "correctly rejected")")

print("")
print("=== \(pass) resolve exactly · \(fail) fail ===")
print("SCOPE, stated: 9 of the 48 served domains declare an entropy triple. The other 39")
print("carry no entropy_delta and are NOT counted here. A flourishing ledger over 9 domains")
print("is what exists; a claim over 48 would be a claim about rows that are not there.")
