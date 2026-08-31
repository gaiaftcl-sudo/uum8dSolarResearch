# Study 30 — The sovereign edge pod

**OPEN — hardware and protocol validation charter; no pod built, no tier run. Frozen 2026-08-31.** What this page seals is a four-tier validation protocol — T1 thermal soak, T2 zero-heap ingest, T3 NATS leaf asymmetry, T4 asynchronous replay — each carrying frozen integers, the exact observation that fails it, and a control arm proving the detector fires. **T2 and T4 are runnable against a built pod. T3 is runnable on three of its four arms** — its subject-equality arm waits on an allow-list this page does not freeze. **T1 is not runnable**: its cell charge ceiling pins only when a cell is named by manufacturer and part number, and its enclosure ΔK criterion pins only at build stage. The harvester bound that would otherwise have blocked T1 is resolved here by specification. **This page is not a shear study.** It carries one of the index's four recipe pieces and names the three it lacks. **OPEN is used in the index's own sense: gate integers frozen, no corpus ingested, no pod built, no tier scored.**

## Two maturities, named before anything else

This charter stands on a shipped half and a drafted half, and conflating them would be its easiest failure.

The **geometry** is running code in this repository, read in source this session and cited below with file and line: the wrapped lattice with its explicit winding number, and the unimodular bijection the evolution law rests on. It is measured.

The **mesh spine** is a live public surface, measured today and pinned in this repository as a file with a digest. It is measured.

The **hardware** — the A.E.P-1 pod, its enclosure, its power chain, its bill of materials — is a drawing. Every hardware number on this page is a datasheet figure, a distributor price at a stated quantity break, or arithmetic over those, never a measurement of a built object. The four-tier protocol exists precisely because a drawing is not evidence.

The subject is a zero-extraction terrestrial digital-twin mesh: open pods, owned locally, publishing an integer displacement and nothing else. Local entities own the hardware, the spectrum use and the telemetry. Only an 8-tuple integer displacement is designed to cross to the global mesh. The licensing follows the same seam — CERN-OHL on the hardware, Apache-2.0 on the transport, with the vQbit state machine and the UUM-8D quantiser proprietary behind a hardware abstraction layer whose header is published in full below.

## What this page is, and the class it belongs to

The [index](Shear-Studies-Index.md) states the rule plainly: every charter must instantiate all four pieces of the shear recipe before its status line may advance, and *"A study missing any one of them is not a shear study; it is a correlation hunt."* Study 30 is measured against that rule here rather than left for a reader to measure.

| Piece | Study 30 | |
|---|---|---|
| 1. *"A forcing with a computable clock and track."* | **Partial, and partial is not carried.** The forcing is a physical threshold crossing at the pod, and local proper time τ is its clock — but τ is *intrinsic*, not a public ephemeris announced before the response is examined. No cone, corridor or ground track is named. | ✗ as the recipe means it |
| 2. A public raw response archive | **No.** No pod exists, so no archive exists. | ✗ |
| 3. A sealed adversary | **Yes.** The readings table below carries a real null — that the transport advantage is an encoding artifact any protocol engineer reproduces by swapping verbose JSON for a tight binary schema — and the airtime section concedes it rather than retiring it. | ✓ |
| 4. Standing future events for pre-registration | **No.** Threshold crossings are not a public drumbeat, and nothing recurs on a schedule this charter can pre-register against. | ✗ |

**So: one piece of four.** This page is not a shear study and does not claim to be one. Neither is it a correlation hunt, because it advances no correlation — it makes no claim that any response tracks any forcing.

It is a **hardware and protocol validation charter**: a different object, whose sealed content is a four-tier gate with per-tier failing observations and control arms in both directions. That is [Study 28](Study-28-Wet-Bulb-Threshold-Court.md)'s Section-zero discipline pointed at an artifact instead of at an archive, and it carries its own status vocabulary because the thing being graded is a device rather than a corpus. Study 28 asks whether an instrument can fail on archived station-hours. This page asks whether a device can fail on a bench, and freezes the integers that decide it before the bench exists.

Whether the board admits that class alongside the numbered shear studies is not this page's call. What this page owes the board is an exact statement of which pieces it carries, and that statement is the table above.

**The sibling lane.** [Study 29 — the reentry-mass ledger court](Study-29-Affine-Earth-Sovereign-Substrate.md) carries the atmospheric half of the original combined charter: Ferreira against Maloney, the exact rational counting ledger, the units artifact. That is epistemological shear on a contested continuous model. This page is the constructive architecture. The two were split so that an empirical hardware specification does not dilute the mathematical precision of an atmospheric refutation.

## Section zero — the discrimination gate

Before any pod is graded, each tier must be shown able to fail. **A tier that cannot fail is not a tier.** Always-green and always-red are the same defect, and this program has retired an instrument for exactly that. Each tier below names the exact observation that fails it and the control arm that proves the detector fires. All of it is frozen in this charter, before any hardware exists.

**Stated plainly and first: no pod has been built. No tier has been run. Every result below is an obligation, not a finding.**

### T1 — thermal soak

A pod in its louvered Stevenson-screen enclosure (ASA or PETG), powered only from its own solar-and-storage chain, held across the enclosure's stated envelope through at least one full diurnal cycle.

- **The observation that FAILS it:** the charger asserts charge current while the cell's own temperature sits outside the charge window printed in that cell's datasheet; **or** any brownout reset in the session log; **or** an internal enclosure temperature more than a frozen ΔK above shade ambient at solar noon.
- **The control arm:** the same detector run against a deliberately mis-clamped cell — charge asserted at a bench-forced out-of-window temperature — must fire. A soak harness that reports PASS on a rig built to fail it is a broken scorer, and the study halts on an instrument defect rather than scoring physics.
- **Two integers are conditional, and T1 cannot be run until both pin.** The **55,000 milli-°C** charge ceiling is a representative LiFePO4 figure and freezes only when a cell is pinned by manufacturer and part number. The **ΔK** criterion pins to the enclosure geometry at build stage, before the first soak, and not after. Both are marked UNFROZEN inside the tier table below, not only in Honest limits.
- **On the cell temperature boundary: it is per cell, never per chemistry.** "LiFePO4 tolerates high ambient" is directionally right and is not a specification. The boundary that binds is the one on the specific cell's datasheet — a representative LiFePO4 cell specifies charge 0 to 55 °C and discharge −20 to +60 °C, and those two windows are different from each other, which is the entire content of the criterion. Quoting a chemistry at this line would repeat the exact defect the criterion exists to catch. The durable chemistry-level fact, stated as such and doing no work in the gate: LFP thermal-runaway onset sits near 270 °C against 150–210 °C for NMC (REPORTED — chemistry-class figures, no cell datasheet pinned).
- **The harvester bound is resolved by specification.** See "The power chain — and the panel, sized to the rating" below. The frozen bound is **≤ 510 mW** at the PMIC input, and the specification that holds it is a **~400 mW nominal** panel.

### T2 — zero-heap ingest

The HAL ingest path allocates nothing at runtime. This is Constraint 3b instantiated in silicon: the kernel path allocates nothing, and here the kernel path is the pod's.

- **The observation that FAILS it:** a non-zero delta in the allocator's own high-water mark across the frozen cycle count; **or** any allocating call site inside the declared ingest file set; **or** any float type crossing the HAL boundary in either direction.
- **The declared ingest file set is the implementer's, declared before scoring and published with the result.** This page pins no source tree, so it cannot enumerate the set; what it freezes is that the set is declared in the implementer's own build manifest, published alongside the T2 result, and unchanged between the clean build and the sabotaged control build. A failing observation that resolves against an unpublished list is not a failing observation, so the declaration is a precondition of scoring T2 rather than a detail of running it.
- **Absence of a symbol is not the test.** The gate counts allocations, not spellings. A rule scoped to the spelling a defect last wore will not catch it where it happens — a detector looking for `malloc(` is silent on `UnsafeMutableRawPointer.allocate`, and a detector looking for float literals is blind to a bare float-typed field.
- **The control arm:** a second build carrying exactly **one deliberate 16-byte allocation** in the ingest loop must read a non-zero hook count, and a probe carrying exactly one deliberate `float` parameter must be caught by the type arm. If the clean build reads 0 and the sabotaged build also reads 0, the instrument cannot distinguish, and the study halts on an instrument defect rather than scoring a pod.
- **Scoping caveat, inherited from this substrate's own history rather than discovered here:** a source scan is blind to implicit allocation — ARC boxing, existential containers, closure capture, array copy-on-write — and blind to hot-path frequency. The high-water arm exists because the source arm alone would report a zero it has not earned. Both arms run; a pass requires both.

### T3 — NATS leaf asymmetry

The pod is a leaf. It publishes an 8-tuple integer displacement and subscribes to nothing carrying execution state.

- **The observation that FAILS it:** one inbound application frame; one `SUB` outside the frozen ack inbox; one published subject not string-equal to the frozen allow-list; one published frame whose length is not 42 bytes. **One frame fails the tier.**
- **Two of those four arms are conditional today, and this page says which.** The frozen allow-list of published subjects and the frozen ack-inbox subject are **not pinned on this page** — no subject string is frozen anywhere in this charter. A stranger holding a packet capture can decide the inbound-frame arm and the 42-byte length arm from the capture alone; the subject-equality arm and the ack-inbox arm cannot be decided against a list that does not appear. Those two arms are therefore conditional, they are carried in Open issues, and the status line does not claim T3 is fully runnable.
- **Protocol frames are enumerated by name and excluded by name, never by inference.** `PING`, `PONG`, `INFO`, `+OK`, `-ERR` and the JetStream ack are the enumerated set. A filter written as "anything that looks like protocol chatter" is a filter that grows to fit whatever it sees.
- **The control arm, two-sided:** a capture taken with the radio disabled must print **`CAPTURE_ABSENT`**, never PASS — a gate handed nothing must not exit green, and absence and a pass are different answers. And a build deliberately published to a wrong subject must be caught by the same comparator that grades the frozen one, which is a second reason the allow-list has to pin before that arm can score.
- **What this tier does and does not establish** is written out in "The audited boundary" below, because the strong-sounding version of the claim is the wrong one.

### T4 — asynchronous replay

Two cells that were never simultaneously online re-derive the identical verdict from the same delta stream.

- **The observation that FAILS it:** any sequence gap inside the retained window; any duplicate accepted — a deliberate re-publish must be **rejected** by `Nats-Msg-Id` dedupe, and acceptance is a FAIL; a ring wrap reporting zero overwrites; **one differing byte** between the flushed 8-tuple and the bytes sealed locally before the sever.
- **The control arm:** a probe replay seeded with one reordered delta must produce a difference the comparator catches, and a probe with one flipped bit must too. A comparator that reports IDENTICAL on a corrupted stream is the always-green failure and halts the study.
- **This is the tier the whole geometry exists to make gradeable.** Byte-identical replay is available only because the transform is exact and integral: two cells executing the same integer arithmetic over the same integer deltas cannot disagree in a last bit, because there is no last bit to disagree about.

### The frozen integers, all four tiers, before any pod exists

| Tier | Frozen | Fails on |
|---|---|---|
| **T1** soak | duration ≥ **259,200 s**; chamber air ≥ **45,000 milli-°C** for ≥ **246,240 s** (95%); applied thermal load **2,000 mW** **on the enclosure exterior**; harvester input bounded ≤ **510 mW**; ingest period **60,000,000,000 ns** ± **100,000,000 ns**; cell charge ceiling **55,000 milli-°C — UNFROZEN, pins with the cell**; enclosure **ΔK — UNFROZEN, pins at build stage** | a boot-count delta other than 0; any second below 45,000 milli-°C beyond the 12,960 s allowance; any non-zero charge current recorded above the cell ceiling; any inter-sample interval outside the jitter bound; any NVS write returning non-zero |
| **T2** zero-heap | ingest cycles ≥ **100,000**; heap high-water delta between cycle **1,000** and **100,000** exactly **0 bytes**; allocator-hook count exactly **0**; the ingest file set declared in the implementer's build manifest and published with the result | any non-zero high-water delta, or one or more allocator hooks, attributable to a call site inside the declared ingest file set |
| **T3** leaf asymmetry | packet capture ≥ **86,400 s**; inbound application frames exactly **0**; published frame length exactly **42 bytes**; `SUB` frames outside the ack inbox exactly **0** — **ack-inbox subject UNFROZEN**; published subject string-equal to the allow-list — **allow-list UNFROZEN** | one frame — one inbound application frame, one subscription outside the ack inbox, one subject not string-equal, or one frame whose length is not 42 |
| **T4** replay | NVS ring **2,048 records × 42 B = 86,016 bytes** = **122,880 s** (34.1 h) of retained outage at the frozen 60 s cadence; sever arm A ≥ **3,600 s**; sever arm B ≥ **126,480 s**, chosen to force a wrap; stream duplicate window **172,800 s** | any sequence gap inside the retained window; any duplicate accepted; a wrap reporting zero overwrites; **one differing byte** between flushed and locally sealed 8-tuples |

**The two 2 W figures in circulation are different quantities and this table keeps them apart.** T1's **2,000 mW applied thermal load is a chamber heater load on the enclosure exterior**. It is not harvester input, and harvester input is bounded separately at ≤ 510 mW. A gate that fused them would be grading the heater against the PMIC.

**One operating point governs every rate-dependent integer on this page, and it is named here.** T1 freezes the ingest period at 60,000,000,000 ns, so the pod produces at most **60 samples per hour** and therefore at most **60 transmissions per hour**. The **125 transmissions/hour** regulatory duty ceiling computed in the airtime section is a limit the frozen cadence never reaches. Energy is priced at the binding 60 tx/hr rate, the ceiling is priced beside it and labelled as a ceiling, and T4's 34.1 h retention is computed at the same 60 s cadence that T1 freezes. Where a figure prices the ceiling instead, this page says so in the same sentence.

**Every other integer above is frozen as printed and does not move after scoring.** A FAIL is published as a FAIL, on this page, with the same prominence as a pass.

## The geometry that ships, at exactly its measured extent

**T⁸ = R⁸/Z⁸ — the flat 8-torus.** An affine space is a vector space whose origin has been forgotten: only displacement is represented, absolute position is not. That is the property the wire needs, not a metaphor chosen for the page. A pod that publishes *where it is* has surrendered something. A pod that publishes *how far the world moved* has surrendered a displacement, and a displacement on a torus does not name a point.

