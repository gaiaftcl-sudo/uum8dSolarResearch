# Study 22 — The ground state is a coordinate, not a vibe

**Status: LIVE ON GLAMA — fixture locked 2026-08-26**  
**Program:** [Shear Studies Index](Shear-Studies-Index) · [Math Court on Glama](Affine-Math-Court-Glama) · [Zero Float · Zero Shear](Zero-Float-Zero-Shear-Paradigm)

Call it today: `execute_2local_hamiltonian` at `https://affine.earth/language-invariant/mcp`  
Or walk the whole court: `clients/math-court-mcp`

---

The 2-local Hamiltonian is the bedrock QMA-complete problem — quantum k-SAT. IonQ-class machines and every VQE notebook treat it as a continuous energy landscape. They rotate analog qubits with a floating-point gradient and publish a *statistical* ground energy. The rotation drifts. The answer is an average. There is no coordinate you can replay tomorrow and get the same bits.

Affine.Earth does not anneal that landscape. A 2-qubit projector is a **spatial exclusion zone** on the Eisenstein lattice. The presented spin string either sits outside every exclusion or it is blocked. The energy is an exact rational `num/den`.

**The public example locked it.** The Glama client posted `constraints=0,1,1,1` and `config=0,1` as decimal strings. The nine cells returned energy **−1/1** and `AFFINE_QMA_2LOCAL`. Same payload through `math_court` domain `qma_2local`. A JSON float on that wire is refused — VQE’s native language cannot enter the court.

The presented configuration is verified. Unknown grounds are not searched. That is still the shear: the adversary is the continuous \(e^{-iHt}\) story, and it has no string to show.

## Frozen law

| Symbol | Rule |
|---|---|
| `z = 1−2s` | computational bit → discrete direction |
| `E = Σ (J_num/J_den) z_i z_j` | exact rational |
| WIN | fixture energy `−1/1` and no exclusion |
| MISS | aligned config, or energy ≠ sealed ground |
| REFUSED | IEEE token (`.` or `e`) on the wire |

## Falsifiers

| Falsifier | Effect |
|---|---|
| Fixture config energy ≠ −1/1 | Primary MISS |
| Float payload admitted | Court is broken |
