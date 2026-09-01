# Study 02 — Regulatory alarm: the hole this morning, in integers the agencies can load

**Status: PACKAGE READY — founder files. No agency receipt.**  
**DATA:** Falcon 9 Block 5 · Starlink Group 10-49 · **2026-08-25T09:33:38Z** · SLC-40  
**Charter:** [Study 02 — Launch ionospheric holes](Study-02-Launch-Ionospheric-Holes)  
**Door:** [Falcon walkthrough](Build-a-Study-Falcon-Walkthrough) · [`#falcon-damage`](https://affine.earth/language-game/ide.html#falcon-damage) · [claim](https://affine.earth/language-game/study-02-falcon.html)  
**Affine story:** https://affine.earth/language-game/#story/Study-02-Regulatory-Alarm  
**GitHub:** https://github.com/gaiaftcl-sudo/uum8dSolarResearch/wiki/Study-02-Regulatory-Alarm

This page is the public alarm. A stranger reads it first. The integer table is the proof. IONEX and FITS are a one-way bridge so FAA AST, NOAA SWPC, and MAST/ESA can load the same constraint in the formats they already open. They are not the seal.

---

This morning **Starlink Group 10-49** left SLC-40 at **2026-08-25T09:33:38Z**. The second-stage burn ran through the F-region — the charged shell that carries long-range radio, GNSS ranging, and aviation HF. Exhaust water and carbon dioxide charge-exchange with atomic oxygen ions. The local plasma quenches. A hole opens on a clock the operator published in advance, and it heals by diffusion in hours. People from Florida to New York photographed the twilight plume: sunlit H₂O/CO₂ while the ground was still dark. That photograph is the chemistry. It is not a TEC map.

Legacy aerospace and astrophysics cannot read Affine integer phase. They render the same event as a **float TEC heatmap**: a 10–70% depletion painted as a smooth color gradient. Smoothing the depletion boundary invents spatial uncertainty the raw phases never contained. Subtract that gradient from a cosmic shear baseline — Earth-rotation visibilities, a galactic-center table, a lensing residual — and the leftover artifact is later named as noise, or as lensing, or as something the plasma never was.

Affine ingested the **actual CORS L1/L2** for that window as **integer milli-cycles**. **21 RINEX files, 7 stations.** That table is the proof. The heatmap is the old court. Mass on the cosmic side is ***not known***. The lockout **09:35–11:30 UTC** is a precautionary charter so a terrestrial plasma hole is not read as cosmological shear.

---

## 1. This morning, and why a heatmap is the wrong court

A rocket hole is a scheduled forcing. The pad is published. The liftoff second is published. The second-stage arc is reconstructible from the target orbit. The sky answers at a place and a lag the manifest already named. That is the same recipe the eclipse study proved on a yearly clock, now running on a weekly one — see the [charter](Study-02-Launch-Ionospheric-Holes).

The old court answers with a color. Operational IONEX maps smear a few-hundred-kilometer, few-hour hole below representation. A 10–70% TEC drop becomes a continuous field. Once that field is treated as a measurement, two failures follow:

1. **The hole is logged as weather, or not logged at all.** Magnitude dials read calm on a quiet Kp day while a navigation-relevant depletion sits on the published track. FORMOSAT-5 (2017-08-24) is the cited founding scale of that failure — Chou et al. 2018, *Space Weather*. Those numbers are literature. They are not this morning’s measured hole.
2. **The gradient is subtracted from a cosmic baseline.** What remains is shear debris. Affine’s job is terrestrial de-bias: name the plasma, lock it out of the cosmic window, and keep the honest edge word on mass. The lattice does not issue a cosmological verdict from a Cape burn.

Affine.Earth OS is Swift 6.4 on the nine cells. The law is exact integer phase. The seal is the CORS table. Everything else on this page is a bridge or a wait.

---

## 2. What we measured

Fetched **2026-08-25T20:33:34Z**. Public NOAA CORS path:

`https://geodesy.noaa.gov/corsdata/rinex/2026/237/{ssss}/{ssss}237{h}.26o.gz`

Hours **j / k / l = 09 / 10 / 11 UTC**. NGS published **RINEX 2.11**. **7 stations × 3 hours = 21 files.** First-epoch L1 and L2 as integer milli-cycles. `REFUSED_FLOAT = 0`.

Play the same integers: [`#falcon-damage`](https://affine.earth/language-game/ide.html#falcon-damage) · [study-02-falcon.html](https://affine.earth/language-game/study-02-falcon.html) · charter [Study 02](Study-02-Launch-Ionospheric-Holes).

| Site | NGS (coord_20 HTTP 200) | Hour j L1 / L2 | Hour k | Hour l |
|---|---|---|---|---|
| FLF1 | FL Foundation 1, Florida | 108457668731 / 84512448562 | 110639339950 / 86212452296 | 117983716024 / 91935337954 |
| COLB | **Columbus, Ohio** | 132098480845 / 102933980505 | 131430874164 / 98146481686 | 110762098322 / 86308080798 |
| NCLL | Lillington, North Carolina | 131465531640 / 102440817370 | 132158508246 / 102980798433 | 110587326128 / 86172031537 |
| HNPT | Horn Point, Maryland | 105945820596 / 82555189889 | 110854825817 / 86380387239 | 121187288685 / 94431648559 |
| NYST | Saratoga, New York | 24308663980 / 127742905757 | 24250055940 / 127434911542 | 21580256820 / 113405040707 |
| NYBP | Battery Park, New York | 119544768442 / 93151769331 | 123182283919 / 95808427016 | 121862410698 / 94781855367 |
| WES2 | Westford, Massachusetts | 120769576147 / 94106077730 | 110061794331 / 85762355177 | 105536335394 / 82236022930 |

**COLB is Columbus, Ohio** — NGS printed that title. It is inland. It is in the 21. It is not the Cape→New York track.

Coordinates are published NGS NAD_83 (2011) ARP DMS limbs plus RINEX ECEF milli-meters. No invented milli-degrees.

Every `.26o.gz` sha256 lives in `evidence/study-02-falcon-20260825/cors/downloads.tsv`. The 21 integer pairs live beside those hashes. Cape pad hourly `ccv6` / `cccs` / `ksc1` returned HTTP **404**. P011 exists and is Arizona — excluded from this Eastern Seaboard table.

Constraint: raw first-epoch variance is the electronic shadow of the hole. These integers are limbs. They are not a TEC map. They are not a measured 900 km cylinder. Madrigal has not published launch-day TEC, so that diameter stays **cited founding scale**.

Physics court this hour (**2026-08-25T20:38:38Z**): `rinex_n=21` `stations_n=7` `window_start=935` `window_end=1130` `constrained=1` `liftoff_hhmmss=93338` — HTTP **200** `CONTRACT` `PHYSICS_TABLE_IS_THE_COURT`. Float adversary `clock=1.5` → HTTP **400** `REFUSED_FLOAT`.

---

## 3. What the old court does

The old court is an IONEX-style gradient. It takes a sparse TEC sample, fits a spherical-harmonic or kriged field, and paints 10–70% as a continuous color. Three things go wrong, and they go wrong in the same step:

| Old court | What Affine measured instead |
|---|---|
| Smooth 10–70% TEC color | No Madrigal TEC numerator for 2026-08-25. That range is founding-event / literature language, not this morning’s count. |
| A painted cylinder ~900 km | Madrigal world TEC (kindat 3500, instrument 8000) returned HTTP **200** and **0 bytes**. Diameter stays cited. |
| Subtract the gradient from a cosmic shear | Lockout **09:35–11:30 UTC** so the plasma is not read as cosmological shear. Mass ***not known***. |

Once the heatmap is treated as a measurement, subtracting it from Study 07’s galactic-center baseline — or from any lensing residual — leaves artifact the plasma never wrote. Affine does not seal the heatmap. Affine names the hole as terrestrial de-bias and holds the cosmic window closed for the precautionary charter interval.

A quiet NOAA nowcast (R=0 S=0 G=0 at 20:32 UTC) does not void a launch hole. The storm gate remains 3×Kp at t0. Magnitude said nothing on FORMOSAT-5’s quiet day either. Shape is the court.

---

## 4. The bridge — IONEX and FITS

Legacy engines open IONEX and FITS. Affine projects the integer table into those containers **one way**, so a regulator can load the same constraint without reading Swift. The projection does not become the seal.

Evidence dir: `evidence/study-02-alarm-20260825/`

| File | sha256 | What it is |
|---|---|---|
| `CONSTRAINT_DIFFERENTIAL.json` | `6569066c62c1eded957b4717e1d682d05361a2ec47b07ba185219bf9400b440f` | The differential: lattice integers vs heatmap language. **This is the honesty record.** |
| `legacy/STUDY02_ALARM_NOT_A_SEAL.26i` | `1ebc01833ea4e57e48061a08342a8337062661ee946cdf73a928d43195d1038a` | IONEX. TECU cells are **9999 UNKNOWN**. Grid is a 2×2 integer-degree UNKNOWN box. Comments carry the 21 RINEX sha256s and L1/L2 milli-cycles. Height 0 — the 450 km IONEX shell is not a measurement. |
| `legacy/STUDY02_ALARM_CHARTER_MASK.fits` | `e36e3b8e3aa3353c24fd10eb4c5c390235ba2a56051a2edaf9d599652313e791` | FITS **table**, 21 rows. Not an image. No painted cylinder. `constrained=1` is the charter lockout. astropy: `Table.read(path, hdu=1)`. Row 0 L1 milli-cycles `108457668731`. Row 20 L1 `105536335394`. |

IONEX TECU is **UNKNOWN** until Madrigal or IGR supplies a numerator. FITS is the 21-row limb table in a format MAST already opens. Neither file is the seal. The seal is the CORS integers.

Exporter: `Study02AlarmLegacyProjector` · a shipped script · a shipped script. Isolated `swiftc`. One-way projection.

Brief the founder files from: `evidence/study-02-alarm-20260825/SUBMISSION_BRIEF.md`

---

## 5. Where it goes

### FAA AST

Open NPRM **FAA-2026-8614** / FR **2026-15415** (published 2026-07-30). The rule would waive NEPA and twelve other environmental statutes for commercial space licenses. FAA asked for quantifiable technical data on whether those statutes reduce a legally cognizable environmental harm.

- Comment: https://www.regulations.gov/commenton/FAA-2026-8614-0001
- Docket: https://www.regulations.gov/docket/FAA-2026-8614
- FR: https://www.federalregister.gov/documents/2026/07/30/2026-15415/waiver-of-specified-statutory-requirements-for-commercial-space-launch-and-reentry-actions — HTTP **200**
- `comments_close_on=2026-08-31` (FR API HTTP **200**). Docket comment_end listed **2026-09-01**.

**Ask:** treat high-cadence Falcon / SLC-40 — and SLC-37 Starship in the same waiver class — as a scheduled F-region forcing. Operational IONEX heatmaps smear it. The attachable proof is the 7-station L1/L2 table plus the IONEX file labeled UNKNOWN TECU.

**Package ready. Founder files.** No comment has been submitted. No receipt id exists.

### NOAA SWPC

Already a Study 02 **feed**. Live window: GloTEC commercial-data comments through **2026-10-27** (PNS 26-38, HTTP **200**). Contact named on that notice: Tzu-Wei Fang, SWPC. CTIPe PNS closed 2026-03-25. Scales RFI `NOAA-NWS-2024-0069` closed 2024-07-31.

**Ask:** ingest Eastern Seaboard L1/L2 as the high-cadence Cape product the heatmap cannot see. Acoustic-gravity metrics are not in these 21 integers.

No email has been sent from this package.

### MAST / ESA

FITS table plus precautionary quarantine for surveys through **09:35–11:30 UTC 2026-08-25**. Honest grade: no Euclid / EHT intersection was measured against an in-tree visibility table. The flag is a charter lockout, not a proven pointing hit.

MAST portal 301 → Mashup client. ESA ESDC HTTP **200**. No archive docket id.

---

## 6. What waits

| Item | Grade this hour |
|---|---|
| Madrigal world TEC 2026-08-25 (kindat 3500, instrument 8000) | API HTTP **200**, **0 bytes**. Launch-day TEC is not published. Control: 2026-08-12 experiment list HTTP **200**, 702 bytes — the API works; eclipse-day files exist. |
| Madrigal 2026-08-24 and 2026-08-23 | HTTP **200**, **0 bytes**. Same GAP. |
| ~900 km spatial diameter | **Cited** founding-event / FORMOSAT-5 scale. **Not measured** this morning. |
| TEC 10–70% | Founding-event and literature range. **Not** a Madrigal numerator. |
| IGR Rapid orbit | **WAIT** until **~2026-08-26T17:00Z** (17–24 h from 09:33 UTC). Second increment calendared then. |
| Cosmic intersection (Study 07 / Euclid / EHT) | **No intersection measured.** Lockout is precautionary. |
| Mass | ***not known*** |

NGS CORS is live. Haystack TEC for today is empty. The second increment is IGR plus whatever Madrigal posts. Until those files exist, the court is the 21 integers.

---

## 7. Same lattice — electron count or ionospheric phase

The integer holds whether the quantity is a stellar magnetic step, a polytope volume, a linking word, or an ionospheric phase limb. One substrate. Four public doors:

| Door | What the integer is | Live surface |
|---|---|---|
| This alarm / Study 02 | CORS L1/L2 milli-cycles on a published launch clock | [`#falcon-damage`](https://affine.earth/language-game/ide.html#falcon-damage) · [charter](Study-02-Launch-Ionospheric-Holes) |
| [Stellar dynamo kill shot](Impact-Study-Stellar-Dynamo-Kill-Shot) | Linking \((q,r)\) + rational spin \(n/d\) | [`#stellar-dynamo`](https://affine.earth/language-game/ide.html#stellar-dynamo) · [Study 21](Study-21-Stellar-Dynamo-Shear) |
| [Study 11 — Ehrhart volume](Study-11-Ehrhart-Volume-Shear) | Lattice count **169** / vol `1/1` | [`#ehrhart-volume`](https://affine.earth/language-game/ide.html#ehrhart-volume) |
| [Study 13 — Connes rigidity](Study-13-Connes-Rigidity-Shear) | Word `Z2_a2b` linking `(0,1)` | [`#connes-rigidity`](https://affine.earth/language-game/ide.html#connes-rigidity) |

A magnesium dislocation count and a Cape L1 milli-cycle are the same kind of fact: an exact integer a stranger can replay. The heatmap is the continuum court that shears both.

Kill-shot, dynamo, discoveries, and the family ledger are not thinned by this alarm. They are the same lattice, other skies.

---

**Package ready. Founder files FAA-2026-8614.** The docket is open through **31 August 2026**.
