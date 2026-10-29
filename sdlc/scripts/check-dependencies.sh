#!/usr/bin/env bash
# Checks every dependency manifest and lockfile against the OSV
# vulnerability database with osv-scanner. Fails closed: a scanner error,
# a vulnerability, or "no packages found" while manifests exist all fail.
# Usage: bash sipkai-pod/sdlc/scripts/check-dependencies.sh [directory]   (default: repository root)

set -uo pipefail
source "$(dirname "$0")/lib.sh"
target="${1:-.}"

if ! type -P osv-scanner >/dev/null 2>&1; then
  echo "FAIL  osv-scanner is not installed: https://google.github.io/osv-scanner/installation/"
  exit 1
fi

# Folders that hold downloaded or generated code; a project adds its own in
# sdlc.config.sh as SDLC_DEPENDENCY_SKIP=(...).
skip=(node_modules target build dist vendor .git "${SDLC_DEPENDENCY_SKIP[@]:-}")
prune=(); excludes=()
for d in "${skip[@]}"; do [ -n "$d" ] || continue; prune+=(-name "$d" -o); [ "$d" = .git ] || excludes+=(--x-exclude "$d"); done
unset 'prune[${#prune[@]}-1]'
manifests=$(find "$target" \( "${prune[@]}" \) -prune -o \
  \( -name pom.xml -o -name build.gradle -o -name build.gradle.kts -o -name package-lock.json -o -name requirements.txt \
     -o -name pyproject.toml -o -name go.mod -o -name Cargo.toml -o -name Gemfile -o -name '*.lock' \) -type f -print)

osv-scanner scan source -r "${excludes[@]}" "$target"
rc=$?

case "$rc" in
  0)   echo "PASS  osv-scanner found no known vulnerabilities" ;;
  1)   echo "FAIL  osv-scanner found known vulnerabilities (listed above)" ;;
  128)
    if [ -z "$manifests" ]; then
      echo "PASS  no dependency manifests exist yet, so there is nothing to scan"
      rc=0
    else
      echo "FAIL  manifests exist but osv-scanner found no packages in them:"
      echo "$manifests"
      rc=1
    fi
    ;;
  *)   echo "FAIL  osv-scanner stopped with exit code $rc" ; rc=1 ;;
esac

exit "$rc"
