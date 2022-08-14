local json = require "cjson"
local redis = require "resty.redis"
local mongo = require "resty.mongol"

ngx.log(ngx.ERR, "content_by_lua_block")

ngx.req.read_body()
local data = ngx.req.get_body_data() -- string

if not data then
    ngx.say("failed to get post data")
    return
end

local rsp = 
{
    ["code"]= 0, 
    ["data"]= {}, 
    ["msg"]= ""
}

args = json.decode(data)
local user = args["user"]
local pwd = args["password"]

if not user then
    rsp["code"] = 1
    rsp["msg"] = "账号为空"
    ngx.say(json.encode(rsp))
    return -- ngx.say后记得return
end

if not pwd then
    rsp["code"] = 1
    rsp["msg"] = "密码为空"
    ngx.say(json.encode(rsp))
    return
end

local conn = mongo:new()
conn:set_timeout(1000)
local ok, err = conn:connect("127.0.0.1", 27017)
if not ok then
    ngx.log(ngx.ERR, "connect mongo err" .. err)
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错误"
    ngx.say(json.encode(rsp))
    return
end

local db = conn:new_db_handle("web")
local coll = db:get_col("user")
local r = coll:find_one({name=user}, {password=1})

if not r then
    rsp["code"] = 1
    rsp["msg"] = "账号密码错误"
    ngx.say(json.encode(rsp))
    return
end

if r["password"] ~= pwd then
    ngx.log(ngx.ERR, "==========user:" .. user .. " password not right, db:" .. r["password"])
    rsp["code"] = 1
    rsp["msg"] = "账号密码错误"
    ngx.say(json.encode(rsp))
    return
end

local token = ngx.md5(ngx.time() .. user)

local cache = redis:new()
cache:set_timeout(1000, 1000, 1000) -- 1sec
local ok, err = cache:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.ERR, "redis conn err")
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错"
    ngx.say(json.encode(rsp))
    return
end
local res, err = cache:set(user, token)
if not res then
    ngx.log(ngx.ERR, "token set err")
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错误"
    ngx.say(json.encode(rsp))
    return
end

-- 设置过期时间1h
cache:expire(user, 3600)
-- 登录信息存入mongo login_info表
local remote_addr = ngx.var.remote_addr -- 客户端ip
local remote_port = ngx.var.remote_port -- 客户端port
local uri = ngx.var.uri -- 客户端请求uri
local insert_time = ngx.time()
local insert_time_str = os.date("%Y-%m-%d %H:%M:%S")
local request_time = ngx.now() - ngx.req.start_time()

local h, err = ngx.req.get_headers()
local headers = ""
if type(h) == "table" then
    for k, v in pairs(h) do
        headers = headers .. k .. ": " .. v .. ";"
    end
end
local table_coll = db:get_col("login_info")
local doc = 
{
    ["user"]= user,
    ["insert_time"]= insert_time,
    ["insert_time_str"]= insert_time_str,
    ["uri"]= uri,
    ["remote_addr"]= remote_addr,
    ["remote_port"]= remote_port,
    ["request_time"]= request_time,
    ["headers"] = headers
}
local r, err = table_coll:insert({doc}) -- 插入格式 {{}}

ngx.log(ngx.ERR, "r:" .. tostring(r))
ngx.log(ngx.ERR, "err:" .. tostring(err))

ngx.log(ngx.ERR, "remote_addr:" .. remote_addr)
ngx.log(ngx.ERR, "remote_port:" .. remote_port)
ngx.log(ngx.ERR, "uri:" .. uri)
ngx.log(ngx.ERR, "insert_time:" .. insert_time)
ngx.log(ngx.ERR, "insert_time_str:" .. insert_time_str)
ngx.log(ngx.ERR, "request_time:" .. request_time)
ngx.log(ngx.ERR, "headers:" .. tostring(headers))

-- if not r then
--     rsp["code"] = 1
--     rsp["msg"] = "账号密码错误"
--     ngx.say(json.encode(rsp))
--     return
-- end


ngx.header["Set-Cookie"] = "token=" .. token
ngx.header["Set-Cookie"] = "user=" .. user
ngx.log(ngx.ERR, "user:" .. user .. ", token:" .. token)
rsp["code"] = 0
rsp["msg"] = "登陆成功"
ngx.say(json.encode(rsp))

