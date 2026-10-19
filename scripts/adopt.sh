#!/usr/bin/env bash
# Adopts the Sipk.ai POD in the project that includes it as sipkai-pod/.
# Creates the two files the project must own when they are missing and
# prints what to do next. Safe to re-run: it never overwrites.
#
#   git submodule add https://github.com/zsipkai/sipkai-pod.git sipkai-pod
#   bash sipkai-pod/scripts/adopt.sh

set -euo pipefail
cd "$(cd "$(dirname "$0")/../.." && pwd)"

create() {
  local target="$1" source="$2"
  if [ -e "$target" ]; then
    echo "kept     $target (already there)"
  else
    cp "$source" "$target"
    echo "created  $target"
  fi
}

create sdlc.config.sh sipkai-pod/templates/sdlc.config.sh
create AGENTS.md sipkai-pod/templates/AGENTS.md
if [ ! -e CLAUDE.md ]; then
  printf '# Claude Code entry point\n\n@AGENTS.md\n' > CLAUDE.md
  echo "created  CLAUDE.md"
fi

cat <<'TEXT'

Next:
1. Fill sdlc.config.sh: folders, truth files and the gate stages (unconfigured stages fail on purpose).
2. Write the product rules into AGENTS.md and the project's choices within the method into docs/SDLC-PROJECT.md.
3. Load the plugin in Claude Code by adding this to .claude/settings.json:
   {
     "extraKnownMarketplaces": {
       "sipkai-pod": { "source": { "source": "directory", "path": "./sipkai-pod" } }
     },
     "enabledPlugins": { "sipkai-pod@sipkai-pod": true }
   }
4. Run the bootstrap lane once, then: bash sipkai-pod/scripts/install-hooks.sh
5. Work one story at a time: /plan-task STORY-NNN
TEXT
