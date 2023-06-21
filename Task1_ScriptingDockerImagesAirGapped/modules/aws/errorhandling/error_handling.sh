#!/bin/bash

#Abort the code
function Abort {
  typeset exitcode=$1 ; shift
  case "$exitcode" in
    0 ) Log INFO "$*" ;;
    * ) Log FATAL "$*" ;;
  esac
  exit $exitcode
}

#Log the code
function Log {
  typeset level=$1 ; shift
  typeset msg="$*"
  typeset date="`date '+%Y/%m/%d %H:%M:%S'`"

  case "$level" in
    ERROR | FATAL        ) echo "$date $level: $msg" >&2 ;;
    WARN  | INFO | DEBUG ) echo "$date $level: $msg" ;;
    * ) Abort 1 "Internal error: invalid log level ($level)" ;;
  esac
}

#shows functions of error
function show_error() {
    
    if [[ $1 -eq 0 ]]; then
        Log INFO $2
    elif [[ $1 -eq 254 ]]; then
        Log INFO $2
    else 
        Abort $1
    fi

}