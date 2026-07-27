# OpenCore Model

DexRoboKnix uses an OpenCore model at every active layer.

## Principle

Core repos should be usable, inspectable, and useful without Enterprise code.

Enterprise repos may add private connectors, managed deployment, commercial support, organisation controls, and customer-specific integrations.

## Repo Split

| Entity | Core | Enterprise |
| --- | --- | --- |
| DexSpine | `dexspine-core` | `dexspine-enterprise` |
| DexCLI | `dexcli-core` | `dexcli-enterprise` |
| ShadowOS | `shadowos-core` | `shadowos-enterprise` |
| ADE | `ade-core` | `ade-enterprise` |

## License Decision

Finalized via [ADR 0002](file:///C:/Users/Dan/Documents/Projects/DEXROBOKNIX/docs/adr/0002-opencore-licensing-matrix.md):

- **Core Repositories**: **AGPL-3.0** (GNU Affero General Public License v3.0).
- **Enterprise Repositories**: Commercial Proprietary EULA.

Existing MIT and PGL references in `dexcli-core` and `dexspine-core` will be updated to AGPL-3.0 prior to public repository release.


