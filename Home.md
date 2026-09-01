# We are about to make the sky five times dirtier than nature ever made it, and no law requires anyone to measure it.

Not a metaphor. A mass balance, in a closed system, with integers.

The stratosphere has been fed metal for the whole history of life — meteors burn up in it and leave a haze of iron and magnesium smoke. That flux is about **20 to 40 tonnes a day**, and it has been roughly constant for as long as there have been living things underneath it.

At the satellite disposal rate that has already been **filed** with the United States Federal Communications Commission, human beings will inject metal into that same layer at **5.4 to 10.9 times the natural rate.**

Not different metal in a different place. The same kind of material, into the same layer, at five to eleven times the rate the planet has ever supplied it.

**It has not happened yet.** That is the only reason this page exists.

---

## The arithmetic, in full, because you should not take that from us

This is the entire model. It is the simplest instrument in this programme and it is the one we trust most, because it needs no chemistry, no threshold, and no supercomputer.

The stratosphere exchanges slowly with the air below it. Particles put into it settle out over a year or a few. So at steady state:

> **burden = injection rate × residence time**

Now compare human injection to meteoric injection. Same layer, same particle sizes, same settling physics — **so the residence time cancels.**

> **human burden ÷ natural burden = human injection ÷ natural injection**

That is it. Two mass fluxes, one division. Both are measured, neither is modelled.

| what is being disposed of | metal per year | as a share of the entire natural meteoric flux |
|---|---|---|
| **2025, measured** | 461 t | **3.1% – 6.3%** |
| **19,408 satellites, already authorised** | 1,909 t | **13.0% – 26.1%** |
| 100,000 satellites, filed | 9,840 t | **67% – 135%** |
| **orbital data centres, filed** | 80,000 t | **548% – 1,096%** |

Read the left number in each range first. It is the kinder one — it assumes the natural flux is at the high end, which makes us look better.

Even being kind to ourselves: **the fleet that is already legally approved puts human metal at a seventh to a quarter of everything nature delivers.** The orbital data centres take it past everything nature delivers, five times over.

Reproduce that in four minutes: `reproduce/closed-system-box-model.swift`. The instructions are at the bottom of this page and they require no account, no key, and no trust in us.

---

## Five reasons that number could be wrong, and we are telling you before you ask

We put these first because a warning that hides its weaknesses is not a warning, it is an advertisement.

1. **It names no consequence.** A composition ratio is not an ozone loss and not a harm. Five modelling groups disagree about the consequence and this model settles none of it.
2. **Ablation fractions are assumed comparable.** Meteoroids arrive at 11–72 km/s and burn almost completely. Satellites reenter near 7–8 km/s and some of them reach the ground. If those fractions differ, the ratio moves. **This is the assumption most likely to be wrong, which is why it is second on the list and not buried.**
3. **The chemistry is not the same.** Meteoric smoke is iron and magnesium silicate. Satellite ablation is aluminium-rich. Equal mass is not equal chemistry — and alumina's surface chemistry is precisely what the whole scientific dispute is about.
4. **The natural flux carries a factor-of-two spread** in the published literature. We carry both ends rather than picking a midpoint that would flatter us.
5. **Steady state is assumed.** A rising injection rate has not yet built the burden it implies. These ratios describe where it settles, not where it is today.

Every one of those is a reason to go and measure. **Not one of them is a reason not to.**

---

## What is already in the sky

In calendar year 2025, **1,907 catalogued objects re-entered the atmosphere.** That count is exact — it is a count of rows, and counting has no error bar.

Their total dry mass was about **460 tonnes**. And here we have to tell you something about our own headline number.

**Three quarters of that mass comes from values the catalogue itself marks as estimates.** The GCAT catalogue flags an estimated dry mass with a `?`. Of the 1,907 objects, **864 carry that flag, and they account for 75.7% of the total.** We published `461,213,509 grams` — nine significant figures — on this page, and nine significant figures on that number was false precision. It was our error and we found it by auditing ourselves.

