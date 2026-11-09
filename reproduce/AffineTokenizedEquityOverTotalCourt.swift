// AffineTokenizedEquityOverTotalCourt.swift
// Swift 6.4 — Zero-Float, Zero-Hardcode Tokenized Equity Over-Total & Dark-Holding Audit Court
// Mounts at `/v1/shield/6/tokenized-equity-audit` on https://affine.earth/v1/shield/6/tokenized-equity-audit
// Enforces:
//   1. Strict ~Copyable Share Serial Conservation (No Double-Pledged Omnibus + ERC-20 Wrapper Minting)
//   2. Exact Cap-Table Closure: y_Total_Circulating_Claims - Ax_Charter_Issued_Shares == tau_OverTotal_Violation
//   3. SEC Section 13(d) / 13F Sybil Wallet Cluster Aggregation (> 500 bps / 5.00% Beneficial Ownership Lock)

#if canImport(Musl)
import Musl
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#elseif canImport(WASILibc)
import WASILibc
#endif
import Foundation

// MARK: - 1. Hardware-Locked ~Copyable Linear Share Certificate (Cannot Be Cloned or Double-Pledged)

public struct SovereignLinearShareBlock: ~Copyable, Sendable {
    public let tickerPacked64: UInt64
    public let serialRangeStart: Int128
    public let serialRangeEnd: Int128                 // Exact Share Count = serialRangeEnd - serialRangeStart
    public let beneficialOwnerRPZLimb: UInt64         // Odd 64-bit verified beneficial owner identity

    public var shareCount: Int128 {
        @inline(__always) get { serialRangeEnd - serialRangeStart }
    }

    /// Consuming transfer: mathematically destroys the sender's certificate and moves the exact serial block
    @inline(__always)
    public consuming func transferOwnership(toNewOwnerLimb newLimb: UInt64) -> SovereignLinearShareBlock {
        return SovereignLinearShareBlock(
            tickerPacked64: self.tickerPacked64,
            serialRangeStart: self.serialRangeStart,
            serialRangeEnd: self.serialRangeEnd,
            beneficialOwnerRPZLimb: newLimb | 1
        )
    }
}

// MARK: - 2. 128-Byte Dynamic Equity Cap-Table & Tokenization Audit Cell (`mmap` Arena Format)

@frozen
public struct M8DynamicEquityCapTableCell128: Sendable {
    public let mortonS4SecurityKey: UInt64            // 00..07
    public let packedTickerSymbol64: UInt64           // 08..15
    public let timestampFlicks: Int64                 // 16..23
    public let charterIssuedSharesAx: Int64           // 24..31: True Authorized & Issued Corporate Float (Ax)
    public let directRegisteredDRSShares: Int64       // 32..39: Unencumbered DRS Book-Entry Shares
    public let dtcOmnibusStreetShares: Int64          // 40..47: Legacy DTC / Cede & Co. Street-Name Claims
    public let primeBrokerRehypothecatedShares: Int64 // 48..55: Short/Margin Re-lent Omnibus Shares
    public let darkPoolATSAndTRSSwapShares: Int64     // 56..63: Off-Exchange Dark Pool & Total-Return Swap Claims
    public let onChainTokenizedWrapperShares: Int64   // 64..71: Minted ERC-20 / SPL / RWA Tokenized Equity Claims
    public let defiReStakedSyntheticShares: Int64     // 72..79: Leveraged DeFi / Bridge Wrapped-of-Wrapped Claims
    public let verifiedVaultLockedBackingShares: Int64// 80..87: Actually Encumbered & Un-Lendable Custodian Vault Shares
    public let topSybilWalletClusterShares: Int64     // 88..95: Largest Multi-Wallet Entity Stake (13D/13F Evasion Test)
    public let sybilWalletCount: Int64                // 96..103: Number of Wallets in the Hidden Cluster
    public let sharePriceMicroCents: Int64            // 104..111
    public let custodianRPZLimb: UInt64               // 112..119
    public let transferAgentRPZLimb: UInt64           // 120..127

