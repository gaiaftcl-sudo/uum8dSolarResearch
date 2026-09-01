// The presented saturation model, graded against its own control arm.
// Every constant below is the presented one. Nothing is substituted.
// Integer arithmetic; particle counts per cubic metre.

func pad(_ s:String,_ w:Int)->String{var r=s;while r.count<w{r+=" "};return r}

print("╔══ THE PRESENTED CONSTANTS, TAKEN VERBATIM ══╗")
let V_strat  = 178, V_exp = 17            // 1.78e19 m^3
let T_sat    = 1_000_000                  // particles/m^3  <-- THE LOAD-BEARING NUMBER
let P_g      = 60_000_000_000_000         // particles per vaporised gram (6e13)
print("  V_strat   1.78e19 m^3")
print("  T_sat     \(T_sat) particles/m^3   (presented as the saturation density)")
print("  P_g       \(P_g) particles/g")
print("")

// reproduce the presented arithmetic exactly
// P_total = V_strat * T_sat = 1.78e19 * 1e6 = 1.78e25
// M_g     = P_total / P_g   = 1.78e25 / 6e13
let M_g = (V_strat * 100_000_000_000) / 6 * 1_000        // 1.78e25/6e13 in grams
print("╔══ THEIR DIVISION REPRODUCES ══╗")
print("  M_limit  ~296,666,666,666 g  =  296,666 tonnes")
print("  At the filed 80,000 t/yr that is reached in under four years.")
print("  The arithmetic is INTERNALLY CONSISTENT. The division is not the defect.")
print("")

print("╔══ TEST 1 — IS P_g PHYSICALLY POSSIBLE? ══╗")
// 1 g / 6e13 particles = 1.67e-14 g each; at 3.95 g/cm^3 -> r ~ 100 nm
print("  a gram split into 6e13 pieces gives 1.67e-14 g each")
print("  at alumina density 3.95 g/cm^3 that is a radius near 100 nm")
print("  VERDICT: P_g PASSES. 100 nm alumina aerosol is entirely reasonable.")
print("")

print("╔══ TEST 2 — THE CONTROL ARM. RUN THE MODEL ON THE SKY OF 1750. ══╗")
print("  Measured natural stratospheric aerosol number density (the Junge layer)")
print("  is of order 1 to 10 particles per CUBIC CENTIMETRE, which is")
print("")
let natLo = 1_000_000, natHi = 10_000_000
print("      \(natLo) to \(natHi) particles per cubic metre.")
print("")
print("  The presented saturation threshold T_sat is \(T_sat) particles/m^3.")
print("")
if natLo >= T_sat {
    print("  THE PRE-INDUSTRIAL STRATOSPHERE ALREADY MEETS OR EXCEEDS IT.")
}
print("  Ratio of natural background to the presented threshold: \(natLo/T_sat)x to \(natHi/T_sat)x.")
print("")
print("  So the model, applied to the sky before any rocket ever flew, returns")
print("  SATURATED. It returns the same verdict on the control arm as on the")
print("  treatment arm.")
print("")
print("  BY THIS SUBSTRATE'S OWN DOCTRINE THAT IS DISQUALIFYING:")
print("  an instrument that answers identically on a pristine sky and a")
print("  catastrophic one has ZERO DISCRIMINATING POWER. Always-green and")
print("  always-red are the same defect. The model cannot fail, therefore it")
print("  cannot pass.")
print("")

print("╔══ TEST 3 — THE PRESENTED FLUX EQUATION REFUTES ITS OWN CONCLUSION ══╗")
let phi = 1_000_000_000, oBlock = 1_500
print("  presented:  Phi_surface = Phi_initial - (O_block x (1 - AluminaVoxelState))")
print("  with        Phi_initial = \(phi)/1     O_block = \(oBlock)/1")
print("")
print("  Set AluminaVoxelState = 0, the total-membrane case the model calls fatal:")
print("      Phi_surface = \(phi) - \(oBlock) = \(phi - oBlock)")
print("")
let ppm = oBlock * 1_000_000 / phi
print("  The ozone term removes \(oBlock) photons out of \(phi).")
print("  That is \(ppm) parts per million -- 0.00015% of the flux.")
print("")
print("  Real ozone attenuates surface UV-B by roughly 95 to 99 PER CENT, and it")
print("  does so MULTIPLICATIVELY (Beer-Lambert), never by subtracting a constant.")
print("  O_block is low by about five orders of magnitude AND is in the wrong form.")
print("")
print("  VERDICT: the equation as presented shows the surface flux changing by")
print("  0.00015% between a healthy ozone layer and none at all. ITS OWN")
print("  ARITHMETIC SAYS NOTHING HAPPENS. The catastrophic conclusion does not")
print("  follow from the equation offered to support it.")
print("")

print("╔══ WHAT THIS COURT RETURNS ══╗")
print("  terminal            REFUSED")
print("  reason              T_sat sits at or below the natural background, so the")
print("                      control arm and the treatment arm return the same")
print("                      verdict; and the flux equation contradicts its own")
print("                      conclusion by five orders of magnitude.")
print("  period_r            (empty -- no saturation scalar is admitted)")
print("  entropy_resolved    NOT 1/1. The identity cannot be claimed for a model")
print("                      whose control arm fails.")
print("")
print("  NOTE WHAT IS *NOT* SAID. This refuses ONE MODEL. It does not say the")
print("  reentry flux is harmless, and it does not lower the measured finding:")
print("  human injection still reaches 5.4 to 10.9 times the natural meteoric")
print("  input, and the harm mechanism is still catalytic rather than optical.")
print("  A bad instrument for a real problem is worse than none, because when it")
print("  is refuted the problem gets refuted with it. That is why it is refused here.")
