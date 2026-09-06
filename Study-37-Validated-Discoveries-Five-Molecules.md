# Study 37 — Thirty-seven thousand validated discoveries, five molecules

*A generative materials pipeline reported 37,910 validated discoveries. Counting the distinct
molecules returns 5. Every row in the file is a valid molecule with a correct molecular weight and a
correct logP; every per-row check that ran on it was right to pass it. The defect is not in any row.
It is in the relation between rows, and no per-item validator ever holds two items at once.*

**Status: RESULTS SEALED 2026-09-06** — the instrument is built with a 13-arm control suite passing in both directions, every figure re-derived from digest-verified bytes, and the transcript sealed path-independently. The refutation was attempted at the widest reading available and failed: taking every column at once as identity, the corpus is still five things.

## The question

A generative pipeline emits candidates. A validator checks each one — is this a well-formed
molecule, does it obey Lipinski, is the weight plausible. Rows that pass are written to a validated
corpus, and the corpus is reported by its row count.

Every step of that is reasonable, and it produces a number that can be wrong by three to four orders
of magnitude without a single check failing:

> **What does "validated" mean when every item passes and the corpus is five molecules?**

That is a **discrete** question, so it is counted rather than estimated. One hash set, one integer.

## The measurement

Two files, pinned by digest and verified before anything was read.

```
materials_bivqbit_validated.csv    eba20edffd6aecd8fd00d547deb217828be2ae82ff5e2bb1b16f990cbea17a66
materials_chemistry_validated.csv  38fcd2c6048b361a0131843da549cfbbca84eefe921d1f575d28a010f09d6de4
proteins_validated.csv             bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
```

### materials_bivqbit_validated.csv — 4,058,636 bytes

```
TOTAL ROWS            37,910          (data records; header excluded)
DISTINCT IDENTITY     5               (column 2, 'smiles')
EXACT RATIO           37,910 : 5      (rows/distinct = 7,582 exactly, remainder 0)
VERDICT               COLLAPSED
```

The frequency table in full. Every row of the file is in it.

| count | smiles |
|---|---|
| 7,649 | `C1CCCCC1` |
| 7,598 | `O=C(O)c1ccccc1` |
| 7,596 | `c1cnccn1` |
| 7,580 | `c1ccc2ccccc2c1` |
| 7,487 | `c1ccccc1` |

`full-table sha256 95594154026f63552bf746f535be96392bca50385b4577c72d545c3d1de67aa1`

The remainder is 0, but the emission was not uniform by construction: the five counts span 7,487 to
7,649, a spread of 162. The ratio is exact; the design was not balanced.

### materials_chemistry_validated.csv — 8,712 rows, 30 distinct

The second file is the same shape at a different scale, and it is printed in full because thirty
values fit on a page and a truncated frequency table is not a count.

| count | smiles | | count | smiles |
|---|---|---|---|---|
| 851 | `C` | | 219 | `CCC(C)NCC(O)c1ccc(O)c(CO)c1` |
| 618 | `CCCO` | | 205 | `NCC(=O)O` |
| 428 | `c1ccc(-c2ccc3ccccc3c2)cc1` | | 200 | `CCn1cnc2c1c(=O)n(C)c(=O)n2C` |
| 421 | `c1ccc(-c2cncnc2)cc1` | | 195 | `O=C(O)CO` |
| 421 | `c1ccc(C2CCCCC2)cc1` | | 121 | `Cn1c(=O)c2c(ncn2CN)n(C)c1=O` |
| 416 | `c1ccc(-c2ccsc2)cc1` | | 118 | `c1ccc(-c2ccccc2-c2cc[nH]c2)cc1` |
| 411 | `c1ccc(-c2cnccn2)cc1` | | 116 | `c1ccc(-c2ccccc2-c2ccncc2)cc1` |
| 409 | `c1ccc(-c2ccccc2)cc1` | | 109 | `CC(CN)NCC(O)c1ccc(O)c(CO)c1` |
| 409 | `c1ccc(C2CCCC2)cc1` | | 100 | `CC(CO)NCC(O)c1ccc(O)c(CO)c1` |
| 404 | `c1ccc(-c2ccoc2)cc1` | | 99 | `Cn1c(=O)c2c(ncn2CO)n(C)c1=O` |
| 396 | `c1ccc(-c2ccncc2)cc1` | | 99 | `c1ccc(-c2ccccc2-c2cncnc2)cc1` |
| 370 | `CCC(=O)O` | | 95 | `CC1(NCC(O)c2ccc(O)c(CO)c2)CCCC1` |
| 366 | `c1ccc(-c2cc[nH]c2)cc1` | | 95 | `c1ccc(-c2ccccc2-c2ccoc2)cc1` |
| 335 | `OCCO` | | 87 | `c1ccc(-c2ccccc2-c2cnccn2)cc1` |
| 302 | `NCCO` | | | |
| 297 | `OC1CCCC1` | | | |

