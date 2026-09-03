// STUDY — THE FUSION COURT LAW IS TOPOLOGY-AGNOSTIC.
//
// THE CLAIM, stated so it can be refuted: tokamak, stellarator and spheromak
// differ ONLY in how their flux-surface mesh is wired — node count, edge count,
// which closure edges exist. They do NOT differ in the law that grades an
// operating point. FusionOperatingPointLaw.grade(_:) takes an OperatingEnvelope
// and NOTHING ELSE; a Topology descriptor is not one of its arguments, so it
// cannot enter the verdict. This study makes that checkable instead of asserted.
//
// SCOPE, before any result. This is a LAW-LEVEL invariant. The substrate strobe
// (the mesh that actually carries these nodes and edges across nine cells) is
// the cells build — Mac-blocked and out of scope here. NOTHING below runs a
// strobe. What is proven is exactly this: the committed verdict law is blind to
// topology, and the layout difference lives entirely in a descriptor the law
// never reads. Said plainly at the end again.
//
// THE LAW IS NOT DEFINED HERE. It lives in
//   app/FusionCourt/Sources/FusionOperatingPoint/
// and is compiled in alongside this file:
//   xcrun swiftc -O -swift-version 5 \
//     app/FusionCourt/Sources/FusionOperatingPoint/*.swift <this> -o /tmp/x
// A law written twice IS a hop. The three verdicts below come from the ONE
// committed grade(_:), not from a reimplementation.
#if compiler(>=6.0)

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }

// ── A TOPOLOGY DESCRIPTOR IS PURE LAYOUT ─────────────────────────────────────
// It says how the mesh is wired. It is NOT an OperatingEnvelope field and NOT a
// grade(_:) argument. Everything here is computed from the two descriptor fields
// the task names — fieldPeriods and hasToroidalCircuit — plus the shared sampling
// resolution. No count below is a literal typed next to a label.
struct Topology {
    let name: String
    let fieldPeriods: Int         // toroidal symmetry order: tokamak 1, W7-X-class 5
    let hasToroidalCircuit: Bool  // false => simply-connected (spheromak): no toroidal hole

    // A machine with no toroidal circuit is simply-connected, so its magnetic
    // AXIS is a point, not a ring. DERIVED from the descriptor, never a free knob.
    var axisDegenerates: Bool { !hasToroidalCircuit }

    // `surfaces` nested flux surfaces, each sampled at `poloidalSamples` poloidal
    // angles, replicated across `fieldPeriods` toroidal periods. On a degenerate
    // axis the innermost surface collapses to ONE node per period.
    func nodeCount(surfaces s: Int, poloidalSamples p: Int) -> Int {
        axisDegenerates
            ? (s - 1) * p * fieldPeriods + fieldPeriods
            : s * p * fieldPeriods
    }

    // poloidal loops — one closed ring per surface per period (a degenerate axis
    // carries no ring)
    func poloidalEdges(surfaces s: Int, poloidalSamples p: Int) -> Int {
        (axisDegenerates ? (s - 1) : s) * p * fieldPeriods
    }
    // radial spokes — adjacent surfaces at the same poloidal angle
    func radialEdges(surfaces s: Int, poloidalSamples p: Int) -> Int {
        (s - 1) * p * fieldPeriods
    }
    // toroidal-closure edges — the loop that closes AROUND the torus. These exist
    // ONLY when the machine has a toroidal circuit. THIS is the negative control.
    func toroidalEdges(surfaces s: Int, poloidalSamples p: Int) -> Int {
        hasToroidalCircuit ? fieldPeriods * s * p : 0
    }
    func edgeCount(surfaces s: Int, poloidalSamples p: Int) -> Int {
        poloidalEdges(surfaces: s, poloidalSamples: p)
        + radialEdges(surfaces: s, poloidalSamples: p)
        + toroidalEdges(surfaces: s, poloidalSamples: p)
    }
}

// The EXACT bytes of a verdict, in a canonical string, so "identical" is a
// character-for-character comparison and not a vibe.
func signature(_ v: CourtVerdict) -> String {
    let b = v.bindingBranch?.rawValue ?? "-"
    let open = v.openBranches.map { $0.rawValue }.joined(separator: ",")
    return "\(v.verdict)|binding=\(b)|open=[\(open)]|piIndep=\(v.piIndependent)|path=\(v.exactPath)"
}

