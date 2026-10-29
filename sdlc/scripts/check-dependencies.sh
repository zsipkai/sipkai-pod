#!/usr/bin/env bash
# Checks every dependency manifest and lockfile against the OSV
# vulnerability database with osv-scanner. Fails closed: a scanner error,
# a vulnerability, or "no packages found" while manifests exist all fail.
# Usage: bash sipkai-pod/sdlc/scripts/check-dependencies.sh [directory]   (default: repository root)

set -uo pipefail
source "$(dirname "$0")/lib.sh"
target="${1:-.}"

if ! type -P osv-scanner >/dev/null 2>&1; then
  echo "FAIL  osv-scanner is not installed. Run: brew install osv-scanner"
  exit 1
fi

manifests=$(find "$target" \( -name node_modules -o -name target -o -name cdk.out -o -name .git \) -prune -o \
  \( -name pom.xml -o -name package-lock.json -o -name requirements.txt -o -name '*.lock' \) -type f -print)

osv-scanner scan source -r --x-exclude node_modules --x-exclude target --x-exclude cdk.out "$target"
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