`full-table sha256 74db969f653be18214608230b4aaee30498f7fcd09df9e3d7b107ddb5c8f64f7`

Across both files: **35 distinct molecules carried by 46,622 rows**, overlap **0**. Two pipelines
converged on disjoint small sets.

## What the five are, and why that makes the count legible

A reader who is not a chemist can still read this table, because these are compounds from an
undergraduate textbook's first chapters. They are not exotic candidates.

| smiles | atoms | molecular_weight | logp | identity | formula |
|---|---|---|---|---|---|
| `C1CCCCC1` | 18 | 84.162 | 2.3406000000000002 | cyclohexane | C₆H₁₂ |
| `O=C(O)c1ccccc1` | 15 | 122.12299999999996 | 1.3848 | benzoic acid | C₇H₆O₂ |
| `c1cnccn1` | 10 | 80.09 | 0.4765999999999999 | pyrazine | C₄H₄N₂ |
| `c1ccc2ccccc2c1` | 18 | 128.17399999999995 | 2.839800000000001 | naphthalene | C₁₀H₈ |
| `c1ccccc1` | 12 | 78.11399999999999 | 1.6866 | benzene | C₆H₆ |

That table is the whole of what 37,910 validated discoveries assert. Not a summary of it — the
whole of it. Every row in the file is one of those five lines with a different serial number and a
different timestamp attached.

The identities are read off the SMILES rather than taken on trust. `C1CCCCC1` is a six-membered ring
of sp3 carbons; `c1ccccc1` the aromatic six-ring; `O=C(O)c1ccccc1` that ring carrying a carboxyl;
`c1cnccn1` the six-ring with nitrogen in a 1,4 relation; `c1ccc2ccccc2c1` two fused aromatic
six-rings. Each file weight was then checked against the formula in **milli-unit integers** —
C=12011, H=1008, O=15999, N=14007, the file decimal converted by integer digit arithmetic with
rounding, never by parsing a float:

```
C1CCCCC1        formula 84162  file 84162  MATCH    atoms 18 = 18
c1ccccc1        formula 78114  file 78114  MATCH    atoms 12 = 12
O=C(O)c1ccccc1  formula 122123 file 122123 MATCH    atoms 15 = 15
c1cnccn1        formula 80090  file 80090  MATCH    atoms 10 = 10
c1ccc2ccccc2c1  formula 128174 file 128174 MATCH    atoms 18 = 18
CONTROL: C5H12 against the cyclohexane row -> 72151 vs 84162 DIFFER   (the checker discriminates)
```

Ten comparisons, ten matches, and a control proving the checker can say no. **Each molecule is
correct.** Whatever wrote each row wrote a coherent molecule. That is exactly why no per-row check
could have caught this.

## The mechanism — the columns that vary are what made the corpus look large

This is the part that generalises, and it is visible in one table. Every column of the file, counted
over the same 37,910 rows:

| col | name | distinct | shape | most frequent |
|---|---|---|---|---|
| 1 | `discovery_id` | **37,910** | varies on every row | `MOLECULE_10` ×1 |
| 2 | `smiles` | **5** | COLLAPSED | `C1CCCCC1` ×7,649 |
| 3 | `num_atoms` | 4 | COLLAPSED | `18` ×15,229 |
| 4 | `molecular_weight` | 5 | COLLAPSED | `84.162` ×7,649 |
| 5 | `logp` | 5 | COLLAPSED | `2.3406000000000002` ×7,649 |
| 6 | `hbd` | 2 | COLLAPSED | `0` ×30,312 |
| 7 | `hba` | 3 | COLLAPSED | `0` ×22,716 |
| 8 | `lipinski_pass` | 1 | CONSTANT | `True` ×37,910 |
| 9 | `method` | 1 | CONSTANT | `BiVQbit-EGNN` ×37,910 |
| 10 | `timestamp` | **37,910** | varies on every row | `2025-10-12T06:07:19.319163` ×1 |

