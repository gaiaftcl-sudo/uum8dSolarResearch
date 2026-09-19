# Study 49 — The phase code never needs π

*A phase-only spatial light modulator is a panel of pixels, each of which can hold one of a fixed
number of phase levels — 256 of them, in the common eight-bit convention, spread over one full turn.
The device cannot be driven between levels, so a synthesiser must choose one of the levels the device
has. This study takes the level below — floor — on both sides of every comparison, and reports what
round-to-nearest gives instead, because that choice turns out to matter more than the precision does.*

*So a hologram is not a function into the real numbers. It is one integer per pixel: a command word,
2,073,600 pixels long on a common panel, **16,588,800 bits of command word** in total.*

*The usual way to compute it carries radians: work out the phase as a real number, wrap it modulo 2π,
scale by 256/2π, round. That route carries π — a number the device never uses — through every pixel.
The other way computes the integer directly, because for two masks with a closed form — a blazed
grating and a Fresnel lens — the code is a ratio of integers and **the π cancels**. A mask with no
closed form is outside what this measures.*

*Measured here: on a blazed grating the radians route in double precision **hands the device 47
different codes in 1,920 pixels**, and all 47 sit **exactly** on a level boundary. On a full-panel
lens it is **7 per million pixels handed a different command word in float64, 951 per million in
float32**. And **4 of 1,920 pixels take a different code depending on which end the sum started** —
the same mask, the other way round, with π removed and still 4, which is how we learned that π is not
what makes an answer order-dependent.*

**Status: FINDINGS SEALED 2026-09-17** — one program, thirteen control arms, two of which must NOT
hold, seal `ec768ab33eb7d8a771afe773d267d03a8fc28dd99386d6345921a622052a071f`, marker
`SLM_PHASE_CODE__THE_CODE_IS_A_RATIO_OF_INTEGERS`. Compiled to `wasm32-wasip1` and run under
wasmtime, it prints the native transcript byte for byte — measured. **It now opens in the Studio
too**: at pin `017a5971fb11…` the sandbox row reads `RUNS`, parity `IDENTICAL`, 115 transcript lines,
digest `79f9e4c8133d9345…` — the browser prints the same bytes as the native run.

---

## Why the π cancels

Two masks do most of the work in holography, and both have a closed form.

A **blazed grating** of `m` periods across `N` pixels has ideal phase `φ(n) = 2π·m·n/N`. The device
wants a level, not a phase, and the level is `φ·L/2π`. Put those together and the 2π disappears:

```
code(n) = floor( L · m · n / N )  mod L
```

A **Fresnel lens** of focal length `f` at wavelength `λ` on pixel pitch `p` has **paraxial** phase
`φ(r) = π·p²·r²/(λ·f)`, with `r²` an integer count of pixels from the centre. The level is again
`φ·L/2π`:

```
code(r²) = floor( L · p² · r² / (2·λ·f) )  mod L
```

Both are ratios of integers. π enters only if you insist on answering in radians a question the
device asked in codes. The exact arm in this study never evaluates π, never wraps a real number and
never rounds one — and a control arm **derives** the cancellation rather than asserting it: the phase
is carried with its power of π kept as a symbol, the division by 2π is performed on that symbol, and
the arm checks both that the power reached zero and that the rational left over is the code. A paired
arm drops the 2 from the 2π and **must not** reproduce the code. That pairing is why the claim is
graded DERIVED below; the first version of this arm compared the formula against a copy of its own
body, and a dropped factor of two mis-coded 2,064,821 pixels while the arm still held.

### The quadratic is an idealisation, and this study measures what it costs

The spherical wavefront phase is `(2π/λ)(√(r²p² + f²) − f)`, which carries a square root and is *not*
a ratio of integers. At the corner of this panel the paraxial phase and the spherical wavefront differ
by **30.503 levels** — measured exactly, with an integer square root, no float anywhere in it. That is
about thirty times larger than every one-level difference reported below.

