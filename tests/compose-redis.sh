#!/usr/bin/env bash
# Compose with two services: the web app reaches redis (configured via app-env).
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
[ "$(curl -fsS "$BASE/health")" = "ok" ] || fail "/health did not return ok"
first="$(curl -fsS "$BASE/")"
second="$(curl -fsS "$BASE/")"
[ "$second" -eq $(( first + 1 )) ] || fail "visit counter did not increase ($first -> $second)"
pass "web app and redis work together ($first -> $second)"
