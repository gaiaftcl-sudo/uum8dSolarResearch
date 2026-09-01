# The reentry forcing nobody is required to measure

**Page class: EVIDENCE.** Every assertion below carries its grade — VERIFIED, REPORTED, MEASURED, PROJECTION, ABSENT or NOT_KNOWN — defined in [the ontology](Ontology).

**Every number on this page is either exact integer arithmetic over a corpus pinned by digest, or a verbatim quotation from a primary source with its citation attached.** Where a quantity is contested, the contest is shown. Where the honest answer is that something is not known, it says so.

This page makes **no claim of catastrophe, no claim of established ecological harm, and no prediction**. It states a forcing that is exactly countable, an occupancy that has already been measured, a scientific response that five published groups disagree about *on the sign*, and a regulatory record in which no one is obliged to measure any of it.

Reproduce everything: `git clone` this repository and run [`reproduce/validate.sh`](reproduce/validate.sh).

---

## 1. What is already in the stratosphere, measured

Murphy et al. 2023, *PNAS* 120(43) e2313374120. The PALMS single-particle laser mass spectrometer flown on NASA's WB-57 from Fairbanks, Alaska, during the SABRE mission, February–March 2023, sampling to 19 km pressure altitude. **Over 500,000 individual aerosol particles** analysed.

> "About 10% of stratospheric sulfuric acid particles larger than 120 nm in diameter contain aluminum and other elements from spacecraft reentry."

With its uncertainty, from the same paper: **10 ± 7%**, by particle number, above 120 nm diameter. Over twenty elements were detected in ratios consistent with spacecraft alloys; niobium and hafnium are named as markers for rocket nozzles.

And the comparison the authors themselves draw, verbatim:

> "The flux of aluminum from meteoroids is estimated to be 130 tons y⁻¹, of which about 20 tons y⁻¹ ablates. **About 210 tons y⁻¹ of aluminum ablates from reentering spacecraft.**"

**On the paper's own denominator, spacecraft aluminium entering the stratosphere already exceeds the ablated meteoric supply by roughly ten-fold.** Reentering spacecraft ablate between 40 and 70 km, over a footprint about 300 km long.

**The denominator is contested and this page will not hide it.** The ablated-meteoric-aluminium figure differs by a factor of about seven between papers sharing co-authors: ~20 t/yr (Murphy et al. 2023) against 131 t/yr (Schulz & Glassmeier 2021) and 142 t/yr (Schulz et al. 2025). The same spacecraft injection therefore reads as roughly 10× the natural rate on one denominator and under 2× on another. **Any "N times the natural rate" claim must name its denominator, including ours.**

The authors' own projection, and their own limiting clause:

> "Planned increases in the number of low earth orbit satellites within the next few decades could cause up to half of stratospheric sulfuric acid particles to contain metals from reentry. **The influence of this level of metallic content on the properties of stratospheric aerosol is unknown.**"

Roughly 50% of stratospheric particles already contain *meteoric* metals. The projection is that spacecraft metals reach a comparable share.

---

## 2. The forcing, exactly, by operator and by year

Computed from the GCAT catalogue, pinned at `corpus/study-29/` by sha256 `090ce077…`. Dry mass is parsed as an exact integer gram count by string split — no floating-point parse enters the ledger. Operator code `SPXS`, status in {R, AR, D}.

| year | satellites | mass | share of **all** reentering mass |
|---|---|---|---|
| 2019 | 0 | 0 | 0.0% |
| 2020 | 119 | 20.0 t | 16.0% |
| 2021 | 147 | 27.8 t | 14.0% |
| 2022 | 245 | 36.3 t | 14.3% |
| 2023 | 188 | 34.5 t | 14.7% |
| 2024 | 334 | 112.7 t | 26.2% |
| **2025** | **679** | **211.6 t** | **45.8%** |

One operator went from nothing to **45.8% of all mass entering Earth's atmosphere** in six years.

**Two honesty constraints on that table.** The 2026 row is a partial year: 124.2 t through day 242, which annualises to **187.3 t/yr — 0.89× of 2025, flat to slightly down**, not continuing the climb. And GCAT's `DryMass` column carries an estimate flag: **±20%**. The launch-mass column is unflagged and reliable; the dry-mass figures inherit that band.

**What actually enters the air**, from SpaceX's own demisability analysis (M. Nicolls, 2025-02-26):

> "On the Starlink V2mini satellite, we predict that approximately 5% of the mass of the entire satellite could survive reentry. The biggest contributor (~90% of the surviving mass) is silicon from the solar cells."

So roughly **95% ablates**. That confirms the premise of every alumina argument — and the same document names **no aluminium fraction at all**, and says the surviving remainder is mostly silicon.

---

## 3. What is authorized, what is requested, and why the difference matters