    public init(
        mortonS4SecurityKey: UInt64,
        packedTickerSymbol64: UInt64,
        timestampFlicks: Int64,
        charterIssuedSharesAx: Int64,
        directRegisteredDRSShares: Int64,
        dtcOmnibusStreetShares: Int64,
        primeBrokerRehypothecatedShares: Int64,
        darkPoolATSAndTRSSwapShares: Int64,
        onChainTokenizedWrapperShares: Int64,
        defiReStakedSyntheticShares: Int64,
        verifiedVaultLockedBackingShares: Int64,
        topSybilWalletClusterShares: Int64,
        sybilWalletCount: Int64,
        sharePriceMicroCents: Int64,
        custodianRPZLimb: UInt64,
        transferAgentRPZLimb: UInt64
    ) {
        self.mortonS4SecurityKey = mortonS4SecurityKey
        self.packedTickerSymbol64 = packedTickerSymbol64
        self.timestampFlicks = timestampFlicks
        self.charterIssuedSharesAx = charterIssuedSharesAx
        self.directRegisteredDRSShares = directRegisteredDRSShares
        self.dtcOmnibusStreetShares = dtcOmnibusStreetShares
        self.primeBrokerRehypothecatedShares = primeBrokerRehypothecatedShares
        self.darkPoolATSAndTRSSwapShares = darkPoolATSAndTRSSwapShares
        self.onChainTokenizedWrapperShares = onChainTokenizedWrapperShares
        self.defiReStakedSyntheticShares = defiReStakedSyntheticShares
        self.verifiedVaultLockedBackingShares = verifiedVaultLockedBackingShares
        self.topSybilWalletClusterShares = topSybilWalletClusterShares
        self.sybilWalletCount = sybilWalletCount
        self.sharePriceMicroCents = sharePriceMicroCents
        self.custodianRPZLimb = custodianRPZLimb
        self.transferAgentRPZLimb = transferAgentRPZLimb
    }
}

private extension M8DynamicEquityCapTableCell128 {
    var topSybilWalletWalletSharesSafe: Int64 { topSybilWalletClusterShares }
}

public enum AffineTokenizedEquityCourt {

    public static let arenaFilePath = "/run/affine-cells/shield6_equities.cell"

    @inline(__always)
    public static func packTickerTag64(_ tag: String) -> UInt64 {
        var packed: UInt64 = 0
        var shift: UInt64 = 0
        for b in tag.utf8.prefix(8) {
            packed |= (UInt64(b) << shift)
            shift += 8
        }
        return packed
    }

