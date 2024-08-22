import 'package:get/get.dart';
import 'package:im/base/base_logic.dart';
import 'package:im/entities/user_entity.dart';
import 'package:im/global/keys.dart';
import 'package:im/repository/user_repository.dart';
import 'package:im/route/route_path.dart';
import 'package:im/utils/tool_util.dart';

mixin QrScanMixin on BaseLogic {
  void scan() {
    goScan().then((value) async {
      if (value != null) {
        showLoading();
        UserEntity? user = await UserRepository.getUserInfoByQrCode(value);
        hiddenLoading();
        if (user != null) {
          if (user.friendship == "M") {
            Get.toNamed(RoutePath.MY_INFO_PAGE);
          } else {
            Get.toNamed(RoutePath.USER_INFO_PAGE, arguments: {Keys.ID: user.id});
          }
        }
      }
    });
  }
}
