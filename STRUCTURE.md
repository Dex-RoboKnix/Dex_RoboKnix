# DexRoboKnix Structure

This file records the ratified working structure as of 2026-05-22.

## Active Structure

| ID | Layer | Canonical entity | Repo path |
| --- | --- | --- | --- |
| L1 | Brand / Org | DexRoboKnix | `Dex_RoboKnix` |
| L2-SPINE | Ecosystem / Platform | DexSpine | `dexspine-core`, `dexspine-enterprise` |
| L3-SPINE-DEXCLI | Tool under DexSpine | DexCLI | `dexcli-core`, `dexcli-enterprise` |
| L2-OS | Ecosystem / Platform | ShadowOS | `shadowos-core`, `shadowos-enterprise` |
| L3-OS-ADE | Tool under ShadowOS | ADE | `ade-core`, `ade-enterprise` |

## Controlling Rules

- DexRoboKnix governs the map; it does not replace the products.
- DexSpine and ShadowOS are the only active L2 platforms.
- DexCLI sits under DexSpine.
- ADE sits under ShadowOS unless Dan explicitly changes the architecture.
- ShadowOS must be able to run without ADE.
- ADE depends on ShadowOS to expose a desktop to agents.
- OpenCore applies at every active layer.

**Historical naming note:** In earlier planning sessions, both "ADE" and "Shadow OS" were used interchangeably to refer to the same whole-product concept (the native desktop environment). The current, ratified meaning separates them: **ShadowOS** is the L2 desktop-in-a-tab product — the sovereign local desktop container providing windows, dock, menus, and persistence. **ADE** (Agent Desktop Environment) is the L3 MCP-observability component that sits under ShadowOS, bridging external LLM harnesses (Codex, Claude Desktop) into ShadowOS container instances for real-time agent work observation. The public `Dex-RoboKnix/ade-core` GitHub repo description still reads "Autonomous Desktop Environment" as of this writing — that is the pre-ratification name and has not been updated to match; **"Agent Desktop Environment" is the ratified meaning**, and the GitHub description should be corrected to match rather than treated as a second, competing definition.

## Current Architecture Decision Needed

The ADE implementation currently uses a native Tauri shell, while the ratified structure defines ShadowOS as the desktop and ADE as the agent-operability layer over it.

This must be resolved before heavy ADE Phase 1 and Phase 2 work proceeds.

