import 'package:get/get.dart';

import 'logic.dart';

class DevicesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DevicesLogic>(() => DevicesLogic());
  }
}
