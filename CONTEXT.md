# DexRoboKnix Domain Context

DexRoboKnix is the parent organisation and governance ecosystem. Together with DexSpine it forms L1 — what *defines*; the L2 products conform to it.

> **Precedence.** This file is the authority for vocabulary that spans packages —
> the layer map and the names of the entities in it. Where a per-package glossary
> conflicts with this file on such a term, this file wins. Per-package glossaries
> remain authoritative for terms local to their own package. See ADR-0006.

## The layer map

```
L1  DexRoboKnix   — governance: OpenCore licensing, naming, provenance tags
    DexSpine      — DEX838, 8:3:8, dexspine-core (reference implementation)
         ▲ conform / pull
         │
L2  ShadowOS      DexCLI      DexFolio      DexScape
      │             │
L3  ADE, shell,   terminal, web,
    window mgr,   swarm worker
    design system
```

The layer number measures **containment, not reuse**. The test: **L1 defines, L2
conforms** — a thing others are measured against is L1, a thing that is measured
is L2. **L3 is the components of exactly one L2** (decided 2026-08-09, see
ADR-0012). Directory paths were deliberately not moved and do not encode layers —
read the layer from this file, never from folder position.

> **Prototype status.** Every L2 product below is pre-1.0 / prototype: a goal
> with a working prototype, not a shipped product. The current build target is
> L1 — the machinery that produces the plans that produce the products. Do not
> describe an L2 product as shipped in any public document, the same discipline
> this file already applies to Enterprise Edition. This is a label only: nothing
> is archived, moved or deleted on the strength of a layer number (ADR-0012 §9,
> ADR-0011 §4).

## Core Entities

**DexRoboKnix**:
The parent governance layer (L1) controlling repo structure, OpenCore licensing rules, naming conventions, and ecosystem boundaries.
_Avoid_: DEX, DexOS, Null State

**DexSpine**:
The L1 standard for deterministic human-LLM collaboration: the DEX838 wire syntax, the 8:3:8 Dexfilter, and `dexspine-core` as its **reference implementation**. It sits at L1 alongside DexRoboKnix governance because it is a standard products are measured against, not a product that is measured — L1 defines, L2 conforms (relocated from L2 on 2026-08-09, see ADR-0012 §2).
_Avoid_: Prompt engine, Spine framework, the L2 cognitive infrastructure platform (its pre-ADR-0012 definition)

**ShadowOS**:
The L2 native desktop container: the Tauri/Rust/SolidJS application a person actually sees and drives, owning the app shell, boot and runtime lifecycle, window management, the design system, multi-display handling, and client state persistence. Composed of ADE, the shell and the window manager (L3 components); hosts DexFolio and DexScape (L2 products) — see "hosted" and "component" below.
_Status_: pre-1.0 / prototype.
_Avoid_: Shadow Desktop, HaikuDexOS, DexOS, Browser-only tab app, ADE

**DexCLI**:
The L2 product shipped via terminal and web: a Gemini-first multi-agent swarm orchestrator. It **conforms to** DEX838 rather than defining it, which is what places it at L2 and not L1. Toward ShadowOS it plays the **Harness** role (decided 2026-08-06, see ADR-0007) — **a role is orthogonal to a layer**, so being a Harness says nothing about which layer DexCLI is on.
_Status_: pre-1.0 / prototype.
_Avoid_: L3, a tool built on DexSpine (its pre-ADR-0012 placement), Dex CLI (two words), the Harness (that names the role, not the product — several things play it)

**DexFolio**:
The L2 knowledge-capture product: an Obsidian-style note-taking and linking application. Installable and runnable standalone, and also runs unmodified inside ShadowOS as its default notes app — the same application both ways, not a separate ShadowOS-native reimplementation (decided 2026-08-06, see ADR-0008). It is *hosted* by ShadowOS and by DexScape; three hosts, one application.
_Status_: pre-1.0 / prototype.
_Avoid_: Folio (that names the artefact it produces, not the product — see "folio" below), Dex Folio (two words)

**DexScape**:
The L2 product: a Chromium-based browser, a peer of ShadowOS, DexCLI and DexFolio. Its first delivery is as the browser app *hosted* inside ShadowOS, so that ShadowOS can display DexFolio. It is not an L3 component of ShadowOS and it does not replace ShadowOS's WebView2 rendering. **Intent only — no repo, no code.** The name is pinned here ahead of implementation on the same reasoning as ADR-0007: an unpinned name is what let "ADE" mean four things (decided 2026-08-09, see ADR-0012 §7).
_Status_: intent only — pre-1.0, unimplemented. Do not describe it in the present tense.
_Avoid_: ShadowOS's browser, the webview, DexScape shell, a ShadowOS component

**folio**:
An individual HTML artefact, produced by DexFolio, that captures a unit of knowledge in structured form. Distinct from DexSpine — a folio is not a spine instance, and DexRoboKnix has no generic "spine" primitive (decided 2026-08-06: DexSpine remains scoped to DEX838/8:3:8, not generalized). Generated by pointing DexFolio at a project folder or repo, which runs DexSpine via DEX838 to complete a set of nodes that populate the folio (see ADR-0009).

