local json = require "cjson"
local redis = require "resty.redis"

local cache = redis:new()
cache:set_timeout(1000, 1000, 1000) -- 1sec
local ok, err = cache:connect("127.0.0.1", 6379)

ngx.header['Content-Type'] = 'application/json; charset=utf-8'
local rsp = 
{
    ["code"]= 0, 
    ["data"]= {}, 
    ["msg"]= ""
}

if not ok then
    ngx.log(ngx.ERR, "redis conn err")
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错"
    ngx.say(json.encode(rsp))
    return
end

user = "桂万利"
token = ngx.md5(ngx.time() .. user)
local res, err = cache:set(user, token)
if not res then
    ngx.log(ngx.ERR, "token set err")
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错"
    ngx.say(json.encode(rsp))
    return
end

ngx.header["Set-Cookie"] = "token=" .. token
local res, err = cache:get(user)
rsp["data"] = {["value"]=res}
ngx.say(json.encode(rsp))
