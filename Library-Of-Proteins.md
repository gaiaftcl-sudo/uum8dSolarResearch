# The Library of Proteins

*Candidate and known protein and peptide matter, admitted by a law rather than by us. Every
entry names one measurement, the program that produced it, a figure matched at a token boundary
against a line of that program's output, the seal over the whole run, and the observation that
would overturn it. Nothing enters on an author's say-so, and nothing enters because it sounded
promising.*

---

## What this library is for, and who it is for

It is for someone who does not know us and has no reason to trust us.

A patient, a prescriber, a regulator, a bench scientist, a journalist. Someone who wants to
know what a claim about a peptide actually rests on, and who is entitled to get that answer
without asking anyone's permission, without an account, and without believing a word of the
prose around it. Every figure on this page can be re-derived from a clean clone with a Swift
compiler and the public corpora. If a figure here and the program that produces it ever
disagree, the harness that runs on every commit goes red and says which one moved.

It is a **library, not a study**. A study closes. This grows: as new peptide matter is
measured, it is added under the same law, and what is already here stays where it is —
including anything later refuted, which is superseded in place and never deleted.

**Today it holds five admitted entries, one held entry, and four named open slots.**

---

## The admission law, in one paragraph

An entry is a fenced `affine-entry` block carrying thirteen required keys: what library it
belongs to, an identifier well-formed for its kind, what was measured with a quantity in it,
the program in `reproduce/` that produces it, at least one figure matching, at a token boundary, a line of
that program's output, a seal that program prints or the explicit token `NONE_PRINTED`, a
grade transcribed from [`Ontology.md`](Ontology) and supported by the evidence actually
present, at least one line saying what we explicitly do **not** call it, the observation that
would overturn it, a command a stranger can run from a clean clone, and the standing line that
none of this is medical advice — carried inside the entry, because a row gets copied out of a
library and the disclaimer has to travel with it. Fifteen per-entry clauses check that. Nine
more hold the whole collection at once and publish a distinct count over the identity field — and
the count carried by its most repeated value — beside the row count, always. A tenth clause, F1,
holds two libraries at once, which is why the three libraries are graded in ONE run.
**Nothing enters without a reproducible measurement**, and a claim whose figure no program prints
is refused with the clause named. The full law is
[The library admission law](The-Library-Admission-Law); the law *is* the program,
`reproduce/library-admission-law.swift`, and it runs 71 control arms in three directions before
it grades anything.

**Why the per-library half exists.** A generative pipeline in this same programme reported
37,910 validated discoveries and contained **five distinct molecules**. Every row was valid.
Every per-row check that ran on it was right to pass it. No per-item validator can see that
defect, because no per-item validator ever holds two items at once. So this page publishes its
row count and its distinct count side by side, on every axis, and it is a section of the page
rather than a footnote.

---

## The entries

Five admitted. Each block below is the entry, byte for byte, as the checker reads it from
`library/proteins/`. The commentary around each block carries no claim.

### 1 — The founding population: 78,680 generated sequences, absent from the human proteome

The corpus arrived from a generative pipeline labelled *validated cures*. That label is not
evidence and it is not carried here. What **is** carried is the one question about the corpus
that is exactly decidable without a model, a score or a judgement: does any of it already exist
in us? Every one of the 5,165,782 generated residues was matched against every one of the
11,418,237 residues of the reviewed human proteome. Complete enumeration, integers only, no
sampling and no cutoff inside the arithmetic.