**node**:
One structural entry within a folio, completed by running DEX838 over source material. A plain structural unit — not an instance of the generic "spine" primitive DexRoboKnix decided not to adopt. Comes in two kinds — **filter application** and **inventory node** — see both below (decided 2026-08-13, see ADR-0013 §3).

**filter application**:
The full 19-question node: 8 plan questions, 3 MVE files (`va.md`, `hu.md`, `llm.md`), 8 execute questions, applied to one `layer:phase:point` coordinate. Named after `DEXFILTER_APPLICATION.md`, the per-layer index file the corpus already writes at this shape. Reserved for the business itself and for subjects that earn one — see "inventory node" for the cheaper default a discovered subject gets otherwise. What promotes an inventory node to a filter application is not yet decided (ticket 25).
_Avoid_: full node, deep node, 19-question node

**inventory node**:
The cheap node kind for a discovered product, API surface, or documentation page found while walking a target: subject, link, overview, and an evidence stamp — never a plan/MVE/execute triad. Exists because node counts are an output of discovery, never a target: a tool that aims at a filter-application count for every discovered surface pads to reach it (decided 2026-08-13, see ADR-0013 §3, ruling R3). See "promotion" below for what turns one into a filter application.
_Avoid_: product record, surface entry, link node, shallow node

**promotion**:
The decision that turns an inventory node into a full filter application. Made after an inventory pass over the whole target, never before it. A discovered subject is promoted if it *is* the audited business itself (always, with or without a framework lens) or if a framework manifest names it as relevant; otherwise it stays inventory-only. Un-promoted subjects are always a stated limit in the deliverable — "N surfaces inventoried, not deep-analysed" — never silently absent. Decided 2026-08-14, ADR-0016 / ruling R11.
_Avoid_: upgrade, escalation (both imply a severity judgement this isn't), deep-dive (names the effect, not the mechanism)

**evidence stamp**:
The URL and retrieval date attached to an inventory node, so a finding about a non-consenting target can be traced back to what was actually observed and when. Required on every inventory node; whether it becomes mandatory on filter applications too is unresolved (ticket 24).
_Avoid_: citation, source note, timestamp

**Agent Desktop Environment (ADE)**:
The L3 harness layer inside ShadowOS: the agent runtime, MCP surface, protocol envelope, and session and permission scope that let an LLM drive a desktop instead of a person. In earlier planning sessions "ADE" and "ShadowOS" were used interchangeably for the same whole-product concept, and the public `Dex-RoboKnix/ade-core` GitHub repo description still reads "Autonomous Desktop Environment" as of this writing; "Agent Desktop Environment" is the ratified meaning and the GitHub description is stale, not a competing definition. See `l1/STRUCTURE.md` ("Historical naming note") for the full account.
_Avoid_: Native ShadowOS, ADE standalone, Autonomous Desktop Environment, the desktop, the shell

**Shell**:
ShadowOS's own Tauri application layer — SolidJS UI in WebView2 plus the Rust core. A part of ShadowOS, never a part of ADE.
_Avoid_: ADE Shell, the desktop container (that is ShadowOS entire, not just its shell)

**Harness**:
The external LLM client ADE connects a desktop to — Claude Desktop, Codex CLI, a local model runner, and (decided 2026-08-06, see ADR-0007) DexCLI. Replaces the term "Backend", which read to newcomers as "the server".
_Avoid_: Backend, Model backend, Engine

**Desktop**:
One running ShadowOS container instance, driven either by a person or, through ADE, by an LLM. ShadowOS spins up desktops; a desktop is the unit that gets driven.
_Avoid_: Session (that is ADE's bounded agent run, not the desktop itself), Instance, Workspace

**hosted**:
The relation between two L2 products where one runs the other. A hosted product is independently installable, does not ship with its host, and its host does not depend on it. **ShadowOS hosts DexFolio and DexScape.** Hosting is not composition — a hosted product keeps its own layer and its own life (decided 2026-08-09, see ADR-0012 §6).
_Avoid_: embedded, built into, bundled with, part of (all read as composition), a plugin

**component**:
An L3 building block with no life outside its one parent L2. **ShadowOS is composed of ADE, the shell and the window manager.** Every L3 has exactly one parent L2 — there are no shared components, because a thing genuinely shared across products is a standard and therefore L1.
**The test: can it be installed on its own? Then it is *hosted*, not a component.** This distinction exists because "inside ShadowOS" was true of both ADE (L3) and DexFolio (L2) and so answerable two ways — the exact mechanism ADR-0006 blames for four days of wrong vocabulary.
_Avoid_: module, sub-product, using "component" for anything installable on its own

> **Legacy path note.** The ShadowOS container's code currently lives under
> `ShadowOS/Agent Desktop Environment/ade-core/`. That path predates ADR-0006 and
> is legacy: directory names were deliberately not moved. Read the layer from
> this glossary, not from the folder it sits in.


## Governance & Licensing

**OpenCore**:
The intended business and distribution rule: every entity maintains a public open-source Core edition (AGPL-3.0), with a private commercial Enterprise edition once there is a product and a market to sell it to. As of 2026-07-31 no Enterprise edition exists and none is being built.
_Avoid_: Dual-repo split without governance, Anti-enterprise

**Core Edition**:
The public, open-source codebase of an entity licensed under AGPL-3.0. Today this is the whole of DexRoboKnix.
_Avoid_: Free tier, Community edition

**Enterprise Edition**:
A future private, commercial extension of an entity. Deferred: no enterprise repos exist, no enterprise code is written, and the term names an intent rather than a thing. Do not describe it in the present tense in any public document.
_Avoid_: Premium tier, Closed core, present-tense claims about enterprise features

## Cognitive Syntax & Method

**DEX838**:
The unified single-line wire syntax `dex(scope, @context)["subject"]` used for deterministic LLM extractions, agent IPC, and prompt evaluation.
_Avoid_: Arbitrary prompts, Softcode-only string

**8:3:8 Dexfilter**:
The standard analytical process consisting of 8 plan questions, 3 MVE files (`va.md`, `hu.md`, `llm.md`), and 8 execute questions.
_Avoid_: Unstructured prompt loop

**Softcode**:
Conceptual, intent-driven instructions denoted by `dex()` indicating design goals or high-level requirements.
_Avoid_: Hardcode, Pseudocode

**Hardcode**:
Literal, executable code/syntax denoted by `dex[]` specifying explicit functions, libraries, or algorithms.
_Avoid_: Softcode, Broad spec

**spine coordinate**:
The `layer:phase:point` address every plan/execute node carries in its wire context (e.g. `layer:policy,phase:plan,point:5`), naming its position in the fixed 96-node plan/execute space (6 layers × 2 phases × 8 points; the 18 MVE files sit alongside these per layer but are not independently coordinate-addressed). Decided 2026-08-13, ADR-0013 §8 / ruling R8.
_Avoid_: node ID, address (too generic — "coordinate" is the term this repo uses)

**framework** (DexProduct sense):
A lens applied *over* a completed, framework-agnostic spine at invocation time (`dex(ITIL, www.example.com)`) — never baked into spine construction. Decided 2026-08-13, ADR-0013 §4 / ruling R4. Not a clause database; see "framework manifest".
_Avoid_: compliance registry, clause database (the framing R8 rejected outright)

**framework manifest**:
The mechanism behind a framework: a list of spine coordinates the framework requires to be populated, plus the bar a populated node has to meet at each, each entry carrying a citation. A manifest over at most 114 coordinates is a bounded, reviewable artifact, not an open-ended clause database. Ships as inert data inside `dexspine-core` (ADR-0010: never a package dependency of it). Decided 2026-08-13/2026-08-14, ADR-0013 §8 and ADR-0015.
_Avoid_: clause registry, rule engine, compliance database

**gap analysis** (DexProduct sense):
The three-state result of projecting a framework manifest over a completed spine, coordinate by coordinate: **covered** (node exists, holds evidence, meets the bar), **weak** (node exists but inferred, empty, or below the bar), or **not observable** (no node at that coordinate from public evidence). The third state is a finding about the evidence, not about the business, and must never be flattened into the second. Explicitly not a certification or attestation of compliance — ADR-0015 §6.
_Avoid_: compliance score, pass/fail, certification, audit result (the last one undersells that this is a gap analysis, not a verdict)

**action record**:
A finding derived on demand from one gap-analysis result — never a spine node itself, never persisted. A **weak** coordinate produces a *remediation* action; a **not observable** coordinate produces an *evidence-request* action, worded so it never reads as a remediation task; a **covered** coordinate produces no action at all. Severity is never asserted by the tool — a caller-supplied value is used verbatim, an omitted one renders as an explicit UNASSESSED marker rather than a guess. Borrows three ideas from SARIF/OSCAL prior art without adopting either schema wholesale: a result references a location rather than re-encoding the assessed content, severity is a field the tool doesn't have to originate, and "no finding" is a valid, common outcome, not an edge case. Decided 2026-08-14, ADR-0017 / ticket 22.
_Avoid_: finding (too generic — this repo's term is "action record"), issue, ticket (both collide with GitHub's own vocabulary), remediation task (only correct for the weak-state kind, wrong for evidence-request)

## Human Governance & Provenance

**Layer 8 Veto**:
The constitutional governance rule that human authority overrides all automated agent decisions, system defaults, or test outputs.
_Avoid_: Autonomous override, Unchecked agent loop

**PHC (Pure Human Cognitive)**:
Unassisted human thought, daily notes, and raw conceptual input generated without AI assistance.
_Avoid_: Raw prompt, Human scratchpad

**OHC (Original Human Context)**:
Structured specifications, domain rules, and architecture documents authored directly by human lead.
_Avoid_: Generated spec, AI draft

**AAC (AI-Assisted Collaborative)**:
Artifacts, code, chat transcripts, and specifications produced or refined through human-LLM collaboration.
_Avoid_: Auto-code, Unchecked output



