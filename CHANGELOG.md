# Sipk.ai POD changelog

## 2.9.1 — 2026-10-30

Fixes to the dependency lane (SI-184), found by Adam's review of Money Review's pin of 2.9.0; within the founder's approval of 2.9 ("Yes, build 2.9"). 71 process evaluations.

- `check-dependency-lane.sh` reads the diff without rename detection, so code renamed onto a lockfile name shows as the deletion it is, and accepts only lockfiles changed in place (S-3).
- It refuses a working tree with uncommitted changes, because the fingerprint builds the working tree, not the commit (S-4).
- It stops at the first refusal of its file check, and removes its throwaway worktree of `main` on every exit (S-7).
- The pod's own CI annotates each failing case, and its evaluations run on `main` on every machine (a Linux runner's git defaults to `master`).

## 2.9.0 — 2026-10-30

Approved by Zoltán Šipkai in chat on 2026-10-30 ("Yes, build 2.9"), after asking "I need to speed up and make my pipeline more effective, what are the improvement points? Can you make it happen?". Built from STORY-045, the first story on a short route, and the 2.8.0 push. SI-181 to SI-186. 69 process evaluations, run both inside a project and on their own. No control is removed.

- **Budgets follow risk too** (SI-181, R-7.2). HIGH adds the reviews it requires: S 450k, M 1.1M, L 2.1M, XL 3.6M; LOW and STANDARD keep 300k, 800k, 1.6M, 3M. STORY-045 stopped for the founder because its reviews alone used two thirds of an S budget.
- **The start check sees where a session began** (SI-182). The project's harness settings set `SIPKAI_PROJECT`; `stage-start.sh` stops any session without it. Comparing folders could not catch a session that started in the parent folder and then moved in.
- **Two stories at a time** (SI-183, R-2.4). Stories in a sprint that do not block each other and share no declared files run at once, each in its own worktree; they merge one at a time, and the second re-runs its full gate on the new `main`.
- **A dependency lane** (SI-184, R-4.1). `check-dependency-lane.sh` proves an update changed only lockfiles, still satisfies its manifests, leaves the shipped build byte-identical and keeps the scan green; such an update takes one session, Adam's review and a 200k budget. Any refusal is the full route. A project opts in with `project_lock_check` and `project_build_fingerprint`.
- **Reviewers start light** (SI-185, R-6.1). Each persona is briefed as its own agent type, with only its job's tools, never as a general-purpose agent.
- **The pod checks itself** (SI-186). `run-evals.sh` runs on its own in a throwaway project, and a GitHub workflow runs it on every push. Five second-opinion evaluations no longer lean on a project's STORY-001.
- **Expected effect, not yet measured:** fewer founder stops on HIGH stories, about half the calendar time of a sprint with independent stories, and about 200k saved on each dependency update. Tina measures it over the next five stories.

## 2.8.0 — 2026-10-30

Approved by Zoltán Šipkai in chat on 2026-10-30 ("Yes, build 2.8"), after asking "can you make the AI POD half of the token and still the same quality?". Built from the ledger of Money Review's ten finished stories (15.7M tokens; 31% Review, 23% Validate, 12% Plan). SI-177 to SI-180. 63 process evaluations. No control is removed: every criterion keeps a proof that can fail, the design check and the review stay with someone other than the builder, the second model family, Adam at HIGH risk, `top` for verification, the gate on the exact commit and the founder's authority are unchanged.

- **One review pack per round** (SI-177). `review-pack.sh` builds the one file every lens and the second opinion start from: the record's contract without its ledger, earlier findings or verdicts, the current text of the named files, and at Review the diff. It never holds the Review Verdict, so findings still form before conclusions. Reviewers are planned at about 60k tokens instead of 100k.
- **Short records** (SI-178). Evidence goes in by reference; a record runs to at most S 300, M 450, L 600, XL 800 lines, refused by `check-change-records.sh`.
- **No step abandoned halfway** (SI-179). Each step has a planned share of the budget; `stage-start.sh STORY-NNN <step>` stops it before it starts when less is left.
- **Lenses earn their place** (SI-180). Each verdict carries a `Found only by:` line, refused when missing; after five stories in which a lens caught nothing alone, Tina proposes folding it.
- **Fixed on the way.** The record template's budget line still showed the 2.0 sizes, and its second-opinion headings cited the retired "rule 16"; clear-review said the second opinion's pack holds the charter, which it never did; and the checker refused the template's own `Size: S — <reason>` line (found by STORY-045, Money Review MR-002).
- **Expected effect, not yet measured:** with the size routes of 2.6, about half the tokens of the first ten stories. Tina checks it over the next five stories.

## 2.7.0 — 2026-10-29

Approved by Zoltán Šipkai in chat on 2026-10-29 ("Yes, all five"; "fix my team comprehensively based on the independent study ... hierarchical, no duplication, no drift, but all the rules in place ... this is a hard rule"). The study is filed as `method/reviews/2026-10-29-independent-study.md`. SI-172 to SI-176. 56 process evaluations.

