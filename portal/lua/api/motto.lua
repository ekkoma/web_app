local json = require "cjson"
local redis = require "resty.redis"
local mongo = require "resty.mongol"

local method = ngx.var.request_method
-- local user = ngx.var.cookie_user
-- local token = ngx.var.cookie_token

local motto = {
    "对待生命，不妨大胆一点，因为我们终将失去它。-尼采",
    "人生自是有情痴，此恨不关风与月。-欧阳修",
    "君不见，黄河之水天上来，奔流到海不复回。-李白",
    "岑夫子，丹丘生，将进酒，杯莫停。-李白",
    "前不见古人，后不见来者。念天地之悠悠，独怆然而涕下。-陈子昂",
    "我曾踏足山巅，也曾进入低谷，二者都让我受益良多 -塔里克",
    "树叶的一生，只是为了归根吗？-亚索",
    "真正的大师，永远都怀着一颗学徒的心 -易",
    "世间万物中，表里如一者，又有几个？ -婕拉",
    "我发现勇气根本靠不住，只有完全的疯狂才有意义 -克烈",
    "凝视深渊过久，深渊将回以凝视 -尼采",
    "杀不死我的，只会让我更坚强。-尼采",
    "白昼之光，岂知夜色之深。-尼采"
}

local rsp = 
{
    ["code"]= 0, 
    ["data"]= {}, 
    ["msg"]= ""
}

-- 请求方法判断
if method ~= "POST" then
    ngx.log(ngx.ERR, "request method :" .. method)
    rsp["code"] = 1
    rsp["msg"] = "method err"
    ngx.say(json.encode(rsp))
    return
end

-- 鉴权
-- local cache = redis:new()
-- cache:set_timeout(1000, 1000, 1000) -- 1sec
-- local ok, err = cache:connect("127.0.0.1", 6379)
-- if not ok then
--     ngx.log(ngx.ERR, "redis conn err")
--     rsp["code"] = 1
--     rsp["msg"] = "服务器内部错"
--     ngx.say(json.encode(rsp))
--     return
-- end
-- local res, err = cache:get(user)
-- if not res then
--     ngx.log(ngx.ERR, "user get err")
--     rsp["code"] = 1
--     rsp["msg"] = "user error"
--     ngx.say(json.encode(rsp))
--     return
-- end
-- if res ~= token then
--     ngx.log(ngx.ERR, "token err, res:" .. res .. " token:" .. token)
--     rsp["code"] = 1
--     rsp["msg"] = "token error"
--     ngx.say(json.encode(rsp))
--     return
-- end

-- 随机获取一条信息
math.randomseed(os.time())
local motto_str = motto[math.random(1, #motto)]

rsp["data"] = motto_str
ngx.say(json.encode(rsp))
return
