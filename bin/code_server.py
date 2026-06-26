#!/usr/bin/env python3

import argparse
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import sys


class MyHandler(BaseHTTPRequestHandler):
    def do_POST(self) -> None:

        content_len = int(self.headers["content-length"])
        body = json.loads(self.rfile.read(content_len).decode("utf-8"))
        self.log_message("%s", body)

        if self.path == "/code":
            self._run_vscode(body)
            self.send_response(200)
        elif self.path == "/notify":
            self._run_notify(body)
            self.send_response(200)
        else:
            self.send_response(404)

        self.end_headers()

    def _run_vscode(self, body):
        remote_host = body["host"]
        remote_path = body["path"]
        try:
            env = os.environ.copy()
            env["VSCODE_WSL_DEBUG_INFO"] = "true"
            print(env, file=sys.stderr)
            subprocess.run(
                [
                    "/opt/homebrew/bin/code",
                    "--folder-uri",
                    f"vscode-remote://ssh-remote+{remote_host}{remote_path}",
                ],
                check=True,
                env=env,
            )
        except subprocess.CalledProcessError as e:
            print(e.stderr, file=sys.stderr)
            self.log_error("%s", e.stderr)
            raise e

    def _run_notify(self, body):
        title: str = body["title"]
        subtitle: str = body["subtitle"]
        content: str = body["body"]
        try:
            env = os.environ.copy()
            # launchd starts this server with a minimal PATH (no ~/.local/bin),
            # so resolve `notify` by absolute path like the code binary above.
            notify = os.path.expanduser("~/.local/bin/notify")
            subprocess.run(
                [
                    notify,
                    "-t",
                    title,
                    "-s",
                    subtitle,
                    content,
                ],
                check=True,
                env=env,
            )
        except subprocess.CalledProcessError as e:
            print(e.stderr, file=sys.stderr)
            self.log_error("%s", e.stderr)
            raise e


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", "-H", default="localhost")
    parser.add_argument("--port", "-P", type=int, default=8080)
    args = parser.parse_args()

    server = HTTPServer((args.host, args.port), MyHandler)
    server.serve_forever()
    # env = os.environ.copy()
    # env["VSCODE_WSL_DEBUG_INFO"] = "true"
    # from pathlib import Path
    # Path("/home/ueda/code_server.log").write_text(json.dumps(env))
    # print(env)


if __name__ == "__main__":
    main()
