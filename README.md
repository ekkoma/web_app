### web server

mongodb 持久化存储
```
客户表：user {'_id': 唯一id,
              'name': 姓名, 
              'phone': 电话, 
              'email': 邮箱, 
              'create_time': 注册时间,
              'last_login_time': 最近登录时间,
              'role': 角色,
              'status': 状态(1-激活，0-失效),
              'password': 密码
              }
角色表：role {'_id': 唯一id,
              'level': 角色等级(1-普通，2-管理员),
              'create_time': 创建时间,
              'status': 状态(1-激活，0-失效)
              }
数据表：data {
    '_id': 唯一id,
    'type': 数据类型(1-类型1，2-类型2),
    '': ,
}

登录日志表：login_info {
    '_id': mongo唯一id,
    'insert_time_str': ,
    'user': ,
    'request_time': ,
    'headers': ,
    'remote_addr': ,
    'remote_port': ,
    'uri': ,
    'insert_time': ,
}

```
架构
#### 1.portal server 门户
```
1.登录
2.查询数据
```

#### 2. register server 注册服务器
```
1.注册新用户
```

#### 3.auth server 鉴权服务
```
1.鉴权
```

#### 4.backapp 后台进程
```
1.producer 生产者进程：从网站爬取数据/生成随机数据，打到kafka集群 topic-data
2.consumer 消费者进程：从kafka集群 topic-data消费数据，打入mongodb集群
```

#### 5.项目目录
```
├── go_web          -- 上游服务，业务接口
│   └── api
├── mongo           -- 存储
│   ├── db
│   ├── log
│   └── mongodb
│       └── bin
├── portal
│   ├── conf        -- nginx配置
│   │   └── extra
│   │       └── location
│   ├── dist
│   │   ├── assets
│   │   └── idux-icons
│   ├── logs
│   |── lua             -- lua写登录与鉴权，waf阻拦
│       └── api
│   
└── redis           -- token等用户信息缓存
    ├── log
    └── redis-bin
```
