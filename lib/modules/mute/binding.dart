import 'package:get/get.dart';
import 'package:im/global/keys.dart';

import 'logic.dart';

class MuteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MuteLogic>(() => MuteLogic(), tag: Get.arguments[Keys.ID]);
  }
}
