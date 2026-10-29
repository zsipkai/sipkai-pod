---
name: test-acceptance
description: Sipk.ai POD stage 4, Accept. Proves every acceptance criterion of a DEVELOPED change with a named, passing proof, including adverse, boundary, error and UI evidence with an accessibility check, and updates the coverage matrix. Use before independent review; it does not replace full regression.
---

# Stage 4 · Accept · `/test-acceptance`

**Proves:** every criterion has a named, passing proof, including UI proofs.
**Cost of a miss caught here:** hours.

## Who

| | |
|---|---|
| Accountable, does the work | **Bruno** (Tester) |
| Consulted | **Miro** on whether the proofs show the problem is solved; **Michal** fixes product defects on the branch |
| Orchestrates | **Sipk.ai**, who briefs Bruno with the record and a return budget, and writes the ledger line |
| Founder | none; the tests validate the outcome (R-5.2). Development deployments for (live) criteria are the pod's own |

## Input and output

- **Input:** a change record at `Stage: DEVELOPED` on its story branch.
- **Output:** `## Acceptance Evidence` filled, the project's coverage doc updated, `Acceptance outcome: ACCEPTANCE-TEST-PROVEN`, `Stage: ACCEPTANCE-TEST-PROVEN`.

## Hard rule

Fixing a test to pass without knowing whether the code, the test or the design is wrong breaks the prime directive (R-3.8, R-3.9). Find out which, then fix that thing.

## Applying the routed tier

Test authoring runs at the record's tier capped at `mid`; tests that encode a control-plane or security control run at `top` (R-7.3). Delegated like Develop, with a return budget. The test diff still gets `top` scrutiny in Review.

## Steps

0. **Start check.** `bash sipkai-pod/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10). Red means stop: a session in the wrong folder is started again from the project root; a budget stop goes to the founder for a raise, a split or an escalation.
1. **Write the tests the record promised.** Every criterion maps to at least one named test covering its primary, adverse, boundary and error paths (R-3.1, R-3.2). Expected values come from an independent source, never from the code under test (R-3.6). Shared constants have both-side contract tests (R-3.3). Anything a person sees on screen gets a UI test using the shipped `data-testid` identifiers, at the widths the project requires, with an accessibility check (R-3.7). Changed tests get a controlled counterexample that shows they can fail (R-3.18). Tests carry their provenance tag and story id (R-3.15).
2. **Run targeted evidence, fast first.** The narrow targets for everything the change touches, with the exact commands from the project's coverage doc quoted in the record: drift and change-record checks, unit and contract tests, the targeted UI journeys (R-3.16). Criteria marked (live) are proven against a dev deployment of the candidate that the founder approved and started. The complete matrix runs later in Regress.
3. **Triage honestly.** Classify every failure as product defect, test defect, requirement defect, environment defect or flaky infrastructure (R-3.8). Product defects return to `/develop-code`; a wrong design returns to `/validate-design` and resets downstream outcomes (R-2.9).
4. **Update the coverage matrix.** Add rows marked `AUTO`, `PARTIAL` or `MANUAL` honestly. Manual-only proofs get written steps and are declared as manual gaps (R-3.5).
5. **Fill Acceptance Evidence and hand off: measured, never reported.** Every number comes from a command quoted in the record and run at evidence time; subagent self-reports are leads, not evidence (R-3.17). Fill the criterion-to-proof table, commands and results, failure classifications, skips and manual gaps (R-3.10). Set `Acceptance outcome: ACCEPTANCE-TEST-PROVEN` and `Stage: ACCEPTANCE-TEST-PROVEN`. Sipk.ai appends the spend line (R-7.11). Update the board and point the founder at `/clear-review` in a fresh session. If any criterion cannot be proven, stop where the evidence is.

## Scripts and checks

```bash
bash sipkai-pod/scripts/stage-start.sh STORY-NNN        # first, before any cd: folder and budget
bash sipkai-pod/scripts/check-doc-drift.sh
bash sipkai-pod/scripts/check-change-records.sh
# plus the project's exact narrow test commands from its coverage doc
```

## Model tier and budget

Bruno writes at `mid` (control and security tests at `top`); Sipk.ai orchestrates at `top`.

## Exit condition

The acceptance map is fully executed: no criterion without a proof, no skip without an owned reason.

## Rules that bind this stage

R-2.9, R-3.1 to R-3.3, R-3.5 to R-3.12, R-3.15 to R-3.19, R-7.3, R-7.11.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
