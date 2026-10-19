# Index

One line per page. Add a line when you add a page; delete the line when you delete the page.

## Start here

- `README.md` — the idea, the team, the route, what makes it different, how to adopt it
- `AGENTS.md` — the ten pillars, every key concept in one paragraph each; read by every harness
- `CLAUDE.md` — the Claude Code adapter that loads `AGENTS.md`
- `RULES.md` — every rule as a numbered paragraph, grouped by pillar, with its origin
- `PIPELINE.md` — stages, evidence states, gates, lanes, risk tiers, the RACI matrix, a story end to end
- `TEAM.md` — the roster, how the team talks to the founder, authority at a glance, model tiers

## Stages (also the slash commands)

- `skills/plan-task/SKILL.md` — stage 1, Plan: story to Discovery Brief, routing and budget (Marketa)
- `skills/validate-design/SKILL.md` — stage 2, Validate: the devil's-advocate gate and the Design Verdict (Marketa)
- `skills/develop-code/SKILL.md` — stage 3, Develop: the implementation at the routed tier (Michal)
- `skills/test-acceptance/SKILL.md` — stage 4, Accept: a named proof for every criterion (Bruno)
- `skills/clear-review/SKILL.md` — stage 5, Review: lenses, the independent reviewer, the generalist pass (Sipk.ai)
- `skills/test-regression/SKILL.md` — stage 6, Regress: the full matrix on one SHA, the certificate (Bruno)
- `skills/deploy-change/SKILL.md` — stage 7, Deploy: hard gate, protected merge, the founder's deploy, live proof (Ivan)

## People (also the agent definitions)

- `agents/sipkai.md` — Sipk.ai, Engineering Director and orchestrator, the main session
- `agents/miro.md` — Miro, Product Owner: backlog, readiness, the domain lens
- `agents/marketa.md` — Marketa, Architect: the brief, the design verdict, routing, decisions
- `agents/michal.md` — Michal, Developer: the implementation, the self-check, review fixes
- `agents/bruno.md` — Bruno, Tester: acceptance proofs, the certificate, test-quality and drift lenses
- `agents/adam.md` — Adam, Security: the security lens, control-plane verdicts, secrets and supply chain
- `agents/ivan.md` — Ivan, DevOps and Deploy: the gate, CI, the merge, the deploy, live verification
- `agents/tina.md` — Tina, Scrum Master: the bill, the metrics, research, improvement proposals
- `agents/independent-reviewer.md` — the outside reviewer from a second model family: judge, never gate

## Lenses (review checklists any persona can wear)

- `agents/lenses/architecture.md` — boundaries, single owners, dependency direction, migrations
- `agents/lenses/security.md` — secrets, bypasses, authority, exceptions
- `agents/lenses/test-quality.md` — tests that could pass for the wrong reason
- `agents/lenses/doc-drift.md` — documentation claims measured against code and live state

## Machinery

- `templates/` — story, change record, decision record, dated review, release pre-flight, `sdlc.config.sh` and `AGENTS.md` starters
- `scripts/` — the gate and its checks, the pack builder for the independent reviewer, the cost report, the hook installer, `adopt.sh`
- `evals/` — process evaluations: known good and known bad cases that prove the checks still catch what they must
- `decisions/` — decisions about the method itself (SADR-NNN)
- `IMPROVEMENTS.md` — the improvement log: agents propose, only a human approves
- `CHANGELOG.md`, `VERSION` — what changed, which version this is
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` — the Claude Code plugin and the local marketplace a project loads it from
- `LICENSE` — MIT

## About the move

- `MIGRATION.md` — where every file of version 1.2.0 landed, what stays in a product repository, the proofs that nothing drifted
