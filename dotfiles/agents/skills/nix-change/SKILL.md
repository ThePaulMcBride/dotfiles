---
name: nix-change
description: Workflow for making Nix and Home Manager changes carefully, with attention to scope, reuse, and rebuild steps. Use when editing flake, hosts, or modules.
---

# Nix Change

Use this workflow when changing NixOS, nix-darwin, or Home Manager configuration.

## Scope first

Before editing, determine the right scope:

- host-specific change in `hosts/`
- reusable logic in `modules/`
- app config under `dotfiles/`

Avoid putting reusable logic directly into a host file unless it is truly host-specific.

## Change strategy

- Prefer minimal, composable changes.
- Reuse existing modules and patterns in the repo.
- Preserve formatting and style already used nearby.
- If a setting can live in managed app config instead of inline Nix, prefer the existing repo pattern.

## Validation

When practical, suggest or run the appropriate rebuild command after changes.

Examples:

```sh
darwin-switch
nix-switch
```

If a change is risky or broad, explain the expected impact before applying it.
