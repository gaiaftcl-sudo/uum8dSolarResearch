# The first treatment for Alexander disease — and the safety question that should be exact

*A shear study on zilganersen (Zanvastro) for Alexander disease. The subject under grading is the safety **instrument** — never the medicine, the company, or a child.*

## A disease that had nothing

For a family, Alexander disease often begins as a question no one can answer: a head growing too fast, seizures, a delay in sitting or walking, a slow unlearning of skills already won. It is an *astrocytopathy* — a disease of the astrocyte, the brain's support cell — caused almost always by a new, dominant mutation in a single gene, *GFAP*. Most affected children are the only person in their family who ever will be; the variant arises fresh. The mutant protein does not merely fail, it poisons, jamming the astrocyte's scaffolding into aggregates called Rosenthal fibers, and the white matter unravels downstream. It is the one leukodystrophy that begins in an astrocyte protein rather than in myelin.

Prognosis depends heavily on age at onset, and the range is wide enough that no single lifespan is honest across it. The infantile form is often fatal within the first decade; a pediatric natural-history cohort of mixed onset put the mean age at death near 18.6 years, with loss of independent walking as the hinge after which decline accelerates. Later-onset disease can run into adulthood, sometimes decades. It is ultra-rare — a frequency often cited near one in 2.7 million, a few hundred known U.S. patients. Until this year, medicine could name the disease precisely and change its course not at all: seizure medicine, a feeding tube, a wheelchair, and time.

## The breakthrough

On September 3, 2026, the FDA approved Zanvastro (zilganersen, Ionis) — the first disease-modifying therapy for Alexander disease, in children and adults. It is not a cure and does not undo damage. What it does is mechanistically rational: it lowers the toxic protein at its source. Zilganersen is an antisense oligonucleotide built as a *gapmer* — a central DNA core flanked by 2′-*O*-methoxyethyl RNA wings — whose sequence is the reverse complement of a stretch of *GFAP* messenger RNA. It pairs with that transcript by Watson–Crick base pairing, forming a duplex the cell's own enzyme RNase H1 recognizes and cleaves, destroying the message before more of the poisoning protein is made; the oligonucleotide is released and recycles. It is given intrathecally — into the spinal fluid — at 50 mg once every twelve weeks.

In the pivotal Phase 1–3 study (NCT04849741; roughly 49–54 participants across eight countries, randomized 2:1 against control), the dose met its primary endpoint: at Week 61, treated patients aged five and older held walking speed roughly steady while controls declined — a **33.3% least-squares-mean difference on the 10-Meter Walk Test, p = 0.041** (a small cohort, a borderline margin, one motor measure with a real floor). The honest word is *stabilization*: it slows the loss, it does not give back what is gone. It carries Orphan Drug, Fast Track, Breakthrough Therapy, and Rare Pediatric Disease designations, and an aseptic-meningitis warning in its label; ex-U.S. rights were licensed to Recordati.

**This is real hope.** The rest of this study is not about the medicine. It is about which safety question a computer can answer *exactly*, why that is worth money and lives, and where the exact answer stops.

![For an antisense drug, off-target danger is a discrete question; answered in exact integers it is one answer on every machine, in floating point it shears — and what that is worth, for patients and for pharma](images/aso-exact-safety.svg)

## What we ran — the real sequence, against the whole transcriptome

An antisense drug carries one safety-relevant risk that is, unusually, a matter of exact arithmetic. An ASO can bind and trigger cleavage not only of its intended target but of any transcript its sequence partly matches — *hybridization-dependent off-target*, a documented driver of ASO toxicity. Asking "where else can it bind?" is a question about Watson–Crick base pairing: A with U, G with C. That is counting, not estimating.

**This page previously carried a synthetic, representative screen, and said so on its face.** It showed the *kind* of divergence between an exact and a floating-point instrument; it had not screened zilganersen or any real *GFAP* sequence. **That gap is now closed.** The sequence is public — NCATS GSRS, UNII `AXQ9493NT2` — and it is the same string the [off-target atlas](Oligonucleotide-Off-Target-Atlas) carries in its registry:

