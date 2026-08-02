#!/bin/bash

source ./01.common.sh

LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD
SERVICE=cart

root_check
LOG_DIR

roboshop_user

nodejs_install

app_install

npm install &>> $LOG_FILE
VALIDATE $? "Install dependencies"

Service_Enable