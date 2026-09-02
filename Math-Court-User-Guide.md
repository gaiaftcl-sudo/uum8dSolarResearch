# User guide — bind the Affine.Earth Math Court

**Validated 2026-09-02** on the live 9-cell apex, per cell with SNI pinned to each of the nine A records (HTTP 200 on all nine; `tools/list` **49**, one name set).  
MCP: `https://affine.earth/language-invariant/mcp` · Registry: `earth.affine/math-court`  
Glama: [Affine Earth Math Court Remote](https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote)  
Live proof: `bash clients/math-court-mcp/prove-live-court.sh` · raw `tools/list`: `clients/math-court-mcp/evidence/tools-list-20260827T194820Z.raw`

The court lives on affine.earth. This git is the bind. You POST decimal strings. You do not evaluate a lattice.

Full walk with source: [Example app user guide](Math-Court-Example-App.md) · marketing: [Math Court on Glama](Affine-Math-Court-Glama.md) · [algorithm inventory](Quantum-Algorithms-Inventory.md)

---

## 1. Bind in Cursor, Claude, or VS Code

Copy [`clients/math-court-mcp/configs/cursor.mcp.json`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/clients/math-court-mcp/configs/cursor.mcp.json):

```json
{
  "mcpServers": {
    "affine-earth-math-court": {
      "url": "https://affine.earth/language-invariant/mcp"
    }
  }
}
```

VS Code: [`configs/vscode.mcp.json`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/blob/main/clients/math-court-mcp/configs/vscode.mcp.json).  
STDIO-only hosts: `python3 clients/math-court-mcp/stdio/affine_earth_mcp_stdio.py`.

After bind, `tools/list` must show `math_court`, `lattice_op`, `verify_jordan_bond`, and the four QMA names. It must **not** show `mine`, `isolate`, `sha256d`, or `submitblock`.

Live `tools/list` 2026-09-02: **49** tools (HTTP 200), measured per-cell against all nine A records rather than through the apex round-robin — that round-robin has masked a 1/9 straggler before. Must include `corpus_coverage`, `corpus_capability_map`, `code_ir_equiv` and `execute_artifact_crucible`. Must **not** include `run_quantum_algorithm` or miner verbs. The QC-001…021 named verifiers (`verify_shor_witness`, `verify_grover`, …), the two projection tools and `expose` are all **live** — every row in §4b below was replayed against the served surface on 2026-09-02. The 49 is the measured live count, not a forecast; it read 48 on 2026-08-29 and 23 on 2026-08-27. Call table: [Conjecture Alignment](Conjecture-Alignment-UUM8D.md). An earlier walk printed 21 — stale.

## 2. The wire rule

Every number is a **decimal string**. `12` is legal. `1/2` is legal. `0.5` is refused.

If your agent serializes a JSON number, the court refuses you. That is the trap for VQE / anneal / SDP notebooks.

## 3. Call the whole court

`math_court` with an empty body returns the catalog. A domain ingest needs `source`, `role`, and the domain keys as strings.

```bash
curl -sS https://affine.earth/language-invariant/mcp \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"math_court","arguments":{"domain":"qma_permanent","role":"researcher","source":"wiki:guide","matrix":"1,1,1|1,1,1|1,1,1"}}}'
```

That lock is permanent **6**.

## 4. The four QMA tools by name

| Tool | Strings to send | Locked 2026-08-27 live |
|---|---|---|
| `execute_2local_hamiltonian` | `constraints=0,1,1,1` `config=0,1` | energy **−1/1** |
| `route_spin_glass_manifold` | `edges=0,1,1;1,2,1;2,0,1` `spins=1,-1,1` | energy **−1** |
| `verify_n_representability` | `rho2=1/2,0/1\|0/1,1/2` `n=2` | **WIN** |
| `execute_exact_permanent` | `matrix=1,1,1\|1,1,1\|1,1,1` | **6** |

Studies: [22](Study-22-QMA-2-Local-Hamiltonian.md) · [23](Study-23-QMA-Spin-Glass.md) · [24](Study-24-QMA-N-Representability.md) · [25](Study-25-Exact-Permanent.md)

Presented configurations are verified. Unknown grounds are not searched.

## 4b. QC-001…021 verifiers and the two projection tools (LIVE, replayed 2026-09-02)

