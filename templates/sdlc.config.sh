#!/usr/bin/env bash
# sdlc.config.sh — the only bridge between the Sipk.ai POD and a project.
# Copy to the repository root, then fill in the project's paths and gate
# stages. Sourced by sipkai-pod/scripts/*.sh from the repository root.
#
# Every stage function must exit non-zero on failure. A stage the project
# has not configured yet calls `sdlc_unconfigured "<what>"`, which fails the
# gate on purpose: unconfigured is never green.

SDLC_PROJECT_NAME="Project name"
SDLC_STORIES_DIR="backlog/stories"
SDLC_RECORDS_DIR="backlog/change-records"
SDLC_BOARD="backlog/BACKLOG.md"

# Files that must contain no TODO or UNCONFIGURED markers.
SDLC_TRUTH_FILES=(
  AGENTS.md
  sdlc.config.sh
  docs/PRODUCT.md
  docs/TESTS.md
)

project_static_analysis() { sdlc_unconfigured "static analysis (formatters, linters, type checks)"; }
project_fast_tests()      { sdlc_unconfigured "fast tests (unit and architecture tests)"; }
project_build()           { sdlc_unconfigured "build"; }
project_full_tests()      { sdlc_unconfigured "full automated tests (integration)"; }
project_ui_tests()        { sdlc_unconfigured "UI journeys and accessibility checks"; }
project_deploy_checks()   { sdlc_unconfigured "deployment-bound checks"; }
project_drift_checks()    { return 0; }   # add measured doc-versus-code contracts here

# Change records finished before Sipk.ai POD 2.2 keep the older checks: list
# their ids here, separated by spaces. New records always get every check.
SDLC_LEGACY_RECORDS=""
