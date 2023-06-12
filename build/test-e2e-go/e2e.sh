#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#
# golang e2e test launcher. Do not run directly, this is intended to be executed by the prow job inside a container.

set -eo pipefail

set +e

echo "Starting e2e tests"
start_time=$(date +%s)
go test ./e2e/... --p 1 --e2e --test.v "$@" | tee test_results.txt
exit_code=$?
end_time=$(date +%s)
echo "Tests took $(( end_time - start_time )) seconds"

# Save test results to ARTIFACTS directory. The ARTIFACTS env var is set by prow.
# The containerized entry points mount the ARTIFACTS directory to a path inside
# the container, and pass the mounted path as ARTIFACTS. Using the env var directly
# enables running this script more flexibly, e.g. without docker in docker.
if [[ -n "${ARTIFACTS}" && -d "${ARTIFACTS}" ]]; then
  echo "Creating junit xml report"
  cat test_results.txt | go-junit-report --subtest-mode=exclude-parents > "${ARTIFACTS}/junit_report.xml"
  if [ "$exit_code" -eq 0 ]; then
    junit-report reset-failure --path="${ARTIFACTS}/junit_report.xml"
  fi
fi

exit $exit_code
