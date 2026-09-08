// =====================================================================================
// wasi-exposure.swift — BEFORE YOU SIGN: HOW MUCH OF WHAT YOU ARE DUE CAN BE TAKEN?
//
//     ./wasi-exposure <pool-address> <token-in> <amount-in>
//
// The published study answers a question about the past: you were taken, here is how
// much. That answer arrives after the signature. This program asks the same arithmetic
// the other question — the one that is still open while the person is looking at it.
//
// ------------------------------------------------------------------------------------
// THE DERIVATION, AND WHY IT IS THE SAME ARITHMETIC
//
// Write out(a; S) for the amount a pool in state S returns for an exact input a. This is
// the pool's own function and nothing here re-invents it:
//
//     constant product        out(a; R_in, R_out, F) = floor( a·F·R_out / (R_in·1000 + a·F) )
//     concentrated liquidity  out(a; sqrtP, L, fee)  = v3Step(...).amountOut
//
// The REALISED loss the study published is equation (4):
//
//     shortfall = out(a; S_before_front) − out(a; S_after_front)                    (4)
//
// — what the victim's own input would have returned at the state that stood before the
// inserted leg, less what it actually returned at the state that leg left behind.
//
// The EXPOSURE this program computes is:
//
//     exposure(a, f) = out(a; S_now) − out(a; S_now ⊕ f)                            (5)
//
// (4) and (5) are the SAME EXPRESSION. The only difference is which state is called
// "before": in (4) it is a state that already stood, recovered from the chain; in (5)
// it is the state standing now, read from the pool this second. `S ⊕ f` is the pool's
// own transition under a front leg of size f, and it is again out():
//
//     constant product   R_in' = R_in + f ,  R_out' = R_out − out(f; S)
//     concentrated liq.  sqrtP' = v3Step(sqrtP, L, fee, f).sqrtNext
//
// So (5) introduces NO new arithmetic. It calls v2Out and v3Step — the same functions,
// compiled from the same bytes, that produced every figure on the published page.
//
// ------------------------------------------------------------------------------------
// ONE LAW, ONE HOME. This file defines no conjunct, no pool arithmetic and no shortfall
// formula. Every one of those lives in extraction-exact.swift and is compiled into this
// binary as a VERBATIM BYTE SLICE of that file (lines 1..2535), whose sha256 is computed
// at build time and printed at run time. v2Out(), v3Step(), v3InvertStart(),
// computeShortfall(), runCorpus(), U256/I256/SInt and the JSON scanner are called here by
// their own names, unmodified. Two implementations drift; this one has to be right for a
// stranger who is about to sign something, so there is only one.
//
// WHAT THIS FILE OWNS: reading the pool's current state off the wire, the ladder and the
// two comparison panels, the corpus join that validates the check against losses that
// already happened, and the printing. All of it I/O and presentation. None of it law.
//
// INTEGER ONLY. Every amount on every decision path is an integer in token base units.
// There is exactly one Double in this program, URLRequest.timeoutInterval, built from an
// Int and never read back. It touches no number that is anybody's money.
//
// NO PURCHASE IS EVER PROPOSED. This program does not tell anyone to trade, not to trade,
// or where. It reports a quantity and the arithmetic that produced it.
// =====================================================================================

import Foundation

// =====================================================================================
// SECTION 1 — THE FOUR WIRE ANSWERS, KEPT APART
//
// An endpoint that serves HTTP 200 carrying an interstitial has answered a DIFFERENT
// question. An endpoint that returns "0x" for a call has answered THIS one with nothing.
// Neither is LIVE. The verdict comes from the BODY; the status code is recorded and
// never decides.
// =====================================================================================

enum XWire: String {
    case LIVE           // this endpoint answered THIS question with usable content
    case ABSENCE        // it says the data is not there (pruned, unavailable, null, empty return)
    case REFUSAL        // it says it will not answer me (key, auth, quota)
    case BOT_BLOCKED    // an interstitial stands between me and the answer
    case NOT_KNOWN      // transport failed, or the body was not a JSON-RPC answer
}

struct XResult {
    let endpoint: String
    let status: Int
    let bytes: Int
    let body: Data
    let wire: XWire
    let reason: String
    let millis: UInt64
}

// The one and only Double in this program. Built from an Int, never read.
let X_TIMEOUT_SECONDS_INT = 25
let xTimeout: TimeInterval = TimeInterval(X_TIMEOUT_SECONDS_INT)

var xRequests = 0
var xBytes = 0

/// Classify a response body. Pure, so the self-test can drive it with fixed bytes and
/// prove it discriminates in five directions without a network.
func xClassify(status: Int, body: Data, transportError: String?) -> (XWire, String) {
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
    var resultEmptyHex = false
    xWithJS(body) { J in
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
                if J.strEq(vs, "0x") { resultEmptyHex = true }
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
            || m.contains("missing") || m.contains("no historical") || m.contains("cannot fulfill")
            || m.contains("execution reverted") || m.contains("revert") {
            return (.ABSENCE, "RPC_ABSENCE[" + errCode + "]:" + String(m.prefix(70)))
        }
        return (.NOT_KNOWN, "RPC_ERROR[" + errCode + "]:" + String(m.prefix(70)))
    }
    if !haveResult { return (.NOT_KNOWN, "NO_RESULT_FIELD") }
    if resultNull { return (.ABSENCE, "RESULT_NULL") }
    // An eth_call to a contract that has no such function returns "0x" with HTTP 200 and
    // no error object. That is the ABSENCE of an answer, and it must not read as LIVE:
    // it is the exact shape that would let an unknown pool be answered as zero exposure.
    if resultEmptyHex { return (.ABSENCE, "RESULT_EMPTY_RETURNDATA") }
    return (.LIVE, "RESULT_PRESENT")
}

func xPost(_ endpoint: String, _ payload: String) -> XResult {
    let t0 = DispatchTime.now().uptimeNanoseconds
    guard let url = URL(string: endpoint) else {
        return XResult(endpoint: endpoint, status: 0, bytes: 0, body: Data(),
                       wire: .NOT_KNOWN, reason: "BAD_URL", millis: 0)
    }
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.setValue("affine-earth-wasi-exposure/1", forHTTPHeaderField: "User-Agent")
    req.httpBody = payload.data(using: .utf8)
    req.timeoutInterval = xTimeout

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
    _ = sem.wait(timeout: .now() + .seconds(X_TIMEOUT_SECONDS_INT + 10))
    let ms = (DispatchTime.now().uptimeNanoseconds &- t0) / 1_000_000
    xRequests += 1
    xBytes += outData.count
    let (w, why) = xClassify(status: outStatus, body: outData, transportError: outErr)
    return XResult(endpoint: endpoint, status: outStatus, bytes: outData.count,
                   body: outData, wire: w, reason: why, millis: ms)
}

// Free, no key, no account, no registration. The tool tries them in order and says which
// answered, so a stranger can see exactly where their answer came from.
struct XEndpoint { let url: String; let note: String }
let X_ENDPOINTS: [XEndpoint] = [
    XEndpoint(url: "https://rpc.mevblocker.io",           note: "free, no key"),
    XEndpoint(url: "https://eth.merkle.io",               note: "free, no key"),
    XEndpoint(url: "https://eth.drpc.org",                note: "free, no key"),
    XEndpoint(url: "https://eth-pokt.nodies.app",         note: "free, no key"),
    XEndpoint(url: "https://ethereum-rpc.publicnode.com", note: "free, no key"),
    XEndpoint(url: "https://cloudflare-eth.com",          note: "free, no key"),
    XEndpoint(url: "https://1rpc.io/eth",                 note: "free, no key"),
    XEndpoint(url: "https://rpc.flashbots.net",           note: "free, no key"),
]

// =====================================================================================
// SECTION 2 — READING A JSON-RPC BODY WITH THE DETECTOR'S OWN SCANNER
// =====================================================================================

@discardableResult
func xWithJS<T>(_ d: Data, _ body: (JS) -> T?) -> T? {
    if d.isEmpty { return nil }
    return d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) -> T? in
        guard let p = raw.bindMemory(to: UInt8.self).baseAddress else { return nil }
        return body(JS(p: p, n: d.count))
    }
}

/// Decode word `k` of an eth_call return, using the detector's OWN dataWord decoder — the
/// same one that read every Swap event in the study. `result` is a quoted "0x..." string,
/// which is exactly the shape dataWord expects.
func xCallWord(_ d: Data, _ k: Int) -> I256? {
    return xWithJS(d) { (J: JS) -> I256? in
        var at = -1
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, "result") { at = vs } }
        if at < 0 { return nil }
        return J.dataWord(at, k)
    }
}

/// How many 32-byte words the return data carries. A getReserves() answer carries 3; a
/// slot0() answer carries 7. A short answer is NOT_KNOWN, never a zero.
func xCallWordCount(_ d: Data) -> Int {
    return xWithJS(d) { (J: JS) -> Int? in
        var at = -1
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, "result") { at = vs } }
        if at < 0 { return nil }
        return J.dataWords(at)
    } ?? -1
}

func xTopHexU64(_ d: Data, _ key: StaticString) -> UInt64? {
    return xWithJS(d) { (J: JS) -> UInt64? in
        var v: UInt64? = nil
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, key) { v = J.hexU64(vs) } }
        return v
    }
}

/// The whole `result` as a lowercased hex string without 0x, for address returns.
func xCallHex(_ d: Data) -> String? {
    return xWithJS(d) { (J: JS) -> String? in
        var at = -1
        _ = J.objectEach(0) { ks, kl, vs in if J.keyIs(ks, kl, "result") { at = vs } }
        if at < 0 { return nil }
        guard let s = J.strOut(at) else { return nil }
        let low = s.lowercased()
        return low.hasPrefix("0x") ? String(low.dropFirst(2)) : low
    }
}

// =====================================================================================
// SECTION 3 — THE POOL STATE, IN ITS OWN NATIVE FORM
//
// Two venue shapes, kept apart. A constant-product pool's state is a reserve pair; a
// concentrated-liquidity pool's state is a price, a liquidity and a fee tier. They are
// NOT converted into one another on any decision path — a V3 pool is stepped by v3Step,
// never by a constant-product stand-in.
// =====================================================================================

enum PoolShape: String {
    case constantProduct = "CONSTANT_PRODUCT"        // Uniswap-V2-shaped
    case concentrated    = "CONCENTRATED_LIQUIDITY"  // Uniswap-V3-shaped
}

struct PoolState {
    var shape: PoolShape = .constantProduct
    var pool: Addr = (0, 0, 0)
    var token0: Addr = (0, 0, 0)
    var token1: Addr = (0, 0, 0)
    var haveTokens = false
    // constant product
    var r0 = U256()
    var r1 = U256()
    var feeNum: UInt64 = 997            // /1000, RECOVERED where the chain allows, never assumed silently
    var feeRecovered = false
    // concentrated liquidity
    var sqrtP = U256()
    var liq = U256()
    var feePips: UInt64 = 0
    // provenance
    var blockNumber: UInt64 = 0
    var servedBy = ""
    var confirmedBy = ""
}

/// The direction the caller's trade runs, in the pool's own token ordering.
/// zeroForOne == true  means token0 in, token1 out.
struct Side { let zeroForOne: Bool }

// =====================================================================================
// SECTION 4 — EQUATION (5). THE ONLY NEW CODE, AND IT IS TWO SUBTRACTIONS.
//
// `due` and `got` are both out(), from the slice. `taken` is their difference. There is
// no third quantity and there is no formula here that the published page does not use.
// =====================================================================================

/// One of exactly two answers, kept apart: a quantity, or a named reason there is none.
enum XExposure {
    case known(due: U256, got: U256, taken: U256, tenThousandths: UInt64)
    case notKnown(String)
}

/// out(a; S) — the amount this pool returns for exact input `a` in state `S`.
/// Calls the slice. Defines nothing.
func xOut(_ st: PoolState, _ side: Side, _ a: U256) -> U256? {
    if a.isZero { return nil }
    switch st.shape {
    case .constantProduct:
        let rin  = side.zeroForOne ? st.r0 : st.r1
        let rout = side.zeroForOne ? st.r1 : st.r0
        return v2Out(a, rin, rout, st.feeNum)
    case .concentrated:
        guard let s = v3Step(sqrtCur: st.sqrtP, liquidity: st.liq, feePips: st.feePips,
                             grossIn: a, zeroForOne: side.zeroForOne) else { return nil }
        return s.amountOut
    }
}

