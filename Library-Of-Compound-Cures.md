This library is for someone who does not know us and has no reason to trust us.

A patient reading a label. A prescriber who wants to know where else a strand of RNA could bind. A
regulator asking whether a claim was measured or merely stated. A laboratory deciding where to
point a bench. None of them should have to take our word for anything, and in this library none of
them does: every figure on this page is printed by a program in `reproduce/`, and the command that
prints it is written beside the figure.

It is a library, not a study. **Studies close; a library grows.** Entries arrive as evidence
arrives, and each one is admitted by a law rather than by a person — there is no reviewer here to
persuade and no committee to convince.

What is in it today: exact off-target maps for the nucleic-acid medicines the public registry
publishes a usable sequence for, a genome-wide map for every guide RNA in that registry, and an
exact discrimination court over seventeen tumour types asking what actually recovers a published
master-regulator set. Five entries. Two named things it does not have.

---

## The admission law, in one paragraph

Nothing enters this library without a reproducible measurement. An entry must name itself with a
public identifier the law checks rather than trusts, state what was measured **with a quantity**,
name a program in `reproduce/` that produces it, list figures that each match a line of that
program's output, carry either a seal that program actually prints or the explicit token
`NONE_PRINTED`, take a grade from this wiki's ontology that the present evidence supports, say in
its own words what it refuses to claim, name the observation that would overturn it, give a command
a stranger runs from a clean clone, and carry the not-advice line **inside the entry** so it travels
when a row is copied out. That is the per-entry half — fifteen clauses, E0 to E14. The other half
holds every entry at once: nine clauses, L1 to L9, publishing a **distinct count over the identity
field beside the row count, always**, with integer ceilings the library declares in advance and the
law tests as `count(most repeated value) ≤ declared` — per value, never as a ratio, because a ratio between two
integers is where a float enters a program that had none.

The full law: **[The library admission law](The-Library-Admission-Law)**. The law itself is the
program `reproduce/library-admission-law.swift` — 2,495 lines, Swift 6.4, zero float on every
decision path, 65 control arms passing in three directions. Beyond the two halves there is one
**federation** clause, F1, which asks the only question neither half can: *is one entry filed in
two different libraries?* No per-library clause can see it, because no per-library clause ever
holds two libraries at once — which is why **the three libraries are graded in a single run and
never one at a time.**

**Why the second half exists.** A generative pipeline in this same programme reported **37,910
validated discoveries** and contained **five distinct molecules**. Every row carried a valid
molecule and every per-row check that ran on it was right to pass it; the emitting loop read
`seeds[i % len(seeds)]`, so the row count was the loop bound. No per-item validator can see that,
because no per-item validator ever holds two items at once. That is why this page publishes a row
count and a distinct count side by side and will never publish one without the other.

### Three terminals, and they are three answers

| terminal | what it means here |
|---|---|
| **ADMITTED** | every clause is satisfied on evidence present at this grading. It does **not** mean true, safe, or recommended — read the entry's own refusal lines |
| **REFUSED** | a clause is violated, and the clause is named. There is no state between admitted and refused |
| **NOT_KNOWN** | a clause cannot be decided because its evidence is not present here. The entry waits, by name, and is neither in the library nor thrown out of it |

An **open slot** is a fourth thing and deliberately not a terminal: a held entry has evidence that
exists somewhere, a slot has evidence nowhere. Slots are named below, count in no axis, and gate on
nothing. Naming a slot is how a library says what it is missing instead of quietly not having it.

### Grade this library yourself

```bash
xcrun swiftc -O -swift-version 5 reproduce/library-admission-law.swift -o /tmp/lal
/tmp/lal --library library/proteins --library library/compounds --library library/materials \
         --reproduce reproduce --evidence /tmp
```

**Grade all three libraries in one command.** F1 — no entry filed in two libraries — is a relation
*between* libraries, and a run given one library cannot answer it: it prints
`F1_NO_ENTRY_FILED_TWICE   NOT_KNOWN` and exits 2, which is the honest answer and is not a
clearance. The first published version of these three pages each carried a clean table produced by
a separate single-library run, and the clause that refused the combined run could not be reached by
any of the three. That is fixed in the law, and this is the command it is fixed with.

`--evidence` is where `out_<program>.txt` transcripts live; `validate.sh` writes them to `/tmp`,
which is the default. Exit `0` all admitted, `1` something refused, `2` something held, `3` the
control arm failed and nothing was graded.

Measured 2026-09-07, all three libraries together: `15 ADMITTED · 1 HELD · 0 REFUSED`, every
per-library clause holding, and F1 clear over 12 distinct triples. The seal is **path-independent
by construction** — filesystem paths are printed and never sealed, because a seal that moves with
the checkout directory indicts a correct reproduction.

