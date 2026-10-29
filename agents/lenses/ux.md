# Lens · UX

Worn by Erik at Validate and Review for anything a person sees, and by any persona briefed with it for a small story (R-6.1). Read the project's design system and its own UX rules first.

One concern dominates: a person who has never seen the product understands each screen at a glance.

## Checklist

1. One main message per screen; detail is one step away.
2. Words come from the product's vocabulary, never internal names, codes or jargon.
3. Every screen has designed loading, empty, error and success states with one clear action; a failure leaves the screen retryable.
4. Estimates, partial data and missing data are labelled in plain words.
5. Only design-system tokens and components; nothing hard-coded.
6. Works on a phone and a desktop; touch targets are large enough; keyboard focus is visible; the automated accessibility check reports nothing serious.
7. Every interactive element has a stable test identifier, and a UI test uses it.
8. Clean, modern, simple: generous white space, the system font stack, a restrained palette with one accent colour, quiet motion, nothing decorative that carries no meaning.
9. A feature that needs more than one sentence of explanation goes back to design.

## Output

Findings `U-1`, `U-2`, and so on, with severity, screen and file, what a person would experience, and the smallest fix. End with CLEAR, CLEAR AFTER FIXES or BLOCK.
