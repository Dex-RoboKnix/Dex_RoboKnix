# ADR 0011: The five nested repos are publication units, and the workspace is internal

- **Status**: accepted
- **Date**: 2026-08-09
- **Decided by**: Dan
- **Wayfinder ticket**: [dexroboknix#2](https://github.com/Dex-RoboKnix/dexroboknix/issues/2), part of map [dexroboknix#1](https://github.com/Dex-RoboKnix/dexroboknix/issues/1)

## Context

Five nested git repositories sit inside the outer `dexroboknix` repo: `l1`,
`dexspine/core`, `dexspine/dexcli/core`,
`ShadowOS/Agent Desktop Environment/ade-core`, and `ShadowOS/core`. The outer
repo has no `.gitmodules` file. Ticket 01 removed the enterprise half of the
original `E1` batch; this ADR ratifies what remains.

Inspection of the actual repo state (not the ticket's description of it) found
the premise was wrong in four ways:

- There are **three** gitlinks in the index, not five: `l1`,
  `dexspine/core`, `dexspine/dexcli/core`.
- `ade-core` is not a gitlink. It is **double-tracked**: 272 files in the outer
  index as ordinary blobs, and the same files inside its own nested `.git`.
- `ShadowOS/core` is not a gitlink either. The outer repo tracks **zero** of its
  files. It is invisible to the outer repo.
- **A `.gitmodules` file alone does not repair the clone.** Two of the three
  pinned commits exist on no remote branch: `l1@23a234d` and
  `dexcli-core@419e595`. Only `dexspine/core@17b46ad` is on `origin/main`.
  Registering a submodule that points at an unpushed commit still produces a
  broken checkout.

Four inner repos hold unpushed commits: `l1` (3), `dexspine/dexcli/core` (11),
`dexspine/core` (1), `ShadowOS/core` (1). `ade-core`'s HEAD is already pushed;
its 109 modified files are working-tree only and do not affect the pin.

### Why the separation exists

The split was not an architectural choice. It was a **containment measure**
after personal information reached the main repo. `DexRProject files/` is
gitignored and was never committed — the `E6` gate held — but the concern is
live and it governs how these repos are published.

Two related concerns surfaced while checking that claim:

- `dexspine/dexcli/core/HANDOFF.md` carries 6 absolute local paths of the form
  `file:///C:/Users/Dan/…`, inside the 11 unpushed commits. Publishing those
  commits publishes the username and local directory layout.
- `l1/OPENCORE.md` line 22 carries the same pattern and is **already public**
  in commit `ca5977f` on `origin/main`. That is pre-existing exposure, tracked
  separately, and is not a blocker on this ticket.

No credentials were found. Every `API_KEY` match in the `dexcli-core` diff is an
environment-variable *name* in auth-detection logic, not a value.

### Why `packages/*` is not a competing copy

ADR-0005 places the Core Editions under `packages/`, which read as a conflict
with the nested repos. It is not one. The cross-reference notes added in `ac684e6`
already draw the distinction: `packages/dexspine-core` is the canonical **JS
runtime parser** for the DEX838 wire grammar; `dexspine/core` is the canonical
**specification authority** it implements. Two artefacts, two jobs.

## Decision

**1. The five nested repos are publication units.** Each is a separately
published GitHub repository under AGPL-3.0. That is their purpose. `packages/*`
is the internal pnpm workspace. Publication and layering are different concerns
and neither is evidence about the other.

**2. Directory nesting carries no architectural meaning.** A submodule is a
pinned commit ID. `dexspine/dexcli/core` sitting inside `dexspine/` gives DexCLI
no access to DexSpine's code or configuration, at build time or at run time.
Dependency direction is stated in ADR-0010 and nowhere else. Nobody may read
folder position as inheritance.

**3. The surgery is approved, in this order.** The order is load-bearing —
steps 1 and 2 cannot swap.

1. **Rewrite** the 11 unpushed `dexcli-core` commits so the absolute local paths
   in `HANDOFF.md` never existed. A forward-scrub commit is insufficient: git
   publishes history, not end state, so a 12th commit removing the paths still
   ships commits 1–11 containing them. These commits are unpushed, so the
   rewrite is safe — there is nothing downstream to break.
2. **Push** `l1`, `dexspine/core`, `dexspine/dexcli/core` and `ShadowOS/core`,
   so every commit a gitlink names exists on its remote.
3. **`git rm -r --cached`** the 272 double-tracked `ade-core` paths out of the
   outer index.
4. **Write `.gitmodules`** registering all five repos against their remotes:
   `Dex_RoboKnix` (l1), `dexspine-core`, `dexcli-core`, `ade-core`,
   `shadowos-core`.
5. **Archive, do not delete** — see decision 4.

**4. Nothing is deleted. Cruft is archived to local disk, outside the repo.**
Ruled by Dan, 2026-08-09: *"We don't delete anything but we can have an archive
on my local disk so the GitHub is cleaner."*

The archive lives **outside the working tree entirely** (e.g.
`C:/Users/Dan/Documents/DexRoboKnix-Archive/`), not in an in-repo `.archive/`.
Physical separation is the point: the two existing archive directories,
`.trash-01-enterprise-gitlinks/` and
`ShadowOS/Agent Desktop Environment/.trash-ticket13-14/`, are untracked but have
**no `.gitignore` entry**, so a single `git add -A` would commit them. An
in-repo archive depends on the same `.gitignore` mechanism that already failed
to catch `Project Documentation/`.

Moved to the archive: `Project Documentation/` (5 files), all three `.bak` files
under `ShadowOS/Agent Desktop Environment/docs/archive/`, the `_tmp_*` files,
and `index.test.ts.stale`. `docs/build-spec.md` stays live.

Because nothing is deleted, the human glance the ticket reserved for
`index.test.ts.stale` is moot and was dropped — no file can be lost. For the
record, the evidence was conclusive: it holds 4 `it()` blocks, all 4 appear
verbatim in its sibling `app.test.ts` (17,128 bytes, 16 blocks), and it has no
git history under the `.stale` name. It is `index.test.ts` after a rename, with
work continued in the new file.

**5. The `.bak` count in the ticket was wrong; archive all three.**
`ADE-Build-Spec-600.Spec.bak` and `ADE-Build-Spec-600.specs.bak` are
byte-identical (md5 `11f12c31…`, 86,514 bytes each). But `Architecture-Spine.bak`
(20,952 bytes) is **distinct content** the ticket never counted — deleting only
the "duplicate pair" would have left it behind. Archiving by pattern sweeps all
three. `docs/build-spec.md` (88,146 bytes, newer, evolved) stays.

**6. `Project Documentation/` is untracked and archived; its public history
stands.** All 5 files are in `HEAD` and on `origin/main` — already public.
`MVB-UK-Document-Register.md` (12,510 bytes) is a UK company-formation and tax
plan covering PSC registers, director identity verification, business bank
account opening, the £90,000 VAT threshold, and PAYE thresholds. That is
squarely the category `.gitignore` names three lines above `DexRProject files/`:
*"business strategy, personal notes… keep locally"*. The rule did not catch it
because it was committed under a different path.

Ruled by Dan: `git rm --cached` and archive, **accepting that the content stays
retrievable from public history.** A history rewrite was offered and declined —
the content is company strategy, not identity data (no address, company number,
or NI number), and a rewrite of published history costs a force-push plus a
GitHub support request to purge orphans, for a guarantee that is partial once
content has been public for weeks.

**7. The `E6` gate is re-scoped.** `E6` currently reads
`git log origin/main..main --name-only` on the **outer** repo only. Once these
five repos are submodules, four more repos push to public remotes on their own
schedule, through a door `E6` does not watch. `E6` now applies to every repo
being pushed, not the outer repo alone. This is the exact leak class the
separation was built to prevent.

## Consequences

- A fresh clone plus `git submodule update --init` produces a working tree. No
  Test A claim about cloning this repo is true before step 4 completes.
- ADR-0005 is **extended, not superseded**. `packages/*` stays the internal
  workspace; the nested repos stay the publication units.
- Execution happens on Dan's machine. The sandbox mount blocks `unlink` and has
  no push credentials.
- This ADR ratifies a decision only. A separate build ticket executes it.

## Out of scope, raised separately

A layer model was proposed during this sign-off that does not match the written
record: L3 as reusable building blocks defined at L1 and composed into L2
products; DexSpine as an *internal* L2 meta-builder that updates the *external*
L2 products; plus two entities that exist in no file — **DexScape** (a
Chromium-based browser) and **DexProduct**. This conflicts with CONTEXT.md and
ADR-0006 (which put ADE at L3 *inside* ShadowOS) and with ADR-0010 (which makes
`dexspine-core` a zero-dependency leaf its consumers pull from, not a builder
that pushes updates down). It deserves its own ADR and may supersede ADR-0006
and amend ADR-0010. It does not change the git surgery, which is why it did not
block this sign-off.

`l1/OPENCORE.md`'s already-public absolute path is likewise a separate cleanup.
