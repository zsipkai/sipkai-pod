#!/usr/bin/env bash
# Dependency lane check (R-4.1, SI-184). A lockfile-only update takes the
# dependency lane only when this passes on its committed story branch:
#
#   bash sipkai-pod/sdlc/scripts/check-dependency-lane.sh
#
# 1. Every changed file is a lockfile or the story's own paperwork (records,
#    stories, the board, an IMPROVEMENTS.md). A manifest, code or
#    configuration change takes the full route.
# 2. The lockfiles still satisfy their manifests: project_lock_check.
# 3. The shipped build is byte-identical to main's: project_build_fingerprint,
#    run here and in a throwaway worktree of main.
# 4. The dependency scan is green: check-dependencies.sh.
#
# The last line is the receipt the record quotes. Any refusal: the full route.

set -uo pipefail
S="$(cd "$(dirname "$0")" && pwd)"
source "$S/lib.sh"
main="${SDLC_MAIN_BRANCH:-main}"
fail=0
refuse() { echo "FAIL  $1"; fail=1; }

lockfiles='(^|/)(package-lock\.json|npm-shrinkwrap\.json|yarn\.lock|pnpm-lock\.yaml|poetry\.lock|uv\.lock|Pipfile\.lock|Cargo\.lock|go\.sum|Gemfile\.lock|composer\.lock|gradle\.lockfile|packages\.lock\.json)$'
changed=$(git diff --name-only "$main"...HEAD)
printf '%s\n' "$changed" | grep -Eq "$lockfiles" || refuse "no lockfile changed against $main"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  printf '%s\n' "$f" | grep -Eq "$lockfiles" && continue
  case "$f" in "$SDLC_RECORDS_DIR"/*|"$SDLC_STORIES_DIR"/*|*IMPROVEMENTS.md) continue ;; esac
  [ "$f" = "${SDLC_BOARD:-}" ] && continue
  refuse "$f changed, and it is neither a lockfile nor the story's paperwork"
done <<< "$changed"
[ "$fail" -eq 0 ] && echo "PASS  only lockfiles and the story's paperwork changed"

if ! declare -F project_lock_check >/dev/null; then
  refuse "UNCONFIGURED: project_lock_check — define it in sdlc.config.sh"
elif project_lock_check >/dev/null 2>&1; then
  echo "PASS  the lockfiles satisfy their manifests"
else
  refuse "a lockfile does not satisfy its manifest (project_lock_check)"
fi

if ! declare -F project_build_fingerprint >/dev/null; then
  refuse "UNCONFIGURED: project_build_fingerprint — define it in sdlc.config.sh"
else
  here=$(project_build_fingerprint 2>/dev/null) || refuse "project_build_fingerprint failed on HEAD"
  base="$(mktemp -d)/main"
  if git worktree add -q --detach "$base" "$main" >/dev/null 2>&1; then
    there=$(cd "$base" && project_build_fingerprint 2>/dev/null) || refuse "project_build_fingerprint failed on $main"
    git worktree remove --force "$base" >/dev/null 2>&1
  else
    refuse "cannot check out $main to compare the build"
  fi
  if [ -n "${here:-}" ] && [ "${here:-}" = "${there:-}" ]; then
    echo "PASS  the shipped build is byte-identical to $main's ($here)"
  else
    refuse "the shipped build differs from $main's ('${there:-none}' there, '${here:-none}' here)"
  fi
fi

scan=$(bash "$S/check-dependencies.sh" 2>&1); rc=$?
if [ "$rc" -eq 0 ]; then echo "PASS  the dependency scan is green"; else printf '%s\n' "$scan" | tail -n 5; refuse "the dependency scan is not green"; fi

if [ "$fail" -eq 0 ]; then
  echo "DEPENDENCY LANE PASS $(git rev-parse --short HEAD) $(date -u +%Y-%m-%dT%H:%MZ)"
else
  echo "DEPENDENCY LANE REFUSED: take the full route (R-4.1)"
fi
exit "$fail"
