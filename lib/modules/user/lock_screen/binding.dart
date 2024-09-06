import 'package:get/get.dart';

import 'logic.dart';

class LockScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockScreenLogic>(() => LockScreenLogic());
  }
}
