# A drug an AI designed, and the safety questions our instruments can and cannot reach

*A CURES-family review of rentosertib (ISM001-055 / INS018_055) for idiopathic pulmonary fibrosis. The subject under grading is our own **instrument set** — never the medicine, never the company, and never a person who has this disease.*

## What this molecule is, plainly

Idiopathic pulmonary fibrosis is a disease in which lung tissue is progressively replaced by scar. The scar is stiff where the lung needs to be elastic, and breathing gets harder as it spreads. Two medicines are approved for it worldwide — pirfenidone and nintedanib — and both slow the loss of lung function rather than restoring it. That is the whole approved shelf. In the registry enumerated below, **84 phase-3 treatment trials** are registered in this condition, and the list of studies of any phase that were terminated, withdrawn or suspended runs to **93, with 87 of them carrying a reason the sponsor wrote down**. People living with IPF have been waiting a long time for a third option.

Rentosertib is a candidate for that shelf, and it is unusual in how it came to exist. Insilico Medicine used generative models both to nominate the target — **TNIK**, TRAF2- and NCK-interacting kinase — and to design the molecule against it. That both halves of the discovery were machine-generated is **REPORTED** — it comes from the sponsor's own account and from the trial record, not from anything this page measured. Whatever else is true about it, it makes this molecule a landmark worth getting right.

**This page takes no side on the medicine.** It does not say rentosertib works and it does not say it fails. What it does is put our own measuring tools under the light, state precisely which questions about this drug they can answer exactly, state at the same volume which questions they cannot reach at all, and refuse to publish a number in the gap between the two. A structural or network figure is **not** efficacy, **not** a dose, **not** a mechanism, and **not** evidence that any drug helps or harms anyone.

---

## 1. The structural lock — counted per element, cross-checked against three registries

Before anything else, the identifiers. A transcription error in a drug identifier that travels into a safety document is exactly the failure this program exists to prevent, so the strings submitted for this review were **verified rather than trusted**.

`reproduce/rentosertib-structure-lock-exact.swift` is a full SMILES parser written for this purpose — organic subset plus bracket atoms, ring closures including `%nn`, branches, bond orders, and an integer valence model for implicit hydrogen. There is no `Float`, no `Double`, no float literal and no float conversion anywhere in it. It takes its corpus paths from `argv`; no absolute path is baked into the source.

**The atom table, counted, not assumed:**

```
    element |  counted | declared | verdict
    --------+----------+----------+---------
    C       |       27 |       27 | AGREE
    H       |       30 |       30 | AGREE
    F       |        1 |        1 | AGREE
    N       |        7 |        7 | AGREE
    O       |        1 |        1 | AGREE

    counted formula (Hill) : C27H30FN7O     declared : C27H30FN7O
    heavy atoms 36 · bonds 40 · components 1
```

**There is no transcription error in the submitted formula/SMILES pair.** **MEASURED.**

**The four-source lock.** One string agreeing with itself proves nothing, so the same parser was run over three further strings written by three independent producers in three different styles:

| source | formula | heavy-atom skeleton (Weisfeiler–Lehman, integer FNV-1a 64) |
|---|---|---|
| submitted for review (Kekulé) | C27H30FN7O | `b5da901cbcba5535` |
| PubChem CID 164938183 | C27H30FN7O | `b5da901cbcba5535` |
| ChEMBL CHEMBL5969552 (aromatic) | C27H30FN7O | `b5da901cbcba5535` |
| NCATS GSRS, UNII M9NU5G8WXY (aromatic) | C27H30FN7O | `b5da901cbcba5535` |

All four are the same molecule by formula **and** by connectivity. The connectivity instrument was proved to **discriminate** before it was trusted: *ortho*-, *meta*- and *para*-xylene share one formula, C8H10, and produce three different digests; a meta-fluoro variant of rentosertib itself has the identical formula C27H30FN7O and a different skeleton digest.

**The InChIKey was NOT computed, and the program says so rather than approximating.** An InChIKey is a truncated SHA-256 over the IUPAC InChI string, which is itself the output of the InChI normalisation and canonical-numbering algorithm; that algorithm is not implemented here, so no key is computed and none is guessed. What *is* verified exactly, from the string and from the parsed structure: three hyphen-separated blocks of 14/10/1 characters; version character `S` = standard InChI; protonation character `N` = neutral; and block 2 equal to `UHFFFAOYSA`, the constant meaning *no stereochemistry layer and no isotope layer*. That constant was then cross-checked against the molecule itself — **0 tetrahedral stereo descriptors, 0 directional bond descriptors, 0 carbons bearing four distinct heavy substituents**; the isopropyl methine carries two identical methyls and is not a stereocentre. The structure is consistent with `UHFFFAOYSA`. Block 1 is verified by **registry lookup**, which is a different kind of evidence and is labelled as such.

**Registry lookups, login-free, misses reported as misses:**

- PubChem `inchikey/ZVDNXHUSIKGTSF-UHFFFAOYSA-N` → **HIT.** CID 164938183, `MolecularFormula` C27H30FN7O, InChIKey echoed identical.
- PubChem `name/rentosertib` → **HIT.** Same CID.
- PubChem `name/ISM001-055` → **MISS, HTTP 404** — although the synonym list for CID 164938183 does carry `ISM001-055`. That is an index miss, not an absent compound. `name/INS018_055` and `name/INS018-055` both return 200.
- ChEMBL by standard InChIKey → **HIT.** CHEMBL5969552, `full_molformula` C27H30FN7O, `max_phase` null, `first_approval` null.
- ChEMBL `molecule/search?q=rentosertib` → **MISS**, `total_count` 0.
- NCATS GSRS `substances(M9NU5G8WXY)` → **HIT.** uuid `d12effca-a1cb-4ac8-b5bb-807964de76f1`, formula C27H30FN7O, names carrying `rentosertib [INN]`, `RENTOSERTIB [USAN]`, `INS-018_055` and `INS018_055`.

