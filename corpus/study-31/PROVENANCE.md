# Study 31 baseline corpus — total column ozone

**Source:** NOAA Global Monitoring Laboratory, Dobson spectrophotometer total-ozone archive,
`https://gml.noaa.gov/aftp/data/ozwv/Dobson/dobson_to<STN>.txt`

**Fetched:** 2026-09-01, anonymously. No account, no key, no login.

**Stations, chosen to span latitude rather than to favour a result:**

| file | station | latitude | rows | span |
|---|---|---|---|---|
| `ozone_BRW.txt` | Barrow, Alaska | 71.32 N | 4,926 | 1973-07-29 .. 2026-06-29 |
| `ozone_BLD.txt` | Boulder, Colorado | 40.02 N | 15,835 | 1966-09-19 .. 2026-06-28 |
| `ozone_MLO.txt` | Mauna Loa, Hawaii | 19.53 N | 17,431 | 1963-12-26 .. 2026-06-30 |
| `ozone_SMO.txt` | Tutuila, American Samoa | 14.25 S | 9,255 | 1976-01-02 .. 2026-06-22 |
| `ozone_SPO.txt` | Amundsen-Scott, South Pole | 89.90 S | 9,128 | 1963-12-05 .. 2026-07-30 |

**56,575 daily observations.**

**Why this archive and not a model reanalysis:** these are ground-based instrument readings, not
model output. The court grades instruments; a baseline taken from a model would make the
comparison circular.

**The zero-float property:** `Total_Ozone` is published in Dobson Units at exactly one decimal
place. It is ingested as an exact integer count of **deci-Dobson** (`276.0 DU` -> `2760`). No
floating-point value is constructed at any point between the archive file and the sealed verdict.

---

# Radiative baseline — greenhouse forcing and the reflective term

Ingested 2026-09-01 after the ozone baseline, because a biosphere study that grades only the
UV axis and ignores the radiative one is incomplete. Both were fetched anonymously.

| file | source | what it is |
|---|---|---|
| `aggi.txt` | NOAA GML Annual Greenhouse Gas Index | **measured radiative forcing in W/m², per gas, 1979–2024** |
| `co2_gl.txt` | NOAA GML | globally averaged monthly CO₂, ppm |
| `ch4_gl.txt` | NOAA GML | globally averaged monthly CH₄, ppb |
| `n2o_gl.txt` | NOAA GML | globally averaged monthly N₂O, ppb |

**Zero float.** AGGI publishes forcing at three decimals of W/m², ingested as exact integer
**milli-W/m²** (`3.539` → `3539`). CO₂ is published at two decimals of ppm, ingested as exact
integer **centi-ppm**. No floating-point value is constructed.

**Why AGGI is the right baseline:** it is the measured forcing the world already uses, in the same
unit the satellite-forcing papers report (mW/m²). Putting a projected satellite term against it is
a division of two measured-unit quantities rather than a comparison between differently-united
numbers — a failure this programme has already made once and corrected.
