# Independent study of the Sipk.ai POD 2.5.0

- Date: 2026-10-29
- Reviewer: an independent agent session, read-only, briefed only with the five questions below and the repository; it ran nothing except gitleaks against an empty folder to confirm one failure
- Asked by: Zoltán Šipkai ("is this now hierarchical, independent from the project, independent from code, can they immediately start to pick up a project, can they fully work together ... make a deep study and create me top 5 improvements")
- Checked by Sipk.ai before filing: the link-checker root (confirmed: since 2.3 it checked the pod's links, not the project's) and the missing secret-scan config for a new project (confirmed in `check-secrets.sh`)
- Outcome: the founder approved all five improvements the same day; they ship as 2.7.0

## 1. Hierarchical and easy to navigate? Partly

- **Duplication.** The same facts appear in several places, so they drift:
  - The team table is in CLAUDE.md, agents/README.md and README.md.
  - The track table was in CLAUDE.md, sdlc/README.md and RULES R-2.8.
  - "How the pod talks" is in CLAUDE.md, agents/README.md and charter agreements 8 and 10.
- **Contradictions that have already happened:**
  - independent-reviewer.md says the second opinion runs "twice" at STANDARD and above; the tracks said once for the shorter routes.
  - independent-reviewer.md and clear-review step 3 say the pack holds "the charter"; second-opinion.sh never adds it.
  - CLAUDE.md and R-2.4 say the pod chains stages on its own; several stage pages still say "point the founder at …"; test-regression says Deploy "runs only on his deliberate invocation", while deploy-change says Sipk.ai invokes it.
  - Where retrospectives go: R-10.2 and deploy-change say the reviews folder; templates/README.md says `lessons-learned/`.
  - templates/setup/AGENTS.md says `backlog/…`, but the config defaults to `delivery/backlog/…`, and it lists only the seven-stage route, with no sizes and no Sprint 0.
  - sdlc/README.md's quality table suggests independent review only at CRITICAL, while CLAUDE.md says above LOW.
  - Pillar 6 says "mechanical gates decide", but adam.md says Adam's BLOCK stops the merge.
  - The Full lane (all seven stages for anything a user sees) collided with the short routes.
- **Stale pages:** scripts/README.md and evals/README.md say "unchanged from 1.2.0"; marketplace.json says "eight personas, seven stage commands".
- **Wrong level:** the 50-line old-number map in RULES.md is history and belongs in method/.

## 2. Independent of any one project? No

- **Money Review data:** R-7.2 calibrates every budget on Money Review's spend; the method's improvement log is mostly Money Review rows, and every project's gate checks it; agents/README.md names Zoltán as "the founder".
- **Stack and tool assumptions:** npm `--save-exact --before` in R-8.5; Java-shaped proof forms in R-3.1; web-only `data-testid` in develop-code and test-acceptance; Java, Node and AWS CDK folders hard-coded in check-dependencies.sh; Homebrew install hints in check-tools.sh; gitleaks, osv-scanner and rg required; the pod must sit at `<root>/sipkai-pod`; the integration branch is always `main`.
- **Vendor assumptions:** the second opinion is OpenAI only, the key comes from the macOS Keychain, the model defaults to `gpt-5.1`.
- **Style assumptions:** Apple visual style with 44-point touch targets. (The founder chose this for Erik; it stays.)

## 3. Independent of code and of the coding harness? Partly

- **Claude Code only:** the plugin manifest; the `model:` and `tools:` lines in persona frontmatter, which also override the tiers (Bruno is fixed to `sonnet` but must run `top` or `small`); the `@AGENTS.md` shim and the settings.json setup; `.claude/**` as control plane and project lenses in `.claude/agents/`; least authority resting entirely on settings.json deny rules, so another harness loses it silently.
- **Missing mechanics in any harness:** "starts every step itself in a fresh session" has no stated mechanism; "harness-measured usage" is never defined, and in practice the ledger holds context-counter estimates.
- **Portable:** the gate, the scripts and the record format run under any harness; the rest works as prose read by a cooperative agent.

