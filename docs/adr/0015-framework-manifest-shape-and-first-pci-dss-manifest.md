# ADR 0015: Framework manifest shape, authorship, storage, and the first PCI DSS 4.0 manifest

- **Status**: accepted
- **Date**: 2026-08-14
- **Decided by**: Dan
- **Wayfinder ticket**: ticket 21, part of the
  DexProduct backlog ADR-0013 opened
- **Relationship to prior ADRs**: **completes** [ADR-0013](0013-dexproduct-is-the-audit-generator-and-dex-url-is-a-second-grammar.md)
  §8 (R8's framework-is-a-manifest correction) and §9 (ADR-0010's zero-dependency rule,
  applied here to where a manifest lives). Ticket 21 was left explicitly open by ADR-0013's
  consequences; this ADR closes it.

## Context

ADR-0013 §8 (R8) settled *what* a framework is — a manifest of spine coordinates plus a
per-coordinate bar, not a clause database — but left six concrete questions open: which
framework gets the first manifest, what a manifest entry contains, who authors one, where
it lives, whether it carries currency information, and where the "this is a gap analysis,
not a certification" boundary is stated. `RATIFICATION.md` finding F7 first raised the gap;
ticket 21 tracked it.

This ADR records the answers, reached through live one-question-at-a-time grilling on
2026-08-14 per this repo's wayfinder convention, and the code built the same session to
prove the model against a real framework.

## Decision

### 1. PCI DSS 4.0 is the first manifest

The sharpest commercial case, not the operational one (ITIL) Dan reached for when
originally explaining the lens model. It has the additional property of being the
framework whose Requirement 6.4.3 — script inventory on payment pages — directly
motivated R5's nested-bracket parser fix (ADR-0013 §5a), so the backlog's two halves
connect: the parser bug this session fixed exists because of exactly the kind of clause
text this manifest cites.

### 2. A manifest entry is human-readable, not machine-checkable

Minimum fields: `coordinate` (`{ layer, phase, point }`), `rationale` (why the framework
requires this coordinate), `passingBar` (a prose description of what a passing answer
contains), and `citation` (the specific clause). No structured, testable condition is
required — a person, or an LLM doing the gap analysis, reads the bar and judges
covered/weak/not-observable. This matches how the rest of DexSpine works today:
judgement-driven, not rule-engine-driven. Revisit if judgement-call variance in what counts
as "covered" turns out to matter more than the cost of building a rule engine.

### 3. Agent drafts, human reviews

An agent drafts a manifest — reading the actual framework's published requirements,
proposing coordinates, rationale, and citations — and a human reviews and corrects it
before it is authoritative. Chosen over Dan authoring manifests directly (slower, no
review-and-correct cycle needed but higher latency to a first proof case) and over waiting
for a client's own compliance function (safest, but blocks proving the model at all before
a real engagement exists).

**Consequence for what shipped with this ADR:** the PCI DSS 4.0 manifest
(`packages/dexspine-core/src/frameworks/pci-dss-4-0.js`) is a first draft. Its citations
name real PCI DSS 4.0 requirements, but the coordinate assignment, rationale, and passing
bar are judgement calls that have not yet been reviewed. The file's own header comment
states this plainly and must not be removed until an actual review has happened.

### 4. A manifest is inert data inside `dexspine-core`

Not a separate package, not a runtime input. A manifest is a plain JS value with zero
`@dexroboknix/*` imports — `createFrameworkManifest()` and its consumers
(`findManifestEntry`, `currencyStamp`) take a manifest as a parameter and import nothing
framework-specific. This satisfies [ADR-0010](0010-package-dependency-direction-rule.md)
trivially, because a manifest was never a dependency edge to begin with — it is data
`dexspine-core` happens to ship, the same way it ships `PlanNode` and `RowSection` as
reference domain models.

Rejected alternatives: a separate `@dexroboknix/dexspine-frameworks` package (defers
decisions the ADR-0010 boundary doesn't actually require yet, for the cost of a package to
maintain from day one over a single manifest); a runtime-supplied external file (heaviest
to build now — a loader, schema validation, no reference example shipped — for a single
proof case).

### 5. Currency is stamped on both the manifest and the deliverable

