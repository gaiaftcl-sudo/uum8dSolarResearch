# corpus/gene-length-instrument — provenance

One file, 19,704 genes, every column an aggregate property of a gene. No individual's DNA is
here, no genotype, no variant call, and nothing that could be traced to a person.

## gene_model_constraint.tsv

`gene_id  symbol  chrom  start_pos  end_pos  gene_len  cds_length  loeuf_num  loeuf_den  exp_lof  obs_lof`

- **Coordinates and lengths** — the GRCh37 gene model, protein-coding genes with a defined
  interval. `gene_len = end_pos - start_pos + 1`, the genomic span, which is what a nearest-gene
  rule actually measures a distance to.
- **`cds_length`** — coding sequence length in bases.
- **`loeuf_num` / `loeuf_den`** — gnomAD's LOEUF as an EXACT RATIONAL. LOEUF is published as a
  decimal; storing it as a fraction is what lets the program compare two genes by
  cross-multiplication and never divide on a decision path. Denominators differ between rows and
  that is fine: the comparator handles it, and a program that first converted to a common decimal
  would have thrown away the exactness it is claiming.
- **`exp_lof` / `obs_lof`** — gnomAD's expected and observed loss-of-function counts. The expected
  count is LOEUF's denominator, and it is a function of coding length. That is the whole subject
  of section 2 of the study.

Both sources are public and need no account: the Ensembl/GENCODE gene model and the gnomAD
constraint release. Neither is redistributed whole here — this is the column slice the study reads.

## What is NOT here

No variant list. The catchment figures are computed from the gene model alone, by measuring every
base of every catchment, so a reader does not need to download 13 million variant positions to
check them — and so the result cannot be an artefact of which variants someone chose.
