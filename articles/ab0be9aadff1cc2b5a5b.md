---
title: "【Kubernetes】入門したので簡潔にまとめてみた"
emoji: "🔖"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Docker, Kubernetes, AWS]
published: true
---
## 【1】 マニフェストファイル（AP）

#### ◆ Pod

 - Pod作成時```ContainerCreating```の場合```$ kubectl describe pod [Pod名]```で確認

```pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: sample-app
  namespace: default
  labels:
    app: test
    type: application
spec:
  containers:
    - name: sample-app
      image: sample-app:v1.0
    command:
      - /bin/bash
    args:
      - -c
      - rails db:migrate && rails server
```

#### ◆ Service

```service.yml
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  ports:
  - port: 3000
    targetPort: 3000
```

#### ◆ Deployment

```Deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment
spec:
  selector:
    matchLabels:   #templateのlabelと一致させる
      app: test
    replicas: 2
  strategy:
    rollingUpdate:   #基本はRollingUpdate一択
      maxSurge: 1
      maxUnavailable: 1
  revesionHistoryLimit: 12   #ReplicaSetの履歴保存数
    template:
      metadata:
        labels:   #5行上のmatchLabelsと一致させる
          app: test
      spec:
        containers:
        - name: sample-app
          image: sample-app:v1.0
          ports:
          - containerPort: 3000
```

#### ◆ ConfigMap

```configmap.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config   #configMapKeyRefで使用
data:
  sample.cfg: |
    username: test   #configMapKeyRefで使用

---

apiVersion: v1
kind: Pod
metadata:
  name: sample
spec:
  containers:
  - name: sample-app
    image: sample-app:v1.0
    env:
    - name: TYPE
      valueFrom:
        configMapKeyRef:
          name: config     #上記configMapのmetadata参照
          key: username    #上記configMapのdataプロパティ参照
```

#### ◆ Ingress

```ingress.yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: sample
spec:
  rules:
  - http:
      paths:
      - path: /   #どのパスにリダイレクトするか設定
        backend:
          serviceName: sample   #Serviceマニフェストのmetadata参照
          servicePort: 80
```

## 【2】 マニフェストファイル（DB）

#### ◆ Pod
```pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: sample-db
spec:
  containers:
    - name: postgresql
      image: sample-db:v1.0
　　　 volumeMounts:
        - mountPath: "/var/lib/postgresql/data"
          name: db
  volumes:
    - name: db
      persistentVolumeClaim:
        claimName: sample-pvc
```

#### ◆ PersistentVolume    PersistentVolumeClaim
```pv-pvc.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sample-pv
spec:
  capacity:                   #ストレージ容量
    storage: 1Gi
  accessModes:
  - ReadWriteMany              #他はReadWriteOnce, ReadOnlyMany
  storageClassName: standard   #ストレージの種類
  hostpath:
    path: "/tmp"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sample-pvc
spec:
  accessModes:
    - ReadWriteMany            #他はReadWriteOnce, ReadOnlyMany
  resources:
    requests:
      storage: 1Gi             #ストレージ容量
  storageClassName: standard   #ストレージの種類
```




## 【3】 pod操作

##### ◆ pod作成

```
$ kubectl apply -f pod.yml
```

##### ◆ pod一覧確認
```
$ kubectl get pod
NAME    READY     STATUS    RESTARTS   AGE
sample    1/1       Running    0         3s
```

##### ◆ pod削除
```
$ kubectl delete pod sample
$ kubectl delete -f pod.yml
```

##### ◆ podログイン
```
$ kubectl exec -it sample sh
```

##### ◆ podとのファイル転送
```
$ kubectl cp sample:/root/hello.txt ./hello.txt
```

##### ◆ pod詳細表示
```
$ kubectl describe pod/sample
```

##### ◆ podログ確認
```
$ kubectl logs pod/sample
```

##### ◆ IPアドレス確認
```
$ kubectl get pod -o wide
```

## 【4】 kubectlインストール

```
$ brew install kubectl
$ brew install kubernetes-cli
$ kubectl version --client
```





# 参考文献
 - [kubectlのインストールおよびセットアップ](https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/)
 - [kubernetes : kubectlコマンド一覧](https://qiita.com/suzukihi724/items/241f7241d297a2d4a55c)
 - [kubernetesクラスタでRailsアプリを公開するチュートリアル](https://qiita.com/tatsurou313/items/223dfa599ee5aaf6b2f0)
 - [Kubernetesオブジェクトを理解する](https://kubernetes.io/ja/docs/concepts/overview/working-with-objects/kubernetes-objects/)
 - [コピペだけでRailsをKubernetes上で最速で動かすためのガイド。GCP、AWS依存なしでDockerイメージ作成から始める。](https://qiita.com/ttiger55/items/215cab36da848fba156b)
 - [kubernetesのConfigMapを理解する](https://qiita.com/oguogura/items/68741b91b70962081504)
