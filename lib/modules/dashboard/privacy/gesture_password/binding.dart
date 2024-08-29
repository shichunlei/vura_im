import 'package:get/get.dart';

import 'logic.dart';

class GesturePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GesturePasswordLogic>(() => GesturePasswordLogic());
  }
}
