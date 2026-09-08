# What a gene's length already decides

*Two instruments that answer before you ask them. The subject under grading is a **mapping rule**
and a **constraint score** — never a gene, never a person, and never anyone's DNA.*

**Status: VERIFIED — 2026-09-08.** 19,704 genes, every catchment base counted with no sampling,
**16 self-test arms in both directions, 0 failed**, 17 published figures recomputed and
**0 disagreeing**. Both results are re-derivable from a 1.5 MB public corpus in under three seconds.

---

## Why this page exists

Two of the most-used moves in human genetics are:

1. **map a variant to its nearest gene**, and
2. **ask whether the resulting gene set is unusually constrained**, usually with gnomAD's LOEUF.

Both are reasonable. Both are also **instruments with a built-in answer**, and the size of that
built-in answer is measurable exactly. This page measures it. Nothing here says anyone's result is
wrong; it says what a matched control has to hold constant before the result means what it looks
like.

## 1 — Nearest-gene mapping is a length-weighted lottery

A long gene has a larger catchment. That is not a hypothesis, it is geometry: every base inside the
gene maps to it, and so does every base in the flanks up to the point where a neighbour gets closer.
So a variant with **no biology attached at all**, dropped uniformly at random on the genome, lands
disproportionately on long genes.

Measured over the whole gene model, counting **every base of every catchment** — no variant list, no
sampling, no binning:

| | mean length of the assigned gene | against the average gene |
|---|---:|---:|
| the average gene, unweighted | **66,591 bp** | 1000/1000 |
| **nearest by INTERVAL** — the field's own rule, ≤ 100 kb | **243,881 bp** | **3662/1000** |
| nearest by MIDPOINT, ≤ 100 kb | **114,478 bp** | **1719/1000** |

Assignable bases: **2,070,253,229** under the interval rule (of which 1,261,815,650 lie inside a
gene) and **1,628,025,115** under the midpoint rule. The two domains differ, and the reason they
differ *is* the finding: a long gene reaches further under the interval rule.

**A variant with nothing biological about it maps to a gene 3.66× the length of the average gene.**
The midpoint rule carries less than half that bias — 1.72× — and nobody chose it for that reason;
the interval rule is the convention.

This matters because gene sets that are enriched for long genes are not rare or exotic. Brain-
expressed genes are long. So an analysis that maps variants to nearest genes and then asks *"is this
set brain-enriched?"* is asking a question its own mapping has already half-answered.

## 2 — LOEUF's denominator is coding length

LOEUF is the upper bound of the observed/expected loss-of-function ratio. Its **denominator is the
expected LoF count**, and the expected count is a function of how much coding sequence a gene has.
So the score should fall with length even where nothing about constraint differs — and it does,
monotonically, across every decile.

Median LOEUF × 10⁶ over the 19,197 genes carrying both a LOEUF and an expected-LoF count:

| decile | by gene length | by expected LoF | by CDS length |
|---|---:|---:|---:|
| D1 | **1626000** | **1799000** | 1686000 |
| D2 | 1215000 | 1454000 | 1268000 |
| D3 | 1096000 | 1146000 | 1129000 |
| D4 | 995000 | 1013000 | 1140000 |
| D5 | 974000 | 921000 | 919000 |
| D6 | 872000 | 867000 | 867000 |
| D7 | 812000 | 765000 | 794000 |
| D8 | 720000 | 648000 | 704000 |
| D9 | 572000 | 551000 | 558000 |
| D10 | **484000** | **412000** | 412000 |

- by **gene length**: 1626000 → 484000, a **3359/1000** swing, **strictly monotone**
- by **expected LoF**: 1799000 → 412000, a **4366/1000** swing, **strictly monotone**
- by **CDS length**: 4092/1000, and **not** monotone — D4 sits above D3. Reported as it came out.
  A result that were fabricated, or fitted, would be monotone everywhere.

### The control, run both ways

The obvious objection is that gene length and expected-LoF count are the same variable wearing two
coats. So each is held inside the other's decile and the residual measured — in both directions,
because running it one way only would have answered a question the page did not ask.

