import 'package:get/get.dart';

import 'logic.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootLogic>(() => RootLogic());
  }
}