**What ships is a three-axis wrapped lattice with windings.** Read in source this session: `UUM8DFactCoordinate.wrapped()` at `cells/xcode/Sources/InvariantCompiler/UUM8DFactCoordinate.swift:261` is floored modulo into `[0, span)` with an explicit winding. Verbatim, `&+=` intact:

> `var cell = shifted % span; if cell < 0 { cell &+= span }; let winding = (shifted - cell) / span`

The wire block at `:304` emits a winding for **`sx`, `sy`, `sz` only**. Every other record component — `tOrdinal`, `kvDigestHex`, `kwMass`, `ptElevationFt`, `phiVariance`, `addLaw`, `entropyCap`, `mortonKey`, `affineParameter` — is emitted unwrapped, carrying no winding. **A three-axis spatial quotient map ships. The eight-axis map onto T⁸ is the design.** The source's own comment at `:42` is itself the evidence: the Morton key is 3 × 21 = 63 bits, sized to fit a signed Int64, because it indexes three axes.

**The clamp repair is the strongest shipped thing on this page, at its true size.** `mortonBitsPerAxis = 21` (`:43`) and `mortonScale = 2¹⁸` (`:46`), so the pre-change code pinned anything with |value| ≥ 4 to the ceiling cell 2097151. The source's own worked table at `:229–234` shows `sx=4`, `sx=5`, `sx=1000` and `sx=2147483647` all landing on that one cell — every fact past ±4 therefore carried the same first-axis cell index. What that cost downstream depends on how the index is consumed, and this page cites no routing measurement. Wrapping is not a wider clamp. It is a different operation — total, and injective inside one period, with the winding carrying the sheet.

**Two different objects, named apart so the tag cannot migrate.** The shipped `UUM8DFactCoordinate` record — among its fields, three wrapped rationals, an Int64 ordinal, a String digest, four further rationals, an `Int64` elevation, an `Int64` Morton key and an affine parameter — and the pod's proposed **16-byte 8-tuple displacement** are not the same object. The first ships today and is cited above with file and line. The second is drafted, and nothing in the shipped record certifies it.

## The unimodular claim, and the control arm that discriminates

An 8×8 integer matrix with det = ±1 is a bijection on Z⁸: its inverse is again integral, so lattice points map to lattice points **in both directions**.

Reproducible, and the generator is published: a composition of ten elementary shears `(t, s, c)` = (0,1,3), (2,0,−1), (4,3,2), (1,5,−4), (6,2,1), (7,6,5), (3,7,−2), (5,4,3), (2,6,−1), (0,7,2), each det = 1 by construction. Determinant by fraction-free Bareiss elimination, integer throughout. Source point set: the 4,000 tuples `(a, b, c, e, a−b, b−c, c−e, a+e)` for a,b,c ∈ [0,10), e ∈ [0,4).

**Measured: det = 1, and 4,000 distinct points map to 4,000 distinct integral images.**

**And that result alone is an instrument that cannot fail.** The obvious control arm is to push a non-unimodular matrix through the same harness and watch the image count collapse. It does not collapse. Measured:

| Matrix | det | distinct images of 4,000 | reaches e₁ = (1,0,…,0) |
|---|---|---|---|
| composed unimodular | 1 | **4,000** | **yes** |
| diag(2,1,…,1) | 2 | **4,000** | **no** |
| two equal rows | 0 | **4,000** | — |

Every nonsingular integer matrix is injective on Z⁸, so a det = 2 map separates 4,000 points exactly as well as a unimodular one; and a singular map can still be injective *on a finite sample*, which is why even det = 0 scores 4,000 here. **The image count measures injectivity, and injectivity is not the property being claimed.**

What det = ±1 buys is **surjectivity onto Z⁸** — an integral inverse — and the arm that detects it is **reachability**. Under diag(2,1,…,1) every image has an even first coordinate, so e₁ is unreachable; under the unimodular map it is reached. **That row is the discriminating arm. The image-count row is a labelled smoke test on a theorem, and this page publishes it as one rather than as evidence.**

This is the program's own rule applied to the program's own instrument: an instrument must discriminate, and always-green is a defect whether or not the thing it is measuring happens to be true.

## The transform is lossless; the ingest is not

**Z⁸ → Z⁸ under a unimodular map is bijective and lossless.** Established by the determinant, and the reachability arm above shows the property being claimed is the one being tested.

**R → Z⁸ is many-to-one, and it is the one irreversible step in the pipeline.** A sensor produces a voltage; the quantiser produces a lattice point; an interval of voltages maps to one point, and nothing downstream restores the interval. Lossless is therefore a property of the **transform** and not of the **pipeline**, and the claim this charter makes is the second one stated exactly.

The claim, and it is still strong: **lossless at the chosen resolution**, with the resolution published as a number an implementer checks against their own sensor's noise floor. The wire units are 10⁻³ °C, 10⁻³ %RH and 1 Pa, and the implementer's obligation is one comparison: **is the quantiser step at least an order below the sensor's datasheet RMS noise?** If it is, the lattice point carries everything the sensor actually resolved. If it is not, the pod is publishing digits its sensor never earned. **This page pins no sensor part, so it does not perform that check; it states the check and names it as owed.**

Never claimed anywhere on this page: that the exact physical reality can be reconstructed from the delta.

## The state vector, the axis allocation, and what happens when the link drops

A node tracks a live state vector **v**(τ) on T⁸. What crosses is never **v** but the affine displacement

> **Δv**(τ) = **v**(τ_k) − **v**(τ_{k−1})

Affine space has no fixed origin, so a displacement is the only thing the node has to publish. The evolution law is stated on the same terms:

> d**v**/dτ = **M** · **s**_telemetry,  **M** ∈ GL(8, ℤ), det(**M**) = ±1

**GL(8, ℤ) is exactly the group of integral unimodular matrices**, so the section above is this law's invertibility statement rather than a separate claim.

### The axis allocation

| Node class | ⟨x₁, x₂, x₃⟩ | ⟨x₄ … x₈⟩ |
|---|---|---|
| **Stationary pod** | a constant anchor cell index — a fixed spatial lattice anchor | track local thermodynamic and environmental transitions |
| **Mobile pod** (vehicle, drone, swarm) | an integrated kinematic step counter / relative inertial displacement | evolve |

**⟨x₄, x₅, x₆⟩ — direct thermodynamic telemetry**, each a fixed integer scaling of a milli-unit offset, reduced modulo N:

> x₄ = round(k_T · (T − T₀)) mod N  ·  x₅ = round(k_H · (H − H₀)) mod N  ·  x₆ = round(k_P · (P − P₀)) mod N

with k_T, k_H, k_P fixed **integer** scaling constants. **Their values are not frozen on this page**, and they are carried in Open issues.

**The property that makes this float-free is worth stating explicitly, because it is what makes the integer HAL signature load-bearing rather than stylistic.** The HAL delivers `int32_t` milli-units. So `k · (T − T₀)` is an exact integer product, and **the rounding operator is vacuous** — it is applied to a value that is already an integer, and it can never introduce a choice. If the HAL delivered a float, `round` would be a real decision made against whichever libm the toolchain shipped, at exactly the boundary where the many-to-one crossing happens.

**The modulus is fixed by the wire, not chosen.** The frozen delta is eight `int16` axes, so each axis carries exactly 2¹⁶ distinct values: **N = N_τ = 65,536**, and the recoverability bound is **|change| < N/2 = 32,768**. Freezing the frame width froze the modulus; nothing further is needed to pin it.

**The three axes the HAL supplies, and the two it derives.** The published HAL takes three sensor scalars plus a timestamp, and the wire carries eight axes. The map is complete for a stationary pod and is stated here rather than left open: ⟨x₁, x₂, x₃⟩ are the constant anchor, **x₄, x₅, x₆ come directly from the three ingested scalars**, **x₇ is derived from those three by the flux definition below**, and **x₈ is the temporal winding of τ**. The only quantities the map still needs are k_T, k_H, k_P.

**x₇ — thermodynamic flux derivative, and the naive form is wrong across the wrap.** The obvious definition, a sum of absolute differences over i = 4…6, reports a catastrophic step whenever a value crosses the modular boundary. Measured at N = 65,536: a value moving to x = 5 from x = 65,530 is a true change of **11**, and the naive difference reports **65,525**. Since x₇ drives adaptive mesh ping rate, a benign step across the boundary would command full rate.

**The fix is exact and integer-only — the signed shortest path on Z/N:**

> d = ((a − b + N/2) mod N) − N/2

which returns 11 and −11 correctly and agrees with the true change whenever |change| < N/2. The frozen definition is

> x₇ = ( Σ_{i=4}^{6} |ringDelta(x_i(τ_k), x_i(τ_{k−1}))| ) mod N

**x₈ = τ_k mod N_τ** — the temporal winding, a phase invariant that prevents cyclic replay ambiguity across disconnected mesh partitions.

### One bound, three consequences

**|change| < N/2 = 32,768** is the same bound in all three places it appears, and stating it once is cheaper than three near-duplicates that can drift apart:

1. **Wire recoverability.** The 16-byte delta carries no sheet index, so a displacement is recoverable only while it stays inside one period.
2. **The covering space.** R⁸ is the universal cover of T⁸ and the winding is the covering index — which sheet a displacement came from. A delta inside one period needs no index; one that leaves must be published as a wrap.
3. **The flux derivative.** `ringDelta` agrees with the true change exactly on that interval.

**The delta-driven architecture is what makes the bound natural rather than lucky.** A pod is designed to transmit on threshold breach, so its displacements are small by construction, and a breach large enough to wrap is a different event that this charter requires be published **as a wrap**, never silently aliased.

### Local proper time τ

A disconnected node has no NTP and no GNSS discipline. Ordering is governed instead by a monotonic local counter, τ_{k+1} = τ_k + δτ, advanced once per deterministic state transition. On reconnection the upstream twin orders transitions by the pod's **intrinsic τ** rather than by arrival time, so clock skew and delivery races cannot reorder a node's own history.

**This is what makes T4 gradeable.** Two cells that were never simultaneously online would re-derive the same verdict because the sequence is carried in the payload, not inferred from the network — and whether a built pod honours that is what T4 scores.

### The NVS ring, and the limit a cyclic buffer has

Deltas are appended to a **pre-allocated cyclic buffer** in non-volatile storage — no allocation, which is the Constraint 3b instance this hardware must satisfy — and replayed in order to the nearest forwarder on mesh discovery, integrity checked by monotonic sequence id.

**The honest limit: a cyclic buffer overwrites.** Reversibility reconstructs intermediate states only while the chain is unbroken, so **the ring depth sets the maximum tolerable disconnection**, and an outage longer than that breaks the chain rather than degrading gracefully. At the frozen 2,048 records × 42 B on the frozen 60 s cadence that is 122,880 s — **34.1 h**. At the 125 tx/hr regulatory ceiling the same ring would hold 2,048 × 28.8 s = 58,982 s = 16.4 h, and that operating point is not the pod's.

**Frozen obligation:** the depth is published as an integer, and a pod that overwrites an unsent delta **must publish a gap marker**. A silent overwrite is the always-green failure in storage clothing — the stream looks continuous, and the discontinuity is exactly the thing a replay needs to know about. T4's sever arm B is set at ≥ 126,480 s specifically to force a wrap and make the marker observable.

### The MCP-governed WASM sandbox

Pre-compiled bytecode runs on a zero-heap WASM micro-core: `malloc`/`free` disabled, memory mapped to fixed static pages. MCP defines the capabilities, the read-only segments and the export subjects. The guest reaches the pod only through the HAL, and cannot inspect registers, thread contexts or host memory maps.

**Where this bites the float rule, and it is not hypothetical.** The execution hook hands `raw_telemetry_t` fields straight to `vqbit_ingest_telemetry`. If that struct carries floats, the boundary has merely moved one function out and the published HAL signature is decorative. **This charter therefore requires `raw_telemetry_t` to be integer-typed at the I²C/SPI read**, with conversion in the implementer's driver against a named sensor datasheet. **T2's float arm grades the whole path, not just the published signature.**

## The HAL, and why it takes integers

The published surface takes integer milli-units, in the spelling this codebase already uses on the wire (`alt_micro_m`, `azimuth_milli_deg`, `confinement_ppm`):

```c
int vqbit_ingest_telemetry(int32_t temp_milli_c, int32_t humidity_milli_pct,
                           int32_t pressure_pa, uint64_t timestamp_ns);
```

The reason is a consensus property rather than a style preference: **two pods running different libm implementations quantise a float differently at the boundary**, and two pods that quantise differently place the same air on different lattice cells. The boundary is exactly where the many-to-one crossing happens, so a difference there is a difference in **the published fact itself** — not a rounding artifact downstream of a fact.

Integer conversion happens once, in the implementer's own driver, against the implementer's own sensor — where it is visible, auditable and pinned to a datasheet — rather than inside a proprietary layer against whichever libm the toolchain shipped. T2's float arm is what keeps it that way.

## The audited boundary

The tool surface is an **audited boundary**, and this page is careful about what that word carries.

The published tool surface reaches the delta ring buffer and nothing beyond it. **T3 is the tier that grades whether a built pod's session matches that surface:** a full-session packet capture plus an enumeration of the advertised tools, scored against the frozen arms above. No pod exists, so no capture has been taken and no enumeration has been performed. When it is run it will be a demonstration **about the configuration as audited, on the session audited** — never a statement about every configuration.

**No proof-by-signature is claimed anywhere on this page.** The boundary is not asserted unbreakable; the charter's claim is that it is **enumerable and auditable**, and T3 is where that is checked.

The claim class, verbatim and load-bearing: **a presented configuration is verified; an unknown configuration is not searched.**

## The self-weaving mesh

**No mesh has been built. Everything in this section is the charter's design intent, and the criterion at the foot of it is what would decide any of it.**

The net is not dropped from above; it is designed to be tied from below, one pod at a time. Each deployment is intended to add an anchor point, so that the mesh drapes over the landscape rather than being imposed on it.

Two radio layers are specified. **Sub-1 GHz LoRa** for long haul, where 800–900 MHz propagation penetrates vegetation and foliage at relatively low attenuation and sustains near-line-of-sight links at modest data rates. **2.4 GHz ESP-NOW** for dense short hops between neighbours. No rigid IP table, no fixed routing infrastructure, no cellular dependency.

**Routing is specified as opportunistic and terrain-aware.** Rather than forcing a payload through an obstruction, a node evaluates local occlusion dynamically: it broadcasts a micro-ping and selects the neighbour offering the lowest **Expected Opportunistic Transmission Energy (EOTE)** across its forwarder set. Under this rule the displacement is intended to reach the nearest NATS gateway by diffraction around ridges and clutter rather than through them, and a degraded link is to be routed around by redundant paths. Whether the mesh spans kilometres without dedicated backhaul at every node is what the criterion below decides. **The gateway itself still needs an uplink, and the cost table charges for exactly that.**

