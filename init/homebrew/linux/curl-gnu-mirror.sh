#!/bin/bash
# curl wrapper for HOMEBREW_CURL_PATH: reroutes GNU download hosts to the kernel.org
# mirror, which serves the same tree far more reliably (ftpmirror.gnu.org and
# ftp.gnu.org have multi-hour outages that turn every GNU tarball into an endless
# retry loop, and invisible-mirror.net serves corrupted ncurses tarballs; some
# formulae list no usable fallback mirror). Formula sha256 checks still verify
# whatever is fetched.
# Must exec the system curl by absolute path: a bare `curl` resolves to Homebrew's
# shim, which execs HOMEBREW_CURL_PATH (this script) again in an infinite loop.
args=()
for a in "$@"; do
  a="${a/#https:\/\/ftpmirror.gnu.org\//https://mirrors.kernel.org/}"
  a="${a/#https:\/\/ftp.gnu.org\//https://mirrors.kernel.org/}"
  a="${a/#http:\/\/ftp.gnu.org\//https://mirrors.kernel.org/}"
  a="${a/#https:\/\/invisible-mirror.net\/archives\/ncurses\//https://mirrors.kernel.org/gnu/ncurses/}"
  a="${a/#http:\/\/invisible-mirror.net\/archives\/ncurses\//https://mirrors.kernel.org/gnu/ncurses/}"
  args+=("$a")
done
exec /usr/bin/curl "${args[@]}"
