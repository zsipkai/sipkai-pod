---
name: test-regression
description: Sipk.ai POD stage 6, Regress. Runs the project's complete deterministic matrix through the canonical gate on the exact REVIEW-CLEARED commit and issues a Regression Certificate naming that SHA. Use after review fixes and before deployment authority is granted.
---

# Stage 6 · Regress · `/test-regression`

**Proves:** the complete matrix passes on the exact reviewed commit.
**Cost of a miss caught here:** a broken release candidate.

## Who

| | |
|---|---|
| Accountable, does the work | **Bruno** (Tester), who may run on the `small` tier: he runs the script and reports honestly |
| Consulted | **Ivan** when the gate, the environment or CI misbehaves |
| Orchestrates | **Sipk.ai**, who writes the ledger line |
| Founder | none; the certificate lets Sipk.ai start Deploy |

## Input and output

- **Input:** a change record at `Stage: REVIEW-CLEARED` with review fixes on the branch.
- **Output:** `## Regression Certificate` naming the exact commit SHA, environment, commands and results; `Regression outcome: REGRESSION-TEST-PROVEN`, `Stage: REGRESSION-TEST-PROVEN`.

## Hard rule

The certificate describes one exact commit. Any code, test, configuration or merge-candidate change afterwards invalidates it and returns the work to `/clear-review` and this stage. A red or missing required check stops the transition; no skips, retries, sleeps or weaker thresholds to make it green (R-3.9).

## The matrix

Gate parity: run the canonical script, never a hand-picked approximation (R-3.21).

| Change | Command |
|---|---|
| any change | `bash sipkai-pod/scripts/sdlc-gate.sh --full` |
| anything a user sees, navigation, accessibility, or a release | `bash sipkai-pod/scripts/sdlc-gate.sh --ui` |

The gate already includes tools, change records, links, doc drift, secrets, the project's static analysis, tests and build, dependency vulnerabilities and the process evaluations.

## Steps

0. **Start check.** `bash sipkai-pod/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10). Red means stop: a session in the wrong folder is started again from the project root; a budget stop goes to the founder for a raise, a split or an escalation.
1. **Pin the candidate.** Update from `main` without discarding unrelated work, then `git rev-parse HEAD`. If anything changes after this point, start over.
2. **Run the matrix.** The gate mode from the table above, in a clean environment when available. The known baseline is zero failing tests; any red is signal about this change and is triaged like Accept (code, test or design wrong), never parked as a new known failure. Environmental reruns are recorded as discarded runs, not hidden (R-3.17). Confirm required CI reports green on the same commit when CI is configured (R-8.14).
3. **Issue the certificate.** Fill `## Regression Certificate`: `- Commit SHA:`, `- Environment:`, `- Full gate command:` verbatim, results per layer, counts, duration, skips, discarded runs, CI evidence, and `- Result: PASS` (or FAIL, which keeps the stage at `REVIEW-CLEARED`) (R-2.7). On PASS set `Regression outcome: REGRESSION-TEST-PROVEN` and `Stage: REGRESSION-TEST-PROVEN`. Sipk.ai appends the spend line (R-7.11). Update the board and point the founder at `/deploy-change`, which runs only on his deliberate invocation in a fresh session. Quote the line the gate printed as `- Gate receipt:`; the checker refuses a certificate without it, with another commit in it, or naming a commit the repository does not have (R-2.7).

## Scripts and checks

```bash
bash sipkai-pod/scripts/stage-start.sh STORY-NNN        # first, before any cd: folder and budget
git rev-parse HEAD
bash sipkai-pod/scripts/sdlc-gate.sh --full
bash sipkai-pod/scripts/sdlc-gate.sh --ui
```

## Model tier and budget

`small` is enough (R-7.5); the script does the judging. Sipk.ai orchestrates at `top`.

## Exit condition

The complete matrix is green on the certified SHA, or the record stays `REVIEW-CLEARED` with the failures triaged.

## Rules that bind this stage

R-2.7, R-2.16, R-2.17, R-3.8, R-3.9, R-3.17, R-3.19, R-3.21, R-7.5, R-7.11, R-8.14.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
