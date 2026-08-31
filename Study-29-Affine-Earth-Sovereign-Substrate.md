# Study 29 — The Affine.Earth sovereign substrate

**OPEN — validation charter only; no pod built, no tier run.** What this study freezes is a four-tier validation protocol — T1 thermal soak, T2 zero-heap ingest, T3 NATS leaf asymmetry, T4 asynchronous JetStream replay — each with the exact observation that fails it and a control arm proving the detector fires. **All four tiers now carry frozen integers.** Two of T1's are conditional — its cell ceiling pins when a cell is named, and its harvester bound requires resizing the drafted panel — so **T1 cannot be run today**; T2, T3 and T4 are runnable against a built pod. **T1 is additionally blocked** by a rated-input overrun in the drafted power chain, named in Section zero and carried in Open issues rather than papered over. The geometry rows are shipped and measured at their true extent — a three-axis spatial quotient map with an explicit winding number, not an eight-axis map onto T⁸. The hardware rows are a drawing and are marked as drafted everywhere they appear. **This page is not a shear study**; it carries one of the recipe's four pieces and says which.

## Two halves, two maturities, named before anything else

This page carries a shipped half and a drafted half, and conflating them would be the study's easiest failure. The **geometry** — the flat 8-torus wire, the quotient map with its winding number, the unimodular bijection — is running code in this repository, measured this session, and cited below with file and line. The **hardware** — the $15-class A.E.P-1 pod, its enclosure, its power chain, its bill of materials — is a drawing. Every number in the hardware section is a datasheet figure or a distributor price, not a measurement of a built object, and the four-tier protocol exists precisely because a drawing is not evidence.

The subject is a zero-extraction terrestrial digital-twin mesh: open pods, owned locally, that publish an integer displacement and nothing else. Local entities own the hardware, the spectrum use, and the telemetry. Only an 8-tuple integer displacement crosses to the global mesh. The licensing follows the same seam — CERN-OHL on the hardware, Apache-2.0 on the transport, with the vQbit state machine and the UUM-8D quantiser proprietary behind a hardware abstraction layer whose header is published in full below.

## The geometry, and the quotient map that ships — stated at exactly its measured extent

**T⁸ = R⁸/Z⁸ — the orientable flat 8-torus.** An affine space is a vector space whose origin has been forgotten: only displacement is represented, absolute position is not. That is not a metaphor chosen for this page; it is the property the wire needs. A pod that publishes *where it is* has surrendered something. A pod that publishes *how far the world moved* has surrendered a displacement, and a displacement on a torus does not name a point.

**What ships is a three-axis wrapped lattice with windings, and this page previously overstated it as eight.** An earlier pass wrote "the eight axes together are the map onto T⁸" and tagged it shipped. Read in source: `UUM8DFactCoordinate.wrapped()` — `cells/xcode/Sources/InvariantCompiler/UUM8DFactCoordinate.swift:261` — is real, is floored modulo with an explicit winding, and the wire block at `:304` emits windings for **`sx`, `sy`, `sz` only**. The record's remaining fields — `tOrdinal`, `kvDigestHex`, `kwMass`, `ptElevationFt`, `phiVariance`, `addLaw`, `entropyCap` — are emitted raw, unwrapped, carrying no winding. **The three spatial axes that form the NATS routing subject are wrapped. The full eight-axis map is not shipped.** The verbatim source line, `&+=` and all:

> `var cell = shifted % span; if cell < 0 { cell &+= span }; let winding = (shifted - cell) / span`

**The clamp repair is real and is the strongest shipped thing on this page, at its true size.** `mortonBitsPerAxis = 21` and `mortonScale = 2¹⁸`, so the pre-change code pinned anything with |value| ≥ 4 to the ceiling cell 2097151 — the source's own worked table at lines 228–233 shows `sx=4`, `sx=5`, `sx=1000` and `sx=2147483647` all landing there. Because the first axis **is** the routing subject, every fact past ±4 routed to the same sector as every other: distinct facts collapsed onto one cell, and a centralised store wearing a lattice's name. Wrapping is not a wider clamp; it is a different operation — total, and injective inside one period.

**Two different objects, named apart so the tag cannot migrate.** The shipped `UUM8DFactCoordinate` record (three wrapped rationals, an Int64 ordinal, a String digest and four further rationals) and the pod's proposed **16-byte 8-tuple displacement** are not the same object. The first ships today and is cited above. The second is drafted, and nothing in the shipped record certifies it.

## The unimodular claim, and the control arm that actually discriminates

An 8×8 integer matrix with det = ±1 is a bijection on Z⁸: its inverse is again integral, so lattice points map to lattice points **in both directions**. Reproducible — a composition of ten elementary shears `(t, s, c)` = (0,1,3), (2,0,−1), (4,3,2), (1,5,−4), (6,2,1), (7,6,5), (3,7,−2), (5,4,3), (2,6,−1), (0,7,2), each det = 1 by construction; determinant by fraction-free Bareiss elimination, integer throughout; source point set the 4,000 tuples `(a, b, c, e, a−b, b−c, c−e, a+e)` for a,b,c ∈ [0,10), e ∈ [0,4).

**Result: det = 1, and 4,000 distinct points map to 4,000 distinct integral images.** Generator, determinant and both control arms are one self-contained Swift program with no imports and no floats; it prints the table below and is the artifact a stranger re-runs.

**And that result, alone, is an instrument that cannot fail — measured, not assumed.** The obvious control arm is to push a non-unimodular matrix through the same harness and watch the image count collapse. It does not collapse. Measured this session:

| Matrix | det | distinct images of 4,000 | reaches e₁ = (1,0,…,0) |
|---|---|---|---|
| composed unimodular | 1 | **4,000** | **yes** |
| diag(2,1,…,1) | 2 | **4,000** | **no** |
| two equal rows | 0 | **4,000** | — |

Every nonsingular integer matrix is injective on Z⁸, so a det = 2 map separates 4,000 points exactly as well as a unimodular one; and a singular map can still be injective *on a finite sample*, which is why even det = 0 scores 4,000 here. **The image count measures injectivity, and injectivity is not the property being claimed.** What det = ±1 buys is *surjectivity onto Z⁸* — an integral inverse — and the arm that detects it is reachability: under diag(2,1,…,1) every image has an even first coordinate, so **e₁ is unreachable**, while under the unimodular map it is reached. That row is the discriminating arm; the image-count row is a smoke test on a theorem, and this page labels it as one rather than presenting it as evidence.

This is the program's own rule applied to the program's own page: an instrument must discriminate, and always-green is a defect whether or not the thing it is measuring is true.

## The transform is lossless; the ingest is not

**Z⁸ → Z⁸ under a unimodular map is bijective and lossless.** Proved by the determinant, and the reachability arm above shows the property being claimed is the one being tested.

**R → Z⁸ is many-to-one, and it is the one irreversible step in the pipeline.** A sensor produces a voltage; the quantiser produces a lattice point; an interval of voltages maps to one point, and nothing downstream restores the interval. So "lossless" is a true statement about the **transform** and a false statement about the **pipeline**. A page that says the second while meaning the first has claimed the physical state is recoverable from the delta. It is not.

The honest claim, and it is still strong: **lossless at the chosen resolution**, with the resolution published as a number an implementer checks against their own sensor's noise floor. The wire units are 10⁻³ °C, 10⁻³ %RH and 1 Pa, and the implementer's obligation is one comparison: is the quantiser step at least an order below the sensor's datasheet RMS noise? If it is, the lattice point carries everything the sensor actually resolved. If it is not, the pod is publishing digits its sensor never earned. **This page pins no sensor part, so it does not perform that check; it states the check and names it as owed** (Open issues).

