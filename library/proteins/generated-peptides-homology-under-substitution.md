# Homology under substitution — the screen that answers what the substring screen cannot

This entry is expected to be **HELD** at grading until its program has been run in
this clone. That is the correct state and not a defect: absence of evidence here is
NOT_KNOWN, and NOT_KNOWN is neither admission nor refusal.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the same 78,680 sequences, put to a different question
TITLE          Exact Smith-Waterman against the reviewed human proteome, real against null
MEASURED       Paired against their own shuffles, 36,128 sequences score above and 36,113 below — a coin. The null maximum of 94 exceeds the real maximum of 90, over 118 trillion dynamic-programming cells with BLOSUM62 and integer affine gaps.
PROGRAM        peptide-homology-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         36128
FIGURE         36113
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/peptide-homology-exact.swift, with reproduce/validate-homology.sh
REFUSED        not sealed. The screen is in repair for a completeness figure that was stated unfalsifiably, and until that lands these numbers are measured and unsealed, which is a weaker thing than the substring screen beside it
REFUSED        not a finding of safety. A screen that finds no homology has found no homology and nothing else
FALSIFIER      the repaired program returning a real maximum above its null maximum, or an above/below split materially off a coin
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 peptide-homology-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
