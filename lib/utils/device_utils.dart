import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'log_utils.dart';

class DeviceUtils {
  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

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
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// 设置底部间距
  static double setBottomMargin(double margin) => bottomSafeHeight == 0 ? margin : bottomSafeHeight;

  static Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Log.json(androidInfo.data);
      return '${androidInfo.brand} ${androidInfo.model}';
    }

    if (isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Log.json(iosInfo.data);
      return iosInfo.name;
    }

    return 'unKnow';
  }

  static Future<String?> getDeviceId() async {
    if (isAndroid) {
      const androidIdPlugin = AndroidId();
      return await androidIdPlugin.getId();
    }
    if (isIOS) {
      IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
      return iosInfo.identifierForVendor;
    }

    return 'unKnow';
  }
}
