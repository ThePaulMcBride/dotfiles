---
name: commit-prep
description: Prepare a clean, reviewable commit by summarizing changes, grouping related work, and proposing commit messages. Use before committing or when helping organize changes.
---

# Commit Prep

Use this workflow before creating a commit.

## Process

1. Review the current diff.
2. Identify whether the changes represent one logical unit or several.
3. Recommend splitting unrelated changes when appropriate.
4. Summarize what changed and why.
5. Identify the narrowest useful scope from the affected component, package, service, or subsystem.
6. Propose a concise, scope-first commit message.

## Guidelines

- Prefer commits that represent a single logical change.
- Call out accidental edits, noisy formatting, or unrelated churn.
- If tests were added or updated, mention that in the summary.
- If the diff is not ready to commit, explain what is still missing.

## Commit Messages

Follow repository-specific commit rules when they exist. Otherwise, use the guidance from [Stop Using Conventional Commits](https://sumnerevans.com/posts/software-engineering/stop-using-conventional-commits/):

- Use `<scope>: <imperative description>`.
- Put the affected subsystem first because scope is the most useful information in a commit log.
- Select a stable project term for the scope, such as a package, service, module, tool, or application.
- Do not prefix messages with Conventional Commit types such as `feat`, `fix`, `chore`, `docs`, or `refactor`.
- Make the description concrete enough that the nature of the change is evident without a type label.
- Write for developers who scan history, investigate failures, or identify conflicting changes.
- Use a body when the motivation, constraints, or tradeoffs are not clear from the subject and diff.
- Keep changelog and release-version decisions separate from commit messages.

Examples:

```text
agents: add shared tuicr review workflow
ghostty: map shift-backspace to forward delete
auth: reject expired refresh tokens
```
