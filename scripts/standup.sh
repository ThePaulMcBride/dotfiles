#!/usr/bin/env bash
# Random standup order for the Journeys team.
# Usage:
#   standup                     # print randomised order
#   standup -i                  # reveal one at a time on Enter
#   standup --paul,eric         # exclude names (comma-separated)

set -euo pipefail

JOURNEYS=(kerry paul eric josh guy nick james rya jon)

interactive=false
remove=()
for arg in "$@"; do
  case "$arg" in
  -i | --interactive) interactive=true ;;
  --*) IFS=',' read -ra remove <<<"${arg#--}" ;;
  esac
done

shuf=$(command -v gshuf || command -v shuf)
mapfile -t names < <(
  printf '%s\n' "${JOURNEYS[@]}" |
    grep -vxFf <(printf '%s\n' "${remove[@]:-}") |
    "$shuf"
)

if $interactive; then
  echo "Press Enter to reveal the next name..."
  for i in "${!names[@]}"; do
    read -r _
    echo "$((i + 1)) ${names[$i]}"
  done
else
  for i in "${!names[@]}"; do
    echo "$((i + 1)) ${names[$i]}"
  done
fi
