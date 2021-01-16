---
title: "【Vue】学習開始３週目で覚える内容"
emoji: "😎"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Vue.js, JavaScript]
published: true
---
# 3週目で学ぶべきこと
 - **双方向データバインディング**
 - **修飾子**

# コンポーネント間バインディング

 - 入力値を``$event.target.value``で受け取る
 - ``props``, ``$emit``を使用してデータバインディングを行う

#### ◆ 親コンポーネント
```App.vue
<template>
  <!-- v-modelで入力された値を"Child.vue"に"$event"として共有する -->
  <Child v-model="sample"></Child>
</template>

<script>
export default {
  data() {
    return {
      //sample：属性名 YES：初期値　
      sample: "YES"
    }
  }
};
</script>
```

#### ◆ 子コンポーネント

```Child.vue
<template>
  <!-- "親コンポーネントのv-model"で入力された値を受け取る -->
  <input
    :value="value"
    @input="$emit('input', $event.target.value)"
  >
  <!-- "子コンポーネントの入力値を"$emit"を使用して、"親コンポーネント"と共有する -->
  <!-- input：属性値  $event.target.value：入力値 -->
</template>

<script>
export default {
  //"親コンポーネント"の"v-model"入力値
  props: ["value"]
}
<script>
```

# テキストボックスバインディング

 - ``p style="white-space: pre-line;"``を使って、空白・改行を反映する
 - ``textareaタグ`` + ``v-model``でテキストボックスを作成する
 - ``placeholder``は、``入力欄の初期値``を指定する

```App.vue
<template>
  <div>
    <!-- "textarea" + "v-model"で、入力欄作成 -->
    <textarea v-model="sample" placeholder="入力欄"></textarea>
    <!-- p style="white-space: pre-line;"で空白・改行を反映する -->
　　 <p style="white-space: pre-line;">{{ sample }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //sample：属性名　
      sample: ""
    }
  }
};
</script>
```

# 単体チェックボックスバインディング

 - ``input type="checkbox"``で、チェックボックス作成
 - v-modelで指定するプロパティは、``string or numberを選択するboolean型``

```App.vue
<template>
  <div>
     <!-- "checkbox"をセットする -->
　　 <input type="checkbox" id="sample" v-model="sample">
  </div>
</template>

<script>
export default {
  data() {
    return {
      //string or numberを選択するboolean型　
      sample: false
    }
  }
};
</script>
```

# 複数チェックボックスバインディング

 - labelタグ：``label forの属性値``と、``inputタグのid属性値``が同じ場合、紐付けられる
 - 複数選択のチェックボックスの場合、dataプロパティ値(sample)は、``配列``をセットする

```App.vue
<template>
  <div>
     <!-- "YES"を選ぶcheckboxをセットする -->
　　 <input type="checkbox" id="1" value="YES" v-model="sample">
    <label for="1">YES</label>
     <!-- "NO"を選ぶcheckboxをセットする -->
     <input type="checkbox" id="1" value="NO" v-model="sample">
    <label for="1">NO</label>
　　 <!-- "checkboxで選択した値"を出力する -->
    <p>{{sample}}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //checkboxで選択した値を"配列"として受け取る
      sample: []
    }
  }
};
</script>
```

# ラジオボタンバインディング

 - ``inputタグのid属性値``と``label for``の属性値は``同じ値``をセットすることで紐付ける
 - ``input type="radio"``で``ラジオボタン``を作成する
 - 各々の選択肢に``同じv-model``を設定することで、選択可能になる

```App.vue
<template>
  <div>
     <!-- "YES"を選択するラジオボタンをセットする -->
　　  <input type="radio" id="1" value="YES" v-model="sample">
     <label for="1">YES</label>
　　　<!-- "NO"を選択するラジオボタンをセットする -->
     <input type="radio" id="2" value="NO" v-model="sample">
     <label for="2">NO</label>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //sample：属性名 YES：初期値　
      sample: "YES"
    }
  }
};
</script>
```

# セレクトボックスバインディング

 - ``v-for="引数 in 配列"``でレンダリングを実施する
 - ``multiple``は``複数選択``を許容する

```App.vue
<template>
  <div>
     <!-- セレクトボックスの入力値とdataプロパティ属性値を"v-model"で関連付ける -->
     <!-- "multiple"は、複数選択を許可する -->
  <select v-model="sample" multiple>
　　　<!-- v-forディレクティブで"リストレンダリング"を実施し、keyに"sample"をセットする -->
  <option v-for="sample in samples" :key="sample">{{sample}}</option>
  </select>
     <!-- セレクトボックスで選択した内容を出力する -->
   <p>{{sample}}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //v-forディレクティブで使用する"配列"を作成する　
      samples: ["犬", "ネコ", "ウサギ"],
      //セレクトボックスの"初期値"を設定する
      sample: "犬"
    }
  }
};
</script>
```


# 修飾子

#### ◆ lazy修飾子
 - ``changeイベント``後に、データを反映させる
 - デフォルトでは、v-modelは``inputイベント``後に反映させる

```App.vue
<template>
  <div>
     <!-- lazy修飾子によって、"changeイベント"後にデータ反映 -->
    <input v-model.lazy="sample">
  </div>
</template>
```

#### ◆ number修飾子

 - ユーザの入力を``number型``に自動変換させる

```App.vue
<template>
  <div>
     <!-- number修飾子によって、入力データを"number型"に変換 -->
    <input v-model.number="sample" type="number">
  </div>
</template>
```

#### ◆ trim修飾子

 - ユーザの入力から``空白を自動でカット``する
 - ```<pre>タグ```は空白や改行をそのまま表示する

```App.vue
<template>
  <div>
     <!-- trim修飾子によって、入力データの空白を自動でカットする -->
    <input v-model.trim="sample" type="text">
     <!-- "preタグ"によって、trim修飾子の"空白カット"をそのまま表示する -->
　　 <pre>{{ sample }}</pre>
  </div>
</template>

<script>
export default {
  data() {
    return {
      //sample：属性名　default：値
      sample: "default"
    }
  }
};
</script>
```

# 同シリーズ

 - [【Vue】学習開始１週間で覚える内容](https://qiita.com/umaibou1126/items/a6e2b81e6bdd56d2275b)
 - [【Vue】学習開始２週目で覚える内容](https://qiita.com/umaibou1126/items/e7509ee835e17977b5d8)
 - [【Vue】学習開始３週目で覚える内容](https://qiita.com/umaibou1126/items/7d820360d23fd87cdf38)



# 参考文献
 - [フォーム入力バインディング](https://jp.vuejs.org/v2/guide/forms.html)
 - [label](https://html-coding.co.jp/annex/dictionary/html/label/)
 - [Vue.js：v-modelと$emitを使ってデータを読み書きする子コンポーネントをつくる (2019/10/13追記)](https://qiita.com/ozone/items/b75efe5c449cbc469b1e)
