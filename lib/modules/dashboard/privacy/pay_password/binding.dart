import 'package:get/get.dart';

import 'logic.dart';

class PayPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayPasswordLogic>(() => PayPasswordLogic());
  }
}
