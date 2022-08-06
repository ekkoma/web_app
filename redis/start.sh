#!/bin/bash

source /web_server/shell_env

# 日志文件路径
REDIS_LOG_FILE="/web_server/redis/log/redis.log"

if [ ! -f ${REDIS_LOG_FILE} ]; then
    mkdir -p /web_server/redis/log/
    touch ${REDIS_LOG_FILE}
    chmod 755 ${REDIS_LOG_FILE}
fi

# 启动redis
./redis-server redis.conf

state=`ps aux | grep redis-server | grep -v grep | awk '{print $12}'`
if [ -z state ]; then
    echo -e "${RED}redis start error!${COLOR_END}"
else
    echo -e "${GREEN}redis start on:${state}${COLOR_END}"
fi