```
5'-CAGTATTACCTCTACTAGTC-3'
```

It was screened against **GENCODE v50** (sha256 `5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56`, nothing behind a login). No sampling, no seed heuristic, no e-value, no cutoff inside the arithmetic — one integer per window, the same integer on every machine:

```
transcripts scanned : 670670
windows enumerated  : 1467336203

KNOWN-CASE CHECK — the perfect complement must be GFAP
  perfect 20/20 windows : 2
  genes carrying them   : GFAP
  PASS — the instrument finds the drug's own target. Nothing below is assumed.

EXACT ARM — complete complementarity histogram, every window, no sampling
  20/20 paired : 2
  19/20 paired : 0
  18/20 paired : 0
  17/20 paired : 11
  16/20 paired : 313
  15/20 paired : 3994
  14/20 paired : 31130
  13/20 paired : 202866
  12/20 paired : 1024631
  11/20 paired : 4357818
  10/20 paired : 14873649
  <10/20      : 1446841789
```

**The instrument was checked on the one case it already knew, before it reported anything else.** The perfect 20-of-20 complement of zilganersen must be *GFAP*, or the screen is wrong. It found two perfect windows, both in *GFAP*, and only then printed a result. A screen that cannot find the drug's own target has not earned the right to report anything about a gene nobody expected.

### Read the two zeros

Across **1,467,336,203 windows** of the human transcriptome there is **not one site anywhere** that pairs with this drug at 19 of 20 or at 18 of 20. After its own target, the next-closest thing in the entire transcriptome is **three mismatches away**. That gap is not a modelling choice or an assumption — it is a complete count, and anyone with curl can re-derive it.

The eleven sites at 17/20, in full, because a safety artifact that lists only some of its findings is not one: **XYLB** (3 transcripts), **ENSG00000239572** (5 transcripts), **ADAM20P1** (2 transcripts), **ENSG00000293223** (1 transcript).

### The control arm — is that burden unusual, or is it just what a 20-mer does?

A list of off-target sites means nothing on its own. *Any* 20-mer has near-complementary windows in a 1.47-billion-window corpus, simply because the corpus is enormous. So the same pass screened **sixteen scrambles of the drug's own bases** — the identical multiset of A, C, G and T in a different order, permuted deterministically. A scramble is this molecule's composition with none of its design.

On-target and off-target are kept strictly apart, because conflating them makes a working drug look dangerous: at 20/20 the drug will always exceed every control, and that is the design succeeding, not a liability.

```
  ON-TARGET, kept separate and NOT compared against the controls:
    drug perfect 20/20 windows, all in GFAP : 2
    control probes with a perfect 20/20 anywhere      : 0

  OFF-TARGET BURDEN — every window OUTSIDE GFAP, drug against its own composition

  threshold      drug        control min    control median   control max     drug rank
  17/20                11              2               35            141             5 of 17
  16/20               324            141              787           1355             3 of 17
  15/20              4318           2886             7091          10715             4 of 17
  14/20             35448          26651            55916          79502             4 of 17
```

**At 16 of 20 or better, outside *GFAP*, zilganersen carries 324 near-complementary windows where the median permutation of its own bases carries 787** (upper median, the 9th of 16 sorted controls; min and max are printed beside it so the choice can be re-made). It ranks 3rd, 4th, 4th and 5th of seventeen probes across the four thresholds — consistently in the low quartile of its own composition class, and inside the control range at all four, never below every member of it. Its specificity is a property of the **order** its bases were chosen in, not of the bases themselves.

**That is the design-stage result, and it is the transferable one.** The off-target burden of a candidate oligonucleotide can be ranked against its own composition's control distribution *before synthesis*, at the cost of one pass over a public file, and the ranking is an integer that reads the same in every laboratory forever.