**Every submitted identifier is confirmed. Nothing in the submitted set was wrong.**

**Self-validation, both directions: 89 arms, 0 failures.** Twenty-two positive arms are countable by hand (methane, ethanol, benzene in both aromatic and Kekulé form, pyridine both forms, pyrrole, furan, thiophene, imidazole both forms, fluorobenzene, piperazine, *N*-methylpiperazine, isopropylamine, acetamide, acetanilide, aspirin, caffeine, dinitrogen, acetonitrile, a two-component input). Eight negative arms each alter one element and require the program to **disagree and name the element that moved** — `C26H30FN7O` names C, `C27H31FN7O` names H, `C27H30N7O` names F, `C27H30FN6O` names N, `C27H30FN7` names O. Six refusal arms hand it an empty string, an unbalanced `)`, an unclosed branch, an unclosed ring, an unknown element and a malformed bracket; all six refuse. **A gate given nothing does not pass**, and the program exits **1**, not 0, when it is run with no corpus — the absence of an input is never a green result.

C-007 note: a SMILES string and an InChIKey are public structural identifiers and are publishable. **No synthetic route appears on this page and none will.**

---

## 2. What our instruments can and cannot reach — read this before any number below

**This is the most important section on the page, and it is the reason this review exists.**

The Study 26 machinery scores *master-regulator signature reversal*: it asks whether a perturbation pushes a tumour's regulatory programme back toward its healthy state, in a measured expression space. It is a good instrument. **It cannot be pointed at this drug**, and the two reasons are measurements, not opinions.

**Reason one — TNIK is not a landmark gene.** The LINCS L1000 platform physically measures 978 genes and infers the rest. In `GSE92742_Broad_LINCS_gene_info.txt.gz` (sha256 `741216ccc53320119b47ab006de3bcad48963c57087c9e07f50f0d6cd088711a`, 12,328 rows, 978 with `pr_is_lm = 1`, 10,174 with `pr_is_bing = 1`), the row for gene 23043 reads:

```
23043   TNIK   TRAF2 and NCK interacting kinase   pr_is_lm=0   pr_is_bing=1
```

TNIK sits in the **inferred** space. Its value there is a model output, not a measurement. Any score we computed in the landmark space and attributed to this drug's target would be reporting a model's opinion of a gene as if it were an observation.

