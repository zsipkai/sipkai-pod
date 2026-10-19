#!/usr/bin/env bash
# Sipk.ai POD process evaluations: replay known good and known bad cases
# and prove each check still reaches the right verdict. A mismatch fails
# the run. Add a case for every new failure class (R-3.20).

set -uo pipefail
cd "$(cd "$(dirname "$0")/../.." && pwd)"
S=sipkai-pod/scripts
F=sipkai-pod/evals/fixtures
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
records() { CHECK_RECORDS_DIR="$F/records/$1" bash "$S/check-change-records.sh"; }

evaluate "records: valid PLANNED record passes"           0       "PASS"                      records good-planned
evaluate "records: valid DEPLOYED record passes"          0       "PASS"                      records good-deployed
evaluate "records: HIGH risk on mid tier is refused"      nonzero "routing rule 7"            records high-risk-mid-tier
evaluate "records: stage ahead of its evidence"           nonzero "claims DEVELOPED"          records stage-outruns-evidence
evaluate "records: later section already claimed"         nonzero "must be PENDING"           records later-section-not-pending
evaluate "records: placeholder in a completed section"    nonzero "template placeholders"     records placeholder-in-completed-section
evaluate "records: DEPLOYED with unchecked Done box"      nonzero "unchecked Definition"      records deployed-unchecked-dod
evaluate "records: DEPLOYED without receipts"             nonzero "Deployment Record needs"   records deployed-missing-receipts

evaluate "drift: clean file with angle brackets passes"   0       "no TODO or UNCONFIGURED"   env CHECK_TRUTH_FILES="$F/drift/clean.md" bash "$S/check-doc-drift.sh"
evaluate "drift: TODO marker is caught"                   nonzero "markers remain"            env CHECK_TRUTH_FILES="$F/drift/marker.md" bash "$S/check-doc-drift.sh"
mkdir -p "$tmp/with space"; cp "$F/drift/marker.md" "$tmp/with space/marker.md"
evaluate "drift: truth file path with a space is read"    nonzero "markers remain"            env CHECK_TRUTH_FILES="$tmp/with space/marker.md" bash "$S/check-doc-drift.sh"
evaluate "drift: missing ripgrep fails closed"            nonzero "ripgrep (rg) is not installed" env -i HOME="$HOME" PATH=/usr/bin:/bin bash "$S/check-doc-drift.sh"
evaluate "tools: missing programs fail closed"            nonzero "is not installed"          env -i HOME="$HOME" PATH=/usr/bin:/bin bash "$S/check-tools.sh"
mkdir -p "$tmp/java21"
cat > "$tmp/java21/java" <<'SH'
#!/bin/sh
echo 'openjdk version "21.0.4" 2024-07-16 LTS' >&2
SH
chmod +x "$tmp/java21/java"
evaluate "tools: Java 21 is refused, 25 is required"      nonzero "25 or newer is required"   env PATH="$tmp/java21:$PATH" bash "$S/check-tools.sh"

# Second opinion: a missing Keychain item stops --auto with exit 2 and a
# clear message. A stand-in `security` that finds nothing keeps the real
# Keychain out of the evaluation.
mkdir -p "$tmp/nokey"
printf '#!/bin/sh\nexit 44\n' > "$tmp/nokey/security"; chmod +x "$tmp/nokey/security"
evaluate "second opinion: missing key exits 2 with a message" 0   "no key: exit 2"            bash -c 'PATH="$1:$PATH" bash "$2/second-opinion.sh" STORY-001 design --auto 2>&1; rc=$?; [ "$rc" -eq 2 ] && echo "no key: exit 2"' _ "$tmp/nokey" "$S"
evaluate "second opinion: missing key names the Keychain item" nonzero "sipkai-openai-api"   env PATH="$tmp/nokey:$PATH" bash "$S/second-opinion.sh" STORY-001 design --auto

# Pre-commit hook: the commit must hold what the gate checks. A throwaway
# repository with a stand-in gate isolates the hook's own refusal.
hook_repo() {
  local dir="$tmp/hook-$1"
  mkdir -p "$dir/sipkai-pod/scripts"
  git -C "$dir" init -q
  printf '#!/usr/bin/env bash\necho "stand-in gate ran"\n' > "$dir/sipkai-pod/scripts/sdlc-gate.sh"
  echo "broken" > "$dir/file.txt"
  git -C "$dir" add file.txt sipkai-pod/scripts/sdlc-gate.sh
  echo "$dir"
}
dir=$(hook_repo refused); echo "fixed" > "$dir/file.txt"
evaluate "hook: staged copy differing from working copy is refused" nonzero "file.txt"   bash -c 'cd "$1" && bash "$2"' _ "$dir" "$PWD/$S/pre-commit"
dir=$(hook_repo clean)
evaluate "hook: index matching the working tree runs the gate"      0       "stand-in gate ran" bash -c 'cd "$1" && bash "$2"' _ "$dir" "$PWD/$S/pre-commit"

improvements() { CHECK_IMPROVEMENTS_FILE="$F/improvements/$1.md" bash "$S/check-improvements.sh"; }
evaluate "improvements: human-approved and proposed rows pass" 0     "every approval is human"   improvements good
evaluate "improvements: APPROVED without approver refused"  nonzero "without a human approver"  improvements approved-without-approver
evaluate "improvements: agent named as approver refused"    nonzero "only a human approves"     improvements agent-approved
evaluate "improvements: APPLIED without location refused"   nonzero "without saying where"      improvements applied-without-location
evaluate "improvements: approval without a date refused"    nonzero "has no date"               improvements approval-without-date

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
