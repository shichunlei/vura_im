import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class TransferResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferResultLogic>(() => TransferResultLogic(), tag: Get.arguments[Keys.ID]);
  }
}
