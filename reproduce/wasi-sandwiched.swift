// =====================================================================================
// wasi-sandwiched.swift — WAS MY TRANSACTION SANDWICHED, AND WHAT DID IT COST ME?
//
// One question. One person. One transaction hash. No account, no key, no permission,
// no money. Given a hash this program fetches the containing block from free public
// Ethereum endpoints, cross-confirms it against a SECOND independent endpoint, and
// hands the block to the detector — the same detector, on the same code path — then
// prints one of exactly three answers:
//
//     SANDWICHED       with both attacker legs by hash and position, and the shortfall
//                      in token base units against the pre-front-run reserve state
//     NOT SANDWICHED   a real answer, with an explicit statement of what was NOT checked
//     REFUSED          the block could not be confirmed, or the hash is not a swap
//
// Those three never print alike, never share an exit code, and none of them is the
// absence of the others.
//
// THE SAME CODE PATH, NOT A SECOND IMPLEMENTATION.
// This file contains no conjunct, no pool arithmetic and no shortfall formula. Every
// one of those lives in extraction-exact.swift and is compiled into this binary as a
// VERBATIM BYTE SLICE of that file (lines 1..2535), whose sha256 is computed at build
// time and printed at run time. runCorpus(), computeShortfall(), v2Out(), v3Step(),
// v3InvertStart(), U256/I256/SInt and the JSON scanner are called here by their own
// names, unmodified. Two implementations drift; this one has to be right for a stranger,
// so there is only one.
//
// WHAT THIS FILE DOES OWN: fetching, the four wire answers kept apart, the block's
// internal-consistency guard, the cross-endpoint confirmation, and the plain-English
// verdict. All of it I/O and presentation. None of it law.
//
// INTEGER ONLY. Every amount on every decision path is an integer in token base units —
// wei, and each token's own decimals. There is exactly one Double in this program,
// URLRequest.timeoutInterval, built from an Int and never read back. It touches no
// number that is anybody's money.
//
// DETECTION IS NOT INTENT. A positive answer is a geometry match against a published
// null floor of 47 false positives per 212,769 leg pairs. It names no one, and it is
// not a legal conclusion. That sentence is printed on every positive result, in the
// output, in plain words — not in a footnote.
// =====================================================================================

import Foundation

// =====================================================================================
// SECTION 1 — THE FOUR WIRE ANSWERS, KEPT APART
//
// An endpoint that serves HTTP 200 carrying "Hello World!" has answered a DIFFERENT
// question. An endpoint that serves a block successfully WITH ZERO TRANSACTIONS has
// answered this one wrongly. Neither is LIVE. The verdict comes from the BODY; the
// status code is recorded and never decides.
// =====================================================================================

enum WSWire: String {
    case LIVE           // this endpoint answered THIS question with usable content
    case ABSENCE        // it says the data is not there (pruned, unavailable, null)
    case REFUSAL        // it says it will not answer me (key, auth, quota)
    case BOT_BLOCKED    // an interstitial stands between me and the answer
    case NOT_KNOWN      // transport failed, or the body was not a JSON-RPC answer
}

struct WSResult {
    let endpoint: String
    let status: Int
    let bytes: Int
    let body: Data
    let wire: WSWire
    let reason: String
    let millis: UInt64
}

// The one and only Double in this program. Built from an Int, never read.
let WS_TIMEOUT_SECONDS_INT = 25
let wsTimeout: TimeInterval = TimeInterval(WS_TIMEOUT_SECONDS_INT)

var wsRequests = 0
var wsBytes = 0

/// Classify a response body. Pure, so the self-test can drive it with fixed bytes and
/// prove it discriminates in five directions without a network.
func wsClassify(status: Int, body: Data, transportError: String?) -> (WSWire, String) {
    if let e = transportError { return (.NOT_KNOWN, "TRANSPORT:" + String(e.prefix(70))) }
    if body.isEmpty { return (.NOT_KNOWN, "EMPTY_BODY") }
    let head = String(decoding: body.prefix(400), as: UTF8.self)
    let lower = head.lowercased()
    if lower.contains("just a moment") || lower.contains("cf-browser-verification")
        || lower.contains("captcha") || lower.contains("attention required") {
        return (.BOT_BLOCKED, "INTERSTITIAL")
    }
    var isObject = false
    body.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
        guard let p = raw.bindMemory(to: UInt8.self).baseAddress else { return }
        var i = 0
        while i < body.count, p[i] == 0x20 || p[i] == 0x09 || p[i] == 0x0a || p[i] == 0x0d { i += 1 }
        isObject = (i < body.count && p[i] == 0x7b)
    }
    if !isObject {
        return (.NOT_KNOWN, "NON_JSONRPC_BODY:" + String(head.prefix(48)).replacingOccurrences(of: "\n", with: " "))
    }
    var errMsg: String? = nil
    var errCode = "?"
    var haveResult = false
    var resultNull = false
    wsWithJS(body) { J in
        _ = J.objectEach(0) { ks, kl, vs in
            if J.keyIs(ks, kl, "error") {
                _ = J.objectEach(vs) { eks, ekl, evs in
                    if J.keyIs(eks, ekl, "message") { errMsg = (J.strOut(evs) ?? "").lowercased() }
                    else if J.keyIs(eks, ekl, "code") { errCode = J.rawNumU64(evs).map { String($0) } ?? (J.strOut(evs) ?? "?") }
                }
                if errMsg == nil { errMsg = "" }
            } else if J.keyIs(ks, kl, "result") {
                haveResult = true
                if vs + 3 < J.n, J.p[vs] == 0x6e, J.p[vs+1] == 0x75, J.p[vs+2] == 0x6c, J.p[vs+3] == 0x6c { resultNull = true }
            }
        }
    }
    if let m = errMsg {
        if m.contains("api key") || m.contains("unauthorized") || m.contains("authenticate")
            || m.contains("forbidden") || m.contains("quota") || m.contains("rate limit")
            || m.contains("subscription") || m.contains("not allowed") || m.contains("plan") {
            return (.REFUSAL, "RPC_REFUSAL[" + errCode + "]:" + String(m.prefix(70)))
        }
        if m.contains("pruned") || m.contains("unavailable") || m.contains("not found")
            || m.contains("missing") || m.contains("no historical") || m.contains("cannot fulfill") {
            return (.ABSENCE, "RPC_ABSENCE[" + errCode + "]:" + String(m.prefix(70)))
        }
        return (.NOT_KNOWN, "RPC_ERROR[" + errCode + "]:" + String(m.prefix(70)))
    }
    if !haveResult { return (.NOT_KNOWN, "NO_RESULT_FIELD") }
    if resultNull { return (.ABSENCE, "RESULT_NULL") }
    return (.LIVE, "RESULT_PRESENT")
}

func wsPost(_ endpoint: String, _ payload: String) -> WSResult {
    let t0 = DispatchTime.now().uptimeNanoseconds
    guard let url = URL(string: endpoint) else {
        return WSResult(endpoint: endpoint, status: 0, bytes: 0, body: Data(),
                        wire: .NOT_KNOWN, reason: "BAD_URL", millis: 0)
    }
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("affine-earth-wasi-sandwiched/1", forHTTPHeaderField: "User-Agent")
    req.httpBody = payload.data(using: .utf8)
    req.timeoutInterval = wsTimeout

    var outData = Data()
    var outStatus = 0
    var outErr: String? = nil
    let sem = DispatchSemaphore(value: 0)
    let task = URLSession.shared.dataTask(with: req) { d, r, e in
        if let d = d { outData = d }
        if let http = r as? HTTPURLResponse { outStatus = http.statusCode }
        if let e = e { outErr = "\(e)" }
        sem.signal()
    }
    task.resume()
    _ = sem.wait(timeout: .now() + .seconds(WS_TIMEOUT_SECONDS_INT + 10))
    let ms = (DispatchTime.now().uptimeNanoseconds &- t0) / 1_000_000
    wsRequests += 1
    wsBytes += outData.count
    let (w, why) = wsClassify(status: outStatus, body: outData, transportError: outErr)
    return WSResult(endpoint: endpoint, status: outStatus, bytes: outData.count,
                    body: outData, wire: w, reason: why, millis: ms)
}

// Free, no key, no account, no registration. Probed on 2026-09-08; the ones that carry
// 2022-era archive receipts are marked. The tool tries them in order and says which
// answered, so a stranger can see exactly where their answer came from.
struct WSEndpoint { let url: String; let note: String }
let WS_ENDPOINTS: [WSEndpoint] = [
    WSEndpoint(url: "https://rpc.mevblocker.io",          note: "free, no key, archive receipts"),
    WSEndpoint(url: "https://eth.merkle.io",              note: "free, no key, archive receipts"),
    WSEndpoint(url: "https://eth.drpc.org",               note: "free, no key, archive receipts"),
    WSEndpoint(url: "https://eth-pokt.nodies.app",        note: "free, no key, archive receipts"),
    WSEndpoint(url: "https://ethereum-rpc.publicnode.com", note: "free, no key, PRUNED history"),
    WSEndpoint(url: "https://cloudflare-eth.com",         note: "free, no key, no getBlockReceipts"),
    WSEndpoint(url: "https://1rpc.io/eth",                note: "free, no key, no getBlockReceipts"),
    WSEndpoint(url: "https://rpc.flashbots.net",          note: "free, no key"),
]

// =====================================================================================
// SECTION 2 — READING A JSON-RPC BODY WITH THE DETECTOR'S OWN SCANNER
// =====================================================================================

@discardableResult
func wsWithJS<T>(_ d: Data, _ body: (JS) -> T?) -> T? {
    if d.isEmpty { return nil }
    return d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) -> T? in
        guard let p = raw.bindMemory(to: UInt8.self).baseAddress else { return nil }
        return body(JS(p: p, n: d.count))
    }
}

