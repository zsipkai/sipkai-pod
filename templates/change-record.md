# STORY-NNN: <Title>

Stage: PLANNED
Risk: LOW | STANDARD | HIGH | CRITICAL
Size: <S | M | L | XL> — <one line: the route this size takes and why (R-2.8); XXL is split first; CRITICAL is always XL>
Execution model: small | mid | top (per sipkai-pod/sdlc/RULES.md section 7 — assigned in /plan-task, checked in /validate-design; HIGH/CRITICAL risk requires top)
Budget: <from the size table — S=750k M=2M L=2.5M XL=4M (total tokens); XXL must be split>
Owner: <accountable human>
Story: `backlog/stories/STORY-NNN-<slug>.md`
Lane: full | test-only | docs/process-only | hotfix | bootstrap
Coordination issue: <optional URL or key>
Deployment candidate: PENDING
Harness and version: <agent harness and version when available>
Model: <model or None recorded by harness>

## Discovery Brief

Planning outcome: PLANNED

### Outcome and non-goals

### Current behavior and observations

### Context manifest

List the rules, ADRs, living docs, component docs, code, tests, schemas, contracts, specifications, history, issues, logs, web pages, and tool results read for this change. State why each source matters, classify it as `TRUSTED`, `VERIFIED`, or `UNTRUSTED`, and record how material external claims were checked. Record contradictions as blockers.

| Source | Trust class | Why it matters | Verification |
|---|---|---|---|
| <path, URL, issue, log, or tool result> | <TRUSTED/VERIFIED/UNTRUSTED> | <reason> | <code, test, system, or human check> |

### The facts a fresh session needs inline

Every acceptance-critical fact (exact limits, identifiers, formulas, rounding rules, copy) written out here, so the next stage passes the isolation test without opening other documents.

### Declared scope and runtime authority

- Expected files or directories:
- Control-plane files expected to change: None
- Dependencies expected to change: None
- Allowed tools:
- Filesystem scope:
- Network destinations:
- Credential or permission profile:

### Affected owners and contracts

### Unknowns and blockers

### Development tasks

Order small tasks by dependency. Name verified files and tests; label uncertain paths as hypotheses.

### Acceptance map

| Acceptance criterion | Primary proof | Adverse or boundary proof | Layer |
|---|---|---|---|
| <criterion> | <test or procedure> | <negative case> | <unit/integration/UI/live/manual> |

### Risk, observability, and rollback

| Risk or failure mode | Tier | Detection | Mitigation | Rollback owner |
|---|---|---|---|---|
| <risk> | <tier> | <signal> | <control> | <human or role> |

### Required specialists

| Reviewer | Why | Stage |
|---|---|---|
| <reviewer agent> | <risk surface> | <validate-design / clear-review> |

### Human checkpoints

| Decision | Required? | Owner | Evidence or date |
|---|---|---|---|
| Story ready | yes | <name or role> | <reference> |
| Design validation | <based on risk> | <name or role> | <reference> |
| Outcome acceptance | <based on risk> | <name or role> | <reference> |
| Merge or production deployment | yes | <name or role> | <reference> |

### Agent budget and spend ledger

- Token budget (stop-loss): from the size table in the `Budget:` metadata
- Allowed tier by stage: per sipkai-pod/sdlc/RULES.md section 7 (execution at the routed tier; verification always top)
- Stop condition: crossing the budget halts the stage for a human decision — raise, split, or escalate the tier. `stage-start.sh` checks it at the start of every stage (R-7.2). A raise changes `Budget:`; a decision to go on without one is a line `Budget decision: <what> — <name>, YYYY-MM-DD`.

Each stage appends one line here as it finishes (mark estimates as such):

`Tokens spent (<stage>): <n> — <note>`

`sipkai-pod/sdlc/scripts/cost-report.sh` aggregates these lines across all records.
- Actual cost:

## Design Verdict

Design outcome: PENDING

### Validated design and simpler alternative considered

### Findings and resolutions