**And the wire carries no winding, which is a constraint rather than an oversight.** The frozen payload is 16 bytes — eight `int16` displacements — with no room for a sheet index, so a delta is recoverable only while it stays inside one period. **Frozen charter bound: |Δ| < span/2 per axis.** The delta-driven architecture below is what makes that bound natural rather than lucky: a pod transmits on threshold breach, so its displacements are small by construction, and a breach large enough to wrap is a different event that the charter requires be published as a wrap rather than silently aliased. T3's payload criterion grades the 16-byte width; this bound is what makes the width sufficient.

Never claimed anywhere on this page: that the exact physical reality can be reconstructed from the delta.

## Reversibility buys computational integrity, not heat

A reversibility argument is available here and the thermodynamic version of it does not survive arithmetic.

**Measured:** erasing a 256-bit delta has a Landauer bound of **7.35 × 10⁻¹⁹ J at 300 K** (kT ln 2 = 2.871 × 10⁻²¹ J/bit, times 256 — re-derived this session, VERIFIED). Against the energy budget below: the compute-and-quantise wake window is **9.9 × 10⁻³ J**, a factor of **1.3 × 10¹⁶** above the bound, and a whole delivered report at **53.3 × 10⁻³ J** is a factor of **7.3 × 10¹⁶** above it. Which term you choose as "the erasure work" moves the exponent not at all; the answer is 10¹⁶ either way, and that is the entire point.

Sixteen orders of magnitude is not a margin to be closed by tidier logic. Logical reversibility executed on irreversible CMOS yields no thermodynamic saving; the bound is not what any of that energy is spent against. Realising it would need adiabatic hardware, which the A.E.P-1 is not and does not claim to be.

**Where reversibility actually pays, and it is the payoff the substrate uses:** computational integrity. Any cell can replay the state and re-derive the verdict, because the delta stream is a reversible record and the transform over it is a bijection. That is Constraint 6 (Bennett) as this substrate actually consumes it — the property that lets two cells that were never simultaneously online reach the same answer, which is exactly what T4 grades. Reversibility belongs in the integrity argument. It does not belong in a heat argument, and it is not put in one here.

## Section zero — the discrimination gate

Before any pod is graded, each tier must be shown able to fail. **A tier that cannot fail is not a tier** — the program has retired an instrument for exactly that defect, and always-green and always-red are the same defect. Each tier below names the exact observation that fails it and the control arm that proves the detector fires. All of it is frozen in this charter, before any hardware exists.

**Stated plainly and first: no pod has passed any tier. No pod has been built. T1 is blocked.**

### T1 — Thermal soak

A pod in its louvered Stevenson-screen enclosure (ASA or PETG), powered only from its own solar-and-storage chain, held across the enclosure's stated envelope through at least one full diurnal cycle.

- **The observation that FAILS it:** the charger asserts charge current while the cell's own temperature sits outside the charge window printed in that cell's datasheet; **or** any brownout reset in the session log; **or** an internal enclosure temperature more than a frozen ΔK above shade ambient at solar noon (ΔK to be pinned to the enclosure geometry at build stage, before the first soak, and not after).
- **The control arm:** the same detector run against a deliberately mis-clamped cell — charge asserted at a bench-forced out-of-window temperature — must fire. A soak harness that reports PASS on a rig built to fail it is a broken scorer, and the study halts on an instrument defect rather than scoring physics.
- **T1 IS BLOCKED, and the blocker is a real design defect, not a paperwork gap.** The BQ25570 carries a rated **Peak Input Power of 510 mW** (REPORTED — TI SLUSBH2G). The drafted pod pairs it with a 1–2 W panel. That is an overrun of 2.0× against a 1 W panel and 3.9× against 2 W. The repair is one of two things and this page does not pretend otherwise: a different PMIC rated for the panel, or a panel sized to the PMIC. **And the input limit is not the only one.** The part's buck output is rated **110 mA typical** (REPORTED, same datasheet), while the ESP32-C6 draws **295–382 mA** during a 2.4 GHz transmit — so the drafted ESP-NOW path cannot be sourced from VOUT at all. The standard resolution is to use the BQ25570 purely as the MPPT charger and run the MCU from VBAT with bulk capacitance sized for the burst, but that is a different topology from "powered by the BQ25570" and the page must say which one the pod uses. A third specification is widely mis-quoted in secondary sources: cold-start VIN(CS) was revised upward to **600 mV typ / 700 mV max**, not the 330 mV still in circulation. **And TI listed the part out of stock at the time of checking** — a single-source PMIC in an open-hardware BOM whose premise is that anyone can build it. **Until that is resolved, T1 cannot be run, and running it anyway would grade a rig operating outside a component's rated envelope.**
- **On the cell temperature boundary: it is per cell, not per chemistry.** "LiFePO4 tolerates >45 °C" is directionally right and is not a specification. The boundary that binds is the one on the specific cell's datasheet — a representative LiFePO4 cell specifies charge 0 to 55 °C and discharge −20 to +60 °C, and those two windows are different from each other, which is the entire content of the criterion. The cell part is not pinned on this page (Open issues), so T1's window integer is not frozen yet either, and it is named as owed rather than invented.

### T2 — Zero-heap ingest

The HAL ingest path allocates nothing at runtime.

- **The observation that FAILS it:** a non-zero delta in the allocator's own high-water mark across 10,000 consecutive `vqbit_ingest_telemetry` calls; **or** any allocating call site present in the declared ingest file set; **or** any float type crossing the HAL boundary in either direction.
- **The control arm:** a probe build with one deliberate heap allocation inserted in the ingest path must be caught by the same detector, and a probe with one deliberate `float` parameter must be caught by the type arm. A gate that is green on both the clean build and the sabotaged build is measuring nothing.
- **The scoping caveat, carried from the substrate's own history rather than discovered here:** a source scan is blind to implicit allocation — ARC boxing, existential containers, closure capture, array copy-on-write — and blind to hot-path frequency. The high-water-mark arm exists because the source arm alone would report a zero it has not earned. Both arms run; a pass requires both.

### T3 — NATS leaf asymmetry

The pod is a leaf. It publishes an 8-tuple integer displacement and subscribes to nothing carrying execution state.

- **The observation that FAILS it:** a full-session packet audit showing any inbound subject outside the frozen allow-list; **or** any outbound payload whose byte length exceeds the frozen 8-tuple wire size; **or** a tool-surface enumeration returning any tool that reaches past the delta ring buffer.
- **The control arm:** a probe leaf configured with one extra inbound subject must be caught by the audit, and a probe surface with one extra tool must be caught by the enumeration. Absence of a finding on an un-probed detector is not evidence.
- **What this tier does and does not establish** is written out in the audited-boundary section below, because the strong-sounding version of this claim is the wrong one.

### T4 — Asynchronous JetStream replay

Two cells that were never simultaneously online re-derive the identical verdict from the same delta stream.

- **The observation that FAILS it:** any byte difference between the two re-derived verdicts; **or** a verdict that changes with delivery order; **or** a verdict that cannot be re-derived at all from the stream alone.
- **The control arm:** a probe replay seeded with one reordered delta must produce a difference the comparator catches, and a probe with one flipped bit must too. A comparator that reports IDENTICAL on a corrupted stream is the always-green failure and halts the study.
- **This is the tier the whole geometry exists to make gradeable.** Byte-identical replay is available only because the transform is exact and integral: two cells executing the same integer arithmetic over the same integer deltas cannot disagree in a last bit, because there is no last bit to disagree about.

**The frozen integers, all four tiers, before any pod exists.**

