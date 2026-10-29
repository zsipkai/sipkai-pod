#!/usr/bin/env bash
# Sipk.ai POD gate — the hard enforcement layer behind /plan-task … /deploy-change.
#
#   --fast    tools, change records, links, doc drift, secrets, improvement
#             approvals, project static
#             analysis and fast tests. Every commit (pre-commit hook).
#   --full    --fast + project build, full tests, dependency vulnerabilities,
#             Sipk.ai process evaluations. Regression proof and CI.
#   --ui      --full + project UI journeys and accessibility checks.
#   --deploy  --ui + project deployment-bound checks. /deploy-change.
#
# Fails closed: a missing tool or an unconfigured project stage fails the gate.
# A passing --full, --ui or --deploy run prints a gate receipt (commit, mode,
# result, UTC time) and appends it to build/gate-receipts.log; the Regression
# Certificate quotes it (R-2.7). A dirty tree gets no receipt: the commit
# would not be what the gate checked.
# SDLC_GATE_QUIET=1 keeps success output to one line per stage (full detail in
# build/gate-last.log); failures always print verbatim.

set -uo pipefail
source "$(dirname "$0")/lib.sh"

mode="${1:---fast}"
case "$mode" in
  --fast|--full|--ui|--deploy) ;;
  *) echo "Usage: bash sipkai-pod/scripts/sdlc-gate.sh [--fast|--full|--ui|--deploy]"; exit 2 ;;
esac

overall=0
quiet="${SDLC_GATE_QUIET:-0}"
gate_log="build/gate-last.log"
mkdir -p build; : > "$gate_log"

stage() {
  local name="$1"; shift
  local out rc
  out=$("$@" 2>&1); rc=$?
  printf '== %s ==\n%s\n' "$name" "$out" >> "$gate_log"
  if [ "$rc" -eq 0 ]; then
    if [ "$quiet" = "1" ]; then echo "  ok $name"; else echo ""; echo "== $name =="; printf '%s\n' "$out"; fi
  else
    echo ""; echo "== $name == FAILED (exit $rc)"; printf '%s\n' "$out"
    overall=1
  fi
}

S="sipkai-pod/scripts"
stage "required tools"         bash "$S/check-tools.sh"
stage "change-record states"   bash "$S/check-change-records.sh"
stage "Markdown links"         python3 "$S/check-md-links.py"
stage "documentation drift"    bash "$S/check-doc-drift.sh"
stage "secrets (gitleaks)"     bash "$S/check-secrets.sh"
stage "SDLC improvement approvals" bash "$S/check-improvements.sh"
stage "static analysis"        project_static_analysis
stage "fast tests"             project_fast_tests

if [ "$mode" != "--fast" ]; then
  stage "build"                project_build
  stage "full automated tests" project_full_tests
  stage "dependency vulnerabilities (OSV)" bash "$S/check-dependencies.sh"
  stage "Sipk.ai process evaluations"      bash sipkai-pod/evals/run-evals.sh
fi
if [ "$mode" = "--ui" ] || [ "$mode" = "--deploy" ]; then
  stage "UI journeys and accessibility" project_ui_tests
fi
if [ "$mode" = "--deploy" ]; then
  stage "deployment checks"    project_deploy_checks
fi

echo ""
if [ "$overall" -eq 0 ]; then
  echo "GATE PASSED ($mode)"
  if [ "$mode" != "--fast" ]; then
    if [ -z "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]; then
      receipt="$(git rev-parse HEAD) ${mode#--} PASS $(date -u +%Y-%m-%dT%H:%M:%SZ)"
      echo "$receipt" >> build/gate-receipts.log
      echo "Gate receipt: $receipt"
    else
      echo "No gate receipt: tracked files differ from HEAD, so the commit is not what the gate checked."
    fi
  fi
else
  echo "GATE FAILED ($mode). Fix the cause. Do not weaken the check."
fi
exit "$overall"
