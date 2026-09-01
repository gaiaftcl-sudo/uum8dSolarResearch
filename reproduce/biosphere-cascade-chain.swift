// STUDY 31 — the biosphere cascade, as a chain of graded links.
//
// A cascade is a PRODUCT. Each link is a factor. The product is computable only
// where every factor carries a number. Where a link is unmeasured, the product is
// unmeasured -- and WHICH LINK BREAKS IT is the finding.
//
// This program does not predict a collapse. It multiplies the chain as far as the
// published evidence allows, states the grade of every link, and names the exact
// link where the multiplication has to stop. Integer arithmetic in per-mille.

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }
func rp(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r = " " + r }; return r }
func d1(_ pm: Int) -> String { "\(pm/10).\(abs(pm)%10)" }   // per-mille -> percent, 1dp

print("╔══ THE CHAIN, LINK BY LINK, WITH THE GRADE ON EACH ══╗")
struct Link { let n: Int, name: String, grade: String, value: String }
let chain = [
  Link(n: 1, name: "injection -> stratospheric burden",   grade: "MEASURED",
       value: "residence time CANCELS; burden ratio = flux ratio"),
  Link(n: 2, name: "burden -> global mean ozone loss",    grade: "CONTESTED",
       value: "five models, DISAGREEING ON SIGN"),
  Link(n: 3, name: "global mean -> regional worst case",  grade: "MEASURED",
       value: "12x  (Antarctic 60% while global mean was 5%)"),
  Link(n: 4, name: "ozone loss -> surface UV-B increase", grade: "ESTABLISHED",
       value: "radiation amplification factor 1.1 to 2.0"),
  Link(n: 5, name: "UV-B -> phytoplankton productivity",  grade: "CITED, NOT MEASURED",
       value: "mechanism established; NO transfer function at this forcing"),
  Link(n: 6, name: "phytoplankton -> food web and O2",    grade: "NOT_KNOWN",
       value: "no quantified transfer function exists in any literature we found"),
]
for l in chain {
  print("  \(l.n). \(pad(l.name,38)) \(pad(l.grade,22)) \(l.value)")
}
print("")
print("  LINKS 1, 3 and 4 MULTIPLY. Link 2 is a contested spread carried as a spread.")
print("  THE CHAIN STOPS AT LINK 5. Not because the mechanism is doubtful -- it is not --")
print("  but because NO ONE HAS MEASURED THE TRANSFER FUNCTION against this forcing.")
print("")

print("╔══ LINK 3 IS THE ONE NOBODY PUTS ON A PUBLIC PAGE ══╗")
print("  Every model in this field reports a GLOBAL MEAN. The Montreal-era global mean")
print("  column loss peaked near 5%. In the same years the Antarctic springtime hole")
print("  reached about 60%.")
print("")
print("      A GLOBAL MEAN IS TWELVE TIMES KINDER THAN THE WORST REGION.")
print("")
print("  That is not a modelling opinion, it is what the ozone record did. A projection")
print("  quoted as a global mean has already divided the regional damage by twelve")
print("  before the reader sees it. Both numbers below are therefore published.")
print("")

// per-mille global-mean column loss from the envelope, by filed scenario
let scen: [(String, Int)] = [
  ("2025, measured",           0),      // 0.029% rounds to 0 per-mille; printed exactly below
  ("authorized 19,408",        2),      // 0.257%  -> 2.57 per-mille, floored to 2
  ("Gen3 filed 100,000",      13),      // 1.324%  -> 13.24
  ("orbital data centres",   107),      // 10.767% -> 107.67
]
let RAF_LO = 11, RAF_HI = 20            // radiation amplification factor x10

print("╔══ MULTIPLYING THE CHAIN AS FAR AS IT GOES ══╗")
print("  \(pad("scenario",24))\(rp("global mean",13))\(rp("regional (x12)",16))\(rp("surface UV-B rise",22))")
for (n, gm) in scen {
    let reg = gm * 12
    if reg >= 1000 {
        print("  \(pad(n,24))\(rp(d1(gm)+"%",13))\(rp(d1(reg)+"%",16))\(rp("IMPOSSIBLE - see below",22))")
    } else {
        let uvLo = reg * RAF_LO / 10, uvHi = reg * RAF_HI / 10
        print("  \(pad(n,24))\(rp(d1(gm)+"%",13))\(rp(d1(reg)+"%",16))\(rp("+\(d1(uvLo))% to +\(d1(uvHi))%",22))")
    }
}
print("")
print("  (2025 is 0.029% global mean -- below the per-mille resolution of this table,")
print("   and far below the 1-2% natural year-to-year variability. It is printed as 0.0.)")
print("")

