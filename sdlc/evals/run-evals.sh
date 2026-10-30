#!/usr/bin/env bash
# Sipk.ai POD process evaluations: replay known good and known bad cases
# and prove each check still reaches the right verdict. A mismatch fails
# the run. Add a case for every new failure class (R-3.5).

set -uo pipefail
pod="$(cd "$(dirname "$0")/../.." && pwd)"
# Run on its own (the pod's CI, SI-186), outside a project: build a throwaway
# project that includes this pod and run there.
if [ ! -f "$pod/../sdlc.config.sh" ]; then
  proj=$(mktemp -d); mkdir "$proj/sipkai-pod"
  (cd "$pod" && tar --exclude=.git -cf - .) | tar -xf - -C "$proj/sipkai-pod"
  cp "$pod/sdlc/evals/project/sdlc.config.sh" "$proj/sdlc.config.sh"
  git -C "$proj" init -q -b main && git -C "$proj" add -A && git -C "$proj" -c user.email=eval@example.test -c user.name=eval commit -qm "evaluation project"
  bash "$proj/sipkai-pod/sdlc/evals/run-evals.sh"; rc=$?
  rm -rf "$proj"; exit "$rc"
fi
cd "$pod/.."
# A session whose project settings loaded carries SIPKAI_PROJECT (R-8.1, SI-182).
SIPKAI_PROJECT=$(set +u; . ./sdlc.config.sh >/dev/null 2>&1; printf '%s' "${SDLC_PROJECT_NAME:-}"); export SIPKAI_PROJECT
S=sipkai-pod/sdlc/scripts
F=sipkai-pod/sdlc/evals/fixtures
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

