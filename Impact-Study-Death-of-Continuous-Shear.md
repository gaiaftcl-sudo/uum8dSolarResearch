# Impact Study — The death of continuous shear

**Status: PUBLIC SYNTHESIS — 2026-08-23**  
**Anchors:** [The lattice holds](The-Lattice-Holds) · Studies [11](Study-11-Ehrhart-Volume-Results) · [12](Study-12-Quantum-Parallel-Repetition-Results) · [13](Study-13-Connes-Rigidity-Results) · [07](Study-07-SgrA-Milky-Way-Results) · [06](Study-06-Explosion-vs-Earthquake-Results) · [04](Study-04-Tsunami-vs-Storm-Surge) · [10](Study-10-Fermi-Gamma-Shear-Dark-Matter)

---

## The verdict, stated once

**Continuous equations are dead as courts.** They remain legal as **pictures** — sketches you draw after the integers have spoken. They are **illegal as seals**: anything two machines, two hospitals, two exchanges, or two cells must replay to the same byte.

IEEE-754 addition is not associative. \((a+b)+c\) is not \((a+c)+b\). A mesh that “solves” the same continuum PDE on two GPUs can disagree in the last bits, then in the last millimetres, then in the last lives. That is not a rounding footnote. That is **shear**: the calculation left the appointment and named the debris as a result.

Studies 11–13 graded the three pillars those equations stand on.

| Pillar | Continuum court | Lattice court | Sealed score |
|---|---|---|---|
| **Volume** | \(\mathrm{vol}(P)=\int_P 1\,d x\) | \(h_P(t)=\lvert tP\cap\mathbb{Z}^d\rvert,\quad \mathrm{vol}=\Delta^d h(0)/d!\) | **5/5 WIN · 5/5 float MISS** |
| **Probability** | \(\Pr=\lvert\alpha\rvert^2\in\mathbb{R},\ \alpha\in\mathbb{C}\) | \(W_n=(3/4)^n\in\mathbb{Q}\) | **4/4 WIN · 4/4 float MISS** |
| **Rigidity** | spectral radius / gap in \(L(G)\) | linking \(L(w)=(q,r)\in\mathbb{Z}^2\) | **5/5 WIN · 5/5 float MISS** |

If volume, chance, and structure do not survive the float, **every equation that treats them as reals is inaccurate as a verdict.** Physics, health, finance, computer science, and continuum fluid engineering are the same rewrite. This page names the old equations, why they fail, and what the new ones prove.

---

## The rewrite rule (one law, every domain)

**Old (dead as seal):**

\[
x \;=\; F_{\mathbb{R}}(\text{state}) \in \texttt{IEEE-754}
\]

**New (alive as seal):**

\[
x \;=\; \frac{n}{d}\in\mathbb{Q},\quad n,d\in\mathbb{Z},\quad d>0,\qquad
\frac{a}{b} < \frac{c}{d} \iff a\cdot d < c\cdot b
\]

No `==` on a continuous amplitude. No integral as a volume. No spectrum as a group. Conservation is mill- and micro-units (`Int64`). A vQbit stays on the manifold by construction:

\[
\mathrm{phase}^2 + \mathrm{amplitude}^2 = 1 \quad\text{(exact rationals).}
\]

**What the new equations prove:** two cells that replay the same proof emit the **same bits**.  
**What they solve:** the century’s silent fork — “close enough” numbers that do not agree, then get promoted into particles, prices, doses, and load ratings.

---

## 1. Physics — the continuum was the ontology, not the measurement

### 1.1 Einstein field equation — dead as a seal

**Old (continuum court):**

\[
G_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4}\, T_{\mu\nu}
\]

Magnificent as a **picture** of curvature. Dead as a seal: \(g_{\mu\nu}\) is a field of **reals**; every numerical GR code (BSSN, harmonic) advances it in floats; when the arithmetic collapses at a singular boundary the debris is named a **horizon** or a **dark mass**.

