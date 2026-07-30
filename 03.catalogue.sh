#!/bin/bash

source ./01.common.sh
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD
SERVICE=catalogue

root_check



VALIDATE() {

if [ $1 == 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi
}

LOG_DIR

roboshop_user

nodejs_install

app_install

Service_Enable

cp $WRK_DIR/mongo.repo /etc/yum.repos.d/
VALIDATE $? "Copy Mongo Process"

dnf install mongodb-mongosh -y  &>> $LOG_FILE
VALIDATE $? "mongodb client Installation"

db=$(mongosh --quiet --host mongodb.daws88s.shop --eval "db.getMongo().getDBNames().includes('catalogue')")

if [ $db == false ]; then
      
    mongosh --host mongodb.daws88s.shop </app/db/master-data.js &>> $LOG_FILE
    else 
    echo "Catalogue Schema already exists in MongoDB"
fi