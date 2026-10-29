---
name: design
description: Sipk.ai POD standard track, session 1 of 3. Plans and validates one story in a single session: the Discovery Brief and the Design Verdict, by Marketa with at most two lenses. Use for a standard-track story (Size S or M, LOW or STANDARD risk, outside the rapid limits). A full-track story uses /plan-task and /validate-design instead.
---

# Design · `/design` (standard track)

**Proves:** the change is understood and the smallest design that meets every criterion survived attack on paper.
**Leaves:** `Stage: DESIGN-VALIDATED`, with the Discovery Brief and the Design Verdict filled.

## Who

Marketa (accountable, does the work); at most two lenses chosen for the story's surfaces (R-6.1); Erik when the story changes a screen; Tina checks the budget. Sipk.ai orchestrates.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.1, R-7.2).
1. **Plan**, as `/plan-task` describes, briefly: outcome, the facts a fresh session needs inline, scope, the acceptance map with a proof that can fail for each criterion, risks with rollback, routing and budget. Confirm `Track: standard` and its one-line reason; anything that belongs to the full track (R-2.8) moves the story up now.
2. **Validate**, as `/validate-design` describes, briefly: attack the brief yourself with the claims checklist (R-6.4), then brief at most two lenses in parallel. No second opinion here; it runs once, on the diff, at `/ship` (R-6.2).
3. **Verdict.** Findings consolidated; QUESTIONs answered with the best-supported option and reported (R-6.3). Set `Planning outcome` and `Design outcome`, `Stage: DESIGN-VALIDATED`, append the spend line, hand off to `/build` in a fresh session.

## Exit condition

A fresh session can build the story from the record alone; every criterion has a planned proof that can fail.

## Rules that bind this step

R-2.3, R-2.6, R-2.8, R-6.1, R-6.4, R-7.1, R-7.2, R-7.3.
