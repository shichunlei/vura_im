import 'package:get/get.dart';

import 'logic.dart';

class SetNumberPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetNumberPasswordLogic>(() => SetNumberPasswordLogic());
  }
}
