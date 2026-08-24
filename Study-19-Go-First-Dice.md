# Study 19 — Combinatorial State Space: 5-Player Go First Dice

**Status: LAW FROZEN + LIVE CLAIM — 2026-08-24 · Meyer 2023 5×d60 CALORIE**  
**Program:** [Language-games study board](Language-Games-Study-Board.md) · [Study 11 Ehrhart](Study-11-Ehrhart-Volume-Shear.md) · [Study 12 chance](Study-12-Quantum-Parallel-Repetition-Shear.md)

| Surface | URL / key | Grade |
|---|---|---|
| Claim UI | https://affine.earth/language-game/study-19-gofirst.html | POST `gofirst` ingest |
| IDE | https://affine.earth/language-game/ide.html#gofirst-dice | hash loads the cited faces and POSTs |
| Look | https://affine.earth/language-game/#researcher | GET only |
| Court | `POST /language-invariant/game/gofirst/ingest` | `die_a`…`die_e` + `cited_id` + `perm_num`/`perm_den` · source+role |
| Affine story | https://affine.earth/language-game/#story/Study-19-Go-First-Dice | this charter |
| GitHub | https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-19-Go-First-Dice | door |

Isolate a minimal-face integer set for N=5 dice such that all 5! (120) outcome permutations hold uniform probability, with zero collision states (ties). Exact discrete optimization over integer partition space.

**Conventional failure:** CPLEX/Gurobi-class solvers use floating-point simplex relaxations. Pruning depends on libm epsilon. Float drift forks cells; pruned branches uncertifiable; consensus on the search tree breaks.

**Affine path (UUM 8D Math Court):** exact checkable integer proof, not heuristic convergence.

1. **Exact Rational Boundary Mapping** — 120 orderings as exact irreducible rationals. The court reuses `GaiaFTCLCore.Rational` (cross-multiply `a·d < c·b`), the same law GET `/language-invariant/rational/boundary` and `/language-invariant/rational/arena` already serve. Stein binary GCD lives on that path. `REFUSED_FLOAT`.
2. **Discrete Shear for Traversal** — prune by raw limb cross-multiply. The branch that dies on one cell dies on all. Pruning is an arithmetic artifact, not a tolerance.
3. **Event-Sourced Verification** — seal refuses what the constructor refuses. GET `/language-invariant/eisenstein/seal` is the decode-path sibling. Decode on any peer runs the same predicate.

**Integration payload:** the published N=5 face configuration as a checkable integer proof. Uniformity is exact `1/120` (`perm_num=1`, `perm_den=120`). Never `0.008333`. This IS an optimal-control case for the shear studies.

**Shear mapping**

- Boundary saturation: 1/120 cross-multiply of *accumulated* products blows 64-bit; wrap = logic shear
- String-backed / limb isolation: `/language-invariant/rational/boundary` expands exact rational state, no truncation
- Substrate consensus: localized int shear = silent fork; strings/limbs over bounded int/uint

The court **verifies** a presented integer face tuple. It does not search for faces. Deriving an unknown configuration by iteration is the 2D fallacy (LAW 4 / LAW 9).

---

## Integer keys

| Key | Kind | Rule |
|---|---|---|
| `die_a`…`die_e` | Int64 lists | five published 60-face lists, strictly increasing |
| `cited_id` | exact token | `meyer-2023-5d60` |
| `n_players` | Int64 | 5 |
| `face_counts` | Int64 list | `[60,60,60,60,60]` |
| `perm_num` / `perm_den` | Int64 | exact Rational `1/120` via `!(p<t) && !(t<p)` |
| `source` + `role` | required | empty source → HTTP 400 `REFUSED_UNATTRIBUTED` |

IEEE payload (`0.008333`, `1.5`) → HTTP 400 `REFUSED_FLOAT`.

---

## Cited published fixture (not invented)

