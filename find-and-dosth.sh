# -*- coding:utf-8 -*-
#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# File Name:   find-and-dosth.sh
# Purpose:     Search one path and get specified files do something
#
# Author:      Ke Wang
#
# Created:     2019-09-09
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

main(){
    dest_dir="/var/"
    search_dir="log"
    search_file="boot.log*"
    matched_items=$(ls -F "${dest_dir}" | sed "s|^|${dest_dir}|g" | grep -v '@$' | xargs -I {} find {} -name "${search_dir}")
    for item in `echo "${matched_items}"`;do
        echo "${item}"
        if [ -f "${item}" ];then
            cat "${item}"
        else
            find "${item}" -type f -name "${search_file}" | xargs -I {} ls -l {}
            # We can do more here with a script or program
            #find "${item}" -type f -name "${search_file}" | xargs -I {} ./do-more.sh {}
        fi
    done
}

#---------------- Main Program --------------
main "$@"
