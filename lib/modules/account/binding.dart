import 'package:get/get.dart';

import 'logic.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountLogic>(() => AccountLogic());
  }
}
