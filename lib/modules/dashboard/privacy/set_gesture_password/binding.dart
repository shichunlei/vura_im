import 'package:get/get.dart';

import 'logic.dart';

class SetGesturePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetGesturePasswordLogic>(() => SetGesturePasswordLogic());
  }
}
