# Migration from 1.2.0 to 2.0.0

A structure-only move, applied on 2026-10-19. Every rule keeps its meaning; only its address changes. The new material is the roster (R-8.1), the Scrum Master (R-10.7) and the orchestrator's name, all from the founder's decisions of 2026-10-19. The founder also decided that day: the whole method in its own repository, included by projects rather than copied; the name Sipk.ai POD; the two HTML guides of 1.2.0 retired; the method usable from any harness and easy to give to anyone.

## How the two repositories connect

```text
sipkai-pod (this repository, also a Claude Code plugin and its own local marketplace)
  ├── AGENTS.md, RULES.md, PIPELINE.md, TEAM.md   the method
  ├── skills/ and agents/                          the stage commands and the personas, loaded as a plugin
  ├── templates/ scripts/ evals/ decisions/        the machinery, run from the included folder without a harness
  └── IMPROVEMENTS.md                              the improvement log, which moves with the method

money-review (a product repository)
  ├── AGENTS.md                 the product's constitution: product rules, private material, required reading, quick commands
  ├── CLAUDE.md                 adapter: imports AGENTS.md
  ├── .claude/settings.json     deny rules, and the marketplace entry that loads the plugin from sipkai-pod/
  ├── .claude/agents/           the project's own lenses (financial accuracy, UX simplicity, the Money Review security items)
  ├── docs/SDLC-PROJECT.md      the project's choices: which models fill the tiers, gate stages, tailoring, bootstrap
  ├── sdlc.config.sh            the only bridge: folders, truth files, gate stages (SADR-003)
  └── sipkai-pod/               this repository as a git submodule, pinned to one commit
```

## Where every file of 1.2.0 landed