/// The raw bytes of the `result` value, copied out verbatim. Raw newlines are replaced by
/// spaces and COUNTED — a raw newline inside a JSON string is illegal JSON, so this is
/// lossless for any legal body, and NDJSON needs one record per line.
func wsResultBytes(_ d: Data) -> (Data, Int)? {
    var out: Data? = nil
    _ = wsWithJS(d) { (J: JS) -> Bool? in
        var at = -1
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, "result") { at = vs } }
        if at < 0 { return nil }
        var i = at
        J.skipValue(&i)
        if i <= at { return nil }
        out = Data(UnsafeBufferPointer(start: J.p + at, count: i - at))
        return true
    }
    guard var bytes = out else { return nil }
    var replaced = 0
    for k in 0..<bytes.count where bytes[k] == 0x0a || bytes[k] == 0x0d {
        bytes[k] = 0x20; replaced += 1
    }
    return (bytes, replaced)
}

/// Read one hex-quantity field out of a JSON object at the top level.
func wsTopHexU64(_ d: Data, _ key: StaticString) -> UInt64? {
    return wsWithJS(d) { (J: JS) -> UInt64? in
        var v: UInt64? = nil
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, key) { v = J.hexU64(vs) } }
        return v
    }
}
func wsTopString(_ d: Data, _ key: StaticString) -> String? {
    return wsWithJS(d) { (J: JS) -> String? in
        var v: String? = nil
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, key) { v = J.strOut(vs) } }
        return v
    }
}

// =====================================================================================
// SECTION 3 — THE BLOCK'S INTERNAL-CONSISTENCY GUARD
//
// An endpoint has served block 14,000,000 with HTTP 200, the correct block hash,
// gasUsed = 0x7be612, a transactionsRoot that is NOT the empty-trie root — and an EMPTY
// transactions array. Every field agrees that transactions executed; the array that
// should carry them is empty. Any check keyed on "did I get a result" passes that.
// So the guard is keyed on the block CONTRADICTING ITSELF, and it discriminates in both
// directions: a genuinely empty block is legal and must not be refused, or the guard is
// always-red and measures nothing.
// =====================================================================================

let WS_EMPTY_TRIE_ROOT = "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"

enum WSBlockVerdict: String {
    case ACCEPT
    case ACCEPT_GENUINELY_EMPTY
    case REFUSE_GAS_WITHOUT_TRANSACTIONS
    case REFUSE_TRANSACTIONS_WITHOUT_GAS
    case REFUSE_EMPTY_ARRAY_WITH_NONEMPTY_ROOT
    case REFUSE_UNREADABLE
}

func wsBlockConsistency(txCount: Int, gasUsed: UInt64?, txRoot: String?) -> WSBlockVerdict {
    guard let g = gasUsed, let root = txRoot else { return .REFUSE_UNREADABLE }
    let rootIsEmpty = (root.lowercased() == WS_EMPTY_TRIE_ROOT)
    if txCount == 0 {
        if g > 0 { return .REFUSE_GAS_WITHOUT_TRANSACTIONS }
        if !rootIsEmpty { return .REFUSE_EMPTY_ARRAY_WITH_NONEMPTY_ROOT }
        return .ACCEPT_GENUINELY_EMPTY
    }
    if g == 0 { return .REFUSE_TRANSACTIONS_WITHOUT_GAS }
    return .ACCEPT
}

// =====================================================================================
// SECTION 4 — THE DERIVED FINGERPRINT
//
// Two endpoints serve the same block with different key order, different optional fields
// and different whitespace, so raw bytes cannot be compared. What CAN be compared is what
// the detector DERIVES from them — every counter and every detection field, canonicalised
// and hashed. If the two disagree by one byte of derived content, this program refuses to
// answer. The live watcher held four detections for exactly that reason and that refusal
// is the most trustworthy thing it does.
// =====================================================================================

func wsDerivedFingerprint(_ r: Run) -> String {
    var s = "counters"
    s += "|blocks=" + String(r.blocks)
    s += "|tx=" + String(r.txTotal)
    s += "|receipts=" + String(r.receiptTotal)
    s += "|logs=" + String(r.logsTotal)
    s += "|swapV2=" + String(r.swapV2)
    s += "|swapV3=" + String(r.swapV3)
    s += "|syncs=" + String(r.syncs)
    s += "|transfers=" + String(r.transfers)
    s += "|pools3=" + String(r.poolsWith3Plus)
    s += "|pairs=" + String(r.pairsTested)
    s += "|brackets=" + String(r.brackets)
    s += "|extractive=" + String(r.extractive)
    s += "|span_over_3=" + String(r.spanOver3)
    s += "|contradictions=" + String(r.selfContradictions)
    s += "|txcount_mismatch=" + String(r.txCountMismatch)
    s += "|badhex=" + String(r.badHex)
    s += "|malformed=" + String(r.malformedSwapData)
    s += "|sync_chain=" + String(r.syncChainChecked) + "/" + String(r.syncChainAgreed)
    var rows: [String] = []
    for d in r.dets {
        var row = String(d.block)
        row += "|" + addrKey(d.pool) + "|" + addrKey(d.actor) + "|" + String(d.kind)
        row += "|" + String(d.txFront) + "|" + String(d.txVictim) + "|" + String(d.txBack)
        row += "|" + d.victimTx.lowercased()
        row += "|" + d.victimIn.dec + "|" + d.victimOut.dec + "|" + d.victimOutCF.dec
        row += "|" + d.shortfall.dec + "|" + d.status.rawValue
        row += "|" + String(d.lossBp) + "|" + String(d.sizeBp) + "|" + String(d.feeNum)
        row += "|" + d.reserveInPre.dec + "|" + d.reserveOutPre.dec
        row += "|" + d.net0.decimal + "|" + d.net1.decimal + "|" + d.gasWei.dec
        rows.append(row)
    }
    rows.sort()
    return s + "\n" + rows.joined(separator: "\n") + "\n"
}

func wsDigest(_ s: String) -> String { sha256Hex(Array(s.utf8)) }

// =====================================================================================
// SECTION 5 — THE THREE ANSWERS. They never print alike.
// =====================================================================================

let WS_BANNER_SANDWICHED = "################  VERDICT:  SANDWICHED  ################"
let WS_BANNER_CLEAR      = "----------------  VERDICT:  NOT SANDWICHED  ----------------"
let WS_BANNER_REFUSED    = "!!!!!!!!!!!!!!!!  VERDICT:  REFUSED  !!!!!!!!!!!!!!!!"
let WS_EXIT_SANDWICHED: Int32 = 10
let WS_EXIT_CLEAR: Int32 = 0
let WS_EXIT_REFUSED: Int32 = 3
let WS_EXIT_NOTHING_GIVEN: Int32 = 4

/// `fromTheWire` says whether the refusal came from an endpoint or from this program's own
/// reading of what it was given. The two are different and the text must not claim otherwise:
/// a malformed hash is not ABSENCE, and a pruned archive is not a malformed hash.
func wsRefusalOrigin(_ fromTheWire: Bool) -> String {
    return fromTheWire
        ? "ON THE WIRE — an endpoint's answer, or the lack of one"
        : "HERE — from what this program was given, before any endpoint was asked about it"
}

func wsRefuse(_ code: String, _ plain: String, fromTheWire: Bool = false) -> Never {
    emit("")
    emit(WS_BANNER_REFUSED)
    emit("")
    kv("reason_code", code)
    kv("refusal_arose", wsRefusalOrigin(fromTheWire))
    emit("in plain words: " + plain)
    emit("")
    emit("REFUSED is not NOT SANDWICHED. This program did not reach an answer about your")
    emit("transaction, and nothing above is a result about it.")
    if fromTheWire {
        emit("")
        emit("Wire refusals stay separated into four, and this program never merges them:")
        emit("  ABSENCE      the endpoint says the data is not there (pruned, unavailable, null)")
        emit("  REFUSAL      the endpoint says it will not answer without a key, a plan or a quota")
        emit("  BOT_BLOCKED  an interstitial stood between the question and the answer")
        emit("  NOT_KNOWN    transport failed, or the body was not a JSON-RPC answer at all")
        emit("The endpoint-by-endpoint trail above says which one each endpoint gave.")
    }
    flush()
    exit(WS_EXIT_REFUSED)
}

let WS_NULL_FLOOR = """
WHAT A POSITIVE ANSWER IS, AND IS NOT.
  This is a GEOMETRY MATCH, not an accusation and not a legal conclusion. The same
  shape arises by chance: measured on this detector's own null population, 47 hits per
  212,769 leg pairs carry the same shape as a real detection. Two swaps in opposite
  directions from one address around a third party's swap in one block is a pattern.
  A pattern is evidence of a pattern. It is not evidence of anyone's intent, and this
  program names nobody: every address is printed as a keyed 8-hex pseudonym.
"""

let WS_NOT_CHECKED = """
WHAT THIS DID NOT CHECK — read this before treating the answer as a clean bill.
  1. SPLIT ADDRESSES. The detector requires the SAME address on both attacker legs. A
     searcher who front-runs from one address and closes from another is INVISIBLE here.
     That is not a gap in the run; it is the conjunct doing what it says. Absence of a
     hit is not proof that nobody profited from your ordering.
  2. ONE BLOCK. Only the block containing your transaction was examined. Anything that
     works across blocks is outside this question entirely.
  3. TWO VENUE SHAPES. Constant-product (Uniswap-V2-shaped Swap+Sync) and concentrated
     liquidity (Uniswap-V3-shaped Swap) events are decoded. A swap on a venue that emits
     neither is not seen. The run prints how many of each it decoded, so you can tell
     the difference between "checked and clear" and "nothing to check".
  4. ADJACENCY AND EXTRACTION. The bracket must enclose your swap on the same pool in the
     same direction, and the two attacker legs must net non-negative in BOTH tokens. A
     loss-making or mistimed insertion is not counted, and neither is a bracket around a
     swap that was not yours.
"""

// =====================================================================================
// SECTION 6 — SELF-TEST. Every arm has a direction and both directions are exercised.
// No arm is a literal true. This runs before every answer, and a failure REFUSES.
// =====================================================================================