So here is the honest form. If every flagged value is off by the full ±20% the catalogue implies, in the same direction:

> **2025 reentry mass: about 460 tonnes. Range 391 to 531.**
> **Alumina reaching the stratosphere: 180 to 244 tonnes a year — 45 to 61 tonnes each season.**

**The claim survived. The precision did not.** Both halves of that are on this page, and the program that computes the band is `reproduce/mass-uncertainty-band.swift`.

That is what we mean by exact arithmetic. Not that we are never wrong — that when we are wrong, the machine finds it and the correction is published with a date on it.

---

## Season by season, in the only terms that matter

### Right now, this season

**About fifty tonnes** of spacecraft turned to metal vapour in the stratosphere — not on the ground where it could be swept up, but in the layer of air that holds the ozone. Half a tonne a day. It happened last season too, and the one before.

**Nobody had to report it. No agency collects it. There is no reentry emissions inventory anywhere on Earth.**

When the FCC authorised these constellations it did so under a **categorical exclusion** from environmental review — meaning the environmental review was not conducted and passed. It was formally skipped.

What you felt this season: nothing. That is exactly the problem.

### The seasons after the approved fleet flies

**477 tonnes a season.** Nine times today's rate.

This is not speculation about corporate ambition. It is what **19,408 already-authorised satellites** produce on a five-year replacement cycle. And five-year replacement is the part everyone misses: these are not monuments. **A fleet of N satellites on a five-year life is a permanent N/5-per-year disposal stream, forever, for as long as the service exists.** The mass never stops arriving, because the fleet is always being replaced.

### The seasons after the filed fleet flies

**2,460 tonnes a season.** Twenty-seven tonnes a day. One hundred thousand satellites, filed at the FCC, not yet granted.

### The seasons after the orbital data centres

**20,000 tonnes a season. 219 tonnes every single day.**

In 2026 SpaceX filed for roughly a million satellites carrying AI compute — data centres in orbit. **Their own filing puts 40,000 units a year into disposal reentry.** We used their number. We did not pick a worse one, and we could have.

And this one takes something else with it. Applying a published elemental analysis of a GPU to that same disposal rate, this leaves the Earth permanently every year, as vapour:

| copper | titanium | bismuth | palladium | silver | gold | thallium |
|---|---|---|---|---|---|---|
| ~1,000 t | 20+ t | 20+ t | 2+ t | ~2 t | ~170 kg | ~76 kg |

Palladium and thallium at roughly **one percent of annual global mine production** (REPORTED — Ars Technica 2026-08-20, citing *Nature Communications Earth & Environment*). Dug out of the ground, lifted to orbit, and deliberately vaporised rather than recycled.

---

## What it does when it gets there — and the honest line between mechanism and measurement

The founder of this project put it plainly: heat, weather, ocean plankton, food cycles. Those are the stakes, and they are the reason to care. Here is exactly how much of that we can stand behind, and where the evidence stops.

**What is measured and published:**

- **The polar vortex responds.** Maloney and colleagues (2025, WACCM6 + CARMA, REPORTED) — the paper we cite *against* our own concern, because it finds a *weaker* ozone hole — also reports **~1.5 K of temperature anomaly and a ~10% reduction in Southern Hemisphere polar-vortex wind speed.** Read that again. **The reassuring paper reports the stratosphere's circulation changing.** A weakened polar vortex is a mid-latitude weather story: it is the mechanism behind cold-air outbreaks and disrupted seasonal patterns. It is not good news wearing good news' clothes.
- **This class of mechanism has already done multi-percent damage, once, and it was observed.** The 2019–20 Australian fires put 0.4–1.0 Tg of smoke into the stratosphere. Measured consequence: HCl **50–60% below climatology**, ClO and ClONO₂ enhanced, and a modelled **3–5% reduction in southern mid-latitude total column ozone** (Solomon et al., *Nature* 615, 2023 — REPORTED). Aerosol-surface chlorine activation without polar-stratospheric-cloud temperatures — **the same shape of claim now made for alumina.** That is not a projection. That is a natural experiment the planet already ran.
- **Humid heat is already killing people, and it is already counted.** July 2026, Japan: **41,174 people carried to hospital by ambulance for heatstroke in one month, 79 confirmed dead** (REPORTED — FDMA figures). Korea, 2026-08-02: **42.5 °C**, the highest in 122 years of observation. That is on this wiki as [Study 28](Study-28-Wet-Bulb-Threshold-Court), and what that study grades is that **the operational instruments deciding when to warn people carry error bands the size of the verdict.**

