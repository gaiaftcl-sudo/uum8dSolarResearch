# 78,680 generated sequences, counted against the reviewed human proteome

The entry is the block. Everything outside it is commentary and carries no claim.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the 78,680 generated sequences, pinned in corpus/eric/SHA256SUMS
TITLE          Generated peptides against the human proteome — exact substring screen
MEASURED       0 of 78,680 generated sequences occur in the reviewed human proteome. 5,165,782 generated residues matched against 11,418,237 reference residues over 20,431 proteins, complete enumeration, no sampling. Longest exact shared substring 12 residues against a median generated length of 66, reached by 1 sequence.
PROGRAM        protein-novelty-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         corpus rows       78680
FIGURE         reference residues 11418237
FIGURE         8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          VERIFIED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — one file, no imports beyond Foundation, 12 self-test arms in both directions
REFUSED        not a cure, and not a claim of efficacy against any of the 16 cancer labels these sequences carry
REFUSED        not safe. Structure, folding, binding, immunogenicity, toxicity, protease stability and off-target activity were not measured
REFUSED        not unrelated to human proteins. This screen measures exact substring identity. Homology under substitution is a different measurement, not a refinement of this one, and it was not made here
REFUSED        the source corpus confidence, coherence, overall_score and validation_passed columns are Doubles and are barred from every verdict here
FALSIFIER      a screen of the same two digests returning any occurrence of a generated sequence in the reference, or a longest exact shared substring above 12 residues
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

**What this is.** Novel chemical matter, at primary-sequence resolution, and nothing
further. The strongest word the arithmetic supports is *absent from the proteome as
exact strings*.
