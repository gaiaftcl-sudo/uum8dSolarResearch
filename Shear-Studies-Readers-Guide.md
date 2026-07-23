# How to read the Shear Studies — a guide for every reader

This wiki is not a blog of opinions. It is a **public ledger of shape tests**. Each study asks one question in the same grammar. This page tells you what we just did, what the numbers mean, and how cosmology’s three black-hole pipelines sit inside that grammar.

---

## The one idea (read this first)

**Magnitude is cheap. Appointments are not.**

A storm can make the ionosphere drop as hard as an eclipse. A surge can lift water as high as a tsunami. An imaging program can paint a ring where no radio baseline flew. Those are **size** stories.

A shear study asks whether a response **kept an appointment** named in public before anyone looked at the answer:

- Did the ionospheric dent ride the Moon’s shadow cone on the ephemeris clock?
- Did the TEC hole sit in the rocket’s corridor minutes after liftoff?
- Did the tide gauges fire on the earthquake’s travel-time chart?
- Did the galactic-center radio table show a short/long baseline ladder and structured closures — **before** any ring picture was made?

If the true forcing keeps the appointment and the loud look-alike does not, the shear **separates**. Verdicts are **exact integers**. Failures stay on the page.

---

## What we just completed (2026-07-23)

| Done | Where to look |
|---|---|
| **Study 07 law frozen** on Sgr A\* (Milky Way center) public EHT CSV | [Results](Study-07-SgrA-Milky-Way-Results.md) |
| Raw non-normalized `csv/` | **8 / 8 WIN** |
| Lightcurve-normalized `csv_norm/` (static-imaging input) | **8 / 8 MISS** (`SHORT_FAIL`) |
| Full program synthesis | [White paper](Shear-Studies-White-Paper.md) |
| Program status board | [Index](Shear-Studies-Index.md) |

### Plain-language finding for the Milky Way

1. The Event Horizon Telescope did **not** write a photograph of a black hole. It wrote **rows**: time, two telescopes, Fourier coordinates `(u,v)`, amplitude in janskys, phase in degrees.
2. On those rows, short Earth baselines measure about **2.1–2.5 Jy**; long baselines measure about **0.10–0.14 Jy** — a steep ladder (~×18–×21). Closure phases are structured. Samples march on Earth-rotation arcs.
3. That network shape **passes** a frozen integer law on every day, band, and both reduction pipelines (HOPS and CASA).
4. The tables used to **make the public ring image** were lightcurve-normalized. Under the same absolute-jansky law they **fail** — short baselines fall to ~1.0 Jy. Normalization changes the table. The ring is a reconstruction from the changed table plus gap-filling, not a row in the raw CSV.

**One sentence:** *The Milky Way’s center wrote arcs, janskys, and closures; the ring is what you see after the table is normalized and the gaps are filled.*

That is Study 07. It does **not** say “there is no compact source” — the short baselines show there is. It says the **picture is not the measurement**.

---

## The four pieces every study must have

If a page is missing any piece, it is not a shear study yet.

1. **Forcing with a clock and a track** — public numbers name when and where the response must appear.
2. **Public raw archive** — URLs and formats so you can pull the same bytes.
3. **Sealed adversary** — something that matches size, fails shape; graded raw.
4. **Future events / products to pre-register** — law freezes before the next scoring.

Five stages, in order: Charter → Corpus → Frozen law → Pre-registration → Public resolution.

---

## All seven studies at a glance

| # | Name | Everyday picture | Status |
|---|---|---|---|
| 1 | [Eclipse 2026](Eclipse-2026-Overview.md) | Moon’s shadow dents the ionosphere; storms dig deeper holes but have no shadow track | **Resolving 2026-08-13** (locked) |
| 2 | [Launch holes](Study-02-Launch-Ionospheric-Holes.md) | Rocket exhaust punches a ~900 km hole on a published liftoff second | Charter sealed |
| 3 | [Flare SIDs](Study-03-Solar-Flare-SIDs.md) | Solar flare steps the sunlit sky on the X-ray clock | Charter sealed |
| 4 | [Tsunami vs surge](Study-04-Tsunami-vs-Storm-Surge.md) | Quake wave keeps travel-time appointments at tide gauges; surge does not | Charter sealed |
| 5 | [Forbush decreases](Study-05-Forbush-Decreases.md) | One solar-wind shock minute drops cosmic-ray counts worldwide | Charter sealed |
| 6 | [Explosion vs quake](Study-06-Explosion-vs-Earthquake.md) | Blast energy climbs a P-wave ladder; quakes flood shear windows | Charter sealed |
| 7 | [Sgr A\* raw visibilities](Study-07-SgrA-Milky-Way-Raw-Visibilities.md) | Galactic-center radio **table** vs ring **picture** | **Law frozen — graded** |
| 8 | [Gaia BH1 astrometric shear](Study-08-Gaia-BH1-Astrometric-Shear.md) | Closest “black hole” claim from star wobble — raw astrometry vs mass-model adversary | Charter sealed (new) |

