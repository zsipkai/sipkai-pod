# SADR-006: A digital agile team, organised top-down, that starts from a project description

- Date: 2026-10-29
- Status: Accepted
- Owner: Zoltán Šipkai
- Evidence: the founder's instructions in chat on 2026-10-29: a hierarchical structure with a main CLAUDE.md, the team, and the process with its scripts and skills; a team that can be given a backlog and knows what to do; a business case before a backlog; a Sprint 0 with backlog, plan, UI and mocks, design system, accesses and a proof of concept; every artefact created in the project folder, never in the pod; a fully automatic flow, "a digital agile team". Tina's triage of the same day: no intake, no retrospective, budgets that did not predict.

## Decision

- **The team charter comes first** (`agents/CHARTER.md`, R-1.7): vision, mission, the mandate to be the best, the quickest and the cheapest AI delivery team in the world, and eleven agreements in priority order that outrank every other page; only the founder's own word outranks it. The founder called it the alpha and omega of the team.

- **Top-down structure.** `CLAUDE.md` is the top (what the pod is, the key rules, the flow, how it talks, what it keeps), with `AGENTS.md` as the same file for other harnesses. Under it: `agents/` (the team), `sdlc/` (the process: the flow, `RULES.md`, `skills/`, `scripts/`, `evals/`), `templates/` (the artefacts the team creates in a project), `method/` (the pod's own decisions and improvement log).
- **Sprint 0 before any story** (R-2.20), opened by a business case the founder says go to (R-2.21); new steps `/sprint-zero`, `/business-case`, `/define-backlog`, `/design-ui`, `/prove-concept`.
- **Erik, UX and UI Designer**, joins the team, with a clean, modern, Apple-like style and a UX lens.
- **Sprints.** The founder names a story or approves a sprint of stories; the pod runs them one after another on its own (R-2.13).
- **The project workspace** (R-8.19): every artefact lives in the folders `sdlc.config.sh` names (default `delivery/`), created by `adopt.sh`.

## Consequences

A project can be handed to the pod as a description and comes back ready to develop after Sprint 0. The plugin declares `./sdlc/skills/` and its nine persona files explicitly. Every path inside the pod moved; projects move their pin and their references once.

## Review trigger

The first project adopted from scratch through Sprint 0, or a harness that cannot load skills from `sdlc/skills/`.