Choosing the quadratic is a modelling decision this study does not grade. It is named here, and marked
**ABSENT**, so that "the code is a ratio of integers" is never read as a claim about the wavefront. It
is a claim about the quadratic mask, which is what optical benches actually write.

## What we checked, and on what

> Compute the same two masks twice — once as integers, once the way a continuous-space synthesiser
> does — and count the pixels where the device would be handed a different command word.

The panel is a public geometry: 1,920 × 1,080 pixels on a 4.5 µm pitch, eight-bit phase, at the
iodine-stabilised helium-neon wavelength of 632.8 nm. The focal length, 100.0 mm, is our choice and
is stated as ours. Every float arm uses only `+ − × ÷` and rounding, all of which IEEE-754 specifies
exactly, so the arms print the same bytes on this machine and in a browser. No `sin`, `cos`, `fmod`
or `pow` appears anywhere in the file: those differ between maths libraries, and a transcript that
depended on them would not reproduce.

### The control arms, before any figure

Twelve arms, **two of which must NOT hold**, and the program refuses to grade a figure if any of them
comes out the wrong way:

- two independent integer routes to the code agree on every pixel — a closed form against an
  accumulator that adds `L·m` and reduces by `N`;
- a single injected level offset **is** detected, in the array the comparison actually reads;
- **the un-injected array reports no difference** (**must not** report one);
- **float64 agrees on every pixel a quarter level clear of a boundary** — the control that shows the
  float route is not simply wrong everywhere. It gates on the grating's float64 arm only; the lens
  arms and both float32 arms are covered by the π-free arm below, not by this one;
- **dividing the phase by 2π drives the power of π to zero** — the cancellation, derived on a symbol
  rather than evaluated;
- the π-free rational that remains **is** the lens code, and the same derivation gives the grating code;
- **dropping the 2 from the 2π still reproduces the code** (**must not** — this is the arm that would
  have caught the defect the first version of this study shipped with);
- the exact codes do not change with the order in which pixels are visited;
- the integer square root is exact at, just below and just above a perfect square — it is what
  measures the paraxial departure, so it is checked rather than trusted;
- **a float64 route with π cancelled out of it agrees with the exact codes on every pixel of both
  masks** — all 1,920 grating pixels and all 2,073,600 lens pixels;
- **a float32 route with π cancelled out agrees on every grating pixel** too.

Those last arms turn this study's headline from an attribution into a measurement. The page says π is
what makes the float route disagree; an arm that removes π from a float route and finds zero
disagreements is what entitles it to say so.

**And running them found the headline was too broad.** There is no arm for the π-free float32 route on
the *lens*, because that route does **not** agree — and an arm written around a result it was allowed
to choose proves nothing. It is reported as a measurement instead, below.

There is no arm for "a geometry with no rounding to do", and the reason is itself a finding. Of the
**128** grating pixels where `L·m·n/N` is a whole number, the radians route lands below it and floors
down on **47** — not on all of them, which is why it is reported as a count and not as a rule.

## The numbers

| mask | route | different codes | largest gap |
|---|---|---|---|
| grating, 7 periods over 1,920 px | radians, float64 | **47** of 1,920 | 1 level |
| grating, 7 periods over 1,920 px | radians, float32 | 45 of 1,920 | 1 level |
| lens, full panel | radians, float64 | **16** of 2,073,600 | 1 level |
| lens, full panel | radians, float32 | **1,974** of 2,073,600 | 1 level |
| either mask | integers | 0 | — |

On the grating, float64 hands the device 47 different codes in 1,920 pixels, and float32 hands it 45.

On the lens, float64 hands the device 16 different codes in 2,073,600 pixels, and float32 hands it 1,974.

The stronger statement is also true, and it is the one to read: 47 of the 47 sit EXACTLY on a
boundary — the level changes at that very pixel, remainder zero, not merely within a quarter level of
an edge.

**float32 differs on fewer grating pixels than float64, and they are mostly different pixels.** The
table above would otherwise invite the inference that less precision means more differing codes, and
then contradict it. Measured: 21 pixels common to both arms, 26 float64 only, 24 float32 only. On this
mask the differences are a floor-at-an-exact-integer effect, so the *direction* of the float error
decides the count rather than its size. The lens rows run the other way, which is what a precision
effect looks like.

