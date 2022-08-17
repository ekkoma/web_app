package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: %s [command]\n", os.Args[0])
		os.Exit(1)
	}

	// 检查可执行文件是否存在
	cmdName := os.Args[1]
	base_path := filepath.Base(cmdName)
	if base_path == cmdName {
		if lp, err := exec.LookPath(os.Args[1]); err != nil {
			fmt.Println("look path err:", err)
			os.Exit(2)
		} else {
			cmdName = lp
		}
	}

	cwd, err := os.Getwd()
	if err != nil {
		fmt.Println("getwd err:", err)
		os.Exit(3)
	}

	procAttr := &os.ProcAttr {
		Files: []*os.File{os.Stdin, os.Stdout, os.Stderr},
	}

	// 启动子进程
	process, err := os.StartProcess(cmdName, []string{cwd}, procAttr)
	if err != nil {
		fmt.Println("start process err:", process, err)
		os.Exit(4)
	}

	// state, err := process.Wait()
	// if err != nil {
	// 	fmt.Println("wait err:", err)
	// 	os.Exit(5)
	// }
	time.Sleep(2)
	//fmt.Println("state:", state)
	// 主进程退出
	os.Exit(0)
}