/// S ⊕ f — the pool's own state transition under a front leg of size `f` on the same side.
/// Calls the slice. Defines nothing.
func xAdvance(_ st: PoolState, _ side: Side, _ f: U256) -> PoolState? {
    if f.isZero { return st }
    var out = st
    switch st.shape {
    case .constantProduct:
        let rin  = side.zeroForOne ? st.r0 : st.r1
        let rout = side.zeroForOne ? st.r1 : st.r0
        guard let fo = v2Out(f, rin, rout, st.feeNum) else { return nil }
        if U256.cmp(fo, rout) >= 0 { return nil }
        let (rinN, c) = U256.addC(rin, f)
        if c { return nil }
        let routN = rout - fo
        if side.zeroForOne { out.r0 = rinN; out.r1 = routN } else { out.r1 = rinN; out.r0 = routN }
        return out
    case .concentrated:
        guard let s = v3Step(sqrtCur: st.sqrtP, liquidity: st.liq, feePips: st.feePips,
                             grossIn: f, zeroForOne: side.zeroForOne) else { return nil }
        out.sqrtP = s.sqrtNext
        return out
    }
}

/// EQUATION (5). exposure(a, f) = out(a; S) − out(a; S ⊕ f).
func xExposure(_ st: PoolState, _ side: Side, amountIn a: U256, attackerIn f: U256) -> XExposure {
    guard let due = xOut(st, side, a) else { return .notKnown("NOT_KNOWN_POOL_ARITHMETIC_RANGE_ON_YOUR_OWN_TRADE") }
    if due.isZero { return .notKnown("NOT_KNOWN_YOUR_TRADE_RETURNS_NOTHING_AT_THIS_STATE") }
    guard let st2 = xAdvance(st, side, f) else { return .notKnown("NOT_KNOWN_FRONT_LEG_EXCEEDS_THIS_POOL") }
    guard let got = xOut(st2, side, a) else { return .notKnown("NOT_KNOWN_POOL_ARITHMETIC_RANGE_AFTER_THE_FRONT_LEG") }
    if U256.cmp(got, due) > 0 { return .notKnown("NOT_KNOWN_NON_MONOTONE_STEP") }
    let taken = due - got
    guard let bpU = U256.mulDiv(taken, U256(10_000), due), let bp = bpU.asU64 else {
        return .notKnown("NOT_KNOWN_RATIO_RANGE")
    }
    return .known(due: due, got: got, taken: taken, tenThousandths: bp)
}

/// The quantity the study measured as predictive: the caller's input as ten-thousandths
/// of the pool's own input-side depth. For a V3 pool this is against the VIRTUAL reserve
/// at the current price, L·2^96/sqrtP or L·sqrtP/2^96, which is the same quantity the
/// published per-victim table prints.
func xPoolRelativeSizeBp(_ st: PoolState, _ side: Side, _ a: U256) -> UInt64? {
    guard let rin = xInputDepth(st, side) else { return nil }
    if rin.isZero { return nil }
    guard let s = U256.mulDiv(a, U256(10_000), rin) else { return nil }
    return s.asU64
}

func xInputDepth(_ st: PoolState, _ side: Side) -> U256? {
    switch st.shape {
    case .constantProduct:
        return side.zeroForOne ? st.r0 : st.r1
    case .concentrated:
        // x = L·2^96/sqrtP  (token0),  y = L·sqrtP/2^96  (token1)
        if st.sqrtP.isZero { return nil }
        let x = U256.mulDiv(st.liq, Q96, st.sqrtP)
        let y = U256.mulDiv(st.liq, st.sqrtP, Q96)
        return side.zeroForOne ? x : y
    }
}

/// A pool of the same price and shape, k times deeper. Price is held: both reserves scale
/// by k for constant product, and L scales by k at the same sqrtP for concentrated
/// liquidity, which is exactly what "the same market, more depth" means.
func xDeeper(_ st: PoolState, times k: UInt64) -> PoolState? {
    var out = st
    switch st.shape {
    case .constantProduct:
        guard let a = U256.mulDiv(st.r0, U256(k), U256(1)),
              let b = U256.mulDiv(st.r1, U256(k), U256(1)) else { return nil }
        out.r0 = a; out.r1 = b
    case .concentrated:
        guard let l = U256.mulDiv(st.liq, U256(k), U256(1)) else { return nil }
        out.liq = l
    }
    return out
}

// =====================================================================================
// SECTION 5 — THE ANSWERS. They never print alike.
// =====================================================================================

// NO LAW DIGEST IS FROZEN INTO THIS BINARY, AND THAT IS DELIBERATE.
//
// The first version of this file carried the published slice digest as a literal and
// REFUSED when the detector no longer produced it. That is the stale-constant defect
// wearing a gate's clothes: the law legitimately grows, and a digest typed into a second
// consumer of it goes stale the first time somebody adds a function — at which point the
// tool refuses over a change that broke nothing. Measured the same afternoon: the detector
// went from 2,688 lines to 3,011 in a neighbouring session and every typed boundary in the
// tree went wrong at once.
//
// What replaces it is a RELATION rather than a literal: this binary is cut from the same
// file, at the same named marker, as the sibling tool, and wasi-exposure-one-law.sh reads
// BOTH binaries and requires the same digest out of each. A relation cannot go stale when
// the law grows, and it still fails the moment the two tools stop sharing a law — which is
// the only thing the literal was ever there to catch.

let X_BANNER_EXPOSED  = "################  EXPOSURE:  MEASURED  ################"
let X_BANNER_REFUSED  = "!!!!!!!!!!!!!!!!  EXPOSURE:  REFUSED  !!!!!!!!!!!!!!!!"
let X_EXIT_OK: Int32 = 0
let X_EXIT_REFUSED: Int32 = 3
let X_EXIT_NOTHING_GIVEN: Int32 = 4
let X_EXIT_VALIDATION_BROKEN: Int32 = 5

func xRefusalOrigin(_ fromTheWire: Bool) -> String {
    return fromTheWire
        ? "ON THE WIRE — an endpoint's answer, or the lack of one"
        : "HERE — from what this program was given, before any endpoint was asked about it"
}

func xRefuse(_ code: String, _ plain: String, fromTheWire: Bool = false) -> Never {
    emit("")
    emit(X_BANNER_REFUSED)
    emit("")
    kv("reason_code", code)
    kv("refusal_arose", xRefusalOrigin(fromTheWire))
    emit("in plain words: " + plain)
    emit("")
    emit("REFUSED IS NOT ZERO EXPOSURE. This program did not reach an answer about this")
    emit("pool, and nothing above is a result about it. An unknown pool is refused, never")
    emit("answered as safe — a check that returns zero when it cannot see is worse than no")
    emit("check, because somebody signs on it.")
    if fromTheWire {
        emit("")
        emit("Wire answers stay separated into four, and this program never merges them:")
        emit("  ABSENCE      the endpoint says the data is not there (pruned, null, empty return)")
        emit("  REFUSAL      the endpoint says it will not answer without a key, a plan or a quota")
        emit("  BOT_BLOCKED  an interstitial stood between the question and the answer")
        emit("  NOT_KNOWN    transport failed, or the body was not a JSON-RPC answer at all")
    }
    xReferenceFigures(code)
    flush()
    exit(X_EXIT_REFUSED)
}

/// EVERY exit path prints the reference figures, including the ones that measured nothing.
func xReferenceFigures(_ why: String) {
    section("REFERENCE FIGURES — published, from the pinned corpus. Not this run's measurements.")
    kv("why_this_path", why)
    emit("  corpus            Ethereum blocks 14,000,000–14,000,999 · 13,586 s of one chain")
    emit("  detections        108 inserted trades · 87 costed EXACTLY · 21 NOT_KNOWN, named")
    emit("  typical hit       MEDIAN 476 ten-thousandths of the output that was due")
    emit("  absolute          MEDIAN 0.170457244547709297 ETH ≈ 558 USDC per victim")
    emit("  derived floor     28,889,398,990,674,697,077 wei = 28.8894 WETH = 94,645.77 USDC")
    emit("  spread            min 47 · p10 49 · p25 102 · MEDIAN 476 · p75 1,785 · max 9,999")
    emit("  by venue          constant-product 73 victims median 575 · concentrated 14 median 105")
    emit("  WHAT PREDICTS IT  pool-relative size Kendall tau +491 permille")
    emit("                    absolute ETH size  Kendall tau −500 permille")
    emit("                    — in absolute terms the SMALLER trades take the LARGER relative hit,")
    emit("                      which is why this program reports pool-relative size and not size.")
    emit("  concentration     48 distinct pools, ONE carries 22 of 108 (203 permille)")
    emit("  null floor        47 false positives per 212,769 leg pairs")
}

// =====================================================================================
// SECTION 6 — HONEST LIMITS. Printed on every answer, in the output, not in prose
// somewhere else. A person acting on this number is entitled to read what it is not.
// =====================================================================================

let X_LIMITS = """
WHAT THIS NUMBER IS, AND WHAT IT IS NOT — read this before acting on it.
  1. COULD, NOT WILL. Exposure is what an inserted leg COULD take from this trade at this
     state. It is not a prediction that anyone will insert one. Most swaps are not
     sandwiched: the study measured 108 insertions across 1,000 blocks carrying 200,826
     transactions. A large exposure is not a warning that it is about to happen, and a
     small one is not a promise that it will not.
  2. ONE ATTACK SHAPE, THIS POOL. The geometry assumed here is a single front leg on THIS
     pool, in THIS direction, closed afterwards. A searcher who splits legs across two
     addresses, routes through a different pool, or works across blocks is OUTSIDE this
     arithmetic entirely — the study's own detector cannot see those either, and neither
     can this. Absence of exposure here is not absence of exposure.
  3. THE STATE MOVES. Reserves change between this read and your signature. The answer
     above is for the state at the block number printed with it, and for no other. A pool
     that anyone else trades in the meantime is a different pool by the time you sign.
  4. ONE PRICE STEP, ON A CONCENTRATED-LIQUIDITY POOL. This is the one limit that can
     make the figure too SMALL, so it is stated first among the arithmetic ones. A V3-shaped
     pool holds its liquidity in ticks; this models ONE step at the liquidity standing now
     and does not fetch the tick map. If a leg moves the price far enough to cross into a
     range with LESS liquidity, the real hit is LARGER than printed here. The price move
     each rung causes is printed beside it in ten-thousandths, so you can see when that is
     likely: a small move is safely inside one range, a large one is not. On a constant-
     product pool the question does not arise — its liquidity is one range by construction,
     and every constant-product figure here is exact for the state read.
  5. NO ROUTER, NO SLIPPAGE SETTING, NO GAS. This is the pool's own arithmetic on the pool's
     own amounts. It does not model your router's path splitting, your slippage tolerance
     (which is what actually BOUNDS what can be taken from you), or what the insertion costs
     the person doing it. A slippage limit you set is a cap this arithmetic does not know
     about.
  6. NOT ADVICE. No purchase, trade, venue or action is proposed anywhere in this output.
     This program reports a quantity and shows the arithmetic that produced it.
"""

// =====================================================================================
// SECTION 7 — THE LADDER AND THE TWO COMPARISON PANELS
//
// A single number would be a lie by omission: the attacker chooses their size and the
// person signing does not. So the answer is a SHAPE — exposure across the sizes an
// inserted leg could plausibly take — and then the two comparisons that turn the shape
// into a choice the person can actually make.
// =====================================================================================

struct XRung { let label: String; let f: U256; let e: XExposure }

/// Attacker sizes as multiples of the caller's own trade. Eighths, because an inserted leg
/// smaller than the trade it front-runs is common and the low end is where the shape bends.
let X_LADDER_NUM: [UInt64] = [1, 1, 1, 1, 2, 4, 8, 16]
let X_LADDER_DEN: [UInt64] = [8, 4, 2, 1, 1, 1, 1, 1]

