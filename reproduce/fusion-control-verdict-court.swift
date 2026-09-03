// STUDY 33 — the fusion control verdict court.
//
// This court grades CONTROL INSTRUMENTS at the safety boundary. It does not
// claim to control plasma better than anyone: this programme operates no
// tokamak and this page never pretends otherwise. It asks one frozen question:
//
//     WHEN THE MITIGATION FIRES, CAN THE VERDICT BE RE-DERIVED?
//
// Every count below was measured 2026-09-01 by census over the pre-court
// implementations and is carried here as a dated constant (the sources are
// private working directories; only counts and grades are published, never
// paths, identifiers or code).
func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}
func rp(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r=" "+r};return r}

print("╔══ 1. OUR OWN PRIOR-ERA FUSION CODE, GRADED FIRST ══╗")
print("  Published before this programme's own findings, because a court that")
print("  grades instruments must grade its own first. These implementations")
print("  PREDATE the Affine.Earth MCP court: they are the earlier era, dated,")
print("  and they are not the claim.")
print("")
struct Impl{let lang:String;let lines:Int;let floatTok:Int;let exactTok:Int;let machineData:Int}
let impls=[("prior-era control model (interpreted)", Impl(lang:"Python + numpy + torch", lines:445, floatTok:2, exactTok:0, machineData:0)),
           ("prior-era reactor GNN (compiled)",      Impl(lang:"Swift", lines:392, floatTok:32, exactTok:0, machineData:0))]
print("  \(pad("implementation",38))\(pad("stack",26))\(rp("lines",7))\(rp("float",7))\(rp("exact",7))")
for (n,i) in impls { print("  \(pad(n,38))\(pad(i.lang,26))\(rp("\(i.lines)",7))\(rp("\(i.floatTok)",7))\(rp("\(i.exactTok)",7))") }
print("")
print("  EXACT-RATIONAL DECLARATIONS ACROSS BOTH: 0.")
print("  REAL MACHINE DATA ACROSS EVERY FUSION FILE SEARCHED: 0 — the word-")
print("  boundary census for DIII-D, NSTX, KSTAR, TCV, MAST, W7-X and shot ids")
print("  returned EMPTY. The only machine reference is a geometry constant in a")
print("  test fixture.")
print("")
print("  THREE CORRECTIONS THIS CENSUS FORCES ON OUR OWN PRIOR PAGES:")
print("   - a headline 'Q = 1.8 energy gain' traces to beta_normalized=1.8, an")
print("     INPUT PARAMETER of a test fixture, not an output. Q never appears as")
print("     a computed result; it appears once as a target in a print statement.")
print("   - 'zero disruptions / 100% stability' is a property of a simulation")
print("     with no reactor behind it, not an operational record.")
print("   - the float census itself has a trap worth naming: the compiled file")
print("     shows 32 float tokens and the interpreted one only 2 -- because its")
print("     float-ness lives IMPLICITLY in array types, invisible to a token")
print("     scan. A gate reading '2' as 'nearly clean' would be wrong.")
print("")

print("╔══ 2. THE COMPARATOR, AT FULL WEIGHT ══╗")
print("  PACMAN is a real AI control framework from a national laboratory and a")
print("  university, and on the axis that matters most to a physicist it is AHEAD")
print("  OF US, not behind: it has run on FIVE REAL-WORLD EXPERIMENTS. We have")
print("  run on none. That is stated first and it is not softened.")
print("")
print("  Its published design carries three properties this court records as")
print("  strengths, not defects: modular algorithm composition; explicit")
print("  millisecond-scale operation; and a human kept, by design, in charge.")
print("")

