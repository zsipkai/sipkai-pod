---
name: build
description: Sipk.ai POD, Sizes M and L. Builds and proves one story in a single session: Develop and Accept, and for Size M also a short Plan and design check first. Michal builds, Bruno proves. Use for a Size M story (session 1 of 2) or a Size L story after /design (session 2 of 3).
---

# Build · `/build` (Sizes M and L)

**Proves:** the contract was built, in scope, and every acceptance criterion has a named, passing proof that can fail.
**Leaves:** `Stage: ACCEPTANCE-TEST-PROVEN`.

## Who

Michal builds at the routed tier; Bruno writes and runs the proofs; Marketa only when the design turns out wrong; Erik only if a screen changes. Sipk.ai orchestrates and writes the ledger.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.1, R-7.2).
1. **Size M only: a short plan and design check.** In the record: the outcome, the files, the acceptance map with one proof that can fail per criterion, the rollback, and `Size: M` with its reason. Walk the claims checklist (R-6.4); then a fresh reviewer who will not build it (Marketa's lens, Adam's at HIGH risk) checks the plan and names the simplest design before any code. Fill `Planning outcome: PLANNED` and `Design outcome: DESIGN-VALIDATED` with one paragraph each. A new contract, dependency, schema or screen, or a real design choice, stops here and moves the story up to L (R-2.8).
2. **Develop**, as `/develop-code` describes: on a story branch, task by task, docs in the same commit, the fast gate green, the governance self-check.
3. **Accept**, as `/test-acceptance` describes: every criterion's proof, adverse and boundary cases, a UI test for anything a person sees, a counterexample that shows each changed test can fail, the coverage doc updated.
4. **Hand off.** Set `Development outcome` and `Acceptance outcome`, `Stage: ACCEPTANCE-TEST-PROVEN`, append the spend line, Sipk.ai starts `/ship` in a fresh session (R-2.4).

## Exit condition

Every criterion has a named, passing proof that can fail; the fast gate is green; nothing outside the declared scope changed.

## Rules that bind this step

R-2.3, R-2.8, R-3.1, R-3.3, R-3.2, R-3.4, R-3.6, R-6.4, R-7.1, R-7.3, R-9.1, R-9.2, R-6.1.
