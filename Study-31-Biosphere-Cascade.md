# Study 31 — The Biosphere Cascade Court

**Page class: CHARTER.** Law frozen 2026-09-01, before the chain was multiplied. Every link carries an evidence grade defined in [the ontology](Ontology). Producing program: `reproduce/biosphere-cascade-chain.swift`.

**Status: LAW FROZEN · FIRST RESULT SEALED 2026-09-01.**

---

## Why this court exists

Every other study on this wiki grades a single instrument against a single question. This one grades a **chain**.

The reason is that the atmospheric literature is organised link by link. One group models injection into the stratosphere. A different group models ozone response. A third field studies UV and marine biology. **Each link is competently studied and nobody multiplies them**, so no published number exists for the thing a person actually wants to know: what does this do to the biosphere.

That gap is not a conspiracy. It is what happens when a question spans four disciplines and no funding line spans them. But the consequence is that the cascade is unexamined, and this court examines it.


## The ingested baseline — a measured healthy sky

**Status: CORPUS INGESTED 2026-09-01. LAW FROZEN. Control arm passed.**

Every other study in this programme ingests a real corpus before it grades anything. This one now does too. Producing program: `reproduce/ozone-baseline-and-state-change.swift`. Corpus: `corpus/study-31/`, pinned by sha256, provenance in `PROVENANCE.md`.

**Source:** NOAA Global Monitoring Laboratory Dobson spectrophotometer total-ozone archive, fetched anonymously — no account, no key. **56,575 daily observations, five stations, 1963–2026, spanning 89.9°S to 71.3°N.** Stations were chosen to span latitude, not to favour a result.

**The zero-float property:** `Total_Ozone` is published in Dobson Units at exactly one decimal place, so it is ingested as an exact integer count of **deci-Dobson** (`276.0 DU` → `2760`). No floating-point value is constructed anywhere between the archive file and the verdict. **21,618 rows admitted, 0 refused.**

### The healthy range, as five instruments actually recorded it

Taken from the **pre-1980** record — before the CFC depletion the Montreal Protocol was written to stop — so the healthy sky is measured rather than assumed.

| station | latitude | n | p05 | median | p95 | healthy range |
|---|---|---|---|---|---|---|
| Barrow, Alaska | 71.32 N | 941 | 268.0 | **337.0** | 454.0 | 268.0–454.0 DU |
| Boulder, Colorado | 40.02 N | 3,051 | 267.0 | **310.0** | 386.0 | 267.0–386.0 DU |
| Mauna Loa, Hawaii | 19.53 N | 3,839 | 237.0 | **266.0** | 296.0 | 237.0–296.0 DU |
| Tutuila, Samoa | 14.25 S | 1,154 | 239.0 | **254.0** | 271.0 | 239.0–271.0 DU |
| Amundsen-Scott, South Pole | 89.90 S | 1,961 | 247.0 | **304.0** | 383.0 | 247.0–383.0 DU |

### The control arm — the instrument must be able to see a real loss

Before projecting anything, the ingest has to demonstrate it can detect a depletion that actually happened. The Montreal-era loss is the known case.

| station | healthy median | 2015+ median | change |
|---|---|---|---|
| Barrow, Alaska | 337.0 DU | 365.0 DU | **+8.3%** |
| Boulder, Colorado | 310.0 DU | 303.0 DU | −2.2% |
| Mauna Loa, Hawaii | 266.0 DU | 263.0 DU | −1.1% |
| Tutuila, Samoa | 254.0 DU | 249.0 DU | −1.9% |
| **Amundsen-Scott, South Pole** | 304.0 DU | 255.0 DU | **-16.1%** |

**CONTROL ARM PASSES.** The ingest independently recovers the Antarctic ozone depletion at **-16.1%**, from raw instrument rows, with no model involved and nothing about ozone chemistry encoded in the parser. **And Barrow returns +8.3%** — the instrument does not simply report loss everywhere, which is what an always-red detector would do. It discriminates.

### The state change, applied to the measured baseline

Worked at Boulder, whose healthy median is **310.0 DU** and whose healthy 5th percentile — the low end of a normal sky — is **267.0 DU**.

| filed scenario | global mean | regional ×12 | Boulder median becomes |
|---|---|---|---|
| authorised 19,408 | 0.3% | 3.6% | 298.9 DU |
| **Gen3 filed 100,000** | 1.3% | 15.6% | **261.7 DU** |
| orbital data centres | 10.8% | 129.6% | exceeds the column |

