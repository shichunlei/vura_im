import 'package:get/get.dart';

import 'logic.dart';

class PayVoucherBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayVoucherLogic>(() => PayVoucherLogic());
  }
}