pass=0; fail=0
# case name | expected exit (0 or nonzero) | text the output must contain | command...
evaluate() {
  local name="$1" want="$2" text="$3"; shift 3
  local out rc ok=1
  out=$("$@" 2>&1); rc=$?
  if [ "$want" = "0" ] && [ "$rc" -ne 0 ]; then ok=0; fi
  if [ "$want" = "nonzero" ] && [ "$rc" -eq 0 ]; then ok=0; fi
  if [ -n "$text" ] && ! printf '%s' "$out" | grep -qF -- "$text"; then ok=0; fi
  if [ "$ok" -eq 1 ]; then echo "PASS  $name"; pass=$((pass+1)); else echo "FAIL  $name (exit $rc, expected $want; wanted text: '$text')"; printf '%s\n' "$out" | sed 's/^/      /' | head -12; fail=$((fail+1)); fi
}
# Fixtures write SHA_HEAD where a certificate needs a commit this repository has.
records() {
  rm -rf "$tmp/records-$1"; cp -R "$F/records/$1" "$tmp/records-$1"
  sed -i.bak "s/SHA_HEAD/$(git rev-parse HEAD)/g" "$tmp/records-$1"/*.md && rm -f "$tmp/records-$1"/*.bak
  CHECK_RECORDS_DIR="$tmp/records-$1" bash "$S/check-change-records.sh"
}

evaluate "records: valid PLANNED record passes"           0       "PASS"                      records good-planned
evaluate "records: valid DEPLOYED record passes"          0       "PASS"                      records good-deployed
evaluate "records: HIGH risk on mid tier is refused"      nonzero "routing rule 7"            records high-risk-mid-tier
evaluate "records: stage ahead of its evidence"           nonzero "claims DEVELOPED"          records stage-outruns-evidence
evaluate "records: later section already claimed"         nonzero "must be PENDING"           records later-section-not-pending
evaluate "records: placeholder in a completed section"    nonzero "template placeholders"     records placeholder-in-completed-section
evaluate "records: DEPLOYED with unchecked Done box"      nonzero "unchecked Definition"      records deployed-unchecked-dod
evaluate "records: DEPLOYED without receipts"             nonzero "Deployment Record needs"   records deployed-missing-receipts
evaluate "records: review without a declared second opinion" nonzero "Review Verdict needs a 'Second opinion:'" records missing-second-opinion
evaluate "records: certificate names an unknown commit"    nonzero "does not have"             records receipt-unknown-sha
evaluate "records: certificate without the gate receipt"   nonzero "needs '- Gate receipt:'"   records receipt-missing
evaluate "records: over budget, stage completed anyway"    nonzero "quoting the founder's own words" records over-budget-no-decision
evaluate "records: over budget, halted inside the stage"   0       "PASS"                      records over-budget-halted
evaluate "records: over budget with a human's decision"    0       "PASS"                      records over-budget-decided
evaluate "records: a budget decision without the founder's words" nonzero "quoting the founder's own words" records over-budget-unquoted
evaluate "records: a ledger line without measured or estimate" nonzero "'measured' or 'estimate'" records unlabelled-ledger
evaluate "records: a CRITICAL story below XL"              nonzero "always planned as XL"      records critical-below-xl
evaluate "records: Size S at LOW risk, reviewed alone"     0       "PASS"                      records s-low-risk-reviewed
evaluate "records: Size L design needs no second opinion"  0       "PASS"                      records l-high-design-without-opinion
evaluate "records: a verdict without 'Found only by:'"    nonzero "needs a 'Found only by:'"  records missing-lens-line
evaluate "records: Size with its one line of reason passes" 0       "PASS"                      records size-with-reason
evaluate "records: a Size S record over 300 lines"         nonzero "over the Size S limit"     records record-too-long
evaluate "records: dependency lane with its receipt passes" 0       "PASS"                      records dependency-lane-receipt
evaluate "records: dependency lane without its receipt"    nonzero "needs '- Dependency lane receipt:'" records dependency-lane-no-receipt

# Start-of-stage check: the session's folder and the budget stop.
evaluate "stage start: session outside the project root"   nonzero "not in the project root"   bash -c 'cd sipkai-pod && bash sdlc/scripts/stage-start.sh STORY-901'
evaluate "stage start: project settings not loaded"        nonzero "harness settings are not loaded" env -u SIPKAI_PROJECT CHECK_RECORDS_DIR="$F/records/over-budget-decided" bash "$S/stage-start.sh" STORY-901
evaluate "stage start: over budget stops the stage"         nonzero "token budget (R-7.2)"     env CHECK_RECORDS_DIR="$F/records/over-budget-no-decision" bash "$S/stage-start.sh" STORY-901
evaluate "stage start: the founder's quoted decision lets it go" 0   "a human decided"           env CHECK_RECORDS_DIR="$F/records/over-budget-decided" bash "$S/stage-start.sh" STORY-901
evaluate "stage start: a step that cannot finish stops first" nonzero "Stop before starting"  env CHECK_RECORDS_DIR="$F/records/step-share-short" bash "$S/stage-start.sh" STORY-901 ship
evaluate "stage start: a step that fits what is left starts" 0      "PASS"                      env CHECK_RECORDS_DIR="$F/records/step-share-short" bash "$S/stage-start.sh" STORY-901 test-regression

# Review pack: the contract and the work, never the ledger, earlier findings or conclusions (R-6.1).
pack_ok() {
  local p; p=$(CHECK_RECORDS_DIR="$F/records/review-pack" bash "$S/review-pack.sh" STORY-901 "$1") || return 1
  grep -q "$2" "$p" || { echo "the pack lacks $2"; return 1; }
  for absent in LEDGER-ROW DESIGN-FINDING-ROW REVIEW-CONCLUSION-ROW "## Review Verdict"; do
    grep -q "$absent" "$p" && { echo "the pack leaks $absent"; return 1; }
  done
  echo "pack ok"
}
evaluate "review pack: design pack holds the contract only" 0       "pack ok"                   pack_ok design CONTRACT-ROW
evaluate "review pack: review pack holds the validated design" 0    "pack ok"                   pack_ok review DESIGN-CONTRACT-ROW

evaluate "drift: clean file with angle brackets passes"   0       "no TODO or UNCONFIGURED"   env CHECK_TRUTH_FILES="$F/drift/clean.md" bash "$S/check-doc-drift.sh"
evaluate "drift: TODO marker is caught"                   nonzero "markers remain"            env CHECK_TRUTH_FILES="$F/drift/marker.md" bash "$S/check-doc-drift.sh"
mkdir -p "$tmp/with space"; cp "$F/drift/marker.md" "$tmp/with space/marker.md"
evaluate "drift: truth file path with a space is read"    nonzero "markers remain"            env CHECK_TRUTH_FILES="$tmp/with space/marker.md" bash "$S/check-doc-drift.sh"
evaluate "drift: missing ripgrep fails closed"            nonzero "ripgrep (rg) is not installed" env -i HOME="$HOME" PATH=/usr/bin:/bin bash "$S/check-doc-drift.sh"
evaluate "tools: missing programs fail closed"            nonzero "is not installed"          env -i HOME="$HOME" PATH=/usr/bin:/bin bash "$S/check-tools.sh"
# A throwaway project whose own tool check fails proves check-tools runs it.
mkdir -p "$tmp/proj/sipkai-pod/sdlc"; cp -R sipkai-pod/sdlc/scripts "$tmp/proj/sipkai-pod/sdlc/scripts"
cat > "$tmp/proj/sdlc.config.sh" <<'CFG'
SDLC_STORIES_DIR="stories"; SDLC_RECORDS_DIR="records"
project_tool_checks() { echo "FAIL  project tool check failed: runtime 1.0, 2.0 or newer is required"; return 1; }
CFG
evaluate "tools: a failing project tool check fails the check" nonzero "project tool check failed" bash "$tmp/proj/sipkai-pod/sdlc/scripts/check-tools.sh"

# Card, board and record agree (check-record-drift.sh), in the same throwaway project.
cat >> "$tmp/proj/sdlc.config.sh" <<'CFG'
SDLC_BOARD="board.md"; SDLC_TRUTH_FILES=(); SDLC_RETIRED_PHRASES=("open the pull request")
CFG
mkdir -p "$tmp/proj/records" "$tmp/proj/stories"
printf '# STORY-901: Fixture\n\nStage: DEVELOPED\nExecution model: mid\nBudget: 750k\n' > "$tmp/proj/records/STORY-901.md"
drift_fixture() {   # card stage | board budget | card note
  printf '# STORY-901: Fixture\n\n- Status: IN DELIVERY\n- Proposed execution model: mid\n- Change record: `records/STORY-901.md` (Stage %s)\n\n%s\n' "$1" "$3" > "$tmp/proj/stories/STORY-901-fixture.md"
  printf '| ID | Story | Tier | Budget | Stage |\n|---|---|---|---|---|\n| STORY-901 | Fixture | mid | %s | DEVELOPED |\n' "$2" > "$tmp/proj/board.md"
}
drift() { (cd "$tmp/proj" && bash sipkai-pod/sdlc/scripts/check-record-drift.sh); }
drift_fixture DEVELOPED 750k "Nothing retired here."
evaluate "drift: card, board and record agree"             0       "agree with their cards"    drift
drift_fixture REVIEW-CLEARED 750k "Nothing retired here."
evaluate "drift: card's stage pointer is stale"            nonzero "says (Stage REVIEW-CLEARED)" drift
drift_fixture DEVELOPED 1.5M "Nothing retired here."
evaluate "drift: board budget differs from the record"     nonzero "Budget '1.5M'"             drift
drift_fixture DEVELOPED 750k "Then open the pull request for review."
evaluate "drift: retired phrase in an open story"          nonzero "retired phrase"            drift

# Second opinion: a missing Keychain item stops --auto with exit 2 and a
# clear message. A stand-in `security` that finds nothing keeps the real
# Keychain out of the evaluation.
mkdir -p "$tmp/nokey"
printf '#!/bin/sh\nexit 44\n' > "$tmp/nokey/security"; chmod +x "$tmp/nokey/security"
evaluate "second opinion: missing key exits 2 with a message" 0   "no key: exit 2"            env CHECK_RECORDS_DIR="$F/records/good-planned" bash -c 'PATH="$1:$PATH" bash "$2/second-opinion.sh" STORY-901 design --auto 2>&1; rc=$?; [ "$rc" -eq 2 ] && echo "no key: exit 2"' _ "$tmp/nokey" "$S"
evaluate "second opinion: missing key names the Keychain item" nonzero "sipkai-openai-api"   env CHECK_RECORDS_DIR="$F/records/good-planned" PATH="$tmp/nokey:$PATH" bash "$S/second-opinion.sh" STORY-901 design --auto

# Second opinion: an API error or an empty answer ends in exit 3, "NOT
# obtained", and no findings file (SI-089). Stand-ins for `security` and
# `curl` keep the real Keychain and the real API out of the evaluation.
for answer in error empty; do
  mkdir -p "$tmp/api-$answer"
  printf '#!/bin/sh\necho sk-evaluation\n' > "$tmp/api-$answer/security"
  if [ "$answer" = error ]; then body='{"error":{"message":"insufficient_quota"}}'; else body='{"choices":[{"message":{"content":""}}]}'; fi
  printf '#!/bin/sh\ncat >/dev/null\necho %s\n' "'$body'" > "$tmp/api-$answer/curl"
  chmod +x "$tmp/api-$answer/security" "$tmp/api-$answer/curl"
done
so_failed() {
  CHECK_RECORDS_DIR="$F/records/good-planned" PATH="$tmp/api-$1:$PATH" bash "$S/second-opinion.sh" STORY-901 design --auto 2>&1; rc=$?
  [ "$rc" -eq 3 ] && [ ! -e build/second-opinion-STORY-901-design-findings.md ] && echo "exit 3, no findings file"
}
evaluate "second opinion: API error is NOT obtained"       0       "exit 3, no findings file"  so_failed error
evaluate "second opinion: empty answer is NOT obtained"    0       "exit 3, no findings file"  so_failed empty
evaluate "second opinion: a key file inside the repository is refused" nonzero "refuses a key file inside the repository" env CHECK_RECORDS_DIR="$F/records/good-planned" SDLC_SECOND_OPINION_KEY_FILE="$PWD/README.md" bash "$S/second-opinion.sh" STORY-901 design --auto
mkdir -p "$tmp/so-records"
printf '# STORY-902: Fixture\n\nStage: PLANNED\n\n- Expected files or directories: `sipkai-pod/VERSION`, `no/such/file.txt`\n' > "$tmp/so-records/STORY-902.md"
evaluate "second opinion: the pack carries the current text of named files" 0 "## Current text of sipkai-pod/VERSION" bash -c 'CHECK_RECORDS_DIR="$1" bash "$2/second-opinion.sh" STORY-902 design >/dev/null && cat build/second-opinion-STORY-902-design.md' _ "$tmp/so-records" "$S"

# Pre-commit hook: the commit must hold what the gate checks. A throwaway
# repository with a stand-in gate isolates the hook's own refusal.
hook_repo() {
  local dir="$tmp/hook-$1"
  mkdir -p "$dir/sipkai-pod/sdlc/scripts"
  git -C "$dir" init -q
  printf '#!/usr/bin/env bash\necho "stand-in gate ran"\n' > "$dir/sipkai-pod/sdlc/scripts/sdlc-gate.sh"
  echo "broken" > "$dir/file.txt"
  git -C "$dir" add file.txt sipkai-pod/sdlc/scripts/sdlc-gate.sh
  echo "$dir"
}
dir=$(hook_repo refused); echo "fixed" > "$dir/file.txt"
evaluate "hook: staged copy differing from working copy is refused" nonzero "file.txt"   bash -c 'cd "$1" && bash "$2"' _ "$dir" "$PWD/$S/pre-commit"
dir=$(hook_repo clean)
evaluate "hook: index matching the working tree runs the gate"      0       "stand-in gate ran" bash -c 'cd "$1" && bash "$2"' _ "$dir" "$PWD/$S/pre-commit"

# Dependency lane (R-4.1, SI-184): a throwaway repository whose project
# functions read the lockfile, and a stand-in osv-scanner that finds nothing.
mkdir -p "$tmp/osv-ok"; printf '#!/bin/sh\nexit 0\n' > "$tmp/osv-ok/osv-scanner"; chmod +x "$tmp/osv-ok/osv-scanner"
lane() {   # name | what the story branch commits | what it leaves uncommitted
  local d="$tmp/lane-$1"
  mkdir -p "$d/sipkai-pod/sdlc" "$d/records" "$d/stories"; cp -R sipkai-pod/sdlc/scripts "$d/sipkai-pod/sdlc/scripts"
  cat > "$d/sdlc.config.sh" <<'CFG'
SDLC_STORIES_DIR="stories"; SDLC_RECORDS_DIR="records"; SDLC_BOARD="board.md"
project_lock_check() { ! grep -q unsatisfied package-lock.json; }
project_build_fingerprint() { sed -n 's/.*"bundle": *"\([^"]*\)".*/\1/p' package-lock.json; }
CFG
  printf '{"lockfileVersion":3,"bundle":"v1","dep":"1.0.0"}\n' > "$d/package-lock.json"
  git -C "$d" init -q && git -C "$d" checkout -q -b main && git -C "$d" add -A && git -C "$d" -c user.email=eval@example.test -c user.name=eval commit -qm main
  git -C "$d" checkout -q -b story
  (cd "$d" && eval "$2")
  git -C "$d" add -A && git -C "$d" -c user.email=eval@example.test -c user.name=eval commit -qm story
  (cd "$d" && eval "${3:-:}")
  (cd "$d" && PATH="$tmp/osv-ok:$PATH" bash sipkai-pod/sdlc/scripts/check-dependency-lane.sh)
}
evaluate "dependency lane: a lockfile-only update passes"   0       "DEPENDENCY LANE PASS"      lane only-lock 'sed -i.bak s/1.0.0/1.0.1/ package-lock.json && rm package-lock.json.bak && echo note > records/STORY-1.md'
evaluate "dependency lane: a code change is refused"        nonzero "neither a lockfile"        lane code 'sed -i.bak s/1.0.0/1.0.1/ package-lock.json && rm package-lock.json.bak && echo code > app.js'
evaluate "dependency lane: code renamed onto a lockfile is refused" nonzero "install-hooks.sh changed (D)" lane rename 'mkdir -p lib && git mv sipkai-pod/sdlc/scripts/install-hooks.sh lib/package-lock.json'
evaluate "dependency lane: uncommitted changes are refused"  nonzero "uncommitted changes"      lane dirty 'sed -i.bak s/1.0.0/1.0.1/ package-lock.json && rm package-lock.json.bak' 'echo x > stray.txt'
evaluate "dependency lane: a changed build is refused"      nonzero "differs from main"         lane build 'sed -i.bak s/v1/v2/ package-lock.json && rm package-lock.json.bak'