**What is a real mechanism but an unmeasured magnitude:** UV reaching the surface raises skin cancer and cataract rates. Crop yields respond. Phytoplankton — the base of the ocean food web and a large share of atmospheric oxygen production — is UV-sensitive, and damage there propagates upward through everything that eats.

**Every one of those chains is established science. Not one of them has been measured against this particular forcing, because the forcing itself is not being measured.** This wiki's own rules forbid us from sealing a verdict on ozone, UV-B or plankton, because we have not graded them — and we follow our own rules in public. They are cited. They are not sealed. We will not pretend otherwise to make this page hit harder.

**And that is the alarm.** Not that we have proof of collapse. That the stakes are the ocean food web and the growing season, the mechanism is established, the injection rate is about to go up fifty-fold, **and there is no instrument pointed at it.**

---

## The scale nobody puts next to the projections

Every honest page owes you this comparison, and ours did not have it until today.

The one group publishing a global column-ozone number is Vliex (2026, GEOS-Chem). Scale their result linearly to each filed fleet:

| scenario | projected column ozone loss | how it compares |
|---|---|---|
| measured today | 0.029% | far below natural variability |
| authorised 19,408 | 0.257% | **still below natural variability** |
| Gen3 filed 100,000 | 1.32% | **inside natural year-to-year variability (~1–2%)** |
| orbital data centres | **10.8%** | **twice the peak global loss that produced the Montreal Protocol (~5%)** |

**Only the last row clears the noise.** We are telling you that, and it makes three of our own four rows weaker.

It also makes the last row the whole argument. A single commercial programme, filed and not yet granted, projects to **twice the global ozone depletion that made the world negotiate a treaty, sign it, and rebuild the refrigeration industry** — with no monitoring obligation attached to it, at all.

And the projection is linear, which is an assumption we flag as probably wrong: heterogeneous chemistry saturates as surface area fills. **The curve almost certainly bends. It could bend either way**, and nobody can currently tell you which, because nobody is measuring.

---

---

## The cascade nobody multiplied

Every group in this field studies one link. One models injection into the stratosphere. Another models the ozone response. A third field studies UV and marine biology. **Each link is competently studied and nobody multiplies them** — so no published number exists for the thing you actually want to know.

We multiplied it. [Study 31](Study-31-Biosphere-Cascade) is the court, and every link carries its grade:

| # | link | grade |
|---|---|---|
| 1 | injection → stratospheric burden | **MEASURED** |
| 2 | burden → global mean ozone loss | **CONTESTED — five models disagree on sign** |
| 3 | global mean → regional worst case | **MEASURED: 12×** |
| 4 | ozone loss → surface UV-B | **ESTABLISHED** |
| 5 | UV-B → phytoplankton productivity | **CITED, NOT MEASURED** |
| 6 | phytoplankton → food web and oxygen | **NOT_KNOWN** |

**Link 3 is the one that is never on a public page.** During the Montreal era the global mean ozone loss peaked near 5%. In those same years the Antarctic hole reached about 60%.

> **A global mean is twelve times kinder than the worst region.** Every projection you have ever read in this field is quoted as a global mean, which means it divided the regional damage by twelve before you saw it.

Multiply the chain and this comes out:

| filed scenario | global mean | regional (×12) | surface UV-B rise |
|---|---|---|---|
| authorised 19,408 | 0.26% | **2.4%** | **+2.6% to +4.8%** |
| Gen3 filed 100,000 | 1.32% | **15.6%** | **+17.1% to +31.2%** |
| orbital data centres | 10.77% | **128.4%** | **IMPOSSIBLE** |