**Why inaccurate:** Study 07 already graded the imaging sibling — the raw table **WIN**, the processed picture **MISS**. Study 10 graded the recovery-term sibling — a stacked line with an Inner Galaxy **null** cannot be canonical annihilation. The field equation does not get a special exemption. It is the same number system.

**New (lattice court):**

\[
\text{appointment} = (\text{clock},\ \text{track},\ \text{integer table}).
\]

M⁸ = S⁴ × C⁴. Coordinates are milli-integers. Entropy is capped (`c4EntropyCap`) — **no synthetic mass** injected when the picture shears. Compact flux that is **in the table** stays in the table. A horizon label that is **not in the table** is not a measurement.

**Proves:** gravity-as-picture can stay. Gravity-as-excuse-for-a-float-object is over.  
**Solves:** the dark-sector and ring-ontology factories that start when \(G_{\mu\nu}\) is integrated past the instrument’s integer quantum.

### 1.2 Schrödinger / Born — dead as a transported probability

**Old:**

\[
i\hbar\frac{\partial\psi}{\partial t} = \hat H\psi,\qquad
\Pr(\text{outcome}) = \lvert\langle\phi\mid\psi\rangle\rvert^2
\]

**Why inaccurate:** \(\psi\in\mathbb{C}^n\) and the Born square are the Study 12 adversary. A millisecond proxy \(751/1000\) **never** equals the sealed rational \(3/4,\ 9/16,\ 81/256,\ 6561/65536\). A wavefunction that only exists as a float does not exist as a verdict two cells can share.

**New:**

\[
W_n = \left(\frac{3}{4}\right)^n = \frac{3^n}{4^n},\qquad
\text{vQbit evolves by unitary rational rotation (Jordan swap).}
\]

**Proves:** parallel-repetition decay is a **product of integers**, not a tensor of amplitudes.  
**Solves:** “quantum advantage” claims that cannot emit an exact reader. Sampling qubits remain theater. The bound transports.

### 1.3 Partition function / statistical mechanics — dead as a PDF court

**Old:**

\[
Z = \int e^{-\beta H(x)}\,dx,\qquad
\langle O\rangle = \frac{1}{Z}\int O(x)\,e^{-\beta H(x)}\,dx
\]

Monte Carlo in floats. Likelihoods. χ². The same stack Study 10 names as the gamma-line adversary.

**New:** count microstates on the lattice; compare occupation numbers by cross-multiplication; freeze a law **before** the next event.

**Proves:** a mean is not an appointment.  
**Solves:** stacked “detections” that appear only after the continuous integral.

### 1.4 Maxwell in the machine — picture vs current

Continuum Maxwell is a picture. The seal is **integer charge counts, integer flux linkages, integer samples**. Faraday’s appointment is a clock (the second the flux changes) and a track (the circuit). A float FEM of \(\nabla\times E = -\partial B/\partial t\) that two vendors cannot replay is not electromagnetism. It is shear.

---

## 2. Health — the dose that two hospitals cannot replay is not a dose

Health already pretended to be integer (milligrams, beats, mmHg) and then **did the arithmetic in floats**. That is why trials fork, why PK models miss the next patient, and why a p-value can be a career.

### 2.1 Pharmacokinetics — the exponential is dead as a seal

**Old:**

\[
\frac{dC}{dt} = -k C,\qquad
C(t) = C_0 e^{-k t}
\]

\(k\) is a float. \(e^{-kt}\) is a libm. Two hospital pharmacies with two compilers get two curves. AUC is a trapezoid of floats. Clearance is a ratio of floats.

**Why inaccurate:** the same crime as Study 11. The body is a **count** (molecules, ng, millilitres). The exponential is a continuous interpolation that **predicts the count from a real integral**. At a sealed dilation the float volume already missed by tens to hundreds of lattice points. A concentration curve is a volume in disguise.

**New:**

\[
C = \frac{n_{\text{mass}}}{d_{\text{vol}}}\quad\text{(exact rational)},\qquad
\Delta C \text{ per } \Delta\tau \text{ is an integer mill-unit step.}
\]

