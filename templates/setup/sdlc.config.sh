#!/usr/bin/env bash
# sdlc.config.sh — the only bridge between the Sipk.ai POD and a project.
# Copy to the repository root, then fill in the project's paths and gate
# stages. Sourced by sipkai-pod/sdlc/scripts/*.sh from the repository root.
#
# Every stage function must exit non-zero on failure. A stage the project
# has not configured yet calls `sdlc_unconfigured "<what>"`, which fails the
# gate on purpose: unconfigured is never green.

SDLC_PROJECT_NAME="Project name"

# The team's workspace in this project (R-8.19). Everything the pod produces
# for this project lives here, never inside sipkai-pod/. adopt.sh creates it.
SDLC_WORKSPACE="delivery"
SDLC_BOARD="delivery/backlog/BACKLOG.md"
SDLC_STORIES_DIR="delivery/backlog/stories"
SDLC_RECORDS_DIR="delivery/backlog/change-records"
SDLC_DECISIONS_DIR="delivery/decisions"
SDLC_LESSONS_DIR="delivery/lessons-learned"
SDLC_REVIEWS_DIR="delivery/reviews"
SDLC_PROJECT_IMPROVEMENTS="delivery/IMPROVEMENTS.md"

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
project_drift_checks()    { sdlc_unconfigured "drift checks (doc-versus-code contracts); write 'return 0 # none yet: <reason>' to declare none"; }

# The project's own tools and versions; check-tools.sh runs this after its
# generic tools. Use `require <program> "<install hint>"`.
project_tool_checks()     { return 0; }

# Phrases of a route or tool the project has retired (for example a review
# route it no longer uses). check-record-drift.sh refuses them in the truth
# files, the stories and the board.
SDLC_RETIRED_PHRASES=()

# The independent reviewer's endpoint and Keychain item (R-6.7). The key
# itself is never written anywhere.
# SDLC_SECOND_OPINION_URL="https://api.openai.com/v1/chat/completions"
# SDLC_SECOND_OPINION_KEYCHAIN_ITEM="sipkai-openai-api"

# Change records finished before Sipk.ai POD 2.2 keep the older checks: list
# their ids here, separated by spaces. New records always get every check.
SDLC_LEGACY_RECORDS=""
