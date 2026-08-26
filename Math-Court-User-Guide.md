# User guide — bind the Affine.Earth Math Court

**Validated 2026-08-26** on the live 9-cell apex.  
MCP: `https://affine.earth/language-invariant/mcp` · Registry: `earth.affine/math-court`  
Glama: [Affine Earth Math Court Remote](https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote)

The court lives on affine.earth. This git is the bind. You POST decimal strings. You do not evaluate a lattice.

Full walk with source: [Example app user guide](Math-Court-Example-App.md) · marketing: [Math Court on Glama](Affine-Math-Court-Glama.md)

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

Measured 2026-08-26: **21** tools.

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

| Tool | Strings to send | Locked 2026-08-26 |
|---|---|---|
| `execute_2local_hamiltonian` | `constraints=0,1,1,1` `config=0,1` | energy **−1/1** |
| `route_spin_glass_manifold` | `edges=0,1,1;1,2,1;2,0,1` `spins=1,-1,1` | energy **−1** |
| `verify_n_representability` | `rho2=1/2,0/1\|0/1,1/2` `n=2` | **WIN** |
| `execute_exact_permanent` | `matrix=1,1,1\|1,1,1\|1,1,1` | **6** |

Studies: [22](Study-22-QMA-2-Local-Hamiltonian.md) · [23](Study-23-QMA-Spin-Glass.md) · [24](Study-24-QMA-N-Representability.md) · [25](Study-25-Exact-Permanent.md)

Presented configurations are verified. Unknown grounds are not searched.

## 5. Jordan bond

```bash
curl -sS https://affine.earth/language-invariant/mcp \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"verify_jordan_bond","arguments":{"A":"1,1,1,1,1,1,1,1|1","B":"1,1,1,1,1,1,1,1|1","K":"3,-2,5,1,7,1,4,2|1"}}}'
```

Locked: `AFFINE_JZ_SHEAR_ZERO`.

## 6. What LIVE and LEARN mean

The example app prints **LIVE** when the cell accepted the string and returned a court status that is not `REFUSED_*`. **LEARN** means the payload or the transport missed. Eclipse and EHT can return `MISS` and still be LIVE — the appointment was graded; it was not met.

## 7. Wrappers that already exist

Python / JS / LangChain / LlamaIndex / CrewAI / AutoGen / OpenAI tools stay in [`clients/math-court-mcp/`](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/tree/main/clients/math-court-mcp). They POST. They do not evaluate a lattice. If a wrapper grows a second law, delete it.