### Both arms floor, and here is what the other rule gives

| mask | route | floor, both sides | round-to-nearest, both sides |
|---|---|---|---|
| grating | radians, float64 | **47** of 1,920 | **0** |
| grating | radians, float32 | 45 of 1,920 | **0** |
| lens | radians, float64 | **16** of 2,073,600 | **0** |
| lens | radians, float32 | **1,974** of 2,073,600 | **1,954** |

That is the honest shape of this result and the page states it rather than letting a reader infer it:
three of the four headline counts are a property of the *rounding rule* as much as of the precision,
and only the float32 lens figure survives the change. Floor-against-floor is a like-for-like
comparison and it is the one this study grades; it is not the only defensible one.

### How much of this is π, and how much is just the precision

Cancel π out of the float route and run it again. That is the measurement the first version of this
study never made, and it narrows the claim:

| mask | route | with π | π cancelled out |
|---|---|---|---|
| grating | float64 | 47 of 1,920 | **0** |
| grating | float32 | 45 of 1,920 | **0** |
| lens | float64 | 16 of 2,073,600 | **0** |
| lens | float32 | 1,974 of 2,073,600 | **970** |

On the grating, and on the lens in double precision, every disagreement is π: remove it and the float
route lands on the exact code every time. **On the lens in single precision it is not** — float64
drops from 16 to 0, while float32
drops only from 1,974 to 970.
About half the single-precision disagreement survives with no π anywhere in the computation, and that
half is the precision alone.

So π is a *sufficient* cause everywhere this study looks, and a *necessary* one only on the grating and
in double precision. The earlier version of this page attributed all four counts to π. Three of them
are; the fourth is half of one.

**A gap of one level is the pixel being handed a different command word than the one the design
specifies.** What that does to an optical field is not measured here, and this page does not claim it.

## The same mask, the other way round

A raster pipeline usually carries a running phase and adds a step per pixel. Do that from the left,
then do it from the right, and compare the command words:

> 4 of 1,920 pixels take a different code depending on which end the sum started.

**How the far end is reached matters more than the direction does, and this page reports both rather
than the larger one.** Reach the far end with a single multiplication instead of by summing the step
1,919 times and the figure is **84** — so roughly eighty of that larger number come from the seed, not
from the direction of summation. The 4 is what the question in this section's title actually asks. An
earlier version of this page published the 84 as though it were the direction; it was not.

And against the exact codes — the comparison the thesis is about, which the first version never
printed — the forward recurrence differs on **44** pixels and the reversed on **48** of 1,920.

### π is not what makes it order-dependent

Run the same recurrence with π cancelled out of it — accumulate the *level* rather than the radian, no
π anywhere — and it still differs on **4 of 1,920** pixels between the two directions. The number does
not move.

So there are two separate costs, and this study had been attributing both to π until the arm was run:

- **π** is why the closed-form float route hands the device a different code at all. The π-free float
  route agrees with the exact codes on every pixel of both masks — that is a control arm, not a claim.
- **carrying a real number per pixel**, with or without π, is why the answer can depend on the order
  of the sum.

The integer route pays neither. There is no π to carry and no sum to order: each code is computed from
its own index. The exact codes are identical either way.

This is the same property the programme keeps finding at every scale it looks: an answer that depends
on the order of the arithmetic is an answer that two machines can disagree about while both are
working correctly. [Study 48](Study-48-The-Atom-Already-Has-An-Address.md) finds it in a lithography
controller carrying a length; [Study 41](Study-41-What-The-Ordering-Cost.md) found it in distributed
consensus. Same sentence, three scales.

## What this does not say

- **It does not say any modulator, product or algorithm is wrong.** No device, vendor or software is
  named or graded. The measurement is of arithmetic.
