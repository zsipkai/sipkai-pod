---
name: sprint-zero
description: Sipk.ai POD Sprint 0. Takes a project from a description to the point where the team can deliver stories on its own: business case and go decision, workspace, backlog, release plan and architecture sketch, UI mocks and design system, accesses, proof of concept, and a green gate. Use when the founder gives the pod a new project or a project that has no backlog yet.
---

# Sprint 0 · `/sprint-zero`

**Proves:** the team is ready to deliver: the project is worth doing, the backlog is ordered, the riskiest assumption is proven, the screens and tokens exist, every access is in place, and the gate is green on an empty change.
**Cost of a miss caught here:** a day. Found in Sprint 1 it costs a story; found at release it costs the release.

## Who

| | |
|---|---|
| Accountable | **Sipk.ai** (Engineering Director) runs Sprint 0 and owns its exit |
| Does the work | **Miro** the business case and the backlog; **Marketa** the release plan, the architecture sketch and the proof of concept's design; **Erik** the mocks and the design system; **Ivan** the accesses, the workspace and the gate; **Michal** the proof of concept's code; **Bruno** its proof; **Adam** the security lens on the accesses and the architecture; **Tina** the budget of the backlog |
| Founder | gives the description; decides go or no-go on the business case; approves the mocks; creates the account-level accesses only he can create; names the first story or approves the first sprint |

## Input and output

- **Input:** the founder's description of the project, a demo, documents he names, or an existing repository without a backlog.
- **Output:** the project workspace (`SDLC_WORKSPACE`, default `delivery/`) holding the business case, the board and ready stories, `sprint-0/` (release plan, architecture sketch, mocks, design system, accesses, proof of concept), the first decision records, and a green gate. Sprint 0's spend is one ledger in `sprint-0/README.md`.

## Hard rule

Sprint 0 is time-boxed (aim: one to three working days of the founder's calendar) and is not a mini waterfall. Every document is the least that lets Sprint 1 start safely. No product feature is built: the proof of concept is thrown away or kept only as a spike branch. A no-go on the business case ends Sprint 0 with the case filed and nothing else created.

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh SPRINT-0`, before any `cd` (R-8.18).
1. **Business case** (`/business-case`, Miro with Tina and Marketa). Problem, users, outcome, scope and non-goals, the first release, risks, the cost to build in tokens and money, and a recommendation. **Gate: the founder says go or no-go** (R-2.21).
2. **Workspace and bridge** (Ivan). Run `bash sipkai-pod/sdlc/scripts/adopt.sh`: it creates `sdlc.config.sh`, the project's `AGENTS.md` and the workspace folders. Everything project-specific lives there, never in `sipkai-pod/` (R-8.19).
3. **Backlog** (`/define-backlog`, Miro). Epics, stories with criteria that can fail, sizes and risks, the proposed order with a reason per story (R-2.19). The first release is marked on the board.
4. **Plan** (Marketa). `sprint-0/release-plan.md`: the milestones, the first sprint's stories, what is deliberately left out. `sprint-0/architecture.md`: one page and one diagram of the components, data and boundaries, the stack and why, the riskiest technical assumption; each lasting choice also becomes a decision record (R-5.8).
5. **UI and mocks, design system** (`/design-ui`, Erik). Clickable HTML mocks of the screens of the first release and `sprint-0/design-system.md` with tokens, components and their states. **Gate: the founder approves the mocks** or says what to change.
6. **Accesses** (Ivan with Adam). `sprint-0/accesses.md`: every repository, cloud account, service, key and permission the work needs, who creates it, where the secret lives (never in the repository), the least authority each persona gets, and the deny rules in the harness settings (R-8.4 to R-8.6). The founder creates what only he can create; the pod checks each access with a read-only command and records it.
7. **Proof of concept** (`/prove-concept`, Marketa with Michal and Bruno). The riskiest technical assumption is tried end to end on a spike branch with a measured result: proven, disproven or changed. A disproven assumption returns to step 4.
8. **Gate and CI** (Ivan). The project's gate stages are configured, the hook is installed, CI runs the same gate, and `sdlc-gate.sh --fast` is green on the empty project (bootstrap lane, R-4.6).
9. **Ready to develop.** Sipk.ai checks the exit list below, writes Sprint 0's ledger, and reports to the founder in one message: the go decision, the first release, the top five stories, the mocks link, open accesses, the proof of concept's result, and the recommended first story or first sprint.

## Exit: ready to develop (R-2.20)

- [ ] The business case says go, with the founder's name and date.
- [ ] The board holds the first release, ordered, with at least the first sprint's stories `DEFINED`.
- [ ] The release plan and the architecture sketch exist; lasting choices have decision records.
- [ ] The founder approved the mocks; the design system has tokens and the components of the first release.
- [ ] Every access in `accesses.md` is granted and checked, or owned by the founder with a date.
- [ ] The proof of concept has a measured result.
- [ ] `sdlc.config.sh` is filled, the hook installed, CI runs the gate, and the fast gate is green.

## Scripts and checks

```bash
bash sipkai-pod/sdlc/scripts/stage-start.sh SPRINT-0     # first, before any cd: the folder
bash sipkai-pod/sdlc/scripts/adopt.sh                    # the bridge, the constitution, the workspace
bash sipkai-pod/sdlc/scripts/install-hooks.sh
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast
```

## Model tier and budget

Planning, design and the business case run `top`; mocks and the design system `mid`; the proof of concept at the tier its risk routes. Sprint 0 aims at a Size L budget (R-7.9).

## Rules that bind this step

R-2.13, R-2.19, R-2.20, R-2.21, R-4.6, R-5.8, R-6.17, R-8.4 to R-8.6, R-8.18, R-8.19.

## Found a weakness in the method?

Log it in `sipkai-pod/method/IMPROVEMENTS.md` as `PROPOSED` with evidence and the exact change, and tell the founder. Never apply it yourself (R-1.1).
