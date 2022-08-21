
package main

import (
	//"fmt"
	"net/http"
	"api"
	"time"
	//"log"
)

func main()  {
	// ServrMux 本质上是一个 HTTP 请求路由器（或者叫多路复用器，Multiplexor）。
	// 它把收到的请求与一组预先定义的 URL 路径列表做对比，然后在匹配到路径的时候调用关联的处理器（Handler）。
	// 函数原型：func NewServeMux() *ServeMux
	mux := http.NewServeMux()

	// 注册路由与处理函数
	api.UriRegister(mux)

	// More control over the server's behavior is available by creating a custom Server:
	s := &http.Server{
		Addr: "127.0.0.1:9090", // Addr string
		Handler: mux, // Handler Handler // handler to invoke, http.DefaultServeMux if nil
		ReadTimeout: 10 * time.Second, // ReadTimeout time.Duration
		WriteTimeout: 10 * time.Second, // time.Duration
		MaxHeaderBytes: 1 << 20, // MaxHeaderBytes int
	}
	s.ListenAndServe()
	//log.Fatal(http.ListenAndServe("127.0.0.1:9090", mux)) // 设置监听端口与处理路由
}

