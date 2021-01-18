---
title: "【Docker/ECR/ECS】 コンテナ入門まとめ②"
---
# 1. Dockerfile

### ◆ mysql-client問題

- Debian10 "buster"(Ubuntuの母らしい)では、"mysql-client"は存在しない
- "default-mysql-client"パッケージを使用する必要がある

```:Dockerfile
FROM ruby:2.6.5    ※GemfileのRubyバージョン要確認
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y default-mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /app   ※アプリケーション名
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app
```




# 2. docker-compose.yml
### ◆ ビルドコンテキストについて
- docker build実行時の"カレントディレクトリ"を指定する
- デフォルトでは、Dockerfileが"カレントディレクトリ"と認識される

```docker-compose.yml
version: '2'
services:
  db:
    image: mysql:latest
    environment:
      MYSQL_DATABASE: データベース名
      MYSQL_ROOT_PASSWORD: XXXXXXX
      MYSQL_USER: ユーザ名
      MYSQL_PASSWORD: XXXXXXX
    ports:
      - "3306:3306"
  web:
    build:
      context: .
      dockerfile: Dockerfile
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    tty: true
    stdin_open: true
    depends_on:
      - db
    ports:
      - "3000:3000"
    volumes:　　
      - .:/app   ※アプリケーション名
 ```

# 3. database.yml
### ◆ 環境変数について
```
 password: <%= ENV['DOCKER_DATABASE_PASSWORD'] %>
```
```
$ export DOCKER_DATABASE_PASSWORD=password  ※パスワード
```


### database.yml
```database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  host: db

development:
  <<: *default
  username: ユーザ名
  password: XXXXXXX
  database: データベース名

production:
  <<: *default
  database: データベース名
  username: ユーザ名
  password: <%= ENV['DOCKER_DATABASE_PASSWORD'] %>
```








# 4. ECRプッシュ作業

### AWS CLI設定    ※AWSマネジメントコンソール"マイセキュリティ資格情報"参照
```
$ aws configure --profile ecr
AWS Access Key ID [None]: ***********************
AWS Secret Access Key [None]: *************************
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

### ECRログインコマンド
```
$ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ***.ecr.ap-northeast-1.amazonaws.com
```

### イメージ作成
```
$ docker build -t 【イメージ名】 .
```

### タグ付け
```
$ docker tag イメージ名:タグ名 ***.dkr.ecr.ap-northeast-1.amazonaws.com/イメージ名:タグ名
```

### プッシュコマンド
```
$ docker push ***.dkr.ecr.ap-northeast-1.amazonaws.com/イメージ名:タグ名
```

# 参考文献
- [【AWS】初めてのECR](https://qiita.com/3utama/items/b19e2239edb6996a735f)
- [イメージのプッシュ](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)
- [AWS CLI の設定](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-configure.html)
- [既存のRailsアプリにDockerを導入する手順](https://qiita.com/kenzoukenzou104809/items/b9e716204e0cd0cea447)
- [既存のrailsプロジェクトをDockerで開発する手順](https://qiita.com/kkyouhei/items/653760627bf9d4bc9e71)
- [Debianのdockerイメージでmysql-clientが無くてハマった人へ](https://qiita.com/henrich/items/1b7ee2f3a72f8bb29cba)
- [Dockerfile 記述のベストプラクティス](https://matsuand.github.io/docs.docker.jp.onthefly/develop/develop-images/dockerfile_best-practices/)
- [database.yml の管理方法いろいろ](https://www.techscore.com/blog/2012/10/26/how-to-manage-database-yml/)
