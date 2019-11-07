#!/usr/bin/env bash
# -*- coding:utf-8 -*-
#-------------------------------------------------------------------------------
# File Name:   increasing-date.sh
# Purpose:    
#
# Author:      Ke Wang
#
# Created:     2019-11-07
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

main(){
    first=$1
    second=$2
    while [ "$first" != "$second" ]; do
        echo $first
        first=$(date -d "-1 days ago ${first}" +%Y%m%d)
    done
}

#---------------- Main Program --------------
main "$@"
