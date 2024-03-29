#!/bin/bash
# Copyright (C) 2011, 2013, 2014 by Yu-Jie Lin
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

VCSSTAT_VERSION=0.6.1

FMT_DIR="%-30s"
FMT_OUT="\e[1;32m+ %5d\e[0m / \e[1;31m- %5d\e[0m / \e[1;33mC %5d\e[0m\n"

CC_LEGEND=(
  "░" "▒" "▓" "█"
  "\e[33;1m░\e[0m" "\e[33;1m▒\e[0m" "\e[33;1m▓\e[0m" "\e[33;1m█\e[0m"
  "\e[32;1m░\e[0m" "\e[32;1m▒\e[0m" "\e[32;1m▓\e[0m" "\e[32;1m█\e[0m"
)


usage() {
  cat <<EOF

$(basename "$0") [options] [''|AUTHOR_NAME [''|HG_DATESPEC [''|GIT_SINCE [''|GIT_UNTIL]]]]

Version $VCSSTAT_VERSION

Every argument is basically optional, however you need to use '' to indicate
that you are not specifying it.

Options:

  -c:       Commit calendar mode
  -p:       Punchcard mode
  -x:       Output additions/deletions/commits in CSV format
  -C:       Do not color output
  -U:       Do not use Unicode (only for -c and implies -C)
  -Z:       Filter out repo with no changes
  -m:       Week starts with Mondays
  -h:       This thing you are reading

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
  read ins del c _ <<< "$(awk "
    BEGIN {ins = 0; del = 0; c = 0}
    {ins += \$1; del += \$2; c++}
    END {print ins, del, c}"
  )"
  ((ins + del == 0)) && [[ $NO_ZEROES == yes ]] && return
  printf "$FMT_LINE" "$1" "$2" $ins $del $c
  ((total_ins += ins, total_del += del, total_c += c))
}


count_ccal() {
  while read d _; do
    if [[ $MONDAY_FIRST == yes ]]; then
      key=$(date -d "$d" +%Y%W%u)
    else
      key=$(date -d "$d" +%Y%U%w)
    fi
    ((ccal[key] += 1))
  done
}


count_pcal() {
  while read d _; do
    printf -v key '%(%u%H)T' $d
    ((pcal[key] += 1))
  done
}


cc_print_year() {
  # generate week numbers of start day of month
  month_week=([1]=$1)
  for ((m = 2; m <= 12; m++)); do
    if [[ $MONDAY_FIRST == yes ]]; then
      read week abbr <<< "$(date -d "$y-$m-1" +'%W %b')"
    else
      read week abbr <<< "$(date -d "$y-$m-1" +'%U %b')"
    fi
    month_week[${week#0}]=$abbr
  done
  for ((w = 0; w <= 53; w++)); do
    if [[ ! -z ${month_week[w]} ]]; then
      echo -n "${month_week[w]}"
      ((w += ${#month_week[w]} - 1))
    else
      echo -n ' '
    fi
  done
  echo

  for ((d = 1; d <= 7; d++)); do
    for ((w = 0; w <= 53; w++)); do
      if [[ $MONDAY_FIRST == yes ]]; then
        printf -v k '%d%02d%d' $y $w $d
      else
        printf -v k '%d%02d%d' $y $w $((d - 1))
      fi
      echo -ne "${CC_LEGEND[$((${ccal[k]:-0} * CC_SCALE / cc_max))]}"
    done
    echo
  done
}


while getopts hcpxCUZm opt; do
  case "$opt" in
    h)
      usage
      exit
      ;;
    c)
      MODE=calendar
      ccal=()
      ;;
    p)
      MODE=punchcard
      pcal=()
      ;;
    x)
      MODE=csv
      ;;
    C)
      FMT_OUT=${FMT_OUT//"\e["?";"??"m"/}
      FMT_OUT=${FMT_OUT//"\e["?"m"/}
      [[ $NO_UNICODE != yes ]] && CC_LEGEND=("░" "▒" "▓" "█")
      ;;
    U)
      NO_UNICODE=yes
      CC_LEGEND=('.' '-' '+' '*' '#' '@')
      ;;
    Z)
      NO_ZEROES=yes
      ;;
    m)
      MONDAY_FIRST=yes
      ;;
  esac
