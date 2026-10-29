---
name: prove-concept
description: Sipk.ai POD, Sprint 0 step 7 and any story whose design rests on an untried technical assumption. Tries the riskiest assumption end to end on a spike branch and records a measured result. Use when an assumption could invalidate the architecture or a story's design.
---

# Proof of concept · `/prove-concept`

**Proves:** the assumption the architecture leans on hardest is true, measured, before anything depends on it.
**Cost of a miss caught here:** a spike branch. Found in Sprint 2 it costs a redesign.

## Who

| | |
|---|---|
| Accountable | **Marketa** (Architect): names the assumption and the measure of success |
| Does the work | **Michal** builds the thinnest end-to-end slice; **Bruno** proves it with a test that could fail; **Ivan** when it needs infrastructure; **Adam** when it touches security |

## Input and output

- **Input:** the riskiest technical assumption from the architecture sketch or a design, with what would prove it false.
- **Output:** `sprint-0/poc.md` from `sipkai-pod/templates/sprint-0/poc.md`: the assumption, what was built, the commands and their output, the result (proven, disproven, changed), and what it means for the architecture. The code stays on a branch `spike/<name>`, never merged as product code.

## Hard rule

A proof of concept proves one thing and is thrown away. It is measured, not demonstrated: the result quotes a command and its output (R-3.17). It never creates billable or production resources the accesses list does not hold, and never touches real data.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh POC` (R-8.18).
1. **Name it.** The assumption in one sentence, the measure that would prove it false, and the time box.
2. **Build the thinnest slice** that exercises it end to end, on `spike/<name>`.
3. **Measure.** Run it; quote the commands and output; Bruno's test shows it can fail.
4. **Decide.** Proven: the architecture stands. Disproven or changed: Marketa revises the architecture sketch and the affected stories before Sprint 1.

## Exit condition

`poc.md` records a measured result and its consequence; the spike branch is named and not merged.

## Rules that bind this step

R-3.17, R-3.18, R-6.17, R-8.9.
