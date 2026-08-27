# Shear Studies — Roadmap

**What this page is.** On 2026-08-27 the program ran a full domain sweep — thirty candidate courts scouted across public archives from the summer's research record, each scored on lives, planet, electricity, and court-buildability, with the rejection reasons published as part of the yield. The sweep's verdict became **[Study 28 — Wet-bulb threshold court](Study-28-Wet-Bulb-Threshold-Court.md)**, chartered the same day. The ranking below is the sweep as it stood at that moment; statuses live on the [program index](Shear-Studies-Index.md), and this page is not updated when they change. Method and vocabulary are the program's own: a candidate ranks by whether a court can be built that is able to lose, on an archive anyone can pull, with verdicts in exact integers.

---

## The sweep — 30 scouted candidates, ranked

**Verdict: Study 28 is the WET-BULB THRESHOLD COURT.** It is the only candidate in the set where the exact-arithmetic claim *is* the life-safety verdict: the threshold is discrete, the inputs are already integers on the wire, the adversary is a named float regression with a **published** error band wider than the verdict, and the whole court runs off one no-auth archive with zero forecast dependency. Sealed census in days, checkable by anyone with a station id and a timestamp.

---

## 1. Master ranking

Score = (lives · planet · electricity) × court-buildability. Buildability dominates ties: a high-impact domain with a gated archive or no way to lose ranks below a modest one with a clean court.

| # | Candidate | Lives | Planet | Elec | Archive (auth?) | Way to lose | Rank basis |
|---|---|---|---|---|---|---|---|
| **1** | **Wet-bulb exact psychrometric key** | high | med | med | ISD, **none** | sharp | purest exact-vs-float verdict flip at a survivability threshold; one archive; fastest seal |
| **2** | **AMR genotype → dyadic MIC lattice** | **highest** | med | med | NCBI PD + NARMS + EUCAST, **none** | sharp | 1.14M attributable deaths/yr REPORTED; MIC is already a dyadic rational; ±1-dilution tolerance is textbook magnitude-mimics-shape |
| **3** | **Flash-flood gauge exceedance court** | high | low | low | NWIS + IEM VTEC, **none** | sharp, day-one | both sides federal records; verdict is string comparison; 135→≥8 dead is the rare measured lead-time experiment |
| 4 | Record-shear heat court (AI emulators) | **highest count** | high | med | ISD/GHCN + WB2, none | genuine | ≥10,000 European June deaths; adversary shear already peer-review-measured; Study 01's method transplanted |
| 5 | Ozaki-II integer FP64 emulation | indirect | med | **highest** | arXiv + ozIMMU, none | joules arm can kill it | strongest criterion (c); DOE adoption makes it policy-relevant now |
| 6 | ShakeAlert alert-geometry court | high | low | low | ComCat/FDSN/DYFI, none | event-by-event | 50M covered; aftershocks guarantee jury supply |
| 7 | AIS spoofing kinematic court | med | med | low | web.ais.dk daily CSV, none | two-sided | wire format is integer-native; a new raw file lands every day |
| 8 | Bit-exact inference replay court | indirect | low | **high** | arXiv + public emulator | two-sided | discrimination gate is explicit and runnable by anyone |
| 9 | Polio VP1 integer-divergence court | high | low | low | GPEI + NCBI Virus, none | four-way, no partial credit | WHO's own case definition is an integer inequality |
| 10 | Wastewater lineage demixing | med | low | med | NWSS + SRA, none | weekly | sum-to-one *forces* fabrication; honest output is a set |
| 11 | ClinVar integer ACMG point court | high | low | med | ClinVar dated FTP, none | cleanest cadence | monthly archived releases = pre-registration for free |
| 12 | UCMR5 PFAS fingerprint court | high | high | low | EPA UCMR5, none | one-shot | half-MRL substitution is fabricated magnitude; but the clock closes this fall |

---

