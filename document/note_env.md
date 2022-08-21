
#### 1.环境变量修改
> /etc/profile 文件尾添加：
```
# java jdk kafka zookeeper依赖
JAVA_HOME=/opt/jdk1.8/jdk-18.0.2
CLASSPATH=$JAVA_HOME/lib
PATH=$PATH:$JAVA_HOME/bin
export PATH JAVA_HOME CLASSPATH
export GO111MODULE=auto #自动获取依赖项
export GOPROXY=https://goproxy.cn #设置代理,指向通的镜像源
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:
export GOPATH=/web_server/go_web # go项目目录
>
# 修改命令提示行
> export PS1='[\[\e[36;1m\]\u@ip[\e[32;1m\]\[\e[31;1m\] \t\[\e[36;1m\]\w\[\e[0m\]]# '
> >source /etc/profile
```
```
# /etc/profile  /etc/bashrc  ~/.bash_profile  ~/.bashrc 当新session打开时，执行顺序：
1.执行/etc/profile  --所有用户
2.在步骤1中会执行. /etc/bashrc  --所有用户
3.根据不同登录用户执行~/.bash_profile  --登录用户
4.在步骤3中会执行. ~/.bashrc  --登录用户
```

#### 2.修改history格式，软硬件资源限制
> /root/.bashrc 文件尾添加：
```
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  `whoami`@${USER_IP}: "
ulimit -HSc unlimited
ulimit -HSn 65535
```

#### 3.go下载安装
```
下载go：https://golang.google.cn/dl/go1.16.5.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.16.5.linux-amd64.tar.gz
修改/etc/profile
export PATH=$PATH:/usr/local/go/bin
```
