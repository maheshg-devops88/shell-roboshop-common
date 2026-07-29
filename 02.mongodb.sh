#!/bin/bash

source ./01.common.sh

userid=$(id -u)
LOG_FOLDER=/var/log/shell-roboshop
LOG_FILE=/var/log/shell-roboshop/$0.log

root_check()

