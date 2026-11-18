#!/usr/bin/env bash
# Password or PIN: the proxy must not serve the app without it.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
code="$(curl -sS -o /tmp/body -w '%{http_code}' "$BASE/" || true)"
echo "HTTP $code without credentials"
if grep -q 'netbird-expose test app' /tmp/body; then
  fail "the app was served without credentials"
fi
pass "the proxy asks for credentials first"
