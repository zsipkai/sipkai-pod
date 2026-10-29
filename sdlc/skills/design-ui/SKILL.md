---
name: design-ui
description: Sipk.ai POD, Sprint 0 step 5 and any story that adds screens. Erik turns the backlog's first release into clickable HTML mocks and a design system of tokens and components, and gets the founder's approval of the mocks. Use in Sprint 0, or when a story needs screens that the design system does not cover yet.
---

# UI, mocks and design system · `/design-ui`

**Proves:** the people who will use the product can see it before it is built, and every screen will be made from one set of tokens and components.
**Cost of a miss caught here:** an hour of mock changes. Found after a story is built it costs the story again.

## Who

| | |
|---|---|
| Accountable, does the work | **Erik** (UX and UI Designer) |
| Consulted | **Miro** whether each screen serves the stories; **Marketa** what the chosen frontend stack can do; **Bruno** the stable identifiers and states the UI tests will need; **Adam** what a screen must never show |
| Founder | approves the mocks, or says what to change |

## Input and output

- **Input:** the board's first release, the business case's users and outcome, any demo or brand the founder already has.
- **Output:** in the project workspace, `sprint-0/mocks/` (one clickable HTML page per main screen, linked together, with sample data that is synthetic) and `sprint-0/design-system.md` from `sipkai-pod/templates/sprint-0/design-system.md`.

## Hard rule

The simplest screen that does the job, in Erik's clean, modern, Apple-like style. One main message per screen, plain words in the product's own vocabulary, every state designed (loading, empty, error, success), accessible by keyboard and to screen readers, works on a phone and a desktop. Mock data is synthetic, never a real person's data (R-8.9).

## Steps

0. **Start check.** `bash sipkai-pod/sdlc/scripts/stage-start.sh UI` (R-8.18).
1. **Journeys.** For each story in the first release, the path a user takes, screen by screen.
2. **Design system first.** Tokens (colour, type, spacing, radius, motion) with light and dark values, and the components the journeys need, each with its states and its accessibility notes.
3. **Mocks.** Clickable HTML built only from those tokens and components, one page per main screen, with every state reachable.
4. **Check.** The UX lens (`agents/lenses/ux.md`) on every screen: one message, plain words, designed states, contrast and focus, phone and desktop.
5. **Approval.** Sipk.ai shows the founder the mocks in one message with the open choices and a recommendation each. His approval, or his changes, are recorded in `design-system.md`.

## Exit condition

Every screen of the first release has an approved mock; every component it uses is in the design system with its states.

## Rules that bind this step

R-3.7, R-8.9, R-9.4, R-9.10.
