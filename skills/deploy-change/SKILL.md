---
name: deploy-change
description: Sipk.ai POD stage 7, Deploy. Re-runs the hard gate on the merge candidate, merges through the protected route, deploys to the development environment, pushes main, verifies live behavior and rollback, and closes the story as DEPLOYED. Use after a Regression Certificate for the current HEAD; a production release waits for the founder's yes.
---

# Stage 7 · Deploy · `/deploy-change`

**Proves:** hard gate, staged deploy, live verification, rollback known.
**Cost of a miss caught here:** a production incident.

## Who

| | |
|---|---|
| Accountable, does the work | **Ivan** (DevOps and Deploy) |
| Consulted | **Adam** on the pre-flight's secrets and workflow changes; **Miro** on what goes into the product's living docs |
| Orchestrates | **Sipk.ai**, who writes the ledger line and closes the story on the board |
| Founder | approves a production release before it starts; gives a separate yes to money beyond the story, a deletion, a price or legal change, a production or account-level permission change, or `--no-verify`. A development release needs nothing from him |

## Input and output

- **Input:** a change record at `Stage: REGRESSION-TEST-PROVEN` whose certificate names the current HEAD.
- **Output:** merged to `main`, affected surfaces deployed and observed live, `## Deployment Record` filled, `Deployment outcome: DEPLOYED`, `Stage: DEPLOYED`, Definition of Done checked, story `DONE`.

## Hard rule

This stage can merge, deploy and spend, so Sipk.ai invokes it only once the Regression Certificate exists for the current HEAD, and a production release waits for the founder's recorded approval before merge (R-8.5). It never repairs product code; a changed candidate returns to Review and Regress. Money beyond the story, resource deletion, price or legal changes, production or account-level permission expansion and `--no-verify` each need their own explicit human yes (R-5.5).

## Steps

1. **The hard gate again, on the merge candidate.** `--deploy`, or `--ui` when there is no deployable surface. Red means stop. No "it's the known failure" hand-waving: fix it, which invalidates the certificate and returns to `/clear-review` (R-3.21).
2. **Pre-flight for release-bound work.** Walk `templates/release-preflight.md` and record each item with evidence. Inspect the exact file set for secrets, workflow changes, generated artifacts and unrelated changes (R-8.10, R-8.11).
3. **Merge through the protected route.** Open the pull request with the Review Verdict as its description and let required CI pass (R-8.14). A merge that was not clean changed the candidate: rerun `/test-regression` on the merged tree first. Where a project does not use pull requests, its own documented protected route applies, and Ivan pushes `main` afterwards where the project allows it.
4. **Deploy what changed, nothing more.** Only the affected surfaces, dev before production, by the project's deployment procedure. Development deployments run on the pod's own development credentials. For production, prepare the exact command or workflow run with its inputs and ask the founder to start it. Then verify the intended behavior live: smoke suite, health, logs, guardrail signals. A successful deploy command is not live verification. Roll back or stop the rollout when live evidence fails, and record what happened.
5. **Close the loop.** Fill `## Deployment Record`: `- Human deployment approval:` (the founder, who and when, for production; `not required, development release (R-5.2)` otherwise), `- Required CI URL or receipt:`, `- Merge SHA:`, artifact or provenance id, deployment surface and id, `- Live behavior observed:`, health and guardrail signals, monitoring window, `- Rollback status:` (R-2.7). A story with no deployable surface records `Deployment surface: none — merged to main`. Set `Deployment outcome: DEPLOYED` and `Stage: DEPLOYED`, and check only the Definition of Done boxes that are genuinely true (R-2.8, R-2.15). Set the story to `DONE`, update the board (status, stage, "Right now", the next story marker) and copy proven behavior into the product's living docs (R-3.26). Anything learned that changes the rules: a project rule, reviewer checklist, drift check or evaluation changes now in the same change; a change to the method becomes a proposal (R-10.6). Sipk.ai appends the spend line (R-7.11) and Tina adds the story to the bill.

## Scripts and checks

```bash
bash sipkai-pod/scripts/sdlc-gate.sh --deploy      # needs the project's dev URL; fails closed without it
bash sipkai-pod/scripts/sdlc-gate.sh --ui          # when there is no deployable surface
bash sipkai-pod/scripts/check-change-records.sh
bash sipkai-pod/scripts/cost-report.sh
```

## Model tier and budget

Always `top` (R-7.5): it can touch production, and its token cost is trivial anyway.

## Exit condition

Every affected surface deployed and observed live, or the failure honestly recorded and the stage left where the evidence is.

## Rules that bind this stage

R-2.7, R-2.8, R-2.15, R-2.17, R-3.21, R-3.26, R-4.7, R-5.5, R-7.5, R-7.11, R-8.5, R-8.10, R-8.11, R-8.13, R-8.14, R-10.6.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
