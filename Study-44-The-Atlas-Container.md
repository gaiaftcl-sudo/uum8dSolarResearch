# Study 44 — Nine billion answers, four billion ways to say them

*On 8 September 2026 Google DeepMind released AlphaGenome Atlas: a precomputed prediction for
every possible single-letter change in the human genome, about **nine billion** of them, one
petabyte, free for non-commercial research. This study measures **the container those numbers
ship in**. It grades no model, reads no prediction, and makes no biological claim. It is
arithmetic about bit patterns, and every figure in it is an integer.*

**Status: RESULTS — 2026-09-09.** Marker `ATLAS_CONTAINER_CANNOT_DISTINGUISH_ITS_OWN_ROWS`,
seal `642d84b418825906d7bc2ec2933f2c8c50b61f3f74f11445d7c89d44ed62e631`, 7 instrument arms
in both directions. **No account, no API key, and no terms accepted** — the study needs two
public artifacts and neither is behind a sign-in.

---

## The sentence this turns on

AlphaGenome's own service definition is published under Apache-2.0 in
[google-deepmind/alphagenome](https://github.com/google-deepmind/alphagenome). In
`atlas_service.proto`, field 4 of `message DenseVariantScore`, there is a comment:

```
  // N-d array of scores, in row-major order. Values are stored as single
  // precision floats.
  bytes scores = 4;
```

**Single precision.** That is not our characterisation of their work — it is their description
of their own wire format, in a file they published, shipped verbatim in this repository at
`corpus/alphagenome-atlas/atlas_service.proto`, sha256
`037e8ca50171582db7bf63780e87cb37d8dfeb2c078573412bdd71c0d69f1ed9`. The program below does not
quote that sentence from our memory: it verifies the file's digest and then **greps the sentence
out of the file**, and refuses if either check fails.

## The arithmetic

A single-precision float is 32 bits. That is 4,294,967,296 bit patterns in total, of which
16,777,214 are NaN and carry no number at all. So the widest possible reading of how many
distinct values the container can express is:

```
  float32 patterns, all            4,294,967,296
  of which carry no number (NaN)   16,777,214
  usable, widest possible reading  4,278,190,082
```

That figure is deliberately generous to the container: it still counts both infinities, and it
counts `+0` and `−0` as two values when they are one. **Every collision figure below is
therefore a floor**, and the true numbers are larger.

Against it, the number of things being stored:

```
  announced single-nucleotide variants   9,000,000,000   REPORTED, their announcement
  re-derived from GRCh38 in this repo    9,299,252,154   3,099,750,718 bases x 3
```

The second figure is not theirs and not taken on trust. `corpus/crispr-clinical/RUN-full-assembly-n32.txt`
— shipped and digest-pinned here for a different study — records GRCh38 primary assembly as
**3,099,750,718 bases over 194 sequences**, counted by our own program over the bytes. Every
base admits exactly three other letters. **The study uses the smaller of the two counts, which
is theirs**, everywhere a larger one would flatter the finding.

## The result

> ```
>   UNCONDITIONAL — holds whatever range the score takes:
>     variants that MUST share a value with another variant : 4,721,809,918
>     that is 52 of every 100 variants in the catalogue
> ```

**More than half of the catalogue is arithmetically obliged to carry the same score bytes as
some other variant.** Not because the model judged those variants equivalent — because there
were not enough distinct numbers to say otherwise. Nine billion things, four and a quarter
billion available answers, and pigeonhole does the rest.

This holds **whatever range the score takes**. It assumes nothing about the model, the biology,
or the distribution of the values. It is the same argument as putting nine pigeons in four
holes, run once at scale.

If the score is bounded to the unit interval — a natural reading for an impact score, and one
this program explicitly does **not** verify — the container is much tighter still:

```
  float32 values available in 0..1                   1,065,353,216
  variants that MUST share a value                   7,934,646,784   (88 of every 100)
  mean variants per representable value              8
```

And the same catalogue in double precision:

```
  float64 values available in 0..1     4,607,182,418,800,017,408
  variants forced to share                                     0
```

**The room was there.** Double precision offers about 512 million times more distinct values in
the unit interval than nine billion variants could ever need. The collisions are a property of
the choice of container, not of the size of the problem.

## What a reader cannot see, which is the part that matters

Look up two variants in the Atlas and get the same number back. **There is no way to tell which
of two things happened.** Either AlphaGenome judged those two changes equally impactful — a real
prediction, and possibly a correct one — or single precision had no distinct value left to give
them and they were rounded onto the same bit pattern. The artifact returns the same bytes in
both cases and does not distinguish them.

That is what "the container cannot distinguish its own rows" means. It is not a claim that any
answer is wrong. It is that **agreement and exhaustion look identical on the wire.**

## What this study does not say, at the same volume as what it does

**Not that any particular pair of variants collides.** Pigeonhole proves collisions exist; it
names none of them, and this program names none. Identifying a specific harmful collision would
require reading their predictions, which this study does not do.

**Not that the model is wrong.** Two variants may be genuinely equally impactful. A container
that cannot separate that case from exhaustion is the finding — not the model's accuracy, which
this study never touches and has no instrument for.

**Not a clinical statement of any kind.** Their own terms of service say the predictions *"are
for theoretical modelling and research purposes only"* and *"must not be used for clinical
decision-making or relied upon for medical or other professional advice."* This study takes them
at their word and goes further: **it reads no prediction value at all.** Not one AVI score
appears in this repository.

**The 88% figure is conditional and is labelled as such.** It rests on scores being bounded to
`0..1`, which we have not verified. **The 52% is unconditional** and is the figure this study
stands on.

## The instrument, and that it refuses

Seven arms run **before a byte of the proto is read**, and they run in both directions — a gate
that only ever passes has measured nothing:

```
  [PASS] float32-one-bit-pattern-is-what-ieee-says
  [PASS] float64-one-bit-pattern-is-what-ieee-says
  [PASS] float32-zero-is-pattern-zero
  [PASS] nan-count-derived-not-assumed
  [PASS] pigeonhole-returns-zero-when-container-suffices
         1,000 variants in 4,278,190,082 slots forces 0 collisions
  [PASS] pigeonhole-returns-nonzero-when-it-does-not
         9,000,000,000 variants in 4,278,190,082 slots forces 4,721,809,918
  [PASS] derived-count-exceeds-announced-so-announced-is-the-conservative-choice
  arms: 7 run, 7 passed, 0 failed
```

The fifth arm is the one worth arguing about. **A pigeonhole that always reports collisions is
not an instrument, it is a slogan** — so the suite hands it a thousand variants and requires the
answer `0`.

And it refuses rather than reporting on evidence it does not have. Measured, both directions:

| given | verdict | exit |
|---|---|---|
| no proto file anywhere | `RUN_TERMINAL REFUSED PROTO_ABSENT` | 2 |
| one byte appended to the proto | `RUN_TERMINAL REFUSED PROTO_DIGEST_MISMATCH` | 3 |
| the sentence absent from the file | `RUN_TERMINAL REFUSED CONTAINER_SENTENCE_ABSENT` | 6 |
| any arm failing | `RUN_TERMINAL REFUSED SELFTEST_FAILED` | 4 |
| the pinned file, unmodified | `RUN_TERMINAL COMPLETE` | 0 |

**The seal is path-independent, measured from three directories** — the repository root,
`reproduce/`, and an unrelated directory with the root given as an argument. One seal,
`642d84b4…`, three places.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
( cd corpus/alphagenome-atlas && shasum -a 256 -c SHA256SUMS )
xcrun swiftc -O -swift-version 5 reproduce/atlas-container-pigeonhole-exact.swift -o /tmp/s44
/tmp/s44
```

No account. No key. No terms. The proto is in the clone, Apache-2.0, with its digest.

## Seal

```
MARKER  ATLAS_CONTAINER_CANNOT_DISTINGUISH_ITS_OWN_ROWS
arms    7 run, 7 passed, 0 failed
sha256  642d84b418825906d7bc2ec2933f2c8c50b61f3f74f11445d7c89d44ed62e631
```

The sealed transcript carries the proto digest, both row counts, every slot count and every
collision figure — and no path, no timing and no source text, which is why the same digest
comes back from three directories.

## Related

- [Study 40 — who told you the order mattered?](Study-40-Indefinite-Causal-Order) — order-dependence as a property of the arithmetic
- [The order of the bases](The-Order-Of-The-Bases) — the same discipline pointed at medicines: exact counting against a molecule's own composition
- [Designed, or forced by its own bases?](CRISPR-Clinical-Guide-Atlas) — where the 3,099,750,718-base GRCh38 figure is measured
- [The library admission law](The-Library-Admission-Law) — what may enter a library, and the 71 arms that prove it refuses

## Rights — source-available, not open-source

`atlas_service.proto` is Google DeepMind's, licensed Apache-2.0, and is redistributed here under
that licence with its origin and digest recorded. Everything else on this page is ours and is
published source-available: the source is visible so that anyone can re-derive every figure. No
AlphaGenome prediction value is reproduced here, and none was retrieved.
