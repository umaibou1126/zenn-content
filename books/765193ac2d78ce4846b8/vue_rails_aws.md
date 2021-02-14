---
title: "【EC2/Vue/Rails】Vue + RailsのEC2デプロイ手順"
---

# 目次
 - **Rubyインストール**
 - **Node.jsインストール**
 - **Vue.jsインストール**
 - **エラー&&対処**

# Rubyインストール

#### ◆ rbenv/ruby-buildインストール
```
$ git clone git://github.com/rbenv/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
$ git clone git://github.com/rbenv/ruby-build.git /tmp/ruby-build
$ cd /tmp/ruby-build
$ sudo ./install.sh
```
#### ◆ Rubyバージョン指定
```
$ rbenv install -l
$ sudo yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel sqlite-devel
$ rbenv install 2.7.1
$ rbenv rehash
$ rbenv global 2.7.1
$ ruby -v
```

### ◆ bundler/railsインストール
```
$ rbenv rehash
$ gem install bundler
$ bundler -v
$ gem install rails -v 6.0.2.1
$ rails -v
```

# Node.jsインストール
```
$ git clone https://github.com/creationix/nvm.git ~/.nvm
$ source ~/.nvm/nvm.sh
$ vim .bash_profile
###追記
if [ -f ~/.nvm/nvm.sh ]; then
        . ~/.nvm/nvm.sh
fi
$ nvm install 12.14.0
$ node --version
$ npm --version
$ npm install yarn -g
$ yarn --version
```
# Vue.jsインストール
```
$ rails webpacker:install:vue
$ npm install vue-router
$ npm install -y vuex
$ npm install axios --save
$ npm install vee-validate --save
$ npm install sass-loader node-sass --save-dev
$ npm install --save-dev core-js@3
$ npm install --save vuex-persistedstate
```

# エラー&&対処
### ◆ sasscエラー
```
//対処法
$ yum update & yum install gcc gcc-c++ make
```

### ◆ sqlite3エラー
```
$ wget https://www.sqlite.org/2019/sqlite-autoconf-3300100.tar.gz
$ tar xzvf sqlite-autoconf-3300100.tar.gz
$ cd sqlite-autoconf-3300100/
$ ./configure --prefix=/opt/sqlite/sqlite3
$ make
$ sudo yum install sqlite-devel
$ sudo make install
$ /opt/sqlite/sqlite3/bin/sqlite3 --version
$ gem install sqlite3 -- --with-sqlite3-include=/opt/sqlite/sqlite3/include --with-sqlite3-lib=/opt/sqlite/sqlite3/lib
```

### ◆ SQLite (3.7.17) is too old
```
//対処法
$ wget https://kojipkgs.fedoraproject.org//packages/sqlite/3.8.11/1.fc21/x86_64/sqlite-devel-3.8.11-1.fc21.x86_64.rpm
$ wget https://kojipkgs.fedoraproject.org//packages/sqlite/3.8.11/1.fc21/x86_64/sqlite-3.8.11-1.fc21.x86_64.rpm
$ sudo yum install sqlite-3.8.11-1.fc21.x86_64.rpm sqlite-devel-3.8.11-1.fc21.x86_64.rpm
$ yum list | grep sqlite
```

### ◆ mysql2エラー
```
$ sudo yum install mysql-devel
$ bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib"
$ bundle install
```

### ◆ Development Toolsエラー
```
対処法
$ yum -y groupinstall "Development Tools"
$ yum -y install gcc-c++ glibc-headers openssl-devel readline libyaml-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel mysql-devel readline-devel
```

### ◆ ImageMagickエラー
```
対処法
$ yum -y install ImageMagick ImageMagick-devel
//gccダウングレード
$ yum install gcc44
$ alternatives --set gcc /usr/bin/gcc44
```

# 参考文献
 - [(デプロイ編①)世界一丁寧なAWS解説。EC2を利用して、RailsアプリをAWSにあげるまで](https://qiita.com/naoki_mochizuki/items/814e0979217b1a25aa3e)
 - [EC2（Amazon Linux2）へRubyのインストールするよ2020](https://qiita.com/Ekodhikodhi/items/01eab1b2b5785163e684)
 - [EC2サーバにRuby環境構築](https://qiita.com/tisk_jdb/items/61025d32862555846865)
 - [CentOS環境でRails6.0をSQLite3 (>=3.8)で動かす](https://qiita.com/8zca/items/175efb0612070530d186)
 - [Amazon Linuxにmysql2を入れようとしたらエラーがでる](https://qiita.com/showwin/items/e069bbba9c87a6c7d91c)
