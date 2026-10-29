# Sipk.ai POD

**A digital agile team of AI agents that you can drop into any project. Give it a project description and it knows what to do: business case and feasibility, backlog, Sprint 0, then development, story by story, with evidence at every step and one human who owns every decision that matters.**

Version 2.7.0 (2026-10-29). By Sipk.ai, Zoltán Šipkai. MIT licensed.

## Start here

Read `CLAUDE.md`. It says what the pod is and holds the map, in which every fact has exactly one home: the charter, the team, the flow, the rules, the step pages, the templates and the pod's own history.

## Adopting it in a project

The whole pod comes into a project as one folder, `sipkai-pod/`, pinned to a commit. Nothing is copied by hand.

```bash
git init                                   # if the project is new
git submodule add https://github.com/zsipkai/sipkai-pod.git sipkai-pod
bash sipkai-pod/sdlc/scripts/adopt.sh      # bridge, constitution, workspace, secret-scan config, project page
git add -A && git commit -m "Adopt the Sipk.ai POD"
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast   # green on day one
```

Then give the team the project description with `/sprint-zero`. Everything after that is in `CLAUDE.md`. A harness other than Claude Code reads `adapters/README.md` first.

**Upgrading** a project is moving the submodule to a newer commit, reading the diff, replaying the evaluations and re-running the gate (`method/decisions/SADR-004`).

## Quick commands inside a project

```bash
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --fast    # every commit (the hook runs it)
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --full    # regression proof and CI
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --ui      # adds UI journeys and accessibility
bash sipkai-pod/sdlc/scripts/sdlc-gate.sh --deploy  # release-bound work
bash sipkai-pod/sdlc/evals/run-evals.sh             # prove the checks still catch known failures
bash sipkai-pod/sdlc/scripts/cost-report.sh         # the bill, from the change records
```

## Lineage

Version 1.x lived inside the Money Review repository as `sipkai-sdlc/` and merged the founder's AI SDLC starter kit v3 with the production pipeline of the Kid Storytime iOS app. Version 2.0.0 is the same rules in their own repository, run by a named pod (`CHANGELOG.md`, `method/decisions/MIGRATION-1.2-to-2.0.md`).