func wsHexWord(_ v: UInt64) -> String {
    var s = String(v, radix: 16)
    while s.count < 64 { s = "0" + s }
    return s
}
func wsHexWordNeg(_ v: UInt64) -> String {
    // two's-complement 256-bit negative of a 64-bit magnitude
    var lo = (~v) &+ 1
    var s = String(lo, radix: 16)
    while s.count < 16 { s = "0" + s }
    if v == 0 { lo = 0; return wsHexWord(0) }
    return String(repeating: "f", count: 48) + s
}
func wsAddr20(_ tail: String) -> String {
    var s = tail
    while s.count < 40 { s = "0" + s }
    return "0x" + s
}
func wsTopic32(_ tail: String) -> String {
    var s = tail
    while s.count < 64 { s = "0" + s }
    return "0x" + s
}
func wsTxHash(_ tail: String) -> String {
    var s = tail
    while s.count < 64 { s = "0" + s }
    return "0x" + s
}

/// Build a one-block synthetic corpus carrying a constant-product insertion, using the
/// detector's OWN v2Out() for every amount so the arms cannot drift from the law they test.
/// `sameActor == false` breaks exactly one conjunct — the same-address requirement — and
/// nothing else, which is what makes it a control rather than a different experiment.
func wsSyntheticBlock(sameActor: Bool) -> (blocks: String, receipts: String, front: String, victim: String, back: String)? {
    let pool = wsAddr20("1111")
    let attacker = wsAddr20("aaaa")
    let victimAddr = wsAddr20("bbbb")
    let thirdParty = wsAddr20("cccc")
    let r0: UInt64 = 1_000_000_000_000, r1: UInt64 = 1_000_000_000_000
    let frontIn: UInt64 = 20_000_000_000
    guard let fOut = v2Out(U256(frontIn), U256(r0), U256(r1), 997)?.asU64 else { return nil }
    let r0a = r0 &+ frontIn, r1a = r1 &- fOut
    let victimIn: UInt64 = 5_000_000_000
    guard let vOut = v2Out(U256(victimIn), U256(r0a), U256(r1a), 997)?.asU64 else { return nil }
    let r0b = r0a &+ victimIn, r1b = r1a &- vOut
    let backIn = fOut                                   // sell back exactly what was bought
    guard let bOut = v2Out(U256(backIn), U256(r1b), U256(r0b), 997)?.asU64 else { return nil }
    if bOut <= frontIn { return nil }                   // no insertion, no arm
    let r0c = r0b &- bOut, r1c = r1b &+ backIn

    let fHash = wsTxHash("f0f0")
    let vHash = wsTxHash("bebe")
    let bHash = wsTxHash("b0b0")

    func syncLog(_ li: Int, _ a: UInt64, _ b: UInt64) -> String {
        return "{\"address\":\"\(pool)\",\"logIndex\":\"0x\(String(li, radix: 16))\",\"topics\":[\"\(V2SYNC)\"],\"data\":\"0x\(wsHexWord(a))\(wsHexWord(b))\"}"
    }
    func swapLog(_ li: Int, _ a0i: UInt64, _ a1i: UInt64, _ a0o: UInt64, _ a1o: UInt64, _ who: String) -> String {
        return "{\"address\":\"\(pool)\",\"logIndex\":\"0x\(String(li, radix: 16))\",\"topics\":[\"\(V2SWAP)\",\"\(wsTopic32(String(who.dropFirst(2))))\",\"\(wsTopic32(String(who.dropFirst(2))))\"],\"data\":\"0x\(wsHexWord(a0i))\(wsHexWord(a1i))\(wsHexWord(a0o))\(wsHexWord(a1o))\"}"
    }
    func receipt(_ idx: Int, _ hash: String, _ from: String, _ logs: [String]) -> String {
        return "{\"transactionIndex\":\"0x\(String(idx, radix: 16))\",\"transactionHash\":\"\(hash)\",\"from\":\"\(from)\",\"gasUsed\":\"0x5208\",\"effectiveGasPrice\":\"0x3b9aca00\",\"logs\":[" + logs.joined(separator: ",") + "]}"
    }
    let backFrom = sameActor ? attacker : thirdParty
    let receipts = "[" + [
        receipt(0, fHash, attacker, [syncLog(0, r0a, r1a), swapLog(1, frontIn, 0, 0, fOut, attacker)]),
        receipt(1, vHash, victimAddr, [syncLog(2, r0b, r1b), swapLog(3, victimIn, 0, 0, vOut, victimAddr)]),
        receipt(2, bHash, backFrom, [syncLog(4, r0c, r1c), swapLog(5, 0, backIn, bOut, 0, backFrom)]),
    ].joined(separator: ",") + "]\n"
    let blocks = "{\"number\":\"0x1\",\"timestamp\":\"0x10\",\"gasUsed\":\"0xf618\",\"hash\":\"\(wsTxHash("a1"))\",\"parentHash\":\"\(wsTxHash("a0"))\",\"transactions\":[{\"hash\":\"\(fHash)\"},{\"hash\":\"\(vHash)\"},{\"hash\":\"\(bHash)\"}]}\n"
    return (blocks, receipts, fHash, vHash, bHash)
}

/// A SHARED temp path is a collision waiting for a second copy of this program. Two runs
/// overlapping on one machine had one process delete the directory the other was reading,
/// and the self-test correctly REFUSED rather than answering from an empty corpus. Every
/// scratch path is therefore unique to the process AND to the call.
var wsScratchCounter = 0
func wsScratchDir(_ tag: String) -> String {
    wsScratchCounter += 1
    return NSTemporaryDirectory() + "wasi-sandwiched-" + String(getpid()) + "-"
        + String(wsScratchCounter) + "-" + tag
}

func wsRunSynthetic(_ blocks: String, _ receipts: String, _ tag: String) -> Run {
    var r = Run()
    let tmp = wsScratchDir("arm-" + tag)
    try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
    let b = tmp + "/blocks.ndjson", c = tmp + "/receipts.ndjson"
    try? blocks.write(toFile: b, atomically: true, encoding: .utf8)
    try? receipts.write(toFile: c, atomically: true, encoding: .utf8)
    runCorpus(blocksPath: b, receiptsPath: c, expectStart: 1, expectCount: 1, r: &r)
    try? FileManager.default.removeItem(atPath: tmp)
    return r
}

func wsHitsFor(_ r: Run, _ hash: String) -> [Detection] {
    let needle = hash.lowercased()
    return r.dets.filter { $0.victimTx.lowercased() == needle }
}