**The geometric reading, and it is not decoration.** R⁸ is the universal covering space of T⁸ and the winding number is precisely the covering index. The physical pods are localised anchor points in that cover; what is projected onto the terrain is the affine coordinate system itself. That is the |change| < N/2 bound read from the other side.

**The falsifiable criterion, and it is a chartered criterion outside the four-tier gate — not a fifth tier, and it carries no frozen integers in the tier table:** a mesh of N ≥ 8 pods with one forwarder deliberately occluded must still deliver every published displacement to the gateway, and the delivered set must be **byte-identical** to the set the sources emitted — no reordering that changes a verdict, no silent drop. **The control arm:** the same mesh with the gateway removed must report undelivered payloads rather than reporting success. A routing layer that cannot distinguish "delivered by another path" from "quietly lost" is the always-green failure in mesh clothing.

## The mesh spine — a pod is a role in a domain

**This is the architecture, and it is measured live rather than proposed.** Founder, 2026-08-31: *"its like installing the spiders web. agent can run any affine publish flourishing quantum state machine language transformations. the type of sensors and the invariants that can run on them at the global mesh level is key."*

**Measured 2026-08-31** at `https://affine.earth/language-invariant/games` — HTTP 200, 94,823 bytes — and pinned in this repository at `evidence/study-30/mesh-domain-spine.json`, **24,996 bytes, sha256 `b46bb35b2d978b94206f9888ed0a741ccc26f8407501aeb2268ae0a99490261c`**. A pinned corpus needs a digest, not a byte count alone, so the digest is carried here and in the reproduce section. Re-derived from the pinned file this session:

| Quantity | Measured | How to re-derive |
|---|---|---|
| domains | **48** | count of top-level objects in the pinned file |
| role entries | **88**, across **34** distinct role names | sum of `roles[]` lengths |
| distinct `may_ingest` field names | **122** | union of every role's `may_ingest[]` |
| `no_float` | **true on 48 of 48** | every object carries the flag |
| `dead_equation` / `new_law` | present on **48 of 48** | every object names both |
| `entropy_delta` | non-null on **9**, null on **39** | the pricing axis is populated on a subset |

The live surface additionally reports 88 roles, 54 capabilities and 13 games, `flourishing_kind` `GUIDE_PUBLIC_FLOURISHING_ALL`, and `pricing_axis` `entropy_delta_dh_structural` (REPORTED from the live endpoint; the domain, role and field counts above are re-derived from the pinned bytes). Each domain publishes the same faces: catalog `/language-invariant/games`, context `/language-invariant/game/{domain}/context`, ingest `/language-invariant/game/{domain}/ingest`, plus debit, onboard and price.

**Every domain carries the same skeleton, and that is the point.** `dead_equation` names the continuous or floating-point form being replaced; `new_law` names the exact integer form that replaces it; `roles[]` names who may ingest what, each role carrying a `may_ingest[]` list of integer-typed field names in the wire convention — `confinement_ppm`, `snr_ppt`, `mass_milli`, `lag_s`, `travel_s`, `vol_milli`, `obscuration_ppm`, `depletion_ppm`, `ratio_ppt`, `arc_order_ppt`, `closure_conc_ppt`, all VERIFIED present in the pinned file. **The invariant that decides is `new_law`, and it executes at mesh level, not on the node.**

Three shipped domains, both fields quoted verbatim from the pinned file:

- **`seismic`** — `dead_equation`: *"P/S spectral discriminant in R"*. `new_law`: *"|travel_s - 53| <= 2 AND snr_ppt >= 20000"*.
- **`eclipse`** — `dead_equation`: *"TEC dropped N%; storm magnitude is the same ruler"*. `new_law`: *"cone gate 800000 ppm; coupling 3/10; confinement 50189 ppm; lag in [-300,+1200] s"*.
- **`physics`** — `dead_equation`: *"G_mu_nu = 8 pi T / c^4 as object factory; Z = integral e^{-beta H}"*. `new_law`: *"appointment = (clock, track, integer table)"*.

**Roles already include physical sensing.** Measured in the pinned file: `station` (in `seismic`, ingesting `travel_s` and `snr_ppt`), `gnss` and `ionosonde` (both in `eclipse`, ingesting `obscuration_ppm`, `depletion_ppm`, `confinement_ppm`, `lag_s`), `detector` (in `physics` and `eht`), plus `operator`, `digital_twin`, `regulator`, `certifier`, `auditor` and `steward`.

**The consequence for this charter, and it changes the question the applications section asks.** A pod is not a fixed-function box that must carry every sensor a use needs. **A pod is a role in a domain.** Its sensor set determines which `may_ingest` fields it can supply; the invariant that decides is the domain's `new_law`, running at mesh level. So a new sensing capability is a **published domain** carrying its own `dead_equation` → `new_law` pair and its roles' `may_ingest` lists — not a hardware change on every node. **Ask "which domain, which role, which `may_ingest` fields" before ever asking "which sensor does the pod need".**

**And the measured gap this immediately exposes, stated because it is the honest one.** Across all 48 domains and all 122 distinct `may_ingest` field names, **no field carries a temperature, a humidity or a pressure**. The pod's own three frozen scalars have no domain to ingest into today. A pod-class domain — carrying its own `dead_equation` → `new_law` pair and a role whose `may_ingest` names milli-°C, milli-%RH and Pa — **does not exist and would have to be published**. That is the work, and it is publishing a domain rather than reflashing hardware.

## What the instrument is for

**The honest limit first, and it governs every sentence in this section: no pod exists.** This section states what the chartered instrument would make **measurable**, never an outcome it achieves. Every tier in Section zero is what would establish that a built pod can hold even that much, and **no tier on this page grades any application outcome at all**. Every third-party figure is attributed inline with source, year and venue, and tagged VERIFIED where the primary source was read this session or REPORTED where it was not.

Four properties this page has already established do the work in all four lanes, and each is named where it is used: the **frozen 60 s ingest cadence**, the **42-byte wire frame**, the **3.240 J/hour binding energy budget at 60 tx/hr**, the **|change| < 32,768 recoverability bound**, and the **delta-driven wake** — a pod in a static environment spends the **83.1 mJ/hour** quiet floor and transmits nothing, which is what makes a multi-year unattended deployment arithmetically possible in the first place.

### Land use and desertification

**What the framework is.** SDG Indicator 15.3.1 is *"Proportion of land that is degraded over total land area"*, integrated from three sub-indicators — trends in land cover, trends in land productivity, and trends in carbon stocks above and below ground, with soil organic carbon (SOC) in the 0–30 cm layer as the surrogate for the third. The UNCCD's Good Practice Guidance calls land cover *"a transformational variable"*, land productivity *"a 'fast' ecological variable"* and carbon stocks *"a 'slow' ecological variable"*, integrates them by a one-out-all-out rule in which a significant negative change in any one makes the unit degraded, and states that *"The Indicator is reported as a binary quantification (i.e., degraded/not degraded)"* (VERIFIED — UNCCD, *Good Practice Guidance. SDG Indicator 15.3.1*, Version 2, 2021, §§1.1–1.2 and Appendix C; PDF fetched and text-extracted 2026-08-31).

**The cadence and the resolutions, exactly.** Reporting is four-yearly — *"The UNCCD has approved a four-year reporting frequency, and therefore a four-year reporting period"*, by decision 15/COP.13, every four years beginning 2018 — against a fixed baseline of *"the 16 years from 1 January 2000 to 31 December 2015"* (VERIFIED — same source). The default global datasets in the GPG's Table 2-1 are ESA-CCI land cover at **300 m**, JRC Land Productivity Dynamics at **1 km**, and ISRIC SoilGrids at **250 m** (VERIFIED — same source, Table 2-1). **The coarsest leg is 1 km, not 250–300 m**, and a page that writes "250–300 m" for the suite understates the default productivity product by a factor of sixteen in area. Pixel areas, as arithmetic over those published resolutions: a 300 m cell is **9.00 ha**, a 250 m cell **6.25 ha**, a 1 km cell **100 ha**.

**The framework names the binding constraint itself, and names it as resolution against the variability of the thing measured.** Verbatim: *"The level of confidence is related to the sub-indicator's absolute spatial resolution, the spatial resolution of the map relative to the typical variability of the object of interest in the environment…"*, followed immediately by the observation that finer local calibration *"is a highly specialized and expensive task however, and may not be realistically achievable by some countries"* (VERIFIED — same source). Its data-selection table adds: *"Large pixels (coarse spatial resolution) represent average conditions over a larger land area, which may not be desirable in landscapes with very complex or heterogeneous structures"* (VERIFIED). And on its own slow variable: *"For slow changing variables such as SOC, reporting every four years may not be practical or offer reliable change detection for many countries"* (VERIFIED).

**The management unit against the pixel.** Half of all fields in Africa's smallholder-dominated agricultural systems are smaller than 1 ha, and smallholder farms occupy up to 40% of agricultural areas globally, mapped from 130,000 crowdsourced locations interpreted on high-resolution imagery (VERIFIED — Lesiv, Laso Bayas, See *et al.* and Fritz, *Global Change Biology* 25(1):174–186, 2019, doi:10.1111/gcb.14492). Combining that with the resolutions above as **arithmetic, not measurement**: at a 1 ha median field, one default 300 m land-cover pixel spans about nine such fields and one default 1 km productivity pixel about a hundred. **The caveat travels with the number:** 1 ha is a median for African smallholder systems and not a global constant, and field boundaries do not tile a pixel exactly, so this is an order-of-magnitude statement about how many management units share one reported verdict — never a count of fields in any particular pixel.

**What in-situ adds, with the size of the gap measured by the people who mapped it.** *"These climatic grids do not reflect conditions below vegetation canopies and near the ground surface, where critical ecosystem functions occur"*, and mean annual soil temperature differs from gridded air temperature *"by up to 10°C (mean = 3.0 ± 2.1°C)"*, with soils in cold and dry biomes **+3.6 ± 2.3 °C** warmer — the dry-biome offset being the desertification lane's own regime — built from over 1,200 1-km² pixels summarised from 8,519 sensors (VERIFIED — Lembrechts, van den Hoogen, Aalto *et al.*, *Global Change Biology* 28:3110–3144, 2022, doi:10.1111/gcb.16060; published-version PDF fetched and read 2026-08-31; repository records disagree on issue number, so volume and pages are cited and the issue is not). The same paper states that ERA5-Land at 0.08° *"remain[s] too coarse for most ecological applications"* (VERIFIED).

**What the pod would make measurable, and it is one thing.** The frozen 60 s ingest period yields **1,440 samples per day**, from which daily Tmin and Tmax are exact integers rather than interpolated values. Those two integers are precisely the inputs the UNCCD's own aridity analysis uses for potential evapotranspiration, and the reason it uses them is stated in its own voice: PET is computed by Hargreaves-Samani from minimum and maximum temperature because the better Penman-Monteith method *"needs more climatic input data, which are not easily retrievable at high spatial resolutions, particularly for multi-scenario projections"* (VERIFIED — Vicente-Serrano, Pricope, Toreti *et al.*, *The Global Threat of Drying Lands*, UNCCD Science-Policy Interface Technical Series No. 09, 2024, ISBN 978-92-95128-16-3, Chapter 1 methodology; PDF fetched and text-extracted 2026-08-31). **The aridity index is used here only in ratio form** — AI = P/PET with the dryland threshold at 0.65 — because the same report's glossary states the relation as a percentage that does not follow from its own ratio, and the ratio form is both exact and free of that discrepancy.

**Scale, attributed.** *"More than three-quarters of all land on Earth (77.6 per cent) experienced a drier climate during the three decades leading up to 2020"*; drylands rose from 37.5 to 40.6 per cent of land excluding Antarctica; dryland population doubled to 2.3 billion in 2020 (VERIFIED — UNCCD SPI Technical Series No. 09, 2024, Key Messages and §2.1). Separately, at least 100 million hectares of healthy and productive land were lost each year over 2015–2019 from national reporting compiled from 126 countries (REPORTED — UNCCD press release, 24 October 2023). **Three different country counts are in circulation — 141 Parties responding to the GPG, 127 reporting in 2018, 126 in the 2023 dashboard — and they are three different populations at three different dates; this page does not fuse them.**

**What the pod does not do, stated as absent channels rather than as limitations to be worked around.**

- **It measures none of the three sub-indicators.** A T/RH/P point sensor produces no land-cover class, no vegetation index and no biomass. On SOC the GPG is explicit: *"The determination of SOC stock requires measurements of SOC concentration, soil bulk density and gravel content"*, and adds that *"Short-range spatial variation is typically large and can be easily confused with temporal variation"* (VERIFIED — GPG v2, 2021). The pod measures none of those three quantities.
- **It carries no soil-moisture channel at all.** The frozen HAL takes three scalars and a timestamp; the axis allocation assigns x₄/x₅/x₆ to T, H and P, x₇ to the flux derivative and x₈ to τ, leaving no axis free. Adding soil moisture is a HAL signature change, a new BOM line, a T2 re-scope and a change to what the frozen 42-byte frame means.
- **A Stevenson screen measures screen-height air, not the soil surface.** WMO-No. 8 specifies screen sensors mounted 1.25–2.0 m above ground. The pod as chartered therefore measures the very quantity Lembrechts *et al.* show differs from soil temperature by a mean of 3.0 ± 2.1 °C. **"Soil-surface microclimate" is not a description of this instrument**; screen-height air microclimate at a point, at a density no synoptic network provides, is.
- **No precipitation, no radiation, no wind.** The aridity index needs precipitation and PET; the pod supplies inputs to the PET half and none of the precipitation half. The GPG's two climate-correction methods for the productivity sub-indicator, Rainfall Use Efficiency and RESTREND, both regress productivity on rainfall (VERIFIED — GPG v2, Appendix B.2), an input the pod does not carry.
- **Reference network density, for the comparison a reader will reach for.** WMO's Global Basic Observing Network states *"The typical distance between stations at standard horizontal spacing is 200 km for surface land stations… but less distance is preferred down to 100 km"* (VERIFIED — WMO, MeteoWorld, 1 June 2023). As arithmetic, a 200 km cell is 40,000 km² and a 100 km cell 10,000 km². **The widely repeated "Africa is eight times below WMO density" figure is not used here: no primary source for it was retrieved.**