Half-life is a **count of beats or seconds until the numerator halves under a sealed map**, not \(t_{1/2}=\ln 2/k\).

**Proves:** a dose is an appointment in mill-units.  
**Solves:** the silent fork between “model predicted 4.73 µg/mL” and the assay’s integer bin.

### 2.2 Hill / Emax — dead as a response court

**Old:**

\[
E = E_{\max}\frac{C^n}{\mathrm{EC}_{50}^n + C^n}
\]

Four floats and a real power. The curve can be fitted to anything. The fit is not a seal.

**New:** response is an **ordinal**: more ligand, more occupied sites, compared by cross-multiplication of integer occupancies. \(\mathrm{EC}_{50}\) that cannot be written `num/den` is not a constant. It is a fit.

### 2.3 The p-value and the Cox model — dead as truth

**Old:**

\[
p = \Pr(\text{data or more extreme}\mid H_0),\qquad
h(t\mid X) = h_0(t)\,e^{\beta\cdot X}
\]

Likelihoods live in \(\mathbb{R}\). Cox multiplies a baseline hazard by a float exponential. Two stats packages, two \(p\)s.

**New:** pre-register the **integer law** (Study grammar: clock, track, adversary). Grade WIN / MISS / VOID on the raw counts. A hazard that is not a rational intensity on a sealed clock is a story.

**Proves:** significance is not an appointment.  
**Solves:** the reproducibility crisis at the number system, not at the press-release.

### 2.4 Radiation, labs, vitals

| Habit | Dead equation / practice | Lattice replacement |
|---|---|---|
| Absorbed dose | Gy as float gray | Integer ionization counts / monitor units |
| BMI / eGFR | real formulae on real weights | mill-unit mass, micromole creatinine, rational ratio |
| ECG / EEG | IIR floats, “filtered then measured” | integer samples; filter named as **adversary** if it changes the seal |
| Imaging SUV | float PET uptake | raw counts; normalization fork = Study 07’s `csv_norm` |

**Health is dead** in the only sense that matters here: a continuum PK/PD/stats stack **cannot be the court** that releases a drug or a gray. The assay already writes integers. Affine reads them.

---

## 3. Finance — the price that two matching engines cannot replay is not a price

### 3.1 Black–Scholes — dead as a seal

**Old:**

\[
\frac{\partial V}{\partial t} + \frac12\sigma^2 S^2\frac{\partial^2 V}{\partial S^2} + r S\frac{\partial V}{\partial S} - r V = 0
\]

and the closed form with \(\mathcal{N}(d_1),\ \mathcal{N}(d_2)\) — the Gaussian CDF in floats, \(\sigma\) a real, \(r\) a real.

**Why inaccurate:** \(S\) in the world is an **integer tick**. \(\sigma\) is a fitted float. \(\mathcal{N}\) is a numerical integral. Greeks are derivatives of a picture. Study 12 already killed the idea that a continuous “probability” equals the discrete product. A risk-neutral measure is a Born rule for money.

**New:**

\[
\text{tick}\in\mathbb{Z},\quad
\text{spread}\in\mathbb{Z},\quad
\text{PnL}=\sum \text{integer lots}\times\text{integer ticks}.
\]

Discounting is a rational \(\frac{n}{d}\) per sealed period — not \(e^{-rt}\).

**Proves:** an option’s continuum PDE is a picture of a tick lattice.  
**Solves:** books that “mark” to a libm and then discover the exchange already settled in integer cents.

### 3.2 Geometric Brownian motion / VaR — dead

**Old:**

\[
dS = \mu S\,dt + \sigma S\,dW,\qquad
\mathrm{VaR}_\alpha = \inf\{x:\Pr(L>x)\le 1-\alpha\}
\]

Monte Carlo of Wiener increments in IEEE-754. Different seeds, different engines, different “99%” losses. That is not risk. That is shear with a confidence interval.

**New:** loss is a **count of ticks**. Tail law is a **pre-registered integer threshold** on a public clock (the session, the fix). Adversary = the float Monte Carlo that misses the sealed count (Study 11 grammar).

