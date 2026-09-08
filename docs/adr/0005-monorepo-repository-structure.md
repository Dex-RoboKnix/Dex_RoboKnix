# ADR 0005: Pnpm Workspace Monorepo Layout for DexRoboKnix Core

- **Status**: accepted
- **Date**: 2026-07-27

## Context
DexRoboKnix consists of multiple sub-entities across L1 (Governance), L2 (DexSpine, ShadowOS), and L3 (ADE, DexCLI). Maintaining separate repositories introduces version drift, complex cross-repo dependency resolution, and out-of-sync DEX838 wire schemas.

## Decision
We decide to adopt a **Single Pnpm Workspace Monorepo** layout for DexRoboKnix. All public Core entities (`l1`, `dexspine-core`, `shadowos-core`, `ade-core`, `dexcli-core`) are managed as workspace packages under `packages/`. Enterprise packages reside in a dedicated `enterprise/` workspace directory.

## Consequences
- Atomic commits and synchronized releases across DEX838 schema, ADE Tauri Rust bridge, and DexCLI agent loop.
- Single root `pnpm-workspace.yaml` and unified build scripts (`pnpm dev`, `pnpm build`).
- Private enterprise components remain isolated in `enterprise/` or a linked private sub-module.
