import 'package:get/get.dart';

import 'logic.dart';

class GestureBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GestureLogic>(() => GestureLogic());
  }
}