**The widely repeated "42,000 approved" is false, and the FCC's own order says so.** FCC 22-91 ¶116 decomposes that exact figure: 29,988 Gen2 that SpaceX *"has applied for"*, 4,408 Gen1 authorized, and 7,518 V-band. Two of the three are now stale — the standalone V-band constellation was merged into Gen2 on 2023-10-13 and no longer exists, and the 29,988 is 15,000 granted with **14,988 explicitly deferred** by DA 26-36 ¶5.

| tier | count | status | source |
|---|---|---|---|
| Gen1 Ku/Ka | 4,408 | **AUTHORIZED** | FCC 21-48, 2021-04-27 |
| Gen2 tranches 1+2 | 15,000 | **AUTHORIZED** | FCC 22-91; DA 26-36, 2026-01-09 |
| **authorized total** | **19,408** | **AUTHORIZED** | — |
| Gen2 remainder | 14,988 | DEFERRED | DA 26-36 ¶5 |
| Direct-to-cell | 15,000 | PENDING | SAT-LOA-20250916-00282 |
| Gen3 | 100,000 | PENDING | SAT-LOA-20260630-00264 *(secondary sourcing only)* |
| **Orbital Data Center** | **1,000,000** | **PENDING** | SAT-LOA-20260108-00016, accepted DA 26-113, 2026-02-04 |

At the SEC-filed five-year useful life for broadband satellites (424B4, 2026-06-12) and the catalogue-measured fleet mass, the authorized tier projects to about **1,909 t/yr** — roughly **9×** the 2025 measured rate. The pending million-satellite application projects to about **98,400 t/yr**, roughly **465×**.

**This page previously published a figure five times too high**, by taking 42,000 from circulation without asking which tier it belonged to. That is the same substitution this program exists to catch, and the correction is recorded rather than quietly applied.

---

## 3b. The orbital data centre application, on SpaceX's own disposal split

The pending application is for **up to one million satellites** (SAT-LOA-20260108-00016, accepted for filing DA 26-113, 2026-02-04). At the roughly five-year life of data-centre GPUs, about **200,000 would be decommissioned each year**.

**They do not all reenter, and the split is SpaceX's own.** Per their FCC filing of 29 May 2026, about **40,000 would deorbit and burn up**; the remaining ~160,000 would be pushed outward to a distant disposal orbit. An earlier version of this page projected all 200,000 as reentering — **five times too many** — and the correction is recorded here rather than applied silently.

| per-unit mass basis | deorbiting flux | vs 2025 measured |
|---|---|---|
| Starlink fleet mean, 492 kg | 19.7 Gg/yr | 93× |
| Gen3 filing figure, 2,000 kg | **80 Gg/yr** | **378×** |
| heavier rack-class, unstated | 160 Gg/yr | 756× |

**The per-unit mass is the missing input and nobody has published it.** No SpaceX filing states an AI-satellite mass, and the reporting that surfaced this filing says so directly: *"Without full, detailed specifications for these satellites, there's no way to properly tally the amount of material"* (Ars Technica, 2026-08-20). The flux is therefore a **range with a named gap**, not a point estimate.

### What that flux means against a sourced denominator

A flux against a sink does not accumulate to a limit; it converges to flux × residence time. Stratospheric aerosol residence is 1–4 years. The background stratospheric aerosol burden is **109–156 Gg of sulfur** (Sheng et al. 2015, doi:10.1002/2014JD021985; Brodowsky et al. 2024, doi:10.5194/acp-24-5513-2024), which at the published 4.083 sulfur-to-aerosol factor (Kremser et al. 2016, doi:10.1002/2015RG000511) is **445–637 Gg of aerosol**.

| sustained flux | τ = 2 yr standing burden | against the natural layer |
|---|---|---|
| 80 Gg/yr | 160 Gg | ~0.25–0.36× |
| 250 Gg/yr | 500 Gg | **~0.8–1.1×** |

**At the upper end this is a sustained perturbation comparable to the entire natural stratospheric aerosol layer.** For scale, Mount Pinatubo peaked at 30–60× background (Kremser et al. 2016) and measurably cooled the surface for roughly two years — but as a *decaying pulse*, not a maintained level.

**This page publishes no saturation year.** A saturation claim requires a capacity in the same units, and no published source states one. Two attempts were put to the court and refused: a proposed threshold of 1 particle/cm³ sits **at** the measured Junge-layer background of 1–10 particles/cm³, so the same arithmetic returns "saturated" for the pre-industrial sky with zero satellites; and an accumulation model omits the 1–4 year sink. Neither refusal is a function of constellation size — scaling the flux does not repair a denominator that equals the ambient value.

---

## 4. Two facts that cut against alarm, stated before the ones that do not