## 2. Top 3 in detail

### RANK 1 — WET-BULB EXACT PSYCHROMETRIC KEY

**Summer-2026 result, sourced.** Japan/Korea July 2026 humid heat: **≥79 dead, >41,000 heatstroke hospitalizations** (phys.org, aa.com.tr); Yangsan ROK **42.5 °C**, highest in 122 years of record (CBC). Gulf/South-Asia coverage (Environment+Energy Leader 2026) documents wet-bulb spikes with no overnight recovery; Gulf stations have logged **T_W > 31 °C** in top-0.1% events (Nature *Comms Earth & Env*). The instrument defect is published by the instrument's own authorities: **NWS SR 90-23 states no true heat-index equation exists** — the operational number is the Rothfusz float regression; the Stull wet-bulb formula carries a stated band of **−1.0 to +0.65 °C** (Stull 2011; MDPI *Atmosphere* 13:1765). Near 31–35 °C survivability and near WBGT/OSHA work-stop cuts, that band is **verdict-sized**.

**Court design.**

| element | design |
|---|---|
| **Clock** | presented-configuration replay over all of 2026, plus the next Gulf/South-Asia/East-Asia humid-heat emergency as the pre-registered forward event |
| **Track** | every station-hour on Earth: integer-tenths (T, T_d, P) with QC flags |
| **Archive** | `https://www.ncei.noaa.gov/data/global-hourly/` — **no auth**, integer-native, global. The `access/2026/` directory is not yet posted (measured 2026-08-27, three independent ways); prior years are served in full, and the season criterion is frozen now to be graded when 2026 appears. Nothing else required. Psychrometric (Magnus/ASHRAE) coefficients are published rationals |
| **Adversary (named)** | Stull 2011 single-expression T_W; Rothfusz heat-index regression; the iterative float psychrometric solvers in HVAC and app pipelines. All track T_W to ~1 °C **everywhere** (magnitude) and fail **at the threshold boundary** (shape) |
| **Integer verdict** | T_W by rational root-bracketing on the psychrometric identity from integer inputs — bounded, exact, identical on every machine. Verdict per station-hour: crossed / not crossed. No rounding step exists |
| **Discrimination gate** | the flip census must be **non-empty at mortality-relevant thresholds and empty at innocuous ones**. A census that flips everywhere is a turn counter; a census that flips nowhere is an empty court. Both graded as loss |

**Impact case.** (a) Heat-health warning activation, Gulf midday-work bans (HRW 2025 flagged them inadequate for millions of migrant workers), athletic and military WBGT stand-downs all trigger on this computed number — a formula-dependent verdict at the threshold is a formula-dependent death. (b) The exact global crossing census is the honest habitability record as T_W 35 °C approaches, currently blurred by approximation choice. (c) Every weather app, HVAC controller and occupational-safety stack re-implements one of these regressions — the law written twice, at planetary scale; one exact rational key computed once per station-hour retires them all checkably.

**What makes it LOSE.** If the 2026 sweep confines verdict flips to hours nowhere near a mortality-relevant threshold (all flips at T_W < 25 °C), the published band is real and harmless and the court is empty where it matters. Second, pre-registered: the next humid-heat emergency must contain flip-hours **at** threshold, at stations in the casualty window, or the practical-stake claim is dead. Third: if the exact key and every float formula agree on every threshold hour in 2026, exactness bought nothing here.

**Honesty bar applied.** The court renders a verdict about the **instrument**, never about physiology, and makes no claim that exact arithmetic replaces heat-stress modelling.

---

### RANK 2 — AMR GENOTYPE → PHENOTYPE ON THE DYADIC MIC LATTICE

