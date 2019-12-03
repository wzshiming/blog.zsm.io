---
title: Bridge
date: 2019-12-03
tags: 
    - tools
    - golang
---

# Bridge - TCP 桥

[![GitHub stars](https://img.shields.io/github/stars/wzshiming/bridge.svg?style=social&label=Star)github.com/wzshiming/bridge](https://github.com/wzshiming/bridge)

由于经常要 ssh 连接不同的服务器需要经过跳板机 
ssh 的 ProxyCommand 使用不同协议使用不用的工具不同的语法格式
在多级代理上甚至不知道如何配置非常麻烦

写这个的初衷就是简化 ssh ProxyCommand 后面的命令格式以统一的格式处理不用的代理协议
后续发现可以写成一个通用的 tcp 代理

在监听端口的功能,一开始只支持 ssh ProxyCommand 的方式,使用 STDIO 和 ssh 通信
后面加上监听本地端口,甚至可以监听 ssh 服务器上的端口

## 支持的协议
- http(s)-connect 拨号
- socks4/4a 拨号
- socks5/5h 拨号
- ssh 拨号 & 监听

## 用法

### 各种协议的代理

``` bash
bridge -b :8080 -p github.io:80 -p ssh://username:password@my_server:22
bridge -b :8080 -p github.io:80 -p ssh://username@my_server:22?identity_file=~/.ssh/id_rsa
bridge -b :8080 -p github.io:80 -p socks5://username:password@my_server:1080
bridge -b :8080 -p github.io:80 -p http://username:password@my_server:8080
```

### 多级代理

``` bash
bridge -b :8080 -p github.io:80 -p http://username:password@my_server2:8080 -p http://username:password@my_server1:8080

```

### 监听 ssh 端口
也可以通过 ssh 监听端口 本地的端口映射到服务器的端口  
由于 sshd 的限制只能监听 127.0.0.1 的端口  
如果想提供对外的服务需要把 /etc/ssh/sshd_config 里的 GatewayPorts no 改成 yes 然后重新加载 sshd  

``` bash
bridge -b :8080 -b ssh://username:password@my_server:22 -p 127.0.0.1:80
```

### 用作 ssh 代理
更多的时候我是用作 ssh 代理的  
在 ~/.ssh/config  

``` text
ProxyCommand bridge -p %h:%p -p "ssh://username@my_server?identity_file=~/.ssh/id_rsa"
```

## 安装
``` bash
# 安装
go get -v github.com/wzshiming/bridge/cmd/bridge
```