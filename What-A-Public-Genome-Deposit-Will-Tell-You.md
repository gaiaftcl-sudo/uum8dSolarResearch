# What a public genome deposit will tell you — and four ways it will quietly mislead you first

*A verification study on the ReGPC Big Five deposit, the largest public personality-genetics release
there is. The subject under grading is the **deposit and the instruments that read it** — never any
person, never any group, and never anyone's traits.*

**Status: VERIFIED — 2026-09-08.** 168 files enumerated, **143 digested and verified on all three of
byte size, sha256 and md5**, **0 refused**. Every figure below was computed from those bytes. No
individual genotype was used, none exists in this deposit, and nothing here assesses anybody.

---

## Why this page exists

Someone is going to build a health tool on this data. It is public, it is enormous, and it is the
best of its kind. Before anyone does, there are four things in it that will silently give a wrong
answer — not through anybody's error, but because honest decisions upstream leave traps downstream.

All four are cheap to avoid once named. That is the whole point of the page.

## The source

**Open Science Framework, DOI `10.17605/OSF.IO/HGNSM`** — public, no account, no data-use agreement.
Schwaba, Clapp Sullivan, Akingbuwa, Ilves, Tanksley, Williams, … & Tucker-Drob (2026), *Nature*.
Revived Genomics of Personality Consortium.

Per-trait sample sizes, as the deposit's own README states them: extraversion 619,416 ·
agreeableness 567,557 · conscientiousness 608,424 · **neuroticism 1,098,209** · openness 568,491.

**There is no single 1.1-million Big Five cohort.** That figure is neuroticism alone. The other four
traits carry roughly half of it, because neuroticism draws on nearly all 46 contributing cohorts
while the others use subsets. Any design treating the five as comparable registers is treating one
register with twice the resolution of the rest as if it were a peer.

## Trap 1 — the deposit does not reproduce its own paper's locus counts

| trait | README N | max per-SNP N in the bytes | shortfall |
|---|---:|---:|---:|
| extraversion | 619,416 | 560,968 | 58,448 |
| agreeableness | 567,557 | 508,331 | 59,226 |
| conscientiousness | 608,424 | 538,822 | 69,602 |
| neuroticism | 1,098,209 | 1,029,379 | 68,830 |
| openness | 568,491 | 509,264 | 59,227 |

**23andMe contributed exactly 59,225 participants to each trait** — from the authors' own
`Section3_cohortldscestimates.csv` — and is excluded from the public deposit. Agreeableness (59,226)
and openness (59,227) match that to within one or two people. Conscientiousness and neuroticism sit
about 10,000 further down, so a second, smaller withdrawal rides on top of the 23andMe one for those
two and is **not itemised anywhere in the deposit**.

**The consequence, stated plainly: only 16 of 32 present agreeableness lead SNPs still reach
5×10⁻⁸ in the released file, and 1 of the 33 is absent from it entirely.** A reader who counts loci
in the deposit and compares that to the paper is counting two different samples.

This is a property of an honest exclusion, not an error by anyone. But it will look like a
replication failure to whoever hits it first.

## Trap 2 — `MAF` is not the effect allele frequency, and the error is invisible

The frequency column is **minor** allele frequency. Variance explained needs the **effect** allele
frequency. At **771 of 1,073 lead loci — 71.85% —** the effect allele is the *major* allele, so
EAF = 1 − MAF.

Substituting one for the other is silently wrong, because 2f(1−f) is symmetric about 0.5: the
arithmetic still returns a plausible number. The deposit ships `ReGPC_MAF_EAF_Crosswalk.txt.gz`
precisely for this. Use it.

Verified: `MAF > 0.5` returns **zero** across all five European files, so the column really is
minor-coded as documented.

## Trap 3 — the five files are not all the same format

`ReGPC_ext_eur`, `ReGPC_con_eur` and `ReGPC_neu_eur` are **space-delimited**.
`ReGPC_agr_eur` and `ReGPC_ope_eur` are **tab-delimited**.

The declared header is identical in all five. A parser that splits on one and not the other will
read three files correctly and two as garbage, or worse, as a single column — without erroring.

## Trap 4 — the circulating lead-locus count double-counts

The figure in circulation is **1,260**. The correct pooled figure is **1,257**: the sum of the five
`<TRAIT>_finalleadsnps.csv` files. The extra three are `leadSNPsAFR` rows **already inside**
finalleadsnps, counted twice.

Reconciles exactly: **1,073 admitted + 183 palindromic dropped + 1 refused = 1,257** — and the
identity holds per trait as well as in total. Per trait: extraversion 221 · agreeableness 34 ·
conscientiousness 115 · neuroticism 591 · openness 112.

