# The data archives — every source, exactly how to reach it

Everything the experiment consumes is public. This page records each archive's access mechanics — including the quirks we hit live, so no one re-discovers them — and the provenance ledger of every byte the substrate has actually ingested.

## Tier 1 — wired and live-verified (Stage 1–3)

### MIT Haystack **Madrigal** — the TEC backbone
- **Base:** `https://cedar.openmadrigal.org` (HTTPS only — plain http 301s). **No account**; every call carries an identification triple (`user_fullname`/`user_email`/`user_affiliation`) from `~/.gaiaftcl/helio_sources.toml`.
- **Discovery:** `getExperimentsService.py?code=8000` (World-wide GNSS TEC; Millstone Hill ISR is code 30). **Quirk #1 (measured):** the end bound must be *next-day 00:00* — an end bound of `23:59:59` intermittently returns an EMPTY experiment list.
- **Files:** `getExperimentFilesService.py?id=<exp>` — gridded vertical TEC is **kindat 3500** (`TEC binned 1 degree by 1 degree by 5 min`), category 1 = final (e.g. `gps240408g.002.hdf5`); line-of-sight TEC is kindat 3505 (Stage-4 material).
- **Extraction:** `isprintService.py` — ASCII always, never HDF5. **Quirk #2 (measured):** `parms` is a REPEATED query key (`parms=YEAR&parms=MONTH&…`), and filters percent-encode `=` and `,` (`filter%3Dgdlat%2C32%2C34`, `%20` between filters). Columns come back whitespace-aligned: `YEAR MONTH DAY HOUR MIN SEC GDLAT GLON TEC DTEC`, 5-minute bins stamped at ~hh:mm:30.
- **Quirk #3 (measured):** isprint scans the ENTIRE day file server-side before the first byte — an eclipse-day file takes several minutes to first byte; the client runs a 900 s request timeout (120 s produced `-1001` timeouts).
- **Strategy (measured):** one scan costs the same whatever the filter, so fetch ONE bounding box over every wanted station per day and slice locally — 7 stations cost the same wall-clock as 1.
- Coverage: world TEC files reach back through 2003 (thinner receiver network in early years — recorded honestly, never mixed across years in baselines).

### GFZ Potsdam **Kp** — the quiet/disturbed gate
- `https://kp.gfz.de/app/json/?start=<day>T00:00:00Z&end=<day>T23:59:59Z&index=Kp` (the old `kp.gfz-potsdam.de` host 301s here). Eight 3-hour values per UT day, keyless JSON. Drives the pre-registered **max Kp ≤ 4** quiet rule for every baseline day.

### USGS **Geomagnetism web service** — magnetometers
- `https://geomag.usgs.gov/ws/data/?id=BOU&format=json&elements=H&sampling_period=60&starttime=…&endtime=…` — keyless JSON (`times[]` + per-element `values[]` with nulls for gaps). 1-minute H component; the Stage-3 capture channel.

### NOAA SWPC — the real-time nowcast
- `https://services.swpc.noaa.gov/json/planetary_k_index_1m.json` — 1-minute estimated planetary K, keyless. `eclipse-watch` reads it every pass; **est Kp ≥ 5 = the storm pivot**.

### NASA GSFC — Besselian elements
- `https://eclipse.gsfc.nasa.gov/SEbeselm/SEbeselm2001/SE<YYYY><Mon><DD>[T|A]beselm.html` — the element polynomials embedded verbatim in the substrate (fingerprints: 2017 `via allEclipseIDs`, 2024 `17af652a628dc38e`, 2026 `f9f9f8eebf7ed0cc`). Note: eclipsewise.com and theskylive.com block programmatic fetch (403); the GSFC tables do not.

## Tier 2 — documented for Stage 4 (the deep retrospective)

