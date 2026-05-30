#!/usr/bin/env bash

set -euo pipefail

steps="${1:-3}"

if ! [[ "$steps" =~ ^[0-9]+$ ]] || [[ "$steps" -lt 1 ]]; then
  echo "Usage: $(basename "$0") [N]" >&2
  echo "  N = generations back to compare (default: 3)" >&2
  exit 1
fi

current_link="$(readlink /nix/var/nix/profiles/system)"
current_gen="$(printf '%s\n' "$current_link" | sed -E 's/.*system-([0-9]+)-link/\1/')"

if ! [[ "$current_gen" =~ ^[0-9]+$ ]]; then
  echo "Could not determine current system generation." >&2
  exit 1
fi

old_gen="$((current_gen - steps))"

if [[ "$old_gen" -lt 1 ]]; then
  echo "Cannot go back $steps generations from current generation $current_gen." >&2
  exit 1
fi

old_link="/nix/var/nix/profiles/system-${old_gen}-link"

if [[ ! -e "$old_link" ]]; then
  echo "Generation link not found: $old_link" >&2
  echo "Tip: run 'sudo nix-env -p /nix/var/nix/profiles/system --list-generations'" >&2
  exit 1
fi

old_path="$(readlink -f "$old_link")"
current_path="/run/current-system"

if command -v nvd >/dev/null 2>&1; then
  exec nvd diff "$old_path" "$current_path"
else
  exec nix run nixpkgs#nvd -- diff "$old_path" "$current_path"
fi
