# SADR-004: The Sipk.ai POD lives in its own repository, is included by projects and loads as a plugin

- Date: 2026-10-19
- Status: Accepted (Zoltán Šipkai, 2026-10-19)
- Owner: Zoltán Šipkai
- Evidence: SADR-003 isolated the method in a folder but left the seven skills and the reviewer agents at the product repository's root because the harness required it, and named "a second project adopts the method" as the trigger to revisit. The founder wants a generic team of agents he can give to any project, with every project's own instructions kept apart, usable from any AI harness. Claude Code plugins now ship skills and agents from their own repository.

## Decision

- The method is the repository `sipkai-pod`, named Sipk.ai POD: pillars, rulebook, pipeline, team, stage pages, persona pages, lenses, templates, scripts, evaluations, decisions, improvement log. Nothing product-specific is inside it.
- A project includes the whole repository as the git submodule `sipkai-pod/`, pinned to a commit. Nothing is copied by hand; the gate, the hook and CI run from the included folder, which needs no harness. `sdlc.config.sh` remains the only bridge (SADR-003).
- Stage pages are the skills and persona pages are the agents. `.claude-plugin/` makes the repository a Claude Code plugin and its own local marketplace, loaded from the included folder through the project's `.claude/settings.json`. `AGENTS.md` holds the pillars for every harness; `CLAUDE.md` only loads it.
- A product repository keeps its constitution with its product rules, its own lenses, its deny rules, its gate stages and its choices within the method (`docs/SDLC-PROJECT.md`).
- The improvement log lives with the method. A row written during a project's story is committed in the included repository and the project moves its pin.

## Consequences

Upgrading a project is: move the submodule to the new commit, read the diff, replay the evaluations, re-run the gate. Giving the pod to a new project is: add the submodule and run `scripts/adopt.sh`. Publishing the method is: publishing the repository. CI must check out the submodule; for a private method repository that needs a read token, which the Money Review workflow rules forbid, so the method repository is meant to be public.

## Review trigger

A third project, a harness that cannot load skills from an included folder, or a project that needs the method at two versions at once.
