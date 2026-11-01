#!/usr/bin/env bash
# Sipk.ai POD change-record checker (SADR-001).
#
# A record may claim a stage only when every section up to that stage holds
# its exact success outcome, and every later section is PENDING or
# SUPERSEDED. Also enforces metadata, the routing floor (HIGH/CRITICAL run
# on `top`), no placeholders in completed sections, regression and
# deployment receipts, and a fully checked Definition of Done at DEPLOYED.
# Since 2.2 also: size as the route (R-2.8, since 2.6), the declared second
# opinion (R-6.2), the gate receipt behind a Regression Certificate (R-2.2)
# and the raised budget (R-7.2); since 2.8 the record's length by size
# (R-2.1) and the 'Found only by:' line in each verdict (R-10.2); since 2.9 the
# dependency lane's size and receipt (R-4.1). Records listed in SDLC_LEGACY_RECORDS
# (sdlc.config.sh) were finished before 2.2 and keep the old checks only.
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

SKILLS=(plan-task validate-design develop-code test-acceptance clear-review test-regression deploy-change)
LEGACY=" ${SDLC_LEGACY_RECORDS:-} "

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
  grep -Eq '^Size: (S|M|L|XL)([[:space:]]+—[[:space:]]+[^[:space:]<].*)?$' "$record" || report_fail "$name: needs one valid size (S|M|L|XL; XXL must be split)"
  grep -Eq '^Execution model: (small|mid|top)' "$record" || report_fail "$name: needs an execution tier (small|mid|top)"
  grep -Eq '^Budget:[[:space:]]*[0-9]' "$record" || report_fail "$name: needs a numeric Budget from the size table"
  grep -Eq '^Owner:[[:space:]]*[^[:space:]<]' "$record" || report_fail "$name: needs an accountable owner"
  grep -Eq "^Story:[[:space:]]*\`?${SDLC_STORIES_DIR}/STORY-" "$record" || report_fail "$name: needs a story path under ${SDLC_STORIES_DIR}/"
  grep -Eq '^Lane: (full|test-only|docs/process-only|hotfix|dependency|bootstrap)$' "$record" || report_fail "$name: needs one declared Lane"

  risk=$(sed -n 's/^Risk:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
  tier=$(sed -n 's/^Execution model:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
  case "$risk" in HIGH|CRITICAL)
    [ "$tier" = "top" ] || report_fail "$name: Risk $risk requires 'Execution model: top' (got '${tier:-none}') — routing rule 7";;
  esac
  lane=$(sed -n 's/^Lane:[[:space:]]*//p' "$record" | head -n 1 | tr -d '[:space:]')
  size=$(sed -n 's/^Size:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')

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
  id="${name%.md}"
  if [[ "$LEGACY" != *" $id "* ]]; then
    # Size is the route (R-2.8): a CRITICAL story is always planned as XL.
    if [ "$risk" = "CRITICAL" ] && [ "$size" != "XL" ]; then
      report_fail "$name: a CRITICAL story is always planned as XL (got Size '${size:-none}') — R-2.8"
    fi
    # Declared second opinion (R-6.2): on the diff above LOW risk for every size, and on the design too for XL.
    if [ "$risk" != "LOW" ]; then
      if [ "$lane" = "full" ] && [ "$size" = "XL" ] && [ "$rank" -ge 1 ] && ! section_body "$record" "Design Verdict" | grep -Eq '^Second opinion:[[:space:]]*[^[:space:]<]'; then
        report_fail "$name: Design Verdict needs a 'Second opinion:' line (the X-n findings, or 'skipped' with the reason) — R-6.2"
      fi
      if [ "$lane" = "full" ] && [ "$rank" -ge 4 ] && ! section_body "$record" "Review Verdict" | grep -Eq '^Second opinion:[[:space:]]*[^[:space:]<]'; then
        report_fail "$name: Review Verdict needs a 'Second opinion:' line (the X-n findings, or 'skipped' with the reason) — R-6.2"
      fi
    fi
    # The certificate's commit exists and carries the gate's own receipt (R-2.2).
    if [ "$rank" -ge 5 ]; then
      sha=$(sed -n 's/^- Commit SHA:[[:space:]]*//p' "$record" | head -n 1 | grep -oE '[0-9a-f]{7,40}' | head -n 1)
      receipt=$(sed -n 's/^- Gate receipt:[[:space:]]*//p' "$record" | head -n 1 | tr -d '`')
      receipt_sha=$(echo "$receipt" | awk '{print $1}')
      if [ -z "$sha" ]; then
        report_fail "$name: Regression Certificate's Commit SHA is not a commit id — R-2.2"
      elif ! git cat-file -e "${sha}^{commit}" 2>/dev/null; then
        report_fail "$name: Regression Certificate names commit $sha, which this repository does not have — R-2.2"
      fi
      if [ -z "$receipt" ]; then
        report_fail "$name: Regression Certificate needs '- Gate receipt:', the line the gate printed — R-2.2"
      elif ! echo "$receipt" | grep -q ' PASS '; then
        report_fail "$name: the gate receipt does not record a pass ('$receipt') — R-2.2"
      elif [ -n "$sha" ] && [[ "$receipt_sha" != "$sha"* ]] && [[ "$sha" != "$receipt_sha"* ]]; then
        report_fail "$name: the gate receipt is for $receipt_sha, the certificate names $sha — R-2.2"
      fi
    fi
    # The dependency lane (R-4.1, SI-184): Size S, and from DEVELOPED the receipt of check-dependency-lane.sh.
    if [ "$lane" = "dependency" ]; then
      [ "$size" = "S" ] || report_fail "$name: the dependency lane is Size S (got '${size:-none}') — R-4.1"
      if [ "$rank" -ge 2 ] && ! section_body "$record" "Implementation Record" | grep -Eq '^- Dependency lane receipt:.*DEPENDENCY LANE PASS [0-9a-f]{7,40}'; then
        report_fail "$name: the dependency lane needs '- Dependency lane receipt:' with the PASS line check-dependency-lane.sh printed — R-4.1"
      fi
    fi
    # Every ledger line says whether its number is measured or an estimate (R-7.3).
    if grep -E '^Tokens spent \(' "$record" | grep -Evq '^Tokens spent \([^)]+\):[[:space:]]*~?[0-9]+[[:space:]]*—[[:space:]]*(measured|estimate)'; then
      report_fail "$name: a 'Tokens spent' line does not say 'measured' or 'estimate' after its number — R-7.3"
    fi
    # A short record (R-2.1, SI-178): every step and every reviewer reads it, so
    # evidence goes in by reference (the command and its receipt), never pasted.
    case "$size" in S) cap=300 ;; M) cap=450 ;; L) cap=600 ;; *) cap=800 ;; esac
    lines=$(wc -l < "$record" | tr -d ' ')
    [ "$lines" -le "$cap" ] || report_fail "$name: $lines lines, over the Size ${size:-?} limit of $cap; put evidence in by reference, not pasted — R-2.1"
    # What each lens alone caught (R-10.2, SI-180): one line in each verdict.
    if [ "$rank" -ge 1 ] && ! section_body "$record" "Design Verdict" | grep -Eq '^Found only by:[[:space:]]*[^[:space:]<]'; then
      report_fail "$name: Design Verdict needs a 'Found only by:' line (each reviewer and the findings no one else raised, or 'none') — R-10.2"
    fi
    if [ "$rank" -ge 4 ] && ! section_body "$record" "Review Verdict" | grep -Eq '^Found only by:[[:space:]]*[^[:space:]<]'; then
      report_fail "$name: Review Verdict needs a 'Found only by:' line (each reviewer and the findings no one else raised, or 'none') — R-10.2"
    fi
    # The raised budget (R-7.2): over budget, a stage may not complete until Budget: is raised, so the ledger stays honest.
    budget_text=$(sed -n 's/^Budget:[[:space:]]*//p' "$record" | head -n 1 | awk '{print $1}')
    budget=$(python3 -c '
import re, sys
m = re.match(r"([0-9]+(?:\.[0-9]+)?)\s*([kKmM]?)", sys.argv[1])
n = float(m.group(1)) if m else 0; u = m.group(2).lower() if m else ""
print(int(n * (1000 if u == "k" else 1000000 if u == "m" else 1)))' "${budget_text:-x}")
    spent=$(grep -E '^Tokens spent \(' "$record" | sed -E 's/.*\):[[:space:]]*~?([0-9]+).*/\1/' | awk '{s+=$1} END {print s+0}')
    last=$(grep -E '^Tokens spent \(' "$record" | tail -n 1 | sed -E 's/^Tokens spent \(([a-z-]+).*/\1/')
    last_rank=-1
    for i in "${!SKILLS[@]}"; do [ "${SKILLS[$i]}" = "$last" ] && last_rank=$i; done
    if [ "$budget" -gt 0 ] && [ "$spent" -ge "$budget" ] && [ "$rank" -ge "$last_rank" ] \
       && ! grep -Eq '^Budget decision:[[:space:]]*"[^"]{3,}".*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$record"; then
      report_fail "$name: spent $spent of its $budget budget and reached $stage without a raised Budget: raise it and add a 'Budget raised:' line (no founder needed) — R-7.2"
    fi
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
