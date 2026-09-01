// STUDY 32 extractor: flight_list.csv (101 MB, 4TU open archive, CC BY 4.0,
// sha256 bd30540049d6f8afd6804eb30ff58d76b3351d361930f25cac8fbf3c27185fc1)
//   -> corpus/study-32/taxiout.csv  (adep,hour_utc,taxi_min — exact integers)
// Column 16 (taxiout_time) is published in integer minutes; nothing is rounded.
// Rows whose taxi field is absent or non-integer are COUNTED and refused, never
// silently dropped: absence is a different answer from a value.
import Foundation
let src = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "/tmp/dc/flight_list.csv"
// resolve the corpus DIRECTORY first, from any cwd the harness uses
let dirs = ["corpus/study-32","../corpus/study-32","../study-32","../../corpus/study-32"]
let corpusDir = dirs.first { FileManager.default.fileExists(atPath: "\($0)/PROVENANCE.md") }
guard let raw = try? String(contentsOfFile: src, encoding: .utf8) else {
    // A fresh clone has the DERIVED corpus (committed, digest-pinned) but not the
    // 101 MB source. That is ABSENT-of-source, not failure: the extraction is
    // replayable by fetching per PROVENANCE.md, and the derived file's integrity
    // is enforced by SHA256SUMS. Say so and stand down without faking a run.
    if let d = corpusDir, FileManager.default.fileExists(atPath: "\(d)/taxiout.csv") {
        print("SOURCE NOT PRESENT (101 MB, fetch per corpus/study-32/PROVENANCE.md).")
        print("Derived corpus stands at \(d)/taxiout.csv, integrity enforced by SHA256SUMS.")
        exit(0)
    }
    print("source missing AND derived corpus missing — nothing stands"); exit(2)
}
var out = "adep,hour_utc,taxi_min\n"
var admitted = 0, refused = 0
for line in raw.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" || $0 == "\r" }).dropFirst() {
    let f = line.split(separator: ",", omittingEmptySubsequences: false)
    guard f.count >= 18 else { refused += 1; continue }
    let adep = f[3], aobt = f[9], taxi = f[15]
    guard adep.count == 4, let t = Int(taxi), t >= 1,
          aobt.count >= 13, let h = Int(aobt.dropFirst(11).prefix(2)) else { refused += 1; continue }
    out += "\(adep),\(h),\(t)\n"; admitted += 1
}
guard let d = corpusDir else { print("corpus/study-32 not found from cwd — refusing to write a stray file"); exit(2) }
try! out.write(toFile: "\(d)/taxiout.csv", atomically: true, encoding: .utf8)
print("EXTRACTED admitted=\(admitted) refused=\(refused) -> \(d)/taxiout.csv")
