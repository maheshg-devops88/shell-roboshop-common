#!/bin/bash

source ./01.common.sh
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD
SERVICE=nginx

root_check

LOG_DIR

VALIDATE()
if [ $1 == 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi

nginx_install



rm -rf /usr/share/$SERVICE/html/* 
VALIDATE $? "Remove default html file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "download frontend.zip file to tmp Dir"

cd /usr/share/$SERVICE/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzip frontend.zip to /app"


rm -rf /etc/$SERVICE/$SERVICE.conf
VALIDATE $? "Remove $SERVICE.conf file"

cp $WRK_DIR/$SERVICE.conf /etc/$SERVICE/
VALIDATE $? "Copy $SERVICE.conf file to /etc/$SERVICE/"

Service_Enable