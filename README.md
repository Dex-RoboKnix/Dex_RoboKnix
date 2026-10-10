---
provenance: AAC
---

# DexRoboKnix

DexRoboKnix is the parent organisation and **L1 governance layer** for the
ecosystem: the naming conventions, provenance tags, OpenCore licensing model,
and repository structure that everything else is measured against.

L1 **defines**. It has two pillars:

- **DexRoboKnix** — governance: OpenCore licensing rules, naming, provenance
  tags, and repo structure.
- **DexSpine** — the L1 standard for deterministic human–LLM collaboration: the
  **DEX838** wire syntax, the **8:3:8** Dexfilter, and `dexspine-core` as its
  reference implementation.

## DexSpine & DEX838

DexSpine is the standard; `dexspine-core` is its reference implementation, with
its own home at **[dexspine-core](https://github.com/Dex-RoboKnix/dexspine-core)**.

- **DEX838** — the wire syntax `dex(scope, @context)["subject"]` for
  deterministic instruction exchange between a human and an LLM.
- **8:3:8 Dexfilter** — the filter shape a unit of work passes through:
  8 plan questions, 3 MVE files (`va.md`, `hu.md`, `llm.md`), 8 execute
  questions.

## OpenCore

Each layer follows the same split:

- **Core** — public / open-source implementation.
- **Enterprise** — a reserved private / commercial boundary. Private
  `*-enterprise` repos exist as placeholders only (README, LICENSE, status note);
  no product code yet. Core code must never depend on enterprise code.

The license matrix is tracked in [`OPENCORE.md`](OPENCORE.md).

## Governance Docs

- [`OPENCORE.md`](OPENCORE.md) — the OpenCore licensing model.
- [`STRUCTURE.md`](STRUCTURE.md) — repository structure.
- [`PROJECT-STATUS.md`](PROJECT-STATUS.md) — current L1 maturity.

## Layer and use

**Layer: L1** (defines). **Used by dex.md for:** the governance rules (OpenCore licensing, naming, provenance tags, layer map) that every Dex repo is measured against. Pre-1.0.

## Which document do I read?

| I want to... | Read |
|---|---|
| Know what is in every repo, and where | [`SITEMAP.md`](SITEMAP.md) |
| Understand the licensing split | [`OPENCORE.md`](OPENCORE.md) |
| See the repo structure | [`STRUCTURE.md`](STRUCTURE.md) |
| See current maturity | [`PROJECT-STATUS.md`](PROJECT-STATUS.md) |
| Build, test or scan as an LLM | [`START.md`](START.md) |
| Cut a release | [`RELEASING.md`](RELEASING.md) |
| Read the docs | [`docs/`](docs/README.md) |

## Licence

OpenCore: AGPL-3.0 Core ([`LICENSE`](LICENSE)). Governance has no Enterprise edition.
