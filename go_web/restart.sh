#!/bin/bash

pid=`ps aux | grep /web_server/go_web | grep -v grep | awk {'print $2'}`

if [ ! -z ${pid} ]; then
    kill ${pid}
    echo "kill :${pid}..."
fi

./bin/daemon ./bin/main

pid=`ps aux | grep /web_server/go_web | grep -v grep | awk {'print $2'}`
echo "pid:${pid}"
