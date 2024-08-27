import 'package:get/get.dart';

import 'logic.dart';

class SelectContactsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectContactsLogic>(() => SelectContactsLogic());
  }
}
