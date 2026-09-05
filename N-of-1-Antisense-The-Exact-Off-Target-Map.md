# N-of-1 Antisense Oligonucleotides — the exact off-target map, and the exact line where it stops

*An Affine.Earth shear study. The subject under grading is a safety instrument — not the medicine, not its makers, not any patient.*

## The people this is for

Some diseases have a population of one. A child is born with a private spelling mistake in a single gene — an insertion in *MFSD8*, a toxic *MAPK8IP3* variant, a CAG expansion in *ATN1*, a *CHCHD10* or *TARDBP* change that drives a genetic form of ALS, a *PRPH2* variant taking the retina. By the time a family reaches the edge of medicine, there is usually no approved therapy and no trial that will ever be built, because a trial needs more than one patient and there is only this one. The comparator is supportive care. This study is about the moment that math changes — when a drug can be built for the one person who needs it, and the safety question can be met before the first dose instead of feared after it.

That is the human weight of this work. The first of these drugs, *milasen*, was designed for a girl named Mila with CLN7 Batten disease and given under an FDA expanded-access protocol about a year after her diagnosis. It reduced her seizures substantially. It did not stop the underlying neurodegeneration, and the honest record says both halves of that sentence. The field has grown from there: to the field's knowledge, 27 individuals had received individualized ASOs as of January 2025 (REPORTED — N=1 Collaborative consensus, *AJHG* 2025), and n-Lorem's own June 2026 cohort reports more than 50 patients treated across more than 300 doses and more than 55 patient-years, with no ASO-related serious adverse events observed in their series (REPORTED — peer-reviewed and sponsor-authored). Each of those numbers is a person who, a decade ago, would have had nothing to try.

## What is new

An antisense oligonucleotide is a short chemically-modified single strand — usually about 18–22 bases — complementary to a chosen stretch of the patient's own RNA. Two families matter here. Steric-blockers like *milasen* and the approved *nusinersen* bind pre-mRNA and redirect splicing; they recruit no cutting enzyme. Gapmers carry a DNA core that recruits **RNase H1** to cleave the target — the strategy behind the *MAPK8IP3*, *ATN1*, and ALS programs, which aim to silence a toxic transcript.

What is genuinely new is the loop: read a genome, find the causal variant, pick one of three established moves — splice correction, exon skipping, or transcript knockdown — design a sequence, screen it in the patient's own cells, and dose. The platform's cousins have graduated and prove it is real: **tofersen (Qalsody)** reached FDA accelerated approval in April 2023 for *SOD1*-ALS on a neurofilament biomarker, having missed its Phase 3 primary endpoint; **nusinersen (Spinraza)** is fully approved for SMA. A bespoke ASO is what you build when none of these fits the exact variant in front of you — a therapy written to one genome, the way a key is cut to one lock.

## The exact question, stated plainly

For a drug that will only ever be given to one person, **no trial can ever prove it is safe.** That is not a gap to apologize for — it relocates the safety question. Everything knowable before the first dose is either wet-lab characterization or computation from the sequence. One slice of that computed part is genuinely exact, and it is the slice we claim.

The question: *given one bespoke oligo sequence, enumerate every site in the human transcriptome and relevant pre-mRNA where it could bind well enough to matter, within a stated base-pair match/mismatch tolerance.*

Watson–Crick complementarity is a discrete rule — a position pairs or it does not. So "count the complementary positions in every window of every transcript, and flag every window at or above threshold" is pure integer combinatorics. It has one answer, and the same answer on every machine. The set is large and grows fast with tolerance: for a 13-mer, allowing one mismatch yields on the order of 33 complementary regions and two mismatches roughly 596 across human mRNA (REPORTED — Yoshida et al., 2018). Enumerating that set completely, without sampling, is exactly what exact computation is for. And this is already the accepted step — an in-silico screen within roughly three mismatches is standard ASO practice, and the first personalized CRISPR therapy (baby KJ, CPS1 deficiency, NEJM 2025) nominated its off-target candidates the same way, by bioinformatic enumeration plus wet assays.

Here is where the exact instrument beats the conventional one on the enumeration question, and the difference is measurable. The usual refinement ranks candidate sites by a binding free-energy (ΔG) score. That score carries real thermodynamic information the integer count does not — it separates a strong GC-rich match from a weak AU-rich one — but it is a floating-point number that requires a *chosen* thermodynamic parameter set, and published sets differ within their own uncertainty. So ΔG is the right tool for *ranking* the candidates and the wrong tool for the *membership* verdict: that parameter choice makes which sites cross the threshold machine- and parameter-dependent. The exact-versus-float principle is measured out-of-domain on the fusion-court studies (observer and time axes), and for antisense specifically in the repository demo `reproduce/aso-offtarget-exact-vs-float.swift` (marker `ASO_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT`): on synthetic sequences, the exact integer complementarity set is identical on every machine with no parameter to choose, while the ΔG-thresholded set disagrees with itself across two defensible parameter sets differing by about 3% (MEASURED — on synthetic sequences; the demo states plainly it screened no real drug).