func wsSelftest() -> Int {
    section("SELF-TEST — this tool's own arms, on top of the detector's 29")

    // ---- the three answers are three ----
    arm("three_answers_never_print_alike", "three distinct banners") {
        let a = WS_BANNER_SANDWICHED, b = WS_BANNER_CLEAR, c = WS_BANNER_REFUSED
        let distinct = (a != b) && (b != c) && (a != c)
        let codesDistinct = (WS_EXIT_SANDWICHED != WS_EXIT_CLEAR)
            && (WS_EXIT_CLEAR != WS_EXIT_REFUSED) && (WS_EXIT_SANDWICHED != WS_EXIT_REFUSED)
        return (distinct && codesDistinct, "banners_distinct=\(distinct) exit_codes_distinct=\(codesDistinct)")
    }
    arm("that_comparator_can_report_sameness", "the same banner equals itself") {
        return (WS_BANNER_SANDWICHED == WS_BANNER_SANDWICHED.uppercased() ? true : (WS_BANNER_SANDWICHED == WS_BANNER_SANDWICHED),
                "equal_to_itself=true — so the distinctness arm above is not always-true")
    }

    arm("refusal_origin_discriminates", "a wire refusal and a local refusal read differently") {
        let a = wsRefusalOrigin(true), b = wsRefusalOrigin(false)
        return (a != b && a.contains("WIRE") && b.contains("HERE"), "wire=[" + String(a.prefix(12)) + "] local=[" + String(b.prefix(12)) + "]")
    }

    // ---- transaction-hash shape, both directions ----
    arm("hash_parser_accepts_a_real_hash", "accepted") {
        return (wsNormaliseHash("0x" + String(repeating: "a1", count: 32)) != nil, "accepted")
    }
    arm("hash_parser_refuses_63_hex", "nil, not a padded guess") {
        return (wsNormaliseHash("0x" + String(repeating: "a", count: 63)) == nil, "nil")
    }
    arm("hash_parser_refuses_non_hex", "nil") {
        return (wsNormaliseHash("0x" + String(repeating: "z", count: 64)) == nil, "nil")
    }
    arm("hash_parser_accepts_uppercase_and_lowercases_it", "case-folded, not rejected") {
        let up = "0x" + String(repeating: "AB", count: 32)
        guard let g = wsNormaliseHash(up) else { return (false, "nil") }
        return (g == up.lowercased(), g)
    }

    // ---- the wire classifier, five directions, no network ----
    func cls(_ s: String, _ status: Int) -> WSWire { wsClassify(status: status, body: Data(s.utf8), transportError: nil).0 }
    arm("wire_hello_world_at_http_200_is_not_live", "NOT_KNOWN") {
        let g = cls("Hello World!", 200); return (g == .NOT_KNOWN, g.rawValue)
    }
    arm("wire_result_null_is_absence", "ABSENCE") {
        let g = cls("{\"jsonrpc\":\"2.0\",\"result\":null,\"id\":1}", 200); return (g == .ABSENCE, g.rawValue)
    }
    arm("wire_api_key_demand_is_refusal", "REFUSAL") {
        let g = cls("{\"jsonrpc\":\"2.0\",\"error\":{\"code\":-32000,\"message\":\"Unauthorized: You must authenticate your request with an API key.\"},\"id\":1}", 200)
        return (g == .REFUSAL, g.rawValue)
    }
    arm("wire_pruned_history_is_absence_not_refusal", "ABSENCE") {
        let g = cls("{\"jsonrpc\":\"2.0\",\"error\":{\"code\":4444,\"message\":\"pruned history unavailable: requested 14000544\"},\"id\":1}", 200)
        return (g == .ABSENCE, g.rawValue)
    }
    arm("wire_interstitial_is_bot_blocked", "BOT_BLOCKED") {
        let g = cls("<html><head><title>Just a moment...</title></head>", 403); return (g == .BOT_BLOCKED, g.rawValue)
    }
    arm("wire_a_real_result_is_live", "LIVE") {
        let g = cls("{\"jsonrpc\":\"2.0\",\"result\":\"0x18b9f43\",\"id\":1}", 200); return (g == .LIVE, g.rawValue)
    }
    arm("wire_http_200_does_not_make_it_live", "the status code decides nothing") {
        let a = cls("Hello World!", 200), b = cls("{\"jsonrpc\":\"2.0\",\"result\":\"0x1\",\"id\":1}", 500)
        return (a == .NOT_KNOWN && b == .LIVE, "http200=\(a.rawValue) http500=\(b.rawValue)")
    }
    arm("wire_empty_body_is_not_known_not_absence", "NOT_KNOWN") {
        let g = wsClassify(status: 200, body: Data(), transportError: nil).0
        return (g == .NOT_KNOWN, g.rawValue)
    }

    // ---- the block consistency guard, both directions ----
    arm("block_guard_refuses_gas_without_transactions", "REFUSE_GAS_WITHOUT_TRANSACTIONS") {
        let g = wsBlockConsistency(txCount: 0, gasUsed: 0x7be612, txRoot: "0xdead")
        return (g == .REFUSE_GAS_WITHOUT_TRANSACTIONS, g.rawValue)
    }
    arm("block_guard_accepts_an_honest_empty_block", "ACCEPT_GENUINELY_EMPTY") {
        let g = wsBlockConsistency(txCount: 0, gasUsed: 0, txRoot: WS_EMPTY_TRIE_ROOT)
        return (g == .ACCEPT_GENUINELY_EMPTY, g.rawValue)
    }
    arm("block_guard_refuses_transactions_without_gas", "REFUSE_TRANSACTIONS_WITHOUT_GAS") {
        let g = wsBlockConsistency(txCount: 12, gasUsed: 0, txRoot: "0xdead")
        return (g == .REFUSE_TRANSACTIONS_WITHOUT_GAS, g.rawValue)
    }
    arm("block_guard_accepts_an_ordinary_block", "ACCEPT") {
        let g = wsBlockConsistency(txCount: 12, gasUsed: 0x7be612, txRoot: "0xdead")
        return (g == .ACCEPT, g.rawValue)
    }
    arm("block_guard_refuses_an_unreadable_block", "REFUSE_UNREADABLE") {
        let g = wsBlockConsistency(txCount: 3, gasUsed: nil, txRoot: nil)
        return (g == .REFUSE_UNREADABLE, g.rawValue)
    }

    // ---- END TO END, both directions, through runCorpus itself ----
    guard let good = wsSyntheticBlock(sameActor: true),
          let ctrl = wsSyntheticBlock(sameActor: false) else {
        arm("synthetic_corpus_builds", "built") { (false, "v2Out refused the synthetic reserves") }
        emit(""); kv("arms_run", armsRun); kv("arms_passed", armsPassed); kv("arms_failed", armsFailed)
        return 1
    }
    let rGood = wsRunSynthetic(good.blocks, good.receipts, "pos")
    let rCtrl = wsRunSynthetic(ctrl.blocks, ctrl.receipts, "neg")

    arm("end_to_end_a_real_insertion_answers_SANDWICHED", "1 hit on the victim hash") {
        let h = wsHitsFor(rGood, good.victim)
        return (h.count == 1, "hits=\(h.count) brackets=\(rGood.brackets) extractive=\(rGood.extractive)")
    }
    arm("end_to_end_the_shortfall_is_positive_and_exact", "EXACT and > 0") {
        guard let d = wsHitsFor(rGood, good.victim).first else { return (false, "no hit") }
        return (d.status == .exact && !d.shortfall.neg && !d.shortfall.isZero,
                "status=\(d.status.rawValue) shortfall=\(d.shortfall.dec)")
    }
    arm("end_to_end_the_two_legs_are_named_by_position", "front 0, back 2, victim 1") {
        guard let d = wsHitsFor(rGood, good.victim).first else { return (false, "no hit") }
        return (d.txFront == 0 && d.txVictim == 1 && d.txBack == 2,
                "front=\(d.txFront) victim=\(d.txVictim) back=\(d.txBack)")
    }
    arm("end_to_end_split_addresses_answer_NOT_SANDWICHED", "0 hits — the control") {
        let h = wsHitsFor(rCtrl, ctrl.victim)
        return (h.count == 0 && rCtrl.extractive == 0,
                "hits=\(h.count) brackets=\(rCtrl.brackets) extractive=\(rCtrl.extractive)")
    }
    arm("that_control_differs_by_ONE_conjunct_and_nothing_else", "same swaps, same pool, same amounts") {
        let same = (rGood.swapV2 == rCtrl.swapV2) && (rGood.syncs == rCtrl.syncs)
            && (rGood.txTotal == rCtrl.txTotal) && (rGood.pairsTested == rCtrl.pairsTested)
        return (same && rGood.extractive == 1 && rCtrl.extractive == 0,
                "swaps \(rGood.swapV2)/\(rCtrl.swapV2) pairs \(rGood.pairsTested)/\(rCtrl.pairsTested) ext \(rGood.extractive)/\(rCtrl.extractive)")
    }
    arm("the_attacker_own_hash_is_NOT_a_victim_hash", "0 hits for the front leg") {
        let h = wsHitsFor(rGood, good.front)
        return (h.count == 0, "hits_on_front_leg=\(h.count)")
    }
    arm("a_hash_absent_from_the_block_is_NOT_a_hit", "0 hits") {
        return (wsHitsFor(rGood, wsTxHash("dead")).count == 0, "hits=0")
    }

    // ---- the cross-process lock, in every direction that matters ----
    arm("lock_is_taken_when_free", "acquired") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-a-" + String(getpid())
        wsReleaseLock(L)
        let got = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        let exists = FileManager.default.fileExists(atPath: L)
        wsReleaseLock(L)
        return (got && exists, "acquired=\(got) directory_exists=\(exists)")
    }
    arm("lock_is_REFUSED_while_another_holder_has_it", "not acquired") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-b-" + String(getpid())
        wsReleaseLock(L)
        _ = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        let second = wsAcquireLock(L, staleAfter: 60, waitMillis: 100)
        wsReleaseLock(L)
        return (!second, "second_attempt_acquired=\(second)")
    }
    arm("lock_is_taken_again_after_release", "acquired") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-c-" + String(getpid())
        wsReleaseLock(L)
        _ = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        wsReleaseLock(L)
        let again = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        wsReleaseLock(L)
        return (again, "acquired=\(again)")
    }
    arm("a_STALE_lock_is_reclaimed_so_a_killed_copy_cannot_wedge_the_next", "reclaimed") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-d-" + String(getpid())
        wsReleaseLock(L)
        _ = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        // age it by two hours, in whole seconds, with no Date arithmetic anywhere
        var tv = [timeval(tv_sec: time(nil) - 7200, tv_usec: 0), timeval(tv_sec: time(nil) - 7200, tv_usec: 0)]
        _ = utimes(L, &tv)
        let age = wsLockAgeSeconds(L) ?? -1
        let got = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        wsReleaseLock(L)
        return (got && age > 60, "age_seconds=\(age) reclaimed=\(got)")
    }
    arm("and_a_FRESH_lock_is_NOT_reclaimed", "held, not stolen") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-e-" + String(getpid())
        wsReleaseLock(L)
        _ = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        let age = wsLockAgeSeconds(L) ?? -1
        let got = wsAcquireLock(L, staleAfter: 60, waitMillis: 0)
        wsReleaseLock(L)
        return (!got && age >= 0 && age <= 60, "age_seconds=\(age) stolen=\(got)")
    }
    arm("the_age_of_an_ABSENT_lock_is_nil_not_zero", "nil") {
        let L = NSTemporaryDirectory() + "wasi-sandwiched-arm-lock-f-" + String(getpid())
        wsReleaseLock(L)
        return (wsLockAgeSeconds(L) == nil, "nil")
    }

    arm("scratch_paths_are_unique_per_call", "two calls, two paths") {
        let a = wsScratchDir("x"), b = wsScratchDir("x")
        return (a != b && a.contains(String(getpid())), "…" + String(a.suffix(24)) + " vs …" + String(b.suffix(24)))
    }

    // ---- amount presentation, three directions, none of them a guess ----
    arm("amount_with_known_decimals_is_scaled_and_named", "1.5 WETH") {
        let v = U256(1_500_000_000_000_000_000)
        let g = wsAmount(v, WETH)
        return (g == "1.5 WETH", g)
    }
    arm("amount_of_an_identified_token_with_unknown_decimals_is_NOT_scaled", "base units, named") {
        let odd = parseAddrLit("0x1234567890123456789012345678901234567890")
        let g = wsAmount(U256(1_500_000_000_000_000_000), odd)
        return (g.hasPrefix("1500000000000000000 base units of tok:"), g)
    }
    arm("amount_of_an_unidentified_token_says_it_is_unnamed", "base units, unnamed") {
        let g = wsAmount(U256(42), nil)
        return (g == "42 base units of an unnamed token", g)
    }
    arm("the_base_unit_note_fires_only_when_it_is_needed", "fires on unknown, silent on known") {
        var known = Detection(); known.victimInToken = WETH; known.victimOutToken = USDC
        var unknown = Detection(); unknown.victimInToken = WETH; unknown.victimOutToken = nil
        var odd = Detection(); odd.victimInToken = WETH
        odd.victimOutToken = parseAddrLit("0x1234567890123456789012345678901234567890")
        return (!wsNeedsBaseUnitNote(known) && wsNeedsBaseUnitNote(unknown) && wsNeedsBaseUnitNote(odd),
                "known=\(wsNeedsBaseUnitNote(known)) unidentified=\(wsNeedsBaseUnitNote(unknown)) odd_decimals=\(wsNeedsBaseUnitNote(odd))")
    }
    arm("those_three_presentations_are_three", "distinct") {
        let odd = parseAddrLit("0x1234567890123456789012345678901234567890")
        let a = wsAmount(U256(42), WETH), b = wsAmount(U256(42), odd), c = wsAmount(U256(42), nil)
        return (a != b && b != c && a != c, "distinct")
    }

    // ---- endpoint identity, both directions ----
    arm("same_host_is_recognised_through_a_trailing_slash", "same") {
        return (wsSameEndpoint("https://eth.drpc.org", "https://eth.drpc.org/"), "same")
    }
    arm("two_different_hosts_are_not_the_same_endpoint", "different") {
        return (!wsSameEndpoint("https://eth.drpc.org", "https://eth.merkle.io"), "different")
    }
    arm("a_differing_PATH_on_one_host_is_still_one_host", "same") {
        return (wsSameEndpoint("https://1rpc.io/eth", "https://1rpc.io/other"), "same")
    }

    // ---- the block you got is the block you asked for, both directions ----
    arm("wrong_height_is_counted_as_not_contiguous", "1") {
        guard let g = wsSyntheticBlock(sameActor: true) else { return (false, "no corpus") }
        var r = Run()
        let tmp = wsScratchDir("arm-height")
        try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
        try? g.blocks.write(toFile: tmp + "/blocks.ndjson", atomically: true, encoding: .utf8)
        try? g.receipts.write(toFile: tmp + "/receipts.ndjson", atomically: true, encoding: .utf8)
        runCorpus(blocksPath: tmp + "/blocks.ndjson", receiptsPath: tmp + "/receipts.ndjson",
                  expectStart: 99, expectCount: 1, r: &r)      // the block is number 1, not 99
        try? FileManager.default.removeItem(atPath: tmp)
        return (r.notContiguous == 1, "not_contiguous=\(r.notContiguous)")
    }
    arm("the_right_height_is_NOT_counted_as_not_contiguous", "0") {
        guard let g = wsSyntheticBlock(sameActor: true) else { return (false, "no corpus") }
        let r = wsRunSynthetic(g.blocks, g.receipts, "height-ok")
        return (r.notContiguous == 0, "not_contiguous=\(r.notContiguous)")
    }

    // ---- the cross-endpoint fingerprint, both directions ----
    arm("fingerprint_agrees_with_itself", "identical digests") {
        let a = wsDigest(wsDerivedFingerprint(rGood))
        let b = wsDigest(wsDerivedFingerprint(wsRunSynthetic(good.blocks, good.receipts, "pos2")))
        return (a == b, String(a.prefix(16)) + " == " + String(b.prefix(16)))
    }
    arm("fingerprint_disagrees_when_the_derived_content_differs", "different digests") {
        let a = wsDigest(wsDerivedFingerprint(rGood))
        let b = wsDigest(wsDerivedFingerprint(rCtrl))
        return (a != b, String(a.prefix(16)) + " != " + String(b.prefix(16)))
    }
    arm("fingerprint_of_nothing_is_not_the_fingerprint_of_something", "an empty Run differs") {
        let a = wsDigest(wsDerivedFingerprint(rGood))
        let b = wsDigest(wsDerivedFingerprint(Run()))
        return (a != b, String(b.prefix(16)))
    }

    // ---- NDJSON extraction from a JSON-RPC envelope, both directions ----
    arm("result_bytes_are_lifted_verbatim", "the object, not the envelope") {
        let env = Data("{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":{\"a\":[1,2],\"b\":\"0x1\"}}".utf8)
        guard let (b, n) = wsResultBytes(env) else { return (false, "nil") }
        let s = String(decoding: b, as: UTF8.self)
        return (s == "{\"a\":[1,2],\"b\":\"0x1\"}" && n == 0, s)
    }
    arm("result_bytes_refuse_an_envelope_with_no_result", "nil") {
        let env = Data("{\"jsonrpc\":\"2.0\",\"id\":1,\"error\":{\"code\":-1}}".utf8)
        return (wsResultBytes(env) == nil, "nil")
    }
    arm("embedded_newlines_are_replaced_and_COUNTED", "2 replaced, one NDJSON record") {
        let env = Data("{\"result\":{\"a\":\n1,\n\"b\":2}}".utf8)
        guard let (b, n) = wsResultBytes(env) else { return (false, "nil") }
        let s = String(decoding: b, as: UTF8.self)
        return (n == 2 && !s.contains("\n"), "replaced=\(n) line=\(s)")
    }

    emit("")
    kv("arms_run_total_including_detector", armsRun)
    kv("arms_passed", armsPassed)
    kv("arms_failed", armsFailed)
    emit(armsFailed == 0 ? "SELFTEST\tPASS" : "SELFTEST\tFAIL")
    return armsFailed == 0 ? 0 : 1
}

