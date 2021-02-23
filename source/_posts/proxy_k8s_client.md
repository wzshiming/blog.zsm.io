---
title: 在本地使用远端的 docker 和 k8s
date: 2021-01-26
tags: 
    - tools
    - proxy
---

## 工具

https://github.com/wzshiming/bridge

## Docker 连接代理
``` shell
# 代理远端的 docker 到本地的 2376 端口
bridge -b 'tcp://127.0.0.1:2376' -p 'unix:///var/run/docker.sock' -p nc: -p 'ssh://root@hostname?identity_file=~/.ssh/id_rsa'
```

``` shell
# 设置环境变量, 新开终端执行 docker 命令
DOCKER_HOST=tcp://127.0.0.1:2376 docker ps
```

## k8s 连接代理
``` shell
# 代理远端的 k8s 到本地的 8000 端口
bridge -b 'tcp://127.0.0.1:8000' -p - -p 'ssh://root@hostname?identity_file=~/.ssh/id_rsa'
```

``` shell
# 设置环境变量, 新开终端执行 kubectl 命令
ALL_PROXY=127.0.0.1:8000 kubectl get node
```