Two columns vary across every single row: a serial identifier and a microsecond timestamp. Neither
carries chemistry. **They are precisely the columns a row count is sensitive to, and precisely the
columns a molecule count must ignore.** A corpus of five molecules, logged once per emission, looks
from the outside exactly like a corpus of 37,910 discoveries — because the log is honest about
events and silent about identity.

The same table for the chemistry file says the same thing: `discovery_id` 8,712, `timestamp` 8,712,
`smiles` 30, `drug_likeness_score` and `safety_score` constant at 1.

The strongest available reading was tested and does not rescue the count. Taking the **entire row**
as identity — every column at once, minus only the serial id and the timestamp:

```
materials_bivqbit_validated.csv     37,910 rows ->      5 whole-row signatures
materials_chemistry_validated.csv    8,712 rows ->     45 whole-row signatures
proteins_validated.csv              78,680 rows -> 78,680 whole-row signatures
```

There is no column, and no combination of columns, under which the first corpus is more than five
things. The protein file under the identical test returns full diversity, so the test discriminates.

Two further readings were tested and did not hold. The collapse is **not progressive** — all five
molecules appear on all six days of emission (7,006 / 5,214 / 5,732 / 7,494 / 9,565 / 2,899 rows,
five distinct on each), and in both the earliest 1,000 rows by timestamp and the latest 1,000. The
corpus was five molecules in its first hour. And `discovery_id` runs `MOLECULE_2` to
`MOLECULE_75820` against the export's own `_bivqbit_scanned: 75823` — a serial label drawn from the
scan index, not a structure.

## The control arm

A counter that returns a small number for everything has found nothing. Always-green and always-red
are the same defect, so the instrument proves it discriminates **before** it measures anything: if
any arm fails, no corpus measurement is emitted at all.

```
PASS  1  synthetic diverse    1,000 rows / 1,000 distinct  -> 1,000  NO_COLLAPSE
PASS  2  synthetic collapsed  1,000 rows / 1 distinct      ->     1  COLLAPSED
PASS  3  synthetic five-way   1,000 rows / 5 distinct      ->     5  COLLAPSED
PASS  4  header-only input                                 -> REFUSED
PASS  5  zero-byte input                                   -> REFUSED
PASS  6  missing file                                      -> REFUSED
PASS  7  ragged records                                    -> REFUSED
PASS  8  identity column absent                            -> REFUSED
PASS  9  DISCRIMINATION  same rows, different verdicts     -> differs
PASS 10  DETERMINISM     row order does not move the table -> 8b9eb4ae5e9cf3a0...
PASS 11  sha256("") and sha256("abc") known answers        -> e3b0c442... / ba7816bf...
PASS 12  REAL negative control  proteins_validated.csv key='sequence'
         -> rows=78,680  distinct=78,680  NO_COLLAPSE  sha-ok

CONTROL ARM  13/13 PASS
```

Arm 12 is the one that matters most, because it is not synthetic. **78,680 rows of real protein
sequence, 78,680 distinct, NO_COLLAPSE** — the same code path, the same comparator, the same
program run, on a corpus that is genuinely diverse. The counter returns full diversity when full
diversity is there.

And the sharpest discrimination evidence is on the collapsed file itself. Same 4,058,636 bytes, same
binary, only the identity column changed:

```
key = smiles        distinct 5        COLLAPSED
key = discovery_id  distinct 37,910   NO_COLLAPSE
key = timestamp     distinct 37,910   NO_COLLAPSE
key = method        distinct 1        COLLAPSED
```

Four keys, four verdicts spanning the full range, on real bytes. A blind counter cannot do that.

