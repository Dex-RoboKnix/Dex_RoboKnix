# ADR 0013: DexProduct is the audit generator, and `dex(<url>)` is a second grammar

- **Status**: accepted
- **Date**: 2026-08-13
- **Decided by**: Dan
- **Wayfinder ticket**: [dexroboknix#14](https://github.com/Dex-RoboKnix/dexroboknix/issues/14) — **closed by this ADR**; part of map [dexroboknix#1](https://github.com/Dex-RoboKnix/dexroboknix/issues/1)
- **Relationship to prior ADRs**: **amends** [ADR-0003](0003-dexspine-syntax-standard.md) (§5 changes the parser contract; the grammar is untouched); **resolves** [ADR-0012 §8](0012-the-layer-model-l1-defines-l2-products-l3-composes-them.md), which recorded DexProduct as deferred and unratified; **leaves [ADR-0010](0010-package-dependency-direction-rule.md) unchanged** (see §9); **applies** [ADR-0004](0004-layer8-governance-and-provenance.md) (§6 stops `hu.md` claiming PHC over agent-written text)

## Context

ADR-0012 §8 recorded **DexProduct** as future work whose placement was
unresolved, on Dan's framing: *"a DexSpine of what we want the product arm to
be, and its outputs will be the L2 product layer"* — and *"not sure where it
sits."* It got a ticket, `#14`, which asked whether DexProduct is a rule, an
artefact, or both, and predicted its own answer: *"If it is the generator whose
outputs are the L2 product layer, it is the same downward arrow #13 is
designing. These two tickets may be one thing."*

On 2026-08-13 a ratification pass ran over `dexspine-core`, `dexspine-tools`,
the `838-scrape` and `dexspine-run` skills, `DEXFILTER.md`, ADR-0003 and the
128-file `dexspine/examples/` corpus. Its method was to run candidate wire
strings through the real `parseDEX838()` via
`packages/dexspine-tools/bin/parse-wire.js` rather than to read the regexes.
That distinction produced the findings: **two of the three parser defects report
`ok: true` while losing data**, so reading the code does not reveal them. Nine
findings were recorded, each with
parser output behind it.

A third thing emerged and took over. Dan's external-target use case —
`dex(www.shopify.com)` producing a spine and a framework gap analysis — turned
out to be the answer to `#14`. Eight rulings followed, recorded verbatim with
their consequences as R1–R8. This ADR
records them.

The grilling that produced R8 is the one worth reading in full. An
open/closed/tiered *registry* framing was put to Dan and rejected outright:
*"Its not that. Its essentially capturing across the defined nodes."* The
framing it replaces was wrong, and it is easy to fall back into.

## Decision

### 1. DexProduct is the L1 generator whose outputs are client-facing deliverables

DexProduct is **the generator, plus the rule for what qualifies as one of its
outputs**. `#14`'s own text was right: it is the same downward arrow `#13` is
designing, not a separate thing.

It is defined by its first use case — the external-target audit — rather than
from first principles. That is the accepted cost, and map `#1`'s
`GENERATE_OVER_SHIP` rule favours it: a thing with one working use case beats a
definition with none.

`#23` (`dex-audit` as a third skill alongside `838-scrape` and `dexspine-run`)
dissolves into this. The audit surface is DexProduct's surface; it is not an
independent question.

### 2. `dex([framework,] <url>)` is a second grammar that desugars into DEX838

**There are now two grammars in this ecosystem, and `dex(<url>)` is not
DEX838.** State this plainly wherever either grammar is documented, because the
next reader will otherwise assume one grammar and be surprised by a parse
failure that is correct behaviour:

```
{ "wire": "dex(www.shopify.com)", "ok": false,
  "error": "Invalid DEX838 wire format: dex(www.shopify.com)" }
```

That output is from the real parser and it is right. `dex(www.shopify.com)`
fails DEX838 on two counts — `DEX838_REGEX` constrains scope to `[\w-]+`, which
excludes dots, and `@context` is mandatory, not optional.

The two grammars, named:

- **DEX838** — the wire syntax `dex(scope, @context)["subject"]`. ADR-0003's
  grammar, unchanged by this ADR. It is what the 128-file corpus is written in,
  what `parseDEX838()` accepts, and what `scanForDex838()` measures conformance
  against.
- **The dex invocation** — the surface syntax `dex([framework,] <url>)`. A
  CLI/skill entry point a person types. It is **not** a wire string, is never
  stored in the corpus, and is never handed to `parseDEX838()`. It **desugars**
  into a DEX838 wire string, which is what everything downstream sees.

The desugaring rule is load-bearing and is therefore code with its own tests,
not agent judgement: the URL becomes the scope slug and the `@target:` value,
and the framework — when given — becomes `@framework:`. It is gated on §5,
because §5 is what decides whether a URL may live in a context value at all.

ADR-0003's grammar is untouched by this section and the corpus needs no
revalidation.

### 3. Two node types: the filter application and the inventory node

The standard gains a second node kind it does not have today.

- **Filter application** — the existing 19-question node: 8 plan questions, 3
  MVE files, 8 execute questions. Applied to the business itself, and to
  subjects that earn one.
- **Inventory node** — subject, link, overview, evidence stamp. Cheap, for the
  discovered product and API-doc surface.

Both get an entry in `CONTEXT.md`, which is the precedence authority for
vocabulary that spans packages (ADR-0006). A name and a definition, not just an
implementation.

**Node counts are an output of discovery, never a target.** "188 nodes for
shopify.com" is retired as a goal. The Dexfilter is fixed at 19 nodes per layer
× 6 layers = 114; 188 is not a multiple of 19 and is not reachable by sliding
the existing filter. A tool that aims at a number pads to reach it.

**What promotes an inventory node to a filter application is not settled by this
ADR.** Build the type without promotion logic.

### 4. The spine is built framework-agnostic; a framework is a lens over it

Dan, verbatim:

> "Full findings across several factors. Security for one. But compliance mostly
> as the dexspine is built so compliance can bolted on to it. For example
> `dex(ITIL, www.ebay.co.uk)` would list anything itil related if needed"

This is a design change, not only a posture ruling. The spine is built from
observed evidence with no framework in play. A framework is then applied *over*
the completed spine as a lens, named at invocation:

```
dex(www.shopify.com)          → spine, no lens
dex(ITIL, www.ebay.co.uk)     → spine + ITIL lens, listing only what ITIL touches
```

ITIL is service management, not regulation, so what is being registered is a
**framework registry**, not a compliance registry. Compliance frameworks are one
class of member alongside operational ones.

Two consequences carry the weight:

- **A spine built today can be re-lensed against a framework added next year
  without re-walking the target.** This is the strongest structural argument for
  the whole approach, and it fell out of Dan's ITIL example rather than being
  designed. It is the pitch.
- **The lens can only report what the spine captured.** A framework requirement
  with no corresponding node is itself a finding — *not observable from public
  evidence* — and that is a different result from *observed and failing*. §8
  states the three states and the rule against flattening them.

Findings may name security issues, not only absences. An absences-only posture
was recommended and Dan ruled otherwise with the reasoning above.

### 5. The parser contract changes — this amends ADR-0003

ADR-0003 established `parseDEX838()` as the single deterministic parser target.
Its **grammar** is unchanged. Its **contract** changes here, in three ways. The
128-file corpus still passes — nothing in it nests today — but the guarantee it
passes under is a different guarantee.

**5a. A hardcode qualifier may contain nested brackets.** `HARDCODE_REGEX`
(`/dex\[([^\]]*)\]/g`) stops at the first `]`, so a clause reference containing
brackets loses data and still reports `ok: true`:

```
input:    dex[must satisfy PCI DSS 4.0 req 6.4.3 [script inventory]]
captured: "must satisfy PCI DSS 4.0 req 6.4.3 [script inventory"
result:   ok: true
```

`extractWireCandidates()` in `packages/dexspine-tools/src/validate.js` already
solved this for the *outer* bracket by tracking depth, with a comment saying
exactly why. That fix moves down into the core parser and applies to both
qualifier kinds. The regex exports stay — `dexspine/dexcli/core` consumes
`HARDCODE_REGEX` for detection — but extraction no longer goes through them.

`838-scrape`'s step-4 advice to "keep hardcode qualifier bodies free of `]`" was
prose enforced by nothing. It is now enforced by the parser, so the advice goes.

**5b. A context value may contain a `:`.** Splitting each context item on every
`:` and accepting only `parts.length === 2` sends a URL down the bare-flag path
and silently discards the key:

```
input:   @target:https://www.shopify.com,mode:green
parsed:  { "target:https://www.shopify.com": true, "mode": "green" }
```

Split on the **first** `:` only. A stray second `@` is stripped from the key
rather than kept in it (`@a:1, @b:2` previously yielded the key `"@b"`).

This is what unblocks §2: a URL can live in `@target:` intact, instead of being
hand-flattened to `shopify-com` the way `anthropic-com-scrape/wires.txt` does in
all five of its wires without saying so.

**5c. A strict mode that rejects rather than silently coerces.** Lenient parsing
stays the default so the corpus and every existing consumer are unaffected.
Strict mode throws on the coercions lenient mode performs quietly: an empty
context item, a context key still carrying an `@`, a duplicate context key, and
an unterminated `dex[` or `dex(` qualifier in the subject.

**Strict mode is what makes the evidence claim honest.** A product sold on
provenance cannot ship a parser that quietly eats half a requirement.

### 6. An unanswered human node is not emitted

`generateMveFiles()` refuses to write `hu.md` without real `humanInsight`. **An
empty human node is an error, not a state** — the absence of the file is the
honest signal.

The defect this closes is the sharpest one in the tree. `mve.js` stamped
`provenance: PHC` on `hu.md` unconditionally, and `dexspine-run`'s step 2b told
the agent to pass an `UNANSWERED` placeholder when it had no human input — so
the artifact asserting the strongest human claim was the one most likely to
contain no human input, six times per 114-node walk. Under ADR-0004 the
provenance tag is the thing being sold.

**The corpus already has the convention.** `DEXFILTER_APPLICATION.md` in the
`claude-code-spine` example renders `[Human MVE](./mve/hu.md) — **UNANSWERED**`
at the index level. Absence already has a representation; it was simply not
enforced at the generator. The fix agrees with that index rather than inventing
a marker.

`dexspine-run` must handle the refusal on every unanswered node, which on an
external target is most of them. That is the point: it makes missing human input
visible at walk time.

**The 6 existing `hu.md` files in `dexspine/examples/claude-code-spine/` are out
of scope here** — whether they are corrected in place or kept as evidence of the
bug is Dan's call and is not decided by this ADR.

### 7. Disclose first, then sell

A genuine security issue found on a non-consenting target is reported to that
target through a stated route **before** it appears in any sales material.

This pairs with §4 and the two are only defensible together: full findings
without a disclosure route is a different posture than full findings with one.
The route and its timeline are needed in writing **before the first live run**,
not after.

**Publication rights are not settled by this ADR** — whether "observed and
failing" claims about a target who has not hired you may appear on a site, a
deck or a case study. The `anthropic-com-scrape` precedent is published, names a
real company, and survives because it claims only *absences* and bounds itself
in a hardcode qualifier (`claim-bounded-to:what-is-reachable-from-the-homepage`).
Under §4 the next one may claim more, so that precedent does not cover the new
case.

### 8. A framework is a manifest of node coordinates, not a clause registry

**This is the load-bearing ruling.** Dan, rejecting the open/closed/tiered
registry framing outright:

> "Its not that. Its essentially capturing across the defined nodes."

Every node in a spine already carries its own address in its wire context. From
`claude-code-spine/03_policy/plan/05_success_criteria.md`:

```
dex(cc-policy-success-criteria, @repo:claude-code,layer:policy,phase:plan,point:5)["…"]
```

`layer:policy,phase:plan,point:5` **is a coordinate**. The spine is a fixed
114-coordinate space — 6 layers × 19, of which 96 are scraped plan/execute nodes
and 18 are MVE files.

So a framework needs no clause data to function. **A framework is a manifest of
the node coordinates it requires to be populated, plus the bar a populated node
has to meet.** ITIL cares about certain Process and Procedure coordinates; PCI
DSS cares about certain Policy and Pattern ones. Clause references are
*citations attached to a manifest entry*, not the mechanism. The lens is a
projection over a coordinate space that already exists, which is precisely why
§4's re-lensing works.

Gap analysis is therefore **three states over the manifest, and they must stay
distinct in every output format**:

1. **covered** — node exists, holds evidence, meets the bar;
2. **weak** — node exists but is inferred, empty, or below the bar;
3. **not observable** — no node at that coordinate from public evidence.

State 3 is a finding about the **evidence**, not about the business. Under §4's
full-findings posture, keeping 2 and 3 apart is doing legal work, not editorial
work — flattening them into "fail" is what would make a client deliverable
indefensible.

Authoring a framework becomes a bounded, reviewable artifact — a manifest over
at most 114 coordinates — rather than an open-ended clause database nobody can
maintain.

**Which frameworks get a manifest first, who authors one, and what the
per-coordinate bar looks like are not settled by this ADR.**

### 9. ADR-0010 stands — generation writes files, which is not an import

**`@dexroboknix/dexspine-core` may declare no `@dexroboknix/*` dependency. That
rule is unchanged, permanent, and its CI check keeps running.**

Nothing in this ADR creates a package edge. DexProduct is a generator, and
ADR-0012 §10 already settled what that means: *generation writes files;
validation reviews proposals; neither is an import.* Code dependencies flow
upward, authorship and generation flow downward.

This matters most for §8. A framework manifest is data a generator reads — it
may be inert data inside `dexspine-core`, a separate package, or a runtime
input. **It may not be a package dependency of `dexspine-core`.** Where a
manifest lives is open; that it cannot be an edge is not.

Any mechanism that would require such an edge returns with its own ADR
explicitly amending ADR-0010. The door stays open; it cannot be walked through
silently.

## Alternatives rejected

- **Amending ADR-0003's grammar so `dex(<url>)` parses** — widening scope to
  admit dots and making `@context` optional. Rejected in favour of §2's
  desugaring: it keeps one wire format, leaves the 128-file corpus valid without
  revalidation, and confines the surface syntax to the entry point where a human
  actually types it.
- **An open / closed / tiered framework registry.** Rejected outright by Dan
  (§8). It asked which frameworks we hold clause text for; the real question is
  which coordinates a framework requires and what a passing answer looks like at
  each. The replaced framing is easy to fall back into and is recorded here so
  that it is not.
- **Absences-only findings.** Recommended, and overruled by Dan in §4 with the
  bolt-on-lens reasoning. §7 is what makes the wider posture defensible.
- **A `dex-audit` third skill** alongside `838-scrape` and `dexspine-run`.
  Dissolved by §1 — it is DexProduct's surface, not an independent question.
- **Leaving the parser as-is and keeping the `838-scrape` prose warning.**
  Rejected by §5: two of the three defects report `ok: true`, so a warning
  addressed to an agent is enforced by nothing and the failure is invisible.
- **A new "unanswered" marker for `hu.md`.** Rejected in §6 — the corpus's
  `DEXFILTER_APPLICATION.md` index already renders `**UNANSWERED**`, so the fix
  agrees with an existing convention instead of adding a second one.
- **Defining DexProduct from first principles** before building anything.
  Rejected under `GENERATE_OVER_SHIP`; §1 accepts definition-by-first-use-case
  as the cheaper and more testable route.

## Consequences

- **`#14` closes.** ADR-0012 §8's deferral is discharged. `#23` and the old
  ticket 17 dissolve into §1 and §2; `#18` and `#19` are resolved by §5 and §6.
- **ADR-0003 is amended, not superseded.** Its grammar stands; §5 replaces its
  parser contract. A reader of ADR-0003 alone now has a stale contract.
- **`CONTEXT.md` changes** — the precedence authority per ADR-0006, so this is
  the load-bearing edit. It gains entries for the two node types in §3 and for
  the dex invocation surface in §2, each with an `_Avoid_` list.
- **`838-scrape`'s step 4 loses its `]` warning** and `dexspine-run`'s step 2b
  loses its `UNANSWERED` placeholder instruction. Both now contradict the code.
- **`dexspine-run` produces fewer files on an unanswered walk**, by design. A
  walk that emits 114 nodes and no `hu.md` is reporting something true.
- **ADR-0010 is unchanged and no CI work falls out of this ADR.**
- **ADR-0004 is applied, not amended.** §6 stops a PHC claim being made over
  agent-written text; the provenance taxonomy itself is untouched.
- **Four questions stay open and are Dan's**: which frameworks get a manifest
  and what the per-coordinate bar is; publication rights on a non-consenting
  target; what promotes an inventory node; and what the six existing `hu.md`
  files become. None of them blocks the build work this ADR unblocks.
- **`#13` is unchanged and still open**, as is the finding underneath it:
  downward generation implements 3 of 19 node types. `generateIntoRepo()` writes
  MVE files only; the 8 plan and 8 execute nodes are hand-written by the agent
  per `dexspine-run`. Two halves of a node, two mechanisms, two different
  guarantees.

## What would have to change to revisit this

A framework that cannot be expressed as a manifest over the 114 coordinates —
one whose requirements do not land on any node address — would break §8 and the
lens model with it, and the coordinate space should be redrawn rather than the
manifest format patched. Or a DexProduct output that genuinely requires
`dexspine-core` to import another `@dexroboknix/*` package, which lands on
ADR-0010 and needs its own ADR, not an amendment here.
