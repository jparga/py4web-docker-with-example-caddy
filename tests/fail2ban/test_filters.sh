#!/usr/bin/env bash
# Check that each Fail2Ban filter extracts exactly the expected IPs from a real Caddy log.
# Comprueba que cada filtro de Fail2Ban extrae exactamente las IPs esperadas de un log real de Caddy.
#
# Usage / Uso: tests/fail2ban/test_filters.sh [fail2ban-regex command]
# Default runs fail2ban-regex inside the same image used in docker-compose.yml.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/../.."
F2B_IMAGE="crazymax/fail2ban:1.1.1"
if [[ $# -gt 0 ]]; then
    REGEX=("$@")
else
    REGEX=(docker run --rm -v "$PWD:/repo:ro" -w /repo --entrypoint fail2ban-regex "$F2B_IMAGE")
fi

LOG=tests/fail2ban/caddy-access.log
failures=0

check() {
    local filter=$1 expected=$2 actual
    actual=$("${REGEX[@]}" -o ip "$LOG" "fail2ban/filter.d/${filter}.conf" | sort | tr '\n' ' ' | sed 's/ $//')
    if [[ "$actual" == "$expected" ]]; then
        echo "ok   ${filter}: ${actual}"
    else
        echo "FAIL ${filter}: expected '${expected}', got '${actual}'"
        failures=$((failures + 1))
    fi
}

check caddy-py4web-auth "203.0.113.10 203.0.113.11"
check caddy-py4web-scan "2001:db8::12 203.0.113.12"

exit "$failures"
