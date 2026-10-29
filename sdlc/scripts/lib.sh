#!/usr/bin/env bash
# Shared setup for Sipk.ai POD scripts: move to the repository root and
# load the project's bridge file. Sourced, never executed directly.

SDLC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$SDLC_ROOT" || exit 1

sdlc_unconfigured() {
  echo "UNCONFIGURED: $1 — define it in sdlc.config.sh (unconfigured is never green)"
  return 1
}

# A stage with nothing to run yet, declared with its reason: green only
# until the first story has built code (a record at DEVELOPED or later).
# From then on the stage must be configured (R-3.5).
sdlc_none() {
  local reason="$1" record stage
  for record in "${SDLC_RECORDS_DIR:-.}"/STORY-*.md; do
    [ -e "$record" ] || continue
    stage=$(sed -n 's/^Stage:[[:space:]]*//p' "$record" | head -n 1 | tr -d '[:space:]')
    case "$stage" in DEVELOPED|ACCEPTANCE-TEST-PROVEN|REVIEW-CLEARED|REGRESSION-TEST-PROVEN|DEPLOYED)
      echo "UNCONFIGURED: declared none ('$reason'), but $(basename "$record" .md) has built code — configure this stage in sdlc.config.sh"
      return 1;;
    esac
  done
  echo "NONE  $reason"
  return 0
}

if [ -f sdlc.config.sh ]; then
  # shellcheck source=/dev/null
  source sdlc.config.sh
else
  echo "FAIL  sdlc.config.sh is missing at the repository root (template: sipkai-pod/templates/setup/sdlc.config.sh)"
  exit 1
fi

: "${SDLC_STORIES_DIR:?SDLC_STORIES_DIR must be set in sdlc.config.sh}"
: "${SDLC_RECORDS_DIR:?SDLC_RECORDS_DIR must be set in sdlc.config.sh}"
