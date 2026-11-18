#!/usr/bin/env bash
# HTTPS backend: the proxy talks TLS to an app with a self-signed certificate.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
[ "$(curl -fsS "$BASE/")" = "https backend" ] || fail "unexpected response from the https backend"
pass "the proxy reached the TLS backend"
