# The Drug That Rewrote the Blood of Two People, and the One Part of Its Safety Case a Computer Can Certify Before Anyone Is Dosed
### PM359 — prime-edited autologous CD34+ stem cells for p47phox chronic granulomatous disease
*An Affine.Earth shear study. Angle: SEAL. Compiled 2026-09-05 from primary public sources.*

---

## The people this is for

Chronic granulomatous disease is a failure of the body's first line of defense. The neutrophils and other phagocytes that swallow bacteria and fungi cannot finish the job — they cannot fire the "respiratory burst," the burst of reactive oxygen the NADPH oxidase makes to kill what they ingest. So the infections keep coming: pneumonias, liver and skin abscesses, swollen infected nodes. And because the same broken oxidase also fails to switch inflammation *off*, many patients carry a Crohn's-like colitis on top of the infections — a gut that inflames itself for no reason it can win. It affects roughly one person in 200,000, across populations. Behind that number are children whose parents learn to read a fever like a weather front, and adults who have spent a lifetime managing a body that cannot quite defend itself.

p47phox disease — a fault in the *NCF1* gene — is the gentler end of this illness, and it is worth being precise about what "gentler" means. It is autosomal recessive, and patients tend to keep more residual oxidase activity than those with the X-linked form, which is the single variable that most predicts survival across all of CGD: not which gene is broken, but how much oxidase you still make. Many p47phox patients reach adulthood — the two people treated with PM359 were 18 and 57. That is real, and it is the honest frame. It is also true that this is a lifelong disease of repeated infection, chronic gut inflammation, and cumulative organ damage, one whose historical mortality has run on the order of a few percent a year across CGD. Today's care — daily antibiotics, antifungals, interferon-gamma, immunosuppression for the colitis — holds the disease down. It has never fixed the oxidase.

## What just changed

In two people, PM359 fixed the oxidase itself — and so far the fix has held. In December 2025 the *New England Journal of Medicine* published the first clinical data reported from any prime-editing therapy in humans, and it was this one. For a field that has spent a decade promising to write single letters back into the human genome, this is the moment the promise met a patient.

The biology is unusually clean. The great majority of p47phox disease comes from a single recurring typo: a two-letter "GT" deletion at the start of exon 2 of *NCF1*, a frameshift that arises because the gene has near-identical pseudogene twins it recombines with. PM359 takes the patient's own blood stem cells, edits them in the lab to write those two letters back — turning `delGT` into the working `GTGT` sequence — and returns them after conditioning. The reading frame is restored; the full-length p47phox protein comes back; the oxidase works again. Two letters, put back where they belong, and a cell that had been broken since birth starts doing its job.

Prime editing is the reason this can be done without cutting the DNA in two. A nickase Cas9 fused to a reverse transcriptase, steered by a pegRNA, nicks a single strand and templates the correction directly onto it. And here is the mechanism that carries the whole study: writing a base this way requires **three** independent sequence matches at a site — the spacer/PAM must be recognized, the primer-binding site must hybridize to the nicked flap, and the reverse-transcriptase template must be complementary enough to be resolved. A plain Cas9 nuclease needs only the first of those. That extra structure is not cosmetic. In one published unbiased, genome-wide specificity assay, of 16 sites the matched Cas9 nuclease edited, a prime editor carrying the same spacer edited only 3 at all, and just 1 above the one-percent level.

The two patients bear the mechanism out. Corrected alleles reached 68% and 91% of their colony-forming cells. Within a month, functional neutrophils — measured by dihydrorhodamine at healthy-donor brightness — reached 69% and 83%, against a roughly 20% level thought sufficient for clinical benefit, and held stable through at least six months, including in the long-term stem cells that sustain the blood supply. Engraftment came in about half the usual time. One patient came off his colitis drug with no flares; the other's gut-inflammation marker fell substantially. No serious adverse events were traced to the cells. Every toxicity seen came from the busulfan used to condition the marrow — not the edit.

This is early: two patients, six months, no approval anywhere, though the FDA has granted Fast Track, Orphan, Rare Pediatric, and RMAT designations. Read the numbers as a strong first signal, not a track record. But a strong first signal is exactly the thing worth protecting — and the part of that protection a computer can carry, it should carry.

## The exact question, stated plainly

Here is the single part of PM359's safety case that is a discrete, exact, bounded object — and it is exactly the kind of object an enumerator owns.

**Where else in the genome could this pegRNA mis-edit?** The reference genome is a fixed string of about 3.1 billion bases. "Off-target" is not a mood; it is a set: the loci that satisfy *all three* prime-editing constraints at once — spacer/PAM match, primer-binding-site hybridization, RT-template complementarity — each within a stated tolerance for mismatches and bulges. That is a positional string-matching problem with a finite, listable answer. And for *this* edit the enumeration has a named worst case built in: because *NCF1* has near-identical pseudogene twins (NCF1B/NCF1C), those loci are the highest a priori off-target candidates, and they are precisely the sites an exact enumeration over the reference resolves rather than argues around.

