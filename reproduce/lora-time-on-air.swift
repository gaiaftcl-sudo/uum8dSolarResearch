// SX1262 LoRa time-on-air, SF9 / BW125 kHz / CR 4-5 / explicit header / CRC on / LDRO off.
// Exact integer microseconds: T_sym = 2^SF/BW = 512/125000 s = 4096 us exactly.
let SF = 9, CR = 1, CRC = 1, IH = 0, DE = 0, nPre = 8
let tSymUs = 4096
let tPreUs = (nPre * 4 + 17) * tSymUs / 4    // (nPre + 4.25)*Tsym, kept integral via quarters

func symbols(_ pl: Int) -> Int {
    let num = 8 * pl - 4 * SF + 28 + 16 * CRC - 20 * IH
    let den = 4 * (SF - 2 * DE)
    let cd = num <= 0 ? 0 : (num + den - 1) / den
    return 8 + max(cd * (CR + 4), 0)
}
func toaUs(_ pl: Int) -> Int { tPreUs + symbols(pl) * tSymUs }
func pad(_ s: String, _ w: Int) -> String { s.count >= w ? s : s + String(repeating: " ", count: w - s.count) }
func ms(_ us: Int) -> String { let f = us % 1000; let z = f < 10 ? "00" : (f < 100 ? "0" : ""); return "\(us / 1000).\(z)\(f)" }

let duty = 36_000_000   // 1% of one hour, in microseconds

print("T_sym=\(tSymUs)us  T_preamble=\(tPreUs)us  duty budget=\(duty)us/hr")
print(pad("frame", 22) + pad("bytes", 7) + pad("symbols", 9) + pad("airtime_ms", 13) + "tx_per_hr")
for (name, pl) in [("float JSON frame", 201), ("delta int32 x8", 32), ("delta int16 x8 raw", 16), ("FRAME: 16B delta + 26B hdr", 42), ("90B frame (int64 x8 + hdr)", 90)] {
    let us = toaUs(pl)
    print(pad(name, 22) + pad("\(pl)", 7) + pad("\(symbols(pl))", 9) + pad(ms(us), 13) + "\(duty / us)")
}
let a = toaUs(201), b = toaUs(32), c = toaUs(16)
print("payload 201:32  = \(201 * 1000 / 32)/1000")
print("airtime 201:32  = \(a * 1000 / b)/1000")
print("tx/hr   32:201  = \((duty / b) * 1000 / (duty / a))/1000")
print("airtime 201:16  = \(a * 1000 / c)/1000    tx/hr 16:201 = \((duty / c) * 1000 / (duty / a))/1000")
