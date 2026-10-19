# Scripts

The gate and its checks, unchanged from version 1.2.0 apart from the folder name. They read folder paths and gate stages from the project's `sdlc.config.sh` and never hard-code product paths.

| Script | Does | Run by |
|---|---|---|
| `sdlc-gate.sh` | the gate: `--fast`, `--full`, `--ui`, `--deploy` (R-3.21) | the hook, CI, Michal, Bruno, Ivan |
| `check-change-records.sh` | the stage never outruns its evidence (R-2.4 to R-2.8) | every gate |
| `check-improvements.sh` | no applied improvement without a human approver and date (R-1.2) | every gate |
| `check-doc-drift.sh` | documentation claims against reality (R-3.22) | every gate, Bruno |
| `check-secrets.sh` | secret scan (R-8.10) | every gate, Adam |
| `check-dependencies.sh` | known vulnerabilities (R-8.11) | `--full` and above, Adam |
| `check-tools.sh` | required tools present, fail closed | every gate |
| `check-md-links.py` | no broken relative links | every gate |
| `second-opinion.sh` | the pack for the independent reviewer, paste or `--auto` (R-6.7) | Marketa at Validate, Sipk.ai at Review |
| `cost-report.sh` | the bill from the ledger lines (R-7.11) | Tina |
| `install-hooks.sh`, `pre-commit` | the local hook (R-8.14) | Ivan |
| `adopt.sh` | creates `sdlc.config.sh` and `AGENTS.md` from the templates in a project that includes the pod | whoever adopts it |
| `lib.sh` | shared helpers | the others |
