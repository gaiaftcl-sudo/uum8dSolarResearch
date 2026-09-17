# No language model in this stack

**This page has no board row, no lifecycle status and no closing verdict, for the same reason the
three libraries have none.** It does not instantiate the shear recipe — there is no sky forcing, no
clock and no track, so there is nothing here to seal against a frozen law. What it has instead is a
pair of gates, each with control arms, and a measurement you can re-run.

It is here because every other page on this wiki rests on it. A board that says its answers are
exact integers a stranger can re-derive is making a claim about the machines it is served from, and
until 2026-09-12 that claim had a hole in it: one process in the substrate could call a model API,
and one cell had been running a local model server since August.

Founder, 2026-09-12: *"yes strip the gym proxy from the roll script we do not connect to any llm in
the stact we get facts for raw vector files."* And, the same day: *"validate those are old and not
used. and also get rid on any bridge to an llm in any of my servers. the fact they are suposes to be
cattle not pets bothers me."*

Both halves of that instruction are done, and the second half is the one this page spends most of its
words on, because *validate those are old and not used* is the part that could have been skipped
quietly.

## What was there, and what it was for

| | |
|---|---|
| the outbound bridge | `GymUpstreamAdapter.swift`, **317 lines** — the substrate's only code path that built a request to a model API host. It listened on `:9333`, translated one request shape into another, and read a key file the founder had placed on the cell |
| how it was reached | the membrane's gym leg, pointed at it by an environment variable the roll script set |
| how it kept coming back | the roll script shipped its unit and **started it before the membrane on every roll**. It was disabled by hand nine times. Measured 2026-09-11: a roll had left it **active on 8 of 9 cells** |
| the local model server | on one cell, a `llama-server` process on a **9.8 GB** quantised model directory, bound to `127.0.0.1:8091`, with a `socat` bridge onto the docker gateway. Running since **23 August**. Its bridge unit's own comment names its only consumer: the Python language-inject sidecar the Swift membrane retired |

## Validated unused before it was touched

This is the part that matters, and it is the part a reader should be most sceptical of, so here is
the evidence rather than the conclusion. Measured on the cell, before anything was stopped:

| what was checked | what it read |
|---|---|
| CPU time consumed since it started | **167 seconds in 19.9 days** |
| its journal | **zero entries** |
| established connections to its port | **none** |
| the model file's access time | **still the second it was loaded**, 23 August — nothing had read the weights since |
| what the bridge was built for | a Python sidecar that no longer exists in the tree |

A process with 167 seconds of CPU across three weeks, no log lines and an untouched model file was
not serving anything. **REPORTED** — the figures above are the cell's own accounting, read once,
before removal; a second reading is not possible now that the thing is gone, which is a limit of
this page and is stated rather than hidden.

## What was removed, and what came back

The adapter, its systemd unit, its installer script and its command-line subcommand are deleted from
the source. The subcommand's slot now prints `REMOVED` and exits non-zero, so a stale unit invoking
it fails loudly instead of silently doing nothing. The membrane is no longer pointed at any upstream,
so its gym leg answers with a named refusal — `gym_upstream_unconfigured` — rather than opening a
connection.

On the cells: both model units stopped, deleted and masked; the `socat` bridge gone; **53** runtime
files of the model server removed; the **9.8 GB** model directory removed. That returned **8.5 GB of
RAM and 10 GB of disk** to the cell and made its model directory identical to its eight peers'.

The roll script no longer installs the unit. It now stops it, **deletes the file, then masks it**,
and refuses to continue if the unit is afterwards active or unmasked.

## Two traps, written down because both cost a measurement

**Delete first, mask second.** `systemctl mask` writes its own symlink at the unit's path. Masking
and *then* deleting the file at that path removes the mask you just installed. Done in the wrong
order, nine cells reported `not-found` where the intended state was `masked` — and `not-found` is
exactly what a cell says when a unit is merely absent and free to be re-installed by the next roll.
Done in the right order, all nine read `masked`, with the link pointing at `/dev/null`.

