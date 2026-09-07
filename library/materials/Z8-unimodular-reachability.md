# The arm that discriminates, and the arm that only looks like it does

```affine-entry
LIBRARY        MATERIALS
IDENTITY_KIND  SPEC_NAME
IDENTITY       GL8Z-UNIMODULAR
SPEC_AUTHORITY The general linear group GL(8,Z), the 8x8 integer matrices of determinant plus or minus one — a standard public mathematical object, with the ten elementary shears that generate the matrix and the 4,000-point source set published in Study 30
TITLE          Image count cannot tell a bijection of Z^8 from a non-bijection; reachability can
MEASURED       Three 8x8 integer matrices over one 4,000-point source set: determinant 1, determinant 2 and determinant 0 each return 4,000 distinct images of 4,000, so the image count separates none of them. The arm that separates them is reachability of e_1 = (1,0,0,0,0,0,0,0): reached under determinant 1, not reached under determinant 2. Inside a plus-or-minus-100 box the unimodular map places 1,934 images of 4,000 against 4,000 for the determinant-2 map.
PROGRAM        unimodular-control-arms
FIGURE         singular det=0: det=0  distinct_images=4000 of 4000
FIGURE         unimodular det=1: det=1  e_1 reachable in sample = true
FIGURE         det=2 scaling: det=2  e_1 reachable in sample = false
FIGURE         images inside a +/-100 box: unimodular=1934  det2=4000  of 4000
SEAL           NONE_PRINTED
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/unimodular-control-arms.swift — determinant by fraction-free Bareiss elimination, integer throughout, with the det 2 and det 0 matrices as its two control arms
REFUSED        not a claim that any shipped wire transform is this matrix. The substrate source is not public; this entry measures the property over a published generator and a published point set and stands in for nothing
REFUSED        not a claim that any sensing pipeline is lossless. Z^8 to Z^8 under this map is bijective; the sensor-to-lattice quantisation ahead of it is many-to-one and irreversible, and that step is outside this measurement
REFUSED        not a hardware design, a bill of materials or an assembly route
FALSIFIER      a run over the same three matrices and the same point set in which e_1 is reachable under the determinant-2 map, or unreachable under the determinant-1 map; or an image count that does separate the three, which would make the smoke test a gate after all
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 unimodular-control-arms.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
