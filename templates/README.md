# Templates: the artefacts the team creates in a project

The pod keeps only templates. Every artefact for a project is created in that project's workspace, the folders its `sdlc.config.sh` names, and never inside `sipkai-pod/` (R-8.6). `sdlc/scripts/adopt.sh` creates the workspace on day one.

## The project workspace

```text
<project>/
  AGENTS.md  CLAUDE.md          the project's constitution: product rules, private material, required reading
  sdlc.config.sh                the only bridge between the pod and the project: folders, gate stages, tools
  sipkai-pod/                   the pod, pinned to a version, never edited for this project
  delivery/                     the team's workspace (SDLC_WORKSPACE)
    business-case.md            go or no-go, with the founder's name and date
    sprint-0/                   README (status and ledger), release-plan, architecture,
                                mocks/, design-system, accesses, poc
    backlog/
      BACKLOG.md                the board (SDLC_BOARD)
      stories/                  one card per story (SDLC_STORIES_DIR)
      change-records/           one record per story, findings/ beside them (SDLC_RECORDS_DIR)
    decisions/                  ADR-NNN, one per lasting choice (SDLC_DECISIONS_DIR)
    lessons-learned/            one retrospective per story (SDLC_LESSONS_DIR)
    reviews/                    dated reviews, release pre-flights (SDLC_REVIEWS_DIR)
    IMPROVEMENTS.md             the project's own improvement log (SDLC_PROJECT_IMPROVEMENTS)
  docs/                         product truth: what the product does, tests, infrastructure, deployment
  src/  tests/                  the code
```

A project that already has its own folders points `sdlc.config.sh` at them instead; the pod reads every path from there.

## The templates

Who owns each artefact is on the team page (`agents/README.md`, "Who owns what").


| Template | Artefact | Written at | Guarded by |
|---|---|---|---|
| `business-case.md` | problem, users, outcome, scope, options, cost range, risks, recommendation, the founder's decision | Sprint 0 step 1 (R-2.5) | no backlog without a go |
| `backlog/backlog.md` | the board: epics, stories in proposed order with the reason for each place, open questions | intake, then kept current at every step | the drift check of card, board and record |
| `backlog/story.md` | one story card with criteria that can fail | intake | the Defined gate (R-2.6) |
| `sprint-0/README.md` | Sprint 0's status table and ledger | Sprint 0 | the exit list (R-2.5) |
| `sprint-0/release-plan.md` | milestones, the first sprint, what is left out | Sprint 0 step 4 | |
| `sprint-0/architecture.md` | one diagram, the stack and why, the riskiest assumption, single owners | Sprint 0 step 4 | lasting choices become decision records |
| `sprint-0/design-system.md` | tokens, components and states, vocabulary, the screens and their mocks | Sprint 0 step 5 | the founder's approval of the mocks |
| `sprint-0/accesses.md` | every access, who creates it, where the secret lives, authority, how it was checked | Sprint 0 step 6 | each access checked with a command |
| `sprint-0/poc.md` | the assumption, what was built, the measured result | Sprint 0 step 7 | a quoted command and output |
| `change-record.md` | one section per stage, the ledger, the receipts | every stage | `check-change-records.sh` on every commit |
| `decisions/adr.md` | a lasting decision with its reason and consequences | when a choice should stay made (R-5.3) | read before every technical choice |
| `lessons-learned/retrospective.md` | the bill, what each lens alone caught, one outside source, three lean proposals | after every `DEPLOYED` story (R-10.2) | proposals become improvement rows |
| `improvements/IMPROVEMENTS.md` | the project's own improvement log | whenever a weakness is found (R-1.2) | `check-improvements.sh` |
| `reviews/review.md`, `reviews/release-preflight.md` | dated independent reviews, the checklist before a release | before releases, on a schedule (R-10.2) | findings feed the backlog |
| `setup/sdlc.config.sh`, `setup/AGENTS.md` | the bridge and the project constitution | once, by `adopt.sh` | unconfigured gate stages fail on purpose |

The method's own decisions and improvement log, shared by every project, live in `sipkai-pod/method/`.
