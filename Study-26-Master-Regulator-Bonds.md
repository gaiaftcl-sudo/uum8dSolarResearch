# Study 26 — Master Regulator Bonds

**Charter published 2026-08-26 and unchanged below. Corpus ingested and the gate run 2026-09-06 on seventeen tumour types. We did not set out to reach a number; we set out to measure one. Every one of the seventeen produced a finding, and all seventeen are published. The charter is what was asked; the Findings section is what the bytes answered.**

## The field's own measured surprise

In 2021 the Califano laboratory published a pan-cancer analysis in *Cell* reporting that **407 master regulator (MR) proteins** canalize the genetics of individual tumor samples from **20 TCGA cohorts** into **112 transcriptionally distinct tumor subtypes**, with the MRs organizing into **24 pan-cancer master regulator block modules (MRBs)**, and **more than 50% of somatic alterations detected in each individual sample** predicted to induce aberrant MR activity (Paull et al., *Cell* 184(2):334-351, 2021, PMID 33434495 — VERIFIED, abstract fetched from PubMed 2026-08-26; the abstract states no total tumor count, and this page prints none).

Set that against what the mutation counts themselves do. Across 92,439 analyzed tumor samples spanning 541 cancer types, the median tumor mutational burden was **3.6 mutations/Mb with a range of 0 to 1,241 mutations/Mb**, and type medians ran from **0.8** (bone marrow myelodysplastic syndrome) to **45.2** (skin squamous cell carcinoma) — a spread of three orders of magnitude across individual tumors (Chalmers et al., *Genome Medicine* 2017, PMC5395719 — VERIFIED, full text fetched). Within a single type the label does not pin the number: in soft tissue angiosarcoma the median was 3.8 mutations/Mb, yet 13.4% of cases carried more than 20 (VERIFIED, same source). Across 3,083 tumor/normal pairs, the median frequency of non-synonymous mutations varied by **more than 1,000-fold** across cancer types (Lawrence et al., *Nature* 499:214-218, 2013, PMC3919509 — VERIFIED, full text fetched). And in 2026 the MSK-IMPACT 50K analysis of 54,331 tumors from 48,179 patients across 448 histological subtypes reported that **one-third of all driver alterations arose in non-canonical contexts**, concluding that the functional role of a driver depends on the cancer type and clinical context in which it arises (Bandlamudi, Muldoon, de Bruijn et al., *Cancer Cell* 44(5), 2026, PMID 41895280 — VERIFIED via the Mount Sinai institutional abstract record).

The field's own summary of this landscape is Vogelstein's: a small number of "mountains" and a much larger number of "hills," with a typical tumor carrying **two to eight driver mutations** drawn from roughly **140 driver genes** that classify into **12 signaling pathways** regulating three core cellular processes — and the concession, in the same paper, that "Methods based on mutation frequency can only prioritize genes for further analysis but cannot unambiguously identify driver genes that are mutated at relatively low frequencies" (Vogelstein et al., *Science* 339:1546-1558, 2013, PMC3749880 — VERIFIED, full text fetched).

So the field's published position — the "tumor checkpoint" / "oncotecture" architecture (Califano & Alvarez, *Nature Reviews Cancer* 17:116-130, 2017, PMID 27977008 — REPORTED from the article listing, body not fetched) — is that tumors with wildly different mutational landscapes converge onto a small, conserved set of master regulator proteins whose aberrant activity maintains the tumor state. Mutation-burden reads are magnitude science: count the lesions. The master-regulator architecture is shape science: find the load-bearing bonds. That reframing is the field's, not this program's.

**The program's parallel, stated as the program's reading:** a load-bearing regulator set whose intactness maintains a state regardless of surrounding noise is, structurally, what this program calls a **bond** — the same object graded in [Study 14 — Protein lattice manifold](Study-14-Protein-Lattice-Manifold.md) and audited across the [Eclipse 2026 model-shear lineage](Eclipse-2026-Model-Shear.md). The house thesis applies unchanged: an adversary can copy the SIZE of a response (a mutation count, a burden per megabase) but cannot keep the forcing APPOINTMENT (which named regulators are active, in which named disease context, inverted by which named compounds). The mapping is an analogy that motivates a decidable test. **The test is what gets sealed. The analogy never is.**

This study claims no cure, and exists partly to show what a claim that is *not* a cure claim looks like: a network-shape claim on public, already-measured bytes, graded in exact strings and exact integers, published win and miss alike.

## Section zero — the discrimination gate

Before any biology is graded, the instrument must be shown able to fail. A scoring rule that any random protein set can satisfy is void before the first byte is scored — the program has already retired one instrument for exactly this defect, and an instrument that cannot distinguish is a turn counter, not a court.

**The score function, frozen here, verbatim, before any set is scored.** It is named first because a gate that does not name its score cannot be shown to discriminate:

> **σ(R, context)** = the integer count of regulators `r ∈ R` whose signed integer activity, computed by the S1 aggregation rule below, falls within the top **N** of the context's full regulator ranking. **N** is frozen at the published MR set's cardinality. Ties in the ranking are broken by HGNC symbol in ascending lexicographic order.

σ reads the context's own expression and regulon bytes and the integer N. **It does not reference the published MR set's identity anywhere** — that is the whole point, and the reason S4 is not scored on S1's overlap-with-the-published-set. A control arm graded on the published set's identity is green whatever the biology does, because a random set trivially misses a named list.

**The gate, in integers, frozen before any MR set is scored:**

- Draw **1,000** size-matched random regulator sets. Each is a uniform sample, without replacement, **from the regulators present in the frozen regulon file for that disease context** — not from all 19,297 HGNC protein-coding symbols. A random draw from the whole protein-coding space would fill nearly every set with symbols that carry no regulon, σ would be undefined or empty by construction, K = 10 would never be approached, and the gate would be always-green: the exact defect this section exists to prevent.
- **A drawn member with no regulon in the frozen file is not scored as zero.** Absence and zero are different answers. Such a member is recorded with the token `NO_REGULON`, its set is discarded and redrawn, and the total number of discards is published in the seal. No set is scored with an undefined member folded in as a nil contribution.
- Score every random set with the **identical** frozen σ applied to the published MR set (same expression signature, same regulon file, same rank quantisation, same integer threshold, same tie rule).
- **PASS:** at most **K = 10** of the 1,000 random sets score at or above the published MR set's σ. **FAIL:** 11 or more do.
- K = 10 is frozen here, in the charter, before any corpus byte is read. It does not move after scoring. A FAIL is published as a FAIL.

If the gate fails, every downstream criterion in this study is void for that disease context, and the page says so. The randomised sets are the control arm; a court that is never shown the healthy population cannot tell a cause from a coincidence.

## The two readings and where they disagree

| Reading | What it holds constant | The observation that separates it | Sourcing |
|---|---|---|---|
| **Mutation magnitude** — the tumor is its lesion count and lesion list | The count and the list | The identical exact key gives opposite answers in different contexts: BRAF V600E responds to vemurafenib in melanoma and barely in colon cancer, via EGFR feedback the mutation list never shows (Prahallad et al., *Nature* 483:100-103, 2012, PMID 22281684). Naive frequency reasoning also manufactures false positives — 101 of 450 "significant" lung-squamous genes were olfactory receptors (VERIFIED, PMC3919509). | REPORTED (Prahallad, abstract summaries); VERIFIED (Lawrence) |
| **Network shape** — the tumor is a maintained regulatory state; the MR set is load-bearing | The identity of the active regulator set | Protein-activity inference from regulons "outperformed mutational analysis in predicting sensitivity to targeted inhibitors" (Alvarez et al., *Nature Genetics* 48:838-847, 2016, PMID 27322546 — VERIFIED, abstract quoted verbatim from the fetched record). Sharpest case: reversible, chromatin-mediated drug tolerance with >100-fold sensitivity change and an *identical genome* before, during, and after — a mutation-list method has zero signal by construction (Sharma et al., *Cell* 141:69-80, 2010, PMID 20371346 — REPORTED). MEK-inhibitor resistance by kinome reprogramming in hours to days, no new mutation (Duncan et al., *Cell* 149:307-321, 2012 — REPORTED); gefitinib resistance by MET amplification re-reaching PI3K while the EGFR key is unchanged, 4 of 18 resistant specimens (Engelman et al., *Science* 316:1039-1043, 2007 — REPORTED). | VERIFIED / REPORTED as marked |
| **The null** — MR sets are descriptive summaries of expression with no causal load | Nothing; it predicts random size-matched sets score as well | This is what Section zero exists to test, and it is not a straw man. The prospective evidence is mixed on the record: in patient-derived xenografts, OncoTreat-predicted drugs achieved **91% 30-day disease control** and 15 of 18 induced the predicted MR-module inversion in vivo (Mundi et al., *Cancer Discovery* 13(6):1386-1407, 2023, PMID 37061969 — VERIFIED, abstract fetched; PDX disease control, not a human response rate) — while the flagship human trial of the predicted drug entinostat in neuroendocrine tumors enrolled 5 patients, terminated early, and **did not meet its primary endpoint**, with all 4 evaluable patients at stable disease and tumor growth rates at 17%, 20%, 33%, and 68% of pre-enrollment rates (Jamison et al., *The Oncologist* 29(9), 2024 — VERIFIED, PMC full text fetched). The null is retired only by the gate, never by citation. | VERIFIED as marked |

