# Release pre-flight: release name or version

Walk this list end to end before release-bound work leaves `/deploy-change`. Every item is checked with evidence (command output, screenshot, link) or marked not applicable with a reason. Copy it into the change record or a dated file under `docs/reviews/`.

## 1. Candidate
- [ ] The Regression Certificate names the exact SHA being released, and CI is green on it.
- [ ] `sipkai-pod/scripts/sdlc-gate.sh --deploy` passed on the merge candidate.
- [ ] No open BLOCKER or HIGH finding; every exception has an owner and expiry.

## 2. Money and limits
- [ ] Cloud spending caps, budget alarms and automatic stops are in place and tested.
- [ ] Third-party API spending caps (AI providers, email, payment) are set.

## 3. Security and privacy
- [ ] Secret scan and dependency scan are clean or have owned exceptions.
- [ ] Authentication, cross-user isolation and deny rules were re-verified for this release.
- [ ] Privacy notice and data-retention behavior match what the product actually does.

## 4. Operations
- [ ] Alarms reach a human; the runbook covers rollback, pausing the service and restoring data.
- [ ] Backup restore was rehearsed within the last quarter.
- [ ] The rollback of this exact release is known and was rehearsed in a non-production environment.

## 5. Product
- [ ] Release notes written; product truth docs describe the released behavior.
- [ ] Accessibility checks pass on every screen; main journeys pass on phone and desktop widths.
- [ ] Store or marketplace metadata (if any) matches the product, and its reviewer agent returned READY.

## 6. Decision
- [ ] The accountable human recorded the release decision with date and scope.