```
CONTROL ARM  65/65 PASS        40 must REFUSE · 17 must ADMIT · 8 must HOLD
  programs in reproduce/   84
LIBRARY PROTEINS    ->  ADMITTED     6 files   5 admitted   1 held   0 refused
LIBRARY COMPOUNDS   ->  ADMITTED     7 files   4 admitted   3 held   0 refused
LIBRARY MATERIALS   ->  ADMITTED     5 files   5 admitted   0 held   0 refused
F1_NO_ENTRY_FILED_TWICE   ok — no triple appears in more than one of the 3 libraries
TRANSCRIPT SEAL  sha256  b9b2ac76b28aab3ac709b1ae4143f0bc1827421b78c0a3d7b44bdd3ec104765c
sealed bytes             31,434
exit                     2
```

**The seal moves when the census moves; the verdict does not, and the difference is worth a
sentence rather than a footnote.** The program census — `programs in reproduce/ 84` — is inside the
sealed transcript, because what programs were available *is* evidence about the grading. A clone
holding a different number of programs prints a different seal. That is content disagreeing, not a
broken reproduction: the per-entry and per-library verdicts above it are what must match.

---

## The entries

Seven entry blocks follow, reproduced verbatim from the canonical entry files in
`library/compounds/`. The checker grades **one entry per file**, so grade the library directory —
this page is the reading surface, not the graded object. **Clause L9 makes "reproduced verbatim" a
gate rather than a promise**: it compares the fenced blocks on this page against the blocks in that
directory as multisets and refuses the library if they differ. Before L9 existed the two agreed,
and that was a fact about one hour rather than something anyone checked.

Each block is the schema. Each carries its own grade, its own refusal lines and its own not-advice
line, so that a row copied out of this library arrives somewhere else still carrying what it
refuses to say.

---

### 1 — Zilganersen: where else in the transcriptome can it bind?

An approved-sequence antisense oligonucleotide against GFAP, screened against every transcript
GENCODE v50 publishes. The whole point of the entry is the shape of the answer: **two perfect
matches, both in the intended gene, and then nothing at all until you drop two mismatches.** The
gap between 20/20 and 17/20 is empty. That emptiness is a measurement, and it is the one a
prescriber would want.

The burden figure is the one that needs its control read alongside it: 324 off-target windows at
16/20 or better outside GFAP, against a **composition-matched control median of 787**. The real
strand is quieter than scrambles of its own composition. A count without that control would be a
number nobody could interpret.

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  UNII
IDENTITY       AXQ9493NT2
TITLE          Zilganersen off-target map, exact, whole human transcriptome
MEASURED       On the real approved sequence against GENCODE v50: 2 perfect 20/20 windows, both in GFAP; 0 at 19/20 and 0 at 18/20; 11 sites named at 17/20; 324 off-target windows at 16/20 or better outside GFAP against a composition-matched control median of 787. 670,670 transcripts, one integer per window, no cutoff inside the arithmetic.
PROGRAM        zilganersen-offtarget-whole-transcriptome
FIGURE         perfect 20/20       : 2, both in GFAP
FIGURE         19/20 and 18/20     : 0 and 0
FIGURE         off-target burden at 16/20 or better, outside GFAP : 324
FIGURE         composition-matched control median at the same threshold : 787
SEAL           edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa
GRADE          MEASURED
SOURCE         NCATS GSRS, UNII AXQ9493NT2 — the sequence is public and nothing here is behind a login
WHERE_THE_LAW_LIVES  reproduce/zilganersen-offtarget-whole-transcriptome.swift
REFUSED        not a safety verdict on the medicine, and not a finding about any patient
REFUSED        not a claim that any listed site is bound, cleaved or clinically relevant in a person. Complementarity is where binding is possible, never where it happens
REFUSED        not a comment on the trial, the endpoint or the approval
FALSIFIER      the same sequence against the same GENCODE v50 digest returning a different count at any of the four thresholds, or a perfect window outside GFAP
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 zilganersen-offtarget-whole-transcriptome.swift -o /tmp/run && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

The eleven sites at 17/20 are named in the program's output — `XYLB`, `ENSG00000239572`,
`ADAM20P1`, `ENSG00000293223` — because a bench that wants to check one needs the name, not the
count.

---

### 2 — Pelacarsen: the same question asked of a different strand

The same instrument, a different medicine, and the reason it is here is that it was asked
**independently and reached the same place twice**: three perfect windows, all in LPA. The
registry-wide atlas below reaches LPA for this strand by a different route, and agreement between
two screens that did not share a code path is worth more than either alone.

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  UNII
IDENTITY       LSO9H7UZ90
TITLE          Pelacarsen off-target map, exact, whole human transcriptome
MEASURED       3 perfect 20/20 windows, all in LPA, over 670,670 transcripts and 1,467,336,203 windows against GENCODE v50. At 17/20 or better outside LPA: LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1.
PROGRAM        pelacarsen-offtarget-whole-transcriptome
FIGURE         perfect 20/20 windows : 3, all in LPA
FIGURE         17/20 or better, not LPA : LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1
FIGURE         513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757
SEAL           513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757
GRADE          MEASURED
SOURCE         NCATS GSRS, UNII LSO9H7UZ90
WHERE_THE_LAW_LIVES  reproduce/pelacarsen-offtarget-whole-transcriptome.swift
REFUSED        not a safety verdict on the medicine and not a finding about any patient
REFUSED        not a claim that LPAL2 or any named transcript is bound in a person
FALSIFIER      an independent screen of the same strand against the same transcriptome digest reaching a different perfect-window count or a different named set at 17/20
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 pelacarsen-offtarget-whole-transcriptome.swift -o /tmp/run && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

