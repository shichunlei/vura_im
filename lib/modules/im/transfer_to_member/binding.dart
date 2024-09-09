import 'package:get/get.dart';

import 'logic.dart';

class TransferToMemberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferToMemberLogic>(() => TransferToMemberLogic());
  }
}
