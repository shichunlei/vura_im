# im

## 运行环境

**************************************************************************************

    [✓] Flutter (Channel stable, 3.22.3, on macOS 14.1.1 23B81 darwin-x64, locale zh-Hans-CN)
        • Flutter version 3.22.3 on channel stable at /Users/mac104/workspace/flutter
        • Upstream repository https://github.com/flutter/flutter.git
        • Framework revision b0850beeb2 (7 weeks ago), 2024-07-16 21:43:41 -0700
        • Engine revision 235db911ba
        • Dart version 3.4.4
        • DevTools version 2.34.3
        • Pub download mirror https://pub.flutter-io.cn
        • Flutter download mirror https://storage.flutter-io.cn
    
    [✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
        • Android SDK at /Users/mac104/Library/Android/sdk
        • Platform android-35, build-tools 35.0.0
        • ANDROID_HOME = /Users/mac104/Library/Android/sdk
        • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
        • Java version OpenJDK Runtime Environment (build 17.0.11+0-17.0.11b1207.24-11852314)
        • All Android licenses accepted.
    
    [✓] Xcode - develop for iOS and macOS (Xcode 15.2)
        • Xcode at /Applications/Xcode.app/Contents/Developer
        • Build 15C500b
        • CocoaPods version 1.15.2
    
    [✓] Android Studio (version 2024.1)
        • Android Studio at /Applications/Android Studio.app/Contents
        • Flutter plugin can be installed from:
            🔨 https://plugins.jetbrains.com/plugin/9212-flutter
        • Dart plugin can be installed from:
            🔨 https://plugins.jetbrains.com/plugin/6351-dart
        • Java version OpenJDK Runtime Environment (build 17.0.11+0-17.0.11b1207.24-11852314)

**************************************************************************************

## Android 签名密钥


## Android 包名

    com.example.vura.app

## 打包

- Android

```bash
  flutter clean
  flutter pub get
  flutter build apk --release --no-tree-shake-icons --verbose
```

- iOS

```bash
  flutter clean
  flutter pub get
  flutter build ios --release --no-tree-shake-icons --verbose
```