- **It does not claim an optical experiment.** Nothing here was illuminated, imaged or diffracted.
- Diffraction efficiency, speckle, crosstalk, phase flicker and the physics of the liquid crystal are
  **ABSENT**: a differing code is a differing command word, not a measured field.
- **The paraxial approximation is ABSENT too** — and measured, at 30.503 levels at the panel corner,
  rather than left for the reader to assume is small. The spherical code is not a ratio of integers.
- **No voltage is computed anywhere.** The code-to-voltage map is device- and calibration-specific and
  this study never reads one.
- **It does not say float64 is unusable.** Measured above, most of its codes agree.
- A presented configuration is verified; an unknown one is not searched.

## Evidence, graded

| claim | grade |
|---|---|
| a phase-only SLM state is one integer code per pixel, 256 levels over 2π | **REPORTED** — public phase-only SLM documentation |
| 1,920 × 1,080 at 4.5 µm pitch; λ = 632.8 nm | **REPORTED** — public datasheets; BIPM mise en pratique |
| f = 100.0 mm | **CHOSEN**, ours, stated so it can be changed |
| the grating and lens codes are ratios of integers, π cancels | **DERIVED** on a symbolic power of π, with a paired arm that must NOT hold when the 2 is dropped from the 2π |
| the lens phase used here is the **paraxial** quadratic, not the spherical wavefront | **REPORTED** — and its departure is MEASURED below |
| paraxial and spherical differ by 30.503 levels at the panel corner | **MEASURED** by exact integer square root |
| grating: float64 47 of 1,920, float32 45 of 1,920 different codes, floor on both sides | **MEASURED** by this run |
| lens: float64 16, float32 1,974 of 2,073,600 different codes, floor on both sides | **MEASURED** |
| under round-to-nearest: grating 0 and 0, lens 0 and 1,954 | **MEASURED** — three of the four headline counts do not survive the other rounding rule |
| all 47 float64 grating disagreements sit exactly on a level boundary | **MEASURED** |
| of the 128 whole-number grating pixels, the radians route floors down on 47 | **MEASURED** |
| grating disagreement sets overlap on 21 pixels; 26 float64 only, 24 float32 only | **MEASURED** |
| 4 of 1,920 pixels change code with the direction of the sum; 84 when the far end is reached by one multiplication | **MEASURED**, both reported |
| the forward recurrence differs from exact on 44 pixels, the reversed on 48 | **MEASURED** |
| a float64 route with π cancelled out agrees with the exact codes on every pixel of both masks | **MEASURED** — the control arm that makes the π attribution a measurement |
| a float32 route with π cancelled out agrees on every grating pixel | **MEASURED** — control arm |
| the same π-free float32 route still differs on 970 of 2,073,600 lens pixels | **MEASURED** — so π is not the whole cause there, and the page says so |
| π removed from the recurrence leaves the order dependence at 4 | **MEASURED** — order dependence is float accumulation, not π |
| any statement about an optical field, efficiency or image quality | **ABSENT** |

## Reproduce

```
swiftc -O -swift-version 5 reproduce/slm-phase-code-exact-vs-float.swift -o slm49 && ./slm49
```

It takes no argument, reads no file and prints its reference figures on every exit path. It compiles
to `wasm32-wasip1`, where it prints the same bytes under wasmtime — measured. It also opens in the
Studio at pin `017a5971fb11…` — 19,038,387 bytes on the wire, parity `IDENTICAL` against the native run — so
this command line and the ▶ badge are the same measurement.

Seal `ec768ab33eb7d8a771afe773d267d03a8fc28dd99386d6345921a622052a071f` ·
marker `SLM_PHASE_CODE__THE_CODE_IS_A_RATIO_OF_INTEGERS`.

## Related

- [Study 48 — the atom already has an address](Study-48-The-Atom-Already-Has-An-Address.md) — the same law four orders of magnitude in, on a silicon surface
- [Study 41 — what the ordering cost](Study-41-What-The-Ordering-Cost.md) — an answer that depends on the order of the arithmetic, in distributed consensus
- [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm.md) — the method in one page
