# Study 08 — Gaia BH1: raw astrometric appointments vs the fitted-mass adversary

Gaia BH1 is sold to the public as “Earth’s closest black hole”: a dark companion of order ten solar masses, hundreds of parsecs away, inferred from the wobble of a visible G-type star. The instrument did not photograph a horizon. It wrote **astrometric and spectroscopic constraints** — positions, proper motions, parallax, radial velocities, and (where published) epoch series — which continuous orbital models then fit to a point mass.

This study runs the shear recipe on that claim. The **forcing** is the observational sampling clock (Gaia scanning law + ground RV epochs). The **response** is the raw public time-series / catalog vectors with Newtonian and Einsteinian mass models stripped at ingest. The **adversary** is the published orbital solution that assigns *N* solar masses and an “event-horizon-scale” narrative to the invisible point. The shear asks whether the **table’s shape** supports that assignment as an appointment, or whether the mass object appears only after continuous global fits push past the sealed integer resolution of the measurements.

Study 07 already executed the same split on pipeline 3 (EHT): raw visibility CSV WIN; imaging-normalized fork MISS. Study 08 opens pipeline 1 (Gaia astrometry). See [Readers’ guide](Shear-Studies-Readers-Guide.md) · [White paper](Shear-Studies-White-Paper.md) · [Study 07 Results](Study-07-SgrA-Milky-Way-Results.md).

> [!NOTE]
> Sourcing: **VERIFIED** = fetched live by this program on the stamp date; **REPORTED** = taken from published papers / archive docs at abstract level. Gaia BH1 discovery paper: El-Badry et al. 2023, MNRAS (REPORTED). Gaia source identifier for the luminous star is recorded at corpus ingest from the paper + ESA archive cross-match and sealed into the inventory — not guessed at grading time.

---

## What every reader should see

| Layer | What it is |
|---|---|
| **Instrument layer** | Gaia (and RV partners) measured a **star that moves** on the sky and in line-of-sight velocity. |
| **Model layer** | Continuous Kepler / GR fits assign an invisible companion mass and call it a black hole. |
| **Shear question** | Do the **raw integer-quantized vectors** keep an appointment that requires that mass object, or does the mass appear only inside the floating-point fit? |

Same grammar as the eclipse (storm vs shadow) and Sgr A\* (CSV vs ring).

---

## The forcing and its clock

- **Clock.** Gaia field-of-view transit times under the commanded scanning law; RV epoch timestamps from the spectroscopic programs named in the discovery paper. Binning sealed as integer seconds from a named JD epoch.
- **Track.** The luminous star’s path on the celestial sphere — right ascension / declination residuals vs a sealed reference, quantized to **integer microarcseconds (µas)** at ingest by decimal-string rules (same discipline as Study 07’s µJy). Radial velocity quantized to **integer meters per second**.
- **Independence.** Mass, inclination, and black-hole labels are **not** inputs to the forcing. They belong to the adversary.

---

## The response archive

