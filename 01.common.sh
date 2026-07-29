#!/bin/bash

userid=$(id -u)

root_check() {

    if [ $userid -ne 0 ]; then
       echo "Please run the script sudo access"
       exit 1
    fi 
}


VALIDATE() {
if [ $1 == 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi
}

LOG_DIR() {

mkdir -p $LOG_FOLDER
VALIDATE $? "LOG directory creation"
}
mongodb_installation () {
    cp mongo.repo /etc/yum.repos.d/
    VALIDATE $? "Copy mongo.repo to yum.repos.d"

    dnf install mongodb-org -y  &>> $LOG_FILE
    VALIDATE $? "mongodb Installation"

    sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/mongod.conf  &>> $LOG_FILE
    VALIDATE $? "Changing to 127.0.0.1 to 0.0.0.0" 

    systemctl enable mongod 
    VALIDATE $? "mongodb enabled"
    
    systemctl start mongod
    VALIDATE $? "mongodb service start state"
}