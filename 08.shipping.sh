#!/bin/bash

source ./01.common.sh

LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD
SERVICE=shipping

root_check

VALIDATE()
if [ $1 == 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi

LOG_DIR

roboshop_user

mvn_install

# Query the database to check if the schema exists
DB_EXISTS=$(mysql -h mysql.daws88s.shop -uroot -pRoboShop@1 -sN -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'cities'")

if [ $DB_EXISTS -ne 1 ]; then
    echo "Schema cities does not exist. Running schema.sql..."
    mysql -h mysql.daws88s.shop -uroot -pRoboShop@1 < /app/db/schema.sql  &>> $LOG_FILE
    mysql -h mysql.daws88s.shop -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOG_FILE
    mysql -h mysql.daws88s.shop -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOG_FILE
else
    echo "Schema cities already exists. Skipping installation."
fi

Service_Enable