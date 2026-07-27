#!/usr/bin/env python3

from __future__ import annotations

import argparse
import glob
import hmac
import json
import os
from pathlib import Path
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
    override = os.environ.get("DESKTOP_BRIDGE_VSCODE_BIN")
    if override:
        return override
    if sys.platform == "darwin":
        for path in ("/opt/homebrew/bin/code", "/usr/local/bin/code"):
            if os.path.exists(path):
                return path
    elif _is_wsl():
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


def _token_file() -> Path:
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    return config_home / "desktop-bridge" / "token"


def _load_token() -> str:
    token = os.environ.get("DESKTOP_BRIDGE_TOKEN")
    if token:
        return token
    path = _token_file()
    if path.is_file():
        return path.read_text().strip()
    return ""


class MyHandler(BaseHTTPRequestHandler):
    bridge_token = ""

    def do_POST(self) -> None:
        if not self._authenticated():
            return

        try:
            content_len = int(self.headers.get("content-length", "0"))
            body = json.loads(self.rfile.read(content_len).decode("utf-8"))
            self.log_message("%s", body)

            if self.path == "/code":
                self._run_vscode(body)
            elif self.path == "/notify":
                self._run_notify(body)
            else:
                self.send_error(404)
                return

            self.send_response(200)
            self.end_headers()
        except (json.JSONDecodeError, KeyError, ValueError) as e:
            self.send_error(400, str(e))
        except subprocess.CalledProcessError as e:
            message = e.stderr.strip() if e.stderr else str(e)
            self.log_error("%s", message)
            self.send_error(500, message)
        except FileNotFoundError as e:
            self.log_error("%s", e)
            self.send_error(500, str(e))

    def _authenticated(self) -> bool:
        token = self.headers.get("X-Desktop-Bridge-Token", "")
        if hmac.compare_digest(token, self.bridge_token):
            return True
        self.send_error(403 if token else 401)
        return False

    @staticmethod
    def _run(argv: list[str], env: dict[str, str] | None = None) -> None:
        subprocess.run(argv, check=True, capture_output=True, text=True, env=env)

    def _run_vscode(self, body):
        remote_host = body["host"]
        remote_path = body["path"]
        env = os.environ.copy()
        env["VSCODE_WSL_DEBUG_INFO"] = "true"
        self._run(
            [
                _vscode_bin(),
                "--folder-uri",
                f"vscode-remote://ssh-remote+{remote_host}{remote_path}",
            ],
            env=env,
        )

    def _run_notify(self, body):
        title: str = body["title"]
        subtitle: str = body["subtitle"]
        content: str = body["body"]
        notify = Path.home() / ".local" / "bin" / "notify"
        self._run([str(notify), "-t", title, "-s", subtitle, content])


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", "-H", default="localhost")
    parser.add_argument("--port", "-P", type=int, default=8080)
    args = parser.parse_args()

    MyHandler.bridge_token = _load_token()
    if not MyHandler.bridge_token:
        parser.error(
            "DESKTOP_BRIDGE_TOKEN or ~/.config/desktop-bridge/token is required"
        )

    server = HTTPServer((args.host, args.port), MyHandler)
    server.serve_forever()
    # env = os.environ.copy()
    # env["VSCODE_WSL_DEBUG_INFO"] = "true"
    # from pathlib import Path
    # Path("/home/ueda/desktop_bridge.log").write_text(json.dumps(env))
    # print(env)


if __name__ == "__main__":
    main()