**Empty input is refused, never counted as zero-collapse.** A counter reporting 0 distinct over 0
rows has announced the strongest possible collapse from the weakest possible evidence, and it will
do so on the day the export breaks. Every refusal path exits 2 and prints the published reference
figures first, so a refusal never silently drops the numbers a reader came for.

## The reusable finding

**Per-item validation is structurally unable to detect a corpus-level defect.**

Not "did not" — *cannot*. A per-item validator is a function of one item. The property that failed
here is a property of the set: how many distinct things are in it. No function of one item can see
it, however many items you run it over, because it never holds two items at once. Running a correct
validator 37,910 times returns 37,910 correct answers and zero information about diversity.

The instrument that closes the gap is not sophisticated. It is a hash set over the identity column
and an integer, published next to the row count. It costs less than the validator that already runs
on every row — and it did not exist.

The general form, which any reader can run on their own corpus today:

```bash
xcrun swiftc -O -swift-version 5 reproduce/corpus-distinct-count-exact.swift -o /tmp/cdc
/tmp/cdc <corpus.csv> <identity-column-name-or-1-based-index>
```

Four rules travel with it, and each one is a defect the counter itself can have:

1. **Publish the two numbers together.** Row count and distinct count, side by side. Either alone is
   a headline that can be off by orders of magnitude while being literally true.
2. **Give the counter a control arm before trusting a reading.** Two arms minimum: a corpus known
   diverse must not report collapse, and a corpus known collapsed must report it. Neither is visible
   from a single reading.
3. **Make empty input a refusal.** Zero over zero is not zero-collapse.
4. **Name the identity column explicitly.** Here it is `smiles`, and it is not `discovery_id` or
   `timestamp` — both of which vary across every row and would report perfect diversity on a corpus
   of five molecules. Which column carries identity is a decision about the domain, and a counter
   pointed at the wrong column is worse than no counter, because it returns a number.

Rule 4 is the instrument's own honest limit, and it is stated here rather than hidden: the program
counts exactly and cannot check that it was pointed at the right column. For *these* files the
choice is closable by measurement — the whole-row-signature test above shows that no column choice
can yield more than five — but in general it is a judgment the counter cannot defend from its own
contents.

## The call

Stated plainly, because a finding that ends in hedging is not a finding.

**What we call.** `materials_bivqbit_validated.csv` holds **37,910 rows and 5 distinct molecules**;
`materials_chemistry_validated.csv` holds **8,712 rows and 30**. Across both, **35 molecules carried
by 46,622 rows**. Those are exact integer counts over the identity column of the pinned bytes,
complete over every row, digests checked first. 37,910 to 5 is a ratio of **7,582 to 1**: a headline
in units of discoveries and a headline in units of molecules differ here by three to four orders of
magnitude, and both are computed from the same file.

**We call the instrument gap, not the pipeline.** Every row validates. `discovery_id` varies across
all 37,910 rows; `timestamp` varies across all 37,910; each molecule carries exactly one molecular
weight and one logP, and each is correct for the molecule named. There is no row in either file that
a per-row check should have rejected.

**What we refuse to call.** We do not call this fabrication, and nothing in these bytes supports
that reading. Five correct molecules with five correct property tuples is a generator converging on
a small set and a ledger recording each emission, which is what an append-only ledger is for.
Whether the convergence is a seeded start, a reward that pays for validity rather than novelty, or a
deduplication step that was never in the design is **not visible in these bytes**, and this
instrument does not guess at it. We do not call the per-row validators wrong — they answered the
question they were asked, and the answer "this row is a valid molecule" is true 46,622 times over.
We do not read `molecular_weight` or `logp` as evidence of anything beyond their own constancy: they
are decimal text here, counted and printed, never compared, so no verdict in this measurement rests
on a float. And we do not extend the count past these files; 37,910 validated from 75,823 scanned
and 8,712 from 11,801 are what the export reports, and the pre-validation population is not in the
pinned bytes.

One caveat runs in the safe direction, and it is worth naming. Distinctness here is exact byte
equality over the SMILES string, not molecular identity, so **5 and 30 are upper bounds** — a
non-canonical spelling or a tautomer would count twice. They can be too high; they cannot be too
low. The cheapest probe that could have undermined the count was run: the chemistry file has 30
distinct SMILES but only 28 distinct molecular weights, and both collisions resolve to genuine
constitutional isomers (`c1ccc(-c2cnccn2)cc1` / `c1ccc(-c2cncnc2)cc1` at 156.188, and their two
biphenyl analogues at 232.286) rather than duplicate spellings of one molecule.