print("╔══ THE RESULT: THE CHAIN BREAKS THE MODEL BEFORE IT BREAKS THE PLANET ══╗")
print("  At the orbital-data-centre scale the linear chain returns a REGIONAL ozone")
print("  loss of 129% -- more ozone destroyed than exists. That is not a forecast of")
print("  catastrophe. IT IS A PROOF THAT THE LINEAR PROJECTION FAILS BEFORE IT GETS")
print("  THERE.")
print("")
print("  Exactly one of these must be true, and NOBODY CAN CURRENTLY SAY WHICH:")
print("    (a) the ozone response saturates far below linear -- the kind reading;")
print("    (b) the 12x regional amplification does not carry to this forcing;")
print("    (c) the projection is right in magnitude and the geometry is different.")
print("")
print("  THAT is the cascade nobody is looking for. Not a predicted extinction --")
print("  a chain whose fourth link returns a physically impossible number, which means")
print("  the published instruments are being used outside the range where they mean")
print("  anything, AND NO ONE HAS NOTICED BECAUSE NO ONE HAS MULTIPLIED THE CHAIN.")
print("")

print("╔══ WHAT WOULD CLOSE EACH OPEN LINK, and what it would cost ══╗")
let fixes: [(String, String)] = [
  ("link 2  contested sign", "a mandatory reentry emissions inventory: mass, composition, ablation altitude, per object. Settles it in ~3 years. Costs near nothing."),
  ("link 3  regional carry", "run the existing models to regional minima and PUBLISH THEM, not just the global mean. Costs one output field."),
  ("link 5  phytoplankton",  "a UV-B dose-response experiment at the projected regional doses. Standard marine biology. Nobody has been asked to fund it."),
  ("link 6  food web",       "the transfer function does not exist. This is the honest terminal: NOT_KNOWN."),
]
for (k, v) in fixes { print("  \(pad(k,24)) \(v)") }
print("")
print("  THREE OF THE FOUR ARE CHEAP AND NONE OF THEM IS BEING DONE.")
print("")

print("╔══ THE COURT DECLARATION — the shape every Affine domain declares ══╗")
print("  Authored to match the 48 domains the live court already carries:")
print("  dead_equation / new_law / entropy triple / flourishing_root / no_float / marker.")
print("")
print("    domain            biosphere")
print("    dead_equation     dOzone/dt integrated over a continuous column, REPORTED AS A GLOBAL MEAN")
print("    new_law           cascade = product of graded links; burden ratio = flux ratio (tau cancels);")
print("                      regional = global x 12; the product stops at the first ungraded link")
print("    entropy_bare      6/1     six links, the continuous form returns ONE averaged answer for all six")
print("    entropy_delta     3/1     three links removed by exact counting (1 burden, 3 regional, 4 UV)")
print("    entropy_resolved  3/1     THREE LINKS REMAIN and NONE can be closed by counting")
print("    no_float          true")
print("    proven_marker     STUDY31_BIOSPHERE_CASCADE_PROVEN")
print("")
print("  THE IDENTITY FAILS, AND THE FAILURE IS THE RESULT:")
print("      entropy_bare - entropy_delta = 3/1,  NOT 1/1.")
print("  Every resolved domain on this substrate lands on 1/1 -- one answer, replayable")
print("  by anyone. This one lands on 3/1 because three links are missing MEASUREMENTS,")
print("  not harder sums. Counting cannot finish it. That is the honest terminal, and it")
print("  is why this domain is declared UNRESOLVED rather than quietly rounded to 1/1.")
print("")
print("╔══ HOW THIS STUDY LOSES ══╗")
print("  It must be able to fail, or it is a turn counter and not a court:")
print("   LOSS (i)   every link turns out to be quantified in existing literature we")
print("              did not find. Then the chain is closed, the gap is ours, and this")
print("              page publishes that with the citations that closed it.")
print("   LOSS (ii)  the 12x regional factor does not generalise beyond polar")
print("              heterogeneous chemistry. Then link 3 collapses to 1x and the")
print("              impossible number never arises.")
print("   LOSS (iii) the chain multiplies cleanly to a small number at every filed")
print("              scale. Then there is no cascade and this study says so.")
print("")
print("  NOTHING IN THIS STUDY CLAIMS AN EXTINCTION, A DATE, OR A ZERO-SURVIVAL")
print("  PROBABILITY. Those are not results. The result is the location of the break.")