**The admissible claim, stated once and in full.** SDG 15.3.1 is reported every four years on a binary one-out-all-out verdict from default products at 300 m, 1 km and 250 m, against a framework that says confidence depends on resolution relative to the variability of the object of interest, and that provides a **named national ground-verification step** — the GPG's own §2.2.2, *"Identifying false positives and false negatives"*, and its statement that determination *"should be contextualized with other data and information for ground-based verification"* (VERIFIED). A pod mesh at the frozen cadence would make daily Tmin and Tmax available as exact integers at sub-field spacing. **Its role would be verification input to the framework's own ground-truth step, never a substitute for the indicator, and no tier on this page grades that role.**

### Water use and irrigation

**The share, with its year and its denominator.** Agriculture accounted for **71 per cent** of total freshwater withdrawals globally in 2022, against 15 per cent industry and 13 per cent municipal (REPORTED — FAO, *AQUASTAT Water Data Snapshot 2025*, published 19 December 2025, reference year 2022, reported via UN-Water; the FAO PDF host refused connection at time of measurement). **Withdrawal is not consumption.** And the same organisation's own methodology page gives **69 per cent** by aggregated volume and **59 per cent** by averaging country ratios, qualifying the first as *"biased strongly by the few countries which have very high water withdrawals"* (VERIFIED — FAO AQUASTAT "Water use" page, no reference year printed, read 2026-08-31). Two numbers for one question, separated only by the denominator: **state the denominator or do not state the ratio.**

**And the most-cited figure in this lane has been audited and found thin.** Tracing the "irrigation withdraws 70 per cent of global freshwater" and "produces 40 per cent of global crops" claims through 3,693 unique documents published 1966–2024, only about **1.5 per cent** of the documents cited in support provide original data; the authors' own re-derivation puts irrigation's share of withdrawals at 45–90 per cent and of grain production at 18–50 per cent, and states those ranges *"should be understood as lower bounds on the true uncertainty"* (REPORTED — Puy, Linga, Wei *et al.*, *PNAS Nexus* 4(11):pgaf323, November 2025, doi:10.1093/pnasnexus/pgaf323).

**How irrigation decisions are actually made, from the primary census file.** USDA NASS Table 25, *"Methods Used in Deciding When to Irrigate: 2023"*, United States row, 212,714 farms reporting any method: condition of crop by observation or experience **164,779**; feel of soil **85,093**; personal calendar schedule **44,349**; scheduled by water supplier **31,192**; soil-moisture sensing device **27,831**; commercial or government scheduling service **17,533**; daily crop-water evapotranspiration reports **15,484**; when neighbours begin to irrigate **10,228**; plant-moisture sensing device **5,282**; computer simulation models **1,627**. The published footnote reads *"Respondents could choose more than one method"*, so the rows do not sum to the total. As shares of 212,714 — arithmetic on the published integers — crop observation **77.5%**, feel of soil **40.0%**, soil-moisture sensor **13.1%**, computer models **0.8%** (VERIFIED — USDA NASS, *2023 Irrigation and Water Management Survey*, AC-22-SS-1, October 2024, Table 25; 4,464,836-byte file downloaded and read). **The instrument in commonest use is a person looking at the crop, by a factor of six over any sensor.**

**The scale at which the decision is made.** 212,714 irrigated farms in 2023 holding 53,135,170 irrigated acres, against 231,474 farms and 55,938,795 acres in 2018 — both the farm count and the acreage fell. Mean irrigated area per farm, as arithmetic on those integers, **249.8 acres (101.1 ha)**. The distribution is heavily skewed: **127,975 farms (60.2%) irrigate 1–49 acres and together hold 1,336,140 acres, 2.5% of the irrigated total** (VERIFIED — same source, Table 6; means and shares computed here). Any claim about "the" spatial scale of an irrigation decision has to carry that skew.

**The temporal scale.** FAO-56 schedules irrigation by tracking root-zone depletion on a **daily** soil water balance, and the reference implementations follow that time step (VERIFIED — Allen, Pereira, Raes & Smith, *Crop evapotranspiration*, FAO Irrigation and Drainage Paper 56, 1998, Ch. 8; daily-step implementation confirmed in Thorp, *SoftwareX* 19:101208, 2022). **The 60 s cadence therefore over-samples this decision by roughly 1,440 to 1.** That over-sampling is not automatically a defect — it is what makes threshold crossings and delta-driven wake possible — but a 60 s cadence must not be presented as if the decision needed 60 s resolution.

**What a T/RH/P pod supplies for evapotranspiration, mapped against the requirement list.** FAO-56 Penman-Monteith reference ET requires four measured meteorological quantities: daily maximum and minimum air temperature, actual vapour pressure, net radiation, and wind speed at 2 m (VERIFIED — FAO-56, Ch. 3). Mapping the pod's channels onto that list — this is a derivation performed here, not a third-party conclusion — the pod supplies **two and a half of four**: Tmax and Tmin directly, actual vapour pressure directly from temperature and humidity rather than by FAO-56's dew-point substitution, and barometric pressure, which lets the psychrometric constant be measured rather than derived from elevation (a real but small refinement, since FAO-56 already computes it from altitude in closed form). It supplies **neither net radiation nor wind speed** — the radiation and aerodynamic halves of the combination equation. FAO-56 provides a documented fallback: estimating the missing terms and using Penman-Monteith *"will provide somewhat more accurate estimates as compared to estimating ETo directly using Equation 52"*, and where no wind data exist *"a value of 2 m/s can be used as a temporary estimate. This value is the average over 2000 weather stations around the globe"* (VERIFIED — FAO-56, Ch. 3). **An ETo computed from temperature and humidity alone is admissible under FAO-56 and carries an assumed global-mean wind and an inferred radiation, and a page publishing one must say which inputs were measured and which were assumed.**

**The overclaim this lane must not make, and it is the sharpest one available.** The systematic review of US soil-water-sensor scheduling reports that sensor-based scheduling used on average **38 per cent less water than traditional/grower scheduling, 20 per cent less than evapotranspiration-replacement, 16 per cent less than computer models, and 1 per cent less than canopy-temperature scheduling**, across 49 papers over two decades, with yield larger or similar in every comparison (REPORTED — Datta & Taghvaeian, *Agricultural Water Management* 278:108148, March 2023, doi:10.1016/j.agwat.2023.108148; full text paywalled, percentages read from the publisher abstract). **The honest reading is a 1–38 per cent band whose value is set by what you compare against, not by the sensor**, and the flattering 38 per cent is the comparison with the least-defined baseline. The control arm is the negative one: a multi-study review of soil-moisture-sensor controllers reports savings of 42–72 per cent in rainy periods but **−1 per cent to 64 per cent in dry periods** — the lower bound is negative — with turf quality sometimes below the minimum acceptable level (REPORTED — Cárdenas-Lailhacar & Dukes, *Transactions of the ASABE* 55(2):581–590, 2012, doi:10.13031/2013.41392; citation confirmed against Crossref, percentages from secondary summaries; the trials are turfgrass and landscape, not a field crop). **Every one of those numbers belongs to a probe buried in the root zone. Placing them next to a T/RH/P pod would attribute to an atmospheric instrument a result earned by a soil instrument, and this page does not do that.**

**Where the supply-side gap actually is, and it is not resolution.** OpenET publishes evapotranspiration *"at a spatial resolution of 30m x 30m (0.22 acres)"* — against the 249.8-acre mean irrigated farm derived above, roughly **1,120 pixels per farm**, finer than any variable-rate control zone. So over the contiguous US the field-scale-versus-satellite-scale gap is **not primarily spatial**, and a page that says it is will be refuted by the first reader who checks. The gaps its own operators name are cadence, latency and scope: it *"currently provides data at monthly and yearly timesteps"*, with *"daily data prior to 2024 … of limited availability"*; on latency it states a two-day target as a target and not as a delivered figure; models degrade under dense cloud; and most decisively, *"OpenET is not intended to be a new irrigation scheduling tool"* (VERIFIED — OpenET FAQ, read 2026-08-31). Accuracy against flux towers at cropland sites: mean absolute error **15.8 mm per month (17% of mean observed ET)**, mean bias **−5.3 mm per month**, r² 0.9 (REPORTED — Volk *et al.*, *Nature Water* 2(2):193–205, 2024, doi:10.1038/s44221-023-00181-7; publisher returned 403, figures from release summaries). **The product covers the contiguous United States; no equivalent 30 m operational ET product is stated to exist for the regions where agriculture takes above 80 per cent of withdrawals, and that geographic asymmetry — not resolution — is the honest opening for a ground mesh.**

**And the deflating finding, carried because it is the one a specialist will raise.** Washington State University's variable-rate-irrigation fact sheet states that crop water use *"is largely independent of the soil type"*, so applying different amounts to different areas *"only makes sense if the crops are getting water from another source besides where the center pivot irrigation system is applying it, or if the crops are using less water in some areas of the field due to disease or pest pressure"*, and concludes that in low-rainfall areas buying variable-rate irrigation in response to variable soils *"has little opportunity to increase profitability"* against managing the whole field uniformly for the problem soil (VERIFIED — Peters, Molaei & Flury, WSU/IAREC irrigation fact sheet, PDF downloaded and read 2026-08-31; no publication date printed). The one case the authors name where denser in-field data earns its keep is leaving room in high-water-holding soils to capture forecast rainfall, which *"requires additional data collection of the soil water content in the different areas of the field"* — a soil channel the pod does not have.

**The admissible claim.** At the frozen 60 s cadence and the 42-byte frame, a T/RH/P mesh would make near-surface microclimate observable at the density irrigation is managed at, and would supply two of the four measured FAO-56 ETo inputs as measurements rather than assumptions. **It would not make soil water content observable, and soil water content is what the scheduling decision reads.** If the pod is to carry the irrigation lane rather than the microclimate lane, the honest version is that the HAL would need a soil channel, and that channel is not in this specification.

### Farming microclimate

**The decision object in this lane is a threshold crossing with a dwell, and that is what a daily aggregate cannot represent at all.** The published critical temperatures growers use are defined as what buds or developing fruit withstand for **thirty minutes** before permanent damage, tabulated per phenological stage at the 10 per cent and 90 per cent damage levels (VERIFIED — Murray, *Critical Temperatures for Frost Damage on Fruit Trees*, Utah State University Extension fact sheet IPM-012-11, March 2020, table attributed on the sheet to Washington State University). **The frozen 60 s ingest cadence resolves that dwell into exactly 30 consecutive samples.** No daily gridded product of any resolution represents a dwell.

**The thresholds are already whole integers, and so is the accumulation law.** Every value in the USU/WSU table is a whole integer degree Fahrenheit — apple silver tip 15/2, green tip 18/10, tight cluster 27/21, full bloom 28/25; peach swollen bud 18/1, pink 25/15, full bloom 27/24; and so on across pear, plum, cherry and apricot (VERIFIED — same source, pp. 1–2). The standard growing-degree-day form is the 86/50 system: daily GDD = (Tmax + Tmin)/2 − 50 °F with Tmax capped at 86 °F and Tmin floored at 50 °F, all four constants whole integers, base 50 °F for corn and 41 °F for forages (VERIFIED — Ohio State University Extension AGF-0101, revised 19 September 2023; NDAWN, NDSU; Cornell NRCCA Competency Area 2, PO 9, whose own caveat is that *"GDD is a valuable but rough guide to maturity time"*). **So the integer wire is the agronomy's own representation, not a substrate preference imposed on it.** As arithmetic derived here and stated as such — no cited agronomy source puts it this way, and no program in this repository computes it — with the clamps applied to integer inputs, 2·GDD_daily = (Tmax + Tmin) − 100 is exactly an integer, so a whole-season accumulation is exact in half-degree-day units with no rounding anywhere; on the pod's milli-unit wire, 2·GDD_daily in milli-degree-days = (T_max_milli + T_min_milli) − 20,000, exact in Int32/Int64 throughout. **And the method choice is itself contested:** two distinct methods for computing daily thermal time from daily extremes are in wide use, differing on whether the base is applied before or after averaging, and they give different totals — naming "GDD" alone does not pin an integer (VERIFIED — McMaster & Wilhelm, *Agricultural and Forest Meteorology* 87(4):291–300, 1997, doi:10.1016/S0168-1923(97)00027-0).

**The cadence lands on the meteorological standard, and the standard also names a gap this specification has.** WMO recommends that atmospheric pressure, air temperature and air humidity *"be reported as 1 to 10 min averages"* and that *"One-minute averages, as far as applicable, are suggested for most variables as suitable instantaneous values"* (VERIFIED — WMO-No. 8, Part II, Ch. 1, §1.3.2.4). The frozen 60 s ingest period is the WMO-recommended reporting interval for exactly the three quantities the frozen wire carries. **That is a coincidence worth stating as a fact and nothing more; it validates the interval, and it establishes nothing about the pod.** The gap is in the same guide: samples used to compute averages must be taken at intervals not exceeding the sensor time constant, and *"samples to be used in estimating extremes of fluctuations should be taken at least four times as often"*; Annex 1.D gives air temperature a 20 s time constant, so WMO's own rule asks for ≤20 s sampling for averages and ≤5 s for extremes — about 3 and 12 samples per minute (VERIFIED — WMO-No. 8, Part II §1.3.2.2 and Part I Annex 1.D; the per-minute counts are arithmetic on those two rules). **A 60 s ingest period as frozen is one instantaneous sample per minute, not a WMO one-minute average, and it under-samples extremes by about 12× against WMO's own rule — and daily Tmax and Tmin, the exact inputs the GDD standard consumes, are extremes.** The gap is fixable inside the existing frame — an integer accumulator sampling faster and publishing one 60 s aggregate per frame, still one 42-byte frame per minute — and it is carried in Open issues rather than left to imply a compliance the specification has not earned.

**The wire unit against the standard.** WMO-No. 8 Annex 1.D, row 1.1: air temperature range −80 to +60 °C, **reported resolution 0.1 K**, required measurement uncertainty 0.1 K in the −40…+40 band, sensor time constant 20 s, output averaging time 1 min, **achievable measurement uncertainty 0.2 K**; row 1.2 gives extremes a 0.3 K required uncertainty (VERIFIED). The frozen wire unit is 10⁻³ °C — 100× finer than the reported resolution and 200× finer than the achievable uncertainty. **Those extra digits are headroom, not accuracy**, and the numbers that actually bind a frost decision are WMO's 0.1 K and the 1 °C alarm margin below. This page pins no sensor part, so the quantiser check remains stated and owed rather than performed.

