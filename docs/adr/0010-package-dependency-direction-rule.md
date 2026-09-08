# ADR 0010: Package dependency-direction rule for @dexroboknix/*

- **Status**: accepted
- **Date**: 2026-08-09
- **Decided by**: Dan
- **Wayfinder ticket**: [dexroboknix#4](https://github.com/Dex-RoboKnix/dexroboknix/issues/4), part of map [dexroboknix#1](https://github.com/Dex-RoboKnix/dexroboknix/issues/1)

## Context

The declared package graph implied a two-tier shape (`dexspine-core` as sole
primitive; `ade-core` as a tool built on it; `shadowos-core` and `dexcli-core`
as tools built on both) but nothing stated or enforced it. The one existing
boundary check, `core-boundary.yml`, guards only `ade-core` → `ade-enterprise`
and had never executed until commit `464b270` (E5) fixed a working-directory
bug.

Inspecting the actual code (not just declared `package.json` dependencies)
found the graph was already wrong in practice:

- `ade-core` bundles two unrelated things: `ipc-client.js` (Tauri `invoke`,
  desktop windowing — `window.open`/`close`/`list`) and `vault.js`'s
  `FsVault` (pure `node:fs` path-scoping, no Tauri dependency).
- `shadowos-core` and `dexcli-core` both declare `@dexroboknix/ade-core` as a
  dependency in `package.json`, but neither imports anything from it —
  confirmed by grep across both `src/` trees. The edge is dead weight.

Given `ade-core` has no real second consumer today, splitting it (e.g.
extracting `FsVault` into its own primitive) was considered and rejected as
premature — one adapter is a hypothetical seam, not a real one. The fix is
to stop declaring dependencies that don't exist in code.

## Decision

**The corrected graph:**

```
dexspine-core   (no deps)                    <- primitive
ade-core        -> dexspine-core             <- desktop/Tauri-specific tool
shadowos-core   -> dexspine-core             <- ade-core dep dropped (unused)
dexcli-core     -> dexspine-core             <- ade-core dep dropped (unused)
```

**The rule:** `@dexroboknix/dexspine-core` may not depend on any other
`@dexroboknix/*` package. It is the single primitive and stays a
zero-dependency leaf, permanently. Every other package may depend on
`dexspine-core`; a new edge between any two non-`dexspine-core` packages
(tool-to-tool) requires an explicit ADR before it's added to a `package.json`.

This is deliberately the narrower of the two framings considered (a single
"primitive may not depend on anything" rule, rather than a general tiered
primitives-vs-tools taxonomy) — it matches current reality exactly and
doesn't anticipate a second primitive that doesn't exist yet.

**Immediate consequence:** remove `@dexroboknix/ade-core` from the
`dependencies` of `shadowos-core/package.json` and `dexcli-core/package.json`
— both are unused today.

## Enforcement

A CI check reading truth from `package.json` (not a second list that can
drift): fail the build if `packages/dexspine-core/package.json` declares any
`dependencies` entry under the `@dexroboknix/` scope. A single-line check
(e.g. `jq` over the manifest, or a two-line `dependency-cruiser` rule scoped
to `packages/dexspine-core`) is sufficient — this rule has exactly one
protected node, not a general graph policy, so a heavier tool
(`eslint-plugin-boundaries`, a bespoke workspace-wide script) is more
machinery than the rule needs. Revisit tooling choice if/when a second
primitive or a tool-to-tool edge is ratified and the rule grows past one
node.

## Consequences

- `dexspine-core` stays trivially publishable and reviewable — no package
  graph to reason about, ever.
- The existing `core-boundary.yml` pattern (a scoped CI check reading
  manifests) is reused rather than introducing a new dependency-analysis
  tool into the workspace.
- Any future tool-to-tool edge (e.g. `dexcli-core` legitimately needing
  `FsVault`) is a deliberate, ADR-recorded act — not a silent `package.json`
  edit.