**A probe whose pattern matches its own command line lies.** An unbracketed process search for
`llama|vllm|ollama` reported **two model processes on every cell in the fleet**. Both were the probe:
the search string appeared in the remote command line the search was running inside. The gate now
matches on the exact process name, and its pattern is bracketed so it cannot match itself. This is
the same defect, in a different costume, as a waiter that waits forever because it is waiting for
itself.

## The two gates, and why each has control arms

An instrument that is always green and an instrument that is always red are the same defect: neither
carries information. So both gates below are run in both directions, and the arms that must refuse
are listed with them.

| gate | what it refuses | control arms |
|---|---|---|
| `no-llm-upstream-in-the-stack.sh` | the adapter, its unit or its installer returning; any Swift or shell line that builds a request to a model API host; the roll script shipping or starting the unit again; the membrane being re-pointed at an upstream | a planted adapter file, a planted request line, a roll script with the mask removed, and a membrane pointed at a host — each must refuse, and does |
| `cells-are-cattle-not-pets.sh` | any of five readings disagreeing across the cells that answer, and the model-bridge reading being anything but zero even when every cell agrees | a differing cell binary, **one** cell running a model server, **every** cell running one, and an empty fleet — the last because a gate handed nothing must not pass |

The first gate's second arm initially failed on its own fixture: the file carried the literal host
string it refuses, so it flagged itself. The fixture is now assembled from pieces at run time. **A
gate whose source contains the thing it forbids will refuse its own source**, and that is worth
knowing before writing the next one.

## The fleet, graded on agreement

There is no golden image to compare a cell against — the cells are built by rolls, not stamped from
a master — so the only available truth is that they agree with each other. A gate that refuses when
eight agree and one does not names the odd cell without needing a manifest of what is correct.

Measured per cell on 2026-09-12, never through the apex that fronts them:

| category | reading |
|---|---|
| cell binary | **unanimous** — one digest across the nine |
| model bridge: processes, ports, unmasked units | **unanimous and zero** — `procs:0 ports:0 units:0` |
| forbidden runtimes under the cell's own bin directory (Python, Node, model runtime) | **unanimous, 0** — it was 2 on seven cells and 4 on the ninth before the sweep |
| the models directory | **unanimous** |
| the cell bin file list | **unanimous** |
| enabled service units | **two values — not unanimous, and named below** |

## The one that does not agree, published at the same weight

`gaiaftcl-treasury-settle.service` is enabled and **active on two of the nine cells**, started three
minutes apart. Its own unit description reads *"Swift, durable pull, one payer"*.

Whether that is a defect depends on where its exclusivity comes from, and this page does not know: if
one payer is enforced by the durable consumer, two running instances are harmless because the broker
hands each message to exactly one of them; if it is enforced by being the only enabled unit, then
there are two payers. **NOT KNOWN**, and left running rather than stopped, because it is settlement
rather than debris and stopping a payer to make a gate green is the wrong trade. It is the founder's
call.

One further disagreement, separate and also open: one cell is not listening on the port the other
eight answer on for the mesh broker. That is a question about that cell's broker surface, not about
models, and it is named here so the "unanimous" rows above are not read as "everything agrees".

## No GPU either

Measured per cell, 2026-09-12, on all nine: **aarch64 ARM Neoverse-N1**, and **0 of 9** carry a GPU
driver, a GPU device node, or a CUDA, ROCm or OpenCL runtime. The serving path is CPU integer
arithmetic end to end. There is no accelerator on these machines to dispatch to, and nothing in the
path that would ask for one.

That is a statement about the nine production cells, not about the Mac the substrate is built on —
the build host is a different question from the serving path.

## No float, and this one you can check from a terminal

The programme's oldest rule is that no verdict may depend on a rounding. On the public court that is
enforced at the door rather than asserted in prose: **every numeric input in all 51 published tools
is a decimal string, not a number**, so the wire carries no floating-point type to put a float into.

Measured live on 2026-09-12, three calls to the same tool — the middle two are the control arms:

| what was posted | what came back |
|---|---|
| `A = "1,2,3,4,5,6,7,8\|1"` — integers as decimal strings | `CALORIE` · `AFFINE_JZ_OP` · result `2,3,4,5,6,7,8,9\|1` |
| `A = "1.5,2,3,4,5,6,7,8\|1"` — one value carrying a decimal point | `REFUSED` · `AFFINE_JZ_PARSE` · result empty |
| `A = 1.5` — a JSON float rather than a decimal string | `REFUSED` · `AFFINE_JZ_PARSE` · result empty |

An instrument that accepted everything and an instrument that refused everything would be equally
useless. This one answers the integer and refuses the float, and names which it did.

The source side is held by four gates, all green at the commit this page was written from, each run
here and quoted as it printed:

| gate | what it printed |
|---|---|
| float literals in the substrate paths | `clean (0 violations, 0 code lines suppressed, 4 comments exempted)` |
| float **types** — a ratchet that may only fall | `The ceiling is ZERO: the substrate path holds no float-typed declaration, and the next one to appear fails this gate on the commit that adds it.` |
| floats in the Rust client shell | `NO_FLOATS_IN_RUST_CLIENT_CLEAN` |
| floating-point instructions in the bare-metal OS image | `NO_FPU_GATE=CLOSED arch=aarch64 boot=absent` |

**And the limitation of that kind of gate is on the record rather than left to be found.** A source
scan reads zero when the spelling it matches is not the spelling in use — which is how 141
float-typed declarations once lived inside a path whose gate reported none, because the gate matched
float *literals* and the declarations were bare types. That history is written into the repository's
own constraints file for exactly this reason. It is why the wire measurement leads this section:
a court that refuses the value at the door cannot be blind to how the value was spelled upstream.

## What replaced it

Facts come from raw vector files through an exact court. The board's translation is the worked
example: each cell derives a per-language coordinate chart in memory at every start, from the raw
rows of a pinned public weight file read by byte range and digest-checked, quantised onto an integer
lattice and ordered by an exact 256-bit integer comparison — and it refuses, by name, every word it
cannot carry. There is no model in that loop and nothing written to disk.
**→ [Study 47 — translation shear](Study-47-Translation-Shear)**

## What this page does not claim

- **It does not claim no model was used to write any of this code.** Agents wrote much of this
  substrate, under the founder's direction, and the commit history says so. The claim is about the
  serving path, not about authorship.
- **It does not claim model weights are absent from every machine the founder owns.** It claims that
  no cell serving this board runs a model process, opens a model port, or holds an unmasked model
  unit, and that no code in the substrate builds a request to a model API host.
- **It does not claim a model is a bad instrument.** It claims a verdict that changes when you run it
  again is not a verdict, and that every claim on this board must be re-derivable by a stranger from
  public bytes. A sampled answer cannot meet that bar; an exact one can. That reading is **ARGUMENT**;
  the rows above are the measurement.
- **It does not claim the removal was free of risk.** It was validated unused on the evidence in the
  table above, and that evidence can no longer be re-read.

## Reproduce

Two of these need the fleet's ssh keys and so are the founder's to run; the rest anyone can run
against a clone of the substrate repository.

```bash
# anyone: the source-side gate, and its control arms
bash no-llm-upstream-in-the-stack.sh
bash no-llm-upstream-in-the-stack.sh --self-test

# anyone: the fleet gate's control arms fire on fixtures, not on cells
bash cells-are-cattle-not-pets.sh --self-test

# the founder, or anyone holding the cell keys: the live per-cell sweeps
bash no-llm-upstream-in-the-stack.sh --fleet
bash cells-are-cattle-not-pets.sh --verbose
```

And the thing the removal was in service of, which needs nothing but a terminal — the court answering
in public, rendering what it can project and naming what it cannot:

```bash
curl -s -X POST https://affine.earth/language-invariant/mcp \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"affine_translate_text",
       "arguments":{"source_lang":"en","target_lang":"es","texts":["book","water"]}}}'
```

Measured 2026-09-12: `book` returns `libro` under `chart:1`, and `water` is withheld as
`REFUSED_SHARED:1 of 1:water→agua(pt)` — the court names the third language whose spelling it
collides with rather than guessing which language it is looking at.