| Archive | Role | Auth | Sourcing |
|---|---|---|---|
| [Gaia ESA Archive](https://gea.esac.esa.int/archive/) — `gaiadr3.gaia_source` + DataLink products for the sealed `source_id` | Mean astrometry; epoch photometry where DataLink serves it | Archive account as ESA requires | REPORTED — ingest VERIFIED at corpus stage |
| Discovery / follow-up supplementary tables (El-Badry et al. 2023 and named RV programs) | Epoch RV and any published epoch astrometry used in the mass fit | None for journal supplements when public | REPORTED at charter; SHA-256 at corpus |
| Scanning-law / observation-time tables as published by Gaia | Sampling clock for confinement windows | None / archive | REPORTED |

**Honest archive limit (chartered):** Gaia DR3 does not publish full epoch astrometry for all sources the way EHT publishes visibility CSV. Where only mean astrometry + RV epochs exist publicly, the Form grades **that** public surface and marks missing epoch-astrometry strata `VOID-by-inventory` — never invents points. If a later Gaia release publishes epoch astrometry for the source, it enters through the Registry before scoring.

---

## The adversary

| Adversary product | Why it mimics |
|---|---|
| Published BH1 orbital solution (*N* M☉ dark companion, period, eccentricity) | Matches the **amplitude** of the star’s wobble with a point mass |
| Popular “closest black hole” distance × mass narrative | Magnitude story for the public |

**Why shape defeats it.** The shear does not ask “is the wobble large?” It asks whether the raw integer series is confined to sampling appointments and phase structure that a **mass-free** sealed null (periodogram controls, phase-scrambled RV, binary models without a horizon-scale compact object) fails — while the published mass fit is graded as a **processing adversary**: if the compact-object claim requires continuous GR/Kepler iteration past the sealed µas / m·s⁻¹ resolution, that dependence is published as MISS on the adversary surface, exactly as `csv_norm` MISS’d in Study 07.

> [!WARNING]
> Capturing IEEE-754 `isSubnormal` / `isNaN` inside the core OS is **not** a seal. Continuous float thrash is outside the grading path. The sealed proof is integer appointments on the public table vs the fitted-mass product.

---

## Execution path — ingest (answered)

**Question:** pull raw Gaia DR3 into bare-metal core memory, or through NATS JetStream, so float thrash does not destabilize the OS?

**Answer — neither for float thrash.**

| Path | Verdict |
|---|---|
| Bare-metal core OS memory for IEEE float unrolling | **Forbidden** — continuous `Double` thrash must not enter the core execution path |
| NATS JetStream as a dump for float thrash | **Forbidden** — NATS carries sealed messages / mesh replication, not arithmetic noise |
| **Dedicated corpus ingest** (Study 07 pattern) | **Required** — `corpus/study-08/` directory; download → SHA-256 → integer µas / m·s⁻¹ quantization → `study08_ledger.json` → wiki Corpus/Results |
| NATS after grade | **Allowed** — publish WIN/MISS/VOID seal rows to the mesh once integers exist |

Concrete sequence:

1. Isolate raw vectors into `corpus/study-08/` (not into the core actor heap as `Double` state).
2. Map shifts as **integer residual series** (µas, m·s⁻¹) with sealed binning — the localized manifold read is on those integers, not on subnormal floats.
3. Freeze thresholds from the historical/control envelope; seal.
4. Grade the published mass solution as adversary; publish MISS/WIN raw.
5. Only then emit a NATS seal if the mesh is live.

---

## The shear metric (to freeze at corpus)

1. **Confinement** — residuals inside sealed sampling windows; out-of-window structure grades as control.
2. **Traveling / phase lag** — orbital phase structure keyed to the sealed period **from the data’s own integer periodogram peak**, not from the adversary’s mass.
3. **Adversary gap** — recompute the published *N* M☉ claim’s required residual amplitude in sealed integers; WIN on raw shape does not license the horizon object; adversary MISS if the compact-object label needs continuous fit beyond sealed resolution.

Exact thresholds: derived at corpus ingest, then frozen — same road as Study 07.

---

## Success criteria

- **S1** — Integer ingest + SHA-256 inventory for every public file used.
- **S2** — Frozen law dated before adversary mass scoring.
- **S3** — Adversary (published BH1 mass solution) graded; MISS/WIN published raw.
- **S4** — Next Gaia data release / updated BH1 solution pre-registered on the Registry page.

---

## Honest limits

- Not a substitute for full binary-population statistics.
- Not a claim that the luminous star does not wobble — the wobble is the table.
- Not an IEEE autopsy inside the OS kernel.
- Epoch-astrometry gaps are VOID-by-inventory, not filled by the mass model.

---

**Status: OPEN — charter published, corpus not yet ingested. Ingest path sealed above: dedicated corpus → integers → ledger; NATS only post-grade.**
