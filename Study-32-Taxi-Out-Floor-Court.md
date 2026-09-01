# Study 32 — The Taxi-Out Floor Court

**Page class: CHARTER + RESULTS (Act 1).** Law frozen 2026-09-01 before grading. Corpus: `corpus/study-32/`, exact integer minutes, CC BY 4.0, provenance and digests pinned. Producing programs: `reproduce/taxiout-extract.swift`, `reproduce/taxiout-floor-court.swift`. Grades per [the ontology](Ontology).

**Status: ACT 1 SEALED on the open 2022 corpus (525,541 flights). ACT 2 (the 2026 challenge data) is ARCHIVE GATED — measured, not assumed: every anonymous probe of the challenge buckets returns 403, keys come with registration, and this programme does not create accounts.**

---

## The premise, and the premise it rejects

The [PRC Data Challenge 2026](https://ansperformance.eu/study/data-challenge/dc2026/data.html) asks the industry to **predict** taxi-out time — to minimise the RMSE of a forecast of operational overhead. This court does the Affine thing instead: it refuses to predict the number and **measures the excess exactly**, against a floor frozen before grading.

> **The frozen law:** `floor(airport)` = the 5th percentile of that airport's own taxi-out record, in integer minutes — the exact-arithmetic form of EUROCONTROL's own *unimpeded taxi time* concept. `excess(flight)` = `taxi − floor(airport)`. Airports admitted at ≥ 5,000 flights. No prediction, no model, no float.

## Act 1 — sealed on 525,541 European departures, calendar 2022

| airport | flights | floor (p05) | median | excess/flight |
|---|---|---|---|---|
| Istanbul LTFM | 48,153 | 16 min | 16 | 2.3 min |
| Vienna LOWW | 38,641 | 7 min | 9 | 3.0 min |
| Copenhagen EKCH | 29,430 | 9 min | 10 | 2.0 min |
| Dublin EIDW | 24,691 | 14 min | 20 | 5.8 min |
| **London Heathrow EGLL** | 20,983 | 10 min | 18 | **8.8 min** |
| Amsterdam EHAM | 8,087 | 9 min | 14 | 6.3 min |

**The ledger, exact:** total excess above the frozen floors, one year of these 20 airports — **1,224,355 minutes = 20,405 hours** across 338,254 admitted flights at those airports; **mean 3.6 minutes per departure**. At the REPORTED ICAO taxi-burn band of 8–15 kg fuel/min: **9,794–18,365 tonnes of fuel, 30,951–58,034 tonnes of CO₂** — per year, from twenty airports' taxi excess alone. That mass enters the same atmospheric ledger [Study 31](Study-31-Biosphere-Cascade) keeps.

## The controls, including the one that failed and why that is on the page

- **Discrimination:** 10 distinct airport floors (one shared floor would mean a broken instrument).
- **Known case:** the largest excess-per-flight must land on a slot-constrained hub — it lands on **Heathrow, 8.8 min. HOLDS.**
- **A control premise failed, and is recorded rather than deleted:** the first known-case arm asserted *a hub's floor must exceed a small field's* — and FAILED, correctly, because the premise was wrong: **a p05 floor measures taxiway geometry, not traffic.** Istanbul's enormous new field floors at 16 minutes and Bergen at 15 against Heathrow's 10, and that is geography. The hub effect lives in the *excess*, where the corrected control finds it.
- **A charter expectation was refuted by the data, and kept:** the charter expected quiet-hour excess ≈ pure coordination overhead (mutex idle → queueing ≈ 0). At **6 of 20 airports the quiet-hour excess is *higher*** — the quietest hours are night hours, and night is not daytime-minus-queueing (deicing, remote stands, single-runway ops). **The decomposition of the excess into queueing physics versus coordination overhead is therefore NOT_KNOWN from this corpus alone, and this court does not assert it.** The excess ledger itself stands.

## What this court refuses to carry

A proposal for this study circulated claiming that a discrete state representation *eliminates taxiing* — that the measured delta is entirely legacy-ATC waste and "state shear drops to zero." **Refused, on the proposal's own architecture:**

- **A discrete representation does not move a 70-tonne aircraft faster.** The floor is physical — engines, tarmac, bounded speed, wake separation — and the frozen law is built *on* it, not against it.
- **The proposal's own collision rule is a mutex, and a mutex queues.** A runway serves one aircraft at a time under any scheduler, including a perfect exact one; when demand exceeds capacity, delay is created by arithmetic, not by probabilistic ATC. "Zero shear" contradicts the proposal's own step 4.
- What an exact scheduler *can* claim is the seam this substrate already serves: **`atc_assert_4d_deconfliction`**, live on the court — exact 4D separation over declared trajectories, returning **a separation certificate or the violating pair, never a confidence score.** That is the honest Affine ATC claim: not zero taxi time, but *verdicts about separation that the bound parties can re-derive.*

## How this study loses

- **LOSS (i):** the excess ledger is dominated by a data artifact (e.g. block-time conventions differing by airline). Testable by per-airline stratification when Act 2's richer fields arrive.
- **LOSS (ii):** the floors are unstable year-over-year — then p05 is not a floor and the law is re-frozen *as a correction, dated*.
- **LOSS (iii):** an exact-scheduling literature value already accounts for the full excess as irreducible queueing. Then the coordination claim dies and the page says so.

## Act 2 — the 2026 challenge, gated and waiting

The 2026 movement data (11 airports, AOBT/ATOT per movement) would let this court compute floors per runway configuration and split the ledger further. The archive is measured **registration-gated** (403 on every anonymous probe). When a registered participant supplies the files, the frozen law runs unchanged — and the study's answer to the challenge's own question is filed as: *the RMSE of a prediction is the wrong quantity; here is the exact excess, its floor, and its refusals.*

---

**Related:** [The replacement grade — the ATC/autonomy seam](The-Replacement-Grade) · [Study 31 — where the fuel mass lands](Study-31-Biosphere-Cascade) · [The ontology](Ontology)
