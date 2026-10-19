# PROJECT-NAME Agent Constitution

PROJECT-NAME is ... (one paragraph: what the product does, for whom, the stack).

## How work happens here

PROJECT-NAME is built by the **Sipk.ai POD**, included as `sipkai-pod/`. The pillars are `sipkai-pod/AGENTS.md`, every rule is in `sipkai-pod/RULES.md`, the route is `sipkai-pod/PIPELINE.md` and the people are `sipkai-pod/TEAM.md`. This project's choices within the method (model tiers, gate stages, tailoring, bootstrap) are in `docs/SDLC-PROJECT.md`; `sdlc.config.sh` is the bridge.

Stories live in `backlog/stories/`, the board is `backlog/BACKLOG.md`, the evidence is in `backlog/change-records/`. Work stories in the order the board gives, one at a time, each stage in a fresh session:

`/plan-task` -> `/validate-design` -> `/develop-code` -> `/test-acceptance` -> `/clear-review` -> `/test-regression` -> `/deploy-change`

## Product rules that override convenience

1. ...

## Private material

What agents must never read, copy or quote, and where synthetic fixtures live. `.claude/settings.json` enforces it with deny rules.

## Required reading by surface

| Surface | Read before editing |
|---|---|
| Every diff | `sipkai-pod/RULES.md` section 9 |
| Control plane, permissions, secrets | `sipkai-pod/RULES.md` section 8, `docs/rules/security.md` |
| Testing and evidence | `sipkai-pod/RULES.md` section 3, `docs/rules/testing.md` |

## Quick commands

```bash
bash sipkai-pod/scripts/sdlc-gate.sh --fast     # every commit (the hook)
bash sipkai-pod/scripts/sdlc-gate.sh --full     # regression proof
bash sipkai-pod/evals/run-evals.sh              # prove the checks still catch known failures
```

## Document map

| Document | Truth it owns |
|---|---|
| `docs/SDLC-PROJECT.md` | this project's choices within the method |
| `sdlc.config.sh` | the project's gate stages and truth files |
| `backlog/BACKLOG.md` | story order, status and what is done |
