# Scripts

The gate and its checks. They read folders, gate stages and tools from the project's `sdlc.config.sh` and never hard-code a product's paths.

| Script | Does | Run by |
|---|---|---|
| `stage-start.sh` | the first step of every stage: started in the project root, inside the budget, and enough left for the step's planned share (R-8.1, R-7.2) | every stage |
| `sdlc-gate.sh` | the gate: `--fast`, `--full`, `--ui`, `--deploy`; a passing `--full` or higher prints a gate receipt (R-3.5, R-2.2) | the hook, CI, Michal, Bruno, Ivan |
| `check-change-records.sh` | the stage never outruns its evidence (R-2.2); since 2.2 the second-opinion line, the gate receipt and the raised budget; since 2.6 size as the route (a CRITICAL story is XL); since 2.8 the record's length by size and the `Found only by:` line | every gate |
| `check-record-drift.sh` | the story card, the board and the change record agree on stage, tier and budget; no retired phrase in the truth files, open stories or board (R-3.6) | every gate |
| `check-improvements.sh` | no applied improvement without a human approver and date (R-1.2) | every gate |
| `check-doc-drift.sh` | documentation claims against reality (R-3.6) | every gate, Bruno |
| `check-secrets.sh` | secret scan (R-8.4) | every gate, Adam |
| `check-dependencies.sh` | known vulnerabilities (R-8.5) | `--full` and above, Adam |
| `check-tools.sh` | required tools present, fail closed | every gate |
| `check-md-links.py` | no broken relative links | every gate |
| `check-dependency-lane.sh` | whether a lockfile-only update may take the dependency lane: only lockfiles and paperwork changed, manifests still satisfied, the shipped build byte-identical to `main`'s, the scan green; prints the receipt the record quotes (R-4.1) | Sipk.ai on `/quick`, before choosing the lane |
| `review-pack.sh` | the one pack every reviewer of a round starts from: the record's contract without its ledger, earlier findings or verdicts, the named files' current text, and at Review the diff (R-6.1) | Sipk.ai at every design check and review |
| `second-opinion.sh` | the pack for the independent reviewer, paste or `--auto`; exit 3 when no second opinion was obtained (R-6.2) | Marketa at Validate, Sipk.ai at Review |
| `cost-report.sh` | the bill from the ledger lines (R-7.3) | Tina |
| `install-hooks.sh`, `pre-commit` | the local hook (R-3.5) | Ivan |
| `adopt.sh` | creates `sdlc.config.sh`, the project's `AGENTS.md` and the team's workspace (board, stories, records, decisions, lessons learned, reviews, Sprint 0, the project's improvement log) in a project that includes the pod; never overwrites | Ivan in Sprint 0 |
| `lib.sh` | shared helpers | the others |