| Tier | Frozen | Fails on |
|---|---|---|
| **T1** soak | duration ≥ **259,200 s**; chamber air ≥ **45,000 milli-°C** for ≥ **246,240 s** (95%); applied thermal load **2,000 mW** **on the enclosure exterior**; harvester input bounded ≤ **510 mW**; ingest period **60,000,000,000 ns** ± **100,000,000 ns**; cell charge ceiling **55,000 milli-°C** *from the pinned cell's datasheet* | a boot-count delta other than 0; any second below 45,000 milli-°C beyond the 12,960 s allowance; any non-zero charge current recorded above the cell ceiling; any inter-sample interval outside the jitter bound; any NVS write returning non-zero |
| **T2** zero-heap | ingest cycles ≥ **100,000**; heap high-water delta between cycle **1,000** and **100,000** exactly **0 bytes**; allocator-hook count exactly **0** | any non-zero high-water delta, or one or more allocator hooks, attributable to a call site inside the ingest loop |
| **T3** leaf asymmetry | packet capture ≥ **86,400 s**; inbound application frames exactly **0** (`PING`, `PONG`, `INFO`, `+OK`, `-ERR` and the JetStream ack enumerated **by name** and excluded by name, never by inference); `SUB` frames outside the frozen ack inbox exactly **0**; published subject string-equal to the frozen allow-list; published frame length exactly **42 bytes** | one frame. One inbound application frame, one subscription outside the ack inbox, one subject not string-equal, or one frame whose length is not 42 |
| **T4** replay | NVS ring **2,048 records × 42 B = 86,016 bytes** = **122,880 s** (34.1 h) of retained outage at the 60 s cadence; sever arm A ≥ **3,600 s**; sever arm B ≥ **126,480 s**, chosen to force a wrap; stream duplicate window **172,800 s** | any sequence gap inside the retained window; any duplicate accepted (a deliberate re-publish must be rejected by `Nats-Msg-Id` dedupe, and acceptance is a FAIL); a wrap reporting zero overwrites; **one differing byte** between flushed and locally sealed 8-tuples |

**The control arms, one per tier, each proving its detector fires.** T1: a bench-forced out-of-window charge must be caught. T2: a second build carrying exactly one deliberate 16-byte allocation in the ingest loop **must** read a non-zero hook count — if the clean build reads 0 and the sabotaged build also reads 0, the instrument cannot distinguish and the study halts on an instrument defect rather than scoring a pod. T3: a capture taken with the radio disabled prints **`CAPTURE_ABSENT`**, never PASS, because absence and a pass are different answers; and a build deliberately published to a wrong subject must be caught. T4: a reordered delta and a flipped bit must each produce a difference the comparator catches.

**Two integers above are conditional, and the page says which.** T1's **55,000 milli-°C** is a representative LiFePO4 figure and becomes frozen only when a cell is pinned by manufacturer and part number — the boundary is per cell, not per chemistry, and quoting a chemistry here would repeat the defect the criterion exists to catch. T1's **≤ 510 mW harvester bound requires resizing the drafted 1–2 W panel**, which is a proposed change to the specification rather than a reading of it; until that resize or a different PMIC is chosen, **T1 cannot be run**. The other integers are frozen as printed and do not move after scoring. A FAIL is published as a FAIL, on this page, with the same prominence as a pass.


## The two readings and where they disagree

| Reading | What it holds constant | The observation that separates it | Sourcing |
|---|---|---|---|
| **Orbital uplink** — terrestrial sensing is a bandwidth problem; put a broadband link at every node and ship the raw stream | The magnitude: it genuinely delivers megabits per node, and for workloads that need megabits there is no substitute and this page does not pretend there is | It is a **metered subscription on hardware and spectrum the local entity does not own** — one per node, or one per aggregation group, and the cost section below concedes that the aggregated form is price-competitive with the pod mesh and in some markets cheaper. Measured mid-2026: terminals $199–2,500 by SKU (Mini $199–249, Standard $349 — the modal consumer figure, Performance $1,999, Enterprise $2,500), or $10–15/month rented, US residential service $55–130/month (REPORTED). Energy follows the same shape: a tracking terminal at 60 W spends ~2.16 × 10⁵ J per hour of availability regardless of how few integers crossed. | REPORTED (prices, terminal power class); arithmetic VERIFIED |
| **Terrestrial integer lattice** — the mesh needs a displacement, not a stream; publish an 8-tuple and own the hardware | The shape: what crosses is a fixed-width integer displacement whose size does not grow with sensor count | An 8-tuple is 32 bytes as int32 and 16 as int16, whatever the pod is sensing. Airtime falls accordingly on this link and node energy is budgeted below, and the hardware, spectrum use and telemetry stay with the local entity. The delta is the whole export. | Airtime and energy VERIFIED (re-derived); hardware drafted |
| **The null** — the transport advantage is an encoding artifact, not a geometric one: any protocol engineer swapping verbose JSON for a tight binary encoding gets the same ratio, and the torus contributes nothing | Nothing; it predicts the ratio survives replacing the lattice with any compact binary schema | **This is not a straw man and Section zero does not retire it — the measurement below concedes it.** The 4.07× airtime ratio is largely an encoding result and is published as such. What the geometry contributes is *sufficiency and fixed width*: the 8-tuple is what the mesh needs, so the payload does not grow when the pod grows a sensor, and T4 is decidable because the arithmetic over it is exact. A compact binary re-encoding of a growing record buys the first ratio once and loses it again as the record grows. | Design statement of this charter |

The readings are separated on **shape, never magnitude**. The orbital reading is not the adversary because its numbers are bad — for the workloads it is built for they are excellent. It is the adversary here because its shape is wrong for *this* workload: a metered per-node subscription on non-owned hardware standing in for a fixed-width displacement on hardware the local entity owns.

## The pod — A.E.P-1, as drafted

| Element | Drafted part / choice | Status |
|---|---|---|
| MCU | ESP32-C6 (RISC-V), Wi-Fi 6 / BLE 5 / 802.15.4, ESP-NOW for pod-to-pod | Capability claims **SUPPORTED** by the Espressif datasheet (REPORTED) |
| Sub-GHz radio | SX1262 LoRa transceiver | Capability claims **SUPPORTED** by the Semtech datasheet (REPORTED) |
| Power management | BQ25570 solar harvester / charger | **DEFECT — see below** |
| Panel | 1–2 W photovoltaic | **DEFECT — see below** |
| Storage | LiFePO4 cell | Boundary is **per cell**, not per chemistry — cell not pinned |
| Enclosure | Louvered Stevenson screen, ASA or PETG | Drafted; ΔK criterion not yet pinned |
| Hardware licence | CERN-OHL | Drafted |
| Transport licence | Apache-2.0 | Drafted |
| vQbit state machine + UUM-8D quantiser | Proprietary, behind the HAL | Header published below |

**The power-chain defect, stated as an open hardware issue.** The BQ25570's rated **Peak Input Power is 510 mW** (REPORTED — TI SLUSBH2G, Absolute Maximum Ratings; Electrical Characteristics gives PIN 0.005–510 mW). Pairing it with a 1–2 W panel exceeds that rating by 2.0× at the low end of the drafted panel range and 3.9× at the high end. This is a real design defect in the draft, it blocks T1, and the page states it rather than papering over it. Two resolutions are admissible and neither is chosen here: a PMIC rated for the panel, or a panel sized to the PMIC. Whichever is chosen changes the harvest budget, and the energy figures below are stated against the pod's report rate rather than against a harvest assumption for exactly that reason.

