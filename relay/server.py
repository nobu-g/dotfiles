#!/usr/bin/env python3
# /// script
# requires-python = ">=3.12,<3.13"
# dependencies = ["mcp>=2,<3", "uvicorn"]
# ///
"""Message relay for the Claude Code agent bridge.

One HTTP-transport MCP server that every agent machine registers with
`claude mcp add --transport http`. Holds one in-memory mailbox per agent name,
so this must run as a single process: a second worker would give each worker
its own set of mailboxes.

The transport is stateful because `Mcp-Session-Id` is the only thing that ties
a name to a caller across tool calls, and stateless mode never issues one.
"""

import argparse
import asyncio
import hmac
import os
import secrets
import socket
import time
from dataclasses import dataclass
from pathlib import Path

import uvicorn
from mcp.server.mcpserver import Context, MCPServer
from mcp.server.transport_security import TransportSecuritySettings
from mcp.types import ToolAnnotations

TOKEN_FILE = (
    Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    / "agent-bridge"
    / "token"
)


def load_or_create_token() -> str:
    """Read the relay token, generating it on the first start.

    Every agent machine keeps a copy in its `claude mcp add` registration, so
    regenerating it on each start would invalidate all of them at once.
    """
    if TOKEN_FILE.exists():
        return TOKEN_FILE.read_text().strip()
    TOKEN_FILE.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    token = secrets.token_urlsafe(32)
    # Create with 0600 rather than write-then-chmod: on a shared machine the
    # window between the two is long enough to read the token out.
    fd = os.open(TOKEN_FILE, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, "w") as handle:
        handle.write(token)
    return token


TOKEN = load_or_create_token()


@dataclass(frozen=True)
class Message:
    sender: str
    body: str


names: dict[str, str] = {}
mailboxes: dict[str, list[Message]] = {}


def authenticated_session(ctx: Context) -> str:
    headers = ctx.headers
    if "authorization" not in headers:
        raise ValueError("Authorization header is missing")
    if not hmac.compare_digest(headers["authorization"], f"Bearer {TOKEN}"):
        raise ValueError("invalid relay token")
    if "mcp-session-id" not in headers:
        raise ValueError("Mcp-Session-Id header is missing")
    return headers["mcp-session-id"]


def caller(ctx: Context) -> str:
    session = authenticated_session(ctx)
    if session not in names:
        raise ValueError("this session has no name yet; call `register` first")
    return names[session]


def format_messages(messages: list[Message]) -> str:
    """Render messages with the sender named by the relay, not by the sender."""
    return "\n\n".join(
        f"--- message from another agent, {message.sender} ---\n{message.body}"
        for message in messages
    )


INSTRUCTIONS = """\
A message relay between independent agent sessions.

To join the relay, call `register` first so other agents can see you.
"""

mcp = MCPServer(
    "agent-bridge",
    description="Message relay between independent agent sessions.",
    instructions=INSTRUCTIONS,
    version="1.0",
)


# An absent `destructive_hint` or `open_world_hint` means *true*, so only the
# hints that contradict those defaults are worth passing.
@mcp.tool(annotations=ToolAnnotations(destructive_hint=False, idempotent_hint=True))
async def register(name: str, ctx: Context) -> str:
    """Give this session a descriptive name that tells it apart from other agents.

    Unless the user asks for something else, use `<host-name>/<repo-name>`.
    Calling this again renames the session, and mail addressed to the old name
    stays behind unread.
    """
    session = authenticated_session(ctx)
    names[session] = name
    return f"registered as {name}"


@mcp.tool(annotations=ToolAnnotations(destructive_hint=False))
async def send(to: str, body: str, ctx: Context) -> str:
    """Leave a message in another agent's mailbox.

    Call `who` first if the name is unknown. Delivery does not interrupt the
    recipient: the message waits until that agent calls `recv`, which it may
    never do.
    """
    sender = caller(ctx)
    # Without this any string is a valid mailbox, so a typo comes back as a
    # success the sender cannot tell from a real delivery.
    if to not in set(names.values()):
        raise ValueError(f"no agent named {to}; call `who` for the list")
    mailboxes.setdefault(to, []).append(Message(sender=sender, body=body))
    return f"sent to {to}"


@mcp.tool()
async def recv(ctx: Context, timeout_seconds: int = 300) -> str:
    """Take everything waiting in this session's mailbox, blocking until it arrives.

    Nothing else can run in this session while waiting. Returns `(no messages)`
    if the mailbox is still empty when the timeout expires.
    """
    me = caller(ctx)
    deadline = time.monotonic() + timeout_seconds
    while time.monotonic() < deadline:
        if messages := mailboxes.pop(me, None):
            return format_messages(messages)
        await asyncio.sleep(2)
    return "(no messages)"


@mcp.tool(annotations=ToolAnnotations(read_only_hint=True))
async def who(ctx: Context) -> str:
    """List this session's own name and the other agents on the relay."""
    me = caller(ctx)
    others = sorted(set(names.values()) - {me})
    if not others:
        return f"you: {me}\n\nNo other agent has registered with the relay yet."
    return f"you: {me}\n\n" + "\n".join(others)


# The relay is bearer-authenticated and its only clients are Claude Code, never
# a browser, so the Host-header check would only break access by hostname.
app = mcp.streamable_http_app(
    stateless_http=False,
    transport_security=TransportSecuritySettings(enable_dns_rebinding_protection=False),
)


def registration_command(host: str, port: int) -> str:
    reachable_host = socket.getfqdn() if host in {"0.0.0.0", "::"} else host
    return (
        f"claude mcp add --transport http agent-bridge -s local \\\n"
        f"  http://{reachable_host}:{port}/mcp \\\n"
        f'  -H "Authorization: Bearer {TOKEN}"'
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8787)
    args = parser.parse_args()
    banner = (
        f"token file: {TOKEN_FILE}\n\n"
        "To add an agent, run this in the project that needs it:\n\n"
        f"{registration_command(args.host, args.port)}\n"
    )
    # stdout is block-buffered when redirected, which would hold the banner back
    # until the relay exits.
    print(banner, flush=True)
    uvicorn.run(app, host=args.host, port=args.port)


if __name__ == "__main__":
    main()