**Finance is dead** as a continuum court. The tape was always integer. The academy computed a fluid. Affine reads the tape.

### 3.3 CAPM / β

**Old:** \(r_i = r_f + \beta_i(r_m-r_f)+\varepsilon\) with float regression.  
**New:** covariation is integer tick co-counts on a sealed bar. \(\beta\) that cannot be `num/den` is a magazine.

---

## 4. Computer science — the machine already knew; the math libraries lied

### 4.1 IEEE-754 — the cancer named

**Old law the industry shipped in 1985:**

\[
(a+b)+c \;\stackrel{?}{=}\; (a+c)+b \qquad\text{FALSE in float.}
\]

Distributed consensus on floats is a contradiction. Two cells, two reduction orders, two bit patterns, two “truths.”

**New:**

\[
\frac{a}{b}+\frac{c}{d}=\frac{ad+bc}{bd}\qquad\text{(exact)},\qquad
\text{seal} = \mathrm{SHA256d}(\text{integer payload}).
\]

Study 12’s adversary \(751/1000\) is the mascot of every `float` probability in a neural net, a compiler heuristic, and a “confidence.”

**Proves:** a transported program is a lattice program.  
**Solves:** mesh desynchronization, irreproducible ML runs, “it worked on my GPU.”

### 4.2 Loss functions and “learning”

**Old:** \(\mathcal{L}=\frac1N\sum (\hat y_i-y_i)^2\) in float32, backprop through libm.  
**New:** labels are integers; scores are rationals; update is a sealed rotation of a vQbit, not a gradient in \(\mathbb{R}^n\). A model that cannot replay its verdict on a second cell has not learned. It has sheared.

### 4.3 Complexity over the reals

Blum–Shub–Smale and “real RAM” assume unit-cost reals. That machine **does not exist**. The machine that exists is integer. Ehrhart (Study 11) is the complexity of volume: **count**, do not integrate. Parallel repetition (Study 12) is the complexity of chance: **multiply rationals**, do not tensor \(\mathbb{C}\).

### 4.4 Types

`Float`, `Double`, `TimeInterval` as seal-path types are **retired**. Duration is `Int64` nanoseconds or `Rational(nanos, 1_000_000_000)`. Constraint 3 is not style. It is the impact study in one compiler trap.

---

## 5. Engineering — leave the fluid they built the plant on

This is the section engineering does not want and cannot dodge.

### 5.1 Navier–Stokes — dead as a seal, not as a sketch

**Old (the equation civilizations poured steel and airframes on):**

\[
\frac{\partial u}{\partial t} + (u\cdot\nabla)u = -\frac{1}{\rho}\nabla p + \nu\nabla^2 u + f,\qquad
\nabla\cdot u = 0
\]

Reynolds-averaged (RANS):

\[
\frac{\partial \overline{u}_i}{\partial t} + \overline{u}_j\frac{\partial \overline{u}_i}{\partial x_j}
= -\frac1\rho\frac{\partial\overline p}{\partial x_i}
+ \nu\nabla^2\overline{u}_i
- \frac{\partial}{\partial x_j}\overline{u_i' u_j'}
\]

The last term — Reynolds stress — is a **float closure**. \(k\)–\(\varepsilon\), \(k\)–\(\omega\), LES Smagorinsky: more floats fitted to the debris of the first floats.

**Why this lacks precision (measured grammar, not taste):**

