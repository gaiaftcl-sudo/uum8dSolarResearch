---
title: Shor Witness Certifier — what the cell actually sealed
audience: cryptographers_engineers_press
contract_version: 1.0.0
authority_kind: normative
release: v120
---

# Shor Witness Certifier — what the cell actually sealed

> **This page corrects a category error.** An earlier draft of this artifact was titled "Shor at Scale" and implied the cell had factored semiprimes up to 8 × 10¹². It had not. The cell factored 35 semiprimes from N = 15 to N = 65,021 by classical brute period-finding; for the larger 13 entries, the *witness was constructed from already-known factors* via the Chinese Remainder Theorem. The verification arithmetic is correct at every row; the framing that called all 48 "factorizations" was wrong. This page states what the seal earns.

## The honest two-tier seal

### Tier 1 — actual factorizations (35 rows, N = 15 → 65,021)

For each row in Tier 1, the cell **discovered the multiplicative order `r` of `a` mod `N`** by classical brute iteration:

```
v := a mod N
while v ≠ 1 and r < N:
    v := (v · a) mod N
    r := r + 1
halfPow := v at r/2 step
```

**No knowledge of `p` or `q` is used.** Once `halfPow` is in hand with `halfPow² ≡ 1 (mod N)` and `halfPow ≠ 1, N − 1`, Shor's classical reduction `gcd(halfPow − 1, N)` extracts a non-trivial factor of `N`. These rows ARE factorizations performed by the cell — classical, not quantum, but the period-finding (the hard step of Shor's reduction) was done.

The ceiling is N ≈ 65,000 because brute search is O(period), and orders for larger N grow past the cell's millisecond budget.

| N | factors | provenance |
|---:|---|---|
| 15 | 3 × 5 | Tier 1 — period found |
| 21 | 7 × 3 | Tier 1 — period found |
| 143 | 11 × 13 | Tier 1 — period found |
| 1,517 | 37 × 41 | Tier 1 — period found |
| 10,403 | 101 × 103 | Tier 1 — period found |
| **65,021** | **253 × 257** | **Tier 1 — period found (largest)** |

35 rows total in Tier 1.

### Tier 2 / Tier 3 — period-PROVIDED witness verifications (13 rows, N up to 8 × 10¹²)

For each row in Tier 2/3, the cell did **NOT** find the period. Instead, the witness `halfPow` was constructed from the already-known prime factorization `(p, q)` using the Chinese Remainder Theorem:

```
halfPow ≡ 1     (mod p)
halfPow ≡ N − 1 (mod q)
```

This construction **assumes what factoring is supposed to discover**. The Lean kernel + Swift recompute then verify that the constructed `halfPow` satisfies the four algebraic relations Shor's reduction operates on. **This certifies the verification arithmetic at scale — it does NOT factor anything.**

| N | factors | provenance |
|---:|---|---|
| 999,919 | 991 × 1,009 | Tier 2 — period PROVIDED (CRT) |
| 9,999,399,973 | 99,991 × 100,003 | Tier 2 — period PROVIDED (CRT) |
| 2,000,009,000,009 | 1,000,003 × 2,000,003 | Tier 3 — period PROVIDED (CRT) |
| **8,000,321,000,351** | **1,000,039 × 8,000,009** | **Tier 3 — period PROVIDED (CRT)** |

13 rows total in Tier 2/3.

## What this is and is NOT

### What this IS

- A real verification capability: the cell certifies any Shor witness `(N, halfPow, p, q)` bit-exactly in milliseconds, at semiprime sizes up to 43 bits, with two independent gates (Lean + Swift) that must agree.
- 35 actual factorizations at small scale (N ≤ 65,021), each performed end-to-end by the cell using classical period-finding without factor knowledge.
- A certifier ready to grade any future Shor output — from quantum hardware, hybrid algorithm, or a future classical breakthrough — at scales the verifier handles.

### What this is NOT

- **NOT a claim that the cell factored 43-bit semiprimes.** The Tier 2/3 witnesses were constructed from already-known factors. The cell verifies them; it did not discover them.
- **NOT a quantum-computing capability claim.** No quantum hardware is involved at any step.
- **NOT a claim against RSA or about cryptographic security at scale.** Classical factoring records (RSA-250 = 829-bit, classical GNFS 2020) are far past anything here. The cell's seal is about *verification*, not factoring records.

## What it does NOT close

**`summit.shor.order_finding_at_scale`** sits on the Rosetta open frontier with the licensing certificate written down. That summit's open obligation: *find the multiplicative order `r` of `a` mod `N` at scale where classical brute search is infeasible AND the cell does not have access to `(p, q)`.* That is the actual hard step of Shor's algorithm. Quantum hardware addresses it via Shor's quantum subroutine in polynomial time; the cell does not run quantum hardware.

**The cell does not claim to have closed this summit.** It ships the certifier in advance so that *when* someone closes it — at whatever scale, by whatever means — the verifier is ready.

## How to verify

```bash
git clone https://github.com/gaiaftcl-sudo/gaiaFTCL.git && cd gaiaFTCL

# 1. Lean kernel seals both tiers
cd proof/lean && lake build FirstRoars.ShorWitnessCertifier
# → ✔ Built FirstRoars.ShorWitnessCertifier (native_decide closes the seal)

# 2. Swift S4 recompute matches bit-for-bit
cd ../../cells/xcode
swift run M8ShorCertifierSmokeTest
# → Tier 1 PASS: 35 / 35  Wall: ~0.6 ms
# → Tier 2/3 PASS: 13 / 13  Wall: ~0.2 ms
# → ✓ SHOR-WITNESS-CERTIFIER SEALED — both tiers verified
```