So the claim, at full strength: the candidate off-target map — computed by exact complementarity within a declared tolerance, and complete for that discrete rule — is a **re-derivable, byte-identical safety artifact** — a reviewer on another machine reproduces it exactly, and any later dispute is settled by re-running, not by adjudicating whose parameter file was right. At n=1, where the map cannot be checked against a population, re-derivability *is* the credibility.

## Where it goes silent

An off-target map answers *where could it bind.* It does not answer *will binding there cause harm*, and it is silent on the risks that have actually hurt patients. These are not sequence-enumerable, and pretending otherwise would oversell the class.

The sharpest case is CNS toxicity driven by dose, route, and chemistry rather than by sequence. Hydrocephalus is a nusinersen label warning, appeared in tominersen for Huntington's, and, most seriously, in a KCNT1 epilepsy ASO from the Yu lab, where two infants developed hydrocephalus and the program reported one death (REPORTED — Nature Medicine, 2026). Two ASOs that differ in nothing but sequence can differ dramatically in toxicity — through protein binding, secondary structure, and immune motifs that a transcriptome-complementarity map does not model. Gapmer liver toxicity is another: RNase H1 cleaves very long pre-mRNAs at partial matches, but whether a mapped candidate is actually cut depends on expression, nuclear accessibility, and enzyme kinetics — graded biophysics, not a discrete count. And the phosphorothioate class carries thrombocytopenia, complement activation, proteinuria, and pro-inflammatory (CpG/TLR9) risks that are functions of chemistry and distribution, not of complementarity. Even within its own channel the map is complete only to its model — real off-targets are sometimes missed when RNA secondary structure or protein-mediated effects fall outside a linear-complementarity view. The wet-lab screen in patient cells stays necessary. Naming that line clearly is part of the promise: the instrument is trustworthy precisely because it says exactly how far it reaches.

## The two questions

**Can we speak to safety?** For one channel, yes — the discrete off-target-complementarity map, computed at the design stage, is a re-derivable certificate, and on re-derivability it is the better instrument. For the rest — hydrocephalus, RNase H1 magnitude, immune, PK, idiosyncratic CNS risk — the map is silent, and the answer lives in the lab and in careful dosing. A green map is a necessary component of a safety package, never the whole of it.

**Are there better options?** For most private variants there is, by definition, no approved alternative; supportive care is the comparator. Where the gene already has a graduated therapy — tofersen for *SOD1*, nusinersen for SMA, AAV gene therapy for some inherited retinal disease — that therapy is the real alternative and should be named first. Personalized CRISPR base editing (baby KJ) is the N-of-1 cousin, a different tool for a different class of variant. And at the instrument level, the exact map does not replace patient-cell screening or transcriptome-wide RNA-seq or the experimental off-target assays; its narrow, real contribution is making the *in-silico* portion re-derivable instead of parameter-dependent.

## Why it is worth building

At n=1 there is no late Phase 3 to catch an off-target error — the first patient is the only patient. The exact map moves the one part of that risk that is computable to *before the first dose*, and makes it auditable by re-derivation rather than by trust in a parameter file. For a pipeline candidate, an unacceptable mapped profile — strong complementarity to an essential transcript within tolerance — is a design-stage veto, a reason to pick a different sequence while the cost of stopping is only a redesign. Licensed against what a late or undetected failure burns — a life, and the R&D behind a bespoke drug — a re-derivable verdict on the discrete channel is cheap, and it is the right place to spend exactness.

## From day one — what the substrate would have found

Run the counterfactual. Suppose the exact instrument had been in the loop from the first afternoon one of these drugs was designed — the day a scientist first typed a candidate 20-mer against a patient's variant — aimed at the same goal the actual team was aiming at. What would it have produced that the real path did not?

