import 'package:get/get.dart';

import 'logic.dart';

class ChargeWayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChargeWayLogic>(() => ChargeWayLogic());
  }
}
