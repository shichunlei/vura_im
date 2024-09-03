import 'package:get/get.dart';

import 'logic.dart';

class WithdrawBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawLogic>(() => WithdrawLogic());
  }
}
