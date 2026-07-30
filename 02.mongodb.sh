#!/bin/bash

source ./01.common.sh
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log

root_check

VALIDATE() {
if [ $1 -eq 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi
}

LOG_DIR

mongodb_installation