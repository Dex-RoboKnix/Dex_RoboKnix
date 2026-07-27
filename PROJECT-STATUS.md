# Project Status

Date: 2026-07-27

| Entity | Current maturity | Next Codex-ready task | Main blocker |
| --- | --- | --- | --- |
| DexRoboKnix | L1 structure, canonical content, and ADRs 0001-0005 are ratified in `DEXROBOKNIX` | Push merged `main` to `origin` (local merge done, not yet pushed) | None — awaiting push from a machine with GitHub credentials |
| DexSpine | Complete alpha corpus copied into `dexspine-core` | Add validator, syntax docs, examples, and package metadata | License conflict and cross-provider claims |
| DexCLI | Working Gemini-first prototype copied into `dexcli-core` | Refactor to provider-agnostic terminal-agent team architecture | Provider scope and Windows PTY cleanup |
| ShadowOS | Buildable browser desktop prototype copied into `shadowos-core`; window manager now wired to ADE IPC (Phase 1) | Persistence hardening, app registry, canonical naming, test coverage | None — boundary resolved via ADR 0001 |
| ADE | Phase 1 complete: native desktop shell, window IPC, Lucent Glass titlebar, agent-harness boot sequence all shipped and tested | Continue T045-T066 shell/control UI, then Phase 2 (MCP server skeleton, permissioned tool registry) | None — boundary resolved via ADR 0001 (ADE is the native shell direction) |

## Current Validation Notes

- ShadowOS prototype build passed with `npm run build`.
- DexCLI prototype test suite passed with `npm test`, but emitted a Windows/Node 24 `node-pty` `AttachConsole failed` message after completion.
- DexSpine alpha corpus has the expected 6 layers, each with 8 plan, 3 MVE, and 8 execute files.
- ADE Phase 0 validation passed after dependency reinstall and clean Rust/Tauri rebuild.
- Phase 1 (ADE native shell + ShadowOS window manager integration): all 4 issues in `.scratch/phase1-ade-shadowos/issues/` completed; full monorepo suite passes 15/15 (`node --test packages/*/test/*.test.js`).
- `feat/T044-phase-0-gate-codex` has been merged into `main` locally. Not yet pushed to `origin` — no GitHub credentials available in the environment that did this merge.