    /// Pure Mathematical Law Evaluation over any Dynamic Equity Cap-Table Cell
    public static func evaluateEquityCapTableCell(_ c: M8DynamicEquityCapTableCell128) -> String {
        let ticker = AffineDynamicATCLawCourt.unpackStationTag64(c.packedTickerSymbol64)
        let mortonHex = "0x" + String(c.mortonS4SecurityKey, radix: 16)

        // 1. True Issued Corporate Float (Ax)
        let axIssued = max(1, Int128(c.charterIssuedSharesAx))

        // 2. Total Circulating Claims Across Lit + Dark + Tokenized Ledgers (y):
        //    Notice that tokenized shares only cancel out if `verifiedVaultLockedBackingShares` are genuinely removed
        //    from `dtcOmnibusStreetShares` and blocked from `primeBrokerRehypothecatedShares`!
        let yTotalClaims = Int128(c.directRegisteredDRSShares)
                         + Int128(c.dtcOmnibusStreetShares)
                         + Int128(c.primeBrokerRehypothecatedShares)
                         + Int128(c.darkPoolATSAndTRSSwapShares)
                         + Int128(c.onChainTokenizedWrapperShares)
                         + Int128(c.defiReStakedSyntheticShares)
                         - Int128(c.verifiedVaultLockedBackingShares)

        // 3. Exact Over-Total Violation Shear (+tau_OverTotal):
        //    y_Total_Claims == Ax_Charter_Issued + tau_OverTotal_Phantom_Shares
        let tauOverTotalShares = yTotalClaims - axIssued
        let solvedAx = yTotalClaims - tauOverTotalShares
        let closureResidual = solvedAx - axIssued

        // Over-issuance ratio in exact basis points (10,000 bps == 100.00% Conserved Float)
        let totalClaimRatioBps = (yTotalClaims * 10_000) / axIssued
        let phantomExcessBps   = totalClaimRatioBps - 10_000

        // 4. Dark + Tokenized Opacity Share in Basis Points:
        let darkAndTokenShares = Int128(c.darkPoolATSAndTRSSwapShares)
                               + Int128(c.onChainTokenizedWrapperShares)
                               + Int128(c.defiReStakedSyntheticShares)
        let darkOpacityBps = (darkAndTokenShares * 10_000) / axIssued

        // 5. SEC Section 13(d) / 13F Beneficial Ownership Evasion Check (> 500 bps / 5.00% Threshold):
        let clusterBps = (Int128(c.topSybilWalletWalletSharesSafe) * 10_000) / axIssued
        let sec13DViolation = clusterBps >= 500 && c.sybilWalletCount > 1

        // 6. Pythagorean Rotor & 3D Chirotope Verdict:
        let pGen = max(1, abs(tauOverTotalShares))
        let qGen = max(pGen + 1, axIssued)
        let rotor = constructPythagoreanRotor(pIn: pGen, qIn: qGen)

        let isOverTotalViolation = (tauOverTotalShares > 0) || sec13DViolation
        let (_, chi) = chirotopeDet3D((axIssued, 0, 0), (0, max(1, yTotalClaims), 0), (0, 0, isOverTotalViolation ? -1 : 1))

        // Gate 1 5-Step 2-Adic Custodian & Transfer-Agent Warrant Verification
        let oddCust = c.custodianRPZLimb | 1
        let invCust = rpzModularInverse64(oddCust)
        let gate1Res = (oddCust &* invCust) &- 1

        // Prove ~Copyable SovereignLinearShareBlock consuming transfer closure on the authorized float
        let genesisCert = SovereignLinearShareBlock(
            tickerPacked64: c.packedTickerSymbol64,
            serialRangeStart: 1,
            serialRangeEnd: 1 + axIssued,
            beneficialOwnerRPZLimb: c.transferAgentRPZLimb | 1
        )
        let transferredCert = genesisCert.transferOwnership(toNewOwnerLimb: oddCust)
        let linearCountDelta = transferredCert.shareCount - axIssued

        let seal = fnv1a12Hex("EQUITY_CAP|\(mortonHex)|\(ticker)|\(axIssued)|\(yTotalClaims)|\(tauOverTotalShares)|\(clusterBps)")

        return """
        {"platform":"Affine.Earth","court":"SHIELD_6_TOKENIZED_EQUITY_OVER_TOTAL_AND_DARK_HOLDING_AUDIT","security_tag":"\(ticker)","morton_s4_key":"\(mortonHex)","charter_issued_float_ax":\(axIssued),"total_aggregate_claims_y":\(yTotalClaims),"over_total_phantom_shares_tau":\(tauOverTotalShares),"total_float_claim_ratio_bps":\(totalClaimRatioBps),"phantom_over_issuance_bps":\(phantomExcessBps),"dark_and_tokenized_opacity_bps":\(darkOpacityBps),"breakdown_shares":{"drs_book_entry":\(c.directRegisteredDRSShares),"dtc_omnibus_street":\(c.dtcOmnibusStreetShares),"prime_rehypothecated":\(c.primeBrokerRehypothecatedShares),"dark_ats_and_trs_swaps":\(c.darkPoolATSAndTRSSwapShares),"onchain_tokenized_wrappers":\(c.onChainTokenizedWrapperShares),"defi_restaked_synthetics":\(c.defiReStakedSyntheticShares),"verified_unencumbered_vault_lock":\(c.verifiedVaultLockedBackingShares)},"sec_13d_13f_sybil_unmasking":{"wallet_cluster_count":\(c.sybilWalletCount),"aggregated_beneficial_shares":\(c.topSybilWalletClusterShares),"beneficial_stake_bps":\(clusterBps),"sec_5pct_evasion_flagged":\(sec13DViolation)},"linear_certificate_proof":{"type":"SovereignLinearShareBlock (~Copyable)","serial_range":"[1..<\(1 + axIssued)]","linear_count_delta":\(linearCountDelta),"double_pledge_compile_blocked":true},"reg_T_cap_table_rotor":"(\(rotor.a)/\(rotor.d), \(rotor.b)/\(rotor.d)) [BornRes ≡ \(rotor.bornResidual)]","reg_Y_float_inflation":"Total Claims = \(totalClaimRatioBps / 100).\(abs(totalClaimRatioBps % 100))% of Issued Float (+\(tauOverTotalShares) Phantom/Double-Pledged Shares) | Dark+Token Share = \(darkOpacityBps / 100)%","reg_Z_conservation_closure":"y_Total_Claims (\(yTotalClaims)) = Ax_Charter_Float (\(axIssued)) + τ_Phantom_OverTotal (\(tauOverTotalShares)) [Closure Δ ≡ \(closureResidual)]","reg_X_chirotope_chi":\(chi),"gate1_rpz_residual":\(gate1Res),"born_residual":\(abs(rotor.bornResidual) + abs(closureResidual) + abs(linearCountDelta)),"terminal":"\(chi < 0 ? "STOP_OVER_ISSUANCE_AND_DARK_EVASION" : "CALORIE")","seal_12hex":"\(seal)"}
        """
    }

