import 'package:get/get.dart';

import 'logic.dart';

class GoogleVerifyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleVerifyLogic>(() => GoogleVerifyLogic());
  }
}