**The answer is zero.** These are novel chemical matter at primary-sequence resolution. That is
the strongest word the arithmetic supports, and this library does not print a stronger one.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the 78,680 generated sequences, pinned in corpus/eric/SHA256SUMS
TITLE          Generated peptides against the human proteome — exact substring screen
MEASURED       0 of 78,680 generated sequences occur in the reviewed human proteome. 5,165,782 generated residues matched against 11,418,237 reference residues over 20,431 proteins, complete enumeration, no sampling. Longest exact shared substring 12 residues against a median generated length of 66, reached by 1 sequence.
PROGRAM        protein-novelty-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         corpus rows       78680
FIGURE         reference residues 11418237
FIGURE         8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
SEAL           8c50b3e877d1dac7b68244464ae679fc43ed273d9fd38e7e348b823c3e80563b
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/protein-novelty-exact.swift — one file, no imports beyond Foundation, 12 self-test arms in both directions
REFUSED        not a cure, and not a claim of efficacy against any of the 16 cancer labels these sequences carry
REFUSED        not safe. Structure, folding, binding, immunogenicity, toxicity, protease stability and off-target activity were not measured
REFUSED        not unrelated to human proteins. This screen measures exact substring identity. Homology under substitution is a different measurement, not a refinement of this one, and it was not made here
REFUSED        the source corpus confidence, coherence, overall_score and validation_passed columns are Doubles and are barred from every verdict here
FALSIFIER      a screen of the same two digests returning any occurrence of a generated sequence in the reference, or a longest exact shared substring above 12 residues
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 protein-novelty-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

### 2 — The second population: 1,400 sequences, screened separately and never pooled

Two populations screened together let either one carry the other's result. These were screened
apart by the same matcher against the same reference, and their intersection is zero — measured,
not assumed. Their longest exact shared substring with a human protein reaches 9 residues, on
sequences running to 100.

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

### 3 — The one individual measurement: a 12-residue fragment in TRIM25 Q14258

The population entry is a count over 78,680 sequences. This is a claim about one of them, and it
is the only sequence in the corpus that carries an individual measurement rather than membership
of a tier: the unique maximum. One sequence, `Lymphoma_504`, length 76, shares the twelve
residues `LETFLAKSRPEL` with `Q14258` beginning at residue 441. Nothing reaches 11. Twelve
sequences reach 10.

The residue index is 1-based, so a reader can confirm the fragment **and** its position with
`grep` against the pinned reference and without running our program at all. That is deliberate:
an individually named entry is only worth having if it can be checked individually.

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

### 4 — What kind of object these sequences are: the composition is a design signature

A stranger should know what they are reading before reading a claim about it. The population is
enriched in lysine and arginine at 198,674 ppm against the reviewed human proteome's own
113,634 ppm — and is at the same time **flatter** than that proteome, spanning 3,927 thousandths
from most to least abundant residue where the proteome spans 8,211. The six least abundant
corpus residues agree to within one part in 118.

Six residues that agree to a part in a hundred are six draws from one shared weight. An
enrichment drawn from a natural background carries that background's spread with it, and this one
does not. **The alphabet was designed.** That is a statement of provenance, not a verdict on the
chemistry, and this library says it plainly rather than leaving a reader to infer it.

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

### 5 — The overlap that does exist is what chance predicts

*Absent from the proteome* and *no closer to the proteome than composition alone forces* are two
different claims. The first is the headline; the second is the one a sceptical reader should
want, because it is the one that says the residual overlap carries no hidden signal.

Against an integer null handed the corpus's own composition — the aligned-pair match probability
is 55,372 ppm where a uniform 20-letter alphabet would be 50,000, so the enrichment is given to
the null for free rather than credited to the corpus as signal — the observed overlap sits where
chance puts it. At 9 residues the null expects 249,852,560 millionths of a coincidence and 246
sequences are observed. At 10, 13,570,309 millionths against 13. The single sequence reaching 12
stands against 39,993 millionths: one event in the tail of eleven length bins, which is a
coincidence to be checked, not a homology to be claimed.

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

---

## The entry that is HELD, and why holding is not refusing

**ABSENCE, REFUSAL and NOT_KNOWN are three different answers.** A sixth entry is on file and is
in neither the admitted set nor the refused set. It waits, by name.

