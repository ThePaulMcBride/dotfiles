---
name: tuicr
description: Use when the user asks to open tuicr, review changes interactively, or process comments from a tuicr review session. Launch reviews in a Zellij tab and use tuicr's review CLI to read or add comments.
---

# tuicr Review Workflow

Adapted from the official `agavra/tuicr` skill for this Zellij-based setup.

Use the TUI for the human review. Use `tuicr review` to discover sessions and process comments.

Do not start a review automatically after coding. Use this skill only when the user requests a tuicr review or asks about an existing session.

## Select the Workflow

For a user-led review of agent changes:

- Launch or find the session.
- Let the user add comments in the TUI.
- Read the comments after the user says that the review is ready.
- Do not add agent-authored comments or review your own patch preemptively.

For an agent review written into tuicr:

- Inspect the patch and prepare findings.
- Add findings only when the user explicitly requests comments in tuicr.
- Set `--username` to identify the agent.

If the request does not identify the workflow, use the user-led workflow and do not add agent comments.

## Find a Session

Determine the repository from the request, current directory, and recent file operations. Ask only when multiple plausible repositories remain.

List sessions with:

```bash
tuicr review list --repo /path/to/repo
tuicr review list --repo owner/repo
tuicr review list --all
```

A checkout path also includes pull-request sessions for its `origin` repository. A subdirectory can return `[]`, so retry with the repository root before concluding that no session exists.

Use the only relevant session when exactly one session has `"active": true`. For multiple active sessions, use the task, scope, paths, and latest activity to select one. If the evidence remains inconclusive, report the candidate slugs and do not add comments. Adding a comment to the wrong valid session can exit successfully.

## Start a Session in Zellij

If no active session exists, launch a named Zellij tab without changing the user's focus:

```bash
<skill-directory>/tuicr-wrapper-zellij.sh /path/to/repo -- -w
```

Always pass an explicit scope after `--`:

- `-w` reviews uncommitted working-tree changes.
- `-r <revset>` reviews a commit range.
- `--file <path>` reviews a file without a version-control repository.
- `-A` reviews all tracked files.

The wrapper prints the new Zellij tab ID and returns immediately. Poll `tuicr review list --repo /path/to/repo` briefly until the active session appears.

If the agent is not inside Zellij, tell the user to start tuicr in the repository. Attach to the session after the user says that it is ready.

tuicr supports Git and Jujutsu repositories. Let the wrapper check both repository types.

## Read User Comments

After the user says that comments are ready, run:

```bash
tuicr review comments --repo /path/to/repo --session <slug>
```

Process comments by type:

- `issue`: correct the problem first.
- `suggestion`: implement it or explain why it does not fit.
- `note`: answer or acknowledge it.
- `praise`: no action is necessary.

Re-read the comments after changes when the review can still be active. Compare comment IDs to avoid processing the same comment twice.

An empty comment list can represent a complete review. Use `reviewed_count` and `file_count` from `tuicr review list`. If the counts match, treat the review as complete with no findings.

## Add Agent Comments

Use line comments when a precise changed line exists:

```bash
tuicr review add --repo /path/to/repo --session <slug> \
  --target-file src/main.rs \
  --line 42 \
  --side new \
  --type issue \
  --username "OpenCode" \
  "Handle the empty case here."
```

Use `--side old` for removed lines. Use `--side new` for added or unchanged lines. Omit `--target-file` for a review-level comment.

After adding a comment, read the comments again. Make sure that the returned line exists on the selected side. tuicr can store an invisible out-of-range comment and still exit successfully.

## Reconstruct the Reviewed Diff

Use the source segment in the session slug:

| Slug segment | Command |
| --- | --- |
| `worktree/<head>` or `staged-and-unstaged/<head>` | `git diff HEAD` |
| `staged/<head>` | `git diff --cached` |
| `unstaged/<head>` | `git diff` |
| `commits/<base>..<head>` | `git diff <base>~1..<head>` |
| `pr/<n>` | `gh pr diff <n>` |

Compare the file count with the session listing. A mismatch makes derived line numbers unreliable.

## Zellij Controls

- Switch tabs with `Alt` and the arrow keys.
- Close tuicr with `q`. The wrapper closes the tab after tuicr exits.
- Toggle pane fullscreen with `Alt-f`.

## Do Not Use This Skill

- The user wants only raw `git diff` output.
- The user requests a non-tuicr review workflow.
- The task is a remote review without a tuicr session.
