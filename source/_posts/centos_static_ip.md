---
title: CentOS 静态 ip
date: 2021-01-14
tags: 
    - linux
    - operation
    - ip
    - note
---

## CentOS 7 静态 ip 配置
```
# cat /etc/sysconfig/network-scripts/ifcfg-ens192
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static # 这个标志着使用静态 ip
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens192
UUID=0e999030-a255-4221-a06e-2a6fd6677419 # 不同机子uuid一样(虚拟机克隆) 会互相顶掉, 可以用 uuidgen 重新生成
DEVICE=ens192
ONBOOT=yes
GATEWAY=10.7.0.1 # 网关
IPADDR=10.7.111.13 # ip
PREFIX=16 # 掩码位数
DNS1=114.114.114.114
ZONE=public
```