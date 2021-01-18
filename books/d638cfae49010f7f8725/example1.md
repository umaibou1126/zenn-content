---
title: "【Vue】学習開始１週間で覚える内容"
---
# 基本用語

|用語|詳細|
|:--:|:--|
|DOM|HTMLに表現するためのプログラム。 **Document Object Model**の略。|
|ディレクティブ|DOM要素に対して**実行するアクションを伝える**トークン。|
|コンポーネント|**.vue拡張子を持つvueファイル**。componentsフォルダに格納される。<br>名前付きかつ再利用可能な**Vueインスタンス**のこと|
|レンダリング|**ディレクティブ**に基づいて**HTML上にデータを反映**させること|

# Vueインスタンス

 - Vueインスタンス：``new Vue``で生成する。``変数定義``を行う。

```sample.js

new Vue({
  el: '#sample',
  data: {
    message: 'Hello World!'
  }
})
```

```sample.html

<div id='sample'>
  <p>{{ message }}</p>
</div>
```

# 条件付きレンダリング

 - ``v-if``、``v-else``、``v-else-if``を用いて条件分岐を行う。

#### ◆ v-ifディレクティブ

```sample.html

<div id="sample">
  <!-- dataプロパティの"answer"を参照する -->
  <p v-if="answer">Hello World!</p>
</div>
```

```sample.js

new Vue({
  el: '#sample',
  data: {
    answer: true
  }
})
```

#### ◆ v-elseディレクティブ

```sample.html

<div id="sample">
  <!-- dataプロパティの"answer"を参照する -->
  <p v-if="answer">Hello World!</p>
  <p v-else="answer">Good Evening!</p>
</div>
```

```sample.js

new Vue({
  el: '#sample',
  data: {
    answer: true
  }
})
```

#### ◆ v-else-ifディレクティブ

```sample.html

<div id="sample">
  <p v-if="answer">Hello World!</p>
  <!-- dataプロパティの"maybe"を参照する -->
  <p v-else-if="maybe">Good Afternoon!</p>
  <p v-else>Good Evening!</p>
</div>
```

```sample.js

new Vue({
  el: '#sample',
  data: {
    answer: true
    maybe: true
  }
})
```

# リストレンダリング

 - ``v-forディレクティブ``を用いてレンダリングを行う。

```sample.html

<div id="sample">
  <ul>
　　 <!-- "sample"は引数。 "引数 in 配列名" -->
    <li v-for="sample in samples">{{sample}}</li>
  </ul>
</div>
```

```sample.js

new Vue({
  el: '#sample',
  data: {
    samples: ['品川', '五反田', '目黒']
  }
})
```

# props

 - ```親コンポーネント```から```子コンポーネント```にデータを渡す際に使用する

#### 親コンポーネント
```App.vue

<template>
  <!-- props名：answer データ値："YES" -->
  <Sample v-bind:answer="YES"></Sample>
</template>

<script>
import Sample from "./components/Sample.vue";

export default {
  data() {
    return {
      answer: 'YES'
   };
 };
};
</script>
```

#### 子コンポーネント

```Sample.vue

<template>
  <div>
<!-- props名：answer 親コンポーネントから参照する -->
     <p>{{ answer }}</p>
  </div>
</template>

<script>
export default {
  props: ["answer"]
};
</script>

```

# $emit

- ```子コンポーネント```から```親コンポーネント```にデータを渡す際に使用する

#### 親コンポーネント
```App.vue

<template>
  <!-- event名：sample-action / props名：answer / $event:受け取るデータ -->
  <Sample v-bind:answer="YES" v-on:sample-action="answer = $event"></Sample>
</template>

<script>
import Sample from "./components/Sample.vue";

export default {
  data() {
    return {
      answer: 'YES'
   }
 }
};
</script>
```

#### 子コンポーネント

```Sample.vue

<template>
  <div>
<!-- props名：answer 親コンポーネントから参照する -->
     <p>{{ answer }}</p>
  <button v-on:click="sample">{{ answer }}</button>
 </div>
</template>

<script>
export default {
  props: ["answer"]
},
methods: {
  sample: function () {
  //event名：sample-action / props名：answer
    this.$emit("sample-action", this.answer + "good")
 }
};
</script>
```


# 参考文献
 - [Vueのpropsの使い方](https://qiita.com/minuro/items/fa3ddd70ace5b99a1f90)
 - [Vue.js「コンポーネント」入門](https://qiita.com/kiyokiyo_kzsby/items/980c1dc45e00d2d3cbb4)
 - [5分でわかるVue.js基礎の基礎](https://qiita.com/kiyokiyo_kzsby/items/ce9fe8b72953584fecee)
 - [Vue.js の条件付きレンダリングを勉強する](https://qiita.com/Sthudent_Camilo/items/f41d5ad3ad02c0928656)
 - [Vue.jsのリストレンダリングを勉強する](https://qiita.com/Sthudent_Camilo/items/9936cc95c9bcff00fc35)
 - [Vueのpropsの使い方](https://qiita.com/minuro/items/fa3ddd70ace5b99a1f90)
 - [Vue.jsをシンプルに理解しよう その4 -propsとemitについて-](https://qiita.com/yusuke_ten/items/f47486fff5e7a163bd7e)
 - [Vue.js用語辞典【未完】](https://qiita.com/Azu-MAX/items/09c6d8b6d562f6661e8f)
 - [DOM の紹介](https://developer.mozilla.org/ja/docs/Web/API/Document_Object_Model/Introduction#What_is_the_DOM)
 - [ディレクティブ](https://012-jp.vuejs.org/guide/directives.html#:~:text=%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%86%E3%82%A3%E3%83%96%E3%81%A8%E3%81%AF%E3%80%81%20DOM%20%E8%A6%81%E7%B4%A0,%E3%81%AE%E7%89%B9%E5%88%A5%E3%81%AA%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%81%A7%E3%81%99%E3%80%82&text=Vue.js%20%E3%81%AE%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%86%E3%82%A3%E3%83%96%E3%81%AF,%E3%81%A7%E3%81%AE%E3%81%BF%E8%A1%A8%E3%81%95%E3%82%8C%E3%81%BE%E3%81%99%E3%80%82)
 - [コンポーネントの基本](https://jp.vuejs.org/v2/guide/components.html)
 - [リストレンダリング](https://jp.vuejs.org/v2/guide/list.html)