**What density is worth, measured.** On a freeze night the authors of the FAO frost manual *"observed spatial differences of 1.0 °C or more within a couple of hundred metres in an orchard … measured at the same height above the ground on flat terrain"*, and conclude *"it is somewhat questionable that Tc values from shelter temperatures are universally applicable"* (VERIFIED — Snyder & de Melo-Abreu, *Frost Protection: fundamentals, practice and economics*, Vol. 1, FAO, 2005, ISBN 92-5-105328-6, Ch. 4, p. 73). **Flat terrain, same height — so that 1.0 °C is the irreducible floor, not a topographic pooling figure, and it is the same magnitude as the margin growers are told to pre-pay:** *"When using a frost alarm, set the alarm about 1 °C higher than the starting air temperature identified in Table 7.5 to ensure sufficient time to start the sprinklers"*, and 1–2 °C higher for a thermostat, *"depending on thermostat accuracy"* (VERIFIED — same source, Ch. 7, p. 170). The margin exists to pay for detection latency and instrument uncertainty, and it is spent on the crop.

**How fast the event moves.** In FAO's worked example, *"most of the temperature drop occurs in a few hours around sunset"*: the temperature fell about 10 °C in the first hour after net radiation turned negative, then about 10 °C more over the entire remainder of the night, at less than 1.0 °C h⁻¹ from two hours after sunset until sunrise (VERIFIED — same source, Ch. 1, p. 6 and Fig. 1.4). As arithmetic on those published figures: ~10 °C/hour is ~0.17 °C per 60 s sample, so FAO's 1 °C alarm margin is worth about six minutes of start time on the steep limb and roughly an hour on the shallow limb. **Two regimes an hour apart in rate, and a daily statistic represents neither.**

**In-canopy against the station, and the GDD consequence.** A Washington State University vineyard instrumented with 7 in-canopy thermistors, 6 berry-cluster thermocouples and 2 weather-station sensors measured, in summer, average daily minimum air temperature within the canopy **1.2 °C lower** and average daily maximum **2.0 °C higher** than at the station, with west-facing clusters 4.0 °C higher; the authors conclude that models assuming station air temperature resembles canopy air temperature *"could have greater uncertainty"* (VERIFIED — Peña Quiñones, Hoogenboom, Salazar Gutiérrez, Stöckle & Keller, *PLOS ONE* 15(6):e0234436, 2020, doi:10.1371/journal.pone.0234436). **The canopy minimum is the colder one, which is the frost-relevant sign.** At production scale, a 731-station in-orchard network plus 34 CIMIS stations across California's Central Valley on 10-minute records measured individual reference stations departing by up to **3.3 °C** from the average of surrounding in-orchard stations, within-20 km discrepancies of 0.17–0.84 °C by quarter, **discrepancies of over 300 GDD** in accumulated thermal time between interpolating all stations and using only the nearest reference station, and phenology prediction errors of 8.3 days for almond flowering (VERIFIED — Martínez-Lüscher, Teitelbaum, Mele, Ma, Frewin & Hazell, *PLOS ONE* 17(5):e0267607, 2022, doi:10.1371/journal.pone.0267607).

**And the honest limit on gridded products, read in both directions.** Comparing Daymet and PRISM against measured weather for maize simulation, the authors found **small** biases for temperature and growing-degree-days and close agreement in phase duration (RMSE 3–7 days), while simulated yields diverged at RMSE 18% (Daymet) and 24% (PRISM) of average yield; interpolation from a dense station network beat every gridded product on both phenology and yield, and the conclusion is that *"gridded weather data cannot replace measured weather data as a basis for field-scale agricultural applications"* (VERIFIED — Mourtzinis, Rattalino Edreira, Conley & Grassini, *European Journal of Agronomy* 82(A):163–172, 2017, doi:10.1016/j.eja.2016.10.013). **So a claim that a pod materially improves GDD accuracy over a gridded product is not supported by this source and is not made here.** For context on what a daily gridded average is: gridMET ~4 km daily (Abatzoglou, *International Journal of Climatology* 33:121–131, 2013), Daymet 1 km daily, PRISM 4 km in the free daily product and 800 m native — and the 1.0 °C within-200 m orchard difference and the 3.3 °C station-to-orchard departure both sit entirely inside a single cell of every one of them.

**What is not admissible in this lane, stated because the strong version is tempting.** An air-temperature threshold crossing is **not a damage verdict**. FAO states that critical temperatures are bud, flower or small-fruit **tissue** temperatures, that these *"are likely to differ from air temperature, which is what growers typically measure"*, that active protection must therefore start and stop at **higher** air temperatures than the tables indicate, and that *"using temperatures from a weather shelter only provides a rough guideline for expected damage"* (VERIFIED — same source, Ch. 2 p. 17 and Ch. 4 p. 73). Note also that FAO's own T10/T90 are *"the temperatures where 10 percent and 90 percent of the marketable crop production is likely to be damaged"* — **a different quantity from the USU/WSU bud table, and the two conventions are not interchangeable** (VERIFIED — same source, Ch. 2, p. 17). One further owed item: FAO's sprinkler start and stop rules are stated on the **wet-bulb** temperature and its published equations (7.2–7.5) are floating-point transcendental expressions. The pod's frozen T/H/P triple is sufficient input and this program already holds an exact psychrometric key — [Study 28](Study-28-Wet-Bulb-Threshold-Court.md) pins the Alduchov–Eskridge saturation form and the moist-air enhancement factor as exact rationals with a bounded-interval exp — but **no integer or rational form of FAO's four equations is pinned in this charter**, so the wet-bulb lane is owed rather than carried.

**Loss magnitude, with its denominator.** Freezes, cold, wet weather and frost together accounted for **$854 million** in US crop damages in 2024, within over $20.3 billion in total crop and rangeland damage, from USDA Risk Management Agency indemnity data adjusted for uninsured acreage (REPORTED — Munch, American Farm Bureau Federation Market Intel, 18 February 2025). **It is a single-year US figure for a fused category, not a frost-only number and not a global one.**

**The admissible claim.** The frost decision object is a threshold crossing with a 30-minute dwell; the published thresholds and the GDD accumulation are already integer laws; the frozen 60 s cadence resolves the dwell into 30 samples and matches the WMO reporting interval; the measured within-orchard spread on a freeze night is 1.0 °C over 200 m on flat terrain at the same height, the same magnitude as the alarm margin FAO tells growers to pre-pay, and entirely inside one cell of every daily gridded product. **And a frost night is exactly a delta-driven event, so the binding 3.240 J/hour budget is this lane's worst case and its mean is far below it.** Not admissible, and no tier grades any of it: that the pod prevents frost damage, improves yield, detects tissue damage, improves GDD accuracy over gridded products, or saves a stated fraction of anything.

### Safety from predators, and the mesh spine reframes the question

**Frame it as detection and early warning that protects the herd and the animal at once.** Persecution arising from livestock conflict is a named driver of large-carnivore decline: of the 31 largest mammalian carnivores, **61 per cent** are IUCN-listed as threatened and **77 per cent** are undergoing continuing population declines, with range estimates for 17 species showing they *"currently occupy on average only 47% (minimum <1%, maximum 73%) of their historical ranges"*; the named mechanism is that wide-ranging behaviour *"bringing them into conflict with humans and livestock, is what makes them vulnerable and poorly able to respond to persecution"* (VERIFIED — Ripple, Estes, Beschta *et al.*, *Science* 343:1241484, 2014, doi:10.1126/science.1241484; author accepted manuscript PDF fetched and read 2026-08-31 — the fetched manuscript prints "VOL 000", so the volume is carried from the published record and not from the bytes read). **Reducing the encounter reduces the loss to the herd and the pressure on the animal, and that is the whole value proposition.**

**The wrong question, and why the spine section above is where this lane is decided.** Asked of a fixed-function node, "can a T/RH/P pod detect a predator?" has one answer: no. A large carnivore approaching a herd produces no change in ambient air temperature, relative humidity or barometric pressure that a fixed pod could resolve, and the closest published sensor study runs the other way — on-animal GPS collars measured sheep travelling **11.6 ± 3.12 km/day** with a wild dog present against **9.2 ± 2.73 km/day** after removal, an overall **12.63 (±0.90) per cent** change in distance travelled, while the temperature-humidity index entered the model as a **nuisance covariate** at *"a −2.17 (±0.10) percent change in distance travelled"* per unit of maximum THI, with the predator-present period carrying the **lower** mean THI (VERIFIED — Evans, Trotter & Manning, *Animals* 12(3):219, 2022, doi:10.3390/ani12030219; PMC8833745 fetched and read 2026-08-31; single-property case study in Western Queensland, and the paper says so). **In the only published sensor study on point, temperature and humidity move opposite to the predator effect and had to be controlled out. A T/RH channel asked to read "predator" from that would be reading weather.** No source found in this pass reports predator detection from ambient T/RH/P — and that is a search result from this pass, never a proof of absence.

**The question the spine actually asks.** A web does not detect prey with a prey-detector; it detects disturbance propagating through a structure, and the web is the sensor. Under the spine architecture the lane needs **a domain whose `new_law` decides on ingested integer deltas, plus at least one role whose `may_ingest` carries a field that moves when a predator is near.** Measured against the pinned spine: **no such domain exists today.** The closest shapes already shipped are `seismic`'s `station` role, whose `new_law` is a threshold on an arrival time and a signal-to-noise ratio in parts-per-thousand — the shape an acoustic detection would take — and `physics`'s `detector` role, ingesting `clock`, `track` and `table_counts`. Neither is a proximity domain, and none of the 122 `may_ingest` field names is a proximity field. **Publishing the domain is the work; reflashing pods is not.** What the pod's frozen properties would then contribute is exact carriage: a fixed-width integer displacement, the |change| < 32,768 bound making a detection event an exact integer rather than a stream, T3's 42-byte frame length, and T4's byte-identical replay grading whether the alert a herder acted on is the alert the sensor emitted.

**And a detection modality is a re-scope, not a footnote.** Every published detection route for a predator near livestock uses acoustic, optical/thermal, or on-animal sensing. A microphone or an imager streams at a data rate orders of magnitude above three int32 scalars every 60 s, and a 42-byte frame carries an eight-axis integer displacement, not a classification. **Naming the modality and re-deriving T2's ingest set, T3's frame length and the hourly energy budget against it is the work this lane owes before any predator claim can be made** — and that sentence is charter reasoning by this pass with no external source, published as reasoning.

**Where the strongest evidence in this field actually sits, because it is not on instruments.** Five randomized controlled trials with crossover designs across four countries support confidence in two deployments: *"The first is the deployment of herders using low-stress livestock-handling techniques"* and *"The second is the deployment of light deterrents when wild carnivores are not already habituated to human lights"*, with *"Our confidence in fladry … enhanced by independent replications"* (VERIFIED — Treves, Fergus, Hermanstorfer, Louchouarn, Ohrens & Pineda-Guerrero, *Animal Frontiers* 14(1):40–52, 2024, doi:10.1093/af/vfad072; PMC10873015 fetched and read). **Not one of the three endorsed interventions is a sensor.** And the evidence base as a whole is thin in its own authors' words: a synthesis of 114 studies drawn from four reviews that screened over 27,000 candidates states that *"scarce quantitative comparisons of interventions and scarce comparisons against experimental controls preclude strong inference about the effectiveness of methods"* and that *"many widely used methods have not been evaluated using controlled experiments"* (VERIFIED — van Eeden, Eklund, Miller *et al.*, *PLOS Biology* 16(9):e2005577, 2018, doi:10.1371/journal.pbio.2005577); an earlier systematic review of 562 publications found only **21** carrying evidence of effectiveness for any intervention (REPORTED — Eklund, López-Bao, Tourani, Chapron & Frank, *Scientific Reports* 7:2097, 2017, doi:10.1038/s41598-017-02323-w; both nature.com and PMC were unreachable this pass, so the counts come from search summaries).

**The measured both-sides outcomes, each with its scope.** Over 25 years, 634 livestock guarding dogs placed on Namibian farmlands (1994–2018), with questionnaire data for 472 dogs across 1,567 surveys: *"LGDs reduced livestock losses for 91% of respondents"*, losses to jackal reduced by 45 per cent, to cheetah 16 per cent, to caracal 15 per cent — and the coexistence half, verbatim: *"Before the placement of an LGD, 13% of farmers reported to have used lethal control methods against predators on their farm. This number dropped to 8% after the placement of an LGD."* (VERIFIED — Marker, Pfeiffer, Siyaya *et al.*, *Journal of Vertebrate Biology* 69(3):20115, 2020, doi:10.25225/jvb.20115; open-access PDF fetched and read 2026-08-31. **Survey-based and uncontrolled, and the page says so.**) Over seven years on Idaho public grazing land, a protected area running herders, guardian dogs, fladry, noisemakers and lights against an adjacent unprotected area: sheep depredation losses to wolves **3.5 times higher** in the unprotected area, protected-area losses **0.02 per cent** of total sheep present, and **no wolves lethally controlled within the protected area** (REPORTED for the figures — Stone, Breck, Timberlake *et al.*, *Journal of Mammalogy* 98(1):33–44, 2017, doi:10.1093/jmammal/gyw188; citation VERIFIED via Crossref, figures read from the abstract; absolute counts were not retrieved and are not stated). At Nairobi National Park, of the attacks recorded at 43 flashlight-equipped enclosures, *"184 (96%) attacks took place prior to flashlight installation and 7 (4%) after flashlight installation"* — **and the displacement finding travels with it**: mean attack distance from the park boundary rose by roughly 2 km per 3 years from 2012, and *"Of the 105 diurnal predation cases, 21 (20%) occurred prior to flashlight installation (2007–2011) and 84 (80%) after"* (VERIFIED — Lesilau, Fonck, Gatta *et al.*, *PLOS ONE* 13(1):e0190898, 2018, doi:10.1371/journal.pone.0190898). **Protection at one enclosure displaced pressure toward unequipped ones and toward daylight; printing the 96 per cent without the displacement would be exactly the overclaim this program exists to catch.** A randomized crossover trial of portable flashing lights on the Chilean Andean plateau deterred puma attacks and did **not** deter Andean fox predation (design VERIFIED — Ohrens, Bonacic & Treves, *Frontiers in Ecology and the Environment* 17(1):32–38, 2019, doi:10.1002/fee.1952, citation confirmed via Crossref; the loss counts are REPORTED from summaries because the publisher returned 403 on every attempt) — **a deterrent that works on one predator and not another is not a general instrument.**