| held constant | moving variable | deciles where it still moves LOEUF | mean shift |
|---|---|---:|---:|
| expected-LoF decile | gene length | **10 of 10** | **-124,600** |
| gene-length decile | expected LoF | **10 of 10** | **-391,700** |

**The denominator dominates by 3143/1000 — and both survive conditioning.** So the honest statement
is not "LOEUF is only its denominator": it is that **coding length accounts for about three times as
much of the LOEUF gradient as genomic length does, and neither is zero.** Both halves of that are
measured; neither is asserted.

## What this means for an analysis you might be running

Nothing here invalidates a published enrichment result. It names what the control has to hold:

- **Match on gene-length decile**, not only on expression level or detection rate. A background set
  matched on expression but not on length is matched on the wrong variable for this instrument.
- **Or map by midpoint.** It carries less than half the length bias, and it costs nothing.
- **Match on expected-LoF count before reading LOEUF**, because that is the score's own denominator.

All three are cheap. None requires new data. Each is a line of code.

## What we call, and what we refuse to call

**We call both measurements exact and complete.** Every base of every catchment on every chromosome
is counted; every gene carrying the fields is scored; nothing is sampled, binned or estimated. The
figures are reproducible in under three seconds from a 1.5 MB file.

**We refuse to call any published enrichment result wrong.** This page measures an instrument's
built-in gradient. Whether a particular result survives matching on that gradient is a question for
that result's own data, and we have not run it.

**We refuse to say anything about any gene, any variant or any person.** No individual data of any
kind is in this corpus. Gene lengths and constraint scores are aggregate properties of a reference
genome, published by their consortia.

**We refuse to convert either result into a claim about biology.** A length-weighted lottery is a
statement about a mapping rule. That brain-expressed genes are long is a fact about the genome, not
a verdict on any neuroscience.

**Where a bench should point.** Re-run one published nearest-gene enrichment with gene-length decile
added to the matching, and publish both numbers side by side. That is a day of work and it would
tell the field how much of its tissue-localisation literature is carrying this gradient.

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch
xcrun swiftc -O -swift-version 5 reproduce/nearest-gene-length-lottery-exact.swift -o /tmp/gl
/tmp/gl
```

Sixteen self-test arms run before any corpus byte is read, in both directions — the decimal parser
must accept scientific notation **and** reject `NA`, text and a double dot; the rational comparator
must order 1/2 before 2/3, must **not** order 2/3 before 1/2, must leave equal rationals in
different denominators unordered, and must separate 1/3 from 33333333333333333/10¹⁷, which a
`Double` calls equal. One arm is a **mutant** that weights every gene equally and is required **not**
to reproduce the catchment mean — which is what shows the weighting, rather than the arithmetic, is
where 3.66× comes from.

The program takes **no argument and no stdin**, and prints its published reference figures as its
very first action, before any file is opened, so every refusal path prints them. The corpus root is
discovered by walking outward from the binary and the working directory; the seal is identical from
any directory.

```
  arms run = 16   failed = 0
  pins disagreeing = 0
MARKER  GENE_LENGTH_INSTRUMENT__NEAREST_GENE_LOTTERY_AND_LOEUF_DENOMINATOR
sha256  c11ae542d7344b95abd87ee84d065954f322d0118d2609b236fe69ae1dda4489
```

Corpus and provenance: `corpus/gene-length-instrument/`, digest-pinned, one file, aggregate
properties of a reference genome only.

Related: [The ceiling on what a genetic score can know](The-Ceiling-On-What-A-Genetic-Score-Can-Know.md) —
what the best possible genotype-only score can ever do, computed exactly.

---

## Rights — source-available, not open-source

The measurements and the law that produces them are published so anyone may check them. Re-deriving
these figures from the public gene model and constraint release requires no permission and no
agreement with us. Affine.Earth asserts no claim over GENCODE, Ensembl or gnomAD, which belong to
their authors and to the public.