**The middle row is the finding.** At the Gen3 filing, the regional loss takes Boulder's median from **310.0 DU to 261.7 DU — below the 5th percentile of its own healthy record.**

> **The median day would become worse than the worst day of the healthy era.**

That is a statement about a measured baseline, not a modelled one. The baseline is what the instrument recorded; only the loss percentage is projected, and it is labelled as such.

The bottom row exceeds the column entirely — which disqualifies the linear projection before it reaches that scale rather than forecasting a collapse, exactly as the cascade chain found independently.

### What is measured, what is projected, what is not known

- **MEASURED** — the healthy ranges, the 2015+ comparison, the recovered Antarctic depletion.
- **PROJECTED** — the column-loss percentages and the 12× regional factor.
- **NOT KNOWN** — the biological response. **No transfer function is applied and none is claimed.** The chain stops where the measurement stops.

### One defect found and fixed in this ingest, recorded because it was silent

The archive uses CRLF line endings. In Swift, `"\r\n"` is a **single Character**, so `split(separator: "\n")` matches nothing and returns a 15,837-line file as **3 lines**. The first run admitted 3 rows out of 21,618.

**The control arm caught it and refused to run the projection** — it reported `CONTROL ARM FAILS: the instrument is the bug`. That is what a control arm is for, and it is why one is frozen ahead of every result in this programme.

## The frozen law

> **A cascade is a product. Each link is a factor. The product is computable only where every factor carries a number. Where a link is unmeasured, the product is unmeasured — and the finding of this court is WHICH LINK BREAKS IT.**

The court multiplies the chain as far as the published evidence allows, states the grade of every link, and names the exact link where multiplication must stop. It renders **no verdict on biological outcome**, because the transfer functions for that do not exist — and saying they do not exist is the result, not a hedge.

## The chain, with the grade on every link

| # | link | grade | what is known |
|---|---|---|---|
| 1 | injection → stratospheric burden | **MEASURED** | residence time cancels; burden ratio = flux ratio |
| 2 | burden → global mean ozone loss | **CONTESTED** | five models, **disagreeing on sign** |
| 3 | global mean → regional worst case | **MEASURED** | **12×** — Antarctic 60% while global mean was 5% |
| 4 | ozone loss → surface UV-B | **ESTABLISHED** | radiation amplification factor 1.1–2.0 |
| 5 | UV-B → phytoplankton productivity | **CITED, NOT MEASURED** | mechanism established; **no transfer function at this forcing** |
| 6 | phytoplankton → food web and O₂ | **NOT_KNOWN** | no quantified transfer function found in any literature |

Links 1, 3 and 4 multiply. Link 2 is a contested spread and is carried as a spread, never collapsed to a preferred value. **The chain stops at link 5** — not because the mechanism is doubtful, it is not, but because nobody has measured the transfer function against this forcing.

## Link 3 — the factor nobody puts on a public page

Every model in this field reports a **global mean**. During the Montreal era the global mean column loss peaked near **5%**. In those same years the Antarctic springtime hole reached about **60%**.

> **A global mean is twelve times kinder than the worst region.**

That is not a modelling opinion. It is what the ozone record did. **A projection quoted as a global mean has already divided the regional damage by twelve before the reader sees it.** This court publishes both numbers, always, and treats a global-mean-only projection as an incomplete result.

## The first result — sealed 2026-09-01

| filed scenario | global mean | regional (×12) | surface UV-B rise |
|---|---|---|---|
| 2025, measured | 0.029% | 0.35% | below natural variability |
| authorised 19,408 | 0.26% | **2.4%** | **+2.6% to +4.8%** |
| Gen3 filed 100,000 | 1.32% | **15.6%** | **+17.1% to +31.2%** |
| orbital data centres | 10.77% | **128.4%** | **IMPOSSIBLE** |

## The finding: the chain breaks the model before it breaks the planet

At the orbital-data-centre scale the linear chain returns a regional ozone loss of **128.4% — more ozone destroyed than exists.**

**That is not a forecast of catastrophe. It is a proof that the linear projection fails before it gets there.**

Exactly one of the following must be true, and **nobody can currently say which**:

- **(a)** the ozone response saturates far below linear — the kind reading, and the likeliest;
- **(b)** the 12× regional amplification does not carry to this forcing;
- **(c)** the projection is right in magnitude and the geometry is different.

