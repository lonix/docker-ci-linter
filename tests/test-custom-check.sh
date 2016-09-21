#!/usr/bin/env bash
# Grant that custom checks are working.
set -eo pipefail

# shellcheck disable=SC1091
source ./run_lint.sh

# Lint the build script
echo "Linting the run_lint.sh script..."
check_bash ./run_lint.sh
