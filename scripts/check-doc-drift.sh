#!/usr/bin/env bash
# Sipk.ai POD documentation drift check. Fails closed.
#  1. Truth files listed in sdlc.config.sh contain no TODO or UNCONFIGURED
#     markers. Angle brackets are allowed (XML, generics, autolinks).
#  2. The project's measured doc-versus-code contracts (project_drift_checks).

set -uo pipefail
source "$(dirname "$0")/lib.sh"

fail=0
pass() { echo "PASS  $1"; }
fail_check() { echo "FAIL  $1"; fail=1; }

if ! type -P rg >/dev/null 2>&1; then
  fail_check "ripgrep (rg) is not installed, so markers cannot be checked. Run: brew install ripgrep"
  exit 1
fi

# CHECK_TRUTH_FILES (used by the evaluations) holds one path per line, so
# paths with spaces work.
if [ -n "${CHECK_TRUTH_FILES:-}" ]; then
  SDLC_TRUTH_FILES=()
  while IFS= read -r path; do
    [ -n "$path" ] && SDLC_TRUTH_FILES+=("$path")
  done <<< "$CHECK_TRUTH_FILES"
fi

for f in "${SDLC_TRUTH_FILES[@]}"; do
  [ -f "$f" ] || fail_check "truth file listed in sdlc.config.sh does not exist: $f"
done

rg -n "TODO|UNCONFIGURED" "${SDLC_TRUTH_FILES[@]}"
rc=$?
case "$rc" in
  0) fail_check "TODO or UNCONFIGURED markers remain in configured truth files (listed above)" ;;
  1) pass "configured truth files contain no TODO or UNCONFIGURED markers" ;;
  *) fail_check "ripgrep could not read every configured truth file (exit code $rc)" ;;
esac

if project_drift_checks; then
  pass "project drift checks"
else
  fail_check "project drift checks (see output above)"
fi

exit "$fail"
