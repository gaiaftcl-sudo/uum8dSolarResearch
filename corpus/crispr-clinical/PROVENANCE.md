# Corpus — every clinical CRISPR guide with a public, login-free spacer

Scout pass, measured 2026-09-07. Nothing in this file is recalled; every number below has a
command beside it that re-measures it.

## What this expands, and why the old rule could not have found these

The published screen (`reproduce/crispr-genome-offtarget-exact.swift`) carried **15** guides. They
were found by scanning all 742 NCATS GSRS substances of class `nucleicAcid` for **one** string —
the canonical SpCas9 sgRNA scaffold `GUUUUAGAGCUAGAAAUAGCAAGU` — and taking the 20 bases before it.

That rule is exact for what it covers and blind to everything else, in three separate ways, all
three measured here rather than argued:

1. **A scaffold variant is not the canonical scaffold.** `CS-101-hsgRNA` and `CS-101-msgRNA`
   (ataglogene autogetemcel) carry `GUUUGAGAGCUAG` — one base different at position 4 — and were
   invisible. Both carry the ordinary 3' terminator hairpin `GCACCGAGUCGGUGC`, which is how they
   were recovered.
2. **A different nuclease puts the spacer at the other end.** Cas12a and Cas12b guides carry a
   5' repeat and a 3' spacer. Reading "the 20 bases before the scaffold" returns nothing on them.
3. **A registry record need not carry a scaffold at all.** `NULABEGLOGENE AUTOGEDTEMCEL` is
   registered as a bare 20-mer. There is no scaffold to anchor on, and the whole record is the
   spacer.

## How the set was enumerated — three independent detectors, unioned

Every one of the 742 `nucleicAcid` records was fetched (8 pages of 100, `raw/gsrs_na_*.json`) and
its subunit sequences extracted to `raw/all_subunits.tsv` (869 rows over 739 keys). Three detectors
ran over that file:

| detector | rule | distinct substances |
|---|---|---|
| A — registry type | `nucleicAcidType` or `nucleicAcidSubType` names CRISPR / sgRNA / guide / Cas9 | 23 |
| B — structure | the sequence carries any known scaffold or direct-repeat anchor | 22 |
| C — name | the record name says gRNA / sgRNA / crRNA / pegRNA / guide / CRISPR / chRDNA | 23 |
| **union** | | **27** |

No single detector finds all 25 guides, which is the argument for the union: `EXAGAMGLOGENE` and
`Lonvoguran` are typed `OLIGONUCLEOTIDE` and invisible to A; the three Persicabtagene records carry
no anchor in any published family and are invisible to B; `Nexiguran`, `Taziguran` and `Lonvoguran`
are named nothing but themselves and are invisible to C.

Two of the 27 are **refused on structure, not on name**: `Lerepmeran` (2,525nt mRNA transgene) and
`Ataglogene autogetemcel mRNA-L` (4,593nt, encodes the Cas9 D10A protein). Each matched one
detector on a coincidence — a 10nt repeat core inside a coding sequence, and the word CRISPR in a
name. Neither is a guide. **25 guides remain.**

## The spacer boundary is measured, never conventional

`build-corpus.swift` locates the record's own anchor and takes the spacer as the remainder on the
side the nuclease dictates. It prints the offset it used as `anchor_evidence` on every row, and it
**refuses** a record whose declared end has no anchor, rather than returning the first 20 bases.
The control arm proves the refusal fires: declaring `EXAGAMGLOGENE` a 3'-spacer record yields
`REFUSED L28RZ5CC6K NO_3PRIME_ANCHOR_IN_100NT_RECORD` and no row.

WHO states the rule itself for one of them, so the 20-base reading is **sourced**: Proposed INN
List 127 defines nexiguran as *"single-stranded guide RNA (sgRNA) targeting the human transthyretin
(TTR) gene with its 5'-terminal 20 nucleotides"*.

## The nuclease — and therefore the PAM — comes from WHO INN, not from the sequence

GSRS publishes the sequence and no mechanism. Its `nucleicAcidSubType` is unreliable for this: all
three Persicabtagene records are labelled `CAS9 GUIDE RNA` while their structure is a 97nt 5'
scaffold with a 22nt 3' spacer, which no Cas9 sgRNA has.

The mechanism was taken from the WHO INN entry each record's own GSRS reference names. All 26
published Proposed INN lists pl110–pl135 were downloaded; pl136 and later do not exist. Each is a
public, login-free PDF on cdn.who.int. Every one of the 25 guides resolved:

