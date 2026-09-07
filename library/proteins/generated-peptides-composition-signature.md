# The composition is a design signature, and it is measured rather than assumed

A stranger reading this library should know what kind of object these sequences are
before reading any claim about them. This entry is that measurement.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the 78,680 generated sequences, put to the question of what their residue composition is
TITLE          Residue composition of the generated population against the reference proteome's own
MEASURED       The population is enriched in lysine and arginine at 198,674 ppm against the reviewed human proteome's own 113,634 ppm, and is simultaneously FLATTER than that proteome: dynamic range, most abundant residue over least, 3,927 thousandths for the corpus against 8,211 for the proteome. The six least abundant corpus residues hold exact counts spanning 1,162, one part in 118, where those same six residues span 3,930 thousandths in the human proteome.
PROGRAM        protein-novelty-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         corpus K+R                   1026307 of 5165782 = 198674 ppm = 19.8674%
FIGURE         reference K+R                1297506 of 11418237 = 113634 ppm = 11.3634%
FIGURE         corpus 3927   human 8211
FIGURE         a spread of 1162 across six residues, which is one part in 118.
FIGURE         8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — counted on both populations from the bytes it has just hashed, and compared against this reference proteome itself rather than against the all-organism Swiss-Prot composition that is usually quoted in its place
REFUSED        not a criticism of the sequences. A designed alphabet is what a generator produces, and stating the provenance is not a verdict on the chemistry
REFUSED        not a claim about function. Composition is not activity, and nothing here measured binding, folding or stability
REFUSED        not a finding of membrane activity. The transcript names the K+R enrichment as the most likely source of nonspecific membrane activity and names it as a SECOND EXPERIMENT, not as a result. It was not measured
REFUSED        not evidence that the population is unnatural in any sense a bench uses. It is evidence that the twenty residue frequencies were drawn from one shared weight rather than from a proteome
FALSIFIER      a recount over the same two digests returning a corpus K+R ppm at or below the reference's, or a corpus dynamic range at or above the reference's, or six least abundant residues spanning more than the reference's range
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
NOTE           Six residues that agree to within a part in a hundred are six draws from one shared weight. An enrichment drawn from a natural background would carry that background's spread with it, and this one does not.
ADDED          2026-09-07
```