**Reason two — TNIK is a master regulator in none of our cohorts.** Across all five published master-regulator sets — `mr_by_cohort_union.tsv`, `mr_by_cohort_union_ICRPRIME.tsv`, `mr_by_subtype.tsv`, `mr_all_distinct.txt`, `mr_recurrent_407.txt` — the token `TNIK` appears **0 times**, while the control token `FOXM1` appears 10, 11, 22, 1 and 1 times respectively. The search discriminates; TNIK is simply not there. (The brief's "seventeen cohorts" is the size of `SCOREABLE_CONTEXTS.txt`; `mr_by_cohort_union.tsv` carries 21 rows, a superset. TNIK is absent from all of both.)

**Reason three — the compound is not in LINCS at all. ABSENT, measured.** Both perturbagen tables were read row by row:

```
GSE92742_Broad_LINCS_pert_info   sha256 dfea176cf8820269ebccd29c21171cbe264188c128421b6d7c0cd2fbfb7fa005
  perturbagen rows tested        : 51383
GSE70138_Broad_LINCS_pert_info   sha256 f935894a86f357a84bc13fd4aa847de6c82762f9869339ebbd9122871d28b91f
  perturbagen rows tested        : 2170

  exact InChIKey matches                    : 0    0
  skeleton-block (ZVDNXHUSIKGTSF) matches   : 0    0
  name matches, 7 spellings                 : 0    0

  POSITIVE CONTROLS — the lookup must be able to find something:
  pirfenidone                               : 1    1
  nintedanib                                : 1    1
  sirolimus                                 : 7    3
```

The releases are 2015–2017; this molecule is 2021 and later. **ABSENT** — we looked, the lookup works, it is not there. That is a different answer from REFUSED and a different answer from NOT_KNOWN, and this page never prints the three alike.

**Therefore this page publishes NO network-recovery number, NO signature-reversal score, and NO recovery fraction for rentosertib. Any such number presented as a measurement of this drug would be invented.** We are stating that as loudly as we would state a positive result, because a silence that reads as either safety or doubt is the failure mode this whole discipline exists to prevent.

Two further boundaries, named at the same volume:

- **We hold no regulatory network of lung tissue.** The 25 networks below are tumour cohorts. Nothing in them is a statement about a fibrotic lung.
- **A network degree is not a target's importance in a disease.** It is a count of edges in one corpus, built for another question entirely.

---

## 3. The public trial record, quoted and graded

Four registered trials, enumerated completely from ClinicalTrials.gov v2. **The query key matters and is stated: `query.term=INS018_055` returns all four. `query.term=rentosertib` returns one. `query.term=ISM001-055` returns zero.** A count published without its key does not reproduce.

| NCT | phase | status | n | primary outcome (registry verbatim) | grade |
|---|---|---|---|---|---|
| NCT05154240 | 1 | COMPLETED | 78 | "Number of participants with treatment-related adverse events based on subjective and objective examination" | NOT_KNOWN |
| NCT05938920 | 2 | COMPLETED | 71 | "Percentage of Participants Who Had at Least 1 Treatment-emergent Adverse Event (TEAE)" | **REPORTED** |
| NCT05975983 | 2 | RECRUITING | 40 | "Percentage of subjects who have at least 1 treatment-emergent adverse event (TEAE)" | NOT_KNOWN |
| NCT07687459 | 3 | NOT_YET_RECRUITING | 320 | "the annual rate of forced vital capacity (FVC; mL) decline over 52 weeks." | NOT_KNOWN |

**Read the grades exactly as the grade law defines them.** `REPORTED` means the registry shows a readout — **it says nothing whatever about whether that readout was favourable.** In the same register, ARTEMIS-IPF (NCT00768300, n=494, whyStopped "Lack of efficacy") and Zephyrus I (NCT03955146, n=393, "Study did not meet its primary endpoint.") are both graded REPORTED. `NOT_KNOWN` means the registry does not show a readout — never that no result exists, and never that something failed.

Three facts about the completed phase 2 that are registry facts and nothing more: its **primary** endpoint is a safety endpoint (treatment-emergent adverse events), change in FVC appears among its **secondary** outcomes, and results are posted to the registry with one DERIVED literature reference (PMID 40461817). **This page does not characterise those results.** We did not run an efficacy analysis, we are not licensed to interpret one, and inventing a verdict in either direction is precisely the failure this review is written against.

The phase 3 is the one to watch: **n = 320, primary endpoint the annual rate of FVC decline in millilitres over 52 weeks, start date 2026-08-30, listed completion 2029-10-30.** That is the trial whose readout would settle the question this page refuses to pre-answer.

---

## 4. The games we could play, and what they returned

The instruction was explicit: if one game cannot be played, play the ones that can. Two arms produced results. Both are counts on public bytes, both self-validate in both directions, and both were then put through an adversarial pass whose repairs are applied below rather than argued with.

### Arm A — what the networks we hold actually say about TNIK

`reproduce/tnik-network-degree-exact.swift` and `reproduce/tnik-repairs-exact.swift`, over the Study 26 regulon corpus.

**The corpus, counted as the work happened:** 26 files read, one of them (`regulon_lamlblood.tsv`) byte-identical to `regulon_laml.tsv` and therefore **excluded** rather than counted twice; **25 networks included, 12,017,368 edges**, cross-checked row by row against `CROSSING_C_SUMMARY.tsv` — 25 agree, 0 disagree. Across all 26 files the line total is **12,548,903**, which `wc -l regulons/*.tsv` independently confirms. **6,172 distinct regulators, 23,318 distinct targets, 10,369,386 distinct (regulator, target) pairs.**

**TNIK's position, as integers:**

```
as a REGULATOR : out-edges 1314 · distinct targets 1258 · targets in >=2 networks 54 · deepest edge 3 of 25
as a TARGET    : in-edges   545 · distinct regulators 503 · regulators in >=2 networks 39 · deepest edge 3 of 25
self-loops     : 0   (the self-loop detector was proved alive on a fixture first)
present as a regulator in 25 of 25 networks · as a target in 25 of 25 networks
```

**Against every regulator in the corpus, by exact rational comparison** — cross-multiplication of integers, no division, no rounding:

```
recurrence rate 54/1258
  regulators with a HIGHER rate : 5713 of 6172
  EXACTLY equal                 : 1        (TNIK itself, and no other)
  lower                         : 458
```

**Against a size-matched control** (regulators whose total out-edge count lies in [1182, 1445], the bounds being TNIK's own 1,314 × 9/10 and × 11/10): 1,279 members, **higher 1,109 · exactly equal 1 · lower 169**.

**Against the 1,115 published master regulators** (all 1,115 mapped through HGNC, all present as regulators in the corpus, 0 unmapped): **higher 1,111 · equal 0 · lower 4**.

**On in-degree** — a second measure, reported whichever way it falls: TNIK's total in-edge rank is **13,494 of 23,318**, the 57th percentile by integer division; on in-recurrence, 14,403 targets rank higher, 7 exactly equal, 8,908 lower. Per cohort, TNIK's in-degree **does** enter the top 16% in one of the 25 networks (brca, rank 1,613 of 19,359).

**On out-degree, tested as an integer predicate** `rank*100 <= 16*n`: **0 of 25 cohorts** place TNIK inside the top 16%. The claim holds — and it holds by **41 ranks** in its closest cohort (gbm, rank 1,009 of 6,056, where the last rank inside the band is 968). That margin is published with the claim, because a round statement that hides how close it ran is not a measurement.

**What these integers are, and are not.** They are a count of one gene's edges in 25 tumour transcriptional networks. They are **not** efficacy, **not** a dose, **not** a mechanism, **not** a safety signal, and **not** evidence that rentosertib or any other drug helps or harms any person. A low network degree is not a claim that a drug does not work, and a high one would not have been a claim that it does. **No adjective is layered on these integers anywhere on this page, and none belongs on them** — a corpus built to find tumour master regulators has no standing to rank a target's importance in a fibrotic lung, in either direction.

**Self-validation:** 44 arms in the original pass and 24 in the repair pass, 0 failures across both, with controls in both directions — SHA-256 against published vectors and a discriminating negative; CRC-32 against `0xCBF43926` and a discriminating negative; gzip inflate passing its own CRC32+ISIZE trailer, and **refusing** when one payload byte is flipped; a hand-counted fixture with TNIK present and a second fixture with TNIK absent, told apart by the same instrument; and eight malformed-corpus arms (empty bytes, two-field line, bad sign character, non-numeric id, missing trailing newline, blank line) that all refuse. **A malformed corpus can never read as a count.**

### Arm B — every registered modality for pulmonary fibrosis, and what is measurable in each

`reproduce/modality-register-exact.swift` and `reproduce/modality-repairs-exact.swift`, over six pinned ClinicalTrials.gov v2 universes, each with its declared `totalCount` checked against the number of records actually decoded: **U1_PF 895 · U2_ILD 1,703 · U3_PBM 579 · U4_LLLT 706 · U5_RENTO 4 · U6_US 10 — all AGREE.** Forty-three modality rows built from 251 declared phrases, 70 validation arms, 0 failures; the repair pass adds 34 further arms, also 0 failures, and refuses outright when given no corpus directory. Reference figures counted as the work happened, never derived from input sizes: 4,364 studies decoded, 151,607 match tests, 25,784,541 characters scanned.

**THE REGISTER, COMPLETE — all 43 rows, no sampling.** A study may appear in several rows; each membership is counted once. `n` is studies in the row of any type; `TREAT` is INTERVENTIONAL studies whose registry `primaryPurpose` is exactly TREATMENT; the grade is computed over the TREAT subset only, and a row with `n > 0` and `TREAT = 0` is graded `NO_TREATMENT_TRIAL` — the phrase occurs in this disease's registry, but never as a therapy under test.

| row | family | declared intent | n | TREAT | observational | posted results | RESULT refs | DERIVED refs | grade |
|---|---|---|---|---:|---:|---:|---:|---:|---|
| `approved_ipf` | PHARMACOLOGICAL | THERAPEUTIC | 118 | 76 | 34 | 31 | 2 | 38 | REPORTED |
| `pde4b` | PHARMACOLOGICAL | THERAPEUTIC | 9 | 8 | 1 | 3 | 0 | 4 | REPORTED |
| `lpa1` | PHARMACOLOGICAL | THERAPEUTIC | 11 | 10 | 0 | 2 | 0 | 2 | REPORTED |
| `integrin_avb6` | PHARMACOLOGICAL | THERAPEUTIC | 6 | 4 | 0 | 4 | 0 | 4 | REPORTED |
| `autotaxin` | PHARMACOLOGICAL | THERAPEUTIC | 3 | 3 | 0 | 3 | 0 | 3 | REPORTED |
| `tnik` | PHARMACOLOGICAL | THERAPEUTIC | 4 | 4 | 0 | 1 | 0 | 1 | REPORTED |
| `galectin3` | PHARMACOLOGICAL | THERAPEUTIC | 2 | 2 | 0 | 2 | 0 | 2 | REPORTED |
| `ctgf` | PHARMACOLOGICAL | THERAPEUTIC | 5 | 5 | 0 | 3 | 0 | 3 | REPORTED |
| `il13_il4` | PHARMACOLOGICAL | THERAPEUTIC | 6 | 5 | 0 | 3 | 0 | 2 | REPORTED |
| `tgfbeta` | PHARMACOLOGICAL | THERAPEUTIC | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |
| `rock` | PHARMACOLOGICAL | THERAPEUTIC | 2 | 1 | 0 | 1 | 0 | 0 | REPORTED |
| `jak` | PHARMACOLOGICAL | THERAPEUTIC | 2 | 2 | 0 | 0 | 0 | 0 | NOT_KNOWN |
| `mtor` | PHARMACOLOGICAL | THERAPEUTIC | 6 | 5 | 0 | 1 | 1 | 2 | REPORTED |
| `antioxidant_nac` | PHARMACOLOGICAL | THERAPEUTIC | 7 | 6 | 1 | 3 | 1 | 3 | REPORTED |
| `immunosuppression` | PHARMACOLOGICAL | THERAPEUTIC | 33 | 30 | 1 | 7 | 5 | 11 | REPORTED |
| `anticoagulant` | PHARMACOLOGICAL | THERAPEUTIC | 2 | 2 | 0 | 1 | 0 | 2 | REPORTED |
| `vasodilator` | PHARMACOLOGICAL | THERAPEUTIC | 42 | 38 | 3 | 15 | 3 | 18 | REPORTED |
| `inhaled_delivery` | DELIVERY_ROUTE | DELIVERY | 60 | 45 | 3 | 9 | 2 | 14 | REPORTED |
| `cell_therapy` | BIOLOGICAL | THERAPEUTIC | 25 | 21 | 3 | 1 | 0 | 1 | REPORTED |
| `nucleic_acid` | BIOLOGICAL | THERAPEUTIC | 1 | 1 | 0 | 0 | 0 | 0 | NOT_KNOWN |
| `antimicrobial` | PHARMACOLOGICAL | THERAPEUTIC | 9 | 7 | 1 | 2 | 1 | 4 | REPORTED |
| `photobiomodulation` | PHOTONIC | THERAPEUTIC | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |
| `laser_any_context` | PHOTONIC | MEASUREMENT | 1 | 0 | 1 | 0 | 0 | 0 | NO_TREATMENT_TRIAL |
| `infrared_any_context` | PHOTONIC | MEASUREMENT | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |
| `ultrasound_therapeutic` | ACOUSTIC | THERAPEUTIC | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |
| `electrostim` | FREQUENCY | THERAPEUTIC | 3 | 2 | 0 | 0 | 1 | 1 | REPORTED |
| `whole_body_vibration` | FREQUENCY | THERAPEUTIC | 1 | 1 | 0 | 0 | 0 | 0 | NOT_KNOWN |
| `em_field_therapy` | FREQUENCY | THERAPEUTIC | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |
| `oscillometry_measurement` | FREQUENCY | MEASUREMENT | 3 | 0 | 3 | 0 | 0 | 0 | NO_TREATMENT_TRIAL |
| `vibrating_mesh_delivery` | FREQUENCY | DELIVERY | 1 | 1 | 0 | 0 | 0 | 0 | NOT_KNOWN |
| `airway_clearance_oscillation` | FREQUENCY | THERAPEUTIC | 1 | 1 | 0 | 0 | 0 | 0 | NOT_KNOWN |
| `oxygen` | SUPPORTIVE | THERAPEUTIC | 42 | 25 | 7 | 1 | 1 | 11 | REPORTED |
| `rehabilitation` | SUPPORTIVE | THERAPEUTIC | 90 | 47 | 22 | 4 | 4 | 24 | REPORTED |
| `transplant` | SURGICAL | THERAPEUTIC | 36 | 22 | 8 | 3 | 1 | 7 | REPORTED |
| `ventilation` | SUPPORTIVE | THERAPEUTIC | 8 | 5 | 3 | 0 | 0 | 1 | NOT_KNOWN |
| `palliative` | SUPPORTIVE | THERAPEUTIC | 18 | 10 | 2 | 4 | 0 | 9 | REPORTED |
| `gerd` | PHARMACOLOGICAL | THERAPEUTIC | 3 | 3 | 0 | 1 | 1 | 1 | REPORTED |
| `vaccine` | BIOLOGICAL | THERAPEUTIC | 10 | 8 | 0 | 3 | 2 | 3 | REPORTED |
| `nutrition` | SUPPORTIVE | THERAPEUTIC | 27 | 19 | 4 | 1 | 2 | 6 | REPORTED |
| `digital` | DIGITAL | THERAPEUTIC | 14 | 2 | 1 | 0 | 0 | 5 | NOT_KNOWN |
| `traditional` | TRADITIONAL | THERAPEUTIC | 5 | 3 | 2 | 0 | 0 | 1 | NOT_KNOWN |
| `psychosocial` | SUPPORTIVE | THERAPEUTIC | 14 | 4 | 3 | 1 | 0 | 5 | REPORTED |
| `NEGATIVE_CONTROL` | CONTROL | CONTROL | 0 | 0 | 0 | 0 | 0 | 0 | **ABSENT** |

The `NEGATIVE_CONTROL` row is a deliberately impossible bucket. It reads 0, which is what proves the register is not matching everything it is shown.

**The frequency and photonic family, pulled out because they are the ones a reader will look for:**

| row | family | declared intent | n | TREAT | grade |
|---|---|---|---|---|---|
| photobiomodulation | PHOTONIC | THERAPEUTIC | 0 | 0 | **ABSENT** |
| infrared_any_context | PHOTONIC | MEASUREMENT | 0 | 0 | **ABSENT** |
| laser_any_context | PHOTONIC | MEASUREMENT | 1 | 0 | NO_TREATMENT_TRIAL |
| ultrasound_therapeutic | ACOUSTIC | THERAPEUTIC | 0 | 0 | **ABSENT** |
| em_field_therapy | FREQUENCY | THERAPEUTIC | 0 | 0 | **ABSENT** |
| electrostim | FREQUENCY | THERAPEUTIC | 3 | 2 | REPORTED |
| whole_body_vibration | FREQUENCY | THERAPEUTIC | 1 | 1 | NOT_KNOWN |
| airway_clearance_oscillation | FREQUENCY | THERAPEUTIC | 1 | 1 | NOT_KNOWN |
| vibrating_mesh_delivery | FREQUENCY | DELIVERY | 1 | 1 | NOT_KNOWN |
| oscillometry_measurement | FREQUENCY | MEASUREMENT | 3 | 0 | NO_TREATMENT_TRIAL |

**Photobiomodulation for pulmonary fibrosis is ABSENT, and the absence is measured rather than blind.** The detector fires hard on its own universes and is near-silent on this disease's — see the published lexicons in §5. What exists in the frequency family for this condition is small and real: three neuromuscular-electrical-stimulation studies, one whole-body-vibration study, one airway-clearance oscillation study, one vibrating-mesh nebuliser study.

**Two false positives were found in our own lexicon during the first pass and excised**, both in the direction that would have flattered this arm. NCT03901196 entered the photobiomodulation row on the word *laser* — it is laser-induced breakdown **spectroscopy**, a tissue-imaging diagnostic, `OBSERVATIONAL`, `primaryPurpose` empty. Had it stood, this arm would have reported "one photobiomodulation study in pulmonary fibrosis, GRADE REPORTED". And "Oscillation Mechanics of the Respiratory System" entered a frequency-therapy row on *oscillat*: forced oscillometry is a lung-function **measurement**, and *vibrat* was catching vibrating-mesh nebulisers, a delivery device. The frequency family is now six declared rows with intent stated per row, and `photobiomodulation` reads ABSENT.

**The pharmacological register, by contrast, is dense.** Complete enumeration of every PHASE3 or PHASE2+PHASE3 study in U1_PF whose registry `primaryPurpose` is TREATMENT: **84 trials, of which 37 are graded REPORTED and 47 NOT_KNOWN**, each printed with its endpoint verbatim. The TNIK row within it is **n = 4, TREAT 4, one with posted results, grade REPORTED** — the four trials in §3. Alongside, the register prints every TERMINATED, WITHDRAWN and SUSPENDED study in the condition — **93 of them, 87 with a stated reason** — in the registry's own unedited words. That list is not a comment on any one programme; it is what drug development in this disease has looked like, and it is the reason a new mechanism reaching phase 3 is worth reporting carefully.

---

## 5. What the adversarial pass changed

Every repair an adversarial reading named was re-derived from the bytes and applied. Six defects were found — five named by the lens, one found while re-deriving. **None of them is hidden here, because a page that repairs quietly has not repaired at all.**

**A1 · "ZERO light-therapy trials name a lung condition of any kind" — REFUTED, and replaced.** Over the distinct union of PBM and LLLT trials, with the condition lexicons published in full and every hit named: a deliberately broad lexicon returns **35**; a strict lexicon confined to lung and lower-respiratory-tract disease returns **9**, of which **7** are INTERVENTIONAL with `primaryPurpose = TREATMENT` — two COPD studies, three respiratory-failure studies, one bronchiolitis, one asthma, one COVID-19 pneumonia and one post-COVID ARDS. A separate upper-airway row (obstructive sleep apnoea and tonsillar obstruction) holds **5** more. A declared borderline is stated rather than buried: **10** further trials name a COVID token with no respiratory word beside it, so the honest figure is **9 or 19 depending on where a reader draws the line, and it is never zero**. What survives, narrower and still true: **0 of the 1,115 light-therapy trials name pulmonary fibrosis or interstitial lung disease.** Controls: the strict lexicon fires on 832 of 895 pulmonary-fibrosis trials, and a nonsense token matches nothing.

**A2 · The broad lexicon's own false positives, named.** Twelve of the 35 broad-row hits are not lungs at all: eleven are dental **alveolar** bone (ridge augmentation, alveolar osteitis, inferior alveolar nerve injury) and one is **thoracic** outlet syndrome, a nerve-compression condition. *Alveolar* and *thoracic* are homographs. All twelve are listed by NCT id in the program output and excised from the count.

**A3 · "1,285 light-therapy trials" was 579 + 706 with the overlap counted twice.** Measured: **170 trials appear in both universes; the distinct union is 1,115.** Every downstream sentence now uses 1,115.

**A4 · "901 wavelength literals" does not survive a scope change, and was the same double-count wearing a unit.** With this page's matcher, the per-universe sum is 465 + 452 = **917** while the distinct union at the same scope is **765** — **152 literals counted twice**. And the count moves with the fields you read. Same bytes, same matcher, five declared scopes over the 1,115-trial union:

```
  S1  interventions only (type + name + description + otherNames)   765 literals in 472 trials
  S2  S1 + briefTitle + officialTitle                               824 literals in 481 trials
  S3  S2 + briefSummary                                            1034 literals in 533 trials
  S4  S3 + primaryOutcome measures                                 1035 literals in 533 trials
  S5  S4 + detailedDescription                                     1434 literals in 602 trials
```

A bare wavelength count is withdrawn; every one on this page now carries its scope. Found while re-deriving this: **the register arm's own pinned page corpus was fetched without `descriptionModule` at all**, so any text count over it was silently interventions-and-titles only whether or not it said so. The scope table above is therefore run over the wider corpus that does carry those fields, and the program prints both.

**A5 · The detector lexicons are published, so the integers can be refuted.** Two independently written word lists, both printed in the program output, run over the same bytes at the same declared scope:

```
                 n      LEXICON A    LEXICON B
  U3_PBM       579           544          565
  U4_LLLT      706           675          698
  U1_PF        895             0            5
```

The two disagree by 21 and 23 trials — which is exactly why the word list is published beside the count. **The discrimination survives on both**: each fires on the light-therapy universes and is near-silent on the pulmonary-fibrosis universe, which is the property the ABSENT verdict rests on.

**A6 · "Tied: 46" was a per-mille bucket, not a tie.** Under floored per-mille comparison the earlier arm reported higher 5,712 / tied 46 / lower 414, and that reproduces exactly. Under **exact rational comparison** — cross-multiplication of integers, no division — the answer is **higher 5,713 · exactly equal 1 · lower 458**, and the one is TNIK itself. **No other regulator in the corpus shares TNIK's recurrence rate.** The floored bucket over-counted equality by 45. The same correction applies in the size-matched band (24 bucket-mates, 1 exact) and among the master regulators (1 bucket-mate, 0 exact).

**A7 · A duplicate check measured on one network was stated for the corpus.** Re-run on all 25: **0 networks carry a duplicate edge, 0 duplicate edges in total.** The original conclusion holds; the original evidence did not cover it.

**A8 · "Present in all 25 networks" is the corpus norm, not a finding.** Counted: **5,888 of 6,172 regulators (95%) appear in all 25**, as do 1,235 of the 1,279 size-band members and 1,086 of the 1,115 master regulators. TNIK's presence in all 25 is unremarkable and is reported as such.

**A9 · A reference figure was 10 too high.** The earlier arm printed 12,548,913 lines parsed. The corpus carries **12,548,903** across all 26 files; the repair program's independent per-file sum and `wc -l` both agree.

**A10 · An HGNC mapping bug introduced during the repair, caught by its own control.** A single-pass symbol map lets an earlier row's *alias* claim a symbol that is a later row's **approved** symbol — measured to mis-map `AR` to 231 and `CDH1` to 51343, which then dropped 10 master regulators out of the corpus population. Fixed with three passes in authority order (approved, then prev_symbol, then alias_symbol), with two arms pinning `AR → 367` and `CDH1 → 999`. After the fix all 1,115 master regulators map and all 1,115 are present, matching the original arm exactly.

---

## 6. What we claim, and what we do not

> **We claim:** the submitted structural identifiers are correct, verified per element and cross-checked against three independent public registries that agree on formula and on heavy-atom connectivity. We claim, as measurements from pinned public bytes: TNIK is **not** a landmark gene (`pr_is_lm = 0`); TNIK is a master regulator in **none** of the five published sets; rentosertib is **ABSENT** from both LINCS perturbagen tables while positive controls in the same lookup return non-zero; photobiomodulation, therapeutic ultrasound and electromagnetic-field therapy are **ABSENT** from the pulmonary-fibrosis registry with a detector proven to fire elsewhere; and the four registered rentosertib trials are as tabulated, with the completed phase 2 graded REPORTED on posted registry results and the phase 3 not yet recruiting. We claim the network integers in §4 are complete counts over 12,017,368 edges, with the corpus size cross-checked two independent ways.
>
> **We do not claim:** any network-recovery number, signature-reversal score, recovery fraction, binding figure, dose, exposure, mechanism or efficacy estimate for rentosertib — our instruments cannot reach those questions and no number for them appears anywhere on this page. We do not characterise the phase 2 readout in either direction. We do not call this drug safe and we do not call it unsafe; neither verdict is ours to give and neither follows from this arithmetic. We do not claim a low network degree means a target is unimportant, and we would not have claimed the reverse from a high one — the corpus is tumour tissue and the disease is a fibrotic lung. We do not claim ABSENT means a modality could not work; it means zero registered trials, counted. The honest edge word on everything unbound is: *not known.*

---

## The call

**On the instruments.** Three of them earn their keep here and one is out of range. The structural lock is exact, discriminating and re-derivable — it caught nothing wrong in this molecule's identifiers, which is the result it is supposed to give when the identifiers are right, and it would have named the element if one had moved. The modality register is a complete, grade-bearing map of what has been tried in this disease and what is countable in each attempt. The network arm is a complete count that says what it counted. **The Study 26 recovery machinery is out of range for this drug, and the page publishes that gap rather than a number to fill it.**

**On the drug. Affine.Earth does not call rentosertib safe, and does not call it unsafe.** What exists publicly is a completed phase 1, a completed phase 2 whose primary endpoint was safety and whose results are posted, a second phase 2 recruiting, and a phase 3 registered at n = 320 with FVC decline over 52 weeks as its primary endpoint. Nobody should take or withhold anything on the strength of this page, and no clinical decision belongs to it.

**Where a bench should point.** Four places, all of them outside what we measured. **One:** a lung-tissue regulatory network — we hold none, and every network statement on this page would be replaced by a better one if a fibrotic-lung network existed to run against. **Two:** a modern perturbational expression dataset that includes this compound, since LINCS predates it by years; that single addition would make the signature question answerable rather than out of range. **Three:** whether TNIK's inferred L1000 value tracks its measured value, which is the difference between a model output and an observation for every inferred gene, not only this one. **Four:** the phase 3's FVC readout, which is the only one of the four that will settle anything.

**And the standing condition, stated as a condition and not as a verdict.** If rentosertib proves efficacious and nothing better exists, **this program will say so, and say it loudly.** The evidence that triggers that is named in advance so it cannot be moved afterwards: **a positive, reported primary readout on NCT07687459 — the annual rate of FVC decline in millilitres over 52 weeks, n = 320 — with results posted to the registry or published, and no approved or late-stage alternative showing a larger effect on the same endpoint.** On that evidence this page will be rewritten to promote it, in the same register and with the same discipline it is written in now. We are not taking sides. We are stating the trigger, in public, before the data exists.

---

## Run it yourself

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# 1. the structural lock — formula per element, four sources, registry cross-check
swiftc -O -swift-version 5 reproduce/rentosertib-structure-lock-exact.swift -o /tmp/lock
/tmp/lock                       # no corpus: 75 structural arms run, EXIT 1, corpus claims NOT MEASURED
/tmp/lock <gene_info.txt> <mr_by_cohort_union.tsv> <GSE92742_pert_info.txt> <GSE70138_pert_info.txt>

# 2. the network arm and its five repairs
swiftc -O -swift-version 5 reproduce/tnik-network-degree-exact.swift -o /tmp/tnik
swiftc -O -swift-version 5 reproduce/tnik-repairs-exact.swift       -o /tmp/tnikfix
/tmp/tnikfix                    # no argv: REFUSED, exit 2 — a gate given nothing must not pass
/tmp/tnikfix <study26-root>

# 3. the modality register and its five repairs
swiftc -O -swift-version 5 reproduce/modality-register-exact.swift  -o /tmp/reg
swiftc -O -swift-version 5 reproduce/modality-repairs-exact.swift   -o /tmp/regfix
/tmp/regfix <pinned-page-corpus-dir> <wider-field-jsonl-dir>

# the registry lookups, login-free, no key, no agreement
curl -s "https://clinicaltrials.gov/api/v2/studies?query.term=INS018_055&countTotal=true"
curl -s "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/ZVDNXHUSIKGTSF-UHFFFAOYSA-N/property/MolecularFormula,InChIKey/JSON"
curl -s "https://www.ebi.ac.uk/chembl/api/data/molecule.json?molecule_structures__standard_inchi_key=ZVDNXHUSIKGTSF-UHFFFAOYSA-N"
curl -s "https://gsrs.ncats.nih.gov/api/v1/substances(M9NU5G8WXY)?view=full"
```

Every program takes its corpus paths from `argv`; no absolute path is baked into any published source. Every one hashes its inputs and refuses on a mismatch, prints its reference figures on **every** exit path including refusals, and exits non-zero when it is given nothing.

Source digests, and a correction about the word *seal* — dated 2026-09-09.

**These five values are digests of the PROGRAMS, not seals over a measurement, and this block used
to call the last one a SEAL.** It is the sha256 of the five sources concatenated. That is
provenance — it says which instrument ran — and it says nothing about what the instrument
returned. A seal in this programme is a digest over the **measurement**: every figure, every arm,
every histogram, and no path, no timing and no source text. Measured on 2026-09-09: none of these
three programs accumulates a transcript or computes a digest over its own results, so **there is
no seal on this page to publish, and the honest thing is to say so rather than to let a source
digest stand in for one.** The block below is relabelled and the word is not reused.

```
MARKER  TNIK_NETWORK_ARM_FIVE_REPAIRS_APPLIED
MARKER  MODALITY_REGISTER_ARM_FIVE_REPAIRS_APPLIED

SOURCE DIGESTS — which instrument ran. NOT a seal over any result.
sha256 rentosertib-structure-lock-exact.swift  3435844fade80cd481ce1117f25501218c62cc73e87a02293c7ab47a4dbe8911
sha256 tnik-network-degree-exact.swift         6878995bf82d4ba514b16285262cd57f65f484d5c931f2f5b22a5fe5ea05d3f5
sha256 tnik-repairs-exact.swift                b855df532d59a7f7836b3a9bc5f0082261683f4baf4895f9bb0f1fed586df979
sha256 modality-register-exact.swift           d2fe1e9700b167affd7ec54ea656efadc76a55e1c839189b5a90d30c1fef3259
sha256 modality-repairs-exact.swift            0e2e8da4afec8c8fd9e893f2c133cf55285352a30b8d50e2db6b2c659d9adf10

SOURCE-SET DIGEST  (the five sources concatenated in the order above)
      2d8bd906268f1e7a4594d47299d799f00a99ada1095f3aaca4083521c240b9a7

TRANSCRIPT SEAL  NONE. These programs seal no measurement.
```

**And this is why rentosertib is an OPEN SLOT in the Library of Compound Cures rather than an
entry, which until today was a decision that happened to be right for a reason nobody had
written down.** The admission law's clause E5 requires a seal the named program actually prints,
checked against the region of its output the run computed. None of these three prints one. So an
entry for this drug cannot be admitted on the evidence that exists, and the condition that would
fill the slot is now specific and cheap: **give the three programs a transcript seal.** Until then
the page's arms stand as figures a reader can re-derive by running the programs, and the library
records the gap by name instead of quietly not having it.

## Sources

- Compound identifiers: [PubChem CID 164938183](https://pubchem.ncbi.nlm.nih.gov/compound/164938183); [ChEMBL CHEMBL5969552](https://www.ebi.ac.uk/chembl/compound_report_card/CHEMBL5969552/); [NCATS GSRS UNII M9NU5G8WXY](https://gsrs.ncats.nih.gov/ginas/app/beta/substances/M9NU5G8WXY). CAS 2828567-39-9.
- Trial record: [NCT05154240](https://clinicaltrials.gov/study/NCT05154240), [NCT05938920](https://clinicaltrials.gov/study/NCT05938920), [NCT05975983](https://clinicaltrials.gov/study/NCT05975983), [NCT07687459](https://clinicaltrials.gov/study/NCT07687459), via the [ClinicalTrials.gov v2 API](https://clinicaltrials.gov/data-api/api).
- Landmark-space definition and perturbagen tables: LINCS L1000, [GSE92742](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE92742) and [GSE70138](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE70138); digests pinned in §2.
- Gene symbol map: [HGNC complete set](https://www.genenames.org/download/archive/).
- Master-regulator sets and the 25-network regulon corpus: [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds.md).

## Related

- [The one safety question made exact](The-Safety-Question-Made-Exact.md) — the same discipline where the exact instrument *does* reach the drug.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas.md) · [CRISPR genome off-target map](CRISPR-Genome-Off-Target-Map.md)
- [Cures without the gatekeeper](Cures-Without-The-Gatekeeper.md) · [Library of compound cures](Library-Of-Compound-Cures.md)

*Grades: VERIFIED / REPORTED / MEASURED / ABSENT / NOT_KNOWN. ABSENT, REFUSED and NOT_KNOWN are three different answers and are never printed alike. This review grades instruments; it does not grade a medicine.*

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
