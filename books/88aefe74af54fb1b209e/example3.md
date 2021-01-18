---
title: "【Docker/ECR/ECS】 コンテナ入門まとめ③"
---
# 前準備

#### ◆ Dockerインストール
```
$ sudo yum update -y

$ sudo amazon-linux-extras install docker
```

#### ◆ Docker起動
```
$ sudo systemctl start docker
```

#### ◆ dockerグループにユーザ追加
```
$ sudo usermod -a -G docker ec2-user
```

#### ◆ dockerアクセス確認
```
$ docker info
```

# ECR編

#### ◆ ECRログイン
```
$ aws ecr get-login --no-include-email  ※出力される長いコマンドでログイン
```

#### ◆ ECRリポジトリ作成
```
$ aws ecr create-repository --repository-name sample  ※リポジトリ名
```

#### ◆ 環境変数セット
```
$ export registryId=[出力されたレジストリId]
$ export region=ap-northeast-1 　※リージョン名
$ export imagename=sample
$ export tag=ver1
```

#### ◆ Dockerイメージ作成
```
$ docker build -t ${imagename}:${tag} .
```

#### ◆ Dockerイメージtag付け
```
$ docker tag ${imagename}:${tag} ${registryId}.dkr.ecr.${region}.amazonaws.com/${imagename}:${tag}
```

#### ◆ Dockerイメージプッシュ
```
$ docker push ${registryId}.dkr.ecr.${region}.amazonaws.com/${imagename}:${tag}
```


# ECS編

#### ◆ IAMロールの作成

- 「AmazonEC2ContainerServiceforEC2Role」ポリシーの付与

```:ecs-role
{
  "Version": "2020-5-23",
  "Statement": [
    {
      "Action": "ecs:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

#### ◆ クラスター作成コマンド
```
$ export region=us-east-1
$ export cluster=sample-cluster
$ aws ecs create-cluster --region ${region} --cluster-name ${cluster}
$ aws ecs list-clusters --region ${region} --output json
```

#### ◆ ec2作成
- AMI選択：ami-34ddbe5c
- IAMロール：上記のecs-roleを使用
- ユーザデータ：下記入力

```:userdata
#!/bin/bash
echo ECS_CLUSTER=[クラスター名] >> /etc/ecs/ecs.config
```

#### ◆ ECS/EC2紐付け確認
```
$ aws ecs list-container-instances --cluster ${cluster} --output json --region ${region}
$ ssh ec2-user@XX.XX.XX.XX    ※ec2ログイン
$ sudo docker ps
```

#### ECSタスク登録・実行

- 参照：[Amazon EC2 Container Service (ECS)を試してみた](https://dev.classmethod.jp/articles/ecs-ataglance/#return-note-126407-1)

```
$ vim sample.json
```

```sample.json
[
  {
    "environment": [],
    "name": "sample",
    "image": "sample-image",
    "cpu": 10,
    "portMappings": [],
    "entryPoint": [
      "/bin/sh"
    ],
    "memory": 10,
    "command": [
      "sample",
      "360"
    ],
    "essential": true
  }
]
```

##### ■ タスク登録コマンド
```
$ aws ecs register-task-definition --family sample --container-definitions file://sample.json --region ${region} --output json
```
##### ■ タスク確認
```
$ aws ecs list-task-definitions --region ${region}
```

##### ■ タスク実行コマンド
```
$ aws ecs run-task --cluster ${cluster} --task-definition sample:1 --count 1 --region ${region} --output json
```

##### ■ タスク実行確認
```
$ sudo docker ps
```

# 参考文献
- [AWS CLI で Amazon ECR に docker イメージを push する](https://qiita.com/aokad/items/17a06c2384041bd60d16)
- [Amazon EC2 Container Service (ECS)を試してみた](https://dev.classmethod.jp/articles/ecs-ataglance/#return-note-126407-1)
- [CircleCI+ECS+ECR環境でDockerコンテナのCD(継続的デプロイ)環境を構築する -前編-](https://dev.classmethod.jp/articles/circleci-ecr-ecs-1/)
- [CircleCI+ECS+ECR環境でDockerコンテナのCD(継続的デプロイ)環境を構築する -後編-](https://dev.classmethod.jp/articles/httpdev-classmethod-jpcloudcircleci-ecr-ecs-2/)
