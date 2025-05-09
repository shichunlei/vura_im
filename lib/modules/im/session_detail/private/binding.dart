import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class PrivateSessionDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivateSessionDetailLogic>(() => PrivateSessionDetailLogic(), tag: Get.arguments[Keys.ID]);
  }
}
