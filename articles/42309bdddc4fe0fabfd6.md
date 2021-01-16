---
title: "【Rails】主要コマンドまとめ"
emoji: "🦔"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Rails, Ruby, Docker, MySQL]
published: true
---
# 参考文献

- [Railsコマンドまとめ(基本~応用)](https://qiita.com/gcyagyu/items/dea818095feed81f66c0)
- [docker-composeでよく使うコマンド(Ruby on Rails)](https://qiita.com/LikeGeohotz/items/0e3cd9dfa67d7ff6ff96)
- [Docker Compose + Railsでイメージ内でbundle installしているはずなのにgemが無いとエラーがでる。](https://qiita.com/hokita222/items/49f4ca54835e08fdd6b2)
- [Capistrano で Rails アプリケーションの自動デプロイ](https://qiita.com/Salinger/items/4ee4f3c5ebd5227196c0)
- [(デプロイ編①)世界一丁寧なAWS解説。EC2を利用して、RailsアプリをAWSにあげるまで](https://qiita.com/naoki_mochizuki/items/814e0979217b1a25aa3e)
- [ssh-agentを利用して、安全にSSH認証を行う](https://qiita.com/naoki_mochizuki/items/93ee2643a4c6ab0a20f5)
- [scpコマンド](https://qiita.com/chihiro/items/142ebe6980a498b5d4a7)


# Rails編

### gemインストール（path指定）

```
$ bundle install --path vendor/bundle
```

### model作成
```
$ rails g model sample name:text    #name=カラム名（text型）
```


# Docker編

### railsプロジェクト作成
```
$ docker-compose run web bundle exec rails new . --force --skip-bundle
```

### キャッシュを利用したくない場合
```
$ docker-compose build --no-cache
```

### MySQL利用
```
$ docker-compose run web rails new . --force --database=mysql
```

### DB関連コマンド
```
$ docker-compose exec web bundle exec rake db:drop     #削除
$ docker-compose exec web bundle exec rake db:create　 #作成
$ docker-compose exec web bundle exec rake db:migrate　#マイグレーション
$ docker-compose exec web bundle exec rake db:seed　　 #データ投入
```

### サーバ起動
```
$ docker-compose up -d
```

### exit1が発生する場合
```
$ rm tmp/pids/server.pid
```

# Unicorn編

### 起動コマンド
```
$ bundle exec unicorn_rails -E XXXXXXX -c config/unicorn/XXXXXX.rb -D
```

### 起動確認
```
$ ps -ef | grep unicorn | grep -v grep
```

# Nginx編

### 起動コマンド
```
$ sudo systemctl start nginx.service
```

### 起動確認
```
$ ps aux | grep nginx
```

# Capistrano編

### database.ymlアップロード
```
$ bundle exec cap XXXXXXX deploy:upload      #環境名(ex: development)
```

### デプロイチェック
```
$ bundle exec cap XXXXXXX deploy:check   #環境名(ex: development)
```

### デプロイ実行
```
$ bundle exec cap XXXXXXX deploy        #環境名(ex: development)
```

# SSH関連コマンド

### 公開鍵作成
```
$ ssh-keygen -t rsa
```

### EC2接続
```
$ ssh -i XXXXX.pem ec2-user@XX.XX.XXX.XXX
```

### ssh-agentに鍵の登録
```
$ ssh-add -K ~/.ssh/XXXX_key_rsa
```

### リモートマシン-ローカル間のファイルコピー
```
$ scp XXXXXX.txt ユーザ名@サーバホスト名:/var/www/XXXXX/XXXX
```
