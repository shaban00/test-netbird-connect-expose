#!/usr/bin/env bash
# TCP: send a Redis PING through the proxy's TCP port.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
l4_host_port
# host and port are passed as arguments, not expanded in the single quotes
# shellcheck disable=SC2016
reply="$(timeout 10 bash -c 'exec 3<>"/dev/tcp/$1/$2"; printf "PING\r\n" >&3; head -c 7 <&3' _ "$L4_HOST" "$L4_PORT" 2>/dev/null | tr -d '\r\n' || true)"
[ "$reply" = "+PONG" ] || fail "no PONG from redis (got '$reply')"
pass "Redis answered PING over TCP"