---

### 3 — Every nucleic-acid medicine the public registry publishes a sequence for

This is the coverage entry, and coverage is the claim it makes. The strands were **enumerated from
the registry, not from a list anyone remembered**: 742 substances of class `nucleicAcid`, 740
carrying a sequence, and those whose every subunit falls between 8 and 60 nt giving **472 strands
across 350 substances**.

Of those, **187 had a target measured from the transcriptome** — found by complementarity, not read
off a label. **285 had no perfect complement anywhere** and were therefore never screened for
off-targets. Those 285 are ABSENT from the map. They are not clean, and the entry says so in its own
refusal line, because a strand that was not screened and a strand that was screened and found quiet
are two different answers and this library never prints them alike.

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

The run was sharded by strand across eight processes, each reading the entire transcriptome, so no
statistic crosses strands and **sharding changes no number**. The published seal is the sha256 of
the eight shard seals in order, which is why a single process cannot print it — the program says so
in its own output rather than leaving a reader to discover it.

The program also corrects an earlier revision of its own window count in public, in its output: a
figure once printed as a property of the run was one arbitrary strand's count. **Window counts are
per strand length**, and the program now says that where the number used to be.

---

### 4 — Where else could this guide cut? The whole genome, counted

Fifteen guide RNAs, found by the canonical SpCas9 scaffold rather than by name — every one of the
742 `nucleicAcid` substances in the registry was scanned for it, and fifteen carry it. Screened
against 3,099,750,718 bases at **304,796,751 NGG PAM sites** on both strands.

The finding is stated at full magnitude because it is there: **all fifteen guides found a
zero-mismatch site, thirteen had exactly one in the whole genome, every guide had zero sites at one
mismatch, and thirteen of fifteen had zero at two.** On the question this instrument answers — how
many places in the genome match this guide, exactly — these are clean guides, and the count is not
an opinion. The fifteen are named in the program's own output beside the UNII each sequence came
from, and they include the guide of an approved therapy people are alive because of today —
exagamglogene autotemcel, UNII `L28RZ5CC6K`. Which of the fifteen is quietest at three and four
mismatches is a per-guide question, and it is answered by the per-guide table rather than by this
summary.

1,718 windows containing an `N` were **set aside and counted**, never folded into either bucket. An
N is neither a match nor a mismatch, and a library that quietly rounds it into one is a library
whose totals cannot be checked.

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
DIGEST_OF      the sealed transcript of the genome-wide guide screen over 15 registry guides
TITLE          Genome-wide off-target map for every guide RNA the public registry publishes
MEASURED       15 guides, found by the canonical SpCas9 scaffold rather than by name, against 3,099,750,718 bases: 304,796,751 NGG PAM sites examined on both strands, 1,718 windows containing an N set aside rather than scored. All 15 guides found a zero-mismatch site and 13 had exactly one in the whole genome; every guide had 0 sites at one mismatch and 13 of 15 had 0 at two.
PROGRAM        crispr-genome-offtarget-exact
FIGURE         487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
FIGURE         304796751 NGG PAM sites
FIGURE         All 15 guides found a zero-mismatch site; 13 had exactly one in the whole genome.
FIGURE         L28RZ5CC6K
SEAL           487b4f81de2d24bd0bb11ecd1d8d42778e3a5d91b9edb33627c86dcc8df34980
GRADE          MEASURED
SOURCE         NCATS GSRS, all 742 nucleicAcid substances scanned for the scaffold; 15 carry it
WHERE_THE_LAW_LIVES  reproduce/crispr-genome-offtarget-exact.swift
REFUSED        not a per-guide safety verdict. This entry publishes the map at the granularity the program prints, and no claim about one named guide beyond what appears there
REFUSED        an N window is neither a match nor a mismatch. The 1,718 are set aside and counted, never folded into either bucket
REFUSED        not a claim that any site is cut in a person. A PAM plus complementarity is where a cut is possible, never where it happens
FALSIFIER      a 16th guide in the registry carrying the canonical scaffold, or a different site count for the same assembly digest
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 crispr-genome-offtarget-exact.swift -o /tmp/run && curl -sL <GRCh38 primary assembly fasta> | gunzip -c | /tmp/run ../corpus/crispr-atlas/guides_all.tsv
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

