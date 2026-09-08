# ADR 0017: The action record — shape, persistence, re-expression, severity, and the three gap states

- **Status**: accepted
- **Date**: 2026-08-14
- **Decided by**: agent research, per Dan's "agent drafts, Dan reviews"-flavored delegation
  (ticket 22 is `wayfinder:research`, explicitly AFK-safe once tickets 21 and 25 land —
  `CLAUDE.md` § "The spine wayfinder map")
- **Wayfinder ticket**: ticket 22, part of the
  DexProduct backlog ADR-0013 opened
- **Relationship to prior ADRs**: **consumes** [ADR-0015](0015-framework-manifest-shape-and-first-pci-dss-manifest.md)'s
  framework manifest and [ADR-0016](0016-inventory-node-promotion-rule.md)'s promotion
  rule as inputs; **encodes** [ADR-0013](0013-dexproduct-is-the-audit-generator-and-dex-url-is-a-second-grammar.md)
  §8's three gap-analysis states (R8) as real values for the first time.

## Context

`RATIFICATION.md` finding F7 recorded that the brief's core mechanic — "planning nodes
for values aren't being implemented to the standard, so it creates an action" — had no
representation anywhere in the codebase, and that `reportDivergence()`
(`packages/dexspine-tools/src/validate.js`) was a `console.log` stub that explicitly does
not call `gh`. Ticket 22 tracked the design question this leaves: what is an "action" node,
and what does it emit?

Unlike every other ticket this backlog resolved, 22 is `wayfinder:research`, not
`wayfinder:grilling` — the ticket's own note explains why: "finding-record shape is
well-trodden ground (SARIF, ASVS, OSCAL)." It became AFK-safe once tickets 21 and 25
landed, since a real framework manifest ([ADR-0015](0015-framework-manifest-shape-and-first-pci-dss-manifest.md))
and a real promotion rule ([ADR-0016](0016-inventory-node-promotion-rule.md)) exist to
design the action-record shape against instead of hypotheticals for both. This ADR records
that design, done directly rather than via live grilling, per the ticket's own type.

## Decision

### 1. An action record is not its own DEX838 wire string

