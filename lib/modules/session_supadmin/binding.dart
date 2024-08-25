import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class SessionSupAdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionSupAdminLogic>(() => SessionSupAdminLogic(), tag: Get.arguments[Keys.ID]);
  }
}
