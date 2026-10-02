# Git Safety

- Run `git commit` or `git push` only when the user explicitly requests it.
- Treat an explicit request in the current conversation as authorization. Do not request a second confirmation.
- Before a commit, inspect the diff and propose a scope-first message by following the `commit-prep` skill.
- Before a push, state the branch, remote, and whether the update is a normal or force push.
