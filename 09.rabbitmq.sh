#!/bin/bash

source ./01.common.sh

LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log
WRK_DIR=$PWD

root_check

VALIDATE()
if [ $1 == 0 ]; then
   echo "$2.....Success" 
 else
   echo "$2.....Failure"
fi

LOG_DIR 

cp $WRK_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Copied rabbitmq.repo to /etc/yum.repos.d"

dnf install rabbitmq-server -y
VALIDATE $? "rabbitmq-server installation"

systemctl enable rabbitmq-server
VALIDATE $? "Enable rabbitmq service"

systemctl restart rabbitmq-server
VALIDATE $? "Start rabbitmq service"

if rabbitmqctl list_users | grep -qE "roboshop"; then
    echo "User 'roboshop' already exists. Skipping creation."
else
    echo "Creating user 'roboshop'..."
    rabbitmqctl add_user roboshop roboshop123
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
fi