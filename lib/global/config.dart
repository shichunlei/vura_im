import 'package:package_info_plus/package_info_plus.dart';
import 'package:vura/utils/log_utils.dart';

class AppConfig {
  /// base_url
  static String baseUrl = "http://18.167.141.201:8888/";
  static String wsUrl = 'ws://18.167.141.201:8878/im';

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

  static const int DEFAULT_TOP_TIME = 2524579200000;
}
