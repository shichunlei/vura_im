import 'package:get/get.dart';
import 'package:vura/global/keys.dart';

import 'logic.dart';

class MuteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MuteLogic>(() => MuteLogic(), tag: Get.arguments[Keys.ID]);
  }
}