The full per-guide map, with coordinates and strands at four mismatches or fewer, is published on
[the CRISPR page](CRISPR-Genome-Off-Target-Map) — because that list is exactly where a laboratory
would start if it wanted to check a guide experimentally, and publishing the summary without it
would be publishing the reassuring half.

---

### 5 — What actually recovers a published master-regulator set?

This is the entry that changes what a reader should do next, and it is a negative result stated at
full magnitude rather than apologised for.

Across seventeen TCGA tumour types, ranking regulators by **regulon size alone — never reading the
patient expression counts at all** — recovers the published master-regulator set at least as
significantly as ranking them by expression in **eleven** of them. Expression adds discrimination in
**five**. One recovers nothing by either arm and is published as such, by name, rather than dropped.
Ties: zero.

The arithmetic is an exact integer hypergeometric upper tail. `C(100,50)` is computed as
`100891344545564193334812497256`, not as a float that agrees to fifteen digits, and the program's
self-test proves the tail equals its own denominator at `s=0` before it grades anything.

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

The seventeen cohorts are printed one per line with pool size, set size, both arms' hit counts and
both exact tails — from `2.685e-29` down to `1.000e+0` — so a reader can disagree with the verdict
on any single cohort while holding the same numbers we do.

---


### 6 — Eleven compound pairs, where no single agent among 20,308 cleared any

This is the entry with the most direct bench handoff in any of the three libraries, and it is
also the entry that proves the admission law is not decoration.

Across fifteen scored tumour types, **44,850 pairs** were scored per type from the 300
most-inverting single agents under a frozen additive law. **Eleven of fifteen** clear a
vehicle-pair control, a self-pair control, and a random-gene-set null at **0 of 200 draws** —
where **0 of 15** cleared for any single agent among **20,308** compounds. The four that do not
clear carry the fewest observable regulators in the corpus: 8, 8, 9 and 9, which is a statement
about the power of this test on those cohorts and never about those cancers.

**And for one day this entry could not exist.** These pairs were published on 2026-09-06 in
prose. The compound names appeared in exactly one place in the entire public repository — the
study page itself. No program printed them, no corpus carried them. This library's own law
refused them under E3 and E4 on first contact with the real corpus, and named them as an open
slot with the condition for entry written down: they enter the day a program prints them.
That program was written the same day, and this entry is its output. **The slot closed the day
it opened**, and the law refused two further defects in this very entry before admitting it —
an identity digest that no FIGURE line claimed, and an invented manifest key.

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

The reader carries a known-case check that runs before any table: the published gain must equal
`best_pair − best_single` on all fifteen rows. Changing a single digit in one result file makes
it name the disagreeing row and emit **no table and no seal**. Given no corpus it refuses rather
than printing an empty result, and its seal is byte-identical from any directory.

### 7 — Is a medicine more specific than the same bases in another order?

The atlas above answers **where** a strand can pair. It cannot answer whether that burden is
unusual, and alone it decides nothing: any 20-mer has hundreds of near-complementary windows in a
corpus of 1.47 billion, for the same reason any twenty-letter string turns up in a large enough
library. This entry is the comparison — every screened strand against **sixteen permutations of its
own bases**, the same multiset with none of the design.

**This slot was named empty on 2026-09-07 and filled on 2026-09-08.** The manifest carried it as an
open slot, in the library's own words, while the screen was still running: *no program, no
transcript, no seal, nothing to hold.* It is an entry now because a program prints it.

The result the bench should read first is not the two successes. It is that **17 undesigned
sequences**, drawn from the corpus by a fixed rule and screened exactly as a medicine is, put the
registry's numbers in a scale — and **none of the seventeen is below its own controls either.**

