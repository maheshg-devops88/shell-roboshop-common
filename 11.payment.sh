#!/bin/bash

source ./01.common.sh

userid=$(id -u)
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD

root_check

LOG_DIR

roboshop_user

python_install

Service_Enable