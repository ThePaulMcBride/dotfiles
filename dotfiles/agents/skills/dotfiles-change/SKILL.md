---
name: dotfiles-change
description: Safe workflow for modifying this dotfiles repo and applying changes through Home Manager or system rebuilds. Use when changing files under dotfiles/, hosts/, or modules/.
---

# Dotfiles Change

This repository is the source of truth for managed configuration.

## Rules

- Prefer editing tracked files in the repo over editing live files in `$HOME`.
- Check whether a file is managed via Home Manager before changing the live copy.
- Keep host-specific differences in the appropriate host file or module.
- Make the smallest targeted change that preserves current structure.

## Before changing config

1. Identify where the setting is actually sourced from.
2. Check whether the relevant file is linked directly, symlinked out-of-store, or unmanaged.
3. If a live file differs from the repo, explain that drift before overwriting assumptions.

## Applying changes

On macOS, suggest the appropriate rebuild flow such as:

```sh
darwin-switch
```

On NixOS, suggest:

```sh
nix-switch
```

If only Home Manager-managed files are affected, mention that a rebuild or switch may be needed before the live config changes take effect.