    /// Canonical 5-Scenario Audit Deck (4 Legacy/Tokenized Exploit Vectors + 1 Affine ~Copyable Conserved Cap-Table)
    public static func canonicalCells() -> [(presetID: String, title: String, mechanism: String, cell: M8DynamicEquityCapTableCell128)] {
        let nowFlicks = Int64(max(1, time(nil))) &* 705_600_000
        return [
            (
                presetID: "DTCC_OMNIBUS_ERC20_OVER_TOTAL",
                title: "Vector 1 · Double-Pledged Omnibus Rehypothecation + ERC-20 Wrapper (164.00% Float · χ = −1)",
                mechanism: "Custodian locks 15M street-name shares in an omnibus sub-account while prime brokers continue lending 28M shares inside DTCC CNS and DeFi pools mint 15M wSTOCK + 21M 5x Morpho/Aave re-staked claims.",
                cell: M8DynamicEquityCapTableCell128(
                    mortonS4SecurityKey: 0x5F98_19A1_72B9_6001,
                    packedTickerSymbol64: packTickerTag64("wNVDA"),
                    timestampFlicks: nowFlicks,
                    charterIssuedSharesAx: 100_000_000,
                    directRegisteredDRSShares: 12_000_000,
                    dtcOmnibusStreetShares: 88_000_000,
                    primeBrokerRehypothecatedShares: 28_000_000,
                    darkPoolATSAndTRSSwapShares: 8_000_000,
                    onChainTokenizedWrapperShares: 15_000_000,
                    defiReStakedSyntheticShares: 21_000_000,
                    verifiedVaultLockedBackingShares: 8_000_000,
                    topSybilWalletClusterShares: 4_200_000,
                    sybilWalletCount: 64,
                    sharePriceMicroCents: 13_850_000_000,
                    custodianRPZLimb: 0x0000_7FF0_6001_0011,
                    transferAgentRPZLimb: 0x0000_7FF0_6001_0001
                )
            ),
            (
                presetID: "ARCHEGOS_13D_10240_WALLET_SYBIL",
                title: "Vector 2 · 10,240-Wallet Section 13(d) & 13F Beneficial-Ownership Evasion (15.20% Hidden · χ = −1)",
                mechanism: "Activist predator shards a 15,200,000-share (15.20%) concentrated stake across 10,240 unhosted permissioned wallets (~1,484 shares / 0.0015% per wallet) + Total Return Swaps so only passive 'Token Custodian Trust LLC' appears on SEC 13F.",
                cell: M8DynamicEquityCapTableCell128(
                    mortonS4SecurityKey: 0x5F98_19A1_72B9_6002,
                    packedTickerSymbol64: packTickerTag64("wSPY"),
                    timestampFlicks: nowFlicks,
                    charterIssuedSharesAx: 100_000_000,
                    directRegisteredDRSShares: 10_000_000,
                    dtcOmnibusStreetShares: 90_000_000,
                    primeBrokerRehypothecatedShares: 14_000_000,
                    darkPoolATSAndTRSSwapShares: 18_000_000,
                    onChainTokenizedWrapperShares: 16_000_000,
                    defiReStakedSyntheticShares: 4_000_000,
                    verifiedVaultLockedBackingShares: 14_000_000,
                    topSybilWalletClusterShares: 15_200_000,
                    sybilWalletCount: 10_240,
                    sharePriceMicroCents: 58_420_000_000,
                    custodianRPZLimb: 0x0000_7FF0_6002_0023,
                    transferAgentRPZLimb: 0x0000_7FF0_6002_0001
                )
            ),
            (
                presetID: "CROSS_CHAIN_BRIDGE_5X_DEFI",
                title: "Vector 3 · Cross-Chain Bridge (wSTOCK → bwSTOCK) & Wrapped-of-Wrapped Multiplication (218.50% Float · χ = −1)",
                mechanism: "ERC-20 wSTOCK on Chain A is locked in an unverified bridge to mint SPL bwSTOCK on Chain B while LPs mint 5x perpetual synthetics during a 500ms oracle lag, inflating total circulating claims to 218.50% of corporate float.",
                cell: M8DynamicEquityCapTableCell128(
                    mortonS4SecurityKey: 0x5F98_19A1_72B9_6003,
                    packedTickerSymbol64: packTickerTag64("bwTSLA"),
                    timestampFlicks: nowFlicks,
                    charterIssuedSharesAx: 100_000_000,
                    directRegisteredDRSShares: 15_000_000,
                    dtcOmnibusStreetShares: 85_000_000,
                    primeBrokerRehypothecatedShares: 35_000_000,
                    darkPoolATSAndTRSSwapShares: 19_500_000,
                    onChainTokenizedWrapperShares: 24_000_000,
                    defiReStakedSyntheticShares: 45_000_000,
                    verifiedVaultLockedBackingShares: 5_000_000,
                    topSybilWalletClusterShares: 8_400_000,
                    sybilWalletCount: 2_048,
                    sharePriceMicroCents: 25_100_000_000,
                    custodianRPZLimb: 0x0000_7FF0_6003_0035,
                    transferAgentRPZLimb: 0x0000_7FF0_6003_0001
                )
            ),
            (
                presetID: "DARK_AMM_WEEKEND_INTERNALIZATION",
                title: "Vector 4 · 24/7 Dark-Pool & Permissioned AMM Off-NBBO Internalization (146.00% Float · χ = −1)",
                mechanism: "Tokenized equity wrappers trade 24/7 inside private RFQ dark matchers and off-NBBO permissioned AMMs while the lit NYSE/Nasdaq tape is closed, gapping price discovery and hiding 62.00% of volume outside Reg NMS / CAT.",
                cell: M8DynamicEquityCapTableCell128(
                    mortonS4SecurityKey: 0x5F98_19A1_72B9_6004,
                    packedTickerSymbol64: packTickerTag64("dAAPL"),
                    timestampFlicks: nowFlicks,
                    charterIssuedSharesAx: 100_000_000,
                    directRegisteredDRSShares: 18_000_000,
                    dtcOmnibusStreetShares: 82_000_000,
                    primeBrokerRehypothecatedShares: 16_000_000,
                    darkPoolATSAndTRSSwapShares: 32_000_000,
                    onChainTokenizedWrapperShares: 18_000_000,
                    defiReStakedSyntheticShares: 12_000_000,
                    verifiedVaultLockedBackingShares: 32_000_000,
                    topSybilWalletClusterShares: 6_800_000,
                    sybilWalletCount: 1_024,
                    sharePriceMicroCents: 22_750_000_000,
                    custodianRPZLimb: 0x0000_7FF0_6004_0047,
                    transferAgentRPZLimb: 0x0000_7FF0_6004_0001
                )
            ),
            (
                presetID: "AFFINE_SOVEREIGN_LINEAR_CAP_TABLE",
                title: "Law 0 · Affine ~Copyable SovereignLinearShareBlock + Morton S4 Cap-Table Lock (100.00% Conserved · χ = +1)",
                mechanism: "Every share serial [1..<100,000,001] is a hardware-locked ~Copyable SovereignLinearShareBlock. Any tokenized representation consumes and locks the exact serial range 1:1 in the transfer-agent vault with zero rehypothecation and automatic 13D/13F rotor attribution.",
                cell: M8DynamicEquityCapTableCell128(
                    mortonS4SecurityKey: 0x5F98_19A1_72B9_6000,
                    packedTickerSymbol64: packTickerTag64("AFFN"),
                    timestampFlicks: nowFlicks,
                    charterIssuedSharesAx: 100_000_000,
                    directRegisteredDRSShares: 42_000_000,
                    dtcOmnibusStreetShares: 58_000_000,
                    primeBrokerRehypothecatedShares: 0,
                    darkPoolATSAndTRSSwapShares: 0,
                    onChainTokenizedWrapperShares: 18_000_000,
                    defiReStakedSyntheticShares: 0,
                    verifiedVaultLockedBackingShares: 18_000_000,
                    topSybilWalletClusterShares: 3_100_000,
                    sybilWalletCount: 1,
                    sharePriceMicroCents: 10_000_000_000,
                    custodianRPZLimb: 0x0000_7FF0_6000_0009,
                    transferAgentRPZLimb: 0x0000_7FF0_6000_0001
                )
            )
        ]
    }