Three things follow, and we assert them confidently:

- **It is provably no larger than a nuclease's danger set — and in practice far sparser.** A nuclease's off-target set is governed by one constraint; a prime editor's is the *intersection* of three. An intersection is a subset of any one of its members, so at matched tolerance this candidate set cannot exceed the spacer-only set — and the measured prime-editing specificity data show it collapsing far below that bound, often to near-empty. The mechanism guarantees the direction; the data show the size.
- **It is re-derivable.** Give the pegRNA and the genome build, and the set is deterministic. Anyone recomputes the same list. That is categorically different from a float-scored, thresholded off-target *predictor* whose ranking drifts run to run with its parameters. For a discrete set, an exact enumerator dominates a float scorer on the one axis a regulator cares about — reproducibility of the claim.
- **It is a design-stage artifact.** This can be computed and handed over as a re-derivable certificate *before a first patient is dosed*, not recovered from a one-off wet-lab assay that lives and dies with its reagents.

That the exact instrument genuinely beats a float scorer on this class of question is not asserted from taste — it is measured, out of domain, on the fusion court: Study 34 (the observer axis) and Study 35 (the time axis), and for nucleic-acid off-target specifically in the named `reproduce/crispr-guide-offtarget-exact-vs-float.swift` demonstration, marker `CRISPR_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT` — where the exact guide-search result is invariant to who runs it and when, while the float score is not. That demonstration was MEASURED on synthetic sequences; it screened no real drug. Those are the anchor. They are not a run on PM359.

## Where it goes silent

Say it plainly: the molecular court for PM359's actual pegRNA and genome coordinates is **dark — a charter, not a result.** No exact enumeration of *this drug's* real off-target set has been run or published here. The proper SEAL deliverable is to run the enumerator on the published sequence against the build, publish the candidate list and the tolerance, and let it be re-derived. Until then, "near-empty for PM359's specific guides" is a computation not yet done — not a finding.

**Question one: can the method speak to safety?** For most of what threatened these two patients, no. The adverse events came from busulfan — a chemistry and PK problem, with its organ toxicity, cytopenias, fertility cost, and long-tail malignancy risk — and no sequence enumerator touches it. On-target editing byproducts (indels at the nick, scaffold insertions, local rearrangements) are only partly enumerable; their *frequencies* are wet-lab measurements. Clonal drift and any leukemogenic risk from modified stem cells are longitudinal, stochastic, population-scale questions that two patients and six months cannot answer, and no computation substitutes for years of clonal tracking. Immunogenicity against the bacterial- and viral-derived editor is biology, not a string. So is manufacturing consistency. The instrument owns the off-target *locus set* and its sparsity — and stops there. "No off-target mutations detected" preclinically means the assay found none; it does not mean zero, and the enumerator bounds the candidates, not the per-locus rate.

**Question two: are there better options?** For p47phox, one established curative route exists today — allogeneic stem-cell transplant, with three-year overall survival of 85.7% and event-free survival of 75.8% in the largest series of 712 patients, best in the young with a well-matched donor. It is genuinely curative for many. It is also donor-gated and carries graft-versus-host disease and graft failure — the two burdens an autologous edited product structurally avoids. Lentiviral gene therapy is in development, further along for the X-linked form, earlier for p47phox; there is no approved gene therapy for any CGD. PM359's rationale — curative-intent, donor-independent, no double-strand break — is a real unmet-need position, on the strength of two patients and RMAT engagement, not a marketed history.

## Why this is worth licensing

The founder's economics are exact here. A re-derivable off-target certificate computed at the design stage costs a computation. A late off-target failure costs lives and burnt R&D. For a working pipeline drug with a positive early signal, this is not a marketing claim — it is decision support for the path forward, and it is the one slice of the safety case that regulators can re-run themselves rather than take on faith. That is the whole SEAL: certify the discrete, bounded, re-derivable part before Phase 1 scales, and be loud about which part it is not.

## From day one — what the substrate would have found

Run the counterfactual honestly. Suppose the exact instrument had been in the loop from the first morning PM359 was designed — the day someone chose the pegRNA that would write `delGT` back to `GTGT` — and pointed at the very same goal: a correction that never touches a site it was not meant to. What would it have produced?

A complete, re-derivable off-target map, at the *design* stage — before an animal, before a patient. The historical path leaned on heuristic guide-scoring tools whose rankings drift with their parameters, and then waited for wet-lab specificity assays and clinical readouts to tell it whether the design had been clean. The exact instrument inverts the order of trust. The day the sequence is fixed, so is the answer: enumerate every locus in the pinned reference that satisfies all three prime-editing constraints within the stated tolerance, hand the finite candidate list to a regulator, and invite them to recompute it themselves. The pseudogene twins NCF1B/NCF1C — the named worst case for this exact edit — appear in that list *by construction*, resolved rather than argued around. A design decision could have carried its own safety certificate from the hour it was made.

