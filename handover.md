# DexRoboKnix Handover

Date: 2026-05-22
Prepared by: Codex
Audience: Dan, Claude, next Codex agent

## Summary

I reviewed the DexRoboKnix orientation docs, artefact register, compiled artefacts, archive folders, and the local ADE workspace. I then produced canonical content, working-system completion specs, seeded the local repo structure, copied the working artefacts into their canonical repo folders, added repo status docs and helpers, validated the copied systems where practical, and prepared a corrected GitHub publish script.

GitHub repository creation is still blocked by organisation permissions: the authenticated GitHub account `danichese` can read the `Dex-RoboKnix` org but cannot create repositories there.

## Files Created or Updated

### Project Synthesis Docs

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\DexRProject files\DR-CANONICAL-CONTENT-v1.0.md`
  - Canonical content for DexRoboKnix, DexSpine, DexCLI, ShadowOS, and ADE.
  - Includes source trails, evolution notes, gaps, contradictions, cross-entity map, gap register, and repurpose register.

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\DexRProject files\DR-WORKING-SYSTEM-SPECS-v1.0.md`
  - Completion specs for turning the artefacts into working systems.
  - Includes current state, target state, Codex build specs, acceptance criteria, dependencies, validation log, decision register, and Codex handoff prompt.
  - Corrected the ShadowOS legacy-doc paths after finding those files at the archive root rather than inside `Shadow\dexos`.

### L1 Repo Docs

Created under:

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\l1`

Files added:

- `README.md`
- `STRUCTURE.md`
- `OPENCORE.md`
- `PROJECT-STATUS.md`
- `ARTEFACT-MIGRATION.md`
- `PUBLISH-TO-GITHUB.ps1`
- `handover.md`

Purpose:

- This is the local seed for the intended `Dex_RoboKnix` GitHub repo.
- It holds the parent layer map, OpenCore notes, artefact migration map, and corrected publish helper.

## Local Repos Created

All local repos have been initialized on `main` and committed.

| Repo | Local path | Current commit | Status |
| --- | --- | --- | --- |
| `Dex_RoboKnix` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\l1` | `c555c14` before this handover commit | Clean before handover file |
| `dexspine-core` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\core` | `272e248` | Clean |
| `dexspine-enterprise` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\enterprise` | `cf48f2a` | Clean |
| `dexcli-core` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\dexcli\core` | `5738f23` | Clean |
| `dexcli-enterprise` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\dexcli\enterprise` | `f9fb7d1` | Clean |
| `shadowos-core` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\core` | `70a84a1` | Clean |
| `shadowos-enterprise` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\enterprise` | `ca05602` | Clean |
| `ade-core` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\Agent Desktop Environment\ade-core` | `548f2f3` | Clean |
| `ade-enterprise` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\Agent Desktop Environment\ade-enterprise` | `475f441` | Clean |

Note: after adding this handover file, the L1 repo has one additional commit.

## Working Artefacts Moved Into Canonical Repo Folders

| Source | Destination | Notes |
| --- | --- | --- |
| `C:\Users\Dan\Documents\Projects\DRarchive\Dex\dex\dexspine-l0` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\core` | DexSpine alpha corpus |
| `C:\Users\Dan\Documents\Projects\DRarchive\0_Dex_Roboknix_\dexrtools\dexcli\dexcli` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\dexcli\core` | DexCLI working prototype |
| `C:\Users\Dan\Documents\Projects\DRarchive\0_Dex_Roboknix_\Shadow\dexos` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\core` | ShadowOS browser desktop prototype |
| `C:\Users\Dan\Documents\Projects\DRarchive\0_Dex_Roboknix_\SHADOW_OS_TECHNICAL_SCOPE.md` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\core\docs\legacy` | Legacy technical scope |
| `C:\Users\Dan\Documents\Projects\DRarchive\0_Dex_Roboknix_\SHADOW_OS_PRODUCT_NARRATIVE.md` | `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\core\docs\legacy` | Legacy product narrative |

Generated folders such as `node_modules`, `dist`, `coverage`, `target`, and `.git` were excluded from the content copy. Dependencies were reinstalled where validation required them.

## Setup Script Review

Reviewed:

- `C:\Users\Dan\Downloads\setup-dr-repos.ps1`

Findings:

- The script is useful as a skeleton but was not run as-is.
- It creates GitHub repos and placeholder READMEs, but does not copy the real working artefacts into local repos.
- It assumes `Dex_RoboKnix` already exists, but GitHub reports it missing.
- It uses stale wording for ADE as "Autonomous Desktop Environment"; current canonical wording is "Agent Desktop Environment".
- It creates a `cartridge` artefact folder, which should remain legacy/outside canonical repo naming unless Dan explicitly revives it.

