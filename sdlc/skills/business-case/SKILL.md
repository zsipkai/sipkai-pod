---
name: business-case
description: Sipk.ai POD, Sprint 0 step 1. Writes the business case for a project or a large new capability and recommends go or no-go, with the cost to build in tokens and money. Use before a backlog is cut, or when the founder asks whether something is worth building. Writes no code and creates no backlog.
---

# Business case · `/business-case`

**Proves:** the work is worth doing, at a cost the founder has seen, before any backlog or code exists.
**Cost of a miss caught here:** nothing yet spent. Caught after Sprint 1 it costs everything built so far.

## Who

| | |
|---|---|
| Accountable, does the work | **Miro** (Product Owner) |
| Consulted | **Tina** the cost to build from the ledger of past stories and the model prices; **Marketa** the feasibility and the biggest technical risk; **Adam** the risk from data, money, privacy or regulation |
| Founder | decides go, no-go or change, with his name and date |

## Input and output

- **Input:** the founder's description, a demo, a market note, or a capability he wants added.
- **Output:** `business-case.md` in the project workspace, from `sipkai-pod/templates/business-case.md`, ending in a recommendation and the founder's decision.

## Hard rule

A case is an argument, not a brochure: every claim about users, market or cost names its source, and a number nobody measured is labelled an estimate. If the honest answer is "do not build this", the case says so (R-2.21).

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh CASE` (R-8.18).
1. **The problem and the users.** Who has the problem, how they solve it today, what it costs them. Sources named.
2. **The outcome.** What a user can do when the first release ships, in one paragraph, and how the founder will know it worked (one or two measurable signals).
3. **Scope.** The first release, what comes later, and the non-goals.
4. **Options.** Build, buy, adapt something existing, or do nothing; one line each on why.
5. **Cost and time.** Tina estimates the build from comparable stories in the ledger: stories by size times the measured median spend, priced at today's model rates, plus running costs (hosting, services) for the first year; ranges, not points.
6. **Risks.** The three biggest: product, technical (Marketa), and data, money, privacy or regulation (Adam), each with how Sprint 0 or the first stories retire it.
7. **Recommendation.** Go, no-go, or go with a changed scope, in one sentence with the reason. Sipk.ai puts it to the founder with the cost range and the three risks. His decision is written into the case with his name and date.

## Exit condition

The case names the problem, users, outcome, scope, options, cost range and risks, and carries the founder's go, no-go or change.

## Rules that bind this step

R-2.21, R-5.7, R-7.9, R-7.11, R-8.7.
