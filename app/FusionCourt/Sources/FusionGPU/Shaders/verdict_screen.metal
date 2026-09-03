#include <metal_stdlib>
using namespace metal;

// verdict_screen — one thread per agent. Computes the SAME terminal the CPU
// golden law computes, from that agent's 256-sample window, in EXACT integer
// ops. No float, no multiply, no divide — abs, subtract, compare, run counter —
// so the GPU result is bit-identical to the CPU by construction, not by
// tolerance. Canonical semantics mirror FusionLaw.screen exactly:
//   (1) whole-window malformed pre-scan FIRST
//   (2) input shorter than the window is REFUSED_MALFORMED
//   (3) envelope refusal, then growth-run MITIGATE
// Terminal ordinals: 0 NOMINAL, 1 MITIGATE, 2 REFUSED_OUT_OF_ENVELOPE, 3 REFUSED_MALFORMED

constant int ADC_MIN = -8192;
constant int ADC_MAX =  8191;
constant int ENVELOPE_ABS = 6000;
constant int GROWTH_WINDOW = 8;
constant int GROWTH_TRIGGER = 900;
constant int PERSIST = 3;

kernel void verdict_screen(device const short*  windows   [[buffer(0)]],
                           device const uint&   windowLen [[buffer(1)]],
                           device const uint&   agentCount[[buffer(2)]],
                           device uint*         terminals [[buffer(3)]],
                           uint gid [[thread_position_in_grid]]) {
    if (gid >= agentCount) return;
    const uint base = gid * windowLen;
    const int  n = int(windowLen);
    const int  W = GROWTH_WINDOW;

    // (1) whole-window malformed pre-scan
    for (int i = 0; i < n; i++) {
        int v = int(windows[base + uint(i)]);
        if (v < ADC_MIN || v > ADC_MAX) { terminals[gid] = 3; return; }
    }
    // (2) too short
    if (n <= W) { terminals[gid] = 3; return; }

    int run = 0;
    for (int k = W; k < n; k++) {
        int raw = int(windows[base + uint(k)]);
        int a = raw < 0 ? -raw : raw;
        if (a > ENVELOPE_ABS) { terminals[gid] = 2; return; }
        int pv = int(windows[base + uint(k - W)]);
        int b = pv < 0 ? -pv : pv;
        int g = a - b;
        if (g >= GROWTH_TRIGGER) {
            run += 1;
            if (run >= PERSIST) { terminals[gid] = 1; return; }
        } else {
            run = 0;
        }
    }
    terminals[gid] = 0;
}