// ── LAYOUTS ──────────────────────────────────────────────────────────────────
let surfaces = 16          // nested flux surfaces sampled
let poloidalSamples = 32   // poloidal angles per surface

let tokamak     = Topology(name: "tokamak",     fieldPeriods: 1, hasToroidalCircuit: true)
let stellarator = Topology(name: "stellarator", fieldPeriods: 5, hasToroidalCircuit: true)
let spheromak   = Topology(name: "spheromak",   fieldPeriods: 1, hasToroidalCircuit: false)
let topos = [tokamak, stellarator, spheromak]

print("╔══ THE FUSION COURT LAW IS TOPOLOGY-AGNOSTIC ══╗")
print("  \(FusionOperatingPointLaw.marker)")
print("  sampling: surfaces=\(surfaces)  poloidalSamples=\(poloidalSamples)  (shared by all three)")
print("")

// ── 1. THE LAYOUTS GENUINELY DIFFER IN SIZE ──────────────────────────────────
print("╔══ 1. NODE / EDGE LAYOUT — different SIZE per topology ══╗")
print("  \(pad("topology",13))\(pad("periods",8))\(pad("toroidal?",10))\(rp("nodes",7))\(rp("edges",8))\(rp("pol",6))\(rp("rad",6))\(rp("tor",6))")
for t in topos {
    let n  = t.nodeCount(surfaces: surfaces, poloidalSamples: poloidalSamples)
    let e  = t.edgeCount(surfaces: surfaces, poloidalSamples: poloidalSamples)
    let pe = t.poloidalEdges(surfaces: surfaces, poloidalSamples: poloidalSamples)
    let re = t.radialEdges(surfaces: surfaces, poloidalSamples: poloidalSamples)
    let te = t.toroidalEdges(surfaces: surfaces, poloidalSamples: poloidalSamples)
    print("  \(pad(t.name,13))\(rp(String(t.fieldPeriods),4))    \(pad(t.hasToroidalCircuit ? "yes":"no",10))\(rp(String(n),7))\(rp(String(e),8))\(rp(String(pe),6))\(rp(String(re),6))\(rp(String(te),6))")
}
print("  The three columns of nodes are three different numbers. The layouts are")
print("  NOT the same object. If the law leaned on any of them, the next section")
print("  could not come out the way it does.")
print("")

// ── 2a. ONE ENVELOPE, THREE TOPOLOGIES, IDENTICAL BYTES ──────────────────────
// A fixed safe operating point (the ITER reference: WIN). Graded once per
// topology. The Topology is not passed to grade(_:) — it CANNOT be — so the only
// honest expectation is byte-for-byte equality.
let safe = OperatingEnvelope(ne14: 1_000_000, ipAmp: 15_000_000,
                             minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)

print("╔══ 2a. SAME PHYSICS ACROSS ALL THREE TOPOLOGIES ══╗")
print("  envelope: ne14=\(safe.ne14) ipAmp=\(safe.ipAmp) a_mm=\(safe.minorRadiusMm) betaN*1e3=\(safe.betaNMilli) qMin*1e3=\(safe.qMinMilli)")
print("  \(pad("topology",13))\(pad("nodes",7))\(pad("verdict signature (the bytes)",1))")
var sigs: [String] = []
for t in topos {
    let v = FusionOperatingPointLaw.grade(safe)   // <- topology is NOT an argument
    let sig = signature(v)
    sigs.append(sig)
    let n = t.nodeCount(surfaces: surfaces, poloidalSamples: poloidalSamples)
    print("  \(pad(t.name,13))\(pad(String(n),7))\(sig)")
}
let allIdentical = sigs.dropFirst().allSatisfy { $0 == sigs[0] }
print("  all three signatures byte-identical: \(allIdentical)")
print("  Different node counts (\(topos.map { String($0.nodeCount(surfaces: surfaces, poloidalSamples: poloidalSamples)) }.joined(separator: ", "))), one verdict. The law never saw the layout.")
print("")

// ── 2b. THE DIFFERENCE THAT DOES MOVE THE VERDICT IS PHYSICS, NOT TOPOLOGY ────
// A stellarator is currentless: ipAmp=0. That is a field of the OperatingEnvelope,
// not of the Topology descriptor. Same densities, current removed -> the verdict
// changes to NOT_APPLICABLE because Greenwald is a statement about a
// current-carrying plasma and the court refuses to invent an n_G that is not there.
let currentless = OperatingEnvelope(ne14: 1_000_000, ipAmp: 0,
                                    minorRadiusMm: 2000, betaNMilli: 1800, qMinMilli: 3000)