```affine-entry
LIBRARY        COMPOUNDS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
DIGEST_OF      the sealed transcript of the registry-wide specificity ranking, over every strand, every threshold, every rank interval and every complete histogram
TITLE          Every registry strand ranked against sixteen rearrangements of its own bases
MEASURED       472 registry strands and 17 undesigned constructed 20-mers screened as 186 families of 17 probes each, 5,355,878,467,758 probe-windows counted with no sampling and no cutoff inside the arithmetic. At 4 mismatches: 2 families pair in strictly fewer places than all sixteen permutations of their own bases, 8 tie the lowest, 122 sit inside their own control range, 1 ties the highest, 44 pair in more places than every permutation, and 9 tie all sixteen. 18 strands are UBIQUITOUS, 266 REFUSED and 19 NOT_KNOWN — three silences, none of which is zero off-targets.
PROGRAM        registry-specificity-ranking
FIGURE         2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
FIGURE         717027798090 + 4638850669668 = 5355878467758
FIGURE         169 registry strands + 17 undesigned constructed 20-mers
FIGURE         18 UBIQUITOUS, 266 REFUSED, 19 NOT_KNOWN
FIGURE         BELOW-all-16 2 | ties-lowest 8 | inside 122 | ties-highest 1 |
SEAL           2d74f5c676d51d45df178f9fed7840729bd87633ae8e5a9104383f6fbd7c3fd1
GRADE          MEASURED
SOURCE         NCATS GSRS class nucleicAcid enumerated in full, screened against GENCODE v50 transcripts
WHERE_THE_LAW_LIVES  reproduce/registry-specificity-ranking.swift
REFUSED        not a safety finding. A near-complementary window is a place a molecule COULD pair — not a cut, not an occupancy, not a clinical event. A high rank is not a safety finding and a low rank is not a clearance
REFUSED        not a ranking of medicines against each other. Every comparison on this entry is a strand against permutations of ITS OWN bases, never against another strand, and raw burden is never pooled across lengths
REFUSED        not a claim about the 303 excluded strands. UBIQUITOUS, REFUSED and NOT_KNOWN are three different answers and an excluded strand is never a clean strand
REFUSED        not the chemistry half. Phosphorothioate backbone binding, complement activation, thrombocytopenia and aseptic meningitis are not sequence matches and this program does not reach them
FALSIFIER      a registry strand in the 8-60 nt band this enumeration omits; or a re-run on the same two public inputs reaching a different seal, a different disposition for any family, or a different count of families strictly below all sixteen
REPRODUCE      xcrun swiftc -O -swift-version 5 reproduce/registry-specificity-ranking.swift -o /tmp/rsr && curl -sL <gencode v50 transcripts fasta> | gunzip -c | /tmp/rsr
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-08
```

The full page, including the tie rule that took a claimed nineteen designed-specificity families
down to a measured two, is **[The order of the bases](The-Order-Of-The-Bases)**.

## The refused section

**A library that shows only what it admitted cannot be audited.** Six things were considered for
this library and did not enter, or entered only as an explicit absence.

### R1 — The eleven master-regulator drug pairs. REFUSED: E3, E4.

Study 26 publishes eleven drug pairs, one per tumour type, each the top of 44,850 scored, each
clearing a vehicle-pair control, a self-pair control and a random-gene-set null. Written out, that
is the strongest-sounding evidence on the board, and it is **the one thing on this page that a
stranger cannot check.**

Measured, not assumed: searched across the whole standalone wiki, the string `AMG-208` appears in
**exactly one file — the study page itself.** So does `saracatinib`. No program in `reproduce/`
prints any of the pairs, no transcript contains them, and no corpus file carries them. A reader of
the study page would take those pairs as sealed; a reader with a clean clone cannot re-derive a
single one.

That is E3 and E4 doing exactly the job they exist for. **The pairs are not deleted and not
disputed.** They are named as an open slot below, with the reason recorded, and they enter the day a
program in `reproduce/` prints them. The same applies to the four tumour types that did not clear
and to the measured blocker named for them — published set size rather than assay coverage. Real
work; not yet re-derivable; therefore not yet admitted.

### R2 — The 285 registry strands with no measurable target. ABSENT, and never clean.

Of 472 strands screened for a target by complementarity against the transcriptome, **285 had no
perfect complement anywhere.** They were therefore never screened for off-targets.

They get their own line here because absence is the easiest thing in a library to misread as
safety. **A strand with no measured off-target map is not a quiet strand. It is an unscreened one.**
The atlas entry carries that as its first refusal line so the distinction travels with the row, and
it is repeated here so a reader who only reads this section still gets it.

There are three answers in this library and this is the difference between two of them: ABSENCE
means we looked and found nothing there; REFUSAL means a clause was violated and is named;
NOT_KNOWN means the evidence to decide is not present here. These 285 are the first: measured
absence of a perfect complement, which is a finding, and which is not a clearance.

### R3 — Any figure from a self-graded column. REFUSED: E12.

`confidence`, `coherence`, `overall_score`, `validation_passed`, `novelty_score`, `quality_score`
and their kin may not appear in a `MEASURED` or `FIGURE` line anywhere in this library. **None of
them measures anything outside the program that wrote them**, and in this wiki's corpora every one
of them is a `Double`.

They remain welcome in a refusal line — saying a column is barred is the opposite of relying on it,
and the law carries a control arm proving the detector knows the difference.

### R4 — Any entry that called a medicine safe or effective. REFUSED by construction.

No entry in this library claims efficacy, and none claims safety. A signature-inversion score is not
efficacy. An off-target map is not a safety clearance. A near-complementary window is not a cut, and
a PAM plus complementarity is where a cut is *possible*, never where it happens. Every entry above
carries those refusals in its own block rather than in this preamble, because the preamble is what
gets left behind when a row is copied.

### R5 — Any entry carrying a procedure. REFUSED: E11, C-007, absolute.

