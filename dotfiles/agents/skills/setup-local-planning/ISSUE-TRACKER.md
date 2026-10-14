# Issue Tracker: Local Markdown

All planning artifacts for this repository remain local as Markdown files in
`.scratch/`. Never publish specs, maps, tickets, comments, or planning state to
GitHub, Linear, or another remote tracker.

## Conventions

- Use one directory per effort: `.scratch/<effort-slug>/`.
- Store its specification at `.scratch/<effort-slug>/spec.md`.
- Store tickets individually under `.scratch/<effort-slug>/issues/`.
- Number tickets in dependency order: `01-<slug>.md`, `02-<slug>.md`, and so on.
- Record workflow state with a `Status:` line near the top of each ticket.
- Append discussion under an `## Comments` heading.

## Publishing and Fetching

When a skill says to publish to the issue tracker, write the corresponding file
under `.scratch/<effort-slug>/`. When a skill says to fetch a ticket, read the
referenced local file. Do not substitute a remote tracker.

## Wayfinding Operations

- **Map:** `.scratch/<effort>/map.md`.
- **Child ticket:** `.scratch/<effort>/issues/NN-<slug>.md`.
- **Type:** Record `research`, `prototype`, `grilling`, or `task` in a `Type:`
  line.
- **Status:** Record `open`, `claimed`, or `resolved` in a `Status:` line.
- **Blocking:** Record ticket numbers in a `Blocked by: NN, NN` line. Use
  `Blocked by: None` when there are no blockers.
- **Frontier:** Select the first numbered ticket that is open, unblocked, and
  unclaimed.
- **Claim:** Set `Status: claimed` before starting work.
- **Resolve:** Append the result under `## Answer`, set `Status: resolved`, and
  add a short link to the map's `Decisions so far` section.
