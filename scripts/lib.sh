#!/usr/bin/env bash
# Shared setup for Sipk.ai POD scripts: move to the repository root and
# load the project's bridge file. Sourced, never executed directly.

SDLC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$SDLC_ROOT" || exit 1

sdlc_unconfigured() {
  echo "UNCONFIGURED: $1 — define it in sdlc.config.sh (unconfigured is never green)"
  return 1
}

if [ -f sdlc.config.sh ]; then
  # shellcheck source=/dev/null
  source sdlc.config.sh
else
  echo "FAIL  sdlc.config.sh is missing at the repository root (template: sipkai-pod/templates/sdlc.config.sh)"
  exit 1
fi

: "${SDLC_STORIES_DIR:?SDLC_STORIES_DIR must be set in sdlc.config.sh}"
: "${SDLC_RECORDS_DIR:?SDLC_RECORDS_DIR must be set in sdlc.config.sh}"
