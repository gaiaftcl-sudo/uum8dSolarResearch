# Study 48 — The atom already has an address

*To build a circuit one atom at a time, somebody has to say which atom. On a hydrogen-passivated
silicon surface the answer is not a position in a plane. It is an address: which row of dimers, which
dimer along that row, which of the dimer's two atoms. There is nothing between those addresses,
because there is no atom there.*

*So there are two ways to run the machine that writes. It can carry the tip as a **length** — a real
number of metres, added up step by step, divided by a pitch and rounded back to an address when it is
time to pulse. Or it can carry the tip as a **count** — the address itself, an integer, with the
lattice as its own ruler.*

*Both agree on the first step. This study measures where they stop agreeing, in atoms.*

*Carrying the length in single precision, **the first hydrogen atom is mis-addressed at step 8,783** —
3,372 nm into the write — and over a path of 4,194,304 steps that route mis-addresses 4,183,204
sites. Carrying the count, the number is zero, and it is zero by construction rather than by luck.*

**Status: FINDINGS SEALED 2026-09-17** — one program, seven control arms in both directions, seal
`4b299340a10e04822aac19294abdbcdb1f05b6387e0ff63e0635c37cf3e5b881`, marker
`HDL_SITE_ADDRESS__THE_LATTICE_IS_ITS_OWN_RULER`. Compiled to `wasm32-wasip1` and run under
wasmtime, it prints the native transcript byte for byte — measured. **It now opens in the Studio
too**: at pin `017a5971fb11…` the sandbox row reads `RUNS`, parity `IDENTICAL`, 69 transcript lines,
digest `bbe5077932fbf3da…` — the browser prints the same bytes as the native run.

---

## What this domain is, and why it is not a niche

Hydrogen depassivation lithography writes at the scale of one atom. A silicon (100) surface is covered
with a single layer of hydrogen; a scanning tunnelling microscope tip pulls individual hydrogen atoms
off it; where the hydrogen is gone, chemistry can happen and nowhere else. The published practice
writes lines **one dimer row** wide — **0.768 nm** — with atomically sharp edges.

That is the whole appeal: the pattern is not *approximately* where you asked. It is exactly on the
atoms you named, or it is wrong.

The surface itself is a rectangular grid. Silicon's cubic lattice parameter is
**a₀ = 5.431020511 Å**; the 2×1 reconstruction puts dimers **3.840 Å** apart along a row and
**7.680 Å** between rows. Those two numbers are `a₀/√2` and `a₀·√2` — irrational in metres, exact in
the lattice. A patch of 1,024 rows by 1,024 dimers holds **2,097,152 writable sites**, and a write is
a finite subset of them.

### The one distance that is not a lattice step, and what we do with it

Two of a site's three coordinates are lattice steps. The third is not, and saying so precisely is what
keeps the rest of this page honest.

On Si(100)-2×1 **the dimer bond runs across the row, not along it** — the two silicon atoms of a dimer
are bonded perpendicular to the direction the dimer row runs. Their separation is REPORTED in the
surface-science literature as roughly **2.2–2.4 Å**, depending on buckling and on the method that
measured it. That is a surface relaxation parameter. It is not an integer multiple of the 3.840 Å
dimer pitch, of the 7.680 Å row pitch, or of any other pitch on this surface.

So `b` — which of the dimer's two atoms — is carried here as a **label**, and it is given **no offset
in the lattice metric**. The intra-dimer displacement is deliberately **ABSENT** from every integer
this study compares, rather than approximated inside one. A control arm proves the arithmetic is
`b`-free instead of taking it on trust.

## The thing worth noticing before any number

The pitch is irrational *in metres*. It is not irrational in dimers.

A controller that carries metres must represent `a₀/√2` in binary, add it a few million times, divide
by it again and round. Every one of those operations is a decision about a number the surface never
uses. A controller that carries the address does none of them: the next site along a row is the next
integer, and
every dimer-centre separation is the integer Δn² + 4Δm², in units of one dimer pitch squared, compared as an integer and never square-rooted.
An address is also a single integer word: row, then dimer along the row, then which atom.