improvements() { CHECK_IMPROVEMENTS_FILE="$F/improvements/$1.md" bash "$S/check-improvements.sh"; }
evaluate "improvements: human-approved and proposed rows pass" 0     "every approval is human"   improvements good
evaluate "improvements: APPROVED without approver refused"  nonzero "without a human approver"  improvements approved-without-approver
evaluate "improvements: agent named as approver refused"    nonzero "only a human approves"     improvements agent-approved
evaluate "improvements: APPLIED without location refused"   nonzero "without saying where"      improvements applied-without-location
evaluate "improvements: approval without a date refused"    nonzero "has no date"               improvements approval-without-date
evaluate "improvements: an apostrophe in the approver is read" 0  "every approval is human"   improvements apostrophe-approver
evaluate "improvements: the method's own logs pass"           0       "every approval is human"   bash "$S/check-improvements.sh" --method

# adopt.sh creates the bridge, the constitution and the team's workspace in a fresh project.
mkdir -p "$tmp/fresh/sipkai-pod/sdlc"; cp -R sipkai-pod/sdlc/scripts "$tmp/fresh/sipkai-pod/sdlc/scripts"; cp -R sipkai-pod/templates "$tmp/fresh/sipkai-pod/templates"; cp -R sipkai-pod/adapters "$tmp/fresh/sipkai-pod/adapters"; git -C "$tmp/fresh" init -q
evaluate "adopt: a fresh project gets its workspace"          0       "created  delivery/sprint-0/" bash "$tmp/fresh/sipkai-pod/sdlc/scripts/adopt.sh"
evaluate "adopt: running it again overwrites nothing"         0       "kept     delivery/backlog/BACKLOG.md" bash "$tmp/fresh/sipkai-pod/sdlc/scripts/adopt.sh"
# A brand-new project reaches a green fast gate on day one (no code, every code stage declared none).
mkdir -p "$tmp/day1/sipkai-pod"; cp -R sipkai-pod/sdlc sipkai-pod/templates sipkai-pod/adapters "$tmp/day1/sipkai-pod/"; rm -rf "$tmp/day1/sipkai-pod/sdlc/evals"
git -C "$tmp/day1" init -q && printf 'A new project.\n' > "$tmp/day1/README.md" && git -C "$tmp/day1" add README.md && git -C "$tmp/day1" -c user.email=eval@example.test -c user.name=eval commit -qm init
day1() { (cd "$tmp/day1" && bash sipkai-pod/sdlc/scripts/adopt.sh >/dev/null && bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast); }
evaluate "adopt: a brand-new project's fast gate is green"   0       "GATE PASSED (--fast)"      day1
mkdir -p "$tmp/day1/delivery/backlog/change-records"; printf '# STORY-001: Built\n\nStage: DEVELOPED\n' > "$tmp/day1/delivery/backlog/change-records/STORY-001.md"
evaluate "adopt: a stage declared none fails once code exists" nonzero "has built code"      bash -c 'cd "$1" && bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast' _ "$tmp/day1"

