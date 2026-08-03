#!/bin/bash
# curl wrapper for Homebrew (HOMEBREW_CURL_PATH). Rewrites source-download URLs that
# point at GNU's mirror redirector, which has multi-day outages (502/timeouts), to the
# canonical ftp.gnu.org host that serves the same paths. Some formulae (e.g. wget,
# bash's patch files) list no fallback mirror, so a redirector outage otherwise makes
# them impossible to install. Formula sha256 checks still verify whatever is fetched.
#
# Must exec the system curl by absolute path: a bare `curl` resolves to Homebrew's
# shim, which execs HOMEBREW_CURL_PATH (this script) again in an infinite loop.
args=()
for a in "$@"; do
  args+=("${a/#https:\/\/ftpmirror.gnu.org\//https://ftp.gnu.org/}")
done
exec /usr/bin/curl "${args[@]}"
