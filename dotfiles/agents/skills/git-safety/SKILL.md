---
name: git-safety
description: Safe workflow rules for git commits, pushes, and other write operations. Use when preparing git changes, reviewing a diff, or deciding whether a git action needs confirmation.
---

# Git Safety

Follow these rules whenever git write operations are involved.

## Required confirmations

Always ask for confirmation before running any of these:

- `git commit`
- `git push`
- `git rebase`
- `git reset`
- `git checkout` that would discard work
- `git stash` when it may hide or alter in-progress work

## Before committing

1. Show the relevant diff or a concise summary of what will be committed.
2. Propose a commit message.
3. Wait for explicit approval.

## Before pushing

1. State the remote and branch.
2. Mention whether the push is expected to create, update, or force-update the remote branch.
3. Wait for explicit approval.

## General guidance

- Prefer read-only git commands first: `git status`, `git diff`, `git log`, `git branch`.
- If the repository is dirty and the user asks for a risky operation, explain the risk first.
- If there is ambiguity about the target branch, remote, or commit contents, stop and ask.
