#!/bin/bash

userid=$(id -u)

root_check() {

    if [ $userid -ne 0 ]; then
       echo "Please run the script sudo access"
       exit 1
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

Redis_Installation () {
    dnf module disable redis -y &>> $LOG_FILE
    VALIDATE $? "Disable redis Module"
    
    dnf module enable redis:7 -y  &>> $LOG_FILE
    VALIDATE $? "Enable redis 7 Module"

    dnf install redis -y &>> $LOG_FILE
    VALIDATE $? "Install redis"

    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOG_FILE
    VALIDATE $? "Changed address from 127.0.0.1 to 0.0.0.0"

    sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf &>> $LOG_FILE
    VALIDATE $? "protected-mode from yes to no"
}

Service_Enable() {

  systemctl daemon-reload
  VALIDATE $? "$SERVICE Service Daemon reload"

  systemctl enable $SERVICE &>> $LOG_FILE
  VALIDATE $? "Enable Systemctl service $SERVICE"

  systemctl start $SERVICE &>> $LOG_FILE
  VALIDATE $? "Start Systemctl service $SERVICE"
}

nodejs_install() {

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE $? "Disable Module nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "Enable module nodejs 20"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE $? "Install nodejs"
}


roboshop_user() {

id roboshop &>> $LOG_FILE
if [ $? == 1 ]; then
    
    echo "Create roboshop user...."
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
  else
    echo "Roboshop user already exists.."
fi
}

app_install() {

rm -rf /app
VALIDATE $? "remove /app Dir if exists"

mkdir -p /app
VALIDATE $? "created directory /app"

curl -o /tmp/$SERVICE.zip https://roboshop-artifacts.s3.amazonaws.com/$SERVICE-v3.zip &>> $LOG_FILE
VALIDATE $? "download $SERVICE.zip file to tmp Dir"

cd /app
unzip /tmp/$SERVICE.zip &>> $LOG_FILE
VALIDATE $? "unzip $SERVICE.zip to /app"



cp $WRK_DIR/$SERVICE.service /etc/systemd/system/
VALIDATE $? "Copy $SERVICE.service to /etc/systemd/system/"
}

nginx_install() {

    dnf module disable nginx -y &>> $LOG_FILE
    VALIDATE $? "Disable module nginx"

    dnf module enable nginx:1.24 -y &>> $LOG_FILE
    VALIDATE $? "Enable module nginx"

    dnf install nginx -y &>> $LOG_FILE
    VALIDATE $? "Install nginx"

}

mysql_install() {

    dnf install mysql-server -y  &>> $LOG_FILE
    VALIDATE $? "Install mysql-server"

    systemctl enable mysqld  &>> $LOG_FILE
    VALIDATE $? "Enable mysqld service"

    systemctl start mysqld &>> $LOG_FILE
    VALIDATE $? "Start mysqld service"

    mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG_FILE
    VALIDATE $? "Change sql root password"
}

mvn_install() {

        dnf install maven -y &>> $LOG_FILE
        VALIDATE $? "Install maven"

        rm -rf /app
        VALIDATE $? "remove /app Dir if exists"

        mkdir -p /app
        VALIDATE $? "created directory /app"

        curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>> $LOG_FILE
        VALIDATE $? "download user.zip file to tmp Dir"

        cd /app
        unzip /tmp/shipping.zip &>> $LOG_FILE
        VALIDATE $? "unzip shipping.zip to /app"

        mvn clean package 
        VALIDATE $? "mvn to Clean package"

        mv target/shipping-1.0.jar shipping.jar
        VALIDATE $? "move shipping.jar from target to /app"

        cp $WRK_DIR/shipping.service /etc/systemd/system/
        VALIDATE $? "Copy shipping.service to /etc/systemd/system/"
}


python_install() {

        dnf install python3 gcc python3-devel -y
        VALIDATE $? "Install python"

        rm -rf /app
        VALIDATE $? "remove /app Dir if exists"

        mkdir -p /app
        VALIDATE $? "created directory /app"


        curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
        VALIDATE $? "download payment.zip file to tmp Dir"

        cd /app 
        unzip /tmp/payment.zip
        VALIDATE $? "unzip payment.zip to /app"


        pip3 install -r requirements.txt
        VALIDATE $? "Install requirements"

        cp $WRK_DIR/payment.service /etc/systemd/system
        VALIDATE $? "Copy payment.service"
}

golang_install() {

        dnf install golang -y
        VALIDATE $? "Install golang"

        rm -rf /app
        VALIDATE $? "remove /app Dir if exists"

        mkdir -p /app
        VALIDATE $? "created directory /app"

        curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip  &>> $LOG_FILE
        VALIDATE $? "download user.zip file to tmp Dir"

        cd /app
        unzip /tmp/dispatch.zip &>> $LOG_FILE
        VALIDATE $? "unzip dispatch.zip to /app"

        go mod init dispatch
        go get 
        go build


        cp $WRK_DIR/dispatch.service /etc/systemd/system
        VALIDATE $? "Copy dispatch.service"
}