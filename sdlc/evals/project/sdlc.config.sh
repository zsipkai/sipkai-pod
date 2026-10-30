# The throwaway project the process evaluations run in when the pod runs
# them on its own, outside any project (its CI, SI-186).
SDLC_PROJECT_NAME="Evaluation project"
SDLC_STORIES_DIR="backlog/stories"
SDLC_RECORDS_DIR="backlog/change-records"
SDLC_BOARD="backlog/BACKLOG.md"
SDLC_TRUTH_FILES=()
project_drift_checks() { echo "PASS  no project drift checks in the evaluation project"; }
SECOND_OPINION_MODEL="evaluation-model"   # never called: the evaluations stand in for the API