An entry names **what** a system is, **what** was measured about it and **where** the law lives. It
never carries a procedure a person could follow. A constructed violation is on disk in
`control-cases/case-7-synthesis-cookbook.md` — otherwise the admitted zilganersen entry with exactly
one line changed — and the law refuses it naming the rule that caught it, the fabrication verb and
the quantity, so a false positive would be contestable rather than mysterious.

### R6 — The five constructed cases, run on real files, so a stranger can run the refusals too.

Refusals are only credible if you can make them happen. Each of these is the admitted zilganersen
entry with **exactly one thing changed**, on disk in `control-cases/`:

```
  case-1-claim-no-program-prints.md         REFUSED  E3_PROGRAM
  case-1b-figure-not-printed.md             REFUSED  E4_FIGURE
  case-2-no-refusal-line.md                 REFUSED  E8_REFUSAL
  case-3-no-identifier.md                   REFUSED  E1_IDENTITY   ('unknown' is a placeholder)
  case-4-verified-on-reported-evidence.md   REFUSED  E7_GRADE_SUPPORTED
  control-cases/collapsed-library/          REFUSED  L3_DISTINCT_IDENTITY
  control-cases/empty-library/              REFUSED  L1_NOT_EMPTY
```

The last two are the ones that matter most to a library. `collapsed-library` is the Study-37 shape
reproduced exactly — four entries, one identity, four different titles — and it prints both axes
side by side so you can watch the wrong counter report perfect diversity:

```
    axis                            entries  distinct  most at 1  declared  holds
    IDENTITY                              4         1          4         1  NO
    TITLE (census, not a gate)            4         4          1         -    -
```

The collapsed library declares **4** per program, per seal, per measured and per triple — as
generously as a library can — so the refusal cannot be blamed on a mean declaration anywhere else.
`DECLARED_ENTRIES_PER_IDENTITY 1` is the only thing left, and it is what catches it.

`empty-library` is **REFUSED, never reported clean**: zero admitted entries is the weakest possible
evidence and calling it a clean library is the strongest possible claim.

---

## Open slots — named, and empty, and two that closed

A slot is a measurement this library has named and does not have: no program, no figure, no seal,
nothing to hold. Slots are counted in no axis above and gate on nothing.

**Both slots this page carried on 2026-09-07 are now closed, and closed the only way a slot may
close — a program prints them:**

| slot named 2026-09-07 | why it was empty | closed |
|---|---|---|
| The eleven master-regulator drug pairs, one per tumour type | published in prose on the study page; no program in `reproduce/` printed them, so a stranger could not re-derive them from a clean clone | **2026-09-07**, entry 6 — `study26-combination-pairs-exact` |
| The registry-wide specificity ranking across all in-scope strands | running at that grading; no program, no transcript, no seal | **2026-09-08**, entry 7 — `registry-specificity-ranking`, seal `2d74f5c6…` |

**Three slots are open, and each names the one condition that would fill it:**

| slot | why it is empty | named |
|---|---|---|
| The exact off-target map of **del-zota's** payload | the sequence is not public. The slot fills the day the sponsor or a regulator puts it on the table — the instrument is already written | 2026-09-08 |
| The exact off-target map of **VERVE-102's** guide on the real molecule | the same reason, on a base editor rather than an oligonucleotide | 2026-09-08 |
| A signature-reversal or network-recovery figure for **rentosertib** | there is nothing to compute against: the compound is **ABSENT** from both LINCS perturbagen tables (51,383 and 2,170 rows read, 0 matches, in a lookup returning 1 and 1 for pirfenidone and nintedanib) and TNIK is a master regulator in none of our cohorts. The slot fills if a public perturbation corpus carries the molecule | 2026-09-08 |

**An invented result would have been easier and would have looked better.** A slot stays empty
until a program prints it, and the three above are in the manifest, so the grader prints them on
every run whether anyone reads this page or not.

---

## Rows and distinct identities, side by side

This library states both, always. Reproduced verbatim from the grading run:

