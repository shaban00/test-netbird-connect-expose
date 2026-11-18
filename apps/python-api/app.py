"""A small JSON API using only the standard library."""
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body, ctype="application/json"):
        data = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/health":
            self._send(200, b"ok\n", "text/plain")
        elif self.path == "/env":
            self._send(200, {"greeting": os.environ.get("GREETING", "")})
        elif self.path == "/headers":
            self._send(200, {k.lower(): v for k, v in self.headers.items()})
        else:
            self._send(200, {"app": "python-api"})

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        self._send(200, self.rfile.read(length), "application/octet-stream")


ThreadingHTTPServer(("0.0.0.0", 5000), Handler).serve_forever()