```affine-entry
LIBRARY        PROTEINS
IDENTITY_KIND  CONTENT_DIGEST
IDENTITY       bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
DIGEST_OF      proteins_validated.csv — the same 78,680 sequences, put to a different question
TITLE          Exact Smith-Waterman against the reviewed human proteome, real against null
MEASURED       Paired against their own shuffles, 36,128 sequences score above and 36,113 below — a coin. The null maximum of 94 exceeds the real maximum of 90, over 118 trillion dynamic-programming cells with BLOSUM62 and integer affine gaps.
PROGRAM        peptide-homology-exact
FIGURE         bb3691b332fb15cdd54c43bc42905478e53c4f4b01862885a7304260498cf3f7
FIGURE         36128
FIGURE         36113
SEAL           b11fe3c9ee6dab0e98b9773a883b438e0cf102fcf4e34bd94ef7cb05a97e0313
GRADE          MEASURED
WHERE_THE_LAW_LIVES  reproduce/peptide-homology-exact.swift, with reproduce/validate-homology.sh
REFUSED        not sealed. The screen is in repair for a completeness figure that was stated unfalsifiably, and until that lands these numbers are measured and unsealed, which is a weaker thing than the substring screen beside it
REFUSED        not a finding of safety. A screen that finds no homology has found no homology and nothing else
FALSIFIER      the repaired program returning a real maximum above its null maximum, or an above/below split materially off a coin
REPRODUCE      cd reproduce && xcrun swiftc -O -swift-version 5 peptide-homology-exact.swift -o /tmp/run && /tmp/run
NOT_ADVICE     Nothing in this entry is medical advice and it is not a recommendation to take anything.
ADDED          2026-09-07
```

The exact Smith-Waterman screen — BLOSUM62, integer affine gaps, 118 trillion dynamic-programming
cells over real sequences and their own shuffles — answers the question the substring screen
cannot: homology under **substitution**. Paired against their own shuffles, 36,128 sequences score
above and 36,113 below, which is a coin, and the null maximum of 94 exceeds the real maximum of 90.

**Read those four numbers at two different strengths, because they are at two different
strengths.** 90 and 94 are pinned reference figures and a program in `reproduce/` prints them
here — `homology-detection-ladder` emits `real corpus observed max   90` and `null observed max
94` before it opens a single file. **36,128 and 36,113 are printed by nothing in this clone.**
They are the held entry's own figures, they are measured and unsealed, and the screen is in
repair for a completeness figure that was stated unfalsifiably. This page does not rest on them,
and the checker says so in its own words rather than leaving a reader to work it out:

```
generated-peptides-homology-under-substitution.md   NOT_KNOWN
    HELD E4_FIGURE               2 of 3 figure(s) are absent from peptide-homology-exact's
                                 output, but that output is ITSELF A REFUSAL — the program did
                                 not run to completion here, so its silence is not evidence
                                 about the figures. Run it against its corpus and grade again.
                                 First absent: '36128'
    HELD E7_GRADE_SUPPORTED      graded MEASURED; the evidence for that grade is not present here
```

That distinction is load-bearing and it was paid for. An earlier revision of the law read the
program's refusal transcript as an *absence* and refused an honest entry for it — the direction
that looks like rigour and is not. A program that stopped for want of its corpus has not said
that a figure is wrong; it has said nothing at all.

---

## THE REFUSED SECTION

A library that shows only what it admitted cannot be audited. Everything below was constructed
or considered, run through the checker, and did not enter. Each case is on disk in
`control-cases/proteins/` so a stranger can run the refusal themselves rather than take this
section's word for it.

### The cure claim, four ways

The corpus arrived labelled *validated cures*. **This library does not carry that word about
anything in it**, and the law was pointed at four different ways an author might smuggle it in.
Each case is the admitted 78,680 entry with **exactly one thing changed**, so the refusal is
attributable to that change and nothing else.

