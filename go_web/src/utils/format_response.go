package utils

import (
	"encoding/json"
	"fmt"
	"os"
)

// 定义json结构
type TestJson struct {
	Name string `json:"name"`
	Tags []string `json:"tags"`
	Id int64 `json:"id"`
}

// 解析请求体
func parseReq() {
	// todo
	return
}

// 构造响应体
func MakeResponse() {
	json_data := []byte(`{
		"name": "ekko",
		"tags": ["aaa", "bbb"],
		"id": 100
	}`)

	var test_json TestJson
	err := json.Unmarshal(json_data, &test_json)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(test_json)
	fmt.Printf("%T",test_json)
	fmt.Println(test_json.Name)

	test_json.Tags = []string{
		"ccc",
		"ddd"}

	b, err := json.Marshal(test_json)
	if err != nil{
		fmt.Println("err:", err)
	}
	return b
}

