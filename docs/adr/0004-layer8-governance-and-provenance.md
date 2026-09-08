# ADR 0004: Layer 8 Human Governance and MVE Provenance Tracking (PHC / OHC / AAC)

- **Status**: accepted
- **Date**: 2026-07-27

## Context
DexRoboKnix emphasizes human cognitive preservation and auditability across all automated LLM workflows. Without explicit tracking, pure human insight becomes mixed with AI-synthesized outputs, obscuring original intent and decision provenance.

## Decision
We decide to enforce:
1. **Layer 8 Veto**: Human decision strictly overrides all automated agent actions, CI/CD checks, or system defaults.
2. **MVE Provenance Frontmatter**: All documentation, specifications, and architecture files must specify `provenance: PHC | OHC | AAC` in YAML frontmatter.
3. **Commit Provenance Metadata**: Agent tool commits and automated changes must specify `AAC` provenance in commit trailers.

## Consequences
- Full visibility into source material: pure human thought (`PHC`), human structured context (`OHC`), and AI-assisted collaboration (`AAC`).
- Ensures human decision authority is legally and operationally preserved across all ecosystem layers.
