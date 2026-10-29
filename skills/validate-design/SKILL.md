---
name: validate-design
description: Sipk.ai POD stage 2, Validate, the devil's-advocate gate. Adversarially challenges a PLANNED change record for fit, simplicity, contracts, security, testability, rollback and routing, fans out lenses and the independent reviewer, and produces a DESIGN-VALIDATED verdict or recorded blockers. Use after /plan-task and before any code.
---

# Stage 2 · Validate · `/validate-design`

**Proves:** the design survives adversarial and specialist attack on paper.
**Cost of a miss caught here:** minutes. Bad designs become bad code at ten times the cost; this is the cheapest place to kill a mistake.

## Who

| | |
|---|---|
| Accountable, does the work | **Marketa** (Architect), attacking her own brief as devil's advocate |
| Consulted, in parallel | **Adam** (security lens), **Miro** (domain lens and the project's own lenses), **Ivan** when infrastructure or deploy authority changes |
| Outside the team | the **Independent reviewer** on any record above LOW risk |
| Orchestrates | **Sipk.ai**, who fans out, consolidates and relays |
| Founder | design approval at CRITICAL only; production or account-level authority; a billable resource no story declared. Everything else Sipk.ai decides and reports (R-5.2, R-6.13) |

## Input and output

- **Input:** a change record at `Stage: PLANNED`.
- **Output:** a filled `## Design Verdict` and `Stage: DESIGN-VALIDATED` with `Design outcome: DESIGN-VALIDATED`, or the record stays `PLANNED` with the blockers that remain.

## Hard rule

Never clear politely, and never rewrite the proposal until objections disappear (R-6.14). The whole pipeline inherits this gate's honesty. No production code.

## Steps

0. **Start check.** `bash sipkai-pod/scripts/stage-start.sh STORY-NNN`, before any `cd` (R-8.18, R-7.10). Red means stop: a session in the wrong folder is started again from the project root; a budget stop goes to the founder for a raise, a split or an escalation.
1. **Attack the Discovery Brief yourself.** Read it cold and try to break it. Evidence: every named file, symbol, decision, owner and number is checked against the repository, not trusted; "follows the pattern in X" means open X. Completeness: does the file list cover everything the scope implies, including the doc updates the drift gate will demand? Contracts: if a shared constant, schema, route or identifier moves, are both-side tests planned; trace persistence, permissions, money and privacy end to end. Cheaper path and simplicity: name the smallest, most readable change with the same user outcome and make the design justify anything bigger in writing (R-9.4 to R-9.11). Decision conflicts (R-5.8). Single owners per the project's architecture rules. Testability: can each criterion fail; a criterion no test can fail is decoration; judge counterexample quality, not coverage. Rollback: if this ships broken on Friday night, what is the undo, per surface? Isolation: could a fresh session implement from the record alone (R-2.10)? Routing: a `small` or `mid` executor on HIGH, CRITICAL or ambiguous work is a BLOCKER; an over-tiered mechanical task is a NOTE (R-7.2). Authority and money: any new authority, billable resource or control-plane change needs the founder, not this gate (R-5.10). Test mechanics: every timer technique, browser or runtime API, or type package a test in the design relies on is run in a scratch check now or marked as a hypothesis for `/develop-code` to re-check (R-6.16).
2. **Fan out the lenses, in parallel, in one message.** Brief the personas the roster assigns to Validate plus the lenses the record's Required specialists table names. Size the fan-out by the story (R-6.5). Give each a bounded brief (R-6.6). They form findings before reading the planner's conclusions (R-6.3). A small-change record gets one lens (R-4.8). A project reviewer that is not available as an agent type runs as a general-purpose agent that reads its charter file first, read-only, and the verdict says so (R-6.6).
3. **The independent reviewer, Risk above LOW.** Run the pack builder in `design` mode. `--auto` sends the pack to the other family's API and returns the findings as `X-n` rows; if the API fails, record it, declare the skip and continue (R-6.7). Judge only, never gate. If the foreign model cannot judge from the pack alone, the record failed the isolation test; that is a finding (R-6.8). A skip is declared in the verdict (R-6.7). Write the result as one line in the verdict, `Second opinion:` with the X-n findings, or `skipped` with the reason when the script reports "NOT obtained" (exit 3); a small-change record skips this step and says so (R-6.7, R-4.8).
4. **Consolidate into the Design Verdict.** Record the cleared design and the smaller alternative considered, then numbered findings with severity BLOCKER, SHOULD, NOTE or QUESTION, evidence and resolution (R-6.13). Exceptions carry scope, owner, reason, compensating control and expiry (R-5.9). Original concerns are never deleted (R-6.9).
5. **Decisions.** Answer every QUESTION with the best-supported option, record the choice and its reasoning in the verdict (and as a decision record when it settles a rule), and list the choices for the founder's report (R-6.13). Obtain and record the founder's decision only for CRITICAL work, production or account-level authority, and a billable resource no story declared (R-5.2, R-5.10).
6. **Verdict.** All blockers resolved and questions answered: set `Design outcome: DESIGN-VALIDATED` and `Stage: DESIGN-VALIDATED`, Sipk.ai appends the spend line naming each reviewer's harness-measured tokens (R-7.11), update the board, point the founder at `/develop-code` in a fresh session. Otherwise the outcome stays `PENDING` or `BLOCKED`, the stage stays `PLANNED`, and the unresolved list is the output. From here the record is the delivery contract (R-2.11).

## Scripts and checks

```bash
bash sipkai-pod/scripts/stage-start.sh STORY-NNN        # first, before any cd: folder and budget
bash sipkai-pod/scripts/second-opinion.sh STORY-NNN design          # builds the pack for the independent reviewer
bash sipkai-pod/scripts/second-opinion.sh STORY-NNN design --auto   # or sends it to the second family's API
bash sipkai-pod/scripts/check-change-records.sh
```

## Model tier and budget

Always `top`, with high effort; verification never downsizes (R-6.12). Lenses run `top`. The independent reviewer is the other family's top model.

## Exit condition

Every BLOCKER resolved or explicitly overridden by the founder and recorded; every QUESTION answered and the answers reported.

## Rules that bind this stage

R-2.10, R-2.11, R-5.2, R-5.8, R-5.9, R-5.10, R-6.3 to R-6.9, R-6.12 to R-6.14, R-7.2, R-7.11, R-9.4 to R-9.11.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
