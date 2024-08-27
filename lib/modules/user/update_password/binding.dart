import 'package:get/get.dart';

import 'logic.dart';

class UpdatePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatePasswordLogic>(() => UpdatePasswordLogic());
  }
}
