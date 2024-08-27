import 'package:vura/utils/log_utils.dart';
import 'package:vura/utils/sp_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  /// base_url
  static String baseUrl = "http://39.98.127.91:8888/";
  static String wsUrl = 'ws://39.98.127.91:8878/im';

  static const String WX_IOS_APPID = '414478124';
  static const String WX_ANDROID_APPID = 'com.tencent.mm';

  /// 版本信息
  static PackageInfo? _version;

  static PackageInfo? get version => _version;

  static void setVersion(PackageInfo version) {
    _version = version;
  }

  /// 设备号
  static String _deviceId = "";

  static String? get deviceId => _deviceId;

  static void setDeviceId(String? value) {
    if (value != null) _deviceId = value;
  }

  /// 系统版本
  static String _osVersion = "";

  static String? get osVersion => _osVersion;

  static void setOsVersion(String value) {
    _osVersion = value;
  }

  static String? userId;

  static void setUserId(String id) {
    Log.d("@@@@@@@@@@@@@@@@@@@===================>$id");
    userId = id;
    SpUtil.setString("_USER_ID_", id);
  }
}
