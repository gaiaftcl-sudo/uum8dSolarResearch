# The overlap that does exist is what chance predicts

"Absent from the proteome" and "no closer to the proteome than composition alone forces"
are two different claims. The population entry carries the first. This entry carries the
second, and it is the weaker-sounding one that a sceptical reader should want.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the 78,680 generated sequences, put to the question of whether their residual overlap with the proteome exceeds chance
TITLE          Residual overlap against an integer null handed the corpus's own composition
MEASURED       Against a null that draws residues at the MEASURED composition of each side — aligned-pair match probability 55,372 ppm, where a uniform 20-letter alphabet would be 50,000 ppm — the residual overlap is what chance predicts. At L=9 the null expects 249,852,560 millionths of a coincidence and 246 sequences are observed; at L=10 it expects 13,570,309 millionths and 13 are observed; the single sequence reaching 12 stands against an expectation of 39,993 millionths.
PROGRAM        protein-novelty-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         aligned-pair match probability = 3266100739639 / 58984123166334 = 55372 ppm
FIGURE         9     249852560                      246
FIGURE         10    13570309                       13
FIGURE         12    39993                          1
FIGURE         8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — the probability is an exact integer ratio and its powers are taken in Int128 fixed point, so no float enters this section either
REFUSED        not a claim of unrelatedness under substitution. This null is built on the same exact-match statistic as the observation, so neither of them can speak past exact-substring resolution, and a reader who drops that qualifier has read a stronger sentence than the arithmetic supports
REFUSED        not a p-value and not an e-value. No e-value is computed anywhere in this program
REFUSED        not a claim that the 12-residue maximum is meaningless. It is a coincidence to be checked, not a homology to be claimed
REFUSED        not a finding of safety, and not a cure
FALSIFIER      a recount over the same two digests returning observed sequence counts above the null expectation at any length of 9 residues or more
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
NOTE           Expected coincidences count aligned query-reference position pairs; the observed column counts SEQUENCES. At 9 residues and above a sequence almost never carries two coincidences, so the two columns are comparable there and not below it.
ADDED          2026-09-07
```