- The trailing 365-day measured flux is **178 t/yr**, which is **below the 450 t/yr average** assumed by the ESA studies SpaceX itself cited to the FCC in the 22-91 docket.
- SpaceX's demisability analysis attributes the surviving fraction mostly to **silicon**, and states no aluminium fraction. The 3/25 alumina yield used elsewhere in this repository is **Ferreira et al. 2024's**, not SpaceX's.

Omitting either would be the defect this program is named for.

---

## 5. The response is contested, on the sign

| group | model | reported |
|---|---|---|
| Ferreira et al. 2024 | mass only | chlorine-activation mechanism; **no ozone percentage at all** |
| Maloney et al. 2025 | WACCM6 + CARMA | a **weaker** springtime ozone hole |
| Revell et al. 2025 | SOCOLv4 | at most a **+0.27% ozone increase** |
| Barker et al. 2026 | all-mission | soot forcing **+6.47 mW/m² instantaneous, −6.40 stratospherically adjusted** |
| Vliex et al. 2026 | GEOS-Chem | **87.7%** of depletion driven by **NOx**, not alumina |

Barker's is the sharpest: **one model, one emissions set, two forcing definitions, opposite signs, zero difference in input data.**

Separately, Wang, Solomon, Santer *et al.*, *Nature* 639(8055), 2025, doi:10.1038/s41586-025-08640-9, **positively detects** the recovery of Antarctic ozone. **No peer-reviewed work claims an observed reversal, and this page does not.**

**The honest verdict on the atmospheric response is NOT KNOWN.** That is a result, not an evasion.

---

## 6. Nobody is required to measure it

This is the operative finding, and it required no model.

- **The only reentry reporting duty the FCC imposes** on an NGSO operator, under the Space Modernization order (47 CFR § 100.201(d)(3)), is: *"The number of satellites that re-entered the atmosphere."* A semi-annual integer count. **No mass, no material, no altitude, no atmospheric measurement of any kind.**
- **FAA reentry licensing does not attach.** A "reentry vehicle" is statutorily one designed to return *"substantially intact"* (51 U.S.C. § 50902(19)). A satellite designed to demise is not one, so 14 CFR part 450 and its NEPA hook at § 450.47 never apply to constellation disposal.
- **The FAA's Congressionally-mandated report** on reentry disposal from large constellations (P.L. 116-260, transmitted 2023-09-22) contains **zero occurrences** of *ozone*, *alumina*, *aluminum oxide*, *stratosphere*, or *air quality*. Its entire risk frame is human casualty on the ground and in the air.
- **The FCC has proposed to exclude space operations from NEPA altogether** as *"extraterritorial activities"* (FCC 25-47, WT Docket 25-217, ¶33) — in a paragraph that acknowledges parties allege *"satellites in orbit can create impacts on the atmosphere from launches and reentries."*
- **The FAA has proposed waiving thirteen federal environmental statutes** for commercial space licences, **including the Clean Air Act** (91 Fed. Reg. 47,997, 2026-07-30), under Executive Order 14335 (2025-08-13), which directs the Secretary of Transportation to *"eliminate or expedite"* environmental review for launch and reentry licensing.

**A search across the FCC, FAA, ITU, UN COPUOS and national space-law instruments returned no requirement, anywhere, that an operator measure or report the atmospheric consequence of reentry.**

---

## 7. The ask

It rests only on what is established, and it survives every disagreement above — because the disagreement is the argument for it.

**Require the measurement.**

A regulator cannot act on a model whose sign is contested. An insurer cannot price one. But no party to that disagreement can argue that the quantity should remain unmeasured while the forcing is exactly countable, already detectable in the stratosphere at 10 ± 7% of particles, and the subject of a pending application for up to one million satellites.

Specifically, and none of it requires resolving the science first:

1. **Report mass and material, not a count.** The existing semi-annual filing already exists; extending it from an integer to a mass-and-composition inventory is a form change, not a new regime.
2. **Fund the measurement that already works.** PALMS on a high-altitude aircraft produced the 10 ± 7% figure from a single campaign. The instrument exists and the method is proven.
3. **Do not remove the only hook while the question is open.** Excluding space operations from NEPA, and waiving the Clean Air Act for launch and reentry, forecloses the review before the science has returned an answer.
4. **Publish the denominator.** The ablated-meteoric-aluminium baseline differs sevenfold across papers sharing authors. Until one is agreed, no ratio anyone quotes — including ours — is decidable.

---

## What this page does not claim

That any life was or will be lost. That any disaster is imminent. That any ecological harm is established. That the stratosphere reaches a saturation limit in any stated year — a saturation claim requires a capacity in the same units, and no published source states one. That incumbent models are wrong.

**A presented configuration is verified; an unknown configuration is not searched.**

*Every figure above is reproducible from this repository or quoted verbatim from a cited primary source. Corrections are recorded on the page rather than applied silently.*
