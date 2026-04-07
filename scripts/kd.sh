#!/usr/bin/env bash

set -euo pipefail

usage="Usage: $(basename "$0") -e ENV [diff|apply] [HELMFILE_OPTS...]"

for candidate in \
  kubernetes/helmfile.yaml \
  kubernetes/helmfile.yml \
  kubernetes/helmfile.yaml.gotmpl \
  kubernetes/helmfile.yml.gotmpl; do
  if [[ -f "$candidate" ]]; then
    helmfile="$candidate"
    break
  fi
done

: "${helmfile:?Could not find a helmfile in kubernetes/}"
branch="${GIT_COMMIT:-origin/main}"
selector=()

while getopts ":he:l:" opt; do
  case "$opt" in
  h)
    echo "$usage"
    exit
    ;;
  e)
    env="$OPTARG"
    ;;
  l)
    selector=(-l "$OPTARG")
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))

case "$1" in
diff | apply)
  op="$1"
  shift
  ;;
esac

git fetch -q

GIT_COMMIT="$(git rev-parse "$branch")"
export GIT_COMMIT

echo "Helmfile: $helmfile" >&2
echo "Branch:   $branch" >&2
echo "Revision: $GIT_COMMIT" >&2
sleep 2

set -x
exec helmfile -f "$helmfile" -e "$env" "${selector[@]}" "$op" --context=3 "$@"