An action is a finding **about** a spine coordinate, not a thing that occupies one.
Encoding it as another `dex(...)["..."]` wire string would conflate the meta-level ("here's
a gap") with the object-level (actual spine content) — exactly the confusion ADR-0013 §2
took care to avoid between the DEX838 grammar and the surface `dex(<url>)` invocation.
Instead, an action record is plain data that **references** a coordinate: `{ coordinate,
kind, state, citation, rationale, passingBar, evidence, severity, effort }`. This is the
one idea borrowed wholesale from SARIF and OSCAL's finding/result shapes: a result carries
a location pointer into the thing being assessed, it does not re-encode the assessed
content itself.

### 2. Derived on demand, never persisted

`createActionRecord()` is a pure function over a coordinate, a manifest entry, and a gap
state — it produces a record, it does not write one anywhere. Persisting action records
as their own node type would mean solving staleness (a re-walked target changes its
evidence) and reconciliation (does a new run's finding replace, merge with, or coexist
with an old one) — real problems, not justified before a real gap-analysis pipeline exists
to persist *against*. That pipeline doesn't exist yet (ADR-0013 finding F6/F7). Revisit
once it does; this ADR deliberately leaves the door open rather than closing it.

### 3. Markdown is the v1 re-expression target

The action record itself is renderer-agnostic — `renderActionRecordMarkdown()` is one
consumer of the plain data shape, not the shape itself. Markdown was chosen for v1 because
it requires no external integration to prove (unlike GitHub issues, which `gh` already
exists for elsewhere in this repo but which would commit the action-record design to one
specific tracker before any client engagement has said that's the right one), works
standalone, and matches the format the rest of this corpus already uses for every other
generated artifact (`va.md`, `llm.md`, `DEXFILTER_APPLICATION.md`). GitHub issues, CSV, and
a deck remain named future re-expression targets — nothing in the record shape blocks
building any of them later.

### 4. Severity is never asserted by the tool

The ticket's own framing settled this: "automated severity on a client's payment stack is a
liability question, not a UX one." `createActionRecord()` accepts a caller-supplied
`severity` and uses it verbatim; when none is given, the record carries an explicit
`UNASSESSED — severity requires human judgement...` marker rather than a heuristic guess.
This is the same posture ADR-0013 §6 (R6) took toward an absent `hu.md` — an absence is an
honest state, not a thing to invent — applied here as a visible marker rather than an
outright refusal, because an action record without a severity is still a useful,
completeable artifact, unlike an `hu.md` with no human content behind it at all.

### 5. R8's three gap states are now real code, and drive the record's *kind*

`GAP_STATES` (`{ COVERED, WEAK, NOT_OBSERVABLE }`) is added to `framework-manifest.js` —
the first place ADR-0013 §8's three-state model becomes an actual exported value rather
than prose and ad hoc string literals. The states drive `createActionRecord()`'s behavior
directly:

- **covered** → `createActionRecord()` returns `null`. Nothing to action when a
  requirement is met.
- **weak** → a `remediation`-kind action.
- **not-observable** → an `evidence-request`-kind action.

The distinction is not cosmetic. `renderActionRecordMarkdown()` headers a `weak` action
"Remediation needed" and a `not-observable` action "Evidence needed", and the two kinds
never share wording — an action derived from "not observable" must never read as a
remediation task, per the ticket's own explicit requirement. This is what stops the
three-state rule from being flattened at the one point in the pipeline (the client-facing
artifact) where flattening would actually cause harm.

## What was built, and what was deliberately left out

`packages/dexspine-core/src/action-record.js`: `createActionRecord()`,
`renderActionRecordMarkdown()`, `ACTION_KINDS`. `framework-manifest.js` gains
`GAP_STATES`. `CONTEXT.md` gains an "action record" entry.

**Not built:** a live pipeline producing action records from a real audit. As with ADR-0015
and ADR-0016, this ADR makes the record shape and its rendering real and tested; nothing
here calls a scraper, a filter-application generator (neither exists — F6/F7), or `gh`.
`reportDivergence()`'s stub is unchanged. Wiring `createActionRecord()` into an actual run
lands wherever `#13`'s generation gap eventually gets built.

## Alternatives rejected

- **Full SARIF or OSCAL schema adoption.** Rejected — both are built for a different
  maturity of tooling (CI-integrated static analysis; federal compliance automation) than
  a first proof case needs. Three ideas were borrowed (location-referencing, tool-agnostic
  severity, "no finding" as a normal outcome); the rest of either schema was not.
- **Persisting action records as their own node type from the start.** Rejected under the
  same reasoning ADR-0013's `GENERATE_OVER_SHIP` rule applies elsewhere: building state
  management for a problem (staleness, reconciliation) that doesn't exist yet, because the
  producing pipeline doesn't exist yet, is premature.
- **GitHub issues as the v1 re-expression target**, since `docs/agents/issue-tracker.md`
  already documents `gh` conventions this repo uses elsewhere. Rejected for v1 — it would
  commit the action-record design to one specific tracker ahead of any real engagement
  saying that's the right one; Markdown was chosen as the neutral, dependency-free default.
- **A severity heuristic** (e.g. inferring severity from the manifest entry or the gap
  state). Rejected outright by the ticket's own framing — this is a liability question,
  and heuristic severity on a payment-stack audit is exactly the kind of claim that needs a
  human, not an inference.

## Consequences

- Ticket 22 is resolved. This closes the last open ticket on the DexProduct backlog opened
  by ADR-0013 (`21`, `24`, `25`, `19a`, `22` — all now resolved).
- `dexspine-core` gains `action-record.js`; `framework-manifest.js` gains `GAP_STATES`.
- `CONTEXT.md` gains an "action record" entry.
- No ADR-0010 consequence — `action-record.js` has no `@dexroboknix/*` dependency.
- `#13` (bidirectional build, F6/F7) remains the single standing piece of unbuilt
  apparatus every ADR in this backlog — 0013 through 0017 — ultimately defers to. Nothing
  here changes that; it is named consistently across all five so the next reader does not
  have to piece it together from five separate documents.

## What would have to change to revisit this

A real gap-analysis run producing enough action records that manual Markdown review
becomes impractical would need persistence (§2) and a second re-expression target (§3)
revisited together — the two are coupled, since a persisted record is what a GitHub-issue
or CSV export would actually read from. Neither is worth building speculatively before
that volume exists.
