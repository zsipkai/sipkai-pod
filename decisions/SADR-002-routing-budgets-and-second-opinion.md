# SADR-002: Route by risk, budget by size, verify on the top tier and a second model family

- Date: 2026-10-14
- Status: Accepted
- Owner: Zoltán Šipkai
- Evidence: a measured XL story cost about 44% less with routing than all-top, with review catching the cheaper model's mistakes; same-family reviewers repeatedly graded their own family's mistakes as fine.

## Decision

Risk and ambiguity select the executing tier; size sets the token budget; verification stages always run the top tier; on STANDARD risk and higher a reviewer from a different model family judges the design and the diff. Details: `rules/model-routing.md`.

## Consequences

Cheap generation is safe only behind expensive verification and mechanical gates. The second opinion costs a paste on a flat-fee subscription and never gates by itself.

## Review trigger

A tier lineup change, or measured cost or quality data that contradicts the routing table.
