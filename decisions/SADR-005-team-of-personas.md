# SADR-005: The method is run by a team of named personas

- Date: 2026-10-19
- Status: Accepted (Zoltán Šipkai, 2026-10-19)
- Owner: Zoltán Šipkai
- Evidence: the founder wants a generic implementation team of agents he can give to any project. In 1.2.0 one orchestrating session did every stage and spawned anonymous reviewers. The founder could not see who was accountable for what, each stage re-read the whole method, and the founder's own name appeared both as the human owner and, in proposals, as the orchestrator.

## Decision

- Eight personas, each one file in `agents/` that is also its agent definition: Sipk.ai (Engineering Director, the main session), Miro (Product Owner), Marketa (Architect), Michal (Developer), Bruno (Tester), Adam (Security), Ivan (DevOps and Deploy), Tina (Scrum Master).
- The founder is the human and has no agent file. The orchestrator is not named after him.
- Each stage has exactly one accountable persona; the RACI in `PIPELINE.md` is the contract.
- Reviewer checklists are lenses, not people. A persona wears a lens; the independent reviewer from a second model family stays outside the team and judges only.
- A persona file is operational, never narrative: accountable for, consulted on, may touch, must refuse, checklists and scripts, how it reports. It is kept under about eighty lines.
- The Scrum Master keeps the bill and the metrics, researches outside practice and proposes improvements; she applies nothing (R-10.7).

## Consequences

Each stage loads its stage page and the accountable persona's page instead of the whole method. The founder hears one voice, Sipk.ai, naming who found what. Authority is bounded per persona, and the harness tools list in each agent file is the enforcement.

## Review trigger

A persona that never acts in twenty stories, or two personas that always act together.