**That is the cascade nobody is looking for.** Not a predicted collapse — a chain whose fourth link returns a physically impossible number, which means the published instruments are being applied outside the range where they mean anything, and no one has noticed **because no one has multiplied the chain.**

The middle row is the one to sit with. At the **Gen3 filing** — 100,000 satellites, filed and not granted — the chain does *not* break, and it returns a regional ozone loss of **15.6%** and a surface UV-B rise of **+17% to +31%**. That number is inside the range where the instruments still mean something. It is not impossible. It is just large.

## What would close each open link

| link | what closes it |
|---|---|
| 2 — contested sign | a mandatory reentry emissions inventory: mass, composition, ablation altitude, per object. Settles it in ~3 years. Costs near nothing. |
| 3 — regional carry | run the existing models to regional minima and **publish them**, not only the global mean. Costs one output field. |
| 5 — phytoplankton | a UV-B dose-response experiment at the projected regional doses. Standard marine biology. Nobody has been asked to fund it. |
| 6 — food web | the transfer function does not exist. Honest terminal: **NOT_KNOWN**. |

**Three of the four are cheap, and none of them is being done.**

## How this study loses

A court that cannot fail is a turn counter. These are frozen before grading:

- **LOSS (i)** — every link turns out to be quantified in existing literature we failed to find. Then the chain closes, the gap was ours, and this page publishes that with the citations that closed it.
- **LOSS (ii)** — the 12× regional factor does not generalise beyond polar heterogeneous chemistry. Then link 3 collapses toward 1× and the impossible number never arises.
- **LOSS (iii)** — the chain multiplies cleanly to a small number at every filed scale. Then there is no cascade, and this study says so on this page.

## The occlusion model, executed and refuted

A model was proposed for this study in which vaporised alumina claims spatial volume in the stratosphere until the particles link into a continuous membrane — a percolation threshold, reached at some block height, after which radiation transport changes discretely.

**That is a testable claim with a known threshold, so this court tested it.** `reproduce/percolation-refutation.swift`:

| quantity | value |
|---|---|
| stratospheric volume | 1.78 × 10¹⁹ m³ |
| filed annual mass, largest scale | 80,000 t |
| volume that mass actually occupies | **2,025 m³ — a cube 27 metres on a side, per year** |
| occupied volume fraction | **1.1 × 10⁻¹⁵** |
| volume fraction at which spheres percolate | ~0.29 |
| **distance to percolation** | **~2.5 × 10¹⁴ ×** |

**The filed annual mass would have to increase by a factor of about two hundred and fifty trillion before the material could form a continuous layer.** Accumulated over the entire age of the Earth it does not approach the threshold.

**The occlusion model is refuted.** There is no voxel exhaustion, no saturation block height, and no continuous metallic sky. Any study built on that mechanism is built on a number off by fourteen orders of magnitude, and this court will not carry it.

### Why the refutation makes the real finding worse, not better

Read it carefully. It says the material occupies **essentially no volume**. If harm required filling the sky, there would be no story here at any filed scale and this entire programme could stop.

**The harm is not occlusion. It is catalysis.**

A catalyst is not consumed and does not need to fill the room. Chlorine from CFCs destroyed several percent of the global ozone column at mixing ratios of **parts per billion** — a volume fraction as negligible as this one. That is the whole reason the Montreal Protocol was necessary, and it is the reason 461 tonnes a year is worth measuring at all.

**So the occlusion model fails in the reassuring direction.** Run honestly, it returns *no problem* — and that conclusion is wrong. A model that cannot see a catalytic mechanism is not a conservative model. It is a blind one, and it would have told the operator to proceed.

What survives is the measurement that depends on none of it: **human injection reaching 5.4 to 10.9 times the natural meteoric input, into a layer whose chemistry is catalytic, with no instrument watching.**

## What this court will not carry

Stated explicitly, because each was proposed and none survived contact with the evidence:

- **No date, no block height, no saturation year.** The threshold that would produce one cannot be found; worked backwards it sits at ambient background, so the same formula returns *already saturated* for the pre-industrial sky. A model that says the sky was saturated in 1750 is measuring an error in the model.
- **No 296,666-tonne threshold.** That figure appears nowhere in this evidence base.
- **No continuous metallic membrane.** Refuted above by fourteen orders of magnitude.
- **No hard integer sterilisation threshold for phytoplankton.** UV-B damage is dose-dependent and graded, with active repair. Treating it as a binary collision is not conservative; it is simply wrong, and it is why link 5 is graded `CITED, NOT MEASURED` rather than assigned a number.
- **No 1,250 kg per unit.** That figure appears in no FCC filing. The measured per-unit mass is **492 kg**; using 1,250 kg re-introduces a 2.54× error this programme already removed.

