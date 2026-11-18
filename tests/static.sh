#!/usr/bin/env bash
# Static site: health, page content, and a 20 MB download arriving intact.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
[ "$(curl -fsS "$BASE/health")" = "ok" ] || fail "/health did not return ok"
pass "health"
grep -q 'netbird-expose test app' <<< "$(curl -fsS "$BASE/")" || fail "page content missing"
pass "page content"
expected="$(curl -fsS "$BASE/big.bin.sha256")"
actual="$(curl -fsS "$BASE/big.bin" | sha256sum | cut -d' ' -f1)"
[ "$expected" = "$actual" ] || fail "20 MB download is corrupted ($actual != $expected)"
pass "20 MB download intact"
