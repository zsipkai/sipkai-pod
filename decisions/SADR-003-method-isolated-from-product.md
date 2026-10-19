# SADR-003: Keep the method in sipkai-pod/ and connect projects through sdlc.config.sh

- Date: 2026-10-14
- Status: Accepted
- Owner: Zoltán Šipkai
- Evidence: in earlier projects the method's rules, the product's rules, stories and evidence all lived in one `docs/` folder, so upgrading the method meant hand-merging product files, and gate scripts held product paths.

## Decision

- The method (SDLC.md, generic rules, templates, scripts, evaluations, these decisions) lives in `sipkai-pod/` and contains nothing product-specific.
- Product truth lives in `docs/`, stories and change records in `backlog/`, code in `src/`, cross-cutting tests in `tests/`.
- `sdlc.config.sh` at the repository root is the only bridge: folder paths, truth files, and the project's gate stages.
- Root-level harness bindings (`AGENTS.md`, `AGENTS.md`, `.claude/`) stay at the root because tools require it.

## Consequences

The method can be upgraded by replacing `sipkai-pod/` and reviewing the diff. Scripts never hard-code product paths. A project cannot pass the gate without configuring its own stages, because unconfigured stages fail closed.

## Review trigger

A second project adopts the method, or a harness supports loading skills from a sub-folder.
