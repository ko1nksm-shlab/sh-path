# path_dirname varname pathname
path_dirname() {
  set -- "$1" "${2:-}"
  [ ! "$2" ] && eval "$1=." && return
  set -- "$1" "${2%"${2##*[!/]}"}"
  [ ! "$2" ] && eval "$1=/" && return
  set -- "$1" "${2%/*}" "$2"
  [ "$2" = "$3" ] && eval "$1=." && return
  set -- "$1" "${2%"${2##*[!/]}"}"
  [ ! "$2" ] && eval "$1=/" && return
  eval "$1=\$2"
}

# path_basename varname pathname [suffix]
#   suffix: .*, .*.*, .**, .ext
path_basename() {
  set -- "$1" "${2%"${2##*[!/]}"}" "${3:-}"
  path_rootname "$1" "${2##*/}" "$3"
}

# path_extname varname pathname [suffix]
#   suffix: .*, .*.*, .**, .ext
path_extname() {
  set -- "$1" "${2%"${2##*[!/]}"}" "${3-".*"}"
  path_rootname "$1" "$2" "$3"
  eval "$1=\${2#\"\$$1\"}"
}

# path_rootname varname pathname [suffix]
#   suffix: .*, .*.*, .**, .ext
path_rootname() {
  set -- "$1" "${2%"${2##*[!/]}"}" "${3-".*"}"
  eval "$1=\$2"
  [ "$2" = "${2%/*}" ] || set -- "$1" "${2##*/}" "$3" "${2%/*}/"
  set -- "$1" "${2#${2%%[!.]*}}" "$3" "${4:-}${2%%[!.]*}"
  while [ "$3" ]; do
    case $3 in
      *'.*') set -- "$1" "${2%.*}" "${3%".*"}" "$4" && continue ;;
      *'.**') set -- "$1" "${2%%.*}" "${3%".**"}" "$4" && continue ;;
      *.[^.]*) set -- "$1" "${2%".${3##*.}"}" "${3%.*}" "$4" "$2" ;;
      *) set -- "$1" "${2%"$3"}"  ""  "$4" "$2"
    esac
    [ "$2" = "$5" ] && return 0
  done
  eval "$1=\$4\$2"
}

# path_normalize varname pathname [basedir]
path_normalize() {
  [ "${2%%/*}" ] && set -- "$1" "${3:-"$PWD"}/$2"
  [ "${2%%/*}" ] && set -- "$1" "$PWD/$2"
  set -- "$1" "$2/" ""

  while [ "$2" ]; do
    set -- "$1" "${2#*/}" "$3" "${2%%/*}"
    case $4 in
      '' | .) ;;
      ..) set -- "$1" "$2" "${3%/*}" ;;
      *) set -- "$1" "$2" "$3/$4" ;;
    esac
  done
  [ "$3" ] || set -- "$1" "$2" "$3/"
  eval "$1=\$3"
}

# path_relative varname pathname [basedir]
path_relative() {
  path_normalize "$1" "$2"
  eval "set -- \"\$1\" \"\$$1\" \"\${3:-}\""
  path_normalize "$1" "${3:-"$PWD"}"
  eval "set -- \"\$1\"  \"\$2\" \"\$$1\" ''"

  if [ "$2" = "$3" ]; then
    set -- "$1" ./
  else
    while [ "$3" ] && [ "$2" = "${2#"$3"}" ]; do
      set -- "$1" "$2" "${3%/*}" "../$4"
    done
    set -- "$1" "${4}${2#"$3/"}"
  fi
  case $2 in
    /* | ./* | ../*) eval "$1=\$2" ;;
    *) eval "$1=./\$2" ;;
  esac
}