```
    axis                            entries  distinct  most at 1  declared  holds
    IDENTITY                              4         4          1         1  yes
    PROGRAM                               4         4          1         1  yes
    SEAL (sealed entries only)            4         4          1         1  yes
    MEASURED                              4         4          1         1  yes
    IDENTITY|PROGRAM|SEAL triple          4         4          1         1  yes
    TITLE (census, not a gate)            4         4          1         -    -
    GRADE (census, not a gate)            4         1          4         -    -

    'most at 1' is the count carried by the single most repeated value on that
    axis. It is the number the declared ceiling is about, and it is printed
    whether the ceiling holds or not — an aggregate that clears while one value
    carries five against a declared two is the collapse this table exists to show.

  GRADE CENSUS over the admitted set (a census, NOT a gate — no library is
  refused for its distribution of grades, and no library should be read as
  strong for having none of the weaker ones):
    MEASURED                   4

  OPEN SLOTS — named, and empty. A slot is NOT an entry and is counted in no
  axis above. It is a measurement this library has named and does not have:
  no program, no figure, no seal. Naming it is how a library says what it is
  missing instead of quietly not having it.
    - The exact off-target map of del-zota's payload. The sequence is not public; the slot fills the day the sponsor or a regulator puts it on the table. Named 2026-09-08.
    - The exact off-target map of VERVE-102's guide on the real molecule. Named 2026-09-08.
    - A signature-reversal or network-recovery figure for rentosertib. The compound is ABSENT from both LINCS perturbagen tables and TNIK is a master regulator in none of our cohorts, so there is nothing to compute against; the slot fills if a public perturbation corpus carries the molecule. Named 2026-09-08.

  PER-LIBRARY CLAUSES
     ok  L1_NOT_EMPTY              7 entry file(s) present
     ok  L2_MANIFEST               LIBRARY COMPOUNDS declares: per identity 1, per program 1, per seal 1, per measured 1, per triple 1; page Library-Of-Compound-Cures.md; open slots 3
     ok  L7_NO_ENTRY_REFUSED       0 of 7 entries refused
     ok  L3_DISTINCT_IDENTITY      4 entries, 4 distinct; most repeated value 'AXQ9493NT2' carries 1, declared ceiling 1 per value — 1 <= 1
     ok  L4_DISTINCT_PROGRAM       4 entries, 4 distinct; most repeated value 'mr-topology-vs-expression-exact' carries 1, declared ceiling 1 per value — 1 <= 1
     ok  L5_DISTINCT_SEAL          4 entries, 4 distinct; most repeated value '513de7e9db6556df1895bfce4cb4d69e4816d7b45b75bee1dc8452335c2c7757' carries 1, declared ceiling 1 per value — 1 <= 1
     ok  L6_DISTINCT_MEASURED      4 entries, 4 distinct; most repeated value '3 perfect 20/20 windows, all in LPA, over 670,670 transcripts and 1,467,336,203 windows against GENCODE v50. At 17/20 or better outside LPA: LPAL2, TMEM254-AS1, LINC02606, LINC01065, ISM1.' carries 1, declared ceiling 1 per value — 1 <= 1
     ok  L8_DISTINCT_TRIPLE        4 entries, 4 distinct; most repeated value 'AXQ9493NT2 | zilganersen-offtarget-whole-transcriptome | edcb277ddea44820502b6446b00ed8bdcfdb08835d6785fdee7d1b370420bbaa' carries 1, declared ceiling 1 per value — 1 <= 1
```

**Seven entry files, four admitted here, three held — and the three are the honest half of this
table.** The library holds seven measurements. Four of them are graded ADMITTED from a clean clone,
because their programs run to completion against corpora small enough to ship in this repository.
The other three — the registry-wide atlas, the genome-wide CRISPR map and the specificity ranking —
name a program that **refuses** without a 1.5 GB public download, so in a clean clone their evidence
is not present and the law returns **NOT_KNOWN**. A held entry is not in the library and is not
thrown out of it. Point the grader at a directory holding those three transcripts and they admit.

**That distinction is younger than this page, and it was our own defect.** Until 2026-09-08 all
three read ADMITTED here, because several programs now print their published figures **on every
exit path** — the right thing for the wiki harness, which must check a page against its program with
no corpus present — and clauses E4 and E5 were matching those figures against text the run had
**quoted** rather than **computed**. The seal of a screen that measured nothing was being credited to
it. Three new control arms hold the repair: a refusal transcript that quotes every declared figure
must HOLD, one that quotes the declared seal must HOLD, and the same entry against a **complete** run
must still ADMIT — because a guard that always holds is the same defect wearing the other face.

Every ceiling is declared at 1 in `library/compounds/LIBRARY.manifest` and tested **per value** —
`count(most repeated value) ≤ declared` — never by a ratio and never in aggregate. `most at 1` is the
column that carries the test; an aggregate can clear while one value carries five against a declared
two, and on the sibling PROTEINS library it did.
**L9 is the clause that ties this page to what was graded.** The checker grades
`library/compounds/`; you are reading `Library-Of-Compound-Cures.md`. Nothing made them agree until
L9 did — it compares the fenced entry blocks of the two as multisets and refuses if they differ,
so an edit to this page that is not also an edit to the entry it publishes fails the harness.

`GRADE` reads 4 admitted entries over 1 distinct value and is labelled **census, not a gate**, in the
output and here. Every admitted entry is graded `MEASURED`. A clause that never refuses is
decoration, and calling a decoration a gate is how a reader comes to trust one — so this library
does not claim strength from its grade distribution, it reports it.

**Read the two columns together. The row count alone is a loop bound.**

---

## How this library grows

### Who may add

**Anyone.** The law is the gatekeeper, not a person. There is no reviewer to persuade. An addition
is a file, a program and a transcript, and the checker is the referee — it runs in public, on a
clean clone, in well under a second once built.

### What must accompany an addition — four things, in one commit

