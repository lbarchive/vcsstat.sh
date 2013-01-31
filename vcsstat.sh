#!/bin/bash
# Copyright (C) 2011, 2013 by Yu-Jie Lin
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

VCSSTAT_VERSION=0.1

FMT_DIR="%-30s"
FMT_OUT="\033[1;32m+ %5d\033[0m / \033[1;31m- %5d\033[0m\n"
NO_ZEROES=

usage() {
  cat <<EOF

$(basename "$0") [-C] [-Z] [''|AUTHOR_NAME [''|HG_DATESPEC [''|GIT_SINCE [''|GIT_UNTIL]]]]

Version $VCSSTAT_VERSION

Every argument is basically optional, however you need to use '' to indicate
that you are not specifying it.

Options:

  -C:       Do not color output
  -Z:       Filter out repo with no changes

HG_DATESPEC Examples
====================

  "2011-08"
  "2011-01 to 2011-03" # Jan. to Mar. in 2011
  ">2011-05"           # Since May.
  "-3"                 # Last three days

See hg manpage for DATE FORMATS section.

GIT_SINCE and GIT_UNTIL Examples
================================

  "2011-01-23"
  "yesterday"
  "2 weeks ago"

See..., uhm I have no idea where to look at. gitrevisions manpage for
date specification, perhaps?
EOF
}

parse_stat() {
  local ins=0 del=0
  read ins del <<< "$(grep 'files changed' |
  sed -e 's/[^0-9]/ /g' |
  awk -v NO_ZEROES=$NO_ZEROES "
    BEGIN {
      ins = 0;
      del = 0;
      }
    {
      ins += \$2;
      del += \$3;
    }
    END {
      printf(ins, del);
    }"
  )"
  if (( ins + del == 0 )) && [[ ! -z $NO_ZEROES ]]; then
    return
  fi
  printf "[%3s] $FMT_DIR $FMT_OUT" "$1" "$2" $ins $del
  : $(( total_ins += ins )) $(( total_del += del ))
}

while (( $# )); do
  case "$1" in
    -h|--help)
      usage
      exit
      ;;
    -C)
      FMT_OUT=${FMT_OUT//"\033["?";"??"m"/}
      FMT_OUT=${FMT_OUT//"\033["?"m"/}
      shift
      ;;
    -Z)
      NO_ZEROES=yes
      shift
      ;;
    *)
      break
      ;;
  esac
done

GIT_ARGS=()
HG_ARGS=()

if [[ ! -z "$1" ]]; then
  HG_ARGS=(  "${HG_ARGS[@]}" "--user"   "$1")
  GIT_ARGS=("${GIT_ARGS[@]}" "--author" "$1")
fi

[[ ! -z "$2" ]] && HG_ARGS=(  "${HG_ARGS[@]}" "--date"  "$2")
[[ ! -z "$3" ]] && GIT_ARGS=("${GIT_ARGS[@]}" "--since" "$3")
[[ ! -z "$4" ]] && GIT_ARGS=("${GIT_ARGS[@]}" "--until" "$4")

total_ins=0
total_del=0

for d in */ .; do
  [[ ! -d "$d" ]] && continue
  cd "$d"
  d=${d%\/}
  if [[ -d .hg ]]; then
    parse_stat  "Hg" "$d" < <(hg  log  "${HG_ARGS[@]}" --stat)
  elif [[ -d .git ]]; then
    parse_stat "Git" "$d" < <(git log "${GIT_ARGS[@]}" --shortstat --oneline)
  else
    :
  fi
  cd ..
done

if (( total_ins + total_del > 0 )) || [[ -z $NO_ZEROES ]]; then
  printf "TOTAL $FMT_DIR $FMT_OUT" '' $total_ins $total_del
fi
