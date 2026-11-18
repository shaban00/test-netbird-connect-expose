import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import redis

db = redis.Redis(host=os.environ["REDIS_HOST"], port=6379)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            db.ping()
            body = b"ok\n"
        else:
            body = f"{db.incr('visits')}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


ThreadingHTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
