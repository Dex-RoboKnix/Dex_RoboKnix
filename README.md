# DexRoboKnix

> **Canonical copy:** This is the canonical L1 governance documentation authority; `packages/l1` is the canonical L1 governance metadata package it exports.

DexRoboKnix is the parent organisation and governing structure for the DexRoboKnix ecosystem.

It is not a single product. It is the layer map, operating philosophy, OpenCore model, and repo structure that keeps DexSpine, DexCLI, ShadowOS, and ADE aligned.

## Layer Map

| Layer | Entity | Role |
| --- | --- | --- |
| L1 | DexRoboKnix | Parent brand, governance, repo map, OpenCore structure |
| L2 | DexSpine | Deterministic cognitive infrastructure for LLM collaboration |
| L3 under DexSpine | DexCLI | Terminal-agent team manager |
| L2 | ShadowOS | Local-first **native** desktop container (Tauri/Rust/SolidJS) — the desktop a person sees and drives |
| L3 under ShadowOS | ADE | Agent Desktop Environment, the harness layer that lets an LLM drive a ShadowOS desktop instead of a person |

## OpenCore

Every active layer is intended to follow the same split:

- Core: public/open source implementation.
- Enterprise: private/commercial extensions, connectors, managed deployment, and support.

**As of 2026-07-31, DexRoboKnix is an open-source offering and nothing else.** No
enterprise repos exist and no enterprise code is being written; that work starts
only once there is a product and a market. Treat "Enterprise" below as stated
intent, not as something you can obtain.

The exact license matrix is still a project decision. Do not assume one license applies across all repos until `OPENCORE.md` is finalized.

## Active Repos

| Repo | Visibility | Entity |
| --- | --- | --- |
| `Dex_RoboKnix` | Public | L1 docs and project status |
| `dexspine-core` | Public | DexSpine Core |
| `dexspine-enterprise` | Private | DexSpine Enterprise placeholder |
| `dexcli-core` | Public | DexCLI Core |
| `dexcli-enterprise` | Private | DexCLI Enterprise placeholder |
| `shadowos-core` | Public | ShadowOS Core |
| `shadowos-enterprise` | Private | ShadowOS Enterprise placeholder |
| `ade-core` | Public | ADE Core |
| `ade-enterprise` | Private | ADE Enterprise placeholder |

## Current Build Status

See `PROJECT-STATUS.md` for the current maturity and next Codex-ready task for each entity.

