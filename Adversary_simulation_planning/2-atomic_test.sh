#!/usr/bin/env bash
#
# 2-atomic_simulation.sh
#
# Atomic simulation of a MITRE ATT&CK Discovery technique for use in an
# isolated, controlled lab environment only.
#
# Technique:  T1087.001 - Account Discovery: Local Account
# Tactic:     Discovery
#
# Safety controls:
#   - Refuses to run if stop_test.flag exists in the current directory
#   - Deterministic, read-only commands (no system state is changed)
#   - All output is logged to atomic_results.txt and atomic_log.txt
#
set -euo pipefail

readonly TECHNIQUE_ID="T1087.001"
readonly TECHNIQUE_NAME="Local Account Discovery"
readonly STOP_FLAG="stop_test.flag"
readonly RESULTS_FILE="atomic_results.txt"
readonly LOG_FILE="atomic_log.txt"

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Safety check: abort immediately if the stop flag is present.
if [[ -f "${STOP_FLAG}" ]]; then
    echo "${STOP_FLAG} detected. Aborting simulation."
    echo "Remove the flag file to allow execution."
    exit 1
fi

echo "MITRE ATT&CK Technique: ${TECHNIQUE_ID} - ${TECHNIQUE_NAME}"

start_time="$(timestamp)"
echo "Start time: ${start_time}"
echo "[${start_time}] START - ${TECHNIQUE_ID} - ${TECHNIQUE_NAME}" >> "${LOG_FILE}"

echo "Running simulation..."

{
    echo "MITRE ATT&CK Technique: ${TECHNIQUE_ID} - ${TECHNIQUE_NAME}"
    echo "Generated: ${start_time}"
    echo "---"
    echo "## Local user accounts (/etc/passwd)"
    cat /etc/passwd
    echo "---"
    echo "## Currently logged-in users"
    who 2>/dev/null || echo "who: no users currently logged in or command unavailable"
    echo "---"
    echo "## Current user identity"
    id
} > "${RESULTS_FILE}"

echo "Output saved to ${RESULTS_FILE}"

end_time="$(timestamp)"
echo "End time: ${end_time}"
echo "[${end_time}] END   - ${TECHNIQUE_ID} - ${TECHNIQUE_NAME}" >> "${LOG_FILE}"

echo "Simulation complete. Review ${LOG_FILE} for details."
