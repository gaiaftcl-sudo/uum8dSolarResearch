# Master-regulator recovery: does the network shape already carry it?

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       d0051d7a19daa0cb7f1a3d4f7be7433af73401bbf25fe41079f6409c066fee5a
DIGEST_OF      the sealed verdict transcript of the exact discrimination court over 17 TCGA tumour types
TITLE          Topology against expression, by exact hypergeometric tail, 17 tumour types
MEASURED       Ranking regulators by regulon SIZE ALONE recovers the published master-regulator set at least as significantly as ranking them by patient expression in 11 of 17 tumour types; expression adds discrimination in 5; 1 recovers nothing by either arm and is published as such. Exact integer hypergeometric upper tails, zero float on the decision path.
PROGRAM        mr-topology-vs-expression-exact
FIGURE         d0051d7a19daa0cb7f1a3d4f7be7433af73401bbf25fe41079f6409c066fee5a
FIGURE         TOPOLOGY_EXPLAINS: 11 of 17 tumour types
FIGURE         EXPRESSION_ADDS  : 5 of 17 tumour types
FIGURE         SELFTEST PASS
SEAL           d0051d7a19daa0cb7f1a3d4f7be7433af73401bbf25fe41079f6409c066fee5a
GRADE          MEASURED
SOURCE         GDC open RNA-seq integer counts and the published regulon files, both public
WHERE_THE_LAW_LIVES  reproduce/mr-topology-vs-expression-exact.swift
REFUSED        not a claim that the published master-regulator sets are wrong. It is a statement about what these numbers support and nothing wider
REFUSED        not a claim about any patient, any treatment or any outcome
REFUSED        not a drug pairing. The eleven named drug pairs published in prose on the study page are NOT in this entry, because no program in reproduce/ prints them and a stranger cannot re-derive them from a clean clone. They are named as an open slot in this library's manifest instead
FALSIFIER      the same regulon files and the same integer counts returning a different verdict for any of the 17 cohorts, or a tail probability that disagrees in exact arithmetic
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 mr-topology-vs-expression-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
