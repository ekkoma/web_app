local json = require "cjson"
local mongo = require "resty.mongol"

ngx.header['Content-Type'] = 'application/json; charset=utf-8'
local rsp = 
{
    ["code"]= 0, 
    ["data"]= {}, 
    ["msg"]= ""
}

local conn = mongo:new()
conn:set_timeout(1000)
local ok, err = conn:connect("127.0.0.1", 27017)
if not ok then
    ngx.log(ngx.ERR, "connect mongo err" .. err)
    rsp["code"] = 1
    rsp["msg"] = "服务器内部错误"
    ngx.say(json.encode(rsp))
end

local pwd = "000000"
local user = "桂万利"
local db = conn:new_db_handle("web")
local coll = db:get_col("user")
local r = coll:find_one({name=user}, {password=1})

if r["password"] ~= pwd then
    ngx.log(ngx.ERR, "user:" .. user .. " password not right, db:" .. r["password"] .. " input:" .. pwd)
    rsp["code"] = 1
    rsp["msg"] = "账号密码错误"
    ngx.say(json.encode(rsp))
end

rsp["data"] = {["name"]=user, ["pwd"]=pwd}
ngx.say(json.encode(rsp))
