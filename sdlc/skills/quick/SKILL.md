---
name: quick
description: Sipk.ai POD, the route for a Size S story. One session: a short plan and design check, build, prove every criterion, one independent reviewer, the full gate on the exact commit, ship and a two-line retrospective. Use for a small, clear change of a few files; anything bigger or riskier takes M, L or XL.
---

# Quick · `/quick` (Size S)

**Proves, in one session:** the change is understood, built, proven against every criterion, cleared by someone other than the builder, certified on the exact commit and live.
**Leaves:** `Stage: DEPLOYED`, the story `DONE`.

## Who

Sipk.ai orchestrates; Michal builds at the tier the risk routes; Bruno proves; one reviewer, a fresh subagent who never saw the build, wears the lens the story's surface needs (Adam's at HIGH risk); the second model family reviews the diff at STANDARD risk and above (R-6.2); Ivan ships; Tina adds the line to the bill.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.1, R-7.2).
1. **Plan in a few lines, then have the design checked.** The outcome, the files, one proof that can fail per criterion, the rollback, `Size: S` and its reason, and the claims checklist walked (R-6.4). A fresh reviewer who will not build it (Marketa's lens, Adam's at HIGH risk) checks the plan and names the simplest design before any code. Anything that is not small and clear (a new contract, dependency, schema or screen, or design choices) stops here and moves the story up a size (R-2.8).
2. **Build and prove**, as `/develop-code` and `/test-acceptance` describe, briefly: on a story branch, docs in the same commit, each criterion's proof with a counterexample, the fast gate green.
3. **Review** by one fresh reviewer and, at STANDARD and above, the second opinion on the diff; findings saved as they arrive, fixed surgically, proofs re-run (R-6.1 to R-6.3).
4. **Regress and ship**, as `/test-regression` and `/deploy-change` describe: pin the reviewed commit, the full gate with its receipt, merge, deploy to development, verify live, close the story.
5. **Two lines for the retrospective**: the spend against the budget and anything the next story should do differently (R-10.2).

## Exit condition

The record is `DEPLOYED` with all seven sections filled briefly and every receipt; the story is `DONE`.

## Rules that bind this step

R-2.2, R-2.8, R-3.1, R-3.2, R-3.5, R-6.1, R-6.2, R-6.3, R-6.4, R-7.2, R-8.1.
