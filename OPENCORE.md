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

License is not finalized across the ecosystem.

Known source signals:

- ADE source currently uses AGPL language.
- DexCLI archive includes an MIT license file.
- DexSpine DEX838 material references PGL.
- The master structure defines OpenCore but does not lock the exact license matrix.

Until Dan resolves this, public repos should say `License TBD` or preserve their existing license while clearly marking it as subject to final matrix review.

