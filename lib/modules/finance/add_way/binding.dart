import 'package:get/get.dart';

import 'logic.dart';

class AddWayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWayLogic>(() => AddWayLogic());
  }
}