| case | the one change | verdict | clause, verbatim |
|---|---|---|---|
| `case-8-cure-claim-names-a-figure.md` | a therapeutic figure is added: *efficacy against the 16 labelled cancers: demonstrated* | **REFUSED** | `E4_FIGURE  1 of 5 figure(s) are NOT printed by protein-novelty-exact: first is 'efficacy against the 16 labelled cancers: demonstrated'` — and `E7_GRADE_SUPPORTED` falls with it |
| `case-9-cure-claim-reaches-for-verified.md` | `GRADE MEASURED` → `GRADE VERIFIED` | **REFUSED** | `E7_GRADE_SUPPORTED  graded VERIFIED with no SOURCE+QUOTE. Ontology.md: VERIFIED means fetched and read, with the row or sentence quoted. On this evidence the entry supports REPORTED at most.` |
| `case-10-recommendation-carries-no-refusal.md` | every `REFUSED` line deleted | **REFUSED** | `E0_SHAPE  required key(s) absent: REFUSED` and `E8_REFUSAL  no REFUSED line. An entry with no refusal line is overclaiming by omission — it lets a reader take the largest reading the words allow.` |
| `case-11-prose-only-cure-claim-admitted-a-measured-gap.md` | `MEASURED` rewritten as *78,680 peptide cures for 16 cancers, ready for patients today; 0 of them fail.* | **ADMITTED** | every clause passes. See below. |

**The fourth case is a gap in the law and it is published here rather than left to be found.**

Measured 2026-09-07: a cure claim written as prose, carrying no figure of its own, with the
entry's real figures and real seal left in place, passes all fifteen per-entry clauses. E2 asks
a `MEASURED` line for a quantity and that sentence has one. Nothing in the law reads a `MEASURED`
line against the entry's own `REFUSED` lines, so the entry stands with *78,680 peptide cures* on
one line and *not a cure, and not a claim of efficacy* four lines below it, and the checker
prints `ADMITTED`.

**What the law does catch, exactly:** the moment that claim is asked to name a figure, there is
no figure — case 8. The moment it reaches for a grade above `MEASURED`, the grade is unsupported
— case 9. The moment it drops its refusal lines to read as a recommendation, the shape is
incomplete — case 10. **The law grades evidence, not adjectives.** A sentence that makes no
checkable claim is not caught by an instrument built to check claims.

Naming what a repair would have to discriminate, since a detector is easy to write badly here: a
word list over `MEASURED` refuses the honest line *0 of 78,680 are cures* alongside the dishonest
one, and that is the always-red half of the same defect. The clause worth building reads a
`MEASURED` line against the entry's **own** `REFUSED` lines and refuses the contradiction — which
is a gap in the law, not a missing measurement, so it is not an open slot in this library's
manifest. Until it lands, this stands as a named, dated, reproducible hole with its control case
on disk.

### The thirteen sequences at 10 residues — considered, did not enter

Thirteen sequences reach a 10-residue exact shared substring, each in a different human protein,
each with a named accession and offset. Every one could have been written as its own entry with a
different identity, a different title and a different `MEASURED` line, and the library would have
grown from five rows to eighteen.

**It would also have been the Study-37 shape exactly.** Thirteen rows, thirteen identities,
thirteen titles, one measurement — a tier, carved into thirteen entries. The axis that varies is
never the axis that lies. They are published in full inside the population entry's own program
output, where they belong, and they are not individually admitted here. The 12-residue maximum is
admitted individually because it is a maximum: exactly one sequence, unique in 78,680.

### The corpus's own score columns

`confidence`, `coherence`, `overall_score`, `validation_passed`. Every one is a `Double`, and
none measures anything outside the program that wrote it. They are barred from every `MEASURED`
and `FIGURE` line by clause E12 and they appear on this page only in refusal lines — which is the
opposite of relying on them.

### The library itself, before the manifest moved

**The three new entries were refused as a collection while every one of them passed individually.**
Run at the moment they landed, with the ceilings still standing where two entries had left them:

