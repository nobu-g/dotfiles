#!/bin/bash
# curl wrapper for HOMEBREW_CURL_PATH: rewrites the unreliable ftpmirror.gnu.org
# redirector (some formulae list no fallback mirror) to the canonical ftp.gnu.org,
# which serves the same paths. Formula sha256 checks still verify what is fetched.
# Must exec the system curl by absolute path: a bare `curl` resolves to Homebrew's
# shim, which execs HOMEBREW_CURL_PATH (this script) again in an infinite loop.
args=()
for a in "$@"; do
  args+=("${a/#https:\/\/ftpmirror.gnu.org\//https://ftp.gnu.org/}")
done
exec /usr/bin/curl "${args[@]}"
