import 'package:vura/utils/log_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  /// base_url
  static String baseUrl = "http://39.98.127.91:8888/";
  static String wsUrl = 'ws://39.98.127.91:8878/im';

  /// 版本信息
  static PackageInfo? _version;

  static PackageInfo? get version => _version;

  static void setVersion(PackageInfo version) {
    _version = version;
  }

  static String? userId;

  static void setUserId(String id) {
    Log.d("@@@@@@@@@@@@@@@@@@@===================>$id");
    userId = id;
  }
}
