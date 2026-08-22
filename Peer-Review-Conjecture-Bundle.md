# Peer-Review Conjecture Bundle — sanitized proof payload

**Status: LOCKED — 2026-08-22**  
**Client / server demarcation:** this tree is the public face. Execution cells stay black-boxed.

Studies 11–13 are sealed as **WIN**. This page names the wins, what they mean, and the files a reviewer can re-run without any orchestration source.

---

## The three WINs

| Study | Sealed score | What the proof means |
|---|---|---|
| **11 Ehrhart volume** | **5/5 WIN** · **5/5** float MISS | Volume is \(\Delta^d h(0)/d!\) from integer dilation counts. A float integral at \(t=12\) is the wrong number on every polytope. |
| **12 Parallel repetition** | **4/4 WIN** · **4/4** float MISS | CHSH’s classical ceiling \(3/4\) multiplies as \((3/4)^n\). Discrete transitions equal that bound. A float amplitude \(751/1000\) never does. |
| **13 Connes rigidity** | **5/5 WIN** · **5/5** float MISS | Group words walk the Eisenstein lattice. Relators fold different spellings onto one linking \((q,r)\). A float spectral proxy is offset by one. |

Reproduce:

```bash
python3 corpus/study-11/study11_grade.py
python3 corpus/study-12/study12_grade.py
python3 corpus/study-13/study13_grade.py
python3 corpus/peer-review-conjecture/export_peer_review_bundle.py
```

Expected: three `primary_win == primary_total` summaries, then a SHA256d digest written to `proofs/payload_double_sha256.hash`.

---

## What is in the bundle (and what is not)

**In:** integer geometries, transition maps, SQLite DDL/DML of the finals, scrubbed stream archives, the zero-float trap list, a sample integer-lane trace, the SHA256d lock.

**Not in:** Swift 6.4 operational source, KVM routing, AArch64 SIMD kernels, node IPs, worker IDs, cluster headers, connection pools.

```text
corpus/peer-review-conjecture/
  schemas/
    ehrhart_polytope_boundary.json      # Bounded integer geometries
    vqbit_bipartite_transition.json     # Discrete CHSH state maps
    affine_persistence_schema.sql       # 8D manifold DDL
    affine_persistence_dml.sql          # Aggregated coefficients / finals
  telemetry/
    sharding_stream_archive.dat         # Scrubbed Ehrhart shard payloads
    entanglement_state_archive.dat      # Scrubbed vQbit round payloads
  proofs/
    zero_float_compiler_manifest.txt    # Seal-path trap configuration
    aarch64_simd_trace_sample.log       # Integer-lane trace (no ISA dump)
    payload_double_sha256.hash          # SHA256d lock
```

---

## How to read a WIN

A **WIN** is not a slogan. It is two integers agreeing and a third integer refusing:

1. **Primary:** the discrete law matches the sealed reference (Ehrhart polynomial / \((3/4)^n\) / rigid linking class).
2. **Adversary MISS:** the continuous proxy reports a different number. If it ever matched, the shear would be gone and the law would have to be re-derived.

That is the same grammar as Studies 06 and 07: the true appointment keeps the clock; the look-alike matches size and fails shape.

---

## Integrity

The lock file is **SHA256d** — SHA256 of SHA256 of a canonical concatenation of every payload file (path + bytes, sorted). Re-run the exporter; the digest must match `proofs/payload_double_sha256.hash`.

```
digest: 9921436ca7e15481d2f7246db6038c2cb434e41e94b38d9f3e0de3ddb6ef69b5
files: 8
algorithm: SHA256(SHA256(canonical-concat))
```

Note: the lock file itself is not inside the concat. Re-running the exporter after an edit changes the digest; that is the point.

Results pages:

- [Study 11 Results](Study-11-Ehrhart-Volume-Results)
- [Study 12 Results](Study-12-Quantum-Parallel-Repetition-Results)
- [Study 13 Results](Study-13-Connes-Rigidity-Results)
- [Conjecture alignment](Conjecture-Alignment-UUM8D)