| nuclease | PAM | PAM side | spacer end | guides | INN evidence |
|---|---|---|---|---|---|
| SpCas9 | NGG | 3' of protospacer | 5' of record | 15 | pl124 pl125 pl126 pl127 pl130 pl132 pl133 pl134 |
| SpCas9 D10A base editor | NGG | 3' | 5' | 3 | pl132 (ristoglogene), pl133 (ataglogene) |
| AsCas12a | TTTV | 5' of protospacer | 3' of record | 4 | pl129 (renizgamglogene), pl133 (peclacabtagene) |
| Cas12b | TTN | 5' of protospacer | 3' of record | 3 | pl131 (persicabtagene) |

pl131, verbatim, on persicabtagene lemgedleucel: *"gene-edited using CRISPR/Cas12b"*.
pl133, verbatim, on imvucabtagene geleucel: *"CRISPR/Cas12a ... hybrid RNA-DNA (chRDNA)"*.

## Second source, machine-checked in both directions

WHO INN prints the same molecules as per-residue chemical nomenclature, which also carries the
2'-O-methyl and phosphorothioate pattern GSRS's subunit string does not. `inn-decode.swift` decodes
that nomenclature back to bases and compares. Four arms, and all four behave in the direction they
were built for:

- lonvoguran, pl130 → `GGATTGCGTATGGGACACAA` — **MATCH** to GSRS `D8UQ4B2T7M`
- nexiguran, pl127 → `AAAGGCTGCTGATGACACCT` — **MATCH** to GSRS `5G537B4BTJ`
- lonvoguran against a deliberately corrupted expectation — **DIFFERS**, as required
- a name absent from the text — **ABSENT**, not zero, and not a silent pass

The source's own misspellings are admitted by name and counted on every run
(`citidylyl`×7, `citydyl`×1, `methylcitidylyl`×3, `methylcitydyl`×1) rather than normalised away.

## What is ABSENT, stated as absence

Six CRISPR products have a GSRS record and **no** guide sequence anywhere public: Lumocabtagene
Geleucel, Brinretigene Vesgedparvovec, Motacabtagene Lurevgedleucel, Edeltresgene Autogeleucel,
Imvucabtagene Geleucel, Teotresgene Autogeleucel. Their GSRS records carry no relationship to any
nucleic-acid substance, and their WHO INN entries name the nuclease and the target locus but print
no spacer. **ABSENT, not zero, and not refused.** No spacer for them was inferred from a target
gene name, and none should be.

## Sources, all public and login-free

- **NCATS GSRS** `https://gsrs.ncats.nih.gov/api/v1/substances/search?q=root_substanceClass:"nucleicAcid"&top=100&skip=N`
  — 742 records, no key, no agreement. Full records at `.../substances(<UNII>)?view=full`.
- **WHO INN Proposed Lists** `https://cdn.who.int/media/docs/default-source/international-nonproprietary-names-(inn)/pl<N>.pdf`
  for N = 110…135 — no key, no agreement. Digests in `SHA256SUMS`.
- **GENCODE GRCh38 primary assembly**, sha256
  `b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca`, 845,635,028 bytes
  compressed, 3,099,750,718 bases over 194 sequences. Digest **re-verified today** against the copy
  already held at `study26/raw/genome/`. Pinned by URL and digest, never committed.

## Sources checked and NOT used

- **clue.io / LINCS gated portals** — out of scope by house rule, as the atlas already routed around.
- **DailyMed and ClinicalTrials.gov** are reachable and login-free, and both were opened and
  searched rather than assumed. The Casgevy label (setid `7c3e12ad-e2fe-4d3f-a630-ea7364d9e846`,
  234,162 bytes of SPL XML) mentions "guide RNA" once and contains **zero** runs of 18 or more
  consecutive ACGT characters; the exa-cel spacer `CTAACAGTTGCTTTTATCAC` does not appear in it. The
  nine ClinicalTrials.gov v2 records returned for `query.intr=exagamglogene` contain **zero** such
  runs. Both are the right source for approval status and trial phase and the wrong one for
  sequence. This was measured on those two records, not generalised to every label in either
  service.
- **WHO MedNet** requires an account. Everything used here came from the open cdn.who.int PDFs
  instead, so no gated source is load-bearing.