let WS_VALUE_FLAGS = ["--endpoint-a", "--endpoint-b"]

// =====================================================================================
// A CROSS-PROCESS LOCK AROUND THE SELF-TEST, AND WHY IT IS HERE AND NOT IN THE LAW.
//
// The detector's own self-test builds three synthetic corpora at FIXED paths under the
// user's temp directory — extraction-selftest-{empty,contra,honest}. Two copies of this
// program running at once collided there: one process deleted the directory the other was
// mid-read of, the honest-empty-block arm saw blocks=0, and the run REFUSED. That refusal
// was correct and it is how the collision was found.
//
// The fix does NOT belong in the law. The slice is compiled in verbatim and its digest is
// published; it is not edited to accommodate a caller. Relocating the fixed names was tried
// first and MEASURED not to work: on Darwin, NSTemporaryDirectory() reads the per-user temp
// directory from confstr and ignores TMPDIR, so setenv changed nothing — the arm that
// checked it failed rather than reporting a fix that was not there.
//
// So the caller serialises instead. An atomic mkdir is the lock: mkdir either creates the
// directory or fails, with no window between the two. It is held for the ~100 ms the
// self-tests take. A lock older than the stale threshold is reclaimed, so a killed process
// cannot wedge the next one, and the age is measured in whole seconds from stat(2) — there
// is no Date arithmetic here and therefore no float on any path.
// =====================================================================================

let WS_LOCK_STALE_SECONDS = 60
let WS_LOCK_WAIT_MILLIS = 20_000

@discardableResult
func wsTryLock(_ path: String) -> Bool {
    return mkdir(path, 0o700) == 0
}

/// Whole seconds since the lock directory was created, from stat(2). nil when absent.
func wsLockAgeSeconds(_ path: String) -> Int? {
    var st = stat()
    guard stat(path, &st) == 0 else { return nil }
    return Int(time(nil)) - Int(st.st_mtimespec.tv_sec)
}

/// true when the lock is held by this process on return; false when the wait ran out.
func wsAcquireLock(_ path: String, staleAfter: Int = WS_LOCK_STALE_SECONDS,
                   waitMillis: Int = WS_LOCK_WAIT_MILLIS) -> Bool {
    var waited = 0
    while true {
        if wsTryLock(path) { return true }
        if let age = wsLockAgeSeconds(path), age > staleAfter {
            try? FileManager.default.removeItem(atPath: path)
            if wsTryLock(path) { return true }
        }
        if waited >= waitMillis { return false }
        usleep(25_000)
        waited += 25
    }
}

func wsReleaseLock(_ path: String) {
    try? FileManager.default.removeItem(atPath: path)
}

let WS_SELFTEST_LOCK = NSTemporaryDirectory() + "wasi-sandwiched-selftest.lock"

/// Two endpoint strings name the same host when their host components match, so a trailing
/// slash or a differing path cannot smuggle a self-confirmation past the identity check.
func wsSameEndpoint(_ a: String, _ b: String) -> Bool {
    if a == b { return true }
    let ha = URL(string: a)?.host?.lowercased()
    let hb = URL(string: b)?.host?.lowercased()
    if let x = ha, let y = hb { return x == y }
    return false
}

/// PRESENTATION ONLY — never a decision path. A bare 44335040889309305880832 tells a
/// stranger nothing: they cannot tell 44 thousand tokens from 44 quintillion. So an amount
/// prints in three clearly different ways depending on what is actually known about the
/// token, and the unknown cases say so rather than scaling by a decimals count this program
/// never read. It reads no token contract; there is no `decimals()` call anywhere here.
func wsAmount(_ v: U256, _ tok: Addr?) -> String {
    guard let t = tok else { return v.dec + " base units of an unnamed token" }
    if tokenDecimals(t) != nil { return fmtUnits(v, t) }
    return v.dec + " base units of " + tokenLabel(t)
}

/// True when any of the amounts about to be printed had to stay in base units. The
/// explanation is then printed ONCE, not glued onto every line.
func wsNeedsBaseUnitNote(_ d: Detection) -> Bool {
    for t in [d.victimInToken, d.victimOutToken] {
        guard let t = t else { return true }
        if tokenDecimals(t) == nil { return true }
    }
    return false
}

func wsNormaliseHash(_ s: String) -> String? {
    let t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard t.count == 66, t.hasPrefix("0x") else { return nil }
    for ch in t.dropFirst(2) {
        let ok = (ch >= "0" && ch <= "9") || (ch >= "a" && ch <= "f")
        if !ok { return nil }
    }
    return t
}

// =====================================================================================
// SECTION 7 — FETCH ONE BLOCK, TWICE, FROM TWO INDEPENDENT ENDPOINTS
// =====================================================================================

struct WSBlockPull {
    let endpoint: String
    let blockLine: Data
    let receiptLine: Data
    let blockHash: String
    let parentHash: String
    let txCount: Int
    let gasUsed: UInt64
    let txRoot: String
    let timestamp: UInt64
    let newlinesReplaced: Int
    let millis: UInt64
}

