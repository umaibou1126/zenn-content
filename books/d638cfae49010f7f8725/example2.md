---
title: "【Vue】学習開始２週目で覚える内容"
---
# v-model

 - v-modelディレクティブ：```formのinput要素```に対して、```データバインディング```を行う際に使用する
 - データバインディング：**データ**と**表示**を結びつけ、``双方向``に変更を反映させること

```App.vue
<template>
  <div>
     <!-- sampleオブジェクト内のanswerを参照する -->
    <input v-model="sample.answer">
    <p>{sample.answer}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //オブジェクト名：sample  プロパティ名：answer
      sample: {
        answer: "Hello World!"
      }
    }
  }
};
</script>
```



# 名前付きslot

 - slot：```親コンポーネント```から```子コンポーネント```にテンプレートを差し込む機能


#### ◆ 親コンポーネント

```App.vue

<template>
  <div>
    <Child>
      <!-- 子コンポーネントの"slot name"で参照される -->
      <template v-slot:sample>
        <h1>親コンポーネントの表示</h1>
　　　　</template>
       <!-- 子コンポーネントの"slot name"で参照される -->
       <template v-slot:answer>
          <!-- dataプロパティ参照 -->
          <p>{{word}}</p>
       </template>
    </Child>
  </div>
</template>

<script>
export default {
  data() {
    return {
      word: "good morning!"
    }
  }
};
```

#### ◆ 子コンポーネント

```Child.vue

<template>
  <div>
    <!-- 親コンポーネント"v-slot:sample"を参照する -->
    <slot name="sample"></slot>
     <hr>
     <p>Hello World!</p>
     <hr>
    <!-- 親コンポーネント"v-slot:answer"を参照する -->
    <slot name="answer"></slot>
  </div>
</template>
```

# スコープ付きslot

 - ```子コンポーネントslotに渡されたprops```に、```親コンポーネント```からアクセスすること

#### ◆ 子コンポーネント

```Child.vue

<template>
  <div>
    <!-- dataプロパティの"word"を、slotに設定する -->
    <!-- ※sampleは"任意の属性名"を設定する -->
    <slot name="sample" v-bind:sample="word"></slot>
  </div>
</template>

<script>
export default {
  data() {
    return {
      word: "good morning!"
    }
  }
};
```

```App.vue

<template>
  <div>
    <Child>
      <!-- 子コンポーネントの v-bind sample="word" が参照される -->
      <!-- "slotProps"は任意の属性名"を設定する -->
      <template v-slot:sample="slotProps">
      <!-- slotPropsは"template内"で使用可能 -->
        <h1>{{ slotProps }}</h1>
　　　　</template>
    </Child>
  </div>
</template>
```

# 動的コンポーネント

 - ```コンポーネント間の切り替え```をスムーズに行う目的で使用する

#### ◆ 子コンポーネント

```Child.vue

<template>
  <p>Child</p>
</template>
```

#### ◆ 親コンポーネント

```App.vue

<template>
  <div>
  <!-- is："別のコンポーネントを参照する"属性 -->
  <component v-bind:is="sample"></component>
  </div>
</template>

<script>
import Child from "./components/Child.vue";

export default {
  data() {
    return {
      //sample：属性名　default：値
      sample: "default"
    };
  },
components: {
  //子コンポーネントを参照する
  Child
}
```

# ライフサイクルフック

 - activated：生き続けたコンポーネントを```活性化```する際に、参照される
 - deactivated：生き続けたコンポーネントを```非活性化```する際に、参照される
 - destroyed：```Vueインスタンスが破棄```された際に、参照される
 - keep-alive：コンポーネントの内容を```保持したい時```に使用する

#### ◆ destroyedメソッド

```Destroy.vue

<script>
export default {
  destroyed() {
    //Vueインスタンスが破棄された際に、出力される
    console.log("Hello World!");
  }
}
</script>
```

#### ◆ keep-alive

```Keepalive.vue
<template>
  <div>
  <keep-alive>
  <!-- 保持したい"コンポーネント"を"keep-alive"で囲む -->
  <component v-bind:is="sample"></component>
  </keep-alive>
  </div>
</template>
```

#### ◆ activated / deactivatedメソッド

```Sample.vue

<script>
export default {
  activated() {
    //コンポーネントが"活性化状態"の時に出力される
    console.log("Hello World!");
  },
  deactivated() {
   //コンポーネントが"非活性化状態"の時に出力される
    console.log("Good morning");
  }
};
</script>
```


# 参考文献

 - [Vuejsのslotの様々な使い方](https://qiita.com/myLifeAsaDog/items/206c04fdef3a874b86f6)
 - [Vue.jsのslotの機能を初心者にわかるように解説してみた](https://future-architect.github.io/articles/20200428/)
 - [Vue.js中級編！？「スコープ付きスロット」を理解しよう](https://www.hypertextcandy.com/vuejs-scoped-slots)
 - [Vuejsのちょっと便利なコンポーネント機能](https://qiita.com/myLifeAsaDog/items/233f10591be8ff42cf1d)
 - [コンポーネントの基本](https://jp.vuejs.org/v2/guide/components.html)
 - [API](https://vuejs.org/v2/api/)
 - [メモリリークを回避する](https://jp.vuejs.org/v2/cookbook/avoiding-memory-leaks.html)
 - [Vue.jsのv-modelを正しく使う](https://qiita.com/simezi9/items/c27d69f17d2d08722b3a)
 - [データバインディング](https://ja.wikipedia.org/wiki/%E3%83%87%E3%83%BC%E3%82%BF%E3%83%90%E3%82%A4%E3%83%B3%E3%83%87%E3%82%A3%E3%83%B3%E3%82%B0#:~:text=%E3%83%87%E3%83%BC%E3%82%BF%E3%83%90%E3%82%A4%E3%83%B3%E3%83%87%E3%82%A3%E3%83%B3%E3%82%B0%EF%BC%88%E3%83%87%E3%83%BC%E3%82%BF%E3%83%90%E3%82%A4%E3%83%B3%E3%83%89%E3%80%81%E3%83%87%E3%83%BC%E3%82%BF,%E4%BB%95%E7%B5%84%E3%81%BF%E3%81%AE%E3%81%93%E3%81%A8%E3%81%A7%E3%81%82%E3%82%8B%E3%80%82)
 - [フォーム入力バインディング](https://jp.vuejs.org/v2/guide/forms.html)