1. **The entry file** in `library/compounds/`, carrying an `affine-entry` block the checker admits.
2. **The program** in `reproduce/`, if it is new: self-contained, integer, with its own control arm
   in both directions. A program that cannot fail has proved nothing.
3. **A `check_figure` row in `reproduce/validate.sh`** for at least one of the entry's figures, so
   the wiki's own harness fails if the page and the program ever drift apart. All five programs
   behind this library already carry them — **thirty rows in total** across the five.
4. **The manifest ceilings**, moved if the addition needs them moved.

Point 4 is not bookkeeping. **A stale ceiling silently re-admits what was just excluded.** This
programme has already paid that bill once, on a float ratchet whose frozen constant kept forgiving
what it had been raised to catch. The same failure here would let this library grow past its own
declared honesty without a single clause going red.

### What happens when evidence is refuted

**Nothing is ever deleted.** A library that cannot retract cannot be trusted, and a library that
retracts by deleting is worse, because it cannot be caught. An entry whose evidence is refuted is
superseded **in place**:

1. add `REFUTED_BY` with what refuted it and a `YYYY-MM-DD` date;
2. rewrite `GRADE` to what the *surviving* evidence supports — usually `NOT_KNOWN`;
3. leave the original `MEASURED`, `FIGURE`, `SEAL` and `REFUSED` lines untouched, so the claim and
   its refutation stand on the same page;
4. `SUPERSEDES` on the replacement entry, if there is one.

E14 enforces it: refuted-and-still-`MEASURED` is refused, an undated refutation is refused because
it cannot be ordered against the claim it refutes, and a refuted entry that is dated and regraded is
**ADMITTED**. Retraction is a path through the law, not an exit from it.

This is written hard for a reason. In this substrate's own ledger, the append-only triggers were
disarmable at runtime and three migrations used the bypass; for every game they touched, *"never
CUREd"* and *"its CUREs were deleted"* are now indistinguishable. **Deleting a refuted entry is the
same act, one step later.**

---

## What this library is not

- **Not medical advice.** Nothing here is medical advice and no entry is a recommendation to take
  anything. Nothing here should change anyone's treatment.
- **Not a safety clearance.** An off-target map measures where binding or cutting is *possible*.
  Whether it happens — in a cell, at a dose, in that chromatin state — is a laboratory question
  these programs have not asked and cannot answer. Off-target potential is one input to safety among
  many, and this library measures that one.
- **Not an efficacy claim.** A signature-inversion score is not efficacy. A recovered
  master-regulator set is not a treatment.
- **Not a ranking.** The atlas publishes coverage and targets, not an ordering of substances by
  risk. Nothing here says one medicine is better than another.
- **Not a substitute for a laboratory or a regulator.** It is the exact, complete, re-derivable
  enumeration such a conversation should start from, available without permission and without
  trusting us.
- **Not a claim that an admitted entry is true.** ADMITTED means the entry is *checkable* — named,
  produced by a program a stranger can run, graded at what its evidence supports, and explicit about
  what it refuses to say.
- **Not finished.** Two slots are named and empty, and they are the honest shape of what is missing.

---

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# grade the libraries — the admission law is the primary artefact, and ALL THREE go in
# ONE run: F1 is a relation between libraries and one library alone cannot answer it
swiftc -O -swift-version 5 reproduce/library-admission-law.swift -o /tmp/lal
/tmp/lal --library library/proteins --library library/compounds --library library/materials \
         --reproduce reproduce --evidence /tmp

# and any single entry's own measurement, e.g. the genome-wide guide map
swiftc -O reproduce/crispr-genome-offtarget-exact.swift -o /tmp/crispr
curl -sL https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/latest_release/GRCh38.primary_assembly.genome.fa.gz \
  | gunzip -c | /tmp/crispr corpus/crispr-atlas/guides_all.tsv
```

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

Each entry above carries its own `REPRODUCE` line, and none of them names a path private to one
machine — that is clause E9, and it is checked rather than promised.

## Related

- [**The library admission law**](The-Library-Admission-Law) — what may enter, and the 65 arms that prove it refuses.
- [**The Library of Proteins**](Library-Of-Proteins) · [**The Library of Material Systems**](Library-Of-Material-Systems) — the other two libraries, graded in the same run as this one.
- [Where else could this guide cut?](CRISPR-Genome-Off-Target-Map) — the full per-guide map with coordinates.
- [The exact off-target atlas of the nucleic-acid medicines](Oligonucleotide-Off-Target-Atlas) — the registry-wide screen.
- [The safety question made exact](The-Safety-Question-Made-Exact) — zilganersen, with its composition-matched control.
- [Study 26 — Master regulator bonds](Study-26-Master-Regulator-Bonds) — the study the discrimination court came from.
- [Study 37 — 37,910 validated discoveries, five molecules](Study-37-Validated-Discoveries-Five-Molecules) — why the per-library half exists.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
