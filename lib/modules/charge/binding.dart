import 'package:get/get.dart';

import 'logic.dart';

class ChargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChargeLogic>(() => ChargeLogic());
  }
}