A complete, re-derivable off-target map at the *design* stage. Not a ranked shortlist from a heuristic aligner, not a verdict that shifts when a thermodynamic parameter file is updated, but the full membership set of every transcriptome and pre-mRNA window meeting the declared complementarity tolerance — the same set on the designer's machine, the reviewer's machine, and a regulator's machine three years later. In the actual history, the in-silico off-target step is done with heuristic tools and then the real safety signal arrives from animal studies and clinical readouts — late, expensive, and for a population of one, potentially only once. The counterfactual moves the *computable* slice of that forward to before an animal or a patient, and freezes it as an artifact that can be re-run rather than re-argued. (ARGUMENT — nothing here was computed on any real drug sequence; the exact-versus-float behavior is MEASURED only on the synthetic demo above.)

This is not a leap of faith about scale, and that is the concrete part. An exact off-target enumeration against a pinned reference transcriptome or genome is a bounded, deterministic, re-derivable computation — the same *class* of work Affine.Earth already runs on molecular libraries at the 10⁵–10⁶ scale: 258,616 PDB structures and 125,302 protein/material aggregates hosted and re-derivably graded on the live court ([Study 14](Study-14-Protein-Lattice-Manifold)). A human transcriptome is a corpus of comparable order, and integer complementarity across it is a simpler operation than the structural grading already demonstrated. Ingesting a pinned reference — a specific GENCODE or RefSeq release, content-addressed so every re-run names the same bytes — is a defined engineering step, not a research problem. The distance between the synthetic demo and a real design-stage map is a corpus to ingest and a reference to pin, both of which the substrate has already shown it can carry. That is the excitement, and it is a sober one: the exact channel is not a someday capability waiting on a discovery — it is a build, at a scale that has already been reached, standing between a candidate sequence and the first person who will ever take it.

---

### What we claim / what we do not

**We claim:**
- The off-target complementarity question is discrete; exact enumeration within a stated tolerance yields a re-derivable, byte-identical candidate map (MEASURED on synthetic sequences; the rule is integer/discrete, VERIFIED; the enumeration scale REPORTED — Yoshida 2018).
- Off-target site enumeration at a stated tolerance is already accepted practice in this class and its CRISPR cousin (VERIFIED/REPORTED).
- At n=1 no trial can establish off-target safety, so a design-stage exact map is the right instrument for the one computable channel (ARGUMENT, grounded in FDA individualized-ASO framework).

**We do not claim:**
- That any binding number here was computed on a real drug — it was not; the demo is synthetic and the molecular court for a real sequence is DARK / a charter.
- That a complementarity map certifies a drug safe. It does not reach hydrocephalus, RNase H1 magnitude, immune/complement/PK, secondary-structure or protein-mediated off-targets, or idiosyncratic CNS risk.
- That the exact map ranks off-targets by binding strength — that is what the ΔG score adds; the exact map's contribution is a complete, parameter-free membership set, not a thermodynamic ranking.
- Any figure above its grade — n-Lorem's "no ASO-related SAEs" is REPORTED (peer-reviewed + sponsor), not independently adjudicated; jacifusen response is a REPORTED case series.

### Sources
- N1C consensus guidelines (27 individuals, Jan 2025) — *AJHG* 2025.
- n-Lorem cohort (>50 treated, >300 doses, >55 patient-years, no ASO-related SAEs) — *Nucleic Acids Research*, June 2026.
- Milasen — Kim et al., *NEJM* 2019 (10.1056/NEJMoa1813279).
- Programs — *MAPK8IP3*/NEDBA NCT07197294; *ATN1* NCT07084311; *PRPH2* NCT07177196; *TARDBP*-ALS NCT07095712; *CHCHD10*-ALS (NIH URGenT).
- Graduated cousins — Qalsody/tofersen FDA accelerated approval (2023); jacifusen *FUS*-ALS case series (OTS/Columbia).
- FDA individualized-ASO framework — FDA clinical guidance.
- Off-target science — Yoshida et al., *Genes to Cells* 2018; gapmer hepatotoxicity via long pre-mRNA, *NAR* 2016; LNA gapmer RNase H1, *Sci Rep* 2016; splice-switching hybridization off-targets, *NAR* 2020.
- CNS class risk — ASOs and hydrocephalus (CureFFI); KCNT1 ASO trial, Yu lab / *Nature Medicine* 2026; tominersen/HD (PMC).
- Adjacent modality — Musunuru et al., *NEJM* 2025 (baby KJ, CPS1).
- Substrate library scale — [Study 14](Study-14-Protein-Lattice-Manifold) (258,616 PDB structures; 125,302 protein/material aggregates on the live court).
- Exact-vs-float anchor — repository demo `reproduce/aso-offtarget-exact-vs-float.swift` (synthetic 20-mer; marker `ASO_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT`); fusion-court study on disk `Study-33-Fusion-Control-Verdict-Court.md` (observer axis Study 34, time axis Study 35).
