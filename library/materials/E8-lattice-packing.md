# E8 — the packing the eight-dimensional quantiser stands on

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       E8
SPEC_AUTHORITY The standard root lattice E8, as fixed in Conway and Sloane, Sphere Packings Lattices and Groups — a public mathematical object with a public name
TITLE          E8 against Z^8 at equal covolume, by direct enumeration
MEASURED       Kissing numbers by direct enumeration: Z^8 touches 16 neighbours, E8 touches 240. Both lattices are unimodular at covolume 1; Z^8 has minimal norm 1 and E8 minimal norm 2, so the packing density ratio is exactly 2^4 = 16 — an integer, not an estimate. Same dimension, same covolume, 16 times denser and 15 times as many neighbours.
PROGRAM        z8-vs-e8-lattice
FIGURE         E8  : 240
FIGURE         density ratio = (sqrt2)^8 = 2^4 = 16
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/z8-vs-e8-lattice.swift — the enumeration, and its det 0 and det 2 control matrices
REFUSED        not a claim that E8 is the right lattice for any particular signal. It is the measured comparison at equal covolume and nothing more
REFUSED        not a construction. This entry names the object and what was counted about it; it carries no fabrication route and none is needed, because the object is a mathematical one
REFUSED        the program prints no seal, and this entry says NONE_PRINTED rather than leaving the field blank. Unsealed and sealed are different states
FALSIFIER      an enumeration over the same two lattices returning a kissing number other than 16 or 240, or a density ratio that is not exactly 16
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 z8-vs-e8-lattice.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
