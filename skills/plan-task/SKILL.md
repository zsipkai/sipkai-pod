---
name: plan-task
description: Sipk.ai POD stage 1, Plan. Turns one DEFINED backlog story into a change record at PLANNED with a Discovery Brief, acceptance map, routing and budget. Use when the founder invokes /plan-task with a story id or asks to plan a story. Writes no production code.
---

# Stage 1 · Plan · `/plan-task`

**Proves:** the change is understood: discovery, scope, risks, acceptance map, routing.
**Cost of a miss caught here:** minutes.

## Who

| | |
|---|---|
| Accountable, does the work | **Marketa** (Architect) |
| Consulted | **Miro** confirms the story is ready and the criteria say what the product needs; **Bruno** on the acceptance map's proofs; **Adam** when the surfaces touch security, money or data; **Tina** on the budget |
| Orchestrates | **Sipk.ai**, who briefs Marketa, writes the ledger line and reports to the founder |
| Founder | selects the story and names it; this is how a story starts (R-2.13) |

## Input and output

- **Input:** a story id (`STORY-NNN`) whose card in the stories folder (`SDLC_STORIES_DIR` in `sdlc.config.sh`) has `Status: DEFINED`.
- **Output:** the change record in the change-records folder (`SDLC_RECORDS_DIR`), created from `templates/change-record.md`, Discovery Brief filled, `Planning outcome: PLANNED`, `Stage: PLANNED`.

## Hard rule

No production code and no edits outside the change record, the story card and the board. Planning that "just quickly fixes" something has skipped five gates. Contradictions and missing facts become blockers, never plausible assumptions.

## Steps

1. **Clean start.** `git status`: if not on `main` or the tree is dirty, stop and ask whether to stash, commit or abort. Pull `main` when a remote exists. Check the story number has no change record yet; parallel sessions have collided on numbering before.
2. **Read the story.** Load the card and its ready checklist. Stop if the owner, risk, size, non-goals, dependencies or falsifiable acceptance criteria are missing (R-2.14), or if a blocking story on the board is not `DONE` (R-2.13). Fixing the story is a conversation with Miro and the founder, not a guess.
3. **Check prior decisions first.** Search the project's and the method's decision folders by keyword before making a technical choice or asking the human anything (R-5.8).
4. **Explore the code and the right docs.** Map the blast radius with a read-only explore agent: files to change, tests that cover them, contracts involved. Read the rules for every surface touched (the project's required-reading table), the governance rules always, and the living docs the story affects. Record every source in the context manifest as `TRUSTED`, `VERIFIED` or `UNTRUSTED` with how material claims were checked (R-8.8). Grep before reading; never load whole folders (R-7.14).
5. **Write the Discovery Brief.** Copy the template to `SDLC_RECORDS_DIR/STORY-NNN.md` and fill every subsection: outcome, non-goals, current behavior and observations; the facts a fresh session needs inline, every acceptance-critical limit, identifier, formula, rounding rule and copy string (R-2.10); declared scope and runtime authority: files, control-plane files, dependencies, tools, network, credentials (R-8.4); affected owners and contracts with the both-side contract tests and doc updates the diff must include (R-3.3); unknowns and blockers; dependency-ordered development tasks sized for review, verified paths separated from hypotheses; the acceptance map with a primary proof and an adverse, boundary or error proof per criterion, its layer, a UI proof for anything a person sees, and (live) criteria named (R-3.1, R-3.2, R-3.7); the risk register with rollback per surface and the one thing most likely to break; required lenses and human checkpoints by risk tier (R-5.2).
6. **Route and budget.** Copy Size and Risk from the card; raise them if exploration shows more risk, never lower them (R-5.4). Assign `Execution model: small | mid | top` from risk and ambiguity (R-7.2). Money, security, data, concurrency and control-plane work is `top`. Test authoring caps at `mid`, except tests that encode a control-plane or security control (R-7.3). Set `Budget:` from the size table (R-7.9); an XXL story is split before this stage ends. Declare the `Lane:` (R-4.1).
7. **Set the outcome and hand off.** Set `Planning outcome: PLANNED` and `Stage: PLANNED`, link the record from the story, set the story to `IN DELIVERY`, update the board's Stage column. Sipk.ai appends `Tokens spent (plan-task): n` from harness-measured usage (R-7.11). Run the change-record check. Report the record path and the decisions taken to the founder, then start `/validate-design` in a fresh session yourself (R-2.12). If anything blocked planning, stop; a blocker keeps the last proven stage.

## Scripts and checks

```bash
bash sipkai-pod/scripts/check-change-records.sh
```

## Model tier and budget

Marketa runs `top`. Exploration may be delegated to a `small` read-only agent that returns raw lists. The whole-pipeline budget is set here and this stage's spend is the first ledger line.

## Exit condition

A fresh session could explain the current system, the intended outcome, the risks, the proofs and the task order from the record alone.

## Rules that bind this stage

R-2.3, R-2.10, R-2.13, R-2.14, R-3.1, R-3.2, R-3.7, R-4.1, R-5.4, R-5.7, R-5.8, R-7.2, R-7.3, R-7.9, R-7.11, R-7.14, R-8.4, R-8.8.

## Found a weakness in the method?

Log it in `IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, note it under "SDLC findings" in the record, and tell the founder. Never apply it yourself (R-1.1).
