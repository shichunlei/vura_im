import 'package:get/get.dart';

import 'logic.dart';

class TransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferLogic>(() => TransferLogic());
  }
}