The 183 palindromic sites are A/T and C/G variants where strand cannot be resolved from the file
alone. A strand-flipped effect allele reverses the sign of an effect, which is worse than a missing
locus because it looks correct.

## What the deposit does support, measured

**Direction survives sibling comparison.** 727 of 871 lead loci present in the matched within-family
files keep the sign of their population effect — **83.47%** — against a **measured floor of 70.64%**
produced by sample overlap alone, computed over 21,825,096 essentially-null comparisons between the
same two files. The excess is **+117 loci**, not +727. The signal is real and it is roughly a
quarter of the size a naive reading gives.

**Direction survives a balanced split; significance does not, and only one of those is about
biology.** Split-half direction agreement is **1,044 of 1,065 (98.03%)** against a 49.95%
derangement control. Re-declaration at 5×10⁻⁸ in both halves is **1 of 1,065** — because the halves
carry only 13.2% and 19.6% of the discovery sample's N. That bounds power, not truth.

**The trait signal does not depend much on which questionnaire measured it.** Cross-instrument
direction agreement matches the split-half control once sample size is matched. Against the Q
statistic's own genome-wide rate — not a nominal 5%, which would have doubled the apparent effect —
a small aggregate component remains: **105 of 984 register loci against 75.8 expected, 1.38×, with
0 of 984 reaching 5×10⁻⁷ in any trait.**

## The one large thing nobody can explain

**European→African transfer deficit: 549/888 (61.8%) against 2,730/2,956 (92.4%)** for European
geography strata — and it **survives power matching** at 327/525 against 515/563 with a near-exact N
match. Allele frequency and imputation quality are **refuted** as explanations by their own
stratification.

The cause is **NOT KNOWN**. It is the largest unexplained structure in the deposit, it is not a
power artifact, and it bears directly on whether anything built from this data generalises beyond
one ancestry. Anyone building a health tool on these bytes should treat it as the open question.

## What we call, and what we refuse to call

**We call this deposit sound and unusually well documented.** 143 of 143 attempted digests verified
on three independent checks, zero refusals, and the consortium shipped the within-family, split-half
and instrument-stratified arms that made every control on this page possible. Most releases ship
none of them. The traps above are the cost of honest choices, not of carelessness.

**We refuse to call any of it a statement about a person.** Every figure here is a population rate
over aggregate summary statistics. No individual genotype exists in this deposit, none was used, and
nothing on this page can or should be applied to anybody. **Personality is not diagnosed, predicted
or scored here, and these data cannot do so.**

**We refuse to convert any of it into a trait assessment, a hiring signal, or a fitness
determination.** Using genetic information for employment or assignment decisions is prohibited
under the US Genetic Information Nondiscrimination Act and comparable law elsewhere. That is a fact
about what may be built.

**Where a bench should point.** The ancestry transfer deficit, because it is large, unexplained, and
survives the obvious controls — and because everything downstream of this deposit inherits it.

## Reproduce

Every fact above is re-derivable from the public deposit. Nothing is behind a login.

```bash
# the deposit, public, no account
curl -sL "https://api.osf.io/v2/nodes/hgnsm/files/osfstorage/" | jq '.data[].attributes.name'

# trap 2 — the effect allele is the major allele at most lead loci
gunzip -c ReGPC_neu_eur.txt.gz | awk 'NR>1 && $6+0>0.5' | wc -l    # 0 — MAF really is minor-coded

# trap 3 — the five files are not the same format
for t in ext agr con neu ope; do
  printf "%s " $t; gunzip -c ReGPC_${t}_eur.txt.gz | head -1 | grep -qP '\t' && echo TAB || echo SPACE
done

# genome-wide significant variants per trait, counted from the bytes
for t in ext agr con neu ope; do
  printf "%s " $t
  gunzip -c ReGPC_${t}_eur.txt.gz | awk 'NR>1 && $10+0<5e-8' | wc -l
done   # 7998 / 1296 / 3612 / 38642 / 3676 — total 55,224 variant-level
```

Variant-level associations below 5×10⁻⁸ total **55,224** across the five European files, over
**46,424,555** variant rows. That is a different quantity from the 1,257 LD-independent lead loci
and the two should never be compared.

---

## Rights — source-available, not open-source

The verification logic and every figure are published so anyone may check them. Re-deriving these
facts from the public deposit requires no permission and no agreement with us. Affine.Earth asserts
no claim over the ReGPC data or the underlying publication, which belong to their authors and to the
public.
