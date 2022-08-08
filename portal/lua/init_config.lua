
-- login 前可调用接口
local pre_urls = {
    ["/login"] = 1,
    ["/hello"] = 1,
    ["/mongo"] = 1,
}

-- login 后才可调用接口
-- post_login_urls = {
-- }
ngx.log(ngx.ERR, "=======================================init")
local shared_urls = ngx.shared.shared_pre_urls
for k, v in pairs(pre_urls) do
    ngx.log(ngx.ERR, "=== k: " .. k .. " v :" .. v)
    local succ, err, forcible = shared_urls:set(k, v)
    ngx.log(ngx.ERR, "===", succ, err, forcible)
end

local keys = shared_urls:get_keys()
for k, v in pairs(keys) do
    ngx.log(ngx.ERR, "============== v:" .. v)
    local val, flags = shared_urls:get(v)
    ngx.log(ngx.ERR, "============== val:" .. val)
end
