# Study 32 corpus — European taxi-out, exact integer minutes

**Source:** EUROCONTROL PRC Data Challenge 2024 dataset, openly archived at 4TU.ResearchData
(doi:10.4121/8CB8484B-DBE7-4750-8B87-A5B1DBC621B4), licence **CC BY 4.0**, fetched anonymously 2026-09-01.

- `flight_list.csv` — 101,091,663 bytes, sha256
  `bd30540049d6f8afd6804eb30ff58d76b3351d361930f25cac8fbf3c27185fc1` — exceeds the repository's
  file limit, so it is pinned here by digest and URL
  (`https://data.4tu.nl/file/8cb8484b-dbe7-4750-8b87-a5b1dbc621b4/2bfbef1a-a75b-4045-a46e-3325bf363c27`)
  rather than committed. 527,162 flight rows, calendar 2022, `taxiout_time` published in
  **integer minutes**.
- `taxiout.csv` — committed. Derived by `reproduce/taxiout-extract.swift` (published): columns
  `adep,hour_utc,taxi_min`, all exact integers. **525,541 rows admitted, 1,621 refused**
  (absent or non-integer fields — counted, never silently dropped).

**The 2026 challenge archive** (`ansperformance.eu/study/data-challenge/dc2026`) was measured the
same day: monthly parquet movement files (~20 MB each) behind `s3.opensky-network.org`, and every
anonymous bucket probe returned **403 — access keys are issued on challenge registration**. This
programme does not create accounts, so the 2026 corpus is **ARCHIVE GATED, NOT ABSENT** — Act 2
runs when a registered participant supplies the files, and the frozen law does not change.
