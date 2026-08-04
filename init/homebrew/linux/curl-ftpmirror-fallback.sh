#!/bin/bash
# curl wrapper for HOMEBREW_CURL_PATH: reroutes broken download hosts to ftp.gnu.org,
# which serves the same content (formula sha256 checks still verify what is fetched):
#  - ftpmirror.gnu.org: unreliable redirector, and some formulae list no fallback mirror
#  - invisible-mirror.net/archives/ncurses: serves corrupted ncurses tarballs
# Must exec the system curl by absolute path: a bare `curl` resolves to Homebrew's
# shim, which execs HOMEBREW_CURL_PATH (this script) again in an infinite loop.
args=()
for a in "$@"; do
  a="${a/#https:\/\/ftpmirror.gnu.org\//https://ftp.gnu.org/}"
  a="${a/#https:\/\/invisible-mirror.net\/archives\/ncurses\//https://ftp.gnu.org/gnu/ncurses/}"
  a="${a/#http:\/\/invisible-mirror.net\/archives\/ncurses\//https://ftp.gnu.org/gnu/ncurses/}"
  args+=("$a")
done
exec /usr/bin/curl "${args[@]}"
