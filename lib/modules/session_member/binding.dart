import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class SessionMemberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionMemberLogic>(() => SessionMemberLogic(), tag: Get.arguments[Keys.ID]);
  }
}
