#!/usr/bin/env bash
# -*- coding:utf-8 -*-
#-------------------------------------------------------------------------------
# File Name:   datetime-ago.sh
# Purpose:    
#
# Author:      Ke Wang
#
# Created:     2019-11-07
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

main(){
    #一月前
    historyTime=$(date "+%Y-%m-%d %H" -d '1 month ago')
    echo ${historyTime}
    historyTimeStamp=$(date -d "$historyTime" +%s)
    echo ${historyTimeStamp}
     
    #一周前
    echo $(date "+%Y-%m-%d %H" -d '7 day ago')
     
    #本月一月一日
    date_this_month=`date +%Y%m01`
     
    #一天前
    date_today=`date -d '1 day ago' +%Y%m%d`
     
    #一小时前
    echo $(date "+%Y-%m-%d %H" -d '-1 hours') 
}

#---------------- Main Program --------------
main "$@"