**The modalities that are established, with their measured error rates, and what they are for.** Automated acoustic wolf detection: a CNN correctly classified 77 per cent of howling examples at a 1.74 per cent false-positive rate, retrieving 81.3 per cent of observed events with a 15-fold reduction in operator time (REPORTED — Campos, Krofel, Rio-Maior & Renna, *Remote Sensing in Ecology and Conservation* 12(1):58–70, 2025, doi:10.1002/rse2.70024; citation VERIFIED via Crossref, figures from summaries after a 403); benchmarking three AI systems on Danish recordings gave individual recall 59.6–78.5 per cent while *"a combined approach utilizing all three models achieved a 96.2% recall"*, the authors concluding the tools function as *"powerful human-aided data reduction tools"* rather than autonomous detectors (REPORTED — Jacobsen, Orlando, Jensen, Pagh & Pertoldi, *Animals* 16(2):175, 2026, doi:10.3390/ani16020175; Crossref record and abstract read, full text not). **Both papers are about population monitoring, and no measured livestock outcome is attached to either.** On the actuator side, virtual fencing is measured and works as containment — 25 collared cows through 14 days of training and 18 of testing gave containment of 99.44 and 99.75 per cent in training and ≥99.97 per cent in testing, with a time-dependent fall in the pulse-to-warning ratio (VERIFIED — Campa Madrid *et al.*, *Animals* 15(15):2178, 2025, doi:10.3390/ani15152178; PMC12345423 fetched and read) — **but it establishes no predator outcome; it moves stock and detects nothing wild.**

**The negative result, and it is the finding this lane most needs.** **No peer-reviewed evaluation of an automated, real-time predator early-warning alert system delivering a measured reduction in livestock losses was found in this pass.** What exists is collar-derived situational awareness on a daily cycle and geofence alerting under development, neither published with a measured depredation outcome (REPORTED — programme descriptions from search summaries; no primary source fetched). **That is a search result from this pass and not a proof that none exists**, and it is stated in exactly that form — because a page that applies this discipline to its own unbuilt pod owes the same discipline to everyone else's.

**The admissible claim.** A pod mesh at the frozen cadence, frame and budget would make the microclimate of a grazing block observable continuously and unattended at the density the block is worked. **It would not make a predator observable.** Making one observable is a published domain plus a role whose `may_ingest` carries a proximity field, and neither exists today. **No tier on this page grades a coexistence outcome at all.**

## The two readings and where they disagree

| Reading | What it holds constant | The observation that separates it | Sourcing |
|---|---|---|---|
| **Orbital uplink** — terrestrial sensing is a bandwidth problem; put a broadband link at every node and ship the raw stream | The magnitude: it genuinely delivers megabits per node, and for workloads that need megabits there is no substitute and this page does not pretend there is | It is a **metered subscription on hardware and spectrum the local entity does not own** — one per node, or one per aggregation group. Energy follows the same shape: a tracking terminal at the 60 W class spends ~2.16 × 10⁵ J per hour of availability regardless of how few integers crossed. | REPORTED (terminal power class); arithmetic VERIFIED |
| **Terrestrial integer lattice** — the mesh needs a displacement, not a stream; publish an 8-tuple and own the hardware | The shape: what crosses is a fixed-width integer displacement whose size does not grow with sensor count | The frame is 42 B whatever the pod is sensing. Airtime falls accordingly on this link, node energy is budgeted below, and under this charter the hardware, spectrum use and telemetry stay with the local entity. The delta is the whole export. | Airtime VERIFIED as arithmetic; hardware drafted |
| **The null** — the transport advantage is an encoding artifact, not a geometric one: any protocol engineer swapping verbose JSON for a tight binary encoding gets the same ratio, and the torus contributes nothing | Nothing; it predicts the ratio survives replacing the lattice with any compact binary schema | **This is the sealed adversary, it is not a straw man, and Section zero does not retire it — the measurement below concedes it.** The 3.49× airtime ratio is largely an encoding result and is published as such. What the geometry contributes is **sufficiency and fixed width**: the 8-tuple is what the mesh needs, so the payload does not grow when the pod grows a sensor, and T4 is decidable because the arithmetic over it is exact. A compact binary re-encoding of a *growing* record buys the ratio once and loses it again as the record grows. | Design statement of this charter |

The readings are separated on **shape, never magnitude**. The orbital reading is not the adversary because its numbers are bad — for the workloads it is built for they are excellent. It is the adversary here because its shape is wrong for *this* workload: a metered per-node subscription on non-owned hardware standing in for a fixed-width displacement on hardware the local entity owns.

## Computed airtime — this workload, this link budget

**SX1262, SF9, 125 kHz bandwidth, CR 4/5, 8-symbol preamble, explicit header, CRC on, LDRO off.** These are **computed** from the closed-form time-on-air expression, not measured on a radio. Re-derived in exact integer microseconds: symbol time 2⁹/125000 s = **4096 µs exactly**; preamble (8 + 4.25) symbols = **50,176 µs**.

| Frame | Payload | Symbols | Airtime | Transmissions/hour at 1% duty |
|---|---|---|---|---|
| Float JSON telemetry frame | 201 B | 233 | **1004.544 ms** | **35** |
| **The frozen wire frame — 16 B delta + 26 B header** | **42 B** | **58** | **287.744 ms** | **125** |
| Δ int32 × 8, payload only | 32 B | 48 | 246.784 ms | 145 |
| Δ int16 × 8, payload only | 16 B | 28 | 164.864 ms | 218 |

**The frozen wire frame is 42 bytes:** a 16-byte displacement of eight `int16` axes plus a 26-byte header (16-byte site id, 8-byte monotonic sequence, 2-byte schema version). The header is load-bearing rather than overhead — T3 grades a published subject and T4 grades duplicate rejection and ordered replay, and neither is decidable without it. The payload-only rows are the displacement alone and are not gradeable under T3 or T4; the operational ratios are the 42 B row's.

**Counts floor; they never round.** One percent of 3600 s is **36.000 s** of airtime per hour, and the count is `floor(36 s ÷ airtime)` in every row. The two rows where the distinction decides the integer:

- 36 × 1004.544 ms = 36.16 s → **breach**. 35 is correct.
- 146 × 246.784 ms = 36.03 s → **breach**. 145 is correct.

A regulated budget floors. Rounding a duty cycle up is a breach expressed as a rounding convention.

**The operational ratios, on the real 42 B frame against the 201 B JSON frame:** airtime 1004.544 : 287.744 = **3.49×**; transmissions per hour 125 : 35 = **3.57×**. Both are derived here from the printed airtimes and counts; `lora-time-on-air.swift` prints the four airtimes and the four floored counts and the payload-only ratios, and **does not print these two** — a reader re-derives them from the table above. The two differ *because* of the floor, and publishing both rather than smoothing them to one number is the point. The airtime ratio sits below the payload-only ratio because preamble and header are fixed cost that no payload shrink removes.

**The sub-band is named, because every count above is specific to it.** Airtime is what a 1% sub-band actually meters — duty cycle is regulated in **time**, not in bytes (REPORTED — the EU **868.0–868.6 MHz sub-band, band g1**, under ERC Recommendation 70-03 / ETSI EN 300 220). Other sub-bands in the same regime carry 0.1% and 10% limits, so a count computed at g1 does not transfer.

**And the pod never reaches this ceiling.** T1 freezes the ingest period at 60 s, so at most 60 samples per hour exist to transmit. The 125 transmissions/hour figure is the regulatory limit on this sub-band at this frame size; the binding rate is **60 tx/hr**, and the energy section prices that.

**Scope, stated rather than left to be inferred:** this is a claim about **this workload on this link budget** — a fixed 8-tuple at SF9/125 kHz on a 1% sub-band. It is not a claim that megabit uplinks are unnecessary in general. A workload that needs a megabit needs a megabit, and no lattice changes that.

## Delta-driven compute — the pod does not poll

**The architecture is specified as event-driven, and that is what the energy table means.** Continuous polling spends power holding a static environment under observation. Here the low-power sensors are tied to hardware interrupts on the ESP32-C6, and while environmental state is unchanged the core stays in deep sleep. Compute is proportional to displacement: on wake the node computes the geometric displacement, and **if the change is below threshold the cycle terminates before touching the NVS buffer or powering the radio.** Energy is expended when reality changes.

**So the hourly totals below are bounded on both ends and measured at neither.** A delta-driven pod in a quiet environment spends the sleep term and nothing else — the **true quiet floor of a genuinely silent hour, 3,600 s × 23.1 µW = 83.16 mJ**, printed on this page as **83.1 mJ/hour**. **The true consumption is a property of the environment, not of the pod**, which is why this page publishes bounds and no single figure between them. **T1 is where they become numbers.**

**The falsifiable criterion this adds, and it is a chartered criterion outside the four-tier gate:** a pod held in a deliberately static environment for a full diurnal cycle must show a transmission count of **zero** and a mean supply current within **±3 µA of the frozen 7 µA sleep budget**, measured at the pod's own rail. **The control arm:** the same pod given one threshold-crossing stimulus must wake, transmit exactly once, and return to sleep. A node that transmits on a static bench is polling with extra steps; a node that stays silent through a real excursion is a broken sensor. Both failures are observable in the same trace. **The per-axis wake threshold that decides "below threshold" is not frozen on this page** — it is carried in Open issues as owed at build stage — so this criterion is chartered and not yet decidable, and neither arm is measured, because no pod exists.

## Energy — a budget from datasheet currents, not a measurement

**No pod exists, so this is a computed budget.** Every input is printed here so a reader can substitute their own and re-derive (VERIFIED as arithmetic; the currents REPORTED from datasheets).

| Term | Value | Source |
|---|---|---|
| Rail | 3300 mV | design |
| SX1262 TX current @ +14 dBm | 45 mA | Semtech SX1262 datasheet, typ (revision not pinned on this page) |
| MCU active (sense + quantise, radio off) | 60 mA | Espressif ESP32-C6 class figure (revision not pinned on this page) |
| Deep sleep | 7 µA | Espressif ESP32-C6 **chip** figure |
| Airtime per report | 287,744 µs | the 42 B frame, computed exactly above |
| MCU wake window | 50,000 µs | design |
| Sleep power | 23.1 µW | 7 µA × 3300 mV |
| **Reports per hour, binding** | **60** | one per frozen 60,000,000,000 ns ingest period |
| Reports per hour, regulatory ceiling | 125 | floor(36 s ÷ 287.744 ms) — **never reached at the frozen cadence** |

Per transmission **42.73 mJ** (0.045 A × 3.3 V × 0.287744 s); per wake **9.90 mJ** (0.060 A × 3.3 V × 0.050 s).

| Operating point | Transmissions | Wakes | Sleep across the remainder | Hourly total | Per delivered report |
|---|---|---|---|---|---|
| **Binding — 60 tx/hr at the frozen 60 s cadence** | 60 × 42.73 = **2,563.8 mJ** | 60 × 9.90 = **594.0 mJ** | 3,579.735 s × 23.1 µW = **82.7 mJ** | **3,240.5 mJ = 3.240 J** | **54.0 mJ** |
| Regulatory ceiling — 125 tx/hr | 125 × 42.73 = **5,341.2 mJ** | 125 × 9.90 = **1,237.5 mJ** | 3,557.782 s × 23.1 µW = **82.2 mJ** | **6,660.9 mJ = 6.661 J** | **53.3 mJ** |
| A genuinely silent hour | 0 | 0 | 3,600 s × 23.1 µW = **83.16 mJ** | **83.1 mJ** | — |

**The three sleep terms are three different quantities and this table keeps them apart.** 82.7 mJ and 82.2 mJ are the sleep remainders *inside* transmitting hours; 83.16 mJ is the floor of an hour in which nothing was transmitted. Only the third prices silence.

| Path | Energy per hour | Basis |
|---|---|---|
| A.E.P-1 pod at the binding 60 reports/hour | **3.240 J** | the budget above |
| A.E.P-1 pod at the 125 reports/hour ceiling | **6.661 J** | the same budget at a rate the frozen cadence never reaches |
| Tracking terminal, 60 W class | **2.16 × 10⁵ J** | 60 W × 3600 s. **The 60 W is a class figure attributed to no vendor**, and it is the denominator's counterpart in the ratio below — a reader substituting a measured terminal draw must recompute rather than inherit it. |

**The ratios, each with its denominator named: 2.16 × 10⁵ J ÷ 3.2405 J = 66,656 : 1 at the binding rate, and ÷ 6.6609 J = 32,428 : 1 at the regulatory ceiling** (rounded to the nearest integer; the floor rule governs duty-cycle counts, not ratios). **The denominator on the other side is an hour of availability, never a delivered measurement.** The two paths move very different data volumes in that hour, so a per-measurement label would compare two different quantities. Both are budgets, and **T1 is the tier that would convert them into measurements.**

**One deep-sleep caveat the budget cannot absorb.** The 7 µA is the *chip* figure. Measured commercial dev boards run to **72 µA** from board-level leakage. **The pod's own PCB must be measured, not inherited.** At 72 µA the sleep power is 237.6 µW, a genuinely silent hour costs **855.36 mJ**, and the binding 60 tx/hr total rises to **4.008 J/hour** — which does not change the shape of the argument and is exactly why T1 measures it instead of this page asserting it.

## The power chain — and the panel, sized to the rating

**The PMIC input rating is pinned to the current revision.** The BQ25570's **SLUSBH2G** carries **Peak Input Power 510 mW** in Absolute Maximum Ratings, and Electrical Characteristics gives PIN 0.005–510 mW. The datasheet's own revision history reads: *Peak Input Power changed From MAX = 400 mW To MAX = 510 mW.* A ≤ 400 mW qualifier survives only as a **footnote on Recommended Operating Conditions after cold start**. **400 mW is not the rating** and is not cited as one here (REPORTED — TI SLUSBH2G, document number pinned; the Espressif and Semtech revisions are not pinned and are named as unpinned).

**Gate 1 resolution: keep the BQ25570, size the panel to the PMIC.** The specified panel is monocrystalline at **~400 mW nominal**.

**Why 500 mW nominal does not hold.** A panel nameplate is an STC figure at 25 °C, and monocrystalline power **rises as temperature falls**, at 0.30–0.45 %/°C. The tested rows, printed by `gate-checks-panel-and-flux.swift`:

| Panel nominal | 0 °C | −20 °C | Sourcing |
|---|---|---|---|
| 500 mW, mildest coefficient 0.30 %/°C | **537 mW** | **567 mW** | printed by the program |
| 500 mW, harshest coefficient 0.45 %/°C | **556 mW** | **601 mW** | printed by the program |
| 450 mW, harshest coefficient | — | **541 mW** | printed by the program |
| **400 mW, harshest coefficient** | **445 mW** | **481 mW** | **arithmetic on this page — no program tests 400 mW** |

