---
name: ship
description: Sipk.ai POD rapid and standard tracks, the last session. Reviews the diff independently, certifies the exact reviewed commit with the full gate, merges and deploys to development, verifies it live, and closes the story with the retrospective. Use after /build for a rapid- or standard-track story.
---

# Ship · `/ship` (rapid and standard tracks)

**Proves:** someone other than the builder cleared the diff, the full matrix passes on that exact commit, and the change is live and proven.
**Leaves:** `Stage: DEPLOYED`, the story `DONE`, the retrospective written.

## Who

Sipk.ai runs the review; one lens (rapid) or at most two (standard), chosen for the story's surfaces; the independent reviewer once, on the diff, except a rapid story at LOW risk (R-6.7); Bruno certifies; Ivan merges and deploys; Tina writes the retrospective. The founder only for a production release.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10).
1. **Review**, as `/clear-review` describes, sized by the track: scope the diff, brief the lenses in parallel (each report saved as it arrives, R-6.18), run the second opinion when the track asks for it and write the `Second opinion:` line, do the generalist pass, fix surgically and re-run the affected proofs. A finding that the track cannot absorb moves the story up a track (R-2.22).
2. **Regress**, as `/test-regression` describes: pin the reviewed commit, run the full gate, quote the gate receipt in the certificate.
3. **Deploy**, as `/deploy-change` describes: the hard gate on the merge candidate, merge through the project's route, deploy to development, verify live, record the rollback, close the story, update the board.
4. **Retrospective** (R-10.9): Tina's one page; Sipk.ai reports to the founder in three sentences.

## Exit condition

The record is `DEPLOYED` with every receipt, the story `DONE`, the board current, the retrospective written.

## Rules that bind this step

R-2.7, R-2.15, R-2.22, R-3.21, R-6.1, R-6.5 to R-6.11, R-6.18, R-8.5, R-8.14, R-10.9.
