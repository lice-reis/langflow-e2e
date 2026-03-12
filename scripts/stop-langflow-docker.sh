#!/usr/bin/env bash
# Usage: ./scripts/stop-langflow-docker.sh
set -euo pipefail
CONTAINER_NAME="langflow-e2e-runner"
echo "Stopping Langflow container..."
docker rm -f "${CONTAINER_NAME}" 2>/dev/null && echo "Container stopped." || echo "No container to stop."
