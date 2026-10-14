---
name: setup-local-planning
description: Configure the current repository to keep Wayfinder, specs, and tickets in local-only Markdown under .scratch.
disable-model-invocation: true
---

# Set Up Local Planning

Configure the current repository for `wayfinder`, `to-spec`, `to-tickets`, and
related planning skills. Planning state must remain local under `.scratch/`.
Never publish planning artifacts to GitHub, Linear, or another remote tracker.

## Process

1. Inspect the repository before editing:
   - Find the repository root.
   - Read `AGENTS.md` and `CLAUDE.md` when present.
   - Read existing files under `docs/agents/`.
   - Check whether `.scratch/` is already ignored by Git.

2. Protect local planning data:
   - In a Git repository, run `git check-ignore --no-index .scratch/probe`.
   - If `.scratch/` is not ignored, append `.scratch/` to
     `.git/info/exclude`. Do not edit the tracked `.gitignore` for this setup.
   - Do not create `.scratch/` until a planning skill has content to store.

3. Check for conflicts:
   - If `docs/agents/issue-tracker.md` configures a remote tracker, explain that
     this setup will replace it and ask before continuing.
   - Preserve unrelated repository instructions and documentation.

4. Install the local planning configuration:
   - Copy [ISSUE-TRACKER.md](./ISSUE-TRACKER.md) to
     `docs/agents/issue-tracker.md`.
   - Copy [TRIAGE-LABELS.md](./TRIAGE-LABELS.md) to
     `docs/agents/triage-labels.md`.
   - Copy [DOMAIN.md](./DOMAIN.md) to `docs/agents/domain.md` unless that file
     already contains a repository-specific domain layout.

5. Add or update this block in the repository instruction file:

   ```markdown
   ## Agent planning

   ### Issue tracker

   Keep specs, maps, and tickets as local-only Markdown under `.scratch/`.
   Never publish planning artifacts to a remote tracker. See
   `docs/agents/issue-tracker.md`.

   ### Triage labels

   Record workflow state in each local ticket. See
   `docs/agents/triage-labels.md`.

   ### Domain docs

   Use the repository's glossary and ADRs when they exist. See
   `docs/agents/domain.md`.
   ```

   Use the existing `AGENTS.md` or `CLAUDE.md` when only one exists. Prefer
   `AGENTS.md` when both exist. If neither exists, ask which one to create and
   recommend `AGENTS.md`. Replace an existing `## Agent planning` block in
   place instead of adding a duplicate.

6. Verify:
   - Confirm `.scratch/probe` is ignored.
   - Confirm all three `docs/agents/` files exist.
   - Confirm the instruction file links to those files.
   - Report what changed. Do not create or publish a remote issue.
