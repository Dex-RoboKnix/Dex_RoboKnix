# DexRoboKnix

> **Canonical copy:** This is the canonical L1 governance documentation authority; `packages/l1` in the working monorepo is the canonical L1 governance metadata package it exports.

DexRoboKnix is the parent organisation and governing structure for the DexRoboKnix ecosystem.

It is not a single product. It is the layer map, operating philosophy, OpenCore model, and repo structure that keeps DexSpine, ShadowOS, DexCLI, DexFolio, and DexScape aligned. This repository is the **public front door**: the governance docs and the layer map live here, and it links down into each component repo.

## Layer Map

Ratified 2026-08-09 (ADR-0012). L1 defines, L2 conforms; L3 is the components of exactly one L2 — see [`CONTEXT.md`](CONTEXT.md) for the authoritative glossary.

| Layer | Entity | Role |
| --- | --- | --- |
| L1 | DexRoboKnix | Parent brand, governance, repo map, OpenCore structure |
| L1 | DexSpine | The standard L2 products conform to: DEX838, 8:3:8 Dexfilter, `dexspine-core` (reference implementation) |
| L2 | ShadowOS | Local-first **native** desktop container (Tauri/Rust/SolidJS) — the desktop a person sees and drives |
| L2 | DexCLI | Gemini-first multi-agent swarm orchestrator, shipped via terminal and web; plays the Harness role toward ShadowOS |
| L2 | DexFolio | Obsidian-style knowledge capture, independently installable and also hosted inside ShadowOS |
| L2 | DexScape | Chromium-based browser — intent only, no repo, no code yet |
| L3 under ShadowOS | ADE, shell, window manager, design system | ADE is the harness layer that lets an LLM drive a ShadowOS desktop instead of a person; none of these are shared components |

## Governance

Architecture Decision Records live in [`docs/adr/`](docs/adr/). Start with [ADR-0012](docs/adr/0012-the-layer-model-l1-defines-l2-products-l3-composes-them.md) (the layer model) and [ADR-0002](docs/adr/0002-opencore-licensing-matrix.md) (OpenCore licensing). The OpenCore model itself is written up in [`OPENCORE.md`](OPENCORE.md); repository structure in [`STRUCTURE.md`](STRUCTURE.md).

## OpenCore

Every active layer is intended to follow the same split:

- **Core** — public / open-source implementation.
- **Enterprise** — private / commercial extensions, connectors, managed deployment, and support.

Private `*-enterprise` repos exist as **placeholders only** — a reserved commercial boundary holding a README, LICENSE, and status note, no product code. That work starts only once there is a product and a market. Treat "Enterprise" below as a stated, reserved boundary, not as something you can obtain today. Core code must never depend on enterprise code (ADR-0010). The exact license matrix is tracked in [`OPENCORE.md`](OPENCORE.md).

## Component Repos

| Repo | Visibility | Entity |
| --- | --- | --- |
| [`Dex_RoboKnix`](https://github.com/Dex-RoboKnix/Dex_RoboKnix) | Public | L1 governance docs, layer map, project status (this repo) |
| [`dexspine-core`](https://github.com/Dex-RoboKnix/dexspine-core) | Public | DexSpine Core — DEX838 + 8:3:8 reference implementation (L1) |
| [`dexcli-core`](https://github.com/Dex-RoboKnix/dexcli-core) | Public | DexCLI Core (L2) |
| [`shadowos-core`](https://github.com/Dex-RoboKnix/shadowos-core) | Public | ShadowOS Core (L2) |
| [`ade-core`](https://github.com/Dex-RoboKnix/ade-core) | Public | ADE Core (L3 under ShadowOS) |
| `dexspine-enterprise` | Private | DexSpine Enterprise placeholder |
| `dexcli-enterprise` | Private | DexCLI Enterprise placeholder |
| `shadowos-enterprise` | Private | ShadowOS Enterprise placeholder |
| `ade-enterprise` | Private | ADE Enterprise placeholder |

## Current Build Status

See [`PROJECT-STATUS.md`](PROJECT-STATUS.md) for current maturity and next steps per entity.