mkdir -p "$tmp/clean" "$tmp/leak"
echo "nothing secret here" > "$tmp/clean/note.txt"
printf 'github_token = "ghp_%s"\n' "$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 36)" > "$tmp/leak/config.txt"
evaluate "secrets: clean folder passes"                   0       "no secrets found"          bash "$S/check-secrets.sh" "$tmp/clean"
evaluate "secrets: planted token is caught"               nonzero "possible secret"           bash "$S/check-secrets.sh" "$tmp/leak"
leak_value=$(sed -n 's/.*"\(ghp_[A-Za-z0-9]*\)".*/\1/p' "$tmp/leak/config.txt")
evaluate "secrets: token value is never printed"          nonzero ""                          bash -c "bash '$S/check-secrets.sh' '$tmp/leak' 2>&1 | grep -qF '$leak_value'"

mkdir -p "$tmp/deps"
cat > "$tmp/deps/package-lock.json" <<'JSON'
{"name":"eval","version":"1.0.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"eval","version":"1.0.0","dependencies":{"lodash":"4.17.15"}},"node_modules/lodash":{"version":"4.17.15","resolved":"https://registry.npmjs.org/lodash/-/lodash-4.17.15.tgz"}}}
JSON
mkdir -p "$tmp/nodeps"
evaluate "dependencies: known-vulnerable lodash is caught" nonzero "known vulnerabilities"     bash "$S/check-dependencies.sh" "$tmp/deps"
evaluate "dependencies: no manifests is an explicit pass"  0       "nothing to scan"           bash "$S/check-dependencies.sh" "$tmp/nodeps"

echo ""
echo "Process evaluations: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
