# The second population — 1,400 sequences, screened separately and never pooled

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204
DIGEST_OF      proteins_by_disease.csv — the second generated population, 1,400 sequences over 12 labels
TITLE          The second generated population, screened on its own terms
MEASURED       1,400 sequences over 78,694 residues and 12 labels, lengths 20 to 100. Screened separately from the 78,680 and never pooled with them; intersection with that population is 0. Longest exact shared substring with the reviewed human proteome reaches 9 residues.
PROGRAM        protein-novelty-exact
FIGURE         24cdbf96621e6c38fa046c7a203fcc3ea09e31fad410d9c1cb51f6d192a04204
FIGURE         second rows       1400   residues 78694   lengths 20 to 100   labels 12
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — the same program and the same run as the 78,680 entry, which is why the two entries share one seal and the manifest declares 2 per seal
REFUSED        not pooled with the 78,680. Two populations screened together would let either one carry the other's result, and the intersection being 0 is a measurement, not an assumption
REFUSED        not a cure and not safe, on the same terms as the larger population
REFUSED        the corpus own score columns are Doubles and are barred from every verdict here
FALSIFIER      any sequence present in both populations, or a longest exact shared substring above 9 residues in this population
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
