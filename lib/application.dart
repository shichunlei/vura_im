import 'package:package_info_plus/package_info_plus.dart';

import 'global/config.dart';
import 'global/keys.dart';
import 'repository/user_repository.dart';
import 'route/route_path.dart';
import 'utils/sp_util.dart';
import 'utils/string_util.dart';

String initialRoute = RoutePath.LOGIN_PAGE;

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

    String accessToken = SpUtil.getString(Keys.ACCESS_TOKEN);
    if (StringUtil.isNotEmpty(accessToken)) {
      /// 已登录，刷新token
      await UserRepository.refreshToken();
      initialRoute = RoutePath.HOME_PAGE;
    } else {
      /// 未登录
      initialRoute = RoutePath.LOGIN_PAGE;
    }
  }
}
