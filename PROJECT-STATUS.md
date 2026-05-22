# Project Status

Date: 2026-05-22

| Entity | Current maturity | Next Codex-ready task | Main blocker |
| --- | --- | --- | --- |
| DexRoboKnix | L1 structure and canonical content are defined | Publish L1 docs and keep repo map current | License matrix |
| DexSpine | Complete alpha corpus copied into `dexspine-core` | Add validator, syntax docs, examples, and package metadata | License conflict and cross-provider claims |
| DexCLI | Working Gemini-first prototype copied into `dexcli-core` | Refactor to provider-agnostic terminal-agent team architecture | Provider scope and Windows PTY cleanup |
| ShadowOS | Buildable browser desktop prototype copied into `shadowos-core` | Harden persistence, app registry, tests, and canonical naming | ShadowOS/ADE boundary |
| ADE | Phase 0 foundation exists under Agent Desktop Environment | Write boundary ADR, then continue T045-T066 | Native ADE shell vs ShadowOS desktop architecture |

## Current Validation Notes

- ShadowOS prototype build passed with `npm run build`.
- DexCLI prototype test suite passed with `npm test`, but emitted a Windows/Node 24 `node-pty` `AttachConsole failed` message after completion.
- DexSpine alpha corpus has the expected 6 layers, each with 8 plan, 3 MVE, and 8 execute files.
- ADE Phase 0 validation passed after dependency reinstall and clean Rust/Tauri rebuild.

