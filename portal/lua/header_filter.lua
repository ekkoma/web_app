-- 响应头部过滤处理(例如添加头部信息)
-- context: http, server, location, location if

-- 设置响应头
ngx.header['Content-Type'] = 'application/json; charset=utf-8'
ngx.header['Time-zone'] = 8 -- 由于http协议指定头不能包含下划线，ngx在检测到_时会自动转换为-
ngx.log(ngx.ERR, "header_filter_by_lua_file")
