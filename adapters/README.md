# Adapters: what a harness must supply

The pod is Markdown, shell and Python. Its pages say what to do; its gate and checks run anywhere. A coding harness (the program the agents run in) has to supply five things the pages cannot. This page lists them; each supported harness has a folder here that says how it supplies them.

| The pod needs | Why | Rule |
|---|---|---|
| **A way to load the pages.** The main file (`CLAUDE.md`, also `AGENTS.md`) in every session; the step pages as commands or as pages the session is pointed at; the member pages as subagent briefs. | Every member works from the same charter, rules and step | R-1.1 |
| **Fresh sessions or fresh subagents.** Sipk.ai starts each step with only the record; reviewers must not see the builder's context. | Long sessions re-pay their history; independent review needs separate context | R-2.4, R-6.1 |
| **Deny rules.** A way to refuse commands and paths per project: private folders, force pushes, `--no-verify`, credential tools, destructive cloud commands. A harness without them must be run inside an operating-system sandbox that does the same. | Least authority is enforced by the harness, not by instructions | R-8.1 |
| **A model per brief.** The orchestrator chooses the tier (`small`, `mid`, `top`) for each subagent it briefs; member pages name tiers, never a vendor's model. | Risk picks the model | R-7.1 |
| **A usage report.** The tokens a session and its subagents used, so a ledger line can say `measured`; without one, every line says `estimate`. | The repository computes its own bill | R-7.3 |

A harness that supplies all five runs the pod as written. One that lacks any of them still runs it, and the project's `docs/SDLC-PROJECT.md` says which control is missing and what replaces it.

| Harness | Folder |
|---|---|
| Claude Code | `claude-code/` |