**Read the bottom row carefully, because it is not the alarming one — it is the disqualifying one.** A regional loss of 128.4% is more ozone than exists. That is not a forecast of catastrophe. **It is a proof that the published instruments fail before they reach the filed scale**, and nobody noticed because nobody multiplied the chain.

The row to sit with is the middle one. At the Gen3 filing the chain does **not** break: it returns a **15.6% regional ozone loss and a +17% to +31% rise in surface UV-B.** That number is inside the range where the instruments still mean something. It is not impossible. It is just large, and no law requires anyone to check it.

And the chain **stops at link 5** — not because the mechanism is doubtful, but because **nobody has ever measured the UV-B dose response of phytoplankton at these doses.** That experiment is standard marine biology. It has not been asked for. Neither has publishing the regional minimum instead of the global mean, which costs one output field in a model that is already running.

**Three of the four open links are cheap. None of them is being done.**

**And the axes have now been joined.** The biosphere column is empty in all five published papers — each models one axis, none carries a biological term, and no two share a full axis set, so the joint number cannot even be assembled from the literature. [Study 31](Study-31-Biosphere-Cascade) holds every axis in one exact ledger, against measured baselines: 56,575 daily ozone observations (the ingest independently recovers the Antarctic depletion at -16.1%, proving it can see a real loss) and NOAA's 46-year greenhouse forcing record. What the join shows: **the already-authorised fleet moves three independent planetary accounts by percent-scale amounts at once** — 13–26% of the natural meteoric flux, 3.1% regional ozone, 1.0% of all greenhouse forcing — **and no instrument reports any of the three.** Every unmeasured biological feedback is named and excluded from the sum, and every one of them points the same way, so the ledger is a floor.



## Where we refused to go

There is no year on this page. No date by which the sky becomes unrecoverable.

We tried to compute one. The calculation needs a threshold concentration at which the atmosphere's behaviour changes, and we could not find one. Working the arithmetic backwards, the threshold it required sat at roughly the **ambient background level** — meaning the same formula, applied to the pre-industrial sky before any rocket ever flew, returns *already saturated*. A model that says the sky was saturated in 1750 is not measuring the sky. It is measuring an error in the model.

So: **we do not know when.** Anyone giving you a date for this — us, or anyone citing us — is giving you a number that does not exist.

And we removed a compound factor of **240×** from our own first estimate, by counting: a units artifact (8.75×), a regulatory-tier conflation where we had mixed authorised satellites with merely requested ones (2.16×), a disposal-fraction error where we assumed every satellite reenters when the filing says 4% do (5×), and a per-unit mass error (2.54×).

**Our first number was 240 times too frightening. We publish that, because a warning that will not correct itself is propaganda.**

---

## The four facts that cut against us

Published here with the same weight as everything above, because a page that only carries evidence for its own thesis has not looked.

- **One of the five models reports the opposite sign.** Maloney 2025 finds a *weaker* springtime ozone hole under satellite ablation. Real paper, real scientists, disagrees with our concern.
- **Revell 2025 reports at most a +0.27% ozone *increase*.** And their alumina is *launch* alumina — the paper does not simulate reentry at all.
- **The dominant chlorine source in the sharpest recent analysis is launch, not reentry — and it comes from solid propellant.** Kerosene emits no chlorine. **Which means the operator we are most worried about scores well on the metric that paper says matters most.** Their engines are cleaner there. We are not going to hide that.
- **The field's widely-quoted "28× divergence" is not a real disagreement.** We found it is a ratio between two different quantities in different units — one a reentry mass flux, one an alumina mass. On one set of units it is **3.2×**, and the two papers land within 4% of each other. Found by counting. No atmospheric model was run.

That last one is the tell, and it cuts both ways. **A field where a five-fold error sits unremarked in the literature for two years is not one whose reassurances you should accept — and not one whose alarms you should accept either. Including ours.**

