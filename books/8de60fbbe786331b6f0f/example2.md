---
title: "エラー / 解決策①"
---

## 【ListViewの入れ子によるエラー】

#### ◆ エラー内容

```
The following assertion was thrown during performResize():
Vertical viewport was given unbounded height.
```

#### ◆ 解決策

```main.dart
ListView(
  shrinkWrap: true,   //追加
  physics: NeverScrollableScrollPhysics(),  //追加
  children: _sample,
)
```

## 【ビューポート（表示領域）が狭いエラー】

#### ◆ エラー内容
```
A RenderFlex overflowed by 92 pixels on the bottom.
```

#### ◆ 解決策
```main.dart
Widget build(BuildContext context) {
    return SingleChildScrollView(   //追加
      child: Column(
        ),
    );
}
```

## 【Firebase.initializeApp()完了後に、runAppする方法】

#### ◆ 解決策
```main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();   //追加
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## 【FirestoreでorderByする方法】

#### ◆ 解決策
```main.dart
void getList() {
    Firestore.instance
        .collection("sample")
        .where("active", isEqualTo: "running")
        .orderBy("createdAt", descending: true)  //orderBy
        .snapshots()
```

## 参考文献
 - [【flutter初心者】ListViewやGridViewを入れ子にするには（Vertical viewport was given unbounded height エラー）](https://qiita.com/code-cutlass/items/3a8b759056db1e8f7639)
 - [[Flutter]TextFieldタップでA RenderFlex overflowed by <xxx> pixels on the bottom. が出るときの対処法](https://qiita.com/welchi/items/e9c907828e553d448269)
 - [【Flutter】キーボード表示時の RenderFlex overflowed エラーを解消](https://yaba-blog.com/flutter-renderflex-overflowed/#toc2)
 - [FlutterでFirebaseを使うときのFirebase.initializeApp()の呼び方](https://qiita.com/edasan/items/f32bc58a4afd0ca92432)
 - [DartのFirestoreでorderByしたらなぜか0件のsnapshotが取得される](https://qiita.com/sekitaka_1214/items/a59ef0f1889ffef6cbc6)
