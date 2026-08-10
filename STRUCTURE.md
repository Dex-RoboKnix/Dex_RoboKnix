# DexRoboKnix Structure

This file originally recorded the ratified working structure as of 2026-05-22.
That structure was superseded 2026-08-09 by ADR-0012 (see the root
`CONTEXT.md`, the authoritative glossary). The table and rules below are
updated to match; the note below records what changed and why.

## Active Structure

| ID | Layer | Canonical entity | Repo path |
| --- | --- | --- | --- |
| L1 | Brand / Org / Governance | DexRoboKnix | `Dex_RoboKnix` |
| L1 | Standard | DexSpine | `dexspine-core`, `dexspine-enterprise` (relocated from L2, ADR-0012 §2) |
| L2 | Product, conforms to L1 | ShadowOS | `shadowos-core`, `shadowos-enterprise` |
| L2 | Product, conforms to L1 | DexCLI | `dexcli-core`, `dexcli-enterprise` (no longer "under DexSpine" — conforming to a standard is not being contained by it) |
| L2 | Product, conforms to L1 | DexFolio | hosted inside ShadowOS; also independently installable |
| L2 | Product, conforms to L1 | DexScape | intent only — no repo, no code yet |
| L3 under ShadowOS | Component of exactly one L2 | ADE, shell, window manager | `ade-core`, `ade-enterprise` |

## Controlling Rules

- DexRoboKnix governs the map; it does not replace the products.
- DexRoboKnix and DexSpine are the only L1 entities — L1 defines, L2 conforms.
- DexCLI, ShadowOS, DexFolio, and DexScape are the active L2 products.
- ADE sits under ShadowOS as an L3 component unless Dan explicitly changes the architecture.
- ShadowOS must be able to run without ADE.
- ADE depends on ShadowOS to expose a desktop to agents.
- Hosting (ShadowOS hosts DexFolio, DexScape) is not composition — a hosted product keeps its own layer. Only ADE, the shell, and the window manager are L3 components of ShadowOS.
- OpenCore applies at every active layer.

**Historical naming note:** In earlier planning sessions, both "ADE" and "Shadow OS" were used interchangeably to refer to the same whole-product concept (the native desktop environment). The current, ratified meaning separates them: **ShadowOS** is the L2 desktop-in-a-tab product — the sovereign local desktop container providing windows, dock, menus, and persistence. **ADE** (Agent Desktop Environment) is the L3 MCP-observability component that sits under ShadowOS, bridging external LLM harnesses (Codex, Claude Desktop) into ShadowOS container instances for real-time agent work observation. The public `Dex-RoboKnix/ade-core` GitHub repo description still reads "Autonomous Desktop Environment" as of this writing — that is the pre-ratification name and has not been updated to match; **"Agent Desktop Environment" is the ratified meaning**, and the GitHub description should be corrected to match rather than treated as a second, competing definition.

## Resolved: ShadowOS/ADE split (ADR-0006)

The open question this file used to record — the ADE implementation using a
native Tauri shell while the ratified structure defined ShadowOS as the
desktop — is resolved: ShadowOS is the container (native Tauri/Rust/SolidJS
shell), ADE is the harness layer inside it. See ADR-0006 and `CONTEXT.md`.

