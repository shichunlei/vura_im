import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class UserInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserInfoLogic>(() => UserInfoLogic(), tag: Get.arguments[Keys.ID]);
  }
}