An independent benchmark also reported a GSEA-based regulator-enrichment method outperforming the VIPER algorithm in all but one of its experiments (RegEnrich, PMC8752721, 2022 — REPORTED), and the term "master regulator" itself is under published criticism as diluted ("When everything is a master regulator, nothing is," *Mol Biol Cell* 2025, PMC11974949 — REPORTED). Both belong on this table's null side of the ledger, and both are why the biology is graded here only as appointment-keeping, never assumed.

## The exact-key court

This study speaks only in exact string keys and exact integers, on the rails the program has already built:

- **Disease** = DOID key, joined to ICD via the xrefs the ontology itself carries — the [Study 16 — Disease type](Study-16-Disease-Type.md) rails. The frozen DOID artifact (release `2026-07-31`, downloaded and counted 2026-08-26 — VERIFIED) holds **12,247 active terms** of 14,762 stanzas, licensed CC0 by its own header.
- **Regulators** = HGNC symbol sets, backed by UniProt accessions. The frozen HGNC complete-set TSV: **45,045 approved rows**, of which **19,297 protein-coding** (VERIFIED, downloaded and counted 2026-08-26). UniProt release 2026_02 reports **20,431 reviewed human entries**, accession grammar `[OPQ][0-9][A-Z0-9]{3}[0-9]|[A-NR-Z][0-9]([A-Z][A-Z0-9]{2}[0-9]){1,2}` (VERIFIED, live REST headers).
- **Drugs** = InChIKey, 27 uppercase characters, the [Study 17 — Chemistry InChIKey](Study-17-Chemistry-InChIKey.md) rails — SMILES and float MW/logP are not the court. The LINCS metadata itself carries `inchi_key` and `pubchem_cid` columns (VERIFIED, file downloaded and header read 2026-08-26), so the chemistry rail joins to the perturbation archive with zero float arithmetic and zero name-matching. The one place a drug **name** enters this study is the OncoTreat comparison inside S3, and it is fenced behind a frozen, checksummed mapping rail declared below — never resolved ad hoc at scoring time. PubChem, holding **124,598,147** compound records (VERIFIED via NCBI einfo 2026-08-26), resolves any key anonymously.
- **Structures** = 4-character PDB ids, the [Study 14 — Protein lattice manifold](Study-14-Protein-Lattice-Manifold.md) rails (N = 258,616 holdings, law frozen and claim live).
- **Activity calls** are quantised to **integer rank ordinals**. Identity is decided by exact string equality — never by multiplying or dividing floats. **Three crossings into that exactness exist, and each is declared at its own site in the frozen law below** — one integer-to-integer quantisation and two genuine float-to-exact reads. None is left implied.

The court that accepts these keys already exists in public. The Affine Math Court is live on Glama — open MCP endpoint `https://affine.earth/language-invariant/mcp`, registry `earth.affine/math-court`, connector `https://glama.ai/mcp/connectors/earth.affine/affine-earth-math-court-remote` — with 21 public tools and court domains that already include disease, chemistry, materials, PDB, and health. The wire is decimal strings: a JSON Float64 is refused at the door, and `verify_jordan_bond` returns `AFFINE_JZ_SHEAR_ZERO` on a uniform lock. See [the Math Court on Glama](Affine-Math-Court-Glama.md) and the [Math Court user guide](Math-Court-User-Guide.md).

