#!/bin/bash

# 停止redis

source /web_server/shell_env

pid=`pidof mongod`
if [ -z ${pid} ]; then
    echo "mongod is not run"
    exit -1
else
    kill ${pid}
    pid=`pidof mongod`
    if [ -z ${pid} ]; then
        echo -e "${GREEN}mongod stop success${COLOR_END}"
        exit 0
    else
        echo -e "${RED}mongod stop failed${COLOR_END}"
        exit -2
    fi
fi