## Lattice position

- **Sealed node**: `qc.qc-001.witness_certifier` — `finiteUniversalCertificate` over the 48-row table
- **Base camp**: `qc.qc-001.n15.factored` (the 2001 textbook factorization)
- **Licenses three things downstream**:
  - `qc.qc-001.tier1.factored:35-rows` — the 35 actual factorizations
  - `qc.qc-001.tier23.witness_verified:13-rows` — the 13 period-provided verifications
  - `summit.shor.order_finding_at_scale:certifier-ready` — the certifier stands ready for that summit's closure

## Why this correction matters

The cell's whole architecture exists to expose category errors of this exact shape — claiming a hard step that was assumed rather than performed. The earlier "Shor at Scale" framing made the error the architecture refuses in others. A regulator or hostile cryptographer reading the original page would have caught the gap in 90 seconds. **The honest seal is still valuable: the cell ships the only verified-end-to-end Shor witness certifier that handles 43-bit semiprimes with dual-gate certification.** Stating that precisely is what makes it unassailable. Stating it as "Shor factoring at 533 billion× textbook" would have collapsed the brand on contact with the first careful reader.

This page exists so the seal's meaning equals what the kernel proved — no more, no less.

## NATS subject

`gaiaftcl.shor.witness.certifier.sealed` — emitted on every successful smoke-test run.

---

## What exists in this repo (2026-08-27)

| Layer | Path | Status |
|---|---|---|
| Lean witness certifier | `proof/lean/FirstRoars/ShorWitnessCertifier.lean` | In tree |
| Lean textbook / large factor | `ShorFactor15.lean`, `ShorFactorLarge.lean` | In tree |
| Lean ECDLP | `ShorECDLP.lean` · couplings `QFTToShorCoupling.lean`, `QPEToShorCoupling.lean` | In tree |
| ECDLP substrate | `cells/xcode/Sources/ShorECDLPSubstrate/` (`ShorECDLPSubstrate.swift`, curve, group-law MPO probe, target descriptor) | Live 3D path: `Secp256k1ECDLPVerificationDispatcher` |
| Typed QC-001 shell | `AlgorithmCatalog.swift` `QC001Shor` / `QC001ECDLPShor` | Throws `vmNotConnected` until a VM is moored |
| Inventory | [Quantum algorithms inventory](Quantum-Algorithms-Inventory.md) | Maps Glama vs Lean vs stripped |

## What was stripped (cite the commits)

| Commit | Date | Deleted |
|---|---|---|
| `6f39e8b8950256e090d68a31657e086989663874` | 2026-07-09 | Reversible-circuit cluster: `ReversibleECDLPOracle*.swift`, `ReversibleFieldP`, `ReversiblePointAdd`, `ReversibleScalarMul`, `ShorECDLPProjection.swift`, `SymbolicShorECDLP.swift` |
| `9192c03626f91b12bff8166644f102431c8b6ef3` | 2026-07-09 | `ShorECDLPTemplate.swift`, `ShorECDLPReversibleOracleTemplate.swift`, `StaticTensorBuilder.swift` |
| `add9d197a70bb2b52ba6d98cf6f11e559e1b9341` | 2026-07-08 | Boot bind `GlobalContraction.dispatcher = ShorECDLPCPUContractor()` |
| `d1a00b7b` / `068a548a` | 2026-07 | `GaiaCellMCPServer/main.swift` (`run_quantum_algorithm`, `distribute-shor` were that surface) |

`ShorBoundaryMaskFactory.swift` remains as a mooring provider. Comments in `GaiaFTCLCLIEntry.swift` record Strip 6: the live answer to \(kG=Q\) is the audited secp256k1 dispatcher, not the retired MPS contractor.

## Glama / public MCP

**Shor IS a public court tool — as a presented-witness verifier, never a period search.** This paragraph read "Shor is not a public court tool; `tools/list` has 23 names" until 2026-09-02, which was true on 2026-08-27 and is stale: live `tools/list` is **49**, measured per cell on all nine A records, and it carries `verify_shor_witness` (QC-001: N, halfPow, factor, cofactor — 15 = 3×5 answers WIN/CALORIE), `verify_period` (a^r ≡ 1 mod N), `project_shor_twin` (post halfPow, receive the factors by gcd; post the factors, receive a by CRT — a bijection, not a search), plus `verify_grover`, `verify_qft_phases`, `verify_vqe_energy` and `verify_qaoa_energy`. None of them finds a period, a marked item or a variational minimum; each certifies what the caller presents. There is still no `shor`, `prove_shor` or `period_find` tool, and the Lean certifier below remains the textbook. See [Math Court on Glama](Affine-Math-Court-Glama.md) and the [MCP user guide](Affine-Earth-MCP-User-Guide.md).

## Leftover Python wrapper

`cells/python/gaiaftcl/src/gaiaftcl/shor.py` and `cells/python/gaiaftcl/src/gaiaftcl/cli.py` still invoke `gaiaftcl prove shor`. The Swift `prove` dispatcher (`GaiaFTCLCLIEntry.swift` case `"prove"`) lists `language-games`, `poly-n`, `substrate-oo`, `conjecture-workload`, `qc020-verifier` — **not `shor`**. Treat the Python verb as leftover, not a live compute path.

## Honest bound

This page already forbids calling Tier 2/3 “factorizations.” It also forbids calling the certifier a quantum-hardware result. Period-finding at scale remains the open summit named above. The public court verifies presented QMA fixtures; it does not run Shor.
