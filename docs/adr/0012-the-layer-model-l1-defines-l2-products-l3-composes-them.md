# ADR 0012: The layer model — L1 defines, L2 is products, L3 composes them

- **Status**: accepted
- **Date**: 2026-08-09
- **Decided by**: Dan
- **Wayfinder ticket**: [dexroboknix#12](https://github.com/Dex-RoboKnix/dexroboknix/issues/12), part of map [dexroboknix#1](https://github.com/Dex-RoboKnix/dexroboknix/issues/1)
- **Relationship to prior ADRs**: **reaffirms** [ADR-0006](0006-shadowos-is-the-container-ade-is-the-harness.md) (does *not* supersede it); **leaves [ADR-0010](0010-package-dependency-direction-rule.md) unchanged** (does *not* amend it); **extends** [ADR-0008](0008-dexfolio-embeds-unmodified-in-shadowos.md); **relocates** DexSpine and DexCLI relative to `CONTEXT.md` and `CLAUDE.md`

## Context

A layer model surfaced repeatedly during the [ADR-0011](0011-nested-repos-are-publication-units-not-architecture.md)
sign-off that did not match the written record. ADR-0011 recorded it out of
scope and raised it as `#12`. It proposed: L3 as reusable building blocks
defined at L1 and composed into L2 products; DexSpine as an *internal* L2
meta-builder that updates the *external* L2 products; DexCLI as an L2 product
offered via terminal and web; ADE as a product label covering ShadowOS, DexFolio
and native DexFolio; plus two entities that exist in no file — **DexScape** and
**DexProduct**.

Two of those conflicted head-on with ratified decisions:

- **ADE-as-umbrella is ADR-0001's reading, which ADR-0006 reversed on Dan's own
  ruling** — *"ADE is not the desktop experience."* ADR-0006 records what the
  umbrella reading cost while it stood for four days: `ade-core/` holding the
  whole desktop container, an ADE glossary calling ADE "the working product name
  under DexRoboKnix" without naming ShadowOS once, two mutually exclusive layer
  maps live in the repo, and **81 build-spec tickets, T001–T124, written in the
  wrong vocabulary**. The symptom that surfaced it was an agent unable to
  determine which of four artefacts "ShadowOS" named. That history was put to
  Dan before this ADR was opened, and the umbrella reading was declined on the
  record for the second time.
- **A meta-builder that pushes updates down is the opposite arrow to ADR-0010**,
  which makes `dexspine-core` a permanently zero-dependency leaf its consumers
  pull from, CI-enforced. Both could not be true.

The grilling took eight rounds, one question at a time. What follows is what Dan
ruled, not what was proposed.

## Decision

### 1. The layer number measures containment, not reuse

**L3 is the components — the building blocks — of an L2.** L1/L2/L3 is one
structure showing how each thing is built and what it feeds. This is what
`CONTEXT.md` and ADR-0006 already say, and it settles the ticket's first bullet:
the "reusable blocks defined at L1" reading is not adopted, because it would
make the same integer mean *inside one product* and *shared across products*
simultaneously.

The shape is a **strict tree with a widening fan-out** — one L1, several L2s,
many L3s. Every L3 has exactly one parent L2.

### 2. DEX838 is an L1 standard, and DexSpine moves wholesale to L1

DEX838 is not a component. It is a standard products **conform to**, sitting at
L1 alongside OpenCore licensing, naming and provenance. DexSpine follows it: the
DEX838 spec, the 8:3:8 Dexfilter, and `dexspine-core` as its **reference
implementation** are all L1.

This is a relocation from `CONTEXT.md`, which currently defines DexSpine as "the
L2 cognitive infrastructure platform", and from `CLAUDE.md`, whose tree hangs
DexCLI off DexSpine at L3.

The test it establishes: **L1 defines, L2 conforms.** A thing that other things
are measured against is L1. A thing that is measured is L2.

### 3. L2 is products only; L3 is their components

```
L1  DexRoboKnix   — governance: OpenCore licensing, naming, provenance tags
    DexSpine      — DEX838, 8:3:8, dexspine-core (reference implementation)
    DexProduct    — future, placement unresolved (see §7)
         ▲ conform / pull
         │
L2  ShadowOS      DexCLI      DexFolio      DexScape
      │             │
L3  ADE, shell,   terminal, web,
    window mgr,   swarm worker
    design system
```

**Zero L2→L2 dependency edges.** Depending on L1 is what every layer does by
definition, so the fan-in that `dexspine-core`'s three consumers appeared to
create was never a fan-in at all — it was three L2 products pulling from L1.

### 4. ADE stays the L3 harness layer inside ShadowOS — ADR-0006 reaffirmed

ADE remains the agent runtime, MCP surface, protocol envelope, and session and
permission scope inside ShadowOS: what lets an LLM drive a desktop instead of a
person. `CONTEXT.md`'s avoid-list for ADE — *Native ShadowOS, ADE standalone,
Autonomous Desktop Environment, the desktop, the shell* — stands unchanged.

**This ADR does not supersede ADR-0006. It reaffirms it.** ADR-0006 has now been
tested twice and held twice.

The idea underneath the umbrella proposal was sound and is not lost: one thing
powering both the agent-driven and the non-agent tools. That thing is **DexSpine
at L1**. It no longer needs to borrow ADE's name, which was the whole problem.

### 5. DexCLI is an L2 product that plays the Harness role

DexCLI is a product shipped via terminal and web. It **conforms to** DEX838
rather than defining it, which is what separates L2 from L1 under §2 — and
ADR-0010 already has `dexcli-core` depending on `dexspine-core`, i.e. behaving
as a consumer.

Toward ShadowOS it plays the **Harness** role per ADR-0007. **A role is
orthogonal to a layer**, so ADR-0007 survives untouched. This corrects a
placement Dan first stated as L1 during the grilling and then revised: putting
tools at L1 would make L1 mean "shared infrastructure" rather than "governance
and the standard", and the L1/L2 line would go soft again.

### 6. Hosting and composition are different relations, and both get named

`CONTEXT.md` gains one distinction, because "inside ShadowOS" is currently true
of both ADE (L3) and DexFolio (L2) and therefore answerable two ways — the exact
mechanism ADR-0006 blames for four days of wrong vocabulary.

- **ShadowOS *hosts* DexFolio and DexScape.** Independently installable L2
  products it can run, which do not ship with it and which it does not depend on.
- **ShadowOS is *composed of* ADE, the shell and the window manager.** L3
  components with no life outside it.

**The test: can it be installed on its own? Then it is hosted, not a component.**

This extends ADR-0008 rather than reopening it. "DexFolio runs unmodified inside
ShadowOS — the same application both ways" is now the first instance of a named
relation instead of a one-off, and it still needs no umbrella term.

### 7. DexScape is an L2 product, recorded as intent

**DexScape** is a Chromium-based browser and an L2 product — a peer of ShadowOS,
DexCLI and DexFolio. Its first delivery is as the browser app **hosted inside
ShadowOS**, so that ShadowOS can display DexFolio. It is not an L3 component of
ShadowOS and it does not replace ShadowOS's WebView2 rendering.

DexFolio therefore has three hosts — standalone, ShadowOS, DexScape — and
remains one application in all three, per ADR-0008.

No repo, no code. The name is pinned in `CONTEXT.md` **now**, ahead of
implementation, on the same reasoning as ADR-0007: an unpinned name is what let
"ADE" mean four things.

### 8. DexProduct is deferred, deliberately

**DexProduct is future work and its placement is unresolved.** Dan's framing, as
given: *"a DexSpine of what we want the product arm to be, and its outputs will
be the L2 product layer"* — sitting below DexSpine within L1, but *"not sure
where it sits."*

It is recorded here so it does not resurface as an unactioned instruction, and
it is **not ratified**. It gets its own ticket.

### 9. L2 and L3 are goals with working prototypes — labelled, not archived

Dan's ruling: *"Label them as goals/objectives, because we have to then build the
L1 that can produce them via plans created within L1. The L2 and L3s are just
ideas and goals that have working prototypes."*

So the current build target is **L1** — the machinery that produces the plans
that produce the products. L2 and L3 are marked pre-1.0 / prototype in
documentation so that no public document claims a shipped product. This is the
same discipline `CONTEXT.md` already applies to Enterprise Edition ("do not
describe it in the present tense").

**Nothing is archived on the strength of a layer number.** The ticket's
"treat anything L2 and below as prototypes and archive" line, read literally,
covered every line of product code including the 81 completed build-spec
tickets. That reading is explicitly not adopted. Archiving remains
ADR-0011's rule: nothing is deleted, and anything archived moves to local disk
outside the working tree, by explicit named path.

### 10. Flow across the DexSpine is bidirectional — as intent, with no mechanism yet

**DexSpine is the universal structure across all repositories**, and the
conceptual data flow across it runs both ways:

- **Downward — generation.** L1 generates plans, specs and scaffolding that land
  in L2 repos. Once written, that code is owned by the L2 product.
- **Upward — validation.** A pattern discovered in an L2 product travels back up
  the DexSpine to be validated against the standard and, if it holds, absorbed
  into it.

**No mechanism for either direction exists in the tree today.** No generator
writes into an L2 repo; no validator reads an L2 pattern back up.

Therefore:

> **ADR-0010 stands exactly as written, and its CI check keeps running.** It
> governs `package.json` edges, and nothing here creates one. Generation writes
> files; validation reviews proposals. Neither is an import.
>
> **Any mechanism that would require such an edge must return with its own ADR
> explicitly amending ADR-0010.** The door stays open; it cannot be walked
> through silently.

This is the distinction the whole ticket turned on, so it is stated
plainly: **code dependencies flow upward (L2 pulls from L1); authorship and
generation flow downward; pattern validation flows upward.** Three arrows, two
planes. Collapsing them is what produced `#12`.

## Alternatives rejected

- **ADE as the umbrella product label** (ADR-0001's reading, third airing).
  Rejected by Dan with the T001–T124 history in front of him. It also leaves the
  agent-connection layer nameless, which is ADR-0006's stated objection.
- **L3 as reusable blocks shared across several L2s** (a fan-in, not a tree).
  Rejected at the DEX838 test case: the shared thing turned out to be L1, not a
  multi-parent L3.
- **DexSpine stays L2 with only the spec at L1.** Rejected — it would make
  ShadowOS, DexCLI and DexFolio's dependence on `dexspine-core` a set of L2→L2
  edges, which ADR-0010 treats as requiring an ADR each.
- **DexCLI at L1 alongside DexSpine.** Stated then revised by Dan; rejected
  because it dissolves the "L1 defines, L2 conforms" test.
- **Splitting DexCLI** (engine at L1, app at L2). Rejected as premature on
  ADR-0010's own reasoning for declining to split `ade-core`: one hypothetical
  consumer is not a seam.
- **Amending ADR-0010 now to permit bidirectional edges.** Rejected — it removes
  a passing guard, eight hours old, in exchange for a shape nothing has built.

## Consequences

- **`CONTEXT.md` changes** — the precedence authority per ADR-0006, so this is
  the load-bearing edit. DexSpine's entry moves to L1 and absorbs the reference
  implementation; DexCLI gains an explicit L2 product entry noting the Harness
  role; new entries for **hosted** and **component**; a new entity entry for
  **DexScape** with an avoid-list, marked intent-only; prototype status noted
  against each L2. **This ADR ratifies a decision only — a separate build ticket
  executes the edit.**
- **`CLAUDE.md`'s tree is wrong as written** and must be redrawn: it shows
  DexSpine at L2 and DexCLI at L3 beneath it.
- **`packages/l1/README.md` needs checking** — it carried the ADR-0001
  vocabulary once already.
- **ADR-0010 is unchanged.** No CI work falls out of this ADR.
- **ADR-0007 is unchanged.** Harness is a role, not a layer.
- **ADR-0008 is unchanged and extended** by the hosted/component distinction.
- **`#9` unblocks.**
- **Two follow-on tickets**: building DEX838 and DexSpine to the bidirectional
  plan; and placing DexProduct.
- **Directory paths are still not moved**, per ADR-0006. `ade-core/` still holds
  ShadowOS container code and is still legacy. Read layers from `CONTEXT.md`,
  never from folder position — ADR-0011 §2 says the same thing about nesting.

## What would have to change to revisit this

A decision to ship a thing that is genuinely shared between two L2 products and
is genuinely *not* a standard — the first true multi-parent L3. That would break
the strict tree, and the map should be redrawn rather than amended. Or DexProduct
turning out to require a real code edge from L1 into an L2 repo, which lands on
ADR-0010 rather than here.
