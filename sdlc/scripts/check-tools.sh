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

require git "Install git: https://git-scm.com/downloads"
require rg "Install ripgrep: https://github.com/BurntSushi/ripgrep#installation"
require gitleaks "Install gitleaks: https://github.com/gitleaks/gitleaks#installing"
require osv-scanner "Install osv-scanner: https://google.github.io/osv-scanner/installation/"
require python3 "Install Python 3: https://www.python.org/downloads/"
# The project's own tools and versions (a language runtime, a build tool)
# live in sdlc.config.sh as project_tool_checks, which uses `require`.
if declare -F project_tool_checks >/dev/null; then
  project_tool_checks || fail=1
fi

exit "$fail"
