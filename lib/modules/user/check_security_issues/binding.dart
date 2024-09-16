import 'package:get/get.dart';

import 'logic.dart';

class CheckSecurityIssuesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckSecurityIssuesLogic>(() => CheckSecurityIssuesLogic());
  }
}