**That is the whole method of this programme, at the smallest scale we have yet found a machine
commanded at.** Bind the
physical domain to the discrete set it already is, and the arithmetic that used to need an error
budget stops existing. [Study 49](Study-49-The-Phase-Code-Never-Needs-Pi.md) does the same thing four
orders of magnitude larger — a 4.5 µm pixel pitch against this 3.840 Å dimer pitch — on a pixel array,
and the law is the same sentence. That pair is one rung of the board, not its extent: the smallest
length on the board is smaller still and is not an address at all —
[Study 27](Study-27-Exact-Nuclear-Scattering.md) reads an ¹¹Li rms matter radius of **3.27 ± 0.24 fm**,
five orders below this dimer pitch — and upward it runs to the L1 point 1.5 million km sunward of
Earth that [Study 05](Study-05-Forbush-Decreases.md) clocks its forcing from, some twenty-four orders
in all.

## What we checked, and on what

> Take one commanded path — 4,194,304 single-dimer steps along one dimer row — and carry it four
> ways. Ask each, at every step, which site it is on. Count the steps where the answer is not the
> site the command reached.

The four arms:

| arm | what it carries | what it does each step |
|---|---|---|
| **EXACT** | the address, as integers | adds 1 to the dimer index |
| **FLOAT32-ACC** | a length in metres, single precision | adds the pitch, divides by the pitch, rounds |
| **FLOAT64-ACC** | a length in metres, double precision | the same |
| **FLOAT32-IDX** | a length, single precision, **not accumulated** | multiplies the step index by the pitch, divides, rounds |

The fourth arm is the control. If the instrument reported mis-addressing for it as well, this study
would be measuring "floating point" in general rather than the accumulation of a length, and the
claim would be worth nothing.

### The control arms, before any figure

The program runs seven arms and refuses to print a graded figure if any of them does not hold. They
are in both directions — six that must hold, and one that must not:

- every site round-trips through its packed address word — row, dimer, atom, all three fields;
- squared separations do not change when the origin moves;
- a single injected mis-step **is** detected by the same comparison that reports the arms;
- the un-injected exact path reports no mis-addressed site (**must not** report one);
- two dimer-centre separations one unit apart — 4 and 5 in the integers — are ordered without a
  square root, both of them on `b = 0`;
- **the integer bracket is `b`-free**: changing only the atom label leaves every squared separation
  unchanged, which is the arm that holds the intra-dimer bond out of the geometry;
- **float32 recomputed from the index mis-addresses nothing over the graded path itself** — the
  control runs the full 4,194,304 steps, not a shorter probe.

That last arm is written that way because of what happens just past it, and the program prints that
too:

> Doubled to 8,388,608 steps,
> float32 recomputed from the index first mis-addresses at step 5,086,264 and gets 289,560 sites wrong.

The control is clean over the path this study grades and not beyond it — which is precisely the
per-path, per-scale analysis the exact arm never has to do, at any scale, ever.

## The number

**float32 accumulating mis-addresses 4,183,204 of 4,194,304 sites; float64 accumulating mis-addresses 0; float32 recomputed from the index mis-addresses 0**, and
**the exact arm mis-addresses 0 sites in 4,194,304 steps**, which it cannot fail to do, because the
address is the count.

The first one matters most:

> float32, accumulating, mis-addresses its first hydrogen site at step 8,783 — 3,372,672 pm of
> commanded travel at the reported pitch — 3,372 nm.

From that step onward the machine is writing at an address nobody asked for, and nothing in the
arithmetic raises a hand. The write does not fail. It succeeds, somewhere else.

## Where each precision stops moving at all

There is a second, harder failure underneath the first, and it is a theorem of IEEE-754 rather than a
property of this loop. Once the carried length is large enough that one pitch falls below the spacing
between representable numbers, adding a pitch does nothing whatsoever:

- **float32: one pitch added to 7.81 mm of carried travel changes nothing** — the step is lost;
- float64: the same at about 4.19 × 10⁶ m of carried travel.

