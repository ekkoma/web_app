package api

import (
	"fmt"
	"net/http"
)
// 函数都放到这里处理

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