**Summer-2026 result, sourced.** medRxiv 2026.03.24.26349209 (24 Mar 2026): systematic review + meta-analysis of Vitek 2 / Phoenix / MicroScan finds **organism- and drug-specific very-major-error patterns that diverge by instrument** (Vitek 2 higher relative VMEs on gram-negatives, Phoenix the opposite) and calls for continued breakpoint monitoring on all three. WHO GLASS 2025 (pub. Oct 2025): **1 in 6** lab-confirmed common bacterial infections resistant in 2023 across **>23 million** confirmed infections, 104 countries; resistance rose in **>40%** of monitored pathogen–antibiotic combinations 2018–2023 at 5–15% relative annual increase. GRAM/GBD (*Lancet*, Sep 2024): **1.14M deaths attributable, 4.71M associated (2021)**; forecast **1.91M / 8.22M by 2050**; **39M cumulative attributable 2025–2050**.

**Court design.**

| element | design |
|---|---|
| **Clock** | NCBI Pathogen Detection ingests and re-clusters continuously; every isolate carries a collection date and BioSample accession. Freeze date D; grade isolates added after D whose phenotype is not yet public |
| **Track** | per isolate: exact resistance-determinant set (allele keys + point-mutation keys) → predicted integer lattice index per drug → EUCAST category |
| **Archive** | `ftp.ncbi.nlm.nih.gov/pathogen/Results/`, RefGene catalog, AMRFinderPlus (github.com/ncbi/amr), NARMS Now integrated data, EUCAST free machine-readable breakpoints. **No auth anywhere.** CLSI M100 is paywalled → **EUCAST is the court's breakpoint source, CLSI is not used** |
| **Adversary (named)** | ML MIC-regression graded by **"essential agreement within ±1 doubling dilution"** — a magnitude tolerance structurally blind to the only change that alters therapy, the S/I/R flip. A model posts 95% essential agreement while every miss is a very major error, because ±1 dilution straddles the breakpoint exactly where the breakpoint sits |
| **Integer verdict** | broth-microdilution MICs are **dyadic rationals on a doubling lattice** — every MIC is integer index n, every breakpoint an integer cut. Integer in, integer out, no float anywhere |
| **Discrimination gate** | grade on **category agreement, never essential agreement** — the tolerance is the adversary and must not be borrowed. Any very major error is a loss for that drug–bug pair |

**Impact case.** (a) A very major error is one patient given a drug the organism eats; the burden numbers above are the exposure. (b) NARMS food-animal isolates (Salmonella, *C. jejuni*, *E. coli*/Shigella, 2015–2025, poultry/cattle/swine) make the same court an agricultural-resistance instrument. (c) Per-instrument, per-site retraining of float MIC regressors — which the March 2026 meta-analysis explicitly demands more of — is compute spent re-deriving a lattice index that an exact determinant lookup fixes deterministically and identically on every machine. Constraint 5 territory: two labs must reach the same conclusion from the same isolate.

**What makes it LOSE.** Isolate-batch pre-registration: seal predicted lattice index, EUCAST category, and the exact determinant set claimed to force it, before phenotype release. Loss on any VME. **The honest loss**: if the exact-key method must answer "the determinant set does not determine the category here" more often than the float regressor beats chance, the exact structure is not carrying the signal and the candidate falls — no retro-fitting the determinant panel.

**Honesty bar applied.** The court predicts a **laboratory category**, not a clinical outcome. No efficacy claim, no treatment recommendation — test claim, not efficacy.

---

### RANK 3 — FLASH-FLOOD GAUGE EXCEEDANCE COURT

**Summer-2026 result, sourced.** July 2026 Texas Hill Country floods: **≥8 dead** (ABC News), one year after July 2025's **135 dead** in the same terrain — and the delta is attributed **in print** to warning infrastructure, with Kerrville's fused rainfall/river/streamflow dashboard credited by the mayor as having saved lives (Texas Tribune 2026-07-17; PBS). Buckhannon WV 2026-07-22: **4.5 in in 37 min, 2 dead**, National Guard deployed (CBS). Sunglow Campground UT 2026-07-17: a Provo fire captain and a family of four killed. Incumbent baseline defect, published by the incumbent: **roughly one-third of NWS flash-flood warnings are false alarms** (NWS Baltimore/Washington). NSSL's July 2026 "Sudden Danger" essay frames flash-flood forecasting as the open problem.

