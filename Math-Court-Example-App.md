# User guide — run the Math Court example app

**Validated 2026-08-26:** `GLAMA 29 LIVE · 0 LEARN of 29`  
**Re-measured tools/list 2026-09-02:** **49** names on every one of the nine cells (SNI pinned), `clients/math-court-mcp/evidence/tools-list-20260902.json`. The 2026-08-27 record (23 names) stands as `evidence/tools-list-20260827T194820Z.raw`.  
Researcher proof: `bash clients/math-court-mcp/prove-live-court.sh`  
Source: [`clients/math-court-mcp/swift-example/`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/tree/main/clients/math-court-mcp/swift-example)

This is the public example of how to use Glama / affine.earth and the **entire** Math Court. The process computes **no verdict**. It posts decimal strings to the nine cells and prints LIVE or LEARN.

Bind-only guide (Cursor / curl): [Math Court user guide](Math-Court-User-Guide.md)  
Why it matters: [Math Court on Glama](Affine-Math-Court-Glama.md)

---

## What you need

- macOS 27 / Swift 6.4 (the sanctioned client language)
- Network to `https://affine.earth/language-invariant/mcp`
- This repository cloned

You do not need a Glama account to run the walk. You need one if you want the connector row inside Glama’s directory.

## Run

```bash
swift run --scratch-path /tmp/affine-math-court-mcp \
  --package-path clients/math-court-mcp/swift-example \
  affine-math-court
```

The walk, in order:

1. `tools/list` — **49** tools (measured live 2026-09-02 per cell on all nine A records; 48 on 2026-08-29, 23 on 2026-08-27), `math_court` present, miner verbs absent. The walk pins the count EXACTLY at 49 — a fleet that regresses to an earlier set must fail, not pass
2. `math_court` catalog — 24 domains
3. one ingest per court domain (geometry through dynamo, then the four QMA domains)
4. the four QMA tools by name
5. `verify_jordan_bond` on the uniform lock

Exit 0 means every row was LIVE. Exit 2 means at least one LEARN.

## What locked on 2026-08-26

```
LIVE   tools/list  n=23 leaked=[]
LIVE   math_court catalog  domains=24
LIVE   court:geometry … court:dynamo
LIVE   court:qma_2local     WIN
LIVE   court:qma_spinglass  WIN
LIVE   court:qma_nrep       WIN
LIVE   court:qma_permanent  WIN
LIVE   qma:execute_2local_hamiltonian     WIN E=-1
LIVE   qma:route_spin_glass_manifold      WIN E=-1
LIVE   qma:verify_n_representability      WIN E=1
LIVE   qma:execute_exact_permanent        WIN E=6
LIVE   verify_jordan_bond  AFFINE_JZ_SHEAR_ZERO
GLAMA 29 LIVE · 0 LEARN of 29
```

The 2026-08-26 walk printed `n=21` before `corpus_coverage` and `corpus_capability_map` were counted. Canonical `tools/list` is **23**.

Eclipse and EHT returned `MISS` and still counted LIVE — the court graded the appointment; the sky numbers in the fixture were not a hit.

## What this proved

| Claim | Lock |
|---|---|
| The court is public | Any laptop can POST the same JSON-RPC the Glama connector uses |
| The court is the whole court | One binary walks every domain, not four toy endpoints |
| Floats cannot enter | The client never sends a JSON number |
| QMA fixtures are exact | −1/1, −1, WIN, 6 |
| The bond is the win | `AFFINE_JZ_SHEAR_ZERO` · miner verbs off `tools/list` |

Presented configurations are verified. Unknown grounds are not searched.

## Read the source

[`Sources/main.swift`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/clients/math-court-mcp/swift-example/Sources/main.swift) is the whole example. Copy that file if you are writing a visitor in another sanctioned shell. Do not copy the law. The law is on the cell.
