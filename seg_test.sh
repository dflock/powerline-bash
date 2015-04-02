#!/usr/bin/env bash
# -*- mode: bash  -*-
set -o nounset
set -o errexit

readonly tty='-T xterm'
# readonly COLOR_FG_WHITE="$(tput $tty setaf 7)"
# readonly COLOR_FG_GRAY="$(tput $tty setaf 8)"
# readonly COLOR_FG_FAILURE="$(tput $tty setaf 1)"
# readonly COLOR_FG_SUCCESS="$(tput $tty setaf 5)"
# readonly COLOR_FG="$(tput $tty setaf 0)"
#
# readonly COLOR_BG_FAILURE="$(tput $tty setab 1)"
# readonly COLOR_BG_SUCCESS="$(tput $tty setab 5)"
# readonly COLOR_BG="$(tput $tty setab 7)"
# readonly COLOR_RESET="$(tput $tty sgr0)"

# Control sequences for fancy colours
readonly CF_BLK="$(tput $tty setaf 0)"
readonly CF_RED="$(tput $tty setaf 1)"
readonly CF_GRN="$(tput $tty setaf 2)"
readonly CF_YLW="$(tput $tty setaf 3)"
readonly CF_BLU="$(tput $tty setaf 4)"
readonly CF_MAG="$(tput $tty setaf 5)"
readonly CF_CYN="$(tput $tty setaf 6)"
readonly CF_WHT="$(tput $tty setaf 7)"
readonly CF_GRA="$(tput $tty setaf 8)"

readonly CF_FAILURE=$CF_RED
readonly CF_SUCCESS=$CF_MAG

readonly CB_BLK="$(tput $tty setab 0)"
readonly CB_RED="$(tput $tty setab 1)"
readonly CB_GRN="$(tput $tty setab 2)"
readonly CB_YLW="$(tput $tty setab 3)"
readonly CB_BLU="$(tput $tty setab 4)"
readonly CB_MAG="$(tput $tty setab 5)"
readonly CB_CYN="$(tput $tty setab 6)"
readonly CB_WHT="$(tput $tty setab 7)"
readonly CB_GRA="$(tput $tty setab 8)"

readonly CB_FAILURE=CB_RED
readonly CB_SUCCESS=CB_MAG

readonly C_RESET="$(tput $tty sgr0)"

__join() {
    local sep="$1"
    shift
    local len=$#
    local args=("$@")
    for ((i=0; i<len; i++)); do
        test $i -ne 0 && echo -n "$sep"
        echo -n "${args[$i]}"
    done
}

seg_dir() {

    local ret=$?
    local state_bg
    local state_fg
    if [ $ret -eq 0 ]; then
        state_fg="$CF_SUCCESS"
        state_bg="$CB_SUCCESS"
    else
        state_fg="$CF_FAILURE"
        state_bg="$CB_FAILURE"
    fi

    local dir="$PWD"
    [[ "$dir" =~ ^"$HOME"(/|$) ]] && dir="${dir/#$HOME/\~}"
    IFS="/" dir_array=($dir)
    echo "$dir_array"

    out=''
    out+="\[$CF_BLK$CB_WHT\]"
    out+=" $(__join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "${dir_array[@]}") "
    out+="\[$CF_WHT$state_bg\]"$'\uE0B0'"\[$CF_BLK\]"
    out+=" $ "
    out+="\[$C_RESET$state_fg\]"$'\uE0B0'
    out+="\[$C_RESET\] "

    echo "$out"
}

__pwd=$(seg_dir)
echo $__pwd
# IFS="-" echo "${__pwd[*]}"
