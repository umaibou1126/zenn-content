---
title: "【Rails】 AWSデプロイ　エラー遭遇まとめ"
---

# Rubyインストール編

### rbenv インストールエラー
```
$ rbenv install -v 2.6.5
configure: error: in `/tmp/ruby-build.202005191817.10626/ruby-2.6.5':
configure: error: no acceptable C compiler found in $PATH
```

### 解決コマンド
```
$ sudo yum install gcc openssl-devel
$ sudo yum install -y gcc-6 bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
$ sudo yum erase ruby.noarch
$ sudo yum install gcc
```

# MySQL編

### root初期パスワード在り処
```
$ cat /var/log/mysqld.log | grep password
A temporary password is generated for root@localhost: ************
```

### 初期パスワードログイン
```
$ mysql_secure_installation
Enter password for user root: ************
New password: ************
Re-enter new password: ***********
```


# RMgick編

### RMagickインストールエラー
```
$ bundle install --path vendor/bundle
An error occurred while installing rmagick (3.0.0), and Bundler cannot continue.
Make sure that `gem install rmagick -v '3.0.0' --source 'https://rubygems.org/'`
```

### 解決コマンド
```
$ sudo yum -y install ImageMagick
$ sudo yum -y install ImageMagick-devel
```

# Nginx編

### Nginxインストールエラー
```
$ sudo yum install nginx
読み込んだプラグイン:extras_suggestions, langpacks, priorities, update-motd
パッケージ nginx は利用できません。
エラー: 何もしません
```

### 解決コマンド
```
$ sudo amazon-linux-extras install nginx1.12
                 or
$ sudo yum install http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm -y
$ sudo yum install nginx -y
```

### nginx.conf設定後のpostメソッド対策
```
$ cd /var/lib
$ sudo chmod -R 775 nginx
```


# 参考文献
- [EC2サーバにRuby環境構築](https://qiita.com/tisk_jdb/items/61025d32862555846865)
- [(デプロイ編①)世界一丁寧なAWS解説。EC2を利用して、RailsアプリをAWSにあげるまで](https://qiita.com/naoki_mochizuki/items/814e0979217b1a25aa3e)
- [AWS構築　格闘日記-2　忘備録](https://happy-teeth.hatenablog.com/entry/2019/01/01/202411)
- [AWSのEC2で行うAmazon Linux2（MySQL5.7）環境構築](https://qiita.com/2no553/items/952dbb8df9a228195189)
- [gem install rmagickでchecking for Magick-config... noがでる解決方法](https://qiita.com/pugiemonn/items/3cee6d1aa6a07caab404)
-  [Amazon LinuxでRMagick 3.0.0 がインストールできない](https://qiita.com/mh4gf/items/173bb5c258198e941ecd)
-  [EC2にyumでNginxをインストールしようとしたらできなかった話](https://qiita.com/kazehiki03/items/7712660dd0401186ac4d)
-  [AWS＋Nginx＋Unicornを利用してRailsアプリをデプロイしてみた。〜その１〜](https://qiita.com/President_Taka/items/b18234b8db4cda97a113)
