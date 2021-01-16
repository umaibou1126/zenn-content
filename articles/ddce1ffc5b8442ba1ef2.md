---
title: "【Docker/ECR/ECS】 コンテナ入門まとめ"
emoji: "🐷"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [AWS, Docker, ECS, ECR]
published: true
---
# 後編
- [Docker / ECR / ECS コンテナ入門まとめ②](https://qiita.com/umaibou1126/items/8d654b219bd8e0f05524)
- [Docker / ECR / ECS コンテナ入門まとめ③](https://qiita.com/umaibou1126/items/aee02db86c9ae9ea7359)

# 参考文献

- [AWS ECSでDockerコンテナ管理入門（基本的な使い方、Blue/Green Deployment、AutoScalingなどいろいろ試してみた）](https://qiita.com/uzresk/items/6acc90e80b0a79b961ce)
- [Dockerコマンド一覧](https://qiita.com/nimusukeroku/items/72bc48a8569a954c7aa2)
- [【備忘録】docker pushしたら拒否された](https://qiita.com/shundayo/items/4ae35930fe9f85f535b0)
- [ECS+ECR環境でDockerコンテナをデプロイする](https://qiita.com/furu8ma/items/6dcf596ee67780e8807f)
- [Dockerイメージの作り方](https://qiita.com/Kitanotori/items/c1cfe19fcd29f7b0746c)
- [【Docker】イメージ名とタグ名を変更する方法](【Docker】イメージ名とタグ名を変更する方法)
- [「Got permission denied while trying to connect to the Docker daemon socket」への対応](https://qiita.com/ashidaka/items/734856443f922ff175b1)
- [Amazon ECS における Docker の基本](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/docker-basics.html)
- [No space left on device とエラーが出るときの対処法](https://qiita.com/0x50/items/ecc6cfdbb8a3f0c0855f)
- [未使用のコンテナ、volumeなどを一括削除](https://qiita.com/reflet/items/5caa88abcf1e8964783a)

# Docker 基本コマンド

### イメージの取得
```
$ docker images [リポジトリ名]  ※リポジトリ名：DockerHubアカウントで作成

<例>
$ docker images username/sample
```

### タグ設定
```
$ docker tag [イメージ名]:タグ名 ユーザ名/[イメージ名]:タグ名

<例>
$ docker tag testimage:1.0 username/testimage:1.0
```

### DockerHubアップロード
```
$ docker login   ※DockerHubログイン

$ docker push ユーザ名/[イメージ名]:タグ名

<例>
$ docker push username/testimage:1.0
```

### コンテナ作成/起動
```
$ docker run [オプション] イメージ名[:タグ名] [引数]

<例>
$ docker run -it --name "sample" testimage /bin/bash
```

### 稼働中のコンテナに接続
```
$ docker attach コンテナ名

<例>
$ docker attach sample   ※プロセス終了:ctrl + P,Q
```

# AWS上でDockerを使用する場合

### Dockerインストール
```
$ sudo yum update -y

$ sudo amazon-linux-extras install docker
```

### Docker起動
```
$ sudo service docker start
         or
$ sudo systemctl start docker
```

### dockerグループにユーザ追加
```
$ sudo usermod -a -G docker ec2-user
```

### dockerアクセス確認
```
$ docker info
```

# "No space left on device" エラー対処

### ファイル数の消費量を表示
```
$ sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n
```

### 未使用のコンテナ/イメージ/ボリュームの一括削除
```
$　docker system prune -af --volumes
```

