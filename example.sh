#!/bin/sh

set -eu

. ./path.sh

# path_dirname var pathname

path_dirname ret "/var/tmp/file.txt"
echo "$ret" # => /var/tmp

# path_basename varname pathname [suffix]

path_basename ret "/var/tmp/file.txt"
echo "$ret" # => file.txt

# path_extname varname pathname [suffix]

path_extname ret "/var/tmp/file.txt"
echo "$ret" # => .txt

# path_rootname varname pathname [suffix]

path_rootname ret "/var/tmp/file.txt"
echo "$ret" # => /var/tmp/file

# path_normalize varname pathname [basedir]

path_normalize ret "/var///tmp/.././file.txt"
echo "$ret" # => /var/file.txt

# path_relative varname pathname [basedir]

path_relative ret "/var/tmp/file.txt" /var/
echo "$ret" # => ./tmp/file.txt

# suffix examples

path_extname ret "/var/tmp/file.tar.gz" .gz
echo "$ret" # => .gz

path_extname ret "/var/tmp/file.tar.gz" .tar.gz
echo "$ret" # => .tar.gz

path_extname ret "/var/tmp/file.tar.gz" ".*.*"
echo "$ret" # => .tar.gz

path_extname ret "/var/tmp/file.tar.gz" ".**"
echo "$ret" # => .tar.gz
