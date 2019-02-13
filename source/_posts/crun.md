---
title: Crun
date: 2019-02-13
tags: 
    - tools
---

## 生成密码字典
用处很简单就是根据规则生成密码
但是使用十分麻烦
``` bash
# 生成 最小为1,最大为6 在abcdefg中所有可能的组合
crunch 1 6 abcdefg

# 调用密码库 charset.lst， 生成最小为1，最大为8 所有可能的组合
crunch 1 8 -f charset.lst mixalpha-numeric-all-space
```
我第一想法为什么不能用 正则生成字典
谷歌度娘找了一圈可能真的没有
没有那就自己写一个呗

## 根据正则生成密码字典
用golang写的 支持直接输入正则
[![GitHub stars](https://img.shields.io/github/stars/wzshiming/crun.svg?style=social&label=Star)github.com/wzshiming/crun](https://github.com/wzshiming/crun)

``` bash
# 生成 1到6位长度的数字所有可能性组合
crun "\d{1,6}"

# 输出到 ditc.txt 文件
crun "\d{1,6}" > ditc.txt

# 暴力美学
crun "(root|admin):[0-9]{4,10}"

# !!!!! 注意如果量太大会超卡的
```

### 安装
``` bash
# 依赖 golang 和 git

# 设置环境变量 如果已经设置 请忽略
mkdir -p $HOME/gopath
export GOPATH=$HOME/gopath
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH

# 下载&&安装
go get -u -v github.com/wzshiming/crun/cmd/crun
```