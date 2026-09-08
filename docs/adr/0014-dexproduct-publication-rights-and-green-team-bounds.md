# ADR 0014: DexProduct publication rights, disclosure route, and green-team code bounds

- **Status**: accepted
- **Date**: 2026-08-14
- **Decided by**: Dan
- **Wayfinder ticket**: ticket 24, part of the
  DexProduct backlog ADR-0013 opened
- **Relationship to prior ADRs**: **completes** [ADR-0013](0013-dexproduct-is-the-audit-generator-and-dex-url-is-a-second-grammar.md)
  §4 (full findings) and §7 (disclose first) — ticket 24 was left explicitly open by that
  ADR's consequences; this ADR closes it. Extends [ADR-0013](0013-dexproduct-is-the-audit-generator-and-dex-url-is-a-second-grammar.md)
  §3's mandatory evidence stamp from inventory nodes to filter applications.

## Context

ADR-0013 §4 (R4) ruled full findings into DexProduct's audit posture — security issues,
not only absences, about a target who has not hired the auditor. §7 (R7) paired that with
a requirement to disclose a genuine security issue to the target before it appears in any
sales material. Both left one question open: **publication**. Once a finding has been
disclosed, may it appear in public material — a site, a deck, a case study — or does full
findings mean something narrower than that?

The existing precedent, `dexspine/examples/anthropic-com-scrape/`, is published: a public
repo, a real named company, no engagement behind it. It survives because it claims only
**absences** and bounds itself explicitly in a hardcode qualifier
(`claim-bounded-to:what-is-reachable-from-the-homepage`). Under R4's wider posture the next
audit may observe and claim more than an absence, so that precedent no longer covers the
case by itself — it needed a ruling, not just an analogy.

This ADR records that ruling, reached through live one-question-at-a-time grilling on
2026-08-14 per this repo's wayfinder convention (`CLAUDE.md` § "The spine wayfinder map").

## Decision

### 1. Publication stays absences-only, permanently

**An "observed and failing" claim about a non-consenting target never appears in public
material — not a site, not a deck, not a case study — regardless of disclosure and
regardless of how much time has passed.** Public material is bounded to absences and
not-observable findings, the same class the `anthropic-com-scrape` precedent already
claims. That precedent is now the permanent rule, not an accident of one example.

R4's full-findings posture governs the **client engagement**. It does not license what
becomes marketing. The two are different audiences with different standards of consent,
and full findings for one does not imply publication rights for the other.

### 2. Disclosure route and timeline

Resolves R7's open item. Before any live run against a non-consenting target:

1. Check the target's published `security.txt` (RFC 9116) for a disclosure contact.
2. Fall back to a `security@` or `abuse@` address if no `security.txt` exists.
3. Fall back to the target's general public contact if neither exists.
4. Give a standard coordinated-disclosure timeline (e.g. 90 days) before any public
   mention of the underlying issue.

Per §1, "public mention" here is narrow: at most, that responsible disclosure occurred —
never the finding itself, before or after the timeline closes.

### 3. Green-team bounds are enforced in code, not only in policy

The audit tool is bound to the public surface **in code**: respect `robots.txt`,
rate-limit requests, read only what's reachable without authentication (homepage, public
docs, public API references). No login attempts, no probing, no fuzzing. This generalizes
the existing `claim-bounded-to:what-is-reachable-from-the-homepage` qualifier from a
one-off hardcode annotation into a standing constraint on what the tool is permitted to
do, not merely what it's permitted to claim afterward.

**Not yet built.** This ADR records the bound; enforcing it in `desugarDexInvocation()` or
wherever the scraper eventually lives is separate build work, tracked against this ADR
rather than invented ad hoc when that code is written.

### 4. Evidence stamp extends to filter applications

ADR-0013 §3 made an evidence stamp (URL + retrieval date) mandatory on inventory nodes —
`createInventoryNode()` refuses to build one without it. That requirement now extends to
filter-application findings: no claim anywhere in a DexProduct audit should ship without a
traceable evidence stamp, inventory node or full filter application alike.

**What this ADR actually makes buildable today, and what it doesn't.** Filter applications
have no generator yet — ADR-0013's own finding F6 recorded that `generateIntoRepo()`
writes only the MVE triad, and the 8 plan / 8 execute nodes are hand-authored by the agent
per `dexspine-run`'s `SKILL.md`. F7 recorded that no gap-analysis or finding apparatus
exists at all. So this ruling cannot yet be enforced by a generator that doesn't exist.
What it does now:

- Introduces a shared, reusable evidence-stamp primitive
  (`packages/dexspine-core/src/evidence-stamp.js`) rather than letting the concept live
  only inside `inventory-node.js`, so it's ready for whatever eventually generates
  filter-application findings.
- `inventory-node.js` is refactored onto the shared primitive instead of duplicating its
  validation.
- `838-scrape`'s guidance is updated to require an evidence-stamp context pair whenever the
  scraped subject is a non-consenting external target, since hand-authored filter
  applications go through `838-scrape` today.

Enforcing this at the wire-string or generator level for filter applications is real
future work. It lands wherever ADR-0013 §9's still-open `#13` (the bidirectional-build
gap, F6/F7) eventually gets built — not invented early against code that doesn't exist.

## Alternatives rejected

- **Public after disclosure plus a fix window** (standard coordinated-disclosure
  publication norm — publish once the window closes). Considered and rejected by Dan:
  public material stays absences-only regardless of whether the window has closed.
- **Engagement-only for everything, including the fact that full findings exist.**
  Rejected — narrower than what was asked; the ruling only restricts *what* can be
  claimed publicly, not whether DexProduct's methodology itself can be discussed.
- **Passive security signals in the green-team bound** (noting an already-exposed public
  misconfiguration, still without active probing). Considered; Dan chose the narrower
  "public surface only" bound instead.
- **Leaving the disclosure route unresolved** pending a live run. Considered and rejected
  — R7 already required this in writing before the first live run, and a `security.txt`
  -first route with a standard timeline is a well-trodden default that doesn't need a real
  run to validate.
- **Leaving the evidence-stamp extension for later**, keeping it inventory-node-only.
  Rejected — Dan extended the requirement now, on the reasoning that consistent
  enforcement is cheaper to build early than to retrofit once filter-application content
  exists at scale.

## Consequences

- Ticket 24 is fully resolved; nothing about it remains open.
- `dexspine-core` gains `evidence-stamp.js`, a shared primitive; `inventory-node.js` is
  refactored onto it with no behavioral change (regression-tested).
- `838-scrape`'s `SKILL.md` gains guidance requiring an evidence-stamp context pair for
  external, non-consenting-target subjects.
- The green-team code bounds (§3) and the filter-application-level evidence-stamp
  enforcement (§4) are **recorded, not built** — both require code that doesn't exist yet
  (the scraper itself, and a filter-application generator respectively). Building either
  should cite this ADR rather than re-deriving the bound from scratch.
- ADR-0010 is untouched — nothing here creates a package edge.

## What would have to change to revisit this

A client engagement whose contract explicitly grants publication rights over its own
findings would not need this ADR revisited — that is a per-engagement grant layered on
top of the default, not a change to the default itself. Revisiting the default (§1) would
need a case where absences-only publication is demonstrated to be commercially unworkable
_and_ a disclosure-and-timeline scheme robust enough to make wider publication defensible
— which is a higher bar than R7 alone cleared.
