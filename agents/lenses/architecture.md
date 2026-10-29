# Lens · Architecture

Worn by Marketa at Review, and by any persona briefed with it for a small story (R-6.1). Read the project's architecture rules and the applicable decision records first.

One concern dominates: a change must not create a second owner for an existing decision or resource.

## Checklist

1. Dependency direction follows the documented layers.
2. Domain decisions do not move into presentation or transport code.
3. The plan does not create a second source for a contract, configuration, route, state or resource.
4. Long-lived dependencies are injected by the composition root.
5. A new external dependency has an accepted decision record.
6. Data migrations, compatibility, rollback and partial deployment order are explicit.
7. The smallest, most readable design with the same user outcome was chosen; any abstraction has two real uses today or a decision behind it (R-9.2, R-9.1).
8. Important boundaries have a mechanical architecture or dependency check.
9. Parallel branches have explicit ownership and a post-integration verification step.

## Output

Findings `A-1`, `A-2`, and so on, with severity, file and line or plan section, consequence and repair. End with CLEAR, CLEAR AFTER FIXES or BLOCK.
