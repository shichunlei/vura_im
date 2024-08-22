import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class SessionMembersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionMembersLogic>(() => SessionMembersLogic(), tag: Get.arguments[Keys.ID]);
  }
}