### And the same question asked in floating point

The screen above has no cutoff inside it and no parameter to choose, so there is nothing in it to
shear. The conventional instrument does have both: it scores each window as a binding free energy in
`Double` and calls a window a candidate below a chosen cutoff. `reproduce/aso-offtarget-exact-vs-float.swift`
runs that comparison on representative sequences — it is deliberately not the real drug, because the
point is the *kind* of divergence, not this molecule's numbers:

- **Exact returns one off-target set** — the same on every machine, with no parameter to choose,
  re-derivable byte-for-byte by a regulator years later. **MEASURED.**
- **Float returns a set that disagrees with itself.** A borderline site — 17 of 20 matches — is
  *flagged* under one defensible thermodynamic parameter set and *cleared* under another equally
  defensible one. The classification turns on which constants the program rounded to, not on the
  biology. **MEASURED** — marker `ASO_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT`.

This is the sequence-safety analogue of the shear this wiki measured on the reactor floor, where the
same density-limit verdict flipped on which rational value of π the program used
([Study 34](Study-34-Observer-Invariant-Verdict)); on the time axis, a floating-point running memory
goes deaf while the exact invariant never drifts ([Study 35](Study-35-The-Safety-Brain-That-Forgets)).
For this class of drug the safety-relevant off-target question is discrete, and answered exactly it
is observer-invariant.

### Two programs, written separately, returning the same integers

This screen is a single-drug instrument. The [off-target atlas](Oligonucleotide-Off-Target-Atlas) is a different program that screens all 472 registry strands at once and reads each drug's target *from the transcriptome* rather than from its label. Run independently on the same public bytes, the atlas returns for zilganersen the identical histogram — 2 at 20/20, 11 at 17/20, 313 at 16/20, 3,994 at 15/20 — the identical measured target *GFAP*, the identical four genes at 17/20, and the identical off-target burden of **324** at 16/20 or better. **Neither program was adjusted to agree with the other**, and the agreement is what a re-derivable result is supposed to look like.

## This is the drug class the exact method was built for

Say it plainly, because the timid version would give away the real thing. For most of pharmacology the instrument for "will this molecule misbehave" is a floating-point one — molecular dynamics, a thermodynamic estimate, a learned fold — and its verdict moves with the force field, the parameters, the rounding, and the platform. An antisense oligonucleotide is different: the safety-relevant question of *where else its sequence strikes* is not a continuous energy at all, it is a discrete search over an alphabet of four letters and a pairing rule. Exact enumeration of that search up to a chosen number of mismatches is complete and re-derivable; the heuristic sequence tools in common use (BLAST/Bowtie-class) trade completeness for speed, can miss real sites, and disagree between tools. The affine, exact-integer approach does not merely characterize that computation — it makes it **auditable**: one off-target set, re-derivable by a safety authority without trusting whoever produced it. For an oligonucleotide, that is not a someday capability. It is the right tool, and it is a better one for this question.

## Where it goes silent

Honesty is the credibility, so the boundary is drawn as loudly as the claim. **A match is not a cut:** the discrete search returns the complete candidate universe; it does not decide which candidates RNase H1 actually cleaves — enzyme tolerance and hybridization energetics settle that, and that layer is not in the exact count. And **the larger half of ASO safety is not a sequence match at all:** the phosphorothioate chemistry that makes these drugs durable binds proteins sequence-*independently*, and complement activation, low platelets, nephro- and a chemistry route to hepatotoxicity, and this label's most visible signal — aseptic (chemical) meningitis, a recognized intrathecal-ASO effect — are governed by chemistry, dose, length, and route. No base search predicts or removes them. The exact method answers **one** question exactly; it does not answer "is this drug safe."

## The two questions, answered

