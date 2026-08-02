#!/bin/bash

source ./01.common.sh
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD
SERVICE=nginx

root_check
LOG_DIR
nginx_install
Service_Enable