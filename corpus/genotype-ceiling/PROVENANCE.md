# corpus/genotype-ceiling — provenance

Every file here is a slice of public, login-free data. No individual genotype is present,
none was used, and nothing here can be applied to a person.

## focal_h2se.tsv — 56 rows, `trait_id \t h2_liability \t standard_error`

Neale lab UK Biobank round-2 GWAS, univariate LDSC heritability release
(`h2univar` / `ukb31063_h2_topline`), European stratum. These are AGGREGATE summary
statistics: one heritability estimate and one standard error per phenotype.

The 56 are the load-relevant phenotypes named in the study's frozen criteria before any
ceiling was computed — sleep and circadian (F2), affect and neuroticism (F3, F4, F7),
general health (F5), risk (F6) and work/employment (F1) — restricted to those carrying
BOTH an h2 and a standard error. A phenotype with no standard error is absent, not zero.

## focal_labels.tsv — `FAM \t DESCRIPTION \t h2_liability \t h2_z \t TRAIT`

The same 56 with the UK Biobank field description and the LDSC z. **The C_lo / C_point /
C_hi columns were REMOVED before staging**, so the program cannot read the number it is
supposed to compute; `genotype-score-ceiling-exact.swift` refuses outright if a C column
reappears in the header.

## pgs_perf_fam.tsv — 1,105 rows

The PGS Catalog `performance_metrics` table, restricted to the seven trait families above
and to European-evaluated rows. Columns are the Catalog's own: performance id, score id,
reported trait, metric, value, ancestry, sample and publication. The full table is 22,959
rows and is fetched from https://www.pgscatalog.org/ without an account.

## trait_pins.tsv — 12 rows

The mapping from a PGS Catalog reported-trait string to a UK Biobank field id, written
before any comparison ran. A published score is compared to a ceiling only where this file
names the pair; every other row is ABSENT, and absence is printed as absence.

## What is NOT here

No individual-level data of any kind. No genotype, no phenotype record, no participant.
Every byte is an aggregate statistic already published by its consortium.