**Can the substrate speak to this drug's safety?** To one sub-question, exactly and better than any floating-point tool: the hybridization-dependent off-target map is a discrete, observer-invariant, re-derivable computation — and that property is worth most precisely here, where a child may be dosed into the CSF four times a year for decades and the real long-term readout is post-marketing surveillance, not a 61-week trial. **The screen has now been run on the real approved sequence**, and the figures above are its output: two perfect windows, both in *GFAP*; nothing at all at 19/20 or 18/20; eleven sites at 17/20, named. On the whole-drug question the boundary is unchanged and is drawn just as loudly — a near-complementary window is a place the molecule COULD pair, not a cut, not an occupancy, and not a clinical event. What has changed is that this page no longer reports a representative screen where a real one was possible.

**Are there better options?** No — and that is a finding, not a gap. Zilganersen is the only approved and only clinical-stage therapy; the honest comparator is the disease's own natural history — relentless and usually fatal — not a rival drug. It would be wrong to invent one, and wrong to say no one is trying: an early preclinical AAV gene-therapy program (UMass Chan / Astellas, 2024) and the ASO's own preclinical *Gfap* rat validation exist, but none has reached a patient. The forward gift is no longer a promise: the composition-matched control arm above **designs and ranks**. A candidate oligonucleotide is scored against sixteen permutations of its own bases, and its off-target burden becomes an integer rank inside its own composition class — 324 windows against a median 787, here. That is an auditable screen at the design stage, runnable before a molecule reaches a child's spinal fluid, and it costs one pass over a public file.

## Why pharma should reset — and what it is worth

The economics of drug safety are brutal and one-directional: a failure found late, in a patient, costs the most in both currencies that matter. A late-stage program that collapses burns the hundreds of millions already spent, and when the failure is a safety signal, it can cost lives before it is caught. Against that, an exact, auditable safety screen at the *design* stage is the cheapest insurance a pipeline can buy — and for the one ASO question that is genuinely discrete, that screen is available and provably observer-invariant today.

The reset is small to state and large in consequence: **move the safety verdict from a number that moves with your parameters to one an authority can re-derive.** For the sequence-safety layer of an oligonucleotide, that is not aspiration; it is arithmetic. Affine.Earth licenses the exact method, and it is priced against what it saves — lives, and the lost work of a failure that need not have happened. That is the offer, stated plainly: not a better guess, an auditable answer, at the stage where changing your mind is still cheap.

---

> ### What we claim, and what we do not
>
> **We claim:** Alexander disease is a devastating, usually fatal childhood astrocyte disease that until 2026 had no disease-modifying treatment, and zilganersen is a genuine first-in-class breakthrough that stabilizes walking speed against a declining natural course. For an antisense drug, hybridization-dependent off-target identification is a discrete, exact, re-derivable computation — measured here to be observer-invariant where a floating-point binding-energy screen reclassifies a borderline site on the parameter set it rounds to — and that is a real, better instrument for this one question, at the design stage. We claim the screen above was run on the REAL approved sequence (UNII AXQ9493NT2) against the whole human transcriptome, complete and unsampled: 2 perfect windows both in GFAP, zero at 19/20 and zero at 18/20, 11 at 17/20 named in full, and an off-target burden of 324 windows at 16/20 or better against a composition-matched control median of 787. A second, independently written program returns the identical integers. The exact-versus-float advantage is also measured out-of-domain on the fusion court (Studies 34 and 35).
>
> **We do not claim:** that any binding energy, occupancy, cleavage prediction, or whole-drug safety verdict was computed for zilganersen. The screen counts Watson-Crick complementarity and nothing else: a near-complementary window is a place the molecule COULD pair, never evidence that RNase H1 cuts there. We do not claim the exact method answers whether the drug is safe: it covers hybridization-dependent off-target candidates only, does not decide which are actually cut, and is silent on the chemistry, immune, route, and aseptic-meningitis risks that dominate this drug's long-haul profile. We do not claim a better therapy exists — none is approved or in late-stage trials. The honest edge word on anything unbound is: *not known.*

## The call

