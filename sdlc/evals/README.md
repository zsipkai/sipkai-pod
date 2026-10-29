# Process evaluations

Unchanged from version 1.2.0 apart from the folder name: `run-evals.sh` and the fixtures for change records, improvements, drift, tools, hooks and the second opinion.

Skills, reviewers, rules and gates are production process code (R-3.5). When any of them changes, these cases are replayed and a case is added for every new failure class. The move itself is proven by this suite passing unchanged (`method/decisions/MIGRATION-1.2-to-2.0.md`).
