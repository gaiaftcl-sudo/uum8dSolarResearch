# The eleven drug pairs, one per tumour type, made re-derivable

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       d0117523ff3b950a0741de281671c0bd977f8dc003f41972f2bfac2f50994d74
DIGEST_OF      the sealed transcript of the reader that prints the eleven pairs from the screen's own per-cohort results
TITLE          Eleven compound pairs clearing three controls where no single agent among 20,308 cleared any
MEASURED       Across 15 scored tumour types, 44,850 pairs scored per type from the 300 most-inverting single agents under a frozen additive law. 11 of 15 clear a vehicle-pair control, a self-pair control, and a random-gene-set null at 0 of 200 draws. 0 of 15 cleared for any single agent among 20,308 compounds. The four that do not clear carry the fewest observable regulators in the corpus: 8, 8, 9 and 9.
PROGRAM        study26-combination-pairs-exact
FIGURE         estradiol + AMG-208
FIGURE         estrone + BMS-387032
FIGURE         olaparib + ursodeoxycholyltaurine
FIGURE         HMN-214 + saracatinib
FIGURE         drospirenone + alpelisib
FIGURE         XMD-892 + NVP-BGJ398
FIGURE         THE PAIRS THAT CLEAR ALL THREE CONTROLS — 11 of 15
FIGURE         d0117523ff3b950a0741de281671c0bd977f8dc003f41972f2bfac2f50994d74
SEAL           d0117523ff3b950a0741de281671c0bd977f8dc003f41972f2bfac2f50994d74
GRADE          MEASURED
SOURCE         Study 26 S3-COMBINATION, per-cohort results pinned in corpus/study-26-combination/
WHERE_THE_LAW_LIVES  reproduce/study26-combination-pairs-exact.swift
REFUSED        not efficacy. A signature-inversion score is an arithmetic statement about expression ranks of landmark genes, and nothing about a dose, a mechanism, or a patient follows from it
REFUSED        not a claim that any pair helps anyone. Whether two compounds act additively in a cell, at a dose, in a person, and whether the combination is tolerable at all, is a laboratory and clinical question this program has not asked
REFUSED        not a re-run of the screen. This program is a faithful reader of the screen's sealed output and says so on every path; re-deriving those bytes from LINCS is a separate and larger reproduction
REFUSED        not a finding about the four that did not clear. Their result is a statement about the power of this test on those cohorts, never about those cancers
FALSIFIER      a cohort file whose published gain does not equal best_pair minus best_single, which the program's own known-case check reports before emitting any table; or a re-run from LINCS reaching different pairs under the same frozen law
REPRODUCE      ( cd corpus/study-26-combination && shasum -a 256 -c SHA256SUMS ) && xcrun swiftc -O -swift-version 5 reproduce/study26-combination-pairs-exact.swift -o /tmp/s26c && /tmp/s26c < /dev/null
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

## Why this entry exists, and why it did not yesterday

These pairs were published on 2026-09-06. For one day they were **not re-derivable**: the compound
names appeared in exactly one place in the entire public repository — the prose of the study page.
No program printed them, no corpus carried them, no transcript contained them. A reader of that page
would take them as sealed; a reader with a clean clone could not check a single one.

This library's own admission law refused them on that basis, on first contact with the real corpus,
under clauses E3 and E4. They were named as an open slot rather than deleted or disputed, with the
condition for entry written down: **they enter the day a program in `reproduce/` prints them.**

That program now exists, and this entry is its output. The slot closed the same day it opened.

The reader carries a known-case check that runs before any table: the published gain must equal
`best_pair − best_single` on all fifteen rows. Changing a single digit in one result file makes it
name the disagreeing row and emit **no table and no seal**. Given no corpus at all it refuses rather
than printing an empty result. Its seal is byte-identical from any directory.
