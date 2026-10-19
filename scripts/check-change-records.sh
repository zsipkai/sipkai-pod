#!/usr/bin/env bash
# Sipk.ai POD change-record checker (SADR-001).
#
# A record may claim a stage only when every section up to that stage holds
# its exact success outcome, and every later section is PENDING or
# SUPERSEDED. Also enforces metadata, the routing floor (HIGH/CRITICAL run
# on `top`), no placeholders in completed sections, regression and
# deployment receipts, and a fully checked Definition of Done at DEPLOYED.
# Runs in `sdlc-gate.sh --fast`, so the pre-commit hook enforces it.
#
# CHECK_RECORDS_DIR overrides the folder (the process evaluations use fixtures).

set -uo pipefail
source "$(dirname "$0")/lib.sh"
DIR="${CHECK_RECORDS_DIR:-$SDLC_RECORDS_DIR}"

fail=0
report_fail() { echo "FAIL  $1"; fail=1; }

STAGES=(PLANNED DESIGN-VALIDATED DEVELOPED ACCEPTANCE-TEST-PROVEN REVIEW-CLEARED REGRESSION-TEST-PROVEN DEPLOYED)
KEYS=("Planning outcome" "Design outcome" "Development outcome" "Acceptance outcome" "Review outcome" "Regression outcome" "Deployment outcome")
SECTIONS=("Discovery Brief" "Design Verdict" "Implementation Record" "Acceptance Evidence" "Review Verdict" "Regression Certificate" "Deployment Record")

section_body() { awk -v h="## $2" '$0==h{on=1;next} on&&/^## /{exit} on{print}' "$1"; }
field_has_value() { grep -Eq "^- ${2}:[[:space:]]*[^[:space:]<]" "$1"; }

found=0
while IFS= read -r record; do
  found=1
  name=$(basename "$record")
  stage=$(sed -n 's/^Stage:[[:space:]]*//p' "$record" | head -n 1 | tr -d '[:space:]')
  rank=-1
  for i in "${!STAGES[@]}"; do [ "${STAGES[$i]}" = "$stage" ] && rank=$i; done
  if [ "$rank" -lt 0 ]; then report_fail "$name: unknown or missing Stage ('${stage:-none}')"; continue; fi

  grep -Eq '^# STORY-[0-9]+: [^<].+' "$record" || report_fail "$name: needs a concrete story title"
  grep -Eq '^Risk: (LOW|STANDARD|HIGH|CRITICAL)$' "$record" || report_fail "$name: needs one valid risk tier"
  grep -Eq '^Size: (S|M|L|XL)$' "$record" || report_fail "$name: needs one valid size (S|M|L|XL; XXL must be split)"
  grep -Eq '^Execution model: (small|mid|top)' "$record" || report_fail "$name: needs an execution tier (small|mid|top)"
  grep -Eq '^Budget:[[:space:]]*[0-9]' "$record" || report_fail "$name: needs a numeric Budget from the size table"
  grep -Eq '^Owner:[[:space:]]*[^[:space:]<]' "$record" || report_fail "$name: needs an accountable owner"
  grep -Eq "^Story:[[:space:]]*\`?${SDLC_STORIES_DIR}/STORY-" "$record" || report_fail "$name: needs a story path under ${SDLC_STORIES_DIR}/"
  grep -Eq '^Lane: (full|test-only|docs/process-only|hotfix|bootstrap)$' "$record" || report_fail "$name: needs one declared Lane"

  risk=$(sed -n 's/^Risk:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
  tier=$(sed -n 's/^Execution model:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
  case "$risk" in HIGH|CRITICAL)
    [ "$tier" = "top" ] || report_fail "$name: Risk $risk requires 'Execution model: top' (got '${tier:-none}') — routing rule 7";;
  esac

  for i in "${!SECTIONS[@]}"; do
    grep -Fqx "## ${SECTIONS[$i]}" "$record" || { report_fail "$name: missing section '## ${SECTIONS[$i]}'"; continue; }
    outcome=$(grep -m1 -E "^${KEYS[$i]}:" "$record" | sed "s/^${KEYS[$i]}:[[:space:]]*//" | tr -d '[:space:]')
    if [ "$i" -le "$rank" ]; then
      [ "$outcome" = "${STAGES[$i]}" ] || report_fail "$name: claims $stage but '${KEYS[$i]}' is '${outcome:-missing}', not ${STAGES[$i]}"
      if section_body "$record" "${SECTIONS[$i]}" | grep -Eq '<[^>]+>'; then
        report_fail "$name: completed section '${SECTIONS[$i]}' still has template placeholders"
      fi
    else
      case "$outcome" in PENDING|SUPERSEDED|BLOCKED) ;; *)
        report_fail "$name: claims $stage but later '${KEYS[$i]}' is '${outcome:-missing}' (must be PENDING, BLOCKED or SUPERSEDED)";;
      esac
    fi
  done

  if [ "$rank" -ge 5 ]; then
    for f in "Commit SHA" "Full gate command" "Result"; do field_has_value "$record" "$f" || report_fail "$name: Regression Certificate needs '$f'"; done
  fi
  if [ "$rank" -ge 6 ]; then
    for f in "Human deployment approval" "Required CI URL or receipt" "Merge SHA" "Live behavior observed" "Rollback status"; do
      field_has_value "$record" "$f" || report_fail "$name: Deployment Record needs '$f'"
    done
    if section_body "$record" "Definition of Done" | grep -Eq '^[[:space:]]*-[[:space:]]*\[[[:space:]]\]'; then
      report_fail "$name: DEPLOYED with unchecked Definition of Done items"
    fi
  fi
done < <(find "$DIR" -type f -name 'STORY-*.md' -print 2>/dev/null | sort)

if [ "$found" -eq 0 ]; then
  echo "PASS  no change records yet in $DIR"
elif [ "$fail" -eq 0 ]; then
  echo "PASS  every change record's stage matches its evidence"
fi
exit "$fail"
