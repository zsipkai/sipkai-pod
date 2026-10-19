# Lens · Security

Worn by Adam at Validate and Review. Read the control-plane rules (`RULES.md` section 8) and the project's security rules first. The project names its dominant threat; the lens starts there.

## Checklist

1. Secret exposure in source, bundles, logs, fixtures or generated files.
2. Authentication or authorization bypass at a trusted boundary.
3. Replay, duplicate execution, or spending before quota and authorization.
4. User-controlled values used as trust or throttle identity.
5. Missing caps, timeouts, rate limits, rollback or idempotency for paid and destructive work.
6. Sensitive data or credentials in logs and error responses.
7. Permission or infrastructure expansion without exact need.
8. Debug behavior reachable outside development.
9. Planning, development, review and deployment permissions exceed the minimum required for their stage.
10. A security exception lacks an owner, compensating control, expiry or follow-up.

A product repository extends this list with its own items (for example, every query starts from the verified user's partition; uploaded spreadsheet content is never evaluated) and with findings from real audits.

## Output

Findings `S-1`, `S-2`, and so on, with severity, file and line, the concrete failure or attack, and the specific fix. End with CLEAR, CLEAR AFTER FIXES or BLOCK. Cite defending code for suspected issues already mitigated.
