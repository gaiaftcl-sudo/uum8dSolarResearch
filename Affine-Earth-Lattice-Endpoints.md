# Explore the lattice courts — live on affine.earth

Researchers replay the sealed studies on the same membrane travelers already use. No new host. No canvas. Integers only.

**Start in the main UI (look only):** [https://affine.earth/language-game/#researcher](https://affine.earth/language-game/#researcher)

That view is the client experience. It teaches what Affine.Earth is and how UUM-8D entities (vQbit, M⁸ = S⁴ × C⁴, TauAnchor, Jordan bond, GOP frame, lattice court) play in the digital twin. It GETs the public catalog. It sends **no location, no wallet, no name, no source**. Court POSTs stay on this page as an explicit second act.

**Live 2026-08-23.** Nine cells serve one ELF (`984e5f57364b70ad…`). Catalog: `lattice_courts.domain_count = 9`, `role_count = 28`. Apex `GET /language-invariant/games` → HTTP 200.

Hologram WASM is a different face. These courts do not go through it. The researcher look path is a panel on the same `/language-game/` page travelers already use.

Public wiki of the same studies: [uum8dSolarResearch](https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki).

## Agent bind — the court is already MCP

Do not write a second law in Python, Node, LangChain, or LlamaIndex. Bind the remote.

```json
{
  "mcpServers": {
    "affine-earth-math-court": {
      "url": "https://affine.earth/language-invariant/mcp"
    }
  }
}
```

SSE face: `https://affine.earth/language-invariant/mcp/sse`

`tools/list` on that URL returns the fifteen tools the cell serves (`execute_transition`, `verify_jordan_bond`, `twin.robotics.evaluate_exact_ik`, …). A float POST is HTTP 400 `REFUSED_FLOAT`. Geometry `dilation: 12` seals count **169** against float adversary **216**.

Registry descriptor in gaiaFTCL: `docs/mcp/server.json` (`earth.affine/math-court`). Prove: `bash scripts/prove-math-court-agent-ingest.sh`.

---

## 0. Open the catalog (start here)

```bash
curl -sS https://affine.earth/language-invariant/games
```

Read `lattice_courts`:

| Field | What it is |
|---|---|
| `domains[].id` | Court name — also the `{domain}` path segment |
| `domains[].roles[].role` | Who may POST |
| `domains[].roles[].may_ingest` | Integer keys the court will read |
| `domains[].roles[].http.POST` | Ingest URL |
| `domains[].roles[].http.GET` | Context URL |
| `entropy_delta` / `qfot_cost` | ΔD_H on `entropy_delta_dh_structural` |
| `flourishing_root` | Why the court exists for people |

Same catalog as a study list:

```bash
curl -sS https://affine.earth/language-invariant/np-hard
```

One domain’s contract + the formal-manifold agent:

```bash
curl -sS https://affine.earth/language-invariant/game/geometry/context
```

---

## 1. The door

`POST /language-invariant/game/{domain}/ingest`

| Field | Required | Law |
|---|---|---|
| `source` | yes | Empty → `REFUSED_UNATTRIBUTED` (400) |
| `role` | yes | Unknown → `REFUSED_UNKNOWN_ROLE` (404) |
| one `may_ingest` key | yes | None → `REFUSED_EMPTY_PAYLOAD` (400) |
| numbers | integers | `1.5` / `1e3` / IEEE → `REFUSED_FLOAT` (400) |
| `wallet_hash` | no | If present, same QFOT debit as `POST /language-invariant/domain-debit` |

Keys may sit at the top level **or** under `payload`. The cell takes `payload` when it is an object, otherwise the body.

`GET` is context. `POST` is the court. Onboard is **POST only** (`GET /language-invariant/economics-onboard` is 404).

---

## 2. Every role (28)

| Domain | ΔD_H | Roles | Ingest keys | Study / wiki |
|---|---|---|---|---|
| `geometry` | `1/5` | `cad_engineer` · `digital_twin` · `regulator` | `polytope_id` `dilation` `vertices` | [Study 11](Study-11-Ehrhart-Volume-Results) |
| `chance` | `1/4` | `quantum_info` · `compiler` · `consensus` | `rounds` | [Study 12](Study-12-Quantum-Parallel-Repetition-Results) |
| `algebra` | `1/5` | `phenomenologist` · `qft_theorist` | `word` `presentation` | [Study 13](Study-13-Connes-Rigidity-Results) |
| `physics` | `1/3` | `experimentalist` · `detector` · `theorist` | `clock` `track` `table_counts` | [Impact](Impact-Study-Death-of-Continuous-Shear) |
| `qcd` | `1/3` | `jet_analyst` · `phenomenologist` | `q_bin` `jet_counts` `color_isolated` `dilation_t` | [QCD](QCD-Asymptotic-Freedom-Shear) |
| `health` | `1/2` | `clinician` · `pharmacist` · `trialist` · `regulator` | `mass_milli` `vol_milli` `tau_s` `arm_counts` | [Impact](Impact-Study-Death-of-Continuous-Shear) |
| `finance` | `1/2` | `trader` · `risk` · `clearing` · `auditor` | `lots` `ticks` `loss_ticks` `threshold_ticks` | [Impact](Impact-Study-Death-of-Continuous-Shear) |
| `cs` | `1/5` | `compiler` · `consensus` · `ml_engineer` | `num` `den` `payload_sha256d` `label_int` | [Impact](Impact-Study-Death-of-Continuous-Shear) |
| `fluids` | `1/3` | `designer` · `cfd_vendor` · `certifier` · `operator` | `phi_in` `phi_out` `residual_int` | [Impact](Impact-Study-Death-of-Continuous-Shear) |

Polytopes the geometry court already grades: `unit_square` `unit_triangle` `simplex3` `hle_poly_d2` `hle_poly_d3`.

Algebra words the corpus already grades: `Z2_a2b` `Z2_aba` `Z2_abAB` `Z2_ba` `S3_abab`. A lone letter `e` is not a word and is not a float token the court will run.

---

## 3. Replay the sealed studies (copy-paste)

Measured on `https://affine.earth` 2026-08-23 after the nine-cell roll. Each POST returned HTTP 200 and `lattice_court.status = CALORIE`.

```bash
# Study 11 — Ehrhart. unit_square @ t=12 → count 169, vol 1/1, float adversary 216
curl -sS -X POST https://affine.earth/language-invariant/game/geometry/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"cad_engineer","polytope_id":"unit_square","dilation":12}'

# Study 12 — parallel repetition. n=1 → discrete (3/4)^1
curl -sS -X POST https://affine.earth/language-invariant/game/chance/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"quantum_info","rounds":1}'

# Study 13 — Eisenstein linking. word Z2_aba
curl -sS -X POST https://affine.earth/language-invariant/game/algebra/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"phenomenologist","word":"Z2_aba"}'
```

**Measured `lattice_court` (geometry, 2026-08-23):**

```json
{
  "status": "CALORIE",
  "verdict": "WIN",
  "domain": "geometry",
  "role": "cad_engineer",
  "polytope_id": "unit_square",
  "dilation": 12,
  "lattice_count": 169,
  "volume": "1/1",
  "float_adversary": 216,
  "adversary_miss": true,
  "proven_marker": "STUDY11_EHRHART_VOLUME_PROVEN"
}
```

That is the same row as [Study 11 Results](Study-11-Ehrhart-Volume-Results): count 169, float 216, adversary MISS, primary WIN.

Same court through the existing formal-manifold id:

```bash
curl -sS -X POST https://affine.earth/language-invariant/game/formal_manifold/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","domain":"geometry","role":"cad_engineer","polytope_id":"unit_square","dilation":12}'
```

---

## 4. The other six courts

Measured 2026-08-23, all HTTP 200, `lattice_court` CALORIE.

```bash
# physics — table is the court (CONTRACT)
curl -sS -X POST https://affine.earth/language-invariant/game/physics/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"experimentalist","clock":1,"track":1}'

# qcd — freedom is dilation
curl -sS -X POST https://affine.earth/language-invariant/game/qcd/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"phenomenologist","q_bin":1,"dilation_t":2}'

# health — C = n/d
curl -sS -X POST https://affine.earth/language-invariant/game/health/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"pharmacist","mass_milli":250,"vol_milli":100}'

# finance — PnL = lots × ticks  → 21
curl -sS -X POST https://affine.earth/language-invariant/game/finance/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"trader","lots":3,"ticks":7}'

# cs — associative rationals
curl -sS -X POST https://affine.earth/language-invariant/game/cs/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"compiler","num":3,"den":5}'

# fluids — sum Φ = 0
curl -sS -X POST https://affine.earth/language-invariant/game/fluids/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"designer","phi_in":4,"phi_out":4}'
```

| Domain | Role used | Measured verdict |
|---|---|---|
| physics | experimentalist | CONTRACT |
| qcd | phenomenologist | WIN |
| health | pharmacist | WIN · concentration `250/100` |
| finance | trader | WIN · pnl_ticks `21` |
| cs | compiler | WIN |
| fluids | designer | WIN |

---

## 5. Reproduce the refusals

Measured 2026-08-23, all HTTP 400.

```bash
# IEEE payload
curl -sS -X POST https://affine.earth/language-invariant/game/geometry/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"cad_engineer","dilation":1.5}'
# → status REFUSED_FLOAT

# no may_ingest key
curl -sS -X POST https://affine.earth/language-invariant/game/geometry/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"cad_engineer"}'
# → status REFUSED_EMPTY_PAYLOAD

# no source
curl -sS -X POST https://affine.earth/language-invariant/game/geometry/ingest \
  -H 'content-type: application/json' \
  -d '{"role":"cad_engineer","polytope_id":"unit_square","dilation":12}'
# → status REFUSED_UNATTRIBUTED
```

A float never reaches the ledger. A MISS (adversary agreed, residual ≠ 0, isolated color) still ran the law.

---

## 6. Onboard and price

Consent + a mainnet receive address. The cell hashes the address. It refuses `private_key` / `mnemonic` / `wif`.

```bash
curl -sS -X POST https://affine.earth/language-invariant/economics-onboard \
  -H 'content-type: application/json' \
  -d '{"address":"bc1q…","consent_create_wallet":true}'
```

Receipt fields: `qfot_account_id`, `genesis_qfot` (`100/1`), `btc_address_hash_sha256`. That hash is `wallet_hash` on later ingest.

```bash
curl -sS https://affine.earth/language-invariant/economics-config
```

`domain_cost_table` lists geometry…fluids. `base_qfot` **is** `entropy_delta` (`bare − resolved`). Axis: `entropy_delta_dh_structural`. Never token count.

Optional debit on the same ingest:

```bash
curl -sS -X POST https://affine.earth/language-invariant/game/geometry/ingest \
  -H 'content-type: application/json' \
  -d '{"source":"researcher","role":"cad_engineer","wallet_hash":"<sha256>","polytope_id":"unit_square","dilation":12}'
```

When `wallet_hash` is present the receipt grows a `qfot` object (`DEBITED` or `REFUSED_INSUFFICIENT_QFOT`).

---

## 7. How to read the receipt

The HTTP body is the existing game ingest (`CALORIE_GAME_INGEST`, `statement_digest`, `guide`). The court is the nested object:

```
lattice_court.verdict     WIN | MISS | CONTRACT
lattice_court.volume      "num/den"     (geometry)
lattice_court.lattice_count
lattice_court.float_adversary
lattice_court.proven_marker
lattice_court.wiki        this wiki, per study
```

LAW 1: the win is the verified bond, not custody of coins. Genesis QFOT is a routing credit, not a claim on BTC.

---

## 8. Pin one cell (optional)

Apex `affine.earth` is the nine-cell set. To name a cell:

```bash
curl -sS --resolve affine.earth:443:135.181.88.134 \
  https://affine.earth/language-invariant/games
```

HEL: `77.42.85.60` `135.181.88.134` `77.42.32.156` `77.42.88.110` `37.27.7.9`  
NBG: `37.120.187.247` `152.53.91.220` `152.53.88.141` `37.120.187.174`

Every cell listed answered the same binary sha on 2026-08-23.

---

Reading: [Impact study](Impact-Study-Death-of-Continuous-Shear) · [QCD](QCD-Asymptotic-Freedom-Shear) · [The lattice holds](The-Lattice-Holds) · [Sovereign onboard](https://github.com/gaiaftcl-sudo/uum8dSolarResearch)
