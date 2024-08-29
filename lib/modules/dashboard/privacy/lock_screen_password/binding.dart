import 'package:get/get.dart';

import 'logic.dart';

class LockScreenPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockScreenPasswordLogic>(() => LockScreenPasswordLogic());
  }
}
