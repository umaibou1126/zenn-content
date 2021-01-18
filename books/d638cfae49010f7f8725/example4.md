---
title: "【Vue】学習開始４週目で覚える内容"
---
# フック関数

 - フック関数：プログラムの中に``独自の処理を割りこませる``ために用意されている仕組み。

|関数名|詳細|
|:--:|:--|
|bind|初めて対象の**htmlタグに紐づいた時**に、呼ばれる|
|inserted|カスタムディレクティブと紐づいた要素が**親Nodeに挿入**された際に呼ばれる|
|update|**コンポーネント内でデータ更新**が行われたタイミングで呼ばれる<br>子コンポーネント更新される**前**|
|componentUpdated|**コンポーネント内でデータ更新**が行われたタイミングで呼ばれる<br>子コンポーネント更新された**後**|
|unbind|htmlタグとの**紐付けが解除された時点**で呼ばれる|

# カスタムディレクティブ

 - 引数は``el, binding, vnode, oldVnode``。 ※基本は``el, binding``を使う
 - フック関数の中で、``bind, update``は頻出のため、``function関数``で省略可能
 - ``el``は``htmlタグ``のことを指す。

```main.js
//カスタムディレクティブ定義方法①
Vue.directive("sample", {
  bind(el, binding) {
     el.style.color = 'red';
  }
});

//カスタムディレクティブ定義方法②
Vue.directive("sample", function(el, binding) {
  el.style.border = 'red';
});
```

#### ◆ binding.value

```App.vue

<template>
  <!-- "v-sample"は、カスタムディレクティブ -->
  <p v-sample="red">Home</p>
</template>
```

```main.js

Vue.directive("sample", function(el, binding) {
  //v-sample="red"の値を、binding.valueで受け取る
  el.style.color = binding.value;
});
```

#### ◆ 引数：arg

```App.vue
<template>
　<!-- "v-sample:solid"で、引数を指定する -->
  <p v-sample:solid="red">Home</p>
</template>
```

```main.js
Vue.directive("sample", function(el, binding) {
  //"v-sample:solid"の引数を"binding.arg"を用いて取得する
  el.style.samplestyle = binding.arg;
});
```

# フィルター

 - ``Vue.filter``で、フィルターを作成し、``パイプ``を使って適用する

```main.js
//フィルター名："UpperCase"　input値を"大文字"に変換する
Vue.filter("UpperCase", function(value) {
  return value.toUpperCase();
});
```

```App.vue
<template>
  <!-- "Vue.filter"で定義した"UpperCase"を挿入する -->
  <h1>{{ answer | UpperCase }}</h1>
</template>

<script>
export default {
  data() {
    return {
     //属性値：answer 初期値："hello world!"
      answer: "hello world!"
    }
  }
};
</script>
```

# ミックスイン

 - ``export const``を用いて``ミックスイン``を定義する
 - ミックスインを定義したファイルを``import``, ``export``を使って反映させる

```sample.js
//ミックスイン名：sampleを定義する
export const sample = {
  data() {
    return {
     //属性値：answer 初期値："hello world!"
      answer: "hello world!"
    }
  }
};
```

```App.vue
<template>
  <p>{{answer}}</p>
</template>

<script>
//ミックスインを定義したファイル名をインポート
import { sample } from "@/sample";

export default {
  //ミックスインで定義した内容をエクスポートし、反映させる
  mixins: [sample]
};
</script>
```
# Vue Router

#### ◆ router.js

```router.js
//vue-routerをインポートする
import Vue from "vue";
import Router from "vue-router";
import Home from "./views/Home.vue";

//Router(プラグイン)を適用する
Vue.use(Router);

//new Routerによって、パスルーティングを指定
export default new Router({
  routes: [
    {
      //path, componentを指定
      path: "/",
      component: Home
    }
  ]
})
```

#### ◆ main.js

```main.js
//vue-routerを追加する
import router from "./router"

new Vue({
  //routerを追加
  router: router,
  render: h => h(App)
}).$mount("#app");
```

#### ◆ App.vue

```App.vue
<template>
  <!-- "router-view"を使用することで、設定したルーティングを適用する -->
  <router-view></router-view>
</template>
```


# 参考文献
 - [Vue.jsのカスタムディレクティブの使い方とフック関数のタイミングを理解する](https://qiita.com/soarflat/items/f3d32e3b8854870c57fc)
 - [フック (hook)](https://wa3.i-3-i.info/word12296.html)
 - [Vue.jsでカスタムディレクティブを実装する](https://qiita.com/shironeko-shobo/items/fbb9344ecc94854e641b)
 - [カスタムディレクティブ](https://jp.vuejs.org/v2/guide/custom-directive.html)
 - [今さら聞けない？Vue Router](https://qiita.com/hshota28/items/765cf903f055754f7557)
