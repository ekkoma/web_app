# /usr/bin/env python
# coding: utf-8

import pstats
import time
import requests
import random
import json
import pymongo
import datetime

city_code_map = {
    '北京' : 54511,
    '天津' : 54517,
    '石家庄' : 53698,
    '太原' : 53772,
    '呼和浩特' : 53463,
    '沈阳' : 54342,
    '吉林' : 54161,
    '哈尔滨' : 50953,
    '上海' : 58367,
    '南京' : 58238,
    '杭州' : 58457,
    '合肥' : 58321,
    '福州' : 58847,
    '南昌' : 58606,
    '济南' : 54823,
    '郑州' : 57083,
    '武汉' : 57494,
    '广州' : 59287
}

pre_url = "https://weather.cma.cn/api/now/"

mongo_host = ["127.0.0.1:27017"]
db = "web"
weather_coll = "weather"

class WeatherModel(object):
    def __init__(self):
        self._client = pymongo.MongoClient(host=mongo_host)
    
    def get_high_low_temperature(self, city_code_list, date):
        """查找数据库中指定城市的最高温最低温"""
        if not self._client:
            print("db conn err")
            raise Exception("db conn err")
        query = {
            "city_code": {'$in': city_code_list},
            "date": date
        }
        projection = {
            "_id": 1,
            "high_temperature": 1,
            "low_temperature": 1,
            "city_code": 1,
            }
        res = []
        find_result_cursor = self._client[db].weather_coll.find(query, projection)
        for find_result in find_result_cursor:
            res.append(find_result)
        if not res:
            print("not find, insert, date:{}".format(date))
            insert_records = []
            for code in city_code_list:
                dc = {
                    "city_code": code,
                    "high_temperature": -1000,
                    "low_temperature": 1000,
                    "update_time": datetime.datetime.now(),
                    "date": date
                }
                insert_records.append(dc)
            self._client[db].weather_coll.insert_many(insert_records)
            find_result_cursor = self._client[db].weather_coll.find(query, projection)
            for find_result in find_result_cursor:
                res.append(find_result)
        
        rec_dict = {}
        for r in res:
            rec_dict[r.get('city_code')] = r
        return rec_dict
        
    def update_high_low_temperature(self, record_list):
        """更新最高温最低温"""
        if not record_list or not isinstance(record_list, list):
            print("param erro:{}".format(record_list))
            raise Exception("param err")
        if not self._client:
            print("db conn err")
            raise Exception("db conn err")
        self._client[db].weather_coll.bulk_write(record_list)
        return True

def crawler_weather_record():
    """爬取天气数据"""
    records = []
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json, text/javascript',
        'Accept-Language': 'zh-CN,zh;q=0.9',
    }
    for _, v in city_code_map.items():
        url = "".join([pre_url, str(v)])
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code != 200:
            print("url:{},response.status_code:{}".format(url, response.status_code))
        else:
            one_record = {}
            res = json.loads(response.text, encoding='utf-8')
            data = res.get('data', {})
            location = data.get('location', {})
            now = data.get('now', {})
            one_record['city_code'] = location.get('id')
            one_record['city_name'] = location.get('name')
            one_record['temperature'] = now.get('temperature')
            records.append(one_record)
            # print("{},{}".format(one_record['city_name'], one_record['temperature']))
        time.sleep(random.randint(1,5))
    return records

def get_need_update_data(records):
    """与当前db数据做比较,检查那些记录需要更新"""
    cur_date = datetime.datetime.now().strftime("%Y-%m-%d")
    need_update = []
    code_records = {}
    for one in records:
        code_records[one.get('city_code')] = one
    code_list = [one.get('city_code') for one in records]
    try:
        db_data = weather_coll.get_high_low_temperature(code_list, cur_date)
    except Exception as e:
        print("err:{}".format(e))
        return False
        
    for code, rec in db_data.items():
        need_high_update = False
        need_low_update = False
        if code_records[code]['temperature'] > rec['high_temperature']:
            need_high_update = True
        if code_records[code]['temperature'] < rec['low_temperature']:
            need_low_update = True
        if need_high_update and need_low_update:
            need_update.append(pymongo.UpdateOne(
                {"_id": rec.get('_id')}, 
                {'$set': {
                        'high_temperature': code_records[code]['temperature'],
                        'low_temperature': code_records[code]['temperature'],
                        'update_time': datetime.datetime.now()
                    }}))
        elif need_high_update:
            need_update.append(pymongo.UpdateOne(
                {"_id": rec.get('_id')}, 
                {'$set': {
                        'high_temperature': code_records[code]['temperature'],
                        'update_time': datetime.datetime.now()
                    }}))
        elif need_low_update:
            need_update.append(pymongo.UpdateOne(
                {"_id": rec.get('_id')}, 
                {'$set': {
                        'low_temperature': code_records[code]['temperature'],
                        'update_time': datetime.datetime.now()
                    }}))
    return need_update

weather_coll = WeatherModel()

if __name__ == "__main__":
    print("[{}] - start run".format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
    start_time = time.time()

    # 获取数据
    records = crawler_weather_record()
    if not records:
        print("crawler_weather_record faild, records:{}".format(records))
        exit(1)
        
    # 需要更新的记录
    update_records = get_need_update_data(records)
    if not update_records:
        print("no need update")
        exit(0)
    
    # 更新数据
    try:
        weather_coll.update_high_low_temperature(update_records)
    except Exception as e:
        print("err:{}".format(e))
        exit(1)

    end_time = time.time()
    print("[{}] -end.".format(datetime.datetime.now().strftime("%Y-m-d %H:%M:%S")))
    print("use time:{}".format(end_time - start_time))