**That fire event is the strongest real anchor available**, and it belongs to the cascade rather than to alarm: the 2019–20 Australian fires put 0.4–1.0 Tg of smoke into the stratosphere — aerosol-surface chlorine activation without polar-stratospheric-cloud temperatures, *the same shape of claim now made for alumina* — and HCl fell 50–60% below climatology. The reservoir was **depleted, not infinite**, and the measured outcome was a **3–5%** mid-latitude column loss. The planet has already run this experiment once at small scale. The answer was neither nothing nor collapse.


## The saturation model, graded against its own control arm

A second model was presented with explicit constants, which makes it fully testable. This court tested every one. `reproduce/tsat-control-arm.swift`.

**Its arithmetic is internally consistent.** V_strat × T_sat ÷ P_g does reproduce 296,666 tonnes. The division is not the defect.

**Test 1 — is P_g = 6×10¹³ particles per gram possible? PASSES.** A gram split into 6×10¹³ pieces gives 1.67×10⁻¹⁴ g each; at alumina density that is a radius near 100 nm, which is entirely reasonable for this aerosol.

**Test 2 — the control arm. FAILS, and it is disqualifying.** The presented saturation density is **T_sat = 1,000,000 particles/m³**. The measured natural stratospheric aerosol number density — the Junge layer — is 1 to 10 particles per cubic *centimetre*, which is **1,000,000 to 10,000,000 particles/m³.**

> **The pre-industrial stratosphere already meets or exceeds the threshold. Run on the sky of 1750, before any rocket ever flew, the model returns SATURATED.**

It returns the same verdict on the control arm as on the treatment arm. By this substrate's own doctrine that is fatal: **an instrument that answers identically on a pristine sky and a catastrophic one has zero discriminating power. Always-green and always-red are the same defect.** A model that cannot fail cannot pass.

**Test 3 — the flux equation refutes its own conclusion. FAILS.** Presented: `Φ_surface = Φ_initial − (O_block × (1 − AluminaVoxelState))`, with Φ_initial = 10⁹ and O_block = 1500. Set AluminaVoxelState to 0 — the total-membrane case the model calls fatal — and Φ_surface = 999,998,500. **The ozone term removes 0.00015% of the flux.** Real ozone attenuates surface UV-B by 95–99%, and does so *multiplicatively* (Beer-Lambert), never by subtracting a constant. O_block is low by five orders of magnitude and is in the wrong form. **The equation offered as proof of catastrophe shows the surface flux changing by 0.00015% between a healthy ozone layer and none at all.**

### The court's own verdict

The model was presented to the live court at `https://affine.earth/language-invariant/mcp` on 2026-09-01, in the domain its author proposed:

```json
{"status":"REFUSED_UNKNOWN_DOMAIN","domain":"stratosphere_uvb_flux",
 "proven":"AFFINE_MATH_COURT","tool":"math_court"}
```

**`REFUSED_UNKNOWN_DOMAIN`.** The court has 48 domains and not one of them is atmospheric — measured the same day, **0 of 49 court tools** mention ozone, reentry, stratosphere or wet-bulb. So no study on this wiki's planetary programme can currently seal, which is why Studies 28–31 carry no `PROVEN` marker while eleven other studies do.

**That gap is the work item, and it is named here rather than papered over:** the `biosphere` domain declared above must be added to the court's domain table and rolled to the fleet. Until it is, this page is a charter with a computed first result, not a sealed verdict, and it says so.

### What refusing a model does not do

**It refuses one model. It does not lower the measured finding.** Human injection still reaches **5.4 to 10.9 times the natural meteoric input**, the harm mechanism is still catalytic rather than optical, and nothing is watching.

**A bad instrument for a real problem is worse than none** — because when the instrument is refuted, the problem gets refuted along with it. That is precisely why it is refused here, by us, before anyone else does it for us.

## Reproduce it

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
xcrun swiftc -O -swift-version 5 reproduce/biosphere-cascade-chain.swift -o /tmp/casc && /tmp/casc
bash reproduce/validate.sh
```

**Related:** [the closed-system box model](Home) · [Study 29 — continuous model shear](Study-29-Continuous-Model-Shear) · [Study 28 — wet-bulb court](Study-28-Wet-Bulb-Threshold-Court) · [the ontology](Ontology)