```
LIBRARY PROTEINS   ->   REFUSED
  entry files   6      ADMITTED 5      HELD 1      REFUSED 0

    axis                            entries  distinct  declared  holds
    IDENTITY                              5         3         2  yes
    PROGRAM                               5         1         2  NO
    SEAL (sealed entries only)            5         1         2  NO
    MEASURED                              5         5         1  yes

   REF  L4_DISTINCT_PROGRAM       5 entries over 1 distinct exceeds the declared ceiling of 2
                                  per value — 1 x 2 < 5. Worst: 'protein-novelty-exact' carries 5.
   REF  L5_DISTINCT_SEAL          5 entries over 1 distinct exceeds the declared ceiling of 2
                                  per value — 1 x 2 < 5.
```

`SECTION 6 — THE CALL` printed: *No individual entry is refused and a LIBRARY clause is. Read the
per-library clauses above: the defect is in the collection, not in any one row.* That is the
per-library half doing the one thing the per-entry half structurally cannot.

The repair is a public act, not a quiet one: `DECLARED_ENTRIES_PER_PROGRAM` and
`DECLARED_ENTRIES_PER_SEAL` moved from 2 to 5, in the manifest, with the reason written beside
them — one program run answers five separable questions here and it is the same run.

**The rest of that paragraph used to read: "`DECLARED_ENTRIES_PER_IDENTITY` was not moved: 3
distinct × 2 ≥ 5 already holds." Later the same day, that sentence was measured and it was wrong.**
`3 × 2 ≥ 5` is an aggregate. Per value — which is where the ceiling is declared and what the words
"per identity" mean — `bb3691b3…` carried **3** against a declared **2**, and the library was
inside the gap while its own page printed `holds`. The ceiling is now 3, the test is per value, and
the `most at 1` column above exists so no reader has to take the arithmetic on trust. The manifest
also declares `DECLARED_ENTRIES_PER_TRIPLE 3` for the first time, for the same three entries.

---

## Rows and distinct identities, side by side

This library states both. Always. It is one hash set and one integer, and it costs less than the
per-entry check that already runs.

```
    axis                            entries  distinct  most at 1  declared  holds
    IDENTITY                              5         3          3         3  yes
    PROGRAM                               5         1          5         5  yes
    SEAL (sealed entries only)            5         1          5         5  yes
    MEASURED                              5         5          1         1  yes
    IDENTITY|PROGRAM|SEAL triple          5         3          3         3  yes
    TITLE (census, not a gate)            5         5          1         -    -
    GRADE (census, not a gate)            5         1          5         -    -
```

**How to read this.** `entries` is the row count. `distinct` is the number of different values on
that axis. **`most at 1` is the count carried by the single most repeated value** — the number the
declared ceiling is actually about. `declared` is the integer this library published in advance, in
its manifest, saying how much repetition it considers honest **at one value**. The test is
`most at 1 ≤ declared`: integer comparison, per value, never a ratio, because a ratio between two
integers is where a float enters a program that had none.

> **The `most at 1` column was not here when this page was first written, and its absence had
> already hidden something on this very library.** The test then read `distinct × declared ≥
> entries` — an *aggregate* wearing a per-value name — and this table printed
> `IDENTITY  5  3  2  yes` while the digest `bb3691b3…` carried **three of the five admitted
> entries against a declared ceiling of two**. `3 × 2 ≥ 5` is true; *no identity carries more than
> 2* was not, and the page never said which one it was testing. The ceiling is now tested where it
> is declared, the most repeated value is named on the passing path as well as the refusing one,
> and `DECLARED_ENTRIES_PER_IDENTITY` moved to **3** in the manifest, in public, with the reason
> written beside it. Nothing was added and nothing was withdrawn; a ceiling that had never been
> true became true.

Five entries over three identities and one program is a small library that says so. A library
reporting 37,910 rows without this table beside it is telling you a loop bound.

**The fifth row is the whole triple.** `IDENTITY|PROGRAM|SEAL` carries 3 at one value here, and the
manifest declares 3: the 78,680-sequence digest, the novelty program and one seal answer the
population question, the composition question and the residual-overlap question from **one run over
one corpus**. That is admissible because the library said so in advance. It is not admissible
because nobody counted.