print("╔══ 3. WHAT THE DESIGN CONCEDES, IN ITS OWN WORDS ══╗")
print("  Two published statements do the work of this entire study:")
print("")
print("   (a) the framework keeps 'humans firmly in charge'.")
print("       READ AS ENGINEERING: the verdict is not trusted to be autonomous")
print("       where the machine is at risk. That is a correct and responsible")
print("       decision -- AND it concedes the point: an un-re-derivable verdict")
print("       needs a human underwriter at the safety boundary. The human IS the")
print("       re-derivation layer, running at human latency against a plasma that")
print("       moves in milliseconds.")
print("")
print("   (b) machine learning models are 'the only way to model the plasma in")
print("       millisecond times'.")
print("       READ AS A CLAIM SHAPE: an impossibility assertion about a whole")
print("       method class. This programme keeps a dated record of exactly that")
print("       shape being wrong -- a capability once declared BLOCKED on a single")
print("       failed configuration, repeated across fourteen documents until it")
print("       read as architectural fact, then measured true on the first honest")
print("       retry. An impossibility claim is a measurement of what has been")
print("       tried, never of what is possible.")
print("")

print("╔══ 4. THE FROZEN QUESTION, AND WHY IT IS THE RIGHT ONE ══╗")
print("  Not 'who controls plasma better' -- we operate no reactor and cannot")
print("  answer that. The question a court CAN answer:")
print("")
print("     WHEN THE MITIGATION SYSTEM FIRES, CAN THE VERDICT BE RE-DERIVED")
print("     BY A PARTY THAT DOES NOT TRUST THE OPERATOR?")
print("")
print("  \(pad("property",34))\(pad("float ML ensemble",22))exact court")
let rows=[("verdict re-derivable by a third party","no — weights + state","yes — integers"),
          ("behaviour outside training data","undefined","refuses or NOT_KNOWN"),
          ("same answer on two machines","platform-dependent","byte-identical"),
          ("post-incident forensics","re-run and hope","re-derive the integer"),
          ("who underwrites the boundary","a human, at human latency","the law, at wire speed"),
          ("real-machine experiments run","FIVE (theirs)","NONE (ours)")]
for (a,b,c) in rows { print("  \(pad(a,34))\(pad(b,22))\(c)") }
print("")
print("  THE LAST ROW IS THE HONEST ONE AND IT IS NOT IN OUR FAVOUR.")
print("")

print("╔══ 5. THE DOMAIN DECLARATION — the court's own shape ══╗")
print("    domain            fusion_control")
print("    dead_equation     continuous MHD + gyrokinetic closure, statistically")
print("                      compressed into a float ML interpolator, underwritten")
print("                      at the safety boundary by a human at human latency")
print("    new_law           the mitigation verdict is an exact integer over")
print("                      declared state; outside the declared envelope the")
print("                      court REFUSES rather than interpolating")
print("    entropy_bare      4/1   four links: state estimate, model, verdict, actuation")
print("    entropy_delta     1/1   one link removed by exact counting (the verdict)")
print("    entropy_resolved  3/1   THREE REMAIN, and none is closable by counting")
print("    no_float          true")
print("    proven_marker     STUDY33_FUSION_CONTROL_VERDICT_PENDING")
print("")
print("  THE MARKER SAYS PENDING AND WILL SAY PENDING UNTIL IT IS EARNED. The")
print("  identity does not resolve to 1/1 here and this court does not pretend")
print("  it does: state estimation, plasma modelling and actuation are physics")
print("  we have not instrumented. Only the VERDICT link is ours to make exact.")
print("")

print("╔══ 6. HOW THIS STUDY LOSES ══╗")
print("   LOSS (i)   the mitigation decision turns out to be re-derivable in the")
print("              existing frameworks -- then the seam is already closed and")
print("              this study publishes that with the citation that closed it.")
print("   LOSS (ii)  an exact envelope cannot be declared for a real device")
print("              without becoming so conservative it fires constantly. That")
print("              is a REAL risk: a court that refuses too often is a court")
print("              nobody switches on.")
print("   LOSS (iii) the out-of-distribution failure mode is bounded in practice")
print("              by existing safety interlocks, making the verdict layer moot.")
print("")
print("╔══ REFUSED ══╗")
print("  - 'we are ahead of them': refused on our own census. They have five real")
print("    experiments; we have a float model and no reactor.")
print("  - 'bad things will happen if their framework proceeds': refused. It is a")
print("    SAFETY framework with a human in the loop by design, and no measurement")
print("    here supports predicting harm from it.")
print("  - any claimed control latency, disruption rate or Q value from this")
print("    programme: refused until a real device produces one.")
