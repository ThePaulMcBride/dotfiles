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
5. Propose a concise commit message.

## Guidelines

- Prefer commits that represent a single logical change.
- Call out accidental edits, noisy formatting, or unrelated churn.
- If tests were added or updated, mention that in the summary.
- If the diff is not ready to commit, explain what is still missing.
