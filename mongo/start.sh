#!/bin/bash

source /web_server/shell_env

# 路径检查
DB_PATH="/web_server/mongo/db"
LOG_FILE="/web_server/mongo/log/mongodb.log"

if [ ! -d ${DB_PATH} ]; then
    mkdir -p ${DB_PATH}
fi
if [ ! -f ${LOG_FILE} ]; then
    mkdir -p /web_server/mongo/log/
    touch ${LOG_FILE}
    chmod 755 ${LOG_FILE}
fi

# 启动mongo
./mongod -f mongodb.conf &>/dev/null

pid=`pidof mongod`
if [ -z pid ]; then
    echo -e "${RED}mongod start error!${COLOR_END}"
    exit -1
else
    echo -e "${GREEN}mongod start success, pid:${pid}"
    exit 0
fi

