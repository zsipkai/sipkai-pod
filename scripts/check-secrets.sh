#!/usr/bin/env bash
# Scans the working tree, and the git history when one exists, for
# credentials with gitleaks. Findings are redacted in the output.
# Usage: bash sipkai-pod/scripts/check-secrets.sh [directory]   (default: repository root)

set -uo pipefail
source "$(dirname "$0")/lib.sh"
root=$(pwd)
target="${1:-.}"

if ! type -P gitleaks >/dev/null 2>&1; then
  echo "FAIL  gitleaks is not installed. Run: brew install gitleaks"
  exit 1
fi

fail=0
gitleaks dir "$target" --config "$root/.gitleaks.toml" --no-banner --redact --log-level warn \
  || { echo "FAIL  gitleaks found a possible secret in the working tree (shown redacted above)"; fail=1; }

if [ "$target" = "." ] && git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
   && git rev-parse --verify HEAD >/dev/null 2>&1; then
  gitleaks git . --config "$root/.gitleaks.toml" --no-banner --redact --log-level warn \
    || { echo "FAIL  gitleaks found a possible secret in git history (shown redacted above)"; fail=1; }
fi

[ "$fail" -eq 0 ] && echo "PASS  no secrets found by gitleaks"
exit "$fail"
