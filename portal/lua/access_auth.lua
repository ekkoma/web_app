
-- 简单waf, 未登录时，请求拒绝
local token = ngx.var.cookie_token
local uri = ngx.var.request_uri
local urls = ngx.shared.shared_pre_urls

ngx.log(ngx.ERR, "token :" .. tostring(token))
ngx.log(ngx.ERR, "uri :" .. uri)

local keys = urls:get_keys()
for k, v in pairs(keys) do
    ngx.log(ngx.ERR, "============== k:" .. k)
    ngx.log(ngx.ERR, "============== v:" .. v)
end

if not token then
    local val, flags = urls:get(uri)
    if val then
        ngx.log(ngx.ERR, "============== ok")
        return
    else
        ngx.log(ngx.ERR, "============== error")
        ngx.exit(ngx.HTTP_BAD_REQUEST)
        return
    end
end

ngx.log(ngx.ERR, "============== has token")

