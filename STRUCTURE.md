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

## Current Architecture Decision Needed

The ADE implementation currently uses a native Tauri shell, while the ratified structure defines ShadowOS as the desktop and ADE as the agent-operability layer over it.

This must be resolved before heavy ADE Phase 1 and Phase 2 work proceeds.