## 4. Can the team pick up a new project immediately? No

- **Setup:** nothing does `git init` or adds the submodule; Sprint 0 put the business case before `adopt.sh`, but its step 0 (`stage-start.sh`) exits without `sdlc.config.sh`.
- **What adopt.sh does not create:** `.gitleaks.toml`, which the secrets check requires (confirmed: gitleaks exits "unable to load gitleaks config"); `docs/PRODUCT.md` and `docs/TESTS.md`, which are default truth files, so doc drift fails; `docs/SDLC-PROJECT.md`, which has no template; deny rules; a CI workflow.
- **Gate on an empty project:** `--fast` fails closed on tools, doc drift, secrets, static analysis and fast tests; only drift checks have a sanctioned "none yet" form, and declaring "no tests yet" looks like weakening the gate; the bootstrap lane has no template.
- **Link checker bug:** `check-md-links.py` resolved its root to `sipkai-pod/`, so the gate checked the pod's links, never the project's.
- **Business case:** it must price the build "from the ledger" at "today's model rates", but a new project has no ledger and the pod has no price table.
- **Never proven:** Money Review skipped Sprint 0; the adopt evaluation only checks that files were created.

## 5. Can the personas genuinely work together? Partly

- **Personas are labels in practice:** Develop, Regress and Deploy ran "by the stage session itself, no subagent" in STORY-007.
- **Sipk.ai holds too much:** it sizes, briefs, keeps the ledger, answers design questions, does the generalist review, is accountable for the Review verdict and edits the fixes; it judges work it orchestrated.
- **The short routes let the builder validate his own design.**
- **No disagreement rule:** nothing says who clears a lens's BLOCK, or who wins between Adam and Marketa.
- **Owners overlap:** the board (Sipk.ai, Miro, Marketa); decision records (owned by Marketa, written by Michal); budget watch (Sipk.ai and Tina).
- **Gaps in authority:** Tina may only touch the method's log, yet must write retrospectives and the project log; Erik and Tina are missing from the authority table; whether a new screen needs the founder's mock approval outside Sprint 0 is unclear.
- **The founder is a bottleneck:** budgets were too low for full-route work (STORY-043 was raised four times).
- **Safeguards satisfied by text alone:** a `Budget decision:` line passes on any name and date, and one record holds a raise "relayed by the orchestrating session"; any `Second opinion: skipped …` line passes.

## Top 5 improvements

1. **Make adopt produce a gate that can turn green, and prove it.** adopt.sh creates `.gitleaks.toml`, `docs/SDLC-PROJECT.md` (new template with a bootstrap section) and the truth files it lists; `sdlc_none "<reason>"` in lib.sh for stages with no code yet; fix the link checker's root; adopt becomes the first step of Sprint 0; an evaluation runs adopt on a fresh project and expects a green `--fast`.
2. **Remove project and vendor leakage.** Money Review figures and rows out of the method; method proposals logged in each project's own log and carried into the pod on upgrade; the npm rule and Java proof forms made generic; "stable test identifiers" instead of `data-testid`; second-opinion URL, model and key source from `sdlc.config.sh`.
3. **One source per fact.** CLAUDE.md summarises and points; the team detail lives in agents/, the sizes in sdlc/README.md, the rules in RULES.md; the old-number map moves to method/; the contradictions above are fixed.
4. **Make orchestration honest.** One place says who starts each step and how; in the short routes a reviewer, not Michal, checks the design; a BLOCK is cleared only by the lens that raised it or by the founder; one owner per file; Tina and Erik get the authority their duties need; `Budget decision:` quotes the founder's own words; ledger lines say whether they are measured or estimated.
5. **A harness adapter.** The plugin, the frontmatter, the settings and deny-rule template, and notes on starting sessions and measuring tokens live in `adapters/claude-code/`; persona and step pages keep tier names only.
