# Affine.Earth MCP — User Guide

**Endpoint:** `https://affine.earth/language-invariant/mcp` · streamable HTTP · JSON-RPC 2.0 · **49 tools** (measured 2026-09-02 per cell on all nine)
No key. No account. No rate card. Served by nine cells behind one apex.

Canonical full text, served on the apex:
[Affine-Earth-MCP-User-Guide.md](https://affine.earth/language-game/press/wiki/Affine-Earth-MCP-User-Guide.md)

---

## Bind it in one call

```bash
curl -sS -X POST https://affine.earth/language-invariant/mcp \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

Measured 2026-09-02: HTTP 200, **49 tools**, identical on all nine A records with SNI pinned per
cell — nine correct answers through a load balancer would not prove nine correct cells, so the guide
checks each one.

## What it is

Nine surfaces over one substrate: exact-integer courts that rule on a claim and name what they
cannot decide. Verdicts are `CALORIE_*` on a win, a named `*_DIVERGED` or `MISS` on a loss,
`NOT_KNOWN` when nothing is decidable, and `REFUSED_*` when the request was malformed. Those four
are held apart deliberately — **absence and refusal are different answers**, and a court that
collapses them tells a caller their claim failed when in fact it was never examined.

Zero floats anywhere: `BigInt`, `RationalQ`, `Int64Rational` and micro-unit integers only. Two cells
replaying one proof on different libm versions would otherwise reach different answers, and
consensus across the nine is the property the whole substrate rests on.

## Related

- [Court Client — the generic wasm IDE for every court](Affine-Court-Client-Template)
- [Shear studies replayed through the Court Client — the checkpoint](Shear-Studies-Court-Client-Checkpoint)
- [Coding Court — the verdict IS the artifact](Affine-Coding-Court-Architecture)
- [Math Court — live on Glama](Affine-Math-Court-Glama)
- [Shear Studies Index](Shear-Studies-Index)
