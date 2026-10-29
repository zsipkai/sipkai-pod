---
name: build
description: Sipk.ai POD rapid and standard tracks. Builds and proves one story in a single session: Develop and Accept, and for the rapid track also a short Plan and Validate first. Michal builds, Bruno proves. Use for a rapid-track story (session 1 of 2) or a standard-track story after /design (session 2 of 3).
---

# Build · `/build` (rapid and standard tracks)

**Proves:** the contract was built, in scope, and every acceptance criterion has a named, passing proof that can fail.
**Leaves:** `Stage: ACCEPTANCE-TEST-PROVEN`.

## Who

Michal builds at the routed tier; Bruno writes and runs the proofs; Marketa only when the design turns out wrong; Erik only if a screen changes (which a rapid story never does). Sipk.ai orchestrates and writes the ledger.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10).
1. **Rapid track only: a short plan and design check.** In the record: the outcome, the files, the acceptance map with one proof that can fail per criterion, the rollback, and `Track: rapid` with its reason. Walk the claims checklist (R-6.17) and check the simplest design yourself. Fill `Planning outcome: PLANNED` and `Design outcome: DESIGN-VALIDATED` with one paragraph each. Anything outside the rapid limits (R-2.22) stops here and moves the story up a track.
2. **Develop**, as `/develop-code` describes: on a story branch, task by task, docs in the same commit, the fast gate green, the governance self-check.
3. **Accept**, as `/test-acceptance` describes: every criterion's proof, adverse and boundary cases, a UI test for anything a person sees, a counterexample that shows each changed test can fail, the coverage doc updated.
4. **Hand off.** Set `Development outcome` and `Acceptance outcome`, `Stage: ACCEPTANCE-TEST-PROVEN`, append the spend line, hand off to `/ship` in a fresh session.

## Exit condition

Every criterion has a named, passing proof that can fail; the fast gate is green; nothing outside the declared scope changed.

## Rules that bind this step

R-2.11, R-2.22, R-3.1 to R-3.18, R-3.23, R-3.24, R-6.17, R-7.6, R-7.11, R-9.1 to R-9.13.