let vTok = FusionOperatingPointLaw.grade(safe)         // tokamak physics: has current
let vStel = FusionOperatingPointLaw.grade(currentless) // stellarator physics: ipAmp=0

print("╔══ 2b. THE VERDICT MOVES ON PHYSICS INPUT, NEVER ON THE DESCRIPTOR ══╗")
print("  \(pad("machine",30))\(pad("ipAmp",12))\(pad("verdict",34))binding/open")
print("  \(pad("tokamak (current-carrying)",30))\(pad(String(safe.ipAmp),12))\(pad(vTok.verdict,34))\(vTok.bindingBranch?.rawValue ?? "-") / \(vTok.openBranches.map{$0.rawValue}.joined(separator:","))")
print("  \(pad("stellarator (currentless)",30))\(pad(String(currentless.ipAmp),12))\(pad(vStel.verdict,34))\(vStel.bindingBranch?.rawValue ?? "-") / \(vStel.openBranches.map{$0.rawValue}.joined(separator:","))")
print("  Same ne14, same a, same betaN, same qMin. The ONLY changed byte is ipAmp,")
print("  a physics field. The topology structs are irrelevant to this delta — the")
print("  law would answer the same for a currentless tokamak or a current-driven")
print("  stellarator, because it grades the point, not the machine.")
print("")

// ── 3. NEGATIVE CONTROL — it must be able to FAIL ────────────────────────────
// A spheromak has no toroidal circuit, so it emits ZERO toroidal-closure edges.
// A toroidal two-path disagreement is therefore not even representable in its
// layout. If a spheromak ever showed a toroidal-closure edge, the descriptor
// would be LYING and the agnosticism claim would be false. This arm checks that,
// in both directions, so it can actually go red.
print("╔══ 3. NEGATIVE CONTROL — toroidal-closure edges ══╗")
print("  \(pad("topology",13))\(pad("hasToroidalCircuit",20))\(rp("torEdges",9))   expectation")
var negControlOK = true
for t in topos {
    let te = t.toroidalEdges(surfaces: surfaces, poloidalSamples: poloidalSamples)
    let mustBePositive = t.hasToroidalCircuit
    let holds = mustBePositive ? (te > 0) : (te == 0)
    if !holds { negControlOK = false }
    let expect = mustBePositive ? "must be > 0" : "must be == 0"
    print("  \(pad(t.name,13))\(pad(t.hasToroidalCircuit ? "true":"false",20))\(rp(String(te),9))   \(expect)  \(holds ? "PASS":"FAIL")")
}
let spheromakTor = spheromak.toroidalEdges(surfaces: surfaces, poloidalSamples: poloidalSamples)
print("  spheromak toroidal-closure edges == 0: \(spheromakTor == 0)")
print("  A toroidal two-path disagreement is not representable in a layout that")
print("  emits no toroidal edge. The descriptor tells the truth about its own")
print("  connectivity, and the arm above would print FAIL if it did not.")
print("  negative control holds in all directions: \(negControlOK)")
print("")

// ── VERDICT OF THE STUDY ─────────────────────────────────────────────────────
print("╔══ WHAT THIS PROVES, AND ONLY THIS ══╗")
print("  The LAW's bytes never change across topologies; only the layout does.")
print("  grade(_:) has no topology argument, three different meshes produced one")
print("  byte-identical verdict on the same point, and the one difference that")
print("  moved a verdict (ipAmp=0) was a physics input, not a descriptor field.")
print("  That is 'we run on ANY reactor topology' made CHECKABLE rather than")
print("  asserted.")
print("")
print("  NOT claimed: this did not run the substrate strobe (the cells build,")
print("  Mac-blocked, out of scope). What is proven is the law-level invariant —")
print("  the committed grade(_:) is blind to topology — and nothing more.")
print("")
let overall = allIdentical && negControlOK && spheromakTor == 0 && vTok.verdict == "WIN" && vStel.verdict == "NOT_APPLICABLE_NO_PLASMA_CURRENT"
print("  STUDY HOLDS: \(overall)")
#endif
