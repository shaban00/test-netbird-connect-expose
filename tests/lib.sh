# shellcheck shell=bash
# Variables set here are used by the scripts that source this file.
# shellcheck disable=SC2034
# Shared helpers for the test scripts. URL is the exposed service's URL.
set -euo pipefail
: "${URL:?URL is required}"
BASE="${URL%/}"

pass() { echo "PASS: $*"; }
fail() { echo "::error::$*"; exit 1; }

# host and port from an L4 URL such as tcp://name.example.com:16379
l4_host_port() {
  local hp="${URL#*://}"
  hp="${hp%%/*}"
  L4_HOST="${hp%:*}"
  L4_PORT="${hp##*:}"
  [[ "$L4_PORT" =~ ^[0-9]+$ ]] || fail "no port in the service URL"
}
