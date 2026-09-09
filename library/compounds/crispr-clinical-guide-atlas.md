# Every clinical CRISPR guide with a public spacer, against its own composition

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       61ef3254a8455ee339917368c5d45013072a377592045d2e0494cc99c0fad247
DIGEST_OF      the sealed transcript of the complete genome-wide enumeration for every clinical CRISPR guide whose spacer is public, with every guide's control arm
TITLE          Twenty-five clinical CRISPR guides, complete enumeration under three PAM rules, each ranked against 32 permutations of its own bases
MEASURED       25 guides registered in a public login-free substance registry with a spacer and named in a WHO INN Proposed List: 18 SpCas9 family under NGG, 4 AsCas12a under TTTV, 3 Cas12b under TTN, at each guide's own measured spacer length, across both strands of GRCh38 primary assembly. Every one of the 24 full-length guides has ZERO sites at one mismatch and 22 of 24 have zero at two; the whole off-target burden sits in the 3 and 4 mismatch buckets. 2,718 coordinates are named in full with chromosome, position and strand, and the number of coordinate lines emitted equals the sum of the 24 burdens exactly, 2,718 = 2,718. Against 32 permutations of its own bases each: 0 of 25 sit below their own composition floor and 25 of 25 sit inside the range their own bases produce, where permutation burdens span 0 to 7,718,082.
PROGRAM        crispr-clinical-guide-atlas-exact
FIGURE         61ef3254a8455ee339917368c5d45013072a377592045d2e0494cc99c0fad247
FIGURE         CRISPR_CLINICAL_GUIDE_ATLAS__COMPLETE_ENUMERATION_IS_OBSERVER_INVARIANT
FIGURE         bb188a75837c3384322723c5935da34605cb89caae43cf3b0468572fda60b80c
SEAL           61ef3254a8455ee339917368c5d45013072a377592045d2e0494cc99c0fad247
GRADE          MEASURED
SOURCE         NCATS GSRS spacers with WHO INN Proposed List product names, screened against GENCODE GRCh38 primary assembly, sha256 b760d18dbb651dd14dfc290083371b3ef3bff122d43a9cefb13ca4ecf38f05ca
WHERE_THE_LAW_LIVES  reproduce/crispr-clinical-guide-atlas-exact.swift
REFUSED        not a claim that any of these therapies is safe, or unsafe. Neither verdict is ours to give and neither follows from this arithmetic
REFUSED        not a cut. A site counted here is a place the chemistry COULD direct a cut, not an occupancy, not a clinical event, and not evidence that any medicine harms anyone
REFUSED        not a judgement of anyone's guide design. A therapeutic spacer is dictated by the locus the medicine has to cut while its permutations have no locus to hit, so the control arm is a statement about that constraint and never about design quality
REFUSED        not coverage of the six products whose spacer is not public. For those the honest word is NOT_KNOWN and it is printed as NOT_KNOWN rather than as zero
FALSIFIER      a candidate site in GRCh38 within the reported mismatch range, under the guide's own PAM rule and spacer length, that this enumeration omits; or a coordinate count that does not equal the sum of the reported burdens
REPRODUCE      xcrun swiftc -O -swift-version 5 reproduce/crispr-clinical-guide-atlas-exact.swift -o /tmp/atlas && curl -sL <GRCh38 primary assembly fasta gz> | gunzip -c | /tmp/atlas corpus/crispr-clinical/guides_expanded.tsv
NOTE           The 3,022-line sealed transcript is SHIPPED in the repository as corpus/crispr-clinical/RUN-full-assembly-n32.txt, digest-pinned in that directory SHA256SUMS beside a deliberately truncated control that REFUSES, so the seal can be checked without the 3 GB assembly download. The program itself refuses without the assembly, so in a clean clone this entry reads NOT_KNOWN until it is run or that transcript is given as evidence.
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-09
```