This is not speculative capacity, and that is the part worth sitting with. Affine.Earth already hosts and re-derivably grades molecular libraries at the 10⁵–10⁶ scale — 258,616 PDB structures and 125,302 protein/material aggregates on the live court ([Study 14](Study-14-Protein-Lattice-Manifold)). An exact off-target enumeration against a reference transcriptome or genome is the *same class* of bounded, deterministic, re-derivable computation, at a scale the substrate has already demonstrated. Ingesting a pinned reference build is a defined step, not a research problem. So the counterfactual is modest in what it asks and large in what it offers: nothing new had to be invented for this drug's off-target map to have existed on day one, in a form anyone could re-derive — and that is the future this opens for the next correction, and the one after it. *(ARGUMENT — nothing was computed on PM359's real sequence; grounded in the MEASURED synthetic demo above and in the demonstrated library scale of Study 14.)*

---

### What we claim / what we do not

**We claim, confidently —**
- Prime editing's off-target *candidate-locus set* is discrete, enumerable, provably no larger than the spacer-only set and in practice far sparser (three-constraint intersection), and re-derivable; for that sub-question an exact enumerator is the right and better instrument than a float scorer. *(Argument, grounded in verified mechanism and measured PE-specificity data.)*
- PM359 reported the first-in-human prime-editing clinical data: 2 patients, corrected alleles 68% / 91% of CFCs, functional neutrophils 69% / 83% by Day 30, stable ≥6 months, fast engraftment, no PM359-attributable SAEs. *(Measured / reported; n = 2.)*
- p47phox is the residual-oxidase, better-surviving end of CGD; allo-HSCT is the current curative standard (3-yr OS 85.7% in the 712-patient series). *(Verified / reported.)*

**We do not claim —**
- That the exact set has been computed for PM359's real guides. The molecular court for this drug is dark — a charter, no run here. *(Not known.)*
- That the method bounds conditioning toxicity, immunogenicity, on-target byproduct rates, clonal/leukemogenic risk, or manufacturing/PK. It does not. *(Out of domain.)*
- Any survival, cure, safety-proven, or approval claim for PM359. *(n = 2, ~6 months, investigational.)*
- The earlier 58% / 66% interim as current — superseded by the published 69% / 83%.

*The subject under grading is the safety instrument — not the medicine, the company, or any patient. PM359 gets a fair reading: a positive early signal, a well-chosen double-strand-break-free modality, and strong regulatory engagement.*

### Sources
- NEJM 2025 — Prime Editing for p47phox-Deficient CGD (NEJMoa2509807; PubMed 41358590)
- Prime Medicine / GlobeNewswire — NEJM publication release (7 Dec 2025); StockTitan (PRME)
- CRISPR Medicine News — first prime-editing therapy in CGD (superseded 58% / 66% interim; engraftment)
- Inside Precision Medicine — first prime-editing clinical results (68% / 91%; ages; ≥6 mo)
- CGTlive — PM359 IND clearance; delGT→GTGT; preclinical >90%
- ClinicalTrials.gov — NCT06559176 (Phase 1/2; UCLA site)
- Prime Medicine / GlobeNewswire; BioSpace — RMAT designation (22 Jun 2026)
- Kuhns et al., NEJM 2010 — Residual NADPH Oxidase and Survival in CGD (PMID 21190454)
- Chiesa et al., Blood 2020 — HCT in CGD, 712 patients
- Roos et al., Blood Advances 2019 — NCF1 (p47phox) genetic/flow analysis
- JPIDS 2018 — CGD epidemiology, pathophysiology, genetics
- Nucleic Acids Research 2020 — Unbiased investigation of prime-editing specificity
- Schejtman et al. — lentiviral gene therapy for p47phox CGD (preclinical); CGD Society — clinical trials
- Anchor (out-of-domain): fusion-court Study 34 (observer axis), Study 35 (time axis); `reproduce/crispr-guide-offtarget-exact-vs-float.swift` (marker `CRISPR_OFFTARGET_EXACT_IS_OBSERVER_INVARIANT`; MEASURED on synthetic sequences — screened no real drug)
- Library scale for the day-one counterfactual: fusion-court [Study 14](Study-14-Protein-Lattice-Manifold) — 258,616 PDB structures; 125,302 protein/material aggregates

**Bottom line for the path-forward decision:** PM359 is a legitimately promising, break-free, donor-independent correction for a disease whose only curative alternative is donor-gated and GVHD-bearing — on two patients and RMAT engagement, not a track record. The one part of its safety case that is discrete, exact, bounded, and re-derivable is the prime-editing off-target locus set, and on that the exact enumerator is the right instrument to SEAL before Phase 1 scales. It does not touch conditioning toxicity, immunogenicity, on-target byproduct rates, or long-term clonal risk, and it has not yet been run on PM359's real sequences — that court is a charter, not a result. Undersell and oversell are both errors here; the honest edge is naming exactly which half of the safety case the method owns — and building the half it owns from the first day of design, where it has always belonged.