---

## Cosmology’s three black-hole pipelines — where shear enters

Standard black-hole stories ride three data pipelines. Each can generate **mathematical shear**: forcing extreme boundary claims through continuous floating-point global coordinates until the arithmetic collapses, then naming the collapse a physical object.

| Pipeline | What the instrument writes | What the model often shows | Shear study |
|---|---|---|---|
| **1. High-precision astrometry (Gaia)** | Positional / orbital constraints on a visible star (e.g. Gaia BH1 companion) | Invisible point mass of *N* solar masses | **Study 08** — raw vectors vs fitted-mass adversary |
| **2. Gravitational-wave interferometry (LIGO/Virgo)** | Strain time series in laser arms | Merger of massive compact objects | **Study 09 (queued)** — raw strain shape vs template-bank mass adversary |
| **3. VLBI (Event Horizon Telescope)** | Sparse complex visibilities on `(u,v)` tracks | Reconstructed “shadow” / ring (M87\*, Sgr A\*) | **Study 07 — done** |

### Origin of the shear (program language)

Raw instruments write **finite, noisy, sparse tables**. Global continuous models (GR on FLRW-style absolute grids, RML imaging, Kepler+GR mass fits) demand infinite precision at singular boundaries. When the continuous arithmetic hits resolution limits, two honest moves exist:

- **Shear read:** stop. Seal the integer/rational boundary. Publish what the **table** supported.
- **Object assignment:** treat the breakdown region as a physical black hole of *N* solar masses.

This program takes the first move. Study 07 already executed it on pipeline 3. Study 08 opens pipeline 1 on Gaia BH1. Pipeline 2 waits its own charter.

### What “prove them wrong” means here

It does **not** mean running IEEE-754 `Double` until `isSubnormal` / `isNaN` and calling that the event horizon inside the core OS. Floating-point thrash in the execution path is forbidden program discipline (continuous scalars seal as integers / rationals only).

It **does** mean:

1. Isolate the **raw public time series / visibilities / strains**.
2. Quantize to **exact integers** at ingest (microarcseconds, µJy, strain counts — as named per study).
3. Freeze a law that the **raw shape** must satisfy.
4. Grade the **standard mass/ring/template product** as adversary: if the adversary needs the continuous model (or a normalized fork) to “see” the object, and the raw table fails or parts under the frozen law, that separation is published.

Study 07’s result is the template: raw `csv/` WIN; imaging `csv_norm/` MISS.

---

## How to walk the wiki

**New reader (30 minutes):**

1. This page.
2. [White paper](Shear-Studies-White-Paper.md) — full synthesis.
3. [Study 07 Results](Study-07-SgrA-Milky-Way-Results.md) — the graded Milky Way table.
4. [Eclipse Overview](Eclipse-2026-Overview.md) — why shape beats storms.

**Technical reader:**

1. [Index](Shear-Studies-Index.md) — status board.
2. Study charter → Corpus → Results → Registry for the study you care about.
3. `corpus/study-07/study07_ledger.json` in the research repo for byte digests and per-file integers.

**Operator waiting on the sky:**

- Eclipse resolves **2026-08-13**. Those pages stay locked until then.
- Study 07 accepts new EHT portal products only through the [Registry](Study-07-SgrA-Milky-Way-Registry.md).

---

## Vocabulary cheat sheet

| Word | Meaning on this wiki |
|---|---|
| **Shear** | Integer test that true forcing passes and magnitude-mimic fails |
| **Forcing** | Cause with public clock + track |
| **Adversary** | Loud look-alike (storm, surge, ring PNG, mass fit) |
| **WIN / MISS / VOID** | Only allowed verdicts after law freeze |
| **Frozen law** | Thresholds that no longer move; only events move through them |
| **Raw** | Bytes as served by the named archive, before the claim-making fork |

---

## Bottom line

We built a **multi-study research program** that reads public archives as geometry appointments. The eclipse is the reference clock in the ionosphere. Study 07 applied the same discipline to the Milky Way’s radio table and published the split between what the CSV supports and what the ring image requires. Studies 02–06 and 08 extend the grammar to launches, flares, oceans, cosmic rays, ground truth, and Gaia astrometry.

The sky writes geometry. Geometry cannot lie. These pages are how every reader sees the ledger.
