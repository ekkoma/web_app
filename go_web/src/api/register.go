package api

import (
	//"fmt"
	"net/http"
)

// ------------------
// uri-handle_func注册
// ------------------

// 定义路由-处理函数
type UrlSwitch map[string]http.Handler
var url_switch =  UrlSwitch{
	"/api/go/hello": SayHello(),
	"/api/go/log_info": LogInfo(),
	"/api/go/not_found": http.NotFoundHandler(),
	"/api/go/redirect": http.RedirectHandler("127.0.0.1:9090/api/go/hello", 307),
}

// 注册路由与处理函数
func UriRegister(mux *http.ServeMux) int {
	for uri := range url_switch {
		mux.Handle(uri, url_switch[uri])
	}
	return 0
}