One warning is promoted to law here rather than buried in limits: of the 12,328 genes in an L1000 profile, only **978 landmark genes are physically measured**; roughly 11,350 (about 92% — arithmetic on the platform's own figures, REPORTED) are computationally inferred from the landmarks. **This study's court scores only the 978 measured landmarks.** The inferred genes are a model's output, not an observation, and a court whose doctrine is exact integers on public raw bytes does not seat a model's output as evidence.

## The response archive

Every input is retrievable without an account, anonymous, and checksummable; one carries a non-commercial license term, stated in its own row. All entries verified live on 2026-08-26 unless marked REPORTED.

| Source | URL | Format / keys | Version / cadence | Auth | Sourcing |
|---|---|---|---|---|---|
| TCGA open expression (GDC) | `https://api.gdc.cancer.gov/data/<uuid>` | STAR gene counts TSV; Ensembl `gene_id` + HGNC `gene_name`; integer `unstranded` column is the court, TPM/FPKM floats excluded | Data Release 46.0 (2026-08-10), API 8.5.0; md5 per file in manifests | None — 11,505 open files of this type, 0 controlled; a 4,244,281-byte file fetched anonymously | VERIFIED |
| GDC open somatic mutations (S2's mutation rail) | `https://api.gdc.cancer.gov/data/<uuid>`, `data_type = "Masked Somatic Mutation"` | MAF (gzipped TSV); `Hugo_Symbol` + `Entrez_Gene_Id` are the exact-string join to HGNC; integer `Start_Position` / `End_Position`; no float column enters the court | Data Release 46.0 (2026-08-10); `md5sum` returned per file by the files endpoint | None — **24,498 open** files of this type against 2,268 controlled, of which **10,640 open within the TCGA program**; one 39,235-byte MAF fetched anonymously and its md5 `57d08529…218106` reproduced byte-exact | VERIFIED (live API query + download 2026-08-26) |
| LINCS L1000 Phase I | `https://ftp.ncbi.nlm.nih.gov/geo/series/GSE92nnn/GSE92742/suppl/` | Level 5 GCTX (HDF5), **473,647 signatures x 12,328 genes**; sidecar TSVs incl. `pert_info` (51,383 perturbagens counted: 20,413 `trt_cp` compounds with InChIKey column). **Level 5 values are float moderated z-scores** — see Crossing B | Frozen 2017-03 vintage; `GSE92742_SHA512SUMS.txt.gz` for byte-exact verification | None | VERIFIED |
| LINCS L1000 Phase II | `https://ftp.ncbi.nlm.nih.gov/geo/series/GSE70nnn/GSE70138/suppl/` | Level 5 GCTX, **118,050 x 12,328** (combined open Level 5 corpus: 591,697 signatures); float values as above | Frozen 2017-03-06 vintage; own SHA512 manifest | None (the clue.io 2020 build is registration-gated and is NOT a rail here) | VERIFIED |
| ARACNe regulons | Bioconductor `aracne.networks` v1.38.0 (Bioc 3.23), DOI 10.18129/B9.bioc.aracne.networks | **25 regulon objects**, not 24: `data/` holds 25 `regulon*.rda` with 25 matching `man/*.Rd`. **24 are TCGA cohort codes** (blca…ucec) that are also GDC project ids; the 25th, `regulonnet`, is the **GEP-NET neuroendocrine interactome** (Alvarez et al. 2018 cohort) and is **not a TCGA cohort code and has no GDC project** — see S1. Regulator→target edge lists, Entrez ids mapped 1:1 to HGNC; `write.regulon()` exports flat text a court can hash. **Upstream inconsistency, declared:** `data/datalist` names a 26th object, `regulonskcm`, for which no `.rda` and no man page exist in the release — S5 names it so a byte-exact seal does not read it as corpus damage | Package release cadence; manual dated 2026-08-25; RELEASE_3_23 cloned and counted 2026-08-26 | None to fetch, **but `file LICENSE` is a Columbia University software evaluation license** — non-commercial, non-profit/academic/educational research only, no redistribution. The caution before commercial-adjacent use stands, and it is a license term, not a suspicion | VERIFIED (package, manual, 25-object list, license text — clone read 2026-08-26) |
| HGNC symbols | `https://storage.googleapis.com/public-download-files/hgnc/tsv/tsv/hgnc_complete_set.txt` | TSV, 16,948,051 bytes; `hgnc_id`, `symbol`, `ensembl_gene_id`, `uniprot_ids` columns are the joins | Monthly snapshots archived in the same bucket; old EBI FTP path now 404 | None | VERIFIED |
| Disease Ontology | `http://purl.obolibrary.org/obo/doid.obo` | OBO, 7,192,337 bytes; DOID keys + ICD/OMIM/MeSH xrefs | Pinned in-file: `releases/2026-07-31`; CC0 license in header | None | VERIFIED |
| UniProt | `https://rest.uniprot.org/uniprotkb/` | Accession strings; counts via `X-Total-Results` header | Release 2026_02 (2026-06-10) via `X-UniProt-Release` header | None | VERIFIED |
| PubChem | `https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/<KEY>/cids/JSON` | InChIKey → CID round-trip | Live; 124,598,147 compounds | None | Count VERIFIED; PUG pattern REPORTED |

What stays controlled at GDC — raw BAM/FASTQ, germline calls, certain clinical elements under dbGaP phs000178 — is **never needed** by this court. Counts, masked somatic mutations, clinical, and biospecimen are open (policy quotes REPORTED from the fetched GDC access page; the open/controlled split of both expression and mutation files independently VERIFIED by live API query). The controlled-access boundary is respected by construction: the law below reads no byte a stranger cannot read.

**The one hand-made rail, named because it is not a public byte.** S3 compares an exact InChIKey set against OncoTreat's published rankings, and those rankings are REPORTED paper content keyed by **drug names**, not InChIKeys. A name is not an exact key, and resolving one at scoring time would be exactly the non-exact join this court forbids. So the mapping is pinned as a rail: a `paper_drug_name → pert_iname → inchi_key` table, transcribed once from the named tables of the named papers, joined only to the `pert_iname` and `inchi_key` columns of the frozen `pert_info` file whose SHA512 is already in the GEO manifest, then **checksummed and published in the corpus before any scoring**. Every row is auditable against the two public artifacts it sits between. A paper name that does not resolve to exactly one InChIKey is **not guessed**: it is published in an exact `UNRESOLVED` list, frozen with the rail, and excluded from both sides of the S3 count. This is the only artifact in the corpus this program mints rather than fetches, and it is declared here rather than discovered later.

The upstream regulon values (`tfmode`, `likelihood`) ship as floats in the R distribution (VERIFIED from the package manual). `likelihood` is refused outright. `tfmode` is **not** refused — its sign is read, and reading the sign of a float is a float-to-exact conversion, not a refusal of one. It is declared as Crossing C below and performed exactly once, at load time.

## The frozen law (to be sealed at corpus stage)

Drafted here; frozen verbatim, with every integer bound to a named release string, before the first byte is scored. Every criterion below is decidable by string equality and integer comparison on public bytes.

**The declared crossings — three, each at its own site, each performed once.** The earlier draft of this charter declared a single crossing and named the wrong one; both statements are corrected here on the page's own text:

- **Crossing A — GDC counts → rank ordinals (S1, S2).** Integer `unstranded` read counts to integer per-sample gene rank ordinals. This is **integer-to-integer**: a quantisation, not a float crossing. Frozen tie rule: tied counts all take the **minimum** ordinal of their tied block (competition ranking); residual ties by HGNC symbol ascending.
- **Crossing B — LINCS Level 5 → rank ordinals (S3).** Level 5 GCTX values are **float moderated z-scores**, so obtaining "measured landmark-gene rank ordinals" is a genuine float-to-exact conversion. It is declared here, performed once at read time, by a frozen rule: rank within the **978 measured landmarks of that signature only**, competition ranking as above, residual ties by HGNC symbol ascending. No float survives this step into any comparison, sum, or seal.
- **Crossing C — regulon `tfmode` → sign token (S1, S2, S3).** `tfmode` is a float and extracting its sign is a read of that float. Declared here, performed once at load time, by a frozen rule: `tfmode > 0 → "+"`, `tfmode < 0 → "−"`, `tfmode == 0 → "0"` recorded as its own token and **never folded into either sign**. `likelihood` is refused entirely and never read.

After A, B, and C the court is exact set arithmetic and integer comparison, end to end.

**The S1 derivation rule, frozen verbatim** — named here because "top-N regulators by integer rank" is not a rule until its aggregation operator, sample universe, and tie rule are written down:

> **Sample universe:** the frozen list of GDC file UUIDs for that cohort — open STAR gene-count files, primary-tumor aliquots, one file per case selected by ascending UUID string order. The list and its md5s are named in the seal.
> **Per-sample ordinals:** Crossing A.
> **Per-sample regulator activity:** for regulator `r`, the signed integer sum over its regulon targets of `(+ordinal)` where the Crossing C token is `"+"`, `(−ordinal)` where it is `"−"`, and **no contribution** where it is `"0"` (a `"0"` target is recorded, not silently dropped).
> **Cohort aggregation operator:** the **integer sum** of per-sample activities across the frozen sample universe. Summation, never a mean — no division, so no float can enter.
> **Ranking:** regulators ordered by that integer, descending; ties by HGNC symbol ascending.

- **S1 — Regulon recovery.** For each disease context (DOID key, TCGA cohort code), the published MR set for that context must re-derive from the public regulon file plus open GDC integer counts as the **top-N regulators by integer rank** under the rule above, N frozen at the published set's cardinality. PASS: |published set ∩ derived top-N| ≥ **M**, M frozen per context at corpus stage as an exact integer, before scoring. Identity by HGNC symbol string equality only. **The regulon-to-GDC-cohort join is 24-of-25, not 25-of-25:** `regulonnet` is a GEP-NET interactome with no GDC project id, so it carries no GDC sample universe, is **excluded from S1 and S2**, and appears only in S3's neuroendocrine context where its cohort is the Alvarez et al. 2018 GEP-NET cohort and not a GDC project. That exclusion is frozen here, not decided at scoring time.
- **S2 — Subtype appointment.** For each frozen pair of subtypes within a cohort, the MR-set identity must separate the pair where the mutation list does not: |MR(A) Δ MR(B)| ≥ **m₁** (symmetric difference, exact set op on symbol strings) while the top-**t** mutated-gene lists of A and B overlap by ≥ **m₂** of t. The mutated-gene lists are derived from the **open GDC Masked Somatic Mutation MAFs** named in the archive table — frozen file UUID list plus per-file md5 in the seal, genes taken by exact `Hugo_Symbol` string, ranked by integer mutated-case count with ties by symbol ascending. All of m₁, m₂, t frozen per pair before scoring. Both readings graded by the same exact set operations — the magnitude adversary is separated on SHAPE and IDENTITY, never on magnitude.
- **S3 — Inversion lookup.** Over the **already-measured** LINCS Level 5 signatures (the 591,697 frozen GEO signatures; `trt_cp` rows with a non-empty `inchi_key` only), the drugs whose measured landmark-gene rank ordinals (Crossing B) invert the MR set's direction at a frozen integer ordinal threshold form an **exact intersection set of InChIKeys**. That set is compared against OncoTreat's published rankings as REPORTED ground truth (Mundi et al. 2023; Alvarez et al. 2018 GEP-NET: 212 tumors, 107 compounds — REPORTED), joined **only** through the frozen, checksummed name→InChIKey rail described above, with its `UNRESOLVED` list excluded from both sides. PASS/FAIL is an integer overlap count against a frozen bound. This is a lookup over measured bytes. It ranks what was measured; it predicts nothing unmeasured, and it replaces no trial.
- **S4 — The discrimination gate** of Section zero: at most **K = 10** of 1,000 size-matched random sets — drawn from the regulators present in that context's frozen regulon file — may score at or above the published MR set under the frozen σ. K and σ are already frozen by this charter.
- **S5 — Byte identity.** Every scored file's checksum matches the published manifest (GEO SHA512, GDC md5 for both counts and MAFs), the minted name→InChIKey rail matches its own published checksum, and every release string (GDC 46.0, GEO 2017 vintages, HGNC snapshot date, DOID `releases/2026-07-31`, UniProt 2026_02, aracne.networks 1.38.0) is named in the seal. The seal records **25 regulon objects present** and the `datalist`-named-but-absent `regulonskcm` as a declared upstream inconsistency, so a stranger reproducing the corpus reads the discrepancy as upstream, not as damage. A stranger with curl reproduces the corpus byte-exact or the seal does not stand.

The honest, sharp statement of what S3 buys — and all it buys: once master-regulator sets and drug perturbation signatures are held as exact keys over already-measured public perturbation data, asking "which measured perturbations invert this regulator set" becomes an **exact set-intersection lookup instead of a statistical screen** — a decidable query over measured bytes. Nothing more is claimed.

## What this protects — people, ecology, and the planet

Patients are failed by irreproducible computational-oncology claims, and the failure is measured, not rhetorical. The signature-inversion field's own reproducibility audit found that querying the second Connectivity Map with signatures derived from the first re-identified the queried compounds at a success rate of **17%** — "Low recall is caused by low differential expression (DE) reproducibility both between CMaps and within each CMap" (Lim & Pavlidis, "Evaluation of connectivity map shows limited reproducibility in drug repositioning," *Scientific Reports* 11(1):17624, 2 September 2021, doi 10.1038/s41598-021-97005-z, PMID 34475469 — VERIFIED, figures and quote reproduced from the PubMed abstract; the per-cell-line 29%–58% range is REPORTED only).

The Broad's own audit of its perturbation archive found that of the **924 shRNAs** targeting the same genes with significant on-target projection ranks — the subset the paper built for direct comparison against CRISPR — **only 41.8% had a larger on-target than off-target component**, against **97.4%** on-target dominance for the CRISPR sgRNAs. The study profiled roughly 13,000 shRNAs overall; **41.8% is measured on the 924-shRNA comparison subset, not on the full archive**, and this page prints the figure only against its own denominator (PMC5726721 — VERIFIED, full text fetched; denominator corrected 2026-08-26). The qualitative finding — that shRNA signatures are heavily seed-driven where CRISPR signatures are not — is what carries into the law below; the archive-wide rate is not established by that measurement and is not asserted here.

And CRISPR re-validation showed the mechanism of action of 10 drugs already in clinical trials — involving roughly 1,000 patients — was mischaracterized: the named target was not the operative target (Lin et al., *Science Translational Medicine* 2019, PMID 31511426 — REPORTED).

Pre-registration plus exact keys plus public corpora is the repair this program can actually contribute: a network claim becomes checkable by a stranger with a terminal. The complete pipeline a stranger runs is public end to end — curl open TCGA counts and open masked-somatic-mutation MAFs from `api.gdc.cancer.gov`, install the public regulon and scoring packages from Bioconductor, derive the MR calls, name every regulator by HGNC symbol, verify every input byte against a published checksum (VERIFIED for the data path; the scoring-package provenance REPORTED). No account and no privileged data anywhere. **One license term, stated rather than waved past:** `aracne.networks` carries Columbia's non-commercial software evaluation license, so the stranger installs those bytes from Bioconductor under that license rather than receiving them from us, and commercial-adjacent use is outside what the license grants.

When the claim misses, the miss is published on this wiki with the same prominence as a win — that is the program's standing practice, and it is the part of reproducibility that costs something.

The same discipline protects the commons downstream: public archives (GEO, GDC, HGNC, DOID, UniProt, PubChem) are a shared scientific resource, and a court that pins release strings and checksums exercises them as archives rather than treating them as a mutable backdrop. Nothing here consumes a wet lab, an animal, or a patient; the entire study is a re-reading of what has already been measured and published.

## Honest limits

- **Not a treatment, not medical advice, not an efficacy result.** The program precedent is [Study 20 — Rife frequency](Study-20-Rife-Frequency.md), wiki label verbatim: **"test claim, not efficacy."** Study 26 grades a network-shape claim on public data. This page does not claim a cure and grades nothing that could establish one.
- **Computation replaces no laboratory and no trial.** S3 ranks already-measured perturbations by exact intersection. It predicts nothing unmeasured. The one human trial of the flagship predicted drug did not meet its primary endpoint (VERIFIED above), and that fact sits in this charter's own evidence table.
- **The biology is not this program's discovery.** That network/protein-activity state can outperform mutation lists is already published and validated in vitro (Alvarez et al. 2016 — VERIFIED), and the move from gene-centric to context-aware framing is the field's own 2026 conclusion (Bandlamudi et al. — VERIFIED). What Study 26 contributes is the grading discipline: law frozen before scoring, identity by exact string, integers on public raw bytes, miss published beside win.
- **Regulon inference is statistical upstream of our exact crossings.** ARACNe (Margolin et al., *BMC Bioinformatics* 2006, PMID 16723010 — VERIFIED) is mutual-information network inference; it requires large cohorts, leaves orphan tissues without matched interactomes (metaVIPER exists to work around exactly that — REPORTED), and an independent benchmark reported a competing method outperforming VIPER in all but one experiment (REPORTED). The court inherits these upstream statistics and declares them, exactly as it declares Crossings A, B, and C at their own sites rather than as one implied crossing.
- **One rail is minted, not fetched.** The `paper_drug_name → pert_iname → inchi_key` mapping behind S3's OncoTreat comparison is transcribed by this program, not downloaded from an archive. It is frozen and checksummed before scoring, published in the corpus row by row, and its `UNRESOLVED` names are excluded from both sides of the count — but it is the one artifact in this study a stranger audits rather than re-downloads, and it is named here for that reason.
- **MR causality is the field's claim.** It is graded here only as appointment-keeping — does the named set re-derive, separate, and invert on schedule — never assumed. The "master regulator" term itself is under published definitional criticism (REPORTED above), which is one more reason the court grades named sets, not the word.
- **Known false-positive modes are carried in the law, not footnoted:** 92% of the L1000 gene space is inferred, so the court scores landmarks only; on the 924-shRNA comparison subset **58.2% did not show a larger on-target than off-target component**, so `trt_cp` compound rows with InChIKeys are the S3 universe and no shRNA row is seated as evidence — the archive-wide seed-domination rate is not established by that measurement and no criterion depends on it; drug-target annotations have a measured error rate on trial-stage drugs, so no target annotation is load-bearing anywhere in S1–S5.
- **What a measurement shows versus what it licenses:** the long-tail sources show that the *set of mutated genes* differs markedly between tumors sharing a subtype label and that most *driver genes* sit in the low-frequency tail. They do not license the claim that most tumors lack a common driver, and this charter does not make it (guardrail VERIFIED as a negative result against PMC6336235).
- **Controlled-access boundaries are respected by construction** — the law reads open bytes only, expression and somatic mutations alike.
- **Claim posture.** Under 21 CFR 801.4, intended use is decided by objective intent as shown in written statements (VERIFIED, regulation text fetched from Cornell LII) — which means this page's own wording is the boundary. The wording is: this study *scores agreement with published measurements* and *grades shape and identity*. It does not recommend, indicate, diagnose, select a therapy, or address any patient. It is research output, not for use in diagnostic procedures, with no clinical validation performed or claimed. The current FDA clinical-decision-support guidance was reissued 2026-01-06 (VERIFIED via two independent legal analyses; the FDA primary PDF was unreachable this session), and the conservative reading — genomic-input decision software remains device-regulated — is adopted here by staying entirely outside decision support.

## Cross-links

- [Study 14 — Protein lattice manifold](Study-14-Protein-Lattice-Manifold.md) — the structures rail: 4-char PDB ids, N = 258,616 holdings, law frozen, claim live.
- [Study 16 — Disease type](Study-16-Disease-Type.md) — the disease rail: ICD/DOID industry keys; generated labels do not WIN; does not treat health as a pocket.
- [Study 17 — Chemistry InChIKey](Study-17-Chemistry-InChIKey.md) — the drug rail: the 27-character key is the identity; SMILES and float MW/logP are not the court.
- [Study 20 — Rife frequency](Study-20-Rife-Frequency.md) — the medical-scoping precedent: test claim, not efficacy.
- [Affine Math Court on Glama](Affine-Math-Court-Glama.md) — the live court that already accepts disease, chemistry, and PDB keys on a decimal-string wire.
- [Eclipse 2026 — Model shear](Eclipse-2026-Model-Shear.md) — the shape-versus-magnitude lineage this study extends into biology.
- [Shear Studies Index](Shear-Studies-Index.md) — the program board, Studies 01–26.

## Data availability — measured 2026-08-27

- **TCGA via GDC open API: SERVED, anonymous.** `api.gdc.cancer.gov/status` reports Data Release 46.0 (2026-08-10); a filtered files query returned 1,231 open-access TCGA-BRCA gene-expression files; a real file answered an anonymous range request with genuine GENCODE-v36 TSV content.
- **LINCS: one door gated, one open.** `api.clue.io` refuses without a user key (HTTP 401 — recorded as GATED; this study does not route through it). The open door is GEO series GSE92742 at `ftp.ncbi.nlm.nih.gov` — directory listable, all 18 supplementary files served, SHA512SUMS present; the Level-5 signature matrix is 20 GB and the metadata sidecars under 25 MB were fetched as proof. The regulon corpus ingest is unblocked through the open doors only.

**Status: FINDINGS SEALED 2026-09-06** — S1 (regulon recovery), S3 (inversion lookup) and S5 (byte identity) all run and published, with every control; S2 (subtype appointment) ruled NOT RUNNABLE, with the blocker measured and shown. — the corpus was built from public bytes, the frozen gate ran on seventeen tumour types, and every finding is published below with the exact probability that produced it. Two defects in our own instrument were found and fixed along the way, and both are recorded. The cardiovascular readouts ride along as a second disease context, graded REPORTED, with the shape law frozen now and the tables to be scored when the congress releases them.

---

# Findings — sealed 2026-09-06

The charter above was written first and is unchanged. What follows is what the bytes said.

## What was built

Everything here was assembled from public sources: no account, no institutional login, no
data-use agreement, no key. The corpus is the first result, because until it existed there was
nothing to argue with.

| piece | what it is | scale |
|---|---|---|
| Regulatory network | the published ARACNe regulons, read out of their own archives | 25 context files · **6,172 distinct regulators · 151,308 regulator-context pairs · 12,017,368 edges** — 7,166,882 activating, 4,850,486 repressing, and **zero** carrying the third sign token, a branch that therefore never fired |
| Patient RNA | GDC open Primary Tumour STAR integer counts, one file per case, selected by ascending UUID so the choice is not ours | frozen universe **8,900 files · 35.12 GB** across 24 cohorts; **7,673 patient samples** in the 17 actually scored |
| Identity rail | HGNC approved symbols, with previous-symbol and alias resolution | 45,045 approved rows, 19,297 protein-coding |
| Independent networks | six regulatory networks **nobody derived these master-regulator sets from** | ARCHS4 and GTEx co-expression; TRRUST literature-curated; ReMap, ENCODE and Literature ChIP-seq |
| Transcriptome | GENCODE v50, for the exact off-target screen | 670,670 transcripts, sha256 `5a320f52…` |

**Seventeen tumour types** carry both a published master-regulator set and enough open expression
to score. Three carry a published set and no scoreable open counts — `laml`, `lgg`, `skcm`. They are named
rather than dropped quietly, and the measured reason for each is given below.

## First, the instrument had to prove it can fire

A gate that cannot fire is not a gate; a gate that fires on everything is the same defect wearing
the other face. So before any published set was scored, the scoring rule was made to prove — on
data, not in prose — that it can tell something from nothing.

Sort a tumour type's patients by barcode and deal them into two halves, alternating: no
randomness, no choice of ours. Rank every regulator on **half the patients**. Take the top 141.
Then recompute the ranking on the **other half — different people, different tumours, never seen
by the first ranking** — and ask how many of the 141 are still there.

| tumour type | reproduced across disjoint patients | same set, gene labels permuted | chance |
|---|---|---|---|
| bladder | **138 / 141** | 0 | 3.36 |
| breast | **138 / 141** | 2 | 3.47 |
| colon | **137 / 141** | 4 | 3.36 |
| glioblastoma | **136 / 141** | 1 | 3.29 |
| head & neck | **140 / 141** | 2 | 3.37 |
| kidney clear cell | **139 / 141** | 3 | 3.39 |
| liver | **137 / 141** | 0 | 3.33 |
| lung adenocarcinoma | **138 / 141** | 1 | 3.37 |
| lung squamous | **138 / 141** | 1 | 3.38 |
| ovary | **138 / 141** | 4 | 3.36 |
| pancreas | **136 / 141** | 1 | 3.29 |
| prostate | **141 / 141** | 0 | 3.43 |
| rectum | **137 / 141** | 1 | 3.29 |
| sarcoma | **135 / 141** | 2 | 3.3 |
| stomach | **138 / 141** | 2 | 3.3 |
| thyroid | **137 / 141** | 1 | 3.45 |
| uterus | **140 / 141** | 0 | 3.31 |

It is worth stopping on this, because it is the kind of number that is easy to read past. A
ranking built from two hundred strangers' tumours, carried across to two hundred *different*
strangers' tumours, agrees on **135 to 141 of 141 proteins** — and it does that in every one of the seventeen
tumour types, prostate landing on a perfect 141 of 141. Shuffle the gene labels, so the same arithmetic runs on the same matrix with the
biology removed, and it collapses to one or two. Sometimes to zero.

That is a sharp instrument. **This is the load-bearing fact for everything below:** when the same
instrument later reads chance on a published master-regulator set, that reading is a fact about
the set, not a failure of the measurement. We proved it could fire before we asked whether it did.

## The result

### S1, run exactly as chartered

Rank every regulator by activity computed from patient expression, take the top N where N is the
published set's own size, count the overlap, and ask whether 1,000 size-matched random sets can
reach it — at most K = 10 may.

**In twelve of seventeen tumour types the overlap clears that null.** That is the published
architecture standing up on public data under its own frozen test, and it is a real finding.

Then we asked the question the charter's null was too weak to see: **is it the expression data
doing the work?**

Because these are not ordinary proteins in this network. Their regulons are large — a median of
**127 targets against a pool median of 69** — and a large regulon is easier to rank highly for
reasons that have nothing to do with any patient. So the same law was run again with the
expression matrix **never opened**, ranking regulators by regulon size alone.

That arm was expected to be a floor. It is not — and that, rather than any pass or miss, is the
finding this study turns on.

### The exact probability, computed rather than sampled

`reproduce/mr-topology-vs-expression-exact.swift` answers this without sampling at all. The
chartered gate draws 1,000 random sets and counts; that is an estimate, and estimates move when
the seed moves. Under the uniform null the same quantity has a closed form — the hypergeometric
upper tail — and it can be evaluated in **exact integer arithmetic**, where it does not move on
any machine, ever.

The program carries the numbers as base-10⁹ big integers, builds C(5923, 141) — a **288-digit
integer** — exactly, sums the tail exactly, and compares the two arms by their numerators, which
share a denominator and so need no division at all. There is no `Double` anywhere on the decision
path. The decimals it prints are rendered from the exact rational by integer comparison; nothing
is ever rounded into a verdict. It checks itself first on values a reader can verify by hand —
C(10,3) = 120, C(52,5) = 2,598,960, C(100,50) = 100891344545564193334812497256, and a tail that
must sum to its own denominator — and if any of those fail it prints nothing else and stops.

| tumour type | pool | N | σ from **expression** | σ from **edge count alone** | P(≥σ) expression | P(≥σ) topology | |
|---|---|---|---|---|---|---|---|
| bladder | 5,923 | 141 | 21 | 16 | 9.138e-12 | 1.725e-7 | expression adds |
| breast | 5,735 | 129 | 9 | 7 | 2.346e-3 | 2.566e-2 | expression adds |
| colon | 5,913 | 118 | 7 | **18** | 8.968e-3 | **1.014e-11** | topology explains |
| glioblastoma | 6,050 | 118 | 10 | **14** | 9.003e-5 | **5.036e-8** | topology explains |
| head & neck | 5,896 | 140 | 6 | **14** | 1.151e-1 | **4.756e-6** | topology explains |
| kidney clear cell | 5,861 | 86 | 7 | 6 | 2.409e-4 | 1.540e-3 | expression adds |
| liver | 5,977 | 56 | 1 | 2 | 4.111e-1 | 9.636e-2 | topology explains |
| lung adenocarcinoma | 5,900 | 233 | 38 | **56** | 2.271e-14 | **4.190e-30** | topology explains |
| lung squamous | 5,889 | 55 | 4 | 5 | 1.631e-3 | 1.440e-4 | topology explains |
| ovary | 5,921 | 256 | **60** | 46 | **2.685e-29** | 2.104e-17 | expression adds |
| pancreas | 6,036 | 148 | 25 | 26 | 7.737e-15 | 7.763e-16 | topology explains |
| prostate | 5,792 | 68 | 3 | 4 | 4.514e-2 | 8.053e-3 | topology explains |
| rectum | 6,039 | 135 | 14 | 17 | 1.506e-6 | 5.470e-9 | topology explains |
| sarcoma | 6,030 | 68 | 7 | 8 | 9.526e-6 | 7.421e-7 | topology explains |
| stomach | 6,021 | 147 | 22 | 27 | 4.338e-12 | 5.458e-17 | topology explains |
| thyroid | 5,758 | 28 | 0 | 0 | 1.0 | 1.0 | neither recovers |
| uterus | 5,998 | 73 | 3 | 2 | 5.875e-2 | 2.227e-1 | expression adds |

**In eleven of seventeen tumour types, counting a regulator's edges recovers the published
master-regulator set at least as significantly as reading the patient's expression data does.**
In head and neck cancer the gap is not subtle: edge count reaches p = 4.8 × 10⁻⁶, while the full
expression-based ranking reaches p = 0.115 and does not clear significance at all.

Five go the other way — bladder, breast, kidney, ovary, uterus — and **in ovary the expression arm
is twelve orders of magnitude ahead of topology.** That is a real signal and it is not being
argued away. Thyroid recovers nothing in either arm, which is also a finding: it says the question
is not answerable in that tumour type on this corpus, and it is recorded as evidence for neither.

The program's own summary, verbatim:

```
TOPOLOGY_EXPLAINS: 11 of 17 tumour types
EXPRESSION_ADDS  : 5 of 17 tumour types
TIE              : 0
NO_RECOVERY      : 1  (neither arm recovered anything; evidence for neither)

MARKER  MR_TOPOLOGY_VS_EXPRESSION__EXACT_TAIL_IS_OBSERVER_INVARIANT
sha256  d0051d7a19daa0cb7f1a3d4f7be7433af73401bbf25fe41079f6409c066fee5a
```

### S1′ — the same question with size removed exactly

**S1′ is registered here as a separate named test. S1 is not edited, and its result above stands
as run.** S1′ changes exactly two declared things: each ordinal is centred (`2·ordinal − (G+1)`,
an exact integer, so a randomly chosen target contributes zero in expectation), and each regulator
is ranked by the exact rational `activity / regulon size`, compared by cross-multiplication of
integers. A large regulon can no longer win for being large.

| | clears the uniform null | clears the degree-matched null |
|---|---|---|
| **S1** as chartered | **12 / 17** | 3 / 17 |
| **S1′**, size removed | 1 / 17 | **1 / 17** |

The one context that survives every null in both laws is **ovary**: σ = 60 under S1 and 26 under
S1′, with zero of 1,000 random sets reaching it under either null.

## The network swap — the control that matters most

There is a circularity in everything above, and it is the sharpest objection to this whole class
of work: the published master regulators are being scored **in the very network they were derived
from**, where they are hubs. So we scored them again in six networks that nobody built them from.

Three are co-expression networks assembled from public RNA-seq unrelated to this corpus (ARCHS4,
GTEx). One is curated from published literature (TRRUST). Three are **experimental ChIP-seq
binding** — where a transcription factor was physically observed on the DNA (ReMap, ENCODE,
Literature ChIP). That last group is the strongest possible swap: it is a different *kind* of
measurement, not a different run of the same one.

**S1′ clearing the degree-matched null, out of 17 tumour types:**

| network | what built it | clears |
|---|---|---|
| ARACNe | **the network the MR sets came from** | 1 |
| **ARCHS4 co-expression** | ~100k public RNA-seq samples, unrelated corpus | **6** |
| GTEx co-expression | normal-tissue RNA-seq | 2 |
| TRRUST | literature curation | 1 |
| ReMap ChIP-seq | observed TF binding | 0 |
| ENCODE ChIP-seq | observed TF binding | 0 |
| Literature ChIP-seq | observed TF binding | 0 |

This is the result we did not expect, and it points in two directions at once.

**Once hub status is removed, the published master regulators show more independent expression
signal on a network nobody derived them from than on the one they came from** — ARCHS4 passes six
times as often as ARACNe. In bladder, ARCHS4 gives σ = 12 against a topology-only 3 and a chance
of 3.4; in head and neck, σ = 11 against 4. That is a real signal, and it is evidence *for* the
biology, arriving from outside the circle.

And the ChIP-seq networks show nothing at all. **That must be read with its power stated:** those
pools hold 118 to 296 regulators against ARACNe's ~5,900, so the smallest of them can only place
2 to 19 published regulators in the pool at all. A zero there is a weak zero, and it is reported
as one rather than counted as a refutation.




## The one place the signal is positive — and what it is a signal of

The network swap left an open thread, and it was the most interesting number on the board: once
regulon size is normalised away, the published master regulators clear the degree-matched null on
**ARCHS4 — a co-expression network built from roughly 100,000 public RNA-seq samples unrelated to
this corpus — in 6 of 17 tumour types, against 1 of 17 on ARACNe, the network they were derived
from.** This section pulls that thread.

### Which regulators carry it

| regulator | tumour types where it reaches the top-N | tumour types where it was eligible |
|---|---|---|
| **FOXM1** | 7 | 10 |
| **E2F1** | 6 | 8 |
| **HSF1** | 6 | 6 |
| **NR2F6** | 6 | 6 |
| **MAZ** | 4 | 4 |
| DRAP1 | 3 | 3 |
| TCF3 | 3 | 3 |
| ZNF687 | 3 | 4 |
| NME2 | 3 | 6 |

Ten regulators reach the top-N in three or more tumour types, and the most recurrent reaches it in
eight. Holding each tumour type's hit count fixed and redrawing from its own eligible published
regulators, **0 of 2,000 draws** reach either number.

### Two things that would explain it away, and what happened when they were tested

**Could it be the shared network?** ARACNe regulons are built per tumour type — a different file
for each. ARCHS4 is a single network used for all seventeen. A regulator whose ARCHS4 regulon
happens to sit high under this statistic would rank high in every tumour type for a reason that
involves no tumour at all, and recurrence would follow from the shared topology alone. The first
null does not exclude this, because it redraws only among published regulators, every one of them
scored through the same fixed topology.

Tested directly: size-matched sets of **regulators the master-regulator papers never named**, drawn
from the same pool and scored through the identical ARCHS4 network and pipeline. Their recurrence
reaches a median maximum of 2 and a best of 6 — **never the observed 8** — and a median of 0
regulators in three or more tumour types against the observed 10, in **0 of 2,000 draws**.

The recurrence is a property of the published regulators, not of the network they are scored through.

**Could it be that tumours proliferate?** This one is not excluded, and it is the reading the data
actually favours. FOXM1, E2F1 and HSF1 are proliferation and heat-shock regulators. A tumour is
proliferating tissue under stress, so these would rank high in tumour expression for a reason that
has nothing to do with governing any *particular* tumour type.

And the shape of the result argues for exactly that. The published architecture's claim is a
**type-specific appointment** — that each tumour type is maintained by its own load-bearing set.
What was measured is the opposite shape: **the same handful of regulators recurring across many
different tumour types.** Cross-tumour consistency is evidence for a shared programme, not for a
type-specific one.

### What this section concludes, and what it does not

Stated as narrowly as the measurement allows:

> On an independent co-expression network, the published master regulators are recoverable beyond
> what unpublished regulators achieve through the same network — and what recurs is a small,
> pan-cancer set of proliferation and stress regulators rather than a per-tumour-type set.

That is a real signal, and it is the first positive one in this study. It is **not** a
demonstration of type-specific master regulation, and this study does not claim one. Separating
"these proteins matter in cancer" from "these proteins are the appointment for *this* cancer"
requires a proliferation-matched control that this corpus cannot supply — the frozen universe holds
Primary Tumour samples only, with no normal tissue to hold proliferation constant against.
Recorded **NOT_KNOWN**, and named as the single most useful thing a successor charter could add.


## S2 — the stage that could not run, and exactly why

The charter's second stage asks whether the master-regulator sets separate two subtypes *within* a
tumour type where the mutation lists do not. It is the sharpest of the three stages, because it is
the one where shape and magnitude are made to disagree on the same patients.

It did not run. The status line above says so, and this section is the measurement behind that
claim rather than an assertion of it.

**The regulator half is present.** The published subtype sets give **112 subtype rows across 20
tumour types**, and every one of the 20 has at least two subtypes — so the pairing S2 needs exists:
bladder has 6, colon 8, head and neck 6, glioblastoma 5.

**The mutation half cannot be partitioned.** S2 requires, for each subtype, the top-*t* mutated
genes among *that subtype's* cases. The published subtype sets identify a subtype by an **integer
index and a member count**, and nothing more:

```
cohort  subtype   n
blca    1        78
blca    2        49
blca    3        45
blca    4        60
blca    5        72
blca    6        37
```

There is no public mapping from that index to GDC case identifiers. Without it there is no way to
say which patients are in subtype 1 and which in subtype 2, and therefore no way to build the two
mutation lists the comparison is made of. The 78 and the 49 are counts of people whose identities
the published set does not carry.

**This is a property of the published corpus, not a limitation we could engineer around.** A more
careful ingest would not help: the mutation data can be partitioned any number of ways, and none of
them is *the* subtype partition unless the subtype membership is known. Nor is it a licensing
barrier we declined to cross — the missing object is not gated, it is absent.

So S2 is recorded **NOT RUNNABLE**, with the reason named and checkable, and every downstream
criterion that depended on it is void rather than quietly reported. It is not a FAIL: nothing was
measured and found wanting. The distinction between *absent* and *refuted* is one this program
keeps, and this is a case of the first.

**What would make it runnable.** A published mapping from each subtype index to its member case
identifiers — a single column that the original analysisnecessarily had in hand — and S2 runs
against the corpus already built here, unchanged. That is the smallest addition anyone could make
to the public record that would turn a stage that cannot run into one that can.

## S3 — the inversion lookup, and what it found

The charter's third stage asks the question a patient would want asked: **is there a public compound
whose transcriptional signature runs opposite to the tumour on that cohort's master regulators?**

The rank corpus carries every one of the archive's **118,050 signatures** as integer ordinals —
extracted by streaming the 21.3 GB archive without ever storing it, with the SHA-512 of the
compressed stream checked against GEO's own published `SHA512SUMS`. Of those, **107,404 are compound
treatments covering 1,792 distinct drugs by InChIKey across 41 cell lines**, and **6,467 are vehicle
(DMSO) controls** — a negative control arm sitting inside the data itself.

### Two narrowings, both declared before scoring

**We test a different quantity than the method under examination claims.** LINCS measures 978
landmark genes, so this tests inversion of the **master-regulator genes' own expression ranks** —
not their inferred protein activity, which is what OncoTreat scores and which LINCS does not carry.
Different quantities. Nothing below speaks to the second.

**The coverage is a minority, and a biased one.** Only **53 of the 407** recurrent master regulators
are LINCS landmarks — 5 to 30 per cohort, 5–17% — and that fraction is enriched for well-studied
genes, because LINCS chose its landmarks partly on prior knowledge. Any result here speaks about the
famous fraction of a set, never the whole set. Cohorts with fewer than 8 observable regulators are
refused outright rather than reported: **prostate (7), thyroid (5)**.

### The law

Over the *m* observable regulators, the exact **Kendall numerator** between the cohort's ordinal
vector and each signature's ordinal vector: concordant pairs minus discordant pairs, a pure integer
over *m*(*m*−1)/2 pairs. No division, no normalisation, no float. Inversion is the *minimum* of that
integer. Two independent implementations — one scalar, one vectorised — are cross-checked on probe
rows, and the program refuses rather than reports if they disagree.

### The result

| tumour type | observable MRs | pairs | best drug K | random-set median K | random sets reaching it | vehicle control |
|---|---|---|---|---|---|---|
| bladder | 14 | 91 | -73 | **-71** | **489 / 1000** | does not clear |
| breast | 16 | 120 | -86 | **-88** | **797 / 1000** | does not clear |
| colon | 16 | 120 | -86 | **-90** | **830 / 1000** | does not clear |
| glioblastoma | 14 | 91 | -75 | **-71** | **269 / 1000** | does not clear |
| head & neck | 25 | 300 | -164 | **-182** | **972 / 1000** | does not clear |
| kidney clear cell | 8 | 28 | -28 | **-28** | **886 / 1000** | does not clear |
| liver | 8 | 28 | -28 | **-28** | **900 / 1000** | does not clear |
| lung adeno | 24 | 276 | -178 | **-170** | **237 / 1000** | does not clear |
| lung squamous | 9 | 36 | -34 | **-34** | **890 / 1000** | does not clear |
| ovary | 30 | 435 | -227 | **-243** | **858 / 1000** | does not clear |
| pancreas | 14 | 91 | -71 | **-71** | **673 / 1000** | clears |
| rectum | 19 | 171 | -109 | **-117** | **935 / 1000** | does not clear |
| sarcoma | 9 | 36 | -34 | **-34** | **917 / 1000** | does not clear |
| stomach | 16 | 120 | -86 | **-88** | **818 / 1000** | clears |
| uterus | 12 | 66 | -56 | **-56** | **653 / 1000** | does not clear |

**No cohort clears both control arms. Not one of 15.**

And the null is not marginal — it is inverted. In most tumour types the **median** random set of the
same size inverts *better* than the best of 1,792 real drugs: head and neck −182 against −164,
ovary −243 against −227. Between 237 and 972 of every 1,000 random gene sets reach what the best
real compound reached.

Read plainly: **on this quantity, at this coverage, there is no inversion signal to find.** The
compounds that top the list are where noise put them, and no drug list is published from this stage.

One further observation, offered as an observation rather than a claim: the published
master-regulator genes appear **harder** to invert than random landmark genes. A mechanism is
available — these are well-expressed, mutually correlated, functionally constrained genes whose
ranks have less room to move — but this study did not test it, and it is recorded **NOT_KNOWN**.

### S3 again, against eleven times as many drugs

The obvious objection to a null result is that not enough was tried. So S3 was run a second time
against the larger LINCS archive: **205,034 compound signatures covering 20,308 distinct
drugs by InChIKey**, against the 107,404 signatures and 1,792 drugs of the first
run. Eleven times the chemical space, same frozen law, same two control arms.

The 21.3 GB archive was streamed twice and never stored — once to read the column order out of its
own tail, once to emit the ordinals — and the SHA-512 of the compressed stream was checked against
the digest GEO publishes for that file. It matched both times. **65 MB ever touched disk.**

| tumour type | observable MRs | best K (1,792 drugs) | random-set median | reaching it | best K (20,308 drugs) | random-set median | reaching it |
|---|---|---|---|---|---|---|---|
| bladder | 14 | -73 | -71 | 489/1000 | -75 | **-73** | **320/1000** |
| breast | 16 | -86 | -88 | 797/1000 | -88 | **-90** | **666/1000** |
| colon | 16 | -86 | -90 | 830/1000 | -94 | **-88** | **208/1000** |
| glioblastoma | 14 | -75 | -71 | 269/1000 | -79 | **-73** | **55/1000** |
| head & neck | 25 | -164 | -182 | 972/1000 | -164 | **-178** | **952/1000** |
| kidney clear cell | 8 | -28 | -28 | 886/1000 | -28 | **-28** | **965/1000** |
| liver | 8 | -28 | -28 | 900/1000 | -28 | **-28** | **965/1000** |
| lung adeno | 24 | -178 | -170 | 237/1000 | -178 | **-168** | **211/1000** |
| lung squamous | 9 | -34 | -34 | 890/1000 | -34 | **-34** | **944/1000** |
| ovary | 30 | -227 | -243 | 858/1000 | -259 | **-237** | **120/1000** |
| pancreas | 14 | -71 | -71 | 673/1000 | -73 | **-73** | **551/1000** |
| rectum | 19 | -109 | -117 | 935/1000 | -121 | **-117** | **303/1000** |
| sarcoma | 9 | -34 | -34 | 917/1000 | -36 | **-34** | **425/1000** |
| stomach | 16 | -86 | -88 | 818/1000 | -96 | **-90** | **112/1000** |
| uterus | 12 | -56 | -56 | 653/1000 | -56 | **-56** | **717/1000** |

**0 of 15 scored tumour types clear both control arms.** Cohorts refused for falling under the frozen floor of 8 observable regulators: prostate (7), thyroid (5).

Testing eleven times more compounds changes the answer nowhere. The best-scoring drug improves
slightly, as drawing more samples from the same distribution will do — and the null improves with
it, because the null is a best-of over the same enlarged candidate set. What does not appear, at
either scale, is a compound that separates from the noise.

That closes off the most natural objection: this is not a result about having searched too small a
library. It is a result about the quantity being measured — the expression ranks of the minority of
master regulators that LINCS observes at all — carrying no recoverable inversion signal.

### A defect in our own null, found and fixed

The first null scored random gene sets against a **single** signature, while the observed statistic
was a best-of-107,404 minimum. It reported **0 of 1,000** — apparently overwhelming. The
structurally-correct null, which takes the best across every signature exactly as the observed value
does, reports **489 of 1,000** on the same cohort. A factor of five hundred, and it turns
"significant" into "nothing".

That is the same defect this study found in the incumbent method, committed by us, one stage later:
**a null that does not match the shape of the observed statistic manufactures significance.** It is
recorded because a study that publishes only its clean runs is not publishing a method.


## S5 — byte identity, re-verified today rather than trusted

The charter's fifth stage asks whether a stranger with curl reproduces this corpus byte-exact, or
the seal does not stand. It is the stage that makes every other number checkable by someone who
does not trust us.

**It was verified by re-reading the corpus, not by reading our own logs.** Eleven of the seventeen
cohorts carry an ingest manifest recording per-file GDC md5 verification; the first six were
ingested before that manifest was added. Reporting the stage from that bookkeeping would have meant
reporting 11 of 17 and calling it a seal. So every scored artefact was re-verified directly instead
— gzip integrity, declared shape, and digest — because **a corpus that cannot be re-verified today
is not sealed, whatever a log said while it was being built.**

| | result |
|---|---|
| count matrices verified | **17 of 17** |
| gzip integrity failures | **0** |
| shape agreement | every cohort 60,660 rows, identical |
| patient samples across the corpus | **7,673** |
| cohorts failing verification | **0** |
| files md5-verified at ingest (where a manifest exists) | **4,377**, 0 skipped |

**The LINCS archive checks against its own publisher.** The 21.3 GB Level-5 archive was streamed
twice and never stored, and the SHA-512 of the compressed stream matches the digest GEO publishes
for that file:

```
GEO publishes  6a3115cf3aaa402bb1bc098678b52b9c…
we streamed    6a3115cf3aaa402bb1bc098678b52b9c…
```

Every derived artefact carries its own digest, so a reader can confirm they hold the same bytes
before re-running anything:

| artefact | bytes | sha256 |
|---|---|---|
| GSE70138 landmark ordinals | 230,905,800 | `706a4e9f3bdec276…` |
| GSE92742 landmark ordinals | 926,453,532 | `9e1d4b74349c11c3…` |
| GENCODE v50 transcripts | 183,554,921 | `5a320f524d73b579…` |
| GRCh38 primary assembly | 845,635,028 | `b760d18dbb651dd1…` |
| TRRUST v2 | 297,659 | `9b909319ccc8e365…` |
| MSigDB Hallmark | 48,690 | `ee2463540042078b…` |

**S5 PASSES.** Every artefact this study was scored on re-verifies today, from public bytes, with
no account and no key.

One upstream inconsistency is carried in the seal rather than smoothed over, exactly as the charter
required: the regulon package's `datalist` names a 26th object, `regulonskcm`, for which no `.rda`
and no manual page exist in the release. It is named here so that a stranger reproducing the corpus
reads the discrepancy as upstream rather than as damage to what we built.

## Is any of this an artifact of sequencing depth?

Patients are not sequenced equally, and a ranking that quietly tracked read depth rather than
biology would make everything above an artifact. So it was measured, on real data, with no
simulation and no downsampling.

Sort each cohort's patients by **total library size** and take the shallowest third and the
deepest third — two disjoint groups chosen to disagree about depth as much as the cohort allows.
Rank regulators on the **shallow** patients, take the top 141, and score that set against the
**deep** patients' own ranking. If the law were a depth readout, these two groups could not agree.

| tumour type | library-size range across patients | depth gap, shallow third vs deep third | zero-count genes, shallow | deep | shallow-ranked set found in deep patients |
|---|---|---|---|---|---|
| bladder | 6.44× | 1.77× | 50.2% | 45.0% | **135 / 141** |
| breast | 5.91× | 1.63× | 47.8% | 43.5% | **130 / 141** |
| colon | 56.17× | 2.64× | 54.9% | 46.9% | **127 / 141** |
| glioblastoma | 7.24× | 1.47× | 40.4% | 32.9% | **124 / 141** |
| head & neck | 4.36× | 1.57× | 48.5% | 46.1% | **131 / 141** |
| kidney clear cell | 30.5× | 1.6× | 44.4% | 40.7% | **132 / 141** |
| liver | 6.43× | 1.53× | 54.8% | 50.1% | **133 / 141** |
| lung adenocarcinoma | 5.76× | 2.3× | 48.2% | 42.0% | **132 / 141** |
| lung squamous | 7.33× | 1.66× | 45.5% | 42.2% | **133 / 141** |
| ovary | 9.11× | 1.96× | 43.5% | 36.8% | **136 / 141** |
| pancreas | 4.41× | 1.6× | 47.8% | 43.6% | **122 / 141** |
| prostate | 5.31× | 1.61× | 47.9% | 44.7% | **130 / 141** |
| rectum | 6.46× | 2.69× | 54.1% | 46.4% | **116 / 141** |
| sarcoma | 4.34× | 1.43× | 50.2% | 46.4% | **129 / 141** |
| stomach | 6.5× | 1.7× | 36.8% | 34.4% | **136 / 141** |
| thyroid | 6.77× | 1.43× | 48.0% | 45.2% | **127 / 141** |
| uterus | 13.31× | 2.12× | 48.7% | 46.9% | **131 / 141** |

Chance throughout is about 3.4. The groups genuinely differ: library sizes span up to **56-fold**
within a single cohort, the deep third carries up to 2.7× the reads of the shallow third, and
several percent more of the genome is at zero counts in the shallow group — which matters, because
zeros form one large tied block and the tie rule is part of the law.

The chartered ordinal is a rank *within* a sample, so it is invariant to any strictly monotone
rescaling by construction; that argument was already available and is worth nothing on its own,
because it does not cover the tie structure. **This measures the part the argument does not
cover, and the answer is that the ranking survives it in all seventeen tumour types.**

## What was excluded, and why — measured, with a control arm

Three of the twenty tumour types with a published master-regulator set are not scored here. They
are named rather than dropped quietly, and the reason for each is measured against the live GDC
API rather than asserted.

| tumour type | published MR set | why it is not scored |
|---|---|---|
| **acute myeloid leukaemia** | 108 regulators | The data exists — **151** open expression files — but all of them are typed `Primary Blood Derived Cancer – Peripheral Blood`, and **0** are `Primary Tumor`. AML is a blood cancer. The universe rule "Primary Tumour only" was frozen before any scoring, and it is not moved afterwards to admit a cohort. |
| **lower-grade glioma** | 29 regulators | 516 open Primary Tumour files exist, but the published regulatory network carries **no regulon for this context** — it covers 25 contexts and this is not among them. Nothing to score against. |
| **melanoma** | 110 regulators | 103 open Primary Tumour files exist; again **no regulon** in the published network. |

The query discriminates: the same filter returns **412** Primary Tumour files for bladder, so a
zero above is a real zero and not a broken question.

**AML is the interesting one, and it is a finding about our own frozen rule rather than about the
biology.** The corpus for it is public, complete, and has a regulon waiting. It is excluded by a
single word in a rule we froze in advance, for a good reason — mixing solid-tumour and
blood-derived sample types in one universe would have been a silent confound — and the discipline
that makes the rest of this page worth reading is the same discipline that keeps that word in
place today. It is the obvious first amendment for a successor charter, declared here so that a
later run cannot present it as a new idea.

## Two defects we found in our own instrument, and fixed

Both were found by making two implementations of the same law disagree, which is the only reason
either was visible. Both are recorded because a study that only publishes its clean runs is not
publishing a method — and because finding them is part of what the seventeen runs were for.

**The seed was not deterministic.** The Monte Carlo nulls were seeded from Python's `hash()` of a
string, which is randomised per process — so the same command produced different nulls on
different runs. A study whose entire claim is that a verdict does not depend on who computes it
cannot seed itself from a value that changes between processes. Seeds are now derived from SHA-256
of the frozen parameter string, and the fix is *proven*: two separate processes now produce
byte-identical output for all seven networks.

**The duplicate gene-symbol rule was undeclared.** The counts matrix carries 60,660 rows but only
59,427 distinct symbols: 110 symbols occupy 1,343 rows, every one a repeated non-coding RNA family
(`Y_RNA` on 756 rows, `Metazoa_SRP` on 170). A dictionary keyed by symbol silently keeps whichever
row it saw last, and "last" differed between two implementations — moving σ by one. No published
master regulator sits on a duplicated symbol, so they enter only as regulon targets, but the rule
was load-bearing enough to change a number and so it is now named and frozen: **rows sharing a
symbol are summed before ranking**, order-independent and exact-integer. The alternative — drop
them — is published as a declared sensitivity arm, because the rule is a choice and the answer is
shown under both choices. **Both boards were run in full: σ is identical in all seventeen tumour
types under either rule.** The rule had to be frozen because it moved a number between two
implementations; having frozen it, it moves nothing in the published result, and that is worth
stating as plainly as a difference would have been.

## What this is, and what it is not

This is not a finding that anyone was wrong, and it is not a claim about any patient. The
published master regulators are hubs in this network; that is a true and useful thing to be, and
ovary shows a signal no amount of topology explains. The measurement is narrower and more specific
than "wrong":

> On this corpus, with this law, in eleven of seventeen tumour types, **the part of the recovery
> that survives is largely the part that never needed the expression data** — and the independent
> expression signal that does exist shows up more clearly outside the network of origin than
> inside it.

That is worth knowing precisely because it is cheap to ask and nobody had asked it. It costs one
afternoon of public bytes and an exact integer. Every decision that rests on "the method found
these regulators in this patient's data" deserves to know which half of that sentence is
load-bearing — and the two halves can now be told apart, by anyone, for free.

---

# The second disease context — and the thing the exact court can do that the old instrument cannot

Cancer closes this charter. Cardiovascular disease rides along as a second disease context,
because in six weeks of 2026 it produced two clean instances of the failure mode this study was
written about — the scalar moved, and the system did not.

| trial | drug | readout | result |
|---|---|---|---|
| **ZEUS** NCT05021835 | ziltivekimab, an anti-IL-6 **monoclonal antibody** | 31 Jul 2026 | **HR 0.99** (95% CI 0.88–1.11), 6,376 randomised. Target engagement confirmed — IL-6 down, hsCRP down — and it *"did not translate into MACE risk reduction"* |
| **Lp(a)HORIZON** NCT04023552 | pelacarsen, an **antisense oligonucleotide** | 4 Sep 2026 | Primary endpoint **not met**, 8,323 randomised. Lp(a) *was* lowered — 72–80% in Phase 2b — and it *"did not demonstrate that this translated into reduced cardiovascular risk"* |

**Graded REPORTED, and no table is invented.** ClinicalTrials.gov carries `hasResults = FALSE` for
ZEUS; HORIZON released no hazard ratio, no confidence interval, no event counts. Both promise full
data at an unnamed congress. **No court is built on absent data.** The shape law is frozen now and
the tables are scored when the congress releases them — a real, dated pre-registration.

And one of these two drugs the exact court can grade today, while the other it cannot touch. Saying
which, and why, is the discrimination that makes the rest believable.

**Ziltivekimab is a monoclonal antibody. It has no nucleotide sequence, and the screen below cannot
say one word about it.** An instrument that claims to grade everything grades nothing.

**Pelacarsen is a 20-mer, and its sequence is public** — NCATS GSRS, UNII `LSO9H7UZ90`:

```
5'-T G C T C C G T T G G T G C T T G T T C-3'
```

As one string, which is what the program is given: `TGCTCCGTTGGTGCTTGTTC`. The transcriptome it
is screened against is GENCODE v50, pinned by digest so a reader can confirm they hold the same
bytes: `5a320f524d73b5793518eb19b118829033713443d0f42af20a67bb31cc06cf56`.

## Every window in the human transcriptome, counted

`reproduce/pelacarsen-offtarget-whole-transcriptome.swift` asks the question a patient actually
has, and it is a permanent question that the trial outcome does not touch: **besides LPA, where
else in the human transcriptome can this molecule bind well enough to matter?**

Watson–Crick complementarity is a *discrete* rule, so it is **counted, not estimated**. Bases are
integers; an antisense oligo binds antiparallel, so position *i* of the drug pairs with position
*L−1−i* of the window, and a position pairs exactly when the two codes sum to 3. Every window of
every transcript is enumerated. No sampling, no seeding heuristic, no e-value, no cutoff inside
the computation, and no parameter at all. One integer per window — the same integer on every
machine, in every laboratory, forever.

```
transcripts scanned : 670670
windows enumerated  : 1467336203
```

**It checks itself on the one thing it already knows.** There is exactly one fact this screen can
be held to in advance: pelacarsen's perfect complement must be in LPA. If the 20/20 hit were
anywhere else, the screen would be wrong — so it tests that first, and prints no off-target list
at all unless it passes.

```
KNOWN-CASE CHECK — the perfect complement must be LPA
  perfect 20/20 windows : 3
  genes carrying them   : LPA
  PASS — the instrument finds the drug's own target and nothing is assumed.
```

Three windows out of 1,467,336,203 pair 20 of 20, and all three are in LPA, at position
~3,840 of three separate transcripts. The screen found the drug's binding site knowing only two
public files.

Then the complete map, with nothing withheld:

| complementarity | windows |
|---|---|
| 20 / 20 | 3 |
| 19 / 20 | 8 |
| 18 / 20 | 28 |
| 17 / 20 | 30 |
| 16 / 20 | 650 |
| 15 / 20 | 6,823 |
| 14 / 20 | 51,567 |
| 13 / 20 | 299,927 |
| 12 / 20 | 1,398,769 |
| below 12 / 20 | 1,465,578,398 |

Everything at 19/20 and 18/20 is still inside LPA — the kringle-IV repeat structure of that gene
returning its own near-copies, which is real biology and exactly what a correct screen should
show. The first molecules that are **not** LPA appear at 17/20, and they are named in full:
`LPAL2` (the LPA-adjacent pseudogene, expected), `TMEM254-AS1`, `LINC02606`, `LINC01065`, `ISM1`.

That list did not exist this morning. It is now a permanent, re-derivable object.

```
MARKER  PELACARSEN_OFFTARGET_EXACT__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
sha256  513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757
```

## The same windows, scored the conventional way

The conventional screen scores a binding free energy in floating point and calls a window a
candidate when ΔG falls below a cutoff. Both halves of that sentence are choices, and the program
measures what each choice costs — on the same 1,757,805 windows, in the same run.

| cutoff (kcal/mol) | candidates, parameter set A | parameter set B | **changed side** |
|---|---|---|---|
| −22 | 1,748,696 | 1,734,206 | 14,490 |
| −26 | 1,493,514 | 1,427,682 | 65,832 |
| **−28** | 1,236,547 | 1,160,345 | **76,202** |
| −32 | 667,351 | 610,079 | 57,294 |
| −36 | 250,607 | 227,370 | 24,067 |
| −40 | 64,364 | 57,741 | 7,607 |

A and B differ by less than 0.1 kcal/mol per stack — **smaller than the published uncertainty of
the parameters themselves.** Both are equally defensible, and they do not name the same molecules:
up to **76,202 windows change side**. And the cutoff is a second free choice stacked on the first
— moving it from −22 to −40 takes the candidate list from 1.75 million to 64 thousand, a
twenty-seven-fold swing with no principle available to adjudicate it.

The exact arm has neither knob. A window pairs 17 of 20, or it does not. The threshold in the
exact arm is only a decision about what to **print**, applied after the arithmetic is finished —
and because the full histogram is published, anyone can re-make that choice without re-running
anything. **That is why the seal above covers the exact arm alone: it is the part with nothing to
perturb.**

## What it costs to not know

- Cardiovascular disease kills **19.8 million people a year — 32% of all deaths** (WHO 2022). US
  cost **$414.7B/yr**, projected to **$1.8T by 2050**.
- A cardiovascular Phase 3 that fails destroys a mean **$255.4M** out-of-pocket (DiMasi), at a
  median **$34,857 per patient** (Davidson, *JACC Basic Transl Sci* 2024).
- **Cardiovascular Phase 3 → approval is 45.6%.** Entering Phase 3 fails **54.4%** of the time.
- Elevated Lp(a) affects roughly **20% of people — about 1.4 billion** — and statins do not lower
  it; they raise it 8–24%.

Two Phase 3 programmes, 14,699 randomised participants, and the scalar-surrogate hypothesis was
tested at maximum cost and did not carry in either. **Nothing here would have predicted those
outcomes, and this study does not claim it would.** What it claims is narrower and checkable: a
pre-registered shape test, and an exhaustive exact off-target map, are instruments that cost an
afternoon and can be run *before* the $255M — and that anyone, anywhere, with no account and no
permission, can re-derive byte-for-byte and disagree with.

That last part is the point. Fourteen thousand people volunteered for those two trials. The least
that is owed them is that the questions asked of the result be ones a stranger can check.
