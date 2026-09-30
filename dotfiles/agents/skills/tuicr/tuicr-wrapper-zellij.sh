#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: tuicr-wrapper-zellij.sh [directory] -- <tuicr-args...>

Open tuicr in a new Zellij tab without changing the current focus.

Examples:
  tuicr-wrapper-zellij.sh . -- -w
  tuicr-wrapper-zellij.sh ~/project -- -r main..HEAD
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -z "${ZELLIJ:-}" ]]; then
  printf 'tuicr: the current shell is not inside Zellij\n' >&2
  exit 1
fi

for command in zellij tuicr; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'tuicr: required command not found: %s\n' "$command" >&2
    exit 1
  fi
done

target="."
if [[ -n "${1:-}" && "${1:-}" != "--" ]]; then
  target="$1"
  shift
fi

if [[ "${1:-}" == "--" ]]; then
  shift
fi

if [[ "$#" -eq 0 ]]; then
  printf 'tuicr: pass an explicit review scope after --\n' >&2
  usage >&2
  exit 1
fi

target=$(cd "$target" && pwd)

if [[ "${1:-}" != "--file" ]] && ! git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
  if ! command -v jj >/dev/null 2>&1 || ! jj --repository "$target" --ignore-working-copy root >/dev/null 2>&1; then
    printf 'tuicr: not a Git or Jujutsu repository: %s\n' "$target" >&2
    exit 1
  fi
fi

repo_name=$(basename "$target")
tab_name="review-${repo_name//[^[:alnum:]_-]/-}"
tab_id=$(zellij action new-tab \
  --no-focus \
  --close-on-exit \
  --cwd "$target" \
  --name "$tab_name" \
  -- tuicr "$@")

printf 'tuicr: opened Zellij tab %s (%s) for %s\n' "$tab_id" "$tab_name" "$target"
