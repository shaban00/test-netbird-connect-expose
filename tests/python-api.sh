#!/usr/bin/env bash
# JSON API: app-env reached the app, request bodies pass intact, proxy headers.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
greeting="$(curl -fsS "$BASE/env" | jq -r .greeting)"
[ "$greeting" = "${EXPECTED_GREETING:?}" ] || fail "app-env not applied (greeting='$greeting')"
pass "app-env reached the app"
head -c 1048576 /dev/urandom > /tmp/body.bin
sent="$(sha256sum < /tmp/body.bin | cut -d' ' -f1)"
got="$(curl -fsS --data-binary @/tmp/body.bin -H 'Content-Type: application/octet-stream' "$BASE/echo" | sha256sum | cut -d' ' -f1)"
[ "$sent" = "$got" ] || fail "1 MB POST body changed on the way"
pass "1 MB POST body intact"
headers="$(curl -fsS "$BASE/headers")"
echo "$headers" | jq 'with_entries(select(.key | test("^(host|x-forwarded-.*|x-real-ip|forwarded)$")))'
if echo "$headers" | jq -e 'has("x-forwarded-for")' >/dev/null; then
  pass "proxy sets X-Forwarded-For"
else
  echo "::warning::The proxy did not set X-Forwarded-For"
fi
