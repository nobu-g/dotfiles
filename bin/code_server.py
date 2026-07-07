#!/usr/bin/env python3

import argparse
import glob
import json
import os
import shutil
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import sys


def _is_wsl() -> bool:
    if os.environ.get("WSL_DISTRO_NAME"):
        return True
    try:
        with open("/proc/version") as f:
            return "microsoft" in f.read().lower()
    except OSError:
        return False


def _vscode_bin() -> str:
    """Resolve the `code` CLI of the local desktop's VS Code.

    The service manager (launchd/systemd) may start this server with a minimal
    PATH, so prefer well-known absolute locations before falling back to PATH.
    """
    override = os.environ.get("CODE_SERVER_VSCODE_BIN")
    if override:
        return override
    if sys.platform == "darwin":
        for path in ("/opt/homebrew/bin/code", "/usr/local/bin/code"):
            if os.path.exists(path):
                return path
    elif _is_wsl():
        # VS Code is installed on the Windows host; its `code` shim under
        # /mnt/c launches the Windows app and understands vscode-remote URIs.
        matches = sorted(
            glob.glob(
                "/mnt/c/Users/*/AppData/Local/Programs/"
                "Microsoft VS Code/bin/code"
            )
        )
        if matches:
            return matches[0]
    found = shutil.which("code")
    if found:
        return found
    raise FileNotFoundError("could not locate the VS Code `code` CLI")


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
                    _vscode_bin(),
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
            # The service manager (launchd/systemd) may start this server with a
            # minimal PATH (no ~/.local/bin), so resolve `notify` by absolute
            # path like the code binary above. deploy/main.sh points this at the
            # platform-specific backend (notify.darwin / notify.wsl).
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
