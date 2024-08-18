import 'package:get/get.dart';

import 'logic.dart';

class LineBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LineLogic>(() => LineLogic());
  }
}
