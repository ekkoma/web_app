local args = ngx.req.get_uri_args()
local headers = ngx.get_req_header()

ngx.log(ngx.ERR, "args:",args)
ngx.log(ngx.ERR, "headers:", args)
ngx.say("prematch")
