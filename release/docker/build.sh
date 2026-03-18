#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

docker build --compress -f "${SCRIPT_DIR}/Dockerfile" -t purbon/kafka-topology-builder "${REPO_ROOT}"
