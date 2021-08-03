---
title: Containerd 安装
date: 2021-08-03
tags: 
    - linux
    - operation
    - containerd
    - note
---

## Containerd  安装

``` bash
VERSION=1.5.4
wget -c https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-amd64.tar.gz
tar xvf containerd-${VERSION}-linux-amd64.tar.gz -C /usr/local/
mkdir /etc/containerd/ && containerd config default > /etc/containerd/config.toml
wget -c -O /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
systemctl start containerd
```

## Nerdctl 安装

``` bash
VERSION=0.11.0
wget -c https://github.com/containerd/nerdctl/releases/download/v${VERSION}/nerdctl-full-${VERSION}-linux-amd64.tar.gz
tar xvf nerdctl-full-${VERSION}-linux-amd64.tar.gz -C /usr/local/
```
