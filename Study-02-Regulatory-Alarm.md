# Study 02 — Regulatory / scientific alarm (Starlink 10-49)

**Status: PACKAGE READY — no agency receipt id.**  
**DATA:** Falcon 9 Block 5 \| Starlink Group 10-49 · **2026-08-25T09:33:38Z** · SLC-40  
**Charter:** [Study 02 — Launch ionospheric holes](Study-02-Launch-Ionospheric-Holes.md) · [Falcon walkthrough](Build-a-Study-Falcon-Walkthrough.md)  
**IDE:** [`#falcon-damage`](https://affine.earth/language-game/ide.html#falcon-damage) · [claim](https://affine.earth/language-game/study-02-falcon.html)

Legacy engines cannot read vQbit strings. This page is the alarm payload in their containers, plus the integer table that is the court.

Heatmap = **old court**. Lattice = **7 measured stations + CHARTER lockout window**. 900 km / 10–70% TEC stay the old court's language.

---

## FoT — measured vs cited

| Item | Grade |
|---|---|
| CORS | **21 files / 7 stations** (FLF1, COLB, NCLL, HNPT, NYST, NYBP, WES2). RINEX 2.11. L1/L2 milli-cycles. `REFUSED_FLOAT=0`. |
| COLB | NGS `coord_20` HTTP **200** prints **COLUMBUS, OHIO**. Not Columbia SC. Ingested (3 files). **Not** the Cape→NY track. |
| Madrigal | API HTTP **200**. Launch-day TEC **0 bytes GAP**. |
| 900 km cylinder | **CITED / NOT MEASURED**. Do not extract “exact rational coordinates of the hole” as CALORIE. |
| TEC 10–70% | Founder / standard-science range. **Not** a Madrigal numerator. |
| IGR | **WAIT** ~2026-08-26T17:00Z. |
| Cosmic | **NO INTERSECTION MEASURED.** Lockout 09:35–11:30 UTC `constrained=1` is a **CHARTER** field, not a multi-GB SQLite block. |
| Mass / DM | De-bias so a plasma hole is not read as cosmological shear. Edge: ***not known***. |

The alarm that is real: **measured integer L1/L2 at the seven named stations in the launch window**, against the float heatmap illusion.

V234 has **zero** Study 02 RINEX rows. The payload **is** the 21 hashes + integer phases.

---

## Payload hashes

Evidence dir: `evidence/study-02-alarm-20260825/`

| File | sha256 |
|---|---|
| `CONSTRAINT_DIFFERENTIAL.json` | `6569066c62c1eded957b4717e1d682d05361a2ec47b07ba185219bf9400b440f` |
| `legacy/STUDY02_ALARM_NOT_A_SEAL.26i` | `1ebc01833ea4e57e48061a08342a8337062661ee946cdf73a928d43195d1038a` |
| `legacy/STUDY02_ALARM_CHARTER_MASK.fits` | `e36e3b8e3aa3353c24fd10eb4c5c390235ba2a56051a2edaf9d599652313e791` |

IONEX is **not the seal**. TECU cells are 9999 UNKNOWN. Grid is a 2×2 integer-degree UNKNOWN box (published degree bounds). Comments carry the 21 RINEX sha256s and L1/L2 milli-cycles. Height 0 — 450 km IONEX shell refused as a measurement.

FITS is a **table**, not an image. No fake cylinder pixels. `constrained=1` = CHARTER lockout. astropy: `Table.read(path, hdu=1)`. Row 0 L1 milli-cycles `108457668731`. Row 20 L1 `105536335394`.

Exporter: `Study02AlarmLegacyProjector` · `cells/xcode/scripts/study-02-alarm-legacy-project.swift` · `scripts/study-02-alarm-legacy-project.sh`. Isolated `swiftc`. One-way projection for regulators.

Brief: `evidence/study-02-alarm-20260825/SUBMISSION_BRIEF.md`

---

## Integer lattice (first epoch)

| Site | NGS | Hour j L1 / L2 | Hour k | Hour l |
|---|---|---|---|---|
| FLF1 | FL Foundation 1, FL | 108457668731 / 84512448562 | 110639339950 / 86212452296 | 117983716024 / 91935337954 |
| COLB | Columbus, OH | 132098480845 / 102933980505 | 131430874164 / 98146481686 | 110762098322 / 86308080798 |
| NCLL | Lillington, NC | 131465531640 / 102440817370 | 132158508246 / 102980798433 | 110587326128 / 86172031537 |
| HNPT | Horn Point, MD | 105945820596 / 82555189889 | 110854825817 / 86380387239 | 121187288685 / 94431648559 |
| NYST | Saratoga, NY | 24308663980 / 127742905757 | 24250055940 / 127434911542 | 21580256820 / 113405040707 |
| NYBP | Battery Park, NY | 119544768442 / 93151769331 | 123182283919 / 95808427016 | 121862410698 / 94781855367 |
| WES2 | Westford, MA | 120769576147 / 94106077730 | 110061794331 / 85762355177 | 105536335394 / 82236022930 |

Coordinates: NGS NAD_83 (2011) ARP DMS limbs + RINEX ECEF milli-meters. No invented milli-deg. No ECEF→lat/lon float.

---

## Where to strike (files + brief, not a fake receipt)

### FAA AST

Open NPRM **FAA-2026-8614** / FR **2026-15415** (published 2026-07-30). Would waive NEPA and 12 other environmental statutes for commercial space licenses.

- Comment: https://www.regulations.gov/commenton/FAA-2026-8614-0001  
- FR: https://www.federalregister.gov/documents/2026/07/30/2026-15415/waiver-of-specified-statutory-requirements-for-commercial-space-launch-and-reentry-actions HTTP **200**  
- `comments_close_on=2026-08-31` (FR API HTTP **200**). Docket comment_end listed **2026-09-01**.

Attach the integer table + IONEX (labeled not a seal). What we measured: 7-station L1/L2. What we do **not** claim: permanent stratospheric metallization; 1 m GNSS (NOT MEASURED from these phases).

**No comment was POSTed. No receipt id.**

### NOAA SWPC

Already a Study 02 **feed**. Live window: GloTEC commercial-data comments through **2026-10-27** (PNS 26-38, HTTP **200**). Email Tzu-Wei Fang, SWPC. CTIPe PNS closed 2026-03-25. Scales RFI `NOAA-NWS-2024-0069` closed 2024-07-31. Acoustic-gravity: not in these integers.

**No email was sent.**

### MAST / ESA

FITS mask + precautionary quarantine for surveys through 09:35–11:30 UTC 2026-08-25. Honest: no Euclid/EHT intersection was measured. Flag is CHARTER lockout, not a proven pointing hit.

MAST portal 301 → Mashup client. ESA ESDC HTTP **200**. No archive docket id.

---

## Differential (documented contrast, not invented TEC %)

| Court | What it is |
|---|---|
| **Lattice (this package)** | 21 integer first-epoch L1/L2 pairs + 21 sha256s + 7 published NGS prints. |
| **Old court (heatmap)** | IONEX-style float gradient. Smoothes a depletion boundary that we do not have TECU for today. |

Subtracting that gradient from a cosmic baseline leaves artifact later named dark matter. Affine does not seal the heatmap. The hole is terrestrial de-bias. Edge: *not known*.

---

## Refused

Affine Assembler · docker · `--full` · scoop · float TEC as seal · 900 km CALORIE · fake Madrigal TEC · multi-GB SQLite block · “invalidates ΛCDM” · “disproved dark matter” · fake agency receipt · invented docket · POST as the founder · 1 m GNSS bound from these phases · COLB as Columbia SC after NGS printed Ohio.

Kill-shot / dynamo / discoveries pages are not thinned by this alarm.