---

## This is stoppable, right now, and cheaply

Not a ban. Three things, all boring:

**1. Measure it.** A mandatory reentry emissions inventory, the way aviation has one. Mass, composition, ablation altitude, per object. It costs almost nothing and it does not exist. **Every argument on this page — ours and theirs — would be settled inside three years by data nobody is collecting.**

**2. End the categorical exclusion.** Not "reject the constellations." *Review* them. The exclusion means the environmental question was never asked. That is a procedural fact, not an opinion about the answer.

**3. Put the compute on the ground.** Which is the next section, and where we have to be careful with you.

**The window is open because the worst case is filed and not granted.** 19,408 are authorised. The 100,000 and the 1,000,000 are applications. A regulator can attach a measurement condition to a licence tomorrow at essentially zero cost, and every number on this page becomes checkable instead of arguable. **That is the whole ask.**

---

## The alternative, line by line — and the row where we lose

This is where a pitch usually goes. Read this paragraph before the table.

**These two things do not do the same job.** A GPU rack in orbit trains and runs neural networks. What we built is an *exact-arithmetic court* that verifies a presented claim. The comparison is honest for the **verification** workload and **dishonest for model training.** Anyone telling you a three-joule sensor replaces a GPU rack is selling something.

| | orbital AI compute | Affine.Earth exact mesh |
|---|---|---|
| where it runs | 500–2,000 km orbit | the ground, in the country that owns it |
| arithmetic | IEEE-754 floating point | exact integers and rationals — no float anywhere |
| same answer twice? | vendor-documented as **no**: Ansys states results change between releases; Dassault states Abaqus/Explicit depends on parallel decomposition; NVIDIA states PhysX varies across platform and compiler | byte-identical, across nine independent machines |
| sensing node energy | n/a | **3.240 joules per hour**, measured budget |
| atmospheric cost, operating | 80,000 t/yr at the filed scale | zero |
| end of life | vaporised, or pushed to a disposal orbit | recoverable, repairable, on the ground |
| repair | impossible | a person with a screwdriver |
| who can audit it | the operator | anyone — the programs are in this repository |
| **cost** | **$1,594,900** | **$1,825,000 — we are more expensive** |

**We ran the cost matrix and we lose on price.** At like-for-like aggregation the orbital path is cheaper, and we are publishing that number because a comparison that only produces favourable rows is not a comparison.

### The row that decides it anyway

Both approaches produce numbers people will act on — that regulators cite, that companies build against.

**Only one produces a number a stranger can re-derive without trusting whoever produced it.**

That is not efficiency. It is the difference between **evidence** and **testimony**. And the five disagreeing atmospheric models are the demonstration: five groups, one physical question, answers that disagree on sign, and no shared arithmetic to settle it between them. **When instruments cannot be reconciled, the loudest institution wins by default.** That is the failure mode this substrate exists to remove, and it is the failure mode currently deciding what happens to the stratosphere.

Floating-point arithmetic is not wrong — it is *approximate*, and the approximation depends on your hardware, your compiler, and the order the sum happened in. The relevant digital-twin standard, ISO 23247-1, contains **zero occurrences** of the word reproducibility. So when two parties disagree about a simulated result, there is no procedure. There is only escalation.

Exact rational arithmetic removes that. A verdict is an integer over an integer. Two machines produce the same one or they do not, and if they do not, exactly one is broken and it is findable.

---

## Why take any of this from us

Because we did not build a court to attack a company. We built a court, ran it against eleven unrelated questions until each one sealed, published the failures, and then it reached the sky.

Every study here does the same thing: take a domain where a floating-point model is the accepted instrument, compute the same quantity in exact integers, and seal the cases where the two render **opposite verdicts**. The subject under grading is always **the instrument**, never the phenomenon.

**Eleven studies carry a live-court PROVEN marker** — you can grep them on the [index](Shear-Studies-Index):

