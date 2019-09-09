#---  FUNCTION  ----------------------------------------------------------------
#          NAME: log4sh
#   DESCRIPTION: write the formated log into file
#    PARAMETERS: log_level log_msg
#       RETURNS: none
#-------------------------------------------------------------------------------
log4sh(){
  local log_olevel

  if [ $# -eq 0 ];then
      printf "No input for function ${FUNCNAME[0]}!\n"
      return
  fi
  [ $# -lt 2 ] && log_level=0 || log_level=${1}
  shift
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

#---  FUNCTION  ----------------------------------------------------------------
#          NAME: fail
#   DESCRIPTION: write the error log into file and exit script with rc 1
#    PARAMETERS: failed error message
#       RETURNS: none
#-------------------------------------------------------------------------------
fail(){
    log4sh 2 "$*"
    exit 1
}
