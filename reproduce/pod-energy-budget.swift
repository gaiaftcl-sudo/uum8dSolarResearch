// A.E.P-1 energy BUDGET from datasheet currents. Not a measurement — no pod exists.
// Exact integer femtojoules internally: uA * mV = nW, and nW * us = fJ. No truncation.
let vMilliV     = 3300
let txUa        = 45_000        // SX1262 TX @ +14 dBm, typ
let mcuUa       = 60_000        // ESP32-C6 active: sample, quantise, hand to radio
let sleepUa     = 7             // ESP32-C6 CHIP deep sleep (boards measure higher)
let txAirtimeUs = 287_744       // the 42 B frame, SF9/BW125, computed exactly
let wakeUs      = 50_000
let hourUs      = 3_600_000_000

func fJ(_ uA: Int, _ us: Int) -> Int { (uA * vMilliV) * us }      // nW * us = fJ
func uJ(_ f: Int) -> Int { f / 1_000_000_000 }
func mJs(_ f: Int) -> String { let u = uJ(f); return "\(u / 1000).\(String((u % 1000) / 100)) mJ" }
func Js(_ f: Int) -> String { let u = uJ(f); return "\(u / 1_000_000).\(String(format2(u % 1_000_000))) J" }
func format2(_ v: Int) -> String { var s = "\(v)"; while s.count < 6 { s = "0" + s }; return String(s.prefix(3)) }

// TWO OPERATING POINTS, and the page must name which it prices.
//  (a) the REGULATORY ceiling: floor(36 s duty budget / airtime) = 125 tx/hr
//  (b) the BINDING rate: T1 freezes the ingest period at 60 s, so at most 60 samples/hr
//      exist to transmit. The ingest period binds first; the duty ceiling is never reached.
let dutyCeilingTx = 36_000_000 / txAirtimeUs
let ingestPeriodUs = 60_000_000_000 / 1000          // 60,000,000,000 ns = 60 s = 60e6 us
let bindingTx = hourUs / ingestPeriodUs

print("=== operating points ===")
print("  regulatory duty ceiling : \(dutyCeilingTx) tx/hr   (36 s airtime budget / 287.744 ms)")
print("  T1 frozen ingest period : 60 s -> \(bindingTx) samples/hr")
print("  THE INGEST PERIOD BINDS FIRST. The duty ceiling is never reached at 60 s cadence.")
print("")

for (name, n) in [("BINDING: 60 tx/hr, every sample transmits", bindingTx),
                  ("regulatory ceiling 125 tx/hr (unreachable at 60 s ingest)", dutyCeilingTx)] {
    let txF   = fJ(txUa, txAirtimeUs) * n
    let wakeF = fJ(mcuUa, wakeUs) * n
    let activeUs = n * (txAirtimeUs + wakeUs)
    let sleepF = fJ(sleepUa, hourUs - activeUs)
    let total  = txF + wakeF + sleepF
    print("--- \(name) ---")
    print("   per transmission \(mJs(fJ(txUa, txAirtimeUs)))   per wake \(mJs(fJ(mcuUa, wakeUs)))")
    print("   tx total \(mJs(txF))   wake total \(mJs(wakeF))   sleep \(mJs(sleepF))")
    print("   TOTAL \(Js(total))/hour     per delivered report \(uJ(total) / n) uJ")
    let termJ = 216_000
    let totalUj = uJ(total)
    let ratio = termJ * 1_000_000 / totalUj      // 216000 J = 216000e6 uJ
    print("   TOTAL exact: \(totalUj) uJ/hour")
    print("   vs 60 W terminal class figure (\(termJ) J/hr): \(ratio) : 1 per hour of availability")
    print("   (exact integer division of 216,000,000,000 uJ by the hourly budget in uJ)")
}

print("")
print("=== the QUIET FLOOR — a genuinely silent hour, no transmissions at all ===")
let silent = fJ(sleepUa, hourUs)
print("   3600 s x \(sleepUa) uA x \(vMilliV) mV = \(mJs(silent))/hour")
print("   (NOT the same as the sleep term inside a transmitting hour, which covers only the remainder)")
print("")
print("=== board-leakage sensitivity: 72 uA measured on a commercial dev board ===")
let silent72 = fJ(72, hourUs)
print("   a silent hour at 72 uA: \(mJs(silent72))/hour")
let txF60 = fJ(txUa, txAirtimeUs) * bindingTx + fJ(mcuUa, wakeUs) * bindingTx
let act60 = bindingTx * (txAirtimeUs + wakeUs)
print("   60 tx/hr at 72 uA: \(Js(txF60 + fJ(72, hourUs - act60)))/hour")
