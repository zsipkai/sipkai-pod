#!/usr/bin/env bash
# sdlc.config.sh — the only bridge between the Sipk.ai POD and a project.
# Copy to the repository root, then fill in the project's paths and gate
# stages. Sourced by sipkai-pod/sdlc/scripts/*.sh from the repository root.
#
# Every stage function must exit non-zero on failure. A stage with nothing to
# run yet calls `sdlc_none "<reason>"`: green until the first story builds
# code, then it must be configured. `sdlc_unconfigured "<what>"` fails always.

SDLC_PROJECT_NAME="Project name"

# The team's workspace in this project (R-8.6). Everything the pod produces
# for this project lives here, never inside sipkai-pod/. adopt.sh creates it.
SDLC_WORKSPACE="delivery"
SDLC_BOARD="delivery/backlog/BACKLOG.md"
SDLC_STORIES_DIR="delivery/backlog/stories"
SDLC_RECORDS_DIR="delivery/backlog/change-records"
SDLC_DECISIONS_DIR="delivery/decisions"
SDLC_LESSONS_DIR="delivery/lessons-learned"
SDLC_REVIEWS_DIR="delivery/reviews"
SDLC_PROJECT_IMPROVEMENTS="delivery/IMPROVEMENTS.md"

# Files that must contain no unfinished markers (the two words check-doc-drift.sh looks for).
SDLC_TRUTH_FILES=(
  AGENTS.md
  sdlc.config.sh
  docs/PRODUCT.md
  docs/TESTS.md
)

project_static_analysis() { sdlc_none "no code yet; configure static analysis (formatters, linters, type checks) with the first story that needs it"; }
project_fast_tests() { sdlc_none "no code yet; configure fast tests (unit and architecture tests) with the first story that needs it"; }
project_build() { sdlc_none "no code yet; configure build with the first story that needs it"; }
project_full_tests() { sdlc_none "no code yet; configure full automated tests (integration) with the first story that needs it"; }
project_ui_tests() { sdlc_none "no code yet; configure UI journeys and accessibility checks with the first story that needs it"; }
project_deploy_checks() { sdlc_none "no code yet; configure deployment-bound checks with the first story that needs it"; }
project_drift_checks()    { sdlc_none "no doc-versus-code contracts yet"; }

# The project's own tools and versions; check-tools.sh runs this after its
# generic tools. Use `require <program> "<install hint>"`.
project_tool_checks()     { return 0; }

# Phrases of a route or tool the project has retired (for example a review
# route it no longer uses). check-record-drift.sh refuses them in the truth
# files, the stories and the board.
SDLC_RETIRED_PHRASES=()

# The independent reviewer (R-6.2): its endpoint (OpenAI-compatible chat
# completions), its model (the other family's top model) and where its key
# lives: a file outside the repository, or on macOS a Keychain item. The key
# itself is never written into the repository.
# SDLC_SECOND_OPINION_URL="https://api.openai.com/v1/chat/completions"
# SDLC_SECOND_OPINION_KEYCHAIN_ITEM="sipkai-openai-api"
# SDLC_SECOND_OPINION_KEY_FILE="$HOME/.config/<project>/second-opinion.key"
SECOND_OPINION_MODEL=""

# The integration branch stories merge into.
SDLC_MAIN_BRANCH="main"

# Folders the dependency scan skips besides node_modules, target, build, dist and vendor.
SDLC_DEPENDENCY_SKIP=()

# Change records finished before Sipk.ai POD 2.2 keep the older checks: list
# their ids here, separated by spaces. New records always get every check.
SDLC_LEGACY_RECORDS=""
