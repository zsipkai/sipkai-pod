# Review title: scope in a few words

- Date: YYYY-MM-DD
- Kind: readiness | production readiness | security audit | architecture | UX | other
- Scope: what was reviewed, at which commit or version
- Reviewers: each reviewer, its charter, and whether it ran in an independent context
- Owner of the decision: the accountable human

## Verdict

One paragraph and a table of gates with status and what is needed.

## Evidence and scope

Commands run (quoted), files and environments inspected, what was not covered and why.

## Findings

Numbered per reviewer (A-n architecture, S-n security, T-n tests and process, P-n product, X-n second family). Each finding: severity (BLOCKER, SHOULD, NOTE, QUESTION), location, the concrete failure, the smallest fix.

### Priority 0: blockers

### Priority 1: fix before the next milestone

### Priority 2: quality and consistency

## Resolution

For every blocker: the fix and where it now lives (story, acceptance criterion, decision, rule). Findings not applied are listed with the reason.

## Accepted risks

Risk, why it is accepted now, and when it is revisited.

## Closure check

A fresh reviewer re-checks every blocker against the files. Record the first-pass result, what was fixed after it, and the final verdict.