Those are the LEAST such travels, bisected out of the IEEE-754 bit pattern rather than doubled up to.
The difference matters more than it looks: doubling until the step is lost stops at 12.9 mm and
6.92 × 10⁶ m — the grid point above each threshold, nearly twice the real answer, and it would have
been published here as though it had been measured. The program prints both, and says which is which.

Double precision therefore has enormous headroom, and this study says so plainly: at this scale it
mis-addresses nothing. The point is not that float64 breaks. The point is that to know it does not
break you must do this analysis, per path, per scale, per precision — and the exact arm needs none of
it, at any scale, ever.

## What this does not say

- **It does not say any instrument, controller or product is wrong.** No microscope, piezo drive,
  amplifier or vendor is named or graded here. The measurement is of arithmetic.
- **It does not claim a lithography experiment.** No hydrogen was removed. Nothing here touched a
  surface; the program computes.
- **It does not say double precision fails at this scale.** Measured above, it does not.
- Thermal drift, tip condition, piezo creep, desorption yield and the chemistry of the surface are
  **ABSENT** from this study. They are real and they are not this.
- A presented configuration is verified; an unknown one is not searched.

## Evidence, graded

| claim | grade |
|---|---|
| the write target on Si(100)-2×1:H is a finite integer address set | **DERIVED** from the published surface geometry |
| a₀ = 5.431020511 Å | **REPORTED** — CODATA/NIST |
| dimer pitch 3.840 Å = a₀/√2; row pitch 7.680 Å = a₀·√2 | **REPORTED**, and both are a₀ restated — they carry a₀'s authority |
| the practice of writing a line **one dimer row** wide | **REPORTED** — US 10,983,142; arXiv:2412.05729 |
| the 0.768 nm width of that line | **DERIVED** — it is the row pitch restated, not an independent measurement |
| the dimer bond runs perpendicular to the dimer row, Si–Si ≈ 2.2–2.4 Å | **REPORTED** — surface-science literature, range as reported; a relaxation parameter, not a lattice step |
| that bond length is **ABSENT** from every integer this study compares | **BY CONSTRUCTION**, and proved by the `b`-free control arm |
| dimer centres separate as `Δn² + 4Δm²` in units of (dimer pitch)² | **DERIVED** from the two REPORTED pitches alone — it uses no intra-dimer distance |
| float32 accumulation mis-addresses its first site at step 8,783 | **MEASURED** by this run |
| float32 accumulation mis-addresses 4,183,204 of 4,194,304 sites | **MEASURED** |
| float64 accumulation mis-addresses none at this scale | **MEASURED** |
| float32 recomputed from the index mis-addresses none over the graded path | **MEASURED** — this is the control arm |
| doubled to 8,388,608 steps, float32-from-index first mis-addresses at step 5,086,264, 289,560 wrong | **MEASURED** — the control arm's own ceiling, stated |
| the exact arm mis-addresses none | **MEASURED**, and true by construction |
| one pitch added to 7.81 mm of float32 travel changes nothing | **MEASURED** — IEEE-754, the threshold bisected, not a doubling grid point |
| any statement about a real tip, a real drive or a real write | **ABSENT** |

## Reproduce

```
swiftc -O -swift-version 5 reproduce/hdl-site-address-exact-vs-float.swift -o hdl48 && ./hdl48
```

It takes no argument, reads no file and prints its reference figures on every exit path, including
the refusal path. It also compiles to `wasm32-wasip1`, where it prints the same bytes under wasmtime —
measured. It also opens in the Studio at pin `017a5971fb11…` — 19,036,777 bytes on the wire, parity
`IDENTICAL` against the native run — so this command line and the ▶ badge are the same measurement.

Seal `4b299340a10e04822aac19294abdbcdb1f05b6387e0ff63e0635c37cf3e5b881` ·
marker `HDL_SITE_ADDRESS__THE_LATTICE_IS_ITS_OWN_RULER`.

## Related

- [Study 49 — the phase code never needs π](Study-49-The-Phase-Code-Never-Needs-Pi.md) — the same law four orders of magnitude out, on a pixel array
- [Study 41 — what the ordering cost](Study-41-What-The-Ordering-Cost.md) — an answer that depends on the order of the arithmetic, in distributed consensus
- [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm.md) — the method in one page
