---
title: "ECS自動デプロイ - Docker編 -"
---

## ツリー図

```:docker/dev
├── app
│   ├── Dockerfile
│   ├── nginx
│   │   ├── app.conf
│   │   └── nginx.conf
│   └── supervisor
│       ├── app.conf
│       └── supervisord.conf
├── db
│   ├── data
│   └── mysql_init
```

## Dockerコマンド

##### ◆ dockerコンテナ削除
```
$ docker rm -f `docker ps -a -q`
```

##### ◆ dockerイメージ削除
```
$ docker rmi `docker images -q`
```

##### ◆ dockerイメージ作成
```
$ docker build -f docker/dev/app/Dockerfile -t sample_dev .
```

##### ◆ ECRプッシュコマンド
```
$ docker tag XXXXXX sample/dev  //Docker hubリポジトリ
$ docker images
$ docker push sample/dev
$ docker tag sample/dev:latest XXXXXX.dkr.ecr.XXXXXX.amazonaws.com/ecs-sample:latest
$ docker push XXXXXX.dkr.ecr.XXXXXX.amazonaws.com/ecs-sample:latest
```

##### ◆ dockerコンテナ内実行コマンド
```
$ bundle install
$ bundle exec rake db:create db:migrate

// supervisor起動
$ /usr/bin/supervisorctl restart app

// production用データベース作成
$ bundle exec rails db:migrate RAILS_ENV=production

// アセットプリコンパイル
$ bundle exec rake assets:precompile RAILS_ENV=production
```

##### ◆ database.ymlコマンド
```
$ export RAILS_DATABASE_USERNAME=test
$ export RAILS_DATABASE_PASSWORD=password
$ export RAILS_DATABASE_HOST=rds.XXXXXX.XXXXXX.rds.amazonaws.com
$ export RAILS_DATABASE_PORT=3306
```

##### ◆ nginx && pumaコマンド
```
// ポート確認
$ ps -ef | grep nginx
$ ps aux | grep nginx

// nginx停止コマンド
$ nginx -s stop

// PID関連コマンド
$ touch /var/run/nginx.pid
$ touch /run/nginx.pid

// ポート占有確認
$ sudo lsof -i:80
$ ps ax | grep rails

// puma起動
$ bundle exec puma -C config/puma.rb
$ bundle exec pumactl start
```

##### ◆ supervisorコマンド
```
// supervisor起動
$ /etc/init.d/supervisor start
$ supervisord -c /etc/supervisor/supervisord.conf

// supervisorのsocketコマンド
$ sudo touch /var/run/supervisor.sock
$ sudo chmod 777 /var/run/supervisor.sock
$ supervisorctl help stop

// supervisordの設定の「/var/run」を「/dev/shm」 に変更する
$ sed -i "s/\/var\/run/\/dev\/shm/g" /etc/supervisor/supervisord.conf
```


## Dockerfile

```:Dockerfile
FROM ruby:2.7.1
ENV APP_ROOT /var/www/sample_dev
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo


/// ディレクトリ作成 ///
RUN mkdir -p $APP_ROOT
RUN mkdir -p /root/tmp
WORKDIR $APP_ROOT


/// Node.js、Nginx, supervisorインストール ///
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    git \
    libcurl4-openssl-dev \
    libghc-yaml-dev \
    libqt5webkit5-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    linux-headers-amd64 \
    default-mysql-client \
    nginx \
    nodejs \
    openssl \
    ruby-dev \
    ruby-json \
    tzdata \
    vim \
    supervisor \
    zlib1g-dev && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*


/// supervisor用logディレクトリ作成 ///
RUN mkdir -p /var/log/supervisor


/// nginx.conf, conf.d/app.conf作成 ///
COPY app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY app/nginx/app.conf /etc/nginx/conf.d/app.conf


/// supervisord.conf, conf.d/app.conf作成 ///
COPY app/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY app/supervisor/app.conf /etc/supervisor/conf.d/app.conf


/// シンボリックリンク（ヘルスチェックログ） ///

/// 各nginxアクセスログ ///
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stdout /var/log/nginx/app.access.log
RUN ln -sf /dev/stderr /var/log/nginx/app.error.log


/// アプリケーションログ(pumaログ) ///
RUN ln -sf /dev/stdout $APP_ROOT/log/development.log
RUN ln -sf /dev/stdout $APP_ROOT/log/production.log


CMD [ "/usr/bin/supervisord" ]
```