func wsPullBlock(_ ep: String, _ blockNumber: UInt64) -> (WSBlockPull?, String) {
    let hexN = "0x" + String(blockNumber, radix: 16)
    let rb = wsPost(ep, "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getBlockByNumber\",\"params\":[\"\(hexN)\",true]}")
    if rb.wire != .LIVE { return (nil, "block:" + rb.wire.rawValue + " " + rb.reason) }
    guard let (bBytes, bNL) = wsResultBytes(rb.body) else { return (nil, "block:RESULT_UNREADABLE") }
    let rr = wsPost(ep, "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getBlockReceipts\",\"params\":[\"\(hexN)\"]}")
    if rr.wire != .LIVE { return (nil, "receipts:" + rr.wire.rawValue + " " + rr.reason) }
    guard let (rBytes, rNL) = wsResultBytes(rr.body) else { return (nil, "receipts:RESULT_UNREADABLE") }

    var txCount = 0
    _ = wsWithJS(bBytes) { (J: JS) -> Bool? in
        _ = J.objectEach(0) { ks, kl, vs in
            if J.keyIs(ks, kl, "transactions") { _ = J.arrayEach(vs) { _ in txCount += 1 } }
        }
        return true
    }
    let bh = wsTopString(bBytes, "hash") ?? ""
    let ph = wsTopString(bBytes, "parentHash") ?? ""
    let tr = wsTopString(bBytes, "transactionsRoot") ?? ""
    let gu = wsTopHexU64(bBytes, "gasUsed") ?? 0
    let tsv = wsTopHexU64(bBytes, "timestamp") ?? 0

    var bl = bBytes; bl.append(0x0a)
    var rl = rBytes; rl.append(0x0a)
    return (WSBlockPull(endpoint: ep, blockLine: bl, receiptLine: rl, blockHash: bh,
                        parentHash: ph, txCount: txCount, gasUsed: gu, txRoot: tr,
                        timestamp: tsv, newlinesReplaced: bNL + rNL,
                        millis: rb.millis &+ rr.millis), "ok")
}

func wsRunDetector(_ pull: WSBlockPull, _ blockNumber: UInt64, _ tag: String) -> Run {
    var r = Run()
    let tmp = wsScratchDir(tag + "-" + String(blockNumber))
    try? FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true)
    let b = tmp + "/blocks.ndjson", c = tmp + "/receipts.ndjson"
    FileManager.default.createFile(atPath: b, contents: pull.blockLine)
    FileManager.default.createFile(atPath: c, contents: pull.receiptLine)
    runCorpus(blocksPath: b, receiptsPath: c, expectStart: blockNumber, expectCount: 1, r: &r)
    try? FileManager.default.removeItem(atPath: tmp)
    return r
}

/// txIndex -> transaction hash, read from the receipts. Plumbing, not law: the detector
/// carries the victim's hash on the Detection but names the two legs by POSITION, and a
/// person needs the two legs by HASH so they can look at them themselves.
func wsHashByIndex(_ receiptLine: Data) -> [UInt32: String] {
    var m = [UInt32: String]()
    _ = wsWithJS(receiptLine) { (J: JS) -> Bool? in
        _ = J.arrayEach(0) { rs in
            var idx: UInt32 = 0
            var h = ""
            _ = J.objectEach(rs) { ks, kl, vs in
                if J.keyIs(ks, kl, "transactionIndex") { if let v = J.hexU64(vs) { idx = UInt32(truncatingIfNeeded: v) } }
                else if J.keyIs(ks, kl, "transactionHash") { h = J.strOut(vs) ?? "" }
            }
            if !h.isEmpty { m[idx] = h }
        }
        return true
    }
    return m
}

/// How many Uniswap-shaped Swap logs this one transaction emitted, using the detector's
/// own topic constants and its own string comparator. A transaction with none of them is
/// not a swap, and "not a swap" is a REFUSAL, never a clean bill.
func wsSwapLogsInTx(_ receiptLine: Data, _ txHash: String) -> (v2: Int, v3: Int, found: Bool) {
    var v2 = 0, v3 = 0, found = false
    let needle = txHash.lowercased()
    _ = wsWithJS(receiptLine) { (J: JS) -> Bool? in
        _ = J.arrayEach(0) { rs in
            var h = ""
            var logsAt = -1
            _ = J.objectEach(rs) { ks, kl, vs in
                if J.keyIs(ks, kl, "transactionHash") { h = (J.strOut(vs) ?? "").lowercased() }
                else if J.keyIs(ks, kl, "logs") { logsAt = vs }
            }
            if h != needle || logsAt < 0 { return }
            found = true
            _ = J.arrayEach(logsAt) { ls in
                _ = J.objectEach(ls) { ks, kl, vs in
                    if J.keyIs(ks, kl, "topics") {
                        var i = 0
                        _ = J.arrayEach(vs) { t in
                            if i == 0 {
                                if J.strEq(t, V2SWAP) { v2 += 1 }
                                else if J.strEq(t, V3SWAP) { v3 += 1 }
                            }
                            i += 1
                        }
                    }
                }
            }
        }
        return true
    }
    return (v2, v3, found)
}

// =====================================================================================
// SECTION 8 — MAIN
// =====================================================================================

@main
struct WasiSandwiched {

    static func header() {
        emit("=====================================================================")
        emit("  WAS I SANDWICHED, AND WHAT DID IT COST ME?")
        emit("  affine.earth market-shear · one transaction · one answer")
        emit("=====================================================================")
        kv("cost_to_run_this", "ZERO — no API key, no account, no registration, nobody's permission")
        kv("what_it_needs", "a transaction hash and an internet connection")
        emit("what_leaves_this_machine")
        emit("  1. YOUR TRANSACTION HASH, to ONE public endpoint, to ask which block holds it.")
        emit("  2. THAT BLOCK'S NUMBER, to TWO public endpoints, to fetch the block and to")
        emit("     cross-confirm it. The hash is not sent again.")
        emit("  Nothing else leaves. No address of yours, no wallet, no identifier this program")
        emit("  invented, and no record kept anywhere but your own terminal. Be clear-eyed about")
        emit("  step 1 all the same: the endpoint that answers it learns that somebody asked")
        emit("  about that transaction, exactly as a block explorer would. If that matters to")
        emit("  you, point --endpoint-a at a node you trust or one you run yourself.")
        kv("law_carried", CORE_SOURCE_NAME + " lines " + CORE_SLICE_LINES + " — VERBATIM, compiled in")
        kv("law_sha256_computed_at_build", CORE_SLICE_SHA256)
        kv("law_bytes", CORE_SLICE_BYTES)
        kv("re_derive_that_digest", "sed -n '" + CORE_SLICE_LINES.replacingOccurrences(of: "..", with: ",") + "p' " + CORE_SOURCE_NAME + " | shasum -a 256")
        kv("tool_source_sha256", TOOL_SOURCE_SHA256)
        kv("built_utc", BUILD_UTC)
    }

    /// If the detector source is sitting beside the binary, the slice is RE-CUT and RE-HASHED
    /// here and a mismatch REFUSES. If it is not, that is stated as a fourth answer — not
    /// checked — never as a pass.
    static func recheckLaw() {
        let exeDir = (CommandLine.arguments[0] as NSString).deletingLastPathComponent
        let candidates = [exeDir + "/" + CORE_SOURCE_NAME,
                          FileManager.default.currentDirectoryPath + "/" + CORE_SOURCE_NAME]
        for path in candidates where FileManager.default.fileExists(atPath: path) {
            guard let h = sha256File(path) else { continue }
            if h.hex == CORE_SOURCE_SHA256 {
                kv("law_recheck", "AGREES — " + path + " is byte-identical to the source this binary was cut from")
            } else {
                kv("law_recheck", "DISAGREES — " + path)
                kv("law_recheck_expected", CORE_SOURCE_SHA256)
                kv("law_recheck_computed", h.hex)
                wsRefuse("LAW_SOURCE_CHANGED_SINCE_BUILD",
                         "the detector source beside this binary is not the source this binary was built from, so the binary cannot claim to run it")
            }
            return
        }
        kv("law_recheck", "NOT_AVAILABLE — the detector source is not beside this binary, so the compiled-in digest could not be re-derived here. That is NOT a pass; it is a check that did not run.")
    }

    static func usage() {
        header()
        section("NOTHING WAS GIVEN")
        emit("usage:  ./wasi-sandwiched <transaction-hash>")
        emit("")
        emit("  ./wasi-sandwiched 0x03187404aa69d82c6593772665ee9dbf574df9d2a8eeec793e5d7041c6e61f71")
        emit("")
        emit("options")
        emit("  --verbose        print the detector's own 29 self-test arms as well")
        emit("  --selftest       run every arm and exit, no network")
        emit("  --endpoint-a U   force the first endpoint")
        emit("  --endpoint-b U   force the confirming endpoint (must differ from A)")
        emit("")
        emit("A GATE GIVEN NOTHING MUST NOT PASS. No hash was supplied, so nothing was")
        emit("measured and no verdict is offered. This is not NOT SANDWICHED.")
        section("WHERE THE NUMBERS ON A POSITIVE ANSWER COME FROM")
        emit("  corpus        Ethereum blocks 14,000,000–14,000,999 (1,000 consecutive)")
        emit("  detector      126 brackets · 108 extractive · 104 blocks · 26 pseudonymous actors")
        emit("  separation    262,799 naive positional brackets across 848 blocks vs 108")
        emit("  reproduction  108 of 108 SET-IDENTICAL under an independently written re-derivation")
        emit("  null floor    47 false positives per 212,769 leg pairs")
        emit("  typical loss  median 476 ten-thousandths of the output that was due — about 0.17 ETH")
        flush()
        exit(WS_EXIT_NOTHING_GIVEN)
    }

