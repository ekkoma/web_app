#!/bin/bash

# 停止redis

RED="\e[31m"
GREEN="\e[32m"
COLOR_END="\e[0m"

# 查看redis进程
get_redis_pid(){
    return `ps aux | grep redis-server | grep -v grep | awk '{print $2}'`
}

if [ -z $(get_redis_pid) ]; then
    echo "redis is not run"
    exit -1
else
    kill ${pid}
    if [ -z $(get_redis_pid):wq
     ]; then
        echo -e "${GREEN}redis stop success${COLOR_END}"
        exit 0
        else
        echo -e "${RED}redis stop failed${COLOR_END}"
    fi
fi
