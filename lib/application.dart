import 'package:package_info_plus/package_info_plus.dart';
import 'package:vura/utils/device_utils.dart';

import 'entities/base_bean.dart';
import 'entities/user_entity.dart';
import 'global/config.dart';
import 'global/keys.dart';
import 'repository/user_repository.dart';
import 'route/route_path.dart';
import 'utils/sp_util.dart';
import 'utils/string_util.dart';
import 'utils/websocket.dart';

String initialRoute = RoutePath.LOGIN_PAGE;

// 全局 WebSocket 实例
final WebSocketManager webSocketManager = WebSocketManager();

class Application {
  static Application? instance;

  static Application getInstance() {
    instance ??= Application();
    return instance!;
  }

  Future<void> initApp() async {
    await SpUtil.getInstance();

    PackageInfo version = await PackageInfo.fromPlatform();
    AppConfig.setVersion(version);

    String? deviceId = await DeviceUtils.getDeviceId();
    AppConfig.setDeviceId(deviceId);

    String accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
    if (StringUtil.isNotEmpty(accessToken)) {
      /// 已登录，刷新token
      BaseBean result = await UserRepository.refreshToken();
      if (result.code != 200) {
        SpUtil.clear();
        initialRoute = RoutePath.LOGIN_PAGE;
      } else {
        UserEntity? user = await UserRepository.getUserInfo();
        if (user?.id != null) AppConfig.setUserId(user!.id!);
        bool loginProtect = SpUtil.getBool(Keys.LOGIN_PROTECT, defValue: false);
        if (loginProtect) {
          initialRoute = RoutePath.LOCK_SCREEN_PAGE;
        } else {
          initialRoute = RoutePath.HOME_PAGE;
        }
      }
    } else {
      /// 未登录
      initialRoute = RoutePath.LOGIN_PAGE;
    }
  }
}
