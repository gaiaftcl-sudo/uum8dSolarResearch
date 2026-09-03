# The GPU crossover — measured, and the two instruments that lied first

**Question:** on this branchy, no-multiply, exact-integer verdict law, at what agent
count does a Metal round-trip beat 12 CPU cores? **Answer, measured on an M4 Max
(40 GPU cores):** it does not, up to one million agents. The CPU is ~2× faster at
every scale, and the GPU is **bit-for-bit correct** the whole way — its loss is a
speed result, never a correctness one.

Run it yourself: `swift build -c release && .build/release/FusionCourt --selftest-crossover`

| N | CPU (12 core) | GPU (round-trip) | parity | winner |
|---|---|---|---|---|
| 4,096 | 232 µs | 1,037 µs | BIT-EXACT | CPU |
| 16,384 | 541 µs | 1,641 µs | BIT-EXACT | CPU |
| 65,536 | 1,966 µs | 4,349 µs | BIT-EXACT | CPU |
| 262,144 | 7,479 µs | 15,072 µs | BIT-EXACT | CPU |
| 1,048,576 | 29,301 µs | 58,969 µs | BIT-EXACT | CPU |

Why: a kernel launch is a fixed ~1 ms of encode + dispatch + read-back, and the law
is `abs`, subtract, compare and a run counter — no multiply, no divide, nothing a
GPU's float lanes accelerate. Twelve CPU cores doing the identical integer work pay
no launch and win. This is the founder's call ("we needed it for floating point but
we are not that now"), measured rather than asserted.

## The two measurements that lied first — kept, because they are the reason to trust the third

**Run 1 said the GPU wins everywhere.** It was wrong: the CPU arm transposed the
data column-by-column with a fresh allocation per sample and was charged **72 ms at
65,536 agents against the law's real 128 µs** — 560× the law's cost, all of it
allocation the GPU never paid because it got the flat layout for free. The tell was
that 72 ms vs 128 µs gap. A broken benchmark that flattered the GPU.

**Run 2 said the crossover was 16k.** Still wrong: the CPU arm allocated a fresh
`[Int32]` per agent to widen the Int16 window. Fixed by widening into **one reused
scratch buffer per slab** (12 total, not N) — and refusing to add an Int16 overload
of the law, which would have re-forked the exact logic a prior phase spent itself
merging.

**Run 3 is apples-to-apples:** same flat input both sides, the single law fed
bit-exactly, no per-agent allocation. GPU never wins. Two of three runs flattered
the GPU; only the instrument-corrected one is the result.

Parity is enforced as a build-time test (`FusionGPUTests`), not just measured here —
the GPU verdict must equal the CPU golden bit-for-bit across a corpus that reaches
at least three terminals, or the build fails.
