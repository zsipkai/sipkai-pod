#!/usr/bin/env bash
# Fails closed when a tool the gate depends on is missing, so no check can
# silently pass because its program was never there. Install hints are printed per tool.

set -uo pipefail
source "$(dirname "$0")/lib.sh"

fail=0

require() {
  local name="$1" hint="$2" path
  path=$(type -P "$name" 2>/dev/null || true)
  if [ -n "$path" ] && [ -x "$path" ]; then
    echo "PASS  $name -> $path"
  else
    echo "FAIL  $name is not installed as a program. $hint"
    fail=1
  fi
}

require git "Install Apple's command line tools or Homebrew git."
require rg "Run: brew install ripgrep"
require gitleaks "Run: brew install gitleaks"
require osv-scanner "Run: brew install osv-scanner"
require python3 "Install Python 3."
require node "Install Node.js 22 or newer."
require java "Install Java 25 LTS (H-2)."

if path=$(type -P java 2>/dev/null) && [ -n "$path" ]; then
  major=$(java -version 2>&1 | sed -n 's/.*version "\([0-9]*\).*/\1/p' | head -n 1)
  if [ -n "$major" ] && [ "$major" -ge 25 ]; then
    echo "PASS  java major version $major (25 or newer)"
  else
    echo "FAIL  java major version is '${major:-unknown}'; 25 or newer is required (ADR-001)"
    fail=1
  fi
fi

exit "$fail"