**Court design.**

| element | design |
|---|---|
| **Clock** | convective season, plus autumn-2026 hurricane remnants; every warning issuance and expiry is a timestamped federal record |
| **Track** | NWIS instantaneous gauge height in **hundredths of feet** (exact scaled integers), 5–15 min cadence, thousands of gauges; published integer flood-stage thresholds per gauge |
| **Archive** | `waterservices.usgs.gov/nwis/iv/` (no auth), `water.noaa.gov` thresholds, and every warning polygon with issuance/expiry archived by Iowa Environmental Mesonet: `mesonet.agron.iastate.edu/vtec/` + GIS dumps. **Both sides of the court are no-auth federal records** |
| **Adversary (named)** | the Flash Flood Guidance / QPF float pipeline behind the warnings — mimics rainfall magnitude, fails basin-time shape; measured as the ~1/3 false-alarm ratio and as zero-lead-time events |
| **Integer verdict** | warning issued T1 for polygon P; gauge G inside P crossed its integer flood-stage threshold at T2 or never. Hit / miss / false alarm / lead-time-in-minutes — all decidable by string-exact comparison. **No float enters the court** |
| **Discrimination gate** | the pre-registered integer rate-of-rise ladder (crossing called from the gauge's own discrete derivative) must beat the archived warning lead time on out-of-sample autumn-2026 crossings **and** hold its false-alarm rate below a sealed ceiling on the healthy population of non-flood gauge-days |

**Impact case.** (a) 135 vs ≥8 dead in one terrain across one year is the rare natural experiment where lead time's mortality value is REPORTED in print; flash floods are a top-2 US weather killer. (b) The identical gauge network and identical court extend unchanged to ecological low-flow and flow-extreme thresholds. (c) A 1/3 false-alarm ratio is the always-red instrument defect at national scale with a body count — and it trains the public to ignore warnings. An exact contingency ledger, every row a string-checkable pair of federal records, is undisputable by the agency that produced both halves.

**What makes it LOSE.** (1) If the sealed 2026 ledger shows warning performance at gauged basins is already excellent (high POD, lead time dominated by hydrology not guidance), the indictment collapses and we seal that. (2) The rate-of-rise ladder can simply lose out-of-sample. (3) **Day-one testable limiting fact**: the deadliest 2025–26 events hit reaches upstream of or between gauges — if the fatal-event set is systematically ungauged, the court is real but trying the wrong defendant, and it must shrink or die rather than be defended.

---

## 3. Shortlist — runners-up, one line each

- **Record-shear heat court (AI emulators)** — the natural Study 29: ≥10,000 European June deaths REPORTED, adversary shear already measured in *Science Advances* (arXiv:2508.15724), integer-tenths ISD truth; ranks 4th only because its own loss arm concedes exactness may add nothing at the tenths boundary while the shear is already peer-reviewed.
- **Ozaki-II integer FP64 emulation** — the strongest criterion-(c) court in the set (2.3× over native FP64 on Blackwell REPORTED, DOE Genesis Mission adopting it, open ozIMMU code, byte-identical digest verdict); held at 5 because the joules arm is unmeasured and speedup is not joules.
- **ShakeAlert alert-geometry court** — 50M people covered, $14.7B/yr annualized US quake loss (FEMA P-366), integer DYFI/MMI and station PGA in milli-g, aftershocks guarantee jury supply; distinct from board study 06, which grades waveform discrimination not alert geometry.
- **AIS spoofing kinematic court** — the cleanest integer-native archive in the whole set (position in 1/10000 arc-min, daily no-auth CSV drops covering the Baltic theater), Front Eagle/Adalynn collision with 24 crew evacuated; lives count is modest against the top three.
- **Bit-exact inference replay court** — rounding error as hardware signature (arXiv 2606.00279 + public emulator), byte-equality verdict, explicit two-sided discrimination gate; criterion (c) only, and it shares an adversary class with Ozaki.
- **Polio VP1 integer-divergence court** — WHO's own VDPV definition is an integer inequality (≥6 nt VP1 for serotype 2, ≥10 for 1 and 3), four-way pre-registration with no partial credit; gated to runner-up because GPLN sequence deposition trails the weekly detection tables by months.
- **Wastewater lineage demixing** — sum-to-one non-negative LAD **forces** the solver to fabricate an abundance on a non-identifiable ray, and the honest exact output is a set including the empty set; weekly cadence, clinical referee, one rung below on lives.
- **ClinVar integer ACMG point court** — Tavtigian/ClinGen classification is already an integer sum that the field then launders through a recalibrated float (5–6% missense VUS reclassification, GIM Open 2026); best pre-registration cadence on the board, lives real but downstream of a diff.
- **UCMR5 PFAS fingerprint court** — half-MRL substitution is fabricated magnitude where the honest answer is non-detect, 136M Americans on detection-positive systems REPORTED; one dated future forcing (final release, fall 2026) and then the archive closes.
- **Best-track integer RI court** — ATCF a-decks/b-decks are the cleanest forecast-vs-truth archive in geophysics and already integer knots; a 55%-below-normal season (NOAA, maintained at the August update) may seat no jury.
- **Operational weather at reduced precision (ICON GPU / IFS single)** — daily clock forever and sourced electricity (~40% IFS cost bought by precision drop; 5.5× ICON socket-to-socket, GMD 19:755 2026); overlaps the record-shear court's archive slice and must be run after it, not beside it.
- **Fire detection ladder** — 489,826 ha EU burned by week 31 and 25+ dead in Spain REPORTED, discrete FIRMS detection ladder vs FWI's absent event axis; FIRMS archive pulls need a registration key and VIIRS cadence may not separate blowup from background.
- **Iberian 0.63 Hz oscillation court** — ENTSO-E's own final report (2026-03-20) makes model-vs-measurement divergence the published verdict, 7–9 dead and €800M–€1.6B REPORTED; PMU-grade waveforms are TSO-private and the public 1–50 Hz recordings may lack the bandwidth to resolve the growth phase.
- **PJM heat-wave forecast-miss court** — 5,400 MW same-day divergence at a record attempt, archive already integer MW; demand response contaminates the actual and hourly public DR data may not decompose it.

---

## 4. Rejected — one line each (the rejection reasons are the yield)

- **Cloudburst / South Asia monsoon** — IMERG is the only truth source at cloudburst resolution and it is Earthdata-login gated; fails recipe criterion (2) as written, and a scraped copy becomes the only copy.
- **US measles chain-identity court** — the criterion is exactly right (one lineage, twelve months, integer month count) but WHO MeaNS is access-controlled and the open N-450 path is too thin to partition 2026 chains; withdraw rather than run it on case counts.
- **Drug-shortage NDC graph** — the API-holder-to-finished-dose-site edges are not public, so the court cannot beat the null "every sole-source NDC is at risk"; self-flagged weakest archive and correctly so.
- **Price of non-associativity energy ledger** — the falsifiable object is the redundant-recompute *fraction*, and **no published measurement of it exists**; standing it up as a study means inventing the number. Keep the sourced TWh totals as the program's electricity denominator, not as a court.
- **Halo rational-arithmetic architecture** — January 2026, outside the summer window, one paper, and the capability claim has no independent replication; it is corroboration of Constraint 3, not a study.
- **Data-center 3.1 GW mass-disconnect** — PJM's public feed is seconds-to-minutes and archived at 5-min, so the 30-second cliff lives only in NERC figures; the court would replay the regulator's own plots and call it a measurement.
- **Curtailment waste ledger** — curtailment is a dispatch decision, so the court can lose to a memo (new battery fleet, constraint re-rating); weakest forcing in the set despite 8 TWh/yr ERCOT curtailment REPORTED.
- **H5N1 genotype / marker court** — the adversary is expert-elicited IRAT/TIPRA floats, which is a soft defendant, and the marker panel may not discriminate the isolates that infected humans from those that did not — a coordinate statement, not a space statement.
- **RNA 3D Leontis-Westhof base-pair court** — CASP17 third-party sequestration is the strongest sealing mechanism on the list, but criterion (a) is second-order and it sits nearest to board study 14; run it only as an explicit low-priority extension.
- **BF16 leaderboard shear** — a real court with an integer Hamming verdict, but same archive class and same adversary as the bit-exact replay court; fold it in as that court's second arm rather than seating it separately.
- **Climate ensemble-consistency / "can we switch computers"** — the field's own 2026 admission is excellent evidence, but migrations are rare, the integer coarse-graining ladder is synthetic rather than native to the archive, and no standing cadence exists.
- **USDA crop-yield shape court** — the release calendar is the best clock in the set and the data are exact, but "state-ranking shape" is a court design we invented rather than one the domain already renders; dollars, not lives.
- **LL84/LL97 degree-day court** — ENERGY STAR being an unreproducible float that assigns $268/tCO2e fines is a genuine indictment, but the clock is annual (grade in May 2027) — the slowest cadence on the board.

---

## 5. Honest limits — what was struck, explicitly

- **No efficacy claims.** The AMR court predicts a laboratory S/I/R category and an integer lattice index; the ClinVar court predicts an integer point total and a band. Neither claims a patient outcome. Test claim, not efficacy — the study-20 lineage.
- **No wholesale replacement of physical simulation.** The record-shear, ICON-precision and Ozaki courts grade **verdict flips and replayability**, not physics substitution. Exact arithmetic answers the *verdict* once and checkably; it does not stand in for the atmosphere.
- **Electricity numbers kept only where sourced.** Retained: IEA 415 TWh (2024) → 945 TWh (2030); 485 TWh data centres 2025 (IEA); ~200 TWh/yr data-centre + HPC (MBE 2022, PMC8892942); ~40% IFS cost reduction from double→single (ECMWF); 5.5× ICON socket-to-socket (GMD 19:755, 2026); INT8 ~0.2 pJ vs FP64 FMA ~26.7 pJ. **Dropped**: the "~0.6 GWh per event" surplus derivation (arithmetic on a press figure, not a reported measurement) and the redundant-recompute attribution fraction (no published measurement as of 2026-08-27).
- **Duplicate check against the 27.** None of the top 12 duplicates a board study. Adjacencies declared: RANK 3 and study 04 share no archive (gauge stage + VTEC polygons vs tsunami/surge); the two compute courts sit beside studies 22–25 on a different archive (live commercial inference and GPU arithmetic, not complexity theory); the best-track court deliberately stops at the intensity/track ladder and touches no coastal-water physics.

---

## Open decisions before the next mint

1. **Registration-gated archives: admitted or not?** The cloudburst candidate (226+ REPORTED dead, largest exposed population in the set) and the fire ladder's archive pulls both turn on this one ruling. The program's standing read holds the line at no-auth; the ruling rests with the program's steward and is recorded here when made.
2. **Whether Study 29 is pre-committed now.** The record-shear heat court and the wet-bulb court share the ISD archive, so running 28 first buys 29's ingest for free — a single ruling seals both charters against one archive lane.
3. **Whether the Ozaki court jumps the queue on criterion (c).** DOE is adopting integer FP64 emulation as policy this year; the window where a sealed joules-per-correctly-rounded-DGEMM measurement is novel is open now and closes when someone publishes it.