**The $15 BOM does not close, and the arithmetic is published.** At 1k quantities the three named silicon parts alone are ESP32-C6-WROOM-1-N4 **$2.88** (DigiKey, tape-and-reel), SX1262IMLTRT **$5.70** (DigiKey) against **$4.87** (Mouser), BQ25570RGRR **$4.68** (DigiKey) against **$4.82** (Mouser) — all read August 2026 at the 1,000-unit break. **The spread matters and one quote would hide it**: the SX1262 differs by 17% between distributors, which moves the silicon floor by ~$0.83. Taking the cheaper quote on each line gives **$12.43**; the dearer gives **$13.40**, and that is before enclosure, panel, cell, PCB and sensor. **The defensible built cost is ~$22–30 at 1k.** Still unpriced and unavoidable: LiFePO4 cell (~$2–4), panel (~$1.50–4), T/RH/pressure sensor (~$1–3), PCB (~$1–2), RF matching, crystals, antenna and passives (~$1.50–3), enclosure filament (~$1–3), plus assembly and test. The $15 label names the class the pod aims at, and it is a target, not a measured build cost. The cost table below is computed at $25 and $30, never at $15.

**$15 is reachable only by changing the parts list, and the most interesting route is worth naming.** The ESP32-C6 already carries 802.15.4 and Wi-Fi, so a pod that meshes over ESP-NOW or Thread and reaches the gateway through its neighbours **does not need the SX1262 at all** — that is $5.70 of $13.40 removed, leaving MCU + PMIC at $7.28–7.70. What it costs is the long single hop: LoRa reaches a gateway kilometres away, a 2.4 GHz mesh needs neighbours. **Both topologies are admissible under this charter and they are different deployments**, dense-mesh versus sparse-star, and this page does not choose between them. Other routes: a lower-cost sub-GHz part (LLCC68, or third-party SX1262 modules at $2–4), or a commodity charger in place of the BQ25570. Each changes what T1 and T3 grade.

**Every BOM line above is a distributor price at a stated quantity break, read August 2026.** An undated, unqualified "$15" is the one number on this page a reader can falsify in ten minutes, which is why it is labelled a target everywhere it appears.

## The HAL, and the floats that left it

The drafted HAL header took `float temp_c`, `float humidity`, `float pressure`. Those are removed, deliberately, and the reason is a consensus property rather than a style preference: **two pods running different libm implementations quantise a float differently at the boundary**, and two pods that quantise differently place the same air on different lattice cells. That is the divergence Constraint 3 exists to prevent, and putting a float at the ingest boundary is the one place where it is guaranteed to bite — the boundary is where the many-to-one crossing happens, so a difference there is a difference in the published fact itself.

The published surface takes integer milli-units, in the spelling the codebase already uses on the wire (`alt_micro_m`, `azimuth_milli_deg`, `confinement_ppm`):

```c
int vqbit_ingest_telemetry(int32_t temp_milli_c, int32_t humidity_milli_pct,
                           int32_t pressure_pa, uint64_t timestamp_ns);
```

The integer conversion now happens once, in the implementer's own driver, against the implementer's own sensor — where it is visible, auditable and pinned to a datasheet — rather than inside a proprietary layer against whichever libm the toolchain shipped. T2's float arm is what keeps it that way.

## The audited boundary

The tool surface is an **audited boundary**, and the page is careful about what that word carries.

The surface enumerates to the delta ring buffer and nothing else. A packet audit over a full session, plus an enumeration of the advertised tool surface, together demonstrate that no execution state crosses — that is what T3 grades, and it is a demonstration about the configuration as audited, on the session audited. **No proof-by-signature is claimed anywhere on this page**, and the boundary is not asserted to be unbreakable; it is asserted to be enumerable and auditable, which is a smaller claim that a stranger can check and a larger one than an unexamined assertion.

The claim class, verbatim and load-bearing: **a presented configuration is verified; an unknown configuration is not searched.**

## Computed airtime — this workload, this link budget

**SX1262, SF9, 125 kHz bandwidth, CR 4/5, 8-symbol preamble, explicit header, CRC on, LDRO off.** These are **computed** from the closed-form time-on-air expression, not measured on a radio. Re-derived this session in exact integer microseconds from the standard LoRa time-on-air formulation — symbol time 2⁹/125000 s = **4096 µs exactly**, preamble (8 + 4.25) symbols = **50,176 µs** (VERIFIED, reproduced independently):

| Frame | Payload | Symbols | Airtime | Transmissions/hour at 1% duty |
|---|---|---|---|---|
| Float JSON telemetry frame | 201 B | 233 | **1004.544 ms** | **35** |
| **The frozen wire frame — 16 B delta + 26 B header** | **42 B** | **58** | **287.744 ms** | **125** |
| Δ int32 × 8, payload only | 32 B | 48 | 246.784 ms | 145 |
| Δ int16 × 8, payload only | 16 B | 28 | 164.864 ms | 218 |

**The frame is 42 bytes, not 16, and an earlier pass of this page priced the payload as though it were the frame.** The 16-byte figure is the *displacement* — eight `int16` axes — and it is correct as such. But T3 grades a published subject and T4 grades duplicate rejection and ordered replay, and neither is decidable without a header: **16 B delta + 26 B header (16-byte site id, 8-byte monotonic sequence, 2-byte schema version) = 42 B on the wire.** Pricing the delta alone credits the architecture with an airtime it never achieves.

**So the headline ratio falls, and this is the third figure on this page to fall on re-derivation.** Against the 201 B float frame: airtime 1004.544:287.744 = **3.49×**, transmissions per hour 125:35 = **3.57×**. The payload-only ratio of 6.28× describes a frame that cannot satisfy the gate this study freezes.
**The operational figure is 3.49×, and every other ratio on this page is a payload-only number that the frame does not deliver.** Airtime and transmission count differ *because* of the floor, and publishing both rather than smoothing them to one number is the point. The airtime ratio is below the payload ratio because preamble and header are fixed cost that no payload shrink removes. Airtime is what a 1% sub-band actually meters — duty cycle is regulated in **time**, not in bytes (REPORTED — the EU **868.0–868.6 MHz sub-band, band g1**, under ERC Recommendation 70-03 / ETSI EN 300 220; other sub-bands in the same regime carry 0.1% and 10% limits, so every count in this table is specific to g1) — so the count is floor(36 s ÷ airtime) in every row.

**Scope, stated rather than left to be inferred:** this is a claim about **this workload on this link budget** — a fixed 8-tuple at SF9/125 kHz on a 1% sub-band. It is not a claim that megabit uplinks are unnecessary in general. A workload that needs a megabit needs a megabit, and no lattice changes that.

## Delta-driven compute — the pod does not poll

**The architecture is event-driven, and this changes what the energy table means.** Continuous polling spends power holding a static environment under observation. Here the low-power sensors are tied to hardware interrupts on the ESP32-C6, and while the environmental state is unchanged the core stays in deep sleep. Compute is proportional to the displacement: on wake the node computes the geometric displacement, and **if the state change is below threshold the cycle terminates before touching the JetStream buffer or powering the radio**. Energy is expended when reality changes.

**So the 6.660 J/hour figure below is a ceiling, not an expectation.** It prices the pod at its maximum regulated transmission rate — every duty-cycle slot used, every hour. A delta-driven pod in a quiet environment spends the sleep term and almost nothing else: **81.8 mJ/hour** at the chip's 7 µA, which is roughly eighty times below the ceiling. The true consumption sits between those two bounds and is a property of the *environment*, not of the pod, which is why this page publishes both bounds and no single figure between them. **Neither bound is a measurement; both are budgets, and T1 is where they become numbers.**

**The falsifiable criterion this adds, and it belongs in the gate:** a pod held in a deliberately static environment for a full diurnal cycle must show a transmission count of **zero** and a current profile indistinguishable from the sleep budget. **The control arm:** the same pod given one threshold-crossing stimulus must wake, transmit exactly once, and return to sleep. A node that transmits on a static bench is polling with extra steps; a node that stays silent through a real excursion is a broken sensor. Both failures are observable in the same trace, and neither is currently measured because no pod exists.

