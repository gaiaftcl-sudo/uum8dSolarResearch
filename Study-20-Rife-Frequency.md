# Study 20 — Rife light and sound (integer test claim)

**Status: LAW FROZEN + LIVE CLAIM — 2026-08-25 · test claim, not efficacy**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Discoveries by user](Discoveries-By-User.md)

| Surface | URL / key | Grade |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-20-rife.html | POST `rife` ingest |
| IDE | https://affine.earth/language-game/ide.html#rife-frequency | integer Hz and/or nm |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/game/rife/ingest` | `hz` and/or `nm` · source+role |
| Affine story | https://affine.earth/language-game/#story/Study-20-Rife-Frequency | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-20-Rife-Frequency | door |

This study has a court. It is **not OPEN**. OPEN stays 03 / 05 / 08.

**Affine does not write that a frequency kills cancer.** Affine does not host a treatment SOP.

---

## What was fetched this hour

[Wikipedia: Royal Rife](https://en.wikipedia.org/wiki/Royal_Rife) (GET 2026-08-25) describes microscopes and an “oscillating beam ray.” It **does not publish an integer Hz/nm table**. None is invented.

The court therefore accepts **any integer** `hz` and/or `nm` with `source`+`role` and seals CALORIE as `integer_frequency_claim_accepted`. Wiki label: **test claim, not efficacy**.

Optional cited fixture (published integers, attributed):

| cited_id | Integer | Source |
|---|---|---|
| `iso16-a440` | **440 Hz** | [Wikipedia A440](https://en.wikipedia.org/wiki/A440_(pitch_standard)) · ISO 16:1975 concert pitch |
| `visible-spectrum-380nm` | **380 nm** | [Wikipedia Visible spectrum](https://en.wikipedia.org/wiki/Visible_spectrum) — typical human-eye short bound |
| `visible-spectrum-750nm` | **750 nm** | same page — typical human-eye long bound |

Electronics Australia (1998) measured one marketed device at *about* 40 kHz. “About” is not an integer court key. It is not on the fixture.

---

## Integer keys

| Key | Kind | Rule |
|---|---|---|
| `hz` | Int64 | positive integer when present |
| `nm` | Int64 | positive integer when present |
| `cited_id` | optional token | must match a fixture row if presented |
| `source` + `role` | required | empty source → HTTP 400 `REFUSED_UNATTRIBUTED` |

IEEE payload (`432.0`) → HTTP 400 `REFUSED_FLOAT`.

---

## Example POSTs

**WIN** (cited 440 Hz):

```json
{"source":"researcher","role":"researcher","hz":440,"cited_id":"iso16-a440"}
```

**WIN** (any integer Hz with source+role, not on the fixture):

```json
{"source":"researcher","role":"researcher","hz":727}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"researcher","hz":432.0}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"researcher","hz":440}
```

File-only HTML is not the court. **LIVE CLAIM** only if apex POST HTTP 200 WIN.

---

## What this page does not do

- Does not invent Rife mortal-oscillatory rates
- Does not claim efficacy
- Does not write a treatment SOP
- Does not fill OPEN 03 / 05 / 08
- Does not host occupancy / docking

Swift: `cells/xcode/Sources/InvariantCompiler/RifeFrequencyCourt.swift` · domain `rife` in `LatticeDomainIntegration.swift`.
