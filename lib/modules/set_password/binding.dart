import 'package:get/get.dart';

import 'logic.dart';

class SetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetPasswordLogic>(() => SetPasswordLogic());
  }
}
