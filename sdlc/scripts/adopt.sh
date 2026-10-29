#!/usr/bin/env bash
# Adopts the Sipk.ai POD in the project that includes it as sipkai-pod/.
# Creates the files the project must own and the team's workspace when they
# are missing, and prints what to do next. Safe to re-run: it never overwrites.
#
#   git submodule add https://github.com/zsipkai/sipkai-pod.git sipkai-pod
#   bash sipkai-pod/sdlc/scripts/adopt.sh

set -euo pipefail
cd "$(cd "$(dirname "$0")/../../.." && pwd)"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "This folder is not a git repository. Start with: git init && git submodule add <pod repository> sipkai-pod"
  exit 1
fi

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
create .gitleaks.toml sipkai-pod/templates/setup/gitleaks.toml
mkdir -p docs
create docs/SDLC-PROJECT.md sipkai-pod/templates/setup/SDLC-PROJECT.md
if [ ! -e CLAUDE.md ]; then
  printf '# Claude Code entry point\n\n@AGENTS.md\n' > CLAUDE.md
  echo "created  CLAUDE.md"
fi

# Claude Code: the plugin and a starting set of deny rules (adapters/claude-code/).
if [ ! -e .claude/settings.json ]; then
  mkdir -p .claude && cp sipkai-pod/adapters/claude-code/settings.json .claude/settings.json
  echo "created  .claude/settings.json (deny rules and the plugin; add the project's own private folders)"
else
  echo "kept     .claude/settings.json (add the plugin entry from sipkai-pod/adapters/claude-code/README.md if it is missing)"
fi

# The team's workspace (R-8.6), at the folders sdlc.config.sh names.
# shellcheck source=/dev/null
source sdlc.config.sh
T=sipkai-pod/templates
for dir in "$SDLC_STORIES_DIR" "$SDLC_RECORDS_DIR" "${SDLC_DECISIONS_DIR:-}" "${SDLC_LESSONS_DIR:-}" "${SDLC_REVIEWS_DIR:-}"; do
  [ -n "$dir" ] || continue
  if [ -d "$dir" ]; then echo "kept     $dir/"; else mkdir -p "$dir"; echo "created  $dir/"; fi
done
create "$SDLC_BOARD" "$T/backlog/backlog.md"
[ -n "${SDLC_PROJECT_IMPROVEMENTS:-}" ] && create "$SDLC_PROJECT_IMPROVEMENTS" "$T/improvements/IMPROVEMENTS.md"
# Every truth file the bridge names exists, so the drift check has something to read.
for f in "${SDLC_TRUTH_FILES[@]:-}"; do
  [ -n "$f" ] && [ ! -e "$f" ] || continue
  mkdir -p "$(dirname "$f")"
  printf '# %s\n\nWritten by the pod during Sprint 0 and kept current with every story.\n' "$(basename "$f" .md)" > "$f"
  echo "created  $f"
done
if [ -n "${SDLC_WORKSPACE:-}" ] && [ ! -d "$SDLC_WORKSPACE/sprint-0" ]; then
  mkdir -p "$SDLC_WORKSPACE/sprint-0/mocks"
  cp "$T"/sprint-0/*.md "$SDLC_WORKSPACE/sprint-0/"
  echo "created  $SDLC_WORKSPACE/sprint-0/ (README, release plan, architecture, design system, accesses, proof of concept)"
fi

cat <<'TEXT'

Next:
1. Commit, then run: bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast (green on day one: code stages are declared none until the first story builds code).
2. Write the product rules into AGENTS.md and the project's choices within the method into docs/SDLC-PROJECT.md.
3. Another harness than Claude Code: read sipkai-pod/adapters/README.md for what it must supply.
4. Run the bootstrap lane once, then: bash sipkai-pod/sdlc/scripts/install-hooks.sh
5. Start Sprint 0 with /sprint-zero and the project description; after it, name a story (/plan-task STORY-NNN) or approve a sprint, and the pod runs the rest.
TEXT
