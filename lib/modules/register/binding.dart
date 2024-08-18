import 'package:get/get.dart';

import 'logic.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterLogic>(() => RegisterLogic());
  }
}
