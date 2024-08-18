import 'package:get/get.dart';

import 'logic.dart';

class PrivacyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyLogic>(() => PrivacyLogic());
  }
}
