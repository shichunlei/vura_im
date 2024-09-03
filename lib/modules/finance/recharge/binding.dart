import 'package:get/get.dart';

import 'logic.dart';

class RechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RechargeLogic>(() => RechargeLogic());
  }
}
