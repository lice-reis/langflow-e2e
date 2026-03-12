#!/usr/bin/env bash
PID_FILE="/tmp/langflow-e2e.pid"
if [ -f "${PID_FILE}" ]; then
  kill "$(cat ${PID_FILE})" 2>/dev/null && echo "Langflow stopped." || echo "Process already gone."
  rm -f "${PID_FILE}"
else
  echo "No PID file found."
fi
