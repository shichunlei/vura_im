import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceUtils {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);

  static bool get isMobile => isAndroid || isIOS;

  static bool get isWeb => kIsWeb;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isIOS => Platform.isIOS;

  /// 屏幕宽
  ///
  static double get width => 1.sw;

  /// 屏幕高
  ///
  static double get height => 1.sh;

  /// 标题栏高度（包括状态栏）
  ///
  static double get navigationBarHeight => topSafeHeight + kToolbarHeight;

  /// 状态栏高度
  ///
  static double get topSafeHeight => ScreenUtil().statusBarHeight;

  /// 底部状态栏高度
  ///
  static double get bottomSafeHeight => ScreenUtil().bottomBarHeight;

  /// 隐藏键盘
  ///
  /// [context] 上下文
  ///
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 隐藏状态栏
  static void hideTopSafeHeight() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  }

  /// 隐藏底部操作栏
  static void hideBottomSafeHeight() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  }

  /// 设置底部间距
  static double setBottomMargin(double margin) => bottomSafeHeight == 0 ? margin : bottomSafeHeight;

  /// 竖屏
  static void lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  /// 横屏
  static void lockScreenLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  static void unlockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  static Future<String> getPlatformVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return '${androidInfo.brand} ${androidInfo.model} Android ${androidInfo.version.release}';
    }

    if (isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }

    if (isWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return '${webBrowserInfo.browserName}-${webBrowserInfo.appVersion}';
    }

    return 'unKnow';
  }
}