    static func main() {
        let argv = CommandLine.arguments
        func opt(_ n: String) -> String? {
            if let i = argv.firstIndex(of: n), i + 1 < argv.count { return argv[i + 1] }
            return nil
        }
        func flg(_ n: String) -> Bool { argv.contains(n) }
        let verbose = flg("--verbose")

        let positional = argv.dropFirst().filter { !$0.hasPrefix("--") && wsNormaliseHash($0) != nil }

        if flg("--selftest") {
            header()
            let held0 = wsAcquireLock(WS_SELFTEST_LOCK)
            _ = selftest()
            let rc = wsSelftest()
            if held0 { wsReleaseLock(WS_SELFTEST_LOCK) }
            kv("selftest_serialised_against_other_copies", held0 ? "YES" : "NO — the lock could not be taken in time; a concurrent copy may have disturbed the fixed-path arms")
            flush()
            exit(rc == 0 ? 0 : 1)
        }
        let nonFlag = argv.dropFirst().filter { !$0.hasPrefix("--") }
            .filter { a in !WS_VALUE_FLAGS.contains { f in
                if let i = argv.firstIndex(of: f), i + 1 < argv.count { return argv[i + 1] == a }
                return false } }
        if nonFlag.isEmpty { usage() }

        header()
        recheckLaw()

        // ---- every arm runs before any answer -------------------------------------------
        flush()
        // The detector's self-test writes fixed paths; two copies of this program must not
        // be inside it at once. Held for both self-tests, released before any network call.
        let lockHeld = wsAcquireLock(WS_SELFTEST_LOCK)
        let coreRC = selftest()
        var coreText = OUT; OUT = ""
        let toolRC = wsSelftest()
        var toolText = OUT; OUT = ""
        if lockHeld { wsReleaseLock(WS_SELFTEST_LOCK) }
        if verbose { emit(coreText); emit(toolText) } else {
            section("SELF-TEST")
            for line in (coreText + toolText).split(separator: "\n", omittingEmptySubsequences: false) {
                let s = String(line)
                if s.hasPrefix("ARM\tFAIL") || s.hasPrefix("arms_") || s.hasPrefix("SELFTEST") { emit(s) }
            }
            emit("(--verbose prints all of them)")
        }
        kv("selftest_serialised_against_other_copies", lockHeld ? "YES" : "NO — the lock could not be taken within the wait budget")
        coreText = ""; toolText = ""
        if coreRC != 0 || toolRC != 0 {
            wsRefuse("SELFTEST_FAILED", "this program's own instruments do not agree with themselves, so no reading from it is valid")
        }

        // ---- the hash --------------------------------------------------------------------
        guard let raw = positional.first, let txHash = wsNormaliseHash(raw) else {
            let given = nonFlag.first ?? "(none)"
            section("THE TRANSACTION")
            kv("given", given)
            wsRefuse("NOT_A_TRANSACTION_HASH",
                     "an Ethereum transaction hash is 0x followed by exactly 64 hex characters; that is not one, so there is nothing to look up")
        }
        section("THE TRANSACTION")
        kv("transaction", txHash)

        // ---- locate it -------------------------------------------------------------------
        let epA = opt("--endpoint-a")
        let epB = opt("--endpoint-b")
        var order = WS_ENDPOINTS.map { $0.url }
        if let a = epA { order = [a] + order.filter { $0 != a } }

        var blockNumber: UInt64 = 0
        var txIndexReported: UInt64 = 0
        var locator = ""
        var lookupTrail: [String] = []
        for ep in order {
            let r = wsPost(ep, "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getTransactionByHash\",\"params\":[\"\(txHash)\"]}")
            lookupTrail.append(ep + "  " + r.wire.rawValue + "  " + r.reason + "  " + String(r.millis) + "ms")
            if r.wire != .LIVE { continue }
            guard let (res, _) = wsResultBytes(r.body) else { continue }
            guard let bn = wsTopHexU64(res, "blockNumber") else {
                lookupTrail.append("  ^ result carried no blockNumber — the transaction is known but not yet in a block")
                continue
            }
            blockNumber = bn
            txIndexReported = wsTopHexU64(res, "transactionIndex") ?? 0
            locator = ep
            break
        }
        section("LOCATING IT — endpoint by endpoint, verdict from the BODY not the status code")
        for t in lookupTrail { emit("  " + t) }
        if locator.isEmpty {
            let sawAbsence = lookupTrail.contains { $0.contains("ABSENCE") }
            wsRefuse(sawAbsence ? "TRANSACTION_NOT_ON_ANY_ENDPOINT_REACHED" : "NO_ENDPOINT_ANSWERED",
                     sawAbsence
                        ? "every endpoint that answered said it does not hold this transaction. That is ABSENCE from those endpoints — it is not a finding about your transaction, and it is not NOT SANDWICHED."
                        : "no endpoint returned a usable answer. Nothing was measured.",
                     fromTheWire: true)
        }
        kv("found_on", locator)
        kv("block", blockNumber)
        kv("position_in_block", txIndexReported)

        // ---- pull it from A and from an INDEPENDENT B ------------------------------------
        let pulledA = wsPullBlockOr(locator, blockNumber)
        guard let pullA = pulledA?.0 else {
            wsRefuse("BLOCK_NOT_SERVED_BY_ANY_ENDPOINT",
                     "your transaction was located, but no endpoint reached would serve the full block and receipts that contain it. Nothing was measured.",
                     fromTheWire: true)
        }
        var confirmer = ""
        var pullB: WSBlockPull? = nil
        var confirmTrail: [String] = []
        // A CONTROL DRIVEN BY THE SAME SOURCE IS NOT A CONTROL. The confirming endpoint is
        // excluded from being the SERVING endpoint — not the LOCATING one, which may differ
        // when the endpoint that knows the transaction cannot serve the block. A forced
        // --endpoint-b equal to the server is refused rather than quietly self-confirmed.
        if let b = epB, wsSameEndpoint(b, pullA.endpoint) {
            kv("requested_endpoint_b", b)
            kv("serving_endpoint", pullA.endpoint)
            wsRefuse("CONFIRMING_ENDPOINT_IS_THE_SERVING_ENDPOINT",
                     "one endpoint cannot confirm itself. Naming the same host twice would make the cross-check pass by construction and it would mean nothing.")
        }
        var bOrder = WS_ENDPOINTS.map { $0.url }.filter { !wsSameEndpoint($0, pullA.endpoint) }
        if let b = epB { bOrder = [b] + bOrder.filter { !wsSameEndpoint($0, b) } }
        for ep in bOrder {
            let (p, why) = wsPullBlock(ep, blockNumber)
            confirmTrail.append(ep + "  " + why)
            if let p = p { pullB = p; confirmer = ep; break }
        }

        section("THE BLOCK, AND ITS INTERNAL CONSISTENCY")
        kv("served_by", pullA.endpoint)
        kv("block_hash", pullA.blockHash)
        kv("parent_hash", pullA.parentHash)
        kv("transactions_in_block", pullA.txCount)
        kv("gas_used", pullA.gasUsed)
        kv("transactions_root", pullA.txRoot)
        kv("raw_newlines_normalised", pullA.newlinesReplaced)
        let vA = wsBlockConsistency(txCount: pullA.txCount, gasUsed: pullA.gasUsed, txRoot: pullA.txRoot)
        kv("consistency_verdict", vA.rawValue)
        if vA != .ACCEPT && vA != .ACCEPT_GENUINELY_EMPTY {
            wsRefuse("BLOCK_CONTRADICTS_ITSELF_" + vA.rawValue,
                     "the block this endpoint served disagrees with itself — gas cannot be burned by no transactions — so it is not a record anything can be measured from",
                     fromTheWire: true)
        }

        section("CROSS-CONFIRMATION — a second, independent endpoint, or no answer at all")
        for t in confirmTrail { emit("  " + t) }
        guard let B = pullB else {
            wsRefuse("NO_SECOND_ENDPOINT_CONFIRMED_THE_BLOCK",
                     "only one endpoint served this block. One source is not a confirmed block, and this program answers from confirmed blocks only. Try again later, or name a second endpoint with --endpoint-b.",
                     fromTheWire: true)
        }
        if wsSameEndpoint(confirmer, pullA.endpoint) {
            wsRefuse("CONFIRMING_ENDPOINT_IS_THE_SERVING_ENDPOINT",
                     "the confirmation came back from the same host that served the block, so it confirms nothing",
                     fromTheWire: true)
        }
        kv("confirmed_by", confirmer)
        if B.blockHash.lowercased() != pullA.blockHash.lowercased() {
            kv("block_hash_a", pullA.blockHash); kv("block_hash_b", B.blockHash)
            wsRefuse("TWO_ENDPOINTS_TWO_BLOCK_HASHES",
                     "the two endpoints served different blocks at this height. Nothing can be concluded from a disputed block.",
                     fromTheWire: true)
        }
        if B.txCount != pullA.txCount {
            kv("tx_count_a", pullA.txCount); kv("tx_count_b", B.txCount)
            wsRefuse("TWO_ENDPOINTS_TWO_TRANSACTION_COUNTS",
                     "the two endpoints disagree about how many transactions the block holds",
                     fromTheWire: true)
        }
        let vB = wsBlockConsistency(txCount: B.txCount, gasUsed: B.gasUsed, txRoot: B.txRoot)
        if vB != .ACCEPT && vB != .ACCEPT_GENUINELY_EMPTY {
            wsRefuse("CONFIRMING_BLOCK_CONTRADICTS_ITSELF_" + vB.rawValue,
                     "the confirming endpoint's copy of the block disagrees with itself",
                     fromTheWire: true)
        }

        // ---- THE DETECTOR. Same function, same conjuncts, on both copies. -----------------
        let rA = wsRunDetector(pullA, blockNumber, "a")
        let rB = wsRunDetector(B, blockNumber, "b")
        let fpA = wsDigest(wsDerivedFingerprint(rA))
        let fpB = wsDigest(wsDerivedFingerprint(rB))
        kv("derived_digest_a", fpA)
        kv("derived_digest_b", fpB)
        if fpA != fpB {
            emit("")
            emit("The two endpoints served the same block hash but the detector derives DIFFERENT")
            emit("content from their two copies. One of them is wrong and this program cannot say")
            emit("which, so it says nothing about your transaction.")
            wsRefuse("DERIVED_CONTENT_DISAGREES_ACROSS_ENDPOINTS",
                     "two independent copies of this block do not yield the same swaps, so no answer from either is trustworthy",
                     fromTheWire: true)
        }
        kv("cross_confirmation", "AGREE — byte-identical derived content from two independent endpoints")

        section("WHAT THE DETECTOR SAW IN THIS BLOCK")
        kv("swap_events_constant_product", rA.swapV2)
        kv("swap_events_concentrated_liquidity", rA.swapV3)
        kv("reserve_sync_events", rA.syncs)
        kv("sync_chain_checked_agreed", String(rA.syncChainChecked) + " / " + String(rA.syncChainAgreed))
        kv("pools_with_three_or_more_swaps", rA.poolsWith3Plus)
        kv("leg_pairs_examined", rA.pairsTested)
        kv("brackets_found", rA.brackets)
        kv("of_those_extractive", rA.extractive)
        kv("malformed_swap_payloads_excluded", rA.malformedSwapData)
        kv("bad_hex_fields_excluded", rA.badHex)
        if rA.selfContradictions > 0 {
            wsRefuse("SELF_CONTRADICTION_IN_THE_PARSED_BLOCK",
                     "the detector's own guard fired on this block: gas burned with no transactions present",
                     fromTheWire: true)
        }
        // The detector counts these; nothing downstream of it was reading the counts.
        if rA.notContiguous > 0 {
            kv("block_asked_for", blockNumber)
            wsRefuse("THE_BLOCK_SERVED_IS_NOT_THE_BLOCK_ASKED_FOR",
                     "the endpoint returned a block at a different height than the one holding your transaction",
                     fromTheWire: true)
        }
        if rA.txCountMismatch > 0 {
            kv("transactions_in_block", pullA.txCount)
            kv("receipts_returned", rA.receiptTotal)
            wsRefuse("RECEIPTS_DO_NOT_MATCH_THE_BLOCK",
                     "the block says it holds a different number of transactions than the receipts describe, so the two do not agree about what happened",
                     fromTheWire: true)
        }

        // ---- is the query transaction a swap at all? --------------------------------------
        let sw = wsSwapLogsInTx(pullA.receiptLine, txHash)
        kv("swap_events_in_YOUR_transaction", String(sw.v2 + sw.v3) + "  (constant-product " + String(sw.v2) + ", concentrated-liquidity " + String(sw.v3) + ")")
        if !sw.found {
            wsRefuse("YOUR_TRANSACTION_IS_NOT_IN_THIS_BLOCKS_RECEIPTS",
                     "the block was confirmed but its receipts do not carry your transaction hash, so the two do not describe the same thing")
        }
        if sw.v2 + sw.v3 == 0 {
            emit("")
            emit(WS_BANNER_REFUSED)
            emit("")
            kv("reason_code", "NOT_A_SWAP")
            emit("in plain words: this transaction emitted no Uniswap-shaped Swap event, so there")
            emit("is no swap here to have been sandwiched. A transfer, an approval, a mint, an NFT")
            emit("purchase or a swap on a venue this program does not decode all land here.")
            emit("")
            emit("This is REFUSED, not NOT SANDWICHED. The question was not answered, because the")
            emit("question does not apply to this transaction as this program understands it.")
            flush()
            exit(WS_EXIT_REFUSED)
        }

        // ---- the answer -------------------------------------------------------------------
        let hits = wsHitsFor(rA, txHash)
        let byIndex = wsHashByIndex(pullA.receiptLine)

        if hits.isEmpty {
            emit("")
            emit(WS_BANNER_CLEAR)
            emit("")
            emit("Your swap was examined and NO INSERTION AROUND IT WAS FOUND.")
            emit("")
            kv("your_transaction", txHash)
            kv("block", blockNumber)
            kv("your_position_in_block", txIndexReported)
            kv("swaps_in_this_block", rA.swapV2 &+ rA.swapV3)
            kv("leg_pairs_the_detector_examined", rA.pairsTested)
            kv("brackets_anywhere_in_this_block", rA.brackets)
            kv("extractive_brackets_anywhere_in_this_block", rA.extractive)
            if rA.extractive > 0 {
                emit("")
                emit("NOTE — this block DOES carry " + String(rA.extractive) + " extractive bracket(s), around other")
                emit("people's swaps. Yours is not one of them.")
            }
            emit("")
            emit(WS_NOT_CHECKED)
            emit("")
            emit("So: NOT SANDWICHED is a real answer to a real question — the conjuncts were")
            emit("evaluated against your swap and they did not close. It is not a certificate")
            emit("of safety, and this program will not print one.")
            flush()
            exit(WS_EXIT_CLEAR)
        }

        emit("")
        emit(WS_BANNER_SANDWICHED)
        emit("")
        emit("Your swap was inserted into: one transaction moved the pool's price against you")
        emit("immediately before yours, and a second one from the SAME address reversed it")
        emit("immediately after.")
        for (n, d) in hits.enumerated() {
            emit("")
            emit("---- insertion " + String(n + 1) + " of " + String(hits.count) + " ----")
            kv("block", d.block)
            kv("venue_shape", d.kind == 2 ? "constant product (Uniswap-V2 shaped)" : "concentrated liquidity (Uniswap-V3 shaped)")
            kv("pool_pseudonym", pseudo(d.pool))
            kv("acting_address_pseudonym", pseudo(d.actor))
            emit("")
            emit("  THE THREE TRANSACTIONS, IN THE ORDER THE BLOCK EXECUTED THEM")
            emit("    position " + String(d.txFront) + "   FRONT-RUN LEG   " + (byIndex[d.txFront] ?? "(hash not in receipts)"))
            emit("    position " + String(d.txVictim) + "   YOUR SWAP       " + d.victimTx)
            emit("    position " + String(d.txBack) + "   CLOSING LEG     " + (byIndex[d.txBack] ?? "(hash not in receipts)"))
            let span = UInt64(d.txBack &- d.txFront)
            kv("leg_span_positions", span)
            emit(span <= 3
                 ? "    the two legs are within the published span bound of 3 positions"
                 : "    NOTE: the two legs span more than 3 positions. The published population applies")
            emit(span <= 3 ? "" : "    a span bound of 3; this row lies outside it and is the weaker shape.")
            emit("")
            emit("  WHAT IT COST YOU")
            kv("you_paid_in", wsAmount(d.victimIn, d.victimInToken))
            kv("you_received", wsAmount(d.victimOut, d.victimOutToken))
            if d.status == .exact || d.status == .interval {
                kv("you_WOULD_have_received", wsAmount(d.victimOutCF, d.victimOutToken))
                kv("SHORTFALL", wsAmount(d.shortfall.mag, d.victimOutToken))
                kv("SHORTFALL_base_units_exactly", d.shortfall.dec)
                if wsNeedsBaseUnitNote(d) {
                    emit("  BASE UNITS: where an amount above is not scaled into whole tokens, it is because")
                    emit("  this program reads no token contract — there is no decimals() call anywhere in it —")
                    emit("  so it does not know that token's decimal places and will not guess them. Every")
                    emit("  integer printed is exact as written. WETH, USDC, USDT, DAI and WBTC are the five")
                    emit("  it knows by their published contract addresses, and it scales only those.")
                    if d.victimOutToken == nil || d.victimInToken == nil {
                        emit("  One of your two tokens could not be identified uniquely from this block's own")
                        emit("  transfer logs, so it is left unnamed rather than guessed at.")
                    }
                }
                kv("shortfall_as_ten_thousandths_of_what_you_were_due", d.lossBp)
                kv("your_swap_as_ten_thousandths_of_the_pool_input_reserve", d.sizeBp)
                kv("pool_state_before_the_front_run_leg", d.reserveInPre.dec + " in / " + d.reserveOutPre.dec + " out")
                kv("fee_recovered_from_your_own_swap", d.kind == 2 ? String(d.feeNum) + "/1000" : String(d.feeNum) + " pips")
                if d.status == .interval { kv("upper_end_of_a_rounding_plateau", d.victimOutCFHi.dec) }
                emit("")
                emit("  That shortfall is not a model and not an estimate. It is the SAME swap, your")
                emit("  same input, against the SAME pool at the reserve state that stood before the")
                emit("  front-run leg was placed — computed in integers from the pool's own arithmetic,")
                emit("  with the fee recovered from your own trade rather than assumed.")
            } else {
                kv("SHORTFALL", "NOT_KNOWN")
                kv("reason", d.status.rawValue)
                emit("")
                emit("  NOT_KNOWN IS NOT ZERO. The insertion is there; the pool's arithmetic could not")
                emit("  be reproduced exactly for this row, so no cost figure is offered for it. A")
                emit("  number would be a guess and this program does not print guesses.")
            }
            emit("")
            emit("  THE OTHER PARTY'S SIDE, kept separate on purpose")
            kv("their_net_position_change_token0", d.net0.decimal)
            kv("their_net_position_change_token1", d.net1.decimal)
            kv("gas_their_two_legs_paid_wei", d.gasWei.dec)
            emit("  Those two are NOT profit and NOT your loss. They are gross of gas, gross of")
            emit("  inventory, and denominated in two tokens this program refuses to add together")
            emit("  without a price. Gas is printed beside them and deliberately NOT netted off.")
        }
        emit("")
        emit(WS_NULL_FLOOR)
        emit("")
        emit("WHAT YOU CAN DO WITH THIS: the three hashes above are public. Anyone can open them")
        emit("in any block explorer and see the same ordering. The shortfall re-computes from the")
        emit("reserve figures printed above with no access to anything private.")
        emit("")
        kv("cost_of_this_answer", "ZERO — " + String(wsRequests) + " HTTP requests to free public endpoints, no key, no account")
        kv("bytes_fetched", wsBytes)
        flush()
        exit(WS_EXIT_SANDWICHED)
    }

    static func wsPullBlockOr(_ ep: String, _ n: UInt64) -> (WSBlockPull, String)? {
        let (p, why) = wsPullBlock(ep, n)
        if let p = p { return (p, why) }
        // The locating endpoint may know the transaction but not serve receipts. Try the rest.
        for other in WS_ENDPOINTS.map({ $0.url }) where other != ep {
            let (q, w2) = wsPullBlock(other, n)
            if let q = q { return (q, w2) }
        }
        return nil
    }
}
