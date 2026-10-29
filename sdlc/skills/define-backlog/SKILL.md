---
name: define-backlog
description: Sipk.ai POD intake, before Plan. Turns a project description, a product brief or a new feature request into an ordered backlog of DEFINED and IDEA stories on the board, with size, risk, dependencies and a proposed order. Use when the founder gives the pod a project or a large new capability and asks for a backlog. Writes no code and starts no story.
---

# Intake · Define the backlog · `/define-backlog`

**Proves:** the work is understood as a backlog: every story is small enough to deliver, has criteria that can fail, and sits in an order the founder can pick from.
**Cost of a miss caught here:** minutes. A missing or wrongly cut story found at Plan costs a stage; found at Review it costs a story.

## Who

| | |
|---|---|
| Accountable, does the work | **Miro** (Product Owner) |
| Consulted | **Marketa** cuts stories along technical seams and sizes them; **Adam** names the risk tier of anything touching security, money, data or permissions; **Tina** checks each size against the measured spend of past stories |
| Orchestrates | **Sipk.ai**, who briefs Miro, writes the ledger line and reports to the founder |
| Founder | gives the description, answers the open questions, names the story that goes into development (R-2.13) |

## Input and output

- **Input:** the business case the founder said go to (R-2.21), with the project description, a demo or a feature request behind it.
- **Output:** story cards in the stories folder (`SDLC_STORIES_DIR`) from `templates/backlog/story.md`, each at `DEFINED` (ready) or `IDEA` (not ready, with what is missing); the board (`SDLC_BOARD`) from `templates/backlog/backlog.md` with epics, the proposed order and the open questions; one short message to the founder.

## Hard rule

No code, no change record, no stage started. The board's order is a proposal: the founder names every story that goes into development (R-2.13) and may reorder at any time. A gap in the description becomes a question for him, never a plausible guess (R-5.7).

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh INTAKE`, before any `cd` (R-8.18); only the folder part applies.
1. **Read the description and what exists.** The founder's description, the existing board and stories, the product docs and the decisions. Never re-cut a story that is already in delivery.
2. **Find the outcomes.** List what a user can do when the product or capability is done, in the product's words. Group them into epics, each with one sentence of value.
3. **Cut stories.** One story is one observable outcome a user or operator can check, with criteria that can fail (R-2.14). Cut along the seams Marketa names: a foundation story first where nothing else can start without it, then thin vertical slices. A story Marketa sizes XXL is split now (R-7.9).
4. **Size, risk and dependencies.** Size from Marketa against the measured table (R-7.9), risk from the risk tiers (R-5.1) with Adam's word on anything sensitive, dependencies as story ids. Tina flags a size that the ledger of similar past stories contradicts.
5. **Order by the prioritisation rule (R-2.19).** Blockers first; then the story that retires the biggest open risk or assumption; then value to the user per size; the founder's own order always wins. Write one line per story saying why it sits where it does.
6. **Mark readiness.** `DEFINED` when the card passes the Defined gate (R-2.14); otherwise `IDEA` with the missing piece named. Acceptance-critical facts go into the card inline.
7. **Hand off.** One message to the founder: the epics in one line each, the top five stories in order with one reason each, the open questions as one list with a recommendation each, and the story the pod recommends he names first. Sipk.ai appends `Tokens spent (define-backlog): n` to the board's intake note from harness-measured usage.

## Scripts and checks

```bash
bash sipkai-pod/sdlc/scripts/stage-start.sh INTAKE        # first, before any cd: the folder
bash sipkai-pod/sdlc/scripts/check-md-links.py            # cards and board link correctly
```

## Model tier and budget

Miro and Marketa run `top` for cutting and ordering; grooming an existing board runs `small` (R-7.4). One intake of a whole project aims at a Size M budget.

## Exit condition

Every outcome in the description is covered by a story or named as out of scope; every story has a size, a risk, its dependencies and a reason for its place; the top of the board holds at least one `DEFINED` story.

## Rules that bind this step

R-2.13, R-2.14, R-2.19, R-5.1, R-5.7, R-7.4, R-7.9, R-8.18.

## Found a weakness in the method?

Log it in `method/IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, and tell the founder. Never apply it yourself (R-1.1).
