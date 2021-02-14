---
title: "【Vue Rails】Vue + Railsで"Hello Vue!"表示"
---

# Vue + Railsアプリ作成

#### ◆ Railsアプリ作成
```
// "-webpack=vue"オプションでVue.js使用可能
$ rails new <アプリケーション名> -webpack=vue
```

#### ◆ model作成
```
// カラム名：name データ型：text
$ rails g model sample name:text
```

#### ◆ migrationファイル編集(Hello.Vue!表示には不要)
```db/migrate/20200627045139_create_sample.rb
class CreateSample < ActiveRecord::Migration[6.0]
  def change
    create_table :sample do |t|
      t.text :name, null: false, default: ""
    end
  end
end
```

#### ◆ マイグレーション
```
$ rails db:create      //データベース作成
$ rails db:migrate　   //マイグレーション実施
```

#### ◆ controller作成

```app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
  end
end
```

#### ◆ routes.rb編集
```config/routes.rb
Rails.application.routes.draw do
  root to: 'home#index'
end
```

####◆ index.html.erb編集
```app/views/home/index.html.erb
<%= javascript_pack_tag 'hello_vue' %>
<%= stylesheet_pack_tag 'hello_vue' %>
```

#### ◆ hello.vue.js（デフォルトで設定済）
```app/javascript/packs/hello_vue.js
import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello'))
  const app = new Vue({
    el,
    render: h => h(App)
  })

  console.log(app)
})
```

#### ◆ app.vue(デフォルトで設定済)
```app/javascript/app.vue
<template>
  <div id="app">
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
```

# 備忘録

#### ◆ before_action
 - メソッドを定義して、``before_action``にセットする

```login_controller.rb
class LoginController < ApplicationController
  before_action :set_answer

  def set_answer
    @sample = "Hello World!"
  end
end
```

#### ◆ rescue_from
 - ``例外処理``。エラー処理を行う画面を設定する
 - ``app/controller/application_controller.rb``に記述する

```app/controller/application_controller.rb
class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

end
```

# 遭遇したエラー

#### ◆ エラー内容①
```
Webpacker::Manifest::MissingEntryError in Home#index
```

#### 解決策：Webpackインストール
```
$ yarn
$ bin/yarn
$ webpack
$ webpack
```

#### ◆ エラー内容②
```
Error: vue-loader requires @vue/compiler-sfc to be present in the dependency tree.
```

#### 解決策：vue-loaderダウングレード
```
$ npm remove vue-loader
$ npm install --save vue-loader@15.9.2
$ yarn add vue-loader@15.9.2
```

#### ◆ エラー内容③
```
Sprockets::Rails::Helper::AssetNotFound in Home#index
 <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```
#### 解決策：app/views/layouts/application.html.erb編集
```app/views/layouts/application.html.erb
<!-- javascript_include_tagの行を削除 -->
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```

# 参考文献

 - [Ruby on Rails, Vue.js で始めるモダン WEB アプリケーション入門](https://qiita.com/tatsurou313/items/4f18c0d4d231e2fb55f4)
 - [Vue.jsとRailsでTODOアプリのチュートリアルみたいなものを作ってみた](https://qiita.com/naoki85/items/51a8b0f2cbf949d08b11)
 - [実践の場で役立つ！Ruby on Railsのbefore_actionの使い方【初心者向け】](https://techacademy.jp/magazine/7464)
 - [【Rails】インストール時につまづきがちなエラー集](https://blog.yuhiisk.com/archive/2018/04/24/rails-error-collection.html)
 - [エラー：vue-loaderでは、依存関係ツリーに@ vue / compiler-sfcが存在する必要があります ＃1672](https://github.com/vuejs/vue-loader/issues/1672)
 - [【npm/yarn】パッケージをダウングレードする](https://rennnosukesann.hatenablog.com/entry/2019/01/04/004352)