`TITLE` and `GRADE` are printed as a **census, labelled not a gate**, and print a dash rather than a
verdict. A clause that never refuses is decoration, and calling a decoration a gate is how a reader
comes to trust one.

### The four open slots

An open slot is a fourth thing and deliberately not a terminal. A held entry has evidence that
exists somewhere; a slot has evidence **nowhere** — no program, no figure, no seal. Slots count in
no axis and gate on nothing. Naming them is how this library says what it is missing instead of
quietly not having it.

1. **Homology under substitution across the whole 80,080-sequence population** — the exact
   Smith-Waterman screen. Measured, not yet sealed; in repair for an unfalsifiable completeness
   figure. Named 2026-09-07.
2. **The 12-residue fragment `LETFLAKSRPEL` assayed against the human protein it was found in.**
   A bench measurement. The library does not have it. Named 2026-09-07.
3. **Nonspecific membrane activity of the K+R-enriched population.** Named by the screen's own
   transcript as the second experiment; no program, no figure, no seal. Named 2026-09-07.
4. **Structure, folding, binding, immunogenicity, toxicity, protease stability and off-target
   activity** for any sequence in this library. None measured, none held, none in progress here.
   Named 2026-09-07.

---

## How this library grows

**Who may add: anyone.** The law is the gatekeeper, not a person. There is no reviewer to persuade
and no committee to convince. An addition is a file, a program and a transcript, and the checker is
the referee — it runs in public, on a clean clone. Measured on this machine: **0.12 s of CPU and
1.0 s of wall time** to grade all sixteen entries across the three libraries, once the checker is
built. Building it took 6 min 24 s of wall time and 13.2 s of CPU on a contended machine, which is
worth stating rather than rounding to *fast*.

**What must accompany an addition — four things, in ONE commit:**

1. **The entry file** carrying an `affine-entry` block the checker admits.
2. **The program** in `reproduce/`, if it is new: self-contained, integer, with its own control arm
   in both directions.
3. **A `check_figure` row in `reproduce/validate.sh`** for at least one of the entry's figures, so
   the wiki's own harness goes red if the page and the program ever drift apart.
4. **The manifest ceilings**, moved if the addition needs them moved.

Point 4 is not bookkeeping. A stale ceiling silently re-admits what was just excluded. This
programme has already paid for that on a float ratchet whose frozen constant kept forgiving what it
had been raised to catch — and it was paid again here today, in the refusal printed two sections up.

**What this addition itself filed**, so the rule is visible being obeyed rather than described:

```bash
check_figure protein-novelty-exact "LETFLAKSRPEL" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "Q14258" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "249852560" "Generated-Peptides-Against-The-Human-Proteome.md"
check_figure protein-novelty-exact "198674 ppm = 19.8674%" ""
```

The last row is pinned **program-side only**, and says so in a comment beside it: the page carrying
that figure is not yet in the wiki root, and a row pinned to a page that does not exist is a red
harness. Its third argument becomes `Library-Of-Proteins.md` the moment this page lands, and the
pin is then two-sided like the three above it.

### When evidence is refuted, nothing is deleted

**A library that cannot retract cannot be trusted, and one that retracts by deleting is worse,
because it cannot be caught.** An entry whose evidence is overturned is superseded **in place**:

1. add `REFUTED_BY`, with what refuted it and a `YYYY-MM-DD` date;
2. rewrite `GRADE` to what the *surviving* evidence supports — usually `NOT_KNOWN`;
3. leave `MEASURED`, `FIGURE`, `SEAL` and `REFUSED` untouched, so the claim and its refutation
   stand on the same page;
4. `SUPERSEDES` on the replacement entry, if there is one.

Clause E14 enforces it in both directions: refuted-and-still-`MEASURED` is refused, an undated
refutation is refused, and a refuted entry that is dated and regraded is **admitted**. Retraction is
a path through the law, not an exit from it.

