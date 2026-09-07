# The one place in 5,165,782 residues where a generated sequence touches a human protein at motif length

The population entry says no generated sequence occurs in the human proteome. This entry
says where the population comes closest, once, and names the protein it comes closest to.
The entry is the block; everything outside it is commentary and carries no claim.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  ACCESSION
IDENTITY       Q14258
TITLE          TRIM25 Q14258 — the unique 12-residue maximum of the generated population
MEASURED       Exactly 1 of the 78,680 generated sequences reaches a 12-residue exact shared substring with a reviewed human protein: sequence Lymphoma_504, length 76, sharing LETFLAKSRPEL with Q14258 beginning at residue 441, 1-based. It is the unique maximum of the population: 0 sequences reach 11 residues and 12 sequences reach 10.
PROGRAM        protein-novelty-exact
FIGURE         Lymphoma_504                      76   12      Q14258     441                 LETFLAKSRPEL
FIGURE         12             1           12               1
FIGURE         observed minimum 5, observed maximum 12
FIGURE         8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — the same run and the same seal as the population entry; the tie rule is that among all longest matches the smallest reference position wins, and arm A12 tests it against an independent scan
REFUSED        not a binding claim. Nothing here measured whether this fragment binds Q14258, or anything else. A shared string is a string
REFUSED        not homology. 12 exact residues out of 76 is an exact-substring coincidence in the tail of an eleven-bin distribution, and the same program measures the null that predicts it
REFUSED        not a target. Q14258 names where in the reference the fragment occurs. It was not selected, not assayed, and is not proposed as a partner
REFUSED        not a cure and not safe, on the same terms as the population this sequence belongs to
FALSIFIER      a screen of the same two digests returning any sequence with a longest shared substring above 12, or returning this fragment at a different accession or a different residue offset
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
NOTE           The residue index is 1-based within Q14258, so a reader can confirm both the fragment and its position with grep against the pinned reference and without this program.
ADDED          2026-09-07
```

**Why this entry exists separately from the population.** The population's claim is a
count over 78,680 sequences. This is a claim about one of them, and it is the only
sequence in the corpus that carries an individual measurement — every other row in the
distribution is a member of a tier, not a maximum.
