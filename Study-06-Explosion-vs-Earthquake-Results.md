# Study 06 — Results: frozen law on Punggye-ri integer counts

## For every reader

1. The instrument wrote **integer seismometer counts** (miniSEED STEIM), not a float spectrum.
2. At IC.MDJ, every announced DPRK test (2006–2017) shows a travel-time appointment near **53 s** with huge SNR.
3. Near-site tectonic / collapse events either miss that appointment or sit far below the SNR floor.
4. Under a frozen integer law: **6/6 explosions WIN · 3/3 adversaries correctly rejected**.

Charter: [Study 06](Study-06-Explosion-vs-Earthquake.md) · Corpus: [Corpus](Study-06-Explosion-vs-Earthquake-Corpus.md) · Ledger: `corpus/study-06/study06_ledger.json`

---

## Frozen law (sealed 2026-08-20T19:45:00Z)

| Symbol | Meaning | Sealed integer |
|---|---|---|
| `pn_pred_s` | IC.MDJ predicted regional onset from catalog origin | **53** s |
| `T_lag_s` | \|travel − pn_pred\| max | **2** s |
| `T_snr_ppt` | peak 1-s energy ×1000 / pre-origin 20-s median | **20,000** ppt |
| Onset | first 1-s bin after origin with energy ≥ 5× pre-median and ≥ median+500 | — |
| FIRE | onset found AND lag ≤ T_lag AND snr ≥ T_snr | — |

Station stratum this seal: **IC.MDJ.00.BHZ only**. IU.INCN = **VOID-by-inventory** (not pulled). No float crosses a seal.

**WIN (explosion)** iff detector FIRE. **WIN (adversary)** iff detector does **not** FIRE.

---

## Primary grades — announced explosions

**6 / 6 WIN**

| Event | Origin (UTC) | mb×1000 | travel_s | lag_s | snr_ppt | Verdict |
|---|---|---:|---:|---:|---:|---|
| usp000eurb (2006-10-09) | 2006-10-09T01:35:28.020Z | 4300 | 53 | 0 | 68,315 | **WIN** |
| usp000gxgc (2009-05-25) | 2009-05-25T00:54:43.120Z | 4700 | 53 | 0 | 584,014 | **WIN** |
| usc000f5t0 (2013-02-12) | 2013-02-12T02:57:51.490Z | 5100 | 53 | 0 | 1,324,649 | **WIN** |
| us10004bnm (2016-01-06) | 2016-01-06T01:30:01.480Z | 5100 | 53 | 0 | 643,006 | **WIN** |
| us10006n8a (2016-09-09) | 2016-09-09T00:30:01.440Z | 5300 | 53 | 0 | 718,965 | **WIN** |
| us2000aert (2017-09-03) | 2017-09-03T03:30:01.760Z | 6300 | 52 | −1 | 3,494,402 | **WIN** |

Leave-one-out under the same frozen integers: **6/6 WIN**.

---

## Adversary grades — collapse + near-site

**3 / 3 correctly rejected (WIN on adversary surface)**

| Event | Class | travel_s | lag_s | snr_ppt | FIRE | Verdict |
|---|---|---:|---:|---:|---|---|
| us2000aetk (2017-09-03 +8m30s) | cavity collapse | — | — | 2,734 | no | **WIN** |
| us2000ati7 (2017-09-23) | near-site ml 3.6 | 61 | +8 | 5,887 | no | **WIN** |
| us1000aqsx (2017-10-12) | near-site mb_lg 2.9 | 60 | +7 | 8,571 | no | **WIN** |

Shape separation: explosions keep the **53±2 s** appointment at SNR ≥ 20,000 ppt. Adversaries either have no onset under the sealed rule, or arrive **+7…+8 s** off the frozen ladder with SNR below the floor.

---

## What this proves for UUM-8D

Raw ground motion is an **integer lattice appointment** (catalog clock + station track + count energy). Continuous P/S spectral discriminants are not required to separate the announced class from its loudest near-site look-alikes on this stratum.

---

**Status: LAW FROZEN — historical IC.MDJ seal complete. Prospective ComCat explosion-type events OPEN on the Registry. IU.INCN and 2010-05-12 holdout remain VOID / unscored until pulled.**
