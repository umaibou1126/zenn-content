---
title: "エラー / 解決策③"
---

## 1. settings_aar.gradleが存在しないエラー

##### ◆ エラー内容
```
1. Copy `settings.gradle` as `settings_aar.gradle`
2. Remove the following code from `settings_aar.gradle`:

    def localPropertiesFile = new File(rootProject.projectDir, "local.properties")
    def properties = new Properties()

    assert localPropertiesFile.exists()
    localPropertiesFile.withReader("UTF-8") { reader -> properties.load(reader) }

    def flutterSdkPath = properties.getProperty("flutter.sdk")
    assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
    apply from: "$flutterSdkPath/packages/flutter_tools/gradle/app_plugin_loader.gradle"
```

##### ◆ 解決策
```setting_aar.gradle
include ':app'
def flutterProjectRoot = rootProject.projectDir.parentFile.toPath()

def plugins = new Properties()
def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":$name"
    project(":$name").projectDir = pluginDirectory
}
```



## 2. amplify add codegen実行エラー

##### ◆ エラー内容
```
Error: amplify-codegen-appsync-model-plugin not support language target flutter. Supported codegen targets arr java, android, swift, ios, javascript, typescript
```

##### ◆ 解決策
```
$ npm install -g @aws-amplify/cli
 $ amplify -v
 $ amplify upgrade
 4.41.0
```

## 3. Podfile platformエラー
##### ◆ エラー内容
```
they required a higher minimum deployment target.
```

##### ◆ 解決策
```
platform :ios, '8.0'   // before
platform :ios, '9.0'   // after
```

## 4. android:labelエラー

##### ◆ エラー内容
```
Error: Attribute application@label value=(flutter_bloc_pattern) from AndroidManifest.xml:18:9-45 is also present at [:DynamsoftBarcodeReader] AndroidManifest.xml:13:9-41 value=(@string/app_name).
```

##### ◆ 解決策
```AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.sample">   // 追記
    <!-- io.flutter.app.FlutterApplication is an android.app.Application that
         calls FlutterMain.startInitialization(this); in its onCreate method.
         In most cases you can leave this as-is, but you if you want to provide
         additional functionality it is fine to subclass or reimplement
         FlutterApplication and put your custom class here. -->
    <application
        tools:replace="android:name"
        android:name="io.flutter.app.FlutterApplication"
        android:label="sample"
        android:icon="@mipmap/ic_launcher">
```

## 5. Android画面固定

##### ◆ 横画面固定
```AndroidManifest.xml
<activity
    android:name=".MainActivity"
    android:screenOrientation="landscape"
</activity>
```

##### ◆ 縦画面固定
```AndroidManifest.xml
<activity
    android:name=".MainActivity"
    android:screenOrientation="portrait"
</activity>
```

## 参考文献
 - [cannot run amplify codegen #288](https://github.com/aws-amplify/amplify-flutter/issues/288)
 - [cocoaPodsで「they required a higher minimum deployment target. 」というエラーが出た時の対処方法](https://program-life.com/1767)
 - [Androidの表示画面の回転固定](https://qiita.com/okhiroyuki/items/889a4d7b4284e3280efe)
 - [add 'tools:replace=“android:label”' to <application> element at AndroidManifest.xml:16:5-39:19 to override](https://stackoverflow.com/questions/54924256/add-toolsreplace-androidlabel-to-application-element-at-androidmanifest)
 - [Getting started](https://docs.amplify.aws/lib/datastore/getting-started/q/platform/flutter)
 - [manual_migration_settings.gradle.md](https://github.com/flutter/flutter/blob/master/packages/flutter_tools/gradle/manual_migration_settings.gradle.md)
