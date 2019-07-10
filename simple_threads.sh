# -*- coding:utf-8 -*-
#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# File Name:   test1.sh
# Purpose:    
#
# Author:      Ke Wang
#
# Created:     2019-07-09
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------
job0()
{
    echo "Wget package ..."
    sleep 4
    touch ".${FUNCNAME[0]}done"
}

job1()
{
    echo "Prepare job data ..."
    sleep 3
    touch ".${FUNCNAME[0]}done"
}

main()
{
    job0 &
    job1 &
    wait  # Wait all jobs done
    if [[ -f .job0done ]];then
        echo "job0 done!"
    fi
    if [[ -f .job1done ]];then
        echo "job1 done!"
    fi

    echo "all is ending"
}

#---------------- Main Program --------------
main
