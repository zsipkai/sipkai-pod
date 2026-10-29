#!/usr/bin/env bash
# Start-of-stage check (R-8.1, R-7.2). Every stage runs it before anything else:
#
#   bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN
#
# 1. The session started in the project root, the folder that holds
#    sdlc.config.sh. A harness loads its project settings (deny rules,
#    project reviewers) only from the folder a session starts in, so a
#    stage started in a parent folder runs without them (SI-029, SI-144).
#    Run this before any `cd`; the folder you are in is the folder you
#    started in.
# 2. The story is inside its budget, or a named human decided to go on.
#    The record's `Tokens spent` lines are summed against `Budget:`; at or
#    above it, the stage stops unless a `Budget decision:` line names a
#    human and a date (SI-070).
#
# CHECK_RECORDS_DIR overrides the records folder (the process evaluations use fixtures).

set -uo pipefail
started_in="$(pwd -P)"
charter="$(cd "$(dirname "$0")/../.." && pwd)/agents/CHARTER.md"
source "$(dirname "$0")/lib.sh"
root="$(pwd -P)"
story="${1:?usage: stage-start.sh STORY-NNN}"
fail=0

# The charter comes first (R-1.1): every stage begins with its agreements in view.
if [ -f "$charter" ]; then
  echo "Team charter (sipkai-pod/agents/CHARTER.md): the best, the quickest, the cheapest, in that order. Our agreements, in priority order:"
  grep -E '^### [0-9]+\. ' "$charter" | sed 's/^### /  /'
else
  echo "FAIL  the team charter is missing: $charter"; fail=1
fi

if [ "$started_in" = "$root" ]; then
  echo "PASS  started in the project root ($root)"
else
  echo "FAIL  this session started in $started_in, not in the project root $root."
  echo "      The project's deny rules and reviewers load only for a session started in the root."
  echo "      Stop and start the stage again from $root (or from the story's worktree root)."
  fail=1
fi

record="${CHECK_RECORDS_DIR:-$SDLC_RECORDS_DIR}/${story}.md"
if [ ! -f "$record" ]; then
  echo "PASS  no change record for $story yet (planning creates it)"
else
  budget_text=$(sed -n 's/^Budget:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
  budget=$(python3 -c '
import re, sys
m = re.match(r"([0-9]+(?:\.[0-9]+)?)\s*([kKmM]?)", sys.argv[1])
if not m: print(""); sys.exit()
n = float(m.group(1)); u = m.group(2).lower()
print(int(n * (1000 if u == "k" else 1000000 if u == "m" else 1)))' "${budget_text:-x}")
  spent=$(grep -E '^Tokens spent \(' "$record" | sed -E 's/.*\):[[:space:]]*~?([0-9]+).*/\1/' | awk '{s+=$1} END {print s+0}')
  if [ -z "$budget" ]; then
    echo "FAIL  $story has no numeric Budget: line"; fail=1
  elif [ "$spent" -lt "$budget" ]; then
    echo "PASS  $story has spent $spent of its $budget token budget"
  elif grep -Eq '^Budget decision:.*[^[:space:]].*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$record"; then
    echo "PASS  $story is over budget ($spent of $budget), and a human decided to go on:"
    grep -E '^Budget decision:' "$record" | tail -n 1 | sed 's/^/      /'
  else
    echo "FAIL  $story has spent $spent of its $budget token budget (R-7.2)."
    echo "      Stop. The founder chooses: raise the budget, split the story, or escalate the tier."
    echo "      Record his answer as a new Budget: value, or as 'Budget decision: <what> — <name>, YYYY-MM-DD'."
    fail=1
  fi
fi
exit "$fail"