**What a reader should do.** Add a distinct count over the identity column to the reporting path of
any generative pipeline, next to the row count, and publish both. Give it a control arm before
trusting a reading. Refuse empty input. Name the identity column. The program that does all four is
below, it is 1,110 lines, and it runs on any CSV.

This is a finding about instrumentation. It is not an accusation about anyone.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
( cd corpus/eric && shasum -a 256 -c SHA256SUMS )   # six files, all OK, before anything is read
xcrun swiftc -O -swift-version 5 reproduce/corpus-distinct-count-exact.swift -o /tmp/cdc
/tmp/cdc < /dev/null                         # no argv, stdin from /dev/null
```

Exit 0, 464 lines, zero bytes on stderr. The control arm runs first and nothing is measured if it
fails. Section 6 of the transcript re-derives all 22 published figures from the pinned bytes and
reports **0 disagreements**; when a figure does not re-derive it prints `DISAGREES`, names both
numbers, and exits 1 — the measurement wins and the published figure is the one that gets corrected.

Swift 6.4, `-swift-version 5`, zero warnings, zero errors. **Zero float on every decision path:** the
1,110-line source contains exactly one occurrence of `Double`/`Float`/`CGFloat` and it is inside a
comment on line 19. Every count is an `Int`; the collapse test is the integer comparison
`distinct * 10 <= rows`; `molecular_weight` and `logp` are carried as byte strings and reach only
`Set<String>` and the display padder. Complete enumeration over every row, no sampling.

All three corpora are CRLF throughout (37,911 / 8,713 / 78,681 CR-terminated lines). The reader
handles it; a naive splitter will carry a stray `\r` into the final column and get a different
answer for `timestamp`. That is the detail a reproduction fails on.

## The seal

```
TRANSCRIPT SEAL  sha256  1c2e05a659917cd5de0d20446483b26372c757b48cec510070644e7307b7fd36
sealed bytes             25,192   (stdout above the seal block, exactly)
exit                     0
```

Cross-checked against the system hasher: `head -c 25192 | shasum -a 256` returns the identical
digest, and repeated runs and independent rebuilds emit it byte-for-byte.

**The seal is path-independent, and it was not always.** The first build printed the corpus directory
it had read *inside* the sealed region, so the digest moved with the checkout: identical corpus bytes
at a second location sealed `684a01ed…` over 25,224 rather than `d2f99571…` over 25,342 — a
difference of exactly 118, the length difference between the two path strings — while every figure
and all 21 `AGREES` lines were identical. That is the worst failure a seal can have: it indicts a
correct reproduction. The path is now printed outside the sealed transcript and the fix is
demonstrated rather than asserted — the same corpus at two different filesystem locations returns
`1c2e05a6…` over 25,192 bytes from both.

The finding it was caught by is the finding this page is about: **a self-consistent reading looks
correct.** The program agreed with itself perfectly at every step; only a comparison against
something outside it showed the defect.

Three further pins, each byte-identical from any location, so a reader can verify the counting
without reproducing the whole transcript:

```
bivqbit   smiles frequency table    95594154026f63552bf746f535be96392bca50385b4577c72d545c3d1de67aa1
chemistry smiles frequency table    74db969f653be18214608230b4aaee30498f7fcd09df9e3d7b107ddb5c8f64f7
proteins  sequence frequency table  0169f514a861ece42573fbff4d4db28e27880373adb7296a304aa9ddb860c1f4
```

## Related

- [Known molecular discoveries](Known-Molecular-Discoveries.md) — the public review ledger these corpora feed.
- [Where else could this guide cut? The whole genome, counted](CRISPR-Genome-Off-Target-Map.md) — the same discipline over the human genome.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md)
- [Zero float, zero shear](Zero-Float-Zero-Shear-Paradigm.md) — why no verdict here rests on a decimal.
- [Ask someone you trust to check this](Ask-Someone-You-Trust-To-Check-This.md)

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