1. **It lives in \(C^\infty\) / \(L^2\).** The Clay question (exist, unique, smooth) is a **continuum** question. A question that cannot be stated as an integer appointment is not a seal question. Ninety years of analysis did not fail because the field is stupid. It failed because **the object was never a lattice point**.
2. **Every CFD code shears it.** Finite volume / finite element / spectral: the residual is IEEE-754. Two vendors, two meshes, two “converged” lift coefficients. The aircraft is one. The numbers are not.
3. **Volume and flux are Study 11.** A control volume’s mass is a **count**. CFD predicts that count from \(\int \rho\,dV\) in floats. At sealed dilation the float-volume adversary already missed **every** corpus polytope (errors +47, −19, −167, +47, +835). A fuel tank, a cabin, a blood chamber, a reactor loop is a polytope. **The plant was sized on the adversary.**
4. **Vorticity is Study 13.** \(\omega=\nabla\times u\) in reals is a spectrum-shaped object. Linking on the Eisenstein lattice is a walk \((q,r)\). Circulation that cannot be written as an integer linking class is not a transported invariant.
5. **The ocean already voted.** Study 04: a tsunami is **not** a Navier–Stokes demo. It is an origin **second** and a Huygens appointment in **integer minutes** on public gauges. Sandy’s **larger** height kept **no** appointment. RANS of “the surge” would have been proud of the height and blind to the clock. That is the whole crime.

**Shallow-water picture (legal as sketch, illegal as seal):**

\[
c=\sqrt{gH}
\]

Study 04 pins a **solver + bathymetry version** so every replayer gets the **same integer minute**. Live `sqrt` in a random libm is the adversary.

### 5.2 What engineering must leave

| Built on | Why it lacks precision | Leave-behind |
|---|---|---|
| RANS / LES digital twins | Closure floats; mesh-dependent residuals | Integer conservation on a sealed lattice; twin must **replay** |
| FEA stress in `double` | Stiffness \(\int B^T C B\,dV\) is Study 11’s integral | Exact facet / element counts; rational constitutive `num/den` |
| “Converged to 1e-6” | A float tolerance is not an appointment | WIN / MISS on integer residuals |
| Wind-tunnel CFD correlation | Magnitude matching (lift within 3%) | Shape: separation line, shedding **clock**, integer strouhal counts |
| Pipe networks / HVAC | Moody chart, float Darcy–Weisbach | Head in mill-units; Reynolds **number** retired as a seal (it is a real ratio) |
| Blood-flow / airway CFD | Same NS stack inside a body | Health §2 — millilitre counts, not \(\nu\nabla^2 u\) theater |
| Fusion / reactor CFD | Continuum closures at the edge | Entropy cap; no synthetic term when the float shears |

**Reynolds number**

\[
\mathrm{Re}=\frac{UL}{\nu}
\]

is a **real**. It is a useful **picture** of a regime. It is **not** a seal. Two labs with two \(\nu\) tables already disagree. Affine compares integer mass flux to integer viscous mill-units by cross-multiplication. The regime is an ordinal, not a float badge.

### 5.3 The new fluid equations (what they prove and solve)

**Mass (count):**

\[
\sum_{\text{faces}} \Phi_{\text{in}} - \sum_{\text{faces}} \Phi_{\text{out}} = \Delta M,\qquad
\Phi,M\in\mathbb{Z}\ \text{(mill-units).}
\]

**Momentum (mill-units per beat):**

\[
\Delta (M V) = \sum F\,\Delta\tau,\qquad
V=\frac{n}{d},\ F,\Delta\tau\in\mathbb{Z}.
\]

**Incompressibility as fairness (no float divergence):**

\[
\sum_{\text{faces}} \Phi = 0 \quad\text{(exact integer).}
\]

Not \(\lvert\nabla\cdot u\rvert<\varepsilon\).

**Vorticity as linking:**

\[
L(\gamma)=(q,r)\in\mathbb{Z}^2
\]

A closed material circuit that is the same circuit after the relators of the domain **lands on the same link** (Study 13). A float \(Q\)-criterion blob is the spectral adversary.

**Volume of the vessel:**

\[
\mathrm{vol}=\frac{\Delta^d h(0)}{d!}
\]

from counted lattice points (Study 11). Not \(\sum_e \det(J_e)/6\) in `float64`.

**Energy:**

\[
E = \frac{n}{d}\quad\text{rational},\qquad
\text{dissipation is a counted drop, not }\nu\int\lvert\nabla u\rvert^2.
\]

