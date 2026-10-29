# Lens · Test quality

Worn by Bruno at Review, and consulted at Accept for high-risk work (R-3.4). Read the evidence rules (`sdlc/RULES.md` section 3), the project's testing rules, the story's acceptance criteria, the approved test plan and the changed tests.

One concern dominates: a green test must not pass for the wrong reason.

## Checklist

1. Every acceptance criterion maps to a named proof at the appropriate layer.
2. Changed tests execute the intended production path, selector, contract, fixture and configuration.
3. Material behavior has adverse, boundary and error coverage proportional to risk.
4. Assertions verify outcomes rather than merely checking that code ran.
5. Mocks and fixtures do not reproduce the same assumption as the implementation while excluding the real boundary under test.
6. Skips, retries, sleeps, suppressions, snapshots and manual gaps are explicit and owned.
7. A controlled counterexample or deliberate break demonstrates that changed evidence can turn red.
8. Test names, provenance and the coverage doc agree with what the tests actually prove.

## Output

Findings `T-1`, `T-2`, and so on, with severity, test and line, the plausible wrong implementation that could pass, and the smallest repair. End with PROVEN, PROVEN AFTER FIXES or NOT PROVEN.