**Every combination the programs test exceeds 510 mW.** A 500 mW nominal panel breaches the PMIC's rated input on a cold clear morning, which is precisely the condition a solar-powered outdoor node is built for. **The ~400 mW nominal specification is derived by arithmetic from the tested 450/500 mW rows and is not itself a printed program arm**: 400 mW × 1.2025 = 481 mW at −20 °C on the harshest coefficient, under the 510 mW ceiling with 29 mW of margin. Adding a 400 mW arm across both temperatures and all three coefficients is owed and is carried in Open issues. Spec a panel by its worst-case deliverable power, never by its nameplate.

**And the margin is unaffected, which is why the resize costs nothing.** Supply against demand, scaled linearly to 400 mW nominal from the program's 500 mW overcast case and **labelled as arithmetic, not as a printed arm**: a 400 mW panel yielding 80 mW through a 24 h overcast day gives **1.92 Wh**.

| Demand | Daily energy | Margin against 1.92 Wh |
|---|---|---|
| A fully quiet day at the 83.1 mJ/hour floor | 1.996 J = **0.000554 Wh** | **3,463×** |
| The binding 60 tx/hr rate, every hour | 77.77 J = **0.021603 Wh** | **88×** |
| The 125 tx/hr regulatory ceiling, every hour | 159.86 J = **0.044411 Wh** | **43×** |

Even 40 mW for 4 h in deep winter gives 0.16 Wh — **3×** the full regulatory ceiling. **The panel was never the constraint; the PMIC's input rating was.** (`panel-energy-margin.swift` prints 54× at 500 mW nominal against the ceiling and `gate-checks-panel-and-flux.swift` prints 48× at 450 mW; the 43×, 88× and 3,463× rows above are this page's arithmetic at the specified 400 mW.)

**The second limit, and the topology it forces.** The BQ25570's buck output is rated **110 mA typical**, while the ESP32-C6 draws **295–382 mA** during a 2.4 GHz transmit burst. **The ESP-NOW path cannot be sourced from VOUT.** The resolution is architectural and is stated here as the chosen one: **MPPT charges storage — a LiFePO4 cell or a 500 F supercapacitor bank — and the accumulated charge drives the burst.** The PMIC is the charger, never the burst supply.

**A third specification is widely mis-quoted.** Cold-start VIN(CS) is **600 mV typ / 700 mV max**, not the 330 mV still carried by secondary sources. Continuous harvesting after cold start goes down to VIN = 100 mV.

**And the part is single-source.** TI listed it out of stock at the time of checking — a supply risk in an open-hardware BOM whose premise is that anyone can build it.

## Reversibility buys computational integrity, not heat

A reversibility argument is available here, and its thermodynamic version does not survive arithmetic.

At 300 K, kT ln 2 = **2.871 × 10⁻²¹ J/bit**. On this page's own two widths: erasing the **128-bit displacement** has a Landauer bound of **3.67 × 10⁻¹⁹ J**, and erasing the **336-bit wire frame** has a bound of **9.65 × 10⁻¹⁹ J**. Against the budget above, the compute-and-quantise wake window at **9.9 × 10⁻³ J** is a factor of **1.0 × 10¹⁶** over the frame bound, and a whole delivered report at **54.0 × 10⁻³ J** is a factor of **5.6 × 10¹⁶** over it. Which width and which term are chosen moves the exponent not at all; the answer is 10¹⁶ every way, and that is the entire point.

**Sixteen orders of magnitude is not a margin tidier logic closes.** Logical reversibility executed on irreversible CMOS yields no thermodynamic saving; the bound is not what any of that energy is spent against. Realising it would need adiabatic hardware, which the A.E.P-1 is not and does not claim to be.

**The float exception, named because the page's own discipline applies to the page.** This paragraph is the only arithmetic on this page computed in floating point, because ln 2 is irrational. It decides nothing: no verdict, no tier, no frozen integer depends on it, and only its **exponent** carries the argument. Every program in the reproduce section is integer-only and declares no float type. This one quantity is prose arithmetic, and it is labelled as such rather than left to be discovered.

**Where reversibility actually pays, and it is the payoff the substrate uses:** computational integrity. **T4 grades whether a cell can replay the delta stream and re-derive the verdict**; the transform over that stream is a bijection, which is the property that makes the replay decidable. That is Constraint 6 (Bennett) as this substrate consumes it — the property that would let two cells that were never simultaneously online reach the same answer. Reversibility belongs in the integrity argument. It does not belong in a heat argument, and it is not put in one here.

## Cost — measured arithmetic under stated assumptions

**This section is arithmetic, not a verdict.** It is not the sealed object of this study, and it does not appear in the status line. The sealed object is the four-tier protocol.

10,000 sites over 10 years, **both sides paying for backhaul**. The service-tier names are one commercial operator's published plan names read mid-2026; **the operator is not named on this page, the tiers are carried as published plan names with no vendor attribution, and the prices are REPORTED** (VERIFIED as arithmetic on those reported prices).

| Architecture | Backhaul assumption | 10-year total |
|---|---|---|
| Orbital, one terminal **per site**, US Standard + MAX | 10,000 subscriptions | **$159.49M** |
| Orbital, one terminal **per site**, US Mini + Residential | 10,000 subscriptions | **$67.99M** |
| Orbital, one terminal **per site**, Kenya Mini + 50 GB | 10,000 subscriptions | **$12.53M** |
| Orbital, **1 terminal : 10 sites**, US Standard + MAX | 1,000 subscriptions | **$15.95M** |
| Orbital, **1 terminal : 100 sites**, US Standard + MAX | 100 subscriptions | **$1.59M** |
| Orbital, **1 terminal : 100 sites**, Kenya Mini + 50 GB | 100 subscriptions | **$0.125M** |
| **A.E.P-1**, 10,000 pods @ $25 + 100 gateways on US MAX uplinks | 100 subscriptions | **$1.83M** |
| **A.E.P-1**, 10,000 pods @ $30 + 100 gateways on US MAX uplinks | 100 subscriptions | **$1.88M** |

**The two rows a reader is invited to compare, published as their line items so they reconcile.** The orbital 1:100 US row is **$1,594,900 = CapEx $34,900 (100 terminals at $349) + OpEx $1,560,000**. The A.E.P-1 $25 row is **$1,825,000 = pods $250,000 + gateway hardware $15,000 + gateway uplink $1,560,000**. **The gateway hardware assumption is $150 per unit, and a $150 gateway is not a $349 Standard terminal** — that is why adding $0.25M of pods to the $1.59M orbital row gives $1.84M and not $1.83M. Naming the assumption is what makes the two rows comparable at all.

**Read the rows that share an assumption, and read the market column before the architecture column.** At like-for-like 1:100 aggregation on identical US uplinks the rows are what they are. In a low-cost market at the same aggregation the orbital row falls by an order of magnitude. **The market chosen moves the answer by two orders of magnitude before architecture is considered at all**, which is why a single headline ratio drawn from this table would be an artifact of an assumption rather than a property of a design.

**No cost advantage is claimed by this study.** What this study does claim, and will defend:

- **Sovereignty.** Under aggregation, the orbital path still routes every site's telemetry through one commercial operator's ground segment. Under this charter the pod mesh publishes an 8-tuple displacement and retains the rest locally. That is an ownership property of the specification, not a price, and T3 is the tier that would show a built pod honours it.
- **Deployability, held to the budget.** The budget is 3.240 J/hour at the binding rate, 6.661 J/hour at the regulatory ceiling and 83.1 mJ/hour at the quiet floor; the tracking-terminal class figure is 2.16 × 10⁵ J per hour of availability. Both are budgets. Whether a site without grid power can be instrumented on those numbers is what T1 measures.
- **No single-operator dependency.** 100 subscriptions to one company is 100 fewer than 10,000, and still one company — the property is granularity of exposure, and it is stated at that size.
- **Failure granularity.** The charter's exposure unit is the gateway cell; the orbital path's is the operator relationship. Neither blast radius has been exercised, and no tier on this page grades it.

## The pod as drafted — A.E.P-1

| Element | Drafted part / choice | Status |
|---|---|---|
| MCU | ESP32-C6 (RISC-V), Wi-Fi 6 / BLE 5 / 802.15.4, ESP-NOW for pod-to-pod | Capability claims SUPPORTED by the Espressif datasheet (REPORTED; revision not pinned) |
| Sub-GHz radio | SX1262 LoRa transceiver | Capability claims SUPPORTED by the Semtech datasheet (REPORTED; revision not pinned) |
| Power management | BQ25570 solar harvester / charger, **MPPT charge only** | Rated input pinned to **TI SLUSBH2G**; single-source, listed out of stock at checking |
| Panel | **~400 mW nominal** monocrystalline | Sized by arithmetic from the tested 450/500 mW rows to stay under 510 mW; the 400 mW arm is owed |
| Storage | LiFePO4 cell **or** 500 F supercapacitor bank; drives the TX burst | Cell not pinned — T1's charge-window integer is therefore not frozen |
| Enclosure | Louvered Stevenson screen, ASA or PETG | Drafted; ΔK criterion pins at build stage; mounting height not pinned |
| Sensing | T / RH / P only, integer milli-units at the HAL | No soil-moisture, precipitation, radiation, wind, acoustic or optical channel |
| Hardware licence | CERN-OHL | Drafted |
| Transport licence | Apache-2.0 | Drafted |
| vQbit state machine + UUM-8D quantiser | Proprietary, behind the HAL | Header published above |

### Bill of materials — all lines read August 2026 at the 1,000-unit break, distributor named per line

| Part | DigiKey | Mouser |
|---|---|---|
| ESP32-C6-WROOM-1-N4 | **$2.88** | — |
| SX1262IMLTRT | **$5.70** | **$4.87** |
| BQ25570RGRR | **$4.68** | **$4.82** |

**One quote per line would hide the spread, and the spread is on the largest line.** The SX1262 quotes differ by **$0.83**, which is **17.0% of the lower quote ($4.87) and 14.6% of the higher ($5.70)** — a ratio in a section whose subject is hidden spread has to state its denominator. Taking the cheaper quote on each line gives **$12.43** ($2.88 + $4.87 + $4.68); the dearer gives **$13.40** ($2.88 + $5.70 + $4.82).

**Still unpriced and unavoidable:** LiFePO4 cell ~$2–4; panel ~$1.50–4; T/RH/P sensor ~$1–3; PCB ~$1–2; RF matching, crystals, antenna and passives ~$1.50–3; ASA/PETG filament ~$1–3; plus assembly and test.

**The realistic built cost is $22–30 at 1k.** **$15 is a target naming a class, never a measured build cost**, and it is reachable only by changing the parts list. The cost table above is computed at $25 and $30, never at $15.

**The cleanest route to the target is worth naming, because it is a different deployment rather than a cheaper version of the same one.** The ESP32-C6 already carries 802.15.4 and Wi-Fi, so a pod that meshes over ESP-NOW or Thread and reaches the gateway through its neighbours **needs no SX1262 at all**, leaving MCU + PMIC at **$7.56** on the cheaper quotes ($2.88 + $4.68) and **$7.70** on the dearer ($2.88 + $4.82). What it costs is the long single hop: LoRa reaches a gateway kilometres away; a 2.4 GHz mesh needs neighbours. **Both topologies are admissible under this charter — dense-mesh and sparse-star — and this page does not choose between them.** Other routes: LLCC68 or third-party SX1262 modules at $2–4; a commodity charger in place of the BQ25570. Each changes what T1 and T3 grade.

**Every BOM line above is a distributor price at a stated quantity break with a date.** An undated, unqualified "$15" is the one number on this page a reader can falsify in ten minutes, which is why it is labelled a target everywhere it appears.

## What this charter is built to protect

**Local ownership of local measurement.** Zero extraction is a property of the wire format: what crosses is a displacement on a torus, so the global mesh would receive what it needs to compute and no stream that could be resold. **T3 is the tier that grades whether a built pod holds that line.** The hardware is CERN-OHL and the transport Apache-2.0, so ownership of the pods stays with the local entity by licence.

**Replayable verdicts.** T4 exists because two cells re-deriving the same verdict from the same deltas is the property that would make a distributed measurement checkable by a stranger — the same discipline [Study 11 — Ehrhart volume shear](Study-11-Ehrhart-Volume-Shear.md) carries in arithmetic and [Study 28](Study-28-Wet-Bulb-Threshold-Court.md) carries at a survivability line. Exact integers replay byte-identically; a float pipeline's last bit is a property of a machine.

**Instrumentation where the grid is not.** The budget is 3.240 J/hour at the binding rate and 83.1 mJ/hour at the quiet floor, against a small panel and a cell. Whether that closes on a built pod is T1's question, and it is the question that decides whether a site off the grid can be instrumented at all.

**An enumerable boundary instead of a trusted one.** A tool surface that enumerates to a ring buffer can be audited by anyone with a packet capture. That is a smaller claim than an unbreakable one and it is checkable, which an unchecked assurance is not.

**A sensing capability that is a published law, not a hardware refresh.** Because the mesh spine makes a pod a role in a domain, a new capability is a `dead_equation` → `new_law` pair and a `may_ingest` list rather than a field visit to every node. **No pod-class domain exists today**, and publishing one is the work.

## What this study does not judge

- **Orbital broadband as a technology.** For workloads that need megabits it delivers megabits, and the readings table says so. The comparison is scoped to this workload on this link budget.
- **Which architecture wins.** The cost table is arithmetic under stated assumptions. It renders no verdict, and the study claims no cost advantage.
- **Any built pod's performance.** No pod exists. Every hardware row is a drawing, and the four tiers are what would convert a drawing into a measurement.
- **The physical state behind a delta.** The R → Z⁸ ingest is many-to-one. The delta carries the lattice point, not the air.
- **Any application outcome.** The applications section states what would become measurable. No tier on this page grades land degradation, water saved, a crop protected, or an encounter avoided, and this page claims none of them.

## Honest limits

