# Project Status

Date: 2026-09-08

The current build target is **L1** — the machinery that produces the plans that
produce the products (ADR-0012 §9). Every L2 product below is **pre-1.0 /
prototype**: a goal with a working prototype, not a shipped product. Nothing here
is described in the present tense as shipped.

| Entity | Layer | Maturity |
| --- | --- | --- |
| DexRoboKnix | L1 | Governance ratified through ADR-0017. Layer map (ADR-0012), OpenCore model, and repo structure are settled. |
| DexSpine | L1 | Reference implementation (`dexspine-core`): DEX838 wire parser with strict mode, the 8:3:8 filter model, and the DexProduct decision primitives (framework manifest, promotion rule, evidence stamp, action record) landed per ADR-0013 through ADR-0017. The bidirectional generate/validate pipeline against a live target is the next major build. |
| ShadowOS | L2 | Buildable native desktop prototype (Tauri/Rust/SolidJS); window manager wired to the ADE IPC layer. Prototype. |
| DexCLI | L2 | Working Gemini-first multi-agent prototype. Prototype. |
| DexFolio | L2 | Knowledge-capture prototype; runs standalone and hosted inside ShadowOS. Prototype. |
| DexScape | L2 | Intent only — name reserved, no repo, no code. |
| ADE | L3 (under ShadowOS) | Native shell, window IPC, and agent-harness boot sequence prototyped and tested. Prototype. |

## Notes

- The authoritative vocabulary and layer definitions live in [`CONTEXT.md`](CONTEXT.md);
  the decisions behind them in [`docs/adr/`](docs/adr/).
- "Enterprise" repositories are reserved placeholders only — see the OpenCore
  section of the [README](README.md).
