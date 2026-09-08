# ADR 0016: What promotes an inventory node to a filter application

- **Status**: accepted
- **Date**: 2026-08-14
- **Decided by**: Dan
- **Wayfinder ticket**: ticket 25, part of the
  DexProduct backlog ADR-0013 opened
- **Relationship to prior ADRs**: **completes** [ADR-0013](0013-dexproduct-is-the-audit-generator-and-dex-url-is-a-second-grammar.md)
  §3, which built the inventory node type explicitly *without* a promotion rule, deferring
  it to this ticket. Consumes [ADR-0015](0015-framework-manifest-shape-and-first-pci-dss-manifest.md)'s
  framework manifest as the mechanism the promotion decision runs against.

## Context

ADR-0013 §3 introduced the inventory node — cheap capture (subject, link, overview,
evidence stamp) for a discovered product or API surface — as the standard's second node
kind, explicitly built without logic for promoting one to a full 19-question filter
application. Getting the boundary wrong in either direction breaks the product: promote
too freely and a ten-product SaaS target generates a corpus nobody reads
(`GENERATE_OVER_SHIP`, the map's own rule against documents as completion conditions);
promote too rarely and the deliverable is a link list with a logo on it.

ADR-0013 §8 (R8) supplied a candidate answer worth testing rather than a firm rule: "the
framework manifest decides." That was untestable against a real manifest until
[ADR-0015](0015-framework-manifest-shape-and-first-pci-dss-manifest.md) shipped one. This
ADR confirms R8's candidate and settles the three questions it left open, reached through
live one-question-at-a-time grilling on 2026-08-14.

## Decision

### 1. The framework manifest decides

Confirmed as R8 proposed it. A discovered subject that is not the audited business itself
is promoted to a filter application only when a framework manifest is present and the
subject is judged relevant to it. Rejected alternatives: a standing size/importance rule
independent of any framework (a second rule to maintain alongside the manifest-driven
one, for marginal benefit); unreviewed agent judgement per engagement (least mechanical,
most variance).

### 2. The business itself is always promoted, lens or not

An unlensed `dex(<url>)` run — no framework named — still deep-analyses the target's own
primary subject; every other discovered subject stays inventory-only until a manifest
names it relevant. This keeps ADR-0013 §2's plain entry point (`dex(www.shopify.com)`,
no lens) a complete, useful invocation on its own, rather than a degraded case that only
produces an inventory list. Rejected: "everything stays inventory-only unlensed" (the
core use case would never produce the deep analysis at all) and "unlensed runs aren't a
real case" (would make the plain invocation incomplete by design, contradicting §2).

### 3. Promotion is decided after an inventory pass, not before

`decidePromotions()` takes subjects already discovered by an inventory pass, not a
prediction of what a target will contain. More accurate — the decision runs against what
was actually found — and the inventory pass itself is useful output on its own even
before any promotion decision runs, rather than being subordinate to it.

### 4. Un-promoted subjects are always a stated limit in the deliverable

Confirmed, not reopened — the ticket's own framing already leaned this way and Dan
confirmed it directly. `promotionSummary()` states the count of inventoried-but-not-promoted
subjects and why (no framework manifest coordinate applied) whenever that count is
nonzero. Matches the honesty discipline already established by the three-state
gap-analysis rule (ADR-0013 §8) and `GAP_ANALYSIS_DISCLAIMER` (ADR-0015 §6): a reader
should never be able to assume more depth was done than actually was.

## What was built, and what was deliberately left out

`packages/dexspine-core/src/promotion.js`:

- `decidePromotions({ subjects, manifest })` — each subject carries `id`,
  `isBusinessSubject` (bool), and `manifestRelevant` (bool). A business subject is always
  promoted. A non-business subject is promoted only when a manifest is given and
  `manifestRelevant` is true. Returns `{ id, promoted, reason }` per subject.
- `promotionSummary(decisions)` — the stated-limit sentence §4 requires.

**Deliberately not decided here: manifest *relevance* itself.** Whether a discovered
subject (a checkout page, a company blog) actually touches what a given framework cares
about is a judgement call. `decidePromotions()` takes it as a caller-supplied flag rather
than inferring it — the same posture ADR-0015 §3 took toward manifest authorship itself
(agent proposes, human reviews), applied here to keep an automated relevance-inference
heuristic from being invented where none was asked for.

**Not runnable against a real target yet.** As with ADR-0015, this makes the decision
rule real and tested, not operational. There is still no filter-application generator for
a promoted subject's deep walk to produce (ADR-0013 finding F6) and no scraper to produce
the inventory pass this function consumes at all. Wiring this into an actual audit run
lands wherever `#13`'s generation gap eventually gets built.

## Alternatives rejected

- **A standing size/importance rule** (e.g. top-N discovered subjects by prominence),
  independent of any framework. Rejected — a second promotion mechanism to maintain
  alongside the manifest-driven one, for a case ("what to do on an unlensed run")
  question 2 already answers more simply.
- **Unreviewed agent judgement per engagement.** Rejected as the least mechanical, most
  variance-prone option, against a manifest-driven rule that is mechanical and reviewable.
- **Promotion decided before the walk.** Rejected — cheaper, but risks promoting or
  skipping the wrong subjects on thin information; Dan chose accuracy after a real
  inventory pass over speed.
- **Silent omission of un-promoted subjects.** Not seriously considered — the ticket's own
  framing, and this backlog's established honesty discipline, both pointed the same way.

## Consequences

- Ticket 25 is fully resolved; nothing about it remains open.
- `dexspine-core` gains `promotion.js`.
- `CONTEXT.md` gains a "promotion" entry.
- **Ticket 22 unblocks and becomes AFK-safe** (was `Depends on: 21`, `wayfinder:research`):
  the action-record shape can now be designed against a real manifest and a real
  promotion rule instead of hypotheticals for both.
- No ADR-0010 consequence — `promotion.js` has no `@dexroboknix/*` dependency; it imports
  only within `dexspine-core` itself.

## What would have to change to revisit this

A framework whose relevance to a discovered subject genuinely needs machine inference
rather than a caller-supplied judgement (e.g. a target with thousands of discovered
subjects where manual relevance-tagging is impractical) would need this revisited —
`decidePromotions()`'s contract deliberately leaves room for a smarter relevance signal to
be substituted later without changing the promotion rule itself. Building an actual
gap-analysis run may also surface cases this first pass didn't anticipate, same caveat as
ADR-0015.