**Paul Meyer (2023)** — permutation-fair five 60-sided dice. Faces transcribed 2026-08-24 from [Wikipedia: Go First Dice](https://en.wikipedia.org/wiki/Go_First_Dice).

Problem paper (does not invent the Meyer faces; states the N=5 question and two other constructions): Ford, Grime, Harshbarger, Pollock, *Go First Dice for Five Players and Beyond*, Recreational Mathematics Magazine 10(17) 2023, [DOI 10.2478/rmm-2023-0004](https://doi.org/10.2478/rmm-2023-0004). Harshbarger’s mixed d20+d36+2×d48+d54 construction is cited there and on [ericharshbarger.org/dice/go_first_dice.html](http://www.ericharshbarger.org/dice/go_first_dice.html). This court seals the **complete public integer lists** (Meyer 5×d60). It does not invent faces and does not scan for a smaller set.

Five dice × 60 faces = 300 integers. Tiny. Not a generated-candidate dump.

Die A: `1 10 19 20 21 22 39 40 41 42 51 60 61 62 71 80 81 90 99 100 109 118 119 120 121 122 123 132 133 150 151 168 169 178 179 180 181 182 183 192 201 202 211 220 221 230 239 240 241 250 259 260 261 262 279 280 281 282 291 300`

Die B: `2 9 13 16 25 28 33 36 45 48 52 59 65 68 72 79 85 86 94 95 101 108 112 115 126 129 134 141 145 146 155 156 160 167 172 175 187 188 196 197 203 210 212 219 225 226 234 235 244 247 251 258 266 267 274 275 283 290 294 297`

Die C: `3 8 12 17 24 29 32 37 44 49 53 58 64 69 73 78 83 88 92 97 102 107 111 116 125 130 135 140 143 148 153 158 161 166 171 176 185 190 194 199 204 209 213 218 223 228 232 237 243 248 252 257 264 269 272 277 284 289 293 298`

Die D: `4 7 11 18 26 27 34 35 43 50 54 57 63 70 74 77 84 87 93 96 103 106 110 117 127 128 137 138 142 149 152 159 163 164 173 174 184 191 195 198 205 208 214 217 224 227 231 238 245 246 254 255 263 270 271 278 286 287 295 296`

Die E: `5 6 14 15 23 30 31 38 46 47 55 56 66 67 75 76 82 89 91 98 104 105 113 114 124 131 136 139 144 147 154 157 162 165 170 177 186 189 193 200 206 207 215 216 222 229 233 236 242 249 253 256 265 268 273 276 285 288 292 299`

Named check on WIN: cited-tuple match · face-count 60 · strictly increasing · structural no-tie (300 distinct) · `1/120` Rational. **5! is not enumerated.**

---

## Example POSTs

**WIN** (cited faces + exact 1/120):

```json
{"source":"researcher","role":"combinatorist","cited_id":"meyer-2023-5d60","n_players":5,"perm_num":1,"perm_den":120,"die_a":[1,10,19],"…":"full 60-face lists on the claim UI"}
```

**REFUSED_FLOAT**

```json
{"source":"researcher","role":"combinatorist","cited_id":"meyer-2023-5d60","perm_den":0.008333}
```

**REFUSED_UNATTRIBUTED**

```json
{"source":"","role":"combinatorist","cited_id":"meyer-2023-5d60","perm_num":1,"perm_den":120}
```

**REFUSED_CITED_MISMATCH** — any face not on the Meyer 2023 lists.

File-only HTML is not the court. **LIVE CLAIM** only if apex POST HTTP 200 WIN. If the membrane binary does not yet carry `gofirst`, the claim page says **unknown game_id / DARK**.

---

## What this page does not do

- Does not scan 5-dice face space or run CPLEX/Gurobi
- Does not invent faces
- Does not write `0.008333` as 1/120
- Does not fill OPEN 03 / 05 / 08
- Does not treat health as a pocket
- Does not undo Studies 16–18

Swift: `cells/xcode/Sources/InvariantCompiler/GoFirstDiceCourt.swift` · domain `gofirst` in `LatticeDomainIntegration.swift`.
