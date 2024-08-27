import 'package:get/get.dart';
import 'package:vura/base/base_logic.dart';
import 'package:vura/entities/user_entity.dart';
import 'package:vura/global/enum.dart';
import 'package:vura/global/keys.dart';
import 'package:vura/repository/user_repository.dart';
import 'package:vura/route/route_path.dart';
import 'package:vura/utils/tool_util.dart';

mixin QrScanMixin on BaseLogic {
  void scan() {
    goScan().then((value) async {
      if (value != null) {
        showLoading();
        UserEntity? user = await UserRepository.getUserInfoByQrCode(value);
        hiddenLoading();
        if (user != null) {
          if (user.friendship == YorNType.M) {
            Get.toNamed(RoutePath.MY_INFO_PAGE);
          } else {
            Get.toNamed(RoutePath.USER_INFO_PAGE, arguments: {Keys.ID: user.id});
          }
        }
      }
    });
  }
}
