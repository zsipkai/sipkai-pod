#!/usr/bin/env bash
# Installs the Sipk.ai POD pre-commit hook. Run once per clone, and only
# after the project's fast gate is configured and green (bootstrap lane).

set -euo pipefail
cd "$(cd "$(dirname "$0")/../.." && pwd)"

if [ ! -d .git ]; then
  echo "Run this installer from a normal git checkout."
  exit 1
fi

hook=.git/hooks/pre-commit
cp sipkai-pod/scripts/pre-commit "$hook"
chmod +x "$hook"
echo "Installed $hook"
echo "Required CI must run the same gate (sipkai-pod/scripts/sdlc-gate.sh) before you rely on it for team policy."