| run against | what it graded |
|---|---|
| the Sgr A\* black hole image | whether normalisation survives contact with raw EHT visibilities — **8/8 raw WIN, 8/8 normalised MISS** |
| a North Korean underground test | integer arrival appointments vs spectral float discriminants — **6/6 WIN, 3/3 adversary rejected** |
| lattice polytope volume | exact Ehrhart counts vs float triangulation — **5/5 WIN, 5/5 float MISS** |
| quantum parallel repetition | exact rationals vs float amplitude tensors — **4/4 WIN, 4/4 float MISS** |
| Connes rigidity | integer linking invariants vs a float spectral adversary — **5/5 WIN, 5/5 float MISS** |
| lethal humid heat | the operational heat-index formula, whose own technical attachment states *"No true equation for the Heat Index exists"* and licenses ±1.3 °F — at a line where 0.98 °C is the standard deviation of the human limit itself |
| **the stratosphere** | **five peer-reviewed models that disagree on the sign** |

**And the ones that failed are on this wiki under their own names.** Study 03 is `OPEN` because an archive went dead. Study 08 has no runnable corpus because the data is unpublished until December. Study 10 states explicitly that it does **not** disprove dark matter. Study 04 is a partial seal with the void arms named.

**That is the reason to read the atmospheric result.** Not because we are alarmed — because the machine that produced it publishes its own failures, including the false precision in this page's own headline number, which we found and corrected today.

The type system that makes all of it gradeable: **[the ontology of this wiki](Ontology)**.

---

## Check every number on this page

No account. No key. No dependency on us.

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
bash reproduce/validate.sh
```

The harness verifies that the corpora match their published digests, that every program compiles and runs, that **every figure quoted on these pages appears in the output of the program that claims to produce it**, and that no page cites a path you cannot reach.

**If a check fails, we want the issue. If a number is wrong, tell us and we will publish the correction with a date on it — as we did today with our own headline mass.**

**Or skip the clone and ask the running court directly.** The joint ledger answers live on nine machines at `affine.earth` — the call, the tool name and the four admitted scenarios are on [the study page](Study-31-Biosphere-Cascade). The response grades every axis (`MEASURED` / `PROJECTION` / `NOT_KNOWN`) and carries the marker `STUDY31_BIOSPHERE_JOINT_LEDGER_PROVEN`. Where a projection exceeds physical bounds, the court refuses to print a value at all.


**Ask a researcher you trust to run it.** Not to agree with us. To check us. That is the entire ask of this project and it is written out in full here: **[Ask someone you trust to check this](Ask-Someone-You-Trust-To-Check-This)**.

---

## Start here

| page | what it is |
|---|---|
| [Ask someone you trust to check this](Ask-Someone-You-Trust-To-Check-This) | the human case, in full |
| [The forcing nobody measures](Reentry-Forcing-Nobody-Measures) | the evidence: the ledger, the operator split, the regulatory tiers, the five contested models |
| [The ontology of this wiki](Ontology) | the type system — grades, terminals, controls, and what each page may say |
| [Zero float · zero shear](Zero-Float-Zero-Shear-Paradigm) | the method, and the sealed ledger of where it has been run |
| [All 30 studies](Shear-Studies-Index) | the programme index, every lifecycle state stated |
| [Study 28 — wet-bulb court](Study-28-Wet-Bulb-Threshold-Court) | humid heat: the instruments that decide when to warn people |
| [Study 29 — continuous model shear](Study-29-Continuous-Model-Shear) | the court that grades the atmospheric instruments |
| [Study 31 — the biosphere cascade](Study-31-Biosphere-Cascade) | the chain, link by link, and the exact link where measurement stops |
| [Study 30 — sovereign edge pod](Study-30-Sovereign-Edge-Pod) | the 3.240 J/hour ground node, its energy budget and its cost matrix |

---

*Every figure on this page is produced by a program in `reproduce/` from a corpus pinned by digest in `corpus/`. Projections are labelled as projections. Where we do not know, the page says we do not know. Where we were wrong, the correction is dated and the old number is named.*
