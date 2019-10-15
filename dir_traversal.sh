#!/bin/bash
dir_traversal(){
    for item in `ls ${1}`;do
        sub_file="${1}/${item}"
        [ -d "${sub_file}" ] && dir_traversal "${sub_file}" \
            || printf "${sub_file}\n"
    done
}
[ -z "${1}" ] && { printf "Enter a dir name!\n"; exit 1; }
dir_traversal "${1}"
