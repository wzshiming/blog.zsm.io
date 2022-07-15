---
title: Ferry - kubernetes 跨集群通信组件
date: 2022-02-25
tags: 
    - tools
    - kubernetes
    - golang
---

## Ferry 是什么呢

官网 https://ferryproxy.io/

源码地址 https://github.com/ferryproxy/ferry

Ferry 是为 Kubernetes 开发的一个多集群通信组件

Ferry 可以支持将一个集群的 Service 映射到另一个集群

## 快速开始


# 快速开始

准备至少两个集群才能做演示

可以是一个节点的集群或者 Kind 起的集群但最少也要两个

## 下载 ferryctl

ferryctl 是 ferry 的安装运维工具

需要为每个集群的控制节点都安装一个 ferryctl

https://github.com/ferryproxy/ferry/releases

## 初始化控制面集群

``` bash
# 在控制面集群执行
ferryctl control-plane init
```

## 向控制面声明哪个数据面需要加入

``` bash
# 在控制平面执行，预连接其他数据平面
ferryctl control-plane join cluster-1
```

## 数据面做好被控制面管控的准备

上一个命令执行后, 会响应一个命令复制到数据面集群执行

## 控制面开始管控数据面

上一个命令执行后, 会响应一个命令复制到控制面集群执行

## 规则配置

测试应用需要提前部署并配置 Service

在控制面集群配置路由规则

``` yaml
# 映射 cluster-1 的 app-1.default.svc 映射到 control-plane 的 app-1.default.svc
apiVersion: traffic.ferryproxy.io/v1alpha2
kind: RoutePolicy
metadata:
  name: ferry-rule
  namespace: ferry-system
spec:
  exports:
    - hubName: cluster-1
      service:
        namespace: default
        name: app-1
  imports:
    - hubName: control-plane
      service:
        namespace: default
        name: app-1
```

