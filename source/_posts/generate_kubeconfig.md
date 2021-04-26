---
title: 生成新的 kubeconfig
date: 2021-04-26
tags: 
    - kubernetes
    - golang
---

主要记录一下自己写的拼凑 kubeconfig 的脚本  
由于很难写成一个可定制化的东西, 当前先记录脚本按需求改改吧  

## 使用 SA 的 Token

``` bash
#!/usr/bin/env bash

# KUBECONFIG=you_kubeconfig ./generate_kubeconfig_with_sa.sh > new_kubecofnig

NAME=${NAME:-"readonly-kubeconfig"}
NAMESPACE=${NAMESPACE:-"default"}

kubectl apply -f - 1>&2 <<EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${NAME}
  namespace: ${NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${NAME}
rules:
- apiGroups:
  - "*"
  resources:
  - "*"
  verbs:
  - "get"
  - "list"
  - "watch"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${NAME}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${NAME}
subjects:
  - kind: ServiceAccount
    name: ${NAME}
    namespace: ${NAMESPACE}
---
EOF

SECRET_NAME="$(kubectl get sa -n ${NAMESPACE} ${NAME} -o 'jsonpath={$.secrets[0].name}')"
CA_CRT="$(kubectl get secret -n ${NAMESPACE} ${SECRET_NAME} -o 'jsonpath={$.data.ca\.crt}')"
TOKEN="$(kubectl get secret -n ${NAMESPACE} ${SECRET_NAME} -o 'jsonpath={$.data.token}' | base64 -D)"

APISERVER_ADDRESS=${APISERVER_ADDRESS:-"$(kubectl get cm -n kube-public cluster-info -o yaml | grep 'server: ' | sed 's/server: //' | sed 's/ *//g')"}

cat <<EOF
apiVersion: v1
kind: Config
current-context: ${NAME}
clusters:
- cluster:
    certificate-authority-data: ${CA_CRT}
    server: ${APISERVER_ADDRESS}
  name: ${NAME}
contexts:
- context:
    cluster: ${NAME}
    user: ${NAME}
  name: ${NAME}
users:
- name: ${NAME}
  user:
    token: ${TOKEN}
EOF
```


## 使用 CSR 签证书

``` bash
#!/usr/bin/env bash

# KUBECONFIG=you_kubeconfig ./generate_kubeconfig_with_csr.sh > new_kubecofnig

NAME=${NAME:-"readonly-kubeconfig"}

openssl genrsa -out "${NAME}.key" 2048
CSR="$(openssl req -new -key "${NAME}.key" -subj "/CN=${NAME}" | base64 | tr -d '\n')"

kubectl delete csr "${NAME}" 1>&2

kubectl apply -f - 1>&2 <<EOF
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${NAME}
rules:
- apiGroups:
  - "*"
  resources:
  - "*"
  verbs:
  - "get"
  - "list"
  - "watch"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${NAME}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${NAME}
subjects:
- kind: User
  name: ${NAME}
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${NAME}
spec:
  request: ${CSR}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
---
EOF

kubectl certificate approve "${NAME}" 1>&2

CA_CRT="$(kubectl get cm -n kube-public kube-root-ca.crt -o 'jsonpath={$.data.ca\.crt}' | base64 | tr -d '\n')"
CLIENT_CRT="$(kubectl get csr "${NAME}" -o jsonpath='{$.status.certificate}')"
CLIENT_KEY="$(cat ${NAME}.key | base64 | tr -d '\n')"

APISERVER_ADDRESS=${APISERVER_ADDRESS:-"$(kubectl get cm -n kube-public cluster-info -o yaml | grep 'server: ' | sed 's/server: //' | sed 's/ *//g')"}

cat <<EOF
apiVersion: v1
kind: Config
current-context: ${NAME}
clusters:
- cluster:
    certificate-authority-data: ${CA_CRT}
    server: ${APISERVER_ADDRESS}
  name: ${NAME}
contexts:
- context:
    cluster: ${NAME}
    user: ${NAME}
  name: ${NAME}
users:
- name: ${NAME}
  user:
    client-certificate-data: ${CLIENT_CRT}
    client-key-data: ${CLIENT_KEY}
EOF
```
生成 csr 的 -subj 的参数, CN 字段作为 User， O 字段作为 Group


## 使用 ca 私钥签证书

主体流程同上一个, 唯一不同的就是不再使用 k8s 的 CSR 资源签证书, 而是直接使用集群的 ca 私钥签. 对于权限需要较高, 不推荐使用.
