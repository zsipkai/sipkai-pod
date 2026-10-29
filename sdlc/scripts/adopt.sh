#!/usr/bin/env bash
# Adopts the Sipk.ai POD in the project that includes it as sipkai-pod/.
# Creates the files the project must own and the team's workspace when they
# are missing, and prints what to do next. Safe to re-run: it never overwrites.
#
#   git submodule add https://github.com/zsipkai/sipkai-pod.git sipkai-pod
#   bash sipkai-pod/sdlc/scripts/adopt.sh

set -euo pipefail
cd "$(cd "$(dirname "$0")/../../.." && pwd)"

create() {
  local target="$1" source="$2"
  if [ -e "$target" ]; then
    echo "kept     $target (already there)"
  else
    cp "$source" "$target"
    echo "created  $target"
  fi
}

create sdlc.config.sh sipkai-pod/templates/setup/sdlc.config.sh
create AGENTS.md sipkai-pod/templates/setup/AGENTS.md
if [ ! -e CLAUDE.md ]; then
  printf '# Claude Code entry point\n\n@AGENTS.md\n' > CLAUDE.md
  echo "created  CLAUDE.md"
fi

# The team's workspace (R-8.19), at the folders sdlc.config.sh names.
# shellcheck source=/dev/null
source sdlc.config.sh
T=sipkai-pod/templates
for dir in "$SDLC_STORIES_DIR" "$SDLC_RECORDS_DIR" "${SDLC_DECISIONS_DIR:-}" "${SDLC_LESSONS_DIR:-}" "${SDLC_REVIEWS_DIR:-}"; do
  [ -n "$dir" ] || continue
  if [ -d "$dir" ]; then echo "kept     $dir/"; else mkdir -p "$dir"; echo "created  $dir/"; fi
done
create "$SDLC_BOARD" "$T/backlog/backlog.md"
[ -n "${SDLC_PROJECT_IMPROVEMENTS:-}" ] && create "$SDLC_PROJECT_IMPROVEMENTS" "$T/improvements/IMPROVEMENTS.md"
if [ -n "${SDLC_WORKSPACE:-}" ] && [ ! -d "$SDLC_WORKSPACE/sprint-0" ]; then
  mkdir -p "$SDLC_WORKSPACE/sprint-0/mocks"
  cp "$T"/sprint-0/*.md "$SDLC_WORKSPACE/sprint-0/"
  echo "created  $SDLC_WORKSPACE/sprint-0/ (README, release plan, architecture, design system, accesses, proof of concept)"
fi

cat <<'TEXT'

Next:
1. Fill sdlc.config.sh: the gate stages and the truth files (unconfigured stages fail on purpose).
2. Write the product rules into AGENTS.md and the project's choices within the method into docs/SDLC-PROJECT.md.
3. Load the plugin in Claude Code by adding this to .claude/settings.json:
   {
     "extraKnownMarketplaces": {
       "sipkai-pod": { "source": { "source": "directory", "path": "./sipkai-pod" } }
     },
     "enabledPlugins": { "sipkai-pod@sipkai-pod": true }
   }
4. Run the bootstrap lane once, then: bash sipkai-pod/sdlc/scripts/install-hooks.sh
5. Start Sprint 0 with /sprint-zero and the project description; after it, name a story (/plan-task STORY-NNN) or approve a sprint, and the pod runs the rest.
TEXT
