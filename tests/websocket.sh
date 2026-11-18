#!/usr/bin/env bash
# WebSocket: upgrade through the proxy and get a message echoed back.
# shellcheck source=tests/lib.sh
. "$(dirname "$0")/lib.sh"
# A virtual environment, because the system Python refuses pip installs (PEP 668).
VENV="${RUNNER_TEMP:-/tmp}/ws-venv"
python3 -m venv "$VENV"
"$VENV/bin/pip" install --quiet --disable-pip-version-check websockets==15.0.1
WS_URL="${WS_URL:-wss://${BASE#https://}/}" "$VENV/bin/python" - <<'PY'
import asyncio, os, websockets

async def main():
    async with websockets.connect(os.environ["WS_URL"], open_timeout=20) as ws:
        await ws.send("hello-through-netbird")
        for _ in range(5):  # the server greets first, then echoes
            msg = await asyncio.wait_for(ws.recv(), 10)
            if msg == "hello-through-netbird":
                return
    raise SystemExit("no echo received")

asyncio.run(main())
PY
pass "WebSocket message echoed through the proxy"
