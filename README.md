# sh-path

I found code I wrote for bash in the past, modified it for the POSIX shell, and added some miscellaneous tests. (Still) experimental implementation. May need more testing.

## Functions

See also [example.sh](example.sh)

### path_dirname

```txt
Usage: path_dirname varname pathname
    varname: variable name
    pathname: path name
```

```sh
path_dirname ret "/var/tmp/file.txt"
echo "$ret" # => /var/tmp
```

### path_basename

```txt
Usage: path_basename varname pathname [suffix]
    varname: variable name
    pathname: path name
    suffix: .*, .*.*, .**, .ext (default: NULL)
```

```sh
path_basename ret "/var/tmp/file.txt"
echo "$ret" # => file.txt
```

### path_extname

```txt
Usage: path_extname varname pathname [suffix]
    varname: variable name
    pathname: path name
    suffix: .*, .*.*, .**, .ext (default: .*)
```

```sh
path_extname ret "/var/tmp/file.txt"
echo "$ret" # => .txt
```

suffix examples

```sh
path_extname ret "/var/tmp/file.tar.gz" .gz
echo "$ret" # => .gz

path_extname ret "/var/tmp/file.tar.gz" .tar.gz
echo "$ret" # => .tar.gz

path_extname ret "/var/tmp/file.tar.gz" ".*.*"
echo "$ret" # => .tar.gz

path_extname ret "/var/tmp/file.tar.gz" ".**"
echo "$ret" # => .tar.gz
```

### path_rootname

```txt
Usage: path_rootname varname pathname [suffix]
    varname: variable name
    pathname: path name
    suffix: .*, .*.*, .**, .ext (default: .*)
```

```sh
path_rootname ret "/var/tmp/file.txt"
echo "$ret" # => /var/tmp/file
```

### path_normalize

```txt
Usage: path_normalize varname pathname [basedir]
    varname: variable name
    pathname: path name
    basedir: base directory (default: PWD)
```

```sh
path_normalize ret "/var///tmp/.././file.txt"
echo "$ret" # => /var/file.txt
```

### path_relative

```txt
Usage: path_relative varname pathname [basedir]
    varname: variable name
    pathname: path name
    basedir: base directory (default: PWD)
```

```sh
path_relative ret "/var/tmp/file.txt" /var/
echo "$ret" # => ./tmp/file.txt
```