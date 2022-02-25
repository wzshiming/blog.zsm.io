---
title: Ferry - kubernetes 跨集群通信组件
date: 2022-02-25
tags: 
    - tools
    - kubernetes
    - golang
---

## Ferry 是什么呢

Ferry 是为 Kubernetes 开发的一个多集群通信组件

Ferry 可以支持将一个集群的 Service 映射到另一个集群

## 快速开始

准备至少两个集群, 可以是一个节点的集群或者 Kind 起的集群, 但最少也要两个才能做演示
### 下载 ferryctl (ferry 安装运维工具)

https://github.com/ferry-proxy/ferryctl/releases

为每个集群的控制节点都安装一个 ferryctl
### 初始化控制面集群
#### 在控制面集群执行
``` bash
ferryctl control-plane init
```

### 其他数据面集群加入
#### 在控制面集群执行

控制面集群可以连接到这个集群

```
ferryctl control-plane pre-join direct 其他数据面集群名
```
或

控制面集群不可连接到这个集群
```
ferryctl control-plane pre-join tunnel 其他数据面集群名
```

其他数据面集群名: 可以随意定但是后续规则里使用同样的就可以了

### 在数据面集群执行
上一个命令执行后, 会响应一个命令复制到数据面集群执行



### 在控制面集群执行
上一个命令执行后, 会响应一个命令复制到控制面集群执行

### 规则配置

测试应用需要提前部署并配置 Service

在控制面集群配置 Ferry 的规则
``` yaml
# 映射 cluster-1 带 labels app=web-1 的 service 映射到 control-plane 同名 service
apiVersion: ferry.zsm.io/v1alpha1
kind: FerryPolicy
metadata:
  name: ferry-test
  namespace: ferry-system
spec:
  rules:
    - exports:
        - clusterName: cluster-1
          match:
            labels:
              app: web-1
      imports:
        - clusterName: control-plane
```


``` yaml
# 映射 cluster-1 的 web-1.test.svc 映射到 control-plane 的 xxx-1.default.svc
apiVersion: ferry.zsm.io/v1alpha1
kind: FerryPolicy
metadata:
  name: ferry-test
  namespace: ferry-system
spec:
  rules:
    - exports:
        - clusterName: cluster-1
          match:
            namespace: test
            name: web-1
      imports:
        - clusterName: control-plane
          match:
            namespace: default
            name: xxx-1
```

