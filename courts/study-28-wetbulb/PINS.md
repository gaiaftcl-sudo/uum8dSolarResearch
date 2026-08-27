# Study 28 — Act 1 corpus pins (fetched and receipted 2026-08-27)

Source: `https://noaa-global-hourly-pds.s3.amazonaws.com/2025/<station>.csv` (mirror of
`https://www.ncei.noaa.gov/data/global-hourly/access/2025/`). Anyone with curl reproduces
the corpus byte-exact from these receipts or the seal does not stand.

| Station | Bytes | S3 Last-Modified |
|---|---|---|
| 47152099999 | 1906289 | Sat, 04 Oct 2025 13:28:53 GMT |
| 47153099999 | 2224690 | Sat, 04 Oct 2025 13:33:40 GMT |
| 41217099999 | 2602046 | Sat, 04 Oct 2025 13:32:04 GMT |
| 41715099999 | 673693  | Sat, 04 Oct 2025 13:30:52 GMT |
| 41184099999 | 2330979 | Sat, 04 Oct 2025 13:26:43 GMT |
| 41024099999 | 2466290 | Sat, 04 Oct 2025 13:29:12 GMT |
| 41150099999 | 2518015 | Sat, 04 Oct 2025 13:33:53 GMT |
| 47138099999 | 1943227 | Sat, 04 Oct 2025 13:33:02 GMT |
| 47165099999 | 1968665 | Sat, 04 Oct 2025 13:30:12 GMT |

WMO-No. 8 (2024 edition, Volume I) PDF sha256:
`4f020a5970bb3fca44f61df3ae63f6c02a74b6b60cfd6951b49aa520b1c94187`
(psychrometer pair frozen from Annex 4.B formula 4.B.8, read verbatim).

Build and replay:

```bash
swiftc -O -o study28-court study28-court.swift
./study28-court
```

The engine expects the nine CSVs in the directory named at the top of the source.
libm identity of the sealed run: Apple libSystem, macOS Version 27.0 (Build 26A5416b).