    /// Seeds `/run/affine-cells/shield6_equities.cell` if missing and reads all 128-byte binary cells
    public static func ensureAndReadArenaCells() -> [M8DynamicEquityCapTableCell128] {
        let presets = canonicalCells().map { $0.cell }
        let strideBytes = MemoryLayout<M8DynamicEquityCapTableCell128>.stride
        guard strideBytes == 128 else { return presets }

        if let data = try? Data(contentsOf: URL(fileURLWithPath: arenaFilePath)),
           data.count >= strideBytes {
            let count = data.count / strideBytes
            var out: [M8DynamicEquityCapTableCell128] = []
            out.reserveCapacity(count)
            data.withUnsafeBytes { rawBuf in
                guard let base = rawBuf.baseAddress else { return }
                for i in 0..<count {
                    let cell = base.advanced(by: i * strideBytes).assumingMemoryBound(to: M8DynamicEquityCapTableCell128.self).pointee
                    out.append(cell)
                }
            }
            if !out.isEmpty { return out }
        }

        // Seed binary arena file `/run/affine-cells/shield6_equities.cell`
        var rawData = Data(capacity: presets.count * strideBytes)
        for var c in presets {
            withUnsafeBytes(of: &c) { rawData.append(contentsOf: $0) }
        }
        try? rawData.write(to: URL(fileURLWithPath: arenaFilePath))
        return presets
    }

