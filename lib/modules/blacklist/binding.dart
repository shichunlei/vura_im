import 'package:get/get.dart';

import 'logic.dart';

class BlacklistBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlacklistLogic>(() => BlacklistLogic());
  }
}
