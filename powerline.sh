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

readonly CB_FAILURE=$CB_RED
readonly CB_SUCCESS=$CB_MAG

readonly C_RESET="$(tput $tty sgr0)"

#
# Segments
#
seg_username() {
    echo "$USER"
}

seg_hostname() {
    echo hostname
}

seg_git() {
    if [ -f /usr/bin/git ]; then
        source ~/.git-prompt.sh
        echo $(__git_ps1)
    else
        echo ''
    fi
}

seg_dir() {

    local dir="$PWD"
    local out=''

    [[ "$dir" =~ ^"$HOME"(/|$) ]] && dir="${dir/#$HOME/\~}"
    IFS="/" dir_array=($dir)

    out+="\[$CF_BLK$CF_WHT\]"
    out+=" $(str_join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "${dir_array[@]}") "

    echo "$out"
}

seg_retval() {
    ret=$1

    local state_bg
    local state_fg
    local out=''

    if [ "$ret" -eq 0 ]; then
        state_fg="$CF_SUCCESS"
        state_bg="$CB_SUCCESS"
    else
        state_fg="$CF_FAILURE"
        state_bg="$CB_FAILURE"
    fi

    out+="\[$CF_WHT$state_bg\]"$'\uE0B0'"\[$CF_BLK\]"
    out+=" $ "
    out+="\[$C_RESET$state_fg\]"$'\uE0B0'

    echo "$out"
}


str_join() {
    local sep="$1"
    shift
    local len=$#
    local args=("$@")
    for ((i=0; i<len; i++)); do
        test $i -ne 0 && echo -n "$sep"
        echo -n "${args[$i]}"
    done
}

#
# Build final prompt string and echo it
#
build_ps1() {

    local readonly return_code=$?

    local out="\n"
    local user=$(seg_username)
    local host=$(seg_hostname)
    local dir=$(seg_dir)
    local git=$(seg_git)
    local retval=$(seg_retval $return_code)

    local seg_user="$user"
    seg_user+='@'
    seg_user+="$host"

    out+="\[$CF_WHT$CB_GRA\]"
    out+=$(str_join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "$seg_user")
    out+=$(str_join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "$dir")
    out+=$(str_join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "$git")
    out+=$(str_join " \[$CF_GRA\]"$'\uE0B1'"\[$CF_BLK\] " "$retval")
    out+="\[$C_RESET\] "

    echo "$out"
}
# PROMPT_COMMAND=__ps1

#
# Echo out final string
#
build_ps1