- **No pod has been built and no tier has been run.** This is a charter. Nothing on this page is a hardware measurement.
- **T1 cannot be run today.** Its cell charge ceiling pins when a cell is named by manufacturer and part number; its enclosure ΔK criterion pins at build stage, before the first soak, and not after. The harvester bound is resolved by specification, and the specification is a proposed panel rather than a purchased one.
- **T3 is not fully runnable.** Its subject allow-list and its ack-inbox subject are not frozen anywhere on this page, so two of its four arms cannot be scored against a string that does not exist. The inbound-frame and 42-byte-length arms are decidable from a capture today.
- **The scaling constants k_T, k_H, k_P are unfrozen.** N and N_τ are pinned at 65,536 by the int16 wire width, and the bound |change| < 32,768 follows; the three scalings do not follow from anything on this page.
- **The energy figures are budgets bounded on both ends and measured at neither.** 3.240 J/hour prices the binding cadence, 6.661 J/hour prices a regulatory ceiling the frozen cadence never reaches, 83.1 mJ/hour prices a silent hour. True consumption is a property of the environment. T1 is where all three become numbers.
- **Deep-sleep current is a chip figure, not a board figure.** 7 µA is the specification; commercial boards measure to 72 µA from board-level leakage, which lifts the binding hourly total to 4.008 J.
- **The 400 mW panel specification is arithmetic, not a printed program arm.** `panel-energy-margin.swift` tests 500 mW and `gate-checks-panel-and-flux.swift` tests 500 and 450 mW; every row either prints is over the 510 mW ceiling. The 400 mW rows on this page are scaled from those.
- **`pod-energy-budget.swift` truncates its µW intermediate**, computing the sleep power as 23 µW rather than 23.1 µW, so the sleep term it prints is a lower bound about 0.43% low. The figures published above are exact arithmetic on the printed inputs, not the program's output, and the program is the lower bound until its helper is fixed.
- **The airtime result is an encoding result as much as a geometry result, and the null row says so.** 3.49× on airtime and 3.57× on transmissions per hour, on this workload, this link budget, and the g1 sub-band, and both derived on this page rather than printed by the program. What the geometry contributes is fixed width and exact replay, not the ratio.
- **The $15 BOM does not close.** $12.43–13.40 of silicon at 1k before enclosure, panel, cell, PCB and sensor. **$22–30** is the defensible built cost.
- **The quantiser resolution is not checked against a named sensor's noise floor.** The check is one comparison and it is stated; the sensor part is not pinned, so it is owed rather than performed.
- **The PMIC is single-source and was listed out of stock at checking.**
- **The NVS ring bounds the tolerable outage.** 34.1 h at the frozen depth and the frozen 60 s cadence. An outage longer than that breaks the chain rather than degrading gracefully, and the gap marker is what keeps the break visible.
- **T2's float arm is chartered but unimplemented**, and its control arm — a probe build carrying one deliberate `float` parameter — has not been run.
- **The 60 s ingest period as frozen is one sample per minute, not a WMO one-minute average.** WMO-No. 8's own sampling rule asks for ≤20 s sampling for averages and ≤5 s for extremes on a 20 s-time-constant temperature sensor, so the specification under-samples extremes by about 12× against that rule, and daily Tmin and Tmax are extremes.
- **The pod's mounting height is not pinned**, and the frost literature makes height load-bearing.
- **No integer or rational form of FAO's wet-bulb sprinkler equations is pinned here**, so that lane is owed rather than carried, even though Study 28 already holds the psychrometric coefficients as exact rationals.
- **The applications section states what would become measurable and never an outcome.** Every figure in it is third-party and attributed inline with a VERIFIED or REPORTED tag; several load-bearing figures are REPORTED because the publisher was unreachable this pass, and each says so at its own point of use.
- **"No such thing was found in this pass" is not "no such thing exists."** Two negative results in the applications section — no reported predator detection from ambient T/RH/P, and no evaluated real-time predator early-warning system with a measured loss reduction — are search results from this pass and are published in exactly that form.
- **The life-cycle comparison is owed.** Manufacturing footprint, one LiFePO4 cell per node, and end-of-life for 10,000 outdoor units are quantified nowhere on this page.
- **Third-party figures are carried as REPORTED** — datasheets, distributor listings and published papers read, not archives re-derived by this program. What is tagged VERIFIED is what was re-derived this session: the shipped quotient map read from source with file and line, the unimodular arms, the mesh-spine counts from the pinned file, the airtimes and floored counts, the energy and panel arithmetic, and the cost rows on the reported prices.
- **The Espressif and Semtech datasheet revisions are not pinned** and are named as unpinned rather than guessed. The TI revision is pinned: SLUSBH2G.
- **The audited boundary is audited, not proven.** T3 grades a configuration on a session. It does not establish that no configuration could ever leak, and no proof-by-signature is claimed anywhere on this page.

## Open issues — carried on the face of the charter

These sit here rather than in a footnote, because several of them gate the tiers above.

1. **No pod exists and no tier has been run.** Every hardware row is a drawing. The four-tier protocol is what would convert it into a measurement.
2. **T3's frozen subject allow-list and ack-inbox subject are not pinned.** Until they are, two of T3's four arms are conditional and the tier is not fully runnable.
3. **k_T, k_H and k_P are not frozen.** N = N_τ = 65,536 and |change| < 32,768 follow from the int16 wire width; the three scaling constants do not, and x₄, x₅, x₆ are not reproducible without them.
4. **The per-axis wake threshold that gates a transmission is not frozen**, so the static-diurnal criterion is chartered and not yet decidable.
5. **The LiFePO4 cell is not pinned**, so T1's charge-window integer is not frozen. The boundary is per cell, not per chemistry — a representative cell specifies charge 0–55 °C and discharge −20 to +60 °C, two different windows, which is the whole content of the criterion.
6. **The T1 enclosure ΔK criterion is not pinned** to the enclosure geometry. It must be frozen at build stage, before the first soak, and not after.
7. **Deep-sleep current is a chip figure, not a board figure.** 7 µA specified; 72 µA measured on commercial boards. The pod's own PCB must be measured, and T1 is where that happens.
8. **A 400 mW nominal arm is owed in `gate-checks-panel-and-flux.swift`**, across both temperatures and all three coefficients. Until it exists the panel specification is arithmetic scaled from the tested rows.
9. **`pod-energy-budget.swift`'s µW intermediate truncates.** Compute in nanojoules or multiply before dividing, re-run, and the printed sleep terms match the exact arithmetic published here.
10. **`lora-time-on-air.swift` does not print the two operational ratios** it is credited with elsewhere. Either add 1004.544 : 287.744 and 125 : 35 as printed lines or leave them derived on the page, as they are here.
11. **The quantiser resolution has not been checked against a named sensor's noise floor.** The wire units are 10⁻³ °C, 10⁻³ %RH and 1 Pa; the sensor part is not pinned.
12. **The PMIC is single-source and was listed out of stock at checking** — a supply risk in an open-hardware BOM whose premise is that anyone can build it.
13. **The 60 s ingest period samples rather than averages.** An integer accumulator sampling at ≤5 s and publishing one 60 s aggregate per 42-byte frame would satisfy WMO-No. 8's extremes rule at the same frame rate and the same transmission count; it is not specified here.
14. **The pod's mounting height is not pinned.**
15. **No pod-class domain exists on the mesh spine.** None of the 48 published domains carries a temperature, humidity or pressure `may_ingest` field, so the pod's own three scalars have nowhere to ingest. Publishing that domain — its `dead_equation`, its `new_law`, its roles and their `may_ingest` lists — is the work.
16. **The predator lane has no domain and no field.** It needs a `new_law` deciding on ingested integer deltas and at least one role whose `may_ingest` carries a proximity field. Neither exists, and adding a detection modality re-scopes T2's ingest set, T3's frame length and the hourly budget.
17. **The $15 target requires a parts-list change**, and the two candidate topologies — LoRa sparse-star and 2.4 GHz dense-mesh — are different deployments. This page does not choose between them, and each changes what T1 and T3 grade.
18. **No cost advantage is claimed.** The cost table is arithmetic under stated assumptions, and the market chosen moves the answer by two orders of magnitude before architecture is considered.
19. **The life-cycle comparison is owed.** Manufacturing footprint, one LiFePO4 cell per node, and end-of-life for 10,000 outdoor units are quantified nowhere.
20. **T2's float arm is chartered but unimplemented**, and its control arm has not been run.

## Reproduce every number

Self-contained Swift programs, no imports, each printing the table it backs. **None of them declares a float type.** The Landauer paragraph above is prose arithmetic that decides nothing, and it is the page's only floating-point quantity.

They live under `evidence/study-29/` and keep that path — the directory predates the split and is not renamed, because a path that moves is a citation that breaks. The mesh-spine evidence lives under `evidence/study-30/`.

Build each with:

```
xcrun swiftc -O -swift-version 6 <file>.swift -o /tmp/out && /tmp/out
```

| File | Reproduces | Carries its own control arm |
|---|---|---|
| `evidence/study-29/unimodular-control-arms.swift` | det = 1 by fraction-free Bareiss; the 4,000-point run; the det = 2 and det = 0 arms; the reachability arm | **Yes** — and it is the arm that shows image count does *not* discriminate while reachability does |
| `evidence/study-29/lora-time-on-air.swift` | the four airtimes in exact integer microseconds, the **floored** counts, the 42 B frame, and the payload-only ratios. **It does not print the 3.49× and 3.57× operational ratios**, which are derived on this page from its printed airtimes and counts | the payload-only rows are the arm that shows what the frame does not deliver |
| `evidence/study-29/pod-energy-budget.swift` | the per-transmission and per-wake terms and the 125 tx/hr ceiling row. **Its µW intermediate truncates 23.1 µW to 23 µW, so its sleep term is a lower bound**; the hourly totals published above are exact arithmetic on its printed inputs | every datasheet input is printed so a reader substitutes their own |
| `evidence/study-29/cost-matrix.swift` | every row of the cost table at four markets and three aggregation ratios, including the pods / gateway-hardware / gateway-uplink line items | the per-site and 1:100 rows are each other's arm |
| `evidence/study-29/panel-energy-margin.swift` | supply against demand at 500 mW nominal, all conditions | the deep-winter row is the arm against the overcast-day row |
| `evidence/study-29/gate-checks-panel-and-flux.swift` | the cold-day panel overshoot at 500 and 450 mW across both temperature coefficients; the x₇ ring-delta defect at N = 65,536 and its fix | **Yes** — it prints the naive 65,525 beside the true 11 |
| `evidence/study-30/mesh-domain-spine.json` | the mesh spine, pinned: 24,996 bytes, sha256 `b46bb35b2d978b94206f9888ed0a741ccc26f8407501aeb2268ae0a99490261c`. 48 domains, 88 role entries, 34 role names, 122 distinct `may_ingest` fields, `no_float` true on 48 of 48 | the pinned bytes are the arm against the live endpoint, which is rewritten as domains are published |
| `evidence/study-29/reentry-alumina-ledger.swift`, `evidence/study-29/z8-vs-e8-lattice.swift` | belong to [Study 29](Study-29-Affine-Earth-Sovereign-Substrate.md); noted here only as cross-links | — |

**The energy, panel and cost programs are budgets, not measurements, and print their inputs for that reason.** The unimodular and airtime programs are integer-only in every law path and carry no float operation, which is the condition for byte-identical output across hosts; cross-host byte-identity is not measured here, because the programs were run on one host.

## Cross-links

- [Study 29 — the reentry-mass ledger court](Study-29-Affine-Earth-Sovereign-Substrate.md) — the sibling lane, split from this page on 2026-08-31: Ferreira against Maloney, the exact rational counting ledger, the units artifact. Pure epistemological shear on a contested continuous model.
- [Study 28 — Wet-bulb threshold court](Study-28-Wet-Bulb-Threshold-Court.md) — the Section-zero precedent this charter instantiates for an artifact: per-criterion failing observations, control arms in both directions, losses published as losses. It also holds the exact-rational psychrometric coefficients this page's farming lane names as owed.
- [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm.md) — why the HAL takes integers, stated as program doctrine.
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md) — the precedent this page inherits: a gate frozen at charter stage before any byte is scored, plus a "Claim posture" section under 21 CFR 801.4 in which the page's own wording is treated as the boundary of what it claims.
- [Study 11 — Ehrhart volume shear](Study-11-Ehrhart-Volume-Shear.md) — the arithmetic cousin: exact lattice counting against float evaluation of the same quantity.
- [Study 09 — Global convective bond](Study-09-Global-Convective-Bond.md) — the terrestrial-sensing lane this charter supplies instruments for; frozen integer thresholds, REFUSED ≠ clear sky.
- [Shear Studies Index](Shear-Studies-Index.md) — the program board and the four-piece recipe every charter must instantiate.

**Status: OPEN — hardware and protocol validation charter; no pod built, no tier run. OPEN in the index's own sense: gate integers frozen, no corpus ingested, no pod built, no tier scored. Four tiers frozen 2026-08-31, each with its failing observation and its control arm; T2 and T4 runnable against a built pod, T3 runnable on its inbound-frame and 42-byte-length arms with its subject allow-list and ack inbox unfrozen, T1 not runnable — its cell charge ceiling pins when a cell is named and its enclosure ΔK pins at build stage. The binding operating point is 60 tx/hr at the frozen 60,000,000,000 ns ingest period: 3.240 J/hour, 54.0 mJ per report, 66,656 : 1 against a 60 W terminal-class hour of availability; the 125 tx/hr regulatory ceiling is 6.661 J/hour and is never reached; a genuinely silent hour is 83.1 mJ. The PMIC input is pinned to 510 mW (TI SLUSBH2G, revised up from 400 mW) and the panel is specified at ~400 mW nominal by arithmetic scaled from the tested 450/500 mW rows — 481 mW worst case at −20 °C, at ~43× the daily regulatory ceiling and ~88× the binding rate. Shipped and measured: `UUM8DFactCoordinate.wrapped()` at line 261 is the live spatial quotient map, emitting an explicit winding for sx/sy/sz only, with every other record component unwrapped, so the eight-axis T⁸ map is the design and not the shipped instance. A det = 1 unimodular 8×8 maps 4,000 distinct Z⁸ points to 4,000 distinct integral images, and the discriminating control arm is reachability, not image count. The mesh spine is pinned at 24,996 bytes, sha256 b46bb35b…0261c: 48 domains, 88 role entries, 122 distinct may_ingest fields, no_float true on 48 of 48 — and no domain carries a temperature, humidity or pressure field, so the pod-class domain does not exist yet. The wire frame is 42 bytes, N = 65,536 is fixed by the int16 axis width, and the duty-cycle counts floor. The transform is lossless; the R → Z⁸ ingest is not. Applications state what would become measurable and no outcome; no tier grades one. Not a shear study: one of the recipe's four pieces, and the three it lacks are named. No cost advantage is claimed.**
