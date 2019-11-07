#!/usr/bin/env bash
# -*- coding:utf-8 -*-
#-------------------------------------------------------------------------------
# File Name:   random.sh
# Purpose:     various kinds of generating random numbers
#
# Author:      Ke Wang
#
# Created:     2019-11-07
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

## 1. Linux 系统默认随机数
function print_randnum() {
  for i in {1..10};
  do
    randnum=$RANDOM     # Linux 内置随机数, 范围[0,32767], 最多5位随机数
#    randnum=$(awk 'BEGIN{srand(); print rand()*1000000; }') # awk 随机种子函数, 最多5位随机数, 跟时间有关
    echo -e "$i \t $randnum"
  done
}


## Linux 系统随机数 + 范围上限值后, 再取余
function mimvp_randnum_bignum() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(($RANDOM+$max))    # 随机数+范围上限, 然后取余
  randnum=$(($num%$mid+$min)) # 随机数包含上下限边界数值
  echo $randnum
}

function print_randnum_bignum() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_bignum 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}


## 2. Linux 时间戳随机数 (CentOS, Ubuntu支持, MacOS不支持纳秒+%N)
function mimvp_randnum_date() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(date +%s%N | cut -c1-17)   # 19位数, 截取第1-17位数, 下标从1开始
  num=$(date +%s%N)          # 19位数, 截取第1-17位数, 下标从1开始
  randnum=$(($num%$mid+$min))     # 随机数包含上下限边界数值
  echo $randnum
}

function print_randnum_date() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_date 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}



## 3. Linux 随机文件
function mimvp_randnum_file() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(head -n 20 /dev/urandom | cksum | cut -f1 -d ' ')
#  num=$(head -n 20 /dev/urandom | cksum | cut -d ' ' -f1)       # ok
#  num=$(head -n 20 /dev/urandom | cksum | awk '{print $1}')      # ok
#  num=$(head -n 20 /dev/urandom | cksum | awk -F " " '{print $1}')  # ok
  randnum=$(($num%$mid+$min))
  echo $randnum
}

function print_randnum_file() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_file 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}


## 4. Linux uuid
function mimvp_randnum_uuid() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(head -n 20 /proc/sys/kernel/random/uuid | cksum | cut -f1 -d ' ')
  randnum=$(($num%$mid+$min))
  echo $randnum
}

function print_randnum_uuid() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_uuid 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}


## 5. Linux openssl
function mimvp_randnum_openssl() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(openssl rand -base64 8 | cksum | cut -f1 -d ' ')   # -base64
#  num=$(openssl rand -hex 8 | cksum | cut -f1 -d ' ')    # -hex
  randnum=$(($num%$mid+$min))
  echo $randnum
}

function print_randnum_openssl() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_openssl 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}


## 6. custom array, 可以生成整数, 字符串
function mimvp_randnum_array() {
  NUM_LENGTH=18    # 整数的位数, 依据取值范围设定, 默认最长为18位整数(取决于正整数的范围)
  STR_ARRAY=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)   # 生成字符串
  STR_ARRAY=(0 1 2 3 4 5 6 7 8 9)   # 生成整数

  str_array_count=${#STR_ARRAY[@]}  # 字符串数组的元素个数, 62 = 10 + 26 + 26
#  echo "str_array_count: ${str_array_count}"

  i=1
  randnum_array=()
  while [ "$i" -le "${NUM_LENGTH}" ];
  do
    randnum_array[$i]=${STR_ARRAY[$((RANDOM%str_array_count))]}
    let "i=i+1"
  done
  randnum_array_count=${#randnum_array[@]}
#  echo "randnum_array_count: ${randnum_array_count}" # NUM_LENGTH 的长度: 18
#  echo "randnum_array: ${randnum_array[@]}"      # 打印出全部数组元素, 如 B 2 y t z K c Z s N l 9 T b V w j 6

  num='1'       # 整数首位不能是0, 因此直接固定为1, 防止整数时首位为0的异常错误
  for item in ${randnum_array[@]};
  do
    num="${num}${item}"
  done
#  echo "num: $num"  # 1B2ytzKcZsNl9TbVwj6

  min=$1
  max=$2
  mid=$(($max-$min+1))
  randnum=$(($num%$mid+$min))
  echo $randnum
}

function print_randnum_array() {
  for i in {1..10};
  do
    randnum=$(mimvp_randnum_array 40000000 50000000)
    echo -e "$i \t $randnum"
  done
}


## 应用一: 随机生成端口号 1025 ~ 65536 (通用于 CentOS, Ubuntu, MacOS)
function mimvp_app_port() {
  min=$1
  max=$2
  mid=$(($max-$min+1))
  num=$(head -n 20 /dev/urandom | cksum | cut -f1 -d ' ')
  randnum=$(($num%$mid+$min))

  # 排除的端口号 1080, 4500, 8080, 58866, 可以任意添加
  port_exclude='1080,4500,8080,58866'
  flag=`echo ${port_exclude} | grep ${randnum} | wc -l`
  while [ "$flag" -eq "1" ]
  do
    num=$(head -n 20 /dev/urandom | cksum | cut -f1 -d ' ')
    randnum=$(($num%$mid+$min))
    flag=`echo ${port_exclude} | grep ${randnum} | wc -l`
  done
  echo $randnum
}

function print_app_port() {
  for i in {1..10};
  do
    randnum=$(mimvp_app_port 1025 65535)
    echo -e "$i \t $randnum"
  done
}


## 应用二: 随机生成长度为10的密码字符串 (通用于 CentOS, Ubuntu, MacOS)
function mimvp_app_passwd() {
  user_array=`seq -w 10`
  echo ${user_array[@]}

  for idx in ${user_array[@]}
  do
    user_name="user-${idx}"
    passwd=`echo $RANDOM | md5sum | cut -c11-20`
    echo -e "${user_name} \t ${passwd}"
  done
}


## 应用三: 统计掷骰子, 投掷6000次统计分别为1-6的次数 (通用于 CentOS, Ubuntu, MacOS)
function mimvp_app_dice() {
  MAX=6000
  stat_1=0
  stat_2=0
  stat_3=0
  stat_4=0
  stat_5=0
  stat_6=0

  i=1
  while [ "$i" -le "$MAX" ]
  do
    randnum=$(($RANDOM%6)) # 对6取余, 余数为0时记作6点
    case "$randnum" in
      0) stat_6=`expr ${stat_6} + 1`;;  # 余数为0时记作6点
      1) stat_1=`expr ${stat_1} + 1`;;
      2) stat_2=`expr ${stat_2} + 1`;;
      3) stat_3=`expr ${stat_3} + 1`;;
      4) stat_4=`expr ${stat_4} + 1`;;
      5) stat_5=`expr ${stat_5} + 1`;;
    esac
    let "i=i+1"
  done

  echo "stat_1 ${stat_1}"
  echo "stat_2 ${stat_2}"
  echo "stat_3 ${stat_3}"
  echo "stat_4 ${stat_4}"
  echo "stat_5 ${stat_5}"
  echo "stat_6 ${stat_6}"
}


main(){
    print_randnum

    #print_randnum_bignum
    
    #print_randnum_date
    
    #print_randnum_file
    
    #print_randnum_uuid
    
    #print_randnum_openssl
    
    #print_randnum_array
    
    #print_app_port
    
    #mimvp_app_passwd
    
    #mimvp_app_dice     # 循环次数多, 运行时间较长, 大约30秒, 请慎用
}

#---------------- Main Program --------------
main "$@"
