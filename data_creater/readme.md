##### 数据生产进程
```
1.定时任务执行脚本weather_crawler_script.py
2.脚本从天气网爬取指定城市天气，最高温最低温更新入mongodb,web库,weather表
3.每天只存一条记录，新的一天时，优先插入一条再做更新

crontab -e
19 * * * * python3.6 weather_crawler_script.py >> /web_server/data_creater/crond.log
39 * * * * python3.6 weather_crawler_script.py >> /web_server/data_creater/crond.log
59 * * * * python3.6 weather_crawler_script.py >> /web_server/data_creater/crond.log
```