## The state vector, local proper time, and what happens when the link drops

**The 8-tuple is now allocated, which T3's payload criterion required.** A node tracks a live state vector **v**(τ) on T⁸, and the allocation differs by node class:

| Node class | ⟨x₁, x₂, x₃⟩ | ⟨x₄ … x₈⟩ |
|---|---|---|
| **Stationary pod** | fixed spatial lattice anchors | thermodynamic and environmental transitions |
| **Mobile pod** (vehicle, drone, swarm) | evolve — spatial translation across the covering space | evolve |

What crosses is never **v** but the affine displacement **Δv**(τ) = **v**(τ_k) − **v**(τ_{k−1}). Affine space has no fixed origin, so a displacement is the only thing the node has to publish, and the evolution law is stated on the same terms: d**v**/dτ = **M** · **s**_telemetry with **M** ∈ GL(8, ℤ), det(**M**) = ±1. **GL(8, ℤ) is exactly the group of integral unimodular matrices**, so the transform section above is the statement of this law's invertibility, not a separate claim.

**One gap remains open and this page will not paper it.** The published HAL entry point takes three sensor scalars plus a timestamp, and the wire tuple has eight axes. **The map from three ingested scalars to five environmental coordinates is not stated anywhere**, and T3's payload criterion is undecidable until it is. Either the HAL grows arguments or the quantiser derives x₄…x₈ from a stated function of the three; both are admissible, neither is chosen here (Open issues).

**Local proper time τ replaces wall-clock synchronisation, and this is the sharpest idea in the architecture.** A disconnected node has no NTP and no GNSS discipline. Ordering is governed instead by a monotonic local counter, τ_{k+1} = τ_k + δτ, advanced once per deterministic state transition. On reconnection the upstream twin orders transitions by the pod's intrinsic τ rather than by arrival time, so clock skew and delivery races cannot reorder a node's own history. **This is what makes T4 gradeable**: two cells that were never simultaneously online re-derive the same verdict because the sequence is carried in the payload, not inferred from the network.

**Disconnected persistence is a pre-allocated NVS ring, and its depth is a hard bound.** Deltas are appended to a fixed cyclic buffer in non-volatile storage — no allocation, which is the Constraint 3b instance this hardware has to satisfy — and replayed in order to the nearest forwarder on mesh discovery, integrity checked by monotonic sequence id. **The honest limit: a cyclic buffer overwrites.** Reversibility lets intermediate states be reconstructed from deltas only while the chain is unbroken, so **the ring's depth sets the maximum tolerable disconnection**, and an outage longer than that does not degrade gracefully — it breaks the chain and the pre-outage history is not recoverable from what survives. **Frozen charter obligation: the ring depth is published as an integer, and a pod that overwrites an unsent delta must publish a gap marker rather than a clean sequence.** A silent overwrite is the always-green failure in storage clothing.

**The MCP-governed WASM sandbox.** Local logic — threshold alarms, sensor fusion, actuator commands — runs as pre-compiled bytecode on a zero-heap WASM micro-core with `malloc`/`free` disabled and memory mapped to fixed static pages. MCP defines the capabilities, the read-only segments and the export subjects; the guest reaches the pod only through the HAL and cannot inspect registers, thread contexts or host memory maps. **Where this bites the float rule, and it is not hypothetical:** the execution hook hands `sensor_data` fields straight to `vqbit_ingest_telemetry`, so **if `raw_telemetry_t` carries floats, the float boundary has simply moved one function outward** — the quantiser still receives a value that two toolchains can disagree about. The charter requires `raw_telemetry_t` to be integer-typed at the I2C/SPI read, with the conversion performed in the implementer's driver against a named sensor datasheet. T2's float arm grades the whole path, not just the published signature.

## The self-weaving mesh — opportunistic routing over terrain

**The net is not dropped from above; it is tied from below, one pod at a time.** Every deployment adds an anchor point, and the mesh drapes over the landscape rather than being imposed on it. Two radio layers carry it: **sub-1 GHz LoRa** for long haul, where 800–900 MHz propagation penetrates vegetation and foliage at relatively low attenuation and sustains near-line-of-sight links at modest data rates; and **2.4 GHz ESP-NOW** for dense short hops between neighbours. No rigid IP table, no fixed routing infrastructure, no cellular dependency.

**Routing is opportunistic and terrain-aware.** Rather than forcing a payload through an obstruction, a node evaluates local occlusion dynamically: it broadcasts a micro-ping and selects the neighbour offering the lowest **Expected Opportunistic Transmission Energy (EOTE)** across its forwarder set. The 16-byte displacement diffracts around ridges and clutter, finding the RF path of least resistance to the nearest NATS gateway. When a link degrades, intermediate nodes forward by a redundant path; the mesh spans kilometres without dedicated backhaul at every node — **though the gateway itself still needs an uplink, and the cost table charges for exactly that.**

**The geometric reading, and it is not decoration.** R⁸ is the universal covering space of T⁸, and the winding number is precisely the covering index — which sheet of the cover a displacement came from. The physical pods are localised anchor points in that cover; what is being projected onto the terrain is the affine coordinate system itself. This is the same fact as the frozen |Δ| < span/2 bound stated above, read from the other side: a delta that stays inside one period needs no sheet index, and a delta that leaves one must be published as a wrap.

**The structural contrast, stated as mechanism rather than verdict.** An orbital constellation terminates every node's link at a centrally operated ground segment; this mesh terminates local links at locally owned neighbours and reaches a gateway only at the boundary. Both deliver telemetry. They differ in **who holds the anchor points** — and the cost section above concedes that on price, at realistic aggregation, the orbital path wins. The claim here is ownership and reach into places without grid power or cellular coverage, not price.

**The falsifiable criterion, and this tier is genuinely hard:** a mesh of N ≥ 8 pods with one forwarder deliberately occluded must still deliver every published displacement to the gateway, and the delivered set must be **byte-identical** to the set the sources emitted — no reordering that changes a verdict, no silent drop. **The control arm:** the same mesh with the gateway removed must report undelivered payloads rather than reporting success. A routing layer that cannot distinguish "delivered by another path" from "quietly lost" is the always-green failure in mesh clothing. **No mesh has been built; this criterion is chartered, not run.**

## Energy — a budget from datasheet currents, not a measurement

**This is a computed budget, not a measurement, because no pod exists.** Every input is a datasheet figure, printed here so a reader can substitute their own and re-derive (VERIFIED as arithmetic; the currents REPORTED from datasheets):

| Term | Value | Source |
|---|---|---|
| Rail | 3300 mV | design |
| SX1262 TX current @ +14 dBm | 45 mA | Semtech SX1262 datasheet, typ |
| MCU active (sense + quantise, radio off) | 60 mA | ESP32-C6 class figure |
| Deep sleep | 7 µA | ESP32-C6 **chip** figure |
| Airtime per report | 287,744 µs | the 42 B frame, computed exactly above |
| MCU wake window | 50,000 µs | design |
| Reports per hour | 125 | floor(36 s ÷ 287.744 ms) |

Per transmission **42.7 mJ**; per wake **9.9 mJ**; sleep across the remainder of the hour **81.8 mJ**; **total 6.660 J/hour**, or **53.3 mJ per delivered report**.

| Path | Energy per hour | Basis |
|---|---|---|
| A.E.P-1 pod at 125 reports/hour | **6.660 J** | the budget above |
| Tracking terminal, 60 W class | **2.16 × 10⁵ J** | 60 W × 3600 s. **The 60 W is a class figure, not a vendor specification**, and it is the denominator of the ratio below — a reader substituting a measured terminal draw should recompute rather than inherit it. |

