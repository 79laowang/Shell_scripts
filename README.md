# Linux Shell You can do like this
The purpose of this documentation is to document and illustrate commonly-known and lesser-known usage doing various tasks using Linux shell.

## Catalog
* [log4sh](#log4sh)
* [Print a separate line](#Print-a-separate-line)
* [Generate random characters with specified length](#Generate-random-characters-with-specified-length)
* [List files of subdirectories recursively](#List-files-of-subdirectories-recursively)
* [Simple multi-threads running jobs](#Simple-multi-threads-running-jobs)
* [Json processor tool jq usage](#Json-processor-tool-jq-usage)
* [Shell dictionary usage](#Shell-dictionary-usage)
* [Shell progress bar](#Shell-progress-bar)

### log4sh
The most people know log4j(Java), The same, the Linux Shell also has log4sh.
#### Example code:
```Bash
log4sh(){
  local log_level

  if [ $# -eq 0 ];then
      printf "No input for function ${FUNCNAME[0]}!\n"
      return
  fi
  if [ $# -lt 2 ]; then
      log_level=0
  else
      log_level=${1}
      shift
  fi
  if [ -z ${log_file} ]; then
    log_filename="$(basename $0)"
    log_filename="${log_filename%.*}-`date +%Y%m%d_%H%M%S`.log"
    log_path="$(dirname $0)/logs"
    [ ! -d "${log_path}" ] && mkdir "${log_path}"
    log_file="${log_path}/${log_filename}"
  fi
  [ ! -f "${log_file}" ] && touch "${log_file}"
  chmod 666 "${log_file}"
  log_msg="$(date "+%Y-%m-%d %H:%M:%S") [${0##*/}] [${FUNCNAME[1]}]"
  case ${log_level} in
    0)
        log_msg="${log_msg} INFO: $*"
        echo "${log_msg}" | tee -a "${log_file}" 2>&1
    ;;
    1)
        log_msg="${log_msg} WARNING: $*"
        echo "${log_msg}" | tee -a "${log_file}" 2>&1
    ;;
    2)
        log_msg="${log_msg} ERROR: $*"
        echo "${log_msg}" | tee -a "${log_file}" 2>&1
    ;;
    3)
        log_msg="${log_msg} DEBUG: $*"
        echo "${log_msg}" | tee -a "${log_file}" 2>&1
    ;;
  esac
}
```
Write above log4sh example code to a common-funcs.sh file and load it in a script.
#### Example Usage:
```Bash
main(){
    . common-funcs.sh
    log4sh "test ..."
    log4sh 1 "test ..."
    log4sh 2 "test ..."
    log4sh 3 "test ..."
}

#---------------- Main Program --------------
main "$@"
```
#### Example Results:
```
2019-10-15 04:35:57 [test.sh] [main] INFO: test ...
2019-10-15 04:35:57 [test.sh] [main] WARNING: test ...
2019-10-15 04:35:57 [test.sh] [main] ERROR: test ...
2019-10-15 04:35:57 [test.sh] [main] DEBUG: test ... 
```
    
### Print a separate line
#### Example code:
```Bash
sp_line(){
    printf '%.0s-' {1..80}; printf '\n'
}
```
#### Example Results:
```
# printf '%.0s-' {1..80}; printf '\n'
--------------------------------------------------------------------------------
```

### Generate random characters with specified length
#### Example code:
```Bash
random_str()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
} 
```
#### Example Usage:
```Bash
#random_str 6
m1P4wt
```

### List files of subdirectories recursively
#### Example code:
```Bash
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
```
#### Example Results:
```
# ./dir-traversal.sh /var/log/
/var/log//anaconda/anaconda.log
/var/log//anaconda/ifcfg.log
/var/log//anaconda/journal.log
/var/log//anaconda/ks-script-0KvBaz.log
/var/log//anaconda/ks-script-CfD3rG.log
...
```
### Simple multi-threads running jobs
#### Example code:
```Bash
#!/usr/bin/env bash
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
```
#### Example Results:
```
Prepare job data ...
Wget package ...
job0 done!
job1 done!
all is ending
```

### Json processor tool jq usage
#### Example code:
```Bash
cat > test.json <<EOF
{
  "bugs": [
    {
      "bug_verify": "",
      "bug_id": "43"
    },
    {
      "bug_verify": "",
      "bug_id": "44"
    },
    {
      "bug_verify": "",
      "bug_id": "45"
    }
  ],
}
EOF

# Get all bugs id
bugs=$(jq -r '.bugs[].bug_id' test.json)

# Modify spedified item value.
BUB=43
jq -r --arg BUG "$BUG" '.bugs[]|select(.bug_id == $BUG).bug_verify="failed"' test.json
```

### Shell dictionary usage
Dictionary / associative arrays / hash map are very useful data structures and they can be created in bash version 4.0 and above. 
#### Example code:
```Bash
    declare -A dict

    dict["key1"]=val1
    dict+=( ["key2"]=val2 ["key3"]=val3 )
    # Iterate dictionary and print keys- values.
    for key in ${!dict[@]}; do
        echo "${key}:${dict[${key}]}"
    done
    dict["key1"]=val11 # modify a key's value
    echo "dict:key1->${dict["key1"]}"
    echo ${dict[@]} # get all values
    echo ${!dict[*]} # get all keys
    unset dict[key1]  # lets delete key1
    echo ${dict[*]} # get all values
```
#### Example Results:
```
# ./shell-dict.sh
key3:val3
key2:val2
key1:val1
dict:key1->val11
val3 val2 val11
key3 key2 key1
val3 val2
```
### Shell progress bar
#### Example code:
```Bash
trap 'kill $BG_PID;echo;exit' 1 2 3 15

function pbar
{
while true
do
    for j in '-' '\\' '|' '/'
    do
        echo -ne "\033[1D$j"
        sleep 1
    done
done
}

# Use -e, the backslash will be display at the end of the line
echo -e "Start downloading image  "
# Use -n, the backslash will be display at the end of the words
echo -n "Start downloading image  "
pbar &
BG_PID=$!

# Main programm, we use sleep to replace
sleep 10
echo
kill $BG_PID
```
#### Example Results:
```
$ ./sh-progress-bar.sh
Start downloading image
Start downloading image \
```