| Archive | What | Access | Registration |
|---|---|---|---|
| **NASA CDDIS** | 1 Hz RINEX (15-min Hatanaka+gzip granules, ~285 sites, ~25 GB/day; consolidated to tars after 6 months) | `https://cddis.nasa.gov/archive/gnss/data/highrate/YYYY/DDD/HH/` | **Earthdata login** (free) |
| **EarthScope/GAGE** | NOTA high-rate + NTRIP real-time (1 Hz BINEX/RTCM) | archive + `rtgps@earthscope.org` for caster creds | free registration |
| **ESA Swarm** | MAGx_LR 1 Hz / MAGx_HR 50 Hz vector field, EFIx_LP 2 Hz plasma, TEC products (CDF) | VirES `https://vires.services` / `swarm-diss.eo.esa.int` | **ESA EO** (~2 working days) |
| **UCAR CDAAC** | COSMIC-2 `ionPrf` electron-density profiles (netCDF, Abel-inverted, 6 satellites) | `https://data.cosmic.ucar.edu/gnss-ro/cosmic2/` (DOI 10.5065/t353-c093) | free (some products) |
| **GIRO/DIDBase** | 64 ionosondes, 42 real-time (minutes latency), foF2/TID diagnostics | `https://giro.uml.edu/didbase/` | free (rules-of-road ack) |
| **SuperMAG** | >600 baseline-corrected magnetometers, 1-min uniform + indices | `https://supermag.jhuapl.edu/` | free registration |
| **NASA OMNIWeb** | 1-min bow-shock-nose IMF/plasma + Dst/AE/SYM-H, 1995→ | `https://omniweb.gsfc.nasa.gov/` | none |
| **WDC Kyoto** | Dst (the storm-intensity canon) | `https://wdc.kugi.kyoto-u.ac.jp/dstdir/` | none |
| **IRIS/EarthScope DMC** | infrasound/seismic miniSEED (TA 40 Hz BDF channels) | FDSN `https://service.iris.edu/` | none |
| **IGS real-time** | NTRIP correction streams | `caster.cddis.eosdis.nasa.gov`, `products.igs-ip.net` | free registration |

Registrations are **founder actions** (account signups); none block the current pipeline.

## The provenance discipline

Every fetched artifact lands as a row in `helio_ingest_provenance` carrying the **SHA-256 of the raw fetched bytes**, the exact request URL, the source file path inside the archive, the row count that survived quantization, and the fetch timestamp. Every sample row in `helio_series_samples` points back to its provenance row. Same-scan slices share the same SHA — visible below.

<!-- GAIA:BEGIN ingest-ledger -->
| UT day | Stations sliced | vTEC bins | Scan SHA-256 (12) | Max Kp | Class |
|---|---|---|---|---|---|
| 2003-10-29 | 7 | 1860 | `145dc2eaf8ca` | 9.0 | DISTURBED |
| 2003-10-30 | 7 | 1816 | `abaf5f22591e` | 9.0 | DISTURBED |
| 2017-07-25 | 5 | 1440 | `1a8590fab838` | 3.0 | quiet |
| 2017-08-14 | 5 | 1440 | `1cc6b02e6c84` | 2.0 | quiet |
| 2017-08-21 | 5 | 1440 | `1d94e38b4b4d` | 3.0 | quiet |
| 2017-08-28 | 5 | 1440 | `7c195648907e` | 0.7 | quiet |
| 2023-09-17 | 4 | 1152 | `37f0b808236e` | 3.3 | quiet |
| 2023-09-30 | 4 | 1152 | `86df55f9289f` | 2.3 | quiet |
| 2023-10-02 | 4 | 1152 | `aa254ad157b2` | 3.0 | quiet |
| 2023-10-07 | 4 | 1152 | `11079644ae38` | 1.7 | quiet |
| 2023-10-14 | 4 | 1152 | `a5cc83d231c8` | 3.0 | quiet |
| 2023-10-21 | 4 | 1152 | `9cd98d7d699c` | 5.0 | DISTURBED |
| 2024-03-12 | 7 | 2016 | `881948be8b56` | 2.3 | quiet |
| 2024-04-01 | 7 | 2016 | `3c4eb2649f94` | 3.7 | quiet |
| 2024-04-08 | 7 | 2014 | `7f36c28f7ab6` | 3.3 | quiet |
| 2024-04-15 | 7 | 2016 | `d09d2dcafe16` | 2.7 | quiet |
| 2024-05-10 | 7 | 2013 | `eb16ca1b2801` | 8.7 | DISTURBED |
| 2024-05-11 | 7 | 2012 | `dc0c9c4b4a4c` | 9.0 | DISTURBED |

*One Madrigal world-file scan per day, sliced per station locally; SHA-256 over the raw fetched bytes. Generated from `helio_ingest_provenance` + ledger Kp.*
<!-- GAIA:END ingest-ledger -->

## Quantization registry (the single float→int crossing)

| Quantity | Unit stored | Scale | Where it comes from |
|---|---|---|---|
| `vtec` | milliTECU | ×1000 | Madrigal gridded TEC (lower-median fold per second across grid cells) |
| `kp` | Kp tenths | ×10 | GFZ definitive/nowcast |
| `kp_est` | Kp hundredths | ×100 | SWPC 1-minute nowcast |
| `mag_h` | milli-nT | ×1000 | USGS observatory H |
| `isr_ne` | 10⁹ m⁻³ | ÷10⁹ | Millstone Hill ISR (Stage-4) |
| obscuration | ppm of disk area | ×10⁶ | substrate Besselian calculator |
| contacts | whole seconds UT | — | substrate Besselian calculator |

Round-half-even, `IngestQuantizer` is the only crossing, non-finite values stay absent (never a fake zero), and nothing downstream of the store ever touches a float (Constraints 3/5).