- **A green gate on day one** (SI-172). `adopt.sh` refuses a folder that is not a git repository, and creates the secret-scan config, `docs/SDLC-PROJECT.md` (new template with the bootstrap lane), every truth file, the Claude Code settings and the workspace. `sdlc_none "<reason>"` declares a stage with no code yet and fails once any story has built code. Sprint 0 starts with `adopt.sh`. Fixed: since 2.3 the link checker checked the pod's links instead of the project's. Two evaluations prove a brand-new project is green and a stage declared none turns red once code exists.
- **Nothing about one project, vendor or tool inside the pod** (SI-173). Money Review's figures left R-7.2; the npm rule, the Java-shaped proof forms and `data-testid` are general; install hints point at the tools' own pages; the integration branch, the dependency-scan skips, the second-opinion model and its key source (a file outside the repository, or the macOS Keychain) come from `sdlc.config.sh`. Method proposals start in the project's own log, marked `METHOD:`, and Tina carries them into the pod's log; the project's gate checks only the project's log.
- **One home per fact** (SI-174). `CLAUDE.md` is the map and holds the pillars and how the pod talks; the team page holds how the team is built, who owns what, how it operates, where authority ends and the model tiers; the flow page holds the sizes, steps and who is accountable for each; `templates/README.md` the workspace and artefacts; the old-number map moved to `method/RULE-MAP.md`. The contradictions the study found are fixed.
- **Honest orchestration** (SI-175). R-2.4 says how Sipk.ai starts each step in each kind of harness; in S and M a fresh reviewer, never the builder, checks the design; a BLOCK is cleared only by the reviewer who raised it or by the founder, and disagreements are settled by a written rule; every artefact has one owner; a `Budget decision:` must quote the founder's own words; every ledger line says `measured` or `estimate`; a second skipped second opinion in a row stops the next review.
- **Adapters** (SI-176). `adapters/README.md` lists the five things any harness must supply; `adapters/claude-code/` says how Claude Code does it and holds a deny-rule settings template. Member pages name tiers only (`model: inherit`).
- **Every rule kept.** A sentence-by-sentence comparison with 2.6 found 16 changed sentences; each was generalised, made stricter, or moved to its one home, and none dropped an obligation. All 40 rules remain.

## 2.6.0 — 2026-10-29

Approved by Zoltán Šipkai in chat on 2026-10-29 ("refactor the AI SDLC that it will be S, M, L, XL, XXL ... the most rapid, token efficient but quality development"). SI-171. 50 process evaluations.

- **Size is the route** (R-2.8). S: one session, `/quick`. M: `/build`, `/ship`. L: `/design`, `/build`, `/ship`. XL: the seven stage pages. XXL: never one story; a business case with feasibility and a backlog of S to XL stories. The three tracks of 2.4 are gone.
- **Risk adds controls, never removes them**: the second model family on the diff at STANDARD and above, the top model and Adam's lens at HIGH, XL and the founder's design approval for every CRITICAL story. The checker refuses a CRITICAL story below XL and asks for a design-stage second opinion only at XL.
- **Budgets by size** (R-7.2): S 300k, M 800k, L 1.6M, XL 3M; an XXL epic spends an M budget on its case and backlog.
- **Feasibility** is now an explicit step and verdict in every business case, and only a feasible case goes on.
- Every size still keeps a proof that can fail per criterion, the gate on the exact commit with its receipt, a reviewer who is not the builder, the full record, the budget stop and the founder's authority.

## 2.5.0 — 2026-10-29

Approved by Zoltán Šipkai in chat on 2026-10-29 ("simplify the 146 rules ... not compromise any quality and any step"). SI-170. 51 process evaluations.

- **148 rules folded into 40**, one paragraph each, under the same ten pillars; the rulebook went from about 7,500 to about 5,050 words. Each new rule carries every obligation of the rules it replaced: no check, gate, stage, approval or proof was removed. Only two notes that obliged nothing were dropped as rules (the maturity ladder and "the Batch API is not adopted yet").
- **A map from every old number to its new one** closes the rulebook. A mechanical check confirmed all 148 old rules appear in it exactly once and every target exists.
- Every citation in the pod's pages, step pages, persona pages, scripts and evaluations was repointed; finished change records, reviews, decisions and finished story cards keep their old numbers, which the map resolves.

## 2.4.0 — 2026-10-29

Approved by Zoltán Šipkai in chat on 2026-10-29 ("Yes, build 2.4"): a simpler, faster flow where the team decides from each story's complexity who it needs (SI-169). 51 process evaluations.

- **Three tracks** (R-2.22). Sipk.ai picks, with Marketa, the lightest track that meets every acceptance criterion and brings in only the members it needs. **Rapid** (Size S, LOW or STANDARD, nothing sensitive, no new contract or screen): two sessions, `/build` and `/ship`. **Standard** (Size S or M, LOW or STANDARD): three sessions, `/design`, `/build`, `/ship`. **Full** (HIGH or CRITICAL, Size L or XL, or anything sensitive): the seven stage pages. A surprise moves a story up a track, never down.
- **Kept in every track:** a proof that can fail for every criterion, the gate on the exact commit with its receipt, review by someone other than the builder, one change record with all seven sections, the budget stop and the founder's authority.
- New step pages `/design`, `/build`, `/ship`; the record checker requires `Track:` on new records and enforces each track's limits and its second opinion (full: at Validate and Review; standard and rapid: once on the diff, none for a rapid LOW story). The small-change lane of 2.2 is retired into the rapid track.
- The charter's agreement 6 now says it plainly: the lightest track that meets all the criteria, only the members the story needs.

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