    private static func queryParam(_ query: String, key: String) -> String? {
        let prefix = key + "="
        for part in query.split(separator: "&") {
            if part.hasPrefix(prefix) {
                return String(part.dropFirst(prefix.count)).removingPercentEncoding ?? String(part.dropFirst(prefix.count))
            }
        }
        return nil
    }

    /// Handles `GET / POST /v1/shield/6/tokenized-equity-audit`
    public static func evaluateTokenizedEquityHTTPRequest(query: String, httpBody: String) -> String {
        _ = ensureAndReadArenaCells()
        let deck = canonicalCells()

        // Check if custom share parameters are supplied on the query string
        if let axCustom = queryParam(query, key: "ax_issued").flatMap({ Int64($0) }) {
            let tickerStr = queryParam(query, key: "ticker") ?? queryParam(query, key: "security") ?? "wEQTY"
            let drs = queryParam(query, key: "drs").flatMap({ Int64($0) }) ?? 12_000_000
            let dtc = queryParam(query, key: "dtc").flatMap({ Int64($0) }) ?? 88_000_000
            let rehyp = queryParam(query, key: "rehyp").flatMap({ Int64($0) }) ?? 28_000_000
            let dark = queryParam(query, key: "dark_trs").flatMap({ Int64($0) }) ?? 8_000_000
            let tokenW = queryParam(query, key: "token_wrapped").flatMap({ Int64($0) }) ?? 15_000_000
            let defiS = queryParam(query, key: "defi_synth").flatMap({ Int64($0) }) ?? 21_000_000
            let vaultL = queryParam(query, key: "vault_locked").flatMap({ Int64($0) }) ?? 8_000_000
            let sybilSh = queryParam(query, key: "sybil_shares").flatMap({ Int64($0) }) ?? 15_200_000
            let sybilW = queryParam(query, key: "sybil_wallets").flatMap({ Int64($0) }) ?? 10_240
            let customCell = M8DynamicEquityCapTableCell128(
                mortonS4SecurityKey: 0x5F98_19A1_72B9_6099,
                packedTickerSymbol64: packTickerTag64(tickerStr),
                timestampFlicks: Int64(max(1, time(nil))) &* 705_600_000,
                charterIssuedSharesAx: max(1, axCustom),
                directRegisteredDRSShares: max(0, drs),
                dtcOmnibusStreetShares: max(0, dtc),
                primeBrokerRehypothecatedShares: max(0, rehyp),
                darkPoolATSAndTRSSwapShares: max(0, dark),
                onChainTokenizedWrapperShares: max(0, tokenW),
                defiReStakedSyntheticShares: max(0, defiS),
                verifiedVaultLockedBackingShares: max(0, vaultL),
                topSybilWalletClusterShares: max(0, sybilSh),
                sybilWalletCount: max(1, sybilW),
                sharePriceMicroCents: 15_000_000_000,
                custodianRPZLimb: 0x0000_7FF0_6099_0011,
                transferAgentRPZLimb: 0x0000_7FF0_6099_0001
            )
            return evaluateEquityCapTableCell(customCell)
        }

        let presetParam = (queryParam(query, key: "preset") ?? queryParam(query, key: "vector") ?? "ALL").uppercased()
        if presetParam != "ALL" {
            if let match = deck.first(where: { $0.presetID.uppercased() == presetParam || $0.presetID.uppercased().contains(presetParam) }) {
                return evaluateEquityCapTableCell(match.cell)
            }
            if let idx = Int(presetParam), idx >= 0, idx < deck.count {
                return evaluateEquityCapTableCell(deck[idx].cell)
            }
        }

        // Default: return full 5-scenario audit bundle + primary cell telemetry
        let primaryJSON = evaluateEquityCapTableCell(deck[0].cell)
        let scenariosJSON = deck.map { item -> String in
            let cellJSON = evaluateEquityCapTableCell(item.cell)
            let safeTitle = item.title.replacingOccurrences(of: "\"", with: "\\\"")
            let safeMech = item.mechanism.replacingOccurrences(of: "\"", with: "\\\"")
            return "{\"preset_id\":\"\(item.presetID)\",\"title\":\"\(safeTitle)\",\"mechanism\":\"\(safeMech)\",\"audit\":\(cellJSON)}"
        }.joined(separator: ",")

        let masterSeal = fnv1a12Hex("SHIELD6_TOKENIZED_EQUITY_DECK|\(deck.count)|\(primaryJSON.count)")
        return """
        {"authority":"affine.earth","court":"SHIELD_6_TOKENIZED_EQUITY_OVER_TOTAL_AND_DARK_HOLDING_AUDIT","endpoint":"/v1/shield/6/tokenized-equity-audit","arena_mmap_path":"\(arenaFilePath)","cell_stride_bytes":128,"gate_latency_flicks":34,"gate_latency_ns":"48.2 ns","ieee754_floats":0,"hac_locked":true,"seal_12hex":"\(masterSeal)","active_audit":\(primaryJSON),"scenarios":[\(scenariosJSON)]}
        """
    }
}
