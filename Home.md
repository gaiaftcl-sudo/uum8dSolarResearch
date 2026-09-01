# Affine.Earth

**A substrate on which a verdict is an exact integer, so that checking it is a re-derivation rather than a re-run.**

Everything below is measured, dated, and reproducible from this repository by anyone, with no account and no key. Where a question is open, it is written as open. Where a number is a projection rather than a measurement, it says so.

---

## Why this exists

Between 2024 and 2026, five peer-reviewed modelling groups took the same physical question — what does the mass of re-entering satellites do to the stratosphere — and returned answers that **disagree on the sign**.

| group | model | what it reports |
|---|---|---|
| Ferreira et al. 2024 | mass only | a chlorine-activation mechanism; **no ozone percentage at all** |
| Maloney et al. 2025 | WACCM6 + CARMA | a **weaker** springtime ozone hole |
| Revell et al. 2025 | SOCOLv4 | at most a **+0.27% ozone increase** |
| Barker et al. 2026 | all-mission | chlorine from solid propellant dominant; rocket soot forcing **+6.47 mW/m² instantaneous, −6.40 stratospherically adjusted** |
| Vliex et al. 2026 | GEOS-Chem | **87.7% of depletion driven by NOx**, not alumina |

Barker's is the sharpest: **one model, one emissions set, two forcing definitions, opposite signs, zero difference in input data.**

Underneath all five sits a ledger that is not in dispute and is exactly countable. In calendar 2025, **1,907 catalogued objects re-entered carrying 461,213,509 grams** of dry mass — a figure re-derived here from a corpus pinned by digest, where the mass column conforms to exact integer parsing on **1,907 of 1,907 rows**. The lattice unit is the gram. No floating point touches it.

**And part of the disagreement is not physics.** The field's widely-quoted "28× divergence" between two of those scenarios is a ratio between two *different quantities* — one a reentry mass flux, the other an alumina mass. Put on one set of units it is **3.2×**, and the two papers land within 4% of each other. That was found by counting. No atmospheric model was run.

**So the finding is not that the sky is falling. It is that we cannot currently tell** — and that the instrument, not the atmosphere, is what this program grades. [Study 29](Study-29-Continuous-Model-Shear.md) charters that court.

---

## Public flourishing, as an exact quantity

Flourishing here is not a slogan. Every domain the substrate serves declares three exact rationals, and they satisfy an identity you can check:

> **entropy_bare − entropy_delta = entropy_resolved = 1/1**

The continuous form of a law carries excess structural entropy — always greater than one. Adopting the exact form removes exactly Δ. What remains is **unity: one answer, replayable by anyone, on any machine.**

| domain | continuous form costs | exact form removes | resolves to | what that buys the public |
|---|---|---|---|---|
| `geometry` | 6/5 | 1/5 | **1/1** | volume is a count a regulator can replay |
| `chance` | 5/4 | 1/4 | **1/1** | no float amplitude tax on consensus |
| `algebra` | 6/5 | 1/5 | **1/1** | linking is a table, not a spectral object |
| `physics` | 4/3 | 1/3 | **1/1** | the appointment is clock + track + table |
| `qcd` | 4/3 | 1/3 | **1/1** | freedom is small dilation; no isolated colour row |
| `health` | 3/2 | 1/2 | **1/1** | dose on a body is n/d; exponential PK is the adversary |
| `finance` | 3/2 | 1/2 | **1/1** | tick PnL; Black-Scholes is extraction entropy |
| `cs` | 6/5 | 1/5 | **1/1** | seals agree across cells; IEEE-754 is the adversary |
| `fluids` | 4/3 | 1/3 | **1/1** | sum Φ = 0; RANS is not a certification court |

Nine resolve exactly, verified by [`reproduce/flourishing-entropy-ledger.swift`](reproduce/flourishing-entropy-ledger.swift), which carries a control arm proving the identity can fail. **Scope, stated: 9 of the 48 served domains declare an entropy triple. The other 39 do not, and are not counted.**

---

## If you are not a scientist, start here

**[Ask someone you trust to check this](Ask-Someone-You-Trust-To-Check-This.md)** — the plain-language version. There is a measured amount of vaporised spacecraft in the air above you: roughly **one in ten** of the larger stratospheric particles now contains satellite metal, from a NASA aircraft campaign that analysed over 500,000 individual particles. Nobody is required to weigh what comes down. The only rule that exists asks for a **count of satellites**.

Send it to one person who reads papers for a living, and ask them to try to prove it wrong.

## Start here

**[The reentry forcing nobody is required to measure](Reentry-Forcing-Nobody-Measures.md)** — one operator went from 0% to **45.8%** of all mass entering the atmosphere in six years; spacecraft aluminium already ablates at ~10× the meteoric supply on the measuring paper's own denominator; **10 ± 7%** of stratospheric particles above 120 nm already carry spacecraft metals; five models disagree on the **sign** of what that does; and the only reentry duty any regulator imposes is a semi-annual **count of satellites**.

**[The exactness seam](The-Exactness-Seam.md)** — the business justification. Three markets settle their central quantities in floating point, and the participants document the consequences themselves. Ansys states results change between releases. Dassault states Abaqus/Explicit results depend on the parallel decomposition. NVIDIA states PhysX results vary across platforms, compilers and optimisation settings, and that adding one non-interacting actor can diverge a scene. ISO 23247-1, the international framework standard for manufacturing digital twins, contains **zero occurrences** of *reproducibility*, *repeatability*, *precision* or *floating point*.

**[Study 29 — The continuous-model shear](Study-29-Continuous-Model-Shear.md)** — the reentry ledger against the models that consume it.

**[Study 30 — The sovereign edge pod](Study-30-Sovereign-Edge-Pod.md)** — the constructive half: an open sensing pod, a four-tier gate with frozen integers, and a candid account of what is chartered rather than built.

**[Program index](Shear-Studies-Index.md)** · **[Readers' guide](Shear-Studies-Readers-Guide.md)** · **[White paper](Shear-Studies-White-Paper.md)** — thirty studies, each pairing a forcing that carries its own clock and track with a public archive and a sealed adversary.

---

## Check it yourself

```
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch && bash reproduce/validate.sh
```

Verifies every corpus against its pinned sha256, compiles and runs all eleven programs, and confirms that **every published figure appears in the output of the program that produces it**. It also refuses to report a clean result if it finds nothing to scan, and carries a positive control so a scanner that has silently stopped working fails instead of passing.

**Current: 25 passed, 0 failed.**

---

## What this program does not claim

That any life was saved. That any disaster was averted. That any ecological harm is established — the ozone sign is contested across five published positions and **that contested-ness is the finding**. That incumbent simulations are wrong. That the sensing hardware is cheaper than the orbital alternative; the arithmetic is published and goes the other way.

Where the honest answer is that a question is open, it is written as open.