Replacement helper added:

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\l1\PUBLISH-TO-GITHUB.ps1`

This helper publishes the seeded local repos after org permissions are fixed.

## GitHub Status

GitHub CLI status:

- Authenticated account: `danichese`
- Token scopes include `repo`, `read:org`, `workflow`

Blocked action:

- Creating repos under `Dex-RoboKnix`

Error observed:

```text
GraphQL: danichese does not have the correct permissions to execute `CreateRepository` (createRepository)
```

Repos still missing remotely:

- `Dex-RoboKnix/Dex_RoboKnix`
- `Dex-RoboKnix/dexspine-core`
- `Dex-RoboKnix/dexspine-enterprise`
- `Dex-RoboKnix/dexcli-core`
- `Dex-RoboKnix/dexcli-enterprise`
- `Dex-RoboKnix/shadowos-core`
- `Dex-RoboKnix/shadowos-enterprise`
- `Dex-RoboKnix/ade-core`
- `Dex-RoboKnix/ade-enterprise`

Once Dan has org repo-creation permission, run:

```powershell
C:\Users\Dan\Documents\Projects\DEXROBOKNIX\l1\PUBLISH-TO-GITHUB.ps1
```

## Validation Performed

### DexSpine Core

Path:

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\core`

Command:

```powershell
node scripts/validate-dexspine.mjs
```

Result:

```text
DexSpine validation passed: 6 layers, 8:3:8 structure intact.
```

### DexCLI Core

Path:

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\dexspine\dexcli\core`

Commands:

```powershell
npm install
npm test
```

Result:

- Test suite passed: 4/4 checks.
- `node-pty` still prints a post-test Windows/Node 24 error:

```text
Error: AttachConsole failed
```

This is a known residual risk and should be fixed before production claims.

NPM audit note:

- `npm install` reported 1 moderate vulnerability.

### ShadowOS Core

Path:

- `C:\Users\Dan\Documents\Projects\DEXROBOKNIX\ShadowOS\core`

Commands:

```powershell
npm install
npm run build
```

Result:

- Build passed.

NPM audit note:

- `npm install` reported 16 vulnerabilities: 1 low, 5 moderate, 10 high.
- These are inherited from the prototype dependency set and should be reviewed before public release.

### ADE

Earlier validation against the parent ADE workspace passed after dependency reinstall and stale Tauri target cleanup:

- `pnpm -r build`
- `pnpm -r test`
- `pnpm biome check .`
- `cargo fmt --all --check`
- `cargo build`
- `cargo test`
- `cargo clippy -- -D warnings`

ADE core and enterprise folders were then initialized as separate local repos.

## Important Decisions Still Open

### D001 - ShadowOS/ADE Boundary

The master structure says:

- ShadowOS is the standalone desktop.
- ADE sits on top of ShadowOS and makes it agent-operable.

The ADE repo currently implements a native Tauri shell. Before major ADE Phase 1/Phase 2 work, write an ADR deciding whether:

- ADE remains L3 over ShadowOS.
- ADE becomes the native shell direction.
- ShadowOS core embeds into ADE while still remaining standalone.

### D002 - License Matrix

Sources conflict:

- ADE uses AGPL language.
- DexCLI archive has MIT.
- DexSpine DEX838 material references PGL.
- Master structure says OpenCore but does not lock exact licenses.

Dan should decide the license matrix before public repo publication.

### D003 - DexCLI Provider Scope

Working DexCLI code is Gemini-first. Canonical DexCLI is provider-agnostic. Next build step should introduce provider adapters with Gemini as the first adapter.

### D004 - ShadowOS Prototype Hardening

ShadowOS builds, but still needs:

- Canonical package rename.
- Safe persistence API.
- App registry.
- Test coverage.
- Removal of legacy/IP-adjacent visual wording.
- Security review of Electron/local server paths.

## Recommended Next Sequence

1. Fix GitHub org repo-creation permission for `danichese`.
2. Run `PUBLISH-TO-GITHUB.ps1` from the L1 repo.
3. Create an ADR for ShadowOS/ADE boundary before more ADE implementation.
4. Resolve license matrix.
5. Continue DexSpine Core:
   - Add syntax docs.
   - Add examples.
   - Extend validator/test fixtures.
6. Continue DexCLI Core:
   - Provider abstraction.
   - `node-pty` cleanup fix.
   - DexSpine packet support.
7. Continue ShadowOS Core:
   - Persistence hardening.
   - App registry.
   - Tests.
8. Continue ADE Core:
   - T045-T066 shell/control UI.
   - MCP server skeleton.
   - Permissioned tool registry.

## Good Handoff Prompt For Claude

```text
Review:
- DEXROBOKNIX/l1/handover.md
- DEXROBOKNIX/DexRProject files/DR-CANONICAL-CONTENT-v1.0.md
- DEXROBOKNIX/DexRProject files/DR-WORKING-SYSTEM-SPECS-v1.0.md

Current state:
- Local repos are seeded and committed.
- GitHub publishing is blocked by Dex-RoboKnix org CreateRepository permission.
- DexSpine validates.
- DexCLI tests pass with a known node-pty Windows cleanup issue.
- ShadowOS builds with inherited dependency vulnerabilities.
- ADE Phase 0 validated earlier; boundary decision remains critical.

Next task:
Resolve the GitHub org permission and publish the seeded repos, then create the ShadowOS/ADE boundary ADR before progressing ADE Phase 1.
```

