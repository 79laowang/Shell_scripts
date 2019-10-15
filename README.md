# Linux Shell You can do
The purpose of this documentation is to document and illustrate commonly-known and lesser-known usage doing various tasks using Linux shell.

## Catalog
* [log4sh](#log4sh)
* [Print a separate line](#Print-a-separate-line)
* [Generate random characters with specified length](#Generate-random-characters-with-specified-length)

### log4sh
The most people know log4j(Java), The same, the Linux Shell also has log4sh.
#### Example code:
```Bash
log4sh(){
  local log_olevel

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

### script4

