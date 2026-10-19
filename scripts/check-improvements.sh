#!/usr/bin/env bash
# Sipk.ai POD improvement-log check (R-1.1, R-1.2).
# Every APPROVED or APPLIED improvement names a human approver and a date;
# an agent or model is never an approver; APPLIED rows say where they landed.
# CHECK_IMPROVEMENTS_FILE overrides the file (the process evaluations use fixtures).

set -uo pipefail
source "$(dirname "$0")/lib.sh"
file="${CHECK_IMPROVEMENTS_FILE:-sipkai-pod/IMPROVEMENTS.md}"

if [ ! -f "$file" ]; then
  echo "FAIL  improvement log $file is missing"
  exit 1
fi

fail=0
rows=0
while IFS= read -r line; do
  rows=$((rows+1))
  IFS='|' read -r _ id _ _ _ _ status approver applied _ <<< "$line"
  id=$(echo "$id" | xargs); status=$(echo "$status" | xargs)
  approver=$(echo "$approver" | xargs); applied=$(echo "$applied" | xargs)
  case "$status" in
    PROPOSED|REJECTED) ;;
    APPROVED|APPLIED)
      if [ -z "$approver" ] || [ "$approver" = "-" ] || [ "$approver" = "—" ]; then
        echo "FAIL  $id is $status without a human approver"; fail=1
      elif ! echo "$approver" | grep -Eq '[0-9]{4}-[0-9]{2}-[0-9]{2}'; then
        echo "FAIL  $id approval has no date (expected 'Name, YYYY-MM-DD')"; fail=1
      elif echo "$approver" | grep -Eiq '(^|[^a-z])(claude|gpt|chatgpt|agent|model|ai|assistant|bot|reviewer)([^a-z]|$)'; then
        echo "FAIL  $id names an agent or model as approver ('$approver'); only a human approves"; fail=1
      fi
      if [ "$status" = "APPLIED" ] && { [ -z "$applied" ] || [ "$applied" = "-" ] || [ "$applied" = "—" ]; }; then
        echo "FAIL  $id is APPLIED without saying where it landed"; fail=1
      fi
      ;;
    *) echo "FAIL  $id has unknown status '${status:-empty}' (PROPOSED, APPROVED, REJECTED or APPLIED)"; fail=1 ;;
  esac
done < <(grep -E '^\| *SI-[0-9]+' "$file")

[ "$fail" -eq 0 ] && echo "PASS  $rows improvement rows, every approval is human and dated"
exit "$fail"
