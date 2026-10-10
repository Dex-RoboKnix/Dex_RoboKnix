---
provenance: AAC
---

# Sitemap

Every DexRoboKnix component and its repos. Layers per ADR-0012: L1 defines, L2 conforms, L3 is the components of exactly one L2. Every L2 product is pre-1.0 / prototype. Each component has a Core repo (AGPL-3.0) and an Enterprise repo (no Enterprise edition exists yet). Private repos need access from the owner. Public URL: to be added (no product is published as a site yet).

| Layer | Component | Core repo | Enterprise repo | dex.md uses it for |
|---|---|---|---|---|
| L1 | DexRoboKnix (governance) | [Dex_RoboKnix](https://github.com/Dex-RoboKnix/Dex_RoboKnix) (public, this repo) | none: governance has no Enterprise edition | rules, naming, provenance tags |
| L1 | DexSpine (DEX838, 8:3:8) | [dexspine-core](https://github.com/Dex-RoboKnix/dexspine-core) (public) | [dexspine-enterprise](https://github.com/Dex-RoboKnix/dexspine-enterprise) (private) | Stage 2: base questions, pinned at commit `fbcd0a89` |
| L2 | DexFolio | [dexfolio](https://github.com/Dex-RoboKnix/dexfolio) (private) | [dexfolio-enterprise](https://github.com/Dex-RoboKnix/dexfolio-enterprise) (private) | the folio builders and template, vendored in dex-md from `v0.1.0` |
| L2 | ShadowOS | [shadowos](https://github.com/Dex-RoboKnix/shadowos) (private, the app); [shadowos-core](https://github.com/Dex-RoboKnix/shadowos-core) (public) | [shadowos-enterprise](https://github.com/Dex-RoboKnix/shadowos-enterprise) (private) | Stage 6b (optional): runs `shadowos` at `v0.2.0` |
| L2 | DexCLI | [dexcli-core](https://github.com/Dex-RoboKnix/dexcli-core) (public) | [dexcli-enterprise](https://github.com/Dex-RoboKnix/dexcli-enterprise) (private) | not used directly |
| L2 | DexScape | [dexscape-core](https://github.com/Dex-RoboKnix/dexscape-core) (private, intent only) | [dexscape-enterprise](https://github.com/Dex-RoboKnix/dexscape-enterprise) (private) | not used |
| L3 of ShadowOS | ADE | [ade-core](https://github.com/Dex-RoboKnix/ade-core) (public) | [ade-enterprise](https://github.com/Dex-RoboKnix/ade-enterprise) (private) | not used directly |
| L3 of ShadowOS | shell | [shadowos-shell-core](https://github.com/Dex-RoboKnix/shadowos-shell-core) (private) | [shadowos-shell-enterprise](https://github.com/Dex-RoboKnix/shadowos-shell-enterprise) (private) | not used directly |
| L3 of ShadowOS | window manager | [shadowos-wm-core](https://github.com/Dex-RoboKnix/shadowos-wm-core) (private) | [shadowos-wm-enterprise](https://github.com/Dex-RoboKnix/shadowos-wm-enterprise) (private) | not used directly |
| L3 of ShadowOS | design system | [shadowos-design-core](https://github.com/Dex-RoboKnix/shadowos-design-core) (private) | [shadowos-design-enterprise](https://github.com/Dex-RoboKnix/shadowos-design-enterprise) (private) | not used directly |
| L3 of DexCLI | terminal | [dexcli-terminal-core](https://github.com/Dex-RoboKnix/dexcli-terminal-core) (private) | [dexcli-terminal-enterprise](https://github.com/Dex-RoboKnix/dexcli-terminal-enterprise) (private) | not used |
| L3 of DexCLI | web | [dexcli-web-core](https://github.com/Dex-RoboKnix/dexcli-web-core) (private) | [dexcli-web-enterprise](https://github.com/Dex-RoboKnix/dexcli-web-enterprise) (private) | not used |
| L3 of DexCLI | swarm worker | [dexcli-swarm-core](https://github.com/Dex-RoboKnix/dexcli-swarm-core) (private) | [dexcli-swarm-enterprise](https://github.com/Dex-RoboKnix/dexcli-swarm-enterprise) (private) | not used |

## The installer

[dex-md](https://github.com/Dex-RoboKnix/dex-md) (private) holds `dex.md`, the one-file installer, with its method, engine and skills. It is the entry point that ties the components above together: at Stage 2 it clones itself at a pinned tag and DexSpine at a pinned commit, and at Stage 6b, if wanted, ShadowOS at a pinned tag.

## Other repos

- `dexroboknix` (private): the working monorepo where the components are developed and the issues live.
- `mofmd` (private): the older MoF installer, superseded by dex-md.

Directory paths in the monorepo do not encode layers; read layers from `CONTEXT.md`.