A manifest carries `version` and `reviewedAt`. `currencyStamp(manifest)` produces
`"Assessed against <name> <version>, manifest reviewed <date>."` for whatever eventually
generates a deliverable to include, so staleness is visible in the output a reader actually
sees, not only in source control history. PCI DSS 4.0 has dated, versioned requirements
(a v3.2.1 sunset already happened once), which is exactly the case this guards against.

### 6. The honest boundary lives in the tool's output

`GAP_ANALYSIS_DISCLAIMER`, a fixed string exported from `framework-manifest.js`, states
plainly that a DexProduct gap analysis is not a certification or attestation of
compliance, and that "not observable" is a finding about available public evidence, not
about the business (restating ADR-0013 §8's three-state rule at the point a deliverable
reader would actually encounter it). Chosen over engagement-letter-only, on the reasoning
that the boundary should travel with the artifact wherever it's read, not only exist in a
contract the reader may never see. Not chosen: repeating it in an engagement letter too —
Dan's answer was "in the tool's output itself," not "both."

## What this ADR does not do

**The manifest cannot yet be applied.** ADR-0013 finding F6 recorded that
`generateIntoRepo()` writes only the MVE triad — no generator exists for the 8 plan / 8
execute filter-application nodes, and finding F7 recorded that no gap-analysis apparatus
exists at all. This ADR makes the manifest *shape* and a first *instance* real and
reviewable; projecting it over an actual spine to produce covered/weak/not-observable
results is separate build work that lands wherever `#13`'s generation gap eventually gets
built. Citing this ADR when that work happens saves re-deriving the manifest contract from
scratch.

The green-team code bounds ADR-0014 §3 recorded are similarly not enforced here — there is
no scraper yet for a manifest to be projected through.

## Alternatives rejected

- **ITIL as the first manifest.** Considered — it's the worked example from ADR-0013 §4 —
  but Dan chose PCI DSS 4.0 as the sharper commercial case with a direct tie to this
  session's own parser fix.
- **Machine-checkable manifest entries.** Rejected as more work per entry than the
  judgement-driven rest of DexSpine currently does; revisit only if variance in human
  judgement about "covered" proves costly in practice.
- **Dan authors manifests directly**, or **wait for a client's compliance function.**
  Both considered; "agent drafts, Dan reviews" was chosen as the fastest path to a real,
  reviewable proof case.
- **A separate framework-manifest package, or a runtime-supplied external manifest.**
  Both considered against "inert data inside `dexspine-core`" and rejected as more
  machinery than one proof manifest needs, per the same reasoning ADR-0010 itself used to
  decline building general dependency-analysis tooling for a single protected node.
- **Currency on the manifest only, not the deliverable.** Considered as the simpler
  option; Dan chose both.
- **Engagement-letter-only, or both, for the honest-boundary disclaimer.** Considered;
  Dan's answer was output-only.

## Consequences

- Ticket 21 is fully resolved; nothing about it remains open.
- `dexspine-core` gains `framework-manifest.js` (the primitive) and
  `frameworks/pci-dss-4-0.js` (the first manifest, unreviewed — see §3).
- `CONTEXT.md` gains four entries: spine coordinate, framework, framework manifest, gap
  analysis.
- **Ticket 25 unblocks** (was `Depends on: 21`): R8's candidate promotion rule — "the
  framework manifest decides whether a discovered subject earns a filter application" —
  can now be tested against a concrete manifest instead of a hypothetical one.
- **Ticket 22 unblocks and becomes AFK-safe** (was `Depends on: 21`, `wayfinder:research`):
  safe to delegate to a background agent per `CLAUDE.md`'s wayfinder rule, now that a real
  manifest exists to design the action-record shape against.
- ADR-0010 is unchanged — §4 confirms a manifest was never the kind of thing that rule
  restricts.

## What would have to change to revisit this

A manifest entry that genuinely cannot be judged without a structured, testable rule (§2)
would need this revisited — the reasoning here explicitly leaves that door open rather
than ruling it out permanently. Building an actual filter-application generator or
gap-analysis run (the work this ADR deliberately doesn't do) may also surface shape
problems with the manifest contract that this first proof case didn't anticipate; that is
expected and is what the "unreviewed" marking on the PCI DSS manifest itself is for.