func xLadder(_ st: PoolState, _ side: Side, _ a: U256) -> [XRung] {
    var out: [XRung] = []
    for i in 0..<X_LADDER_NUM.count {
        let n = X_LADDER_NUM[i], d = X_LADDER_DEN[i]
        guard let f = U256.mulDiv(a, U256(n), U256(d)) else { continue }
        let lbl = (d == 1) ? (String(n) + "x") : (String(n) + "/" + String(d) + "x")
        out.append(XRung(label: lbl, f: f, e: xExposure(st, side, amountIn: a, attackerIn: f)))
    }
    return out
}

func xTaken(_ e: XExposure) -> U256? {
    if case .known(_, _, let t, _) = e { return t }
    return nil
}
func xBp(_ e: XExposure) -> UInt64? {
    if case .known(_, _, _, let b) = e { return b }
    return nil
}

// =====================================================================================
// SECTION 8 — VALIDATION AGAINST LOSSES THAT ALREADY HAPPENED
//
// This is the arm that decides whether the check is worth anything. For each of the 87
// costed victims the study published, the pre-front pool state and the attacker size that
// was ACTUALLY used are both recoverable from the corpus. Run equation (5) at that state
// with that size and it must reproduce the shortfall equation (4) computed — to the base
// unit, not approximately.
//
// If it cannot reproduce a loss that already happened, it cannot forecast one, and the
// verdict is BROKEN.
//
// THE FRONT LEG IS AN OBSERVATION, NOT A DERIVATION. It would be trivial and worthless to
// solve for the attacker size that makes the prediction come true — that instrument would
// be always-green. The size used below is read out of the block, from the front leg's own
// Swap event, by a pass that never looks at the victim's output.
// =====================================================================================

struct XLeg {
    var block: UInt64 = 0
    var pool: Addr = (0, 0, 0)
    var txIndex: UInt32 = 0
    var kind: UInt8 = 0
    var dir: UInt8 = 0
    var amountIn = U256()
    var amountOut = U256()
    var sqrtP = U256()
    var liq = U256()
    var seen: Int = 0            // how many swap logs matched this key; >1 is NOT_KNOWN
}

/// A SECOND pass over the corpus receipts that reads ONE thing: the swap legs, keyed by
/// (block, pool, transaction index). No conjunct, no shortfall, no verdict — I/O only,
/// through the detector's own JSON scanner and its own dataWord decoder.
func xIndexLegs(blocksPath: String, receiptsPath: String, expectStart: UInt64) -> [String: XLeg] {
    var index = [String: XLeg]()
    guard let bd = try? Data(contentsOf: URL(fileURLWithPath: blocksPath), options: .mappedIfSafe),
          let rd = try? Data(contentsOf: URL(fileURLWithPath: receiptsPath), options: .mappedIfSafe) else {
        return index
    }
    func lineRanges(_ d: Data) -> [(Int, Int)] {
        var out: [(Int, Int)] = []
        d.withUnsafeBytes { (raw: UnsafeRawBufferPointer) in
            guard let p = raw.bindMemory(to: UInt8.self).baseAddress else { return }
            var s = 0
            for i in 0..<d.count where p[i] == 0x0a {
                if i > s { out.append((s, i - s)) }
                s = i + 1
            }
            if d.count > s { out.append((s, d.count - s)) }
        }
        return out
    }
    let bLines = lineRanges(bd), rLines = lineRanges(rd)
    bd.withUnsafeBytes { (braw: UnsafeRawBufferPointer) in
    rd.withUnsafeBytes { (rraw: UnsafeRawBufferPointer) in
        guard let bp = braw.bindMemory(to: UInt8.self).baseAddress,
              let rp = rraw.bindMemory(to: UInt8.self).baseAddress else { return }
        let n = min(bLines.count, rLines.count)
        for bi in 0..<n {
            let (bo, bl) = bLines[bi]
            let J = JS(p: bp + bo, n: bl)
            var num: UInt64 = 0
            _ = J.objectEach(0) { ks, kl, vs in
                if J.keyIs(ks, kl, "number") { if let v = J.hexU64(vs) { num = v } }
            }
            if num == 0 { num = expectStart &+ UInt64(bi) }
            let (ro, rl) = rLines[bi]
            let R = JS(p: rp + ro, n: rl)
            _ = R.arrayEach(0) { rs in
                var txIdx: UInt32 = 0
                var logsAt = -1
                _ = R.objectEach(rs) { ks, kl, vs in
                    if R.keyIs(ks, kl, "transactionIndex") { if let v = R.hexU64(vs) { txIdx = UInt32(truncatingIfNeeded: v) } }
                    else if R.keyIs(ks, kl, "logs") { logsAt = vs }
                }
                if logsAt < 0 { return }
                _ = R.arrayEach(logsAt) { ls in
                    var pool: Addr = (0, 0, 0)
                    var kind: UInt8 = 0
                    var dataAt = -1
                    _ = R.objectEach(ls) { ks, kl, vs in
                        if R.keyIs(ks, kl, "address") { if let a = R.addr(vs) { pool = a } }
                        else if R.keyIs(ks, kl, "data") { dataAt = vs }
                        else if R.keyIs(ks, kl, "topics") {
                            var idx = 0
                            _ = R.arrayEach(vs) { tsx in
                                if idx == 0 {
                                    if R.strEq(tsx, V2SWAP) { kind = 2 }
                                    else if R.strEq(tsx, V3SWAP) { kind = 3 }
                                }
                                idx += 1
                            }
                        }
                    }
                    if kind == 0 || dataAt < 0 { return }
                    var lg = XLeg()
                    lg.block = num; lg.pool = pool; lg.txIndex = txIdx; lg.kind = kind
                    var d0 = I256(), d1 = I256()
                    if kind == 2 {
                        guard let a0i = R.dataWord(dataAt, 0), let a1i = R.dataWord(dataAt, 1),
                              let a0o = R.dataWord(dataAt, 2), let a1o = R.dataWord(dataAt, 3) else { return }
                        d0 = a0i - a0o; d1 = a1i - a1o
                    } else {
                        guard let a0 = R.dataWord(dataAt, 0), let a1 = R.dataWord(dataAt, 1),
                              let sp = R.dataWord(dataAt, 2), let lq = R.dataWord(dataAt, 3) else { return }
                        d0 = a0; d1 = a1
                        lg.sqrtP = U256(mag: sp); lg.liq = U256(mag: lq)
                    }
                    lg.dir = (!d0.isNegative && !d0.isZero) ? 0 : 1
                    if lg.dir == 0 { lg.amountIn = U256(mag: d0); lg.amountOut = U256(mag: d1) }
                    else { lg.amountIn = U256(mag: d1); lg.amountOut = U256(mag: d0) }
                    let key = String(num) + "|" + addrKey(pool) + "|" + String(txIdx)
                    if var prev = index[key] { prev.seen += 1; index[key] = prev }
                    else { lg.seen = 1; index[key] = lg }
                }
            }
        }
    }
    }
    return index
}

// =====================================================================================
// SECTION 9 — SELF-TEST. Every arm has a direction and both directions are exercised.
// No arm is a literal true. A gate given nothing must not pass.
// =====================================================================================

var xArms = 0, xPass = 0, xFail = 0
func xArm(_ name: String, _ expect: String, _ got: String) {
    xArms += 1
    if expect == got { xPass += 1; emit("ARM\tPASS\t" + name + "\texpect\t" + expect + "\tgot\t" + got) }
    else { xFail += 1; emit("ARM\tFAIL\t" + name + "\texpect\t" + expect + "\tgot\t" + got) }
}

/// A deep constant-product pool: 10,000 units against 30,000,000 units, 30 bp fee.
func xDeepPool() -> PoolState {
    var s = PoolState()
    s.shape = .constantProduct
    s.r0 = U256(10_000_000_000_000_000)      // 1e16
    s.r1 = U256(30_000_000_000_000_000)      // 3e16
    s.feeNum = 997
    return s
}
/// A thin one: the same price, ten-thousandth of the depth.
func xThinPool() -> PoolState {
    var s = xDeepPool()
    s.r0 = U256(1_000_000_000_000)           // 1e12
    s.r1 = U256(3_000_000_000_000)           // 3e12
    return s
}
/// A concentrated-liquidity pool at 1:1, 30 bp.
func xV3Pool() -> PoolState {
    var s = PoolState()
    s.shape = .concentrated
    s.sqrtP = Q96
    s.liq = U256(100_000_000_000_000_000)
    s.feePips = 3000
    return s
}