```docker-compose.yml
version: '3'
services:
  app:
    build:
      context: .
      dockerfile: app/Dockerfile
    volumes:
      - ~/sample_dev:/var/www/sample_dev


    /// ホスト側で80番ポートの許可が必要 ///
    /// nginxでバーチャルホストを設定する ///
    ports:
      - 80:80
    environment:
      MYSQL_ROOT_PASSWORD: XXXXXX
    depends_on:
      - db
    tty: true
    stdin_open: true

  db:
    image: mysql:5.7
    ports:
      - 3306:3306
    volumes:
      # mysql初期化
      - ./db/mysql_init:/docker-entrypoint-initdb.d
      - ./db/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: XXXXXX
```

## Nginx

```nginx.conf
user  root;
worker_processes  1;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;

    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
}
```

```app.conf
/// アクセスログ、エラーログ設定 ///
  access_log /var/log/nginx/access.log main;
  error_log /var/log/nginx/error.log warn;

    upstream app {
        server unix:///var/www/sample_dev/tmp/sockets/puma.sock;
    }
    server {
        listen 80;
        server_name dev.sample.com;

         /// URLのパス設定 ///
        location / {

        /// リバースプロキシ設定 ///
        proxy_pass http://app;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_redirect off;
    }
}
```

## puma

```config/puma.rb
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count
# ポートを開放しておかないと、socketのlistenが行われない
#port        ENV.fetch('PORT') { 3000 }
environment ENV.fetch('RAILS_ENV') { 'development' }
plugin :tmp_restart

app_root = File.expand_path('../..', __FILE__)
# nginxのhttpディレクティブでsocket通信を行う
bind "unix://#{app_root}/tmp/sockets/puma.sock"

stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
```


## supervisor

```supervisord.conf
/// supervisor.sock作成 ///
[unix_http_server]
file=/var/run/supervisor.sock


[supervisord]
/// nodaemon=true: supervisorがforground(最前面)プロセスで振舞う ///
nodaemon=true


logfile=/var/log/supervisor/supervisord.log
pidfile=/var/tmp/supervisord.pid


/// rpcinterfaceを有効にすると、supervisorctlが有効になる ///
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface


/// supervisorctlを使ってプロセス管理を可能にする ///
[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[include]
files = /etc/supervisor/conf.d/*.conf
```

```app.conf
[program:app]
command=bundle exec puma -C ./config/puma.rb
autostart=true
autorestart=true
stopsignal=TERM
user=root
directory=/var/www/sample_dev/
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0


[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autostart=true
autorestart=true
stopsignal=TERM
user=root
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
```

# 参考文献
 - [[Terraform][Backends][v0.9]tfstateファイルの管理方法](https://blog.adachin.me/archives/5884)
 - [グループ会社のインフラをECS/Fargateに移行して振り返る](https://engineer.blog.lancers.jp/2020/05/ecs-fargate-replace/)
 - [[AWS][Terraform][Fargate]ECSでコンテナをALB配下に置く](https://blog.adachin.me/archives/11211)
 - [circleci/aws-ecs@1.4.0](https://circleci.com/developer/orbs/orb/circleci/aws-ecs)
 - [AWS ECR/ECS へのデプロイ](https://circleci.com/docs/ja/2.0/ecs-ecr/#docker-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%82%92%E3%83%93%E3%83%AB%E3%83%89%E3%81%97%E3%81%A6-aws-ecr-%E3%81%AB%E3%83%97%E3%83%83%E3%82%B7%E3%83%A5%E3%81%99%E3%82%8B)
