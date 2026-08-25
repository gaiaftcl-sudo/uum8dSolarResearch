# Study 10 — Fermi Gamma Shear: the 43 GeV line and why dark-matter annihilation is not possible

**Status: CHARTER WITH ARCHIVE — 2026-08-20** — named HEASARC weekly photon FITS + paper. No keV ingest. Not OPEN. Edge word on mass: *not known*.  
**Paradigm:** [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm) · [Program index](Shear-Studies-Index)

---

## For every reader — one paragraph

NASA’s Fermi telescope recorded photons for 15.5 years. A team stacked Virgo, Fornax, and Ophiuchus, ran continuous likelihood math, and reported a ~**43.2 GeV** gamma-ray “line” as a dark-matter candidate. The same line is **absent** in the center of the Milky Way — where dark matter should be densest and brightest. That silence is the proof cut: **if the energy did not come from the middle, canonical dark-matter annihilation did not produce this release.** The stack is continuous shear. The lattice grades the appointment.

Paper: Fan, Shen, Liang et al., arXiv:2407.11737 / Phys. Rev. Lett. (DOI 10.1103/lq5r-sjp7). New Scientist coverage: the signal “vanishes closer to the centre of our galaxy.”

---

## The shear recipe (this study)

| Piece | Instantiation |
|---|---|
| **Forcing / track** | Sky cones on Virgo, Fornax, Ophiuchus (Liang ROIs) + **Inner Galaxy 3°** control + Earth-limb null control |
| **Clock** | MET integer seconds on weekly LAT photon files |
| **Raw archive** | [HEASARC weekly photon FITS](https://heasarc.gsfc.nasa.gov/FTP/fermi/data/lat/weekly/photon/) — ENERGY (→ integer keV), RA/DEC (→ milli-deg), TIME (MET Int64) |
| **Adversary** | Stacked unbinned-likelihood 43 GeV DM line product (Virgo+Fornax+Ophiuchus collective PDF/smooth path) |
| **Law (to freeze at corpus)** | Inner Galaxy sealed energy-window count ≤ null floor **AND** cluster-only continuous product does not license a density² annihilation object when the middle is silent |

**Verdict language:**

- **WIN (lattice):** Inner Galaxy null holds under frozen integers; cluster raw counts do not require synthetic mass  
- **MISS (adversary):** claiming DM particle mass from the stacked line while the middle is silent  
- **VOID:** incomplete weekly inventory

Ingest: dedicated `corpus/study-10/` only — quantize once — **never** float-thrash into core OS or NATS (Study 08 rule).

---

## Why the middle null ends canonical DM here

Canonical annihilation ∝ ρ² (J-factor). The Inner Galaxy is the expected peak. Liang selected Virgo/Fornax/Ophiuchus for **highest cluster J-factors**, then measured **null** in the inner ~3° Galactic center (and Earth limb).

| Site | Expected under canonical DM | Measured (paper) |
|---|---|---|
| Virgo + Fornax + Ophiuchus (stacked) | Line | TS≈30 (~4.3σ global, their MC) |
| Inner Galaxy | **Brightest** line | **Null** |
| Earth limb | Instrument control | **Null** |

**Sealed reading:** energy of this gamma release is **not** from dark-matter annihilation in the middle. Canonical DM as the source of this line is **not possible**.

UUM-8D names the rest: \(c^4\) is **`c4EntropyCap`** — entropy bound on discrete transitions — not a continuous divisor that summons mass into \(T_{\mu\nu}\).

---

## Success criteria

- **S1** — SHA-256 inventory of weekly LAT files used; integer quantization rules sealed  
- **S2** — Frozen Inner Galaxy null floor dated before adversary scoring  
- **S3** — Adversary (stacked 43 GeV DM product) graded MISS when middle null holds  
- **S4** — Per-cluster (no stack) strata published raw — Smirnov collective-noise caution sealed as a control  
- **S5** — Earth-limb control remains null under the same integers  

---

## Relation to sealed sisters

| Study | Same grammar |
|---|---|
| [07 — Sgr A\*](Study-07-SgrA-Milky-Way-Results) | Raw table WIN · processing fork MISS |
| [06 — explosions](Study-06-Explosion-vs-Earthquake-Results) | Integer appointment · adversary miss |
| [08 — Gaia BH1](Study-08-Gaia-BH1-Astrometric-Shear) | Fitted-mass narrative as adversary |

---

## Cited 2026-08-24 — CMZ slim filaments are not this shear

Study 07's sky (Sgr A\* / the Central Molecular Zone) now carries a **cited** ALMA observation: Yang et al., A&A **694** A86 (2025-02-01), fetched **2026-08-24** — slim filaments, SiO 5–4 plus eight 1.3 mm lines, paper bounds long **>0.5 pc** and narrow **<0.03 pc**, in the 20 and 50 km s⁻¹ clouds. Full table and architectural reading live on [Study 07](Study-07-SgrA-Milky-Way-Raw-Visibilities.md#cited-2026-08-24--alma-slim-filaments-in-the-cmz-not-a-court).

That observation is **not** a keV ingest. Fermi / 43 GeV is a different shear. Filaments do not bind this charter's Inner Galaxy null, and this charter does not grade filament length, width, or position angle. When continuous MHD cannot hold a slim filament, some astronomers reach for dark-matter “glue” as the **adversary narrative** — the lattice does not yet grade that. Honest edge word on mass is ***not known***. Next increment on the filament side is court bind on Study 07 when keys exist — do not stub a court, and do not POST filaments into `physics`.

---

**Status: CHARTER WITH ARCHIVE — named HEASARC weekly photon FITS + paper. No keV corpus on the lattice. Data cited, not ingested. Claim on apex is not served yet. Edge word on mass: *not known*.**
