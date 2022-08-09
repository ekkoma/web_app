
require "resty.core.shdict"
local urls = ngx.shared.shared_pre_urls
local num = urls:capacity()   --number
local keys = urls:get_keys()  --table

ngx.say("num type :" .. type(num))
ngx.say(num)
ngx.say("keys type :" .. type(keys))
ngx.say(keys)