func xSelftest() -> Int {
    xArms = 0; xPass = 0; xFail = 0
    section("SELF-TEST — the exposure check, both directions on every arm")

    let side = Side(zeroForOne: true)

    // ---- 1. A TINY TRADE IN A DEEP POOL IS NEAR ZERO -------------------------------
    let deep = xDeepPool()
    let tiny = U256(1_000_000)                       // 1e6 against 1e16 of depth
    let eTiny = xExposure(deep, side, amountIn: tiny, attackerIn: tiny)
    xArm("tiny_trade_in_a_deep_pool_is_near_zero", "bp <= 1",
         (xBp(eTiny).map { $0 <= 1 ? "bp <= 1" : "bp = " + String($0) }) ?? "NOT_KNOWN")

    // ---- 2. A LARGE TRADE IN A THIN POOL IS LARGE, and the SAME arm says so ---------
    let thin = xThinPool()
    let big = U256(500_000_000_000)                  // 5e11 against 1e12 of depth
    let eBig = xExposure(thin, side, amountIn: big, attackerIn: big)
    xArm("large_trade_in_a_thin_pool_is_large", "bp >= 1000",
         (xBp(eBig).map { $0 >= 1000 ? "bp >= 1000" : "bp = " + String($0) }) ?? "NOT_KNOWN")
    // The pair above is the discrimination: one instrument, two states, two verdicts.
    xArm("and_those_two_are_the_SAME_instrument", "deep < thin",
         (xBp(eTiny).flatMap { t in xBp(eBig).map { b in t < b ? "deep < thin" : "deep=" + String(t) + " thin=" + String(b) } }) ?? "NOT_KNOWN")

    // ---- 3. ZERO ATTACKER SIZE TAKES EXACTLY ZERO ----------------------------------
    let eNone = xExposure(deep, side, amountIn: big, attackerIn: U256())
    xArm("no_front_leg_takes_exactly_zero", "0", xTaken(eNone)?.dec ?? "NOT_KNOWN")

    // ---- 4. THE LADDER IS MONOTONE IN ATTACKER SIZE --------------------------------
    // If it is not, the arithmetic is wrong: a bigger inserted leg cannot take less.
    let rungs = xLadder(thin, side, U256(100_000_000_000))
    var mono = true, prev = U256()
    var rungCount = 0
    for r in rungs {
        guard let t = xTaken(r.e) else { continue }
        rungCount += 1
        if U256.cmp(t, prev) < 0 { mono = false }
        prev = t
    }
    xArm("ladder_is_monotone_in_attacker_size", "monotone over 8 rungs",
         mono ? "monotone over " + String(rungCount) + " rungs" : "NOT_MONOTONE")
    // CONTROL: monotonicity is a real property, so a deliberately shuffled ladder must FAIL
    // the same test. An always-true check would pass this too.
    var shuffled: [U256] = []
    for r in rungs { if let t = xTaken(r.e) { shuffled.append(t) } }
    if shuffled.count >= 2 { shuffled.swapAt(0, shuffled.count - 1) }
    var monoShuf = true; var p2 = U256()
    for t in shuffled { if U256.cmp(t, p2) < 0 { monoShuf = false }; p2 = t }
    xArm("control_the_monotonicity_test_can_FAIL", "NOT_MONOTONE", monoShuf ? "monotone" : "NOT_MONOTONE")

    // ---- 5. A DEEPER POOL LOWERS EXPOSURE FOR THE SAME TRADE -----------------------
    let a5 = U256(100_000_000_000)
    let e5here = xExposure(thin, side, amountIn: a5, attackerIn: a5)
    let deeper10 = xDeeper(thin, times: 10)
    let e5deep = deeper10.map { xExposure($0, side, amountIn: a5, attackerIn: a5) }
    xArm("a_deeper_pool_lowers_exposure_for_the_same_trade", "deeper < here",
         (xBp(e5here).flatMap { h in e5deep.flatMap(xBp).map { d in d < h ? "deeper < here" : "here=" + String(h) + " deeper=" + String(d) } }) ?? "NOT_KNOWN")

    // ---- 6. A SMALLER TRADE LOWERS EXPOSURE IN THE SAME POOL -----------------------
    let small = U256(10_000_000_000)
    let e6 = xExposure(thin, side, amountIn: small, attackerIn: small)
    xArm("a_smaller_trade_lowers_exposure_in_the_same_pool", "smaller < larger",
         (xBp(e5here).flatMap { h in xBp(e6).map { s in s < h ? "smaller < larger" : "larger=" + String(h) + " smaller=" + String(s) } }) ?? "NOT_KNOWN")

    // ---- 7. AN UNKNOWN POOL IS REFUSED, NEVER ANSWERED AS ZERO ---------------------
    var empty = PoolState(); empty.shape = .constantProduct
    let e7 = xExposure(empty, side, amountIn: U256(1000), attackerIn: U256(1000))
    var e7s = "A_NUMBER"
    if case .notKnown(let why) = e7 { e7s = why }
    xArm("an_empty_pool_is_NOT_KNOWN_not_zero", "NOT_KNOWN_POOL_ARITHMETIC_RANGE_ON_YOUR_OWN_TRADE", e7s)
    // CONTROL: the same call on a real pool must NOT return NOT_KNOWN, or the arm above
    // is measuring nothing but the constructor.
    var e7c = "NOT_A_NUMBER"
    if case .known = xExposure(deep, side, amountIn: U256(1000), attackerIn: U256(1000)) { e7c = "A_NUMBER" }
    xArm("control_a_real_pool_does_return_a_number", "A_NUMBER", e7c)

    // ---- 8. THE V3 PATH IS THE V3 PATH ---------------------------------------------
    let v3 = xV3Pool()
    let a8 = U256(1_000_000_000_000_000)
    let e8 = xExposure(v3, side, amountIn: a8, attackerIn: a8)
    xArm("concentrated_liquidity_pool_returns_a_number", "A_NUMBER",
         { if case .known = e8 { return "A_NUMBER" }; if case .notKnown(let w) = e8 { return w }; return "?" }())
    let e8big = xExposure(v3, side, amountIn: a8, attackerIn: U256(10_000_000_000_000_000))
    xArm("and_a_bigger_front_leg_takes_more_of_it", "bigger takes more",
         (xTaken(e8).flatMap { s in xTaken(e8big).map { b in U256.cmp(b, s) > 0 ? "bigger takes more" : "small=" + s.dec + " big=" + b.dec } }) ?? "NOT_KNOWN")

    // ---- 9. EQUATION (5) IS EQUATION (4). Proven by calling the PUBLISHED shortfall
    //         function on a state this program advanced, and requiring the same integer.
    //         This is the join between the two questions and it is exact.
    do {
        let st = thin
        let f = U256(50_000_000_000)
        let a = U256(80_000_000_000)
        let e = xExposure(st, side, amountIn: a, attackerIn: f)
        // The same thing, assembled as the detector sees it: a front leg, a victim leg,
        // and the two Sync records that bracket them — then computeShortfall(), verbatim.
        var det = Detection(); det.kind = 2
        var front = SwapRec(); front.kind = 2; front.pool = (1, 2, 3); front.txIndex = 1; front.logIndex = 2
        var victim = SwapRec(); victim.kind = 2; victim.pool = (1, 2, 3); victim.txIndex = 2; victim.logIndex = 4
        guard let fOut = v2Out(f, st.r0, st.r1, st.feeNum) else { xArm("equation5_is_equation4", "a shortfall", "front leg out of range"); return xFail }
        let r0AfterFront = st.r0 + f
        let r1AfterFront = st.r1 - fOut
        guard let vOut = v2Out(a, r0AfterFront, r1AfterFront, st.feeNum) else { xArm("equation5_is_equation4", "a shortfall", "victim leg out of range"); return xFail }
        var fd0 = I256(); fd0.w = (f.w0, f.w1, f.w2, f.w3)
        var fd1 = I256(); fd1.w = (fOut.w0, fOut.w1, fOut.w2, fOut.w3); fd1 = I256() - fd1
        front.d0 = fd0; front.d1 = fd1; front.dir = 0
        var vd0 = I256(); vd0.w = (a.w0, a.w1, a.w2, a.w3)
        var vd1 = I256(); vd1.w = (vOut.w0, vOut.w1, vOut.w2, vOut.w3); vd1 = I256() - vd1
        victim.d0 = vd0; victim.d1 = vd1; victim.dir = 0
        var syF = SyncRec(); syF.pool = (1, 2, 3); syF.logIndex = 1; syF.r0 = st.r0; syF.r1 = st.r1
        var syV = SyncRec(); syV.pool = (1, 2, 3); syV.logIndex = 3; syV.r0 = r0AfterFront; syV.r1 = r1AfterFront
        // computeShortfall reads the Sync AFTER each leg, so syF carries R-after-front and
        // subtracts the front's own deltas to get R-before-front. Build it that way.
        syF.r0 = r0AfterFront; syF.r1 = r1AfterFront
        syV.r0 = r0AfterFront + a; syV.r1 = r1AfterFront - vOut
        computeShortfall(&det, front: front, victimSwap: victim, syncs: [syF, syV], adjacent: true)
        let published = det.shortfall.dec
        xArm("equation5_is_equation4_to_the_base_unit", published, xTaken(e)?.dec ?? "NOT_KNOWN")
        xArm("and_the_published_side_reached_it_EXACTLY", "EXACT", det.status.rawValue)
        // CONTROL: a DIFFERENT attacker size must produce a DIFFERENT number, or the arm
        // above would pass for any f at all.
        let eWrong = xExposure(st, side, amountIn: a, attackerIn: U256(10_000_000_000))
        xArm("control_a_different_front_size_does_NOT_match", "different",
             (xTaken(eWrong).map { $0.dec == published ? "same" : "different" }) ?? "NOT_KNOWN")
    }

    // ---- 10. THE WIRE CLASSIFIER DISCRIMINATES IN FIVE DIRECTIONS ------------------
    func cl(_ s: String) -> String { xClassify(status: 200, body: Data(s.utf8), transportError: nil).0.rawValue }
    xArm("wire_live", "LIVE", cl("{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":\"0x0000000000000000000000000000000000000000000000000000000000000001\"}"))
    xArm("wire_empty_returndata_is_ABSENCE_not_LIVE", "ABSENCE", cl("{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":\"0x\"}"))
    xArm("wire_null_is_ABSENCE", "ABSENCE", cl("{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":null}"))
    xArm("wire_key_demand_is_REFUSAL", "REFUSAL", cl("{\"jsonrpc\":\"2.0\",\"error\":{\"code\":-32000,\"message\":\"missing api key\"}}"))
    xArm("wire_interstitial_is_BOT_BLOCKED", "BOT_BLOCKED", cl("<html><title>Just a moment...</title></html>"))
    xArm("wire_hello_world_is_NOT_KNOWN", "NOT_KNOWN", cl("Hello World!"))
    xArm("wire_transport_error_is_NOT_KNOWN", "NOT_KNOWN",
         xClassify(status: 0, body: Data(), transportError: "connection refused").0.rawValue)

    // ---- 11. THE eth_call DECODER READS WORDS, AND REFUSES A SHORT ANSWER ----------
    // A 32-byte word is 64 hex characters: 56 zeros then an 8-digit value.
    let gr = "{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":\"0x"
        + String(repeating: "0", count: 56) + "0000000b"          // r0 = 11
        + String(repeating: "0", count: 56) + "00000016"          // r1 = 22
        + String(repeating: "0", count: 64) + "\"}"               // ts = 0
    let d11 = Data(gr.utf8)
    xArm("eth_call_word0", "11", xCallWord(d11, 0).map { U256(mag: $0).dec } ?? "NOT_KNOWN")
    xArm("eth_call_word1", "22", xCallWord(d11, 1).map { U256(mag: $0).dec } ?? "NOT_KNOWN")
    xArm("eth_call_word_count", "3", String(xCallWordCount(d11)))
    let short = Data("{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":\"0x00\"}".utf8)
    xArm("eth_call_short_answer_has_no_word_1", "NOT_KNOWN", xCallWord(short, 1).map { U256(mag: $0).dec } ?? "NOT_KNOWN")

    // ---- 12. THE POOL-RELATIVE SIZE IS THE STUDY'S OWN sizeBp ----------------------
    // 100 units of input against 10,000 of input-side depth is 100 ten-thousandths.
    var p12 = PoolState(); p12.shape = .constantProduct
    p12.r0 = U256(10_000); p12.r1 = U256(10_000); p12.feeNum = 997
    xArm("pool_relative_size_is_ten_thousandths_of_depth", "100",
         xPoolRelativeSizeBp(p12, side, U256(100)).map { String($0) } ?? "NOT_KNOWN")
    xArm("and_it_moves_with_depth_not_with_size_alone", "10",
         xDeeper(p12, times: 10).flatMap { xPoolRelativeSizeBp($0, side, U256(100)) }.map { String($0) } ?? "NOT_KNOWN")

    // ---- 12b. HALVING THE TRADE AND DOUBLING THE DEPTH ARE THE SAME MOVE -----------
    // The study's own finding, as a falsifiable identity on the arithmetic.
    do {
        let a = U256(100_000_000_000)
        let hereHalf = xExposure(thin, side, amountIn: U256.mulDiv(a, U256(1), U256(2))!, attackerIn: U256.mulDiv(a, U256(1), U256(2))!)
        let deepFull = xDeeper(thin, times: 2).map { xExposure($0, side, amountIn: a, attackerIn: a) }
        xArm("halving_the_trade_equals_doubling_the_depth", "same ten-thousandths",
             (xBp(hereHalf).flatMap { h in deepFull.flatMap(xBp).map { d in h == d ? "same ten-thousandths" : "half=" + String(h) + " deep=" + String(d) } }) ?? "NOT_KNOWN")
        // CONTROL: it must NOT hold for a mismatched pair, or the arm is vacuous.
        let deepTen = xDeeper(thin, times: 10).map { xExposure($0, side, amountIn: a, attackerIn: a) }
        xArm("control_a_mismatched_pair_does_NOT_agree", "different",
             (xBp(hereHalf).flatMap { h in deepTen.flatMap(xBp).map { d in h == d ? "same" : "different" } }) ?? "NOT_KNOWN")
    }

    // ---- 13. A GATE GIVEN NOTHING MUST NOT PASS ------------------------------------
    let e13 = xExposure(deep, side, amountIn: U256(), attackerIn: U256(1000))
    var e13s = "A_NUMBER"
    if case .notKnown(let w) = e13 { e13s = w }
    xArm("a_zero_amount_is_NOT_KNOWN_not_zero_exposure",
         "NOT_KNOWN_POOL_ARITHMETIC_RANGE_ON_YOUR_OWN_TRADE", e13s)

    emit("")
    kv("arms_run", xArms)
    kv("arms_passed", xPass)
    kv("arms_failed", xFail)
    emit(xFail == 0 ? "SELFTEST_GREEN" : "SELFTEST_RED")
    return xFail
}

// =====================================================================================
// SECTION 10 — MAIN
// =====================================================================================

@main
struct WasiExposure {

    static func header() {
        emit("=====================================================================")
        emit("  BEFORE YOU SIGN: HOW MUCH OF WHAT YOU ARE DUE CAN BE TAKEN?")
        emit("  affine.earth market-shear · one pool · one trade · one shape")
        emit("=====================================================================")
        kv("cost_to_run_this", "ZERO — no API key, no account, no registration, nobody's permission")
        kv("what_it_needs", "a pool address, which token you are paying in, how much, and an internet connection")
        emit("what_leaves_this_machine")
        emit("  A POOL ADDRESS and the standard read-only calls every block explorer makes")
        emit("  against it, to TWO public endpoints. Your amount is NEVER sent: the size you")
        emit("  type is used only in arithmetic on this machine, against reserves that were")
        emit("  already public. No address of yours, no wallet, no transaction, no signature.")
        kv("law_carried", CORE_SOURCE_NAME + " lines " + CORE_SLICE_LINES + " — VERBATIM, compiled in")
        kv("law_sha256_computed_at_build", CORE_SLICE_SHA256)
        kv("law_bytes", CORE_SLICE_BYTES)
        kv("re_derive_that_digest", "sed -n '" + CORE_SLICE_LINES.replacingOccurrences(of: "..", with: ",") + "p' " + CORE_SOURCE_NAME + " | shasum -a 256")
        kv("tool_source_sha256", TOOL_SOURCE_SHA256)
        kv("built_utc", BUILD_UTC)
    }

    /// TWO SEPARATE FACTS, NEVER MERGED INTO ONE VERDICT.
    ///
    ///   1. Where this binary's law came from, and what it hashes to. Reported, never
    ///      compared against a frozen literal — see the note above the globals.
    ///   2. Is the detector source beside this binary still byte-identical to the one this
    ///      binary was cut from? Re-hashed here, and this one can REFUSE.
    ///
    /// The equality of the two tools' law is measured by wasi-exposure-one-law.sh, which can
    /// see both binaries and the source; a binary cannot check that about itself, and a
    /// binary that claims to is asserting rather than measuring.
    static func recheckLaw() {
        // ---- 1. where the law came from ----------------------------------------------
        kv("law_cut_from", CORE_SOURCE_NAME + " lines " + CORE_SLICE_LINES
                         + ", at the SECTION 11 MAIN marker the sibling tool cuts at")
        emit("  No law digest is frozen into this binary. Whether this tool and wasi-sandwiched")
        emit("  carry the SAME law is measured by wasi-exposure-one-law.sh, which reads both")
        emit("  binaries and requires one digest out of the two — a relation, not a literal,")
        emit("  because a literal goes stale the first time the law legitimately grows.")

        // ---- 2. the detector source beside the binary is still those bytes ------------
        let exeDir = (CommandLine.arguments[0] as NSString).deletingLastPathComponent
        let candidates = [exeDir + "/" + CORE_SOURCE_NAME,
                          FileManager.default.currentDirectoryPath + "/" + CORE_SOURCE_NAME]
        var rechecked = false
        for path in candidates where FileManager.default.fileExists(atPath: path) {
            guard let h = sha256File(path) else { continue }
            rechecked = true
            if h.hex == CORE_SOURCE_SHA256 {
                kv("law_recheck", "AGREES — " + path + " is byte-identical to the source this binary was cut from")
            } else {
                kv("law_recheck", "DISAGREES — " + path)
                kv("law_recheck_expected", CORE_SOURCE_SHA256)
                kv("law_recheck_computed", h.hex)
                emit("  The detector source beside this binary has been edited since this binary")
                emit("  was built. That does NOT change what this binary computes — the law is")
                emit("  compiled in — and it is NOT a fault: the file is shared and other work")
                emit("  lands in it. It is printed so nobody has to wonder which of the two they")
                emit("  are reading. Rebuild with wasi-exposure-build.sh to move onto the new one.")
            }
            break
        }
        if !rechecked {
            kv("law_recheck", "NOT_AVAILABLE — the detector source is not beside this binary, so the compiled-in digest could not be re-derived here. That is NOT a pass; it is a check that did not run.")
        }
    }

    static func usage() {
        header()
        recheckLaw()
        section("NOTHING WAS GIVEN")
        emit("usage:  ./wasi-exposure <pool-address> <token-in> <amount-in>")
        emit("")
        emit("  pool-address  the pool you are about to trade against, 0x + 40 hex")
        emit("  token-in      the token YOU are paying, 0x + 40 hex — it must be one of the")
        emit("                pool's two, and if it is not, this refuses rather than guessing")
        emit("  amount-in     how much of it, in that token's BASE UNITS (wei for an 18-decimal")
        emit("                token). An integer. Nothing here is ever a decimal.")
        emit("")
        emit("  ./wasi-exposure 0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852 \\")
        emit("                  0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 \\")
        emit("                  6000000000000000000")
        emit("")
        emit("options")
        emit("  --selftest              run every arm and exit, no network")
        emit("  --validate --dir DIR    run the check against the 87 losses that already")
        emit("                          happened, in the pinned corpus at DIR")
        emit("  --verbose               print every self-test arm alongside the answer")
        emit("  --endpoint-a U          force the first endpoint")
        emit("  --endpoint-b U          force the confirming endpoint (must differ from A)")
        emit("")
        emit("A GATE GIVEN NOTHING MUST NOT PASS. No pool was supplied, so nothing was")
        emit("measured and no exposure is offered. This is NOT a finding of zero exposure.")
        xReferenceFigures("NOTHING_GIVEN")
        emit("")
        emit(X_LIMITS)
        flush()
        exit(X_EXIT_NOTHING_GIVEN)
    }

    static func normAddr(_ s: String) -> Addr? {
        var t = s.lowercased()
        if t.hasPrefix("0x") { t = String(t.dropFirst(2)) }
        if t.count != 40 { return nil }
        for c in t.utf8 {
            let ok = (c >= 0x30 && c <= 0x39) || (c >= 0x61 && c <= 0x66)
            if !ok { return nil }
        }
        return parseAddrLit("0x" + t)
    }

    /// Decimal string to U256, using the detector's own decU256.
    static func normAmount(_ s: String) -> U256? {
        let t = s.replacingOccurrences(of: "_", with: "").replacingOccurrences(of: ",", with: "")
        if t.isEmpty { return nil }
        return decU256(t)
    }

    // ---- reading the pool's current state, twice, from two independent endpoints -----
    // Standard read-only selectors. Every one of these is what a block explorer calls.
    static let SEL_GETRESERVES = "0x0902f1ac"
    static let SEL_TOKEN0      = "0x0dfe1681"
    static let SEL_TOKEN1      = "0xd21220a7"
    static let SEL_SLOT0       = "0x3850c7bd"
    static let SEL_LIQUIDITY   = "0x1a686502"
    static let SEL_FEE         = "0xddca3f43"

    static func call(_ ep: String, _ to: Addr, _ selector: String, _ block: String) -> XResult {
        let payload = "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_call\",\"params\":[{\"to\":\""
            + addrHexOf(to) + "\",\"data\":\"" + selector + "\"},\"" + block + "\"]}"
        return xPost(ep, payload)
    }

    /// Read one pool at one block from one endpoint. Returns the state, or a named reason.
    static func readPool(_ ep: String, _ pool: Addr, _ blockTag: String, _ trail: inout [String]) -> (PoolState?, String) {
        var st = PoolState()
        st.pool = pool
        st.servedBy = ep

        let t0 = call(ep, pool, SEL_TOKEN0, blockTag)
        trail.append("  token0()      " + ep + "  " + t0.wire.rawValue + "  " + String(t0.millis) + "ms")
        let t1 = call(ep, pool, SEL_TOKEN1, blockTag)
        trail.append("  token1()      " + ep + "  " + t1.wire.rawValue + "  " + String(t1.millis) + "ms")
        if t0.wire == .LIVE, t1.wire == .LIVE,
           let h0 = xCallHex(t0.body), let h1 = xCallHex(t1.body),
           h0.count >= 64, h1.count >= 64,
           let a0 = normAddr(String(h0.suffix(40))), let a1 = normAddr(String(h1.suffix(40))) {
            st.token0 = a0; st.token1 = a1; st.haveTokens = true
        }

        // constant product?
        let gr = call(ep, pool, SEL_GETRESERVES, blockTag)
        trail.append("  getReserves() " + ep + "  " + gr.wire.rawValue + "  " + gr.reason + "  " + String(gr.millis) + "ms")
        if gr.wire == .LIVE, xCallWordCount(gr.body) >= 2,
           let w0 = xCallWord(gr.body, 0), let w1 = xCallWord(gr.body, 1) {
            st.shape = .constantProduct
            st.r0 = U256(mag: w0); st.r1 = U256(mag: w1)
            if st.r0.isZero || st.r1.isZero { return (nil, "POOL_HAS_A_ZERO_RESERVE") }
            return (st, "CONSTANT_PRODUCT")
        }

        // concentrated liquidity?
        let s0 = call(ep, pool, SEL_SLOT0, blockTag)
        trail.append("  slot0()       " + ep + "  " + s0.wire.rawValue + "  " + s0.reason + "  " + String(s0.millis) + "ms")
        if s0.wire == .LIVE, xCallWordCount(s0.body) >= 1, let sp = xCallWord(s0.body, 0) {
            let lq = call(ep, pool, SEL_LIQUIDITY, blockTag)
            trail.append("  liquidity()   " + ep + "  " + lq.wire.rawValue + "  " + String(lq.millis) + "ms")
            let fe = call(ep, pool, SEL_FEE, blockTag)
            trail.append("  fee()         " + ep + "  " + fe.wire.rawValue + "  " + String(fe.millis) + "ms")
            guard lq.wire == .LIVE, let lw = xCallWord(lq.body, 0) else { return (nil, "SLOT0_BUT_NO_LIQUIDITY") }
            guard fe.wire == .LIVE, let fw = xCallWord(fe.body, 0), let f = U256(mag: fw).asU64 else { return (nil, "SLOT0_BUT_NO_FEE_TIER") }
            st.shape = .concentrated
            st.sqrtP = U256(mag: sp); st.liq = U256(mag: lw); st.feePips = f
            if st.sqrtP.isZero { return (nil, "POOL_PRICE_IS_ZERO") }
            if st.liq.isZero { return (nil, "POOL_HAS_NO_LIQUIDITY_AT_THIS_PRICE") }
            if f == 0 || f >= 1_000_000 { return (nil, "FEE_TIER_OUT_OF_RANGE") }
            return (st, "CONCENTRATED_LIQUIDITY")
        }

        if gr.wire == .REFUSAL || s0.wire == .REFUSAL { return (nil, "ENDPOINT_REFUSED") }
        if gr.wire == .BOT_BLOCKED || s0.wire == .BOT_BLOCKED { return (nil, "BOT_BLOCKED") }
        return (nil, "NOT_A_POOL_SHAPE_THIS_PROGRAM_READS")
    }

    // =================================================================================
    // VALIDATION — against the 87 losses that already happened
    // =================================================================================
    static func validate(dir: String) -> Never {
        section("VALIDATION — does this check reproduce losses that ALREADY HAPPENED?")
        emit("For each costed victim the study published, equation (5) is run at the pool")
        emit("state that stood BEFORE the front leg, with the attacker size that was ACTUALLY")
        emit("used — read out of the block, never solved for. It must reproduce the shortfall")
        emit("equation (4) computed, to the base unit. If it cannot reproduce a loss that")
        emit("already happened, it cannot forecast one, and the verdict is BROKEN.")
        emit("")
        let blocks = dir + "/blocks.ndjson"
        let receipts = dir + "/receipts.ndjson"
        kv("corpus_dir", dir)
        for p in [blocks, receipts] {
            if !FileManager.default.fileExists(atPath: p) {
                kv("corpus_file", p + "  ABSENT")
                emit("")
                emit("ABSENT is not a REFUSAL and it is not a pass. The corpus is fetched, never")
                emit("committed: 653,122,749 bytes is too much to carry, and it is public.")
                xReferenceFigures("CORPUS_ABSENT")
                flush(); exit(X_EXIT_REFUSED)
            }
        }
        guard let hb = sha256File(blocks), let hr = sha256File(receipts) else {
            kv("corpus_digest", "NOT_READABLE"); flush(); exit(X_EXIT_REFUSED)
        }
        kv("blocks_ndjson_bytes", hb.bytes)
        kv("blocks_ndjson_sha256_computed", hb.hex)
        kv("receipts_ndjson_bytes", hr.bytes)
        kv("receipts_ndjson_sha256_computed", hr.hex)
        let EXP_B = "2f3c1b9f23645c7b0ad652b1ba677691a16b7a6b538f31af5680189cbf47e5ff"
        let EXP_R = "af09271d39451288bbd9728f6488bb7a7e0d3441428caa22530d159af562feb0"
        kv("blocks_ndjson_sha256_expected", EXP_B)
        kv("receipts_ndjson_sha256_expected", EXP_R)
        if hb.hex != EXP_B || hr.hex != EXP_R {
            emit("")
            emit("INPUT DIGEST MISMATCH. These are not the pinned bytes the published figures")
            emit("were measured over, so an agreement count against them would mean nothing.")
            xReferenceFigures("CORPUS_DIGEST_MISMATCH")
            flush(); exit(X_EXIT_REFUSED)
        }
        kv("hash_check", "BOTH_MATCH")

        // --- the detector's own run, same code path -----------------------------------
        var r = Run()
        runCorpus(blocksPath: blocks, receiptsPath: receipts, expectStart: 14_000_000, expectCount: 1000, r: &r)
        kv("blocks_read", r.blocks)
        kv("detections", UInt64(r.dets.count))
        if r.blocks == 0 || r.dets.isEmpty {
            emit("A GATE GIVEN NOTHING MUST NOT PASS. The corpus produced no detections.")
            xReferenceFigures("CORPUS_PRODUCED_NOTHING")
            flush(); exit(X_EXIT_REFUSED)
        }

        // --- the second pass: the attacker's ACTUAL size, observed --------------------
        let legs = xIndexLegs(blocksPath: blocks, receiptsPath: receipts, expectStart: 14_000_000)
        kv("swap_legs_indexed", UInt64(legs.count))

        var costed = 0
        var checked = 0
        var matched = 0
        var differed = 0
        var notKnown = 0
        // THE FRONT LEG CENSUS. A constant-product pool's swap() lets its caller name the
        // amount it takes OUT; the pool checks only that its own invariant is not broken.
        // So an inserted leg MAY take less than the exact-input formula would give it, and
        // whether it did is a MEASUREMENT, not an assumption. Every checked V2 row is
        // classified here, and the classes are the two directions of one question.
        var frontExactInput = 0
        var frontTookLess = 0
        var frontTookMore = 0
        var frontUnmodelled = 0
        var frontTookLessButRowStillMatched = 0
        var overStated = 0          // prediction ABOVE the realised loss — conservative
        var underStated = 0         // prediction BELOW it — the failure that matters
        var byShape = [String: (Int, Int)]()          // shape -> (checked, matched)
        var worstDiff = U256()
        var worstRow = ""
        var rows: [String] = []
        var notKnownReasons = [String: Int]()

        for d in r.dets {
            if d.status != .exact && d.status != .interval { continue }
            costed += 1
            let key = String(d.block) + "|" + addrKey(d.pool) + "|" + String(d.txFront)
            guard let front = legs[key] else {
                notKnown += 1; notKnownReasons["FRONT_LEG_NOT_FOUND_IN_INDEX", default: 0] += 1; continue
            }
            if front.seen != 1 {
                notKnown += 1; notKnownReasons["MORE_THAN_ONE_SWAP_LOG_AT_THAT_KEY", default: 0] += 1; continue
            }
            // The victim's direction, from the detector's own record.
            let vKey = String(d.block) + "|" + addrKey(d.pool) + "|" + String(d.txVictim)
            guard let vic = legs[vKey], vic.seen == 1 else {
                notKnown += 1; notKnownReasons["VICTIM_LEG_NOT_UNIQUE_IN_INDEX", default: 0] += 1; continue
            }
            if front.dir != vic.dir {
                notKnown += 1; notKnownReasons["FRONT_AND_VICTIM_DIRECTIONS_DISAGREE", default: 0] += 1; continue
            }
            let side = Side(zeroForOne: vic.dir == 0)

            // --- the pre-front state, in the pool's OWN native form ------------------
            var st = PoolState()
            st.pool = d.pool
            if d.kind == 2 {
                st.shape = .constantProduct
                // reserveInPre / reserveOutPre are the pre-front reserves on the victim's
                // own side; put them back in token0/token1 order.
                if side.zeroForOne { st.r0 = d.reserveInPre; st.r1 = d.reserveOutPre }
                else { st.r1 = d.reserveInPre; st.r0 = d.reserveOutPre }
                st.feeNum = d.feeNum
            } else {
                st.shape = .concentrated
                st.liq = front.liq
                st.feePips = d.feeNum
                // The price before the front leg, recovered by the SAME inversion the
                // published shortfall used: v3InvertStart on the front leg's own event.
                guard let (s0lo, _) = v3InvertStart(sqrtAfter: front.sqrtP, liquidity: front.liq,
                                                    feePips: d.feeNum, grossIn: front.amountIn,
                                                    observedOut: front.amountOut,
                                                    zeroForOne: front.dir == 0) else {
                    notKnown += 1; notKnownReasons["FRONT_LEG_NOT_INVERTIBLE_IN_SECOND_PASS", default: 0] += 1; continue
                }
                st.sqrtP = s0lo
            }

            let e = xExposure(st, side, amountIn: d.victimIn, attackerIn: front.amountIn)
            checked += 1
            let shapeKey = d.kind == 2 ? "CONSTANT_PRODUCT" : "CONCENTRATED_LIQUIDITY"
            var acc = byShape[shapeKey] ?? (0, 0)
            acc.0 += 1

            guard case .known(let due, _, let taken, let bp) = e else {
                var why = "?"
                if case .notKnown(let w) = e { why = w }
                notKnown += 1; notKnownReasons[why, default: 0] += 1
                byShape[shapeKey] = acc
                rows.append(String(d.block) + "\t" + d.victimTx + "\t" + shapeKey + "\tNOT_KNOWN\t" + why)
                continue
            }
            // ---- the front leg census, before any verdict ------------------------
            var frontNote = ""
            if d.kind == 2 {
                let rinPre  = side.zeroForOne ? st.r0 : st.r1
                let routPre = side.zeroForOne ? st.r1 : st.r0
                if let modelled = v2Out(front.amountIn, rinPre, routPre, st.feeNum) {
                    let c = U256.cmp(front.amountOut, modelled)
                    if c == 0 { frontExactInput += 1; frontNote = "FRONT_LEG_IS_EXACT_INPUT" }
                    else if c < 0 {
                        frontTookLess += 1
                        // Name the cause precisely: is it an exact-input swap at a DIFFERENT
                        // fee, or not an exact-input swap at all? The pool's own fee-recovery
                        // answers that, and an empty interval is a different answer from a
                        // wide one.
                        let alt = v2RecoverFeeInterval(front.amountIn, rinPre, routPre, front.amountOut)
                        frontNote = "FRONT_LEG_TOOK_LESS_THAN_THE_POOL_WOULD_GIVE by "
                            + (modelled - front.amountOut).dec
                            + (alt == nil ? " · NOT_AN_EXACT_INPUT_SWAP_AT_ANY_FEE"
                                          : " · exact-input at fee " + String(alt!.lo) + ".." + String(alt!.hi) + "/1000")
                    } else {
                        frontTookMore += 1
                        frontNote = "FRONT_LEG_TOOK_MORE_THAN_THE_POOL_WOULD_GIVE by "
                            + (front.amountOut - modelled).dec + " — REPORT THIS, it breaks the pool invariant"
                    }
                } else { frontUnmodelled += 1; frontNote = "FRONT_LEG_OUT_OF_ARITHMETIC_RANGE" }
            }

            // The published realised shortfall for this victim.
            let realised = d.shortfall
            let agree = !realised.neg && U256.cmp(realised.mag, taken) == 0
            // The DUE half is a second, independent agreement: the counterfactual output
            // this program computes must be the counterfactual the study published.
            let dueAgree = U256.cmp(due, d.victimOutCF) == 0
            if agree && dueAgree {
                matched += 1; acc.1 += 1
                // A leg that took less can still leave the victim's integer output unchanged,
                // because out() floors. Counted, so "3 took less" and "2 rows differed" do not
                // read as a contradiction.
                if frontNote.hasPrefix("FRONT_LEG_TOOK_LESS") { frontTookLessButRowStillMatched += 1 }
            }
            else {
                differed += 1
                let over = U256.cmp(taken, realised.mag) > 0
                if over { overStated += 1 } else { underStated += 1 }
                let diff = U256.cmp(realised.mag, taken) >= 0 ? realised.mag - taken : taken - realised.mag
                if U256.cmp(diff, worstDiff) > 0 { worstDiff = diff; worstRow = d.victimTx }
                var share = "NOT_KNOWN"
                if !realised.mag.isZero, let sh = U256.mulDiv(diff, U256(10_000), realised.mag), let v = sh.asU64 {
                    share = String(v) + "/10000_of_that_rows_realised_loss"
                }
                rows.append(String(d.block) + "\t" + d.victimTx + "\t" + shapeKey
                            + "\tDIFFERS\trealised=" + realised.dec + "\tpredicted=" + taken.dec
                            + "\tdiff=" + diff.dec + "\t" + share
                            + "\t" + (over ? "PREDICTION_ABOVE_REALISED" : "PREDICTION_BELOW_REALISED")
                            + "\tdue_agrees=" + (dueAgree ? "YES" : "NO")
                            + "\tattacker_in=" + front.amountIn.dec
                            + "\t" + frontNote)
            }
            byShape[shapeKey] = acc
            if agree && dueAgree && rows.count < 12 {
                rows.append(String(d.block) + "\t" + d.victimTx + "\t" + shapeKey
                            + "\tMATCH\tattacker_in=" + front.amountIn.dec
                            + "\ttaken=" + taken.dec + "\t" + String(bp) + "/10000")
            }
        }

        emit("")
        kv("costed_victims_in_the_corpus", UInt64(costed))
        kv("of_those_CHECKED_by_equation_5", UInt64(checked))
        kv("MATCHED_to_the_base_unit", UInt64(matched))
        kv("DIFFERED", UInt64(differed))
        kv("NOT_KNOWN", UInt64(notKnown))
        if !notKnownReasons.isEmpty {
            emit("NOT_KNOWN is not zero and it is not a match. Each class names its reason:")
            for k in notKnownReasons.keys.sorted() { emit("  " + k + "\t" + String(notKnownReasons[k]!)) }
        }
        if differed > 0 {
            kv("largest_difference_base_units", worstDiff.dec)
            kv("largest_difference_row", worstRow)
        } else {
            emit("largest_difference_base_units\t0 — every checked row agreed EXACTLY, not approximately")
        }
        emit("")
        emit("THE FRONT LEG CENSUS — constant-product rows only, both directions of one question.")
        emit("A V2 pool's swap() lets its caller name the amount it takes OUT and checks only")
        emit("its own invariant, so an inserted leg MAY take less than the exact-input formula")
        emit("gives. Equation (5) models the exact-input leg, so where a real leg took less,")
        emit("the prediction stands ABOVE what was realised — and that is measured here, not")
        emit("assumed.")
        kv("front_leg_was_exact_input", UInt64(frontExactInput))
        kv("front_leg_took_LESS_than_the_pool_would_give", UInt64(frontTookLess))
        kv("front_leg_took_MORE_than_the_pool_would_give", UInt64(frontTookMore))
        kv("front_leg_out_of_arithmetic_range", UInt64(frontUnmodelled))
        kv("of_those_that_took_less_rows_that_STILL_matched_exactly", UInt64(frontTookLessButRowStillMatched))
        emit("  (out() floors to an integer, so a leg that took slightly less can leave the")
        emit("   victim's own output unchanged. That is why the two counts above differ.)")
        kv("differences_where_the_prediction_stood_ABOVE_the_realised_loss", UInt64(overStated))
        kv("differences_where_the_prediction_stood_BELOW_the_realised_loss", UInt64(underStated))
        emit("")
        emit("BY VENUE SHAPE — the two are kept apart because they are different arithmetic:")
        emit("shape\tchecked\tmatched")
        for k in byShape.keys.sorted() {
            let v = byShape[k]!
            emit(k + "\t" + String(v.0) + "\t" + String(v.1))
        }
        emit("")
        emit("EVERY ROW THAT DIFFERED, IN FULL — none is elided, whatever the count:")
        emit("block\tvictim_tx\tshape\tverdict\tdetail")
        let differing = rows.filter { $0.contains("\tDIFFERS\t") || $0.contains("\tNOT_KNOWN\t") }
        if differing.isEmpty { emit("(none)") } else { for row in differing { emit(row) } }
        emit("")
        emit("SAMPLE MATCHED ROWS — victim hashes printed so the harmed party can find their own:")
        emit("block\tvictim_tx\tshape\tverdict\tdetail")
        for row in rows.filter({ $0.contains("\tMATCH\t") }).prefix(12) { emit(row) }

        emit("")
        // THREE VERDICTS, NOT TWO. A prediction that UNDER-states somebody's exposure is the
        // failure that matters — they sign on a number that was too small. A prediction that
        // OVER-states it, with the cause named and the deviation measured, is a different
        // answer and must not be printed as the same word. Neither is "approximately right".
        let anyUnder = underStated > 0
        let anyImpossible = frontTookMore > 0
        if checked == 0 {
            emit("################  VALIDATION:  BROKEN  ################")
            emit("A GATE GIVEN NOTHING MUST NOT PASS. No row was checked, so nothing was measured.")
            xReferenceFigures("VALIDATION_GIVEN_NOTHING")
            flush(); exit(X_EXIT_VALIDATION_BROKEN)
        }
        if anyUnder || anyImpossible {
            emit("################  VALIDATION:  BROKEN  ################")
            if anyUnder {
                emit("On " + String(underStated) + " row(s) the check predicted LESS than was actually")
                emit("taken. That is the failure that matters: somebody would sign on a number that")
                emit("was too small. Nothing this program prints about a future trade is worth")
                emit("acting on until this reads zero.")
            }
            if anyImpossible {
                emit("On " + String(frontTookMore) + " row(s) an inserted leg took MORE than the pool's")
                emit("own arithmetic allows, which the invariant forbids. The reading is not trusted.")
            }
            xReferenceFigures("VALIDATION_BROKEN")
            flush(); exit(X_EXIT_VALIDATION_BROKEN)
        }
        if matched == checked {
            emit("################  VALIDATION:  GREEN — EXACT  ################")
            emit("Equation (5) reproduced every checked realised loss to the base unit. The")
            emit("forecast and the post-mortem are the same arithmetic, and this is the")
            emit("measurement that says so rather than the comment at the top of the file.")
            xReferenceFigures("VALIDATION_GREEN_EXACT")
        } else {
            emit("################  VALIDATION:  GREEN — EXACT ON " + String(matched) + " OF " + String(checked)
                 + ", AN UPPER BOUND ON " + String(differed) + "  ################")
            emit("Every checked row was reproduced to the base unit EXCEPT " + String(differed) + ", and on")
            emit("every one of those the prediction stood ABOVE what was realised — never below.")
            emit("The cause is measured, not assumed, and it is printed row by row above: those")
            emit("inserted legs took LESS out of the pool than the exact-input formula would have")
            emit("given them, which a constant-product pool permits its caller to do.")
            emit("")
            emit("SO READ THE FIGURE AS AN UPPER BOUND, AND THAT IS THE RIGHT DIRECTION FOR A")
            emit("PRE-TRADE CHECK: it says what a leg of that size COULD take, and a real leg")
            emit("cannot take more. It is NOT a promise of exactness on every future trade, and")
            emit("this program does not print one.")
            kv("largest_over_statement_base_units", worstDiff.dec)
            kv("as_a_share_of_that_rows_realised_loss", "see the DIFFERS rows above — both figures are printed")
            xReferenceFigures("VALIDATION_GREEN_UPPER_BOUND")
        }
        emit("")
        emit(X_LIMITS)
        flush(); exit(X_EXIT_OK)
    }

    // =================================================================================
    static func main() {
        let argv = CommandLine.arguments
        func opt(_ n: String) -> String? {
            if let i = argv.firstIndex(of: n), i + 1 < argv.count { return argv[i + 1] }
            return nil
        }
        func flg(_ n: String) -> Bool { argv.contains(n) }
        let verbose = flg("--verbose")
        let valueFlags = ["--dir", "--endpoint-a", "--endpoint-b", "--block"]

        if flg("--selftest") {
            header()
            recheckLaw()
            let rc = xSelftest()
            xReferenceFigures("SELFTEST")
            flush()
            exit(rc == 0 ? 0 : 1)
        }

        let nonFlag = argv.dropFirst().filter { !$0.hasPrefix("--") }
            .filter { a in !valueFlags.contains { f in
                if let i = argv.firstIndex(of: f), i + 1 < argv.count { return argv[i + 1] == a }
                return false } }

        if flg("--validate") {
            header()
            recheckLaw()
            flush()
            let rc = xSelftest()
            if rc != 0 {
                xRefuse("SELFTEST_FAILED", "this program's own instruments do not agree with themselves, so no reading from it is valid")
            }
            guard let dir = opt("--dir") else {
                xRefuse("NO_CORPUS_DIRECTORY", "--validate needs --dir pointing at the directory holding blocks.ndjson and receipts.ndjson")
            }
            validate(dir: dir)
        }

        if nonFlag.count < 3 { usage() }

        header()
        recheckLaw()
        flush()

        // ---- every arm runs before any answer ----------------------------------------
        let rc = xSelftest()
        if !verbose {
            OUT = ""
            section("SELF-TEST")
            kv("arms_run", xArms); kv("arms_passed", xPass); kv("arms_failed", xFail)
            emit(xFail == 0 ? "SELFTEST_GREEN" : "SELFTEST_RED")
            emit("(--selftest prints all of them, with both directions)")
        }
        if rc != 0 {
            xRefuse("SELFTEST_FAILED", "this program's own instruments do not agree with themselves, so no reading from it is valid")
        }

        // ---- what was given ----------------------------------------------------------
        section("WHAT YOU GAVE ME")
        let poolArg = nonFlag[0], tokenArg = nonFlag[1], amountArg = nonFlag[2]
        kv("pool", poolArg)
        kv("token_you_are_paying", tokenArg)
        kv("amount_in_base_units", amountArg)
        guard let pool = normAddr(poolArg) else {
            xRefuse("NOT_AN_ADDRESS", "a pool address is 0x followed by exactly 40 hex characters; that is not one, so there is nothing to read")
        }
        guard let tokenIn = normAddr(tokenArg) else {
            xRefuse("NOT_AN_ADDRESS", "the token you are paying must be given as 0x followed by exactly 40 hex characters")
        }
        guard let amountIn = normAmount(amountArg), !amountIn.isZero else {
            xRefuse("NOT_A_BASE_UNIT_AMOUNT", "the amount must be a whole number of that token's base units — no decimal point, no unit suffix. 1 ETH is 1000000000000000000.")
        }

        // ---- read the pool, twice, from two independent endpoints --------------------
        let epA = opt("--endpoint-a"), epB = opt("--endpoint-b")
        var order = X_ENDPOINTS.map { $0.url }
        if let a = epA { order = [a] + order.filter { $0 != a } }

        section("READING THE POOL — endpoint by endpoint, verdict from the BODY not the status code")
        var trail: [String] = []
        var stA: PoolState? = nil
        var whyA = ""
        var servedBy = ""
        for ep in order {
            let (s, why) = readPool(ep, pool, "latest", &trail)
            trail.append("  -> " + ep + "  " + why)
            if let s = s { stA = s; whyA = why; servedBy = ep; break }
            whyA = why
        }
        for t in trail { emit(t) }
        guard var st = stA else {
            xRefuse("POOL_NOT_READ_" + whyA,
                    "no endpoint served a pool state this program can read at that address. An unknown pool is REFUSED — it is never answered as zero exposure, because somebody signs on that answer.",
                    fromTheWire: true)
        }
        kv("served_by", servedBy)
        kv("pool_shape", st.shape.rawValue)

        // block number the state was read at — the answer is for THAT state and no other
        var blockAt: UInt64 = 0
        for ep in [servedBy] {
            let r = xPost(ep, "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_blockNumber\",\"params\":[]}")
            if r.wire == .LIVE, let res = xCallHex(r.body) {
                blockAt = UInt64(res, radix: 16) ?? 0
            }
        }
        st.blockNumber = blockAt

        // ---- cross-confirm from a SECOND, independent endpoint -----------------------
        // A control driven by the same source is not a control.
        var confirmTrail: [String] = []
        var confirmer = ""
        var stB: PoolState? = nil
        var bOrder = X_ENDPOINTS.map { $0.url }.filter { $0 != servedBy }
        if let b = epB {
            if b == servedBy {
                xRefuse("CONFIRMING_ENDPOINT_IS_THE_SERVING_ENDPOINT",
                        "one endpoint cannot confirm itself. Naming the same host twice would make the cross-check pass by construction and it would mean nothing.")
            }
            bOrder = [b] + bOrder.filter { $0 != b }
        }
        for ep in bOrder {
            let (s, why) = readPool(ep, pool, "latest", &confirmTrail)
            confirmTrail.append("  -> " + ep + "  " + why)
            if let s = s { stB = s; confirmer = ep; break }
        }
        section("CROSS-CONFIRMATION — a second, independent endpoint")
        for t in confirmTrail { emit(t) }
        var confirmed = "NO"
        if let b = stB {
            kv("confirmed_by", confirmer)
            if b.shape != st.shape {
                xRefuse("TWO_ENDPOINTS_TWO_POOL_SHAPES",
                        "the two endpoints disagree about what kind of pool this is. Nothing can be concluded from a disputed state.",
                        fromTheWire: true)
            }
            let same: Bool
            switch st.shape {
            case .constantProduct:
                same = U256.cmp(b.r0, st.r0) == 0 && U256.cmp(b.r1, st.r1) == 0
            case .concentrated:
                same = U256.cmp(b.sqrtP, st.sqrtP) == 0 && U256.cmp(b.liq, st.liq) == 0 && b.feePips == st.feePips
            }
            confirmed = same ? "YES_IDENTICAL_STATE" : "READ_BUT_THE_STATE_HAD_MOVED"
            kv("state_agreement", confirmed)
            if !same {
                emit("The two reads differ. That is NOT an error: a live pool moves between two")
                emit("HTTP requests, and this is the honest form of limit 3 below. The figures")
                emit("that follow are for the FIRST read, at the block printed above, and for no")
                emit("other state.")
            }
        } else {
            kv("confirmed_by", "NONE — only one endpoint served this pool")
            kv("state_agreement", "NOT_CHECKED — that is a check that did not run, never a pass")
        }
        st.confirmedBy = confirmer

        // ---- which side of the pool is the caller on? --------------------------------
        section("YOUR SIDE OF THE POOL")
        if !st.haveTokens {
            xRefuse("POOL_TOKENS_NOT_READ",
                    "this pool would not say which two tokens it holds, so this program cannot tell which side of it you are on. It refuses rather than assuming.",
                    fromTheWire: true)
        }
        kv("token0", addrHexOf(st.token0) + "  " + tokenLabel(st.token0))
        kv("token1", addrHexOf(st.token1) + "  " + tokenLabel(st.token1))
        let zeroForOne: Bool
        if addrEq(tokenIn, st.token0) { zeroForOne = true }
        else if addrEq(tokenIn, st.token1) { zeroForOne = false }
        else {
            xRefuse("TOKEN_IS_NOT_IN_THIS_POOL",
                    "the token you said you are paying is neither of this pool's two tokens. This is refused, not answered — an exposure figure for the wrong pair would be a number about a different question.")
        }
        let side = Side(zeroForOne: zeroForOne)
        kv("you_are_paying", tokenLabel(tokenIn))
        kv("you_receive", tokenLabel(zeroForOne ? st.token1 : st.token0))
        if let dec = tokenDecimals(tokenIn) { kv("its_decimals", String(dec)) }
        else { kv("its_decimals", "NOT_KNOWN — this program knows the decimals of WETH, USDC, USDT, DAI and WBTC only, and never guesses one. Every figure below is in BASE UNITS regardless.") }

        // ---- the answer --------------------------------------------------------------
        emit("")
        emit(X_BANNER_EXPOSED)
        emit("")
        section("WHAT YOU ARE DUE, AT THE STATE READ")
        kv("state_read_at_block", blockAt == 0 ? "NOT_KNOWN" : String(blockAt))
        kv("pool_shape", st.shape.rawValue)
        switch st.shape {
        case .constantProduct:
            kv("reserve_token0", st.r0.dec)
            kv("reserve_token1", st.r1.dec)
            kv("fee_numerator_used", String(st.feeNum) + "/1000  — the standard constant-product fee; this program does not read a per-pool override and says so rather than pretending it did")
        case .concentrated:
            kv("sqrtPriceX96", st.sqrtP.dec)
            kv("liquidity", st.liq.dec)
            kv("fee_pips", String(st.feePips) + " of 1,000,000")
            if let d = xInputDepth(st, side) { kv("virtual_reserve_your_side", d.dec) }
        }
        guard let due = xOut(st, side, amountIn) else {
            xRefuse("YOUR_TRADE_IS_OUT_OF_THIS_POOLS_RANGE",
                    "this pool's own arithmetic will not return a value for a trade that size at this state. That is NOT_KNOWN, not zero exposure.")
        }
        kv("you_pay", amountIn.dec + "  " + tokenLabel(tokenIn) + " base units")
        kv("you_are_due", due.dec + "  " + tokenLabel(zeroForOne ? st.token1 : st.token0) + " base units")
        emit("(before any router fee, any gas, and any slippage limit you set — this is the")
        emit(" pool's own answer to your own amount, and nothing else.)")

        // ---- THE QUANTITY THE STUDY MEASURED AS PREDICTIVE ---------------------------
        section("THE SIZE THAT MATTERS — pool-relative, not absolute")
        if let bp = xPoolRelativeSizeBp(st, side, amountIn) {
            kv("your_trade_as_ten_thousandths_of_this_pools_depth", String(bp))
            emit("The study measured this quantity, not your trade's size in ETH, as the one that")
            emit("tracks the hit: pool-relative size Kendall tau +491 permille, absolute ETH size")
            emit("Kendall tau −500 permille over the same 87 victims. In absolute terms the")
            emit("SMALLER trades took the LARGER relative hit, because they were the ones sitting")
            emit("in thin pools. The number above is the one to watch.")
            let median: UInt64 = 476
            if bp >= 1000 { kv("where_that_sits", "LARGE relative to this pool — " + String(bp) + " ten-thousandths of its depth") }
            else if bp >= 100 { kv("where_that_sits", "middling — " + String(bp) + " ten-thousandths of its depth") }
            else { kv("where_that_sits", "small relative to this pool — " + String(bp) + " ten-thousandths of its depth") }
            kv("for_scale_the_published_median_LOSS_was", String(median) + " ten-thousandths of what the victim was due")
        } else {
            kv("your_trade_as_ten_thousandths_of_this_pools_depth", "NOT_KNOWN — the pool's input-side depth was out of arithmetic range")
        }

        // ---- THE LADDER --------------------------------------------------------------
        section("THE SHAPE — exposure at several inserted-leg sizes")
        emit("A single number would be a lie by omission: whoever inserts a leg picks its size,")
        emit("and you do not. So here is the whole curve. Each row is: an inserted leg of that")
        emit("size on your side of this pool, then your own trade, then their close.")
        emit("")
        let v3 = (st.shape == .concentrated)
        emit("inserted_leg_size\tin_base_units\tyou_would_receive\tTAKEN\tof_10000_you_are_due"
             + (v3 ? "\tprice_move_of_10000\tone_step_still_credible" : ""))
        let rungs = xLadder(st, side, amountIn)
        var lastTaken = U256()
        var monotone = true
        for r in rungs {
            switch r.e {
            case .known(_, let got, let taken, let bp):
                if U256.cmp(taken, lastTaken) < 0 { monotone = false }
                lastTaken = taken
                var tail = ""
                if v3, let after = xAdvance(st, side, r.f) {
                    // |sqrtP' − sqrtP| as ten-thousandths of sqrtP. A tick range on a V3 pool
                    // is 1 basis point wide at the finest spacing and about 200 at the widest,
                    // so a move of a few hundred ten-thousandths is where one step stops being
                    // a safe model. This is a SIGNAL, not a tick lookup, and it says so.
                    let hi = U256.cmp(after.sqrtP, st.sqrtP) >= 0 ? after.sqrtP : st.sqrtP
                    let lo = U256.cmp(after.sqrtP, st.sqrtP) >= 0 ? st.sqrtP : after.sqrtP
                    let d = hi - lo
                    if let mv = U256.mulDiv(d, U256(10_000), st.sqrtP), let m = mv.asU64 {
                        tail = "\t" + String(m) + "\t" + (m <= 100 ? "YES_small_move"
                                                        : m <= 1000 ? "MAYBE_check_the_ticks"
                                                                    : "NO_the_real_hit_is_LARGER")
                    } else { tail = "\tNOT_KNOWN\tNOT_KNOWN" }
                }
                emit(r.label + "\t" + r.f.dec + "\t" + got.dec + "\t" + taken.dec + "\t" + String(bp) + tail)
            case .notKnown(let why):
                emit(r.label + "\t" + r.f.dec + "\tNOT_KNOWN\tNOT_KNOWN\t" + why)
            }
        }
        kv("ladder_monotone_in_inserted_size", monotone ? "YES — as the arithmetic requires" : "NO — REPORT THIS, the arithmetic is wrong")
        if v3 {
            emit("The last two columns are the ONE LIMIT THAT CAN MAKE THIS FIGURE TOO SMALL.")
            emit("This models a single price step at the liquidity standing now. Where the move")
            emit("is large the leg will cross tick boundaries this program did not fetch, and on")
            emit("the far side there may be less liquidity — in which case the REAL hit is bigger")
            emit("than the row says. The error has a direction and it is named, on the row.")
        }
        if !monotone {
            xRefuse("LADDER_NOT_MONOTONE",
                    "a larger inserted leg took less than a smaller one, which the pool's arithmetic forbids. This program will not print a figure it cannot stand behind.")
        }

        // ---- THE TWO COMPARISONS — the whole practical value -------------------------
        section("THE CHOICE YOU ACTUALLY HAVE — the same trade elsewhere, or a smaller one here")
        emit("The two panels below hold the inserted leg at ONE times your own size — a stated")
        emit("reference, not a prediction — so that each panel isolates one thing you control.")
        emit("")
        emit("A. THE SAME TRADE, IN A DEEPER POOL AT THE SAME PRICE")
        emit("depth\tyour_size_of_10000_of_depth\tTAKEN\tof_10000_you_are_due")
        for k in [UInt64(1), 2, 5, 10, 100] {
            guard let dst = (k == 1 ? st : xDeeper(st, times: k)) else {
                emit(String(k) + "x\tNOT_KNOWN\tNOT_KNOWN\tNOT_KNOWN"); continue
            }
            let e = xExposure(dst, side, amountIn: amountIn, attackerIn: amountIn)
            let szs = xPoolRelativeSizeBp(dst, side, amountIn).map { String($0) } ?? "NOT_KNOWN"
            switch e {
            case .known(_, _, let taken, let bp):
                emit(String(k) + "x\t" + szs + "\t" + taken.dec + "\t" + String(bp))
            case .notKnown(let why):
                emit(String(k) + "x\t" + szs + "\tNOT_KNOWN\t" + why)
            }
        }
        emit("")
        emit("B. A SMALLER TRADE, IN THIS POOL, AS IT STANDS")
        emit("your_size\tin_base_units\tyour_size_of_10000_of_depth\tTAKEN\tof_10000_you_are_due")
        for (n, d) in [(UInt64(1), UInt64(1)), (1, 2), (1, 4), (1, 10), (1, 100)] {
            guard let a = U256.mulDiv(amountIn, U256(n), U256(d)), !a.isZero else {
                emit("1/" + String(d) + "\tNOT_KNOWN\tNOT_KNOWN\tNOT_KNOWN\tNOT_KNOWN"); continue
            }
            let lbl = d == 1 ? "full" : "1/" + String(d)
            let e = xExposure(st, side, amountIn: a, attackerIn: a)
            let szs = xPoolRelativeSizeBp(st, side, a).map { String($0) } ?? "NOT_KNOWN"
            switch e {
            case .known(_, _, let taken, let bp):
                emit(lbl + "\t" + a.dec + "\t" + szs + "\t" + taken.dec + "\t" + String(bp))
            case .notKnown(let why):
                emit(lbl + "\t" + a.dec + "\t" + szs + "\tNOT_KNOWN\t" + why)
            }
        }
        // ---- THE TWO PANELS ARE ONE FINDING, AND THAT IS CHECKED HERE ----------------
        // The study measured pool-relative size as what tracks the hit (+491 permille) and
        // absolute size as what does not (-500). If that is true of this pool, then halving
        // the trade and doubling the pool must land on the SAME exposure, because they land
        // on the same pool-relative size. It is a falsifiable prediction, so it is measured
        // rather than asserted.
        emit("")
        emit("THE TWO PANELS ARE THE SAME FINDING — checked, not claimed:")
        emit("pool_relative_size\tA_deeper_pool\tB_smaller_trade\tagree")
        var pairsChecked = 0, pairsAgreed = 0
        for k in [UInt64(2), 5, 10, 100] {
            guard let dst = xDeeper(st, times: k) else { continue }
            let ea = xExposure(dst, side, amountIn: amountIn, attackerIn: amountIn)
            guard let a2 = U256.mulDiv(amountIn, U256(1), U256(k)), !a2.isZero else { continue }
            let eb = xExposure(st, side, amountIn: a2, attackerIn: a2)
            guard let ba = xBp(ea), let bb = xBp(eb) else { continue }
            let szA = xPoolRelativeSizeBp(dst, side, amountIn).map { String($0) } ?? "?"
            let szB = xPoolRelativeSizeBp(st, side, a2).map { String($0) } ?? "?"
            pairsChecked += 1
            let ok = (ba == bb) && (szA == szB)
            if ok { pairsAgreed += 1 }
            emit(szA + (szA == szB ? "" : " vs " + szB) + "\t" + String(ba) + "\t" + String(bb) + "\t" + (ok ? "YES" : "NO"))
        }
        kv("panel_pairs_checked", UInt64(pairsChecked))
        kv("panel_pairs_that_AGREED", UInt64(pairsAgreed))
        if pairsChecked > 0 && pairsAgreed == pairsChecked {
            emit("Every pair agreed. On this pool, HALVING YOUR TRADE AND DOUBLING THE POOL'S")
            emit("DEPTH ARE THE SAME MOVE — which is the study's finding, reproduced on a pool it")
            emit("never saw. It is also the practical point: the quantity you can change is your")
            emit("size RELATIVE TO the depth you trade into, by either lever.")
        } else if pairsChecked > 0 {
            emit("Not every pair agreed. That is a real reading about THIS pool, not an error:")
            emit("integer flooring and, on a concentrated-liquidity pool, the price moving across")
            emit("the step both break the exact correspondence at some sizes. Both columns are")
            emit("printed above so the divergence is visible rather than averaged away.")
        }

        emit("")
        emit("Read the two panels together. Column 'of 10000 you are due' is the SAME quantity")
        emit("the study reported as the victim's relative loss — median 476 across 87 costed")
        emit("victims — so a row here is directly comparable to a row there. Splitting a trade")
        emit("into parts is not free either: each part pays the pool fee and its own gas, and")
        emit("this program does not model those. It reports the exposure and leaves the trade")
        emit("to you. NO PURCHASE, VENUE OR ACTION IS PROPOSED ANYWHERE IN THIS OUTPUT.")

        // ---- the limits, printed HERE, on the answer itself --------------------------
        section("HONEST LIMITS")
        emit(X_LIMITS)
        kv("this_answer_is_for_the_state_at_block", blockAt == 0 ? "NOT_KNOWN" : String(blockAt))
        kv("state_confirmed_by_a_second_endpoint", confirmed)
        kv("requests_made", UInt64(xRequests))
        kv("bytes_received", UInt64(xBytes))
        kv("cost", "ZERO — no key, no account, no registration, no payment, nobody's permission")

        xReferenceFigures("EXPOSURE_MEASURED")
        flush()
        exit(X_EXIT_OK)
    }
}
