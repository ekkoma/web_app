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
    --ngx.log(ngx.ERR, "user:" .. user .. " password not right, db:" .. r["password"])
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

ngx.header["Set-Cookie"] = "token=" .. token
ngx.log(ngx.ERR, "user:" .. user .. ", token:" .. token)
rsp["code"] = 0
rsp["msg"] = "登陆成功"
ngx.say(json.encode(rsp))

