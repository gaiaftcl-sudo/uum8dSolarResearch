# Study 18 — Material STD (COD / mp-id / space-group)

**Status: LAW FROZEN — 2026-08-24 · Claim on apex waits on the membrane binary**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 16](Study-16-Disease-Type.md) · [Study 17](Study-17-Chemistry-InChIKey.md)

| Surface | URL / key | Grade |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-18-material.html | POST `material` ingest |
| IDE | https://affine.earth/language-game/ide.html#material-std | hash loads the fixture and POSTs |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/game/material/ingest` | `cod` / `mp_id` / `space_group`+`pearson` · optional `num_atoms` |
| Affine story | https://affine.earth/language-game/#story/Study-18-Material-STD | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-18-Material-STD | door |

The win is the **verified bond** to a public crystal STD. Generated material nicknames do not WIN. No minted `mp-` ids. No 46622-row catalog.

**Using something that is not accurate (because it shears) may not be useless — it may be dangerous.**

---

## Goal

Name a crystal the way COD / Materials Project / IUCr already name it: **COD** number, and/or **mp-#####**, and/or **space-group 1–230** plus a **Pearson** token. If a row has no STD, the game REFUSES (`REFUSED_NO_STD`). SOP-as-contract is this token. The recipe stays on disk.

---

## Integer / token keys

| Key | Kind | Rule |
|---|---|---|
| `cod` | Int64 | positive COD file number in the authored fixture |
| `mp_id` | exact token | `^mp-[0-9]+$` and present in the fixture — never minted |
| `space_group` | Int64 | 1…230; must travel with `pearson` when it is the only STD |
| `pearson` | exact token | e.g. `cF8` |
| `num_atoms` | Int64 | optional; `> 0` |
| `source` + `role` | required | empty source → `REFUSED_UNATTRIBUTED` |

Float density / GPa / mS/cm → HTTP 400 `REFUSED_FLOAT`.

---

## Authored fixture (3 rows, fetched 2026-08-24)

| STD | integers / tokens | cited | fetch |
|---|---|---|---|
| COD **9008564** | space_group **227** · pearson **cF8** | Diamond | `https://www.crystallography.net/cod/9008564.html` HTTP 200 · COD search `sgNumber=227` |
| mp-**149** | space_group **227** · pearson **cF8** | silicon | public MP id; HTML scrape blocked, id cited not invented |
| COD **1573832** | space_group **194** | hexagonal 4H Si-IV | COD search JSON `file=1573832` |

No invented catalog. Three rows only.

---

## Example POSTs

**WIN**

```json
{"source":"researcher","role":"crystallographer","cod":9008564,"space_group":227,"pearson":"cF8"}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"crystallographer","cod":9008564,"density":3.5}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"crystallographer","cod":9008564}
```

**REFUSED_NO_STD**

```json
{"source":"researcher","role":"crystallographer","mp_id":"mp-99999999"}
```

---

## What this page does not do

- Does not mint Materials Project ids
- Does not dump ERIC materials CSVs
- Does not host SOP / transmutation / warfare guides
- Does not invent occupancy / docking

Swift: `IndustryStandardCourts.swift` · domain `material`.

C-007 arms (warfare / transmutation / gene-vector): **ABSENT FROM APEX**. File count on steward disk: **7**. No game.
