# Fusion researcher's guide — build it, run it, and try to break it

**Page class: GUIDE.** This is the "check us, don't trust us" page for [Affine Fusion Control](Affine-Fusion-Control). Every claim on the study page is re-derivable from these commands. No account, no key, no network. If a check fails, that is the issue we want — tell us.

## What you need

- A Mac with **Swift 6.4** (macOS 26+). `swift --version` should report 6.4.
- Nothing else. No Python, no Node, no package manager, no GPU toolchain — the Metal library is checked in pre-compiled, and the build never invokes the Metal compiler. (A machine with no GPU still runs everything except the GPU-parity arm, which skips and says so.)

## Get it

```bash
git clone https://github.com/gaiaftcl-sudo/uum8dSolarResearch.git
cd uum8dSolarResearch/app/FusionCourt
swift build -c release          # ~10 s cold, zero warnings
swift test                      # 27 tests across 4 suites
```

A clean build with **zero warnings** and a green test run is the first thing to confirm. If either fails, stop and tell us — it should not.

## Run the app

```bash
.build/release/FusionCourt      # opens the four-panel court on 65,536 agents at 1 kHz
```

You should see the verdict wall discriminating across four terminals, a live cadence histogram, and a channel scope. Every number in the panels is read from a published snapshot — **the UI computes nothing it displays.** (Launched as a bare binary it runs but may not open a window; the study page shows how to wrap it in a `.app` bundle if your window server needs one.)

## Re-derive each claim on the study page

| claim | command | what it proves |
|---|---|---|
| the clock holds 1 kHz | `.build/release/FusionCourt --selftest-clock` | 9,999 ticks in 10 s, **0 skipped, 0 gaps**; a deliberate overrun is *recorded*, never hidden |
| the lattice is Int128 | `.build/release/FusionCourt --selftest-lattice` | 128-bit axis, 6 ingest lanes, the Int64 headroom factor |
| cold start is under budget | `.build/release/FusionCourt --selftest-coldstart` | exec-to-exit well under 250 ms, measured by the app's own clock — no python, no external timer |
| the GPU crossover | `.build/release/FusionCourt --selftest-crossover` | CPU vs GPU at 4k–1M, **bit-exact parity** at each N, and the CPU wins throughout |
| all five court terminals reachable | run `reproduce/fusion-operating-court.swift` | `COURT TERMINALS REACHED: 5 of 5` |
| topology-agnosticism | run `reproduce/fusion-topology-agnostic.swift` | byte-identical verdicts across three topologies; spheromak has 0 toroidal edges |

To run a `reproduce/` script (it links the law in automatically):

```bash
cd ../..            # back to repo root
bash reproduce/validate.sh    # 131 checks; every published figure re-derived from source
```

## The gates — the instrument checks its own honesty

Each gate refuses in both directions (fires on a planted violation, stays silent on a legitimate case). Run any with `--self-test`:

```bash
cd app/FusionCourt
bash Tools/one-law-one-home.sh          # the law's constants exist in exactly one file
bash Tools/no-float-outside-render.sh   # 5 exact-integer targets carry no float
bash Tools/law-compiles-both-modes.sh   # the law compiles under Swift 5 AND 6
bash Tools/swift-only.sh                # no python/node/ruby invoked anywhere
```

## What to attack — this is the useful part

The study earns its credibility by being falsifiable. The sharpest places to push:

1. **The bit-parity claim.** `FusionGPUTests` asserts the GPU verdict equals the CPU golden bit-for-bit across a corpus reaching ≥3 terminals. Feed it a trace that makes them disagree and you have found a real bug.
2. **`incremental == batch`.** The streaming law and the batch law must agree for every sample index. This test already caught one precedence inversion (64 of 64 agents disagreed). Find a second.
3. **The refusal terminals.** Construct an input that *should* refuse but returns a verdict, or vice versa. `REFUSED_MALFORMED` must dominate `REFUSED_OUT_OF_ENVELOPE` (not-admissible-data beats admissible-data-out-of-range); show a case where it doesn't.
4. **The π-bracket.** We found one operating point (ne=27057, Ip=400 kA, a=2000 mm) that sits on the Greenwald limit to within π itself. Find another, or show the bracket resolves wrongly when a π is declared.
5. **The crossover.** Our measurement says the GPU never wins to 1M agents. If you can make the GPU win with a *fair* benchmark — same flat input both sides, same law, no per-agent allocation on the CPU arm — that is a genuine result and we want it. (Two of our own first attempts flattered the GPU with a broken CPU arm; the account is in `CROSSOVER.md`, so you know exactly which mistakes not to repeat.)

## What this is not

It grades **presented** telemetry and **presented** operating points. It is **not** wired to a reactor and holds **no** real machine data. The thresholds are frozen for demonstration and a real deployment re-freezes them against its own device. The architecture — exact, re-derivable, refusing where it has no answer — is the claim; the specific numbers are illustrative and dated. See the limits section of [the study](Affine-Fusion-Control).

---

**Related:** [Affine Fusion Control](Affine-Fusion-Control) · [Study 33](Study-33-Fusion-Control-Verdict-Court) · [The ontology](Ontology)
