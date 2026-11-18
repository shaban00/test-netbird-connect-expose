import os
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

delay = int(os.environ.get("START_DELAY", "30"))
print(f"starting in {delay}s", flush=True)
time.sleep(delay)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = b"ok\n" if self.path == "/health" else b"slow-start app\n"
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


print("listening on 8000", flush=True)
ThreadingHTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
