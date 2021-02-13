---
title: "エラー / 解決策②"
---

## 【Bad state: Stream has already been listened to】
#### ◆ エラー内容
```
Bad state: Stream has already been listened to.
```

#### ◆ 解決策

```pubspec.yaml
dependencies:
  rxdart: ^0.25.0
```

```main.dart
// StreamController → BehaviorSubject
final _sample = StreamController<String>();  //before
final _sample = BehaviorSubject<String>();  //after
```

## 【setState() called after dispose();エラー】

#### ◆ エラー内容
```
This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree
```

#### ◆ 解決策

```main.dart
int _count = 0;

void _sampleCounter() {
  if(mounted) {  //追加
    setState(() {
      _count++;
  });
}
```

## 【cloud_firestore/permission-denied】

#### ◆ エラー内容
```
cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.
```

#### ◆ 解決策

```
Firebaseコンソール > プロジェクト選択 > Cloud Firestore > 　ルール
```

## 【Dart条件分岐】

#### ◆ switch文
```main.dart
const sample1 = "犬";
const sample2 = "猫";
var pets = "ペット";

switch (pets) {
  case sample1:
    print('犬好き');
    break;

  case sample2:
    continue sample1;

  default:
    print('犬も猫も好き');
    break;
}
```

#### ◆ if文

```main.dart
var pets = "ペット";

if (pets == "犬") {
  print('犬好き');
} else if (pets == "猫") {
  print('猫好き');
} else
  print('犬も猫も好き');
}
```

## 【setStateメソッド】

#### ◆ setState

```main.dart
int _count = 0;

void _sampleCounter() {
  setState(() {
    _count++;
  });
}
```

## 参考文献
 - [【Flutter】バグ解決: Bad state: Stream has already been listened to.](https://qiita.com/tetsukick/items/b51713d637b66ad84510)
 - [RxDartのBehaviorSubjectとPublishSubjectの違いと使い分け](https://qiita.com/tetsufe/items/28ea0a07410efd6d6a9f)
 - [【Flutter】電卓・計算機アプリの作成 2](https://2357developnote.blogspot.com/2020/05/flutter-calculator2.html)
 - [Flutter：悪い状態：ストリームは既にリッスンされています](https://www.it-swarm-ja.tech/ja/dart/flutter%EF%BC%9A%E6%82%AA%E3%81%84%E7%8A%B6%E6%85%8B%EF%BC%9A%E3%82%B9%E3%83%88%E3%83%AA%E3%83%BC%E3%83%A0%E3%81%AF%E6%97%A2%E3%81%AB%E3%83%AA%E3%83%83%E3%82%B9%E3%83%B3%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99/806158797/)
 - [# Dartの制御文（条件分岐）](https://qiita.com/take0116/items/f85713100ff6af1d6594)
 - [rxdart 0.25.0](https://pub.dev/packages/rxdart/install)
 - [【Dart入門】if文の使い方を説明します（switchや三項演算子とも比較）](https://programming-dojo.com/%E3%80%90dart%E5%85%A5%E9%96%80%E3%80%91if%E6%96%87%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9%E3%82%92%E8%AA%AC%E6%98%8E%E3%81%97%E3%81%BE%E3%81%99/)
 - [制御フロー文 (Control flow statements)](https://www.cresc.co.jp/tech/java/Google_Dart2/language/control_flow/control_flow.html)
 - [FlutterのsetStateとは？](https://qiita.com/koizumiim/items/5cc0f68d224b2cc949ba)
 - [【Flutter】setStateをinitStateの中で呼ぶ時の注意点](https://blog.mrym.tv/2019/12/traps-on-calling-setstate-inside-initstate/)
 - [firestoreのcollectionGroupのデータ取得で `The caller does not have permission to execute the specified operation.`](https://qiita.com/HorikawaTokiya/items/a5f07e26e3b2ef2732ee)