**On the instrument: this shows promise and warrants laboratory follow-up.** The composition-matched
ranking above is a design-stage screen that does not currently exist in the oligonucleotide workflow,
it runs in minutes on public bytes, and it returns an integer that any laboratory or regulator
re-derives identically. A bench designing the next intrathecal ASO should rank its candidates this
way before it synthesises any of them.

**On the drug: Affine.Earth does not call zilganersen safe, and does not call it unsafe.** Neither
verdict is ours to give and neither follows from this arithmetic. What we have is one exactly
answered sub-question — where in the human transcriptome this sequence can pair — reported complete,
with its two zeros and its eleven named sites. The rest of this drug's safety profile is chemistry,
dose and route, and no base search reaches it. **Nobody should take or withhold anything on the
strength of this page**, and no clinical decision belongs to it.

**Where a bench should point.** The eleven 17/20 sites are named above with their transcripts and
positions. Whether any of them is accessible, expressed in the dosed tissue, or cut by RNase H1 is
four wet-lab questions this program has not asked and cannot answer. Those four are the follow-up.

## Run it yourself

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# the real approved sequence, whole transcriptome, with the composition-matched control arm
swiftc -O reproduce/zilganersen-offtarget-whole-transcriptome.swift -o /tmp/zilg
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/gencode.v50.transcripts.fa.gz \
  | gunzip -c | /tmp/zilg

# the exact-vs-float comparison on representative sequences
swift reproduce/aso-offtarget-exact-vs-float.swift
```

Marker and seal, recomputed by the program on every run:

```
MARKER  ZILGANERSEN_OFFTARGET_EXACT__REAL_SEQUENCE_WITH_COMPOSITION_CONTROL
sha256  edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa
```

## Sources

- FDA approval, mechanism, dose, designations, label warning, Recordati license: [Ionis / BioSpace release](https://www.biospace.com/press-releases/zanvastro-zilganersen-approved-by-the-fda-as-the-first-and-only-disease-modifying-treatment-for-alexander-disease-axd-in-pediatric-and-adult-patients); [NeurologyLive](https://www.neurologylive.com/view/fda-approves-zilganersen-first-treatment-alexander-disease); [Pharmacy Times](https://www.pharmacytimes.com/view/fda-approves-zilganersen-injection-first-drug-for-alexander-disease). The FDA prescribing information is the definitive adverse-event source.
- Pivotal trial: [ClinicalTrials.gov NCT04849741](https://clinicaltrials.gov/study/NCT04849741).
- Disease genetics, pathology, natural history: [GeneReviews NBK1172](https://www.ncbi.nlm.nih.gov/books/NBK1172/); [StatPearls NBK562242](https://www.ncbi.nlm.nih.gov/books/NBK562242/); Prust et al., *Neurology* 2011.
- ASO hybridization-dependent off-target as discrete search: Yoshida et al. 2018 (*Genes to Cells* [gtc.12587](https://onlinelibrary.wiley.com/doi/10.1111/gtc.12587)); [NAR 46(11):5366](https://academic.oup.com/nar/article/46/11/5366/5001158). Chemistry/class toxicity: Frazier 2015 (*Toxicol Pathol*).
- Preclinical pipeline: [Astellas / UMass Chan](https://www.umassmed.edu/news/news-archives/2024/06/umass-chan-medical-school-joins-sponsored-research-agreement-with-astellas-pharma/); [*Sci Transl Med* 2021 rat ASO model](https://www.science.org/doi/10.1126/scitranslmed.abg4711).
- Exact-vs-float principle: `reproduce/aso-offtarget-exact-vs-float.swift`; [Study 34](Study-34-Observer-Invariant-Verdict), [Study 35](Study-35-The-Safety-Brain-That-Forgets), [Study 14](Study-14-Protein-Lattice-Manifold).

*Grades: VERIFIED / REPORTED / MEASURED / ARGUMENT / NOT_KNOWN. This study extends — never contradicts — Study 14 and the fusion anchor; its molecular court for a real drug is a charter, and it says so.*
