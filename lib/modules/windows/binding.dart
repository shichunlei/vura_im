import 'package:get/get.dart';

import 'logic.dart';

class WindowsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WindowsLogic>(() => WindowsLogic());
  }
}
