
package main

import (
	"fmt"
	"net/http"
	//"log"
)

// 定义路由-处理函数
type UrlSwitch map[string]http.Handler
var url_switch =  UrlSwitch{
	"/api/go/hello": SayHello(),
	"/api/go/log_info": LogInfo(),
	"/api/go/not_found": http.NotFoundHandler(),
	"/api/go/redirect": http.RedirectHandler("127.0.0.1:9090/api/go/hello", 307),
}

// 日志信息接口
func LogInfo() http.Handler {
	// 定义匿名闭包函数
	fn := func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		//fmt.Fprintln(w, r.Form) // 打印请求参数
		fmt.Println(r.Form) // 打印请求参数
		fmt.Println(w)
		w.Write([]byte("log_info\n"))
	}
	return http.HandlerFunc(fn)
}

// hello测试接口
func SayHello() http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello world\n"))
	}
	return http.HandlerFunc(fn)
}

func main()  {
	// ServrMux 本质上是一个 HTTP 请求路由器（或者叫多路复用器，Multiplexor）。
	// 它把收到的请求与一组预先定义的 URL 路径列表做对比，然后在匹配到路径的时候调用关联的处理器（Handler）。
	mux := http.NewServeMux()

	// 注册路由与处理函数
	for uri := range url_switch {
		mux.Handle(uri, url_switch[uri])
	}

	http.ListenAndServe("127.0.0.1:9090", mux)
	//log.Fatal(http.ListenAndServe("127.0.0.1:9090", mux)) // 设置监听端口与处理路由
}

