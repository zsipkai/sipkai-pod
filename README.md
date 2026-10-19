# Sipk.ai POD

**A pod of AI agents that delivers software through seven evidence-gated stages, owned by one human. Give it to any project; the project's own rules stay in the project.**

Version 2.1.1 (2026-10-19). By Sipk.ai, Zoltán Šipkai. MIT licensed.

## The idea in one paragraph

Agents write most of the code now. That is only safe when the proof that the code works does not come from the agent that wrote it. The Sipk.ai POD puts every change through seven stages, each of which must leave evidence behind in one file, the change record, before the next may start. Mechanical gates read that file on every commit and refuse a stage that runs ahead of its proof. Reviewers are independent, one of them from a different model family entirely. Cheap models do the typing; expensive models do the judging. The human approves what matters and owns every change to the method itself.

## The team

```text
                         the founder (human)
                owns decisions, approves the method and
                      every production release
                                 |
                              Sipk.ai
                    Engineering Director, orchestrator
                                 |
   +----------+----------+-------+-------+----------+----------+
   |          |          |               |          |          |
  Miro     Marketa     Michal          Bruno       Adam       Ivan
 Product  Architect   Developer        Tester    Security   DevOps &
  Owner                                                      Deploy
                                 |
                               Tina
                     Scrum Master: the bill, the metrics,
                        the improvement proposals

   outside the team:  the Independent Reviewer (a second model family)
```

Each persona is one file in `agents/`, which is also its agent definition: accountable for, consulted on, may touch, must refuse, checklists, scripts, how it reports. `TEAM.md` has the roster and the authority matrix.

## The route

```text
Plan -> Validate -> Develop -> Accept -> Review -> Regress -> Deploy
```

| Stage | Proves | Owner |
|---|---|---|
| Plan | the change is understood: scope, risks, acceptance map, routing | Marketa |
| Validate | the design survives attack on paper, from inside and outside the team | Marketa |
| Develop | the contract was built, in scope, fast gate green | Michal |
| Accept | every criterion has a named proof that can fail | Bruno |
| Review | independent lenses and a second model family cleared the diff | Sipk.ai |
| Regress | the complete matrix passes on the exact reviewed commit | Bruno |
| Deploy | hard gate, staged deploy, live verification, rollback known | Ivan |

Each stage is one page in `skills/`, with the same shape every time. `PIPELINE.md` has the whole route with its gates, lanes, risk tiers and a story told end to end.

## What makes it different

- **Evidence states, not status words.** A story is `DESIGN-VALIDATED` because the Design Verdict exists and the checker read it, not because somebody typed the word.
- **One record, the whole way.** The change record is the plan, the contract, the test log, the review table, the certificate and the deployment receipt. A fresh session can run the next stage from it alone.
- **A second model family as judge.** Reviewers from one family share that family's blind spots. The independent reviewer sits outside the team and judges the same pack. It judges; it never gates.
- **Cheap generation, expensive verification.** Risk picks the model, size picks the budget, verification always runs at the top tier, and the repository computes its own bill.
- **Agents improve the method, the human approves.** Every weakness becomes a proposal. Nothing is applied without a name and a date, and the gate checks.
- **Rules cite their scars.** Every rule names the bug that created it, so it gets followed instead of skimmed.
- **Nothing product-specific inside.** The pod is the same for every project. A project adds its own constitution, its own lenses, its own gate stages and its own deny rules, all in the project's repository.

## Where things are

| Page | Holds |
|---|---|
| `AGENTS.md` | the ten pillars, every key concept in one paragraph each; the entry point for every harness |
| `CLAUDE.md` | the Claude Code adapter: loads `AGENTS.md`, nothing else |
| `RULES.md` | every rule as a paragraph, numbered, grouped by pillar |
| `PIPELINE.md` | stages, evidence states, gates, lanes, risk tiers, the RACI, a story end to end |
| `TEAM.md` | the roster, authority at a glance, model tiers |
| `skills/<stage>/SKILL.md` | one page per stage; also the slash command |
| `agents/<persona>.md` | one page per persona; also the agent definition |
| `agents/lenses/` | the generic review checklists |
| `agents/independent-reviewer.md` | the outside reviewer protocol |
| `templates/`, `scripts/`, `evals/`, `decisions/` | the record and story templates, the gate and its checks, the process evaluations, decisions about the method |
| `IMPROVEMENTS.md` | the improvement log: agents propose, only a human approves |
| `INDEX.md` | one line per page |
| `.claude-plugin/` | makes this repository a Claude Code plugin and its own local marketplace |

## Adopting it in a project

The whole pod comes into a project as one included folder, `sipkai-pod/`, pinned to a commit. Nothing is copied by hand.

```bash
git submodule add https://github.com/zsipkai/sipkai-pod.git sipkai-pod
bash sipkai-pod/scripts/adopt.sh
```

`adopt.sh` creates the two files a project must own when they are missing, `sdlc.config.sh` (folders, truth files, gate stages; the only bridge between the pod and the project) and `AGENTS.md` (the project's constitution: product rules, private material, required reading, quick commands), and prints the Claude Code settings that load the plugin from the included folder. Then:

1. Fill `sdlc.config.sh`; unconfigured stages fail the gate on purpose.
2. Write the product rules into the project's `AGENTS.md` and the project's choices within the method (which models fill the tiers, which family gives the second opinion) into its `docs/SDLC-PROJECT.md`.
3. Add the project's own lenses next to the generic ones, for example a financial-accuracy reviewer, in the project's `.claude/agents/`.
4. Run the bootstrap lane once and install the hook: `bash sipkai-pod/scripts/install-hooks.sh`.
5. Work one story at a time from the board: `/plan-task STORY-NNN`, each later stage in a fresh session.

In Claude Code the stage commands are `/sipkai-pod:plan-task` and so on; the short form `/plan-task` works while no other command uses the name. CI checks out the submodule with the repository (`submodules: true`).

**Any harness.** The pillars are in `AGENTS.md`, the convention most coding agents read. The stage pages are plain `SKILL.md` files, the persona pages plain Markdown with a small frontmatter; a harness that cannot load them as commands can still be pointed at the page for the stage. The gate, the checks and the evaluations are shell and Python and need no harness at all.

**Upgrading** a project is moving the submodule to a newer commit, reading the diff, replaying the evaluations (`bash sipkai-pod/evals/run-evals.sh`) and re-running the gate. `decisions/SADR-004` records why.

## Quick commands inside a project

```bash
bash sipkai-pod/scripts/sdlc-gate.sh --fast    # every commit (the hook runs it)
bash sipkai-pod/scripts/sdlc-gate.sh --full    # regression proof and CI
bash sipkai-pod/scripts/sdlc-gate.sh --ui      # adds UI journeys and accessibility
bash sipkai-pod/scripts/sdlc-gate.sh --deploy  # release-bound work
bash sipkai-pod/evals/run-evals.sh             # prove the checks still catch known failures
bash sipkai-pod/scripts/cost-report.sh         # the bill, from the change records
```

## Lineage

Version 1.x lived inside the Money Review repository as `sipkai-sdlc/` and merged the founder's AI SDLC starter kit v3 with the production pipeline of the Kid Storytime iOS app. Version 2.0.0 is the same rules in their own repository, run by a named pod (`CHANGELOG.md`, `MIGRATION.md`).
