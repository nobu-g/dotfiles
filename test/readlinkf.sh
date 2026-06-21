#!/bin/sh

set -eu

repo_root=$(CDPATH='' cd -P "$(dirname "$0")/.." && pwd)
readlinkf="$repo_root/bin/readlinkf"

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/readlinkf-test.XXXXXX")
tmpdir=$(CDPATH='' cd -P "$tmpdir" && pwd)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

mkdir -p "$tmpdir/dir with spaces/subdir"
: >"$tmpdir/dir with spaces/target"
ln -s target "$tmpdir/dir with spaces/relative-link"
ln -s "$tmpdir/dir with spaces/target" "$tmpdir/absolute-link"
ln -s relative-link "$tmpdir/dir with spaces/multihop-link"
ln -s cycle-b "$tmpdir/cycle-a"
ln -s cycle-a "$tmpdir/cycle-b"

assert_path() {
  description=$1
  expected=$2
  input=$3
  actual=$(
    cd "$tmpdir"
    "$readlinkf" "$input"
  )
  if [ "$actual" != "$expected" ]; then
    printf >&2 '%s: expected "%s", got "%s"\n' "$description" "$expected" "$actual"
    exit 1
  fi
}

assert_path 'regular file' "$tmpdir/dir with spaces/target" 'dir with spaces/target'
assert_path 'directory' "$tmpdir/dir with spaces/subdir" 'dir with spaces/subdir/'
assert_path 'relative symbolic link' "$tmpdir/dir with spaces/target" 'dir with spaces/relative-link'
assert_path 'absolute symbolic link' "$tmpdir/dir with spaces/target" 'absolute-link'
assert_path 'multiple symbolic links' "$tmpdir/dir with spaces/target" 'dir with spaces/multihop-link'

if "$readlinkf" >/dev/null 2>&1; then
  printf >&2 'missing argument: expected failure\n'
  exit 1
fi

if "$readlinkf" "$tmpdir/cycle-a" >/dev/null 2>&1; then
  printf >&2 'symbolic link cycle: expected failure\n'
  exit 1
fi

printf '%s\n' 'readlinkf tests passed'