| ID | Severity | Finding | Evidence | Resolution or owner |
|---|---|---|---|---|
| <ID> | <BLOCKER/SHOULD/NOTE/QUESTION> | <finding> | <reference> | <resolution> |

### Second opinion (rule 16 — Risk ≠ LOW)

Second opinion: <family and model, and the `X-n` findings in the table above — or `skipped`, with the reason (R-6.2)>

### Exceptions and waivers

Use `None` when no exception exists. Every exception needs scope, owner, reason, compensating control, and expiry or follow-up.

| Rule or gate | Scope | Approved by | Reason | Compensating control | Expires or follow-up |
|---|---|---|---|---|---|
| None | | | | | |

## Implementation Record

Development outcome: PENDING

### Changed files and reasons

- <path and reason>

### Actual scope and authority used

- Files outside declared scope: <None, or reason and approval>
- Control-plane files changed: <None, or list and human owner review>
- Dependencies added or changed: <None, or provenance, security review, and lockfile evidence>
- Tools and network destinations used:
- Credentials or permissions used:

### Decisions and documentation updated

- <decision, document, or None with reason>

### Narrow checks

- <command and result>

### Deviations

- <None, or deviation plus resolution>

## Acceptance Evidence

Acceptance outcome: PENDING

| Acceptance criterion | Proof run | Result | Adverse proof | Result | Evidence |
|---|---|---|---|---|---|
| <criterion> | <test or procedure> | <pass/fail> | <negative case> | <pass/fail> | <log or reference> |

### Failures, skips, and manual gaps

## Review Verdict

Review outcome: PENDING

### Reviewers and scope

- <reviewer and reviewed surface>

### Second opinion (rule 16 — Risk ≠ LOW)

Second opinion: <family and model, and the `X-n` findings below — or `skipped`, with the reason (R-6.2)>

### Findings, fixes, and focused retests

- <finding, resolution, and retest evidence>

### Remaining risks and human acceptance

- <risk and owner, or None; acceptance evidence when required>

## Regression Certificate

Regression outcome: PENDING

- Commit SHA:
- Environment:
- Full gate command:
- Gate receipt: <the line the passing gate printed: commit, mode, PASS, time (R-2.2)>
- Build and static analysis:
- Unit and integration:
- UI or end-to-end:
- Security and drift checks:
- Required CI:
- Skips or discarded runs:
- Result:

## Deployment Record

Deployment outcome: PENDING

- Human deployment approval:
- Required CI URL or receipt:
- Merge SHA:
- Artifact or provenance identifier:
- Deployment surface and identifier:
- Live behavior observed:
- Health and guardrail signals:
- Monitoring window:
- Rollback status:

## SDLC findings

Weaknesses, gaps or contradictions in the Sipk.ai POD or the project's rules noticed during this story, each logged in `sipkai-pod/method/IMPROVEMENTS.md` as `PROPOSED` (R-1.2). Write `None` if there were none. Nothing here is applied without a recorded human approval.

| Improvement id | Stage that found it | Summary |
|---|---|---|
| None | | |

## Definition of Done

- [ ] Every acceptance criterion has recorded evidence.
- [ ] Required adverse, boundary, permission, and error cases pass.
- [ ] No unexplained skip, suppression, retry, sleep, or weakened assertion remains.
- [ ] Code, tests, documentation, decisions, and contracts agree.
- [ ] No blocking review finding remains.
- [ ] Actual files, dependencies, tools, network access, and permissions match the declared scope or have an owned explanation.
- [ ] Every control-plane change has explicit human owner review and evidence that the control was not weakened.
- [ ] Every exception has an owner, compensating control, and expiry or follow-up.
- [ ] The implementation is the simplest readable design that meets the criteria (R-9.2, R-9.1).
- [ ] SDLC weaknesses found during this story are logged as proposals in `sipkai-pod/method/IMPROVEMENTS.md`; none were applied without human approval.
- [ ] Required human checkpoints are recorded.
- [ ] The reviewed combined tree passed the full required matrix.
- [ ] Deployment, live verification, observation, and rollback status are recorded when applicable.
