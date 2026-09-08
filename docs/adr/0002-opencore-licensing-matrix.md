# ADR 0002: OpenCore AGPL-3.0 Core and Commercial Enterprise Licensing

- **Status**: accepted
- **Date**: 2026-07-27

## Context
Licensing across the DexRoboKnix sub-repositories was historically fragmented across AGPL-3.0 (ADE), MIT (DexCLI), PolyForm (DexSpine), and unspecified licenses. The ratified ecosystem model mandates an OpenCore structure with public Core repos and private Enterprise repos.

## Decision
We decide that **AGPL-3.0** is the standardized license for all public **Core** repositories across DexRoboKnix (`dexroboknix-core`, `dexspine-core`, `shadowos-core`, `ade-core`, `dexcli-core`). All **Enterprise** repositories remain private and licensed under a commercial proprietary EULA.

## Consequences
- Unifies licensing across all Core sub-modules.
- Existing MIT license in `dexcli` and PolyForm references in `dexspine` will be updated to AGPL-3.0 prior to public release.
- Ensures open-source contributions remain copyleft protected while commercial clients purchase Enterprise licenses.

## Amendment (2026-07-31): `ade-core` license-consistency finding (B1)

An earlier pass flagged a possible residual permissive-licence (MIT/Apache-2.0)
claim against `ade-core`. That claim traced back to a stale, auto-generated
summary (`_overview.md`, produced by an earlier context-dump/scraper pass, not
part of the live repo) rather than to anything in the actual tree — a
regenerated summary can reintroduce the same false claim if this isn't
recorded.

What was actually checked, directly against the live `ade-core` tree:
- Every `package.json` under `ade-core/` (excluding `node_modules`): none
  declares a `"license"` field at all — none diverges from AGPL-3.0-or-later.
- Every `Cargo.toml` under `ade-core/`: `apps/shell/src-tauri/Cargo.toml` and
  `services/agent-runtime/Cargo.toml` both use `license.workspace = true`,
  which resolves to `license = "AGPL-3.0-or-later"` in the workspace root
  `Cargo.toml`'s `[workspace.package]`.
- `ade-core/LICENSE` is the AGPL-3.0 text.

**Finding: no residual permissive-licence field exists anywhere in `ade-core`.**
If a future doc-generation pass reports otherwise, treat it as another stale
scraper artifact and re-verify against the live tree directly, not against a
cached summary, before acting on it.

