#!/bin/sh

set -eu

. ./path.sh

assert() {
  expect=$1 func="$2"
  shift 2
  "path_$func" ret "$@"
  if [ "$expect" = "$ret" ]; then
    printf '\033[32m[OK]\033[m %s \033[35m=>\033[m %s\n' "$*" "$expect"
  else
    printf '\033[31m[NG]\033[m %s \033[35m=>\033[m %s\n' "$*" "$expect != $ret"
  fi
}

test_dirname() {
  assert "." dirname ""
  assert "." dirname "."
  assert "/" dirname "/"
  assert "." dirname ".."
  assert "." dirname "foo/"
  assert "/foo" dirname "/foo/bar"
  assert "///foo" dirname "///foo///bar"
  assert "/" dirname "///foo///"
  assert "///foo///bar" dirname "///foo///bar///baz///"
}

test_basename() {
  assert "file.tar.gz" basename /data/file.tar.gz
  assert "file.tar.gz" basename /data/file.tar.gz///
  assert "file" basename /data/file.tar.gz .tar.gz
  assert "file" basename /data/file.tar.gz ".tar.*"
  assert "file" basename /data/file.tar.gz ".**"
  assert "file" basename /data/file.tar.gz/// .tar.gz
  assert ".." basename ..
  assert "usr" basename /usr/
}

test_rootname() {
  assert "/data/file.tar" rootname /data/file.tar.gz
  assert "/data.dir/file.tar" rootname /data.dir/file.tar.gz
  assert "/data.dir/file.tar" rootname /data.dir/file.tar.gz///
  assert "/data.dir/file" rootname /data.dir/file.tar.gz ".**"
  assert "/data/file" rootname /data/file
  assert ".." rootname ..
  assert "/data/.bashrc" rootname /data/.bashrc
}

test_extname() {
  assert ".tar.gz" extname /data/file.tar.gz ".**"
  assert ".tar.gz" extname /data/file.tar.gz/// ".**"
  assert "" extname .
  assert "" extname ..
  assert "" extname /
  assert "" extname file/.
  assert "" extname file/..
  assert "" extname file/...
  assert "" extname /usr/
  assert "" extname /usr/lib
  assert "." extname /usr/file.
  assert "." extname /usr/file..
  assert "" extname /usr/.bashrc
  assert ".gz" extname /usr/.bashrc.gz
}

test_normalize() {
  assert "/tmp/test/b" normalize "test///a/../b///" "/tmp"
  assert "/test/b" normalize "/test///a/../b///" "/tmp"
  assert "/bar" normalize "/foo/../../../bar" "/tmp"
  assert "/baz" normalize "/foo/../bar/../baz" "/tmp"
}

test_relative() {
  assert "./test/b" relative "/tmp/path/test/b" "/tmp/path"
  assert "./--test/b" relative "/tmp/path/--test/b" "/tmp/path"
  assert "../../tmp/dir/a" relative "/tmp/dir/a" "/var/tmp"
  assert "./" relative / "/"
}

if [ $# -eq 0 ]; then
  set -- dirname basename extname rootname normalize relative
fi

for i in "$@"; do
  case $i in
    dirname|basename|extname|rootname|normalize|relative) ;;
    *) echo "unknown: $i" && exit 1 ;;
  esac
  echo "=== $i ==="
  "test_$i"
  echo
done
