# -*- coding:utf-8 -*-
#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# File Name:   sh_threads.sh
# Purpose:    
#
# Author:      Ke Wang
#
# Created:     2019-07-09
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

my_cmd(){
    t=$RANDOM
    t=$[t%15]
    sleep $t
    echo "sleep $t s"
}

main()
{
    # 最大可执行线程数
    SEND_THREAD_NUM=10
    # 任务总数
    job_num=100

    tmp_fifofile="/tmp/$$.fifo" # 脚本运行的当前进程ID号作为文件名 
    mkfifo "$tmp_fifofile" # 新建一个随机fifo管道文件 
    exec 6<>"$tmp_fifofile" # 定义文件描述符6指向这个fifo管道文件 
    rm $tmp_fifofile 

    #往fifo管道文件中写入空行,总共数量为可执行线程最大数
    #每个线程数量等同于一个令牌
    for ((i=0;i<$SEND_THREAD_NUM;i++));do 
        echo
    done >&6 

    for ((i=0;i<${job_num};i++));do #任务数量 
        # 从文件描述符6中读取行（实际指向fifo管道) 
        # 一个read -u6命令执行一次，就从fd6中减去一个回车符，然后向下执行，
        # fd6中没有回车符的时候，就停在这了，从而实现了线程数量控制
        read -u6 
        { 
            my_cmd
            # 再次往fifo管道文件中写入一个空行,相当于归还令牌 
            echo >&6
            
        } & 

        # {} 这部分语句被放入后台作为一个子进程执行，所以不必每次等待3秒后执行 
        #下一个,这部分的echo $i几乎是同时完成的，当fifo中10个空行读完后 for循环 
        # 继续等待 read 中读取fifo数据，当后台的10个子进程等待3秒后，按次序 
        # 排队往fifo输入空行，这样fifo中又有了数据，for语句继续执行 
        pid=$! #打印最后一个进入后台的子进程id 
        echo $pid 
    done 
    wait 
    exec 6>&- #删除文件描述符6 
    exit 0 
}

#---------------- Main Program --------------
main