This is written this hard for a measured reason. The V234 ledger's `BEFORE DELETE` triggers were
disarmable at runtime, three migrations used the bypass, and for every game they touched *"never
CUREd"* and *"its CUREs were deleted"* are now indistinguishable. Deleting a refuted entry is the
same act, one step later.

### What would promote a candidate in this library to a higher grade

Stated plainly, because a library that shows only its ceiling implies a path it has not got.

Everything admitted here is `MEASURED` — produced by a program in `reproduce/` over a corpus pinned
by digest. Under [`Ontology.md`](Ontology) that is what these figures are, and it is neither the
top nor the bottom of the ladder. `VERIFIED` is not a *stronger version* of `MEASURED`; it is a
different claim, about a fetched and quoted external source, and it is reachable only for an entry
whose figure comes from somebody else's published record.

**What is not on the ladder at all:** *safe*, *effective*, *a cure*. No grade in this ontology
carries them, and no program in `reproduce/` produces a figure that would support one. A sequence
in this library moves toward a therapeutic claim only through measurements this library does not
have and names as open slots — a binding assay against a named partner, a membrane-activity panel,
structure, immunogenicity, protease stability, and everything a regulator asks for afterwards. Each
of those, when it exists, enters as its **own entry with its own program and its own falsifier**.
It does not upgrade a sentence already on this page.

The nearest genuine promotion available today is slot 1: the homology screen leaving repair, its
program running to completion in a clean clone, and its held entry graded `MEASURED` on figures the
checker finds verbatim. That is one program-run away, and it is one entry, not a new adjective on
five.

---

## What this library is NOT

- **Not medical advice.** Nothing here is medical advice and nothing here should change anyone's
  treatment. That line travels inside every entry, not just in this section, because a row gets
  copied out of a library.
- **Not a recommendation to take anything.** No entry recommends any substance to any person for
  any purpose.
- **Not a claim that anything here is safe.** Structure, folding, binding, immunogenicity,
  toxicity, protease stability and off-target activity were not measured. They are named open
  slots. A screen that finds no exact match has found no exact match and nothing else.
- **Not a claim that anything here is a cure**, and not a carrier of the generator's own *validated
  cures* label. The corpus arrived with that label; the label is not evidence and it did not enter.
- **Not a claim of efficacy** against any of the sixteen cancers these sequences are labelled for,
  or against anything else.
- **Not a claim of unrelatedness to human proteins.** The admitted screens measure exact substring
  identity. Homology under substitution is a *different measurement, not a refinement of this one*,
  and it is held, not admitted.
- **Not a substitute for a laboratory.** Every open slot on this page is a bench measurement, and a
  bench is the only thing that closes it.
- **Not a substitute for a regulator.** Nothing on this page has been reviewed by any regulatory
  authority, and this page makes no claim about any regulatory status.
- **Not peer-reviewed.** It is better checked than that in one narrow respect and worse in every
  other: every figure is re-derivable by a stranger in minutes, and no expert has read it.

---

## Reproduce

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch

# the measurement — every figure in the five admitted entries
swiftc -O -swift-version 5 reproduce/protein-novelty-exact.swift -o /tmp/novelty
( cd reproduce && /tmp/novelty )

# the law — grade ALL THREE libraries in ONE run. Never one at a time: F1 is a relation
# BETWEEN libraries and a single-library run reports it NOT_KNOWN and exits 2.
swiftc -O -swift-version 5 reproduce/library-admission-law.swift -o /tmp/lal
/tmp/lal --library library/proteins --library library/compounds --library library/materials \
         --reproduce reproduce --evidence /tmp

