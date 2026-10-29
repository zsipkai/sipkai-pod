# Process evaluations

`run-evals.sh` replays known good and known bad cases for every check: change records, sizes and budgets, the start check, improvements, drift, tools, secrets, dependencies, hooks, the second opinion, and a brand-new project reaching a green gate on day one.

Skills, reviewers, rules and gates are production process code (R-3.5). When any of them changes, these cases are replayed and a case is added for every new failure class. The move itself is proven by this suite passing unchanged (`method/decisions/MIGRATION-1.2-to-2.0.md`).
