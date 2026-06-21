#!/usr/bin/env zsh

setopt errexit nounset pipefail

repo_root=${0:A:h:h}
fpath=("$repo_root/.zsh.d/.zfunc" $fpath)
autoload -Uz difference

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/difference-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT

file1="$tmpdir/file 1"
file2="$tmpdir/file 2"

print -l cherry apple banana >"$file1"
print -l banana date >"$file2"

expected=$'apple\ncherry'
actual=$(difference "$file1" "$file2")
[[ $actual == $expected ]] || {
  print -u2 "file input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

actual=$(print -l cherry apple banana | difference "$file2")
[[ $actual == $expected ]] || {
  print -u2 "standard input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

if difference "$tmpdir/missing" "$file2" >/dev/null 2>&1; then
  print -u2 'missing input file: expected failure'
  exit 1
fi

print 'difference tests passed'
