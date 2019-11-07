#!/usr/bin/env bash
# -*- coding:utf-8 -*-
#-------------------------------------------------------------------------------
# File Name:   books-mgr-sys.sh
# Purpose:    
#
# Author:      Ke Wang
#
# Created:     2019-11-07
# Copyright:   (c) Ke Wang 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

function books_sys_menu
{
  echo "---------------------------"
  echo "图书馆管理系统（5.4版本）"
  echo
  echo -n "| " ;echo "1:添加图书"
  echo -n "| " ;echo "2:删除图书"
  echo -n "| " ;echo "3:图书列表"
  echo -n "| " ;echo "4:查找图书"
  echo -n "| " ;echo "5|q:退出系统"
  echo
  echo "---------------------------"
  read -p "请输入你的选择:" a


  case "$a" in
  1)
    add ;;
  2)
    delete ;;
  3)
    list ;;
  4)
    search;;
  5|q|Q)
    return -1 ;;
  *)
    books_sys_menu ;;
  esac
}


function file_exist
{
  if [ ! -f .book.txt ];then
    touch .book.txt
  fi
}


function add
{
  read -p "请输入图书的编号：" number
  read -p "请输入图书的书名：" book_name
  read -p "请输入图书的作者：" author
  read -p "请输入图书的价格：" price
    echo -e "$number\t$book_name\t$author\t$price" >>.book.txt && {
      echo "添加图书成功！"
      echo "-------------------"
    }
  if [ $? -ne 0 ];then
    echo "添加图书失败"
  fi
  books_sys_menu

}

function delete
{
  read -p "请输入要删除的图书的编号：" number
  grep $number .book.txt &>/dev/null && {
      sed -i '/\<'$number'\>/d' .book.txt &>/dev/null &&
      echo "删除图书成功"
  echo "-------------------------"
  }

  if [ $? -ne 0 ];then
    echo "删除图书失败"
    echo "你要删除的图书不存在"
  fi
  books_sys_menu
}

#列出所有图书的信息
function list
{
  echo -e "编号\t书名\t作者\t价格"
  cat .book.txt
  echo "----------------------------"
  books_sys_menu

}


#下面的函数用到的查询菜单
function search_menu
{
  echo;echo "----------------------------"
  echo -n "|";echo -e "1：\t按图书编号查询"
  echo -n "|";echo -e "2：\t按图书书名查询"
  echo -n "|";echo -e "3：\t按图书作者查询"
  echo -n "|";echo -e "4：\t按图书价格查询"
  echo -n "|";echo -e "5|q：\t退出查询系统"
  echo;echo "----------------------------"

}
function search
{
  search_menu
  read -p "请输出你的选择：" myselect
  case "$myselect" in
  1)
    read -p "请输入要查询的图书的编号：" mynumber
    echo -e "编号\t书名\t作者\t价格\n"
    awk '$1=='$mynumber'{print $0}' .book.txt 2>/dev/null

    if [ $? -ne 0 ];then
      echo "图书不存在"
    fi
    search
    ;;
  2)
    read -p "请输入你要查询的书名：" mybook_name
    echo -e "编号\t书名\t作者\t价格\n"
    awk '$2~/'$mybook_name'/{print $0}' .book.txt 2>/dev/null
    if [ $? -ne 0 ];then
      echo "图书不存在"
    fi
    search
    ;;
  3)
    read -p "请输入图书的作者：" myauthor
    echo -e "编号\t书名\t作者\t价格\n"
    awk '$3~/'$myauthor'/{;print $0}' .book.txt 2>/dev/null
    if [ $? -ne 0 ];then
      echo "图书不存在"
    fi
    search
    ;;
  4)
    read -p "请输入图书的价格：" myprice
    echo -e "编号\t书名\t作者\t价格\n"
    awk '$4=='$myprice'{print $0}' .book.txt 2>/dev/null
    if [ $? -ne 0 ];then
      echo "图书不存在"
    fi
    search
    ;;
  5)
    books_sys_menu
    ;;
  *)
    books_sys_menu
    ;;
  esac

}

main(){
    books_sys_menu
}

#---------------- Main Program --------------
main "$@"