**The ratio is 32,430:1 — and its denominator is an hour of availability, not a delivered measurement.** An earlier pass of this page labelled it "energy per delivered measurement." That label was false even though the numerator was fine: the terminal moves a very different data volume in that hour, so per-measurement is a comparison of two different quantities. What the figure honestly says is that **a sensing node can be powered by a small panel and a cell where a tracking terminal cannot** — a deployability claim, and the one that actually decides whether a site without grid power can be instrumented at all.

**One deep-sleep caveat that the budget cannot absorb.** The 7 µA is the *chip* figure. Measured dev boards run an order of magnitude higher — 72 µA on one commercial ESP32-C6 board — because of board-level leakage. The pod's own PCB must be measured, not inherited. At 72 µA the sleep term rises from 81.8 mJ to ~841 mJ and the hourly total to ~7.4 J, which does not change the argument's shape and is exactly why T1 measures it instead of this page asserting it.

## Cost — and the assumption that decides it — FRAMING

**This section is framing. It is not the sealed object of this study, and it does not appear in the status line.** The sealed object is the four-tier protocol.

**The honest result is that cost is not where this architecture wins, and an earlier pass of this page got that backwards.** That pass priced **one satellite subscription per sensing node** while giving the pod mesh 100 gateways with **no backhaul cost at all** — it charged one architecture for its uplink and handed the other its uplink free. Corrected so that both sides pay for backhaul, 10,000 sensing sites over 10 years (VERIFIED as arithmetic; prices REPORTED, mid-2026):

| Architecture | Backhaul assumption | 10-year total |
|---|---|---|
| Orbital, one terminal **per site**, US Standard + MAX | 10,000 subscriptions | **$159.5M** |
| Orbital, one terminal **per site**, US Mini + Residential 100 | 10,000 subscriptions | **$67.99M** |
| Orbital, one terminal **per site**, Kenya Mini + 50 GB | 10,000 subscriptions | **$12.53M** |
| Orbital, **1 terminal : 10 sites**, US Standard + MAX | 1,000 subscriptions | **$15.95M** |
| Orbital, **1 terminal : 100 sites**, US Standard + MAX | 100 subscriptions | **$1.59M** |
| Orbital, **1 terminal : 100 sites**, Kenya Mini + 50 GB | 100 subscriptions | **$0.125M** |
| **A.E.P-1**, 10,000 pods at $25 + 100 gateways, each gateway on a US MAX uplink | 100 subscriptions | **$1.83M** |
| **A.E.P-1**, 10,000 pods at $30 + 100 gateways, each gateway on a US MAX uplink | 100 subscriptions | **$1.88M** |

**Read the two rows that share an assumption.** At 1:100 aggregation on identical US uplinks, orbital is **$1.59M** and the pod mesh is **$1.83M**. **The orbital path is cheaper.** In Kenya at 1:100 it is $0.125M, an order of magnitude below the pod mesh. The 170× and 256–830× advantages that earlier passes of this page reported are artefacts of the per-site-subscription assumption, and they do not survive a comparison a systems engineer would actually construct.

**What this study therefore does not claim:** that the sovereign substrate is cheaper. On backhaul cost at realistic aggregation it is competitive at best and beaten at worst, and the market chosen moves the answer by two orders of magnitude before any architecture is considered.

**What survives the correction, and it is not nothing:**

- **Sovereignty.** Under aggregation the orbital path still routes every site's telemetry through one commercial operator's ground segment. The pod mesh publishes an 8-tuple displacement and retains the rest locally. That is an ownership property, not a price.
- **Deployability.** 6.660 J/hour runs on a small panel and a cell. A tracking terminal does not. Sites without grid power are instrumentable under one architecture and not the other, whatever the subscription costs.
- **No single-operator dependency.** 100 subscriptions to one company is 100 fewer than 10,000, and still one company.
- **Failure granularity.** Losing a gateway costs its cell; losing an operator relationship costs the deployment.

Those are the claims this page will defend. The cost headline is withdrawn.
## The atmospheric ledger, at its sourced strength — FRAMING

**Also framing, also not sealed.** Every figure is attributed inline with its venue and year, and the seed numbers that circulate widely are corrected rather than repeated. Where the field is unsettled this page says so, because a comparison drawn against a contested projection is worth nothing.

