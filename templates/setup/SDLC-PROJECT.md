# How this project applies the Sipk.ai POD

The method is the Sipk.ai POD, included as `sipkai-pod/` at a pinned commit (the commit is the version). This page records only this project's choices within it.

## Models

| Tier | Model today |
|---|---|
| `small` | <model> |
| `mid` | <model> |
| `top` | <model> |
| Second opinion | <another family's top model, its endpoint and where its key lives (never in the repository)> |

## Gate stages

Which commands each stage of `sdlc.config.sh` runs, and the story that configured it. A stage declared `sdlc_none` has nothing to run yet; it must be configured before the first story builds code.

| Stage | Command | Configured by |
|---|---|---|
| static analysis | <command or none yet> | <story> |
| fast tests | | |
| build | | |
| full tests | | |
| UI journeys and accessibility | | |
| deployment checks | | |

## Bootstrap lane

The one-time sequence before the gate exists, never repeated:

1. `git init`, add the pod (`git submodule add <pod repository> sipkai-pod`), run `bash sipkai-pod/sdlc/scripts/adopt.sh`, commit.
2. `bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast` is green with every code stage declared none; install the hook with `bash sipkai-pod/sdlc/scripts/install-hooks.sh`.
3. Run `/sprint-zero`. The first story that adds code configures the stages it needs.

## Tailoring

<This project's own choices: where it deploys, who approves what beyond the method, retired phrases, anything a reviewer must know.>
