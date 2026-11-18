#!/usr/bin/env bash
# UDP: resolve a name from the DNS server through the proxy's UDP port.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
l4_host_port
command -v dig >/dev/null || { sudo apt-get update -qq && sudo apt-get install -y -qq dnsutils; }
answer="$(dig +short +time=3 +tries=3 @"$L4_HOST" -p "$L4_PORT" netbird-expose.test A 2>&1 || true)"
[ "$answer" = "192.0.2.10" ] || fail "unexpected DNS answer: '$answer'"
pass "DNS answered over UDP"
