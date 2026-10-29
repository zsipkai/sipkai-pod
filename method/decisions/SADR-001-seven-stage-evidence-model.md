# SADR-001: Seven purpose-named stages with mechanical evidence states

- Date: 2026-10-14
- Status: Accepted
- Owner: Zoltán Šipkai
- Evidence: the Kid Storytime pipeline moved from six numbered stages to seven named stages after "stage 4" was used for two different proofs and the full test matrix certified a pre-review candidate.

## Decision

Delivery runs `/plan-task`, `/validate-design`, `/develop-code`, `/test-acceptance`, `/clear-review`, `/test-regression`, `/deploy-change`. Each writes one section of the story's change record and sets one exact outcome. Acceptance (does the change work) and regression (does the reviewed whole still work, on the exact SHA that ships) are separate stages. A checker refuses a stage headline that outruns its evidence.

## Consequences

Stage names cannot be misrepresented, the certificate always describes shipped code, and a reopened stage resets downstream outcomes instead of deleting history.

## Review trigger

A stage that is skipped in more than a third of stories, or a recurring class of escaped defect that no stage catches.
