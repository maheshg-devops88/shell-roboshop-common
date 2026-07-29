#!/bin/bash

root_check(){

    if [ $userid -ne 0 ]; then
       echo "Please run the script sudo access"
       exit 1
    fi 
}