done
shift $((OPTIND - 1))


GIT_ARGS=()
HG_ARGS=()

if [[ ! -z "$1" ]]; then
  HG_ARGS=(  "${HG_ARGS[@]}" "--user"   "$1")
  GIT_ARGS=("${GIT_ARGS[@]}" "--author" "$1")
fi

[[ ! -z "$2" ]] && HG_ARGS=(  "${HG_ARGS[@]}" "--date"  "$2")
[[ ! -z "$3" ]] && GIT_ARGS=("${GIT_ARGS[@]}" "--since" "$3")
[[ ! -z "$4" ]] && GIT_ARGS=("${GIT_ARGS[@]}" "--until" "$4")

CC_SCALE=$((${#CC_LEGEND[@]} - 1))


case "$MODE" in
  calendar|punchcard)
    ;;
  csv)
    echo 'Type,Repository,Additions,Deletions,Commits'
    FMT_LINE="%s,%s,%d,%d,%d\n"
    ;;
  *)
    FMT_LINE="[%3s] $FMT_DIR $FMT_OUT"
    ;;
esac


for d in */ .; do
  [[ ! -d "$d" ]] && continue
  cd -- "$d"
  d=${d%\/}
  if [[ -d .hg ]]; then
    case "$MODE" in
      calendar)
        count_ccal < <(hg log "${HG_ARGS[@]}" --template '{date|rfc3339date}\n')
        ;;
      punchcard)
        count_pcal < <(hg log "${HG_ARGS[@]}" --template '{date|hgdate}\n')
        ;;
      *)
        parse_stat  "Hg" "$d" < <(
          hg  log  "${HG_ARGS[@]}" --template '{diffstat}\n' |
          sed -n 's/[^0-9]/ /g ; s/^[0-9]\+// ; /[0-9]/p')
        ;;
    esac
  elif [[ -d .git ]]; then
    case "$MODE" in
      calendar)
        count_ccal < <(git log "${GIT_ARGS[@]}" --pretty=format:%ai)
        ;;
      punchcard)
        count_pcal < <(git log "${GIT_ARGS[@]}" --pretty=format:%at)
        ;;
      *)  # csv and default
        parse_stat "Git" "$d" < <(
          git log "${GIT_ARGS[@]}" --numstat --pretty=format: |
          awk '
          BEGIN {ins = 0; del = 0; two=0}
          {
             if ($0 != "") {
               ins += $1; del += $2
             } else {
               two++
               if (two < 2) next
               print ins, del
               ins = 0; del = 0 ; two = 0
             }
          }
          END {if (two == 1) print ins, del}')
        ;;
    esac
  fi
  cd ..
done


case "$MODE" in
  calendar)
    # find begin and end years
    keys=("${!ccal[@]}")
    cc_begin=${keys[0]:0:4}
    cc_end=${keys[-1]:0:4}
    unset keys[@]
    # find max number of commits
    for count in "${ccal[@]}"; do
      ((count > cc_max)) && cc_max=$count
    done
    for ((y=cc_begin; y<=cc_end; y++)); do
      cc_print_year $y
    done
    ;;
  punchcard)
    # find max number of commits
    for count in "${pcal[@]}"; do
      ((count > cc_max)) && cc_max=$count
    done

    if [[ $MONDAY_FIRST == yes ]]; then
      days_order='1 2 3 4 5 6 7'
    else
      days_order='7 1 2 3 4 5 6'
    fi
    days_names=('' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat' 'Sun')
    for d in $days_order; do
      echo -n "${days_names[d]}"
      for h in {00..23}; do
        echo -ne "  ${CC_LEGEND[$((${pcal[$d$h]:-0} * CC_SCALE / cc_max))]}"
      done
      echo
    done
    echo -n '   ' ; printf '%3s' {0..23} ; echo
    ;;
  *)  # csv and default
    if ((total_c > 0)) || [[ $NO_ZEROES != yes ]]; then
      if [[ $MODE == csv ]]; then
        printf "TOTAL,,%d,%d,%d\n" $total_ins $total_del $total_c
      else
        printf -- '-%.s' {1..64} ; echo
        printf "TOTAL $FMT_DIR $FMT_OUT" '' $total_ins $total_del $total_c
      fi
    fi
    ;;
esac
