import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class SessionDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionDetailLogic>(() => SessionDetailLogic(), tag: "${Get.arguments[Keys.ID]}");
  }
}
