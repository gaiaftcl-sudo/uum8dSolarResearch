# Is a medicine more specific than the same bases in another order?

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
DIGEST_OF      the sealed transcript of the registry-wide specificity ranking, over every strand, every threshold, every rank interval and every complete histogram
TITLE          Every registry strand ranked against sixteen rearrangements of its own bases
MEASURED       472 registry strands and 17 undesigned constructed 20-mers screened as 186 families of 17 probes each, 5,355,878,467,758 probe-windows counted with no sampling and no cutoff inside the arithmetic. At 4 mismatches: 2 families pair in strictly fewer places than all sixteen permutations of their own bases, 8 tie the lowest, 122 sit inside their own control range, 1 ties the highest, 44 pair in more places than every permutation, and 9 tie all sixteen. 18 strands are UBIQUITOUS, 266 REFUSED and 19 NOT_KNOWN — three silences, none of which is zero off-targets.
PROGRAM        registry-specificity-ranking
FIGURE         2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
FIGURE         717027798090 + 4638850669668 = 5355878467758
FIGURE         169 registry strands + 17 undesigned constructed 20-mers
FIGURE         18 UBIQUITOUS, 266 REFUSED, 19 NOT_KNOWN
FIGURE         BELOW-all-16 2 | ties-lowest 8 | inside 122 | ties-highest 1 |
SEAL           2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
GRADE          MEASURED
SOURCE         NCATS GSRS class nucleicAcid enumerated in full, screened against GENCODE v50 transcripts
WHERE_THE_LAW_LIVES  reproduce/registry-specificity-ranking.swift
REFUSED        not a safety finding. A near-complementary window is a place a molecule COULD pair — not a cut, not an occupancy, not a clinical event. A high rank is not a safety finding and a low rank is not a clearance
REFUSED        not a ranking of medicines against each other. Every comparison on this entry is a strand against permutations of ITS OWN bases, never against another strand, and raw burden is never pooled across lengths
REFUSED        not a claim about the 303 excluded strands. UBIQUITOUS, REFUSED and NOT_KNOWN are three different answers and an excluded strand is never a clean strand
REFUSED        not the chemistry half. Phosphorothioate backbone binding, complement activation, thrombocytopenia and aseptic meningitis are not sequence matches and this program does not reach them
FALSIFIER      a registry strand in the 8-60 nt band this enumeration omits; or a re-run on the same two public inputs reaching a different seal, a different disposition for any family, or a different count of families strictly below all sixteen
REPRODUCE      xcrun swiftc -O -swift-version 5 reproduce/registry-specificity-ranking.swift -o /tmp/rsr && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/rsr
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-08
```