Same wire rule. Same honesty: a presented witness, not a search.

| Tool | Strings to send | Live lock, 2026-09-02 |
|---|---|---|
| `verify_shor_witness` | `N=15` `halfPow=4` `factor=3` `cofactor=5` | factor **3** |
| `project_shor_twin` | `N=3233` `halfPow=794` *(factors withheld)* | factors **61*53** |
| `project_shor_twin` | `N=3233` `factor=61` `cofactor=53` *(a withheld)* | **a=794** |
| `project_affine_key` | `A=1` *(Q withheld)* | **Q = 0479be667e…** the generator |
| `project_affine_key` | `q_hex=0479be667e…` *(A withheld)* | verdict **CHI_EXHAUSTED**, `energy_num` = n (~1.16e77, the bond dimension this instance requires) over `energy_den` = 4096 (the ceiling); `ground` = x(Q), which is public. A cost report, not a graded pair: the detail names the probe as the limit. The wire `status` reads MISS today |
| `verify_period` | `a=7` `N=15` `r=4` `proper_divisors=1,2` | period **4** |
| `verify_grover` | `oracle=0001` `marked=3` | marked **3** |
| `verify_qft_phases` | `n=4` `k=1` `phases=0/4,1/4,2/4,3/4` | WIN |
| `verify_qpe_phase` | `m=2` `k=1` `phase=1/4` | WIN |
| `verify_vqe_energy` | same as 2-local | **−1/1** |
| `verify_qaoa_energy` | same as spin-glass | **−1** |

Full table including HHL, DJ, BV, Simon, amp, walk, teleport, topo, presented pair: [Conjecture Alignment](Conjecture-Alignment-UUM8D.md). `math_court` domains `qc_shor` … `qc_topo` / `qc_pair` are the same law.

## 5. Jordan bond

```bash
curl -sS https://affine.earth/language-invariant/mcp \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"verify_jordan_bond","arguments":{"A":"1,1,1,1,1,1,1,1|1","B":"1,1,1,1,1,1,1,1|1","K":"3,-2,5,1,7,1,4,2|1"}}}'
```

Locked: `AFFINE_JZ_SHEAR_ZERO`.

## 6. What LIVE and LEARN mean

The example app prints **LIVE** when the cell accepted the string and returned a court status that is not `REFUSED_*`. **LEARN** means the payload or the transport missed. Eclipse and EHT can return `MISS` and still be LIVE — the appointment was graded; it was not met.

## 6b. The Coding Court is on the same endpoint

Two tools, same wire rule, same refusal contract:

| Tool | Send | Live lock, 2026-09-02 |
|---|---|---|
| `code_ir_equiv` | `left_file` + `right_file`, each `{path, content}` — whole files | reordered constants → `CALORIE_CODE_IR_EQUIV`; one moved constant → `CODE_IR_DIVERGED` naming it; no constants → `NOT_KNOWN` |
| `execute_artifact_crucible` | `brief` (the twelve-field ARTIFACT INGESTION BRIEF, verbatim template) + `artifact` (source text, or a base64 wasm module) | assembler source → `ARTIFACT_ASSEMBLED_NOT_DELIVERED` (no toolchain on a cell, by design); a `cbz` under a no-branch brief → `ARTIFACT_LAW_BROKEN`; a `Double` in Swift → `ARTIFACT_LAW_BROKEN` (Constraint 3); a well-formed 4,946-byte module → rung 7 **WIN**, returned as `content[].resource.blob` with `artifact_kind wasm.module` and a sha256 that re-digests to the posted bytes |

Full guide, including the template the court recognises: [Affine Coding Court](Affine-Coding-Court-Architecture.md) · [MCP user guide](Affine-Earth-MCP-User-Guide.md).

## 7. Wrappers that already exist

Live proof (lists tools, invokes Studies 11–13 + 22–25 fixtures, fails on drift):

```bash
bash clients/math-court-mcp/prove-live-court.sh
```

Python / JS / LangChain / LlamaIndex / CrewAI / AutoGen / OpenAI tools stay in [`clients/math-court-mcp/`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/tree/main/clients/math-court-mcp). They POST. They do not evaluate a lattice. If a wrapper grows a second law, delete it.
