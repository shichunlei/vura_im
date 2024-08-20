import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class SessionManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionManagerLogic>(() => SessionManagerLogic(), tag: "${Get.arguments[Keys.ID]}");
  }
}
