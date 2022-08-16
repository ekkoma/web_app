local json = require "cjson"
local redis = require "resty.redis"
local mongo = require "resty.mongol"

local method = ngx.var.request_method
-- local user = ngx.var.cookie_user
-- local token = ngx.var.cookie_token
-- local http_cookie = ngx.var.http_cookie
-- headers = ngx.req.get_headers()
-- ngx.log(ngx.ERR, "================")
-- ngx.log(ngx.ERR, method, " ", headers.cookie)
-- ngx.log(ngx.ERR, "================")

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

-- ngx.req.read_body()
-- ngx.req.get_body_data() -- string

function print_table(tb)
    tb_str = ""
    if type(tb) ~= "table" then
        return tb_str
    end
    for k, v in pairs(tb) do
        ngx.log(ngx.ERR, "=========== k:", tostring(k))
        ngx.log(ngx.ERR, "=========== v:", tostring(v))
    end
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
local coll = db:get_col("login_info")

-- https://github.com/bigplum/lua-resty-mongol
-- ####cursor = col:find(query, returnfields, num_each_query) Returns a cursor object for excuting query.
-- returnfields is the fields to return, eg: {n=0} or {n=1}
-- num_each_query is the max result number for each query of the cursor to avoid fetch a large result in memory, must larger than 1, 0 for no limit, default to 100.
local cursor = coll:find({}, {insert_time=1, remote_addr=1, remote_port=1, user=1, insert_time_str=1, headers=1}, 100)

-- ###Cursor objects
-- ####index, item = cursor:next() Returns the next item and advances the cursor.
-- ####cursor:pairs() A handy wrapper around cursor:next() that works in a generic for loop:
-- 	for index, item in cursor:pairs() do
-- ####cursor:limit(n) Limits the number of results returned.
-- ####result = cursor:sort(field, size) Returns an array with size size sorted by given field.
-- field is an array by which to sort, and this array size MUST be 1. The element in the array has as key the field name, and as value either 1 for ascending sort, or -1 for descending sort.
-- num is the temp array size for sorting, default to 10000.

if not cursor then
    rsp["code"] = 1
    rsp["msg"] = "server error"
    ngx.say(json.encode(rsp))
    return
end

data = {}
for index, item in cursor:pairs() do
    -- index: number
    -- item: table
    info = {}
    info["login_user"] = item["user"]
    info["client_addr"] = item["remote_addr"]
    info["client_port"] = item["remote_port"]
    info["insert_time"] = item["insert_time_str"]
    info["request_headers"] = item["headers"]
    -- 空表判断，否则table.insert插入会报错
    if next(data) == nil then
        data = {info}
    else
        table.insert(data, info)
    end
end

-- 返回值
-- {
--     "code":0,
--     "msg":"",
--     "data":[
--         {},
--         {}
--     ]
-- }
rsp["data"] = data
ngx.say(json.encode(rsp))

