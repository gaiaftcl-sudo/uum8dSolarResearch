# The registry-wide off-target atlas of the nucleic-acid medicines

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08
DIGEST_OF      the merged seal of the eight strand shards of the registry-wide off-target atlas
TITLE          Every nucleic-acid substance the public registry publishes a usable sequence for
MEASURED       472 strands across 350 substances, enumerated from the registry rather than from a list anyone remembered: 742 substances of class nucleicAcid, 740 carrying a sequence, and those whose every subunit falls in 8 to 60 nt. 187 strands had a target measured FROM the transcriptome; 285 had no perfect complement anywhere and were therefore not screened for off-targets.
PROGRAM        oligo-offtarget-atlas-exact
FIGURE         321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08
FIGURE         472 strands across 350 substances
FIGURE         187 strands had a measured target; 285 had no perfect complement anywhere
SEAL           321b36c694b89a45bb81668d7ea62b9c85cf0b3087e18bba586f43b230274b08
GRADE          MEASURED
SOURCE         NCATS GSRS, class nucleicAcid, enumerated in full
WHERE_THE_LAW_LIVES  reproduce/oligo-offtarget-atlas-exact.swift
REFUSED        the 285 refused strands are ABSENT from the map, never scored as clean. A strand with no perfect complement was not screened, and that is a different answer from a strand that was screened and found quiet
REFUSED        not a safety ranking. This entry publishes coverage and targets, not an ordering of substances by risk
REFUSED        not a claim about any approval, label or trial
FALSIFIER      a strand in the registry inside the 8 to 60 nt range that this enumeration omits, or a measured target that a second independent screen does not reach
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 oligo-offtarget-atlas-exact.swift -o /tmp/run && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/run ../corpus/oligo-atlas/all_nucleicacid.tsv
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```