- **The "500× more potent than surface CO₂" figure has the wrong baseline.** Ryan et al. 2022 (*Earth's Future* 10, e2021EF002612) state that kerosene rocket black carbon, **by 2029** under their launch-growth scenario, induces instantaneous radiative forcing per unit mass "more than 500 times greater than BC forcing from Earth-bound sources" — **soot to soot, and a projection rather than a present-day ratio**. Their own body figures are sharper than the abstract: 7,800 mW/m²/yr per Tg BC for contemporary rockets and 9,900 for a space-tourism scenario, against 20.7 for all other sources — factors of **375** and **475**. "~500×" is the rounded tourism number. No paper compares rocket black carbon to CO₂ at 500:1. The nearest real soot-to-CO₂ quantity is a GWP-100 of **900, range 120–1800**, Bond et al. 2013 (*J. Geophys. Res. Atmos.* 118(11), 5380–5552, doi:10.1002/jgrd.50171) — a different quantity on a different denominator.
- **And the sign of that forcing flips under the other standard metric, in the same group's newest paper.** Barker et al. 2026 report rocket black carbon at **+6.47 mW/m² instantaneous** and **−6.40 mW/m² stratospherically adjusted**, concluding it behaves like a potential solar-geoengineering agent. A bare "500× warming" claim is metric-dependent, and the most recent work by the authors of the 500× figure gives the adjusted forcing a negative sign. **This page therefore does not use rocket soot as a warming argument at all.**
- **The absolute magnitude is small, which is the honest counterweight.** A decade of contemporary launches gives **3.9 mW/m²**, rising to 7.9 with three years of added space tourism — about **6% of black-carbon warming from all other sources, from 0.02% of black-carbon emissions**. The per-unit-mass potency is real; the total is not currently large, and Barker et al. close by calling for ambient measurements to constrain the models.
- **"~2,400 deorbits per year" is a steady-state projection with traceable arithmetic**, not a measured rate — 12,000 authorised satellites divided by a 5-year design life (the reasoning in Boley & Byers 2021). Measured, calendar 2025 (ESA *Annual Space Environment Report*, Issue 10.0, 1 May 2026): **1,881 catalogued re-entries, of which 1,117 payloads**; 486.7 t of re-entered mass. Starlink specifically: **1,779 deorbited all-time since 2019** — the cumulative total sits below the claimed annual rate, and recent windows annualise to roughly **520–950/yr**. Publish the projection with both assumptions attached and the measured number beside it.
- **Alumina: publish the range, not its low end.** Ferreira et al. 2024 (*Geophys. Res. Lett.* 51, e2024GL109280) estimate **~17 t of aluminium oxides from the 2022 reentering population**, and state that a mega-constellation scenario "can reach over 360 metric tons per year" — a ~21× increase, and 360 is a floor within one scenario rather than a measured rate. A separate paper, Maloney, Portmann, Ross and Rosenlof (*J. Geophys. Res. Atmospheres*, 2025, doi:10.1029/2024JD042442), simulates **10,000 t/yr** at >60,000 satellites. Those are two scenarios from two papers, not the ends of one published range, and this page had previously fused them into a single "28× range" that neither paper states.
- **The ozone-depletion sign is contested, and the only full simulation to date points the other way.** The mechanism is established — alumina surfaces activate chlorine, and Ferreira et al. 2024 name Al₂O₃ as a known chlorine-activation catalyst — but that paper quantifies **mass only** and reports no ozone-loss percentage. Maloney, Portmann, Ross and Rosenlof (*J. Geophys. Res. Atmospheres*, 2025, doi:10.1029/2024JD042442), simulating the 10,000 t/yr case, find a 20–40 Gg stratospheric burden produces ~1.5 K temperature anomalies and a ~10% weaker polar vortex, **leading to a weaker springtime ozone hole**. Barker et al. 2026, modelling all space activity, find ozone loss dominated by **chlorine from solid propellant**, with mega-constellations at only **9%** of all-mission depletion because they fly kerosene rockets that emit no chlorine. NOAA's own summary of the Maloney work says how alumina affects ozone remains unclear.
- **No peer-reviewed work claims an observed reversal of ozone recovery, and the 2025 literature reports the opposite.** Wang, Solomon, Santer, Kinnison, Fu, Stone, Zhang, Manney and Millan, "Fingerprinting the recovery of Antarctic ozone", *Nature* 639(8055), 2025, doi:10.1038/s41586-025-08640-9 — a formal attribution of **recovery**; WMO records the 2025 Antarctic hole as the fifth smallest since 1992. **What the literature claims is delay, never reversal, and it is quantified**: −0.29% near-global annual-mean total column ozone by 2030 under an ambitious 2,040-launches/yr scenario with Antarctic springtime down 3.9% (npj, 2025); Ryan et al. 2022 give 0.01% global and 0.15% upper-stratospheric spring loss at 60–90°N. Say "delay", with a number and a scenario.

**And the terrestrial side is not free either, which this page will not pretend.** A mesh of 10,000 pods has a manufacturing footprint, a lithium-iron-phosphate cell per node, and an end-of-life path, and **none of those is quantified on this page**. What is true is narrower: the export is an integer 8-tuple, so the mesh adds nothing to the stratosphere in operation. A full life-cycle comparison is owed and is listed in Open issues rather than claimed here.

## What this protects

**Local ownership of local measurement.** The zero-extraction property is structural, not promised: what crosses is a displacement on a torus, so the global mesh receives what it needs to compute and never receives a stream it could resell. The hardware is CERN-OHL, the transport Apache-2.0, and the spectrum use is the local entity's own. An entity that wants out takes its pods with it.

**Replayable verdicts.** T4 exists because two cells re-deriving the same verdict from the same deltas is the property that makes a distributed measurement checkable by a stranger — the same discipline [Study 11 — Ehrhart volume shear](Study-11-Ehrhart-Volume-Shear.md) carries in arithmetic and [Study 28 — Wet-bulb threshold court](Study-28-Wet-Bulb-Threshold-Court.md) carries at a survivability line. Exact integers replay byte-identically; a float pipeline's last bit is a property of a machine.

**A cost floor low enough to be owned rather than rented.** ~$18–25 per pod against a $199–599 terminal plus $55–130/month is the difference between a community that buys instruments and a community that leases access to its own weather.

**An enumerable boundary instead of a trusted one.** A tool surface that enumerates to a ring buffer can be audited by anyone with a packet capture. That is a smaller claim than an unbreakable one and a much larger one than an unchecked assurance.

## Against the shear recipe — this is not a shear study, and says so

The [index](Shear-Studies-Index.md) states the rule plainly: every charter must instantiate all four pieces before its status line may advance, and *"a study missing any one of them is not a shear study; it is a correlation hunt."* Study 29 is measured against that rule here rather than left for a reader to measure.

| Piece | Study 29 | |
|---|---|---|
| 1. A forcing with a computable public clock and track | **Partial.** The forcing is a physical threshold crossing at the pod and local τ is its clock — but τ is *intrinsic*, not a public ephemeris announced before the response. No cone, corridor or ground track is named. | ✗ as the recipe means it |
| 2. A public raw response archive | **No.** No pod exists, so no archive exists. | ✗ |
| 3. A sealed adversary | **Yes.** The readings table carries a real null — that the transport advantage is an encoding artifact any protocol engineer reproduces — and the airtime section concedes it rather than retiring it. | ✓ |
| 4. Standing future events for pre-registration | **No.** Threshold crossings are not a public drumbeat, and nothing recurs on a schedule the charter can pre-register against. | ✗ |

**So this page is not a shear study and does not claim to be one.** It is also not a correlation hunt, because it advances no correlation: it makes no claim that any response tracks any forcing. It is a **hardware and protocol validation charter** — a different object, whose sealed content is a four-tier gate with per-tier failing observations and control arms, exactly the Section-zero discipline [Study 28](Study-28-Wet-Bulb-Threshold-Court.md) established, applied to an artifact instead of to an archive.

**Whether the board admits that class is not this page's call to make.** The honest options are three: admit it as a distinct lane with its own status vocabulary; hold it off the numbered board and publish it as a specification page; or require it to grow pieces 1, 2 and 4 before it takes a number. This page states which pieces it carries so that decision is made on the facts rather than on the page's tone.

## What this study does not judge

- **Anyone's launch programme.** The atmospheric section reports attributed figures, corrects three that circulate wrongly, and marks the ozone sign as contested. It renders no verdict.
- **Orbital broadband as a technology.** For workloads that need megabits, it delivers megabits, and this page says so in the readings table. The comparison is scoped to this workload on this link budget.
- **Any built pod's performance.** No pod exists. Every hardware row is a drawing, and the four tiers are what would convert a drawing into a measurement.
- **The physical state behind a delta.** The R → Z⁸ ingest is many-to-one. The delta carries the lattice point, not the air.

## Honest limits

- **No pod has been built and no tier has been run.** This is a charter. The status line says so, and nothing on this page is a hardware measurement.
- **T1 is blocked by a real defect.** The BQ25570 510 mW rated peak input against a 1–2 W panel is an overrun of 2.0× against a 1 W panel and 3.9× against 2 W. It is stated as an open hardware issue and it gates the first tier.
- **The $15 BOM does not close.** $13.00–13.40 of silicon at 1k before enclosure, panel, cell, PCB and sensor. **~$22–30** is the defensible built cost; the cost table is computed at $25 and $30. $15 is reachable only by changing the parts list — dropping the SX1262 for an ESP-NOW/802.15.4 mesh is the cleanest route, and it is a different deployment rather than a cheaper version of the same one.
- **The airtime result is an encoding result as much as a geometry result, and the null row says so.** 4.07× on airtime, 6.28× on payload, on this workload and this link budget. What the geometry contributes is fixed width and exact replay, not the ratio.
- **The cost headline is withdrawn, and this is the largest correction on the page.** Earlier passes reported 170× and then 256–830× in favour of the pod mesh. Both priced one satellite subscription per sensing node while handing the pod mesh its gateway backhaul free. Charged symmetrically at 1:100 aggregation on identical US uplinks, orbital is $1.59M against the pod mesh at $1.83M — **orbital is cheaper**, and cheaper again by an order of magnitude in low-cost markets. This study does not claim a cost advantage.
- **The life-cycle comparison is owed.** Manufacturing footprint, one LiFePO4 cell per node, and end-of-life for 10,000 pods are quantified nowhere on this page.
- **The quantiser resolution is not yet checked against a named sensor's noise floor.** The check is stated; the sensor part is not pinned, so the check is owed rather than performed.
- **The LiFePO4 temperature boundary is per cell, not per chemistry.** The cell is not pinned, so T1's window integer is not frozen.
- **Third-party figures on this page are carried as REPORTED** — literature and datasheets read, not archives re-derived by this program. What is tagged VERIFIED is what was re-derived this session: the shipped quotient map read from source with file and line, the three airtimes, the Landauer arithmetic, and the economics arithmetic on the reported prices.
- **The Maloney et al. 2025 venue string is not pinned** and is named as unpinned rather than guessed.
- **The audited boundary is audited, not proven.** T3 grades a configuration on a session. It does not establish that no configuration could ever leak, and it is not written as though it did.

## Open issues — what a reader must know is unresolved

These are carried on the face of the charter rather than in a footnote, because several of them gate the tiers above.

1. **T1 IS BLOCKED — the power chain has a rated-input violation.** The BQ25570 carries a rated **Peak Input Power of 510 mW** against a drafted 1–2 W panel: an overrun of 2.0× at 1 W and 3.9× at 2 W. **And the 510 mW is itself the correction of a superseded number.** Earlier passes of this page said 400 mW, citing the 2013 revision string. The current datasheet revision history reads: Peak Input Power changed From MAX = 400 mW To MAX = 510 mW. A ≤400 mW qualifier survives, but only as a footnote on Recommended Operating Conditions after cold start. The defect is real at either figure; the page was carrying a stale rating on the number that blocks its first tier, which is the precise failure this study is written about. Resolve with a PMIC rated for the panel or a panel sized to the PMIC. No thermal soak may be scored until then.
2. **The same part has two further limits the draft does not satisfy.** Its buck output is rated **110 mA typical** against the ESP32-C6's **295–382 mA** 2.4 GHz transmit burst, so the drafted ESP-NOW path cannot be sourced from VOUT; the standard resolution is MPPT-charger-only with the MCU on VBAT and bulk capacitance sized for the burst, which is a different topology and must be stated as the chosen one. Cold-start VIN(CS) is **600 mV typ / 700 mV max**, not the 330 mV still quoted by secondary sources.
3. **The PMIC is single-source and was listed out of stock at the time of checking** — a supply risk in an open-hardware BOM whose premise is that anyone can build it.
4. **No pod exists and no tier has been run.** Every hardware row is a drawing. The four-tier protocol is what would convert it into a measurement.
5. **The $15 BOM does not close.** $13.00–13.40 of silicon at 1k before enclosure, panel, cell, PCB and sensor; **~$22–30** is the defensible built cost. $15 is reachable only by changing the parts list, and the cleanest route — dropping the SX1262 for an ESP-NOW/802.15.4 mesh, saving $5.70 — buys a different deployment (dense mesh, short hops) rather than a cheaper version of the same one.
6. **The quantiser resolution has not been checked against a named sensor's noise floor.** The wire units are 10⁻³ °C, 10⁻³ %RH and 1 Pa; the sensor part is not pinned, so the one comparison this page asks an implementer to make has not been made here.
7. **The LiFePO4 temperature boundary is per cell, not per chemistry**, so T1's charge-window integer is not frozen. A representative cell specifies charge 0–55 °C and discharge −20 to +60 °C — two different windows, which is the whole content of the criterion.
8. **The T1 enclosure ΔK criterion is not yet pinned** to the enclosure geometry. It must be frozen at build stage, before the first soak, and not after.
9. **Deep-sleep current is a chip figure, not a board figure.** 7 µA is the ESP32-C6 specification; measured commercial boards run to 72 µA from board-level leakage. The pod's own PCB must be measured, and T1 is where that happens.
10. **The cost headline is withdrawn.** Charged symmetrically — both architectures paying for backhaul — orbital at 1:100 aggregation is **cheaper** than the pod mesh on identical US uplinks, and an order of magnitude cheaper in low-cost markets. This study claims sovereignty, deployability and failure granularity; it does not claim price.
11. **The life-cycle comparison is owed.** Manufacturing footprint, one LiFePO4 cell per node, and end-of-life for 10,000 pods are quantified nowhere on this page.
12. **T2's float arm is chartered but unimplemented.** No gate yet enforces integer-only types across the HAL C boundary, and its control arm — a probe build carrying one deliberate `float` parameter — has not been run.
13. **The ozone-depletion sign from rocket alumina is contested and unresolved**, and the only full simulation to date produces a *weaker* springtime ozone hole. No peer-reviewed work claims an observed reversal of ozone recovery.
14. **The Maloney et al. 2025 venue string is not pinned** and is named as unpinned rather than guessed.
15. **The audited boundary is audited, not proven.** T3 grades a configuration on a session. It does not establish that no configuration could ever leak, and no proof-by-signature is claimed anywhere on this page.

## Reproduce every number on this page

Four self-contained Swift programs, no imports, no floats in any law path, each printing the table it backs. Build with `xcrun swiftc -O -swift-version 6 <file>.swift -o /tmp/out && /tmp/out`.

| File | Reproduces | Carries its own control arm |
|---|---|---|
| `evidence/study-29/unimodular-control-arms.swift` | det = 1 by fraction-free Bareiss; 4,000 → 4,000 distinct integral images; the det = 2 and det = 0 arms | **Yes** — and it is the arm that shows image count does *not* discriminate |
| `evidence/study-29/lora-time-on-air.swift` | the three airtimes in exact integer microseconds, the floored transmission counts, all three ratios | the 16 B row is the arm that was already correct |
| `evidence/study-29/pod-energy-budget.swift` | 42.7 mJ / 9.9 mJ / 81.8 mJ, 6.660 J per hour, 32,430:1, with every datasheet input printed | assumptions are printed so a reader substitutes their own |
| `evidence/study-29/cost-matrix.swift` | every row of the cost table, at all four markets and three aggregation ratios | the per-site and 1:100 rows are each other's arm |

**The energy and cost programs are budgets, not measurements, and print their inputs for that reason.** The unimodular and airtime programs are exact and reproduce byte-identically anywhere Swift runs, which is the property the whole page argues for.

## Cross-links

- [Study 28 — Wet-bulb threshold court](Study-28-Wet-Bulb-Threshold-Court.md) — the section-zero precedent this charter instantiates for hardware: per-criterion failing observations, control arms in both directions, losses published as losses.
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md) — the claim-class precedent: the "verified / not searched" sentence pattern, and a gate frozen before any byte is scored.
- [Study 11 — Ehrhart volume shear](Study-11-Ehrhart-Volume-Shear.md) — the arithmetic cousin: exact lattice counting against float evaluation of the same quantity.
- [Study 09 — Global convective bond](Study-09-Global-Convective-Bond.md) — the terrestrial-sensing lane this study supplies instruments for; frozen Int64 thresholds, REFUSED ≠ clear sky.
- [Study 02 — Regulatory alarm](Study-02-Regulatory-Alarm.md) — the precedent for packaging an atmospheric ledger with every unmeasured quantity labelled cited rather than painted.
- [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm.md) — why the HAL takes integers, stated as program doctrine.
- [Shear Studies Index](Shear-Studies-Index.md) — the program board and the recipe every charter must instantiate.

**Status: OPEN — validation charter only; no pod built, no tier run. Four tiers frozen 2026-08-31 with each tier's failing observation and control arm; all four carry frozen integers; T2/T3/T4 are runnable against a built pod, T1 is not — its cell ceiling pins when a cell is named and its harvester bound requires resizing the drafted panel. T1 additionally blocked: the BQ25570 carries a rated Peak Input Power of 510 mW (TI SLUSBH2G, revised up from 400 mW) against a drafted 1–2 W panel — an overrun of 2.0× to 3.9×. Shipped and measured: `UUM8DFactCoordinate.wrapped()` at line 261 is the live spatial quotient map, emitting an explicit winding for sx/sy/sz only; five further record components are unwrapped, so the eight-axis T⁸ map is the design, not the shipped instance. A det = 1 unimodular 8×8 maps 4,000 distinct Z⁸ points to 4,000 distinct integral images, and the discriminating control arm is reachability, not image count. The transform is lossless; the R → Z⁸ ingest is not. No cost advantage is claimed.**
