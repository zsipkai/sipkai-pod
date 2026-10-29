# PROJECT-NAME Agent Constitution

PROJECT-NAME is ... (one paragraph: what the product does, for whom, the stack).

## How work happens here

PROJECT-NAME is built by the **Sipk.ai POD**, included as `sipkai-pod/`. The team works by its charter `sipkai-pod/agents/CHARTER.md`; the main page is `sipkai-pod/CLAUDE.md`, the flow `sipkai-pod/sdlc/README.md`, the rules `sipkai-pod/sdlc/RULES.md`, the team `sipkai-pod/agents/README.md`. This project's choices within the method (model tiers, gate stages, tailoring, bootstrap) are in `docs/SDLC-PROJECT.md`; `sdlc.config.sh` is the bridge.

Everything the team makes for this project lives in the workspace folders `sdlc.config.sh` names. A new project starts with `/sprint-zero`; after it, the founder names a story or approves a sprint, and each story runs the route its size sets (S, M, L, XL; an XXL is split first), as `sipkai-pod/sdlc/README.md` describes.

## Product rules that override convenience

1. ...

## Private material

What agents must never read, copy or quote, and where synthetic fixtures live. The harness's deny rules (in Claude Code `.claude/settings.json`) enforce it with deny rules.

## Required reading by surface

| Surface | Read before editing |
|---|---|
| Every diff | `sipkai-pod/sdlc/RULES.md` section 9 |
| Control plane, permissions, secrets | `sipkai-pod/sdlc/RULES.md` section 8, `docs/rules/security.md` |
| Testing and evidence | `sipkai-pod/sdlc/RULES.md` section 3, `docs/rules/testing.md` |

## Quick commands

```bash
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast     # every commit (the hook)
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --full     # regression proof
bash sipkai-pod/sdlc/evals/run-evals.sh              # prove the checks still catch known failures
```

## Document map

| Document | Truth it owns |
|---|---|
| `docs/SDLC-PROJECT.md` | this project's choices within the method |
| `sdlc.config.sh` | the project's gate stages and truth files |
| `backlog/BACKLOG.md` | story order, status and what is done |
