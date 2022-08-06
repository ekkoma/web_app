#!/bin/bash

source /web_server/shell_env
valid_keys=("start", "stop", "reload")

print_message="
param error \n
### usage <$0> start   --------- start nginx        # \n
### usage <$0> reload  --------- reload nginx       # \n
### usage <$0> stop    --------- start nginx        # \n
### nginx -c /web_server/portal/conf/nginx.conf     #"

if [[ $# != 1 ]]; then
    echo -e ${print_message}
    exit -1
fi

# 参数1是数组的子集（模糊匹配）
if [[ ! "${valid_keys[*]}" =~ $1 ]]; then
    echo -e ${print_message}
    exit -1
fi

function stop()
{
    echo "stop nginx..."
    pid=`ps aux | grep "nginx -c /web_server/portal/conf/nginx.conf" | grep -v grep | awk '{print $2}'`
    if [ ! -z ${pid} ]; then
        kill ${pid}
    fi
    echo -e "${GREEN}stop ok${COLOR_END}"
}

function start()
{
    echo "start nginx..."
    nginx -c /web_server/portal/conf/nginx.conf
    echo -e "${GREEN}nginx started${COLOR_END}"
}

function reload()
{
    echo "reload nginx..."
    nginx -c /web_server/portal/conf/nginx.conf -s reload
    echo -e "${GREEN}nginx reload success${COLOR_END}"
}

case $1 in
    "start")
    start
    ;;
    "stop")
    stop
    ;;
    "reload")
    reload
    ;;
esac