| 1.2.0 (in `money-review/`) | 2.0.0 (this repository) | Note |
|---|---|---|
| `sipkai-sdlc/SDLC.md` §1 idea, §16 design choices | `README.md`, `AGENTS.md` | prose, no rules lost |
| `SDLC.md` §2 pipeline, §3 evidence states, §4 lanes, §5 risk, §9 enforcement, §10 quality stack, §12 entry and exit, §13 story end to end | `PIPELINE.md` and `RULES.md` sections 2 to 5 | |
| `SDLC.md` §6 routing summary | `RULES.md` section 7 | the summary is dropped; the full rules are the only copy |
| `SDLC.md` §7 agent roster | `TEAM.md`, `agents/` | reviewers become lenses worn by personas |
| `SDLC.md` §8 memory layers, §11 control plane | `RULES.md` section 8 | |
| `SDLC.md` §14 keeping honest, §15 measuring | `RULES.md` section 10 | |
| `SDLC.md` §17 adopting | `README.md` "Adopting it in a project", `scripts/adopt.sh` | |
| `sipkai-sdlc/rules/model-routing.md` | `RULES.md` section 7 (R-7.1 to R-7.16), second opinion in section 6 (R-6.7, R-6.8) | |
| `sipkai-sdlc/rules/testing-evidence.md` | `RULES.md` section 3 (R-3.1 to R-3.20) | |
| `sipkai-sdlc/rules/ai-generation-governance.md` | `RULES.md` section 9, plus R-3.9 (prime directive), R-3.23 to R-3.25, R-8.11, R-8.15, R-1.1 | |
| `sipkai-sdlc/rules/control-plane.md` | `RULES.md` section 8 (R-8.2 to R-8.14), R-5.9, R-8.13 | |
| `AGENTS.md` hard rules 1 to 13 (method part) | `RULES.md`: R-2.11, R-3.9, R-3.24, R-3.23, R-3.3, R-8.10, R-1.6, R-5.8, R-5.5, R-8.7, R-9.1, R-9.4, R-1.1 | |
| `AGENTS.md` product rules, private material, required reading by surface, quick commands, document map, repository layout | stay in `money-review/AGENTS.md` | product truth never moves |
| `AGENTS.md` risk and authority, control plane, stop and ask, context discipline | `RULES.md` R-5.1 to R-5.7, R-8.2, R-8.16 | the product constitution keeps a pointer |
| `.claude/skills/<stage>/SKILL.md` (7) | `skills/<stage>/SKILL.md` (7) | same steps, fixed page shape, persona names, rule ids |
| `.claude/agents/architecture-reviewer.md` | `agents/lenses/architecture.md`, worn by Marketa | |
| `.claude/agents/security-reviewer.md` items 1 to 10 | `agents/lenses/security.md`, worn by Adam | |
| `.claude/agents/security-reviewer.md` items 11 to 15 | `money-review/.claude/agents/security-money-review.md` | Money Review specific |
| `.claude/agents/test-quality-reviewer.md` | `agents/lenses/test-quality.md`, worn by Bruno | |
| `.claude/agents/doc-drift-checker.md` | `agents/lenses/doc-drift.md`, worn by Bruno | |
| `.claude/agents/financial-accuracy-reviewer.md`, `ux-simplicity-reviewer.md` | stay in `money-review/.claude/agents/`, carried by Miro | product lenses |
| `.claude/settings.json` | stays in `money-review/`, gains the marketplace entry | deny rules are per project |
| `sipkai-sdlc/templates/*` | `templates/*` | unchanged apart from the folder name and the rule ids |
| `sipkai-sdlc/scripts/*` | `scripts/*` | unchanged apart from the folder name; `check-md-links.py` takes an optional root |
| `sipkai-sdlc/evals/*` | `evals/*` | unchanged apart from the folder name; the 28 cases pass |
| `sipkai-sdlc/decisions/SADR-001..003` | `decisions/` | unchanged; SADR-004 and SADR-005 accepted |
| `sipkai-sdlc/IMPROVEMENTS.md` | `IMPROVEMENTS.md` | rows SI-001 to SI-155 unchanged; SI-156 is this move |
| `sipkai-sdlc/CHANGELOG.md`, `README.md` | `CHANGELOG.md`, `README.md` | 2.0.0 entry added |
| `sipkai-sdlc/dashboard.html`, `build-your-sdlc.html` | retired | founder's decision, 2026-10-19 |
| `docs/SDLC-PROJECT.md`, `sdlc.config.sh` | stay in `money-review/` | the project's choices and the bridge |
| (new) | `LICENSE`, `.claude-plugin/marketplace.json`, `scripts/adopt.sh`, `templates/AGENTS.md` | so the pod can be given to anyone and adopted in two commands |

## Proof that nothing drifted

In the product repository, with the submodule in place and the plugin loaded:

1. `bash sipkai-pod/evals/run-evals.sh` passes with the same 28 cases as before.
2. `bash sipkai-pod/scripts/sdlc-gate.sh --fast` is green on the product repository.
3. Every rule paragraph in `RULES.md` has an origin trailer (`*was …*` or `*founder's decision …*`): the count of rule ids equals the count of trailers.
4. Every `R-n.m` cited by a stage page, a persona page or a lens exists in `RULES.md`.
5. The link checker finds no broken relative link: `python3 sipkai-pod/scripts/check-md-links.py` in the project and `python3 scripts/check-md-links.py .` here.
6. A fresh Claude Code session in the project lists the plugin as loaded with seven skills and eight agents.

## Things the move settled by structure

- Proposal SI-010's first point (the stage appending its own spend line) is resolved by wording every stage page as "Sipk.ai appends the spend line from harness-measured usage", which is what R-7.11 always said.
- The names in the Review Verdict's reviewer column become persona names (Marketa A-n, Adam S-n, Bruno T-n and D-n, Miro F-n and U-n, the independent reviewer X-n); the numbering series are unchanged.
- Generic file names keep the generic word: `sdlc.config.sh`, `sdlc-gate.sh`, `docs/SDLC-PROJECT.md` and the record's "SDLC findings" section, because SDLC there means the lifecycle, not the brand.
