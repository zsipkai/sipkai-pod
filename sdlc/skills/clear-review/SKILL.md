---
name: clear-review
description: Sipk.ai POD stage 5, Review. Independent review of an ACCEPTANCE-TEST-PROVEN diff by parallel read-only lenses, the independent reviewer from a second model family and a generalist pass (correctness, governance, scope, test diff), then surgical fixes and retests to reach REVIEW-CLEARED. Use after acceptance proof and before full regression.
---

# Stage 5 · Review · `/clear-review`

**Proves:** independent lenses, a second model family and a generalist cleared the diff.
**Cost of a miss caught here:** hours to days.

## Who

| | |
|---|---|
| Accountable | **Sipk.ai** (Engineering Director): scopes the diff, does the generalist pass, consolidates, decides resolutions |
| Consulted, in parallel, read-only | **Marketa** (architecture lens), **Adam** (security lens, verdict on control-plane changes), **Miro** (domain lens and the project's own lenses), **Bruno** (test-quality and doc-drift lenses), **Ivan** on gate, hook, CI and deploy configuration changes |
| Outside the team | the **Independent reviewer** on any record above LOW risk |
| Fixes | **Michal**, surgically, then **Bruno** re-runs the affected proofs |
| Founder | none inside the stage; receives the verdict, the decisions taken and any HIGH finding deferred into a story. Control-plane changes in the product repository get Adam's verdict (R-8.2) |

## Input and output

- **Input:** a change record at `Stage: ACCEPTANCE-TEST-PROVEN` and the complete diff against `main`.
- **Output:** `## Review Verdict` filled, blockers fixed and retested, `Review outcome: REVIEW-CLEARED`, `Stage: REVIEW-CLEARED`.

## Hard rule

One model reviewing its own diff is proofreading, not review (R-6.1). Green targeted tests never overrule a credible correctness, security or maintainability finding (R-6.11). The builder does not self-certify HIGH work.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10). Red means stop: a session in the wrong folder is started again from the project root; a budget stop goes to the founder for a raise, a split or an escalation.
1. **Scope the diff.** `git diff main...HEAD --stat`. Compare against the declared file set and explain every out-of-scope change, including tests, docs, configuration, generated files, dependencies and control-plane files (R-8.4). Map paths and risks to lenses using the risk register and the project's review triggers.
2. **Fan out, in parallel, in one message.** Brief only the personas the roster assigns to Review plus the lenses the record's Required specialists table names, sized by the story (R-6.5), each with a bounded brief (R-6.6). Each reports in its own numbering (A-n, S-n, T-n, D-n, and the project's own) and forms findings before reading the builder's conclusions (R-6.3). Treat every handoff as untrusted until checked against the diff and deterministic evidence (R-8.7). While they run, do the generalist pass yourself: correctness and edge cases nobody else owns; the human-written check and no invented API (R-9.1, R-9.2); the simplicity and readability check, where over-engineering, unreadable code, speculative abstraction and unrequested generality are findings with a concrete simpler alternative (R-9.11); the scope pass, where drive-by changes are findings, not bonuses; the test diff: deleted or weakened assertions, changed mocks, narrowed data, new skips or retries, bypassed setup (R-3.13); control-plane changes get a named human owner verdict (R-8.2). A project reviewer that is not available as an agent type runs as a general-purpose agent that reads its charter file first, read-only, and the verdict says so; plan about 100k tokens per reviewer (R-6.6). Save each report the moment it arrives as `findings/clear-review-STORY-NNN-<reviewer>.md` in the records folder; a resumed stage reads those first and re-runs only reviewers that never reported (R-6.18).
3. **The independent reviewer, Risk above LOW.** Run the pack builder in `review` mode: charter, record and diff in one pack. `--auto` sends it to the other family's API and returns the findings as `X-n`; if the API fails, record it, declare the skip and continue (R-6.7). Judge only, never gate. A skip is declared in the verdict (R-6.7). Write the result as one line in the verdict, `Second opinion:` with the X-n findings, or `skipped` with the reason when the script reports "NOT obtained" (exit 3) (R-6.7).
4. **Consolidate.** One severity-ranked table under `## Review Verdict`: id, severity, file and line, summary, resolution. Same root cause is one row credited to every reviewer who found it. Disproved findings stay with the evidence that closed them; verify against the current file before accepting or dismissing (R-6.9).
5. **Resolve surgically.** CRITICAL and BLOCKER: fix now on this branch, rerun the narrow tests and repeat the affected acceptance proofs. HIGH: fix now, or defer it into a new, linked backlog story with the reason recorded and reported to the founder. MEDIUM and LOW: fix if under fifteen minutes, otherwise a backlog story. A fix that wants to grow becomes a story. A fix that changes scope, design or a public contract returns to the owning earlier stage (R-6.10).
6. **Verify and hand off.** Run the fast gate and the narrow targets the fixes touched. Record reviewers, findings, fixes, retests, remaining risks and required human acceptance. Set `Review outcome: REVIEW-CLEARED` and `Stage: REVIEW-CLEARED`. Sipk.ai appends the spend line naming each reviewer's harness-measured tokens (R-7.11). Update the board and point the founder at `/test-regression` in a fresh session; the full matrix must certify this exact reviewed candidate.

## Scripts and checks

```bash
bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN        # first, before any cd: folder and budget
git diff main...HEAD --stat
bash sipkai-pod/sdlc/scripts/second-opinion.sh STORY-NNN review [--auto]
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast
```

## Model tier and budget

Always `top`, with high effort (R-6.12). Lenses run `top`. The independent reviewer is the other family's top model. Fan out to judge, never to type (R-7.15).

## Exit condition

Every BLOCKER and CRITICAL fixed and retested; every HIGH fixed or deferred by the founder into a linked backlog story.

## Rules that bind this stage

R-3.13, R-3.14, R-6.1 to R-6.12, R-6.15, R-7.11, R-7.15, R-8.2, R-8.4, R-8.7, R-9.1, R-9.2, R-9.11, R-9.12.

## Found a weakness in the method?

Log it in `method/IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
