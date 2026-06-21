#!/usr/bin/env zsh

setopt errexit nounset pipefail

repo_root=${0:A:h:h}
fpath=("$repo_root/.zsh.d/.zfunc" $fpath)
autoload -Uz union

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/union-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT

file1="$tmpdir/file 1"
file2="$tmpdir/file 2"

print -l banana apple banana >"$file1"
print -l date apple cherry >"$file2"

expected=$'banana\napple\ndate\ncherry'
actual=$(union "$file1" "$file2")
[[ $actual == $expected ]] || {
  print -u2 "file input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

expected=$'banana\napple\ndate\ncherry'
actual=$(print -l banana apple banana | union "$file2")
[[ $actual == $expected ]] || {
  print -u2 "standard input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

if union "$tmpdir/missing" >/dev/null 2>&1; then
  print -u2 'missing input file: expected failure'
  exit 1
fi

print 'union tests passed'
