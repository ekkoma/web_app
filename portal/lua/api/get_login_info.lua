local json = require "cjson"
local redis = require "resty.redis"
local mongo = require "resty.mongol"

local method = ngx.var.request_method
local user = ngx.var.cookie_user
local token = ngx.var.cookie_token

local rsp = 
{
    ["code"]= 0, 
    ["data"]= {}, 
    ["msg"]= ""
}

if method ~= "POST" then
    ngx.log(ngx.ERR, "request method :" .. method)
    rsp["code"] = 1
    rsp["msg"] = "method err"
    ngx.say(json.encode(rsp))
    return
end

ngx.req.read_body()
ngx.req.get_body_data() -- string




