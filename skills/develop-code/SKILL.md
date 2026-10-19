---
name: develop-code
description: Sipk.ai POD stage 3, Develop. Implements one DESIGN-VALIDATED change record on a story branch at the routed model tier, keeping code, narrow tests, docs, decisions and contracts aligned, with the fast gate green. Use only after design validation has cleared the change.
---

# Stage 3 · Develop · `/develop-code`

**Proves:** the contract was built, in scope, fast gate green.
**Cost of a miss caught here:** an hour.

## Who

| | |
|---|---|
| Accountable, does the work | **Michal** (Developer), at the record's routed tier |
| Consulted | **Marketa** when the design turns out wrong; a material deviation returns to Validate |
| Orchestrates | **Sipk.ai**, always `top`, who briefs Michal with the record only, states a return budget, and writes the ledger line |
| Founder | none in the normal case; control-plane changes are called out for his review |

## Input and output

- **Input:** a change record at `Stage: DESIGN-VALIDATED`.
- **Output:** a story branch with the implementation, narrow tests green, docs updated, `## Implementation Record` filled, `Development outcome: DEVELOPED`, `Stage: DEVELOPED`.

## Hard rule

The design-validated record is the delivery contract (R-2.11). Discovering the design is wrong is normal; the response is to update the record and return to `/validate-design` when the change is material, never to diverge silently.

## Applying the routed tier

Sipk.ai delegates the implementation to Michal with the record's `Execution model:` and the matching effort (R-7.13). Michal receives only the change record and returns raw structured data, never narrative. Grep before reading; filter tool output (R-7.14). Parallel workers only for disjoint mechanical batches on the `small` tier (R-7.15). A blocker or a twice-red fast gate re-runs the stage one tier up, noted in the record; never improvise through it, never self-downgrade (R-7.6, R-7.7).

## Steps

1. **Branch.** `git checkout -b story/STORY-NNN-slug`.
2. **Load the constraints.** The rules for the surfaces touched (the project's required-reading table), the project's error-handling and naming rules, and the governance rules always.
3. **Work the tasks in order.** For each task: implement exactly what it says; keep the project buildable in the same edit (R-3.24); new interactive UI gets stable `data-testid` identifiers in the same diff (R-3.7); documented behavior changes its doc in the same commit (R-3.23); shared constants update every side and both contract tests in the same commit (R-3.3); a new durable technical choice gets a decision record and a conflict with an accepted one returns to Validate (R-5.8); run the narrowest trustworthy check for what changed before moving on (R-3.16).
4. **Self-check before handoff.** Read the diff for machine tells and invented APIs (R-9.1, R-9.2) and fix them now. Read it for simplicity: the least code that meets the criteria, readable top to bottom, no speculative abstraction, no unrequested option, no cleverness (R-9.4 to R-9.10); simplify now. Compare actual files, dependencies, tools, network use and permissions with the declared scope; every difference is explained in the record or returned to design; control-plane changes are called out for the owner (R-8.2, R-8.4). The fast gate passes. Never `--no-verify` (R-4.7). Commit in task-sized commits whose messages say why (R-9.13).
5. **Fill the Implementation Record and hand off.** Changed files with reasons, declared versus actual scope, dependency provenance, authority used, decisions and docs updated, contract mirrors, narrow check commands and results, deviations. Set `Development outcome: DEVELOPED` and `Stage: DEVELOPED`. Sipk.ai appends `Tokens spent (develop-code): n` from harness-measured usage (R-7.11). Update the board and point the founder at `/test-acceptance` in a fresh session. If blocked, leave the stage where the evidence is.

## Scripts and checks

```bash
bash sipkai-pod/scripts/sdlc-gate.sh --fast     # must be green before handoff; the hook runs it on every commit
```

## Model tier and budget

Michal runs the record's tier: `small` for LOW mechanical work, `mid` for STANDARD, `top` for HIGH, CRITICAL, ambiguous, money, security, concurrency and control-plane work (R-7.2). One failed attempt escalates one tier (R-7.6). Crossing the budget stops the stage (R-7.10).

## Exit condition

Every development task is done or explicitly returned to design, and the fast gate is green.

## Rules that bind this stage

R-2.11, R-3.3, R-3.7, R-3.16, R-3.23, R-3.24, R-4.7, R-5.8, R-7.2, R-7.6, R-7.7, R-7.10, R-7.11, R-7.13 to R-7.15, R-8.2, R-8.4, R-8.5, R-9.1 to R-9.13.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
