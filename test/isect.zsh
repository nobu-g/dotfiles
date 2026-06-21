#!/usr/bin/env zsh

setopt errexit nounset pipefail

repo_root=${0:A:h:h}
fpath=("$repo_root/.zsh.d/.zfunc" $fpath)
autoload -Uz isect

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/isect-test.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT

file1="$tmpdir/file 1"
file2="$tmpdir/file 2"

print -l banana apple banana apple cherry >"$file1"
print -l date apple banana apple banana >"$file2"

expected=$'banana\napple'
actual=$(isect "$file1" "$file2")
[[ $actual == $expected ]] || {
  print -u2 "file input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

actual=$(isect "$file2" <"$file1")
[[ $actual == $expected ]] || {
  print -u2 "standard input: expected ${(qqq)expected}, got ${(qqq)actual}"
  exit 1
}

print -l repeated repeated >"$file1"
print -l other >"$file2"
actual=$(isect "$file1" "$file2")
[[ -z $actual ]] || {
  print -u2 "duplicates in one file: expected empty output, got ${(qqq)actual}"
  exit 1
}

if isect "$tmpdir/missing" "$file2" >/dev/null 2>&1; then
  print -u2 'missing input file: expected failure'
  exit 1
fi

if isect >/dev/null 2>&1; then
  print -u2 'missing arguments: expected failure'
  exit 1
else
  exit_status=$?
  [[ $exit_status -eq 2 ]] || {
    print -u2 "missing arguments: expected status 2, got $exit_status"
    exit 1
  }
fi

if isect "$file1" "$file2" extra >/dev/null 2>&1; then
  print -u2 'too many arguments: expected failure'
  exit 1
else
  exit_status=$?
  [[ $exit_status -eq 2 ]] || {
    print -u2 "too many arguments: expected status 2, got $exit_status"
    exit 1
  }
fi

print 'isect tests passed'
