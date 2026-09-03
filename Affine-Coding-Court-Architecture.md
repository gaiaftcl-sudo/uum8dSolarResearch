# The Affine Coding Court — the verdict IS the artifact

Not a grade about code. The finished, runnable thing — or a named reason you do not have one.

Canonical full text, served on the apex:
[Affine-Coding-Court-Architecture.md](https://affine.earth/language-game/press/wiki/Affine-Coding-Court-Architecture.md)

LIVE on the apex, measured per cell 2026-09-02: `execute_artifact_crucible` is the 49th tool on all nine A records; a posted 4,946-byte wasm module came back rung 7 as a `wasm.module` resource, byte-exact. The page that loads and runs what it returns: [Court Client](Affine-Court-Client-Template).

---

## Why it exists

The previous coding court was graded over 75 turns against a real problem:

> **PASS as an IR grader. FAIL as a coding-agent court. Dest sats 0. The court never returned a file
> we compile.**

Every one of those calls was correct on its own terms — it compared LLVM IR constant multisets and
said whether they matched, faithfully, 75 times. **And nothing in its output said it had not done the
job.** One success marker could not distinguish *"these constant pools are identical"* from *"here is
the artifact you asked for"*, and no field existed that a caller could have checked to learn the
difference.

`emit_source`, `code_cite` and `code_compile` all answered `-32601`. `code_ir_equiv` with a
`left_file` answered `REFUSED_MISSING_ARG`. The court could not be *asked* for source, and refused
the only argument shape that would have carried a file.

## The shape

```
ARTIFACT INGESTION BRIEF ─▶ parse, refuse by name ─▶ rule on a LADDER ─▶ seal, digest-verified
```

A brief is four sections and twelve fields. Each field removes a degree of freedom the artifact would
otherwise inherit — an unstated memory binding is one the agent chooses. The brief is not paperwork;
it is the entropy removed *before* generation rather than detected after.

The verdict is a ladder, not a coin. `CALORIE_AFFINE_ARTIFACT_DELIVERED` at the top;
`ARTIFACT_ASSEMBLED_NOT_DELIVERED`, `ARTIFACT_WIN_UNVERIFIABLE`, `ARTIFACT_PROTOCOL_CONTRADICTED`,
`ARTIFACT_TARGET_ABSENT`, `ARTIFACT_LAW_BROKEN`, `NOT_KNOWN` and `REFUSED_*` below it. Collapsing
five states into one MISS is exactly what made the previous court useless.

## Unverified is never a win

A posted module needs no compiling, so the *toolchain* ceiling genuinely does not apply to it — and
from that it is one short step to concluding the rung is the top one. It is not. **Sealing bytes and
satisfying the win condition are different claims**, and receiving the bytes establishes only the
first.

The sealed rung is therefore the **lower** of the two: a ceiling that does not apply is lifted, every
other reason the judgment fell short still binds. The artifact is still returned — refusing to hand
back a valid module because its brief names something the court cannot see would punish the caller
for the brief's defect — but the verdict says plainly that the win was not verified here.

Getting this backwards turns *"I could not check"* into *"you passed"*, which is precisely what the
75-turn game consisted of.

## A win condition can be measurable and still undecidable here

Two different defects, and conflating them keeps the second one hidden:

| clause | who can measure it | brief needs |
|---|---|---|
| "completes in a single CPU cycle" | **no one** | a **rewrite** |
| "dest sats greater than zero after sendraw" | a block explorer, **not this court** | a **split** |

The court has no chain access, no wallet and no broadcast path. A brief whose exit clause ends there
caps at `ARTIFACT_WIN_UNVERIFIABLE` **by construction, and no rewrite of the artifact can raise it**.
That ceiling is the court being honest. The repair is to split the brief into the half the court can
decide and the half that needs evidence from elsewhere — which is what
`BONDED-PAYABLE-VERIFY-BRIEF.txt` is, and why it sits beside the whole-game brief rather than
replacing it.

## The lesson the court learned on itself

The first delivered module was to prove a safeguard: *"those three dests and the 2009 corpus."* Its
verdict line was `corpus.opened && corpus.bytes > 0 && dests.count == 3` — a **file-existence check
wearing a safeguard's name**. Measured, it passed on three fabricated dests, and again on a 28-byte
file standing in for 4.3 MB.

The discrimination arm meant to catch that withheld a preopened directory and watched the verdict
flip. **That proves `open()` is load-bearing and nothing more.** Content was never load-bearing, and
no arm that removes a file can discover it.

> **An arm must vary the thing the claim is about.** This one varied *availability* while the claim
> was about *identity*.

The replacement verifies the three dests byte-exact **and in order** (the manifest binds `row % 3` to
payout / cell / fidelity, so a permutation pays the right amounts to the wrong places), every one of
21,953 rows rather than a sample, the row/byte identity `4 + 21953×196 = 4,302,792`, and a digest
over every byte. Eight arms, including one hex character altered inside an otherwise byte-identical
corpus — the only arm the digest is needed for, and the one that separates *"verifies the corpus"*
from *"verifies the corpus has the right shape"*.

The digest routine checks itself against published vectors before the corpus is read, and its
expected constant comes from a **separate** program — a constant read back from the artifact's own
output would be true by construction.

## Master of things affine

It enforces the Constraints **whether or not a brief declared them** — a brief that forgets to ban
floats does not get floats certified. Constraint 3 (zero floats), Constraint 4 (no stubs),
Constraint 5 (determinism) and LAW 4/9 (no classical search) are not preferences a brief may decline;
they are the conditions under which nine cells agree at all.

Scoped honestly: these are source-text detectors, blind to implicit ARC boxing and copy-on-write. A
clean result reads *"nothing detectable"*, never *"proven compliant"*.

## Status

**95 tests, 0 failures, 0 skipped** — re-measured 2026-09-01 with
`swift test --filter 'Court|Crucible|Judgment'` in the substrate checkout, so the number is reproducible
rather than remembered. Per suite: crucible 30, judgment 21, brief 11, whole-file 16, IR-equiv 7,
reach 5, classical-vs-affine 4, MCP JSON-RPC 1. Both arms of every detector.

The count is stated with its filter because the previous figure here — 119 — had no command attached
and could not be checked against anything. The skip count is reported alongside it for the same
reason: this suite once printed *"23 tests, 1 skipped, 0 failures"* while the one test proving the
acceptance criterion never executed, and a skip that hides a path bug reads as a decision.

The full page holds *proven*, *measured*,
*committed-but-not-serving* and *not-claimed* strictly apart — including the two defects found in
this court itself, because those teach more than the design does.

## Related

- [Affine.Earth MCP — User Guide](Affine-Earth-MCP-User-Guide)
- [Math Court — live on Glama](Affine-Math-Court-Glama)
