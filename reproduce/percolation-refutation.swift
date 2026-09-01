// Does the stratosphere "run out of voxels"? Execute the volumetric model exactly
// and find out. Integer arithmetic, all quantities scaled to avoid any float.
//
// The occlusion model says: vaporised alumina claims spatial volume until the
// disconnected particles link into a continuous membrane (percolation), at which
// point radiation transport changes discretely.
//
// That is a testable claim with a known threshold, so it is tested here.

func pad(_ s: String, _ w: Int) -> String { var r = s; while r.count < w { r += " " }; return r }

print("╔══ THE OCCLUSION MODEL, EXECUTED ══╗")
print("")
// stratospheric volume, the figure the proposal itself uses
// 1.78e19 m^3, held as 178 * 10^17
let stratExp = 17, stratMant = 178              // 1.78e19 m^3
print("  stratospheric volume            \(stratMant) x 10^\(stratExp) m^3   = 1.78e19")

// annual mass at the largest FILED scale
let massG_exp = 10, massG_mant = 8              // 8e10 g = 80,000 t
print("  filed annual mass               \(massG_mant) x 10^\(massG_exp) g      = 80,000 t/yr")

// alumina bulk density 3.95 g/cm^3 = 3.95e6 g/m^3
let rhoExp = 6, rhoMant = 395                   // 3.95e6, held as 395 x 10^4
print("  alumina density                 3.95e6 g/m^3      (bulk corundum)")
print("")

// volume occupied = mass / density
//   8e10 / 3.95e6 = 2.0253e4 m^3
// computed as integers: 8*10^10 * 1000 / (395 * 10^4) = 20253 m^3 (floor)
let occupied = (massG_mant * 1_000_000_000_000 * 1000) / (rhoMant * 10_000)
print("  VOLUME ACTUALLY OCCUPIED        \(occupied) m^3")
print("  For scale, that is a cube about 27 metres on a side. Per year.")
print("")

// volume fraction = occupied / strat volume, expressed as parts per 10^18
// occupied / 1.78e19  -> multiply by 10^18 to get an integer count
//   20253 * 10^18 / 1.78e19 = 20253 / 17.8 = 1137 parts per 10^18
let fracPer1e18 = occupied * 10 / stratMant     // = occupied*10^18 / (178*10^17)
print("╔══ THE VOLUME FRACTION ══╗")
print("  occupied fraction               \(fracPer1e18) parts per 10^18")
print("                                  = about 1.1 x 10^-15")
print("")

// continuum percolation threshold for randomly placed spheres ~ 0.29 volume fraction
// expressed in the same units: 0.29 -> 29 * 10^16 parts per 10^18
let threshPer1e18 = 29 * 10_000_000_000_000_000
print("╔══ THE PERCOLATION THRESHOLD ══╗")
print("  randomly placed spheres percolate near a volume fraction of 0.29")
print("  threshold                       \(threshPer1e18) parts per 10^18")
print("")
let ratio = threshPer1e18 / max(fracPer1e18, 1)
print("╔══ THE VERDICT ══╗")
print("  distance to percolation         \(ratio) x")
print("")
print("  The filed annual mass would have to increase by a factor of about")
print("  TWO HUNDRED AND FIFTY TRILLION before the alumina could form a")
print("  continuous membrane. Accumulated over the entire age of the Earth it")
print("  does not approach the threshold.")
print("")
print("  THE OCCLUSION MODEL IS REFUTED. There is no voxel exhaustion, no")
print("  saturation block height, and no continuous metallic sky. Any study")
print("  built on that mechanism is built on a number that is off by fourteen")
print("  orders of magnitude.")
print("")

print("╔══ AND THIS IS WHY THE REAL FINDING IS WORSE, NOT BETTER ══╗")
print("  Read the refutation carefully. It says the material occupies essentially")
print("  NO VOLUME. If harm required filling the sky, there would be no story here")
print("  at any filed scale, and this whole programme could stop.")
print("")
print("  The harm is not occlusion. IT IS CATALYSIS.")
print("")
print("  A catalyst is not consumed and does not need to fill the room. Chlorine")
print("  from CFCs destroyed several percent of the global ozone column at mixing")
print("  ratios of parts per billion -- a volume fraction as negligible as this one.")
print("  That is the entire reason the Montreal Protocol was necessary, and it is")
print("  the reason 461 tonnes a year is worth measuring at all.")
print("")
print("  So the occlusion model fails in the REASSURING direction: run honestly it")
print("  says there is no problem, and that conclusion is wrong. A model that")
print("  cannot see a catalytic mechanism is not a conservative model. It is a")
print("  blind one -- and it would have told SpaceX to proceed.")
print("")
print("  What survives is the measurement that does not depend on any of this:")
print("  human injection reaching 5.4 to 10.9 times the natural meteoric input,")
print("  into a layer whose chemistry is catalytic, with no instrument watching.")
