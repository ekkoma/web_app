
-- 简单waf, 未登录时，请求拒绝
local token = ngx.var.cookie_token
local uri = ngx.var.request_uri
local urls = ngx.shared.shared_pre_urls

if not token then
    local val, flags = urls:get(uri)
    if val then
        return
    else
        ngx.log(ngx.ERR, "============== not login, uir: " .. uri)
        ngx.exit(ngx.HTTP_BAD_REQUEST)
        return
    end
end
