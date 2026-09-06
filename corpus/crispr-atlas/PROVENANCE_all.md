# Corpus — every guide RNA the registry publishes

The first version of this screen carried two guides, found by searching NCATS GSRS for drug names
recalled from memory. That is a completeness defect no harness can catch: a guide nobody recalls is
silently absent from a safety map. The registry is enumerated instead.

## How the guides were found

All 742 substances of class `nucleicAcid` were fetched from GSRS and scanned for the **canonical
SpCas9 sgRNA scaffold** `GUUUUAGAGCUAGAAAUAGCAAGU`. Fifteen carry it. In every one the scaffold
begins at position 20, so the spacer is the preceding 20 bases — which is what makes the 20-base
reading a measurement rather than a convention.

Finding them by structure rather than by name recovered guides that a name search missed, and it
vindicated an earlier refusal rather than overturning it. `NTLA-2001`'s own record is the full
4,423-base molecule carrying the Cas9 messenger RNA, with no isolatable spacer, and it was refused.
Its guide exists under a **separate** record — `Nexiguran`, UNII `5G537B4BTJ` — and the enumeration
found it. Refusing to guess at the mRNA record lost nothing.

## The cut site is measured, not declared

Most guide records carry no target annotation, so requiring a declared target chromosome cannot
enumerate a registry. A guide's measured cut site is where its **zero-mismatch** match actually
falls in the assembly. Off-targets are the sites outside it. A guide with no zero-mismatch site
anywhere gets **no** off-target list, because its published spacer and the assembly disagree.

## The assembly

GENCODE GRCh38 primary assembly, sha256
`b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca`, 3,099,750,718 bases across 194
sequences. Pinned by URL and digest rather than committed.
