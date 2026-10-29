#!/usr/bin/env bash
# Review pack (R-6.1): the one file every reviewer of a round starts from,
# built once by Sipk.ai, read by each lens and by the second opinion.
#
#   bash sipkai-pod/sdlc/scripts/review-pack.sh STORY-NNN design|review
#
# It holds the contract and the work, and nothing a reviewer must not see
# first: the record's header and the sections up to the work under review
# (without the spend ledger, earlier findings tables or second opinions,
# and never the Review Verdict, so findings form before conclusions), the
# current text of the files the record names, and for a review the diff.
# A reviewer opens other files only to confirm or place a finding.
#
# Prints the pack's path. CHECK_RECORDS_DIR overrides the records folder.

set -euo pipefail
source "$(dirname "$0")/lib.sh"

STORY="${1:?usage: review-pack.sh STORY-NNN design|review}"
STAGE="${2:?usage: review-pack.sh STORY-NNN design|review}"
RECORD="${CHECK_RECORDS_DIR:-$SDLC_RECORDS_DIR}/${STORY}.md"
[ -f "$RECORD" ] || { echo "No change record at $RECORD" >&2; exit 1; }
case "$STAGE" in
  design) keep="Discovery Brief" ;;
  review) keep="Discovery Brief|Design Verdict|Implementation Record|Acceptance Evidence" ;;
  *) echo "Stage must be 'design' or 'review'" >&2; exit 1 ;;
esac

mkdir -p build
OUT="build/review-pack-${STORY}-${STAGE}.md"

{
  echo "# Review pack: ${STORY}, ${STAGE}"
  echo
  echo "Everything this review starts from. Open another file only to confirm or place a finding."
  echo
  echo "## The change record (the contract, without its ledger and earlier findings)"
  echo
  # Header lines, then only the kept sections, minus the subsections no reviewer needs.
  awk -v keep="^## (${keep})\$" '
    /^## / { on = ($0 ~ keep); skip = 0 }
    /^### / { skip = ($0 ~ /^### (Agent budget and spend ledger|Findings and resolutions|Second opinion)/) }
    !seen_section && !/^## / { print; next }
    /^## / { seen_section = 1 }
    on && !skip { print }
  ' "$RECORD"
  # The current text of the existing files the record says it changes, so a
  # reviewer without repository access can judge an edit (SI-023, SI-151).
  # Taken from the record's "Expected files or directories:" line; at most
  # 400 lines per file and 4000 in all.
  scope=$(grep -m1 -E '^- Expected files or directories:' "$RECORD" | grep -oE '`[^`]+`' | tr -d '`' || true)
  budget=4000
  for f in $scope; do
    [ -f "$f" ] || continue
    n=$(wc -l < "$f" | tr -d ' ')
    [ "$budget" -le 0 ] && { echo; echo "(More files are named in the record; the pack's 4000-line limit was reached.)"; break; }
    take=$(( n < 400 ? n : 400 )); [ "$take" -gt "$budget" ] && take=$budget
    echo
    echo "## Current text of $f ($n lines$([ "$take" -lt "$n" ] && echo ", first $take shown"))"
    echo
    echo '```'
    head -n "$take" "$f"
    echo '```'
    budget=$(( budget - take ))
  done
  if [ "$STAGE" = "review" ]; then
    echo
    echo "## The diff (${SDLC_MAIN_BRANCH:-main}...HEAD)"
    echo
    echo '```diff'
    git diff "${SDLC_MAIN_BRANCH:-main}"...HEAD
    echo '```'
  fi
} > "$OUT"

echo "$OUT"