**Proves:** a fluid system that matters (wing, vessel, coastline, reactor) has **appointments** — mass counts, arrival minutes, shedding periods — that the NS+float stack is structurally unable to keep identical across vendors.  
**Solves:** the precision gap engineering has been papering with “mesh independence studies.” Those studies compare two shears. They do not reach a seal.

### 5.4 What this does **not** say

It does not say air is not a fluid, or that a picture of NS is useless for intuition. It says the **systems** — certificates, twins, load ratings, evacuation clocks — **cannot be built on that picture as if it were a court**. Study 04 already built the ocean court: origin second, integer minutes, height as the **adversary**. That is the template for every pipe, wing, and artery.

---

## 6. One table — old equation, why dead, what replaces it

| Domain | Equation that is no longer a court | Why | New equation / law | What it solves |
|---|---|---|---|---|
| Geometry | \(\mathrm{vol}=\int_P\) | Study 11 MISS | \(\Delta^d h(0)/d!\) | Replayable volume |
| Chance | \(\Pr=\lvert\alpha\rvert^2\) | Study 12 MISS | \((3/4)^n\in\mathbb{Q}\) | Transported bound |
| Algebra | spectral gap | Study 13 MISS | \(L(w)=(q,r)\) | Rigid identity of words |
| Gravity | \(G_{\mu\nu}=8\pi T_{\mu\nu}/c^4\) as object-factory | 07 / 10 | clock + track + integer table | No synthetic mass |
| QM evolution | \(i\hbar\partial_t\psi=H\psi\) as float ψ | 12 | vQbit rational rotation | No amplitude theater |
| Stats | \(Z=\int e^{-\beta H}\) | 10 stack | count + pre-register | No stacked particle |
| PK | \(C=C_0 e^{-kt}\) | libm fork | mill-unit rational \(C\) | Dose two hospitals share |
| Trials | \(p\)-value, Cox \(e^{\beta X}\) | ℝ likelihood | WIN/MISS on counts | Reproducibility |
| Options | Black–Scholes PDE | \(\mathcal{N}(d)\) float | tick lattice, rational discount | Marks that match the tape |
| Risk | GBM + VaR Monte Carlo | seed shear | integer loss counts | Risk that replays |
| CS | IEEE-754 sums | non-associative | Rational + SHA256d | Mesh consensus |
| ML | float loss + backprop | 12 adversary | integer labels, rational score | Replayable verdict |
| Fluids | NS + RANS closures | continuum + float mesh | integer \(\Phi\), linking, Ehrhart vol | Plant/twin precision |
| Ocean | \(c=\sqrt{gH}\) live float | libm | pinned minutes (Study 04) | Evacuation clock |
| Blast | spectral P/S | float discriminant | 53±2 s integer SNR (Study 06) | Treaty ladder |

---

## 7. What “dead” means (no theatre)

**Dead** = may not sign a seal, a dose, a mark-to-market that claims truth, a load rating, a consensus, or a discovery.

**Not dead** = may still be drawn on a blackboard to tell a human where to look. The blackboard is not the ledger.

Einstein’s continuum stays as the **best 1915 picture of a field**. Affine’s Eisenstein lattice is the **2026 court of a measurement**. Fluid dynamics stays as the **best 19th-century picture of a stream**. Integer conservation plus linking plus Ehrhart volume is the **court of a plant**.

The assumption that just broke is the same in every row: *the adult form of the integer table is a real equation.* It is not. The real equation is a **lossy projection**. Project first, certify, dose, price, or fly, and you will certify your projection.

---

## 8. Reproduce the pillars

```bash
python3 corpus/study-11/study11_grade.py
python3 corpus/study-12/study12_grade.py
python3 corpus/study-13/study13_grade.py
```

SHA256d lock: `9921436ca7e15481d2f7246db6038c2cb434e41e94b38d9f3e0de3ddb6ef69b5`  
[Peer-review bundle](Peer-Review-Conjecture-Bundle) · [The lattice holds](The-Lattice-Holds)

---

**Zero float. Zero shear. Physics, health, finance, and continuum CFD are pictures. The lattice is the court.**
