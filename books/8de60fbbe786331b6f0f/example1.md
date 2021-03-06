---
title: "Section1 環境構築"
---

# iOS編

### 1. Firebaseプロジェクト作成
[![Image from Gyazo](https://i.gyazo.com/ffa6c7e669476505a072551306086564.png)](https://gyazo.com/ffa6c7e669476505a072551306086564)


### 2. iOSアプリの追加

[![Image from Gyazo](https://i.gyazo.com/679b98eff0015aa199e7647f2ac7fcc3.png)](https://gyazo.com/679b98eff0015aa199e7647f2ac7fcc3)


 - iOSバンドルID

[![Image from Gyazo](https://i.gyazo.com/d7509f0cb63860b41b7af3abc9a8d220.png)](https://gyazo.com/d7509f0cb63860b41b7af3abc9a8d220)


### 3. GoogleService-Info.plist

[![Image from Gyazo](https://i.gyazo.com/d26cd8b0113fd06a35f7332b4646cff0.png)](https://gyazo.com/d26cd8b0113fd06a35f7332b4646cff0)


 - Xcodeプロジェクトに追加

[![Image from Gyazo](https://i.gyazo.com/3af4b99eb2235241cbe493bd9e4bbe2e.png)](https://gyazo.com/3af4b99eb2235241cbe493bd9e4bbe2e)


### 4.FlutterFire プラグインを追加する

 - firebase_core導入

```
dependencies:
  firebase_core: ^0.5.2
```

[![Image from Gyazo](https://i.gyazo.com/bca3526366eb6f6e203dd490e5e9d7dd.png)](https://gyazo.com/bca3526366eb6f6e203dd490e5e9d7dd)

 - cloud_firestore導入

```
dependencies:
  cloud_firestore: ^0.14.3
```

[![Image from Gyazo](https://i.gyazo.com/0ce5b408df704352a1d76c64f6a88f0e.png)](https://gyazo.com/0ce5b408df704352a1d76c64f6a88f0e)




# Android編

### 1.Androidアプリの追加

[![Image from Gyazo](https://i.gyazo.com/255f3b338ab4b4866e7ec49ae7cf968f.png)](https://gyazo.com/255f3b338ab4b4866e7ec49ae7cf968f)


 - Androidパッケージ名

```AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="sample">
```

### 2.google-services.jsonの追加

[![Image from Gyazo](https://i.gyazo.com/e6d0863310cd764d2780c87482f87630.png)](https://gyazo.com/e6d0863310cd764d2780c87482f87630)


```
android/app
├── build.gradle
├── google-services.json  //追加
└── src
```


### 3.Firebase SDK の追加

```android/build.gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.4'  //追加
  }
```

```android/app/build.gradle
apply plugin: 'com.google.gms.google-services'  //追加
```

```android/app/build.gradle
android {
    defaultConfig {
        ...
        minSdkVersion 15
        targetSdkVersion 28
        multiDexEnabled true
    }
    ...
}

dependencies {
  implementation 'com.android.support:multidex:1.0.3'
}
```

## 参考文献
 - [Flutter アプリに Firebase を追加する](https://firebase.google.com/docs/flutter/setup?hl=ja)
 - [cloud_firestore 0.13.6 ](https://pub.dev/packages/cloud_firestore/versions/0.13.6)
 - [firebase_core 0.5.2](https://pub.dev/packages/firebase_core/install)
 - [64K を超えるメソッドを使用するアプリ向けに multidex を有効化する](https://developer.android.com/studio/build/multidex)
 - [【Flutter実践】Firebase環境構築と、Firestoreのデータを取得してアプリで表示](https://www.youtube.com/watch?v=IiEsyHiIwxc)
 - [firebase_core](https://pub.dev/packages/firebase_core/install)
 - [cloud_firestore](https://pub.dev/packages/cloud_firestore/install)
 - [provider](https://pub.dev/packages/provider/install)
 - [firebase_auth](https://pub.dev/packages/firebase_auth/install)
 - [image_picker](https://pub.dev/packages/image_picker/install)
 - [firebase_storage](https://pub.dev/packages/firebase_storage/install)
