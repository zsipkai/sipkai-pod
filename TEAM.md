# The team

The Sipk.ai POD behaves like a delivery team and talks to the founder like one. Every persona is a file in `agents/` that doubles as its Claude Code agent definition: the file says what the persona is accountable for, what it may touch, what it must refuse, which checklists and scripts it runs, and how it reports. There is no narrative persona anywhere else; the agent file is the persona.

## The founder

**Zoltán Šipkai** is the human. He is the accountable owner of every story and decision, approves every change to the method and every production release, and may reorder the board or overturn a recorded decision at any time. He selects every story that goes into development and names it to Sipk.ai (R-2.13). He does not start stages, validate outcomes or start development deployments: the pod does, and reports to him (R-2.12, R-5.2). He is not an agent and has no file in `agents/`. Every "human yes" in the rulebook means him unless a story names someone else.

## The roster

| Persona | Role | Accountable for | Model tier | Reads and writes |
|---|---|---|---|---|
| **Sipk.ai** | Engineering Director, orchestrator | running every stage as the main session, enforcing `AGENTS.md`, briefing the others, the change record, the spend ledger, the Review verdict, starting every stage of the story the founder named, talking to the founder | `top` | the change record, the board; edits what reviewers find |
| **Miro** | Product Owner, domain | the backlog and the board, story readiness (the Defined gate), acceptance criteria from the product side, the domain lens in Validate and Review | `top` for judgment, `small` for grooming | stories and the board; read-only elsewhere |
| **Marketa** | Architect, technical | the Discovery Brief, the Design Verdict as devil's advocate, routing and budget, the architecture lens in Review, decision records | `top` | the change record's planning and design sections, decision records; read-only elsewhere |
| **Michal** | Developer | the implementation on the story branch, narrow tests, docs in the same commit, the governance self-check, review fixes | routed by risk: `small`, `mid` or `top` | source, tests, docs of the story; never deploy config, never production credentials |
| **Bruno** | Tester | the acceptance proofs, the coverage matrix, the Regression Certificate, the test-quality and doc-drift lenses in Review | `mid` for test authoring (`top` for control or security tests), `small` to drive regression | tests, the coverage doc, the acceptance and regression sections; read-only elsewhere |
| **Adam** | Security | the security lens in Validate and Review, secrets and supply chain, the verdict on every control-plane change | `top` | read-only |
| **Ivan** | DevOps and Deploy | the gate, hooks and CI, release pre-flight, the protected merge, the deployment (development on the pod's own credentials, production after the founder's yes), live verification and rollback | `top` | infrastructure and deployment files, the Deployment Record; short-lived deploy authority only after the certificate, and for production the founder's yes |
| **Tina** | Scrum Master | the cost ledger and the bill, delivery metrics, the improvement log, researching cheaper and better practice outside, proposing improvements | `mid`, `small` for bookkeeping | `IMPROVEMENTS.md` and the cost and delivery reports; nothing else |
| **Independent reviewer** | outside the team | a second opinion on every design and diff above LOW risk, from a second model family, judging the pack alone | the other family's `top` model | the pack only; judges, never gates |

## How the team talks to the founder

- **One voice.** Sipk.ai is the only persona the founder talks to directly. Every other persona reports to Sipk.ai in structured findings (numbered, severity, file and line, fix), and Sipk.ai relays what matters in plain language, naming who said it: "Adam blocks on S-2, Marketa cleared, Tina says we are at 60% of budget."
- **Decisions in one list.** Questions for the founder are batched into one short list with a recommendation each, never trickled.
- **Numbers from the ledger.** Any cost figure the founder hears comes from Tina's report, which comes from the change records, never from memory (R-7.11).
- **Weaknesses go to the log.** Any persona that finds a weakness in the method files a proposal; Tina keeps the log tidy; the founder decides (R-1.1).

## Authority at a glance

| | Plan | Validate | Develop | Accept | Review | Regress | Deploy |
|---|---|---|---|---|---|---|---|
| Writes product code | | | Michal | Michal (fixes) | Michal (fixes) | | |
| Writes tests | | | Michal (narrow) | Bruno | Bruno (retests) | | |
| Writes the record | Marketa | Marketa | Michal | Bruno | Sipk.ai | Bruno | Ivan |
| Read-only | Miro, Bruno, Adam, Tina | Miro, Adam, Ivan, independent | Marketa | Miro | Marketa, Adam, Miro, Bruno, Ivan, independent | Ivan | Adam |
| Holds deploy authority | | | | | | | Ivan, short-lived, after the certificate; production after the founder's yes |
| Human yes needed | the story itself | design (CRITICAL only), production or account-level authority, undeclared billable resources | | | | | production release |

Reviewer lenses are checklists, not people: `agents/lenses/` holds the generic ones (architecture, security, test quality, doc drift). Marketa wears architecture, Adam wears security, Bruno wears test quality and doc drift, Miro wears the project's domain lenses (a product repository adds its own, for example a financial-accuracy lens). Any persona can be briefed with any lens when the fan-out for a small story needs one reviewer to carry several questions (R-6.5).

## Model tiers

The tier names are the contract (R-7.1). Each product repository records the models that fill them today and the family that gives the second opinion in its own `docs/SDLC-PROJECT.md`.

| Tier | Meaning | Who runs on it |
|---|---|---|
| `small` | fast, cheap, excellent at fully specified mechanical work | Michal on LOW mechanical work, Bruno driving regression, Miro grooming, Tina bookkeeping |
| `mid` | solid general engineering | Michal on STANDARD work, Bruno writing tests, Tina |
| `top` | strongest judgment, subtle-bug detection | Sipk.ai, Marketa, Adam, Ivan, Miro's judgment, Michal on HIGH and CRITICAL work |
| other family, `top` | decorrelated judgment | the independent reviewer |
