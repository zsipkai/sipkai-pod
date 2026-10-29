# Sipk.ai POD changelog

## 2.3.0 — 2026-10-29

Approved by Zoltán Šipkai in chat on 2026-10-29: Tina's eight-point decision list ("approved") and his instructions for a top-down structure, Sprint 0 and a digital agile team (SADR-006, SI-162 to SI-168). 49 process evaluations.

- **The team charter** (`agents/CHARTER.md`, R-1.7): vision, mission, the mandate to be the best, the quickest and the cheapest AI delivery team in the world (ranked in that order, proven with numbers), and eleven agreements in priority order that outrank every other page. Every stage's start check prints them; every persona page names the charter first; the retrospective and Tina measure the team against the mandate.
- **Top-down structure.** `CLAUDE.md` is the top: what the pod is, the ten key rules, the flow, how the pod talks, what it keeps; `AGENTS.md` is the same file. Then `agents/` (the team), `sdlc/` (the flow in `sdlc/README.md`, every rule in `sdlc/RULES.md`, the step pages in `sdlc/skills/`, the gate in `sdlc/scripts/`, the cases in `sdlc/evals/`), `templates/` (the artefacts a project gets), `method/` (the pod's own decisions and log). Every script path moved from `sipkai-pod/scripts/` to `sipkai-pod/sdlc/scripts/`.
- **Sprint 0** (R-2.20): `/sprint-zero` runs business case, workspace, backlog, release plan and architecture sketch, UI mocks and design system, accesses, proof of concept and a green gate, with an exit list. New steps `/business-case` (R-2.21: no backlog without the founder's go), `/define-backlog` (R-2.19: intake and prioritisation), `/design-ui`, `/prove-concept`, and templates for each output.
- **Erik, UX and UI Designer**, clean, modern and simple in the spirit of Apple's design, with a UX lens.
- **Sprints** (R-2.13): the founder names a story or approves a sprint; the pod delivers its stories one after another on its own.
- **The project workspace** (R-8.19): every artefact lives in the project, in the folders `sdlc.config.sh` names (default `delivery/`); `adopt.sh` creates them.
- **The team sits down after every story** (R-10.9): Tina's one-page retrospective with the bill and three lean proposals.
- **Budgets recalibrated from the ledger** (R-7.9): S 750k, M 2M, L 2.5M, XL 4M; nine of ten stories had crossed the old ones.
- **Drift is a script, not a reviewer run**: `check-record-drift.sh` compares card, board and record, and refuses retired phrases.
- **Claims are run, not asserted** (R-6.17), one checklist for 18 proposals; **a stopped stage keeps its findings** (R-6.18); the second-opinion pack carries the current text of the files a change edits.
- **The pod holds nothing project-specific**: Java and Node checks moved to a project's `project_tool_checks`; the second-opinion endpoint and Keychain item come from the bridge; two stale stage sentences fixed.
- **A lean log**: open rows grouped by theme in `method/IMPROVEMENTS.md`, applied and rejected rows in `method/IMPROVEMENTS-ARCHIVE.md`, project rows in each project's own log, all checked. Seven stale rows closed. The log check no longer breaks on an apostrophe.

## 2.2.0 — 2026-10-29

Approved by Zoltán Šipkai in chat ("Points 1 to 4", 2026-10-29): the six approved improvements applied, plus SI-003, SI-005, SI-029, SI-080, SI-088, SI-089 and SI-154. Thirteen new process evaluations, 41 in all; each new check was broken once to prove its evaluation turns red.

- **Every stage starts with one check** (R-8.18, R-7.10). `scripts/stage-start.sh STORY-NNN` stops a stage that started outside the project root, where the project's deny rules and reviewers do not load, and a stage whose story has spent its budget without a human's decision.
- **The budget stop is mechanical** (R-7.10, SI-070). The record checker refuses a record that completed a stage over budget without a raised `Budget:` or a `Budget decision: ... — name, date` line. In Money Review, five of the ten finished stories had crossed their budget with nothing recorded.
- **No silent passes** (R-2.7, R-6.7; SI-003, SI-005, SI-089). A passing `--full`, `--ui` or `--deploy` gate prints a receipt, and the Regression Certificate quotes it; the checker refuses a certificate naming a commit the repository does not have. Every full-lane verdict above LOW risk carries a `Second opinion:` line. `second-opinion.sh --auto` exits 3 with "Second opinion NOT obtained" and leaves no findings file when the API fails or answers nothing.
- **A small-change lane** (R-4.8, SI-088). Size S, a few files, no user-visible behaviour change, no new contract, never CRITICAL: Plan, Validate and Develop in one session, one lens on the design, one second opinion on the diff, then Accept, Review, Regress and Deploy with every gate.
- **Rule text** (SI-030, SI-065, SI-066, SI-144, SI-145). Seven-day age for every pin, transitive npm packages included (R-8.11); UI tests change with what they assert and run before such a commit (R-3.24); prescribed test mechanics are tried before a design clears (R-6.16); about 100k tokens per reviewer and a general-purpose fallback for a reviewer the harness cannot load (R-6.6); five forms of adverse proof for a forbidding control (R-3.18).
- Records finished before 2.2 are listed in the project's `SDLC_LEGACY_RECORDS` and keep the older checks.

## 2.1.1 — 2026-10-19

Correction by the founder the same evening: he selects every story that goes into development; the pod never picks one (R-2.13). The 2.1.0 text that let Sipk.ai take the next story from the board is withdrawn.

## 2.1.0 — 2026-10-19

Approved by Zoltán Šipkai (IMPROVEMENTS.md SI-157). The pod runs on its own; the founder keeps the method and production.

- **The founder names the story, the pod runs it.** The founder selects each story for development; Sipk.ai then starts every stage in a fresh session itself through to `DEPLOYED` and stops (R-2.12, R-2.13, R-2.18).
- **Checkpoints reduced to what matters.** LOW to HIGH: only a production release needs the founder; CRITICAL adds design approval. Tests validate the outcome; lenses, the independent reviewer and the gate clear the merge (R-5.2).
- **Development is the pod's.** Deployments, infrastructure and permissions in the development environment inside an approved story need no human; production and account-level changes do (R-5.5, R-5.10, R-8.5). `/deploy-change` is invoked by Sipk.ai after the certificate and pushes `main` where the project allows it.
- **Second opinion fully automatic** (R-6.7). Design QUESTIONs are answered by Sipk.ai with the best-supported option and reported (R-6.13).
- **Control plane.** In the method repository the founder reviews every change; in a product repository Adam gives the verdict (R-8.2).

## 2.0.0 — 2026-10-19

Approved by Zoltán Šipkai (IMPROVEMENTS.md SI-156; SADR-004, SADR-005). Structure only; no rule changed.

- **Its own repository, its own name.** The method is now the Sipk.ai POD, a pod of AI agents in the repository `sipkai-pod`, with nothing product-specific inside. A project includes the whole repository as the git submodule `sipkai-pod/` at a pinned commit and keeps its own constitution, lenses, gate stages and deny rules.
- **A plugin for Claude Code.** `.claude-plugin/` makes the repository a plugin and its own local marketplace, so the seven stage commands and the eight personas load from the included folder. `AGENTS.md` holds the pillars for every other harness; `CLAUDE.md` only loads it.
- **One shape per page.** `AGENTS.md` holds the ten pillars; `RULES.md` every rule as a numbered paragraph with its 1.2.0 origin; `PIPELINE.md` the route; `TEAM.md` the roster. Stage pages and slash commands are the same files under `skills/`; persona pages and agent definitions are the same files under `agents/`.
- **The team of personas.** Sipk.ai (orchestrator), Miro, Marketa, Michal, Bruno, Adam, Ivan, Tina. Reviewer checklists became lenses under `agents/lenses/`, worn by personas; project-specific lenses stay in the product repository. The cross-family second opinion is described as the independent reviewer, outside the team.
- **New, by the founder's decision:** the Scrum Master role (R-10.7) and the roster rule (R-8.1).
- **Adoption in two commands.** `scripts/adopt.sh` creates `sdlc.config.sh` and the project's `AGENTS.md` from templates and prints the plugin settings. `check-md-links.py` accepts a root so the repository checks its own links. The two HTML guides of 1.2.0 were retired.
- Scripts, templates and evaluations are unchanged apart from the folder name `sipkai-sdlc/` → `sipkai-pod/`; the 28 evaluation cases pass.

## 1.2.0 — 2026-10-17

Approved by Zoltán Šipkai (IMPROVEMENTS.md SI-009, SI-012, SI-014, SI-015, SI-016).

- **Java 25 everywhere (SI-009).** The ADR-001 title names Java 25 and `check-tools.sh` requires Java 25 or newer.
- **Safer automatic second opinion (SI-012).** `second-opinion.sh --auto` reads the key only from the macOS Keychain item `sipkai-openai-api`, hands it to curl on stdin, and exits 2 with a clear message when the key is missing. `SECOND_OPINION_KEY_CMD` is gone.
- **Simpler documentation drift check (SI-014).** Truth files are checked only for `TODO` and `UNCONFIGURED` markers; angle brackets are allowed, and evaluation paths may contain spaces.
- **The hook commits what it checked (SI-015).** `pre-commit` refuses a commit when tracked files differ between the index and the working tree, and names them.
- **Control tests at `top` (SI-016).** Routing rule 2: tests that encode a control-plane or security control are written at `top`.
- Six new process evaluation cases (28 in all).

## 1.1.0 — 2026-10-14

Approved by Zoltán Šipkai (IMPROVEMENTS.md SI-001 and SI-002).

- **Self-improvement with a human in the loop (SI-001).** Agents must log every weakness or gap they find in the SDLC as a proposal in `IMPROVEMENTS.md` and never apply it without a recorded human approval. Adds constitution rule 13, governance rule 28, control-plane rule 3, an "SDLC findings" section and Definition of Done item in the change record, a line in every stage skill, and `scripts/check-improvements.sh` in every gate with five evaluation cases.
- **Human-readable, simplest implementation (SI-002).** Adds constitution rule 12 and governance rules 20–27 (least code, no speculative abstraction, plain over clever, small named units, standard and existing first, comments say why, simpler design wins, readability is reviewed), with checks in `/validate-design`, `/develop-code`, `/clear-review`, the architecture reviewer and the Definition of Done.

## 1.0.0 — 2026-10-14

First release under the Sipk.ai brand, adopted by Money Review.

### Merged from the AI SDLC starter kit v3
- Seven purpose-named stages with mechanical evidence states and one change record per story.
- Size and Risk routing to `small`, `mid` and `top` tiers, token budgets as a stop-loss, spend ledger and cost report.
- Cross-family second opinion on STANDARD risk and higher (judge, never gate).
- Control plane: instructions are code, untrusted context, bounded authority, test integrity.
- Templates for stories, change records and decision records; the change-record checker; the second-opinion pack builder.

### Merged from the Kid Storytime production pipeline
- Lanes (full, test-only, docs/process-only, hotfix, bootstrap) declared out loud.
- The devil's-advocate design checklist, the QUESTION severity, the isolation test and the rule that critical facts are written inline.
- Clean-start and story-number collision checks in `/plan-task`; decisions searched before any question.
- AI-generation governance rules: code must read human-written, no invented API or facts, supply-chain review of skills and MCP servers.
- Gate modes including `--ui`, gate parity, quiet mode, and stages that judge both exit code and output.
- Evidence measured, never reported: numeric claims come from commands run at evidence time.
- Dated independent reviews and release pre-flight checklists.

### New in 1.0.0
- The method is isolated in `sipkai-pod/`; projects connect through `sdlc.config.sh` (SADR-003).
- Every check fails closed: missing tools, unreadable files and unconfigured stages fail the gate.
- Secret scanning (gitleaks) and dependency vulnerability scanning (OSV-Scanner) are standard gate stages.
- The change-record checker enforces stage ordering (earlier sections succeeded, later sections pending or superseded) as well as metadata, routing floor, placeholders and receipts.
- Process evaluations in `evals/` run in `--full`, so a broken checker breaks the build.
