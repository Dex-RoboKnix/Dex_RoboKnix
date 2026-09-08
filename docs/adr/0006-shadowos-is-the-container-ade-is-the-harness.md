# ADR 0006: ShadowOS is the desktop container; ADE is the harness layer

- **Status**: accepted
- **Date**: 2026-07-31
- **Supersedes**: [ADR 0001 — ADE as Native Desktop Shell hosting ShadowOS Web UI](0001-ade-shadowos-architecture.md)
- **Decided by**: Dan

## Context

ADR-0001 (2026-07-27) considered the layer map in which ShadowOS is the L2
desktop and ADE is an L3 component above it, and **rejected** it. It ruled that
ADE is "the single native desktop container and shell for DexRoboKnix" and that
ShadowOS is a set of "web components integrated directly inside ADE's webview UI
layer."

That ruling propagated faithfully. Four days later it is visible in:

- `packages/l1/README.md` — "L3: ADE / Agent Desktop Environment (Native Tauri Desktop Shell)"
- `ShadowOS/Agent Desktop Environment/docs/glossary.md` — ADE is "the working
  product name under DexRoboKnix"; "Shell" is listed as an ADE term; ShadowOS is
  not mentioned once
- The directory layout: the desktop container's code (app shell, boot, window
  manager, design system) sits under `ade-core/`
- 81 completed build-spec tickets, T001–T124, written against that vocabulary

Root `CONTEXT.md` never adopted it. It still defines ShadowOS as "the L2
sovereign native desktop container platform" and ADE as "the L3 MCP connection
bridge and desktop observation layer," and lists *"Native ShadowOS"* under ADE's
avoid-list — precisely the reading ADR-0001 mandated.

So the repo has carried two mutually exclusive layer maps for four days. The
symptom that surfaced it: an agent asked to "focus on ShadowOS and get something
shippable" could not determine which artefact ShadowOS names, and there are four
candidates in the tree.

Dan's ruling, 2026-07-31: *"L2 is ShadowOS and that is the desktop container. ADE
is an L3 component of ShadowOS that connects an LLM via the harness. ADE is not
the desktop experience."*

## Decision

**ShadowOS (L2) is the desktop container.** It owns the Tauri application shell,
boot and runtime lifecycle, the window manager, the design system (Lucent
Glass), multi-display handling, and client state persistence. It is what a user
sees and drives.

**ADE (L3) is the harness layer, a component of ShadowOS.** It owns the agent
runtime service, the MCP server surface, the protocol envelope and IPC contract,
session and permission scope, and the connection to an external LLM harness. It
is what lets an LLM drive a desktop instead of a human.

**One runtime, as ADR-0001 required.** This reverses ADR-0001's *naming*, not its
engineering conclusion. There remains exactly one desktop runtime — a single
Tauri binary — with ShadowOS and ADE as layers inside it, not two competing
desktop implementations. ADR-0001's stated concern, "duplicate maintenance
overhead and architectural ambiguity from two separate desktop runtimes," is
therefore not reintroduced.

**Root `CONTEXT.md` is the precedence authority for cross-repo vocabulary.**
Where a per-package glossary conflicts with it on a term that spans packages
(ShadowOS, ADE, DexSpine, DexCLI, the layer map), root `CONTEXT.md` wins.
Per-package glossaries remain authoritative for terms local to their package.
Previously no precedence rule existed between them, which is what let the two
maps coexist unnoticed.

**Directory paths are not moved.** `ade-core/` continues to hold ShadowOS
container code. The name is legacy and is recorded as such rather than corrected,
because moving it would rewrite paths across 81 completed tickets, the 600-step
build spec, the Cargo workspace, CI, and the boundary-check scripts — for no
behavioural gain. A future move is a mechanical refactor available at any time;
the label being wrong in docs is what actually misleads readers, and that is
fixed here.

## Alternatives rejected

- **Move the code to match the layers** (`shadowos-core/` for shell,
  window-manager, design-system; `ade-core/` for agent-runtime, protocol). The
  honest structure, and the one to reach for eventually. Rejected now because the
  cost lands entirely on already-completed work and blocks shipping.
- **Keep ADR-0001 and accept ADE as the umbrella product name.** Cheapest, and it
  would make 81 tickets retroactively correct. Rejected because it makes the
  product unexplainable: "Agent Desktop Environment" as a name for the desktop
  itself leaves the agent-connection layer nameless, and the offer — desktops a
  human or an LLM can drive — needs both halves named to be stated at all.

## Consequences

- **Public descriptions must change.** The `shadowos-core` GitHub repo is
  described as a "local-first browser desktop environment"; ShadowOS is a native
  Tauri app per ADR-0001's surviving engineering ruling, and root `CONTEXT.md`
  lists "Browser-only tab app" under ShadowOS's avoid-list. The `ade-core` repo is
  described as "Autonomous Desktop Environment"; the ratified expansion is
  **Agent** Desktop Environment. Both need correcting on GitHub — a
  credential-bearing action outside the sandbox.
- **The ADE glossary is rewritten**, not deleted: terms are reassigned to their
  owning layer, and its precedence header now defers to root `CONTEXT.md` for
  cross-repo terms.
- **"Backend" is retired in favour of "Harness"** — see `CONTEXT.md`. "Backend"
  reads to any newcomer as "the server", which is not what it meant.
- **A dependency-direction question is now sharp and unresolved.**
  `ade-core/apps/shell/src-tauri/Cargo.toml:20` declares
  `ade-agent-runtime = { path = "../../../services/agent-runtime" }` — the
  container compiles the harness in. If ADE is a component *of* ShadowOS, a
  human-only desktop should not require the harness to be linked. This is the
  L2/L3 boundary made concrete and it sets the rule for the whole monorepo.
- **Terms that cannot survive the one-line test are now visible.**

## What would have to change to revisit this

A decision to ship the desktop container and the harness as separately
installable products, or to ship a browser-only ShadowOS with no Tauri shell. In
either case the single-runtime premise both this ADR and ADR-0001 rest on no
longer holds, and the layer map should be redrawn from scratch rather than
amended.
