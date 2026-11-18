#!/usr/bin/env bash
# Slow start: the action waited for the app instead of failing early.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
[ "$(curl -fsS "$BASE/health")" = "ok" ] || fail "/health did not return ok"
pass "the response check waited for the slow app"