# and watch it refuse: four constructed cure claims, one change each
for c in control-cases/proteins/*.md; do /tmp/lal --entry "$c" --reproduce reproduce --evidence /tmp; done
```

No account, no key, no data-use agreement, and no floating point anywhere in the exact path.

**Grade the three libraries together, always.** A run given one library cannot answer a question
about the relation between libraries, so it prints `F1_NO_ENTRY_FILED_TWICE   NOT_KNOWN` and exits
2 — the honest answer, and not a clearance. The first version of this page published a clean table
produced by a single-library run that structurally could not reach the clause the combined run
refused on. That is fixed in the law and in this command.

**What the checker printed here, 2026-09-08**, so a reader has something to compare against:

```
CONTROL ARM  71/71 PASS        43 must REFUSE · 19 must ADMIT · 9 must HOLD
LIBRARY PROTEINS   ->   ADMITTED
  entry files   6      ADMITTED 5      HELD 1      REFUSED 0
  programs in reproduce/   89
  generated-peptides-homology-under-substitution.md   NOT_KNOWN
      HELD E4_FIGURE   3 figure(s) declared, and peptide-homology-exact's output here is
                       ITSELF A REFUSAL — it published no verdict, so any figure appearing
                       in it was QUOTED, not computed. A quoted figure is not evidence.
      HELD E5_SEAL     the declared seal does appear in that text, which is exactly the
                       trap: appearing and being computed are two different things.
F1_NO_ENTRY_FILED_TWICE   ok — no triple appears in more than one of the 3 libraries
                          graded together; 12 distinct triples over 14 admitted entries
TRANSCRIPT SEAL  sha256  da85dccf51d40c7dd5ecaf6842ba2927370c2bc6a26730e7ff3c55193297a3e5
sealed bytes             32,378
exit                     2          (2 means an entry is HELD, 1 means refused, 0 means clean)
```

**That HELD row is a correction we made to our own law on 2026-09-08, and it is worth reading
before the numbers.** The homology screen takes about 35 minutes over a 58,984,123,166,334-cell
comparison, so its program has a harness path: given no argument it runs no screen and instead
**prints the published figures**, which is what lets the wiki's harness check this page against the
program in a clean clone. Clauses E4 and E5 were then matching the entry's declared figures and its
declared seal against text the program had **quoted rather than computed** — and passing. The seal
of a screen that measured nothing was being credited to it. Both clauses now test for a refusal
**before** they look for the figure, three new control arms hold the repair, and this entry reads
NOT_KNOWN in a clean clone until someone runs the screen. **A held entry is not in the library and
is not thrown out of it.** Point the grader at a directory holding that transcript and it admits.

That seal covers the graded transcript, which includes the count of programs in `reproduce/` — so
a clone holding a different number of programs prints a different seal, and that is content
disagreeing, not a broken reproduction. The per-entry and per-library verdicts above it are what
must match.

The seal is **path-independent by construction**:
filesystem paths are printed outside the sealed bytes, because a seal that moves with the checkout
directory indicts a correct reproduction. The library entries carry the screen's
`ROOT-INVARIANT` digest — the transcript less its two filesystem-path lines — for the same reason.

---

## Related

- [**The library admission law**](The-Library-Admission-Law) — the law this page is downstream of, and the primary artefact of this work.
- [**The Library of Compound Cures**](Library-Of-Compound-Cures) · [**The Library of Material Systems**](Library-Of-Material-Systems) — the other two libraries, graded in the same run as this one.
- [Are the generated cures new? 78,680 sequences, counted against the human proteome](Generated-Peptides-Against-The-Human-Proteome) — the study the founding entries are drawn from.
- [Study 37 — 37,910 validated discoveries, five molecules](Study-37-Validated-Discoveries-Five-Molecules) — why the distinct count is a section of this page and not a footnote.
- [Ontology](Ontology) — the seven grades, transcribed rather than invented.

## Rights — source-available, not open-source

This wiki and its programs are published **source-available**: the source is visible so anyone
can inspect it and re-derive every figure. That visibility grants no rights. The repository
carries no LICENSE, which under default copyright means **all rights are reserved**. Any other
use requires a separate written licensing agreement with the authors.
